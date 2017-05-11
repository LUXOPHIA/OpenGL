# OpenGL 1.5
[FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) のビューを埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-1.5/--------/_SCREENSHOT/OpenGL.png)

描画する度に膨大な頂点情報を転送していたのでは、GPU の性能如何ではなく、CPU とのメモリ帯域がネックになってしまう。
そこで、[Vertex Buffer Object(VBO)](https://www.wikiwand.com/en/Vertex_Buffer_Object) という機能を用い、GPU のメモリ側に配列を確保し、頂点情報を予め転送しておくことができるようになった。

```pascal
procedure TForm1.FormCreate(Sender: TObject);
～
begin
     ～
     _BufV := TGLBufferV<TSingle3D>   .Create;
     _BufC := TGLBufferV<TAlphaColorF>.Create;
     _BufF := TGLBufferI<TCardinal3D> .Create;
     ～
end;
```
```pascal
procedure TForm1.MakeModel;
const
     Ps :array [ 0..8-1 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                           ( X:+1; Y:-1; Z:-1 ),
                                           ( X:-1; Y:+1; Z:-1 ),
                                           ( X:+1; Y:+1; Z:-1 ),
                                           ( X:-1; Y:-1; Z:+1 ),
                                           ( X:+1; Y:-1; Z:+1 ),
                                           ( X:-1; Y:+1; Z:+1 ),
                                           ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..8-1 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                              ( R:1; G:0; B:0; A:1 ),
                                              ( R:0; G:1; B:0; A:1 ),
                                              ( R:1; G:1; B:0; A:1 ),
                                              ( R:0; G:0; B:1; A:1 ),
                                              ( R:1; G:0; B:1; A:1 ),
                                              ( R:0; G:1; B:1; A:1 ),
                                              ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 0..12-1 ] of TCardinal3D = ( ( _1:0; _2:4; _3:6 ), ( _1:6; _2:2; _3:0 ),
                                              ( _1:0; _2:1; _3:5 ), ( _1:5; _2:4; _3:0 ),
                                              ( _1:0; _2:2; _3:3 ), ( _1:3; _2:1; _3:0 ),
                                              ( _1:7; _2:5; _3:1 ), ( _1:1; _2:3; _3:7 ),
                                              ( _1:7; _2:3; _3:2 ), ( _1:2; _2:6; _3:7 ),
                                              ( _1:7; _2:6; _3:4 ), ( _1:4; _2:5; _3:7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5
     _BufV.Import( Ps );
     _BufC.Import( Cs );
     _BufF.Import( Fs );
end;
```
```pascal
procedure TForm1.FormDestroy(Sender: TObject);
begin
     _BufV.DisposeOf;
     _BufC.DisposeOf;
     _BufF.DisposeOf;
end;
```

VBO を作成する際には [`glGenBuffers`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBindBuffer.xml) ルーチンを、削除する際には [`glDeleteBuffers`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glDeleteBuffers.xml) ルーチンを用いる。

```pascal
constructor TGLBuffer<_TYPE_>.Create( const Kind_:GLenum; const Usage_:GLenum = GL_STATIC_DRAW );
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

描画する際は、[OpenGL 1.1](https://github.com/LUXOPHIA/OpenGL/blob/OpenGL-1.1) と同様に `glEnableClientState` ルーチンによって頂点配列機能を有効化した上で、`gl～Pointer` ルーチンを呼ぶ直前に VBO をバインドする。もちろんこの場合、`gl～Pointer` ルーチンに配列を渡す必要はないので、最後の引数は nil となる。

```pascal
procedure TForm1.DrawModel;
begin
     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );
       with _BufV do
       begin
            Bind;
              glVertexPointer( 3, GL_FLOAT, 0, nil );
            Unbind;
       end;
       with _BufC do
       begin
            Bind;
              glColorPointer( 4, GL_FLOAT, 0, nil );
            Unbind;
       end;
       with _BufF do
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
