## 歴史に学ぶ OpenGL

OpenGL のバージョンを辿りながら実装していくことで、新しい API が追加された意図を理解しながら、パイプラインの構造を把握していきます。

* [OpenGL 1.0](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.0)
* [OpenGL 1.1](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.1)
* [OpenGL 1.5](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.5)
* [OpenGL 2.1](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-2.1)
* [OpenGL 3.0](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-3.0)

----

# OpenGL
[FMX：FireMonkey](https://www.wikiwand.com/en/FireMonkey) フレームワークのコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) の描画領域を埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/master/--------/_SCREENSHOT/OpenGL-View.png)

シェーダのソースコードは `TMemo` コンポーネントによって書き換えることができ、リアルタイムにコンパイルされて、適宜エラーメッセージも表示されます。

![](https://github.com/LUXOPHIA/OpenGL/raw/master/--------/_SCREENSHOT/OpenGL-Shader-Vertex.png)

[`glLinkProgram`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glLinkProgram.xhtml) ルーチンによるリンク時のエラーメッセージも、TMemo コンポーネントで確認できます。

![](https://github.com/LUXOPHIA/OpenGL/raw/master/--------/_SCREENSHOT/OpenGL-Program.png)

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)

※ [VCL]((https://www.wikiwand.com/ja/Visual_Component_Library)) 版はこちら ⇒ [OpenGL_VCL](https://github.com/LUXOPHIA/OpenGL_VCL/)
