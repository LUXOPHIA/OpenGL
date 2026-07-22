unit LUX.Curve.Lanczos;

interface //#################################################################### ■

uses LUX.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Sinc( const X_:Single ) :Single; overload;
function Sinc( const X_:Double ) :Double; overload;

implementation //############################################################### ■

uses LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Sinc( const X_:Single ) :Single;
var
   X :Single;
begin
     X := Pi * X_;
     if Abs( X ) < SINGLE_EPS3 then Result := 1
                               else Result := Sin( X ) / X;
end;

function Sinc( const X_:Double ) :Double;
var
   X :Double;
begin
     X := Pi * X_;
     if Abs( X ) < DOUBLE_EPS3 then Result := 1
                               else Result := Sin( X ) / X;
end;

end. //######################################################################### ■