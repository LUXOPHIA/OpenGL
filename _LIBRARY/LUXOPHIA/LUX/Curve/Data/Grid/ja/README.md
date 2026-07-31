# LUX.Curve.Data.Grid
[English](../README.md) | [日本語](README.md)

1次元制御点グリッド上の曲線クラス。`TCurve<T>` は `LUX.Data.Grid.D1` の `TPoins<T>` グリッドの上に定義された曲線を評価し、`TPlots<T>` はそれ自身がグリッドであって、曲線を弧長の等間隔で再標本化して埋められる。

## 1. 概要

どちらのクラスも点の型についてジェネリックで、それぞれちょうど1つの抽象メソッドを持つ。`TCurve<T>` は1スパンの評価（`Segment`）を派生クラスに委ね、そこで `LUX.Curve.*` の基底が制御点に適用される。`TPlots<T>` は距離（`Distance`）を派生クラスに委ねる。変更の伝播は自動である。グリッドが `OnChange` を発火すると、それを聴いている曲線が自身の `OnChange` を発火し、さらにそれを聴いているプロットがキャッシュを無効化して、次の読み出しで遅延再構築する。

## 2. 技術的背景

### 2.1 媒介変数

`PoinsN` 点のグリッド上の曲線は `CellsN = PoinsN − 1` 個のスパンを持ち、$X \in [\,0,\ \mathrm{CellsN}\,]$ で媒介変数化される。`Value` は媒介変数をスパン番号と局所媒介変数に分解する。

```math
C(X) = \mathrm{Segment}\!\left( \lfloor X \rfloor,\ X - \lfloor X \rfloor \right) \qquad \text{(2.1)}
```

### 2.2 弧長と弧長等間隔の再標本化

`TPlots` は曲線を $M$ = `EdgesN` 本の弦（既定 1024）で近似する。$t_j = j \cdot \mathrm{CellsN} / M$ として、辺の長さと全弧長は

```math
e_j = \mathrm{Distance}\!\left( C(t_j),\ C(t_{j+1}) \right), \qquad L = \sum_{j=0}^{M-1} e_j \qquad \text{(2.2)}
```

再標本化の点数は要求間隔 `PlotGap` から $P = \mathrm{round}( L / \mathrm{PlotGap} ) + 1$ と定まり、第 $i$ 点は弧長 $s_i = i \cdot L / (P-1)$ の位置に置かれる。実装は辺のリストを順に歩き、$s_i$ を含む辺の内部で累積弦長を線形に逆算する。結果は、元の媒介変数化がどれほど不均一に進んでも、曲線に沿っておよそ `PlotGap` 間隔で並ぶ点のグリッドである。

## 3. アーキテクチャ

```
・LUX.Curve.Data.Grid.D1        ･･･ [ uses LUX.Data.Grid.D1, LUX.Curve ]
  ┗・TCurve<_TPoin_>           ･･･ 制御点グリッド上の曲線
     ┣・Poins :TPoins<_TPoin_> ･･･ 制御点
     ┣・Segment                ･･･ 抽象 — 1スパンの評価
     ┣・Value                  ･･･ (2.1)、曲線全体
     ┗・OnChange :TDelegates

・LUX.Curve.Data.Grid.D1.Plots
  ┗・TPlots<_TPoin_>           ･･･ ( TPoins ) 弧長等間隔の再標本化
     ┣・Curve :TCurve<_TPoin_> ･･･ 再標本化する曲線
     ┣・EdgesN  Edges  ArcLen  ･･･ 弦近似 (2.2)
     ┣・PlotGap                ･･･ 要求する点間隔
     ┗・Distance               ･･･ 抽象 — 距離
```

```
・Curve/Data/Grid/
  ┣・LUX.Curve.Data.Grid.D1.pas       ･･･ TCurve<T>
  ┗・LUX.Curve.Data.Grid.D1.Plots.pas ･･･ TPlots<T>
```

## 4. 使い方

```pascal
uses LUX.D3, LUX.D4, LUX.Curve.CatmullRom,
     LUX.Data.Grid.D1,
     LUX.Curve.Data.Grid.D1,
     LUX.Curve.Data.Grid.D1.Plots;

type
  TMyCurve = class( TCurve<TSingle3D> )
  protected
    function Segment( const I_:Integer; const T_:Double ) :TSingle3D; override;
  end;

  TMyPlots = class( TPlots<TSingle3D> )
  protected
    function Distance( const P0_,P1_:TSingle3D ) :Double; override;
  end;

function TMyCurve.Segment( const I_:Integer; const T_:Double ) :TSingle3D;
var
   W :TSingle4D;
begin
     W := CatmullRom( Single( T_ ) );

     Result := W[1] * Poins[ I_-1 ] + W[2] * Poins[ I_   ]
             + W[3] * Poins[ I_+1 ] + W[4] * Poins[ I_+2 ];
end;

function TMyPlots.Distance( const P0_,P1_:TSingle3D ) :Double;
begin
     Result := ( P1_ - P0_ ).Size;
end;
```

```pascal
     Plots         := TMyPlots.Create;
     Plots.Curve   := Curve;
     Plots.PlotGap := 0.1;

     for I := 0 to Plots.PoinsN-1 do P := Plots[ I ];
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
