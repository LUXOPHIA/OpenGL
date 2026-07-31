# LUX.Code.C
[English](README.md) | [日本語](ja/README.md)

Type aliases that let C declarations be transcribed into Delphi almost verbatim. Every C type name becomes a Delphi alias under a fixed naming rule, so a header translation can be checked against the original by eye.

## 1. Overview

The single unit `LUX.Code.C` declares no code of substance — only names. Each C type maps to three aliases: `T_` for the type itself, `P_` for a pointer to it and `PP_` for a pointer to that pointer, with the words of a multi-word C type joined by underscores (`unsigned long int` → `T_unsigned_long_int`). `PP_` aliases are declared only where they have been needed; the remainder are present in the source as comments, ready to be enabled. A handful of Windows handle and API types (`T_HANDLE`, `T_HWND`, `T_DWORD`, `T_SECURITY_ATTRIBUTES`, …), the constants `UINT32_MAX` / `UINT64_MAX`, and the character-array helper `T_chars` complete the unit.

## 2. Technical Background

The aliases fix the C-to-Delphi correspondence for the Windows data model, in which `int` and `long` are both 32-bit. The core of the table:

| C | Alias | Delphi type |
|---|---|---|
| `bool` | `T_bool` | `Boolean` |
| `char` | `T_char` | `AnsiChar` |
| `signed char` | `T_signed_char` | `Shortint` |
| `unsigned char` | `T_unsigned_char` | `Byte` |
| `short` | `T_short` | `Smallint` |
| `unsigned short` | `T_unsigned_short` | `Word` |
| `int` | `T_int` | `Longint` |
| `unsigned int` | `T_unsigned_int` | `LongWord` |
| `long` | `T_long` | `Longint` |
| `unsigned long` | `T_unsigned_long` | `LongWord` |
| `__int64` | `T___int64` | `Int64` |
| `float` | `T_float` | `Single` |
| `double` | `T_double` | `Double` |
| `long double` | `T_long_double` | `Extended` |
| `void *` | `P_void` | `Pointer` |
| `int8_t` … `uint64_t` | `T_int8_t` … `T_uint64_t` | `Int8` … `UInt64` |
| `size_t` | `T_size_t` | `NativeUInt` |
| `intptr_t` / `uintptr_t` | `T_intptr_t` / `T_uintptr_t` | `IntPtr` / `UIntPtr` |
| `wchar_t` | `T_wchar_t` | `WideChar` |

The fixed-width `intN_t` family follows C99 `<stdint.h>` [1]. `T_chars = TArray<T_char>` carries a NUL-terminated C string as a Delphi dynamic array, and its helper `H_chars.ToString` converts it to a Delphi `String` by reading it as a `P_char`.

## 3. Architecture

```
・LUX.Code.C                 ･･･ [ uses System.SysUtils, WinApi.Windows ]
  ┣・T_…  P_…  PP_…      ･･･ type, pointer and pointer-to-pointer aliases
  ┣・T_chars                ･･･ TArray<T_char>, with H_chars.ToString
  ┗・UINT32_MAX  UINT64_MAX ･･･ constants
```

```
・Code/
  ┗・LUX.Code.C.pas ･･･ the aliases
```

## 4. Usage

```pascal
uses LUX.Code.C;

///// C:  int my_count( const char *name_, size_t size_ );

function my_count( name_:P_char; size_:T_size_t ) :T_int; cdecl;
         external 'my.dll';
```

```pascal
var
   Cs :T_chars;
   S  :String;
begin
     ...
     S := Cs.ToString;    // NUL-terminated T_chars → String
end;
```

## 5. References

1. ISO/IEC, [*ISO/IEC 9899:1999 — Programming languages — C*](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf), ISO/IEC, 1999.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
