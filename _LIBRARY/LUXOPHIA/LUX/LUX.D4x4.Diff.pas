unit LUX.D4x4.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Diff,
     LUX.D2, LUX.D2.Diff,
     LUX.D3, LUX.D3.Diff,
     LUX.D4x4;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function TexToMatrix( const T_:TSingle2D; const Func_:TdSingleFunc2Dto3D ) :TSingleM4; overload;
function TexToMatrix( const T_:TDouble2D; const Func_:TdDoubleFunc2Dto3D ) :TDoubleM4; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function TexToMatrix( const T_:TSingle2D; const Func_:TdSingleFunc2Dto3D ) :TSingleM4;
var
   T :TdSingle2D;
begin
     T.o := T_;  T.d := TSingle2D.Create( 1, 0 );

     with Func_( T ) do
     begin
          Result.AxisP := o;
          Result.AxisX := d.Unitor;
     end;

     T.o := T_;  T.d := TSingle2D.Create( 0, 1 );

     Result.AxisY := Func_( T ).d.Unitor;

     Result.AxisZ := CrossProduct( Result.AxisX, Result.AxisY ).Unitor;
end;

function TexToMatrix( const T_:TDouble2D; const Func_:TdDoubleFunc2Dto3D ) :TDoubleM4;
var
   T :TdDouble2D;
begin
     T.o := T_;  T.d := TDouble2D.Create( 1, 0 );

     with Func_( T ) do
     begin
          Result.AxisP := o;
          Result.AxisX := d.Unitor;
     end;

     T.o := T_;  T.d := TDouble2D.Create( 0, 1 );

     Result.AxisY := Func_( T ).d.Unitor;

     Result.AxisZ := CrossProduct( Result.AxisX, Result.AxisY ).Unitor;
end;

end. //######################################################################### ■
