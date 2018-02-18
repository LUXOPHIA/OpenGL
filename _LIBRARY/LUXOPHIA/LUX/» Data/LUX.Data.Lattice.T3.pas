unit LUX.Data.Lattice.T3;

interface //#################################################################### ■

uses System.SysUtils, System.Classes,
     LUX, LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TArray3D<_TItem_>     = class;
     TBricArray3D<_TItem_> = class;
     TGridArray3D<_TItem_> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TArray3D<_TItem_>

     IArray3D = interface
     ['{2ED01C38-BB77-4958-83DE-E4F723A74774}']
       ///// アクセス
       function GetElemsX :Integer;
       function GetElemsY :Integer;
       function GetElemsZ :Integer;
       function GetItemsX :Integer;
       procedure SetItemsX( const ItemsX_:Integer );
       function GetItemsY :Integer;
       procedure SetItemsY( const ItemsY_:Integer );
       function GetItemsZ :Integer;
       procedure SetItemsZ( const ItemsZ_:Integer );
       function GetMargsX :Integer;
       procedure SetMargsX( const MargsX_:Integer );
       function GetMargsY :Integer;
       procedure SetMargsY( const MargsY_:Integer );
       function GetMargsZ :Integer;
       procedure SetMargsZ( const MargsZ_:Integer );
       ///// プロパティ
       property ElemsX :Integer read GetElemsX                ;
       property ElemsY :Integer read GetElemsY                ;
       property ElemsZ :Integer read GetElemsZ                ;
       property ItemsX :Integer read GetItemsX write SetItemsX;
       property ItemsY :Integer read GetItemsY write SetItemsY;
       property ItemsZ :Integer read GetItemsZ write SetItemsZ;
       property MargsX :Integer read GetMargsX write SetMargsX;
       property MargsY :Integer read GetMargsY write SetMargsY;
       property MargsZ :Integer read GetMargsZ write SetMargsZ;
     end;

     //-------------------------------------------------------------------------

     TArray3D<_TItem_> = class( TInterfacedBase, IArray3D )
     public type
       _PItem_ = ^_TItem_;
     private
       ///// メソッド
       procedure MakeArray; virtual;
       function XYZtoI( const X_,Y_,Z_:Integer ) :Integer; inline;
     protected
       _Items  :TArray<_TItem_>;
       _ElemsX :Integer;
       _ElemsY :Integer;
       _ElemsZ :Integer;
       _ItemsX :Integer;
       _ItemsY :Integer;
       _ItemsZ :Integer;
       _MargsX :Integer;
       _MargsY :Integer;
       _MargsZ :Integer;
       ///// イベント
       _OnChange :TNotifyEvent;
       ///// アクセス
       function GetItems( const X_,Y_,Z_:Integer ) :_TItem_;
       procedure SetItems( const X_,Y_,Z_:Integer; const Item_:_TItem_ );
       function GetItemP( const X_,Y_,Z_:Integer ) :_PItem_;
       function GetElemsX :Integer;
       function GetElemsY :Integer;
       function GetElemsZ :Integer;
       function GetItemsX :Integer;
       procedure SetItemsX( const ItemsX_:Integer );
       function GetItemsY :Integer;
       procedure SetItemsY( const ItemsY_:Integer );
       function GetItemsZ :Integer;
       procedure SetItemsZ( const ItemsZ_:Integer );
       function GetMargsX :Integer;
       procedure SetMargsX( const MargsX_:Integer );
       function GetMargsY :Integer;
       procedure SetMargsY( const MargsY_:Integer );
       function GetMargsZ :Integer;
       procedure SetMargsZ( const MargsZ_:Integer );
       function GetItemSize :Integer;
       function GetTotalN :Integer;
       function GetTotalSize :Integer;

       function GetLines( const Y_,Z_:Integer ) :PByteArray;
       function GetLineSize :Integer;
       function GetStepX :Integer;
       function GetStepY :Integer;
       function GetStepZ :Integer;
       function GetElemStepX :Integer;
       function GetElemStepY :Integer;
       function GetElemStepZ :Integer;
     public
       constructor Create; overload;
       constructor Create( const ItemsX_,ItemsY_,ItemsZ_:Integer ); overload;
       constructor Create( const ItemsX_,ItemsY_,ItemsZ_,Margs_:Integer ); overload;
       constructor Create( const ItemsX_,ItemsY_,ItemsZ_,MargsX_,MargsY_,MargsZ_:Integer ); overload; virtual;
       procedure AfterConstruction; override;
       destructor Destroy; override;
       ///// プロパティ
       property Items[ const X_,Y_,Z_:Integer ] :_TItem_    read GetItems    write SetItems ; default;
       property ItemP[ const X_,Y_,Z_:Integer ] :_PItem_    read GetItemP                   ;
       property ElemsX                          :Integer    read GetElemsX                  ;
       property ElemsY                          :Integer    read GetElemsY                  ;
       property ElemsZ                          :Integer    read GetElemsZ                  ;
       property ItemsX                          :Integer    read GetItemsX   write SetItemsX;
       property ItemsY                          :Integer    read GetItemsY   write SetItemsY;
       property ItemsZ                          :Integer    read GetItemsZ   write SetItemsZ;
       property MargsX                          :Integer    read GetMargsX   write SetMargsX;
       property MargsY                          :Integer    read GetMargsY   write SetMargsY;
       property MargsZ                          :Integer    read GetMargsZ   write SetMargsZ;

       property ItemSize                        :Integer    read GetItemSize                ;
       property TotalN                          :Integer    read GetTotalN                  ;
       property TotalSize                       :Integer    read GetTotalSize               ;

       property Lines[ const Y_,Z_:Integer ]    :PByteArray read GetLines                   ;
       property LineSize                        :Integer    read GetLineSize                ;
       property StepX                           :Integer    read GetStepX                   ;
       property StepY                           :Integer    read GetStepY                   ;
       property StepZ                           :Integer    read GetStepZ                   ;
       property ElemStepX                       :Integer    read GetElemStepX               ;
       property ElemStepY                       :Integer    read GetElemStepY               ;
       property ElemStepZ                       :Integer    read GetElemStepZ               ;
       ///// イベント
       property OnChange :TNotifyEvent read _OnChange write _OnChange;
       ///// メソッド
       class procedure Swap( var Array0_,Array1_:TArray3D<_TItem_> ); static;
       procedure Read( const Stream_:TStream ); virtual;
       procedure Write( const Stream_:TStream ); virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBricArray3D<_TItem_>

     IBricArray3D = interface( IArray3D )
     ['{40BD11E7-4BF9-43F3-BE98-846C78B22EFD}']
       ///// アクセス
       function GetGridsX :Integer;
       procedure SetGridsX( const GridX_:Integer );
       function GetGridsY :Integer;
       procedure SetGridsY( const GridY_:Integer );
       function GetGridsZ :Integer;
       procedure SetGridsZ( const GridZ_:Integer );
       ///// プロパティ
       property BricsX :Integer read GetItemsX write SetItemsX;
       property BricsY :Integer read GetItemsY write SetItemsY;
       property BricsZ :Integer read GetItemsZ write SetItemsZ;
       property GridsX :Integer read GetGridsX write SetGridsX;
       property GridsY :Integer read GetGridsY write SetGridsY;
       property GridsZ :Integer read GetGridsZ write SetGridsZ;
     end;

     TBricArray3D<_TItem_> = class( TArray3D<_TItem_>, IBricArray3D )
     private
     protected
       ///// アクセス
       function GetGridsX :Integer;
       procedure SetGridsX( const GridX_:Integer );
       function GetGridsY :Integer;
       procedure SetGridsY( const GridY_:Integer );
       function GetGridsZ :Integer;
       procedure SetGridsZ( const GridZ_:Integer );
     public
       ///// プロパティ
       property Brics[ const X_,Y_,Z_:Integer ] :_TItem_ read GetItems  write SetItems ; default;
       property BricsX                          :Integer read GetItemsX write SetItemsX;
       property BricsY                          :Integer read GetItemsY write SetItemsY;
       property BricsZ                          :Integer read GetItemsZ write SetItemsZ;
       property GridsX                          :Integer read GetGridsX write SetGridsX;
       property GridsY                          :Integer read GetGridsY write SetGridsY;
       property GridsZ                          :Integer read GetGridsZ write SetGridsZ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGridArray3D<_TItem_>

     IGridArray3D = interface( IArray3D )
     ['{60135172-47A4-4183-8CE9-B590E8F21835}']
       ///// アクセス
       function GetBricsX :Integer;
       procedure SetBricsX( const BricsX_:Integer );
       function GetBricsY :Integer;
       procedure SetBricsY( const BricsY_:Integer );
       function GetBricsZ :Integer;
       procedure SetBricsZ( const BricsZ_:Integer );
       ///// プロパティ
       property GridsX :Integer read GetItemsX write SetItemsX;
       property GridsY :Integer read GetItemsY write SetItemsY;
       property GridsZ :Integer read GetItemsZ write SetItemsZ;
       property BricsX :Integer read GetBricsX write SetBricsX;
       property BricsY :Integer read GetBricsY write SetBricsY;
       property BricsZ :Integer read GetBricsZ write SetBricsZ;
     end;

     TGridArray3D<_TItem_> = class( TArray3D<_TItem_>, IGridArray3D )
     private
     protected
       ///// アクセス
       function GetBricsX :Integer;
       procedure SetBricsX( const BricsX_:Integer );
       function GetBricsY :Integer;
       procedure SetBricsY( const BricsY_:Integer );
       function GetBricsZ :Integer;
       procedure SetBricsZ( const BricsZ_:Integer );
     public
       constructor Create( const BricsX_,BricsY_,BricsZ_,MargsX_,MargsY_,MargsZ_:Integer ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Grids[ const X_,Y_,Z_:Integer ] :_TItem_ read GetItems  write SetItems ; default;
       property GridsX                          :Integer read GetItemsX write SetItemsX;
       property GridsY                          :Integer read GetItemsY write SetItemsY;
       property GridsZ                          :Integer read GetItemsZ write SetItemsZ;
       property BricsX                          :Integer read GetBricsX write SetBricsX;
       property BricsY                          :Integer read GetBricsY write SetBricsY;
       property BricsZ                          :Integer read GetBricsZ write SetBricsZ;
       ///// メソッド
       procedure Read( const Stream_:TStream ); override;
       procedure Write( const Stream_:TStream ); override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBricIterGridArray3D<_TItem_>

     IBricIterGridArray3D<_TItem_> = interface
     ['{F5FE2821-AAE8-4D83-9732-956556A2E7C2}']
     {protected}
       function GetPos :TInteger3D;
       procedure SetPos( const Pos_:TInteger3D );
       function GetGrids( const X_,Y_,Z_:Shortint ) :_TItem_;
       procedure SetGrids( const X_,Y_,Z_:Shortint; const Item_:_TItem_ );
       function GetGX( const I_:Shortint ) :Integer;
       function GetGY( const I_:Shortint ) :Integer;
       function GetGZ( const I_:Shortint ) :Integer;
     {public}
       property Pos                              :TInteger3D read GetPos   write SetPos  ;
       property Grids[ const X_,Y_,Z_:Shortint ] :_TItem_    read GetGrids write SetGrids; default;
       property GX[ const I_:Shortint ]          :Integer    read GetGX;
       property GY[ const I_:Shortint ]          :Integer    read GetGY;
       property GZ[ const I_:Shortint ]          :Integer    read GetGZ;
       ///// メソッド
       procedure GoPrevX; overload;
       procedure GoNextX; overload;
       procedure GoPrevY; overload;
       procedure GoNextY; overload;
       procedure GoPrevZ; overload;
       procedure GoNextZ; overload;
       procedure GoPrevX( const N_:Integer ); overload;
       procedure GoNextX( const N_:Integer ); overload;
       procedure GoPrevY( const N_:Integer ); overload;
       procedure GoNextY( const N_:Integer ); overload;
       procedure GoPrevZ( const N_:Integer ); overload;
       procedure GoNextZ( const N_:Integer ); overload;
     end;

     //-------------------------------------------------------------------------

     TBricIterGridArray3D<_TItem_> = class( TInterfacedObject, IBricIterGridArray3D<_TItem_> )
     private
     protected type
       _PItem_ = ^_TItem_;
     protected
       _Array :TGridArray3D<_TItem_>;
       _Grids :array [ -1..+2, -1..+2, -1..+2 ] of _PItem_;
       _GX    :array [ -1..+2 ] of Integer;
       _GY    :array [ -1..+2 ] of Integer;
       _GZ    :array [ -1..+2 ] of Integer;
       ///// アクセス
       function GetPos :TInteger3D;
       procedure SetPos( const Pos_:TInteger3D );
       function GetGrids( const X_,Y_,Z_:Shortint ) :_TItem_;
       procedure SetGrids( const X_,Y_,Z_:Shortint; const Item_:_TItem_ );
       function GetGX( const I_:Shortint ) :Integer;
       function GetGY( const I_:Shortint ) :Integer;
       function GetGZ( const I_:Shortint ) :Integer;
     public
       constructor Create( const Array_:TGridArray3D<_TItem_> );
       destructor Destroy; override;
       ///// プロパティ
       property Pos                              :TInteger3D read GetPos   write SetPos  ;
       property Grids[ const X_,Y_,Z_:Shortint ] :_TItem_    read GetGrids write SetGrids; default;
       property GX[ const I_:Shortint ]          :Integer    read GetGX                  ;
       property GY[ const I_:Shortint ]          :Integer    read GetGY                  ;
       property GZ[ const I_:Shortint ]          :Integer    read GetGZ                  ;
       ///// メソッド
       procedure GoPrevX; overload;
       procedure GoNextX; overload;
       procedure GoPrevY; overload;
       procedure GoNextY; overload;
       procedure GoPrevZ; overload;
       procedure GoNextZ; overload;
       procedure GoPrevX( const N_:Integer ); overload;
       procedure GoNextX( const N_:Integer ); overload;
       procedure GoPrevY( const N_:Integer ); overload;
       procedure GoNextY( const N_:Integer ); overload;
       procedure GoPrevZ( const N_:Integer ); overload;
       procedure GoNextZ( const N_:Integer ); overload;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TArray3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TArray3D<_TItem_>.MakeArray;
begin
     _ElemsX := _MargsX + _ItemsX + _MargsX;
     _ElemsY := _MargsY + _ItemsY + _MargsY;
     _ElemsZ := _MargsZ + _ItemsZ + _MargsZ;

     SetLength( _Items, GetTotalN );
end;

function TArray3D<_TItem_>.XYZtoI( const X_,Y_,Z_:Integer ) :Integer;
begin
     Result := ( ( _MargsZ + Z_ ) * _ElemsY + ( _MargsY + Y_ ) ) * _ElemsX + ( _MargsX + X_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TArray3D<_TItem_>.GetItems( const X_,Y_,Z_:Integer ) :_TItem_;
begin
     Result := _Items[ XYZtoI( X_, Y_, Z_ ) ];
end;

procedure TArray3D<_TItem_>.SetItems( const X_,Y_,Z_:Integer; const Item_:_TItem_ );
begin
     _Items[ XYZtoI( X_, Y_, Z_ ) ] := Item_;
end;

function TArray3D<_TItem_>.GetItemP( const X_,Y_,Z_:Integer ) :_PItem_;
begin
     Result := @_Items[ XYZtoI( X_, Y_, Z_ ) ];
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetElemsX :Integer;
begin
     Result := _ElemsX;
end;

function TArray3D<_TItem_>.GetElemsY :Integer;
begin
     Result := _ElemsY;
end;

function TArray3D<_TItem_>.GetElemsZ :Integer;
begin
     Result := _ElemsZ;
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetItemsX :Integer;
begin
     Result := _ItemsX;
end;

procedure TArray3D<_TItem_>.SetItemsX( const ItemsX_:Integer );
begin
     _ItemsX := ItemsX_;  MakeArray;
end;

function TArray3D<_TItem_>.GetItemsY :Integer;
begin
     Result := _ItemsY;
end;

procedure TArray3D<_TItem_>.SetItemsY( const ItemsY_:Integer );
begin
     _ItemsY := ItemsY_;  MakeArray;
end;

function TArray3D<_TItem_>.GetItemsZ :Integer;
begin
     Result := _ItemsZ;
end;

procedure TArray3D<_TItem_>.SetItemsZ( const ItemsZ_:Integer );
begin
     _ItemsZ := ItemsZ_;  MakeArray;
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetMargsX :Integer;
begin
     Result := _MargsX;
end;

procedure TArray3D<_TItem_>.SetMargsX( const MargsX_:Integer );
begin
     _MargsX := MargsX_;  MakeArray;
end;

function TArray3D<_TItem_>.GetMargsY :Integer;
begin
     Result := _MargsY;
end;

procedure TArray3D<_TItem_>.SetMargsY( const MargsY_:Integer );
begin
     _MargsY := MargsY_;  MakeArray;
end;

function TArray3D<_TItem_>.GetMargsZ :Integer;
begin
     Result := _MargsZ;
end;

procedure TArray3D<_TItem_>.SetMargsZ( const MargsZ_:Integer );
begin
     _MargsZ := MargsZ_;  MakeArray;
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetItemSize :Integer;
begin
     Result := SizeOf( _TItem_ );
end;

function TArray3D<_TItem_>.GetTotalN :Integer;
begin
     Result := _ElemsZ * _ElemsY * _ElemsX;
end;

function TArray3D<_TItem_>.GetTotalSize :Integer;
begin
     Result := GetTotalN * GetItemSize;
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetLines( const Y_,Z_:Integer ) :PByteArray;
begin
     Result := @_Items[ XYZtoI( 0, Y_, Z_ ) ];
end;

function TArray3D<_TItem_>.GetLineSize :Integer;
begin
     Result := GetItemSize * _ItemsX;
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetStepX :Integer;
begin
     Result := GetItemSize;
end;

function TArray3D<_TItem_>.GetStepY :Integer;
begin
     Result := GetStepX * _ElemsX;
end;

function TArray3D<_TItem_>.GetStepZ :Integer;
begin
     Result := GetStepY * _ElemsY;
end;

//------------------------------------------------------------------------------

function TArray3D<_TItem_>.GetElemStepX :Integer;
begin
     Result := 1;
end;

function TArray3D<_TItem_>.GetElemStepY :Integer;
begin
     Result := GetElemStepX * _ElemsX;
end;

function TArray3D<_TItem_>.GetElemStepZ :Integer;
begin
     Result := GetElemStepY * _ElemsY;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TArray3D<_TItem_>.Create;
begin
     Create( 0, 0, 0 );
end;

constructor TArray3D<_TItem_>.Create( const ItemsX_,ItemsY_,ItemsZ_:Integer );
begin
     Create( ItemsX_, ItemsY_, ItemsZ_, 0 );
end;

constructor TArray3D<_TItem_>.Create( const ItemsX_,ItemsY_,ItemsZ_,Margs_:Integer );
begin
     Create( ItemsX_, ItemsY_, ItemsZ_, Margs_, Margs_, Margs_ );
end;

constructor TArray3D<_TItem_>.Create( const ItemsX_,ItemsY_,ItemsZ_,MargsX_,MargsY_,MargsZ_:Integer );
begin
     inherited Create;

     _ItemsX := ItemsX_;
     _ItemsY := ItemsY_;
     _ItemsZ := ItemsZ_;
     _MargsX := MargsX_;
     _MargsY := MargsY_;
     _MargsZ := MargsZ_;
end;

procedure TArray3D<_TItem_>.AfterConstruction;
begin
     MakeArray;
end;

destructor TArray3D<_TItem_>.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

class procedure TArray3D<_TItem_>.Swap( var Array0_,Array1_:TArray3D<_TItem_> );
var
   A :TArray3D<_TItem_>;
begin
     A := Array0_;  Array0_ := Array1_;  Array1_ := A;
end;

//------------------------------------------------------------------------------

procedure TArray3D<_TItem_>.Read( const Stream_:TStream );
begin
     Stream_.Read( _Items[ 0 ], GetTotalSize );
end;

procedure TArray3D<_TItem_>.Write( const Stream_:TStream );
begin
     Stream_.Write( _Items[ 0 ], GetTotalSize );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBricArray3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TBricArray3D<_TItem_>.GetGridsX :Integer;
begin
     Result := BricsX + 1;
end;

procedure TBricArray3D<_TItem_>.SetGridsX( const GridX_:Integer );
begin
     BricsX := GridX_ - 1;
end;

function TBricArray3D<_TItem_>.GetGridsY :Integer;
begin
     Result := BricsY + 1;
end;

procedure TBricArray3D<_TItem_>.SetGridsY( const GridY_:Integer );
begin
     BricsY := GridY_ - 1;
end;

function TBricArray3D<_TItem_>.GetGridsZ :Integer;
begin
     Result := BricsZ + 1;
end;

procedure TBricArray3D<_TItem_>.SetGridsZ( const GridZ_:Integer );
begin
     BricsY := GridZ_ - 1;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGridArray3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGridArray3D<_TItem_>.GetBricsX :Integer;
begin
     Result := _ItemsX - 1;
end;

procedure TGridArray3D<_TItem_>.SetBricsX( const BricsX_:Integer );
begin
     _ItemsX  := BricsX_ + 1;  MakeArray;
end;

function TGridArray3D<_TItem_>.GetBricsY :Integer;
begin
     Result := _ItemsY - 1;
end;

procedure TGridArray3D<_TItem_>.SetBricsY( const BricsY_:Integer );
begin
     _ItemsY  := BricsY_ + 1;  MakeArray;
end;

function TGridArray3D<_TItem_>.GetBricsZ :Integer;
begin
     Result := _ItemsZ - 1;
end;

procedure TGridArray3D<_TItem_>.SetBricsZ( const BricsZ_:Integer );
begin
     _ItemsZ  := BricsZ_ + 1;  MakeArray;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGridArray3D<_TItem_>.Create( const BricsX_,BricsY_,BricsZ_,MargsX_,MargsY_,MargsZ_:Integer );
begin
     inherited Create( BricsX_+1, BricsY_+1, BricsZ_+1,
                       MargsX_  , MargsY_  , MargsZ_   );

end;

destructor TGridArray3D<_TItem_>.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGridArray3D<_TItem_>.Read( const Stream_:TStream );
var
   S, M :TCardinal3D;
begin
     with Stream_ do
     begin
          Read( S, SizeOf( TCardinal3D ) );
          Read( M, SizeOf( TCardinal3D ) );
     end;

     BricsX := S.X;
     BricsY := S.Y;
     BricsZ := S.Z;

     MargsX := M.X;
     MargsY := M.Y;
     MargsZ := M.Z;

     inherited;
end;

procedure TGridArray3D<_TItem_>.Write( const Stream_:TStream );
var
   S, M :TCardinal3D;
begin
     with S do
     begin
          X := BricsX;
          Y := BricsY;
          Z := BricsZ;
     end;

     with M do
     begin
          X := MargsX;
          Y := MargsY;
          Z := MargsZ;
     end;

     with Stream_ do
     begin
          Write( S, SizeOf( TCardinal3D ) );
          Write( M, SizeOf( TCardinal3D ) );
     end;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBricIterGridArray3D<_TItem_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TBricIterGridArray3D<_TItem_>.GetPos :TInteger3D;
begin
     Result := TInteger3D.Create( _GX[0], _GY[0], _GZ[0] );
end;

procedure TBricIterGridArray3D<_TItem_>.SetPos( const Pos_:TInteger3D );
var
   X, Y, Z :Integer;
begin
     for X := -1 to +2 do _GX[ X ] := Pos_.X + X;
     for Y := -1 to +2 do _GY[ Y ] := Pos_.Y + Y;
     for Z := -1 to +2 do _GZ[ Z ] := Pos_.Z + Z;

     for Z := -1 to +2 do
     for Y := -1 to +2 do
     for X := -1 to +2 do _Grids[ Z, Y, X ] := _Array.ItemP[ _GX[ X ], _GY[ Y ], _GZ[ Z ] ];
end;

//------------------------------------------------------------------------------

function TBricIterGridArray3D<_TItem_>.GetGrids( const X_,Y_,Z_:Shortint ) :_TItem_;
begin
     Result := _Grids[ Z_, Y_, X_ ]^;
end;

procedure TBricIterGridArray3D<_TItem_>.SetGrids( const X_,Y_,Z_:Shortint; const Item_:_TItem_ );
begin
     _Grids[ Z_, Y_, X_ ]^ := Item_;
end;

//------------------------------------------------------------------------------

function TBricIterGridArray3D<_TItem_>.GetGX( const I_:Shortint ) :Integer;
begin
     Result := _GX[ I_ ];
end;

function TBricIterGridArray3D<_TItem_>.GetGY( const I_:Shortint ) :Integer;
begin
     Result := _GY[ I_ ];
end;

function TBricIterGridArray3D<_TItem_>.GetGZ( const I_:Shortint ) :Integer;
begin
     Result := _GZ[ I_ ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TBricIterGridArray3D<_TItem_>.Create( const Array_:TGridArray3D<_TItem_> );
begin
     inherited Create;

     _Array := Array_;

     Pos := TInteger3D.Create( 0, 0, 0 );
end;

destructor TBricIterGridArray3D<_TItem_>.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TBricIterGridArray3D<_TItem_>.GoPrevX;
var
   Y, Z :Integer;
begin
     Move( _GX[ -1 ], _GX[ 0 ], 3 * SizeOf( Integer ) );  Dec( _GX[ -1 ] );

     for Z := -1 to +2 do
     begin
          for Y := -1 to +2 do
          begin
               Move( _Grids[ Z, Y, -1 ], _Grids[ Z, Y, 0 ], 3 * SizeOf( _PItem_ ) );

               Dec( _Grids[ Z, Y, -1 ], _Array.ElemStepX );
          end;
     end;
end;

procedure TBricIterGridArray3D<_TItem_>.GoNextX;
var
   Y, Z :Integer;
begin
     Move( _GX[ 0 ], _GX[ -1 ], 3 * SizeOf( Integer ) );  Inc( _GX[ +2 ] );

     for Z := -1 to +2 do
     begin
          for Y := -1 to +2 do
          begin
               Move( _Grids[ Z, Y, 0 ], _Grids[ Z, Y, -1 ], 3 * SizeOf( _PItem_ ) );

               Inc( _Grids[ Z, Y, +2 ], _Array.ElemStepX );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TBricIterGridArray3D<_TItem_>.GoPrevY;
var
   Z, X :Integer;
begin
     Move( _GY[ -1 ], _GY[ 0 ], 3 * SizeOf( Integer ) );  Dec( _GY[ -1 ] );

     for Z := -1 to +2 do
     begin
          Move( _Grids[ Z, -1 ], _Grids[ Z, 0 ], 12 * SizeOf( _PItem_ ) );

          for X := -1 to +2 do
          begin
               Dec( _Grids[ Z, -1, X ], _Array.ElemStepY );
          end;
     end;
end;

procedure TBricIterGridArray3D<_TItem_>.GoNextY;
var
   Z, X :Integer;
begin
     Move( _GY[ 0 ], _GY[ -1 ], 3 * SizeOf( Integer ) );  Inc( _GY[ +2 ] );

     for Z := -1 to +2 do
     begin
          Move( _Grids[ Z, 0 ], _Grids[ Z, -1 ], 12 * SizeOf( _PItem_ ) );

          for X := -1 to +2 do
          begin
               Inc( _Grids[ Z, +2, X ], _Array.ElemStepY );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TBricIterGridArray3D<_TItem_>.GoPrevZ;
var
   X, Y :Integer;
begin
     Move( _GZ[ -1 ], _GZ[ 0 ], 3 * SizeOf( Integer ) );  Dec( _GZ[ -1 ] );

     Move( _Grids[ -1 ], _Grids[ 0 ], 48 * SizeOf( _PItem_ ) );

     for Y := -1 to +2 do
     begin
          for X := -1 to +2 do
          begin
               Dec( _Grids[ -1, Y, X ], _Array.ElemStepZ );
          end;
     end;
end;

procedure TBricIterGridArray3D<_TItem_>.GoNextZ;
var
   X, Y :Integer;
begin
     Move( _GZ[ 0 ], _GZ[ -1 ], 3 * SizeOf( Integer ) );  Inc( _GZ[ +2 ] );

     Move( _Grids[ 0 ], _Grids[ -1 ], 48 * SizeOf( _PItem_ ) );

     for Y := -1 to +2 do
     begin
          for X := -1 to +2 do
          begin
               Inc( _Grids[ +2, Y, X ], _Array.ElemStepZ );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TBricIterGridArray3D<_TItem_>.GoPrevX( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do GoPrevX;
end;

procedure TBricIterGridArray3D<_TItem_>.GoNextX( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do GoNextX;
end;

procedure TBricIterGridArray3D<_TItem_>.GoPrevY( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do GoPrevY;
end;

procedure TBricIterGridArray3D<_TItem_>.GoNextY( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do GoNextY;
end;

procedure TBricIterGridArray3D<_TItem_>.GoPrevZ( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do GoPrevZ;
end;

procedure TBricIterGridArray3D<_TItem_>.GoNextZ( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do GoNextZ;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
