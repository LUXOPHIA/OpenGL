unit LUX.D1;

interface //#################################################################### ■

uses LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle

     TSingle = record
     private
     public
       ///// M E T H O D
       class function RandG( const SD_:Single = 1 ) :Single; static;
       class function RandBS1 :Single; static;
       class function RandBS2 :Single; static;
       class function RandBS4 :Single; static;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble

     TDouble = record
     private
     public
       ///// M E T H O D
       class function RandG( const SD_:Double = 1 ) :Double; static;
       class function RandBS1 :Double; static;
       class function RandBS2 :Double; static;
       class function RandBS4 :Double; static;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gauss

function Gauss( const X_,SD_:Single ) :Single; overload;
function Gauss( const X_,SD_:Double ) :Double; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TSingle.RandG( const SD_:Single = 1 ) :Single;
begin
     Result := System.Math.RandG( 0, SD_ );
end;

class function TSingle.RandBS1 :Single;
begin
     Result := Random - 0.5;
end;

class function TSingle.RandBS2 :Single;
begin
     Result := RandBS1 + RandBS1;
end;

class function TSingle.RandBS4 :Single;
begin
     Result := RandBS2 + RandBS2;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TDouble.RandG( const SD_:Double = 1 ) :Double;
begin
     Result := System.Math.RandG( 0, SD_ );
end;

class function TDouble.RandBS1 :Double;
begin
     Result := Random - 0.5;
end;

class function TDouble.RandBS2 :Double;
begin
     Result := RandBS1 + RandBS1;
end;

class function TDouble.RandBS4 :Double;
begin
     Result := RandBS2 + RandBS2;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gauss

function Gauss( const X_,SD_:Single ) :Single;
var
   V :Single;
begin
     V := Pow2( SD_ );

     Result := Exp( -Pow2( X_ ) / ( 2 * V ) ) / Roo2( Pi2 * V );
end;

function Gauss( const X_,SD_:Double ) :Double;
var
   V :Double;
begin
     V := Pow2( SD_ );

     Result := Exp( -Pow2( X_ ) / ( 2 * V ) ) / Roo2( Pi2 * V );
end;

end. //######################################################################### ■
