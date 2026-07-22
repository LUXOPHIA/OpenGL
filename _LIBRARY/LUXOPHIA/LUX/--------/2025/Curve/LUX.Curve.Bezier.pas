unit LUX.Curve.Bezier;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2, LUX.D2x2, LUX.D2x4,
     LUX.D3, LUX.D3x3, LUX.D3x4,
     LUX.D4, LUX.D4x4,
     LUX.D5,
     LUX.DN,
     LUX.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

procedure Bezier4( const T_:Single; out Ws_:TSingle4D ); overload;
procedure Bezier4( const T_:Double; out Ws_:TDouble4D ); overload;
procedure Bezier4( const T_:TdSingle; out Ws_:TdSingle4D ); overload;
procedure Bezier4( const T_:TdDouble; out Ws_:TdDouble4D ); overload;

function Bezier4( const Ps_:TSingle4D; const T_:Single ) :Single; overload;
function Bezier4( const Ps_:TDouble4D; const T_:Double ) :Double; overload;
function Bezier4( const Ps_:TdSingle4D; const T_:TdSingle ) :TdSingle; overload;
function Bezier4( const Ps_:TdDouble4D; const T_:TdDouble ) :TdDouble; overload;

function Bezier4( const Ps_:TSingle4x2D; const T_:Single ) :TSingle2D; overload;
function Bezier4( const Ps_:TDouble4x2D; const T_:Double ) :TDouble2D; overload;
function Bezier4( const Ps_:TdSingle4x2D; const T_:TdSingle ) :TdSingle2D; overload;
function Bezier4( const Ps_:TdDouble4x2D; const T_:TdDouble ) :TdDouble2D; overload;

function Bezier4( const Ps_:TSingle4x3D; const T_:Single ) :TSingle3D; overload;
function Bezier4( const Ps_:TDouble4x3D; const T_:Double ) :TDouble3D; overload;
function Bezier4( const Ps_:TdSingle4x3D; const T_:TdSingle ) :TdSingle3D; overload;
function Bezier4( const Ps_:TdDouble4x3D; const T_:TdDouble ) :TdDouble3D; overload;

function Bezier( const T_:Single; const Cs_:TSingleND ) :Single; overload;
function Bezier( const T_:Double; const Cs_:TDoubleND ) :Double; overload;

function TrimBezier( const T0_,T1_:Single ) :TSingleM4; overload;
function TrimBezier( const T0_,T1_:Double ) :TDoubleM4; overload;

function PolyToBezi( const P_:TSingleND ) :TSingleND; overload;
function PolyToBezi( const P_:TDoubleND ) :TDoubleND; overload;

function BeziToPoly( const P_:TSingleND ) :TSingleND; overload;
function BeziToPoly( const P_:TDoubleND ) :TDoubleND; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

procedure Bezier4( const T_:Single; out Ws_:TSingle4D );
var
   T1, T2, T3,
   S1, S2, S3 :Single;
begin
     T1 :=      T_;  S1 := 1  - T_;
     T2 := T1 * T1;  S2 := S1 * S1;
     T3 := T1 * T2;  S3 := S1 * S2;

     with Ws_ do
     begin
          _1 :=          S3;
          _2 := 3 * T1 * S2;
          _3 := 3 * T2 * S1;
          _4 :=     T3     ;
     end;
end;

procedure Bezier4( const T_:Double; out Ws_:TDouble4D );
var
   T1, T2, T3,
   S1, S2, S3 :Double;
begin
     T1 :=      T_;  S1 := 1  - T_;
     T2 := T1 * T1;  S2 := S1 * S1;
     T3 := T1 * T2;  S3 := S1 * S2;

     with Ws_ do
     begin
          _1 :=          S3;
          _2 := 3 * T1 * S2;
          _3 := 3 * T2 * S1;
          _4 :=     T3     ;
     end;
end;

procedure Bezier4( const T_:TdSingle; out Ws_:TdSingle4D );
var
   T1, T2, T3,
   S1, S2, S3 :TdSingle;
begin
     T1 :=      T_;  S1 := 1  - T_;
     T2 := T1 * T1;  S2 := S1 * S1;
     T3 := T1 * T2;  S3 := S1 * S2;

     with Ws_ do
     begin
          _1 :=          S3;
          _2 := 3 * T1 * S2;
          _3 := 3 * T2 * S1;
          _4 :=     T3     ;
     end;
end;

procedure Bezier4( const T_:TdDouble; out Ws_:TdDouble4D );
var
   T1, T2, T3,
   S1, S2, S3 :TdDouble;
begin
     T1 :=      T_;  S1 := 1  - T_;
     T2 := T1 * T1;  S2 := S1 * S1;
     T3 := T1 * T2;  S3 := S1 * S2;

     with Ws_ do
     begin
          _1 :=          S3;
          _2 := 3 * T1 * S2;
          _3 := 3 * T2 * S1;
          _4 :=     T3     ;
     end;
end;

//------------------------------------------------------------------------------

function Bezier4( const Ps_:TSingle4D; const T_:Single ) :Single;
var
   Ws :TSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TDouble4D; const T_:Double ) :Double;
var
   Ws :TDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdSingle4D; const T_:TdSingle ) :TdSingle;
var
   Ws :TdSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdDouble4D; const T_:TdDouble ) :TdDouble;
var
   Ws :TdDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

//------------------------------------------------------------------------------

function Bezier4( const Ps_:TSingle4x2D; const T_:Single ) :TSingle2D;
var
   Ws :TSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TDouble4x2D; const T_:Double ) :TDouble2D;
var
   Ws :TDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdSingle4x2D; const T_:TdSingle ) :TdSingle2D;
var
   Ws :TdSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdDouble4x2D; const T_:TdDouble ) :TdDouble2D;
var
   Ws :TdDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

//------------------------------------------------------------------------------

function Bezier4( const Ps_:TSingle4x3D; const T_:Single ) :TSingle3D;
var
   Ws :TSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TDouble4x3D; const T_:Double ) :TDouble3D;
var
   Ws :TDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdSingle4x3D; const T_:TdSingle ) :TdSingle3D;
var
   Ws :TdSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdDouble4x3D; const T_:TdDouble ) :TdDouble3D;
var
   Ws :TdDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

//------------------------------------------------------------------------------

function Bezier( const T_:Single; const Cs_:TSingleND ) :Single;
var
   Cs :TArray<Single>;
   N, I :Integer;
begin
     Cs := Copy( Cs_._Xs );

     for N := High( Cs ) downto 1 do
     begin
          for I := 0 to N-1 do Cs[ I ] := Lerp( Cs[ I ], Cs[ I+1 ], T_ );
     end;

     Result := Cs[ 0 ];
end;

function Bezier( const T_:Double; const Cs_:TDoubleND ) :Double;
var
   Cs :TArray<Double>;
   N, I :Integer;
begin
     Cs := Copy( Cs_._Xs );

     for N := High( Cs ) downto 1 do
     begin
          for I := 0 to N-1 do Cs[ I ] := Lerp( Cs[ I ], Cs[ I+1 ], T_ );
     end;

     Result := Cs[ 0 ];
end;

//------------------------------------------------------------------------------

function TrimBezier( const T0_,T1_:Single ) :TSingleM4;
var
   Td1, Td2, Td3, Tb1, Tb2, Tb3,
   Sd1, Sd2, Sd3, Sb1, Sb2, Sb3,
   W1, W2 :Single;
begin
     Td1 :=     T0_;  Td2 := Td1 * Td1;  Td3 := Td1 * Td2;
     Tb1 := 1 - T0_;  Tb2 := Tb1 * Tb1;  Tb3 := Tb1 * Tb2;
     Sd1 :=     T1_;  Sd2 := Sd1 * Sd1;  Sd3 := Sd1 * Sd2;
     Sb1 := 1 - T1_;  Sb2 := Sb1 * Sb1;  Sb3 := Sb1 * Sb2;

     W1 := T1_ - T0_;  W2 := 2 * W1;

     with Result do
     begin
          _11 := Tb3      ;  _12 :=   3 * Td1 * Tb1        * Tb1;  _13 :=   3 * Td1 * Tb1        * Td1;  _14 := Td3      ;
          _21 := Tb2 * Sb1;  _22 := ( 3 * Td1 * Sb1 + W1 ) * Tb1;  _23 := ( 3 * Td1 * Sb1 + W2 ) * Td1;  _24 := Td2 * Sd1;
          _31 := Tb1 * Sb2;  _32 := ( 3 * Td1 * Sb1 + W2 ) * Sb1;  _33 := ( 3 * Td1 * Sb1 + W1 ) * Sd1;  _34 := Td1 * Sd2;
          _41 :=       Sb3;  _42 :=   3 * Sd1 * Sb1        * Sb1;  _43 :=   3 * Sd1 * Sb1        * Sd1;  _44 :=       Sd3;
     end;
end;

function TrimBezier( const T0_,T1_:Double ) :TDoubleM4;
var
   Td1, Td2, Td3, Tb1, Tb2, Tb3,
   Sd1, Sd2, Sd3, Sb1, Sb2, Sb3,
   W1, W2 :Double;
begin
     Td1 :=     T0_;  Td2 := Td1 * Td1;  Td3 := Td1 * Td2;
     Tb1 := 1 - T0_;  Tb2 := Tb1 * Tb1;  Tb3 := Tb1 * Tb2;
     Sd1 :=     T1_;  Sd2 := Sd1 * Sd1;  Sd3 := Sd1 * Sd2;
     Sb1 := 1 - T1_;  Sb2 := Sb1 * Sb1;  Sb3 := Sb1 * Sb2;

     W1 := T1_ - T0_;  W2 := 2 * W1;

     with Result do
     begin
          _11 := Tb3      ;  _12 :=   3 * Td1 * Tb1        * Tb1;  _13 :=   3 * Td1 * Tb1        * Td1;  _14 := Td3      ;
          _21 := Tb2 * Sb1;  _22 := ( 3 * Td1 * Sb1 + W1 ) * Tb1;  _23 := ( 3 * Td1 * Sb1 + W2 ) * Td1;  _24 := Td2 * Sd1;
          _31 := Tb1 * Sb2;  _32 := ( 3 * Td1 * Sb1 + W2 ) * Sb1;  _33 := ( 3 * Td1 * Sb1 + W1 ) * Sd1;  _34 := Td1 * Sd2;
          _41 :=       Sb3;  _42 :=   3 * Sd1 * Sb1        * Sb1;  _43 :=   3 * Sd1 * Sb1        * Sd1;  _44 :=       Sd3;
     end;
end;

//------------------------------------------------------------------------------

function PolyToBezi( const P_:TSingleND ) :TSingleND;
var
   X, Y :Integer;
begin
     with Result do
     begin
          DimN := P_.DimN;

          for X := 0 to DimN-1 do _Xs[ X ] := P_[ X ] / Comb( DimN-1, X );

          for Y := 1 to DimN-1 do
          begin
               for X := DimN-1 downto Y do _Xs[ X ] := _Xs[ X ] + _Xs[ X-1 ];
          end;
     end;
end;

function PolyToBezi( const P_:TDoubleND ) :TDoubleND;
var
   X, Y :Integer;
begin
     with Result do
     begin
          DimN := P_.DimN;

          for X := 0 to DimN-1 do _Xs[ X ] := P_[ X ] / Comb( DimN-1, X );

          for Y := 1 to DimN-1 do
          begin
               for X := DimN-1 downto Y do _Xs[ X ] := _Xs[ X ] + _Xs[ X-1 ];
          end;
     end;
end;

//------------------------------------------------------------------------------

function BeziToPoly( const P_:TSingleND ) :TSingleND;
var
   X, Y :Integer;
begin
     with Result do
     begin
          _Xs := Copy( P_._Xs );

          for Y := 1 to DimN-1 do
          begin
               for X := DimN-1 downto Y do _Xs[ X ] := _Xs[ X ] - _Xs[ X-1 ];
          end;

          for X := 0 to DimN-1 do _Xs[ X ] := _Xs[ X ] * Comb( DimN-1, X );
     end;
end;

function BeziToPoly( const P_:TDoubleND ) :TDoubleND;
var
   X, Y :Integer;
begin
     with Result do
     begin
          _Xs := Copy( P_._Xs );

          for Y := 1 to DimN-1 do
          begin
               for X := DimN-1 downto Y do _Xs[ X ] := _Xs[ X ] - _Xs[ X-1 ];
          end;

          for X := 0 to DimN-1 do _Xs[ X ] := _Xs[ X ] * Comb( DimN-1, X );
     end;
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
