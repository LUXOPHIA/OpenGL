unit LUX.GPU.OpenGL.Atom.Buffer.PixBuf.D3;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX,
     LUX.GPU.OpenGL.Atom,
     LUX.GPU.OpenGL.Atom.Buffer,
     LUX.GPU.OpenGL.Atom.Textur,
     LUX.GPU.OpenGL.Atom.Buffer.PixBuf,
     LUX.GPU.OpenGL.Atom.Buffer.PixBuf.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     IGLPixBuf3D                 = interface;
     TGLPixBuf3D<_TItem_:record> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPixBuf3D<_TItem_>

     IGLPixBuf3D = interface( IGLPixBuf2D )
     ['{68D24B25-0598-466A-BD4D-BBAFC369B5CD}']
     {protected}
       ///// アクセス
       function GetItemsZ :Integer;
       procedure SetItemsZ( const ItemsZ_:Integer );
     {public}
       ///// プロパティ
       property ItemsZ :Integer read GetItemsZ write SetItemsZ;
     end;

     //-------------------------------------------------------------------------

     TGLPixBuf3D<_TItem_:record> = class( TGLPixBuf2D<_TItem_>, IGLPixBuf3D )
     private
     protected
       _ItemsZ :Integer;
       ///// アクセス
       function GetItemsZ :Integer;
       procedure SetItemsZ( const ItemsZ_:Integer );
       ///// メソッド
       procedure MakeBuffer; override;
     public
       ///// プロパティ
       property ItemsZ :Integer read GetItemsZ write SetItemsZ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiPix3D<_TItem_>

     IGLPoiPix3D = interface( IGLPixBuf3D )
     ['{97C18089-90B8-4E43-9C6D-59737D6D555E}']
     {protected}
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetPoinsZ :Integer;
       procedure SetPoinsZ( const PoinsZ_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
       function GetCellsZ :Integer;
       procedure SetCellsZ( const CellsZ_:Integer );
     {public}
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property PoinsZ :Integer read GetPoinsZ write SetPoinsZ;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
       property CellsZ :Integer read GetCellsZ write SetCellsZ;
     end;

     //-------------------------------------------------------------------------

     TGLPoiPix3D<_TItem_:record> = class( TGLPixBuf3D<_TItem_>, IGLPoiPix3D )
     private
     protected
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetPoinsZ :Integer;
       procedure SetPoinsZ( const PoinsZ_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
       function GetCellsZ :Integer;
       procedure SetCellsZ( const CellsZ_:Integer );
     public
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property PoinsZ :Integer read GetPoinsZ write SetPoinsZ;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
       property CellsZ :Integer read GetCellsZ write SetCellsZ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelPix3D<_TItem_>

     IGLCelPix3D = interface( IGLPixBuf3D )
     ['{4ED06E66-A90B-4FE4-B8D9-742FAF6025FB}']
     {protected}
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetPoinsZ :Integer;
       procedure SetPoinsZ( const PoinsZ_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
       function GetCellsZ :Integer;
       procedure SetCellsZ( const CellsZ_:Integer );
     {public}
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property PoinsZ :Integer read GetPoinsZ write SetPoinsZ;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
       property CellsZ :Integer read GetCellsZ write SetCellsZ;
     end;

     //-------------------------------------------------------------------------

     TGLCelPix3D<_TItem_:record> = class( TGLPixBuf3D<_TItem_>, IGLCelPix3D )
     private
     protected
       ///// アクセス
       function GetPoinsX :Integer;
       procedure SetPoinsX( const PoinsX_:Integer );
       function GetPoinsY :Integer;
       procedure SetPoinsY( const PoinsY_:Integer );
       function GetPoinsZ :Integer;
       procedure SetPoinsZ( const PoinsZ_:Integer );
       function GetCellsX :Integer;
       procedure SetCellsX( const CellsX_:Integer );
       function GetCellsY :Integer;
       procedure SetCellsY( const CellsY_:Integer );
       function GetCellsZ :Integer;
       procedure SetCellsZ( const CellsZ_:Integer );
     public
       ///// プロパティ
       property PoinsX :Integer read GetPoinsX write SetPoinsX;
       property PoinsY :Integer read GetPoinsX write SetPoinsY;
       property PoinsZ :Integer read GetPoinsZ write SetPoinsZ;
       property CellsX :Integer read GetCellsX write SetCellsX;
       property CellsY :Integer read GetCellsX write SetCellsY;
       property CellsZ :Integer read GetCellsZ write SetCellsZ;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPixBuf3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLPixBuf3D<_TItem_>.GetItemsZ :Integer;
begin
     Result := _ItemsZ;
end;

procedure TGLPixBuf3D<_TItem_>.SetItemsZ( const ItemsZ_:Integer );
begin
     _ItemsZ := ItemsZ_;  MakeBuffer;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPixBuf3D<_TItem_>.MakeBuffer;
begin
     Count := _ItemsZ * _ItemsY * _ItemsX;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiPix3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLPoiPix3D<_TItem_>.GetPoinsX :Integer;
begin
     Result := ItemsX;
end;

procedure TGLPoiPix3D<_TItem_>.SetPoinsX( const PoinsX_:Integer );
begin
     ItemsX := PoinsX_;
end;

function TGLPoiPix3D<_TItem_>.GetPoinsY :Integer;
begin
     Result := ItemsY;
end;

procedure TGLPoiPix3D<_TItem_>.SetPoinsY( const PoinsY_:Integer );
begin
     ItemsY := PoinsY_;
end;

function TGLPoiPix3D<_TItem_>.GetPoinsZ :Integer;
begin
     Result := ItemsZ;
end;

procedure TGLPoiPix3D<_TItem_>.SetPoinsZ( const PoinsZ_:Integer );
begin
     ItemsZ := PoinsZ_;
end;

//------------------------------------------------------------------------------

function TGLPoiPix3D<_TItem_>.GetCellsX :Integer;
begin
     Result := ItemsX - 1;
end;

procedure TGLPoiPix3D<_TItem_>.SetCellsX( const CellsX_:Integer );
begin
     ItemsX := CellsX_ + 1;
end;

function TGLPoiPix3D<_TItem_>.GetCellsY :Integer;
begin
     Result := ItemsY - 1;
end;

procedure TGLPoiPix3D<_TItem_>.SetCellsY( const CellsY_:Integer );
begin
     ItemsY := CellsY_ + 1;
end;

function TGLPoiPix3D<_TItem_>.GetCellsZ :Integer;
begin
     Result := ItemsZ - 1;
end;

procedure TGLPoiPix3D<_TItem_>.SetCellsZ( const CellsZ_:Integer );
begin
     ItemsZ := CellsZ_ + 1;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelPix3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLCelPix3D<_TItem_>.GetPoinsX :Integer;
begin
     Result := ItemsX + 1;
end;

procedure TGLCelPix3D<_TItem_>.SetPoinsX( const PoinsX_:Integer );
begin
     ItemsX := PoinsX_ - 1;
end;

function TGLCelPix3D<_TItem_>.GetPoinsY :Integer;
begin
     Result := ItemsY + 1;
end;

procedure TGLCelPix3D<_TItem_>.SetPoinsY( const PoinsY_:Integer );
begin
     ItemsY := PoinsY_ - 1;
end;

function TGLCelPix3D<_TItem_>.GetPoinsZ :Integer;
begin
     Result := ItemsZ + 1;
end;

procedure TGLCelPix3D<_TItem_>.SetPoinsZ( const PoinsZ_:Integer );
begin
     ItemsZ := PoinsZ_ - 1;
end;

//------------------------------------------------------------------------------

function TGLCelPix3D<_TItem_>.GetCellsX :Integer;
begin
     Result := ItemsX;
end;

procedure TGLCelPix3D<_TItem_>.SetCellsX( const CellsX_:Integer );
begin
     ItemsX := CellsX_;
end;

function TGLCelPix3D<_TItem_>.GetCellsY :Integer;
begin
     Result := ItemsY;
end;

procedure TGLCelPix3D<_TItem_>.SetCellsY( const CellsY_:Integer );
begin
     ItemsY := CellsY_;
end;

function TGLCelPix3D<_TItem_>.GetCellsZ :Integer;
begin
     Result := ItemsZ;
end;

procedure TGLCelPix3D<_TItem_>.SetCellsZ( const CellsZ_:Integer );
begin
     ItemsZ := CellsZ_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■