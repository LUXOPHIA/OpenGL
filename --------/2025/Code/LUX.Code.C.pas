unit LUX.Code.C;

interface //#################################################################### ■

uses System.Types, System.SysUtils,
     WinApi.Windows,
     LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     T_bool                = Boolean;              P_bool                = PBoolean;              { PP_bool               = PPBoolean;   }  //                 bool
     T_char                = AnsiChar;             P_char                = PAnsiChar;               PP_char               = PPAnsiChar;     //                 char
     T_signed_char         = Shortint;             P_signed_char         = PShortint;             { PP_signed_char        = PPShortint;  }  //    signed       char
     T_unsigned_char       = Byte;                 P_unsigned_char       = PByte;                   PP_unsigned_char      = PPByte;         //  unsigned       char
     T_short               = Smallint;             P_short               = PSmallint;             { PP_short              = PPSmallint;  }  //           short
     T_signed_short        = Smallint;             P_signed_short        = PSmallint;             { PP_signed_short       = PPSmallint;  }  //    signed short
     T_unsigned_short      = Word;                 P_unsigned_short      = PWord;                 { PP_unsigned_short     = PPWord;      }  //  unsigned short
     T_short_int           = Smallint;             P_short_int           = PSmallint;             { PP_short_int          = PPSmallint;  }  //           short int
     T_signed_short_int    = Smallint;             P_signed_short_int    = PSmallint;             { PP_signed_short_int   = PPSmallint;  }  //    signed short int
     T_unsigned_short_int  = Word;                 P_unsigned_short_int  = PWord;                 { PP_unsigned_short_int = PPWord;      }  //  unsigned short int
     T_long                = Longint;              P_long                = PLongint;              { PP_long               = PPLongint;   }  //            long
     T_signed_long         = Longint;              P_signed_long         = PLongint;              { PP_signed_long        = PPLongint;   }  //    signed  long
     T_unsigned_long       = LongWord;             P_unsigned_long       = PLongWord;             { PP_unsigned_long      = PPLongWord;  }  //  unsigned  long
     T_long_int            = Longint;              P_long_int            = PLongint;              { PP_long_int           = PPLongint;   }  //            long int
     T_signed_long_int     = Longint;              P_signed_long_int     = PLongint;              { PP_signed_long_int    = PPLongint;   }  //    signed  long int
     T_unsigned_long_int   = LongWord;             P_unsigned_long_int   = PLongWord;             { PP_unsigned_long_int  = PPLongWord;  }  //  unsigned  long int
     T_signed              = Longint;              P_signed              = PLongint;              { PP_signed             = PPLongint;   }  //    signed
     T_unsigned            = LongWord;             P_unsigned            = PLongWord;             { PP_unsigned           = PPLongWord;  }  //  unsigned
     T_int                 = Longint;              P_int                 = PLongint;                PP_int                = PPLongint;      //                 int
     T_signed_int          = Longint;              P_signed_int          = PLongint;              { PP_signed_int         = PPLongint;   }  //    signed       int
     T_unsigned_int        = LongWord;             P_unsigned_int        = PLongWord;             { PP_unsigned_int       = PPLongWord;  }  //  unsigned       int
     T___int64             = Int64;                P___int64             = PInt64;                { PP___int64            = PPInt64;     }  //                 __int64
     T_signed___int64      = Int64;                P_signed___int64      = PInt64;                { PP_signed___int64     = PPInt64;     }  //    signed       __int64
     T_float               = Single;               P_float               = PSingle;               { PP_float              = PPSingle;    }  //                 float
     T_double              = Double;               P_double              = PDouble;               { PP_double             = PPDouble;    }  //                 double
     T_long_double         = Extended;             P_long_double         = PExtended;             { PP_long_double        = PPExtended;  }  //            long double
   { T_void                            }           P_void                = Pointer;                 PP_void               = PPointer;       //                 void

     T_int8_t              = Int8;                 P_int8_t              = PInt8;                   PP_int8_t             = ^P_int8_t;
     T_uint8_t             = UInt8;                P_uint8_t             = PUInt8;                  PP_uint8_t            = ^P_uint8_t;
     T_int16_t             = Int16;                P_int16_t             = PInt16;                  PP_int16_t            = ^P_int16_t;
     T_uint16_t            = UInt16;               P_uint16_t            = PUInt16;                 PP_uint16_t           = ^P_uint16_t;
     T_int32_t             = Int32;                P_int32_t             = PInt32;                  PP_int32_t            = ^P_int32_t;
     T_uint32_t            = UInt32;               P_uint32_t            = PUInt32;                 PP_uint32_t           = ^P_uint32_t;
     T_int64_t             = Int64;                P_int64_t             = PInt64;                  PP_int64_t            = ^P_int64_t;
     T_uint64_t            = UInt64;               P_uint64_t            = PUInt64;                 PP_uint64_t           = ^P_uint64_t;

     T_HANDLE              = THandle;              P_HANDLE              = ^T_HANDLE;
     T_HINSTANCE           = HINST;
     T_HWND                = HWND;

     T_size_t              = NativeUInt;           P_size_t              = ^T_size_t;

     T_wchar_t             = WideChar;             P_wchar_t             = PWideChar;

     T_LPCWSTR             = P_wchar_t;

     T_intptr_t            = IntPtr;               P_intptr_t            = PIntPtr;
     T_uintptr_t           = UIntPtr;              P_uintptr_t           = PUIntPtr;

     T_DWORD               = DWORD;                P_DWORD               = PDWORD;

     T_HMONITOR            = HMONITOR;             P_HMONITOR            = ^T_HMONITOR;

     T_SECURITY_ATTRIBUTES = SECURITY_ATTRIBUTES;  P_SECURITY_ATTRIBUTES = ^T_SECURITY_ATTRIBUTES;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% T_chars

     T_chars = TArray<T_char>;

     H_chars = record helper for T_chars
       function ToString :String;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

      UINT32_MAX = UInt32.MaxValue;
      UINT64_MAX = UInt64.MaxValue;

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% T_chars

function H_chars.ToString :String;
begin
     Result := String( P_char( Self ) );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
