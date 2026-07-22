unit LUX.Data.Grid.D1;

interface //#################################################################### ■

uses LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins1D<_TPoin_>

     TPoins<_TPoin_> = class
     private
     protected
       _Poins :TArray<_TPoin_>;  upPoins :Boolean;
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       function GetPoinsN :Integer; virtual;
       procedure SetPoinsN( const PoinsN_:Integer ); virtual;
       function GetCellsN :Integer; virtual;
       procedure SetCellsN( const CellsN_:Integer ); virtual;
       function GetPoins( const I_:Integer ) :_TPoin_; virtual;
       procedure SetPoins( const I_:Integer; const Point_:_TPoin_ ); virtual;
       ///// M E T H O D
       procedure InitPoins; virtual;
       procedure MakePoins; virtual;
     public
       constructor Create;
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property CellsN                    :Integer  read GetCellsN write SetCellsN;
       property PoinsN                    :Integer  read GetPoinsN write SetPoinsN;
       property Poins[ const I_:Integer ] :_TPoin_  read GetPoins  write SetPoins ; default;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLoopPoins1D<_TPoin_>

     TLoopPoins<_TPoin_> = class( TPoins<_TPoin_> )
     private
       ///// M E T H O D
       function XtoI( const X_:Integer ) :Integer;
     protected
       ///// A C C E S S O R
       function GetCellsN :Integer; override;
       procedure SetCellsN( const CellsN_:Integer ); override;
       function GetPoins( const I_:Integer ) :_TPoin_; override;
       procedure SetPoins( const I_:Integer; const Point_:_TPoin_ ); override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins1D<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPoins<_TPoin_>.GetPoinsN :Integer;
begin
     Result := Length( _Poins );
end;

procedure TPoins<_TPoin_>.SetPoinsN( const PoinsN_:Integer );
begin
     if Length( _Poins ) = PoinsN_ then Exit;

     SetLength( _Poins, PoinsN_ );  upPoins := True;  _OnChange.Run( Self );
end;

//------------------------------------------------------------------------------

function TPoins<_TPoin_>.GetCellsN :Integer;
begin
     Result := PoinsN - 1;
end;

procedure TPoins<_TPoin_>.SetCellsN( const CellsN_:Integer );
begin
     PoinsN := CellsN_ + 1;
end;

//------------------------------------------------------------------------------

function TPoins<_TPoin_>.GetPoins( const I_:Integer ) :_TPoin_;
begin
     InitPoins;

     Result := _Poins[ I_ ];
end;

procedure TPoins<_TPoin_>.SetPoins( const I_:Integer; const Point_:_TPoin_ );
begin
     _Poins[ I_ ] := Point_;  upPoins := True;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoins<_TPoin_>.InitPoins;
begin
     if upPoins then
     begin
          upPoins := False;

          SetLength( _Poins, PoinsN );

          MakePoins;
     end;
end;

procedure TPoins<_TPoin_>.MakePoins;
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoins<_TPoin_>.Create;
begin
     inherited;

     PoinsN := 0;
end;

destructor TPoins<_TPoin_>.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLoopPoins1D<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////////// M E T H O D

function TLoopPoins<_TPoin_>.XtoI( const X_:Integer ) :Integer;
begin
     Result := ( PoinsN * 10 + X_ ) mod PoinsN;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TLoopPoins<_TPoin_>.GetCellsN :Integer;
begin
     Result := PoinsN;
end;

procedure TLoopPoins<_TPoin_>.SetCellsN( const CellsN_:Integer );
begin
     PoinsN := CellsN_;
end;

//------------------------------------------------------------------------------

function TLoopPoins<_TPoin_>.GetPoins( const I_:Integer ) :_TPoin_;
begin
     InitPoins;

     Result := _Poins[ XtoI( I_ ) ];
end;

procedure TLoopPoins<_TPoin_>.SetPoins( const I_:Integer; const Point_:_TPoin_ );
begin
     _Poins[ XtoI( I_ ) ] := Point_;  upPoins := True;  _OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■