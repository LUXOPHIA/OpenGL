unit LUX.Complex.FMX.D3;

interface //#################################################################### ■

uses System.SysUtils, System.RTLConsts, System.Classes,
     System.Types, System.UITypes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX,
     LUX.D1.Diff,
     LUX.D2, LUX.D2.Diff,
     LUX.D3, LUX.D3.Diff,
     LUX.D4x4, LUX.D4x4.Diff,
     LUX.Complex,
     LUX.Complex.Diff,
     LUX.FMX.Graphics.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TComplex3D

     TComplex3D = class( TF3DShaper )
     private
       ///// M E T H O D
       function XYtoI( const X_,Y_:Integer ) :Integer; inline;
     protected
       _Polygons :TMeshData;
       _Material :TLightMaterialSource;
       _Func     :TdDoubleCFunc;
       _Area     :TDoubleAreaC;
       _DivX     :Integer;
       _DivY     :Integer;
       _Scale    :Double;
       ///// A C C E S S O R
       function GetFunc :TdDoubleCFunc;
       procedure SetFunc( const Func_:TdDoubleCFunc );
       function GetArea :TDoubleAreaC;
       procedure SetArea( const Area_:TDoubleAreaC );
       function GetDivX :Integer;
       procedure SetDivX( const DivX_:Integer );
       function GetDivY :Integer;
       procedure SetDivY( const DivY_:Integer );
       function GetScale :Double;
       procedure SetScale( const Scale_:Double );
       ///// M E T H O D
       procedure Render; override;
       function TexToPos( const T_:TdDouble2D ) :TdDouble3D;
       procedure MakeGeometry; override;
       procedure MakeTopology; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Material :TLightMaterialSource read   _Material write   _Material;
       property Func     :TdDoubleCFunc        read GetFunc     write SetFunc    ;
       property Area     :TDoubleAreaC         read GetArea     write SetArea    ;
       property DivX     :Integer              read GetDivX     write SetDivX    ;
       property DivY     :Integer              read GetDivY     write SetDivY    ;
       property Scale    :Double               read GetScale    write SetScale   ;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Threading;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TComplex3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

function TComplex3D.XYtoI( const X_,Y_:Integer ) :Integer;
begin
     Result := ( _DivX + 1 ) * Y_ + X_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TComplex3D.GetFunc :TdDoubleCFunc;
begin
     Result := _Func;
end;

procedure TComplex3D.SetFunc( const Func_:TdDoubleCFunc );
begin
     _Func := Func_;

     upGeometry := True;

     Repaint;
end;

//------------------------------------------------------------------------------

function TComplex3D.GetArea :TDoubleAreaC;
begin
     Result := _Area;
end;

procedure TComplex3D.SetArea( const Area_:TDoubleAreaC );
begin
     _Area := Area_;

     upGeometry := True;

     Repaint;
end;

//------------------------------------------------------------------------------

function TComplex3D.GetDivX :Integer;
begin
     Result := _DivX;
end;

procedure TComplex3D.SetDivX( const DivX_:Integer );
begin
     _DivX := DivX_;

     upGeometry := True;
     upTopology := True;

     Repaint;
end;

function TComplex3D.GetDivY :Integer;
begin
     Result := _DivY;
end;

procedure TComplex3D.SetDivY( const DivY_:Integer );
begin
     _DivY := DivY_;

     upGeometry := True;
     upTopology := True;

     Repaint;
end;

//------------------------------------------------------------------------------

function TComplex3D.GetScale :Double;
begin
     Result := _Scale;
end;

procedure TComplex3D.SetScale( const Scale_:Double );
begin
     _Scale := Scale_;

     upGeometry := True;

     Repaint;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TComplex3D.Render;
begin
     inherited;

     _Polygons.Render( Context, TMaterialSource.ValidMaterial( _Material ), AbsoluteOpacity );
end;

function TComplex3D.TexToPos( const T_:TdDouble2D ) :TdDouble3D;
var
   C :TdDoubleC;
begin
     C.R := ( _Area.Max.R - _Area.Min.R ) * T_.X + _Area.Min.R;
     C.I := ( _Area.Max.I - _Area.Min.I ) * T_.Y + _Area.Min.I;

     Result.Y := Func( C ).Abso;
     Result.X := C.R;
     Result.Z := C.I;
end;

procedure TComplex3D.MakeGeometry;
var
   VB :TVertexBuffer;
begin
     VB := _Polygons.VertexBuffer;

     if not Assigned( Func ) then
     begin
          VB.Length := 0;  Exit;
     end;

     VB.Length := ( _DivX + 1 ) * ( _DivY + 1 );

     TParallel.For( 0, _DivY, procedure( Y_:Integer )
     var
        X, I :Integer;
        T :TDouble2D;
        M :TDoubleM4;
        C :TDoubleC;
        T2 :TPointF;
     begin
          T.Y := Y_ / _DivY;

          for X := 0 to _DivX do
          begin
               T.X := X / _DivX;

               M := TexToMatrix( T, TexToPos );

               C.R := ( _Area.Max.R - _Area.Min.R ) * T.X + _Area.Min.R;
               C.I := ( _Area.Max.I - _Area.Min.I ) * T.Y + _Area.Min.I;

               C := Func( C ).o;

               C.Abso := C.Abso / ( _Scale + C.Abso );

               T2.X := 0.5 + C.R / 2;
               T2.Y := 0.5 + C.I / 2;

               I := XYtoI( X, Y_ );

               VB.Vertices [ I ] := M.AxisP;
               VB.Normals  [ I ] := M.AxisZ;
               VB.TexCoord0[ I ] := T2;
          end;
     end );
end;

procedure TComplex3D.MakeTopology;
var
   X, Y, I :Integer;
begin
     with _Polygons.IndexBuffer do
     begin
          if not Assigned( Func ) then
          begin
               Length := 0;  Exit;
          end;

          Length := 3{Poin} * 2{Face} * _DivX * _DivY;

          I := 0;
          for Y := 0 to _DivY-1 do
          begin
               for X := 0 to _DivX-1 do
               begin
                    //     X0     X1
                    //  Y0 +------+
                    //     |＼    |
                    //     |  ＼  |
                    //     |    ＼|
                    //  Y1 +------+

                    Indices[ I ] := XYtoI( X  , Y   );  Inc( I );
                    Indices[ I ] := XYtoI( X+1, Y   );  Inc( I );
                    Indices[ I ] := XYtoI( X+1, Y+1 );  Inc( I );

                    Indices[ I ] := XYtoI( X+1, Y+1 );  Inc( I );
                    Indices[ I ] := XYtoI( X  , Y+1 );  Inc( I );
                    Indices[ I ] := XYtoI( X  , Y   );  Inc( I );
               end;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TComplex3D.Create( Owner_:TComponent );
begin
     inherited;

     _Polygons := TMeshData.Create;

     _Material := TLightMaterialSource.Create( Self );
     _Material.Specular := TAlphaColors.Null;

     Func  := nil;
     Area  := TDoubleAreaC.Create( -1, -1, +1, +1 );
     DivX  := 64;
     DivY  := 64;
     Scale := 1;
end;

destructor TComplex3D.Destroy;
begin
     _Polygons.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■