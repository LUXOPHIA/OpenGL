# LUX.D1.Half
[English](README.md) | [日本語](ja/README.md)

`LUX.D1.Half` implements the IEEE 754 `binary16` half-precision floating-point number as the value record `THalf`, stored in a bare `UInt16`, together with bit-exact conversions to and from `Single` and a full set of operators and elementary functions. `LUX.D1.Half.Diff` adds the dual-number twin `TdHalf`, which carries a value and its first derivative, both in half precision.

## 1. Overview

`THalf` is a Delphi `record` with overloaded operators, so it is stack-allocated and copied by value like any other LUX numeric type. No half-precision machine instruction is assumed: every operation widens to `Single`, computes there, and rounds the result back to `binary16` on store. Implicit casts convert `Integer`, `Int64`, `Single` and `Double` to `THalf`; the reverse cast is provided to `Single` only, because offering several widening casts would make call resolution ambiguous.

Because a mixed expression first demotes its other operand to `THalf`, an extremely small coefficient can vanish in the rounding; code that needs the wider dynamic range should widen to `Single` explicitly.

## 2. Mathematical Background

### 2.1 Bit layout

A `THalf` occupies 16 bits — sign $s$ (1 bit), biased exponent $e$ (5 bits) and mantissa $m$ (10 bits):

```
| 15 | 14 … 10 | 9 … 0 |
| s  |    e    |   m   |
```

Normal numbers ($1 \le e \le 30$) encode

```math
x = (-1)^{s} \, 2^{\,e-15} \left( 1 + \frac{m}{2^{10}} \right) \qquad \text{(2.1)}
```

and subnormals ($e = 0$, $m \ne 0$) encode

```math
x = (-1)^{s} \, 2^{-14} \, \frac{m}{2^{10}} \qquad \text{(2.2)}
```

$e = 31$ is reserved: $m = 0$ is $\pm\infty$ and $m \ne 0$ is NaN. The canonical quiet NaN produced by the unit (`THalf.NaN`, and by `SingleToHalf` for any incoming NaN) is the bit pattern `$7E00`.

### 2.2 Range constants

The resulting bounds are exported as constants:

| constant | value | meaning |
|---|---|---|
| `HALF_EPS` | $2^{-10} = 9.765625 \times 10^{-4}$ | gap between $1$ and the next value |
| `HALF_MIN` | $2^{-14} \approx 6.104 \times 10^{-5}$ | smallest normal number |
| `HALF_SUB` | $2^{-24} \approx 5.960 \times 10^{-8}$ | smallest subnormal number |
| `HALF_MAX` | $65504 = (2 - 2^{-10}) \, 2^{15}$ | largest finite value |

### 2.3 Conversion and rounding

`HalfToSingle` is lossless, since every `binary16` value is exactly representable in `binary32`; subnormal inputs are renormalised during the exponent widening. `SingleToHalf` rounds to nearest, ties to even; results beyond `HALF_MAX` saturate to $\pm\infty$, inputs below $2^{-25}$ in magnitude flush to $\pm 0$, and NaNs are quieted to `$7E00`. Every arithmetic operator is therefore

```math
a \circ b = \mathrm{rnd}_{16}\!\left( \mathrm{fl}_{32}(a) \circ \mathrm{fl}_{32}(b) \right) \qquad \text{(2.3)}
```

with a rounding step at every store. `Abso` is the one exception: it clears the sign bit directly, without any rounding. Equality and ordering compare the widened values, so $+0 = -0$ and NaN comparisons behave as IEEE 754 prescribes.

### 2.4 Dual numbers

`TdHalf` in `LUX.D1.Half.Diff` carries the fields `o` (value) and `d` (derivative), forming the dual number $o + d\varepsilon$ with $\varepsilon^2 = 0$. Every overloaded function propagates the derivative exactly, with no step size:

```math
f( o + d \varepsilon ) = f(o) + f'(o) \, d \, \varepsilon \qquad \text{(2.4)}
```

Implicit casts from `Integer`, `Int64`, `Single` and `THalf` seed `d` with zero, so literal constants behave as constants under differentiation.

## 3. Architecture

```
[ LUX.D1.Half ]

・THalf                                                 ･･･ binary16 record
  ┣・V :UInt16                                         ･･･ raw bit pattern
  ┣・operators                                         ･･･ via Single, rounded
  ┣・casts                                             ･･･ ⇄ numeric types
  ┗・RandG / RandBS1 / RandBS2 / RandBS4 / NaN         ･･･ class functions

・HalfToSingle / SingleToHalf                           ･･･ raw bit conversions
・Pow2 … Pow5,  Roo2 / Roo3                            ･･･ powers and roots
・Clamp / ClampMin / ClampMax,  Min / Max,  Sign / Abso ･･･ clamping helpers
・Sin / Cos / SinCos / CosSin / Tan,  ArcSin / ArcCos / ArcTan / ArcTan2
・Exp / Ln,  Power / IntPower,  Cosh / Sinh,  Gauss     ･･･ elementary functions

[ LUX.D1.Half.Diff ]

・TdHalf                                                ･･･ THalf dual number
  ┣・o :THalf                                          ･･･ value
  ┗・d :THalf                                          ･･･ derivative
```

The `.Diff` unit overloads the same function set for `TdHalf`, each returning value and derivative together.

```
・Half/
  ┣・LUX.D1.Half.pas      ･･･ THalf, HALF_* constants, conversions, functions
  ┗・LUX.D1.Half.DIff.pas ･･･ TdHalf and its function overloads
```

## 4. Usage

```pascal
uses LUX, LUX.D1.Half, LUX.D1.Half.Diff;

var
   H, K :THalf;
   D    :TdHalf;
   S    :Single;
begin
     H := THalf.Create( 1.5 );    // round a Single to binary16
     K := 0.25;                   // implicit cast
     H := H + 2 * K;              // computed in Single, stored as binary16
     S := H;                      // widening back to Single is lossless

     ///// derivative of f(x) = x·sin(x) at x = 0.5
     D := TdHalf.Create( THalf.Create( 0.5 ), THalf.Create( 1 ) );
     D := D * Sin( D );
     // D.o ≈ 0.2397   ( = 0.5·sin 0.5 )
     // D.d ≈ 0.9182   ( = sin 0.5 + 0.5·cos 0.5 )
end;
```

## 5. References

1. IEEE, [*IEEE Standard for Floating-Point Arithmetic (IEEE Std 754-2019)*](https://doi.org/10.1109/IEEESTD.2019.8766229), IEEE, 2019.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
