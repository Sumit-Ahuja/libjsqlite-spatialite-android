# -------------------
# Android_R4.3.0.mk
# ndk-build clean
# ndk-build
# As of 2015-10-02
# -------------------
# changes:
# - geos-3.5.0
# - liblwgeom
# - json-c-0.12
# -------------------
LOCAL_PATH := $(call my-dir)
JSQLITE_PATH := javasqlite-20120209
SPATIALITE_PATH := libspatialite-4.3.0
GEOS_PATH := geos-3.5.0
JSONC_PATH := json-c-0.12
LWGEOM_PATH := postgis-2.2.svn/liblwgeom
PROJ4_PATH := proj-4.9.1
SQLITE_PATH := sqlite-amalgamation-3081002
ICONV_PATH := libiconv-1.13.1
RASTERLITE2_PATH := librasterlite2-4.3.0
GEOTIFF_PATH := libgeotiff-1.4.0
TIFF_PATH := tiff-4.0.4/libtiff
JPEG_PATH := jpeg-6b
GIF_PATH := giflib-5.1.1/lib
CAIRO_PATH := cairo-1.14.2/src
FREETYPE_PATH := freetype-2.6
FONTCONFIG_PATH := fontconfig-2.11.1
EXPAT_PATH := expat-2.1.0
PIXMAN_PATH := pixman-0.32.6
PNG_PATH := libpng-1.6.10
WEBP_PATH := libwebp-0.4.0
XML2_PATH := libxml2-2.9.2
CURL_PATH := curl-7.36.0
LZMA_PATH := xz-5.2.1
CHARLS_PATH := charls-1.0
OPENJPEG_PATH := openjpeg-2.0.0

include $(LOCAL_PATH)/charls-1.0.mk
include $(LOCAL_PATH)/jsqlite-R4.2.0.mk
include $(LOCAL_PATH)/iconv-1.13.1.mk
include $(LOCAL_PATH)/sqlite-3081002.mk
include $(LOCAL_PATH)/proj4-4.9.1.mk
include $(LOCAL_PATH)/geos-3.5.0.mk
include $(LOCAL_PATH)/json-c-0.12.mk
include $(LOCAL_PATH)/liblwgeom-2.2.0.mk
include $(LOCAL_PATH)/spatialite-4.3.0.mk
include $(LOCAL_PATH)/libjpeg-6b.mk
include $(LOCAL_PATH)/openjpeg-2.0.0.mk
include $(LOCAL_PATH)/giflib-5.1.1.mk
include $(LOCAL_PATH)/libpng-1.6.10.mk
include $(LOCAL_PATH)/libtiff-4.0.4.mk
include $(LOCAL_PATH)/libwebp-0.4.0.mk
include $(LOCAL_PATH)/pixman-0.32.6.mk
include $(LOCAL_PATH)/freetype-2.6.mk
include $(LOCAL_PATH)/fontconfig-2.11.1.mk
include $(LOCAL_PATH)/expat-2.1.0.mk
include $(LOCAL_PATH)/cairo-1.14.2.mk
include $(LOCAL_PATH)/libgeotiff-1.4.0.mk
include $(LOCAL_PATH)/libxml2-2.9.2.mk
include $(LOCAL_PATH)/libcurl-7.36.0.mk
include $(LOCAL_PATH)/lzma-xz-5.2.1.mk
include $(LOCAL_PATH)/rasterlite2-4.3.0.mk
$(call import-module,android/cpufeatures)
