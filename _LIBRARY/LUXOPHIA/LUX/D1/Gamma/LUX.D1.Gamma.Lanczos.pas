unit LUX.D1.Gamma.Lanczos;

interface //#################################################################### ■

uses LUX;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//  Lanczos 近似による実数ガンマ関数。
//  関数名の数字は係数の項数を表す:
//    RLnGamma7 /RGamma7  … N= 7, g=5        (Numerical Recipes)
//    RLnGamma9 /RGamma9  … N= 9, g=7
//    RLnGamma11/RGamma11 … N=11, g=9
//    RLnGamma15/RGamma15 … N=15, g=607/128  (Boost 系・最高精度)
//
//  ※ 非正整数 (0, -1, -2, ...) は極であり、内部で0除算が発生する。
//     浮動小数点例外がマスクされた既定環境 (Delphi 12+ / FMX) では INF/NaN を返し、
//     SetExceptionMask で例外を有効化した環境では EZeroDivide 等が発生する。
//  ※ RLnGamma* は Γ(x)<0 となる区間 (-1<x<0, -3<x<-2, ...) では NaN を返す。

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RLnGamma*

function RLnGamma7( const X_:Single ) :Single; overload;
function RLnGamma7( const X_:Double ) :Double; overload;
function RLnGamma9( const X_:Single ) :Single; overload;
function RLnGamma9( const X_:Double ) :Double; overload;
function RLnGamma11( const X_:Single ) :Single; overload;
function RLnGamma11( const X_:Double ) :Double; overload;
function RLnGamma15( const X_:Single ) :Single; overload;
function RLnGamma15( const X_:Double ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RGamma*

function RGamma7( const X_:Single ) :Single; overload;
function RGamma7( const X_:Double ) :Double; overload;
function RGamma9( const X_:Single ) :Single; overload;
function RGamma9( const X_:Double ) :Double; overload;
function RGamma11( const X_:Single ) :Single; overload;
function RGamma11( const X_:Double ) :Double; overload;
function RGamma15( const X_:Single ) :Single; overload;
function RGamma15( const X_:Double ) :Double; overload;

implementation //############################################################### ■

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      _LC7g :Double = 5;
      _LC7s :array [ 0..7-1 ] of Double = (
               +1.000000000190015    ,
              +76.18009172947146     ,
              -86.50532032941677     ,
              +24.01409824083091     ,
               -1.231739572450155    ,
               +0.1208650973866179e-2,
               -0.5395239384953e-5    );

      _LC9g :Double = 7;
      _LC9s :array [ 0..9-1 ] of Double = (
               +0.99999999999980993227684700473478,
             +676.520368121885098567009190444019  ,
            -1259.13921672240287047156078755283   ,
             +771.3234287776530788486528258894    ,
             -176.61502916214059906584551354      ,
              +12.507343278686904814458936853     ,
               -0.13857109526572011689554707      ,
               +9.984369578019570859563e-6        ,
               +1.50563273514931155834e-7          );

      _LC11g :Double = 9;
      _LC11s :array [ 0..11-1 ] of Double = (
               +1.000000000000000174663    ,
            +5716.400188274341379136       ,
           -14815.30426768413909044        ,
           +14291.49277657478554025        ,
            -6348.160217641458813289       ,
            +1301.608286058321874105       ,
             -108.1767053514369634679      ,
               +2.605696505611755827729    ,
               -0.7423452510201416151527e-2,
               +0.5384136432509564062961e-7,
               -0.4023533141268236372067e-8 );

      _LC15g :Double = 607/128;
      _LC15s :array [ 0..15-1 ] of Double = (
               +0.99999999999999709182   ,
              +57.156235665862923517     ,
              -59.597960355475491248     ,
              +14.136097974741747174     ,
               -0.49191381609762019978   ,
               +0.33994649984811888699e-4,
               +0.46523628927048575665e-4,
               -0.98374475304879564677e-4,
               +0.15808870322491248884e-3,
               -0.21026444172410488319e-3,
               +0.21743961811521264320e-3,
               -0.16431810653676389022e-3,
               +0.84418223983852743293e-4,
               -0.26190838401581408670e-4,
               +0.36899182659531622704e-5 );

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RLnGamma*

function RLnGammaP( const X_:Single; const LCg_:Double; const LCs_:array of Double ) :Single; overload;  // 0 < X
var
   X1, B, A :Single;
   I :Integer;
begin
     X1 := X_ - 1;

     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );

     B := X1 + LCg_ + 0.5;

     Result := Ln(Pi2)/2 + Ln( A ) - B + Ln( B ) * ( X1 + 0.5 );
end;

function RLnGammaP( const X_:Double; const LCg_:Double; const LCs_:array of Double ) :Double; overload;  // 0 < X
var
   X1, B, A :Double;
   I :Integer;
begin
     X1 := X_ - 1;

     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );

     B := X1 + LCg_ + 0.5;

     Result := Ln(Pi2)/2 + Ln( A ) - B + Ln( B ) * ( X1 + 0.5 );
end;

//------------------------------------------------------------------------------

function RLnGamma( const X_:Single; const LCg_:Double; const LCs_:array of Double ) :Single; overload;
begin
     if X_ < 0.5 then Result := Ln( Pi / Sin( Pi * X_ ) ) - RLnGammaP( 1 - X_, LCg_, LCs_ )
                 else Result :=                             RLnGammaP(     X_, LCg_, LCs_ );
end;

function RLnGamma( const X_:Double; const LCg_:Double; const LCs_:array of Double ) :Double; overload;
begin
     if X_ < 0.5 then Result := Ln( Pi / Sin( Pi * X_ ) ) - RLnGammaP( 1 - X_, LCg_, LCs_ )
                 else Result :=                             RLnGammaP(     X_, LCg_, LCs_ );
end;

//------------------------------------------------------------------------------

function RLnGamma7( const X_:Single ) :Single;
begin
     Result := RLnGamma( X_, _LC7g, _LC7s );
end;

function RLnGamma7( const X_:Double ) :Double;
begin
     Result := RLnGamma( X_, _LC7g, _LC7s );
end;

function RLnGamma9( const X_:Single ) :Single;
begin
     Result := RLnGamma( X_, _LC9g, _LC9s );
end;

function RLnGamma9( const X_:Double ) :Double;
begin
     Result := RLnGamma( X_, _LC9g, _LC9s );
end;

function RLnGamma11( const X_:Single ) :Single;
begin
     Result := RLnGamma( X_, _LC11g, _LC11s );
end;

function RLnGamma11( const X_:Double ) :Double;
begin
     Result := RLnGamma( X_, _LC11g, _LC11s );
end;

function RLnGamma15( const X_:Single ) :Single;
begin
     Result := RLnGamma( X_, _LC15g, _LC15s );
end;

function RLnGamma15( const X_:Double ) :Double;
begin
     Result := RLnGamma( X_, _LC15g, _LC15s );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RGamma*

function RGammaP( const X_:Single; const LCg_:Double; const LCs_:array of Double ) :Single; overload;  // 0 < X
var
   X1, B, A :Single;
   I :Integer;
begin
     // Result := Exp( RLnGammaP( X_, LCg_, LCs_ ) );
	 
     X1 := X_ - 1;
     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );
     B := X1 + LCg_ + 0.5;
     Result := A * Exp( Ln( B ) * ( X1 + 0.5 ) - B + Ln(Pi2)/2 );
end;

function RGammaP( const X_:Double; const LCg_:Double; const LCs_:array of Double ) :Double; overload;  // 0 < X
var
   X1, B, A :Double;
   I :Integer;
begin
     // Result := Exp( RLnGammaP( X_, LCg_, LCs_ ) );
	 
     X1 := X_ - 1;
     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );
     B := X1 + LCg_ + 0.5;
     Result := A * Exp( Ln( B ) * ( X1 + 0.5 ) - B + Ln(Pi2)/2 );
end;

//------------------------------------------------------------------------------

function RGamma( const X_:Single; const LCg_:Double; const LCs_:array of Double ) :Single; overload;
begin
     if X_ < 0.5 then Result := Pi / ( Sin( Pi * X_ ) * RGammaP( 1 - X_, LCg_, LCs_ ) )
                 else Result :=                         RGammaP(     X_, LCg_, LCs_ );
end;

function RGamma( const X_:Double; const LCg_:Double; const LCs_:array of Double ) :Double; overload;
begin
     if X_ < 0.5 then Result := Pi / ( Sin( Pi * X_ ) * RGammaP( 1 - X_, LCg_, LCs_ ) )
                 else Result :=                         RGammaP(     X_, LCg_, LCs_ );
end;

//------------------------------------------------------------------------------

function RGamma7( const X_:Single ) :Single;
begin
     Result := RGamma( X_, _LC7g, _LC7s );
end;

function RGamma7( const X_:Double ) :Double;
begin
     Result := RGamma( X_, _LC7g, _LC7s );
end;

function RGamma9( const X_:Single ) :Single;
begin
     Result := RGamma( X_, _LC9g, _LC9s );
end;

function RGamma9( const X_:Double ) :Double;
begin
     Result := RGamma( X_, _LC9g, _LC9s );
end;

function RGamma11( const X_:Single ) :Single;
begin
     Result := RGamma( X_, _LC11g, _LC11s );
end;

function RGamma11( const X_:Double ) :Double;
begin
     Result := RGamma( X_, _LC11g, _LC11s );
end;

function RGamma15( const X_:Single ) :Single;
begin
     Result := RGamma( X_, _LC15g, _LC15s );
end;

function RGamma15( const X_:Double ) :Double;
begin
     Result := RGamma( X_, _LC15g, _LC15s );
end;

end. //######################################################################### ■