/* =========================================================================
 * Copyright 2005-2007 Charlie Savage, cfis@interserv.com
 *
 * Interface for a SWIG generated geos module.
 *
 * This is free software; you can redistribute and/or modify it under
 * the terms of the GNU Lesser General Public Licence as published
 * by the Free Software Foundation. 
 * See the COPYING file for more information.
 *
 * ========================================================================= */

%module geos

%include "attribute.i"
%include "exception.i"
%include "std_string.i"
%include "std_vector.i"
%include "std_except.i"

%{ 
#include "geos_c.h"
/* Needed for va_start, etc. */
#include <stdarg.h>
%}

/* Constants copied from geos_c.h.  Would be nice
   to reuse the originals but we can't without exposing
   the whole c api. */
#define GEOS_VERSION_MAJOR 3
#define GEOS_VERSION_MINOR 6
#define GEOS_VERSION_PATCH 1
#define GEOS_VERSION "3.6.1"
#define GEOS_JTS_PORT "1.13.0"

#define GEOS_CAPI_VERSION_MAJOR 1
#define GEOS_CAPI_VERSION_MINOR 10
#define GEOS_CAPI_VERSION_PATCH 1
#define GEOS_CAPI_FIRST_INTERFACE GEOS_CAPI_VERSION_MAJOR 
#define GEOS_CAPI_LAST_INTERFACE (GEOS_CAPI_VERSION_MAJOR+GEOS_CAPI_VERSION_MINOR)
#define GEOS_CAPI_VERSION "3.6.1-CAPI-1.10.1"

/* Supported geometry types */
enum GEOSGeomTypes { 
    GEOS_POINT,
    GEOS_LINESTRING,
    GEOS_LINEARRING,
    GEOS_POLYGON,
    GEOS_MULTIPOINT,
    GEOS_MULTILINESTRING,
    GEOS_MULTIPOLYGON,
    GEOS_GEOMETRYCOLLECTION
};

enum GEOSByteOrders {
	GEOS_WKB_XDR = 0, /* Big Endian */
	GEOS_WKB_NDR = 1 /* Little Endian */
};

/* From OffsetCurveSetBuilder.h for buffer operations. */
%{
    static const int DEFAULT_QUADRANT_SEGMENTS=8;
%}

/* Message and Error Handling */
%{

/* This is not thread safe ! */
static const int MESSAGE_SIZE = 1000;
static char message[MESSAGE_SIZE];

void noticeHandler(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    vsnprintf(message, sizeof(message) - 1, fmt, args);
    va_end(args);
}

void errorHandler(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    vsnprintf(message, sizeof(message) - 1, fmt, args);
    va_end(args);
}
%}


/* First initialize geos */
%init %{
    initGEOS(noticeHandler, errorHandler);
%}


/* Module level methods */
%rename("version") GEOSversion;
const char *GEOSversion();

/* Exception handler */
%exception
{
    try
    {
        $action
    }
    catch (const std::exception& e)
    {
        SWIG_exception(SWIG_RuntimeError, e.what());
    }
}


/* ==============  Language Specific Files ============ */

/* Import language specific SWIG files.  This allows each language
   to define its own renames as well as any special functionality
   such as language specific iterators for collections. Note 
   that %include allows the included files to generate interface
   wrapper code while %import does not.  Thus use %include since
   this is an important feature (for example, Ruby needs it to #undef
   the select macro) */


#ifdef SWIGPYTHON
	%include ../swig/python/python.i
#endif

#ifdef SWIGRUBY
	%include ../swig/ruby/ruby.i
#endif




// ===  CoordinateSequence ===
%{
typedef void GeosCoordinateSequence;

void checkCoordSeqBounds(const GEOSCoordSeq coordSeq, const size_t index)
{
    unsigned int size = 0;
    GEOSCoordSeq_getSize(coordSeq, &size);

    if (index < 0 || index >= size)
        throw std::runtime_error("Index out of bounds");
}
%}

%newobject GeosCoordinateSequence::clone;
%rename (CoordinateSequence) GeosCoordinateSequence;
class GeosCoordinateSequence
{
public:
%extend
{
    GeosCoordinateSequence(size_t size, size_t dims)
    {
        return (GeosCoordinateSequence*) GEOSCoordSeq_create(size, dims);
    }

    ~GeosCoordinateSequence()
    {
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        return GEOSCoordSeq_destroy(coords);
    }

    GeosCoordinateSequence *clone()
    {
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        return (GeosCoordinateSequence*) GEOSCoordSeq_clone(coords);
    }

    int setX(size_t idx, double val)
    {
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        return GEOSCoordSeq_setX(coords, idx, val);
    }

    int setY(size_t idx, double val)
    {
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        return GEOSCoordSeq_setY(coords, idx, val);
    }

    int setZ(size_t idx, double val)
    {
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        return GEOSCoordSeq_setZ(coords, idx, val);
    }

    int setOrdinate(size_t idx, size_t dim, double val)
    {
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        return GEOSCoordSeq_setOrdinate(coords, idx, dim, val);
    }

    double getX(size_t idx)
    {
        double result;
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        GEOSCoordSeq_getX(coords, idx, &result);
        return result;
    }

    double getY(size_t idx)
    {
        double result;
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        GEOSCoordSeq_getY(coords, idx, &result);
        return result;
    }
    
    double getZ(size_t idx)
    {
        double result;
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        GEOSCoordSeq_getZ(coords, idx, &result);
        return result;
    }
    
    double getOrdinate(size_t idx, size_t dim)
    {
        double result;
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        checkCoordSeqBounds(coords, idx);
        GEOSCoordSeq_getOrdinate(coords, idx, dim, &result);
        return result;
    }

    unsigned int getSize()
    {
        unsigned int result;
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        GEOSCoordSeq_getSize(coords, &result);
        return result;
    }

    unsigned int getDimensions()
    {
        unsigned int result;
        GEOSCoordSeq coords = (GEOSCoordSeq) self;
        GEOSCoordSeq_getDimensions(coords, &result);
        return result;
    }
}
};


/* ========  Fake Classes to Create Geom Hierarchy ====== */
%rename(Geometry) GeosGeometry;
%rename(Point) GeosPoint;
%rename(LineString) GeosLineString;
%rename(LinearRing) GeosLinearRing;
%rename(Polygon) GeosPolygon;
%rename(GeometryCollection) GeosGeometryCollection;
%rename(MultiPoint) GeosMultiPoint;
%rename(MultiLineString) GeosMultiLineString;
%rename(MultiLinearRing) GeosMultiLinearRing;
%rename(MultiPolygon) GeosMultiPolygon;
%rename(WktReader) GeosWktReader;
%rename(WktWriter) GeosWktWriter;
%rename(WkbReader) GeosWkbReader;
%rename(WkbWriter) GeosWkbWriter;


%rename("union") GeosGeometry::geomUnion;

%{
typedef void GeosGeometry;
typedef void GeosPoint;
typedef void GeosLineString;
typedef void GeosLinearRing;
typedef void GeosPolygon;
typedef void GeosGeometryCollection;
typedef void GeosMultiPoint;
typedef void GeosMultiLineString;
typedef void GeosMultiLinearRing;
typedef void GeosMultiPolygon;

typedef void GeosWktReader;
typedef void GeosWktWriter;
typedef void GeosWkbReader;
typedef void GeosWkbWriter;
%}

%newobject GeosGeometry::intersection;
%newobject GeosGeometry::buffer;
%newobject GeosGeometry::convexHull;
%newobject GeosGeometry::difference;
%newobject GeosGeometry::symDifference;
%newobject GeosGeometry::boundary;
%newobject GeosGeometry::geomUnion;
%newobject GeosGeometry::pointOnSurface;
%newobject GeosGeometry::getCentroid;
%newobject GeosGeometry::relate;
%newobject GeosGeometry::lineMerge;
%newobject GeosGeometry::simplify;
%newobject GeosGeometry::topologyPreserveSimplify;


%typemap(out) GeosGeometry*
{
    /* %typemap(out) GeosGeometry */

    if ($1 == NULL)
        SWIG_exception(SWIG_RuntimeError, message);

    GeosGeometry *geom = $1;
    GEOSGeomTypes geomId = (GEOSGeomTypes)GEOSGeomTypeId((GEOSGeom) geom);

    switch (geomId)
    {
    case GEOS_POINT:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosPoint*), 0 | $owner);
        break;
	case GEOS_LINESTRING:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosLineString*), 0 | $owner);
        break;
	case GEOS_LINEARRING:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosLinearRing*), 0 | $owner);
        break;
	case GEOS_POLYGON:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosPolygon*), 0 | $owner);
        break;
	case GEOS_MULTIPOINT:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosMultiPoint*), 0 | $owner);
        break;
	case GEOS_MULTILINESTRING:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosMultiLineString*), 0 | $owner);
        break;
	case GEOS_MULTIPOLYGON:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosMultiPolygon*), 0 | $owner);
        break;
	case GEOS_GEOMETRYCOLLECTION:
        $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $descriptor(GeosGeometryCollection*), 0 | $owner);
        break;
    }
}

/* Setup a default typemap for buffer. */
%typemap(default) int quadsegs
{
    $1 = DEFAULT_QUADRANT_SEGMENTS;
}

%{
bool checkBoolResult(char result)
{
    int intResult = (int) result;

    if (intResult == 1)
        return true;
    else if (intResult == 0)
        return false;
    else
        throw std::runtime_error(message);
}
%}

%newobject GeosGeometry::clone;
class GeosGeometry
{
private:
    GeosGeometry();
public:
%extend
{
    ~GeosGeometry()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }

    GeosGeometry *clone()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSGeom_clone(geom);
    }
    
    char *geomType()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSGeomType(geom);
    }

    int typeId()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSGeomTypeId(geom);
    }
    
    void normalize()
    {
        GEOSGeom geom = (GEOSGeom) self;
        int result = GEOSNormalize(geom);

        if (result == -1)
            throw std::runtime_error(message);
    }

    int getSRID()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSGetSRID(geom);
    }

    void setSRID(int SRID)
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSSetSRID(geom, SRID);
    }

    size_t getDimensions()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSGeom_getDimensions(geom);
    }

    size_t getNumGeometries()
    {
        GEOSGeom geom = (GEOSGeom) self;
        size_t result = GEOSGetNumGeometries(geom);
        
        if ((int)result == -1)
            throw std::runtime_error(message);

        return result;
    }

    /* Topology Operations */
    GeosGeometry *intersection(GeosGeometry *other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return (GeosGeometry*) GEOSIntersection(geom, otherGeom);
    }

    GeosGeometry *buffer(double width, int quadsegs)
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSBuffer(geom, width, quadsegs);
    }

    GeosGeometry *convexHull()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSConvexHull(geom);
    }

    GeosGeometry *difference(GeosGeometry *other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return (GeosGeometry*) GEOSDifference(geom, otherGeom);
    }

    GeosGeometry *symDifference(GeosGeometry *other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return (GeosGeometry*) GEOSSymDifference(geom, otherGeom);
    }

    GeosGeometry *boundary()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSBoundary(geom);
    }

    GeosGeometry *geomUnion(GeosGeometry *other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return (GeosGeometry*) GEOSUnion(geom, otherGeom);
    }
    
    GeosGeometry *pointOnSurface()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSPointOnSurface(geom);
    }

    GeosGeometry *getCentroid()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSGetCentroid(geom);
    }

    GeosGeometry *getEnvelope()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSEnvelope(geom);
    }

    char *relate(GeosGeometry *other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return GEOSRelate(geom, otherGeom);
    }

    /* TODO - expose GEOSPolygonize*/
    GeosGeometry *lineMerge()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return GEOSLineMerge(geom);
    }

    GeosGeometry *simplify(double tolerance)
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSSimplify(geom, tolerance);
    }

    GeosGeometry *topologyPreserveSimplify(double tolerance)
    {
        GEOSGeom geom = (GEOSGeom) self;
        return (GeosGeometry*) GEOSTopologyPreserveSimplify(geom, tolerance);
    }

    /* Binary predicates - return 2 on exception, 1 on true, 0 on false */
    bool relatePattern(const GeosGeometry* other, const char *pat)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSRelatePattern(geom, otherGeom, pat));
    }

    bool disjoint(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSDisjoint(geom, otherGeom));
    }

    bool touches(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSTouches(geom, otherGeom));
    }

    bool intersects(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSIntersects(geom, otherGeom));
    }

    bool crosses(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSCrosses(geom, otherGeom));
    }

    bool within(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSWithin(geom, otherGeom));
    }

    bool contains(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSContains(geom, otherGeom));
    }

    bool overlaps(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSOverlaps(geom, otherGeom));
    }

    bool equals(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSEquals(geom, otherGeom));
    }

    bool equalsExact(const GeosGeometry* other, double tolerance)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSEqualsExact(geom, otherGeom, tolerance));
    }

    /* Unary predicate - return 2 on exception, 1 on true, 0 on false */
    bool isEmpty()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return checkBoolResult(GEOSisEmpty(geom));
    }

    bool isValid()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return checkBoolResult(GEOSisValid(geom));
    }

    bool isSimple()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return checkBoolResult(GEOSisSimple(geom));
    }

    bool isRing()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return checkBoolResult(GEOSisRing(geom));
    }

    bool hasZ()
    {
        GEOSGeom geom = (GEOSGeom) self;
        return checkBoolResult(GEOSHasZ(geom));
    }

    /* Miscellaneous Functions.
       Return 0 on exception, 1 otherwise */
    double area()
    {
        GEOSGeom geom = (GEOSGeom) self;
        double result;

        int code = GEOSArea(geom, &result);

        if (code == 0)
            throw std::runtime_error(message);

        return result;
    }

    double length()
    {
        GEOSGeom geom = (GEOSGeom) self;
        double result;

        int code = GEOSLength(geom, &result);

        if (code == 0)
            throw std::runtime_error(message);

        return result;
    }

    double distance(const GeosGeometry* other)
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        double result;

        int code = GEOSDistance(geom, otherGeom, &result);

        if (code == 0)
            throw std::runtime_error(message);

        return result;
    }
}
};

class GeosPoint: public GeosGeometry
{
private:
    GeosPoint();
public:
%extend
{   
    ~GeosPoint()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
    
    const GeosCoordinateSequence* getCoordSeq()
    {
        GEOSGeom geom = (GEOSGeom) self;
        const GEOSCoordSeq result = (const GEOSCoordSeq) GEOSGeom_getCoordSeq(geom);

        if (result == NULL)
            throw std::runtime_error(message);

        return (const GeosCoordinateSequence*) result;
    }
}
};

class GeosLineString: public GeosGeometry
{
public:
%extend
{   
    ~GeosLineString()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
    
    const GeosCoordinateSequence* getCoordSeq()
    {
        GEOSGeom geom = (GEOSGeom) self;
        const GEOSCoordSeq result = (const GEOSCoordSeq) GEOSGeom_getCoordSeq(geom);

        if (result == NULL)
            throw std::runtime_error(message);

        return (const GeosCoordinateSequence*) result;
    }
}
};

class GeosLinearRing: public GeosGeometry
{
public:
%extend
{   
    ~GeosLinearRing()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
    
    const GeosCoordinateSequence* getCoordSeq()
    {
        GEOSGeom geom = (GEOSGeom) self;
        const GEOSCoordSeq result = (const GEOSCoordSeq) GEOSGeom_getCoordSeq(geom);

        if (result == NULL)
            throw std::runtime_error(message);

        return (const GeosCoordinateSequence*) result;
    }
}
};


class GeosPolygon: public GeosGeometry
{
public:
%extend
{   
    ~GeosPolygon()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
    
    const GeosGeometry* getExteriorRing()
    {
        GEOSGeom geom = (GEOSGeom) self;
        const GEOSGeom result = (const GEOSGeom) GEOSGetExteriorRing(geom);

        if (result == NULL)
            throw std::runtime_error(message);

        return (const GeosGeometry*) result;
    }

    size_t getNumInteriorRings()
    {
        GEOSGeom geom = (GEOSGeom) self;
        size_t result = GEOSGetNumInteriorRings(geom);

        if ((int)result == -1)
            throw std::runtime_error(message);

        return result;
    }

    const GeosGeometry* getInteriorRingN(size_t n)
    {
        GEOSGeom geom = (GEOSGeom) self;

        size_t size = GEOSGetNumInteriorRings(geom);

        if (n < 0 || n >= size)
            throw std::runtime_error("Index out of bounds");

        const GEOSGeom result = (const GEOSGeom) GEOSGetInteriorRingN(geom, n);

        if (result == NULL)
            throw std::runtime_error(message);

        return (const GeosGeometry*) result;
    }
}
};

class GeosGeometryCollection: public GeosGeometry
{
public:
%extend
{   
    ~GeosGeometryCollection()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
    
    const GeosGeometry* getGeometryN(size_t n)
    {
        GEOSGeom geom = (GEOSGeom) self;
        const GEOSGeom result = (const GEOSGeom) GEOSGetGeometryN(geom, n);

        if (result == NULL)
            throw std::runtime_error(message);

        return (const GeosGeometry*) result;
    }
}
};

class GeosMultiPoint: public GeosGeometryCollection
{
public:
%extend
{   
    ~GeosMultiPoint()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
}
};

class GeosMultiLineString: public GeosGeometryCollection
{
public:
%extend
{   
    ~GeosMultiLineString()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
}
};

class GeosMultiLinearRing: public GeosGeometryCollection
{
public:
%extend
{   
    ~GeosMultiLinearRing()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
}
};

class GeosMultiPolygon: public GeosGeometryCollection
{
public:
%extend
{   
    ~GeosMultiPolygon()
    {
        GEOSGeom geom = (GEOSGeom) self;
        GEOSGeom_destroy(geom);
    }
}
};


// ==== Geometry Constructors ===========
%newobject createPoint;
%newobject createLineString;
%newobject createLinearRing;
%newobject createPolygon;

%apply SWIGTYPE *DISOWN {GeosCoordinateSequence *s};
%apply SWIGTYPE *DISOWN {GeosLinearRing *shell};

%typemap(default) (GeosLinearRing **holes, size_t nholes)
{
    $1 = NULL;
    $2 = 0;
}

%inline %{
GeosGeometry *createPoint(GeosCoordinateSequence *s)
{
    GEOSCoordSeq coords = (GEOSCoordSeq) s;
    GEOSGeom geom = GEOSGeom_createPoint(coords);

    if(geom == NULL)
        throw std::runtime_error(message);

    return (GeosGeometry*) geom;
}

GeosGeometry *createLineString(GeosCoordinateSequence *s)
{
    GEOSCoordSeq coords = (GEOSCoordSeq) s;
    GEOSGeom geom = GEOSGeom_createLineString(coords);

    if(geom == NULL)
        throw std::runtime_error(message);

    return (GeosGeometry*) geom;
}

GeosGeometry *createLinearRing(GeosCoordinateSequence *s)
{
    GEOSCoordSeq coords = (GEOSCoordSeq) s;
    GEOSGeom geom = GEOSGeom_createLinearRing(coords);

    if(geom == NULL)
        throw std::runtime_error(message);

    return (GeosGeometry*) geom;
}

GeosGeometry *createPolygon(GeosLinearRing *shell, GeosLinearRing **holes, size_t nholes)
{
    GEOSGeom shellGeom = (GEOSGeom) shell;
    GEOSGeom* holeGeoms = (GEOSGeom*) holes;
    GEOSGeom geom = GEOSGeom_createPolygon(shellGeom, holeGeoms, nholes);

    if(geom == NULL)
        throw std::runtime_error(message);

    return (GeosGeometry*) geom;
}

%}

/*
 * Second argument is an array of GEOSGeom objects.
 * The caller remains owner of the array, but pointed-to
 * objects become ownership of the returned GEOSGeom.
 
extern GEOSGeom GEOS_DLL GEOSGeom_createCollection(int type,
	GEOSGeom *geoms, size_t ngeoms);
*/

%clear GeosCoordinateSequence *s;

// === Prepared Geometry ===

%{
typedef void GeosPreparedGeometry;
%}

%rename (Prepared) GeosPreparedGeometry;
class GeosPreparedGeometry
{
public:
%extend
{
    GeosPreparedGeometry(const GeosGeometry *source)
    {
        const GEOSPreparedGeometry *prep = GEOSPrepare((const GEOSGeometry *)source);
        if(prep == NULL)
            throw std::runtime_error(message);
        return (GeosPreparedGeometry *) prep;
    }

    ~GeosPreparedGeometry()
    {
        GEOSPreparedGeometry *prep = (GEOSPreparedGeometry *) self;
        return GEOSPreparedGeom_destroy(prep);
    }

    bool contains (const GeosGeometry* other)
    {
        GEOSPreparedGeometry *prep = (GEOSPreparedGeometry *) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSPreparedContains(prep, otherGeom));
    }

    bool containsProperly(const GeosGeometry* other)
    {
        GEOSPreparedGeometry *prep = (GEOSPreparedGeometry *) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSPreparedContainsProperly(prep, otherGeom));
    }

    bool covers (const GeosGeometry* other)
    {
        GEOSPreparedGeometry *prep = (GEOSPreparedGeometry *) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSPreparedCovers(prep, otherGeom));
    }

    bool intersects (const GeosGeometry* other)
    {
        GEOSPreparedGeometry *prep = (GEOSPreparedGeometry *) self;
        GEOSGeom otherGeom = (GEOSGeom) other;
        return checkBoolResult(GEOSPreparedIntersects(prep, otherGeom));
    }
}
};

// === STRtree ===

%{
typedef void GeosSTRtree;
/* GeosIndexItem typedef'd here so it can be %typemap(typecheck)'d
   as a native object by each language specially */
typedef void *GeosIndexItem;
typedef GEOSQueryCallback GeosQueryCallback;
%}

%rename (STRtree) GeosSTRtree;
class GeosSTRtree
{
public:
%extend
{
    %typemap(default) int nodeCapacity {
     $1 = 10;
    };
    GeosSTRtree(int nodeCapacity)
    {
        GEOSSTRtree *tree = GEOSSTRtree_create(nodeCapacity);
        if(tree == NULL)
            throw std::runtime_error(message);
        return (GeosSTRtree *) tree;
    }

    ~GeosSTRtree()
    {
        GEOSSTRtree *tree = (GEOSSTRtree *) self;
        return GEOSSTRtree_destroy(tree);
    }

    void insert (const GeosGeometry* g, GeosIndexItem item)
    {
        GEOSSTRtree *tree = (GEOSSTRtree *) self;
        const GEOSGeometry *geom = (const GEOSGeometry *) g;
        GEOSSTRtree_insert(tree, geom, item);
    }

    void remove (const GeosGeometry* g, GeosIndexItem item)
    {
        GEOSSTRtree *tree = (GEOSSTRtree *) self;
        const GEOSGeometry *geom = (const GEOSGeometry *) g;
        GEOSSTRtree_remove(tree, geom, item);
    }

    void query (const GeosGeometry* g, GeosQueryCallback callback,
                GeosIndexItem accumulator)
    {
        GEOSSTRtree *tree = (GEOSSTRtree *) self;
        const GEOSGeometry *geom = (const GEOSGeometry *) g;
        GEOSSTRtree_query(tree, geom, callback, accumulator);
    }

    void iterate (GeosQueryCallback callback, GeosIndexItem accumulator)
    {
        GEOSSTRtree *tree = (GEOSSTRtree *) self;
        GEOSSTRtree_iterate(tree, callback, accumulator);
    }
}
};


// === Input/Output ===

/* This typemap allows the scripting language to pass in buffers
   to the geometry write methods. */
%typemap(in) (const unsigned char* wkb, size_t size) (int alloc = 0)
{
    /* %typemap(in) (const unsigned char* wkb, size_t size) (int alloc = 0) */
    if (SWIG_AsCharPtrAndSize($input, (char**)&$1, &$2, &alloc) != SWIG_OK)
        SWIG_exception(SWIG_RuntimeError, "Expecting a string");
    /* Don't want to include last null character! */
    $2--;
}

/* These three type maps are for geomToWKB and geomToHEX.  We need
to ignore the size input argument, then create a new string in the
scripting language of the correct size, and then free the 
provided string. */

/* set the size parameter to a temporary variable. */
%typemap(in, numinputs=0) size_t *size (size_t temp = 0)
{
	/* %typemap(in, numinputs=0) size_t *size (size_t temp = 0) */
  	$1 = &temp;
}

/* Disable SWIG's normally generated code so we can replace it
   with the argout typemap below. */
%typemap(out) unsigned char* 
{
    /* %typemap(out) unsigned char* */
}

/* Create a new target string of the correct size. */
%typemap(argout) size_t *size 
{
    /* %typemap(argout) size_t *size */
    $result = SWIG_FromCharPtrAndSize((const char*)result, *$1);
}

/* Free the c-string returned  by the function. */
%typemap(freearg) size_t *size
{
    /* %typemap(freearg) size_t *size */
    std::free(result);
}


%newobject GeosWktReader::read;
class GeosWktReader
{
public:
%extend
{
    GeosWktReader()
    {
        return GEOSWKTReader_create();
    }
        
    ~GeosWktReader()
    {
        GEOSWKTReader *reader = (GEOSWKTReader*) self;
        GEOSWKTReader_destroy(reader);
    }
    
    GeosGeometry* read(const char *wkt)
    {
        if(wkt == NULL)
            throw std::runtime_error("Trying to create geometry from a NULL string");
            
        GEOSWKTReader *reader = (GEOSWKTReader*) self;
        GEOSGeometry *geom = GEOSWKTReader_read(reader, wkt);

        if(geom == NULL)
            throw std::runtime_error(message);

        return (GeosGeometry*) geom;
    }
}
};

class GeosWktWriter
{
public:
%extend
{
    GeosWktWriter()
    {
        return GEOSWKTWriter_create();
    }
        
    ~GeosWktWriter()
    {
        GEOSWKTWriter *writer = (GEOSWKTWriter*) self;
        GEOSWKTWriter_destroy(writer);
    }
    
    char* write(const GeosGeometry* g)
    {
        GEOSWKTWriter *writer = (GEOSWKTWriter*) self;
        GEOSGeom geom = (GEOSGeom) g;
        return GEOSWKTWriter_write(writer, geom);
    }
}
};


%newobject GeosWkbReader::read;
%newobject GeosWkbReader::readHEX;
class GeosWkbReader
{
public:
%extend
{
    GeosWkbReader()
    {
        return GEOSWKBReader_create();
    }
        
    ~GeosWkbReader()
    {
        GEOSWKBReader *reader = (GEOSWKBReader*) self;
        GEOSWKBReader_destroy(reader);
    }
    
    GeosGeometry* read(const unsigned char *wkb, size_t size)
    {
        if(wkb == NULL)
          throw std::runtime_error("Trying to create geometry from a NULL string");
         
        GEOSWKBReader *reader = (GEOSWKBReader*) self;
        GEOSGeometry *geom = GEOSWKBReader_read(reader, wkb, size);
       
        if(geom == NULL)
          throw std::runtime_error(message);

        return (GeosGeometry*) geom;
    }
    
    GeosGeometry* readHEX(const unsigned char *wkb, size_t size)
    {
        if(wkb == NULL)
          throw std::runtime_error("Trying to create geometry from a NULL string");
         
        GEOSWKBReader *reader = (GEOSWKBReader*) self;
        GEOSGeometry *geom = GEOSWKBReader_readHEX(reader, wkb, size);
       
        if(geom == NULL)
          throw std::runtime_error(message);

        return (GeosGeometry*) geom;
    }
}
};

class GeosWkbWriter
{
public:
%extend
{
    GeosWkbWriter()
    {
        return GEOSWKBWriter_create();
    }
        
    ~GeosWkbWriter()
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        GEOSWKBWriter_destroy(writer);
    }
    
    int getOutputDimension()
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        return GEOSWKBWriter_getOutputDimension(writer);
    }

    void setOutputDimension(int newDimension)
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        GEOSWKBWriter_setOutputDimension(writer, newDimension);
    }

    int getByteOrder()
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        return GEOSWKBWriter_getByteOrder(writer);
    }

    void setByteOrder(int newByteOrder)
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        return GEOSWKBWriter_setByteOrder(writer, newByteOrder);
    }

    bool getIncludeSRID()
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        return GEOSWKBWriter_getIncludeSRID(writer);
    }

    void setIncludeSRID(bool newIncludeSRID)
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        return GEOSWKBWriter_setIncludeSRID(writer, newIncludeSRID);
    }
    
    unsigned char* write(const GeosGeometry* g, size_t *size)
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        GEOSGeom geom = (GEOSGeom) g;
        return GEOSWKBWriter_write(writer, geom, size);
    }
    
    unsigned char* writeHEX(const GeosGeometry* g, size_t *size)
    {
        GEOSWKBWriter *writer = (GEOSWKBWriter*) self;
        GEOSGeom geom = (GEOSGeom) g;
        return GEOSWKBWriter_writeHEX(writer, geom, size);
    }
}
};
