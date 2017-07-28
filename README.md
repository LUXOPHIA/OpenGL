# OpenGL 2.1
[FMX：FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) の描画領域を埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-2.1/--------/_SCREENSHOT/OpenGL.png)

従来固定されていたシェーダのパイプラインを、[GLSL](https://www.wikiwand.com/ja/GLSL) という言語でプログラミングできるようになった。
構造としては、種類毎に作成された複数のシェーダオブジェクトを、**プログラム**という管理オブジェクトに統合することで、描画時の実行が可能となる。

シェーダオブジェクトには、ソースコードを読み込ませてコンパイルさせる。エラーメッセージなども出力されるので、デバッグ作業も可能となる。

```pascal
procedure TForm1.FormCreate(Sender: TObject);
～
begin
     ～
     _VerterP := TGLVerterS<TSingle3D>   .Create( GL_STATIC_DRAW );
     _VerterC := TGLVerterS<TAlphaColorF>.Create( GL_STATIC_DRAW );
     _Elemer  := TGLElemerFace32         .Create( GL_STATIC_DRAW );
     _ShaderV := TGLShaderV              .Create;
     _ShaderF := TGLShaderF              .Create;
     _Progra  := TGLProgra               .Create;
     InitShaper;
     InitViewer;
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
     ///// バッファ
     _VerterP.Import( Ps );
     _VerterC.Import( Cs );
     _Elemer .Import( Es );
     ///// シェーダ
     with _ShaderV do
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
          ～
     end;
     with _ShaderF do
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
          ～
     end;
     ///// プログラム
     with _Progra do
     begin
          Attach( _ShaderV );
          Attach( _ShaderF );
          Link;
          Assert( Status, Errors.Text );
     end;
end;
```
```pascal
procedure TForm1.FormDestroy(Sender: TObject);
begin
     _ShaderV.DisposeOf;
     _ShaderF.DisposeOf;
     _Progra .DisposeOf;
     _VerterP.DisposeOf;
     _VerterC.DisposeOf;
     _Elemer .DisposeOf;
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
constructor TGLProgra.Create;
begin
     ～
     _ID := glCreateProgram;
end;

destructor TGLProgra.Destroy;
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
function TGLShader.GetStatus :Boolean;
～
begin
     glGetShaderiv( _ID, GL_COMPILE_STATUS, @S );
     ～
end;
```

エラーメッセージは [`glGetShaderInfoLog`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glGetShaderInfoLog.xml) ルーチンによって取得できる。メッセージの文字（バイト）数は [`glGetShaderiv`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glGetShader.xml) ルーチンによって予め取得できる。

```pascal
function TGLShader.GetErrors :String;
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
procedure TGLProgra.Attach( const Shader_:TGLShader );
begin
     glAttachShader( _ID, Shader_.ID );
end;

procedure TGLProgra.Detach( const Shader_:TGLShader );
begin
     glDetachShader( _ID, Shader_.ID );
end;
```

プログラムオブジェクトへ登録されたシェーダオブジェクトを[リンク](https://www.wikiwand.com/ja/%E5%8B%95%E7%9A%84%E3%83%AA%E3%83%B3%E3%82%AF)させるには、[`glLinkProgram`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glLinkProgram.xml) ルーチンを用いる。

```pascal
procedure TGLProgra.Link;
begin
     glLinkProgram( _ID );
     ～
end;
```

描画する際には、glDrawElements ルーチンを呼ぶ直前で、プログラムオブジェクトを利用可能にする。

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
              with _Progra do
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
procedure TGLProgra.Use;
begin
     glUseProgram( _ID );
end;

class procedure TGLProgra.Unuse;
begin
     glUseProgram( 0 );
end;
```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
