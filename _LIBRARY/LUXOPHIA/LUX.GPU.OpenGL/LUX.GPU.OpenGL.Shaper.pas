﻿unit LUX.GPU.OpenGL.Shaper;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D2, LUX.D3, LUX.M4, LUX.Tree,
     LUX.GPU.OpenGL,
     LUX.GPU.OpenGL.Buffer,
     LUX.GPU.OpenGL.Buffer.Verter,
     LUX.GPU.OpenGL.Buffer.Elemer,
     LUX.GPU.OpenGL.Scener,
     LUX.GPU.OpenGL.Matery;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaper

     TGLShaper = class( TGLNode, IGLShaper )
     private
     protected
       _Matery :IGLMatery;
       ///// メソッド
       procedure BeginDraw; override;
       procedure EndDraw; override;
     public
       constructor Create( const Paren_:ITreeNode ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Matery :IGLMatery read _Matery write _Matery;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperPoin

     TGLShaperPoin = class( TGLShaper )
     private
     protected
       _PosBuf :TGLVerterS<TSingle3D>;
       _NorBuf :TGLVerterS<TSingle3D>;
       _TexBuf :TGLVerterS<TSingle2D>;
       ///// メソッド
       procedure BeginDraw; override;
       procedure DrawCore; override;
       procedure EndDraw; override;
     public
       constructor Create( const Paren_:ITreeNode ); override;
       destructor Destroy; override;
       ///// プロパティ
       property PosBuf :TGLVerterS<TSingle3D> read _PosBuf;
       property NorBuf :TGLVerterS<TSingle3D> read _NorBuf;
       property TexBuf :TGLVerterS<TSingle2D> read _TexBuf;
       ///// メソッド
       procedure LoadFromFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivU_,DivV_:Integer ); virtual;
       procedure LoadFromFileSTL( const FileName_:String );
       procedure LoadFromFileOBJ( const FileName_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperLine

     TGLShaperLine = class( TGLShaperPoin )
     private
     protected
       _EleBuf :TGLElemerLine32;
       _LineW  :Single;
       ///// メソッド
       procedure BeginDraw; override;
       procedure DrawCore; override;
       procedure EndDraw; override;
     public
       constructor Create( const Paren_:ITreeNode ); override;
       destructor Destroy; override;
       ///// プロパティ
       property EleBuf :TGLElemerLine32 read _EleBuf             ;
       property LineW  :Single          read _LineW  write _LineW;
       ///// メソッド
       procedure LoadFromFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivU_,DivV_:Integer ); override;
       procedure LoadFromFileSTL( const FileName_:String );
       procedure LoadFromFileOBJ( const FileName_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperFace

     TGLShaperFace = class( TGLShaperPoin )
     private
     protected
       _EleBuf :TGLElemerFace32;
       ///// メソッド
       procedure DrawCore; override;
     public
       constructor Create( const Paren_:ITreeNode ); override;
       destructor Destroy; override;
       ///// プロパティ
       property EleBuf :TGLElemerFace32 read _EleBuf;
       ///// メソッド
       procedure LoadFromFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivU_,DivV_:Integer ); override;
       procedure LoadFromFileSTL( const FileName_:String );
       procedure LoadFromFileOBJ( const FileName_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperCopy

     TGLShaperCopy = class( TGLShaper )
     private
     protected
       _Shaper :TGLShaperPoin;
       ///// メソッド
       procedure BeginDraw; override;
       procedure DrawCore; override;
       procedure EndDraw; override;
     public
       constructor Create( const Paren_:ITreeNode ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Shaper :TGLShaperPoin read _Shaper write _Shaper;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.Classes, System.RegularExpressions, System.Generics.Collections;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaper

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaper.BeginDraw;
begin
     inherited;

     if Assigned( _Matery ) then _Matery.Use;
end;

procedure TGLShaper.EndDraw;
begin
     if Assigned( _Matery ) then _Matery.Unuse;

     inherited;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLShaper.Create( const Paren_:ITreeNode );
begin
     inherited;

end;

destructor TGLShaper.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperPoin

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperPoin.BeginDraw;
begin
     inherited;

     _PosBuf.Use( 0{BinP} );
     _NorBuf.Use( 1{BinP} );
     _TexBuf.Use( 2{BinP} );
end;

procedure TGLShaperPoin.DrawCore;
begin
     glDrawArrays( GL_POINTS, 0, _PosBuf.Count );
end;

procedure TGLShaperPoin.EndDraw;
begin
     _PosBuf.Unuse( 0{BinP} );
     _NorBuf.Unuse( 1{BinP} );
     _TexBuf.Unuse( 2{BinP} );

     inherited;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLShaperPoin.Create( const Paren_:ITreeNode );
begin
     inherited;

     _PosBuf := TGLVerterS<TSingle3D>.Create( GL_STATIC_DRAW );
     _NorBuf := TGLVerterS<TSingle3D>.Create( GL_STATIC_DRAW );
     _TexBuf := TGLVerterS<TSingle2D>.Create( GL_STATIC_DRAW );
end;

destructor TGLShaperPoin.Destroy;
begin
     _PosBuf.DisposeOf;
     _NorBuf.DisposeOf;
     _TexBuf.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperPoin.LoadFromFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivU_,DivV_:Integer );
//··································
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := ( DivU_ + 1 ) * Y_ + X_;
     end;
//··································
var
   C, X, Y, I :Integer;
   Ps, Ns :TGLBufferData<TSingle3D>;
   Ts :TGLBufferData<TSingle2D>;
   T :TSingle2D;
   M :TSingleM4;
begin
     C := ( DivV_ + 1 ) * ( DivU_ + 1 );

     _PosBuf.Count := C;
     _NorBuf.Count := C;
     _TexBuf.Count := C;

     Ps := _PosBuf.Map( GL_WRITE_ONLY );
     Ns := _NorBuf.Map( GL_WRITE_ONLY );
     Ts := _TexBuf.Map( GL_WRITE_ONLY );

     for Y := 0 to DivV_ do
     begin
          T.V := Y / DivV_;
          for X := 0 to DivU_ do
          begin
               T.U := X / DivU_;

               I := XYtoI( X, Y );

               Ts[ I ] := T;

               M := Tensor( T, Func_ );

               Ps[ I ] := M.AxisP;
               Ns[ I ] := M.AxisZ;
          end;
     end;

     _PosBuf.Unmap;
     _NorBuf.Unmap;
     _TexBuf.Unmap;
end;

//------------------------------------------------------------------------------

procedure TGLShaperPoin.LoadFromFileSTL( const FileName_:String );
var
   F :TFileStream;
   Hs :array [ 0..80-1 ] of AnsiChar;
   FsN, I :Cardinal;
   Fs :array of packed record
                  Nor  :TSingle3D;
                  Pos1 :TSingle3D;
                  Pos2 :TSingle3D;
                  Pos3 :TSingle3D;
                  _    :Word;
                end;
   E :TCardinal3D;
   Ps, Ns :TGLBufferData<TSingle3D>;
begin
     F := TFileStream.Create( FileName_, fmOpenRead );
     try
        F.Read( Hs, SizeOf( Hs ) );

        F.Read( FsN, SizeOf( FsN ) );

        SetLength( Fs, FsN );

        F.Read( Fs[0], 50 * FsN );
     finally
            F.DisposeOf;
     end;

     _PosBuf.Count := 3 * FsN;
     _NorBuf.Count := 3 * FsN;

     Ps := _PosBuf.Map( GL_WRITE_ONLY );
     Ns := _NorBuf.Map( GL_WRITE_ONLY );

     E.X := 0;
     E.Y := 1;
     E.Z := 2;
     for I := 0 to FsN-1 do
     begin
          with Fs[ I ] do
          begin
               Ps.Items[ E.X ] := Pos1;
               Ps.Items[ E.Y ] := Pos2;
               Ps.Items[ E.Z ] := Pos3;

               Ns.Items[ E.X ] := Nor;
               Ns.Items[ E.Y ] := Nor;
               Ns.Items[ E.Z ] := Nor;
          end;

          Inc( E.X, 3 );
          Inc( E.Y, 3 );
          Inc( E.Z, 3 );
     end;

     _PosBuf.Unmap;
     _NorBuf.Unmap;
end;

//------------------------------------------------------------------------------

procedure TGLShaperPoin.LoadFromFileOBJ( const FileName_:String );
type
    TVert = record
      P :Integer;
      N :Integer;
      T :Integer;
    end;
var
   Vs :TDictionary<TVert,Integer>;
//·····································
     function ReadVert( const M_:TMatch ) :Cardinal;
     var
        V :TVert;
     begin
          with V do
          begin
               P := StrToIntDef( M_.Groups[ 1 ].Value, 0 ) - 1;
               T := StrToIntDef( M_.Groups[ 2 ].Value, 0 ) - 1;
               N := StrToIntDef( M_.Groups[ 3 ].Value, 0 ) - 1;
          end;

          if Vs.ContainsKey( V ) then Result := Vs[ V ]
          else
          begin
               Result := Vs.Count;  Vs.Add( V, Result );
          end;
     end;
//·····································
var
   F :TStreamReader;
   RV, RN, RT, RF, RI :TRegEx;
   Ps, Ns :TArray<TSingle3D>;
   Ts :TArray<TSingle2D>;
   L :String; 
   P, N :TSingle3D;
   T :TSingle2D;
   Ms :TMatchCollection;
   K :Integer;
   V :TPair<TVert,Integer>;
begin
     Vs := TDictionary<TVert,Integer>.Create;

     F := TStreamReader.Create( FileName_, TEncoding.Default );
     try
          RV := TRegEx.Create( 'v[ \t]+([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t\n]+)' );
          RN := TRegEx.Create( 'vn[ \t]+([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t\n]+)' );
          RT := TRegEx.Create( 'vt[ \t]+([^ \t]+)[ \t]+([^ \t]+)' );
          RF := TRegEx.Create( 'f( [^\n]+)' );
          RI := TRegEx.Create( '[ \t]+(\d+)/?(\d*)/?(\d*)' );

          Ps := [];
          Ns := [];
          Ts := [];
          while not F.EndOfStream do
          begin
               L := F.ReadLine;

               with RV.Match( L ) do
               begin
                    if Success then
                    begin
                         P.X := Groups[ 1 ].Value.ToSingle;
                         P.Y := Groups[ 2 ].Value.ToSingle;
                         P.Z := Groups[ 3 ].Value.ToSingle;

                         Ps := Ps + [ P ];
                    end;
               end;

               with RN.Match( L ) do
               begin
                    if Success then
                    begin
                         N.X := Groups[ 1 ].Value.ToSingle;
                         N.Y := Groups[ 2 ].Value.ToSingle;
                         N.Z := Groups[ 3 ].Value.ToSingle;

                         Ns := Ns + [ N ];
                    end;
               end;

               with RT.Match( L ) do
               begin
                    if Success then
                    begin
                         T.X := Groups[ 1 ].Value.ToSingle;
                         T.Y := Groups[ 2 ].Value.ToSingle;

                         Ts := Ts + [ T ];
                    end;
               end;

               with RF.Match( L ) do
               begin
                    if Success then
                    begin
                         Ms := RI.Matches( Groups[ 1 ].Value );

                         for K := 0 to Ms.Count-1 do ReadVert( Ms[ K ] );
                    end;
               end;
          end;
     finally
            F.DisposeOf;
     end;

     if Length( Ps ) > 0 then
     begin
          with _PosBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ps[ V.Key.P ];
               end;

               Unmap;
          end;
     end;

     if Length( Ns ) > 0 then
     begin
          with _NorBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ns[ V.Key.N ];
               end;

               Unmap;
          end;
     end;

     if Length( Ts ) > 0 then
     begin
          with _TexBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ts[ V.Key.T ];
               end;

               Unmap;
          end;
     end;

     Vs.DisposeOf;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperLine

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperLine.BeginDraw;
begin
     inherited;

     glLineWidth( _LineW );
end;

procedure TGLShaperLine.DrawCore;
begin
     _EleBuf.Draw;
end;

procedure TGLShaperLine.EndDraw;
begin

     inherited;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLShaperLine.Create( const Paren_:ITreeNode );
begin
     inherited;

     _EleBuf := TGLElemerLine32.Create( GL_STATIC_DRAW );

     _LineW := 1;
end;

destructor TGLShaperLine.Destroy;
begin
     _EleBuf.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperLine.LoadFromFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivU_,DivV_:Integer );
//··································
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := ( DivU_ + 1 ) * Y_ + X_;
     end;
//··································
var
   X, Y, I, I0, I1 :Integer;
   Es :TGLBufferData<TCardinal2D>;
begin
     inherited;

     _EleBuf.Count := DivV_ * ( DivU_+1 ) + ( DivV_+1 ) * DivU_;

     Es := _EleBuf.Map( GL_WRITE_ONLY );

     I := 0;

     for Y := 0 to DivV_ do
     begin
          for X := 0 to DivU_-1 do
          begin
               I0 := XYtoI( X+0, Y );
               I1 := XYtoI( X+1, Y );

               Es[ I ] := TCardinal2D.Create( I0, I1 );  Inc( I );
          end;
     end;

     for X := 0 to DivU_ do
     begin
          for Y := 0 to DivV_-1 do
          begin
               I0 := XYtoI( X, Y+0 );
               I1 := XYtoI( X, Y+1 );

               Es[ I ] := TCardinal2D.Create( I0, I1 );  Inc( I );
          end;
     end;

     _EleBuf.Unmap;
end;

//------------------------------------------------------------------------------

procedure TGLShaperLine.LoadFromFileSTL( const FileName_:String );
var
   F :TFileStream;
   Hs :array [ 0..80-1 ] of AnsiChar;
   FsN, I :Cardinal;
   Fs :array of packed record
                  Nor  :TSingle3D;
                  Pos1 :TSingle3D;
                  Pos2 :TSingle3D;
                  Pos3 :TSingle3D;
                  _    :Word;
                end;
   E :TCardinal3D;
   Ps, Ns :TGLBufferData<TSingle3D>;
   Es :TGLBufferData<TCardinal2D>;
begin
     F := TFileStream.Create( FileName_, fmOpenRead );
     try
        F.Read( Hs, SizeOf( Hs ) );

        F.Read( FsN, SizeOf( FsN ) );

        SetLength( Fs, FsN );

        F.Read( Fs[0], 50 * FsN );
     finally
            F.DisposeOf;
     end;

     _PosBuf.Count := 3 * FsN;
     _NorBuf.Count := 3 * FsN;
     _EleBuf.Count := 3 * FsN;

     Ps := _PosBuf.Map( GL_WRITE_ONLY );
     Ns := _NorBuf.Map( GL_WRITE_ONLY );
     Es := _EleBuf.Map( GL_WRITE_ONLY );

     E.X := 0;
     E.Y := 1;
     E.Z := 2;
     for I := 0 to FsN-1 do
     begin
          with Fs[ I ] do
          begin
               Ps.Items[ E.X ] := Pos1;
               Ps.Items[ E.Y ] := Pos2;
               Ps.Items[ E.Z ] := Pos3;

               Ns.Items[ E.X ] := Nor;
               Ns.Items[ E.Y ] := Nor;
               Ns.Items[ E.Z ] := Nor;
          end;

          Es.Items[ I*3+0 ] := TCardinal2D.Create( E.X, E.Y );
          Es.Items[ I*3+1 ] := TCardinal2D.Create( E.Y, E.Z );
          Es.Items[ I*3+2 ] := TCardinal2D.Create( E.Z, E.X );

          Inc( E.X, 3 );
          Inc( E.Y, 3 );
          Inc( E.Z, 3 );
     end;

     _PosBuf.Unmap;
     _NorBuf.Unmap;
     _EleBuf.Unmap;
end;

//------------------------------------------------------------------------------

procedure TGLShaperLine.LoadFromFileOBJ( const FileName_:String );
type
    TVert = record
      P :Integer;
      N :Integer;
      T :Integer;
    end;
var
   Vs :TDictionary<TVert,Integer>;
//·····································
     function ReadVert( const M_:TMatch ) :Cardinal;
     var
        V :TVert;
     begin
          with V do
          begin
               P := StrToIntDef( M_.Groups[ 1 ].Value, 0 ) - 1;
               T := StrToIntDef( M_.Groups[ 2 ].Value, 0 ) - 1;
               N := StrToIntDef( M_.Groups[ 3 ].Value, 0 ) - 1;
          end;

          if Vs.ContainsKey( V ) then Result := Vs[ V ]
          else
          begin
               Result := Vs.Count;  Vs.Add( V, Result );
          end;
     end;
//·····································
var
   F :TStreamReader;
   RV, RN, RT, RF, RI :TRegEx;
   Ps, Ns :TArray<TSingle3D>;
   Ts :TArray<TSingle2D>;
   L :String; 
   P, N :TSingle3D;
   T :TSingle2D;
   Es :TArray<TCardinal2D>;
   Ms :TMatchCollection;
   E :TCardinal2D;
   K :Integer;
   V :TPair<TVert,Integer>;
begin
     Vs := TDictionary<TVert,Integer>.Create;

     F := TStreamReader.Create( FileName_, TEncoding.Default );
     try
          RV := TRegEx.Create( 'v[ \t]+([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t\n]+)' );
          RN := TRegEx.Create( 'vn[ \t]+([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t\n]+)' );
          RT := TRegEx.Create( 'vt[ \t]+([^ \t]+)[ \t]+([^ \t]+)' );
          RF := TRegEx.Create( 'f( [^\n]+)' );
          RI := TRegEx.Create( '[ \t]+(\d+)/?(\d*)/?(\d*)' );

          Ps := [];
          Ns := [];
          Ts := [];
          Es := [];
          while not F.EndOfStream do
          begin
               L := F.ReadLine;

               with RV.Match( L ) do
               begin
                    if Success then
                    begin
                         P.X := Groups[ 1 ].Value.ToSingle;
                         P.Y := Groups[ 2 ].Value.ToSingle;
                         P.Z := Groups[ 3 ].Value.ToSingle;

                         Ps := Ps + [ P ];
                    end;
               end;

               with RN.Match( L ) do
               begin
                    if Success then
                    begin
                         N.X := Groups[ 1 ].Value.ToSingle;
                         N.Y := Groups[ 2 ].Value.ToSingle;
                         N.Z := Groups[ 3 ].Value.ToSingle;

                         Ns := Ns + [ N ];
                    end;
               end;

               with RT.Match( L ) do
               begin
                    if Success then
                    begin
                         T.X := Groups[ 1 ].Value.ToSingle;
                         T.Y := Groups[ 2 ].Value.ToSingle;

                         Ts := Ts + [ T ];
                    end;
               end;

               with RF.Match( L ) do
               begin
                    if Success then
                    begin
                         Ms := RI.Matches( Groups[ 1 ].Value );

                         E.X := ReadVert( Ms[ 0 ] );
                         E.Y := ReadVert( Ms[ 1 ] );

                         Es := Es + [ E ];

                         for K := 2 to Ms.Count-1 do
                         begin
                              E.X := E.Y;  E.Y := ReadVert( Ms[ K ] );

                              Es := Es + [ E ];
                         end;
                    end;
               end;
          end;
     finally
            F.DisposeOf;
     end;

     if Length( Ps ) > 0 then
     begin
          with _PosBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ps[ V.Key.P ];
               end;

               Unmap;
          end;
     end;

     if Length( Ns ) > 0 then
     begin
          with _NorBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ns[ V.Key.N ];
               end;

               Unmap;
          end;
     end;

     if Length( Ts ) > 0 then
     begin
          with _TexBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ts[ V.Key.T ];
               end;

               Unmap;
          end;
     end;

     Vs.DisposeOf;

     _EleBuf.Import( Es );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperFace

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperFace.DrawCore;
begin
     _EleBuf.Draw;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLShaperFace.Create( const Paren_:ITreeNode );
begin
     inherited;

     _EleBuf := TGLElemerFace32.Create( GL_STATIC_DRAW );
end;

destructor TGLShaperFace.Destroy;
begin
     _EleBuf.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperFace.LoadFromFunc( const Func_:TConstFunc<TdSingle2D,TdSingle3D>; const DivU_,DivV_:Integer );
//··································
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := ( DivU_ + 1 ) * Y_ + X_;
     end;
//··································
var
   X0, Y0, X1, Y1, I, I00, I01, I10, I11 :Integer;
   Es :TGLBufferData<TCardinal3D>;
begin
     inherited;

     _EleBuf.Count := 2 * DivV_ * DivU_;

     Es := _EleBuf.Map( GL_WRITE_ONLY );

     I := 0;
     for Y0 := 0 to DivV_-1 do
     begin
          Y1 := Y0 + 1;
          for X0 := 0 to DivU_-1 do
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

     _EleBuf.Unmap;
end;

//------------------------------------------------------------------------------

procedure TGLShaperFace.LoadFromFileSTL( const FileName_:String );
var
   F :TFileStream;
   Hs :array [ 0..80-1 ] of AnsiChar;
   FsN, I :Cardinal;
   Fs :array of packed record
                  Nor  :TSingle3D;
                  Pos1 :TSingle3D;
                  Pos2 :TSingle3D;
                  Pos3 :TSingle3D;
                  _    :Word;
                end;
   E :TCardinal3D;
   Ps, Ns :TGLBufferData<TSingle3D>;
   Es :TGLBufferData<TCardinal3D>;
begin
     F := TFileStream.Create( FileName_, fmOpenRead );
     try
        F.Read( Hs, SizeOf( Hs ) );

        F.Read( FsN, SizeOf( FsN ) );

        SetLength( Fs, FsN );

        F.Read( Fs[0], 50 * FsN );
     finally
            F.DisposeOf;
     end;

     _PosBuf.Count := 3 * FsN;
     _NorBuf.Count := 3 * FsN;
     _EleBuf.Count :=     FsN;

     Ps := _PosBuf.Map( GL_WRITE_ONLY );
     Ns := _NorBuf.Map( GL_WRITE_ONLY );
     Es := _EleBuf.Map( GL_WRITE_ONLY );

     E.X := 0;
     E.Y := 1;
     E.Z := 2;
     for I := 0 to FsN-1 do
     begin
          with Fs[ I ] do
          begin
               Ps.Items[ E.X ] := Pos1;
               Ps.Items[ E.Y ] := Pos2;
               Ps.Items[ E.Z ] := Pos3;

               Ns.Items[ E.X ] := Nor;
               Ns.Items[ E.Y ] := Nor;
               Ns.Items[ E.Z ] := Nor;
          end;

          Es.Items[ I ] := E;

          Inc( E.X, 3 );
          Inc( E.Y, 3 );
          Inc( E.Z, 3 );
     end;

     _PosBuf.Unmap;
     _NorBuf.Unmap;
     _EleBuf.Unmap;
end;

//------------------------------------------------------------------------------

procedure TGLShaperFace.LoadFromFileOBJ( const FileName_:String );
type
    TVert = record
      P :Integer;
      N :Integer;
      T :Integer;
    end;
var
   Vs :TDictionary<TVert,Integer>;
//·····································
     function ReadVert( const M_:TMatch ) :Cardinal;
     var
        V :TVert;
     begin
          with V do
          begin
               P := StrToIntDef( M_.Groups[ 1 ].Value, 0 ) - 1;
               T := StrToIntDef( M_.Groups[ 2 ].Value, 0 ) - 1;
               N := StrToIntDef( M_.Groups[ 3 ].Value, 0 ) - 1;
          end;

          if Vs.ContainsKey( V ) then Result := Vs[ V ]
          else
          begin
               Result := Vs.Count;  Vs.Add( V, Result );
          end;
     end;
//·····································
var
   F :TStreamReader;
   RV, RN, RT, RF, RI :TRegEx;
   Ps, Ns :TArray<TSingle3D>;
   Ts :TArray<TSingle2D>;
   L :String; 
   P, N :TSingle3D;
   T :TSingle2D;
   Es :TArray<TCardinal3D>;
   Ms :TMatchCollection;
   E :TCardinal3D;
   K :Integer;
   V :TPair<TVert,Integer>;
begin
     Vs := TDictionary<TVert,Integer>.Create;

     F := TStreamReader.Create( FileName_, TEncoding.Default );
     try
          RV := TRegEx.Create( 'v[ \t]+([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t\n]+)' );
          RN := TRegEx.Create( 'vn[ \t]+([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t\n]+)' );
          RT := TRegEx.Create( 'vt[ \t]+([^ \t]+)[ \t]+([^ \t]+)' );
          RF := TRegEx.Create( 'f( [^\n]+)' );
          RI := TRegEx.Create( '[ \t]+(\d+)/?(\d*)/?(\d*)' );

          Ps := [];
          Ns := [];
          Ts := [];
          Es := [];
          while not F.EndOfStream do
          begin
               L := F.ReadLine;

               with RV.Match( L ) do
               begin
                    if Success then
                    begin
                         P.X := Groups[ 1 ].Value.ToSingle;
                         P.Y := Groups[ 2 ].Value.ToSingle;
                         P.Z := Groups[ 3 ].Value.ToSingle;

                         Ps := Ps + [ P ];
                    end;
               end;

               with RN.Match( L ) do
               begin
                    if Success then
                    begin
                         N.X := Groups[ 1 ].Value.ToSingle;
                         N.Y := Groups[ 2 ].Value.ToSingle;
                         N.Z := Groups[ 3 ].Value.ToSingle;

                         Ns := Ns + [ N ];
                    end;
               end;

               with RT.Match( L ) do
               begin
                    if Success then
                    begin
                         T.X := Groups[ 1 ].Value.ToSingle;
                         T.Y := Groups[ 2 ].Value.ToSingle;

                         Ts := Ts + [ T ];
                    end;
               end;

               with RF.Match( L ) do
               begin
                    if Success then
                    begin
                         Ms := RI.Matches( Groups[ 1 ].Value );

                         E.X := ReadVert( Ms[ 0 ] );
                         E.Y := ReadVert( Ms[ 1 ] );
                         E.Z := ReadVert( Ms[ 2 ] );

                         Es := Es + [ E ];

                         for K := 3 to Ms.Count-1 do
                         begin
                              E.Y := E.Z;  E.Z := ReadVert( Ms[ K ] );

                              Es := Es + [ E ];
                         end;
                    end;
               end;
          end;
     finally
            F.DisposeOf;
     end;

     if Length( Ps ) > 0 then
     begin
          with _PosBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ps[ V.Key.P ];
               end;

               Unmap;
          end;
     end;

     if Length( Ns ) > 0 then
     begin
          with _NorBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ns[ V.Key.N ];
               end;

               Unmap;
          end;
     end;

     if Length( Ts ) > 0 then
     begin
          with _TexBuf do
          begin
               Count := Vs.Count;

               with Map( GL_WRITE_ONLY ) do
               begin
                    for V in Vs do Items[ V.Value ] := Ts[ V.Key.T ];
               end;

               Unmap;
          end;
     end;

     Vs.DisposeOf;

     _EleBuf.Import( Es );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLShaperCopy

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLShaperCopy.BeginDraw;
begin
     inherited;

     with _Shaper do
     begin
          if not Assigned( Self._Matery ) then Matery.Use;

          PosBuf.Use( 0{BinP} );
          NorBuf.Use( 1{BinP} );
          TexBuf.Use( 2{BinP} );
     end;
end;

procedure TGLShaperCopy.DrawCore;
begin
     _Shaper.DrawCore;
end;

procedure TGLShaperCopy.EndDraw;
begin
     with _Shaper do
     begin
          PosBuf.Unuse( 0{BinP} );
          NorBuf.Unuse( 1{BinP} );
          TexBuf.Unuse( 2{BinP} );

          if not Assigned( Self._Matery ) then Matery.Use;
     end;

     inherited;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLShaperCopy.Create( const Paren_:ITreeNode );
begin
     inherited;

end;

destructor TGLShaperCopy.Destroy;
begin

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
