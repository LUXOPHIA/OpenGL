﻿unit LUX.GPU.OpenGL.Atom.Imager;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX,
     LUX.Data.Lattice,
     LUX.GPU.OpenGL.Atom,
     LUX.GPU.OpenGL.Atom.Buffer.PixBuf;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLImager<_TItem_,_TGrider_,_TPixBuf_>

     IGLImager = interface( IGLAtomer )
     ['{E2F97606-18B0-4E45-88D2-ABE16446AD6F}']
       ///// アクセス
       function GetKind :GLenum;
       procedure SetKind( const Kind_:GLenum );
       function GetTexelF :GLenum;
       procedure SetTexelF( const TexelF_:GLenum );
       function GetPixelF :GLenum;
       procedure SetPixelF( const PixelF_:GLenum );
       function GetPixelT :GLenum;
       procedure SetPixelT( const PixelT_:GLenum );
       ///// プロパティ
       property Kind   :GLenum read GetKind   write SetKind  ;
       property TexelF :GLenum read GetTexelF write SetTexelF;
       property PixelF :GLenum read GetPixelF write SetPixelF;
       property PixelT :GLenum read GetPixelT write SetPixelT;
       /////メソッド
       procedure Bind;
       procedure Unbind;
       procedure Use( const BindI_:GLuint );
       procedure Unuse( const BindI_:GLuint );
       procedure UseComput( const BindI_:GLuint );
       procedure UnuseComput( const BindI_:GLuint );
       procedure SendData;
       procedure ReceData;
       procedure SendPixBuf;
       procedure RecePixBuf;
       procedure CopyFrom( const PixBuf_:IGLPixBuf ); overload;
       procedure CopyTo( const PixBuf_:IGLPixBuf ); overload;
     end;

     //-------------------------------------------------------------------------

     TGLImager<_TItem_  :record;
               _TGrider_:TCoreArray<_TItem_>,constructor;
               _TPixBuf_:TGLPixBuf<_TItem_> ,constructor> = class( TGLAtomer, IGLImager )
     private
     protected
       _Grider :_TGrider_;
       _Kind   :GLenum;
       _TexelF :GLenum;
       _PixelF :GLenum;
       _PixelT :GLenum;
       _PixBuf :_TPixBuf_;
       ///// アクセス
       function GetKind :GLenum;
       procedure SetKind( const Kind_:GLenum );
       function GetTexelF :GLenum;
       procedure SetTexelF( const TexelF_:GLenum ); virtual;
       function GetPixelF :GLenum;
       procedure SetPixelF( const PixelF_:GLenum );
       function GetPixelT :GLenum;
       procedure SetPixelT( const PixelT_:GLenum );
     public
       constructor Create( const Kind_:GLenum );
       destructor Destroy; override;
       ///// プロパティ
       property Grider :_TGrider_ read   _Grider                ;
       property Kind   :GLenum    read GetKind   write SetKind  ;
       property TexelF :GLenum    read GetTexelF write SetTexelF;
       property PixelF :GLenum    read GetPixelF write SetPixelF;
       property PixelT :GLenum    read GetPixelT write SetPixelT;
       property PixBuf :_TPixBuf_ read   _PixBuf                ;
       ///// メソッド
       procedure Bind;
       procedure Unbind;
       procedure Use( const BindI_:GLuint ); virtual;
       procedure Unuse( const BindI_:GLuint ); virtual;
       procedure UseComput( const BindI_:GLuint );
       procedure UnuseComput( const BindI_:GLuint );
       procedure SendData; virtual; abstract;
       procedure ReceData;
       procedure SendPixBuf; virtual; abstract;
       procedure RecePixBuf;
       procedure CopyFrom( const PixBuf_:IGLPixBuf ); overload;
       procedure CopyTo( const PixBuf_:IGLPixBuf ); overload;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLImager

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLImager<_TItem_,_TGrider_,_TPixBuf_>.GetKind :GLenum;
begin
     Result := _Kind;
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.SetKind( const Kind_:GLenum );
begin
     _Kind := Kind_;
end;

function TGLImager<_TItem_,_TGrider_,_TPixBuf_>.GetTexelF :GLenum;
begin
     Result := _TexelF;
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.SetTexelF( const TexelF_:GLenum );
begin
     _TexelF := TexelF_;
end;

function TGLImager<_TItem_,_TGrider_,_TPixBuf_>.GetPixelF :GLenum;
begin
     Result := _PixelF;
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.SetPixelF( const PixelF_:GLenum );
begin
     _PixelF := PixelF_;
end;

function TGLImager<_TItem_,_TGrider_,_TPixBuf_>.GetPixelT :GLenum;
begin
     Result := _PixelT;
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.SetPixelT( const PixelT_:GLenum );
begin
     _PixelT := PixelT_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLImager<_TItem_,_TGrider_,_TPixBuf_>.Create( const Kind_:GLenum );
begin
     inherited Create;

     glGenTextures( 1, @_ID );

     _Grider := _TGrider_.Create;

     _Kind := Kind_;

     Bind;
       glTexParameteri( _Kind, GL_TEXTURE_MAX_LEVEL, 0 );
     Unbind;

     _PixBuf := _TPixBuf_.Create;  _PixBuf.Usage := GL_DYNAMIC_DRAW;
end;

destructor TGLImager<_TItem_,_TGrider_,_TPixBuf_>.Destroy;
begin
     _PixBuf.DisposeOf;

     _Grider.DisposeOf;

     glDeleteTextures( 1, @_ID );

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.Bind;
begin
     glBindTexture( _Kind, _ID );
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.Unbind;
begin
     glBindTexture( _Kind, 0 );
end;

//------------------------------------------------------------------------------

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.Use( const BindI_:GLuint );
begin
     glActiveTexture( GL_TEXTURE0 + BindI_ );

       Bind;

     glActiveTexture( GL_TEXTURE0 );
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.Unuse( const BindI_:GLuint );
begin
     glActiveTexture( GL_TEXTURE0 + BindI_ );

       Unbind;

     glActiveTexture( GL_TEXTURE0 );
end;

//------------------------------------------------------------------------------

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.UseComput( const BindI_:GLuint );
begin
     glBindImageTexture( BindI_, ID, 0, GL_FALSE, 0, GL_READ_WRITE, _TexelF );
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.UnuseComput( const BindI_:GLuint );
begin
     glBindImageTexture( BindI_, 0, 0, GL_FALSE, 0, GL_READ_WRITE, _TexelF );
end;

//------------------------------------------------------------------------------

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.ReceData;
begin
     Bind;
       glGetTexImage( _Kind, 0, _PixelF, _PixelT, _Grider.Elem0P );
     Unbind;
end;

//------------------------------------------------------------------------------

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.RecePixBuf;
begin
     Bind;
       glGetTexImage( _Kind, 0, _PixelF, _PixelT, nil );
     Unbind;
end;

//------------------------------------------------------------------------------

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.CopyFrom( const PixBuf_:IGLPixBuf );
begin
     PixBuf_.BindRead;

     SendPixBuf;

     PixBuf_.UnbindRead;
end;

procedure TGLImager<_TItem_,_TGrider_,_TPixBuf_>.CopyTo( const PixBuf_:IGLPixBuf );
begin
     PixBuf_.BindWrite;

     RecePixBuf;

     PixBuf_.UnbindWrite;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■