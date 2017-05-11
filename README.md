# OpenGL 3.0
[FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) のビューを埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-3.0/--------/_SCREENSHOT/OpenGL.png)

Vertex Array Object(VAO) を用いることにより、バッファブジェクトやプログラムオブジェクトを描画の度に一々バインドする必要がなくなる。

```pascal
procedure TForm1.DrawModel;
begin
     with _Arra do
     begin
          Bind;
            glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );
          Unbind;
     end;
end;
```

VAO の生成/廃棄には [`glGenVertexArrays`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glGenVertexArrays.xhtml) / [`glDeleteVertexArrays`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glDeleteVertexArrays.xhtml) ルーチンを用いる。

```pascal
procedure TForm1.FormCreate(Sender: TObject);
～
begin
     ～
     _Arra := TGLArray.Create;
     MakeModel;
     ～
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Arra.DisposeOf;
     ～
end;
```
```pascal
constructor TGLArray.Create;
begin
     ～
     glGenVertexArrays( 1, @_ID );
end;

destructor TGLArray.Destroy;
begin
     glDeleteVertexArrays( 1, @_ID );
     ～
end;
```

VAO をバインドした上で、バッファオブジェクトなどの各種バインドを実行すると、その状態を記録することができる。ブログラムオブジェクトの glUseProgram もその対象である。

```pascal
procedure TForm1.MakeModel;
～
begin
     ～
     with _Arra do
     begin
          Bind;
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
            _BufF.Bind;
            _Prog.Use;
          Unbind;
     end;
end;
```

VAO のバインドには [`glBindVertexArray`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glBindVertexArray.xhtml) ルーチンを用いる。

```pascal
procedure TGLArray.Bind;
begin
     glBindVertexArray( _ID );
end;

procedure TGLArray.Unbind;
begin
     glBindVertexArray( 0 );
end;
```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
