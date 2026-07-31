# LUX.D1.Gamma
[English](README.md) | [日本語](ja/README.md)

`LUX.D1.Gamma.*` evaluates the gamma function and its logarithm for a real argument by two independent derivations — the Lanczos approximation (`LUX.D1.Gamma.Lanczos`) and a Delphi port of Takuya Ooura's `gamerf` package (`LUX.D1.Gamma.Ooura`) — so that results can be cross-checked against each other. Each unit has a `.Diff` counterpart that runs the identical algorithm on dual numbers, returning the value and its derivative together.

## 1. Overview

Every function is overloaded for `Single` and `Double` (and, in the `.Diff` units, for `TdSingle` and `TdDouble` from `LUX.D1.Diff`). Two cautions apply throughout:

* The non-positive integers $0, -1, -2, \dots$ are poles of $\Gamma$, and a division by zero occurs internally there. In the default environment with floating-point exceptions masked (Delphi 12+ / FMX) the functions return INF/NaN; with exceptions unmasked via `SetExceptionMask`, `EZeroDivide` or similar is raised.
* `RLnGamma*` returns NaN on the intervals where $\Gamma(x) < 0$ ($-1 < x < 0$, $-3 < x < -2$, …), since the real logarithm is undefined there. Code that needs $\ln|\Gamma(x)|$ must handle those intervals itself.

## 2. Mathematical Background

### 2.1 The gamma function

```math
\Gamma(x) = \int_0^{\infty} t^{\,x-1} e^{-t} \, dt \qquad \text{(2.1)}
```

satisfies the recurrence $\Gamma(x+1) = x\,\Gamma(x)$ and the reflection formula

```math
\Gamma(x) \, \Gamma(1-x) = \frac{\pi}{\sin \pi x} \qquad \text{(2.2)}
```

Both implementations approximate on the right half-line and use (2.2) — in log form for `RLnGamma*` — to reach $x < \tfrac{1}{2}$ (Lanczos) or $x < 0$ (Ooura).

### 2.2 Lanczos approximation

For $x \ge \tfrac{1}{2}$, with $z = x - 1$ and $B = z + g + \tfrac{1}{2}$, the code evaluates

```math
\Gamma(x) \approx \sqrt{2\pi} \; B^{\,z+1/2} \, e^{-B} \left[ c_0 + \sum_{k=1}^{N-1} \frac{c_k}{z+k} \right] \qquad \text{(2.3)}
```

`RLnGamma*` computes (2.3) directly in logarithmic form; `RGamma*` folds the exponentials into a single `Exp` call rather than exponentiating an intermediate $\ln\Gamma$. The numeral in each function name is the term count $N$ of its coefficient set:

| functions | $N$ | $g$ | origin |
|---|---|---|---|
| `RGamma7` / `RLnGamma7` | 7 | $5$ | Numerical Recipes [2] |
| `RGamma9` / `RLnGamma9` | 9 | $7$ | |
| `RGamma11` / `RLnGamma11` | 11 | $9$ | |
| `RGamma15` / `RLnGamma15` | 15 | $607/128$ | Boost-style, highest accuracy [3] |

All coefficient sets are stored in `Double` and shared by the `Single` overloads.

### 2.3 Ooura's gamerf approximations

`LUX.D1.Gamma.Ooura` ports `dgamma.c` / `dlgamma.c` from the `gamerf` package [4] (Copyright(C) 1996 Takuya OOURA, usable "for any purpose and without fee").

`RGamma` reduces the argument to $w = x - (N+2) \in [-\tfrac{1}{2}, \tfrac{1}{2}]$, evaluates a degree-13 polynomial $Y(w) \approx 1/\Gamma(w+2)$, and restores the argument with the recurrence $\Gamma(x+1) = x\,\Gamma(x)$, applied upward for $N > 0$ and downward otherwise:

```math
\Gamma(x) = \frac{(x-1)(x-2)\cdots(x-N)}{Y(w)}, \qquad w = x - (N+2) \qquad \text{(2.4)}
```

`RLnGamma` is piecewise over $w$ ($w = x$ for $x \ge 0$, $w = 1 - x$ for $x < 0$, finished by reflection):

* $w < \tfrac{1}{2}$ — an 11-term polynomial (two coefficient sets, split at $w = \tfrac{1}{4}$) approximating $1/\Gamma(w)$, whose logarithm is negated; its leading coefficients are visibly $1$ and the Euler–Mascheroni constant $\gamma = 0.5772\dots$, matching the Maclaurin series of $w/\Gamma(1+w)$.
* $\tfrac{1}{2} \le w < 3.5$ — seven degree-13 polynomial pieces, indexed through the auxiliary variable $t = w - 4.5/(w + 0.5)$.
* $3.5 \le w < 8$ — five degree-12 polynomial pieces on unit subintervals.
* $w \ge 8$ — an asymptotic series of Stirling type,

```math
\ln \Gamma(w) \approx \left( w - \tfrac{1}{2} \right) \ln w - w + \tfrac{1}{2} \ln 2\pi + \frac{d_1}{w} + \frac{d_2}{w^{3}} + \cdots + \frac{d_6}{w^{11}} \qquad \text{(2.5)}
```

whose coefficients sit close to the Bernoulli values of Stirling's series ($d_1 \approx \tfrac{1}{12}$, $d_2 \approx -\tfrac{1}{360}$, …) but are numerically adjusted.

### 2.4 Automatic differentiation

The `.Diff` units repeat the same algorithms on the dual numbers `TdSingle` / `TdDouble`, whose operators propagate

```math
f( o + d \varepsilon ) = f(o) + f'(o) \, d \, \varepsilon \qquad \text{(2.6)}
```

so seeding the input with $d = 1$ returns $\Gamma'(x)$ — and, through `RLnGamma*`, the digamma function $\psi(x) = \Gamma'(x)/\Gamma(x)$ — alongside the value, with no finite differencing. Branch decisions (the argument reduction indices) are taken on the value part `o` alone.

## 3. Architecture

```
[ LUX.D1.Gamma.Lanczos ( + .Diff ) ]

・RLnGamma7 / RLnGamma9 / RLnGamma11 / RLnGamma15 ･･･ ln Γ(x), N-term sets
・RGamma7 / RGamma9 / RGamma11 / RGamma15         ･･･ Γ(x)

[ LUX.D1.Gamma.Ooura ( + .Diff ) ]

・RGamma                                          ･･･ Γ(x), 1/Γ poly (2.4)
・RLnGamma                                        ･･･ ln Γ(x), piecewise (2.5)
```

Each name is overloaded for `Single` and `Double`; the `.Diff` units overload the same names for `TdSingle` and `TdDouble`. The complex-argument counterparts live in `LUX.C2.Gamma.*` under the `Complex` folder.

```
・Gamma/
  ┣・LUX.D1.Gamma.Lanczos.pas      ･･･ Lanczos, 4 coefficient sets
  ┣・LUX.D1.Gamma.Lanczos.Diff.pas ･･･ dual-number version
  ┣・LUX.D1.Gamma.Ooura.pas        ･･･ port of gamerf ( dgamma.c / dlgamma.c )
  ┗・LUX.D1.Gamma.Ooura.Diff.pas   ･･･ dual-number version
```

## 4. Usage

```pascal
uses LUX.D1.Diff,
     LUX.D1.Gamma.Lanczos,
     LUX.D1.Gamma.Ooura,
     LUX.D1.Gamma.Lanczos.Diff;

var
   X, G1, G2 :Double;
   D         :TdDouble;
begin
     X := 4.5;

     G1 := RGamma15( X );                    // Lanczos:  Γ(4.5) = 11.6317…
     G2 := LUX.D1.Gamma.Ooura.RGamma( X );   // independent cross-check

     ///// value and derivative together
     D := RLnGamma15( TdDouble.Create( 4.5, 1 ) );
     // D.o = ln Γ(4.5) = 2.4537…
     // D.d = ψ(4.5)    = 1.3888…      ( digamma )
end;
```

## 5. References

1. C. Lanczos, [*A Precision Approximation of the Gamma Function*](https://doi.org/10.1137/0701008), Journal of the Society for Industrial and Applied Mathematics, Series B: Numerical Analysis, vol. 1, no. 1, pp. 86–96, 1964.
2. W. H. Press, S. A. Teukolsky, W. T. Vetterling and B. P. Flannery, [*Numerical Recipes: The Art of Scientific Computing*](https://numerical.recipes/), 3rd ed., Cambridge University Press, 2007.
3. Boost C++ Libraries, [*The Lanczos Approximation — Boost Math Toolkit*](https://www.boost.org/doc/libs/release/libs/math/doc/html/math_toolkit/lanczos.html).
4. T. Ooura, [*Gamma / Error Functions*](https://www.kurims.kyoto-u.ac.jp/~ooura/gamerf.html), Research Institute for Mathematical Sciences, Kyoto University, 1996.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
