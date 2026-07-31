# LUX.Complex.FMX.D3
[English](../README.md) | [日本語](README.md)

FireMonkey 用の単一ユニット。複素関数 $f : \mathbb{C} \to \mathbb{C}$ のグラフを、矩形の定義域上の照明・テクスチャ付き曲面として描く 3D コントロール `TComplex3D` である。

## 1. 概要

`TComplex3D` は `TF3DShaper`（`LUX.FMX.Graphics.D3`）を継承し、必要に応じて再構築される `TMeshData` を保持する。関数は `LUX.Complex.Diff` の双対数型 `TdDoubleCFunc` として与える。これにより曲面の偏微分が正確に得られ、頂点法線は差分近似ではなく `TexToMatrix`（`LUX.D4x4.Diff`）による自動微分から計算される。形状生成は `TParallel.For` で並列化され、定義域は `TDoubleAreaC` の窓を `DivX` × `DivY` に分割し、各セルを2枚の三角形で張る。

## 2. 技術的背景

`Area` 上を動く $z = x + i y$ に対し、頂点は関数値の絶対値の高さに置かれる。

```math
\mathbf{p}(x, y) = \left(\, x,\ |f(z)|,\ y \,\right) \qquad \text{(2.1)}
```

関数値そのものはテクスチャ座標に符号化される。絶対値は `Scale` $= s$ で圧縮され、偏角を保ったまま全平面が単位円板に写り、円板は単位テクスチャ正方形に配置される。

```math
w' = \frac{w}{s + |w|}, \qquad t = \left( \frac{1 + \operatorname{Re} w'}{2},\ \frac{1 + \operatorname{Im} w'}{2} \right), \qquad w = f(z) \qquad \text{(2.2)}
```

したがって `Material` に割り当てたテクスチャは関数値の色地図として働く。すなわちドメインカラーリングであり、円板の中心が $0$、縁が $\infty$ に対応する。

## 3. アーキテクチャ

```
・TComplex3D ( TF3DShaper )          ･･･ f : C → C の曲面グラフ
  ┣・Func :TdDoubleCFunc            ･･･ 描く関数（ 双対数 → 法線 ）
  ┣・Area :TDoubleAreaC             ･･･ 定義域（ 既定 -1-1i … +1+1i ）
  ┣・DivX,DivY :Integer             ･･･ 格子の分割数（ 既定 64 × 64 ）
  ┣・Scale :Double                  ･･･ 絶対値圧縮の s（ 既定 1 ）
  ┗・Material :TLightMaterialSource ･･･ 照明マテリアル。テクスチャ＝色地図
```

いずれかのプロパティを設定すると形状（`DivX` / `DivY` の場合は位相も）が無効化され再描画される。`Func` が `nil` のときメッシュは空になる。

## 4. 使い方

```pascal
uses LUX.Complex, LUX.Complex.Diff, LUX.Complex.FMX.D3,
     LUX.C2.Gamma.Ooura.Diff;

var
   G :TComplex3D;
begin
     G := TComplex3D.Create( Viewport3D1 );
     G.Parent := Viewport3D1;

     G.Func := function( const C_:TdDoubleC ) :TdDoubleC
               begin
                    Result := Gamma( C_ );        // Γ(z)。微分付き
               end;
     G.Area  := TDoubleAreaC.Create( -4, -4, +4, +4 );
     G.Scale := 2;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
