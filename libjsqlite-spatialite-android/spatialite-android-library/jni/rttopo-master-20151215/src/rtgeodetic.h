/**********************************************************************
 *
 * rttopo - topology library
 * http://gitlab.com/rttopo/rttopo
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
 * Copyright 2009 Paul Ramsey <pramsey@cleverelephant.ca>
 *
 **********************************************************************/



#ifndef _RTGEODETIC_H
#define _RTGEODETIC_H 1

/* For NAN */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <math.h>

#ifndef NAN
#define NAN 0.0/0.0
#endif

extern int gbox_geocentric_slow;

#define POW2(x) ((x)*(x))

/**
* Point in spherical coordinates on the world. Units of radians.
*/
typedef struct
{
	double lon;
	double lat;
} GEOGRAPHIC_POINT;

/**
* Two-point great circle segment from a to b.
*/
typedef struct
{
	GEOGRAPHIC_POINT start;
	GEOGRAPHIC_POINT end;
} GEOGRAPHIC_EDGE;

/**
* Holder for sorting points in distance algorithm
*/
typedef struct
{
	double measure;
	uint32_t index;
} DISTANCE_ORDER;

/**
* Conversion functions
*/
#define deg2rad(d) (M_PI * (d) / 180.0)
#define rad2deg(r) (180.0 * (r) / M_PI)

/**
* Ape a java function
*/
#define signum(a) ((a) < 0 ? -1 : ((a) > 0 ? 1 : (a)))


/**
* Bitmask elements for edge_intersects(const RTCTX *ctx) return value.
*/
#define PIR_NO_INTERACT    0x00
#define PIR_INTERSECTS     0x01
#define PIR_COLINEAR       0x02
#define PIR_A_TOUCH_RIGHT   0x04
#define PIR_A_TOUCH_LEFT  0x08
#define PIR_B_TOUCH_RIGHT   0x10
#define PIR_B_TOUCH_LEFT  0x20


/*
* Geodetic calculations
*/
void geog2cart(const RTCTX *ctx, const GEOGRAPHIC_POINT *g, POINT3D *p);
void cart2geog(const RTCTX *ctx, const POINT3D *p, GEOGRAPHIC_POINT *g);
void robust_cross_product(const RTCTX *ctx, const GEOGRAPHIC_POINT *p, const GEOGRAPHIC_POINT *q, POINT3D *a);
void x_to_z(const RTCTX *ctx, POINT3D *p);
void y_to_z(const RTCTX *ctx, POINT3D *p);
int edge_point_on_plane(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e, const GEOGRAPHIC_POINT *p);
int edge_point_in_cone(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e, const GEOGRAPHIC_POINT *p);
int edge_contains_coplanar_point(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e, const GEOGRAPHIC_POINT *p);
int edge_contains_point(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e, const GEOGRAPHIC_POINT *p);
double z_to_latitude(const RTCTX *ctx, double z, int top);
int clairaut_cartesian(const RTCTX *ctx, const POINT3D *start, const POINT3D *end, GEOGRAPHIC_POINT *g_top, GEOGRAPHIC_POINT *g_bottom);
int clairaut_geographic(const RTCTX *ctx, const GEOGRAPHIC_POINT *start, const GEOGRAPHIC_POINT *end, GEOGRAPHIC_POINT *g_top, GEOGRAPHIC_POINT *g_bottom);
double sphere_distance(const RTCTX *ctx, const GEOGRAPHIC_POINT *s, const GEOGRAPHIC_POINT *e);
double sphere_distance_cartesian(const RTCTX *ctx, const POINT3D *s, const POINT3D *e);
int sphere_project(const RTCTX *ctx, const GEOGRAPHIC_POINT *r, double distance, double azimuth, GEOGRAPHIC_POINT *n);
int edge_calculate_gbox_slow(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e, RTGBOX *gbox);
int edge_calculate_gbox(const RTCTX *ctx, const POINT3D *A1, const POINT3D *A2, RTGBOX *gbox);
int edge_intersection(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e1, const GEOGRAPHIC_EDGE *e2, GEOGRAPHIC_POINT *g);
int edge_intersects(const RTCTX *ctx, const POINT3D *A1, const POINT3D *A2, const POINT3D *B1, const POINT3D *B2);
double edge_distance_to_point(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e, const GEOGRAPHIC_POINT *gp, GEOGRAPHIC_POINT *closest);
double edge_distance_to_edge(const RTCTX *ctx, const GEOGRAPHIC_EDGE *e1, const GEOGRAPHIC_EDGE *e2, GEOGRAPHIC_POINT *closest1, GEOGRAPHIC_POINT *closest2);
void geographic_point_init(const RTCTX *ctx, double lon, double lat, GEOGRAPHIC_POINT *g);
int ptarray_contains_point_sphere(const RTCTX *ctx, const RTPOINTARRAY *pa, const RTPOINT2D *pt_outside, const RTPOINT2D *pt_to_test);
int rtpoly_covers_point2d(const RTCTX *ctx, const RTPOLY *poly, const RTPOINT2D *pt_to_test);
void rtpoly_pt_outside(const RTCTX *ctx, const RTPOLY *poly, RTPOINT2D *pt_outside);
int ptarray_point_in_ring(const RTPOINTARRAY *pa, const RTPOINT2D *pt_outside, const RTPOINT2D *pt_to_test);
double ptarray_area_sphere(const RTCTX *ctx, const RTPOINTARRAY *pa);
double latitude_degrees_normalize(const RTCTX *ctx, double lat);
double longitude_degrees_normalize(const RTCTX *ctx, double lon);
double ptarray_length_spheroid(const RTCTX *ctx, const RTPOINTARRAY *pa, const SPHEROID *s);
int geographic_point_equals(const RTCTX *ctx, const GEOGRAPHIC_POINT *g1, const GEOGRAPHIC_POINT *g2);
int crosses_dateline(const RTCTX *ctx, const GEOGRAPHIC_POINT *s, const GEOGRAPHIC_POINT *e);
void point_shift(const RTCTX *ctx, GEOGRAPHIC_POINT *p, double shift);
double longitude_radians_normalize(const RTCTX *ctx, double lon);
double latitude_radians_normalize(const RTCTX *ctx, double lat);
void vector_sum(const RTCTX *ctx, const POINT3D *a, const POINT3D *b, POINT3D *n);
double vector_angle(const RTCTX *ctx, const POINT3D* v1, const POINT3D* v2);
void vector_rotate(const RTCTX *ctx, const POINT3D* v1, const POINT3D* v2, double angle, POINT3D* n);
void normalize(const RTCTX *ctx, POINT3D *p);
void unit_normal(const RTCTX *ctx, const POINT3D *P1, const POINT3D *P2, POINT3D *normal);
double sphere_direction(const RTCTX *ctx, const GEOGRAPHIC_POINT *s, const GEOGRAPHIC_POINT *e, double d);
void ll2cart(const RTCTX *ctx, const RTPOINT2D *g, POINT3D *p);

/*
** Prototypes for spheroid functions.
*/
double spheroid_distance(const RTCTX *ctx, const GEOGRAPHIC_POINT *a, const GEOGRAPHIC_POINT *b, const SPHEROID *spheroid);
double spheroid_direction(const RTCTX *ctx, const GEOGRAPHIC_POINT *r, const GEOGRAPHIC_POINT *s, const SPHEROID *spheroid);
int spheroid_project(const RTCTX *ctx, const GEOGRAPHIC_POINT *r, const SPHEROID *spheroid, double distance, double azimuth, GEOGRAPHIC_POINT *g);


#endif /* _RTGEODETIC_H */



/**
* Notes for rewrite
* 
* Define separate POINT types for 2-d-points-in-radiands and 3-d-points-in-geocentric
* Maintain consistent units (radians?) throughout all calculations
* Put an index pointer onto RTGEOM itself, and cache the indexed RTGEOM instead of a bare tree
* only primitive objects should get a tree
*/


