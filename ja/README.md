# LUX.GPU.OpenGL
[English](../README.md) | [日本語](README.md)

Windows 上での [OpenGL](https://registry.khronos.org/OpenGL/index_gl.php) 4.3 コアプロファイルによる描画と GPU 計算のための **Delphi** ライブラリ。WGL コンテキスト・GLSL プログラム・バッファ・テクスチャ・フレームバッファをオブジェクトとして包み、カメラ・形状・マテリアルのシーングラフを載せ、さらに `TGLViewer` フレームによって OpenGL の描画領域を FMX / VCL のフォーム上に他の GUI パーツと同様に配置できます。

----

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：数学型 `TSingle3D` / `TSingleM4`・ツリー／リストコンテナ・色・FMX 用フォームヘルパーを提供する基盤ライブラリ。

## 1. 概要

本ライブラリは 4 層で構成されます。

| 層 | フォルダ / ユニット | 内容 |
|:--|:--|:--|
| コンテキスト | `LUX.GPU.OpenGL.pas` | `IOpenGL` / `TOpenGL` — ピクセル形式・デバイスコンテキスト・レンダリングコンテキスト（WGL） |
| Atom | `Atom/` | 個々の GL オブジェクトの薄いラッパー：シェーダー・プログラム・バッファ・テクスチャ・イメージ・フレームバッファ |
| シーン | `LUX.GPU.OpenGL.{Scener,Camera,Shaper,Matery,Inform}.pas` | シーンツリー・カメラ・形状・マテリアル・境界ボックス表示 |
| フレームワーク | `_FMX/`, `_VCL/` | `TGLViewer` フレーム・ホストウィンドウ・オフスクリーンレンダラー |

プラットフォーム/フレームワークに依存するのはフレームワーク層のみで、他は FMX と VCL で共通です。コンピュートシェーダーは `LUX.GPU.OpenGL.Comput.pas`（`TGLComput`）としてシーングラフとは独立に利用できます。

| フレームワーク | ユニット | デモ |
|:--|:--|:--|
| [FMX](https://www.wikiwand.com/en/FireMonkey) | `_FMX/LUX.GPU.OpenGL.{Window,Viewer,Render}.pas` | [LUXOPHIA/OpenGL](https://github.com/LUXOPHIA/OpenGL) [6] |
| VCL | `_VCL/LUX.GPU.OpenGL.{Window,Viewer,Render}.pas` | [LUXOPHIA/OpenGL_VCL](https://github.com/LUXOPHIA/OpenGL_VCL) [7] |

## 2. 技術的背景

### 2.1 コンテキストの生成（WGL）

Windows では OpenGL のレンダリングコンテキスト（`HGLRC`）は、あらかじめピクセル形式を決めたデバイスコンテキスト（`HDC`）に結び付けられます [3]。`TOpenGL` はコンストラクタでその手順を実行します。すなわち、隠しウィンドウを作り、その `HDC` を取得し、`ChoosePixelFormat` / `DescribePixelFormat` で `TPixelFormatDescriptor` を確定し、`SetPixelFormat` で適用し、`wglCreateContext` でコンテキストを生成します。`TOpenGL.DefaultPFD` は `PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER`・`PFD_TYPE_RGBA`・カラー 24 ビット・デプス 32 ビットを要求します。

コンテキストはプロセスにちょうど 1 つです。フレームワーク別の派生クラス `TOepnGL_FMX`（綴りはソースのまま）と `TOpenGL_VCL` は `_FMX/`・`_VCL/LUX.GPU.OpenGL.Window.pas` の `initialization` 節で生成され、グローバル変数 `_OpenGL_ :IOpenGL` に格納され、続いて `InitOpenGLext` により OpenGL 1.1 以降のエントリポイントが利用可能になります。各描画領域は `wglMakeCurrent( 自身の DC, _OpenGL_.RC )` を呼ぶため、すべての描画領域が 1 つのコンテキスト、したがって 1 組の GL オブジェクトを共有します。`InitOpenGL` が初期状態を設定します：`GL_DEPTH_TEST`・`GL_CULL_FACE`・`glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )` を伴う `GL_BLEND`・`GL_PROGRAM_POINT_SIZE`。

### 2.2 座標変換の連鎖

`TGLObject` は親に対する相対姿勢を $R$（`RelaPose`）として保持し、絶対姿勢

```math
M = M_{\text{parent}} R \tag{1}
```

をユニフォームバッファ（`AbsoPose`）にキャッシュします。これは祖先が動いたときに遅延再計算されます。カメラ自身も `TGLObject` なので、その絶対姿勢 $C$ はカメラ→ワールド行列であり、ビュー行列は $C^{-1}$ です。射影行列 $P$（`TGLCamera.Proj`）とビューポートのアスペクト整合行列 $S$ を用いると、モデル空間の頂点のクリップ空間座標は

```math
p_{\text{clip}} = S \, P \, C^{-1} M \, p_{\text{model}} \tag{2}
```

となり、これは頂点/ジオメトリシェーダーへ出力される式そのものです。法線は逆転置行列を用います。

```math
n_{\text{world}} = \bigl( M^{-1} \bigr)^{\!\top} n_{\text{model}} . \tag{3}
```

$S$ は正方のクリップ空間を $w \times h$ ピクセルの非正方ビューポートへレターボックス配置します。

```math
S = \begin{cases}
\operatorname{Scale}( h/w,\; 1,\; 1 ) & h < w \\
\operatorname{Scale}( 1,\; w/h,\; 1 ) & w < h \\
I & \text{その他}
\end{cases} \tag{4}
```

これら 4 つの行列は `std140` のユニフォームブロックとして固定のバインディングポイントで GLSL に渡されます。頂点属性も同様です。

| バインディング | ユニフォームブロック | 書き込む側 |
|:--:|:--|:--|
| 0 | `TViewerScal` | `TGLViewer` / `TGL_Render` — $S$ |
| 1 | `TCameraProj` | `TGLCamera` — $P$ |
| 2 | `TCameraPose` | `TGLCamera` — $C$ |
| 3 | `TShaperPose` | `TGLObject` — $M$ |
| 4… | マテリアル固有（`TMateryCol`・`TAmbient` …） | `TGLMatery` の派生 |

| バインディング | 頂点属性 | 宣言する側 |
|:--:|:--|:--|
| 0 | `_SenderPos`（`vec3`） | `TGLMatery` |
| 1 | `_SenderNor`（`vec3`） | `TGLMateryNor` |
| 2 | `_SenderTex`（`vec2`） | `TGLMateryNorTex` |

いずれのカメラも、近平面 $n = 0.1$・遠平面 $f = 1000$ の非対称視錐台から $P$ を構成します。正規化されたレンズシフト `Offs` を $\mathbf{o}$ と書くと、近平面における半幅は

```math
s_{\text{orth}} = \frac{\texttt{Size}}{2} , \qquad
s_{\text{pers}} = n \tan\!\frac{\texttt{Angl}}{2} \tag{5}
```

であり、視錐台は $\mathbf{c} = s\,\mathbf{o}$ として $[\,c_x - s,\; c_x + s\,] \times [\,c_y - s,\; c_y + s\,]$ となり、`TSingleM4.ProjOrth` または `TSingleM4.ProjPers` に渡されます。既定値は `TGLCameraPers` が `Angl` $= 60°$、`TGLCameraOrth` が `Size` $= 10$ です。

(2) を逆に解くとピッキング用のレイが得られます。`TGLViewer.ShootRay` はピクセル $(x, y)$ を正規化デバイス座標 $\mathbf{s}$ に写し、$s_z = \mp 1$ の 2 点を

```math
\mathbf{p} = C \, P^{-1} S^{-1} \mathbf{s} \tag{6}
```

で逆射影し、近点をレイの始点、差分を方向とします。`PickObject` はその後 `HitRay` でシーンツリーを辿り、各オブジェクトのローカル座標系で境界ボックスとの交差を判定します。

### 2.3 プログラム・シェーダーと名前によるバインド

`TGLShader` とその種別 `TGLShaderV` / `TGLShaderG` / `TGLShaderF` / `TGLShaderC`（頂点・ジオメトリ・フラグメント・コンピュート）は GLSL ソースを `TStrings` として保持します。`Source` への代入で再コンパイルされ、`Status` / `Errors` でコンパイルログを取得できます。`TGLProgra` はアタッチされたシェーダーをプログラムオブジェクトへリンクし、その派生 `TGLEngine` はバインディングポイントと GLSL 名を対応付ける 5 つの*ポーター*を追加します。

| ポーター | 対応付ける対象 | 解決手段 |
|:--|:--|:--|
| `TGLPorterV`（`VerBufs`） | 頂点属性 | `glGetAttribLocation` |
| `TGLPorterU`（`UniBufs`） | ユニフォームブロック | `glGetUniformBlockIndex` |
| `TGLPorterT`（`Texturs`） | サンプラーユニフォーム | `glGetUniformLocation` |
| `TGLPorterS`（`StoBufs`） | シェーダーストレージブロック | `glGetProgramResourceIndex` |
| `TGLPorterF`（`Framers`） | フラグメント出力 | `glBindFragDataLocation` |

マテリアルは自分のポートを一度だけ宣言する（`UniBufs.Add( 4, 'TMateryCol' )`）ため、描画時には対応するバインディングポイントでバッファの `Use` を呼ぶだけで済みます。GLSL のロケーション検索はプログラムのリンク時に一度だけ行われます。

### 2.4 描画とコンピュートのディスパッチ

描画はシーンツリーの深さ優先走査です。`TGLObject.Draw` が `BeginDraw`（$M$ をバインディング 3 に束縛）・`DrawMain`・`EndDraw`（境界ボックス表示を描画し、束縛を解除）を呼び、続いて子へ再帰します。`TGLShaper` は `BeginDraw`/`EndDraw` をオーバーライドしてマテリアルを `Use`/`Unuse` し、`TGLShaperPoin` は `PosBuf`/`NorBuf`/`TexBuf` を属性バインディング 0/1/2 に束縛します。最終的に `DrawMain` が GL の描画命令を発行します — 点形状では `glDrawArrays( GL_POINTS, … )`、インデックス付きの線・面では `EleBuf.Draw`（`glDrawElements`）です。

オフスクリーン出力とアンチエイリアスのため、`TGL_Render` はマルチサンプルフレームバッファ `TGLFramerN` に描画し、`glBlitFramebuffer` で `TGLFramer1` へ解決します。

`TGLComput` はコンピュートシェーダーをディスパッチします。`GrupsX/Y/Z` は `glDispatchCompute` に渡すワークグループ数、`ItemsX/Y/Z` はローカルワークグループサイズであり、起動される呼び出しの総数は

```math
N = \prod_{d} \texttt{Grups}_d \cdot \texttt{Items}_d . \tag{7}
```

`Run` はシェーダー内の `layout( local_size_x = … ) in;` で固定されたサイズを用い、`RunARB` は `glDispatchComputeGroupSizeARB`（`GL_ARB_compute_variable_group_size`）でディスパッチ時にサイズを渡します。`Buffers` / `Imagers` / `Texturs` に名前で与えたストレージバッファやイメージは、初回実行時にエンジンのポーターへ自動登録されます。

## 3. アーキテクチャ

### 3.1 クラス階層

```
・IOpenGL / TOpenGL                               ･･･ WGL コンテキスト・_OpenGL_
  ┣・TOepnGL_FMX                                 ･･･ 隠し FMX フォーム [_FMX]
  ┗・TOpenGL_VCL                                 ･･･ 隠し VCL フォーム [_VCL]

・TGLAtomer                                       ･･･ GL オブジェクトの共通基底
  ┣・TGLVarray                                   ･･･ 頂点配列オブジェクト
  ┣・TGLShader                                   ･･･ Source / Status / Errors
  ┃  ┗・TGLShaderV, TGLShaderG, TGLShaderF, TGLShaderC
  ┣・TGLProgra                                   ･･･ glCreateProgram / Link
  ┃  ┗・TGLEngine                               ･･･ ＋ バッファ／テクスチャ表
  ┣・TGLBuffer<T,Iter>                           ･･･ glGenBuffers、Map / Unmap
  ┃  ┣・TGLVerBuf<T> — TGLVerBufI, TGLVerBufS  ･･･ 頂点属性
  ┃  ┣・TGLEleBuf<T> — TGLEleBufFace, TGLEleBufLine, TGLEleBufQuadLines
  ┃  ┣・TGLUniBuf<T>                            ･･･ ユニフォームブロック記憶域
  ┃  ┣・TGLStoBuf<T>                            ･･･ シェーダーストレージ
  ┃  ┗・TGLPixBuf<T,Iter>                       ･･･ ピクセルバッファ、1D/2D/3D
  ┃     ┗・TGLPoiPix{1,2,3}D, TGLCelPix{1,2,3}D ･･･ 点/セル標本のグリッド
  ┣・TGLImager<T,Iter,Grid>                      ･･･ イメージ階層＋画素グリッド
  ┃  ┗・TGLImager{1,2,3}D — TGLPoiIma{1,2,3}D, TGLCelIma{1,2,3}D
  ┣・TGLSamplr                                   ･･･ glGenSamplers
  ┣・TGLChaner — TGLChaner1, TGLChanerN         ･･･ FB アタッチメント
  ┗・TGLFramer — TGLFramer1, TGLFramerN         ･･･ FBO ＋ TGLColors の表
・TGLTextur<T,Iter,Grid,Imager>                   ･･･ サンプラーとイメージャの対
  ┗・TGLPoiTex{1,2,3}D, TGLCelTex{1,2,3}D

・TGLObject ( TTreeNode<TGLObject>, IGLObject )   ･･･ シーンノード
  ┣・TGLScener                                   ･･･ ルート（姿勢は単位行列）
  ┣・TGLCamera                                   ･･･ Proj・Offs・Render
  ┃  ┣・TGLCameraOrth                           ･･･ Size
  ┃  ┗・TGLCameraPers                           ･･･ Angl
  ┗・TGLShaper                                   ･･･ 形状。Matery :IGLMatery
     ┣・TGLShaperZeroPoins                       ･･･ PoinsN、頂点バッファなし
     ┃  ┣・TMarcubes, TColorMarcubes            ･･･ マーチングキューブ法 [5]
     ┃  ┗・（TGLShaperZeroLines, TGLShaperZeroTrias）
     ┗・TGLShaperPoin                            ･･･ PosBuf / NorBuf / TexBuf
        ┣・TGLShaperLine                         ･･･ TGLEleBufLine32、LineW
        ┃  ┗・TGLShaperLineCube
        ┣・TGLShaperQuadLine                     ･･･ TGLEleBufQuadLines32
        ┣・TGLShaperFace                         ･･･ EleBuf :TGLEleBufFace32
        ┃  ┣・TGLShaperOctree                   ･･･ Tree :TOctree3D、Collision
        ┃  ┗・TGLText                           ･･･ [_VCL]
        ┣・TGLShaperVoxels                       ･･･ Count・SizeX/Y/Z・Color
        ┗・TGLDotCube, TGLShaperCopy
・TGLInform                                       ･･･ 境界ボックス表示

・IGLMatery / TGLMatery                           ･･･ TGLEngine・シェーダー所有
  ┣・TGLMateryNor                                ･･･ ＋ 法線属性
  ┃  ┗・TGLMateryNorTex                         ･･･ ＋ テクスチャ座標属性
  ┃     ┗・TGLMateryNorTexG                     ･･･ ＋ TGLShaderG
  ┣・TGLMateryG                                  ･･･ ＋ TGLShaderG
  ┗・TGLMatery{Color,RGB,Diffuse,Imag,ImagG,Plastic,Mirror,Glass,BB,Voxels}

・TGLViewer ( TFrame )                            ･･･ 画面表示 [_FMX] [_VCL]
  ┣・FMX: コントロールは HWND を持たないため子 TGLViewerForm（HWND）を内包
  ┗・VCL: フレーム自身の HWND に直接描画
・TGL_Render — TGLRender                         ･･･ オフスクリーン描画
・IGLComput / TGLComput                           ･･･ コンピュートシェーダー実行
```

1 フレームの描画時のデータの流れ:

```
1 フレームの呼び出しツリー（実行順・上から下へ）

・TGLViewer.Paint / TGLRender.Render
  ┣・BeginRender                     ･･･ wglMakeCurrent, glClear
  ┃  ┗・TViewerScal.Use( 0 )        ･･･ S
  ┣・TGLCamera.Render
  ┃  ┣・TCameraProj.Use( 1 )        ･･･ P
  ┃  ┗・TCameraPose.Use( 2 )        ･･･ C
  ┣・TGLScener.Draw
  ┃  ┗・TGLObject.Draw              ･･･ シーンツリーを深さ優先で走査
  ┃     ┣・BeginDraw
  ┃     ┃  ┣・TShaperPose.Use( 3 ) ･･･ M
  ┃     ┃  ┗・Matery.Use
  ┃     ┃     ┗・TGLEngine.Use
  ┃     ┃        ┣・VerBufs        ･･･ glVertexAttribPointer
  ┃     ┃        ┣・UniBufs        ･･･ glBindBufferBase
  ┃     ┃        ┣・Texturs        ･･･ glBindTexture
  ┃     ┃        ┗・StoBufs        ･･･ glBindBufferBase
  ┃     ┣・DrawMain                 ･･･ glDrawArrays / EleBuf.Draw
  ┃     ┗・EndDraw                  ･･･ Inform.Draw、束縛解除
  ┗・EndRender                       ･･･ glFlush, SwapBuffers（または blit）
```

### 3.2 ファイル構成

```
・LUX.GPU.OpenGL/
  ┣・LUX.GPU.OpenGL.pas                   ･･･ IOpenGL / TOpenGL、_OpenGL_
  ┣・LUX.GPU.OpenGL.Scener.pas            ･･･ TGLObject / TGLScener
  ┣・LUX.GPU.OpenGL.Camera.pas            ･･･ TGLCamera{,Orth,Pers}
  ┣・LUX.GPU.OpenGL.Shaper.pas            ･･･ TGLShaper 系、STL / OBJ ローダー
  ┣・LUX.GPU.OpenGL.Matery.pas            ･･･ TGLMatery 系、基底の GLSL ソース
  ┣・LUX.GPU.OpenGL.Inform.pas            ･･･ TGLInform — 境界ボックス表示
  ┣・LUX.GPU.OpenGL.Comput.pas            ･･･ TGLComput・コンピュートシェーダー
  ┣・LUX.GPU.OpenGL.Render_.pas           ･･･ TGL_Render・フレームワーク非依存
  ┣・Atom/                                ･･･ GL オブジェクト 1 つにクラス 1 つ
  ┃  ┣・LUX.GPU.OpenGL.Atom.pas          ･･･ TGLAtomer / TGLVarray
  ┃  ┣・LUX.GPU.OpenGL.Atom.Shader.pas   ･･･ TGLShader{,C,V,G,F}
  ┃  ┣・LUX.GPU.OpenGL.Atom.Progra.pas   ･･･ TGLProgra
  ┃  ┣・LUX.GPU.OpenGL.Atom.Engine.pas   ･･･ TGLEngine
  ┃  ┣・LUX.GPU.OpenGL.Atom.Porter.pas   ･･･ TGLPorter{F,V,U,T,S}
  ┃  ┣・LUX.GPU.OpenGL.Atom.Buffer.pas   ･･･ TGLBuffer / TGLBufferData
  ┃  ┣・Buffer/                          ･･･ バッファ型ごとに 1 ユニット
  ┃  ┣・LUX.GPU.OpenGL.Atom.Imager.pas   ･･･ TGLImager（Imager/ に 1D/2D/3D）
  ┃  ┣・LUX.GPU.OpenGL.Atom.Textur.pas   ･･･ TGLSamplr / TGLTextur（Textur/）
  ┃  ┣・LUX.GPU.OpenGL.Atom.Chaner.pas   ･･･ TGLChaner{,1,N} — アタッチメント
  ┃  ┗・LUX.GPU.OpenGL.Atom.Framer.pas   ･･･ TGLFramer{,1,N} — FBO
  ┣・Matery/                              ･･･ マテリアルのプリセット
  ┃  ┣・LUX.GPU.OpenGL.Matery.Preset.pas ･･･ Color / RGB / Diffuse / …
  ┃  ┗・Textur/_FMX|_VCL/                ･･･ TGLMatery{Imag,ImagG,BB}
  ┣・Shaper/                              ･･･ 形状のプリセット
  ┃  ┣・LUX.GPU.OpenGL.Shaper.Preset.pas ･･･ TGLShaperLineCube / TGLDotCube
  ┃  ┣・LUX.GPU.OpenGL.Shaper.Octree.pas ･･･ TGLShaperOctree — 衝突判定
  ┃  ┣・LUX.GPU.OpenGL.Shaper.Voxels.pas ･･･ TGLShaperVoxels/TGLMateryVoxels
  ┃  ┗・Preset/                          ･･･ TMarcubes ほか ＋ *.glsl
  ┣・_FMX/                                ･･･ FMX 用
  ┃  ┣・LUX.GPU.OpenGL.Window.pas        ･･･ TGLViewerForm / TOepnGL_FMX
  ┃  ┣・LUX.GPU.OpenGL.Viewer.pas|fmx    ･･･ TGLViewer フレーム
  ┃  ┗・LUX.GPU.OpenGL.Render.pas        ･･･ TGLRender
  ┗・_VCL/                                ･･･ VCL 用
     ┣・LUX.GPU.OpenGL.Window.pas         ･･･ TOpenGL_VCL
     ┣・LUX.GPU.OpenGL.Viewer.pas|dfm     ･･･ TGLViewer フレーム
     ┗・LUX.GPU.OpenGL.Render.pas         ･･･ TGLRender
```

## 4. 使い方

本ライブラリのフォルダ — ルート・`Atom/` とその下位フォルダ・`Matery/`・`Shaper/`、および `_FMX/` か `_VCL/` のいずれか一方 — を `LUX` のフォルダとともにプロジェクトの検索パスへ追加します。フレームワーク別のフォルダを両方同時にパスへ入れてはいけません。2 組の `LUX.GPU.OpenGL.Window.pas` / `.Viewer.pas` / `.Render.pas` はユニット名が同一だからです。

### 4.1 フォーム上の描画領域

`TGLViewer` はフレームなので、IDE の *フレームの使用* コマンドでフォームに貼るか、コードで生成します。以下は FMX 版です。VCL では `Align := alClient` とし、`BackColor` は存在しません（クリア色は VCL 側のビューアが設定します）。

```pascal
uses System.Math,
     LUX, LUX.D3, LUX.D4x4,
     LUX.GPU.OpenGL.Scener,
     LUX.GPU.OpenGL.Camera,
     LUX.GPU.OpenGL.Shaper,
     LUX.GPU.OpenGL.Viewer,
     LUX.GPU.OpenGL.Shaper.Preset,
     LUX.GPU.OpenGL.Matery.Preset;

procedure TForm1.FormCreate( Sender:TObject );
begin
     _Viewer := TGLViewer.Create( Self );
     _Viewer.Parent    := Self;
     _Viewer.Align     := TAlignLayout.Client;
     _Viewer.BackColor := TAlphaColorF.Create( 0.1, 0.1, 0.1, 1 );

     ///// シーンツリー: Scener → Camera, Scener → Shaper
     _Scener := TGLScener.Create;

     _Camera       := TGLCameraPers.Create;
     _Camera.Paren := _Scener;
     _Camera.Angl  := DegToRad( 45 );
     _Camera.Pose  := TSingleM4.Translate( 0, 0, 10 );

     _Shaper       := TGLShaperLineCube.Create;
     _Shaper.Paren := _Scener;

     _Viewer.Camera := _Camera;     // 描画領域はこのカメラを通して描く
end;
```

すべてのノードは `TGLObject` なので、`Paren` でツリーを構成し、`Pose`（`= RelaPose`）で親に対する配置を与えます。`AbsoPose` は (1) により導出され、自動的に転送されます。再描画は `_Viewer.Repaint`、`_Viewer.OnPaint` はシーンの後に呼ばれ、重ね描きに使えます。

### 4.2 形状とマテリアル

形状は頂点データとマテリアルを持ちます。

```pascal
var
   S :TGLShaperFace;
   M :TGLMateryDiffuse;
begin
     S := TGLShaperFace.Create;
     S.Paren := _Scener;
     S.LoadFromFileSTL( 'Bunny.stl' );   // または LoadFromFileOBJ / LoadFromFunc
     S.CalcBouBox;                       // 境界ボックス。ピッキングに用いる

     M := TGLMateryDiffuse.Create;
     M.Ambient := TAlphaColorF.Create( 0.1, 0.1, 0.1 );
     M.Diffuse := TAlphaColorF.Create( 0.8, 0.7, 0.6 );

     S.Matery := M;                      // IGLMatery — 参照カウント管理
end;
```

独自マテリアルは基底クラスのシェーダーソースを差し替え、必要な追加のユニフォームブロックをバインディングポイント 4 以降で宣言します（§2.2）。

```pascal
constructor TMyMatery.Create;
begin
     inherited;                                  // Engine・ShaderV・ShaderF が用意される

     _Color := TGLUniBuf<TAlphaColorF>.Create( GL_STATIC_DRAW );

     with _ShaderF.Source do
     begin
          BeginUpdate;
            Clear;
            Add( '#version 430' );
            Add( 'layout( std140 ) uniform TMateryCol{ vec4 _MateryCol; };' );
            Add( 'in TSenderVF{ vec4 Pos; } _Sender;' );
            Add( 'out vec4 _ResultCol;' );
            Add( 'void main(){ _ResultCol = _MateryCol; }' );
          EndUpdate;
     end;
     Assert( _ShaderF.Status, _ShaderF.Errors.Text );

     _Engine.UniBufs.Add( 4{BinP}, 'TMateryCol'{Name} );
end;

procedure TMyMatery.Use;    begin inherited;  _Color.Use  ( 4 ); end;
procedure TMyMatery.Unuse;  begin _Color.Unuse( 4 );  inherited; end;
```

### 4.3 ピッキング

```pascal
procedure TForm1.ViewerMouseDown( Sender:TObject; Button:TMouseButton;
                                  Shift:TShiftState; X, Y:Single );
var
   O :TGLObject;
begin
     O := _Viewer.PickObject( X, Y );      // (6) によるレイ生成と境界ボックス判定
     if Assigned( O ) then O.Inform.Visible := True;
end;
```

### 4.4 ユニット別リファレンス

ユニットごとのクラスとメンバの一覧:

* [**LUX.GPU.OpenGL**.pas](../LUX.GPU.OpenGL.pas.md)
* [**LUX.GPU.OpenGL.Scener**.pas](../LUX.GPU.OpenGL.Scener.pas.md)
* [**LUX.GPU.OpenGL.Camera**.pas](../LUX.GPU.OpenGL.Camera.pas.md)
* [**LUX.GPU.OpenGL.Shaper**.pas](../LUX.GPU.OpenGL.Shaper.pas.md)
* [**LUX.GPU.OpenGL.Matery**.pas](../LUX.GPU.OpenGL.Matery.pas.md)
* [**LUX.GPU.OpenGL.Inform**.pas](../LUX.GPU.OpenGL.Inform.pas.md)
* [**LUX.GPU.OpenGL.Matery.Preset**.pas](../Matery/LUX.GPU.OpenGL.Matery.Preset.pas.md)
* [**LUX.GPU.OpenGL.Matery.Textur.Preset**.pas](../Matery/Textur/_VCL/LUX.GPU.OpenGL.Matery.Textur.Preset.pas.md)
* [**LUX.GPU.OpenGL.Shaper.Preset**.pas](../Shaper/LUX.GPU.OpenGL.Shaper.Preset.pas.md)
* [**LUX.GPU.OpenGL.Shaper.Octree**.pas](../Shaper/LUX.GPU.OpenGL.Shaper.Octree.pas.md)
* [**LUX.GPU.OpenGL.Shaper.Voxels**.pas](../Shaper/LUX.GPU.OpenGL.Shaper.Voxels.pas.md)
* [**LUX.GPU.OpenGL.Viewer**.pas](../_VCL/LUX.GPU.OpenGL.Viewer.pas.md)
* [**LUX.GPU.OpenGL.Window**.pas](../_VCL/LUX.GPU.OpenGL.Window.pas.md)

## 5. 動作環境

* **Delphi** — Win32 / Win64、FMX または VCL。ジェネリクスと匿名メソッドを全面的に用います。
* **Windows** — コンテキスト層は WGL ベースです（`opengl32.dll`・`wglCreateContext`・`wglMakeCurrent` [3]）。FMX の描画領域はさらに子 `HWND` に依存します。
* **OpenGL 4.3 以降** — GPU ドライバ（NVIDIA / AMD / Intel）が提供します。同梱の GLSL はすべて `#version 430` であり、シェーダーストレージブロック・コンピュートシェーダー・`glDispatchCompute` は 4.3 を要求します。OpenGL 1.1 を超えるエントリポイントは `Winapi.OpenGLext.InitOpenGLext` が解決します。`RunARB` はさらに `GL_ARB_compute_variable_group_size` を必要とします。
* **[LUXOPHIA/LUX](https://github.com/LUXOPHIA/LUX)** — 基盤ライブラリ（数学型 `TSingle3D` / `TSingleM4`、ツリー・リストコンテナ、色、および FMX 用ウィンドウが使うフォームヘルパー `TLuxCommonCustomForm`）。本リポジトリには同梱されていません。

## 6. 参考文献

1. Khronos Group, [*The OpenGL Graphics System: A Specification (Version 4.6, Core Profile)*](https://registry.khronos.org/OpenGL/specs/gl/glspec46.core.pdf), 2019.
2. J. Kessenich, D. Baldwin and R. Rost, [*The OpenGL Shading Language, Version 4.60*](https://registry.khronos.org/OpenGL/specs/gl/GLSLangSpec.4.60.pdf), Khronos Group, 2019.
3. Microsoft, [*WGL Functions*](https://learn.microsoft.com/en-us/windows/win32/opengl/wgl-functions), Win32 API ドキュメント.
4. Khronos Group, [*OpenGL Registry*](https://registry.khronos.org/OpenGL/index_gl.php) — [`glcorearb.h`](https://registry.khronos.org/OpenGL/api/GL/glcorearb.h)・[`wglext.h`](https://registry.khronos.org/OpenGL/api/GL/wglext.h) を含む。ソースリポジトリは [KhronosGroup/OpenGL-Registry](https://github.com/KhronosGroup/OpenGL-Registry).
5. W. E. Lorensen and H. E. Cline, [*Marching cubes: A high resolution 3D surface construction algorithm*](https://doi.org/10.1145/37401.37422), ACM SIGGRAPH Computer Graphics, 21(4), pp. 163–169, 1987.
6. LUXOPHIA, [*OpenGL*](https://github.com/LUXOPHIA/OpenGL), GitHub リポジトリ — FMX 版デモ.
7. LUXOPHIA, [*OpenGL_VCL*](https://github.com/LUXOPHIA/OpenGL_VCL), GitHub リポジトリ — VCL 版デモ.
8. 床井浩平, [*Delphiによる最低限のOpenGL制御*](https://tokoik.github.io/opengl/delphi.html).
9. neslib, [*DelphiLearnOpenGL*](https://github.com/neslib/DelphiLearnOpenGL), GitHub リポジトリ — *Learn OpenGL* チュートリアルの Delphi 移植.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
