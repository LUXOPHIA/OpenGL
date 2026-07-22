unit LUX.D1.Legendre.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendre

function NLegendre( const X_:TdSingle; const N_:Integer ) :TdSingle; overload;
function NLegendre( const X_:TdDouble; const N_:Integer ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendreCos

function NLegendreCos( const T_:TdSingle; const N_:Integer ) :TdSingle; overload;
function NLegendreCos( const T_:TdDouble; const N_:Integer ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendre

function dNLegendre( const X_:TdSingle; const N_:Integer ) :TdSingle; overload;
function dNLegendre( const X_:TdDouble; const N_:Integer ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendreCos

function dNLegendreCos( const T_:TdSingle; const N_:Integer ) :TdSingle; overload;
function dNLegendreCos( const T_:TdDouble; const N_:Integer ) :TdDouble; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendre

function NLegendre( const X_:TdSingle; const N_:Integer ) :TdSingle;
begin
     Result := NLegendreCos( ArcCos( X_ ), N_ );
end;

function NLegendre( const X_:TdDouble; const N_:Integer ) :TdDouble;
begin
     Result := NLegendreCos( ArcCos( X_ ), N_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendreCos

{
function NLegendreCos( const T_:TdSingle; const N_:Integer ) :TdSingle;
begin
     Result.o :=  NLegendreCos( T_.o, N_ );
     Result.d := dNLegendreCos( T_.o, N_ ) * T_.d;
end;
}
function NLegendreCos( const T_:TdSingle; const N_:Integer ) :TdSingle;
// - - - - - - - - - - - - - - - - - - -
     function FNN( const N_:Integer ) :TdSingle;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function FN20( const K0_:Integer; const F2_:TdSingle ) :TdSingle;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :TdSingle;
   K, I :Integer;
begin
     Result := 0;

     K := N_;  A := FNN( K );

     for I := 1 to N_ div 2 do
     begin
          Result := Result + A * Cos( K * T_ );

          Dec( K, 2 );

          A := FN20( K, A );
     end;

     if N_ mod 2 = 0 then Result := Result + A / 2           // K = 0
                     else Result := Result + A * Cos( T_ );  // K = 1
end;

{
function NLegendreCos( const T_:TdDouble; const N_:Integer ) :TdDouble;
begin
     Result.o :=  NLegendreCos( T_.o, N_ );
     Result.d := dNLegendreCos( T_.o, N_ ) * T_.d;
end;
}
function NLegendreCos( const T_:TdDouble; const N_:Integer ) :TdDouble;
// - - - - - - - - - - - - - - - - - - -
     function ANN( const N_:Integer ) :TdDouble;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function AN20( const K0_:Integer; const F2_:TdDouble ) :TdDouble;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :TdDouble;
   K, I :Integer;
begin
     Result := 0;

     K := N_;  A := ANN( K );

     for I := 1 to N_ div 2 do
     begin
          Result := Result + A * Cos( K * T_ );

          Dec( K, 2 );

          A := AN20( K, A );
     end;

     if N_ mod 2 = 0 then Result := Result + A / 2           // K = 0
                     else Result := Result + A * Cos( T_ );  // K = 1
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendre

function dNLegendre( const X_:TdSingle; const N_:Integer ) :TdSingle;
begin
     Result := -1 / Roo2( 1 - Pow2( X_ ) ) * dNLegendreCos( ArcCos( X_ ), N_ );
end;

function dNLegendre( const X_:TdDouble; const N_:Integer ) :TdDouble;
begin
     Result := -1 / Roo2( 1 - Pow2( X_ ) ) * dNLegendreCos( ArcCos( X_ ), N_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendreCos

function dNLegendreCos( const T_:TdSingle; const N_:Integer ) :TdSingle;
// - - - - - - - - - - - - - - - - - - -
     function FNN( const N_:Integer ) :TdSingle;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function FN20( const K0_:Integer; const F2_:TdSingle ) :TdSingle;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :TdSingle;
   K, I :Integer;
begin
     Result := 0;

     K := N_;  A := FNN( K );

     for I := 1 to N_ div 2 do
     begin
          Result := Result - A * K * Sin( K * T_ );

          Dec( K, 2 );

          A := FN20( K, A );
     end;

     if N_ mod 2 = 1 then Result := Result - A * Sin( T_ );  // K = 1
end;

function dNLegendreCos( const T_:TdDouble; const N_:Integer ) :TdDouble;
// - - - - - - - - - - - - - - - - - - -
     function ANN( const N_:Integer ) :TdDouble;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function AN20( const K0_:Integer; const F2_:TdDouble ) :TdDouble;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :TdDouble;
   K, I :Integer;
begin
     Result := 0;

     K := N_;  A := ANN( K );

     for I := 1 to N_ div 2 do
     begin
          Result := Result - A * K * Sin( K * T_ );

          Dec( K, 2 );

          A := AN20( K, A );
     end;

     if N_ mod 2 = 1 then Result := Result - A * Sin( T_ );  // K = 1
end;

end. //######################################################################### ■
