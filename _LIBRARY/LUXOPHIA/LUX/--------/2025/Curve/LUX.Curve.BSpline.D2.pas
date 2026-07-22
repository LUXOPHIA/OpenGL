unit LUX.Curve.BSpline.D2;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2,
     LUX.D4, LUX.D4x4,
     LUX.Curve, LUX.Curve.BSpline;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function BSpline4( const X_,Y_:Single ) :Single; overload;
function BSpline4( const X_,Y_:Double ) :Double; overload;
function BSpline4( const X_,Y_:TdSingle ) :TdSingle; overload;
function BSpline4( const X_,Y_:TdDouble ) :TdDouble; overload;

procedure BSplin4( const T_:TSingle2D; out Ws_:TSingleM4 ); overload;
procedure BSplin4( const T_:TDouble2D; out Ws_:TDoubleM4 ); overload;
procedure BSplin4( const T_:TdSingle2D; out Ws_:TdSingleM4 ); overload;
procedure BSplin4( const T_:TdDouble2D; out Ws_:TdDoubleM4 ); overload;

function BSplin4( const Ps_:TSingleM4; const T_:TSingle2D ) :Single; overload;
function BSplin4( const Ps_:TDoubleM4; const T_:TDouble2D ) :Double; overload;
function BSplin4( const Ps_:TdSingleM4; const T_:TdSingle2D ) :TdSingle; overload;
function BSplin4( const Ps_:TdDoubleM4; const T_:TdDouble2D ) :TdDouble; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function BSpline4( const X_,Y_:Single ) :Single;
begin
     Result := BSpline4( Y_ ) * BSpline4( X_ );
end;

function BSpline4( const X_,Y_:Double ) :Double;
begin
     Result := BSpline4( Y_ ) * BSpline4( X_ );
end;

function BSpline4( const X_,Y_:TdSingle ) :TdSingle;
begin
     Result := BSpline4( Y_ ) * BSpline4( X_ );
end;

function BSpline4( const X_,Y_:TdDouble ) :TdDouble;
begin
     Result := BSpline4( Y_ ) * BSpline4( X_ );
end;

//------------------------------------------------------------------------------

procedure BSplin4( const T_:TSingle2D; out Ws_:TSingleM4 );
var
   WX, WY :TSingle4D;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

     with Ws_ do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

procedure BSplin4( const T_:TDouble2D; out Ws_:TDoubleM4 );
var
   WX, WY :TDouble4D;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

     with Ws_ do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

procedure BSplin4( const T_:TdSingle2D; out Ws_:TdSingleM4 );
var
   WX, WY :TdSingle4D;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

     with Ws_ do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

procedure BSplin4( const T_:TdDouble2D; out Ws_:TdDoubleM4 );
var
   WX, WY :TdDouble4D;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

     with Ws_ do
     begin
          _11 := WY._1 * WX._1;  _12 := WY._1 * WX._2;  _13 := WY._1 * WX._3;  _14 := WY._1 * WX._4;
          _21 := WY._2 * WX._1;  _22 := WY._2 * WX._2;  _23 := WY._2 * WX._3;  _24 := WY._2 * WX._4;
          _31 := WY._3 * WX._1;  _32 := WY._3 * WX._2;  _33 := WY._3 * WX._3;  _34 := WY._3 * WX._4;
          _41 := WY._4 * WX._1;  _42 := WY._4 * WX._2;  _43 := WY._4 * WX._3;  _44 := WY._4 * WX._4;
     end;
end;

//------------------------------------------------------------------------------

function BSplin4( const Ps_:TSingleM4; const T_:TSingle2D ) :Single;
var
   WX, WY :TSingle4D;
   P1, P2, P3, P4 :Single;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

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

function BSplin4( const Ps_:TDoubleM4; const T_:TDouble2D ) :Double;
var
   WX, WY :TDouble4D;
   P1, P2, P3, P4 :Double;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

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

function BSplin4( const Ps_:TdSingleM4; const T_:TdSingle2D ) :TdSingle;
var
   WX, WY :TdSingle4D;
   P1, P2, P3, P4 :TdSingle;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

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

function BSplin4( const Ps_:TdDoubleM4; const T_:TdDouble2D ) :TdDouble;
var
   WX, WY :TdDouble4D;
   P1, P2, P3, P4 :TdDouble;
begin
     BSpline4( T_.X, WX );
     BSpline4( T_.Y, WY );

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

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
