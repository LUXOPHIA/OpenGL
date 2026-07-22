unit LUX.Curve.Data.Grid.D1.Plots;

interface //#################################################################### ■

uses LUX.Data.Grid.D1,
     LUX.Curve.Data.Grid.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPlots<_TPoin_>

     TPlots<_TPoin_> = class( TPoins<_TPoin_> )
     private
     protected
       _Curve   :TCurve<_TPoin_>;
       _EdgesN  :Integer;
       _Edges   :TArray<Double>;  upEdges :Boolean;
       _PlotGap :Double;
       ///// A C C E S S O R
       function GetPoinsN :Integer; override;
       procedure UpCurve( Sender_:TObject );
       function GetCurve :TCurve<_TPoin_>; virtual;
       procedure SetCurve( const Curve_:TCurve<_TPoin_> ); virtual;
       function GetEdgesN :Integer; virtual;
       procedure SetEdgesN( const EdgesN_:Integer ); virtual;
       function GetEdges( const I_:Integer ) :Double; virtual;
       function GetArcLen :Double; virtual;
       function GetPlotGap :Double; virtual;
       procedure SetPlotGap( const PlotGap_:Double ); virtual;
       ///// M E T H O D
       function Distance( const P0_,P1_:_TPoin_ ) :Double; virtual; abstract;
       procedure InitEdges; virtual;
       procedure MakeEdges; virtual;
       procedure MakePoins; override;
     public
       constructor Create;
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property CellsN                    :Integer         read GetCellsN                  ;
       property PoinsN                    :Integer         read GetPoinsN                  ;
       property Poins[ const I_:Integer ] :_TPoin_         read GetPoins                   ; default;
       property Curve                     :TCurve<_TPoin_> read GetCurve   write SetCurve  ;
       property EdgesN                    :Integer         read GetEdgesN  write SetEdgesN ;
       property Edges[ const I_:Integer ] :Double          read GetEdges                   ;
       property ArcLen                    :Double          read GetArcLen                  ;
       property PlotGap                   :Double          read GetPlotGap write SetPlotGap;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPlots0<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPlots<_TPoin_>.GetPoinsN :Integer;
begin
     Result := Round( ArcLen / PlotGap ) + 1;
end;

//------------------------------------------------------------------------------

procedure TPlots<_TPoin_>.UpCurve( Sender_:TObject );
begin
     upEdges := True;
     upPoins := True;

     _OnChange.Run( Self );
end;

function TPlots<_TPoin_>.GetCurve :TCurve<_TPoin_>;
begin
     Result := _Curve;
end;

procedure TPlots<_TPoin_>.SetCurve( const Curve_:TCurve<_TPoin_> );
begin
     if _Curve = Curve_ then Exit;

     if Assigned( _Curve ) then _Curve.OnChange.Del( UpCurve );

     _Curve := Curve_;

     if Assigned( _Curve ) then _Curve.OnChange.Add( UpCurve );

     UpCurve( Self );
end;

//------------------------------------------------------------------------------

function TPlots<_TPoin_>.GetEdgesN :Integer;
begin
     Result := _EdgesN;
end;

procedure TPlots<_TPoin_>.SetEdgesN( const EdgesN_:Integer );
begin
     if _EdgesN = EdgesN_ then Exit;

     _EdgesN := EdgesN_;  UpCurve( Self );
end;

//------------------------------------------------------------------------------

function TPlots<_TPoin_>.GetEdges( const I_:Integer ) :Double;
begin
     InitEdges;

     Result := _Edges[ I_ ];
end;

//------------------------------------------------------------------------------

function TPlots<_TPoin_>.GetArcLen :Double;
var
   I :Integer;
begin
     Result := 0;
     for I := 0 to EdgesN-1 do Result := Result + Edges[ I ];
end;

//------------------------------------------------------------------------------

function TPlots<_TPoin_>.GetPlotGap :Double;
begin
     Result := _PlotGap;
end;

procedure TPlots<_TPoin_>.SetPlotGap( const PlotGap_:Double );
begin
     if _PlotGap = PlotGap_ then Exit;

     _PlotGap := PlotGap_;  upPoins := True;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPlots<_TPoin_>.InitEdges;
begin
     if upEdges then
     begin
          upEdges := False;

          SetLength( _Edges, EdgesN );

          MakeEdges;
     end;
end;

procedure TPlots<_TPoin_>.MakeEdges;
var
   T, Td :Double;
   P0, P1 :_TPoin_;
   J :Integer;
begin
     if not Assigned( _Curve ) then Exit;

     Td := _Curve.Poins.CellsN / EdgesN;
     T := 0;  P0 := _Curve.Value( T );
     for J := 0 to EdgesN-1 do
     begin
          T := T + Td;  P1 := _Curve.Value( T );

          _Edges[ J ] := Distance( P0, P1 );

          P0 := P1;
     end;
end;

//------------------------------------------------------------------------------

//     1       2       3       4       5       6       7
//  |--+===|===+===|===+===|===+===|===+===|===+===|===+--| = ArcLen
//     *   1   *   2   *   3   *   4   *   5   *   6   *    = CellsN
//     1       2       3       4       5       6       7    = PoinsN

procedure TPlots<_TPoin_>.MakePoins;
var
   I, J :Integer;
   A, Ad, T, Td :Double;
begin
     if not Assigned( _Curve ) then Exit;

     Td := _Curve.Poins.CellsN / EdgesN;
     Ad := ArcLen / CellsN;

     A := 0;
     J := 0;
     for I := 0 to CellsN do
     begin
          while ( Edges[ J ] < A ) and ( J < EdgesN-1 )  do
          begin
               A := A - Edges[ J ];  Inc( J );
          end;

          T := A / Edges[ J ];

          _Poins[ I ] := _Curve.Value( Td * ( J + T ) );

          A := A + Ad;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPlots<_TPoin_>.Create;
begin
     inherited Create;

     Curve   := nil;
     EdgesN  := 1024;
     PlotGap := 1;
end;

destructor TPlots<_TPoin_>.Destroy;
begin
     Curve := nil;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■