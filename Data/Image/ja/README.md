# LUX.Data.Image
[English](../README.md) | [日本語](README.md)

Delphi / FireMonkey 向けの超高解像度画像ライブラリ。`TLuxImage` は画素をすべて CPU メモリ上のタイル化された縮小ピラミッドとして保持するので、扱える大きさは GPU のテクスチャ制限に縛られず、RAM の許す限り無制限である。付属のビューアは、画像の大きさではなく窓の大きさで決まるコストでリアルタイムに表示する。

## 1. 概要

FireMonkey の `TBitmap` は GPU とデータを共有するため GPU のテクスチャサイズ制限をそのまま受け、実際には 8,192 × 8,192 画素程度が上限となる。`TLuxImage` はそうではない。画素はふつうのヒープ領域に 256 × 256 のタイルに分けて置かれ、画像のどの部分も同時に GPU 上に常駐する必要がない。

### 1.1 特徴

- **GPU のサイズ制限を受けない。** 画素は CPU メモリ上に 256 × 256 のタイルで保持する。
- **4 つの画素形式**。いずれも Skia のネイティブなカラータイプに 1 対 1 で対応する。8bit ・ 16bit の符号無整数、16bit ・ 32bit の浮動小数、すべて RGBA。
- **縮小ピラミッドを内蔵**。全景表示も拡大表示も同じコストで描ける。
- **リアルタイムビューア**。滑らかなホイールズームとドラッグスクロール、GPU によるトーンマッピングとガンマ補正。
- **非同期のファイル入出力**。進捗の通知と完了イベントを備える。
- 依存は RTL ・ FireMonkey ・ Skia のみ。いずれも RAD Studio に標準搭載。

### 1.2 動作要件

- RAD Studio 12 以降（RAD Studio 13 / Delphi 37.0 で開発・確認）
- Windows 64bit
- Skia（RAD Studio 同梱）。`sk4d.dll` を実行ファイルと同じ場所に配置すること

## 2. 技術的背景

### 2.1 タイル保持と縮小ピラミッド

画素は一辺 `LUXIMAGE_TILE`（256）のタイルに分けて、タイルごとに別々のヒープ領域へ保持する。これにより巨大な連続確保を避けられ、バイリニア補間はふつう同一タイル内に収まり、触っていない領域は未確保のままにできる。

各画像は半分ずつの縮小段を持つ。段 0 が原寸で、以降は縦横とも半分（切り上げ）になり 1 × 1 まで続く。

```math
W_{\ell+1} = \max\!\left( 1, \left\lceil \frac{W_\ell}{2} \right\rceil \right), \qquad H_{\ell+1} = \max\!\left( 1, \left\lceil \frac{H_\ell}{2} \right\rceil \right) \qquad \text{(2.1)}
```

$T$ を `LUXIMAGE_TILE` とすると、段 $\ell$ が保持するタイル数は

```math
\mathrm{TilesX}_\ell = \left\lceil \frac{W_\ell}{T} \right\rceil, \qquad \mathrm{TilesY}_\ell = \left\lceil \frac{H_\ell}{T} \right\rceil \qquad \text{(2.2)}
```

であり、右端と下端のタイルは部分的にしか埋まらない。段は `NeedLevel` で必要に応じて構築され、画素を書き換えると段 1 以上は無効化される。

各段は一つ下の段の 4 分の 1 の画素しか持たないので、ピラミッドの費用は基底段に対して有界な割合に収まる。

```math
\sum_{\ell=1}^{\infty} \frac{1}{4^{\ell}} = \frac{1}{3} \qquad \text{(2.3)}
```

したがって完全に構築されたピラミッドは、段 0 のメモリに約 33% を加える。

### 2.2 段の選択

画像 1 画素あたりの画面画素数を表示倍率 $s$ とすると、ビューアが描画に用いる段は

```math
\ell = \min\!\left( \max\!\left( 0, \left\lceil -\log_2 s \right\rceil \right), \; \mathrm{LevelsN} - 1 \right) \qquad \text{(2.4)}
```

であり、その段における実効倍率は

```math
S = s \cdot 2^{\ell} \in [\,1, 2\,) \qquad \text{(2.5)}
```

となる。常に $S \ge 1$ であるから、段の中で縮小が起きることはなく、縮小によるエイリアシングは原理的に発生しない。可視タイル数は画像ではなく窓によって上から抑えられる。

```math
N_{\text{tiles}} \le \left( \left\lceil \frac{W_{\text{view}}}{S \cdot T} \right\rceil + 1 \right) \left( \left\lceil \frac{H_{\text{view}}}{S \cdot T} \right\rceil + 1 \right) \qquad \text{(2.6)}
```

1920 × 1080 の窓なら、画像がどれだけ大きくても最大でおよそ 9 × 6 = 54 枚である。

### 2.3 表示の伝達関数

ビューアはガンマ補正

```math
C' = C^{\,1/\gamma} \qquad \text{(2.7)}
```

を適用し、任意で白色点 $L_w$（`White` プロパティ。既定 1）による拡張 Reinhard のトーンマッピング演算子 [4] を適用する。

```math
C' = \operatorname{clamp}\!\left( \frac{C \left( 1 + C / L_w^{\,2} \right)}{1 + C}, \; 0, \; 1 \right) \qquad \text{(2.8)}
```

いずれも SkSL のランタイムカラーフィルタ、つまり GPU で評価されるので、`Gamma` ・ `ToneMap` ・ `White` の変更はただ同然で、タイルキャッシュも無効化しない。

## 3. アーキテクチャ

### 3.1 モジュールとクラスの構成

```
[ units and what they declare ]

・LUX.Data.Image                      ･･･ RTL only
  ┣・TLuxPixel                       ･･･ ( bpUInt08 … bpSFlo32 )
  ┣・TLuxLevel                       ･･･ ( Width, Height, Tiles* )
  ┣・TLuxImage                       ･･･ ( see the class hierarchy below )
  ┣・LUX.Data.Image.Files            ･･･ [ Skia ]
  ┃  ┣・TLuxImageFiler
  ┃  ┃  ┣・LoadFromPng / SaveToPng ･･･ System.ZLib, streaming
  ┃  ┃  ┗・LoadFromJpg / SaveToJpg ･･･ Skia codec
  ┃  ┣・LuxSkColorType
  ┃  ┗・LuxImageSize
  ┗・LUX.Data.Image.Viewer           ･･･ [ FireMonkey + Skia ]
     ┗・TLuxImageViewer              ･･･ ( TFrame )
        ┣・TTileKey  TTileImg
        ┣・ISkImage cache + apron
        ┣・SkSL colour filter
        ┗・wheel zoom / drag scroll

[ class hierarchy ]

・TLuxImage
  ┣・TLuxImageUInt08                 ･･･ TByteRGBA
  ┣・TLuxImageUInt16                 ･･･ TWordRGBA
  ┣・TLuxImageSFlo16                 ･･･ THalfRGBA
  ┗・TLuxImageSFlo32                 ･･･ TSingleRGBA

[ pixel path ]  tiles → mip pyramid → Skia

・TLuxImage
  ┗・level 0                         ･･･ original pixels, 256 × 256 tiles
     ┗・mip pyramid                  ･･･ level ℓ+1 = half of ℓ ( NeedLevel )
        ┗・level chosen by (2.4)     ･･･ effective scale S ∈ [ 1, 2 )
           ┗・visible tiles of it    ･･･ bounded by (2.6), not by the image
              ┗・ISkImage + apron    ･･･ cached as TTileImg under TTileKey
                 ┗・DrawImageRect    ･･･ SkSL colour filter: tone map + gamma

[ supporting units of the LUX standard library ]

・LUX                                 ･･･ base declarations, TDelegates
  ┣・LUX.Color                       ･･･ TByteRGBA  TWordRGBA  TSingleRGBA
  ┃  ┗・LUX.Color.Half              ･･･ THalfRGB  THalfRGBA
  ┗・LUX.D1.Half                     ･･･ THalf, the half-precision scalar
     ┗・LUX.D1.Half.DIff             ･･･ TdHalf, automatic differentiation
```

`LUX.Data.Image.pas` は FireMonkey も Skia も uses していない。それらへの依存はファイル入出力とビューアのユニットに閉じている。

### 3.2 ファイル構成

```
・Data/Image/
  ┣・LUX.Data.Image.pas        ･･･ TLuxImage と 4 つの具象クラス
  ┣・LUX.Data.Image.Files.pas  ･･･ ファイルの読み書き
  ┗・LUX.Data.Image.Viewer.pas ･･･ TLuxImageViewer（TFrame 継承）
```

## 4. 使い方

### 4.1 プロジェクトの設定

プロジェクトのソースファイルで Skia キャンバスを有効にし、Vulkan バックエンドが自身を登録できるよう `FMX.Skia.Canvas.Vulkan` を uses に入れる。

```pascal
uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  FMX.Skia.Canvas.Vulkan,
  ...

begin
  GlobalUseSkia                    := True;
  GlobalUseSkiaRasterWhenAvailable := False;

  Application.Initialize;
  ...
```

こうするとビューアはウィンドウのサーフェスへ直接描く。中間のラスタ面も、毎フレームの画面全体のテクスチャ転送も発生しない。設定しなくても動作はするが、その場合は中間のラスタへ描いてから転写するので、毎フレーム画面全体ぶんの転送コストがかかる。

### 4.2 読み込みと表示

```pascal
Image  := TLuxImageUInt08.Create;

Viewer        := TLuxImageViewer.Create( Self );
Viewer.Parent := Self;
Viewer.Align  := TAlignLayout.Client;
Viewer.Image  := Image;

Image.OnLoaded.Add( ImageLoaded );

Image.LoadFromFileAsync( 'huge.jpg' );
```

```pascal
procedure TForm1.ImageLoaded( Sender_:TObject );
begin
     Viewer.FitToWindow;
end;
```

## 5. 画素形式

| クラス | 画素レコード | バイト/画素 | Skia のカラータイプ | 表示ガンマの既定値 |
|---|---|---|---|---|
| `TLuxImageUInt08` | `TByteRGBA` | 4 | `BGRA8888` | 1.0 |
| `TLuxImageUInt16` | `TWordRGBA` | 8 | `RGBA16161616` | 1.0 |
| `TLuxImageSFlo16` | `THalfRGBA` | 8 | `RGBAF16` | 2.2 |
| `TLuxImageSFlo32` | `TSingleRGBA` | 16 | `RGBAF32` | 2.2 |

各形式が Skia のネイティブなカラータイプに一致するため、ビューアは画素形式の変換をせずにタイルを GPU へ渡せる。16bit の浮動小数形式は IEEE 754 `binary16` [5] である。

α はストレート（乗算前）で保持する。

整数形式は既に表示用に符号化された値を保持しているとみなす（JPEG は既に sRGB）ので、表示ガンマの既定値は 1.0。浮動小数形式はリニアな値を保持しているとみなすので、既定値は 2.2 で、トーンマッピングも既定で有効になる。

## 6. API

### 6.1 TLuxImage

```pascal
///// 寸法
procedure SetSize( const W_,H_:Integer );
procedure Clear;
property  Width  :Integer;
property  Height :Integer;

///// 形式
class function PixelKind :TLuxPixel;    // bpUInt08 / bpUInt16 / bpSFlo16 / bpSFlo32
class function PixelSize :Integer;      // 1 画素のバイト数
class function IsFloat :Boolean;
class function DefaultGamma :Single;

///// 画素アクセス（書式非依存）
property Colors[ const X_,Y_:Integer ] :TSingleRGBA; default;
procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA );
procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA );

///// 画素アクセス（型付き。各具象クラスが宣言）
property Pixels[ const X_,Y_:Integer ] :TByteRGBA;    // TLuxImageUInt08
property Pixels[ const X_,Y_:Integer ] :TWordRGBA;    // TLuxImageUInt16
property Pixels[ const X_,Y_:Integer ] :THalfRGBA;    // TLuxImageSFlo16
property Pixels[ const X_,Y_:Integer ] :TSingleRGBA;  // TLuxImageSFlo32

///// 生値アクセス（タイル跨ぎを内部で処理する）
procedure GetRaws( const L_,X_,Y_,N_:Integer; const Dst_:Pointer );
procedure SetRaws( const L_,X_,Y_,N_:Integer; const Src_:Pointer );

///// 段とタイル
property LevelsN :Integer;
function LevelWidth ( const L_:Integer ) :Integer;
function LevelHeight( const L_:Integer ) :Integer;
function LevelTilesX( const L_:Integer ) :Integer;
function LevelTilesY( const L_:Integer ) :Integer;
function TileWidth  ( const L_,TX_:Integer ) :Integer;
function TileHeight ( const L_,TY_:Integer ) :Integer;
function TileData( const L_,TX_,TY_:Integer ) :Pointer;  // 未確保なら確保する
function TilePeek( const L_,TX_,TY_:Integer ) :Pointer;  // 未確保なら nil
procedure NeedLevel( const L_:Integer );                 // 段 L_ までを構築する

///// ファイル（同期）
procedure LoadFromFile( const FileName_:String );
procedure SaveToFile( const FileName_:String; const Quality_:Integer = 90 );

///// ファイル（別スレッド）
procedure LoadFromFileAsync( const FileName_:String );
procedure SaveToFileAsync( const FileName_:String; const Quality_:Integer = 90 );
procedure WaitFor;
property  Busy     :Boolean;
property  Progress :Single;      // 0 〜 1

///// 通知
procedure Changed;
property  Version    :Cardinal;  // 変更の度に増える
property  OnChange   :TDelegates;
property  OnProgress :TDelegates;
property  OnLoaded   :TDelegates;
property  OnSaved    :TDelegates;
```

`SetRow` と `SetRaws` は段を無効化するが `OnChange` は発火しない。まとめて書き換えた後に `Changed` を 1 回呼ぶこと。1 画素ずつのプロパティセッタは自分で `Changed` を呼ぶ。

保持しているタイルは余白を持たない。ビューアは描画キャッシュを作る際に、必要な 1 画素ののりしろを自分で集める。

### 6.2 非同期のファイル入出力

`LoadFromFileAsync` と `SaveToFileAsync` は、同じ入出力処理を `TTask` で実行し、通知はすべて `TThread.Queue` でメインスレッドへ戻す。したがってハンドラから直接 UI を触ってよい。

`Busy` はワーカの開始前に立ち、`OnLoaded` / `OnSaved` の直前に降りる。ビューアは `Busy` の間まったく描画しない。これによりワーカはロック無しに画素を書き込める。デストラクタはワーカの終了を待ち、保留中の通知も流し切るので、読み込み中に画像を破棄しても問題ない。

読み込みでは縮小ピラミッドの構築までワーカスレッドで、利用可能なコアを使って行う。最初の再描画時に構築すると、その分だけ UI が止まってしまうためである。

`Progress` はピラミッドの構築も含めた全体を 0 から 1 で表す。行単位で報告するため PNG は滑らかに進むが、JPEG は Skia の復号がコールバックを持たない単一の呼び出しであるため、復号が終わるまで進まない。

### 6.3 対応ファイル形式

| 形式 | 読み | 書き | 備考 |
|---|---|---|---|
| PNG | ✔ | ✔ | `System.ZLib` の上に直接実装。読みは規格の定める全ての形式に対応。書きは RGBA で、`TLuxImageUInt08` なら 8bit、それ以外は 16bit。 |
| JPEG | ✔ | ✔ | Skia のコーデックを使用。 |

PNG の読み込みは [1] の規格全体を網羅する。その圧縮データ列は DEFLATE [2] である。

| | 対応 |
|---|---|
| ビット深度 | 1 ・ 2 ・ 4 ・ 8 ・ 16 |
| カラータイプ | 0 グレイスケール、2 トゥルーカラー、3 パレット、4 グレイスケール＋α、6 トゥルーカラー＋α |
| 透明度 | `tRNS` の3形態すべて ―― パレットのα、グレイの透明色指定、RGB の透明色指定 |
| インターレース | 無し、および Adam7 |

非インターレースの画像は1行ずつ復号してそのままタイルへ書き込むので、ファイルがどれだけ大きくても画像1枚分の一時領域を確保しない。Adam7 の画像はパス毎に復号して画素を最終位置へ散らす。こちらは遅いが、同じく全画面分のバッファを持たない。

JPEG は Skia [6] を経由する。Skia は画像 1 枚分の連続バッファを要求するため、読み書きの間だけ画像本体とは別に `幅 × 高さ × 4` バイトを必要とする。また JPEG の規格 [3] 上の上限は 65,535 画素。

浮動小数の画像を PNG に保存すると 0〜1 にクランプして 16bit へ、JPEG に保存すると 0〜1 にクランプして 8bit へ量子化する。トーンマッピングは表示側の設定なので保存時には掛けない。

`LUX.Data.Image.Files.pas` は以下も公開する。

```pascal
function LuxSkColorType( const Kind_:TLuxPixel ) :TSkColorType;
function LuxImageSize( const FileName_:String; out Width_,Height_:Integer ) :Boolean;
```

### 6.4 TLuxImageViewer

```pascal
property Image      :TLuxImage;
property Gamma      :Single;       // 表示ガンマ（out = in^(1/Gamma)）
property ToneMap    :Boolean;      // Reinhard のトーンマッピング
property White      :Single;       // トーンマッピングの白色点。既定 1
property Background :TAlphaColor;
property Scale      :Single;       // 画面画素 ／ 画像画素
property Origin     :TPointF;      // 表示領域の左上に対応する画像座標
property MinScale   :Single;       // 既定 1/4096
property MaxScale   :Single;       // 既定 256

procedure FitToWindow;
procedure ZoomAt( const P_:TPointF; const Factor_:Single );
procedure ZoomWheel( const WheelDelta_:Integer );
function  ViewToImage( const P_:TPointF ) :TPointF;
function  ImageToView( const P_:TPointF ) :TPointF;
procedure Redraw;
```

`Image` を代入すると、`Gamma` と `ToneMap` はそのクラスの既定値に戻り、画像は窓に合わせられる。

`Scale` を設定すると画像は中央に置き直される（画像の中心が表示の中心へ来る）。`ZoomAt` は逆に表示上の指定した点を固定するもので、ホイールがカーソル下の画素を動かさないのはこちらを使っているため。

ホイールを手前に回すと拡大する。掛かる倍率は $2^{-\Delta / 480}$ なので、4 ノッチで 2 倍になる。左ドラッグでスクロールする。

### 6.5 1 フレームの描き方

1. 段は (2.4) によって選ばれ、段内では常に 1〜2 倍の拡大になる。段の中で縮小が起きないので、縮小によるエイリアシングは原理的に発生しない。
2. その段の可視タイルを列挙する。枚数の上限は (2.6) で与えられる。
3. 各タイルを `ISkImage` 化し、`TTileKey`（段とタイル番号）を鍵としてキャッシュする。キャッシュする画像は隣のタイルから集めた 1 画素ののりしろを持つので、タイル境界でも補間が本物の隣接画素を読み、継ぎ目が出ない。
4. `DrawImageRect` で並べる。`Scale` ≧ 1 では最近傍で採取するので、等倍を超えて拡大すると画素が四角として見える（それ未満では線形）。トーンマッピングとガンマ補正は SkSL のランタイムカラーフィルタ、つまり GPU で行うので、`Gamma` ・ `ToneMap` ・ `White` の変更はただ同然で、キャッシュも無効化しない。

CPU 側でのリサンプルは一切行わない。1 フレームあたりの CPU 仕事は、新しく現れたタイルののりしろ集約だけで、しかもキャッシュミス時のみ。

## 7. 制限

- ディスクへの退避機構は持たない。RAM に載らない画像は開けない。
- TIFF ・ OpenEXR ・ Radiance HDR は未実装。
- Skia のコーデックが確実に変換できるのは 8bit までなので、JPEG は常に BGRA8888 で受けて、対象クラスがそれより広い場合は後から変換する。JPEG は 8bit の形式なので損失は無い。

## 8. デモ

リポジトリのルートにある `LuxImage.dproj` が `_DATA\Image 16384x16384.jpg` を読み込んで表示し、保存もできる。

```
LuxImage.exe [ 画像ファイル ] [ 画素形式の番号 0..3 ]
```

## 9. 参考文献

1. W3C, [*Portable Network Graphics (PNG) Specification (Third Edition)*](https://www.w3.org/TR/png-3/), W3C Recommendation, 2025.
2. P. Deutsch, [*DEFLATE Compressed Data Format Specification version 1.3*](https://www.rfc-editor.org/rfc/rfc1951), RFC 1951, IETF, 1996.
3. ITU-T, [*Recommendation T.81: Digital compression and coding of continuous-tone still images — Requirements and guidelines*](https://www.itu.int/rec/T-REC-T.81), ITU-T, 1992.
4. E. Reinhard, M. Stark, P. Shirley and J. Ferwerda, [*Photographic Tone Reproduction for Digital Images*](https://doi.org/10.1145/566570.566575), ACM Transactions on Graphics, vol. 21, no. 3, pp. 267–276, 2002.
5. IEEE, [*IEEE Standard for Floating-Point Arithmetic (IEEE Std 754-2019)*](https://doi.org/10.1109/IEEESTD.2019.8766229), IEEE, 2019.
6. [*Skia Graphics Library*](https://skia.org/), Google.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
