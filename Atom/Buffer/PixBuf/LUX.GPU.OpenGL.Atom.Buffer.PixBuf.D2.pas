unit LUX.GPU.OpenGL.Atom.Buffer.PixBuf.D2;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX,
     LUX.GPU.OpenGL.Atom,
     LUX.GPU.OpenGL.Atom.Buffer,
     LUX.GPU.OpenGL.Atom.Textur,
     LUX.GPU.OpenGL.Atom.Buffer.PixBuf,
     LUX.GPU.OpenGL.Atom.Buffer.PixBuf.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     IGLPixBuf2D                 = interface;
     TGLPixBuf2D<_TItem_:record> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPixBuf2D<_TItem_>

     IGLPixBuf2D = interface( IGLPixBuf1D )
     ['{127179DF-CB40-4505-8805-59C0E3A6E411}']
     {protected}
       ///// アクセス
       function GetItemsY :Integer;
       procedure SetItemsY( const ItemsY_:Integer );
     {public}
       ///// プロパティ
       property ItemsY :Integer read GetItemsY write SetItemsY;
     end;

     //-------------------------------------------------------------------------

     TGLPixBuf2D<_TItem_:record> = class( TGLPixBuf1D<_TItem_>, IGLPixBuf2D )
     private
     protected
       _ItemsY :Integer;
       ///// アクセス
       function GetItemsY :Integer;
       procedure SetItemsY( const ItemsY_:Integer );
       ///// メソッド
       procedure MakeBuffer; override;
     public
       ///// プロパティ
       property ItemsY :Integer read GetItemsY write SetItemsY;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiPix2D<_TItem_>

     IGLPoiPix2D = interface( IGLPixBuf2D )
     ['{2BEE5402-3221-44CF-9278-5D489B0CAC4A}']
     {protected}
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
     {public}
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
     end;

     //-------------------------------------------------------------------------

     TGLPoiPix2D<_TItem_:record> = class( TGLPixBuf2D<_TItem_>, IGLPoiPix2D )
     private
     protected
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
     public
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelPix2D<_TItem_>

     IGLCelPix2D = interface( IGLPixBuf2D )
     ['{D44A1241-907E-4167-8E1D-F2A473767526}']
     {protected}
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
     {public}
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
     end;

     //-------------------------------------------------------------------------

     TGLCelPix2D<_TItem_:record> = class( TGLPixBuf2D<_TItem_>, IGLCelPix2D )
     private
     protected
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
     public
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPixBuf2D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLPixBuf2D<_TItem_>.GetItemsY :Integer;
begin
     Result := _ItemsY;
end;

procedure TGLPixBuf2D<_TItem_>.SetItemsY( const ItemsY_:Integer );
begin
     _ItemsY := ItemsY_;  MakeBuffer;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPixBuf2D<_TItem_>.MakeBuffer;
begin
     Count := _ItemsY * _ItemsX;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiPix2D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLPoiPix2D<_TItem_>.GetPoinsX :Integer;
begin
     Result := ItemsX;
end;

procedure TGLPoiPix2D<_TItem_>.SetPoinsX( const PoinsX_:Integer );
begin
     ItemsX := PoinsX_;
end;

function TGLPoiPix2D<_TItem_>.GetPoinsY :Integer;
begin
     Result := ItemsY;
end;

procedure TGLPoiPix2D<_TItem_>.SetPoinsY( const PoinsY_:Integer );
begin
     ItemsY := PoinsY_;
end;

//------------------------------------------------------------------------------

function TGLPoiPix2D<_TItem_>.GetCellsX :Integer;
begin
     Result := ItemsX - 1;
end;

procedure TGLPoiPix2D<_TItem_>.SetCellsX( const CellsX_:Integer );
begin
     ItemsX := CellsX_ + 1;
end;

function TGLPoiPix2D<_TItem_>.GetCellsY :Integer;
begin
     Result := ItemsY - 1;
end;

procedure TGLPoiPix2D<_TItem_>.SetCellsY( const CellsY_:Integer );
begin
     ItemsY := CellsY_ + 1;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelPix2D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLCelPix2D<_TItem_>.GetPoinsX :Integer;
begin
     Result := ItemsX + 1;
end;

procedure TGLCelPix2D<_TItem_>.SetPoinsX( const PoinsX_:Integer );
begin
     ItemsX := PoinsX_ - 1;
end;

function TGLCelPix2D<_TItem_>.GetPoinsY :Integer;
begin
     Result := ItemsY + 1;
end;

procedure TGLCelPix2D<_TItem_>.SetPoinsY( const PoinsY_:Integer );
begin
     ItemsY := PoinsY_ - 1;
end;

//------------------------------------------------------------------------------

function TGLCelPix2D<_TItem_>.GetCellsX :Integer;
begin
     Result := ItemsX;
end;

procedure TGLCelPix2D<_TItem_>.SetCellsX( const CellsX_:Integer );
begin
     ItemsX := CellsX_;
end;

function TGLCelPix2D<_TItem_>.GetCellsY :Integer;
begin
     Result := ItemsY;
end;

procedure TGLCelPix2D<_TItem_>.SetCellsY( const CellsY_:Integer );
begin
     ItemsY := CellsY_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■