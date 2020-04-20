# OpenGL 1.1
[FMX：FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) の描画領域を埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-1.0/--------/_SCREENSHOT/OpenGL.png)

[`glEnableClientState`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glEnableClientState.xml) ～ [`glDisableClientState`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glDisableClientState.xml) ルーチンで囲むことにより、頂点配列機能を有効化した上で、
[`glVertexPointer`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glVertexPointer.xml), 
[`glColorPointer`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glColorPointer.xml), 
[`glNormalPointer`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glNormalPointer.xml), 
[`glTexCoordPointer`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glTexCoordPointer.xml) といった、それぞれのデータ型に特有のルーチンを呼び出し、頂点情報を配列として一気に転送する。


```pascal
procedure TForm1.DrawShaper;
const
     Ps :array [ 0..8-1 ] of TSingle3D
           = ( ( X:-1; Y:-1; Z:-1 ), ( X:+1; Y:-1; Z:-1 ),
               ( X:-1; Y:+1; Z:-1 ), ( X:+1; Y:+1; Z:-1 ),
               ( X:-1; Y:-1; Z:+1 ), ( X:+1; Y:-1; Z:+1 ),
               ( X:-1; Y:+1; Z:+1 ), ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..8-1 ] of TAlphaColorF
           = ( ( R:0; G:0; B:0; A:1 ), ( R:1; G:0; B:0; A:1 ),
               ( R:0; G:1; B:0; A:1 ), ( R:1; G:1; B:0; A:1 ),
               ( R:0; G:0; B:1; A:1 ), ( R:1; G:0; B:1; A:1 ),
               ( R:0; G:1; B:1; A:1 ), ( R:1; G:1; B:1; A:1 ) );
     Es :array [ 0..12-1, 0..3-1 ] of Cardinal
           = ( ( 0, 4, 6 ), ( 6, 2, 0 ), ( 7, 5, 1 ), ( 1, 3, 7 ),
               ( 0, 1, 5 ), ( 5, 4, 0 ), ( 7, 3, 2 ), ( 2, 6, 7 ),
               ( 0, 2, 3 ), ( 3, 1, 0 ), ( 7, 6, 4 ), ( 4, 5, 7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5
     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );
       glVertexPointer( 3, GL_FLOAT, 0, @Ps[ 0 ] );
       glColorPointer ( 4, GL_FLOAT, 0, @Cs[ 0 ] );
       glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, @Es[ 0, 0 ] );
     glDisableClientState( GL_VERTEX_ARRAY );
     glDisableClientState( GL_COLOR_ARRAY  );
end;
```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](https://github.com/delphiusers/FreeDelphi/raw/master/FreeDelphi_350px.png)](https://www.embarcadero.com/jp/products/delphi/starter)
