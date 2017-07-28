# OpenGL 1.5
[FMX：FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) の描画領域を埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-1.5/--------/_SCREENSHOT/OpenGL.png)

描画する度に膨大な頂点情報を転送していたのでは、GPU の性能如何ではなく、CPU との通信帯域がネックになってしまう。
そこで [Vertex Buffer Object(VBO)](https://www.wikiwand.com/en/Vertex_Buffer_Object) という機能を用い、GPU のメモリ側に配列を確保して、各種頂点情報を**予め**転送しておくことができるようになった。

```pascal
procedure TForm1.FormCreate(Sender: TObject);
begin
     ～
     _VerterP := TGLVerterS<TSingle3D>   .Create( GL_STATIC_DRAW );
     _VerterC := TGLVerterS<TAlphaColorF>.Create( GL_STATIC_DRAW );
     _Elemer  := TGLElemerFace32         .Create( GL_STATIC_DRAW );
     InitViewer;
     InitShaper;
end;
```
```pascal
procedure TForm1.InitShaper;
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
     Es :array [ 0..12-1 ] of TCardinal3D
           = ( ( X:0; Y:4; Z:6 ), ( X:6; Y:2; Z:0 ), ( X:7; Y:5; Z:1 ), ( X:1; Y:3; Z:7 ),
               ( X:0; Y:1; Z:5 ), ( X:5; Y:4; Z:0 ), ( X:7; Y:3; Z:2 ), ( X:2; Y:6; Z:7 ),
               ( X:0; Y:2; Z:3 ), ( X:3; Y:1; Z:0 ), ( X:7; Y:6; Z:4 ), ( X:4; Y:5; Z:7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5
     _VerterP.Import( Ps );
     _VerterC.Import( Cs );
     _Elemer .Import( Es );
end;
```
```pascal
procedure TForm1.FormDestroy(Sender: TObject);
begin
     _VerterP.DisposeOf;
     _VerterC.DisposeOf;
     _Elemer .DisposeOf;
end;
```

VBO を 生成 / 廃棄 する際には、[`glGenBuffers`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBindBuffer.xml) / [`glDeleteBuffers`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glDeleteBuffers.xml) ルーチンを用いる。

```pascal
constructor TGLBuffer<_TYPE_>.Create( const Usage_:GLenum );
begin
     ～
     glGenBuffers( 1, @_ID );
     ～
end;

destructor TGLBuffer<_TYPE_>.Destroy;
begin
     glDeleteBuffers( 1, @_ID );
     ～
end;
```

GPU 側へ配列を転送するには、一時 VBO を**バインド**した上で、[`glBufferData`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBufferData.xml) ルーチンを用いる。
その際、バッファの種類`_Kind` と アクセス頻度`_Usage` を指定する。

```pascal
procedure TGLBuffer<_TYPE_>.Import( const Array_:array of _TYPE_ );
begin
     ～
     Bind;
       glBufferData( _Kind, SizeOf( Array_ ), @Array_[ 0 ], _Usage );
     Unbind;
end;
```

VBO のバインドには [`glBindBuffer`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBindBuffer.xml) ルーチンを用いる。

```pascal
procedure TGLBuffer<_TYPE_>.Bind;
begin
     glBindBuffer( _Kind, _ID );
end;

procedure TGLBuffer<_TYPE_>.Unbind;
begin
     glBindBuffer( _Kind, 0 );
end;

```

描画する際は、[OpenGL 1.1](https://github.com/LUXOPHIA/OpenGL/blob/OpenGL-1.1) と同様に `glEnableClientState` ルーチンによって頂点配列機能を有効化した上で、`gl～Pointer` や `glDrawElements` ルーチンを呼ぶ直前に VBO をバインドする。もちろんこの場合、ルーチンに実データを渡す必要はないので、最後の引数は `nil` となる。

```pascal
procedure TForm1.DrawShaper;
begin
     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );
       with _VerterP do
       begin
            Bind;
              glVertexPointer( 3, GL_FLOAT, 0, nil );
            Unbind;
       end;
       with _VerterC do
       begin
            Bind;
              glColorPointer( 4, GL_FLOAT, 0, nil );
            Unbind;
       end;
       with _Elemer do
       begin
            Bind;
              glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );
            Unbind;
       end;
     glDisableClientState( GL_VERTEX_ARRAY );
     glDisableClientState( GL_COLOR_ARRAY  );
end;

```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
