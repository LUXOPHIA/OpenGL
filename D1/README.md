# LUX.D1
[English](README.md) | [日本語](ja/README.md)

This folder gathers the scalar special-function fields of the `LUX.D1` namespace — the one-dimensional layer of the LUX library. The unit `LUX.D1` itself (`TSingle` / `TDouble`) lives at the repository root; what sits here are its three sub-fields, each with its own README.

## 1. Overview

Everything below operates on plain scalars in the value-record style of the rest of LUX: `Single` and `Double` overloads declared side by side, and for every unit a `.Diff` twin that repeats the algorithm on dual numbers (`TdSingle` / `TdDouble` from `LUX.D1.Diff`, or `TdHalf`) to return values and derivatives together.

* [**Gamma**](Gamma/README.md) ：the real gamma function by two independent derivations — the Lanczos approximation and a port of Ooura's gamerf — cross-checkable against each other.
* [**Half**](Half/README.md) ：IEEE 754 binary16 half precision as the value record `THalf`, with conversions, elementary functions and the dual-number twin `TdHalf`.
* [**Legendre**](Legendre/README.md) ：orthonormal Legendre polynomials and their derivatives, evaluated by a stable cosine-series recurrence.

```
・D1/
  ┣・Gamma/    ･･･ RGamma* / RLnGamma* ( Lanczos, Ooura ), each + .Diff
  ┣・Half/     ･･･ THalf ( binary16 ) + TdHalf
  ┗・Legendre/ ･･･ NLegendre* / dNLegendre*, + .Diff
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
