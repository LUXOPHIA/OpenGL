unit LUX.Data.Grid.Tria.D2;

interface //#################################################################### ■

uses LUX, LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriaGrid<_TPoin_>

     TTriaGrid<_TPoin_:record> = class
     private
     protected
       _Poins  :TArray2<_TPoin_>;  upPoins :Boolean;
       _CellsN :Integer;
       _DivN   :Integer;
       ///// A C C E S S O R
       function GetPoins( const X_,Y_:Integer ) :_TPoin_; virtual;
       function GetCellsN :Integer; virtual;
       procedure SetCellsN( const CellsN_:Integer ); virtual;
       function GetDivN :Integer; virtual;
       procedure SetDivN( const DivN_:Integer ); virtual;
       function GetEdgesN :Integer; virtual;
       function GetAllFacesN :Integer; virtual;
       function GetAllPoinsN :Integer; virtual;
       ///// M E T H O D
       procedure MakePoins; virtual;
     public
       constructor Create;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Poins[ const X,Y:Integer ] :_TPoin_ read GetPoins                 ;
       property CellsN                     :Integer read GetCellsN write SetCellsN;
       property DivN                       :Integer read GetDivN   write SetDivN  ;
       property EdgesN                     :Integer read GetEdgesN                ;
       property AllCellsN                  :Integer read GetAllFacesN             ;
       property AllPoinsN                  :Integer read GetAllPoinsN             ;
       ///// M E T H O D
       procedure ForPoins( const Proc_:TConstProc3<Integer> );
       procedure ParaForPoins( const Proc_:TConstProc3<Integer> );
       procedure ForFaces( const Proc_:TConstProc3<TInteger3D> );
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Threading;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriaGrid<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

function TTriaGrid<_TPoin_>.GetPoins( const X_,Y_:Integer ) :_TPoin_;
begin
     if upPoins then
     begin
          MakePoins;  upPoins := False;
     end;

     Result := _Poins[ Y_, X_ ];
end;

//------------------------------------------------------------------------------

function TTriaGrid<_TPoin_>.GetCellsN :Integer;
begin
     Result := _CellsN;
end;

procedure TTriaGrid<_TPoin_>.SetCellsN( const CellsN_:Integer );
begin
     _CellsN := CellsN_;  upPoins := True;
end;

//------------------------------------------------------------------------------

function TTriaGrid<_TPoin_>.GetDivN :Integer;
begin
     Result := _DivN;
end;

procedure TTriaGrid<_TPoin_>.SetDivN( const DivN_:Integer );
begin
     _DivN := DivN_;  upPoins := True;
end;

//------------------------------------------------------------------------------

function TTriaGrid<_TPoin_>.GetEdgesN :Integer;
begin
     Result := _CellsN * _DivN;
end;

//------------------------------------------------------------------------------

function TTriaGrid<_TPoin_>.GetAllFacesN :Integer;
begin
     Result := Sqr( EdgesN );
end;

//------------------------------------------------------------------------------

function TTriaGrid<_TPoin_>.GetAllPoinsN :Integer;
begin
     Result := ( EdgesN + 1 ) * ( EdgesN + 2 ) div 2;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TTriaGrid<_TPoin_>.MakePoins;
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTriaGrid<_TPoin_>.Create;
begin
     inherited;

     CellsN := 1;
     DivN   := 1;
end;

destructor TTriaGrid<_TPoin_>.Destroy;
begin

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TTriaGrid<_TPoin_>.ForPoins( const Proc_:TConstProc3<Integer> );
var
   N, W, X, Y, Z :Integer;
begin
     N := EdgesN;

     for Y := 0 to N do
     begin
          W := N - Y;

          for X := 0 to W do
          begin
               Z := W - X;

               Proc_( X, Y, Z );
          end;
     end;
end;

procedure TTriaGrid<_TPoin_>.ParaForPoins( const Proc_:TConstProc3<Integer> );
var
   N :Integer;
begin
     N := EdgesN;

     TParallel.For( 0, N, procedure( Y:Integer )
     var
        W, X, Z :Integer;
     begin
          W := N - Y;

          for X := 0 to W do
          begin
               Z := W - X;

               Proc_( X, Y, Z );
          end;
     end );
end;

//------------------------------------------------------------------------------

procedure TTriaGrid<_TPoin_>.ForFaces( const Proc_:TConstProc3<TInteger3D> );
var
   N, X0, Y0, X1, Y1, W0, W1 :Integer;
begin
     N := EdgesN;

     for Y0 := 0 to N-1 do
     begin
          Y1 := Y0 + 1;
          W0 := N - Y0;
          W1 := N - Y1;

          for X0 := 0 to W0-2 do
          begin
               X1 := X0 + 1;

               //  Y1 +------+
               //     |＼    |
               //     |  ＼  |
               //     |    ＼|
               //  Y0 +------+
               //     X0     X1

               Proc_( TInteger3D.Create( X0, Y0, W0-X0 ),
                      TInteger3D.Create( X1, Y0, W0-X1 ),
                      TInteger3D.Create( X0, Y1, W1-X0 ) );

               Proc_( TInteger3D.Create( X1, Y1, W1-X1 ),
                      TInteger3D.Create( X0, Y1, W1-X0 ),
                      TInteger3D.Create( X1, Y0, W0-X1 ) );
          end;

          X0 := W0-1;  X1 := W0;

          //  Y1 +
          //     |＼
          //     |  ＼
          //     |    ＼
          //  Y0 +------+
          //     X0     X1

          Proc_( TInteger3D.Create( X0, Y0, W0-X0 ),
                 TInteger3D.Create( X1, Y0, W0-X1 ),
                 TInteger3D.Create( X0, Y1, W1-X0 ) );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■