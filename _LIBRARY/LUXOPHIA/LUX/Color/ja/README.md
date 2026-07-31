# LUX.Color
[English](../README.md) | [日本語](README.md)

`LUX.Color` は色型を Delphi の値レコードとして定義する。表示に必要な伝達関数を備えた線形浮動小数点の色と、それと暗黙変換で相互変換できる整数ピクセル形式である。`LUX.Color.Half` は GPU テクスチャに一致する配置の `binary16` 版を追加する。

## 1. 概要

すべての色は、コンストラクタ・演算子・暗黙変換を備えた素の `record` であり、スタックに置かれ値としてコピーされる。浮動小数点レコード `TSingleRGB` / `TSingleRGBA` が計算の中心である。線形の放射輝度を保持し、（チャネルごとの乗算を含む）算術演算を備え、`Gamma` と `ToneMap` の各メソッドを公開する。その周囲に記憶形式が並ぶ。

| レコード | チャネル | 用途 |
|---|---|---|
| `TByteRGB` / `TByteRGBA` | `Byte` | 8ビットピクセル。`TAlphaColor` とビット互換 |
| `TWordRGB` / `TWordRGBA` | `Word` | 16ビットピクセル。Skia の `RGBA16161616` に一致する R,G,B(,A) 順 |
| `TUInt32xRGB` / `TUInt32xRGBA` | `UInt32` | 多数の8ビット標本を溢れなく合計する広幅の累算器 |
| `TByteRGBE` | `Byte` ×4 | 共有指数の HDR 符号化 |
| `THalfRGB` / `THalfRGBA` | `THalf` | `binary16`。Skia の `RGBAF16` に一致する R,G,B(,A) 順 |

リトルエンディアン環境では `TByteRGB` はフィールドを B,G,R 順（`TByteRGBA` では A が最上位）で宣言するため、32ビットのビットパターンが FireMonkey の `TAlphaColor` と一致し、双方向に暗黙変換できる。`TSingleRGBA` も同様に `TAlphaColorF` と相互変換する。アルファはストレート（非前乗算）であり、すべてのコンストラクタと変換で既定は不透明である。

## 2. 数学的背景

### 2.1 ディスプレイガンマ

`Gamma` は線形チャネルを指数 $\gamma$（既定 $2.2$）のディスプレイ向けにチャネルごとに符号化する。`TSingleRGBA.Gamma` はアルファに手を付けない。

```math
C' = C^{\,1/\gamma} \qquad \text{(2.1)}
```

### 2.2 トーンマッピング

`ToneMap` は拡張 Reinhard 演算子 [1] をチャネルごとに適用する。$L_w$ は白色点（引数 `W_`、既定 $1$）、すなわち純白に写る輝度である。

```math
C' = \operatorname{clamp}\!\left( \frac{C \left( 1 + C / L_w^{\,2} \right)}{1 + C},\; 0,\; 1 \right) \qquad \text{(2.2)}
```

### 2.3 共有指数符号化

`TByteRGBE` は3つの8ビット仮数 `R`,`G`,`B` と、全チャネルで共有される1つのバイアス付き指数 `E` を、Radiance 画像形式 [2] の流儀で格納する。仮数 $M$ のチャネルの復号は

```math
C = 2^{\,E-128} \, \frac{M}{255} \qquad \text{(2.3)}
```

`TSingleRGB` からの符号化は $E = 128 + \lceil \log_2 \max( R, G, B ) \rceil$ と $M = \mathrm{round}( 2^{-(E-128)} \, 255 \, C )$ を取る。最も明るいチャネルがスケールを決め、ダイナミックレンジは8ビットガンマピクセルの保持できる範囲を大きく超える。

### 2.4 ビット深度の変換

各変換は範囲の両端で正確に対応する。`Byte` → `Word` は $257$ 倍（`$FF` → `$FFFF`）、`Word` → `Byte` は上位バイトを取る。`Byte` → `Single` は $255$ で割り、`Single` → `Byte` / `Word` は $[0,1]$ にクランプしてから丸める。`THalf` チャネルは `Single` を介して `binary16` の精度内でビット正確に変換される [3]。

## 3. アーキテクチャ

### 3.1 型

```
・TByteRGB         ･･･ R,G,B :Byte、記憶順 B,G,R、⇄ TAlphaColor
  ┗・TByteRGBA    ･･･ C :TByteRGB、A :Byte、TAlphaColor とビット互換

・TWordRGB         ･･･ R,G,B :Word、記憶順 R,G,B（ Skia RGBA16161616 ）
  ┗・TWordRGBA    ･･･ C :TWordRGB、A :Word

・TSingleRGB       ･･･ R,G,B :Single、線形。Gamma / ToneMap
  ┗・TSingleRGBA  ･･･ C :TSingleRGB、A :Single、⇄ TAlphaColorF

・TUInt32xRGB      ･･･ R,G,B :UInt32、溢れない累算器
  ┗・TUInt32xRGBA ･･･ C :TUInt32xRGB、A :UInt32

・TByteRGBE        ･･･ C :TByteRGB、E :Byte、共有指数の HDR

・THalfRGB         ･･･ R,G,B :THalf、記憶順 R,G,B（ Skia RGBAF16 ）
  ┗・THalfRGBA    ･･･ C :THalfRGB、A :THalf
```

`…RGBA` の各レコードは対応する `…RGB` をフィールド `C` として内包し、`R`,`G`,`B` をプロパティとして再公開する。したがって色とそのアルファ付き形式とのポインタキャストはレイアウト上安全である。

### 3.2 ファイル構成

```
・Color/
  ┣・LUX.Color.pas      ･･･ 整数・広幅整数・Single の色レコード
  ┗・LUX.Color.Half.pas ･･･ THalfRGB / THalfRGBA（ binary16 記憶 ）
```

`LUX.Color.Half` はスカラ `THalf` のために `LUX.D1.Half` に依存する。

## 4. 使い方

```pascal
uses LUX.Color;

var
   C :TSingleRGB;
   E :TByteRGBE;
   B :TByteRGB;
   A :TAlphaColor;
begin
     C := TSingleRGB.Create( 4.0, 2.0, 1.0 );    // 線形。白を超える値
     E := C;                                     // RGBE はレンジを保つ

     C := C.ToneMap( 1 ).Gamma( 2.2 );           // Reinhard の後に表示ガンマ
     B := C;                                     // クランプして8ビットに丸め
     A := B;                                     // UI 用の TAlphaColor
end;
```

## 5. 参考文献

1. E. Reinhard, M. Stark, P. Shirley and J. Ferwerda, [*Photographic Tone Reproduction for Digital Images*](https://doi.org/10.1145/566570.566575), ACM Transactions on Graphics, vol. 21, no. 3, pp. 267–276, 2002.
2. G. Ward, [*Real Pixels*](https://www.realtimerendering.com/resources/GraphicsGems/), in Graphics Gems II, Academic Press, pp. 80–83, 1991.
3. IEEE, [*IEEE Standard for Floating-Point Arithmetic (IEEE Std 754-2019)*](https://doi.org/10.1109/IEEESTD.2019.8766229), IEEE, 2019.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
