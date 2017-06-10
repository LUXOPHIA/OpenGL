unit MYX.Shaper;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
     LUX.GPU.OpenGL,
     LUX.GPU.OpenGL.GLView,
     LUX.GPU.OpenGL.Buffer,
     LUX.GPU.OpenGL.Buffer.Unif,
     LUX.GPU.OpenGL.Buffer.Vert,
     LUX.GPU.OpenGL.Buffer.Elem,
     LUX.GPU.OpenGL.Imager,
     LUX.GPU.OpenGL.Imager.FMX,
     LUX.GPU.OpenGL.Shader,
     LUX.GPU.OpenGL.Engine;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TShaperDat

TShaperDat = record
private
public
  Move :TSingleM4;
end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaperBase

     TMyShaperBase = class
     private
     protected
       class var _Dats :TGLBufferU<TShaperDat>;
     protected
       _Ord :Integer;
       ///// アクセス
       function GetDat :TShaperDat;
       procedure SetDat( const Data_:TShaperDat );
     public
       class constructor Create;
       constructor Create;
       destructor Destroy; override;
       class destructor Destroy;
       ///// プロパティ
       property Ord :Integer    read   _Ord;
       property Dat :TShaperDat read GetDat write SetDat;
       ///// メソッド
       procedure Draw; virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaper

     TMyShaper = class( TMyShaperBase )
     private
     protected
       _Poss :TGLBufferVS<TSingle3D>;
       _Nors :TGLBufferVS<TSingle3D>;
       _Texs :TGLBufferVS<TSingle2D>;
       _Eles :TGLBufferE32;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Poss :TGLBufferVS<TSingle3D> read _Poss;
       property Nors :TGLBufferVS<TSingle3D> read _Nors;
       property Texs :TGLBufferVS<TSingle2D> read _Texs;
       property Eles :TGLBufferE32           read _Eles;
       ///// メソッド
       procedure Draw; override;
       procedure LoadFormFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivX_,DivY_:Integer );
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TShaperDat

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaperBase

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TMyShaperBase.GetDat :TShaperDat;
begin
     Result := _Dats[ _Ord ];
end;

procedure TMyShaperBase.SetDat( const Data_:TShaperDat );
begin
     _Dats[ _Ord ] := Data_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

class constructor TMyShaperBase.Create;
begin
     inherited;

     _Dats := TGLBufferU<TShaperDat>.Create( GL_DYNAMIC_DRAW );
end;

constructor TMyShaperBase.Create;
begin
     inherited;

     with _Dats do
     begin
          _Ord := Count;  Count := Count + 1;
     end;
end;

destructor TMyShaperBase.Destroy;
begin

     inherited;
end;

class destructor TMyShaperBase.Destroy;
begin
     _Dats.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyShaperBase.Draw;
begin
     _Dats.Use( 1{BinP}, _Ord{Offs} );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaper

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyShaper.Create;
begin
     inherited;

     _Poss := TGLBufferVS<TSingle3D>.Create( GL_STATIC_DRAW );
     _Nors := TGLBufferVS<TSingle3D>.Create( GL_STATIC_DRAW );
     _Texs := TGLBufferVS<TSingle2D>.Create( GL_STATIC_DRAW );
     _Eles := TGLBufferE32          .Create( GL_STATIC_DRAW );
end;

destructor TMyShaper.Destroy;
begin
     _Poss.DisposeOf;
     _Nors.DisposeOf;
     _Texs.DisposeOf;
     _Eles.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyShaper.Draw;
begin
     inherited;

     _Poss.Use( 0{BinP} );
     _Nors.Use( 1{BinP} );
     _Texs.Use( 2{BinP} );

     _Eles.Draw;
end;

//------------------------------------------------------------------------------

procedure TMyShaper.LoadFormFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivX_,DivY_:Integer );
//······························
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := ( DivX_ + 1 ) * Y_ + X_;
     end;
     //·························
     procedure MakeVerts;
     var
        C, X, Y, I :Integer;
        Ps, Ns :TGLBufferData<TSingle3D>;
        Ts :TGLBufferData<TSingle2D>;
        T :TSingle2D;
        M :TSingleM4;
     begin
          C := ( DivY_ + 1 ) * ( DivX_ + 1 );

          _Poss.Count := C;
          _Nors.Count := C;
          _Texs.Count := C;

          Ps := _Poss.Map( GL_WRITE_ONLY );
          Ns := _Nors.Map( GL_WRITE_ONLY );
          Ts := _Texs.Map( GL_WRITE_ONLY );

          for Y := 0 to DivY_ do
          begin
               T.V := Y / DivY_;
               for X := 0 to DivX_ do
               begin
                    T.U := X / DivX_;

                    I := XYtoI( X, Y );

                    Ts[ I ] := T;

                    M := Tensor( T, Func_ );

                    Ps[ I ] := M.AxisP;
                    Ns[ I ] := M.AxisZ;
               end;
          end;

          _Poss.Unmap;
          _Nors.Unmap;
          _Texs.Unmap;
     end;
     //·························
     procedure MakeElems;
     var
        X0, Y0, X1, Y1, I, I00, I01, I10, I11 :Integer;
        Es :TGLBufferData<TCardinal3D>;
     begin
          _Eles.Count := 2 * DivY_ * DivX_;

          Es := _Eles.Map( GL_WRITE_ONLY );

          I := 0;
          for Y0 := 0 to DivY_-1 do
          begin
               Y1 := Y0 + 1;
               for X0 := 0 to DivX_-1 do
               begin
                    X1 := X0 + 1;

                    I00 := XYtoI( X0, Y0 );  I01 := XYtoI( X1, Y0 );
                    I10 := XYtoI( X0, Y1 );  I11 := XYtoI( X1, Y1 );

                    //  00───01
                    //  │      │
                    //  │      │
                    //  │      │
                    //  10───11

                    Es[ I ] := TCardinal3D.Create( I00, I10, I11 );  Inc( I );
                    Es[ I ] := TCardinal3D.Create( I11, I01, I00 );  Inc( I );
               end;
          end;

          _Eles.Unmap;
     end;
//······························
begin
     MakeVerts;
     MakeElems;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■