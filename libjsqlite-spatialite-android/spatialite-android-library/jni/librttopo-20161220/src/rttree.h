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
 * Copyright (C) 2009-2012 Paul Ramsey <pramsey@cleverelephant.ca>
 *
 **********************************************************************/


typedef struct rect_node
{
  double xmin;
  double xmax;
  double ymin;
  double ymax;
  struct rect_node *left_node;
  struct rect_node *right_node;
  RTPOINT2D *p1;
  RTPOINT2D *p2;
} RECT_NODE;

int rect_tree_contains_point(const RTCTX *ctx, const RECT_NODE *tree, const RTPOINT2D *pt, int *on_boundary);
int rect_tree_intersects_tree(const RTCTX *ctx, const RECT_NODE *tree1, const RECT_NODE *tree2);
void rect_tree_free(const RTCTX *ctx, RECT_NODE *node);
RECT_NODE* rect_node_leaf_new(const RTCTX *ctx, const RTPOINTARRAY *pa, int i);
RECT_NODE* rect_node_internal_new(const RTCTX *ctx, RECT_NODE *left_node, RECT_NODE *right_node);
RECT_NODE* rect_tree_new(const RTCTX *ctx, const RTPOINTARRAY *pa);
