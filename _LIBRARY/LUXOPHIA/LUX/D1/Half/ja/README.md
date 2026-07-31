# LUX.D1.Half
[English](../README.md) | [日本語](README.md)

`LUX.D1.Half` は IEEE 754 `binary16` 半精度浮動小数を、素の `UInt16` に格納する値レコード `THalf` として実装し、`Single` との間のビット単位の変換と、演算子および初等関数の一式を提供する。`LUX.D1.Half.Diff` は双対数の対型 `TdHalf` を追加し、値とその一階微分をともに半精度で保持する。

## 1. 概要

`THalf` は演算子をオーバーロードした Delphi の `record` であり、他の LUX 数値型と同じくスタックに置かれ値としてコピーされる。半精度の演算命令は前提としない。すべての演算は `Single` へ拡張して計算し、格納の際に `binary16` へ丸め戻す。暗黙変換は `Integer`・`Int64`・`Single`・`Double` から `THalf` へ用意され、逆向きは `Single` への1つのみである（複数用意すると呼び出しの解決が曖昧になるため）。

混合式は相手のオペランドを先に `THalf` へ落とすので、極端に小さな係数は丸めで消えることがある。広い動的範囲が必要な箇所では、明示的に `Single` へ広げて計算すること。

## 2. 数学的背景

### 2.1 ビット配置

`THalf` は16ビット — 符号 $s$（1ビット）・バイアス付き指数 $e$（5ビット）・仮数 $m$（10ビット）— を占める。

```
| 15 | 14 … 10 | 9 … 0 |
| s  |    e    |   m   |
```

正規化数（$1 \le e \le 30$）は

```math
x = (-1)^{s} \, 2^{\,e-15} \left( 1 + \frac{m}{2^{10}} \right) \qquad \text{(2.1)}
```

を表し、非正規化数（$e = 0$・$m \ne 0$）は

```math
x = (-1)^{s} \, 2^{-14} \, \frac{m}{2^{10}} \qquad \text{(2.2)}
```

を表す。$e = 31$ は予約されており、$m = 0$ が $\pm\infty$、$m \ne 0$ が NaN である。本ユニットが生成する標準の静粛 NaN（`THalf.NaN`、および `SingleToHalf` に NaN が入力された場合）のビットパターンは `$7E00` である。

### 2.2 範囲定数

得られる限界値は定数として公開される。

| 定数 | 値 | 意味 |
|---|---|---|
| `HALF_EPS` | $2^{-10} = 9.765625 \times 10^{-4}$ | $1$ とその次の値との差 |
| `HALF_MIN` | $2^{-14} \approx 6.104 \times 10^{-5}$ | 最小の正規化数 |
| `HALF_SUB` | $2^{-24} \approx 5.960 \times 10^{-8}$ | 最小の非正規化数 |
| `HALF_MAX` | $65504 = (2 - 2^{-10}) \, 2^{15}$ | 最大の有限値 |

### 2.3 変換と丸め

`HalfToSingle` は無損失である。すべての `binary16` の値は `binary32` で正確に表現でき、非正規化数は指数の拡張の際に正規化される。`SingleToHalf` は最近接偶数丸めを行い、`HALF_MAX` を超える結果は $\pm\infty$ へ飽和し、絶対値が $2^{-25}$ 未満の入力は $\pm 0$ へ落ち、NaN は `$7E00` へ静粛化される。したがってすべての算術演算子は

```math
a \circ b = \mathrm{rnd}_{16}\!\left( \mathrm{fl}_{32}(a) \circ \mathrm{fl}_{32}(b) \right) \qquad \text{(2.3)}
```

であり、格納のたびに丸めが入る。唯一の例外は `Abso` で、符号ビットを直接落とすだけであり丸めを伴わない。等値と大小の比較は拡張後の値で行うので、$+0 = -0$ が成り立ち、NaN の比較は IEEE 754 の規定どおりに振る舞う。

### 2.4 双対数

`LUX.D1.Half.Diff` の `TdHalf` はフィールド `o`（値）と `d`（微分係数）を持ち、$\varepsilon^2 = 0$ とする双対数 $o + d\varepsilon$ をなす。オーバーロードされた各関数は刻み幅なしで微分を厳密に伝播する。

```math
f( o + d \varepsilon ) = f(o) + f'(o) \, d \, \varepsilon \qquad \text{(2.4)}
```

`Integer`・`Int64`・`Single`・`THalf` からの暗黙変換は `d` に零を種として与えるので、リテラル定数は微分の下で定数として振る舞う。

## 3. アーキテクチャ

```
[ LUX.D1.Half ]

・THalf                                                 ･･･ binary16 レコード
  ┣・V :UInt16                                         ･･･ 生のビットパターン
  ┣・演算子                                            ･･･ Single 経由・丸め
  ┣・変換                                              ･･･ 数値型と相互変換
  ┗・RandG / RandBS1 / RandBS2 / RandBS4 / NaN         ･･･ クラス関数

・HalfToSingle / SingleToHalf                           ･･･ 生のビット変換
・Pow2 … Pow5,  Roo2 / Roo3                            ･･･ 冪と冪根
・Clamp / ClampMin / ClampMax,  Min / Max,  Sign / Abso ･･･ 範囲制限の補助
・Sin / Cos / SinCos / CosSin / Tan,  ArcSin / ArcCos / ArcTan / ArcTan2
・Exp / Ln,  Power / IntPower,  Cosh / Sinh,  Gauss     ･･･ 初等関数

[ LUX.D1.Half.Diff ]

・TdHalf                                                ･･･ THalf 上の双対数
  ┣・o :THalf                                          ･･･ 値
  ┗・d :THalf                                          ･･･ 微分係数
```

`.Diff` ユニットは同じ関数群を `TdHalf` 用にオーバーロードし、それぞれが値と微分を同時に返す。

```
・Half/
  ┣・LUX.D1.Half.pas      ･･･ THalf・HALF_* 定数・変換・関数群
  ┗・LUX.D1.Half.DIff.pas ･･･ TdHalf とその関数オーバーロード
```

## 4. 使い方

```pascal
uses LUX, LUX.D1.Half, LUX.D1.Half.Diff;

var
   H, K :THalf;
   D    :TdHalf;
   S    :Single;
begin
     H := THalf.Create( 1.5 );    // Single を binary16 へ丸める
     K := 0.25;                   // 暗黙変換
     H := H + 2 * K;              // Single で計算し binary16 で格納
     S := H;                      // Single へ広げる変換は無損失

     ///// f(x) = x·sin(x) の x = 0.5 における微分
     D := TdHalf.Create( THalf.Create( 0.5 ), THalf.Create( 1 ) );
     D := D * Sin( D );
     // D.o ≈ 0.2397   ( = 0.5·sin 0.5 )
     // D.d ≈ 0.9182   ( = sin 0.5 + 0.5·cos 0.5 )
end;
```

## 5. 参考文献

1. IEEE, [*IEEE Standard for Floating-Point Arithmetic (IEEE Std 754-2019)*](https://doi.org/10.1109/IEEESTD.2019.8766229), IEEE, 2019.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
