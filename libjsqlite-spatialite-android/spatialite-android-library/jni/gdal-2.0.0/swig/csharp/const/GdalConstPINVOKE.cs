/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.7
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

namespace OSGeo.GDAL {

using System;
using System.Runtime.InteropServices;

class GdalConstPINVOKE {

  protected class SWIGExceptionHelper {

    public delegate void ExceptionDelegate(string message);
    public delegate void ExceptionArgumentDelegate(string message, string paramName);

    static ExceptionDelegate applicationDelegate = new ExceptionDelegate(SetPendingApplicationException);
    static ExceptionDelegate arithmeticDelegate = new ExceptionDelegate(SetPendingArithmeticException);
    static ExceptionDelegate divideByZeroDelegate = new ExceptionDelegate(SetPendingDivideByZeroException);
    static ExceptionDelegate indexOutOfRangeDelegate = new ExceptionDelegate(SetPendingIndexOutOfRangeException);
    static ExceptionDelegate invalidCastDelegate = new ExceptionDelegate(SetPendingInvalidCastException);
    static ExceptionDelegate invalidOperationDelegate = new ExceptionDelegate(SetPendingInvalidOperationException);
    static ExceptionDelegate ioDelegate = new ExceptionDelegate(SetPendingIOException);
    static ExceptionDelegate nullReferenceDelegate = new ExceptionDelegate(SetPendingNullReferenceException);
    static ExceptionDelegate outOfMemoryDelegate = new ExceptionDelegate(SetPendingOutOfMemoryException);
    static ExceptionDelegate overflowDelegate = new ExceptionDelegate(SetPendingOverflowException);
    static ExceptionDelegate systemDelegate = new ExceptionDelegate(SetPendingSystemException);

    static ExceptionArgumentDelegate argumentDelegate = new ExceptionArgumentDelegate(SetPendingArgumentException);
    static ExceptionArgumentDelegate argumentNullDelegate = new ExceptionArgumentDelegate(SetPendingArgumentNullException);
    static ExceptionArgumentDelegate argumentOutOfRangeDelegate = new ExceptionArgumentDelegate(SetPendingArgumentOutOfRangeException);

    [DllImport("gdalconst_wrap", EntryPoint="SWIGRegisterExceptionCallbacks_GdalConst")]
    public static extern void SWIGRegisterExceptionCallbacks_GdalConst(
                                ExceptionDelegate applicationDelegate,
                                ExceptionDelegate arithmeticDelegate,
                                ExceptionDelegate divideByZeroDelegate, 
                                ExceptionDelegate indexOutOfRangeDelegate, 
                                ExceptionDelegate invalidCastDelegate,
                                ExceptionDelegate invalidOperationDelegate,
                                ExceptionDelegate ioDelegate,
                                ExceptionDelegate nullReferenceDelegate,
                                ExceptionDelegate outOfMemoryDelegate, 
                                ExceptionDelegate overflowDelegate, 
                                ExceptionDelegate systemExceptionDelegate);

    [DllImport("gdalconst_wrap", EntryPoint="SWIGRegisterExceptionArgumentCallbacks_GdalConst")]
    public static extern void SWIGRegisterExceptionCallbacksArgument_GdalConst(
                                ExceptionArgumentDelegate argumentDelegate,
                                ExceptionArgumentDelegate argumentNullDelegate,
                                ExceptionArgumentDelegate argumentOutOfRangeDelegate);

    static void SetPendingApplicationException(string message) {
      SWIGPendingException.Set(new System.ApplicationException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingArithmeticException(string message) {
      SWIGPendingException.Set(new System.ArithmeticException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingDivideByZeroException(string message) {
      SWIGPendingException.Set(new System.DivideByZeroException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingIndexOutOfRangeException(string message) {
      SWIGPendingException.Set(new System.IndexOutOfRangeException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingInvalidCastException(string message) {
      SWIGPendingException.Set(new System.InvalidCastException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingInvalidOperationException(string message) {
      SWIGPendingException.Set(new System.InvalidOperationException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingIOException(string message) {
      SWIGPendingException.Set(new System.IO.IOException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingNullReferenceException(string message) {
      SWIGPendingException.Set(new System.NullReferenceException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingOutOfMemoryException(string message) {
      SWIGPendingException.Set(new System.OutOfMemoryException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingOverflowException(string message) {
      SWIGPendingException.Set(new System.OverflowException(message, SWIGPendingException.Retrieve()));
    }
    static void SetPendingSystemException(string message) {
      SWIGPendingException.Set(new System.SystemException(message, SWIGPendingException.Retrieve()));
    }

    static void SetPendingArgumentException(string message, string paramName) {
      SWIGPendingException.Set(new System.ArgumentException(message, paramName, SWIGPendingException.Retrieve()));
    }
    static void SetPendingArgumentNullException(string message, string paramName) {
      Exception e = SWIGPendingException.Retrieve();
      if (e != null) message = message + " Inner Exception: " + e.Message;
      SWIGPendingException.Set(new System.ArgumentNullException(paramName, message));
    }
    static void SetPendingArgumentOutOfRangeException(string message, string paramName) {
      Exception e = SWIGPendingException.Retrieve();
      if (e != null) message = message + " Inner Exception: " + e.Message;
      SWIGPendingException.Set(new System.ArgumentOutOfRangeException(paramName, message));
    }

    static SWIGExceptionHelper() {
      SWIGRegisterExceptionCallbacks_GdalConst(
                                applicationDelegate,
                                arithmeticDelegate,
                                divideByZeroDelegate,
                                indexOutOfRangeDelegate,
                                invalidCastDelegate,
                                invalidOperationDelegate,
                                ioDelegate,
                                nullReferenceDelegate,
                                outOfMemoryDelegate,
                                overflowDelegate,
                                systemDelegate);

      SWIGRegisterExceptionCallbacksArgument_GdalConst(
                                argumentDelegate,
                                argumentNullDelegate,
                                argumentOutOfRangeDelegate);
    }
  }

  protected static SWIGExceptionHelper swigExceptionHelper = new SWIGExceptionHelper();

  public class SWIGPendingException {
    [ThreadStatic]
    private static Exception pendingException = null;
    private static int numExceptionsPending = 0;

    public static bool Pending {
      get {
        bool pending = false;
        if (numExceptionsPending > 0)
          if (pendingException != null)
            pending = true;
        return pending;
      } 
    }

    public static void Set(Exception e) {
      if (pendingException != null)
        throw new ApplicationException("FATAL: An earlier pending exception from unmanaged code was missed and thus not thrown (" + pendingException.ToString() + ")", e);
      pendingException = e;
      lock(typeof(GdalConstPINVOKE)) {
        numExceptionsPending++;
      }
    }

    public static Exception Retrieve() {
      Exception e = null;
      if (numExceptionsPending > 0) {
        if (pendingException != null) {
          e = pendingException;
          pendingException = null;
          lock(typeof(GdalConstPINVOKE)) {
            numExceptionsPending--;
          }
        }
      }
      return e;
    }
  }


  protected class SWIGStringHelper {

    public delegate string SWIGStringDelegate(string message);
    static SWIGStringDelegate stringDelegate = new SWIGStringDelegate(CreateString);

    [DllImport("gdalconst_wrap", EntryPoint="SWIGRegisterStringCallback_GdalConst")]
    public static extern void SWIGRegisterStringCallback_GdalConst(SWIGStringDelegate stringDelegate);

    static string CreateString(string cString) {
      return cString;
    }

    static SWIGStringHelper() {
      SWIGRegisterStringCallback_GdalConst(stringDelegate);
    }
  }

  static protected SWIGStringHelper swigStringHelper = new SWIGStringHelper();


  static GdalConstPINVOKE() {
  }


  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_Unknown_get")]
  public static extern int GDT_Unknown_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_Byte_get")]
  public static extern int GDT_Byte_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_UInt16_get")]
  public static extern int GDT_UInt16_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_Int16_get")]
  public static extern int GDT_Int16_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_UInt32_get")]
  public static extern int GDT_UInt32_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_Int32_get")]
  public static extern int GDT_Int32_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_Float32_get")]
  public static extern int GDT_Float32_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_Float64_get")]
  public static extern int GDT_Float64_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_CInt16_get")]
  public static extern int GDT_CInt16_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_CInt32_get")]
  public static extern int GDT_CInt32_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_CFloat32_get")]
  public static extern int GDT_CFloat32_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_CFloat64_get")]
  public static extern int GDT_CFloat64_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDT_TypeCount_get")]
  public static extern int GDT_TypeCount_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GA_ReadOnly_get")]
  public static extern int GA_ReadOnly_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GA_Update_get")]
  public static extern int GA_Update_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GF_Read_get")]
  public static extern int GF_Read_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GF_Write_get")]
  public static extern int GF_Write_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_NearestNeighbour_get")]
  public static extern int GRIORA_NearestNeighbour_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_Bilinear_get")]
  public static extern int GRIORA_Bilinear_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_Cubic_get")]
  public static extern int GRIORA_Cubic_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_CubicSpline_get")]
  public static extern int GRIORA_CubicSpline_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_Lanczos_get")]
  public static extern int GRIORA_Lanczos_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_Average_get")]
  public static extern int GRIORA_Average_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_Mode_get")]
  public static extern int GRIORA_Mode_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRIORA_Gauss_get")]
  public static extern int GRIORA_Gauss_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_Undefined_get")]
  public static extern int GCI_Undefined_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_GrayIndex_get")]
  public static extern int GCI_GrayIndex_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_PaletteIndex_get")]
  public static extern int GCI_PaletteIndex_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_RedBand_get")]
  public static extern int GCI_RedBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_GreenBand_get")]
  public static extern int GCI_GreenBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_BlueBand_get")]
  public static extern int GCI_BlueBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_AlphaBand_get")]
  public static extern int GCI_AlphaBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_HueBand_get")]
  public static extern int GCI_HueBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_SaturationBand_get")]
  public static extern int GCI_SaturationBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_LightnessBand_get")]
  public static extern int GCI_LightnessBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_CyanBand_get")]
  public static extern int GCI_CyanBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_MagentaBand_get")]
  public static extern int GCI_MagentaBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_YellowBand_get")]
  public static extern int GCI_YellowBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_BlackBand_get")]
  public static extern int GCI_BlackBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_YCbCr_YBand_get")]
  public static extern int GCI_YCbCr_YBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_YCbCr_CrBand_get")]
  public static extern int GCI_YCbCr_CrBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GCI_YCbCr_CbBand_get")]
  public static extern int GCI_YCbCr_CbBand_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_NearestNeighbour_get")]
  public static extern int GRA_NearestNeighbour_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_Bilinear_get")]
  public static extern int GRA_Bilinear_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_Cubic_get")]
  public static extern int GRA_Cubic_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_CubicSpline_get")]
  public static extern int GRA_CubicSpline_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_Lanczos_get")]
  public static extern int GRA_Lanczos_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_Average_get")]
  public static extern int GRA_Average_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GRA_Mode_get")]
  public static extern int GRA_Mode_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GPI_Gray_get")]
  public static extern int GPI_Gray_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GPI_RGB_get")]
  public static extern int GPI_RGB_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GPI_CMYK_get")]
  public static extern int GPI_CMYK_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GPI_HLS_get")]
  public static extern int GPI_HLS_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CXT_Element_get")]
  public static extern int CXT_Element_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CXT_Text_get")]
  public static extern int CXT_Text_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CXT_Attribute_get")]
  public static extern int CXT_Attribute_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CXT_Comment_get")]
  public static extern int CXT_Comment_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CXT_Literal_get")]
  public static extern int CXT_Literal_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CE_None_get")]
  public static extern int CE_None_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CE_Debug_get")]
  public static extern int CE_Debug_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CE_Warning_get")]
  public static extern int CE_Warning_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CE_Failure_get")]
  public static extern int CE_Failure_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CE_Fatal_get")]
  public static extern int CE_Fatal_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_None_get")]
  public static extern int CPLE_None_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_AppDefined_get")]
  public static extern int CPLE_AppDefined_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_OutOfMemory_get")]
  public static extern int CPLE_OutOfMemory_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_FileIO_get")]
  public static extern int CPLE_FileIO_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_OpenFailed_get")]
  public static extern int CPLE_OpenFailed_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_IllegalArg_get")]
  public static extern int CPLE_IllegalArg_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_NotSupported_get")]
  public static extern int CPLE_NotSupported_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_AssertionFailed_get")]
  public static extern int CPLE_AssertionFailed_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_NoWriteAccess_get")]
  public static extern int CPLE_NoWriteAccess_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLE_UserInterrupt_get")]
  public static extern int CPLE_UserInterrupt_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_ALL_get")]
  public static extern int OF_ALL_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_RASTER_get")]
  public static extern int OF_RASTER_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_VECTOR_get")]
  public static extern int OF_VECTOR_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_READONLY_get")]
  public static extern int OF_READONLY_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_UPDATE_get")]
  public static extern int OF_UPDATE_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_SHARED_get")]
  public static extern int OF_SHARED_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_OF_VERBOSE_ERROR_get")]
  public static extern int OF_VERBOSE_ERROR_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_LONGNAME_get")]
  public static extern string GDAL_DMD_LONGNAME_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_HELPTOPIC_get")]
  public static extern string GDAL_DMD_HELPTOPIC_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_MIMETYPE_get")]
  public static extern string GDAL_DMD_MIMETYPE_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_EXTENSION_get")]
  public static extern string GDAL_DMD_EXTENSION_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_EXTENSIONS_get")]
  public static extern string GDAL_DMD_EXTENSIONS_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_DMD_CONNECTION_PREFIX_get")]
  public static extern string DMD_CONNECTION_PREFIX_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_CREATIONOPTIONLIST_get")]
  public static extern string GDAL_DMD_CREATIONOPTIONLIST_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_CREATIONDATATYPES_get")]
  public static extern string GDAL_DMD_CREATIONDATATYPES_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_CREATIONFIELDDATATYPES_get")]
  public static extern string GDAL_DMD_CREATIONFIELDDATATYPES_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DMD_SUBDATASETS_get")]
  public static extern string GDAL_DMD_SUBDATASETS_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DCAP_OPEN_get")]
  public static extern string GDAL_DCAP_OPEN_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DCAP_CREATE_get")]
  public static extern string GDAL_DCAP_CREATE_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DCAP_CREATECOPY_get")]
  public static extern string GDAL_DCAP_CREATECOPY_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GDAL_DCAP_VIRTUALIO_get")]
  public static extern string GDAL_DCAP_VIRTUALIO_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_DCAP_RASTER_get")]
  public static extern string DCAP_RASTER_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_DCAP_VECTOR_get")]
  public static extern string DCAP_VECTOR_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_DCAP_NOTNULL_FIELDS_get")]
  public static extern string DCAP_NOTNULL_FIELDS_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_DCAP_DEFAULT_FIELDS_get")]
  public static extern string DCAP_DEFAULT_FIELDS_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_DCAP_NOTNULL_GEOMFIELDS_get")]
  public static extern string DCAP_NOTNULL_GEOMFIELDS_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLES_BackslashQuotable_get")]
  public static extern int CPLES_BackslashQuotable_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLES_XML_get")]
  public static extern int CPLES_XML_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLES_URL_get")]
  public static extern int CPLES_URL_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLES_SQL_get")]
  public static extern int CPLES_SQL_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_CPLES_CSV_get")]
  public static extern int CPLES_CSV_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFT_Integer_get")]
  public static extern int GFT_Integer_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFT_Real_get")]
  public static extern int GFT_Real_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFT_String_get")]
  public static extern int GFT_String_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Generic_get")]
  public static extern int GFU_Generic_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_PixelCount_get")]
  public static extern int GFU_PixelCount_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Name_get")]
  public static extern int GFU_Name_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Min_get")]
  public static extern int GFU_Min_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Max_get")]
  public static extern int GFU_Max_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_MinMax_get")]
  public static extern int GFU_MinMax_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Red_get")]
  public static extern int GFU_Red_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Green_get")]
  public static extern int GFU_Green_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Blue_get")]
  public static extern int GFU_Blue_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_Alpha_get")]
  public static extern int GFU_Alpha_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_RedMin_get")]
  public static extern int GFU_RedMin_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_GreenMin_get")]
  public static extern int GFU_GreenMin_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_BlueMin_get")]
  public static extern int GFU_BlueMin_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_AlphaMin_get")]
  public static extern int GFU_AlphaMin_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_RedMax_get")]
  public static extern int GFU_RedMax_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_GreenMax_get")]
  public static extern int GFU_GreenMax_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_BlueMax_get")]
  public static extern int GFU_BlueMax_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_AlphaMax_get")]
  public static extern int GFU_AlphaMax_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GFU_MaxCount_get")]
  public static extern int GFU_MaxCount_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GMF_ALL_VALID_get")]
  public static extern int GMF_ALL_VALID_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GMF_PER_DATASET_get")]
  public static extern int GMF_PER_DATASET_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GMF_ALPHA_get")]
  public static extern int GMF_ALPHA_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GMF_NODATA_get")]
  public static extern int GMF_NODATA_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GARIO_PENDING_get")]
  public static extern int GARIO_PENDING_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GARIO_UPDATE_get")]
  public static extern int GARIO_UPDATE_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GARIO_ERROR_get")]
  public static extern int GARIO_ERROR_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GARIO_COMPLETE_get")]
  public static extern int GARIO_COMPLETE_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GTO_TIP_get")]
  public static extern int GTO_TIP_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GTO_BIT_get")]
  public static extern int GTO_BIT_get();

  [DllImport("gdalconst_wrap", EntryPoint="CSharp_GTO_BSQ_get")]
  public static extern int GTO_BSQ_get();
}

}
