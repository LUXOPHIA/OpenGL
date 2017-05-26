﻿unit LUX.GPU.OpenGL.Buffer.Elem;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D3, LUX.GPU.OpenGL, LUX.GPU.OpenGL.Buffer;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLBufferE<_TYPE_>

     IGLBufferE = interface( IGLBuffer )
     ['{BCD91AB4-D6E5-49E1-8670-D4C4ED39AFD3}']
       ///// アクセス
       function GetElemT :GLenum;
       ///// プロパティ
       property ElemT :GLenum read GetElemT;
       ///// メソッド
       procedure Draw;
     end;

     //-------------------------------------------------------------------------

     TGLBufferE<_TYPE_:record> = class( TGLBuffer<_TYPE_>, IGLBufferE )
     private
     protected
       ///// アクセス
       function GetKind :GLenum; override;
       function GetElemT :GLenum;
     public
       ///// プロパティ
       property ElemT :GLenum read GetElemT;
       ///// メソッド
       procedure Draw;
     end;

     TGLBufferE8  = TGLBufferE<TByte3D>;
     TGLBufferE16 = TGLBufferE<TWord3D>;
     TGLBufferE32 = TGLBufferE<TCardinal3D>;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLBufferE<_TYPE_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLBufferE<_TYPE_>.GetKind :GLenum;
begin
     Result := GL_ELEMENT_ARRAY_BUFFER;
end;

function TGLBufferE<_TYPE_>.GetElemT :GLenum;
begin
     case  SizeOf( _TYPE_ ) of
       3: Result := GL_UNSIGNED_BYTE;
       6: Result := GL_UNSIGNED_SHORT;
      12: Result := GL_UNSIGNED_INT;
     else Assert( False, 'Unkown Type!' );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLBufferE<_TYPE_>.Draw;
begin
     Bind;

       glDrawElements( GL_TRIANGLES, 3{Poin} * _Count, GetElemT, nil );

     Unbind;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■