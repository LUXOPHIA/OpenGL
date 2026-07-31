# LUX.C2.Gamma
[English](README.md) | [日本語](ja/README.md)

The gamma function for complex argument, implemented twice from independent derivations — the Lanczos approximation and Ooura's `cdgamma` — so that results can be cross-checked. Each implementation has a `.Diff` twin that evaluates $\Gamma(z)$ and $\Gamma'(z)$ together by dual-number automatic differentiation.

## 1. Overview

All functions are free routines overloaded for `TSingleC` / `TDoubleC` (and `TdSingleC` / `TdDoubleC` in the `.Diff` units).

| Unit | Exports |
|---|---|
| `LUX.C2.Gamma.Lanczos` | `LnGamma7/9/11/15`, `Gamma7/9/11/15` |
| `LUX.C2.Gamma.Lanczos.Diff` | the same, over dual complex numbers |
| `LUX.C2.Gamma.Ooura` | `Gamma` |
| `LUX.C2.Gamma.Ooura.Diff` | `Gamma`, over dual complex numbers |

The digit in a Lanczos name is the number of coefficients $N$; each set pairs with its own auxiliary parameter $g$:

| Functions | $N$ | $g$ | Source of the coefficients |
|---|---|---|---|
| `LnGamma7` / `Gamma7` | 7 | $5$ | Numerical Recipes [2] |
| `LnGamma9` / `Gamma9` | 9 | $7$ | |
| `LnGamma11` / `Gamma11` | 11 | $9$ | |
| `LnGamma15` / `Gamma15` | 15 | $607/128$ | Boost-style, highest accuracy [3] |

## 2. Mathematical Background

### 2.1 Lanczos approximation

For $\operatorname{Re} z \ge \tfrac{1}{2}$ the code evaluates, with $c_k$ the coefficient set and $g$ its parameter [1],

```math
\Gamma(z) \approx \sqrt{2\pi}\; \Big( z + g - \tfrac{1}{2} \Big)^{\,z - 1/2} \, e^{-\left( z + g - 1/2 \right)} \left[ c_0 + \sum_{k=1}^{N-1} \frac{c_k}{z - 1 + k} \right] \qquad \text{(2.1)}
```

`Gamma*` computes this directly through one complex `Exp`; `LnGamma*` computes its logarithm term by term.

### 2.2 Reflection

For $\operatorname{Re} z < \tfrac{1}{2}$ both families switch to the reflection formula

```math
\Gamma(z)\, \Gamma(1 - z) = \frac{\pi}{\sin \pi z} \qquad \text{(2.2)}
```

applied directly for `Gamma*` and in logarithmic form for `LnGamma*`, so the approximation is only ever used in the half-plane where it converges well.

### 2.3 Branch of the logarithm

`LnGamma*` satisfies $\exp( \mathrm{LnGamma}(z) ) = \Gamma(z)$, but it is **not** the continuous principal log-gamma (`lgamma`): because each `Ln` takes its principal branch, the result may differ from the principal value by an integer multiple of $2\pi i$.

### 2.4 Poles

The non-positive integers $z = 0, -1, -2, \dots$ are the poles of $\Gamma$, and there the implementations divide by zero. In the default environment with floating-point exceptions masked (Delphi 12+ / FMX) they return `INF` / `NaN`; if exceptions are unmasked with `SetExceptionMask`, `EZeroDivide` or similar is raised.

### 2.5 Ooura's cdgamma

`LUX.C2.Gamma.Ooura` is a Delphi port of `cdgamma.c` from Takuya Ooura's `gamerf` package [4] (whose licence permits free use, copying and modification). It evaluates one fixed rational-and-exponential approximation — there is no selectable order — and for $\operatorname{Re} z < 0$ folds the reflection formula into the same code path using $e^{\pm \pi \operatorname{Im} z}$ terms. The `.Diff` units are the identical algorithms written over the dual types, so seeding the derivative with the real unit yields $\Gamma'(z)$ alongside $\Gamma(z)$ by the analyticity of every step.

## 3. Architecture

```
・Gamma/
  ┣・LUX.C2.Gamma.Lanczos.pas      ･･･ LnGamma7/9/11/15, Gamma7/9/11/15
  ┣・LUX.C2.Gamma.Lanczos.Diff.pas ･･･ the same over TdSingleC / TdDoubleC
  ┣・LUX.C2.Gamma.Ooura.pas        ･･･ Gamma  ( port of gamerf cdgamma.c )
  ┗・LUX.C2.Gamma.Ooura.Diff.pas   ･･･ Gamma over TdSingleC / TdDoubleC
```

The real-argument counterparts live in `D1/Gamma` (`LUX.D1.Gamma.*`); the complex types come from `LUX.Complex` / `LUX.Complex.Diff`.

## 4. Usage

```pascal
uses LUX.D1.Diff, LUX.Complex, LUX.Complex.Diff,
     LUX.C2.Gamma.Lanczos, LUX.C2.Gamma.Lanczos.Diff;

var
   Z, G :TDoubleC;
   F    :TdDoubleC;
begin
     Z := TDoubleC.Create( 0.5, 14.134725 );
     G := Gamma15( Z );                       // Lanczos, N = 15

     ///// Γ and Γ′ together, at z = 2.5
     F := Gamma15( TdDoubleC.Create( TdDouble.Create( 2.5, 1 ) ) );
     // F.o = Γ(2.5),  F.d = Γ′(2.5)
end;
```

`LUX.C2.Gamma.Ooura` exports plain `Gamma` and can be used with the same complex types for cross-checking against the Lanczos results.

## 5. References

1. C. Lanczos, [*A Precision Approximation of the Gamma Function*](https://doi.org/10.1137/0701008), Journal of the Society for Industrial and Applied Mathematics, Series B: Numerical Analysis, vol. 1, no. 1, pp. 86–96, 1964.
2. W. H. Press, S. A. Teukolsky, W. T. Vetterling and B. P. Flannery, [*Numerical Recipes in C, 2nd Edition*](https://numerical.recipes/), Cambridge University Press, 1992.
3. Boost.Math, [*The Lanczos Approximation*](https://www.boost.org/doc/libs/release/libs/math/doc/html/math_toolkit/lanczos.html), Boost C++ Libraries.
4. T. Ooura, [*Gamma / Error Functions*](https://www.kurims.kyoto-u.ac.jp/~ooura/gamerf.html), Research Institute for Mathematical Sciences, Kyoto University, 1996.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
