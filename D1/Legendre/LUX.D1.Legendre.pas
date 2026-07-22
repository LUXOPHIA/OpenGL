unit LUX.D1.Legendre;

interface //#################################################################### ■

uses LUX;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendre

function NLegendre( const X_:Single; const N_:Integer ) :Single; overload;
function NLegendre( const X_:Double; const N_:Integer ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendreCos

function NLegendreCos( const T_:Single; const N_:Integer ) :Single; overload;
function NLegendreCos( const T_:Double; const N_:Integer ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendre

function dNLegendre( const X_:Single; const N_:Integer ) :Single; overload;
function dNLegendre( const X_:Double; const N_:Integer ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendreCos

function dNLegendreCos( const T_:Single; const N_:Integer ) :Single; overload;
function dNLegendreCos( const T_:Double; const N_:Integer ) :Double; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendre

function NLegendre( const X_:Single; const N_:Integer ) :Single;
begin
     Result := NLegendreCos( ArcCos( X_ ), N_ );
end;

function NLegendre( const X_:Double; const N_:Integer ) :Double;
begin
     Result := NLegendreCos( ArcCos( X_ ), N_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NLegendreCos

function NLegendreCos( const T_:Single; const N_:Integer ) :Single;
// - - - - - - - - - - - - - - - - - - -
     function FNN( const N_:Integer ) :Single;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function FN20( const K0_:Integer; const F2_:Single ) :Single;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :Single;
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

function NLegendreCos( const T_:Double; const N_:Integer ) :Double;
// - - - - - - - - - - - - - - - - - - -
     function ANN( const N_:Integer ) :Double;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function AN20( const K0_:Integer; const F2_:Double ) :Double;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :Double;
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

function dNLegendre( const X_:Single; const N_:Integer ) :Single;
begin
     Result := -1 / Roo2( 1 - Pow2( X_ ) ) * dNLegendreCos( ArcCos( X_ ), N_ );
end;

function dNLegendre( const X_:Double; const N_:Integer ) :Double;
begin
     Result := -1 / Roo2( 1 - Pow2( X_ ) ) * dNLegendreCos( ArcCos( X_ ), N_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dNLegendreCos

function dNLegendreCos( const T_:Single; const N_:Integer ) :Single;
// - - - - - - - - - - - - - - - - - - -
     function FNN( const N_:Integer ) :Single;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function FN20( const K0_:Integer; const F2_:Single ) :Single;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :Single;
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

function dNLegendreCos( const T_:Double; const N_:Integer ) :Double;
// - - - - - - - - - - - - - - - - - - -
     function ANN( const N_:Integer ) :Double;
     var
        N :Integer;
     begin
          Result := Sqrt(2);
          for N := 1 to N_ do Result := Sqrt( ( 2 * N - 1 ) * ( 2 * N + 1 ) ) / ( 2 * N ) * Result;
     end;
     //- - - - - - - - - - - - - - - - -
     function AN20( const K0_:Integer; const F2_:Double ) :Double;
     begin
          Result := ( N_ - K0_ - 1 ) * ( N_ + K0_ + 2 ) / ( ( N_ - K0_ ) * ( N_ + K0_ + 1 ) ) * F2_;
     end;
// - - - - - - - - - - - - - - - - - - -
var
   A :Double;
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
