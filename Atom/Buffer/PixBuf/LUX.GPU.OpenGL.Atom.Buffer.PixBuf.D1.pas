unit LUX.GPU.OpenGL.Atom.Buffer.PixBuf.D1;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX,
     LUX.GPU.OpenGL.Atom,
     LUX.GPU.OpenGL.Atom.Buffer,
     LUX.GPU.OpenGL.Atom.Textur,
     LUX.GPU.OpenGL.Atom.Buffer.PixBuf;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     IGLPixBuf1D                 = interface;
     TGLPixBuf1D<_TItem_:record> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPixBuf1D<_TItem_>

     IGLPixBuf1D = interface( IGLBuffer )
     ['{441F1A9D-EC3A-43DE-94D6-467ACF6AA0A8}']
     {protected}
       ///// アクセス
       function GetItemsX :Integer;
       procedure SetItemsX( const ItemsX_:Integer );
     {public}
       ///// プロパティ
       property ItemsX :Integer read GetItemsX write SetItemsX;
     end;

     //-------------------------------------------------------------------------

     TGLPixBuf1D<_TItem_:record> = class( TGLPixBuf<_TItem_>, IGLPixBuf1D )
     private
     protected
       _ItemsX :Integer;
       ///// アクセス
       function GetItemsX :Integer;
       procedure SetItemsX( const ItemsX_:Integer );
       ///// メソッド
       procedure MakeBuffer; virtual;
     public
       ///// プロパティ
       property ItemsX :Integer read GetItemsX write SetItemsX;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiPix1D<_TItem_>

     IGLPoiPix1D = interface( IGLPixBuf1D )
     ['{E9A6BD3C-D3F2-461E-8EF6-2224AB77E315}']
     {protected}
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
     {public}
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property CellsX :Integer read GetCellsX write SetCellsX;
     end;

     //-------------------------------------------------------------------------

     TGLPoiPix1D<_TItem_:record> = class( TGLPixBuf1D<_TItem_>, IGLPoiPix1D )
     private
     protected
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
     public
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property CellsX :Integer read GetCellsX write SetCellsX;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelPix1D<_TItem_>

     IGLCelPix1D = interface( IGLPixBuf1D )
     ['{89BBCE48-2D21-44D0-AC4D-B4ED6110B674}']
     {protected}
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
     {public}
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property CellsX :Integer read GetCellsX write SetCellsX;
     end;

     //-------------------------------------------------------------------------

     TGLCelPix1D<_TItem_:record> = class( TGLPixBuf1D<_TItem_>, IGLCelPix1D )
     private
     protected
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
     public
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property CellsX :Integer read GetCellsX write SetCellsX;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPixBuf1D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLPixBuf1D<_TItem_>.GetItemsX :Integer;
begin
     Result := _ItemsX;
end;

procedure TGLPixBuf1D<_TItem_>.SetItemsX( const ItemsX_:Integer );
begin
     _ItemsX := ItemsX_;  MakeBuffer;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPixBuf1D<_TItem_>.MakeBuffer;
begin
     Count := _ItemsX;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiPix1D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLPoiPix1D<_TItem_>.GetPoinsX :Integer;
begin
     Result := ItemsX;
end;

procedure TGLPoiPix1D<_TItem_>.SetPoinsX( const PoinsX_:Integer );
begin
     ItemsX := PoinsX_;
end;

//------------------------------------------------------------------------------

function TGLPoiPix1D<_TItem_>.GetCellsX :Integer;
begin
     Result := ItemsX - 1;
end;

procedure TGLPoiPix1D<_TItem_>.SetCellsX( const CellsX_:Integer );
begin
     ItemsX := CellsX_ + 1;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelPix1D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLCelPix1D<_TItem_>.GetPoinsX :Integer;
begin
     Result := ItemsX + 1;
end;

procedure TGLCelPix1D<_TItem_>.SetPoinsX( const PoinsX_:Integer );
begin
     ItemsX := PoinsX_ - 1;
end;

//------------------------------------------------------------------------------

function TGLCelPix1D<_TItem_>.GetCellsX :Integer;
begin
     Result := ItemsX;
end;

procedure TGLCelPix1D<_TItem_>.SetCellsX( const CellsX_:Integer );
begin
     ItemsX := CellsX_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■