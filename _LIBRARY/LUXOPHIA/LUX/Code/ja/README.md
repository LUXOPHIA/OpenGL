# LUX.Code.C
[English](../README.md) | [日本語](README.md)

C の宣言をほぼ字義通りに Delphi へ書き写せるようにする型別名。すべての C の型名が一定の命名規則で Delphi の別名になるので、ヘッダの翻訳を原文と目で突き合わせて検証できる。

## 1. 概要

単一のユニット `LUX.Code.C` は実質的なコードを宣言せず、名前だけを宣言する。各 C 型は3つの別名 — 型そのものの `T_`、そのポインタの `P_`、ポインタのポインタの `PP_` — に対応し、複数語の C 型は下線で連結される（`unsigned long int` → `T_unsigned_long_int`）。`PP_` の別名は必要になったものだけが宣言され、残りはソース中にコメントとして待機している。若干の Windows ハンドル・API 型（`T_HANDLE`・`T_HWND`・`T_DWORD`・`T_SECURITY_ATTRIBUTES` など）、定数 `UINT32_MAX` / `UINT64_MAX`、文字配列ヘルパ `T_chars` がユニットを完成させる。

## 2. 技術的背景

これらの別名は、`int` と `long` がともに32ビットである Windows のデータモデルに対する C → Delphi の対応を定める。対応表の中核は次の通り。

| C | 別名 | Delphi 型 |
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

固定幅の `intN_t` 一族は C99 の `<stdint.h>` [1] に従う。`T_chars = TArray<T_char>` は NUL 終端の C 文字列を Delphi の動的配列として運び、そのヘルパ `H_chars.ToString` は `P_char` として読むことで Delphi の `String` へ変換する。

## 3. アーキテクチャ

```
・LUX.Code.C                 ･･･ [ uses System.SysUtils, WinApi.Windows ]
  ┣・T_…  P_…  PP_…      ･･･ 型・ポインタ・ポインタのポインタの別名
  ┣・T_chars                ･･･ TArray<T_char>。H_chars.ToString 付き
  ┗・UINT32_MAX  UINT64_MAX ･･･ 定数
```

```
・Code/
  ┗・LUX.Code.C.pas ･･･ 別名の宣言
```

## 4. 使い方

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
     S := Cs.ToString;    // NUL 終端の T_chars → String
end;
```

## 5. 参考文献

1. ISO/IEC, [*ISO/IEC 9899:1999 — Programming languages — C*](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf), ISO/IEC, 1999.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
