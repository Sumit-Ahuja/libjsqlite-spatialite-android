/**********************************************************************
 *
 * rttopo - topology library
 * http://git.osgeo.org/gogs/rttopo/librttopo
 *
 * rttopo is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * rttopo is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with rttopo.  If not, see <http://www.gnu.org/licenses/>.
 *
 **********************************************************************
 *
 * Implementation of Trevisani-Peri snap algoritm
 *
 * See
 * https://git.osgeo.org/gogs/rttopo/librttopo/wiki/SnapToTopo-algorithm
 *
 **********************************************************************
 *
 * Copyright (C) 2016 Sandro Santilli <strk@kbt.io>
 *
 **********************************************************************/

#include "rttopo_config.h"

/*#define RTGEOM_DEBUG_LEVEL 4*/
#include "rtgeom_log.h"

#include "librttopo_geom.h"
#include "librttopo_internal.h"
#include "librttopo_geom_internal.h"
#include "measures.h"
#include "rtgeom_geos.h"

/*
 * Reference vertex
 *
 * It is the vertex of a topology edge
 * which is within snap tolerance distance from
 * a segment of the input geometry.
 *
 * We store the input geometry segment and the distance
 * (both needed to compute the distance) within the structure.
 *
 */
typedef struct {
  RTPOINT2D pt;
  /* Closest segment in input pointarray (0-based index) */
  int segno;
  double dist;
} RTT_SNAPV;

/* An array of RTT_SNAPV structs */
typedef struct {
  RTT_SNAPV *pts;
  int size;
  int capacity;
} RTT_SNAPV_ARRAY;

#define RTT_SNAPV_ARRAY_INIT(c, a) { \
  (a)->size = 0; \
  (a)->capacity = 1; \
  (a)->pts = rtalloc((c), sizeof(RTT_SNAPV) * (a)->capacity); \
}

#define RTT_SNAPV_ARRAY_CLEAN(c, a) { \
  rtfree((c), (a)->pts); \
  (a)->pts = NULL; \
  (a)->size = 0; \
  (a)->capacity = 0; \
}

#define RTT_SNAPV_ARRAY_PUSH(c, a, r) { \
  if ( (a)->size + 1 > (a)->capacity ) { \
    (a)->capacity *= 2; \
    (a)->pts = rtrealloc((c), (a)->pts, sizeof(RTT_SNAPV) * (a)->capacity); \
  } \
  (a)->pts[(a)->size++] = (r); \
}

/* A pair of points with their distance */
typedef struct {
  RTT_SNAPV *p1;
  RTT_SNAPV *p2;
  double totdist; /* sum of the two points distances */
  double segdist; /* between the two points */
} RTT_VPAIR;

/* An array of RTT_VPAIR structs */
typedef struct {
  RTT_VPAIR *pts;
  int size;
  int capacity;
} RTT_VPAIR_ARRAY;

#define RTT_VPAIR_ARRAY_INIT(c, a) { \
  (a)->size = 0; \
  (a)->capacity = 1; \
  (a)->pts = rtalloc((c), sizeof(RTT_VPAIR) * (a)->capacity); \
}

#define RTT_VPAIR_ARRAY_CLEAN(c, a) { \
  rtfree((c), (a)->pts); \
  (a)->pts = NULL; \
  (a)->size = 0; \
  (a)->capacity = 0; \
}

#define RTT_VPAIR_ARRAY_INIT(c, a) { \
  (a)->size = 0; \
  (a)->capacity = 1; \
  (a)->pts = rtalloc((c), sizeof(RTT_VPAIR) * (a)->capacity); \
}

#define RTT_VPAIR_ARRAY_PUSH(c, a, r) { \
  if ( (a)->size + 1 > (a)->capacity ) { \
    (a)->capacity *= 2; \
    (a)->pts = rtrealloc((c), (a)->pts, sizeof(RTT_VPAIR) * (a)->capacity); \
  } \
  (a)->pts[(a)->size++] = (r); \
}

typedef struct
{

  /*
   * Input parameters / configuration
   */
  const RTT_TOPOLOGY *topo;
  double tssnap;
  int iterate;
  int remove_vertices;

  /*
   * Extent of the geometry being snapped,
   * will be updated as needed as snapping occurs
   */
  RTGBOX workext;

  /*
   * Edges within workext,
   * will be updated as needed as workext extends
   * (maybe should be put in an STRtree)
   */
  RTT_ISO_EDGE *workedges;
  int num_workedges;

} rtgeom_tpsnap_state;

/*
 * Write number of edges in *num_edges, -1 on error.
 * @return edges, or NULL if none-or-error (look *num_edges to tell)
 */
static const RTT_ISO_EDGE *
rtgeom_tpsnap_state_get_edges(rtgeom_tpsnap_state *state, int *num_edges)
{
  if ( ! state->workedges ) {
    RTGBOX qbox = state->workext;
    gbox_expand(state->topo->be_iface->ctx, &qbox, state->tssnap);
    state->workedges = rtt_be_getEdgeWithinBox2D(state->topo,
              &qbox,
              &state->num_workedges,
              RTT_COL_EDGE_ALL, 0);
  }

  *num_edges = state->num_workedges;
  return state->workedges;
}

/*
 * Expand working extent to include new point.
 * Resets working edges if new point expands the last used bounding box.
 */
static void
rtgeom_tpsnap_state_expand_workext_to_include(rtgeom_tpsnap_state *state,
    RTPOINT2D *pt)
{
  const RTCTX *ctx = state->topo->be_iface->ctx;
  POINT3D p3d;

  /* Nothing to do if the box already contains the point */
  if ( gbox_contains_point2d(ctx, &state->workext, pt) ) return;

  p3d.x = pt->x;
  p3d.y = pt->y;
  p3d.z = 0.0;

  gbox_merge_point3d(ctx, &p3d, &state->workext);

  /* Reset workedges */
  if ( state->workedges ) {
    rtt_release_edges(state->topo->be_iface->ctx,
                      state->workedges, state->num_workedges);
    state->workedges = NULL;
  }
}

static void
rtgeom_tpsnap_state_destroy(rtgeom_tpsnap_state *state)
{
  if ( state->workedges ) {
    rtt_release_edges(state->topo->be_iface->ctx,
                      state->workedges, state->num_workedges);
  }
}

/*
 * Find closest segment of pa to a given point
 *
 * @return -1 on error, 0 on success
 */
static int
_rt_find_closest_segment(const RTCTX *ctx, RTPOINT2D *pt, RTPOINTARRAY *pa,
    int *segno, double *dist)
{
  int j;
  RTPOINT2D s0, s1;
  DISTPTS dl;

  *segno = -1;
  *dist = FLT_MAX;

  rt_dist2d_distpts_init(ctx, &dl, DIST_MIN);

  /* Find closest segment */
  for (j=0; j<pa->npoints-1; ++j)
  {
    rt_getPoint2d_p(ctx, pa, j, &s0);
    rt_getPoint2d_p(ctx, pa, j+1, &s1);

    if ( rt_dist2d_pt_seg(ctx, pt, &s0, &s1, &dl) == RT_FALSE )
    {
      rterror(ctx, "rt_dist2d_pt_seg failed in _rt_find_closest_segment");
      return -1;
    }

    /* Segment is too far, check next */
    if ( dl.distance < *dist )
    {
      *segno = j;
      *dist = dl.distance;
    }
  }

  return 0;
}

/*
 * Extract from edge all vertices where distance from pa <= tssnap
 *
 * @return -1 on error, 0 on success
 */
static int
_rt_extract_vertices_within_dist(rtgeom_tpsnap_state *state,
    RTT_SNAPV_ARRAY *vset, RTLINE *edge, RTPOINTARRAY *pa)
{
  int i;
  RTPOINTARRAY *epa = edge->points; /* edge's point array */
  const RTT_TOPOLOGY *topo = state->topo;
  const RTCTX *ctx = topo->be_iface->ctx;

  RTT_SNAPV vert;
  for (i=0; i<epa->npoints; ++i)
  {
    int ret;

    rt_getPoint2d_p(ctx, edge->points, i, &(vert.pt));

    ret = _rt_find_closest_segment(ctx, &(vert.pt), pa, &vert.segno, &vert.dist);
    if ( ret == -1 ) return -1;

    if ( vert.dist <= state->tssnap )
    {
      /* push vert to array */
      RTT_SNAPV_ARRAY_PUSH(ctx, vset, vert);
    }

  }

  return 0;
}

/*
 * Find all topology edge vertices where distance from
 * given pointarray <= tssnap
 *
 * @return -1 on error, 0 on success
 */
static int
_rt_find_vertices_within_dist(
      RTT_SNAPV_ARRAY *vset, RTPOINTARRAY *pa,
      rtgeom_tpsnap_state *state)
{
  int num_edges;
  const RTT_ISO_EDGE *edges;
  const RTT_TOPOLOGY *topo = state->topo;
  const RTCTX *ctx = topo->be_iface->ctx;
  int i;

  edges = rtgeom_tpsnap_state_get_edges(state, &num_edges);
  if ( num_edges == -1 ) {
    rterror(ctx, "Backend error: %s", rtt_be_lastErrorMessage(topo->be_iface));
    return -1;
  }

  for (i=0; i<num_edges; ++i)
  {
    int ret;
    ret = _rt_extract_vertices_within_dist(state, vset, edges[i].geom, pa);
    if ( ret < 0 ) return ret;
  }

  return 0;
}

static int
compare_vpairs(const void *si1, const void *si2)
{
  RTT_VPAIR *a = (RTT_VPAIR *)si1;
  RTT_VPAIR *b = (RTT_VPAIR *)si2;

  if ( a->totdist < b->totdist )
    return -1;
  else if ( a->totdist > b->totdist )
    return 1;

  if ( a->segdist < b->segdist )
    return -1;
  else if ( a->segdist > b->segdist )
    return 1;

  return 0;
}

/*
 * Let *VPlist* be a list of all vertices pairs (*VP*) in *Vset*
 * For each element *VP* in *VPlist*:
 *   Let *VP.TotDist* be the sum of the distances of each of the vertices in *VP*
 *   Let *VP.SegDist* be the distances between the two vertices in *VP*
 * Order *VPlist* by growing *VP.TotDist*, *VP.SegDist*
 *
 * @return 0 on success, -1 on error.
 *
 */
static int
_rt_make_sorted_vertices_pairs(const RTCTX *ctx,
      RTT_SNAPV_ARRAY *vset,
      RTT_VPAIR_ARRAY *vplist)
{
  int i, j, ret;
  DISTPTS dl;
  rt_dist2d_distpts_init(ctx, &dl, DIST_MIN);
  for (i=0; i<vset->size; ++i)
  {
    for (j=i+1; j<vset->size; ++j)
    {
      RTT_VPAIR pair;
      pair.p1 = &(vset->pts[i]);
      pair.p2 = &(vset->pts[j]);
      ret = rt_dist2d_pt_pt(ctx, &(pair.p1->pt), &(pair.p2->pt), &dl);
      pair.segdist = dl.distance;
      pair.totdist = pair.p1->dist + pair.p2->dist;
      if ( ret == RT_FALSE ) return -1;
      RTT_VPAIR_ARRAY_PUSH(ctx, vplist, pair);
    }
  }

  /* Now sort it */
  qsort(vplist->pts, vplist->size, sizeof(RTT_VPAIR), compare_vpairs);

  return 0;
}

/*
 * @return 0 on success, -1 on error
 */
typedef int (*rtptarray_visitor)(const RTCTX *ctx, RTPOINTARRAY *pa, void *userdata);

/*
 * Pass each PTARRAY defining linear components of RTGEOM to the given
 * visitor function
 *
 * This is a mutating visit, where pointarrays are passed as non-const
 *
 * Only (multi)linestring and (multi)polygon will be filtered, with
 * other components simply left unvisited.
 *
 * @return 0 on success, -1 on error (if visitor function ever
 *         returned an error)
 *
 * To be exported if useful
 */
static int
rtgeom_visit_lines(const RTCTX *ctx, RTGEOM *rtgeom,
                   rtptarray_visitor visitor, void *userdata)
{
  int i;
  int ret;
  RTCOLLECTION *coll;
  RTPOLY *poly;
  RTLINE *line;

  switch (rtgeom->type)
  {
  case RTPOLYGONTYPE:
    poly = (RTPOLY*)rtgeom;
    for (i=0; i<poly->nrings; ++i) {
      ret = visitor(ctx, poly->rings[i], userdata);
      if ( ret != 0 ) return ret;
    }
    break;

  case RTLINETYPE:
    line = (RTLINE*)rtgeom;
    return visitor(ctx, line->points, userdata);

  case RTMULTILINETYPE:
  case RTMULTIPOLYGONTYPE:
  case RTCOLLECTIONTYPE:
    coll = (RTCOLLECTION *)rtgeom;
    for (i=0; i<coll->ngeoms; i++) {
      ret = rtgeom_visit_lines(ctx, coll->geoms[i], visitor, userdata);
      if ( ret != 0 ) return ret;
    }
    break;
  }

  return 0;
}

/*
 * Vertex removal phase
 *
 * Remove internal vertices of `pa` that are within state.tssnap
 * distance from edges of state.topo topology.
 *
 * @return -1 on error, number of points removed on success
 */
static int
_rtgeom_tpsnap_ptarray_remove(const RTCTX *ctx, RTPOINTARRAY *pa,
                  rtgeom_tpsnap_state *state)
{
  int num_edges, i, j, ret;
  const RTT_ISO_EDGE *edges;
  const RTT_TOPOLOGY *topo = state->topo;
  int removed = 0;

  /* Let *Eset* be the set of edges of *Topo-ref*
   *             with distance from *Gcomp* <= *TSsnap*
   */
  edges = rtgeom_tpsnap_state_get_edges(state, &num_edges);
  if ( num_edges == -1 ) {
    rterror(ctx, "Backend error: %s", rtt_be_lastErrorMessage(topo->be_iface));
    return -1;
  }

  RTDEBUG(ctx, 1, "vertices removal phase starts");

  /* For each non-endpoint vertex *V* of *Gcomp* */
  for (i=1; i<pa->npoints-1; ++i)
  {
    RTPOINT2D V;
    RTLINE *closest_segment_edge = NULL;
    int closest_segment_number;
    double closest_segment_distance = state->tssnap+1;

    rt_getPoint2d_p(ctx, pa, i, &V);

    RTDEBUGF(ctx, 2, "Analyzing internal vertex POINT(%.15g %.15g)", V.x, V.y);

    /* Find closest edge segment */
    for (j=0; j<num_edges; ++j)
    {
      RTLINE *E = edges[j].geom;
      int segno;
      double dist;

      ret = _rt_find_closest_segment(ctx, &V, E->points, &segno, &dist);
      if ( ret < 0 ) return ret; /* error */

      /* Edge is too far */
      if ( dist > state->tssnap ) {
        RTDEBUGF(ctx, 2, " Vertex is too far (%g) from edge %d", dist, edges[j].edge_id);
        continue;
      }

      RTDEBUGF(ctx, 2, " Vertex within distance from segment %d of edge %d",
        segno, edges[j].edge_id);

      if ( dist < closest_segment_distance )
      {
        closest_segment_edge = E;
        closest_segment_number = segno;
        closest_segment_distance = dist;
      }
    }

    if ( closest_segment_edge )
    {{
      RTPOINT4D V4d, Ep1, Ep2, proj;
      RTPOINTARRAY *epa = closest_segment_edge->points;

      /* Let *Proj* be the closest point in *closest_segment_edge* to *V* */
      V4d.x = V.x; V4d.y = V.y; V4d.m = V4d.z = 0.0;
      rt_getPoint4d_p(ctx, epa, closest_segment_number, &Ep1);
      rt_getPoint4d_p(ctx, epa, closest_segment_number+1, &Ep2);
      closest_point_on_segment(ctx, &V4d, &Ep1, &Ep2, &proj);

      RTDEBUGF(ctx, 2, " Closest point on edge segment LINESTRING(%.15g %.15g, %.15g %.15g) is POINT(%.15g %.15g)",
        Ep1.x, Ep1.y, Ep2.x, Ep2.y, proj.x, proj.y);

      /* Closest point here matches segment endpoint */
      if ( p4d_same(ctx, &proj, &Ep1) || p4d_same(ctx, &proj, &Ep2) ) {
        RTDEBUG(ctx, 2, " Closest point on edge matches segment endpoint");
        continue;
      }

      /* Remove vertex *V* from *Gcomp* */
      RTDEBUGF(ctx, 1, " Removing internal point POINT(%.14g %.15g)",
        V.x, V.y);
      ret = ptarray_remove_point(ctx, pa, i);
      if ( ret == RT_FAILURE ) return -1;
      /* rewind i */
      --i;
      /* increment removed count */
      ++removed;
    }}
  }

  RTDEBUGF(ctx, 1, "vertices removal phase ended (%d removed)", removed);

  return removed;
}

/* Return NULL on error, or a GEOSGeometry on success */
static GEOSGeometry *
_rt_segment_to_geosgeom(const RTCTX *ctx, RTPOINT4D *p1, RTPOINT4D *p2)
{
  RTPOINTARRAY *pa = ptarray_construct(ctx, 0, 0, 2);
  RTLINE *line;
  GEOSGeometry *ret;
  ptarray_set_point4d(ctx, pa, 0, p1);
  ptarray_set_point4d(ctx, pa, 1, p2);
  line = rtline_construct(ctx, 0, NULL, pa);
  ret = RTGEOM2GEOS(ctx, rtline_as_rtgeom(ctx, line), 0);
  rtline_free(ctx, line);
  return ret;
}

/*
 *
 * @return -1 on error, 1 if covered, 0 if not covered
 */
static int
_rt_segment_covered(rtgeom_tpsnap_state *state,
    RTPOINT4D *p1, RTPOINT4D *p2)
{
  const RTT_TOPOLOGY *topo = state->topo;
  const RTCTX *ctx = topo->be_iface->ctx;
  int num_edges, i;
  const RTT_ISO_EDGE *edges;
  GEOSGeometry *sg;

  edges = rtgeom_tpsnap_state_get_edges(state, &num_edges);
  if ( num_edges == -1 ) {
    rterror(ctx, "Backend error: %s", rtt_be_lastErrorMessage(topo->be_iface));
    return -1;
  }

  /* OPTIMIZE: use prepared geometries */
  /* OPTIMIZE: cache cover state of segments */

  sg = _rt_segment_to_geosgeom(ctx, p1, p2);
  for (i=0; i<num_edges; ++i)
  {
    RTGEOM *eg = rtline_as_rtgeom(ctx, edges[i].geom);
    GEOSGeometry *geg = RTGEOM2GEOS(ctx, eg, 0);
    int covers = GEOSCovers_r(ctx->gctx, geg, sg);
    GEOSGeom_destroy_r(ctx->gctx, geg);
    if (covers == 2) {
      GEOSGeom_destroy_r(ctx->gctx, sg);
      rterror(ctx, "Covers error: %s", rtgeom_get_last_geos_error(ctx));
      return -1;
    }
    if ( covers ) {
      GEOSGeom_destroy_r(ctx->gctx, sg);
      return 1;
    }
  }
  GEOSGeom_destroy_r(ctx->gctx, sg);

  return 0;
}

/*
  Let *Point.Proj* be the closest point in *Gcomp* to the point
  Let *Point.InSeg* be the segment of *Gcomp* containing *Point.Proj*'
  IF *Point.InSeg* is NOT COVERED BY *Topo-ref* edges:
      IF *Point.Proj* is NOT cohincident with a vertex of *Gcomp*:
         Insert *Point* after the first vertex of *Point.InSeg*

@return 0 if no valid snap was found, <0 on error, >0 if snapped

*/
static int
_rt_snap_to_valid_vertex(const RTCTX *ctx, RTPOINTARRAY *pa,
  const RTT_SNAPV *v, rtgeom_tpsnap_state *state)
{
  int ret;
  RTPOINT4D p, sp1, sp2, proj;

  p.x = v->pt.x; p.y = v->pt.y; p.m = p.z = 0.0;
  rt_getPoint4d_p(ctx, pa, v->segno, &sp1);
  rt_getPoint4d_p(ctx, pa, v->segno+1, &sp2);

  RTDEBUGF(ctx, 2, "Analyzing snap vertex POINT(%.15g %.15g)", p.x, p.y);
  RTDEBUGF(ctx, 2, " Closest segment %d is LINESTRING(%.15g %.15g, %.15g %.15g)",
    v->segno, sp1.x, sp1.y, sp2.x, sp2.y);

  closest_point_on_segment(ctx, &p, &sp1, &sp2, &proj);

  RTDEBUGF(ctx, 2, " Closest point on segment is POINT(%.15g %.15g)",
    proj.x, proj.y);


  /* Check if closest point matches segment endpoint (could be cached) */
  if ( p4d_same(ctx, &proj, &sp1) || p4d_same(ctx, &proj, &sp2) )
  {
    RTDEBUG(ctx, 2, " Closest point matches a segment's endpoint");
    return 0;
  }

  /* Skip if closest segment is covered by topo-ref */
  ret = _rt_segment_covered(state, &sp1, &sp2);
  if ( ret == -1 ) return -1;
  if ( ret == 1 )
  {
    RTDEBUG(ctx, 2, " Closest segment is covered by topo edges");
    /* it is covered */
    return 0;
  }

  /* Snap ! */
  RTDEBUGF(ctx, 2, "Snapping input segment %d to POINT(%.15g %.15g)",
    v->segno, p.x, p.y);
  ret = ptarray_insert_point(ctx, pa, &p, v->segno+1);
  if ( ret == RT_FAILURE ) return -1;

  return 1;

}

/*
 * @return 0 if no valid snap was found, <0 on error, >0 if snapped
 */
static int
_rt_snap_to_valid_pair(const RTCTX *ctx, RTPOINTARRAY *pa,
  RTT_VPAIR *pair, rtgeom_tpsnap_state *state)
{
  int snapCount = 0, ret;

  ret = _rt_snap_to_valid_vertex(ctx, pa, pair->p1, state);
  if ( ret < 0 ) return ret;
  snapCount += ret;

  if ( ret ) {
    /* Expand working extent */
    rtgeom_tpsnap_state_expand_workext_to_include(state,
      &(pair->p1->pt));

    /* Recompute distance from second point, if first was snapped */
    ret = _rt_find_closest_segment(ctx, &(pair->p2->pt), pa,
              &(pair->p2->segno), &(pair->p2->dist));
    if ( ret < 0 ) return ret; /* error */

  }

  ret = _rt_snap_to_valid_vertex(ctx, pa, pair->p2, state);
  if ( ret < 0 ) return ret;
  snapCount += ret;

  if ( ret ) {
    /* Expand working extent */
    rtgeom_tpsnap_state_expand_workext_to_include(state,
      &(pair->p2->pt));
  }

  return snapCount;
}

/* @return 0 if no valid snap was found, <0 on error, >0 if snapped */
static int
_rt_snap_to_first_valid_pair(const RTCTX *ctx, RTPOINTARRAY *pa,
  RTT_VPAIR_ARRAY *vplist, rtgeom_tpsnap_state *state)
{
  int foundSnap = 0;
  int i;

  for (i=0; i<vplist->size; ++i)
  {
    RTT_VPAIR *pair = &(vplist->pts[i]);
    foundSnap = _rt_snap_to_valid_pair(ctx, pa, pair, state);
    if ( foundSnap ) {
      RTDEBUGF(ctx, 1, "pair %d/%d contained %d valid snaps",
        i, vplist->size, foundSnap);
      break;
    }
  }

  return foundSnap;
}

/*
 * Vertex addition phase
 *
 * @return 0 on success, -1 on error.
 *
 */
int
_rtgeom_tpsnap_ptarray_add(const RTCTX *ctx, RTPOINTARRAY *pa,
                  rtgeom_tpsnap_state *state)
{
  int ret;
  int lookingForSnap = 1;

  RTDEBUG(ctx, 1, "vertices addition phase starts");
  while (lookingForSnap)
  {
    int foundSnap;
    RTT_SNAPV_ARRAY vset;
    RTT_VPAIR_ARRAY vplist;

    lookingForSnap = 0;
    RTT_SNAPV_ARRAY_INIT(ctx, &vset);
    RTT_VPAIR_ARRAY_INIT(ctx, &vplist);

    ret = _rt_find_vertices_within_dist(&vset, pa, state);
    if ( ret < 0 ) {
      RTT_SNAPV_ARRAY_CLEAN(ctx, &vset);
      RTT_VPAIR_ARRAY_CLEAN(ctx, &vplist);
      return -1;
    }
    RTDEBUGF(ctx, 1, "vertices within dist: %d", vset.size);
    if ( vset.size < 2 ) {
      RTT_SNAPV_ARRAY_CLEAN(ctx, &vset);
      RTT_VPAIR_ARRAY_CLEAN(ctx, &vplist);
      break;
    }

    ret = _rt_make_sorted_vertices_pairs(ctx, &vset, &vplist);
    if ( ret < 0 ) {
      RTT_SNAPV_ARRAY_CLEAN(ctx, &vset);
      RTT_VPAIR_ARRAY_CLEAN(ctx, &vplist);
      return -1;
    }
    RTDEBUGF(ctx, 1, "vertices pairs: %d", vplist.size);

    foundSnap = _rt_snap_to_first_valid_pair(ctx, pa, &vplist, state);
    RTDEBUGF(ctx, 1, "foundSnap: %d", foundSnap);

    RTT_SNAPV_ARRAY_CLEAN(ctx, &vset);
    RTT_VPAIR_ARRAY_CLEAN(ctx, &vplist);

    if ( foundSnap < 0 ) return foundSnap; /* error */
    if ( foundSnap && state->iterate ) {
      lookingForSnap = 1;
    }
  }
  RTDEBUG(ctx, 1, "vertices addition phase ends");

  return 0;
}

/*
 * Process a single pointarray with the snap algorithm
 *
 * @return 0 on success, -1 on error.
 */
int
_rtgeom_tpsnap_ptarray(const RTCTX *ctx, RTPOINTARRAY *pa,
                  void *udata)
{
  int ret;
  rtgeom_tpsnap_state *state = udata;

  RTDEBUGF(ctx, 1, "Snapping pointarray with %d points", pa->npoints);

  do {
    ret = _rtgeom_tpsnap_ptarray_add(ctx, pa, state);
    if ( ret == -1 ) return -1;

    if ( state->remove_vertices )
    {
      ret = _rtgeom_tpsnap_ptarray_remove(ctx, pa, state);
      if ( ret == -1 ) return -1;
    }
  } while (ret && state->iterate);

  RTDEBUGF(ctx, 1, "Snapped pointarray has %d points", pa->npoints);

  return 0;

}


/* public, exported */
RTGEOM *
rtt_tpsnap(RTT_TOPOLOGY *topo, const RTGEOM *gin,
                         double tssnap, int iterate, int remove_vertices)
{
  rtgeom_tpsnap_state state;
  const RTCTX *ctx = topo->be_iface->ctx;
  RTGEOM *gtmp = rtgeom_clone_deep(ctx, gin);
  int ret;

  RTDEBUGF(ctx, 1, "snapping: tol %g, iterate %d, remove %d",
    tssnap, iterate, remove_vertices);

  state.topo = topo;
  state.tssnap = tssnap;
  state.iterate = iterate;
  state.remove_vertices = remove_vertices;
  state.workext = *rtgeom_get_bbox(ctx, gin);
  state.workedges = NULL;

  rtgeom_geos_ensure_init(ctx);

  ret = rtgeom_visit_lines(ctx, gtmp, _rtgeom_tpsnap_ptarray, &state);

  rtgeom_tpsnap_state_destroy(&state);

  if ( ret ) {
    rtgeom_free(ctx, gtmp);
    return NULL;
  }

  return gtmp;
}
