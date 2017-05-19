# OpenGL 1.0
[FMX：FireMonkey](https://www.wikiwand.com/en/FireMonkey) のコンポーネントとして [OpenGL](https://www.wikiwand.com/ja/OpenGL) の描画領域を埋め込む方法。

![](https://github.com/LUXOPHIA/OpenGL/raw/OpenGL-1.0/--------/_SCREENSHOT/OpenGL.png)

[`glBegin`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBegin.xml) ～ [`glEnd`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glEnd.xml) ルーチンで囲んだブロック内で、データを GPU へ転送するための [`glVertex`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glVertex.xml), [`glColor`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glColor.xml), [`glNormal`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glNormal.xml), [`glTexCoord`](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glTexCoord.xml) といった、それぞれのデータ型に特有のルーチンを呼びながら、頂点情報を一つ一つ追加していく。

```pascal
procedure TForm1.DrawModel;
const
     Ps :array [ 1..8 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                         ( X:+1; Y:-1; Z:-1 ),
                                         ( X:-1; Y:+1; Z:-1 ),
                                         ( X:+1; Y:+1; Z:-1 ),
                                         ( X:-1; Y:-1; Z:+1 ),
                                         ( X:+1; Y:-1; Z:+1 ),
                                         ( X:-1; Y:+1; Z:+1 ),
                                         ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 1..8 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                            ( R:1; G:0; B:0; A:1 ),
                                            ( R:0; G:1; B:0; A:1 ),
                                            ( R:1; G:1; B:0; A:1 ),
                                            ( R:0; G:0; B:1; A:1 ),
                                            ( R:1; G:0; B:1; A:1 ),
                                            ( R:0; G:1; B:1; A:1 ),
                                            ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 1..6, 1..4 ] of Integer = ( ( 1, 3, 4, 2 ),
                                             ( 1, 5, 7, 3 ),
                                             ( 1, 2, 6, 5 ),
                                             ( 8, 4, 3, 7 ),
                                             ( 8, 6, 2, 4 ),
                                             ( 8, 7, 5, 6 ) );
var
   N, K, I :Integer;
begin
     //    3-------4
     //   /|      /|
     //  7-------8 |
     //  | |     | |
     //  | 1-----|-2
     //  |/      |/
     //  5-------6
     glBegin( GL_QUADS );
       for N := 1 to 6 do
       begin
            for K := 1 to 4 do
            begin
                 I := Fs[ N, K ];
                 with Cs[ I ] do glColor3f( R, G, B );
                 with Ps[ I ] do glVertex3f( X, Y, Z );
            end;
       end;
     glEnd;
end;
```

----
* LUX.GPU.OpenGL
    * [GitHub](https://github.com/LUXOPHIA/LUX.GPU.OpenGL)
    * [Bitbucket](https://bitbucket.org/LUXOPHIA/lux.gpu.opengl)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
