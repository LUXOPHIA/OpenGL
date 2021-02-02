unit LUX.Curve;

interface //#################################################################### ■

uses LUX,
     LUX.D1;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Delta( const X_:Single ) :Single; overload;
function Delta( const X_:Double ) :Double; overload;

function Sinc( const X_:Single ) :Single; overload;
function Sinc( const X_:Double ) :Double; overload;

function Lerp( const P0_,P1_,T0_,T1_,T_:Single ) :Single; overload;
function Lerp( const P0_,P1_,T0_,T1_,T_:Double ) :Double; overload;
function Lerp( const P0_,P1_,T0_,T1_,T_:TdSingle ) :TdSingle; overload;
function Lerp( const P0_,P1_,T0_,T1_,T_:TdDouble ) :TdDouble; overload;

function Lerp( const P0_,P1_,T_:Single ) :Single; overload;
function Lerp( const P0_,P1_,T_:Double ) :Double; overload;
function Lerp( const P0_,P1_,T_:TdSingle ) :TdSingle; overload;
function Lerp( const P0_,P1_,T_:TdDouble ) :TdDouble; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Delta( const X_:Single ) :Single;
begin
     if Abs( X_ ) < SINGLE_EPS1 then Result := 1
                                else Result := 0;
end;

function Delta( const X_:Double ) :Double;
begin
     if Abs( X_ ) < DOUBLE_EPS1 then Result := 1
                                else Result := 0;
end;

//------------------------------------------------------------------------------

function Sinc( const X_:Single ) :Single;
begin
     if Abs( X_ ) < SINGLE_EPS1 then Result := 1
                                else Result := Sin( Pi * X_ ) / ( Pi * X_ );
end;

function Sinc( const X_:Double ) :Double;
begin
     if Abs( X_ ) < DOUBLE_EPS1 then Result := 1
                                else Result := Sin( Pi * X_ ) / ( Pi * X_ );
end;

//------------------------------------------------------------------------------

function Lerp( const P0_,P1_,T0_,T1_,T_:Single ) :Single;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

function Lerp( const P0_,P1_,T0_,T1_,T_:Double ) :Double;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

function Lerp( const P0_,P1_,T0_,T1_,T_:TdSingle ) :TdSingle;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

function Lerp( const P0_,P1_,T0_,T1_,T_:TdDouble ) :TdDouble;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

//------------------------------------------------------------------------------

function Lerp( const P0_,P1_,T_:Single ) :Single;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

function Lerp( const P0_,P1_,T_:Double ) :Double;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

function Lerp( const P0_,P1_,T_:TdSingle ) :TdSingle;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

function Lerp( const P0_,P1_,T_:TdDouble ) :TdDouble;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
