unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3, LUX.GPU.OpenGL, LUX.GPU.OpenGL.Buffer, LUX.GPU.OpenGL.Shader, LUX.GPU.OpenGL.GLView,
  FMX.StdCtrls;

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
      TabItemS: TTabItem;
        TabControlS: TTabControl;
          TabItemSV: TTabItem;
            MemoSVS: TMemo;
            SplitterSV: TSplitter;
            MemoSVE: TMemo;
          TabItemSF: TTabItem;
            MemoSFS: TMemo;
            SplitterSF: TSplitter;
            MemoSFE: TMemo;
      TabItemP: TTabItem;
        MemoP: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MemoSFSChange(Sender: TObject);
    procedure MemoSVSChange(Sender: TObject);
  private
    { private 宣言 }
    _Angle :Single;
  public
    { public 宣言 }
    _BufV :TGLBufferV<TSingle3D>;
    _BufC :TGLBufferV<TAlphaColorF>;
    _BufF :TGLBufferI<TCardinal3D>;
    _ShaV :TGLShaderV;
    _ShaF :TGLShaderF;
    _Prog :TGLProgram;
    _Arra :TGLArray;
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
          Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          MemoSVS.Lines.Assign( Source );
          MemoSVE.Lines.Assign( Error  );
     end;

     with _ShaF do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

          MemoSFS.Lines.Assign( Source );
          MemoSFE.Lines.Assign( Error  );
     end;

     ///// プログラム

     with _Prog do
     begin
          Attach( _ShaV );
          Attach( _ShaF );

          Link;

          MemoP.Lines.Assign( Error );
     end;

     ///// アレイ

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

procedure TForm1.DrawModel;
begin
     with _Arra do
     begin
          Bind;

            glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );

          Unbind;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
const
     C0 :Single = 0.1;
     C1 :Single = 1000;
begin
     _Angle := 0;

     _BufV := TGLBufferV<TSingle3D>   .Create;
     _BufC := TGLBufferV<TAlphaColorF>.Create;
     _BufF := TGLBufferI<TCardinal3D> .Create;

     _ShaV := TGLShaderV.Create;
     _ShaF := TGLShaderF.Create;
     _Prog := TGLProgram.Create;

     _Arra := TGLArray.Create;

     MakeModel;

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, C0, C1 );
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
            glOrtho( -4, +4, -2, +2, C0, C1 );
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
            glOrtho( -3, +3, -3, +3, C0, C1 );
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
            glFrustum( -4/8*C0, +4/8*C0,
                       -3/8*C0, +3/8*C0, C0, C1 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -8 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Arra.DisposeOf;

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

//------------------------------------------------------------------------------

procedure TForm1.MemoSVSChange(Sender: TObject);
begin
     with _ShaV do
     begin
          Source.Assign( MemoSVS.Lines );

          MemoSVE.Lines.Assign( Error );

          if Success then _Prog.Link
                     else TabControl1.TabIndex := 1;
     end;
end;

procedure TForm1.MemoSFSChange(Sender: TObject);
begin
     with _ShaF do
     begin
          Source.Assign( MemoSFS.Lines );

          MemoSFE.Lines.Assign( Error );

          if Success then _Prog.Link
                     else TabControl1.TabIndex := 1;
     end;
end;

end. //######################################################################### ■
