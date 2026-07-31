# LUX.D1
[English](../README.md) | [日本語](README.md)

このフォルダは、LUX ライブラリの1次元層である `LUX.D1` 名前空間のうち、スカラーの特殊関数分野を束ねる。ユニット `LUX.D1` 自体（`TSingle` / `TDouble`）はリポジトリのルートにあり、ここに置かれているのはその3つの下位分野で、それぞれが独自の README を持つ。

## 1. 概要

以下はいずれも、LUX の他の部分と同じ値レコード流儀で素のスカラーを扱う。`Single` と `Double` のオーバーロードが並んで宣言され、各ユニットには、同じアルゴリズムを双対数（`LUX.D1.Diff` の `TdSingle` / `TdDouble`、または `TdHalf`）の上で繰り返して値と微分を同時に返す `.Diff` の対型がある。

* [**Gamma**](../Gamma/ja/README.md) ：実引数のガンマ関数。Lanczos 近似と大浦氏 gamerf の移植という独立な2実装で、相互に照合できる。
* [**Half**](../Half/ja/README.md) ：IEEE 754 binary16 半精度を値レコード `THalf` として実装。変換・初等関数・双対数の対型 `TdHalf` を備える。
* [**Legendre**](../Legendre/ja/README.md) ：正規直交ルジャンドル多項式とその導関数。安定な余弦級数の漸化式で評価する。

```
・D1/
  ┣・Gamma/    ･･･ RGamma* / RLnGamma* ( Lanczos, Ooura )・各 + .Diff
  ┣・Half/     ･･･ THalf ( binary16 ) + TdHalf
  ┗・Legendre/ ･･･ NLegendre* / dNLegendre*・+ .Diff
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
