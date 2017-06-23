﻿unit LUX.GPU.OpenGL.Viewer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.M4, LUX.GPU.OpenGL, LUX.GPU.OpenGL.VCL, LUX.GPU.OpenGL.Buffer.Unifor, LUX.GPU.OpenGL.Camera;

type
  TGLViewer = class(TFrame)
  private
    { Private 宣言 }
    ///// メソッドU
    procedure WMPaint( var Message_:TWMPaint ); message WM_PAINT;
    procedure WMEraseBkgnd( var Message_:TWmEraseBkgnd ); message WM_ERASEBKGND;
  protected
    _DC     :HDC;
    _Viewer :TGLUnifor<TSingleM4>;
    _Camera :TGLCamera;
    ///// イベント
    _OnPaint :TProc;
    ///// メソッド
    procedure Resize; override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure CreateDC;
    procedure DestroyDC;
  public
    { Public 宣言 }
    constructor Create( AOwner_:TComponent ); override;
    destructor Destroy; override;
    ///// プロパティ
    property DC     :HDC       read _DC                  ;
    property Camera :TGLCamera read _Camera write _Camera;
    ///// イベント
    property OnPaint :TProc read _OnPaint write _OnPaint;
    ///// メソッド
    procedure RecreateDC;
    procedure BeginGL;
    procedure EndGL;
    procedure BeginRender;
    procedure EndRender;
  end;

implementation //############################################################### ■

{$R *.dfm}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLViewer.WMEraseBkgnd( var Message_:TWmEraseBkgnd );
begin
     ///// 背景描画を無効化
end;

procedure TGLViewer.WMPaint( var Message_:TWMPaint );
begin
     inherited;

     BeginRender;

       glViewport( 0, 0, ClientWidth, ClientHeight );

       if Assigned( _Camera ) then _Camera.Render;

       _OnPaint;

     EndRender;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLViewer.Resize;
begin
     inherited;

     if not( csDestroying in ComponentState ) then
     begin
          if Height < Width then _Viewer[ 0 ] := TSingleM4.Scale( Height / Width, 1, 1 )
                            else
          if Width < Height then _Viewer[ 0 ] := TSingleM4.Scale( 1, Width / Height, 1 )
                            else _Viewer[ 0 ] := TSingleM4.Identify;

          Self.Repaint;
     end;
end;

//------------------------------------------------------------------------------

procedure TGLViewer.CreateWnd;
begin
     inherited;

     CreateDC;
end;

procedure TGLViewer.DestroyWnd;
begin
     DestroyDC;

     inherited;
end;

//------------------------------------------------------------------------------

procedure TGLViewer.CreateDC;
begin
     _DC := GetDC( Handle );

     _OpenGL_.ApplyPixelFormat( _DC );
end;

procedure TGLViewer.DestroyDC;
begin
     ReleaseDC( Handle, _DC );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLViewer.Create( AOwner_:TComponent );
begin
     inherited;

     _OnPaint := procedure begin end;

     CreateDC;

     _Viewer := TGLUnifor<TSingleM4>.Create( GL_DYNAMIC_DRAW );
     _Viewer.Count := 1;
end;

destructor TGLViewer.Destroy;
begin
     _Viewer.DisposeOf;

     DestroyDC;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLViewer.RecreateDC;
begin
     Self.RecreateWnd;
end;

//------------------------------------------------------------------------------

procedure TGLViewer.BeginGL;
begin
     _OpenGL_.EndGL;

       wglMakeCurrent( _DC, _OpenGL_.RC );
end;

procedure TGLViewer.EndGL;
begin
       wglMakeCurrent( _DC, 0 );

     _OpenGL_.BeginGL;
end;

//------------------------------------------------------------------------------

procedure TGLViewer.BeginRender;
begin
     BeginGL;

       glClearColor( 0, 0, 0, 0 );

       glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT );

       _Viewer.Use( 0{BinP} );
end;

procedure TGLViewer.EndRender;
begin
       _Viewer.Unuse( 0{BinP} );

       glFlush;

       SwapBuffers( _DC );

     EndGL;
end;

end. //######################################################################### ■