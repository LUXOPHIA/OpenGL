# LUX.Color
[English](README.md) | [日本語](ja/README.md)

`LUX.Color` defines colour types as Delphi value records: linear floating-point colours with the transfer functions a display needs, and integer pixel formats that cast implicitly to and from them. `LUX.Color.Half` adds `binary16` variants laid out to match GPU textures.

## 1. Overview

Every colour is a plain `record` with constructors, operators and implicit casts, so colours are stack-allocated and copied by value. The floating-point records `TSingleRGB` / `TSingleRGBA` are the computational centre: they carry linear radiance, support arithmetic (including channel-wise multiplication), and expose the `Gamma` and `ToneMap` methods. Around them sit the storage formats:

| Record | Channels | Purpose |
|---|---|---|
| `TByteRGB` / `TByteRGBA` | `Byte` | 8-bit pixels, bit-compatible with `TAlphaColor` |
| `TWordRGB` / `TWordRGBA` | `Word` | 16-bit pixels, stored R,G,B(,A) to match Skia `RGBA16161616` |
| `TUInt32xRGB` / `TUInt32xRGBA` | `UInt32` | wide accumulators for summing many 8-bit samples |
| `TByteRGBE` | `Byte` ×4 | shared-exponent HDR encoding |
| `THalfRGB` / `THalfRGBA` | `THalf` | `binary16`, stored R,G,B(,A) to match Skia `RGBAF16` |

On little-endian targets `TByteRGB` declares its fields in B,G,R order (A on top for `TByteRGBA`), so the 32-bit pattern coincides with FireMonkey's `TAlphaColor` and both cast implicitly in either direction. `TSingleRGBA` likewise casts to and from `TAlphaColorF`. Alpha is straight (non-premultiplied) and defaults to opaque in every constructor and cast.

## 2. Mathematical Background

### 2.1 Display gamma

`Gamma` encodes a linear channel for a display of exponent $\gamma$ (default $2.2$), per channel; `TSingleRGBA.Gamma` leaves the alpha untouched:

```math
C' = C^{\,1/\gamma} \qquad \text{(2.1)}
```

### 2.2 Tone mapping

`ToneMap` applies the extended Reinhard operator [1] per channel, where $L_w$ is the white point (parameter `W_`, default $1$) — the luminance that maps to pure white:

```math
C' = \operatorname{clamp}\!\left( \frac{C \left( 1 + C / L_w^{\,2} \right)}{1 + C},\; 0,\; 1 \right) \qquad \text{(2.2)}
```

### 2.3 Shared-exponent encoding

`TByteRGBE` stores three 8-bit mantissas `R`,`G`,`B` and one biased exponent `E` shared by all channels, in the manner of the Radiance picture format [2]. Decoding a channel of mantissa $M$ gives

```math
C = 2^{\,E-128} \, \frac{M}{255} \qquad \text{(2.3)}
```

Encoding from `TSingleRGB` takes $E = 128 + \lceil \log_2 \max( R, G, B ) \rceil$ and $M = \mathrm{round}( 2^{-(E-128)} \, 255 \, C )$, so the brightest channel determines the scale and the dynamic range far exceeds what 8-bit gamma pixels can hold.

### 2.4 Bit-depth conversion

The casts convert exactly at the ends of the range: `Byte` → `Word` multiplies by $257$ (so `$FF` → `$FFFF`), `Word` → `Byte` takes the high byte; `Byte` → `Single` divides by $255$, and `Single` → `Byte` / `Word` rounds after clamping to $[0,1]$. `THalf` channels convert through `Single` bit-exactly within `binary16` precision [3].

## 3. Architecture

### 3.1 Types

```
・TByteRGB         ･･･ R,G,B :Byte, stored B,G,R, ⇄ TAlphaColor
  ┗・TByteRGBA    ･･･ C :TByteRGB, A :Byte, bit-compatible with TAlphaColor

・TWordRGB         ･･･ R,G,B :Word, stored R,G,B ( Skia RGBA16161616 )
  ┗・TWordRGBA    ･･･ C :TWordRGB, A :Word

・TSingleRGB       ･･･ R,G,B :Single, linear; Gamma / ToneMap
  ┗・TSingleRGBA  ･･･ C :TSingleRGB, A :Single, ⇄ TAlphaColorF

・TUInt32xRGB      ･･･ R,G,B :UInt32, overflow-free accumulator
  ┗・TUInt32xRGBA ･･･ C :TUInt32xRGB, A :UInt32

・TByteRGBE        ･･･ C :TByteRGB, E :Byte, shared-exponent HDR

・THalfRGB         ･･･ R,G,B :THalf, stored R,G,B ( Skia RGBAF16 )
  ┗・THalfRGBA    ･･･ C :THalfRGB, A :THalf
```

The `…RGBA` records nest the corresponding `…RGB` as their field `C` and re-expose `R`,`G`,`B` as properties, so pointer casts between a colour and its alpha-carrying form are layout-safe.

### 3.2 Files

```
・Color/
  ┣・LUX.Color.pas      ･･･ integer, wide-integer and Single colour records
  ┗・LUX.Color.Half.pas ･･･ THalfRGB / THalfRGBA  ( binary16 storage )
```

`LUX.Color.Half` depends on `LUX.D1.Half` for the `THalf` scalar.

## 4. Usage

```pascal
uses LUX.Color;

var
   C :TSingleRGB;
   E :TByteRGBE;
   B :TByteRGB;
   A :TAlphaColor;
begin
     C := TSingleRGB.Create( 4.0, 2.0, 1.0 );    // linear, above white
     E := C;                                     // RGBE keeps the range

     C := C.ToneMap( 1 ).Gamma( 2.2 );           // Reinhard, then display gamma
     B := C;                                     // clamped and rounded to 8 bit
     A := B;                                     // TAlphaColor for the UI
end;
```

## 5. References

1. E. Reinhard, M. Stark, P. Shirley and J. Ferwerda, [*Photographic Tone Reproduction for Digital Images*](https://doi.org/10.1145/566570.566575), ACM Transactions on Graphics, vol. 21, no. 3, pp. 267–276, 2002.
2. G. Ward, [*Real Pixels*](https://www.realtimerendering.com/resources/GraphicsGems/), in Graphics Gems II, Academic Press, pp. 80–83, 1991.
3. IEEE, [*IEEE Standard for Floating-Point Arithmetic (IEEE Std 754-2019)*](https://doi.org/10.1109/IEEESTD.2019.8766229), IEEE, 2019.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
