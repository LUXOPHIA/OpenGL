unit MYX.Matery;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
     LUX.GPU.OpenGL,
     LUX.GPU.OpenGL.GLView,
     LUX.GPU.OpenGL.Buffer,
     LUX.GPU.OpenGL.Buffer.Unifor,
     LUX.GPU.OpenGL.Buffer.Verter,
     LUX.GPU.OpenGL.Buffer.Elemer,
     LUX.GPU.OpenGL.Imager,
     LUX.GPU.OpenGL.Imager.FMX,
     LUX.GPU.OpenGL.Shader,
     LUX.GPU.OpenGL.Engine;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyMatery

     TMyMatery = class
     private
     protected
       _ShaderV :TGLShaderV;
       _ShaderF :TGLShaderF;
       _Engine  :TGLEngine;
       _Sample  :TGLSample;
       _Imager  :TGLImager2D_RGBA;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property ShaderV :TGLShaderV       read _ShaderV;
       property ShaderF :TGLShaderF       read _ShaderF;
       property Engine  :TGLEngine        read _Engine ;
       property Sample  :TGLSample        read _Sample ;
       property Imager  :TGLImager2D_RGBA read _Imager ;
       ///// メソッド
       procedure Use;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyMatery

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyMatery.Create;
begin
     inherited;

     _ShaderV := TGLShaderV      .Create;
     _ShaderF := TGLShaderF      .Create;
     _Engine  := TGLEngine       .Create;
     _Sample  := TGLSample       .Create;
     _Imager  := TGLImager2D_RGBA.Create;

     with _Engine do
     begin
          with Shaders do
          begin
               Add( _ShaderV{Shad} );
               Add( _ShaderF{Shad} );
          end;

          with Verters do
          begin
               Add( 0{BinP}, '_Vertex_Pos'{Name}, 3{EleN}, GL_FLOAT{EleT} );
               Add( 1{BinP}, '_Vertex_Nor'{Name}, 3{EleN}, GL_FLOAT{EleT} );
               Add( 2{BinP}, '_Vertex_Tex'{Name}, 2{EleN}, GL_FLOAT{EleT} );
          end;

          with Unifors do
          begin
               Add( 0{BinP}, 'TCameraDat'{Name} );
               Add( 1{BinP}, 'TShaperDat'{Name} );
          end;

          with Imagers do
          begin
               Add( 0{BinP}, '_Imager'{Name} );
          end;

          with Framers do
          begin
               Add( 0{BinP}, '_Frag_Col'{Name} );
          end;
     end;
end;

destructor TMyMatery.Destroy;
begin
     _Sample .DisposeOf;
     _Imager .DisposeOf;
     _Engine .DisposeOf;
     _ShaderV.DisposeOf;
     _ShaderF.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyMatery.Use;
begin
     _Engine.Use;

     _Sample.Use( 0{BinP} );
     _Imager.Use( 0{BinP} );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■