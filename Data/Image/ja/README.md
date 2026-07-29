# LUX.Data.Image

Delphi / FireMonkey 向けの超高解像度画像ライブラリ。

English： [../README.md](../README.md)

---

## 概要

FireMonkey の `TBitmap` は GPU とデータを共有するため GPU のテクスチャサイズ制限をそのまま
受け、実際には 8,192 × 8,192 画素程度が上限となる。

`TLuxImage` は画素をすべて CPU メモリに保持するので、扱える大きさは GPU ではなく RAM で
決まる。100,000 × 100,000 画素以上に対応し、付属のビューアは、画像の大きさではなく窓の
大きさで決まるコストでこれをリアルタイムに表示する。

## 特徴

- **GPU のサイズ制限を受けない。** 画素は CPU メモリ上に 256 × 256 のタイルで保持する。
- **4 つの画素形式**。いずれも Skia のネイティブなカラータイプに 1 対 1 で対応する。
  8bit ・ 16bit の符号無整数、16bit ・ 32bit の浮動小数、すべて RGBA。
- **縮小ピラミッドを内蔵**。全景表示も拡大表示も同じコストで描ける。
- **リアルタイムビューア**。滑らかなホイールズームとドラッグスクロール、GPU による
  トーンマッピングとガンマ補正。
- **非同期のファイル入出力**。進捗の通知と完了イベントを備える。
- 依存は RTL ・ FireMonkey ・ Skia のみ。いずれも RAD Studio に標準搭載。

## 動作要件

- RAD Studio 12 以降（RAD Studio 13 / Delphi 37.0 で開発・確認）
- Windows 64bit
- Skia（RAD Studio 同梱）。`sk4d.dll` を実行ファイルと同じ場所に配置すること

---

## ユニット構成

| ユニット | 内容 |
|---|---|
| `LUX.Data.Image.pas` | `TLuxImage` と 4 つの具象クラス |
| `LUX.Data.Image.Files.pas` | ファイルの読み書き |
| `LUX.Data.Image.Viewer.pas` | `TLuxImage` を表示する `TFrame` 継承クラス `TLuxImageViewer` |

併せて LUX 標準ライブラリの以下のユニットを使用する。

| ユニット | 内容 |
|---|---|
| `LUX.pas` | 基本宣言 |
| `LUX.Color.pas` | `TByteRGBA` ・ `TWordRGBA` ・ `TSingleRGBA` など |
| `LUX.Color.Half.pas` | `THalfRGB` ・ `THalfRGBA` |
| `LUX.D1.Half.pas` | 半精度スカラ `THalf` |
| `LUX.D1.Half.DIff.pas` | 半精度の自動微分 `TdHalf` |

`LUX.Data.Image.pas` は FireMonkey も Skia も uses していない。それらへの依存はファイル
入出力とビューアのユニットに閉じている。

---

## 使い方

### プロジェクトの設定

プロジェクトのソースファイルで Skia キャンバスを有効にし、Vulkan バックエンドが自身を
登録できるよう `FMX.Skia.Canvas.Vulkan` を uses に入れる。

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

こうするとビューアはウィンドウのサーフェスへ直接描く。中間のラスタ面も、毎フレームの画面
全体のテクスチャ転送も発生しない。設定しなくても動作はするが、その場合は中間のラスタへ描い
てから転写するので、毎フレーム画面全体ぶんの転送コストがかかる。

### 読み込みと表示

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

---

## 画素形式

| クラス | 画素レコード | バイト/画素 | Skia のカラータイプ | 表示ガンマの既定値 |
|---|---|---|---|---|
| `TLuxImageUInt08` | `TByteRGBA` | 4 | `BGRA8888` | 1.0 |
| `TLuxImageUInt16` | `TWordRGBA` | 8 | `RGBA16161616` | 1.0 |
| `TLuxImageSFlo16` | `THalfRGBA` | 8 | `RGBAF16` | 2.2 |
| `TLuxImageSFlo32` | `TSingleRGBA` | 16 | `RGBAF32` | 2.2 |

各形式が Skia のネイティブなカラータイプに一致するため、ビューアは画素形式の変換をせずに
タイルを GPU へ渡せる。

α はストレート（乗算前）で保持する。

整数形式は既に表示用に符号化された値を保持しているとみなす（JPEG は既に sRGB）ので、表示
ガンマの既定値は 1.0。浮動小数形式はリニアな値を保持しているとみなすので、既定値は 2.2 で、
トーンマッピングも既定で有効になる。

---

## API

### 保持の仕組み

画素は一辺 `LUXIMAGE_TILE`（256）のタイルに分けて、タイルごとに別々のヒープ領域へ保持する。
これにより巨大な連続確保を避けられ、バイリニア補間はふつう同一タイル内に収まり、触っていない
領域は未確保のままにできる。

各画像は半分ずつの縮小段を持つ。段 0 が原寸で、以降は縦横とも半分になり 1 × 1 まで続く。
段は `NeedLevel` で必要に応じて構築され、画素を書き換えると段 1 以上は無効化される。

### TLuxImage

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

`SetRow` と `SetRaws` は段を無効化するが `OnChange` は発火しない。まとめて書き換えた後に
`Changed` を 1 回呼ぶこと。1 画素ずつのプロパティセッタは自分で `Changed` を呼ぶ。

保持しているタイルは余白を持たない。ビューアは描画キャッシュを作る際に、必要な 1 画素の
のりしろを自分で集める。

### 非同期のファイル入出力

`LoadFromFileAsync` と `SaveToFileAsync` は、同じ入出力処理を `TTask` で実行し、通知は
すべて `TThread.Queue` でメインスレッドへ戻す。したがってハンドラから直接 UI を触ってよい。

`Busy` はワーカの開始前に立ち、`OnLoaded` / `OnSaved` の直前に降りる。ビューアは `Busy` の
間まったく描画しない。これによりワーカはロック無しに画素を書き込める。デストラクタはワーカ
の終了を待ち、保留中の通知も流し切るので、読み込み中に画像を破棄しても問題ない。

読み込みでは縮小ピラミッドの構築までワーカスレッドで、利用可能なコアを使って行う。最初の
再描画時に構築すると、その分だけ UI が止まってしまうためである。

`Progress` はピラミッドの構築も含めた全体を 0 から 1 で表す。行単位で報告するため PNG は
滑らかに進むが、JPEG は Skia の復号がコールバックを持たない単一の呼び出しであるため、
復号が終わるまで進まない。

### 対応ファイル形式

| 形式 | 読み | 書き | 備考 |
|---|---|---|---|
| PNG | ✔ | ✔ | `System.ZLib` の上に直接実装。読みは規格の定める全ての形式に対応。書きは RGBA で、`TLuxImageUInt08` なら 8bit、それ以外は 16bit。 |
| JPEG | ✔ | ✔ | Skia のコーデックを使用。 |

PNG の読み込みは規格全体を網羅する。

| | 対応 |
|---|---|
| ビット深度 | 1 ・ 2 ・ 4 ・ 8 ・ 16 |
| カラータイプ | 0 グレイスケール、2 トゥルーカラー、3 パレット、4 グレイスケール＋α、6 トゥルーカラー＋α |
| 透明度 | `tRNS` の3形態すべて ―― パレットのα、グレイの透明色指定、RGB の透明色指定 |
| インターレース | 無し、および Adam7 |

非インターレースの画像は1行ずつ復号してそのままタイルへ書き込むので、ファイルがどれだけ
大きくても画像1枚分の一時領域を確保しない。Adam7 の画像はパス毎に復号して画素を最終位置へ
散らす。こちらは遅いが、同じく全画面分のバッファを持たない。

JPEG は Skia を経由する。Skia は画像 1 枚分の連続バッファを要求するため、読み書きの間だけ
画像本体とは別に `幅 × 高さ × 4` バイトを必要とする。また JPEG の規格上の上限は 65,535 画素。

浮動小数の画像を PNG に保存すると 0〜1 にクランプして 16bit へ、JPEG に保存すると 0〜1 に
クランプして 8bit へ量子化する。トーンマッピングは表示側の設定なので保存時には掛けない。

`LUX.Data.Image.Files.pas` は以下も公開する。

```pascal
function LuxSkColorType( const Kind_:TLuxPixel ) :TSkColorType;
function LuxImageSize( const FileName_:String; out Width_,Height_:Integer ) :Boolean;
```

### TLuxImageViewer

```pascal
property Image      :TLuxImage;
property Gamma      :Single;       // out = in^(1/Gamma)
property ToneMap    :Boolean;      // Reinhard 2002
property White      :Single;       // トーンマッピングの白色点。既定 1
property Background :TAlphaColor;
property Scale      :Single;       // 画面画素 ／ 画像画素
property Origin     :TPointF;      // 表示領域の左上に対応する画像座標
property MinScale   :Single;
property MaxScale   :Single;

procedure FitToWindow;
procedure ZoomAt( const P_:TPointF; const Factor_:Single );
procedure ZoomWheel( const WheelDelta_:Integer );
function  ViewToImage( const P_:TPointF ) :TPointF;
function  ImageToView( const P_:TPointF ) :TPointF;
procedure Redraw;
```

`Image` を代入すると、`Gamma` と `ToneMap` はそのクラスの既定値に戻り、画像は窓に合わせ
られる。

`Scale` を設定すると画像は中央に置き直される（画像の中心が表示の中心へ来る）。`ZoomAt` は
逆に表示上の指定した点を固定するもので、ホイールがカーソル下の画素を動かさないのはこちらを
使っているため。

ホイールを手前に回すと拡大する（4 ノッチで 2 倍）。左ドラッグでスクロールする。

### 1 フレームの描き方

1. 段内では常に 1〜2 倍の拡大になるように段を選ぶ。段の中で縮小が起きないので、縮小に
   よるエイリアシングは原理的に発生しない。
2. その段の可視タイルを列挙する。1920 × 1080 の窓なら、画像がどれだけ大きくても最大で
   およそ 9 × 6 = 54 枚。
3. 各タイルを `ISkImage` 化してキャッシュする。キャッシュする画像は隣のタイルから集めた
   1 画素ののりしろを持つので、タイル境界でも補間が本物の隣接画素を読み、継ぎ目が出ない。
4. `DrawImageRect` で並べる。`Scale` ≧ 1 では最近傍で採取するので、等倍を超えて拡大すると
   画素が四角として見える（それ未満では線形）。トーンマッピングとガンマ補正は SkSL の
   ランタイムカラーフィルタ、つまり GPU で行うので、`Gamma` ・ `ToneMap` ・ `White` の変更は
   ただ同然で、キャッシュも無効化しない。

CPU 側でのリサンプルは一切行わない。1 フレームあたりの CPU 仕事は、新しく現れたタイルの
のりしろ集約だけで、しかもキャッシュミス時のみ。

---

## メモリ

| 画素数 | UInt08 | UInt16 / SFlo16 | SFlo32 |
|---|---|---|---|
| 16,384 × 16,384 | 1 GB | 2 GB | 4 GB |
| 32,768 × 32,768 | 4 GB | 8 GB | 16 GB |
| 100,000 × 100,000 | 40 GB | 80 GB | 160 GB |

縮小ピラミッドを構築すると、これに約 33% が加わる。

---

## 制限

- ディスクへの退避機構は持たない。RAM に載らない画像は開けない。
- TIFF ・ OpenEXR ・ Radiance HDR は未実装。
- Skia のコーデックが確実に変換できるのは 8bit までなので、JPEG は常に BGRA8888 で受けて、
  対象クラスがそれより広い場合は後から変換する。JPEG は 8bit の形式なので損失は無い。

---

## デモ

リポジトリのルートにある `LuxImage.dproj` が `_DATA\Image 16384x16384.jpg` を読み込んで
表示し、保存もできる。

```
LuxImage.exe [ 画像ファイル ] [ 画素形式の番号 0..3 ]
```
