unit LUX.Curve.Bezier.D2;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2, LUX.D2x4, LUX.D2x4x4,
     LUX.D3, LUX.D3x4, LUX.D3x4x4,
     LUX.D4, LUX.D4x4,
     LUX.Curve, LUX.Curve.Bezier;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Bezier4( const T_:TSingle2D ) :TSingleM4; overload;
function Bezier4( const T_:TDouble2D ) :TDoubleM4; overload;
function Bezier4( const T_:TdSingle2D ) :TdSingleM4; overload;
function Bezier4( const T_:TdDouble2D ) :TdDoubleM4; overload;

function Bezier4( const Ps_:TSingleM4; const T_:TSingle2D ) :Single; overload;
function Bezier4( const Ps_:TDoubleM4; const T_:TDouble2D ) :Double; overload;
function Bezier4( const Ps_:TdSingleM4; const T_:TdSingle2D ) :TdSingle; overload;
function Bezier4( const Ps_:TdDoubleM4; const T_:TdDouble2D ) :TdDouble; overload;

function Bezier4( const Ps_:TSingle4x4x2D; const T_:TSingle2D ) :TSingle2D; overload;
function Bezier4( const Ps_:TDouble4x4x2D; const T_:TDouble2D ) :TDouble2D; overload;
function Bezier4( const Ps_:TdSingle4x4x2D; const T_:TdSingle2D ) :TdSingle2D; overload;
function Bezier4( const Ps_:TdDouble4x4x2D; const T_:TdDouble2D ) :TdDouble2D; overload;

function Bezier4( const Ps_:TSingle4x4x3D; const T_:TSingle2D ) :TSingle3D; overload;
function Bezier4( const Ps_:TDouble4x4x3D; const T_:TDouble2D ) :TDouble3D; overload;
function Bezier4( const Ps_:TdSingle4x4x3D; const T_:TdSingle2D ) :TdSingle3D; overload;
function Bezier4( const Ps_:TdDouble4x4x3D; const T_:TdDouble2D ) :TdDouble3D; overload;

function TensorBezier4( const Ps_:TSingle4x4x3D; const T_:TSingle2D ) :TSingleM4; overload;
function TensorBezier4( const Ps_:TDouble4x4x3D; const T_:TDouble2D ) :TDoubleM4; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Bezier4( const T_:TSingle2D ) :TSingleM4;
var
   WX, WY :TSingle4D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with Result do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

function Bezier4( const T_:TDouble2D ) :TDoubleM4;
var
   WX, WY :TDouble4D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with Result do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

function Bezier4( const T_:TdSingle2D ) :TdSingleM4;
var
   WX, WY :TdSingle4D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with Result do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

function Bezier4( const T_:TdDouble2D ) :TdDoubleM4;
var
   WX, WY :TdDouble4D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with Result do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

//------------------------------------------------------------------------------

function Bezier4( const Ps_:TSingleM4; const T_:TSingle2D ) :Single;
var
   WX, WY :TSingle4D;
   P1, P2, P3, P4 :Single;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TDoubleM4; const T_:TDouble2D ) :Double;
var
   WX, WY :TDouble4D;
   P1, P2, P3, P4 :Double;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TdSingleM4; const T_:TdSingle2D ) :TdSingle;
var
   WX, WY :TdSingle4D;
   P1, P2, P3, P4 :TdSingle;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TdDoubleM4; const T_:TdDouble2D ) :TdDouble;
var
   WX, WY :TdDouble4D;
   P1, P2, P3, P4 :TdDouble;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

//------------------------------------------------------------------------------

function Bezier4( const Ps_:TSingle4x4x2D; const T_:TSingle2D ) :TSingle2D;
var
   WX, WY :TSingle4D;
   P1, P2, P3, P4 :TSingle2D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TDouble4x4x2D; const T_:TDouble2D ) :TDouble2D;
var
   WX, WY :TDouble4D;
   P1, P2, P3, P4 :TDouble2D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TdSingle4x4x2D; const T_:TdSingle2D ) :TdSingle2D;
var
   WX, WY :TdSingle4D;
   P1, P2, P3, P4 :TdSingle2D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TdDouble4x4x2D; const T_:TdDouble2D ) :TdDouble2D;
var
   WX, WY :TdDouble4D;
   P1, P2, P3, P4 :TdDouble2D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

//------------------------------------------------------------------------------

function Bezier4( const Ps_:TSingle4x4x3D; const T_:TSingle2D ) :TSingle3D;
var
   WX, WY :TSingle4D;
   P1, P2, P3, P4 :TSingle3D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TDouble4x4x3D; const T_:TDouble2D ) :TDouble3D;
var
   WX, WY :TDouble4D;
   P1, P2, P3, P4 :TDouble3D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TdSingle4x4x3D; const T_:TdSingle2D ) :TdSingle3D;
var
   WX, WY :TdSingle4D;
   P1, P2, P3, P4 :TdSingle3D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

function Bezier4( const Ps_:TdDouble4x4x3D; const T_:TdDouble2D ) :TdDouble3D;
var
   WX, WY :TdDouble4D;
   P1, P2, P3, P4 :TdDouble3D;
begin
     Bezier4( T_.X, WX );
     Bezier4( T_.Y, WY );

     with WX do
     begin
          P1 := _1 * Ps_._11 + _2 * Ps_._12 + _3 * Ps_._13 + _4 * Ps_._14;
          P2 := _1 * Ps_._21 + _2 * Ps_._22 + _3 * Ps_._23 + _4 * Ps_._24;
          P3 := _1 * Ps_._31 + _2 * Ps_._32 + _3 * Ps_._33 + _4 * Ps_._34;
          P4 := _1 * Ps_._41 + _2 * Ps_._42 + _3 * Ps_._43 + _4 * Ps_._44;
     end;

     with WY do
     begin
          Result := _1 * P1 + _2 * P2 + _3 * P3 + _4 * P4;
     end;
end;

//------------------------------------------------------------------------------

function TensorBezier4( const Ps_:TSingle4x4x3D; const T_:TSingle2D ) :TSingleM4;
var
   Ps :TdSingle4x4x3D;
   T :TdSingle2D;
   AP, AX, AY, AZ :TSingle3D;
begin
     Ps := Ps_;
     T  := T_ ;

     T.X.d := +1;
     T.Y.d :=  0;

     with Bezier4( Ps_, T ) do
     begin
          AP := o;
          AX := d;
     end;

     T.X.d :=  0;
     T.Y.d := -1;

     with Bezier4( Ps_, T ) do
     begin
          AY := d;
     end;

     AZ := CrossProduct( AX, AY );

     Result := TSingleM4.Identity;

     with Result do
     begin
          AxisP := AP;
          AxisX := AX.Unitor;
          AxisY := AY.Unitor;
          AxisZ := AZ.Unitor;
     end;
end;

function TensorBezier4( const Ps_:TDouble4x4x3D; const T_:TDouble2D ) :TDoubleM4;
var
   Ps :TdDouble4x4x3D;
   T :TdDouble2D;
   AP, AX, AY, AZ :TDouble3D;
begin
     Ps := Ps_;
     T  := T_ ;

     T.X.d := +1;
     T.Y.d :=  0;

     with Bezier4( Ps_, T ) do
     begin
          AP := o;
          AX := d;
     end;

     T.X.d :=  0;
     T.Y.d := -1;

     with Bezier4( Ps_, T ) do
     begin
          AY := d;
     end;

     AZ := CrossProduct( AX, AY );

     Result := TDoubleM4.Identity;

     with Result do
     begin
          AxisP := AP;
          AxisX := AX.Unitor;
          AxisY := AY.Unitor;
          AxisZ := AZ.Unitor;
     end;
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
