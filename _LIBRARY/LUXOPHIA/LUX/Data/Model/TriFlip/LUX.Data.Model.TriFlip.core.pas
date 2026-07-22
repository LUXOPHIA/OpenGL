unit LUX.Data.Model.TriFlip.core;

interface //#################################################################### ■

uses System.Classes,
     LUX,
     LUX.Data.Model.Poins,
     LUX.Data.Model.Faces;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TTriPoin   <TPos_> = class;
     TTriPoinSet<TPos_> = class;

     TTriFace   <TPos_> = class;
     TTriFaceSet<TPos_> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TVertLR

     // 頂点番号（1..3）の巡回表の行。
     TVertLR = record
     private
     public
       L :Byte;
       R :Byte;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCornIter

     TCornIter<_TPos_> = record
       type TPoin_ = TTriPoin<_TPos_>;
       type TFace_ = TTriFace<_TPos_>;
     private
       _Face :TFace_;
       _Corn :Byte;
       ///// A C C E S S O R
       function GetFlip :TCornIter<_TPos_>;
       procedure SetFlip( Flip_:TCornIter<_TPos_> );
       function GetFacePrev :TCornIter<_TPos_>;
       function GetFaceNext :TCornIter<_TPos_>;
       function GetVertPrev :TCornIter<_TPos_>;
       procedure SetVertPrev( VertPrev_:TCornIter<_TPos_> );
       function GetVertNext :TCornIter<_TPos_>;
       procedure SetVertNext( VertNext_:TCornIter<_TPos_> );
       function GetVert :TPoin_;
     public
       constructor Create( Face_:TFace_; Corn_:Byte );
       ///// P R O P E R T Y
       property Face     :TFace_            read   _Face     write   _Face    ;
       property Corn     :Byte              read   _Corn     write   _Corn    ;
       property Flip     :TCornIter<_TPos_> read GetFlip     write SetFlip    ;
       property FacePrev :TCornIter<_TPos_> read GetFacePrev                  ;
       property FaceNext :TCornIter<_TPos_> read GetFaceNext                  ;
       property VertPrev :TCornIter<_TPos_> read GetVertPrev write SetVertPrev;
       property VertNext :TCornIter<_TPos_> read GetVertNext write SetVertNext;
       property Vert     :TPoin_            read GetVert                      ;
       ///// O P E R A T O R
       class operator Equal( const A_,B_:TCornIter<_TPos_> ) :Boolean;
       class operator NotEqual( const A_,B_:TCornIter<_TPos_> ) :Boolean;
       ///// M E T H O D
       procedure GoFlip;
       procedure GoFacePrev;
       procedure GoFaceNext;
       procedure GoVertPrev;
       procedure GoVertNext;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoin<TPos_>

     TTriPoin<TPos_> = class( TPoin<TPos_,TTriPoinSet<TPos_>> )
     private
       type TFace_ = TTriFace <TPos_>;
       type TCorn_ = TCornIter<TPos_>;
     protected
       _Face :TFace_;
       _Corn :Byte;
       ///// A C C E S S O R
       function GetFace :TFace_; virtual;
       procedure SetFace( const Face_:TFace_ ); virtual;
       function GetCorn :Byte; virtual;
       procedure SetCorn( const Corn_:Byte ); virtual;
       function GetFacesN :Integer; virtual;
     public
       ///// P R O P E R T Y
       property Face   :TFace_  read GetFace   write SetFace;
       property Corn   :Byte    read GetCorn   write SetCorn;
       property FacesN :Integer read GetFacesN              ;
       ///// M E T H O D
       class function JoinOK( const C1_,C2_:TCorn_ ) :Boolean;
       procedure JoinEdge;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoinSet<TPos_>

     TTriPoinSet<TPos_> = class( TPoinSet<TPos_,TTriPoin<TPos_>> )
     private
     protected
       ///// M E T H O D
       function LoadPoin( const Pos_:TPos_ ) :TTriPoin<TPos_>; override;  // 読み込む点を生成する。override で点の型を差し替えられる
     public
       ///// M E T H O D
       procedure SaveToStream( const Stream_:TStream ); override;  // 全ての点の座標を書き込む
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFace<TPos_>

     TTriFace<TPos_> = class( TFace<TPos_,TTriFaceSet<TPos_>> )
     private
       type TPoin_ = TTriPoin <TPos_>;
       type TFace_ = TTriFace <TPos_>;
       type TCorn_ = TCornIter<TPos_>;
     protected
       _Poin :array [ 1..3 ] of TPoin_;
       _Face :array [ 1..3 ] of TFace_;
       _Data :Byte;
       ///// A C C E S S O R
       function GetPoin( const I_:Byte ) :TPoin_; virtual;
       procedure SetPoin( const I_:Byte; const Poin_:TPoin_ ); virtual;
       function GetFace( const I_:Byte ) :TFace_; virtual;
       procedure SetFace( const I_:Byte; const Face_:TFace_ ); virtual;
       function GetCorn( const I_:Byte ) :Byte; virtual;
       procedure SetCorn( const I_,Corn_:Byte ); virtual;
       function GetFlip :Boolean; virtual;
       procedure SetFlip( const Flip_:Boolean ); virtual;
       function GetFlag :Boolean; virtual;
       procedure SetFlag( const Flag_:Boolean ); virtual;
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Poin[ const I_:Byte ] :TPoin_  read GetPoin write SetPoin;
       property Face[ const I_:Byte ] :TFace_  read GetFace write SetFace;
       property Corn[ const I_:Byte ] :Byte    read GetCorn write SetCorn;
       property Flip                  :Boolean read GetFlip write SetFlip;
       property Flag                  :Boolean read GetFlag write SetFlag;
       ///// M E T H O D
       procedure BasteCorn( const Corn_:Byte );
       procedure BindPoins;  // 3頂点のアンカー（Poin.Face / Poin.Corn）を自分に向ける
       procedure FlipEdge( const Corn_:Byte );  // 角 Corn_ の対辺を隣の面と張り替える（対角線の交換）。両面が縫合済みであること
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFaceSet<TPos_>

     TTriFaceSet<TPos_> = class( TFaceSet<TPos_,TTriFace<TPos_>> )
     private
       type TPoin_    = TTriPoin   <TPos_>;
       type TPoinSet_ = TTriPoinSet<TPos_>;
       type TFace_    = TTriFace   <TPos_>;
     protected
       _PoinSet :TPoinSet_;
       ///// A C C E S S O R
       function GetPoinSet :TPoinSet_; virtual;
       procedure SetPoinSet( const PoinSet_:TPoinSet_ ); virtual;
       ///// M E T H O D
       function NewPoinSet :TPoinSet_; virtual;  // 点集合を生成する。override で点集合の型を差し替えられる
       function PoinCode( const Poin_:TPoin_ ) :Integer; virtual;  // 集合に属さない点 → 負の符号（既定 -1 = nil。派生が固有の点に符号を割り当てる）
       function CodePoin( const Code_:Integer ) :TPoin_; virtual;  // 負の符号 → 集合に属さない点（既定は nil。派生が固有の点へ写す）
       function LoadFace :TFace_; virtual;                         // 読み込む面を生成する。override で面の型を差し替えられる
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property PoinSet :TPoinSet_ read GetPoinSet write SetPoinSet;
       ///// M E T H O D
       function CheckEdges :Integer;
       function CheckFaceLings :Integer;
       procedure SaveToFile( const FileName_:String ); virtual;    // *.lxtf へ保存（UTF-8 テキストヘッダ ＋ 空行 ＋ バイナリ）
       procedure LoadFromFile( const FileName_:String ); virtual;  // *.lxtf から復元（点も面も接続ごと全て置き換わる）
     end;

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      VertTableInc :array [ 1..3 ] of TVertLR = ( ( L:2; R:3 ), ( L:3; R:1 ), ( L:1; R:2 ) );  // L = 次の頂点, R = 前の頂点
      VertTableDec :array [ 1..3 ] of TVertLR = ( ( L:3; R:2 ), ( L:1; R:3 ), ( L:2; R:1 ) );  // L = 前の頂点, R = 次の頂点

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.SysUtils,
     LUX.Data;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCornIter<_TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

function TCornIter<_TPos_>.GetFlip :TCornIter<_TPos_>;
begin
     Result.Face := _Face.Face[ _Corn ];
     Result.Corn := _Face.Corn[ _Corn ];
end;

procedure TCornIter<_TPos_>.SetFlip( Flip_:TCornIter<_TPos_> );
begin
     _Face.Face[ _Corn ] := Flip_.Face;
     _Face.Corn[ _Corn ] := Flip_.Corn;
end;

function TCornIter<_TPos_>.GetFacePrev :TCornIter<_TPos_>;
begin
     Result.Face :=               _Face    ;
     Result.Corn := VertTableDec[ _Corn ].L;
end;

function TCornIter<_TPos_>.GetFaceNext :TCornIter<_TPos_>;
begin
     Result.Face :=               _Face    ;
     Result.Corn := VertTableInc[ _Corn ].L;
end;

function TCornIter<_TPos_>.GetVertPrev :TCornIter<_TPos_>;
begin
     Result := FaceNext.Flip;
end;

procedure TCornIter<_TPos_>.SetVertPrev( VertPrev_:TCornIter<_TPos_> );
begin
     FaceNext.Flip := VertPrev_;
end;

function TCornIter<_TPos_>.GetVertNext :TCornIter<_TPos_>;
begin
     Result := Flip.FacePrev;
end;

procedure TCornIter<_TPos_>.SetVertNext( VertNext_:TCornIter<_TPos_> );
begin
     Flip := VertNext_.FaceNext;
end;

function TCornIter<_TPos_>.GetVert :TPoin_;
begin
     Result := _Face.Poin[ _Corn ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCornIter<_TPos_>.Create( Face_:TFace_; Corn_:Byte );
begin
     _Face := Face_;
     _Corn := Corn_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TCornIter<_TPos_>.Equal( const A_,B_:TCornIter<_TPos_> ) :Boolean;
begin
     Result := ( A_.Face = B_.Face ) and ( A_.Corn = B_.Corn )
end;

class operator TCornIter<_TPos_>.NotEqual( const A_,B_:TCornIter<_TPos_> ) :Boolean;
begin
     Result := not ( A_ = B_ );
end;

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TCornIter<_TPos_>.GoFlip;
var
   F :TCornIter<_TPos_>;
begin
     F.Face := _Face;
     F.Corn := _Corn;

     _Face := F.Face.Face[ F.Corn ];
     _Corn := F.Face.Corn[ F.Corn ];
end;

procedure TCornIter<_TPos_>.GoFacePrev;
begin
     _Corn := VertTableDec[ _Corn ].L;
end;

procedure TCornIter<_TPos_>.GoFaceNext;
begin
     _Corn := VertTableInc[ _Corn ].L;
end;

procedure TCornIter<_TPos_>.GoVertPrev;
begin
     GoFaceNext;
     GoFlip;
end;

procedure TCornIter<_TPos_>.GoVertNext;
begin
     GoFlip;
     GoFacePrev;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoin<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriPoin<TPos_>.GetFace :TTriFace<TPos_>;
begin
     Result := _Face;
end;

procedure TTriPoin<TPos_>.SetFace( const Face_:TTriFace<TPos_> );
begin
     _Face := Face_;
end;

function TTriPoin<TPos_>.GetCorn :Byte;
begin
     Result := _Corn;
end;

procedure TTriPoin<TPos_>.SetCorn( const Corn_:Byte );
begin
     _Corn := Corn_;
end;

function TTriPoin<TPos_>.GetFacesN :Integer;
var
   F, F0 :TFace_;
   C, C0 :Byte;
begin
     Result := 0;

     if Face <> nil then
     begin
          F := Face;
          C := VertTableInc[ Corn ].L;

          repeat
                Inc( Result );

                F0 := F;
                C0 := C;

                F :=               F0.Face[ C0 ]   ;
                C := VertTableDec[ F0.Corn[ C0 ] ].L;

          until F = Face;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TTriPoin<TPos_>.JoinOK( const C1_,C2_:TCorn_ ) :Boolean;
begin
     Result := ( C1_.FaceNext.Vert = C2_.Vert );
end;

procedure TTriPoin<TPos_>.JoinEdge;
var
   T,  C,
   C0, C1,
   P0, P1, P2,
   H0, H1,
   T0, T1,
   S0, S1, S2, S3 :TCorn_;
begin
     T := TCorn_.Create( nil, 0 );

     C := TCorn_.Create( _Face, _Corn ).FaceNext;

     C1 := C;

     repeat
           C0 := C1;  C1 := C0.VertNext;

           if  T.Face = nil then
           begin
                C0.VertNext := C0;

                T := C0;
           end
           else
           begin
                P0 := T;
                P1 := C0;
                P2 := T.VertNext;

                P0.VertNext := P1;  P1.VertNext := P2;

                T0 := P0;  T1 := P1;
                           H0 := P1;  H1 := P2;

                ///// 後方

                S0 := H0;  S1 := H1;
                           S2 := H1;
                repeat
                     S3 := S2.VertNext;

                     if JoinOK( S2, S3 ) then
                     begin
                                     S2 := S3;
                     end
                     else
                     if JoinOK( S2, T1 ) then
                     begin
                          S0.VertNext := S3;  H1 := H0.VertNext;

                          T0.VertNext := S1;  S2.VertNext := T1;

                          T1 := S1;

                          S0 := H0;  S1 := H1;
                                     S2 := H1;
                     end
                     else
                     begin
                          S0 := S2;  S1 := S3;
                                     S2 := S3;
                     end;

                until S3 = T0;

                ///// 前方

                S0 := H0;  S1 := H1;
                           S2 := H1;
                repeat
                      S3 := S2.VertNext;

                      if JoinOK( S2, S3 ) then
                      begin
                                     S2 := S3;
                      end
                      else
                      if JoinOK( H0, S1 ) then
                      begin
                           S0.VertNext := S3;  H1 := H0.VertNext;

                           H0.VertNext := S1;  S2.VertNext := H1;

                           H0 := S2;

                           S0 := H0;  S1 := H1;
                                      S2 := H1;
                      end
                      else
                      begin
                           S0 := S2;  S1 := S3;
                                      S2 := S3;
                      end;

                until S3 = T1;

                T := H0;
           end;
     until C1 = C;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoinSet<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TTriPoinSet<TPos_>.LoadPoin( const Pos_:TPos_ ) :TTriPoin<TPos_>;
begin
     Result := TTriPoin<TPos_>.Create( Pos_, Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TTriPoinSet<TPos_>.SaveToStream( const Stream_:TStream );
var
   I :Integer;
   V :TPos_;
begin
     for I := 0 to ChildrsN-1 do
     begin
          V := Childrs[ I ].Pos;

          Stream_.WriteBuffer( V, SizeOf( TPos_ ) );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFace<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriFace<TPos_>.GetPoin( const I_:Byte ) :TPoin_;
begin
     Result := _Poin[ I_ ];
end;

procedure TTriFace<TPos_>.SetPoin( const I_:Byte; const Poin_:TPoin_ );
begin
     _Poin[ I_ ] := Poin_;
end;

function TTriFace<TPos_>.GetFace( const I_:Byte ) :TTriFace<TPos_>;
begin
     Result := _Face[ I_ ];
end;

procedure TTriFace<TPos_>.SetFace( const I_:Byte; const Face_:TTriFace<TPos_> );
begin
     _Face[ I_ ] := Face_;
end;

function TTriFace<TPos_>.GetCorn( const I_:Byte ) :Byte;
begin
     Result := ( _Data shr ( I_ shl 1 ) ) and 3;
end;

procedure TTriFace<TPos_>.SetCorn( const I_,Corn_:Byte );
var
   I :Integer;
begin
     I := I_ shl 1;

     _Data := ( _Data and ( $FF - ( 3 shl I ) ) ) or ( Corn_ shl I );
end;

function TTriFace<TPos_>.GetFlip :Boolean;
begin
     Result := ( _Data and 1 <> 0 );
end;

procedure TTriFace<TPos_>.SetFlip( const Flip_:Boolean );
begin
     _Data := _Data and ($FF-1);  if Flip_ then _Data := _Data or 1;
end;

function TTriFace<TPos_>.GetFlag :Boolean;
begin
     Result := ( _Data and 2 <> 0 );
end;

procedure TTriFace<TPos_>.SetFlag( const Flag_:Boolean );
begin
     _Data := _Data and ($FF-2);  if Flag_ then _Data := _Data or 2;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTriFace<TPos_>.Create;
begin
     inherited;

     Poin[ 1 ] := nil;
     Poin[ 2 ] := nil;
     Poin[ 3 ] := nil;

     Face[ 1 ] := Self;  Corn[ 1 ] := 2;
     Face[ 2 ] := Self;  Corn[ 2 ] := 3;
     Face[ 3 ] := Self;  Corn[ 3 ] := 1;

     Flip := True;
     Flag := False;
end;

destructor TTriFace<TPos_>.Destroy;
var
   I :Byte;
   V :TPoin_;
begin
     for I := 1 to 3 do  // 自分を指しているアンカーを外す（宙吊り防止）
     begin
          V := _Poin[ I ];

          if Assigned( V ) and ( V._Face = Self ) then V._Face := nil;
     end;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TTriFace<TPos_>.BasteCorn( const Corn_:Byte );
var
   V :TPoin_;
   C0, C1, C2 :TCorn_;
begin
     V := _Poin[ Corn_ ];

     C1 := TCorn_.Create( Self, Corn_ ).FaceNext;

     if Assigned( V._Face ) then
     begin
          C0 := TCorn_.Create( V._Face, V._Corn ).FaceNext;

          C2 := C0.VertNext;

          C0.VertNext := C1;  C1.VertNext := C2;
     end
     else
     begin
          C1.VertNext := C1;
     end;

     V._Face := Self;
     V._Corn := Corn_;
end;

procedure TTriFace<TPos_>.BindPoins;
var
   I :Byte;
   V :TPoin_;
begin
     for I := 1 to 3 do
     begin
          V := _Poin[ I ];

          if Assigned( V ) then
          begin
               V._Face := Self;  V._Corn := I;
          end;
     end;
end;

procedure TTriFace<TPos_>.FlipEdge( const Corn_:Byte );
var
   F, G, Nbe, Nda :TFace_;
   cF, cG, Nbc, Ndc :Byte;
   Pa, Pb, Pd, Pe :TPoin_;
begin
     F  := Self;
     cF := Corn_;

     G  := F.Face[ cF ];
     cG := F.Corn[ cF ];

     Pa := F.Poin[ cF ];                        // F = ( Pa, Pb, Pd )
     Pb := F.Poin[ VertTableInc[ cF ].L ];      // G = ( Pe, Pd, Pb )
     Pd := F.Poin[ VertTableInc[ cF ].R ];      // 共有辺 ( Pb, Pd ) を対角線 ( Pa, Pe ) に張り替える
     Pe := G.Poin[ cG ];

     Nbe := G.Face[ VertTableInc[ cG ].L ];  Nbc := G.Corn[ VertTableInc[ cG ].L ];  // 辺 ( Pb, Pe ) の外側
     Nda := F.Face[ VertTableInc[ cF ].L ];  Ndc := F.Corn[ VertTableInc[ cF ].L ];  // 辺 ( Pd, Pa ) の外側

     F.Poin[ VertTableInc[ cF ].R ] := Pe;  // F = ( Pa, Pb, Pe )
     G.Poin[ VertTableInc[ cG ].R ] := Pa;  // G = ( Pe, Pd, Pa )

     F.Face[ cF ] := Nbe;  F.Corn[ cF ] := Nbc;   Nbe.Face[ Nbc ] := F;  Nbe.Corn[ Nbc ] := cF;
     G.Face[ cG ] := Nda;  G.Corn[ cG ] := Ndc;   Nda.Face[ Ndc ] := G;  Nda.Corn[ Ndc ] := cG;

     F.Face[ VertTableInc[ cF ].L ] := G;  F.Corn[ VertTableInc[ cF ].L ] := VertTableInc[ cG ].L;
     G.Face[ VertTableInc[ cG ].L ] := F;  G.Corn[ VertTableInc[ cG ].L ] := VertTableInc[ cF ].L;

     Pb._Face := F;  Pb._Corn := VertTableInc[ cF ].L;  // 空いた席を指していた可能性のある頂点を席替えする
     Pd._Face := G;  Pd._Corn := VertTableInc[ cG ].L;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFaceSet<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriFaceSet<TPos_>.GetPoinSet :TPoinSet_;
begin
     Result := _PoinSet;
end;

procedure TTriFaceSet<TPos_>.SetPoinSet( const PoinSet_:TPoinSet_ );
begin
     _PoinSet := PoinSet_;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTriFaceSet<TPos_>.NewPoinSet :TPoinSet_;
begin
     Result := TPoinSet_.Create;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTriFaceSet<TPos_>.Create;
begin
     inherited;

     _PoinSet := NewPoinSet;
end;

destructor TTriFaceSet<TPos_>.Destroy;
begin
     Clear;  // 面を先に解放する（面の破棄は頂点のアンカーに触れるため、点集合より前でなければならない）

     _PoinSet.Free;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTriFaceSet<TPos_>.CheckEdges :Integer;
var
   I, C0, C1 :Integer;
   F0, F1 :TFace_;
begin
     Result := 0;

     for I := 0 to ChildrsN-1 do
     begin
          F0 := Childrs[ I ];

          for C0 := 1 to 3 do
          begin
               C1 := F0.Corn[ C0 ];

               if C1 > 0 then
               begin
                    F1 := F0.Face[ C0 ];

                    if F1 = nil then Inc( Result )
                                else
                    if ( F1.Face[ C1 ] <> F0 ) or ( F1.Corn[ C1 ] <> C0 ) then Inc( Result );
               end
               else Inc( Result );
          end;
     end;
end;

function TTriFaceSet<TPos_>.CheckFaceLings :Integer;
var
   V :TPoin_;
   F0, F, F1 :TFace_;
   I, K, C0, C, C1 :Integer;
begin
     Result := 0;

     for I := 0 to PoinSet.ChildrsN-1 do
     begin
          V := PoinSet.Childrs[ I ];

          F0 :=               V.Face    ;
          C0 := VertTableInc[ V.Corn ].L;

          F1 := F0;
          C1 := C0;
          for K := 1 to V.FacesN do
          begin
                F := F1;
                C := C1;

                F1 :=               F.Face[ C ]   ;
                C1 := VertTableDec[ F.Corn[ C ] ].L;
          end;

          if F1 <> F0 then Inc( Result );
     end
end;

//------------------------------------------------------------------------------

function TTriFaceSet<TPos_>.PoinCode( const Poin_:TPoin_ ) :Integer;
begin
     Result := -1;  // 集合に属さない点は、既定では nil として保存される
end;

function TTriFaceSet<TPos_>.CodePoin( const Code_:Integer ) :TPoin_;
begin
     Result := nil;  // 負の符号は、既定では nil として復元される
end;

function TTriFaceSet<TPos_>.LoadFace :TFace_;
begin
     Result := TFace_.Create( Self );
end;

//------------------------------------------------------------------------------

procedure TTriFaceSet<TPos_>.SaveToFile( const FileName_:String );
// LUXOPHIA コンテナ形式（LUX.Data 参照）。点は座標のみ（アンカーは導出情報なので保存しない）、
// 面は「頂点番号 ×3 ＋ 隣接面番号 ×3 ＋ 角と旗（_Data）」で、接続構造がそのまま往復する
var
   S :TFileStream;
   I, C :Integer;
   K :Byte;
   F :TFace_;
   P :TPoin_;
   D :Byte;
begin
     S := TFileStream.Create( FileName_, fmCreate );
     try
        WriteHead( S, 'LUXOPHIA TriFlip 1.0', [ 'PoinsN='  + IntToStr( PoinSet.ChildrsN ),
                                                'FacesN='  + IntToStr( ChildrsN         ),
                                                'PosSize=' + IntToStr( SizeOf( TPos_ )  ) ] );

        PoinSet.SaveToStream( S );

        for I := 0 to ChildrsN-1 do
        begin
             F := Childrs[ I ];

             for K := 1 to 3 do  // 点 → 番号（集合の中 = 添字、外 = 負の符号）
             begin
                  P := F._Poin[ K ];

                  if      P = nil            then C := -1
                  else if P.Parent = PoinSet then C := P.Order
                                             else C := PoinCode( P );

                  S.WriteBuffer( C, 4 );
             end;

             for K := 1 to 3 do
             begin
                  if F._Face[ K ] = nil then C := -1
                                        else C := F._Face[ K ].Order;

                  S.WriteBuffer( C, 4 );
             end;

             D := F._Data;

             S.WriteBuffer( D, 1 );
        end;
     finally
        S.Free;
     end;
end;

procedure TTriFaceSet<TPos_>.LoadFromFile( const FileName_:String );
var
   S :TFileStream;
   PoinsN, FacesN, PosSize :Integer;
   I, C, E :Integer;
   K :Byte;
   F :TFace_;
   P :TPoin_;
   D :Byte;
   L, N :String;
begin
     S := TFileStream.Create( FileName_, fmOpenRead or fmShareDenyWrite );
     try
        PoinsN  := -1;
        FacesN  := -1;
        PosSize := SizeOf( TPos_ );

        for L in ReadHead( S, 'LUXOPHIA TriFlip 1.0' ) do  // オプション行（名前=値）
        begin
             E := Pos( '=', L );

             if E <= 0 then Continue;  // 知らない行は読み飛ばす

             N := Copy( L, 1, E-1 );

             if N = 'PoinsN'  then PoinsN  := StrToIntDef( Copy( L, E+1, MaxInt ), -1 ) else
             if N = 'FacesN'  then FacesN  := StrToIntDef( Copy( L, E+1, MaxInt ), -1 ) else
             if N = 'PosSize' then PosSize := StrToIntDef( Copy( L, E+1, MaxInt ), -1 );
        end;

        if ( PoinsN < 0 ) or ( FacesN < 0 ) then raise EInOutError.Create( 'TTriFaceSet.LoadFromFile: PoinsN / FacesN が無い: ' + FileName_ );

        if PosSize <> SizeOf( TPos_ ) then raise EInOutError.Create( 'TTriFaceSet.LoadFromFile: 座標の型が合わない: ' + FileName_ );

        Clear;  // 面 → 点の順で全て置き換える（面の破棄は頂点のアンカーに触れる）

        PoinSet.LoadFromStream( S, PoinsN );

        for I := 1 to FacesN do LoadFace;  // 生成順 = 保存順 = 面の番号

        for I := 0 to FacesN-1 do
        begin
             F := Childrs[ I ];

             for K := 1 to 3 do
             begin
                  S.ReadBuffer( C, 4 );

                  if C >= PoinsN then raise EInOutError.Create( 'TTriFaceSet.LoadFromFile: 頂点番号が壊れている: ' + FileName_ );

                  if C >= 0 then F._Poin[ K ] := PoinSet[ C ]
                            else F._Poin[ K ] := CodePoin( C );
             end;

             for K := 1 to 3 do
             begin
                  S.ReadBuffer( C, 4 );

                  if C >= FacesN then raise EInOutError.Create( 'TTriFaceSet.LoadFromFile: 隣接面番号が壊れている: ' + FileName_ );

                  if C >= 0 then F._Face[ K ] := Childrs[ C ]
                            else F._Face[ K ] := nil;
             end;

             S.ReadBuffer( D, 1 );

             F._Data := D;
        end;

        for I := 0 to FacesN-1 do  // アンカー（導出情報）を張り直す
        begin
             F := Childrs[ I ];

             for K := 1 to 3 do
             begin
                  P := F._Poin[ K ];

                  if Assigned( P ) then begin  P._Face := F;  P._Corn := K;  end;
             end;
        end;
     finally
        S.Free;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
