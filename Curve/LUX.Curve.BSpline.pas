unit LUX.Curve.BSpline;

interface //#################################################################### ■

uses LUX, LUX.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSplineREC

function BSplineREC( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single; overload;
function BSplineREC( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double; overload;

function BSplineREC( const N,I:Integer; const T:Single ) :Single; overload;
function BSplineREC( const N,I:Integer; const T:Double ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSpline

function BSpline( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single; overload;
function BSpline( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double; overload;

function BSpline( const N,I:Integer; const T:Single ) :Single; overload;
function BSpline( const N,I:Integer; const T:Double ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSpline3

function BSpline3( const X_:Double ) :Double; overload;
function BSpline3( const X_:Single ) :Single; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSpline4

function BSpline4( const X_:Single ) :Single; overload;
function BSpline4( const X_:Double ) :Double; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSplineREC

function BSplineREC( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single;
begin
     if N = 0 then
     begin
          if ( Ks[ I ] <= T ) and ( T < Ks[ I+1 ] ) then Result := 1
                                                    else Result := 0;
     end
     else Result := ( T - Ks[ I     ]     ) / ( Ks[ I+N   ] - Ks[ I   ] ) * BSplineREC( N-1, I  , T, Ks )
                  + (     Ks[ I+N+1 ] - T ) / ( Ks[ I+N+1 ] - Ks[ I+1 ] ) * BSplineREC( N-1, I+1, T, Ks );
end;

function BSplineREC( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double;
begin
     if N = 0 then
     begin
          if ( Ks[ I ] <= T ) and ( T < Ks[ I+1 ] ) then Result := 1
                                                    else Result := 0;
     end
     else Result := ( T - Ks[ I     ]     ) / ( Ks[ I+N   ] - Ks[ I   ] ) * BSplineREC( N-1, I  , T, Ks )
                  + (     Ks[ I+N+1 ] - T ) / ( Ks[ I+N+1 ] - Ks[ I+1 ] ) * BSplineREC( N-1, I+1, T, Ks );
end;

//------------------------------------------------------------------------------

//                             N
//                             |
//                 0     1     2                = I
//        +-----+--|--+==|==+--|--+-----+
//       -2    -1     0     1     2     3       = Ks
//        |                       |     |
//       -N                       N     N+1

//                                N
//                                |
//              0     1     2     3             = I
//  +-----+-----|-----|=====|-----|-----+-----+
// -3    -2    -1     0     1     2     3     4 = Ks
//  |                                   |     |
// -N                                   N     N+1

function BSplineREC( const N,I:Integer; const T:Single ) :Single;
// - - - - - - - - - - - - - - - - - - -
     function BSplineREC( const L,I:Integer ) :Single;
     begin
          if L = 0 then
          begin
               if ( I-N <= T ) and ( T < I-N+1 ) then Result := 1
                                                 else Result := 0;
          end
          else Result := ( ( T - (I-N    )     ) * BSplineREC( L-1, I   )
                         + (     (I-N+L+1) - T ) * BSplineREC( L-1, I+1 ) ) / N;
     end;
// - - - - - - - - - - - - - - - - - - -
begin
     Result := BSplineREC( N, I );
end;

function BSplineREC( const N,I:Integer; const T:Double ) :Double;
// - - - - - - - - - - - - - - - - - - -
     function BSplineREC( const L,I:Integer ) :Double;
     begin
          if L = 0 then
          begin
               if ( I-N <= T ) and ( T < I-N+1 ) then Result := 1
                                                 else Result := 0;
          end
          else Result := ( ( T - (I-N    )     ) * BSplineREC( L-1, I   )
                         + (     (I-N+L+1) - T ) * BSplineREC( L-1, I+1 ) ) / N;
     end;
// - - - - - - - - - - - - - - - - - - -
begin
     Result := BSplineREC( N, I );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSpline

function BSpline( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single;
var
   Bs :TArray<Single>;
   J, L :Integer;
   W0, W1 :Single;
begin
     SetLength( Bs, N+1 );
     for J := 0 to N do
     begin
          if ( Ks[ I+J ] <= T ) and ( T < Ks[ I+J+1 ] ) then Bs[ J ] := 1
                                                        else Bs[ J ] := 0;
     end;

     for L := 1 to N do
     begin
          for J := 0 to N-L do
          begin
               W0 := ( T - Ks[ I+J     ]     ) / ( Ks[ I+J+L   ] - Ks[ I+J   ] );
               W1 := (     Ks[ I+J+L+1 ] - T ) / ( Ks[ I+J+L+1 ] - Ks[ I+J+1 ] );

               Bs[ J ] := W0 * Bs[ J ] + W1 * Bs[ J+1 ];
          end;
     end;

     Result := Bs[ 0 ];
end;

function BSpline( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double;
var
   Bs :TArray<Double>;
   J, L :Integer;
   W0, W1 :Double;
begin
     SetLength( Bs, N+1 );
     for J := 0 to N do
     begin
          if ( Ks[ I+J ] <= T ) and ( T < Ks[ I+J+1 ] ) then Bs[ J ] := 1
                                                        else Bs[ J ] := 0;
     end;

     for L := 1 to N do
     begin
          for J := 0 to N-L do
          begin
               W0 := ( T - Ks[ I+J     ]     ) / ( Ks[ I+J+L   ] - Ks[ I+J   ] );
               W1 := (     Ks[ I+J+L+1 ] - T ) / ( Ks[ I+J+L+1 ] - Ks[ I+J+1 ] );

               Bs[ J ] := W0 * Bs[ J ] + W1 * Bs[ J+1 ];
          end;
     end;

     Result := Bs[ 0 ];
end;

//------------------------------------------------------------------------------

//                             N
//                             |
//                 0     1     2                = I
//        +-----+--|--+==|==+--|--+-----+
//       -2    -1     0     1     2     3       = Ks
//        |                       |     |
//       -N                       N     N+1

//                                N
//                                |
//              0     1     2     3             = I
//  +-----+-----|-----|=====|-----|-----+-----+
// -3    -2    -1     0     1     2     3     4 = Ks
//  |                                   |     |
// -N                                   N     N+1

function BSpline( const N,I:Integer; const T:Single ) :Single;
var
   Bs :TArray<Single>;
   J, L :Integer;
begin
     SetLength( Bs, N+1 );
     for J := 0 to N do
     begin
          if ( I+J-N <= T ) and ( T < I+J-N+1 ) then Bs[ J ] := 1
                                                else Bs[ J ] := 0;
     end;

     for L := 1 to N do
     begin
          for J := 0 to N-L do
          begin
               Bs[ J ] := ( ( T - ( I+J-N     )     ) * Bs[ J   ]
                          + (     ( I+J-N+L+1 ) - T ) * Bs[ J+1 ] ) / L;
          end;
     end;

     Result := Bs[ 0 ];
end;

function BSpline( const N,I:Integer; const T:Double ) :Double;
var
   Bs :TArray<Double>;
   J, L :Integer;
begin
     SetLength( Bs, N+1 );
     for J := 0 to N do
     begin
          if ( I+J-N <= T ) and ( T < I+J-N+1 ) then Bs[ J ] := 1
                                                else Bs[ J ] := 0;
     end;

     for L := 1 to N do
     begin
          for J := 0 to N-L do
          begin
               Bs[ J ] := ( ( T - ( I+J-N     )     ) * Bs[ J   ]
                          + (     ( I+J-N+L+1 ) - T ) * Bs[ J+1 ] ) / L;
          end;
     end;

     Result := Bs[ 0 ];
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSpline3

function BSpline3( const X_:Single ) :Single;
var
   X :Single;
begin
     X := Abs( X_ );

     if X < 1/2 then Result := 3/4 - Pow2( X )
                else
     if X < 3/2 then Result := Pow2( X - 3/2 ) / 2
                else Result := 0;
end;

function BSpline3( const X_:Double ) :Double;
var
   X :Double;
begin
     X := Abs( X_ );

     if X < 1/2 then Result := 3/4 - Pow2( X )
                else
     if X < 3/2 then Result := Pow2( X - 3/2 ) / 2
                else Result := 0;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BSpline4

function BSpline4( const X_:Single ) :Single;
const
     A :Single = 1/6;
     B :Single = 4/3;
     C :Single = 2/3;
var
   X :Single;
begin
     X := Abs( X_ );

     if X < 1 then Result := ( X / 2 - 1 ) * X * X + 2/3
              else
     if X < 2 then Result := ( ( 1 - X / 6 ) * X - 2 ) * X + 4/3
              else Result := 0;
end;

function BSpline4( const X_:Double ) :Double;
var
   X :Double;
begin
     X := Abs( X_ );

     if X < 1 then Result := ( X / 2 - 1 ) * X * X + 2/3
              else
     if X < 2 then Result := ( ( 1 - X / 6 ) * X - 2 ) * X + 4/3
              else Result := 0;
end;

end. //######################################################################### ■