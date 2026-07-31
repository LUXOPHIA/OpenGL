# LUX
[English](README.md) | [日本語](ja/README.md)

LUX is the base library of the LUXOPHIA collection. It supplies value-semantics numeric types — scalars, vectors, matrices, quaternions, complex numbers and colours — each with a forward-mode automatic-differentiation twin, together with generic container, mesh and image data structures. Every unit lives in the single `LUX` namespace and, apart from a few clearly separated presentation units, depends on nothing beyond the Delphi RTL.

## 利用ライブラリ

* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：Used only by the presentation unit `LUX.Complex.FMX.D3` ( `TComplex3D` ).

## 1. Overview

### 1.1 Scope

The library is organised as a flat namespace whose leading segment is always `LUX`. Four concerns dominate it:

| Concern | Representative units | Representative types |
|---|---|---|
| Linear algebra | `LUX.D1` … `LUX.D4`, `LUX.D2x2`, `LUX.D3x3`, `LUX.D4x4`, `LUX.Quaternion` | `TSingle3D`, `TSingleM4`, `TSingleQ` |
| Numerics | `LUX.D*.Diff`, `LUX.D1.Half`, `LUX.Complex`, `LUX.D1.Gamma.*`, `LUX.D1.Legendre` | `TdSingle`, `THalf`, `TSingleC` |
| Colour and curves | `LUX.Color`, `LUX.Color.Half`, `LUX.Curve.*` | `TSingleRGBA`, `THalfRGBA`, `TSingleWector<T>` |
| Data structures | `LUX.Data.List`, `LUX.Data.Tree`, `LUX.Data.Grid.*`, `LUX.Data.Model.*`, `LUX.Data.Image` | `TTreeNode`, `TTriaGrid<T>`, `TLuxImage` |

Numeric types are Delphi `record`s with overloaded operators, constructors, properties and implicit casts, so they are stack-allocated, copied by value and need no lifetime management. Container types are classes, and the collection layers are generic so that a client's own derived classes appear in the cross-reference properties rather than the base types.

Almost every numeric type exists as a `Single` and a `Double` variant declared side by side in the same unit; the tables below name only the `Single` form for brevity.

### 1.2 Naming conventions

Identifiers are systematic, which makes the whole library navigable from its names alone.

| Element | Meaning | Example |
|---|---|---|
| `TInteger…` / `TSingle…` / `TDouble…` | element type of the record | `TSingle2D` |
| `THalf`, `TByte…`, `TWord…`, `TUInt32x…` | narrow or accumulating storage | `TWordRGBA` |
| `Td…` | carries a value and its derivative | `TdSingle3D` |
| `…2D` / `…3D` / `…4D` | vector of that dimension | `TSingle4D` |
| `…M2` / `…M3` / `…M4` | square matrix of that order | `TSingleM3` |
| `…Q` | quaternion | `TDoubleQ` |
| `…C` | complex number | `TSingleC` |
| `…RGB` / `…RGBA` | colour, straight (non-premultiplied) alpha | `TSingleRGBA` |

| Unit suffix | Meaning |
|---|---|
| `.D1` … `.D4` | dimension of the space the unit deals with |
| `.D2x2`, `.D3x3`, `.D4x4` | matrices of that order |
| `.Diff` | derivative-carrying counterpart of the unit it shadows |
| `.core` | untyped core layer that the generic typed layer wraps |
| `.Half` | half-precision counterpart |

Record fields follow the same discipline: `X`, `Y`, `Z`, `W` for coordinates, `_1`, `_2`, `_3` for the same storage addressed ordinally, `_1D` for the whole thing as an array, `o` and `d` for a value and its derivative, `R`, `G`, `B`, `A` for colour channels. Vectors are variant records, so `V.X`, `V._1`, `V._1D[0]` and `V[0]` all denote the same storage.

## 2. Modules

Each domain folder carries its own pair of READMEs ( `README.md` / `ja/README.md` ); the tree below links to them.

* [**LUX.Code**](Code/README.md) ：C99-to-Delphi type aliases ( T_int, P_char, … ) for transcribing C headers
* [**LUX.Color**](Color/README.md) ：colour records — linear RGB(A) with Gamma / Reinhard ToneMap; Byte / Word / RGBE / Half formats
* [**LUX.Complex**](Complex/README.md) ：complex numbers TSingleC / TDoubleC with elementary functions and .Diff twins
  * [**LUX.Complex.FMX.D3**](Complex/FMX/README.md) ：TComplex3D — FireMonkey surface plot of a complex function
  * [**LUX.C2.Gamma**](Complex/Gamma/README.md) ：complex gamma function — Lanczos ( N = 7 / 9 / 11 / 15 ) and Ooura cdgamma
* [**LUX.Curve**](Curve/README.md) ：interpolation bases — Bernstein, Cox–de Boor B-spline, Catmull–Rom, sinc, Lerp
  * [**LUX.Curve.Data.Grid**](Curve/Data/Grid/README.md) ：curves over 1-D control-point grids, with equal arc-length resampling
* [**LUX.D1**](D1/README.md) ：scalar special functions — Gamma, Half and Legendre
  * [**LUX.D1.Gamma**](D1/Gamma/README.md) ：real gamma function by Lanczos and Ooura's gamerf, each with a .Diff twin
  * [**LUX.D1.Half**](D1/Half/README.md) ：IEEE 754 binary16 as the value record THalf, plus its dual twin TdHalf
  * [**LUX.D1.Legendre**](D1/Legendre/README.md) ：orthonormal Legendre polynomials and derivatives via a stable recurrence
* [**LUX.Data**](Data/README.md) ：data structures — generic containers, meshes and images, plus stream helpers
  * [**LUX.Data.Grid**](Data/Grid/README.md) ：regular 1-D point grids and a triangular 2-D grid in barycentric indices
  * [**LUX.Data.Image**](Data/Image/README.md) ：tiled ultra-high-resolution images with mip pyramids and async file I/O
  * [**LUX.Data.List**](Data/List/README.md) ：intrusive doubly linked list with an incremental index, core + typed layers
  * [**LUX.Data.Model**](Data/Model/README.md) ：mesh models — generic point / face / cell containers and corner-table meshes
    * [**LUX.Data.Model.TriFlip**](Data/Model/TriFlip/README.md) ：2-D triangle meshes — welding, vertex rings, edge flips, `*.lxtf`
    * [**LUX.Data.Model.TetraFlip**](Data/Model/TetraFlip/README.md) ：3-D tetrahedral meshes — gluing by rotation codes, `*.lxtc`
  * [**LUX.Data.Tree**](Data/Tree/README.md) ：generic tree over the list — TTreeRoot / TTreeKnot / TTreeLeaf, batching
* [**LUX.Quaternion**](Quaternion/README.md) ：quaternions TSingleQ / TDoubleQ — rotation, matrix casts, exp / ln / pow

## 3. Mathematical Background


Every `.Diff` unit shadows its base unit with a type whose values carry both a quantity and its derivative with respect to a chosen independent variable. `TdSingle` holds the fields `o` (the value) and `d` (the derivative), which is the dual number $a_o + a_d \varepsilon$ with $\varepsilon^2 = 0$. Operators propagate derivatives exactly, with no step size and no truncation error:

```math
(a_o + a_d \varepsilon)\,(b_o + b_d \varepsilon) = a_o b_o + \left( a_o b_d + a_d b_o \right) \varepsilon \qquad \text{(3.1)}
```

```math
\frac{a_o + a_d \varepsilon}{b_o + b_d \varepsilon} = \frac{a_o}{b_o} + \frac{a_d b_o - a_o b_d}{b_o^{\,2}} \, \varepsilon \qquad \text{(3.2)}
```

Implicit casts from `Integer`, `Int64` and `Single` seed `d` with zero, so a literal constant is automatically treated as having a vanishing derivative and ordinary expressions compile unchanged. The same construction is lifted to vectors (`TdSingle2D` … `TdSingle4D`), to matrices (`LUX.D4x4.Diff`), to complex numbers (`TdSingleC`) and to half precision (`TdHalf`).

## 4. Architecture

```
・LUX/
  ┣・LUX.pas             ･･･ TDelegates, proc types, scalar helpers, EPS / Pi
  ┣・LUX.～.pas          ･･･ empty unit template ( section banners only )
  ┣・LUX.D1.pas          ･･･ TSingle, TDouble, Gauss
  ┣・LUX.D1.DIff.pas     ･･･ TdSingle, TdDouble
  ┣・LUX.D2.pas          ･･･ LUX.D2.Diff.pas
  ┣・LUX.D3.pas          ･･･ LUX.D3.Diff.pas
  ┣・LUX.D4.pas          ･･･ LUX.D4.Diff.pas
  ┣・LUX.D2x2.pas        ･･･ LUX.D3x3.pas  LUX.D4x4.pas  LUX.D4x4.Diff.pas
  ┣・Quaternion/         ･･･ LUX.Quaternion.pas
  ┣・D1/
  ┃  ┣・Half/           ･･･ THalf and its derivative twin TdHalf
  ┃  ┣・Gamma/          ･･･ real gamma: Lanczos and Ooura, each with .Diff
  ┃  ┗・Legendre/       ･･･ normalised Legendre functions, with .Diff
  ┣・Complex/
  ┃  ┣・LUX.Complex.pas ･･･ LUX.Complex.Diff.pas
  ┃  ┣・Gamma/          ･･･ complex gamma: Lanczos and Ooura, each with .Diff
  ┃  ┗・FMX/            ･･･ TComplex3D, a FireMonkey 3-D shape
  ┣・Color/              ･･･ LUX.Color.pas  LUX.Color.Half.pas
  ┣・Curve/
  ┃  ┣・LUX.Curve.pas   ･･･ weighted-vector records
  ┃  ┣・LUX.Curve.*.pas ･･･ Bezier, BSpline, CatmullRom, Lanczos, Linear
  ┃  ┗・Data/Grid/      ･･･ control-point grids for curve evaluation
  ┣・Code/               ･･･ LUX.Code.C.pas — C99 type and pointer aliases
  ┣・Data/
  ┃  ┣・LUX.Data.pas    ･･･ UTF-8 line and text-header stream helpers
  ┃  ┣・List/           ･･･ intrusive doubly-linked list, core + typed layer
  ┃  ┣・Tree/           ･･･ tree over the list, with update batching
  ┃  ┣・Grid/           ･･･ regular 1-D grids and a triangular 2-D grid
  ┃  ┣・Model/          ･･･ corner-table meshes: TriFlip 2-D, TetraFlip 3-D
  ┃  ┗・Image/          ･･･ ultra-high-resolution images — see its own README
  ┗・--------/2022/      ･･･ frozen earlier tree, outside the current namespace
```

## 5. Usage

Add the repository root and the sub-folders you need to the project's search path, then `uses` the units directly. Nothing has to be registered or initialised.

```pascal
uses LUX, LUX.D3, LUX.D4x4, LUX.Quaternion, LUX.D1.Diff, LUX.Color;

var
   P, Q :TSingle3D;
   M    :TSingleM4;
   R    :TSingleQ;
   F    :TdSingle;
   C    :TSingleRGB;
   D    :Single;
begin
     ///// vectors  ( value semantics, overloaded operators )
     P := TSingle3D.Create( 1, 2, 3 );
     Q := P.Unitor;                              // normalised copy
     D := DotProduct( P, Q );                    // = P.Size

     ///// homogeneous transforms
     M := TSingleM4.Translate( 0, 0, -5 )
        * TSingleM4.RotateY( P4i );              // P4i = Pi/4, declared in LUX
     P := M.MultPos( P );                        // as a position  ( w = 1 )
     Q := M.MultVec( Q );                        // as a direction ( w = 0 )

     ///// quaternions
     R := TSingleQ.Rotate( TSingle3D.IdentityZ, P3i );
     P := R.Trans( P );                          // v' = q v q⁻¹
     M := R;                                     // implicit cast to TSingleM4

     ///// forward-mode automatic differentiation of f(x) = x³ at x = 2
     F := TdSingle.Create( 2, 1 );               // value 2, seed derivative 1
     F := F * F * F;
     // F.o =  8   ( = 2³ )
     // F.d = 12   ( = 3·2² )

     ///// colour
     C := TSingleRGB.Create( 4.0, 2.0, 1.0 );    // linear, above white
     C := C.ToneMap( 1 ).Gamma( 2.2 );           // Reinhard, then display gamma
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
