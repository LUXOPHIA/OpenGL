unit LUX.Curve.BSpline;

interface //#################################################################### ■

uses LUX, LUX.D1, LUX.D2, LUX.D3, LUX.D4;

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

function BSpline( const T_:Single; const I0,N1:Integer; const Ts_:array of Single ) :Single; overload;
function BSpline( const T_:Double; const I0,N1:Integer; const Ts_:array of Double ) :Double; overload;
function BSpline( const T_:TdSingle; const I0,N1:Integer; const Ts_:array of TdSingle ) :TdSingle; overload;
function BSpline( const T_:TdDouble; const I0,N1:Integer; const Ts_:array of TdDouble ) :TdDouble; overload;

function BSpline4( const X_:Single ) :Single; overload;
function BSpline4( const X_:Double ) :Double; overload;
function BSpline4( const X_:TdSingle ) :TdSingle; overload;
function BSpline4( const X_:TdDouble ) :TdDouble; overload;

procedure BSpline4( const T_:Single; out Ws_:TSingle4D ); overload;
procedure BSpline4( const T_:Double; out Ws_:TDouble4D ); overload;
procedure BSpline4( const T_:TdSingle; out Ws_:TdSingle4D ); overload;
procedure BSpline4( const T_:TdDouble; out Ws_:TdDouble4D ); overload;

function BSpline4( const P0_,P1_,P2_,P3_:Single; const T_:Single ) :Single; overload;
function BSpline4( const P0_,P1_,P2_,P3_:Double; const T_:Double ) :Double; overload;
function BSpline4( const P0_,P1_,P2_,P3_:TdSingle; const T_:TdSingle ) :TdSingle; overload;
function BSpline4( const P0_,P1_,P2_,P3_:TdDouble; const T_:TdDouble ) :TdDouble; overload;

function BSpline4( const Ps_:TSingle4D; const T_:Single ) :Single; overload;
function BSpline4( const Ps_:TDouble4D; const T_:Double ) :Double; overload;
function BSpline4( const Ps_:TdSingle4D; const T_:TdSingle ) :TdSingle; overload;
function BSpline4( const Ps_:TdDouble4D; const T_:TdDouble ) :TdDouble; overload;

implementation //############################################################### ■

uses System.Math,
     LUX.Curve;

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

function BSpline( const T_:Single; const I0,N1:Integer; const Ts_:array of Single ) :Single;
var
   I1, N0 :Integer;
   T0, T1, T2, T3 :Single;
begin
     I1 := I0 + 1;

     T0 := Ts_[ I0      ];
     T2 := Ts_[ I0 + N1 ];
     T1 := Ts_[ I1      ];
     T3 := Ts_[ I1 + N1 ];

     if N1 = 1 then
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━
               T0      T2
               ├─N1─┤
                       T1      T3
                       ├─N1─┤    }

          if ( T_ < T0 ) or ( T3 < T_ ) then Result := 0
          else
          begin
               if T_ < T2 then Result := ( T_ - T0 ) / ( T2 - T0 )
                          else
               if T_ > T1 then Result := ( T3 - T_ ) / ( T3 - T1 )
                          else Result := 1;
          end;
     end
     else
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━━━╋━━━╋━
               T0                      T2
               ├─────N1─────┤
                       T1                      T3
                       ├─────N1─────┤    }

          N0 := N1 - 1;

          Result := 0;

          if T2 > T0 then Result := Result + ( T_ - T0 ) / ( T2 - T0 ) * BSpline( T_, I0, N0, Ts_ );
          if T3 > T1 then Result := Result + ( T3 - T_ ) / ( T3 - T1 ) * BSpline( T_, I1, N0, Ts_ );
     end;
end;

function BSpline( const T_:Double; const I0,N1:Integer; const Ts_:array of Double ) :Double;
var
   I1, N0 :Integer;
   T0, T1, T2, T3 :Double;
begin
     I1 := I0 + 1;

     T0 := Ts_[ I0      ];
     T2 := Ts_[ I0 + N1 ];
     T1 := Ts_[ I1      ];
     T3 := Ts_[ I1 + N1 ];

     if N1 = 1 then
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━
               T0      T2
               ├─N1─┤
                       T1      T3
                       ├─N1─┤    }

          if ( T_ < T0 ) or ( T3 < T_ ) then Result := 0
          else
          begin
               if T_ < T2 then Result := ( T_ - T0 ) / ( T2 - T0 )
                          else
               if T_ > T1 then Result := ( T3 - T_ ) / ( T3 - T1 )
                          else Result := 1;
          end;
     end
     else
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━━━╋━━━╋━
               T0                      T2
               ├─────N1─────┤
                       T1                      T3
                       ├─────N1─────┤    }

          N0 := N1 - 1;

          Result := 0;

          if T2 > T0 then Result := Result + ( T_ - T0 ) / ( T2 - T0 ) * BSpline( T_, I0, N0, Ts_ );
          if T3 > T1 then Result := Result + ( T3 - T_ ) / ( T3 - T1 ) * BSpline( T_, I1, N0, Ts_ );
     end;
end;

function BSpline( const T_:TdSingle; const I0,N1:Integer; const Ts_:array of TdSingle ) :TdSingle;
var
   I1, N0 :Integer;
   T0, T1, T2, T3 :TdSingle;
begin
     I1 := I0 + 1;

     T0 := Ts_[ I0      ];
     T2 := Ts_[ I0 + N1 ];
     T1 := Ts_[ I1      ];
     T3 := Ts_[ I1 + N1 ];

     if N1 = 1 then
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━
               T0      T2
               ├─N1─┤
                       T1      T3
                       ├─N1─┤    }

          if ( T_ < T0 ) or ( T3 < T_ ) then Result := 0
          else
          begin
               if T_ < T2 then Result := ( T_ - T0 ) / ( T2 - T0 )
                          else
               if T_ > T1 then Result := ( T3 - T_ ) / ( T3 - T1 )
                          else Result := 1;
          end;
     end
     else
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━━━╋━━━╋━
               T0                      T2
               ├─────N1─────┤
                       T1                      T3
                       ├─────N1─────┤    }

          N0 := N1 - 1;

          Result := 0;

          if T2 > T0 then Result := Result + ( T_ - T0 ) / ( T2 - T0 ) * BSpline( T_, I0, N0, Ts_ );
          if T3 > T1 then Result := Result + ( T3 - T_ ) / ( T3 - T1 ) * BSpline( T_, I1, N0, Ts_ );
     end;
end;

function BSpline( const T_:TdDouble; const I0,N1:Integer; const Ts_:array of TdDouble ) :TdDouble;
var
   I1, N0 :Integer;
   T0, T1, T2, T3 :TdDouble;
begin
     I1 := I0 + 1;

     T0 := Ts_[ I0      ];
     T2 := Ts_[ I0 + N1 ];
     T1 := Ts_[ I1      ];
     T3 := Ts_[ I1 + N1 ];

     if N1 = 1 then
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━
               T0      T2
               ├─N1─┤
                       T1      T3
                       ├─N1─┤    }

          if ( T_ < T0 ) or ( T3 < T_ ) then Result := 0
          else
          begin
               if T_ < T2 then Result := ( T_ - T0 ) / ( T2 - T0 )
                          else
               if T_ > T1 then Result := ( T3 - T_ ) / ( T3 - T1 )
                          else Result := 1;
          end;
     end
     else
     begin
          {    I0      I1
             ━╋━━━╋━━━╋━━━╋━━━╋━
               T0                      T2
               ├─────N1─────┤
                       T1                      T3
                       ├─────N1─────┤    }

          N0 := N1 - 1;

          Result := 0;

          if T2 > T0 then Result := Result + ( T_ - T0 ) / ( T2 - T0 ) * BSpline( T_, I0, N0, Ts_ );
          if T3 > T1 then Result := Result + ( T3 - T_ ) / ( T3 - T1 ) * BSpline( T_, I1, N0, Ts_ );
     end;
end;

//------------------------------------------------------------------------------

function BSpline4( const X_:Single ) :Single;
const
     A :Single = 1/6;
     B :Single = 4/3;
     C :Single = 2/3;
var
   X :Single;
begin
     X := Abs( X_ );

     if X < 1 then Result := ( 0.5 * X - 1 ) * X * X + C
              else
     if X < 2 then Result := ( ( 1 - A * X ) * X - 2 ) * X + B
              else Result := 0;
end;

function BSpline4( const X_:Double ) :Double;
const
     A :Double = 1/6;
     B :Double = 4/3;
     C :Double = 2/3;
var
   X :Double;
begin
     X := Abs( X_ );

     if X < 1 then Result := ( 0.5 * X - 1 ) * X * X + C
              else
     if X < 2 then Result := ( ( 1 - A * X ) * X - 2 ) * X + B
              else Result := 0;
end;

function BSpline4( const X_:TdSingle ) :TdSingle;
const
     A :TdSingle = ( o:1/6; d:0 );
     B :TdSingle = ( o:4/3; d:0 );
     C :TdSingle = ( o:2/3; d:0 );
var
   X :TdSingle;
begin
     X := Abso( X_ );

     if X < 1 then Result := ( X / 2 - 1 ) * X * X + C
              else
     if X < 2 then Result := ( ( 1 - A * X ) * X - 2 ) * X + B
              else Result := 0;
end;

function BSpline4( const X_:TdDouble ) :TdDouble;
const
     A :TdDouble = ( o:1/6; d:0 );
     B :TdDouble = ( o:4/3; d:0 );
     C :TdDouble = ( o:2/3; d:0 );
var
   X :TdDouble;
begin
     X := Abso( X_ );

     if X < 1 then Result := ( X / 2 - 1 ) * X * X + C
              else
     if X < 2 then Result := ( ( 1 - A * X ) * X - 2 ) * X + B
              else Result := 0;
end;

//------------------------------------------------------------------------------

procedure BSpline4( const T_:Single; out Ws_:TSingle4D );
begin
     with Ws_ do
     begin
          _1 := BSpline4( T_ + 1 );
          _2 := BSpline4( T_     );
          _3 := BSpline4( T_ - 1 );
          _4 := BSpline4( T_ - 2 );
     end;
end;

procedure BSpline4( const T_:Double; out Ws_:TDouble4D );
begin
     with Ws_ do
     begin
          _1 := BSpline4( T_ + 1 );
          _2 := BSpline4( T_     );
          _3 := BSpline4( T_ - 1 );
          _4 := BSpline4( T_ - 2 );
     end;
end;

procedure BSpline4( const T_:TdSingle; out Ws_:TdSingle4D );
begin
     with Ws_ do
     begin
          _1 := BSpline4( T_ + 1 );
          _2 := BSpline4( T_     );
          _3 := BSpline4( T_ - 1 );
          _4 := BSpline4( T_ - 2 );
     end;
end;

procedure BSpline4( const T_:TdDouble; out Ws_:TdDouble4D );
begin
     with Ws_ do
     begin
          _1 := BSpline4( T_ + 1 );
          _2 := BSpline4( T_     );
          _3 := BSpline4( T_ - 1 );
          _4 := BSpline4( T_ - 2 );
     end;
end;

//------------------------------------------------------------------------------

function BSpline4( const P0_,P1_,P2_,P3_:Single; const T_:Single ) :Single;
var
   Ws :TSingle4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * P0_
             + Ws._2 * P1_
             + Ws._3 * P2_
             + Ws._4 * P3_;
end;

function BSpline4( const P0_,P1_,P2_,P3_:Double; const T_:Double ) :Double;
var
   Ws :TDouble4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * P0_
             + Ws._2 * P1_
             + Ws._3 * P2_
             + Ws._4 * P3_;
end;

function BSpline4( const P0_,P1_,P2_,P3_:TdSingle; const T_:TdSingle ) :TdSingle;
var
   Ws :TdSingle4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * P0_
             + Ws._2 * P1_
             + Ws._3 * P2_
             + Ws._4 * P3_;
end;

function BSpline4( const P0_,P1_,P2_,P3_:TdDouble; const T_:TdDouble ) :TdDouble;
var
   Ws :TdDouble4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * P0_
             + Ws._2 * P1_
             + Ws._3 * P2_
             + Ws._4 * P3_;
end;

//------------------------------------------------------------------------------

function BSpline4( const Ps_:TSingle4D; const T_:Single ) :Single;
var
   Ws :TSingle4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * Ps_._1
             + Ws._2 * Ps_._2
             + Ws._3 * Ps_._3
             + Ws._4 * Ps_._4;
end;

function BSpline4( const Ps_:TDouble4D; const T_:Double ) :Double;
var
   Ws :TDouble4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * Ps_._1
             + Ws._2 * Ps_._2
             + Ws._3 * Ps_._3
             + Ws._4 * Ps_._4;
end;

function BSpline4( const Ps_:TdSingle4D; const T_:TdSingle ) :TdSingle;
var
   Ws :TdSingle4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * Ps_._1
             + Ws._2 * Ps_._2
             + Ws._3 * Ps_._3
             + Ws._4 * Ps_._4;
end;

function BSpline4( const Ps_:TdDouble4D; const T_:TdDouble ) :TdDouble;
var
   Ws :TdDouble4D;
begin
     BSpline4( T_, Ws );

     Result := Ws._1 * Ps_._1
             + Ws._2 * Ps_._2
             + Ws._3 * Ps_._3
             + Ws._4 * Ps_._4;
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■