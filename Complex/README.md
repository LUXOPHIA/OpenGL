# LUX.Complex
[English](README.md) | [日本語](ja/README.md)

`LUX.Complex` provides complex numbers as Delphi value records — `TSingleC` and `TDoubleC` — together with the elementary functions over them, rectangular domain windows on the complex plane, and, in `LUX.Complex.Diff`, dual-number twins that carry a derivative through every operation.

## 1. Overview

A complex number is a `record` of two fields `R` and `I` with overloaded operators, so expressions read as ordinary arithmetic and values live on the stack. The polar view is exposed through properties: `Abs2` (squared modulus), `Abso` (modulus), `Angle` (argument), `Unitor` (direction), `Conj` (conjugate); `Abso`, `Unitor` and `Conj` are also writable, each preserving the complementary quantity. The class property `Imaginary` supplies the unit $i$, and implicit casts lift reals into the complex types.

Beyond the operators the unit exports free functions overloaded per precision: `Pow`, `Roo2` (square root), `Cos`, `Sin`, `Tan`, `Exp`, `Expi`, `Ln`, `ArcCos`, `ArcSin`. `TSingleAreaC` / `TDoubleAreaC` describe an axis-aligned rectangle `Min` … `Max` of the plane — a domain window for plotting or sampling — with writable `Center`, `CenterR/I` and `SizeR/I` accessors that move or resize the window about its centre. `TSingleCFunc` / `TDoubleCFunc` name a function of one complex variable.

`LUX.Complex.Diff` repeats the whole surface with `TdSingleC` / `TdDoubleC`, whose components are the dual scalars `TdSingle` / `TdDouble` of `LUX.D1.Diff`; the `o` and `d` properties view the value and the derivative as plain complex numbers. Random generators (`RandG`, `RandBS1/2/4`) draw each component independently from the corresponding scalar generator: Gaussian, or the sum of one, two or four uniform variates on $[-\tfrac{1}{2},\tfrac{1}{2})$.

## 2. Mathematical Background

### 2.1 Arithmetic

Multiplication and division follow the componentwise forms; division expands the conjugate over the squared modulus, computed once as `Abs2`:

```math
(a + b i)(c + d i) = (ac - bd) + (ad + bc)\, i \qquad \text{(2.1)}
```

```math
\frac{a + b i}{c + d i} = \frac{ac + bd}{c^{2} + d^{2}} + \frac{bc - ad}{c^{2} + d^{2}}\, i \qquad \text{(2.2)}
```

### 2.2 Polar form and principal branches

The argument is computed by `ArcTan2( I, R )`, so `Angle` $\in (-\pi, \pi]$ and every multivalued function below takes its principal branch from it. `Ln` is

```math
\operatorname{Ln} z = \ln |z| + i \arg z \qquad \text{(2.3)}
```

`Pow` and `Roo2` are evaluated in polar form,

```math
z^{n} = |z|^{n} \left( \cos n \arg z + i \sin n \arg z \right), \qquad \sqrt{z} = \sqrt{|z|} \left( \cos \tfrac{\arg z}{2} + i \sin \tfrac{\arg z}{2} \right) \qquad \text{(2.4)}
```

so the branch cut of all three lies along the negative real axis.

### 2.3 Elementary functions

```math
e^{z} = e^{R} ( \cos I + i \sin I ), \qquad e^{i x} = \cos x + i \sin x \qquad \text{(2.5)}
```

`Expi` computes the right-hand form directly from a real argument via `SinCos`. The trigonometric functions split into hyperbolic products, and the inverse functions are evaluated through the logarithm:

```math
\cos z = \cos R \cosh I - i \sin R \sinh I, \qquad \sin z = \sin R \cosh I + i \cos R \sinh I \qquad \text{(2.6)}
```

```math
\arccos z = -i \operatorname{Ln}\!\left( z + i \sqrt{1 - z^{2}} \right), \qquad \arcsin z = -i \operatorname{Ln}\!\left( i z + \sqrt{1 - z^{2}} \right) \qquad \text{(2.7)}
```

`Tan` is the quotient `Sin / Cos`.

### 2.4 Derivative propagation

In `LUX.Complex.Diff` each component is a dual number $a_o + a_d \varepsilon$ with $\varepsilon^{2} = 0$, so every operator and function propagates derivatives exactly, with no step size. Because the functions of section 2.3 are written in terms of the dual arithmetic itself, seeding `d` with the real unit turns any expression $f(z)$ into the pair $\left( f(z),\ f'(z) \right)$ wherever $f$ is analytic.

## 3. Architecture

Sub-namespaces with their own README:

* [**FMX**](FMX/README.md) ：`TComplex3D` — FireMonkey surface plot of a complex function
* [**Gamma**](Gamma/README.md) ：complex gamma function ( Lanczos / Ooura, each with `.Diff` )

### 3.1 Types

```
・TSingleC                      ･･･ R,I :Single; Abs2/Abso/Angle/Unitor/Conj
・TDoubleC                      ･･･ R,I :Double; ⇄ TSingleC
・TSingleCFunc / TDoubleCFunc   ･･･ reference to function, C → C

・TSingleAreaC                  ･･･ Min,Max :TSingleC; Center* / Size*
・TDoubleAreaC                  ･･･ Min,Max :TDoubleC

・TdSingleC                     ･･･ R,I :TdSingle; o / d views
・TdDoubleC                     ･･･ R,I :TdDouble; ⇄ TdSingleC
・TdSingleCFunc / TdDoubleCFunc ･･･ reference to function over duals
・TdSingleAreaC / TdDoubleAreaC ･･･ domain windows over duals
```

### 3.2 Files

```
・Complex/
  ┣・LUX.Complex.pas      ･･･ T*C / T*AreaC + elementary functions
  ┣・LUX.Complex.Diff.pas ･･･ Td* twins carrying derivatives
  ┣・Gamma/               ･･･ complex gamma — see Gamma/README.md
  ┗・FMX/                 ･･･ TComplex3D — see FMX/README.md
```

## 4. Usage

```pascal
uses LUX.D1.Diff, LUX.Complex, LUX.Complex.Diff;

var
   Z, W :TDoubleC;
   A    :TDoubleAreaC;
   F    :TdDoubleC;
begin
     Z := TDoubleC.Create( 1, 2 );                 // 1 + 2i
     W := Exp( Z ) / ( 1 + Z * Z );
     W := Roo2( Z ) + 3 * TDoubleC.Imaginary;      // principal square root
     // W.Abso, W.Angle : polar form

     A := TDoubleAreaC.Create( -2, -2, +2, +2 );   // domain window
     A.SizeR := 3;                                 // resize about the centre

     ///// automatic differentiation of f(z) = z³ at z = 2
     F := TdDoubleC.Create( TdDouble.Create( 2, 1 ) );
     F := F * F * F;
     // F.o = 8 + 0i,  F.d = 12 + 0i  ( = 3 z² )
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
