# OpenGL 3.0
[FMX：FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) の描画領域を埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-3.0/--------/_SCREENSHOT/OpenGL.png)

[Vertex Array Object(VAO)](https://www.khronos.org/opengl/wiki/Vertex_Specification#Vertex_Array_Object) という機能を用いることにより、バッファブジェクトを描画の度に一々バインドする必要がなくなった。

VAO をバインドした上で、バッファオブジェクトの各種バインドを実行すると、その状態を記録することができる。

```pascal
procedure TForm1.FormCreate(Sender: TObject);
～
begin
     ～
     _Varray := TGLVarray.Create;
     ～
end;
```
```pascal
procedure TForm1.InitShaper;
～
begin
     ～
     with _Varray do
     begin
          Bind;
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
            _Elemer.Bind;
          Unbind;
     end;
end;
```
```pascal
procedure TForm1.DrawShaper;
begin
     with _Progra do
     begin
          Use;
          with _Varray do
          begin
               Bind;
                 glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );
               Unbind;
          end;
          Unuse;
     end;
end;
```
```pascal
procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Varray.DisposeOf;
     ～
end;
```

VAO の生成/廃棄には [`glGenVertexArrays`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glGenVertexArrays.xhtml) / [`glDeleteVertexArrays`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glDeleteVertexArrays.xhtml) ルーチンを用いる。


```pascal
constructor TGLVarray.Create;
begin
     ～
     glGenVertexArrays( 1, @_ID );
end;

destructor TGLVarray.Destroy;
begin
     glDeleteVertexArrays( 1, @_ID );
     ～
end;
```

VAO のバインドには [`glBindVertexArray`](https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glBindVertexArray.xhtml) ルーチンを用いる。

```pascal
procedure TGLVarray.Bind;
begin
     glBindVertexArray( _ID );
end;

procedure TGLVarray.Unbind;
begin
     glBindVertexArray( 0 );
end;
```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](https://github.com/delphiusers/FreeDelphi/raw/master/FreeDelphi_350px.png)](https://www.embarcadero.com/jp/products/delphi/starter)
