# LUX.Data.Grid
[English](../README.md) | [日本語](README.md)

汎用の点グリッド。遅延再構築と変更通知を備えた1次元の点配列、その巡回版、そして点と面を整数の重心座標で列挙する三角形の2次元グリッドからなる。

## 1. 概要

`TPoins<_TPoin_>` は任意の型の点を1次元に並べて保持する。点の読み出しはまず `InitPoins` を呼び、配列が古いと印されている場合に限り記憶域を確保し直して仮想メソッド `MakePoins` を呼ぶ。派生クラスは `MakePoins` を override して点を計算するので、グリッドは最初のアクセス時に遅延して自らを再構築する。すべての変更はデリゲートリスト `OnChange` を発火する。

`TLoopPoins<_TPoin_>` は巡回版であり、添字は `PoinsN` を法として巻き付く。列は輪に閉じ、`CellsN = PoinsN` となる。

`TTriaGrid<_TPoin_>` は二重に分割された三角形グリッドである — 一辺を `CellsN` 個のセルに、各セルを `DivN` 本の小辺に分割する。添字計算を呼び出し側へ晒す代わりに、`ForPoins` / `ParaForPoins` / `ForFaces` で点と面を歩く。

## 2. 数学的背景

### 2.1 1次元グリッド

$P$ 個の点が開いて並ぶ列は、間に $P-1$ 個のセルを持つ。巡回版は両端を同一視するので

```math
\mathrm{CellsN} = \mathrm{PoinsN} - 1 \quad \text{(開)}, \qquad \mathrm{CellsN} = \mathrm{PoinsN} \quad \text{(巡回)} \qquad \text{(2.1)}
```

巡回グリッドは添字 $i$ を記憶域へ

```math
i \;\mapsto\; \left( 10\,N + i \right) \bmod N, \qquad N = \mathrm{PoinsN} \qquad \text{(2.2)}
```

と写す。オフセット $10N$ は、ほどほどに負の添字に対して `mod` の引数を非負に保つ。

### 2.2 三角形グリッド

三角形の一辺は

```math
E = \mathrm{CellsN} \times \mathrm{DivN} \qquad \text{(2.3)}
```

本の小辺（`EdgesN`）に分割される。点は平面

```math
X + Y + Z = E, \qquad X, Y, Z \ge 0 \qquad \text{(2.4)}
```

上の整数重心座標 $(X, Y, Z)$ で番地付けられ、`ForPoins` はこれを行ごとに列挙する（`ParaForPoins` は行を `TParallel.For` で並列化する）。この単体の点と、分割が生む小三角形を数え上げると

```math
\mathrm{AllPoinsN} = \frac{(E+1)(E+2)}{2}, \qquad \mathrm{AllCellsN} = E^{2} \qquad \text{(2.5)}
```

`ForFaces` は $E^2$ 個の面のそれぞれを3つの `TInteger3D` の頂点として渡す。各行は上向きの三角形と、その間に挟まる下向きの三角形を、同じ回転向きで生み出す。

## 3. アーキテクチャ

### 3.1 クラス構成

```
・TPoins<_TPoin_>           ･･･ 1次元の点列。遅延 MakePoins・OnChange デリゲート
  ┗・TLoopPoins<_TPoin_>   ･･･ 巡回版。添字は PoinsN を法として巻き付く

・TTriaGrid<_TPoin_:record> ･･･ 三角形グリッド。ForPoins / ForFaces で歩く
```

### 3.2 ファイル構成

```
・Data/Grid/
  ┣・LUX.Data.Grid.D1.pas      ･･･ TPoins<T>  TLoopPoins<T>
  ┗・LUX.Data.Grid.Tria.D2.pas ･･･ TTriaGrid<T>
```

両ユニットの依存は `LUX`（および `TInteger3D` のための `LUX.D3`）のみで、RTL の外には何も使わない。

## 4. 使い方

```pascal
uses LUX, LUX.D3, LUX.Data.Grid.Tria.D2;

var
   G :TTriaGrid<TSingle3D>;
begin
     G := TTriaGrid<TSingle3D>.Create;
     try
        G.CellsN := 2;
        G.DivN   := 3;   // 一辺あたり E = 6 本の小辺

        G.ForPoins( procedure( const X_,Y_,Z_:Integer )
        begin
             // X_ + Y_ + Z_ = 6 ：整数の重心座標
        end );

        G.ForFaces( procedure( const P0_,P1_,P2_:TInteger3D )
        begin
             // 面ごとに1回、計 36（= 6²）回呼ばれる
        end );
     finally
        G.Free;
     end;
end;
```

1次元グリッドを埋めるには、`TPoins<T>`（または `TLoopPoins<T>`）から派生して `MakePoins` を override する。override は無効化1回につき高々1回、最初の読み出し時に走る。

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
