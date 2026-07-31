# OpenGL

[English](../README.md) | [日本語](README.md)

Delphi / FireMonkey のためのライブコーディング OpenGL プレイグラウンドです。ネイティブな OpenGL 4.3 ビューポートを FMX コンポーネントとして埋め込み、プロシージャルに生成した「編み込みトーラス」を、頂点 → ジオメトリ → フラグメントの完全プログラマブルな GLSL パイプラインで描画します。シェーダのソースコードは実行中に `TMemo` 上で書き換えるとその場で再コンパイルされ、ステージごとのコンパイルログとプログラムのリンクログが UI に表示されます。

![メインウィンドウ](../--------/_SCREENSHOT/OpenGL.png)

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：Delphi のための基盤数学ライブラリ。
* [**LUX.GPU.OpenGL**](https://github.com/LUXOPHIA/LUX.GPU.OpenGL) ：Delphi のための OpenGL ラッパーライブラリ。

## 1. 概要

* **FMX コンポーネントとしての OpenGL ビューポート** — `TGLViewer` は、専用のデバイスコンテキストを持つネイティブ子ウィンドウを内包する FMX フレームであり、ハードウェアアクセラレーションされた OpenGL を通常の FireMonkey レイアウトの中で動作させます。4 つのビューポート（平行投影 3 つ・透視投影 1 つ）が同一シーンを同時に表示し、すべてが単一の WGL レンダリングコンテキスト（`HGLRC`）を共有します。
* **ライブシェーダ編集** — 頂点・ジオメトリ・フラグメントの各シェーダは `_DATA/*.glsl` から `TMemo` エディタへ読み込まれます。編集のたびにドライバへ送り直されて再コンパイルされ、コンパイルエラーはソースの隣に、`glLinkProgram` [4] のログは専用タブに表示されます。
* **プロシージャル形状** — メッシュはパラメトリック関数（`BraidedTorus`）を 1300 × 100 グリッドでサンプリングして CPU 上で生成されます（`TGLShaperFace.LoadFromFunc`）。
* **ジオメトリシェーダによる面取り効果** — 各三角形は、スムーズシェーディングの内側面と、フラットシェーディングの縁面 3 枚へと増幅されます。
* **HDR 環境反射** — フラグメントシェーダは視線を反射させ、正距円筒図法の HDR 環境マップ（`Luxo-Jr_2000x1000.hdr`）をサンプリングし、トーンマッピングとガンマ補正を施します。
* **オフスクリーンレンダリング** — ビューポート 4 は `TGLRender` により 3840 × 2160 でオフスクリーン描画して PNG に保存できます。

### 1.1 関連ブランチ・関連リポジトリ

本リポジトリのブランチでは、同じデモを API 世代ごとに再実装しています。OpenGL の進化を辿ることで、パイプラインの構造を把握できます。

* [OpenGL 1.0](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.0) · [OpenGL 1.1](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.1) · [OpenGL 1.5](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.5) · [OpenGL 2.1](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-2.1) · [OpenGL 3.0](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-3.0)
* [simple](https://github.com/LUXOPHIA/OpenGL/tree/simple) — 最低限にクラス化した変種。
* [OpenGL_VCL](https://github.com/LUXOPHIA/OpenGL_VCL/) — 本プロジェクトの VCL 版。

## 2. 技術的背景

### 2.1 プログラマブルパイプライン

本デモは現代的なプログラマブルパイプライン [2] を駆動します。バッファオブジェクトへアップロードされた頂点データは、頂点シェーダ、ジオメトリシェーダ、ラスタライズ、フラグメントシェーダを流れ、すべて GLSL `#version 430` [3] で記述されています。変換行列は `std140` のユニフォームブロック — `TViewerScal`・`TCameraProj`・`TCameraPose`・`TShaperPose` — として渡され、CPU 側ではそれぞれ `TGLUniBuf<TSingleM4>` のユニフォームバッファオブジェクトが対応します。

### 2.2 変換の連鎖

頂点シェーダ（`ShaderV.glsl`）は頂点をワールド空間へ持ち上げるだけであり、投影はワールド座標のまま処理できるようにジオメトリシェーダへ先送りされます。モデル行列 $M$（`_ShaperPose`）を用いて：

```math
p_{\mathrm{world}} = M \, p_{\mathrm{model}} \qquad (1)
```

法線は、非一様変換の下でも直交性を保つため、逆転置行列で変換されます：

```math
n_{\mathrm{world}} = \left( M^{-1} \right)^{\!\top} n_{\mathrm{model}} \qquad (2)
```

続いてジオメトリシェーダ（`ShaderG.glsl`）がクリップ空間座標を生成します。`_CameraPose` $V$ はカメラの姿勢（カメラ→ワールド）を保持しているため、ビュー行列はその*逆行列*としてシェーダ内で計算されます。$P$ は投影行列（`_CameraProj`。`TGLCameraOrth` では平行投影、`TGLCameraPers` では透視投影）、$S$（`_ViewerScal`）はビューポートのアスペクト比を補正します：

```math
p_{\mathrm{clip}} = S \cdot P \cdot V^{-1} \cdot M \, p_{\mathrm{model}} \qquad (3)
```

### 2.3 ジオメトリの増幅

入力三角形 $P_1 P_2 P_3$ ごとに、ジオメトリシェーダ（`layout( triangles ) in; layout( triangle_strip, max_vertices = 21 ) out;` [5]）は、重み $(0.1,\, 0.8,\, 0.1)$ の重心ブレンドとして内側のコーナー点 $C_i$ を作り、法線方向へわずかにオフセットします。そしてスムーズシェーディングの中央三角形 $C_1 C_2 C_3$ と、面ごとに法線を再計算したフラットシェーディングの縁面クワッド 3 枚（$P_1 P_2 C_2 C_1$ など）を出力し、平坦な入力三角形からパネル状に面取りされた表面を生成します。

### 2.4 反射マッピングと階調再現

フラグメントシェーダ（`ShaderF.glsl`）は、視線 $\vec{V}$ の法線 $\vec{N}$ に関する反射 $\vec{R} = \mathrm{reflect}(\vec{V}, \vec{N})$ を計算し、正距円筒図法のテクスチャ座標へ変換します：

```math
u = \frac{\pi - \operatorname{atan2}(-R_x,\, -R_z)}{2\pi}, \qquad v = \frac{\arccos R_y}{\pi} \qquad (4)
```

環境マップからサンプリングされた HDR 放射輝度は、白色点 $W = 1$ の拡張 Reinhard トーンマッピング演算子で圧縮され、

```math
C' = \operatorname{clamp}\!\left( \frac{C \left( 1 + C / W \right)}{1 + C},\ 0,\ 1 \right) \qquad (5)
```

最後に $C'' = C'^{\,1/\gamma}$（$\gamma = 2.2$）でガンマ補正されます。

## 3. アーキテクチャ

### 3.1 クラス図

本アプリケーションは、[LUX.GPU.OpenGL](https://github.com/LUXOPHIA/LUX.GPU.OpenGL) ライブラリ（`_LIBRARY/` に同梱）のラッパークラス群を組み合わせて構成されています。

```
Ownership — what TForm1 (Main.pas) creates and owns

・TForm1 (Main.pas)
  ┣・GLViewer1..4 :TGLViewer             ･･･ FMX frame + native GL child window
  ┃  ┣・Camera                          ･･･ one of the TGLCamera objects below
  ┃  ┗・_Viewer :TGLUniBuf<TSingleM4>   ･･･ "TViewerScal" UBO
  ┣・_Scener :TGLScener                  ･･･ scene root (TTreeNode<TGLObject>)
  ┃  ┣・_Camera1..3 :TGLCameraOrth      ･･･ "TCameraProj" / "TCameraPose" UBOs
  ┃  ┣・_Camera4 :TGLCameraPers
  ┃  ┗・_Shaper :TGLShaperFace          ･･･ "TShaperPose" UBO + mesh buffers
  ┗・_Matery :TGLMateryImagG             ･･･ shaders + program + texture
     ┣・ShaderV :TGLShaderV              ･･･ (TGLShader: Source/Status/Errors)
     ┣・ShaderG :TGLShaderG
     ┣・ShaderF :TGLShaderF
     ┣・Engine :TGLEngine ( TGLProgra )
     ┃  ┣・VerBufs :TGLPorterV          ･･･ attribute ports
     ┃  ┣・UniBufs :TGLPorterU          ･･･ uniform-block ports
     ┃  ┣・Texturs :TGLPorterT          ･･･ sampler ports
     ┃  ┗・StoBufs :TGLPorterS          ･･･ storage-buffer ports
     ┗・Textur :TGLCelTex2D_TAlphaColorF ･･･ 2-D texture, fed by an HDR Imager

Camera reference — each viewer points at one camera of the scene graph

・GLViewer1..4 . Camera
  ┣・_Camera1..3 :TGLCameraOrth
  ┗・_Camera4 :TGLCameraPers

Material reference — the shaper points at the material

・_Shaper :TGLShaperFace . Matery
  ┗・_Matery :TGLMateryImagG

Shader attachment — the three shaders attach to the engine's program

・Engine :TGLEngine ( TGLProgra )
  ┣・ShaderV :TGLShaderV
  ┣・ShaderG :TGLShaderG
  ┗・ShaderF :TGLShaderF

Global singleton

・_OpenGL_ :IOpenGL ( TOpenGL )           ･･･ hidden window + DC, shared HGLRC
```

データはシーングラフからユニフォームバッファへと流れます。`TGLViewer.Paint` のたびに共有コンテキストをカレントにし、ビューア・カメラ・シェイパの各行列をアップロードした後、マテリアルの `TGLEngine` がバッファ・テクスチャ・リンク済みプログラムをバインドして描画します。`TGLShader.Source` は `TStringList` の変更をトリガに再コンパイルし、`OnCompiled` / `Errors` を通じて報告します。`TGLEngine` は再リンクし、`OnLinked` を通じて報告します。

### 3.2 ファイルツリー

```
・OpenGL/
  ┣・OpenGL.dpr / OpenGL.dproj ･･･ FMX application project (Win32 / Win64)
  ┣・Main.pas / Main.fmx       ･･･ main form: viewports, editors, scene setup
  ┣・_DATA/
  ┃  ┣・ShaderV.glsl          ･･･ vertex shader (model → world, eqs. 1–2)
  ┃  ┣・ShaderG.glsl          ･･･ geometry shader (bevel amplification, eq. 3)
  ┃  ┣・ShaderF.glsl          ･･･ fragment shader (reflection, eqs. 4–5)
  ┃  ┗・Luxo-Jr_2000x1000.hdr ･･･ equirectangular HDR environment map
  ┣・_LIBRARY/LUXOPHIA/
  ┃  ┣・LUX/                  ･･･ vectors/matrices, scene tree, color, curves
  ┃  ┗・LUX.GPU.OpenGL/       ･･･ OpenGL wrapper library (see § 3.1)
  ┗・--------/_SCREENSHOT/     ･･･ screenshots used in this README
```

## 4. 使い方

| 操作 | 場所 | 効果 |
|---|---|---|
| 左ドラッグ | ビューポート 4（透視投影） | モデルを回転（4 つのビューポートすべてが再描画） |
| ダブルクリック | ビューポート 1–3 | そのビューポートを `Viewer1.png` … `Viewer3.png` として保存 |
| ダブルクリック | ビューポート 4 | `TGLRender` により 3840 × 2160 でオフスクリーン描画し `Viewer4.png` として保存 |
| テキスト編集 | **Shader** タブ › Vertex / Geometry / Fragment | アイドル時にシェーダを再コンパイルし、コンパイルエラーを隣のペインに表示 |
| — | **Program** タブ | `glLinkProgram` のログを表示。リンク失敗時は **View** タブが無効化される |

シェーダのソースコードは `TMemo` エディタ上でライブに書き換えることができ、リアルタイムにコンパイルされて、適宜エラーメッセージも表示されます：

![頂点シェーダエディタ](../--------/_SCREENSHOT/OpenGL-Shader-Vertex.png)

`glLinkProgram` [4] によるリンク時のエラーメッセージも、同様に **Program** タブで確認できます：

![プログラムのリンクログ](../--------/_SCREENSHOT/OpenGL-Program.png)

## 5. ビルド

* **IDE**: RAD Studio（Delphi）。プロジェクトファイルは `ProjectVersion` 20.4 形式です。FireMonkey（FMX）フレームワークが必要です。
* **プラットフォーム**: Win32 および Win64（OpenGL コンテキストは WGL 経由で作成されるため Windows 専用です）。
* **依存関係**: 同梱の `_LIBRARY/` ソース以外にはありません。描画はシステムの `opengl32.dll` と、**OpenGL 4.3** を公開する GPU ドライバを通して行われます（シェーダは `#version 430` とジオメトリシェーダを使用します）。
* **実行**: IDE からビルドして実行します。実行ファイルは `..\..\_DATA\*.glsl` と HDR マップを出力ディレクトリ（例：`Win64\Debug\`）からの相対パスで読み込むため、既定の出力構成を維持するか `Main.pas` のパスを調整してください。

## 6. 参考文献

1. Khronos Group, [*OpenGL Registry*](https://registry.khronos.org/OpenGL/).
2. Khronos Group, [*Rendering Pipeline Overview*](https://www.khronos.org/opengl/wiki/Rendering_Pipeline_Overview), OpenGL Wiki.
3. J. Kessenich et al., [*The OpenGL Shading Language, Version 4.30*](https://registry.khronos.org/OpenGL/specs/gl/GLSLangSpec.4.30.pdf).
4. Khronos Group, [*glLinkProgram*](https://registry.khronos.org/OpenGL-Refpages/gl4/html/glLinkProgram.xhtml), OpenGL 4 Reference Pages.
5. Khronos Group, [*Geometry Shader*](https://www.khronos.org/opengl/wiki/Geometry_Shader), OpenGL Wiki.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
