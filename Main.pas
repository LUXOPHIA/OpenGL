unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3, LUX.GPU.OpenGL.Shader, LUX.GPU.OpenGL.GLView;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
      TabItemV: TTabItem;
        Rectangle1: TRectangle;
          GLView1: TGLView;
          GLView2: TGLView;
        GLView3: TGLView;
        GLView4: TGLView;
        Timer1: TTimer;
      TabItemP: TTabItem;
        MemoP: TMemo;
      TabItemS: TTabItem;
        TabControlS: TTabControl;
          TabItemSV: TTabItem;
            TabControlSV: TTabControl;
              TabItemSVS: TTabItem;
                MemoSVS: TMemo;
              TabItemSVE: TTabItem;
                MemoSVE: TMemo;
          TabItemSF: TTabItem;
            TabControlSF: TTabControl;
              TabItemSFS: TTabItem;
                MemoSFS: TMemo;
              TabItemSFE: TTabItem;
                MemoSFE: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private 宣言 }
    _Angle :Single;
  public
    { public 宣言 }
    _BufV :TGLBuffer<TSingle3D>;
    _BufC :TGLBuffer<TAlphaColorF>;
    _BufF :TGLBuffer<Cardinal>;
    _ShaV :TGLShaderV;
    _ShaF :TGLShaderF;
    _Prog :TGLProgram;
    ///// メソッド
    procedure MakeModel;
    procedure DrawModel;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.MakeModel;
const
     Ps :array [ 0..7 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                         ( X:+1; Y:-1; Z:-1 ),
                                         ( X:-1; Y:+1; Z:-1 ),
                                         ( X:+1; Y:+1; Z:-1 ),
                                         ( X:-1; Y:-1; Z:+1 ),
                                         ( X:+1; Y:-1; Z:+1 ),
                                         ( X:-1; Y:+1; Z:+1 ),
                                         ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..7 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                            ( R:1; G:0; B:0; A:1 ),
                                            ( R:0; G:1; B:0; A:1 ),
                                            ( R:1; G:1; B:0; A:1 ),
                                            ( R:0; G:0; B:1; A:1 ),
                                            ( R:1; G:0; B:1; A:1 ),
                                            ( R:0; G:1; B:1; A:1 ),
                                            ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 0..11, 0..2 ] of Cardinal = ( ( 0, 4, 6 ), ( 6, 2, 0 ),
                                               ( 0, 1, 5 ), ( 5, 4, 0 ),
                                               ( 0, 2, 3 ), ( 3, 1, 0 ),
                                               ( 7, 5, 1 ), ( 1, 3, 7 ),
                                               ( 7, 3, 2 ), ( 2, 6, 7 ),
                                               ( 7, 6, 4 ), ( 4, 5, 7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5


     ///// バッファ

     with _BufV do
     begin
          Count := 8;

          Bind;
            glBufferData( GL_ARRAY_BUFFER, SizeOf( Ps ), @Ps[ 0 ], GL_STATIC_DRAW );
          Unbind;
     end;

     with _BufC do
     begin
          Count := 8;

          Bind;
            glBufferData( GL_ARRAY_BUFFER, SizeOf( Cs ), @Cs[ 0 ], GL_STATIC_DRAW );
          Unbind;
     end;

     with _BufF do
     begin
          Count := 36;

          Bind;
            glBufferData( GL_ELEMENT_ARRAY_BUFFER, SizeOf( Fs ), @Fs[ 0, 0 ], GL_STATIC_DRAW );
          Unbind;
     end;

     ///// シェーダ

     with _ShaV do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          MemoSVS.Lines.Assign( Source );
          MemoSVE.Lines.Assign( Error  );

          if not Success then TabControlSV.TabIndex := 1;
     end;

     with _ShaF do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

          MemoSFS.Lines.Assign( Source );
          MemoSFE.Lines.Assign( Error  );

          if not Success then TabControlSF.TabIndex := 1;
     end;

     ///// プログラム

     with _Prog do
     begin
          Attach( _ShaV );
          Attach( _ShaF );

          Link;

          MemoP.Lines.Assign( Error );

          if not Success then TabControl1.TabIndex := 1;
     end;
end;

procedure TForm1.DrawModel;                                                     { OpenGL 2.1 - GLSL 1.2 }
begin
     _Prog.Use;

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

     _Prog.Unuse;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Angle := 0;

     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );

     _BufV := TGLBuffer<TSingle3D>   .Create( GL_ARRAY_BUFFER         );
     _BufC := TGLBuffer<TAlphaColorF>.Create( GL_ARRAY_BUFFER         );
     _BufF := TGLBuffer<Cardinal>    .Create( GL_ELEMENT_ARRAY_BUFFER );

     _ShaV := TGLShaderV.Create;
     _ShaF := TGLShaderF.Create;
     _Prog := TGLProgram.Create;

     MakeModel;

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -4, +4, -2, +2, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( -90, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView4.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -4, +4, -3, +3, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _ShaV.DisposeOf;
     _ShaF.DisposeOf;
     _Prog.DisposeOf;

     _BufV.DisposeOf;
     _BufC.DisposeOf;
     _BufF.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     GLView1.Repaint;
     GLView2.Repaint;
     GLView3.Repaint;
     GLView4.Repaint;
end;

end. //######################################################################### ■
