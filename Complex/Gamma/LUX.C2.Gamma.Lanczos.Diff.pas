unit LUX.C2.Gamma.Lanczos.Diff;

interface //#################################################################### ■

uses LUX, LUX.Complex.Diff;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//  Lanczos 近似による複素ガンマ関数 (双対数による自動微分対応版)。
//  関数名の数字は係数の項数を表す:
//    LnGamma7 /Gamma7  … N= 7, g=5        (Numerical Recipes)
//    LnGamma9 /Gamma9  … N= 9, g=7
//    LnGamma11/Gamma11 … N=11, g=9
//    LnGamma15/Gamma15 … N=15, g=607/128  (Boost 系・最高精度)
//
//  ※ 非正整数 (0, -1, -2, ...) は極であり、内部で0除算が発生する。
//     浮動小数点例外がマスクされた既定環境 (Delphi 12+ / FMX) では INF/NaN を返し、
//     SetExceptionMask で例外を有効化した環境では EZeroDivide 等が発生する。

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LnGamma*

//  注意: LnGamma* は exp(LnGamma(z)) = Γ(z) を満たす対数を返すが、主枝 (lgamma 相当の
//        連続な log-gamma) ではなく、2πi の整数倍だけ異なる場合がある。

function LnGamma7( const X_:TdSingleC ) :TdSingleC; overload;
function LnGamma7( const X_:TdDoubleC ) :TdDoubleC; overload;
function LnGamma9( const X_:TdSingleC ) :TdSingleC; overload;
function LnGamma9( const X_:TdDoubleC ) :TdDoubleC; overload;
function LnGamma11( const X_:TdSingleC ) :TdSingleC; overload;
function LnGamma11( const X_:TdDoubleC ) :TdDoubleC; overload;
function LnGamma15( const X_:TdSingleC ) :TdSingleC; overload;
function LnGamma15( const X_:TdDoubleC ) :TdDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gamma*

function Gamma7( const X_:TdSingleC ) :TdSingleC; overload;
function Gamma7( const X_:TdDoubleC ) :TdDoubleC; overload;
function Gamma9( const X_:TdSingleC ) :TdSingleC; overload;
function Gamma9( const X_:TdDoubleC ) :TdDoubleC; overload;
function Gamma11( const X_:TdSingleC ) :TdSingleC; overload;
function Gamma11( const X_:TdDoubleC ) :TdDoubleC; overload;
function Gamma15( const X_:TdSingleC ) :TdSingleC; overload;
function Gamma15( const X_:TdDoubleC ) :TdDoubleC; overload;

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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LnGamma*

function LnGammaP( const X_:TdSingleC; const LCg_:Double; const LCs_:array of Double ) :TdSingleC; overload;  // 0 < X
var
   X1, B, A :TdSingleC;
   I :Integer;
begin
     X1 := X_ - 1;

     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );

     B := X1 + LCg_ + 0.5;

     Result := Ln(Pi2)/2 + Ln( A ) - B + Ln( B ) * ( X1 + 0.5 );
end;

function LnGammaP( const X_:TdDoubleC; const LCg_:Double; const LCs_:array of Double ) :TdDoubleC; overload;  // 0 < X
var
   X1, B, A :TdDoubleC;
   I :Integer;
begin
     X1 := X_ - 1;

     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );

     B := X1 + LCg_ + 0.5;

     Result := Ln(Pi2)/2 + Ln( A ) - B + Ln( B ) * ( X1 + 0.5 );
end;

//------------------------------------------------------------------------------

function LnGamma( X_:TdSingleC; const LCg_:Double; const LCs_:array of Double ) :TdSingleC; overload;
begin
     if X_.R < 0.5 then Result := Ln( Pi / Sin( Pi * X_ ) ) - LnGammaP( 1 - X_, LCg_, LCs_ )
                   else Result :=                             LnGammaP(     X_, LCg_, LCs_ );
end;

function LnGamma( X_:TdDoubleC; const LCg_:Double; const LCs_:array of Double ) :TdDoubleC; overload;
begin
     if X_.R < 0.5 then Result := Ln( Pi / Sin( Pi * X_ ) ) - LnGammaP( 1 - X_, LCg_, LCs_ )
                   else Result :=                             LnGammaP(     X_, LCg_, LCs_ );
end;

//------------------------------------------------------------------------------

function LnGamma7( const X_:TdSingleC ) :TdSingleC;
begin
     Result := LnGamma( X_, _LC7g, _LC7s );
end;

function LnGamma7( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := LnGamma( X_, _LC7g, _LC7s );
end;

function LnGamma9( const X_:TdSingleC ) :TdSingleC;
begin
     Result := LnGamma( X_, _LC9g, _LC9s );
end;

function LnGamma9( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := LnGamma( X_, _LC9g, _LC9s );
end;

function LnGamma11( const X_:TdSingleC ) :TdSingleC;
begin
     Result := LnGamma( X_, _LC11g, _LC11s );
end;

function LnGamma11( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := LnGamma( X_, _LC11g, _LC11s );
end;

function LnGamma15( const X_:TdSingleC ) :TdSingleC;
begin
     Result := LnGamma( X_, _LC15g, _LC15s );
end;

function LnGamma15( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := LnGamma( X_, _LC15g, _LC15s );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gamma*

function GammaP( const X_:TdSingleC; const LCg_:Double; const LCs_:array of Double ) :TdSingleC; overload;  // 0 < X
var
   X1, B, A :TdSingleC;
   I :Integer;
begin
     // Result := Exp( LnGammaP( X_, LCg_, LCs_ ) );
	 
     X1 := X_ - 1;
     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );
     B := X1 + LCg_ + 0.5;
     Result := A * Exp( Ln( B ) * ( X1 + 0.5 ) - B + Ln(Pi2)/2 );
end;

function GammaP( const X_:TdDoubleC; const LCg_:Double; const LCs_:array of Double ) :TdDoubleC; overload;  // 0 < X
var
   X1, B, A :TdDoubleC;
   I :Integer;
begin
     // Result := Exp( LnGammaP( X_, LCg_, LCs_ ) );
	 
     X1 := X_ - 1;
     A := LCs_[ 0 ];
     for I := 1 to High( LCs_ ) do A := A + LCs_[ I ] / ( X1 + I );
     B := X1 + LCg_ + 0.5;
     Result := A * Exp( Ln( B ) * ( X1 + 0.5 ) - B + Ln(Pi2)/2 );
end;

//------------------------------------------------------------------------------

function Gamma( const X_:TdSingleC; const LCg_:Double; const LCs_:array of Double ) :TdSingleC; overload;
begin
     if X_.R < 0.5 then Result := Pi / ( Sin( Pi * X_ ) * GammaP( 1 - X_, LCg_, LCs_ ) )
                   else Result :=                         GammaP(     X_, LCg_, LCs_ );
end;

function Gamma( const X_:TdDoubleC; const LCg_:Double; const LCs_:array of Double ) :TdDoubleC; overload;
begin
     if X_.R < 0.5 then Result := Pi / ( Sin( Pi * X_ ) * GammaP( 1 - X_, LCg_, LCs_ ) )
                   else Result :=                         GammaP(     X_, LCg_, LCs_ );
end;

//------------------------------------------------------------------------------

function Gamma7( const X_:TdSingleC ) :TdSingleC;
begin
     Result := Gamma( X_, _LC7g, _LC7s );
end;

function Gamma7( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := Gamma( X_, _LC7g, _LC7s );
end;

function Gamma9( const X_:TdSingleC ) :TdSingleC;
begin
     Result := Gamma( X_, _LC9g, _LC9s );
end;

function Gamma9( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := Gamma( X_, _LC9g, _LC9s );
end;

function Gamma11( const X_:TdSingleC ) :TdSingleC;
begin
     Result := Gamma( X_, _LC11g, _LC11s );
end;

function Gamma11( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := Gamma( X_, _LC11g, _LC11s );
end;

function Gamma15( const X_:TdSingleC ) :TdSingleC;
begin
     Result := Gamma( X_, _LC15g, _LC15s );
end;

function Gamma15( const X_:TdDoubleC ) :TdDoubleC;
begin
     Result := Gamma( X_, _LC15g, _LC15s );
end;

end. //######################################################################### ■