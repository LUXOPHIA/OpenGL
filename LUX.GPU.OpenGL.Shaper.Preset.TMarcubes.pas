unit LUX.GPU.OpenGL.Shaper.Preset.TMarcubes;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D2, LUX.D3, LUX.M4,
     LUX.GPU.OpenGL,
     LUX.GPU.OpenGL.Atom.Imager.D2.Preset,
     LUX.GPU.OpenGL.Atom.Imager.D3.Preset,
     LUX.GPU.OpenGL.Matery,
     LUX.GPU.OpenGL.Shaper;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TMarcubes = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMarcubesMatery

     TMarcubesMatery = class( TGLMateryNorTexG )
     private
     protected
       _Voxels :TGLGrider3D_Single;
       _Imager :TGLBricer2D_TAlphaColorF;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Voxels :TGLGrider3D_Single       read _Voxels;
       property Imager :TGLBricer2D_TAlphaColorF read _Imager;
       ///// メソッド
       procedure Use; override;
       procedure Unuse; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMarcubes

     TMarcubes = class( TGLShaperZeroPoins )
     private
     protected
       _SizeX  :Single;
       _SizeY  :Single;
       _SizeZ  :Single;
       ///// アクセス
       function GetGrider :TGLGrider3D_Single;
       function GetSizeX :Single;
       procedure SetSizeX( const SizeX_:Single );
       function GetSizeY :Single;
       procedure SetSizeY( const SizeY_:Single );
       function GetSizeZ :Single;
       procedure SetSizeZ( const SizeZ_:Single );
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// プロパティ
       property Grider :TGLGrider3D_Single read GetGrider               ;
       property SizeX  :Single             read GetSizeX  write SetSizeX;
       property SizeY  :Single             read GetSizeY  write SetSizeY;
       property SizeZ  :Single             read GetSizeZ  write SetSizeZ;
       ///// メソッド
       procedure MakeModel;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMarcubesMatery

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMarcubesMatery.Create;
begin
     inherited;

     with _Engine do
     begin
          with Imagers do
          begin
               Add( 0{BinP}, '_Voxels'{Name} );
               Add( 1{BinP}, '_Imager'{Name} );
          end;
     end;

     _Voxels := TGLGrider3D_Single.Create;
     _Imager := TGLBricer2D_TAlphaColorF  .Create;

     with _Voxels.Texels do
     begin
          BricsX := 100;
          BricsY := 100;
          BricsZ := 100;
     end;
end;

destructor TMarcubesMatery.Destroy;
begin
     _Voxels.DisposeOf;
     _Imager.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMarcubesMatery.Use;
begin
     inherited;

     _Voxels.Use( 0 );
     _Imager.Use( 1 );
end;

procedure TMarcubesMatery.Unuse;
begin
     _Voxels.Unuse( 0 );
     _Imager.Unuse( 1 );

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMarcubes

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TMarcubes.GetGrider :TGLGrider3D_Single;
begin
     Result := ( _Matery as TMarcubesMatery ).Voxels;
end;

//------------------------------------------------------------------------------

function TMarcubes.GetSizeX :Single;
begin
     Result := _SizeX;
end;

procedure TMarcubes.SetSizeX( const SizeX_:Single );
begin
     _SizeX := SizeX_;
end;

function TMarcubes.GetSizeY :Single;
begin
     Result := _SizeY;
end;

procedure TMarcubes.SetSizeY( const SizeY_:Single );
begin
     _SizeY := SizeY_;
end;

function TMarcubes.GetSizeZ :Single;
begin
     Result := _SizeZ;
end;

procedure TMarcubes.SetSizeZ( const SizeZ_:Single );
begin
     _SizeZ := SizeZ_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMarcubes.Create;
begin
     inherited;

     _Matery := TMarcubesMatery.Create;

     SizeX  := 10;
     SizeY  := 10;
     SizeZ  := 10;

     with Grider.Texels do
     begin
          BricsX := 100;
          BricsY := 100;
          BricsZ := 100;
     end;
end;

destructor TMarcubes.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMarcubes.MakeModel;
begin
     with ( _Matery as TMarcubesMatery )._Voxels do
     begin
          SendData;

          with Texels do PoinsN := BricsX * BricsY * BricsZ;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
