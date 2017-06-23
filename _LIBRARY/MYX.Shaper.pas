unit MYX.Shaper;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
     LUX.GPU.OpenGL,
     LUX.GPU.OpenGL.Viewer,
     LUX.GPU.OpenGL.Buffer,
     LUX.GPU.OpenGL.Buffer.Unifor,
     LUX.GPU.OpenGL.Buffer.Verter,
     LUX.GPU.OpenGL.Buffer.Elemer,
     LUX.GPU.OpenGL.Imager,
     LUX.GPU.OpenGL.Imager.FMX,
     LUX.GPU.OpenGL.Shader,
     LUX.GPU.OpenGL.Engine;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaperData

     TMyShaperData = record
     private
     public
       Pose :TSingleM4;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaperBase

     TMyShaperBase = class
     private
     protected
       _Data :TGLUnifor<TMyShaperData>;
       ///// アクセス
       function GetData :TMyShaperData;
       procedure SetData( const Data_:TMyShaperData );
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Data :TMyShaperData read GetData write SetData;
       ///// メソッド
       procedure Draw; virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaper

     TMyShaper = class( TMyShaperBase )
     private
     protected
       _Poss :TGLVerterS<TSingle3D>;
       _Nors :TGLVerterS<TSingle3D>;
       _Texs :TGLVerterS<TSingle2D>;
       _Eles :TGLElemerTria32;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Poss :TGLVerterS<TSingle3D> read _Poss;
       property Nors :TGLVerterS<TSingle3D> read _Nors;
       property Texs :TGLVerterS<TSingle2D> read _Texs;
       property Eles :TGLElemerTria32       read _Eles;
       ///// メソッド
       procedure Draw; override;
       procedure LoadFormFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivX_,DivY_:Integer );
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaperData

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaperBase

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TMyShaperBase.GetData :TMyShaperData;
begin
     Result := _Data[ 0 ];
end;

procedure TMyShaperBase.SetData( const Data_:TMyShaperData );
begin
     _Data[ 0 ] := Data_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyShaperBase.Create;
begin
     inherited;

     _Data := TGLUnifor<TMyShaperData>.Create( GL_DYNAMIC_DRAW );
     _Data.Count := 1;
end;

destructor TMyShaperBase.Destroy;
begin
     _Data.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyShaperBase.Draw;
begin
     _Data.Use( 2{BinP} );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyShaper

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyShaper.Create;
begin
     inherited;

     _Poss := TGLVerterS<TSingle3D>.Create( GL_STATIC_DRAW );
     _Nors := TGLVerterS<TSingle3D>.Create( GL_STATIC_DRAW );
     _Texs := TGLVerterS<TSingle2D>.Create( GL_STATIC_DRAW );
     _Eles := TGLElemerTria32      .Create( GL_STATIC_DRAW );
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