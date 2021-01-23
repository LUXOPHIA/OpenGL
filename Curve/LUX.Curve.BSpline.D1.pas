unit LUX.Curve.BSpline.D1;

interface //#################################################################### ■

uses LUX, LUX.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBSInterp
     //
     //  00    01    02    03    04    05    06    07    08    09    10    11
     //  │    │    ┃    ┃    ┃    ┃    ┃    ┃    ┃    ┃    │    │
     //  ○----○----◆----●━━●━━●━━●━━●━━●----◆----○----○
     //  │    │    ┃    ┃    ┃    ┃    ┃    ┃    ┃    ┃    │    │
     // -03   -02   -01    00   +01   +02   +03   +04   +05   +06   +07   +08
     //  │          ┃    ┃                            ┃    ┃          │
     //  │          ┃<１>┃<-----------Curv----------->┃<１>┃          │
     //  │<---FW--->┃<-----------------Vert----------------->┃<---FW--->│
     //  │<-----------------------------Poin----------------------------->│

     TBSInterp = class
     private
       procedure MakePoins; virtual; abstract;
     protected
       _FilterW  :Integer;
       _CurvMinI :Integer;
       _CurvMaxI :Integer;
       ///// アクセス
       function GetFilterW :Integer;
       procedure SetFilterW( const FilterW_:Integer );
       function GetCurvMinI :Integer;
       procedure SetCurvMinI( const CurvMinI_:Integer );
       function GetCurvMaxI :Integer;
       procedure SetCurvMaxI( const CurvMaxI_:Integer );
       function GetVertMinI :Integer;
       function GetVertMaxI :Integer;
       function GetPoinMinI :Integer;
       function GetPoinMaxI :Integer;
       ///// メソッド
     public
       constructor Create;
       procedure AfterConstruction; override;
       destructor Destroy; override;
       ///// プロパティ
       property FilterW  :Integer read GetFilterW  write SetFilterW ;
       property PoinMinI :Integer read GetPoinMinI                  ;
       property PoinMaxI :Integer read GetPoinMaxI                  ;
       property VertMinI :Integer read GetVertMinI                  ;
       property VertMaxI :Integer read GetVertMaxI                  ;
       property CurvMinI :Integer read GetCurvMinI write SetCurvMinI;
       property CurvMaxI :Integer read GetCurvMaxI write SetCurvMaxI;
       ///// メソッド
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleBSInterp

     TSingleBSInterp = class( TBSInterp )
     private
       procedure MakePoins; override;
     protected
       _Poins :TArray<Single>;  upPoins :Boolean;
       _Verts :TArray<Single>;
       ///// アクセス
       function GetPoins( const I_:Integer ) :Single;
       procedure SetPoins( const I_:Integer; const Poins_:Single );
       function GetVerts( const I_:Integer ) :Single;
       procedure SetVerts( const I_:Integer; const Verts_:Single );
       ///// メソッド
       function BSplineHEF3( const X_:Integer ) :Single;
       function BSplineHEF4( const X_:Integer ) :Single;
       procedure MakeVerts;
     public
       ///// プロパティ
       property Poins[ const I_:Integer ] :Single read GetPoins write SetPoins;
       property Verts[ const I_:Integer ] :Single read GetVerts               ;
       ///// メソッド
       function Curv( const X_:Single ) :Single;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleBSInterp

     TDoubleBSInterp = class( TBSInterp )
     private
       procedure MakePoins; override;
     protected
       _Poins :TArray<Double>;  upPoins :Boolean;
       _Verts :TArray<Double>;
       ///// アクセス
       function GetPoins( const I_:Integer ) :Double;
       procedure SetPoins( const I_:Integer; const Poins_:Double );
       function GetVerts( const I_:Integer ) :Double;
       procedure SetVerts( const I_:Integer; const Verts_:Double );
       ///// メソッド
       function BSplineHEF3( const X_:Integer ) :Double;
       function BSplineHEF4( const X_:Integer ) :Double;
       procedure MakeVerts;
     public
       ///// プロパティ
       property Poins[ const I_:Integer ] :Double read GetPoins write SetPoins;
       property Verts[ const I_:Integer ] :Double read GetVerts               ;
       ///// メソッド
       function Curv( const X_:Double ) :Double;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.Math,
     LUX.Curve.T1.D1;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBSInterp

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

function TBSInterp.GetFilterW :Integer;
begin
     Result := _FilterW;
end;

procedure TBSInterp.SetFilterW( const FilterW_:Integer );
begin
     _FilterW := FilterW_;  MakePoins;
end;

//------------------------------------------------------------------------------

function TBSInterp.GetCurvMinI :Integer;
begin
     Result := _CurvMinI;
end;

procedure TBSInterp.SetCurvMinI( const CurvMinI_:Integer );
begin
     _CurvMinI := CurvMinI_;  MakePoins;
end;

function TBSInterp.GetCurvMaxI :Integer;
begin
     Result := _CurvMaxI;
end;

procedure TBSInterp.SetCurvMaxI( const CurvMaxI_:Integer );
begin
     _CurvMaxI := CurvMaxI_;  MakePoins;
end;

//------------------------------------------------------------------------------

function TBSInterp.GetVertMinI :Integer;
begin
     Result := CurvMinI - 1;
end;

function TBSInterp.GetVertMaxI :Integer;
begin
     Result := CurvMaxI + 1;
end;

//------------------------------------------------------------------------------

function TBSInterp.GetPoinMinI :Integer;
begin
     Result := VertMinI - FilterW;
end;

function TBSInterp.GetPoinMaxI :Integer;
begin
     Result := VertMaxI + FilterW;
end;

/////////////////////////////////////////////////////////////////////// メソッド

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TBSInterp.Create;
begin
     inherited;

end;

procedure TBSInterp.AfterConstruction;
begin
     inherited;

     FilterW  := 4;

     CurvMinI := 0;
     CurvMaxI := 8;
end;

destructor TBSInterp.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleBSInterp

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TSingleBSInterp.MakePoins;
begin
     SetLength( _Poins, PoinMaxI - PoinMinI + 1     );  upPoins := True;
     SetLength( _Verts, VertMaxI - VertMinI + 1 + 1 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

function TSingleBSInterp.GetPoins( const I_:Integer ) :Single;
begin
     Result := _Poins[ I_ - PoinMinI ];
end;

procedure TSingleBSInterp.SetPoins( const I_:Integer; const Poins_:Single );
begin
     _Poins[ I_ - PoinMinI ] := Poins_;  upPoins := True;
end;

//------------------------------------------------------------------------------

function TSingleBSInterp.GetVerts( const I_:Integer ) :Single;
begin
     if upPoins then
     begin
          MakeVerts;

          upPoins := False;
     end;

     Result := _Verts[ I_ - VertMinI ];
end;

procedure TSingleBSInterp.SetVerts( const I_:Integer; const Verts_:Single );
begin
     _Verts[ I_ - VertMinI ] := Verts_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TSingleBSInterp.BSplineHEF3( const X_:Integer ) :Single;
begin
     Result := Sqrt(2) * IntPower( 2*Sqrt(2)-3, Abs( X_ ) );
end;

function TSingleBSInterp.BSplineHEF4( const X_:Integer ) :Single;
begin
     Result := Sqrt(3) * IntPower( Sqrt(3)-2, Abs( X_ ) );
end;

procedure TSingleBSInterp.MakeVerts;
var
   I, X :Integer;
   C :Single;
begin
     for I := VertMinI to VertMaxI do
     begin
          C := 0;

          for X := -FilterW to +FilterW do
          begin
               C := C + BSplineHEF4( X ) * Poins[ I + X ];
          end;

          SetVerts( I, C );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

function TSingleBSInterp.Curv( const X_:Single ) :Single;
var
   Xi :Integer;
   Xd :Single;
begin
     if upPoins then
     begin
          MakeVerts;

          upPoins := False;
     end;

     Xi := Floor( X_ );  Xd := X_ - Xi;

     Result := BSpline4( Verts[ Xi-1 ],
                         Verts[ Xi   ],
                         Verts[ Xi+1 ],
                         Verts[ Xi+2 ], Xd );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleBSInterp

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TDoubleBSInterp.MakePoins;
begin
     SetLength( _Poins, PoinMaxI - PoinMinI + 1     );  upPoins := True;
     SetLength( _Verts, VertMaxI - VertMinI + 1 + 1 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

function TDoubleBSInterp.GetPoins( const I_:Integer ) :Double;
begin
     Result := _Poins[ I_ - PoinMinI ];
end;

procedure TDoubleBSInterp.SetPoins( const I_:Integer; const Poins_:Double );
begin
     _Poins[ I_ - PoinMinI ] := Poins_;  upPoins := True;
end;

//------------------------------------------------------------------------------

function TDoubleBSInterp.GetVerts( const I_:Integer ) :Double;
begin
     if upPoins then
     begin
          MakeVerts;

          upPoins := False;
     end;

     Result := _Verts[ I_ - VertMinI ];
end;

procedure TDoubleBSInterp.SetVerts( const I_:Integer; const Verts_:Double );
begin
     _Verts[ I_ - VertMinI ] := Verts_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TDoubleBSInterp.BSplineHEF3( const X_:Integer ) :Double;
begin
     Result := Sqrt(2) * IntPower( 2*Sqrt(2)-3, Abs( X_ ) );
end;

function TDoubleBSInterp.BSplineHEF4( const X_:Integer ) :Double;
begin
     Result := Sqrt(3) * IntPower( Sqrt(3)-2, Abs( X_ ) );
end;

procedure TDoubleBSInterp.MakeVerts;
var
   I, X :Integer;
   C :Double;
begin
     for I := VertMinI to VertMaxI do
     begin
          C := 0;

          for X := -FilterW to +FilterW do
          begin
               C := C + BSplineHEF4( X ) * Poins[ I + X ];
          end;

          SetVerts( I, C );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

function TDoubleBSInterp.Curv( const X_:Double ) :Double;
var
   Xi :Integer;
   Xd :Double;
begin
     if upPoins then
     begin
          MakeVerts;

          upPoins := False;
     end;

     Xi := Floor( X_ );  Xd := X_ - Xi;

     Result := BSpline4( Verts[ Xi-1 ],
                         Verts[ Xi   ],
                         Verts[ Xi+1 ],
                         Verts[ Xi+2 ], Xd );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■