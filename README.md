# OpenGL 2.1
[FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) のビューを埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-2.1/--------/_SCREENSHOT/OpenGL.png)

従来固定されていたシェーダのパイプラインを、[GLSL](https://www.wikiwand.com/ja/GLSL) という言語でプログラミングできるようになった。
構造としては、種類毎に作成された複数のシェーダオブジェクトを、**プログラム**という管理オブジェクトに統合することで、描画時の実行が可能となる。

シェーダオブジェクトには、ソースコードを読み込ませてコンパイルさせる。エラーメッセージなども出力されるので、デバッグ作業も可能となる。

```pascal
procedure TForm1.FormCreate(Sender: TObject);
～
begin
     ～
     _BufV := TGLBufferV<TSingle3D>   .Create;
     _BufC := TGLBufferV<TAlphaColorF>.Create;
     _BufF := TGLBufferI<TCardinal3D> .Create;
     _ShaV := TGLShaderV.Create;
     _ShaF := TGLShaderF.Create;
     _Prog := TGLProgram.Create;
     MakeModel;
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
     ///// バッファ
     _BufV.Import( Ps );
     _BufC.Import( Cs );
     _BufF.Import( Fs );
     ///// シェーダ
     with _ShaV do
     begin
          with Source do
          begin
               BeginUpdate;
                 Add( '#version 120' );
                 Add( 'void main()' );
                 Add( '{' );
                 Add( '  gl_Position   = gl_ModelViewProjectionMatrix * gl_Vertex;' );
                 Add( '  gl_FrontColor = gl_Color;' );
                 Add( '}' );
               EndUpdate;
          end;
          Assert( Success, Error.Text );
     end;
     with _ShaF do
     begin
          with Source do
          begin
               BeginUpdate;
                 Add( '#version 120' );
                 Add( 'void main()' );
                 Add( '{' );
                 Add( '  gl_FragColor = gl_Color;' );
                 Add( '}' );
               EndUpdate;
          end;
          Assert( Success, Error.Text );
     end;
     ///// プログラム
     with _Prog do
     begin
          Attach( _ShaV );
          Attach( _ShaF );
          Link;
          Assert( Success, Error.Text );
     end;
end;
```
```pascal
procedure TForm1.FormDestroy(Sender: TObject);
begin
     _ShaV.DisposeOf;
     _ShaF.DisposeOf;
     _Prog.DisposeOf;
     _BufV.DisposeOf;
     _BufC.DisposeOf;
     _BufF.DisposeOf;
end;
```

シェーダオブジェクトの 生成 / 削除 には、[`glCreateShader`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glCreateShader.xml) / [`glDeleteShader`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glDeleteShader.xml) ルーチンを用いる。

```pascal
constructor TGLShader.Create( const Kind_:GLenum );
begin
     ～
     _ID := glCreateShader( Kind_ );
     ～
end;

destructor TGLShader.Destroy;
begin
     glDeleteShader( _ID );
     ～
end;
```

プログラムオブジェクトの 生成 / 廃棄 には、[`glCreateProgram`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glCreateProgram.xml) / [`glDeleteProgram`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glDeleteProgram.xml) ルーチンを用いる。

```pascal
constructor TGLProgram.Create;
begin
     ～
     _ID := glCreateProgram;
end;

destructor TGLProgram.Destroy;
begin
     glDeleteProgram( _ID );
     ～
end;
```

シェーダオブジェクトへのソースコードの読込みには、[`glShaderSource`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glShaderSource.xml) ルーチンを用い、コンパイルには [`glCompileShader`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glCompileShader.xml) ルーチンを用いる。

```pascal
procedure TGLShader.Compile( const Source_:String );
～
begin
     ～
     glShaderSource( _ID, 1, @P, @N );
     glCompileShader( _ID );
end;
```

正常にコンパイルできたかどうかは、[`glGetShaderiv`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glGetShader.xml) ルーチンを持ついて調べることができる（`warning`が出た程度では失敗したと見なされない）。

```pascal
function TGLShader.GetState :Boolean;
～
begin
     glGetShaderiv( _ID, GL_COMPILE_STATUS, @S );
     ～
end;
```

エラーメッセージは [`glGetShaderInfoLog`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glGetShaderInfoLog.xml) ルーチンによって取得できる。メッセージの文字（バイト）数は [`glGetShaderiv`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glGetShader.xml) ルーチンによって予め取得できる。

```pascal
function TGLShader.GetError :String;
～
begin
     glGetShaderiv( _ID, GL_INFO_LOG_LENGTH, @N );
     ～
     glGetShaderInfoLog( _ID, N, @CsN, PGLchar( Cs ) );
     ～
end;
```

プログラムオブジェクトへのシェーダオブジェクトの 追加 / 削除 は、[`glAttachShader`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glAttachShader.xml) / [`glDetachShader`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glDetachShader.xml) ルーチンを用いる。

```pascal
procedure TGLProgram.Attach( const Shader_:TGLShader );
begin
     glAttachShader( _ID, Shader_.ID );
end;

procedure TGLProgram.Detach( const Shader_:TGLShader );
begin
     glDetachShader( _ID, Shader_.ID );
end;
```

プログラムオブジェクトへ登録されたシェーダオブジェクトを[リンク](https://www.wikiwand.com/ja/%E5%8B%95%E7%9A%84%E3%83%AA%E3%83%B3%E3%82%AF)させるには、[`glLinkProgram`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glLinkProgram.xml) ルーチンを用いる。

```pascal
procedure TGLProgram.Link;
begin
     glLinkProgram( _ID );
     ～
end;
```

描画する際には、glDrawElements ルーチンを呼ぶ直前で、プログラムオブジェクトを利用可能にする。

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

              with _Prog do
              begin
                   Use;
                     glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );
                   Unuse;
              end;

            Unbind;
       end;
     glDisableClientState( GL_VERTEX_ARRAY );
     glDisableClientState( GL_COLOR_ARRAY  );
end;
```

プログラムオブジェクトを利用可能にするには、[`glUseProgram`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glUseProgram.xml) ルーチンを用いる。

```pascal
procedure TGLProgram.Use;
begin
     glUseProgram( _ID );
end;

class procedure TGLProgram.Unuse;
begin
     glUseProgram( 0 );
end;
```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
