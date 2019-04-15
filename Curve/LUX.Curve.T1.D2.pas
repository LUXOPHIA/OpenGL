unit LUX.Curve.T1.D2;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2, LUX.D2.V4,
     LUX.D4,
     LUX.Curve.T1.D1;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Sinc( const X_,Y_:Single ) :Single; overload;
function Sinc( const X_,Y_:Double ) :Double; overload;

function CatmullRom( const P0_,P1_,P2_,P3_:TSingle2D; const T_:Single ) :TSingle2D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TDouble2D; const T_:Double ) :TDouble2D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TdSingle2D; const T_:TdSingle ) :TdSingle2D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TdDouble2D; const T_:TdDouble ) :TdDouble2D; overload;

function Delta( const X_,Y_:Single ) :Single; overload;
function Delta( const X_,Y_:Double ) :Double; overload;

function BSpline4( const X_,Y_:Single ) :Single; overload;
function BSpline4( const X_,Y_:Double ) :Double; overload;
function BSpline4( const X_,Y_:TdSingle ) :TdSingle; overload;
function BSpline4( const X_,Y_:TdDouble ) :TdDouble; overload;

function Bezier4( const Ps_:TSingle2DV4; const T_:Single ) :TSingle2D; overload;
function Bezier4( const Ps_:TDouble2DV4; const T_:Double ) :TDouble2D; overload;
function Bezier4( const Ps_:TdSingle2DV4; const T_:TdSingle ) :TdSingle2D; overload;
function Bezier4( const Ps_:TdDouble2DV4; const T_:TdDouble ) :TdDouble2D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Sinc( const X_,Y_:Single ) :Single;
begin
     Result := Sinc( Y_ ) * Sinc( X_ );
end;

function Sinc( const X_,Y_:Double ) :Double;
begin
     Result := Sinc( Y_ ) * Sinc( X_ );
end;

//------------------------------------------------------------------------------

function CatmullRom( const P0_,P1_,P2_,P3_:TSingle2D; const T_:Single ) :TSingle2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TDouble2D; const T_:Double ) :TDouble2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TdSingle2D; const T_:TdSingle ) :TdSingle2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TdDouble2D; const T_:TdDouble ) :TdDouble2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

//------------------------------------------------------------------------------

function Delta( const X_,Y_:Single ) :Single;
begin
     Result := Delta( Y_ ) * Delta( X_ );
end;

function Delta( const X_,Y_:Double ) :Double;
begin
     Result := Delta( Y_ ) * Delta( X_ );
end;

//------------------------------------------------------------------------------

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

function Bezier4( const Ps_:TSingle2DV4; const T_:Single ) :TSingle2D;
var
   Ws :TSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TDouble2DV4; const T_:Double ) :TDouble2D;
var
   Ws :TDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdSingle2DV4; const T_:TdSingle ) :TdSingle2D;
var
   Ws :TdSingle4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

function Bezier4( const Ps_:TdDouble2DV4; const T_:TdDouble ) :TdDouble2D;
var
   Ws :TdDouble4D;
begin
     Bezier4( T_, Ws );

     with Ws do Result := _1 * Ps_._1
                        + _2 * Ps_._2
                        + _3 * Ps_._3
                        + _4 * Ps_._4;
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
