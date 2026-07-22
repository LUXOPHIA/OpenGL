unit LUX.Data.Model.TetraFlip.core;

// 四面体メッシュ（TetraFlip）の実装層
//
// ・LUX.Data.Model.TriFlip.core の立体版。頂点（Poin）・胞（Cell）とその集合からなり、
//   胞どうしは4つの面で貼り合わされる。
// ・頂点番号は 0..3。過去実装（LUX.Brep.Cell.TetraFlip）の巡回表をそのまま継承する。
//     VertTable[K] … 面 K（頂点 K の対面）から見た頂点の正準順。先頭 = 対頂点 K、
//                     残り3つ = 面の頂点。各行は (0,1,2,3) の偶置換なので、どの面から
//                     見ても胞の向きは一致する。さらに各行は対合（自分自身が逆置換）
//                     なので、「枠番号 → 頂点番号」と「頂点番号 → 枠番号」の両方に
//                     同じ表が使える。
//     BondTable[B] … 共有面の貼り合わせの回転コード（1..3）。三角形の面は両側の胞から
//                     逆向きに見えるため、貼り合わせは 0 を固定する奇置換（互換）に
//                     限られ、ちょうど3通り。互換は対合なので、コードは両側で同じ値になる。
// ・面 K の隣接情報は3つ:
//     Cell[K] … 隣の胞
//     Corn[K] … 隣の胞から見た対頂点の番号（2bit × 4 を1バイトに詰める）
//     Bond[K] … 共有面の回転コード（2bit × 4 を1バイトに詰める。値 1..3 は2bitに収まる）
//   これらの合成が Join[K,I] = VertTable[ Corn[K] ]._[ BondTable[ Bond[K] ]._[ I ] ]
//   であり、「面 K の枠番号 I に見える自分の頂点」が隣の胞では何番かを与える。
// ・貼り合わせは Weld の一手のみ。両側の面の頂点の同一性から回転コードを導出するため、
//   利用側が Bond を手計算する必要はない。
// ・頂点は所属する胞を1つだけ覚える（Cell / Corn のアンカー）。胞の生成時に BindPoins で
//   張り直せば、頂点から星（周囲の胞）への探索が O(1) で始められる。

interface //#################################################################### ■

uses System.Classes,
     LUX,
     LUX.Data.Model.Poins,
     LUX.Data.Model.Cells;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TTetraPoin   <TPos_> = class;
     TTetraPoinSet<TPos_> = class;

     TTetraCell   <TPos_> = class;
     TTetraCellSet<TPos_> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TByteArray4

     // 巡回表の行。
     TByteArray4 = record
     private
     public
       _ :array [ 0..3 ] of Byte;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoin<TPos_>

     TTetraPoin<TPos_> = class( TPoin<TPos_,TTetraPoinSet<TPos_>> )
     private
       type TCell_ = TTetraCell<TPos_>;
     protected
       _Cell :TCell_;
       _Corn :Byte;
       ///// A C C E S S O R
       function GetCell :TCell_; virtual;
       procedure SetCell( const Cell_:TCell_ ); virtual;
       function GetCorn :Byte; virtual;
       procedure SetCorn( const Corn_:Byte ); virtual;
     public
       ///// P R O P E R T Y
       property Cell :TCell_ read GetCell write SetCell;  // 所属先の胞（アンカー）
       property Corn :Byte   read GetCorn write SetCorn;  // その胞の中の頂点番号
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoinSet<TPos_>

     TTetraPoinSet<TPos_> = class( TPoinSet<TPos_,TTetraPoin<TPos_>> )
     private
     protected
       ///// M E T H O D
       function LoadPoin( const Pos_:TPos_ ) :TTetraPoin<TPos_>; override;  // 読み込む点を生成する。override で点の型を差し替えられる
     public
       ///// M E T H O D
       procedure SaveToStream( const Stream_:TStream ); override;  // 全ての点の座標を書き込む
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCell<TPos_>

     TTetraCell<TPos_> = class( TCell<TPos_,TTetraCellSet<TPos_>> )
     private
       type TPoin_ = TTetraPoin<TPos_>;
       type TCell_ = TTetraCell<TPos_>;
     protected
       _Poin :array [ 0..3 ] of TPoin_;
       _Cell :array [ 0..3 ] of TCell_;
       _Corn :Byte;
       _Bond :Byte;
       _Flag :Byte;
       ///// A C C E S S O R
       function GetPoin( const I_:Byte ) :TPoin_; virtual;
       procedure SetPoin( const I_:Byte; const Poin_:TPoin_ ); virtual;
       function GetCell( const I_:Byte ) :TCell_; virtual;
       procedure SetCell( const I_:Byte; const Cell_:TCell_ ); virtual;
       function GetCorn( const I_:Byte ) :Byte; virtual;
       procedure SetCorn( const I_,Corn_:Byte ); virtual;
       function GetBond( const I_:Byte ) :Byte; virtual;
       procedure SetBond( const I_,Bond_:Byte ); virtual;
       function GetJoin( const K_,I_:Byte ) :Byte;
       function GetFlag :Byte; virtual;
       procedure SetFlag( const Flag_:Byte ); virtual;
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Poin[ const I_:Byte ]    :TPoin_ read GetPoin write SetPoin;  // 頂点
       property Cell[ const I_:Byte ]    :TCell_ read GetCell write SetCell;  // 隣接胞（面 I で接する）
       property Corn[ const I_:Byte ]    :Byte   read GetCorn write SetCorn;  // 隣接胞から見た対頂点の番号
       property Bond[ const I_:Byte ]    :Byte   read GetBond write SetBond;  // 共有面の回転コード（1..3）
       property Join[ const K_,I_:Byte ] :Byte   read GetJoin              ;  // 面 K の枠番号 I の頂点 → 隣接胞での頂点番号
       property Flag                     :Byte   read GetFlag write SetFlag;  // 汎用フラグ（探索の状態管理）
       ///// M E T H O D
       function CornOf( const Poin_:TPoin_ ) :Shortint;  // 頂点 → 角番号（-1 = 含まない）
       procedure BindPoins;  // 4頂点のアンカー（Poin.Cell / Poin.Corn）を自分に向ける
       function BondOf( const K_:Byte; const Cell_:TCell_; const CornK_:Byte ) :Byte;  // 面 K_ と相手の面 CornK_ の回転コード（0 = 貼り合わせ不能）
       function CanWeld( const K_:Byte; const Cell_:TCell_; const CornK_:Byte ) :Boolean;  // 貼り合わせられるか（頂点が鏡像で対応するか）
       procedure Weld( const K_:Byte; const Cell_:TCell_; const CornK_:Byte );  // 面 K_ を相手の面 CornK_ と貼り合わせる（回転コードは頂点の同一性から導出）
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCellSet<TPos_>

     TTetraCellSet<TPos_> = class( TCellSet<TPos_,TTetraCell<TPos_>> )
     private
       type TPoin_    = TTetraPoin   <TPos_>;
       type TPoinSet_ = TTetraPoinSet<TPos_>;
       type TCell_    = TTetraCell   <TPos_>;
     protected
       _PoinSet :TPoinSet_;
       ///// A C C E S S O R
       function GetPoinSet :TPoinSet_; virtual;
       procedure SetPoinSet( const PoinSet_:TPoinSet_ ); virtual;
       ///// M E T H O D
       function NewPoinSet :TPoinSet_; virtual;  // 点集合を生成する。override で点集合の型を差し替えられる
       function PoinCode( const Poin_:TPoin_ ) :Integer; virtual;  // 集合に属さない点 → 負の符号（既定 -1 = nil。派生が固有の点に符号を割り当てる）
       function CodePoin( const Code_:Integer ) :TPoin_; virtual;  // 負の符号 → 集合に属さない点（既定は nil。派生が固有の点へ写す）
       function LoadCell :TCell_; virtual;                         // 読み込む胞を生成する。override で胞の型を差し替えられる
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property PoinSet :TPoinSet_ read GetPoinSet write SetPoinSet;
       ///// M E T H O D
       function CheckCells :Integer;  // 全面の相互接続（Cell / Corn / Bond / 頂点対応）の破れの数
       procedure SaveToFile( const FileName_:String ); virtual;    // *.lxtc へ保存（UTF-8 テキストヘッダ ＋ 空行 ＋ バイナリ）
       procedure LoadFromFile( const FileName_:String ); virtual;  // *.lxtc から復元（点も胞も接続ごと全て置き換わる）
     end;

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      // 面 K から見た頂点の正準順（先頭 = 対頂点）。各行は偶置換かつ対合
      VertTable :array [ 0..3 ] of TByteArray4 = ( ( _:( 0, 1, 2, 3 ) ),
                                                   ( _:( 1, 0, 3, 2 ) ),
                                                   ( _:( 2, 3, 0, 1 ) ),
                                                   ( _:( 3, 2, 1, 0 ) ) );

      // 共有面の回転コード（枠番号 → 相手の枠番号）。各行は 0 を固定する互換（対合）
      BondTable :array [ 1..3 ] of TByteArray4 = ( ( _:( 0, 1, 3, 2 ) ),
                                                   ( _:( 0, 3, 2, 1 ) ),
                                                   ( _:( 0, 2, 1, 3 ) ) );

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.SysUtils,
     LUX.Data;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TByteArray4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoin<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraPoin<TPos_>.GetCell :TTetraCell<TPos_>;
begin
     Result := _Cell;
end;

procedure TTetraPoin<TPos_>.SetCell( const Cell_:TTetraCell<TPos_> );
begin
     _Cell := Cell_;
end;

function TTetraPoin<TPos_>.GetCorn :Byte;
begin
     Result := _Corn;
end;

procedure TTetraPoin<TPos_>.SetCorn( const Corn_:Byte );
begin
     _Corn := Corn_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoinSet<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraPoinSet<TPos_>.LoadPoin( const Pos_:TPos_ ) :TTetraPoin<TPos_>;
begin
     Result := TTetraPoin<TPos_>.Create( Pos_, Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TTetraPoinSet<TPos_>.SaveToStream( const Stream_:TStream );
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCell<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraCell<TPos_>.GetPoin( const I_:Byte ) :TPoin_;
begin
     Result := _Poin[ I_ ];
end;

procedure TTetraCell<TPos_>.SetPoin( const I_:Byte; const Poin_:TPoin_ );
begin
     _Poin[ I_ ] := Poin_;
end;

function TTetraCell<TPos_>.GetCell( const I_:Byte ) :TTetraCell<TPos_>;
begin
     Result := _Cell[ I_ ];
end;

procedure TTetraCell<TPos_>.SetCell( const I_:Byte; const Cell_:TTetraCell<TPos_> );
begin
     _Cell[ I_ ] := Cell_;
end;

function TTetraCell<TPos_>.GetCorn( const I_:Byte ) :Byte;
begin
     Result := _Corn shr ( I_ shl 1 ) and 3;
end;

procedure TTetraCell<TPos_>.SetCorn( const I_,Corn_:Byte );
var
   I :Integer;
begin
     I := I_ shl 1;

     _Corn := _Corn and not ( 3 shl I ) or ( Corn_ shl I );
end;

function TTetraCell<TPos_>.GetBond( const I_:Byte ) :Byte;
begin
     Result := _Bond shr ( I_ shl 1 ) and 3;  // 値 1..3 は2bitにそのまま収まる
end;

procedure TTetraCell<TPos_>.SetBond( const I_,Bond_:Byte );
var
   I :Integer;
begin
     I := I_ shl 1;

     _Bond := _Bond and not ( 3 shl I ) or ( Bond_ shl I );
end;

function TTetraCell<TPos_>.GetJoin( const K_,I_:Byte ) :Byte;
begin
     Result := VertTable[ Corn[ K_ ] ]._[ BondTable[ Bond[ K_ ] ]._[ I_ ] ];
end;

function TTetraCell<TPos_>.GetFlag :Byte;
begin
     Result := _Flag;
end;

procedure TTetraCell<TPos_>.SetFlag( const Flag_:Byte );
begin
     _Flag := Flag_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTetraCell<TPos_>.Create;
var
   I :Byte;
begin
     inherited;

     for I := 0 to 3 do
     begin
          _Poin[ I ] := nil ;
          _Cell[ I ] := Self;

          Corn[ I ] := I;
          Bond[ I ] := 1;
     end;

     _Flag := 0;
end;

destructor TTetraCell<TPos_>.Destroy;
var
   I :Byte;
   V :TPoin_;
begin
     for I := 0 to 3 do  // 自分を指しているアンカーを外す（宙吊り防止）
     begin
          V := _Poin[ I ];

          if Assigned( V ) and ( V._Cell = Self ) then V._Cell := nil;
     end;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraCell<TPos_>.CornOf( const Poin_:TPoin_ ) :Shortint;
begin
     for Result := 0 to 3 do
     begin
          if _Poin[ Result ] = Poin_ then Exit;
     end;

     Result := -1;
end;

procedure TTetraCell<TPos_>.BindPoins;
var
   I :Byte;
   V :TPoin_;
begin
     for I := 0 to 3 do
     begin
          V := _Poin[ I ];

          if Assigned( V ) then
          begin
               V._Cell := Self;  V._Corn := I;
          end;
     end;
end;

function TTetraCell<TPos_>.BondOf( const K_:Byte; const Cell_:TCell_; const CornK_:Byte ) :Byte;
var
   P :TPoin_;
begin
     // 自分の面の先頭の頂点が、相手の枠のどこに見えるかで回転コードが決まる
     P := _Poin[ VertTable[ K_ ]._[ 1 ] ];

     if Cell_._Poin[ VertTable[ CornK_ ]._[ 1 ] ] = P then Result := 1
                                                      else
     if Cell_._Poin[ VertTable[ CornK_ ]._[ 3 ] ] = P then Result := 2
                                                      else
     if Cell_._Poin[ VertTable[ CornK_ ]._[ 2 ] ] = P then Result := 3
                                                      else Exit( 0 );

     // 残りの2頂点も鏡像で対応していること（同じ頂点集合でも同じ向きの面は貼り合わせられない）
     if ( Cell_._Poin[ VertTable[ CornK_ ]._[ BondTable[ Result ]._[ 2 ] ] ] <> _Poin[ VertTable[ K_ ]._[ 2 ] ] )
     or ( Cell_._Poin[ VertTable[ CornK_ ]._[ BondTable[ Result ]._[ 3 ] ] ] <> _Poin[ VertTable[ K_ ]._[ 3 ] ] ) then Result := 0;
end;

function TTetraCell<TPos_>.CanWeld( const K_:Byte; const Cell_:TCell_; const CornK_:Byte ) :Boolean;
begin
     Result := BondOf( K_, Cell_, CornK_ ) > 0;
end;

procedure TTetraCell<TPos_>.Weld( const K_:Byte; const Cell_:TCell_; const CornK_:Byte );
var
   B :Byte;
begin
     B := BondOf( K_, Cell_, CornK_ );

     Assert( B > 0, 'TTetraCell.Weld: 面の頂点が一致しません' );

           Cell[ K_     ] := Cell_;        Corn[ K_     ] := CornK_;        Bond[ K_     ] := B;  // 互換は対合なので
     Cell_.Cell[ CornK_ ] := Self ;  Cell_.Corn[ CornK_ ] := K_    ;  Cell_.Bond[ CornK_ ] := B;  // コードは両側で同じ
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCellSet<TPos_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraCellSet<TPos_>.GetPoinSet :TPoinSet_;
begin
     Result := _PoinSet;
end;

procedure TTetraCellSet<TPos_>.SetPoinSet( const PoinSet_:TPoinSet_ );
begin
     _PoinSet := PoinSet_;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraCellSet<TPos_>.NewPoinSet :TPoinSet_;
begin
     Result := TPoinSet_.Create;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTetraCellSet<TPos_>.Create;
begin
     inherited;

     _PoinSet := NewPoinSet;
end;

destructor TTetraCellSet<TPos_>.Destroy;
begin
     Clear;  // 胞を先に解放する（胞の破棄は頂点のアンカーに触れるため、点集合より前でなければならない）

     _PoinSet.Free;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraCellSet<TPos_>.CheckCells :Integer;
var
   I :Integer;
   C0, C1 :TCell_;
   K0, K1, F :Byte;
begin
     Result := 0;

     for I := 0 to ChildrsN-1 do
     begin
          C0 := Childrs[ I ];

          for K0 := 0 to 3 do
          begin
               C1 := C0.Cell[ K0 ];
               K1 := C0.Corn[ K0 ];

               if ( C1 = nil ) or ( C1 = C0 ) then begin  Inc( Result );  Continue;  end;

               // 相互接続（Cell / Corn / Bond の対称性）
               if ( C1.Cell[ K1 ] <> C0 ) or ( C1.Corn[ K1 ] <> K0 ) or ( C1.Bond[ K1 ] <> C0.Bond[ K0 ] ) then Inc( Result );

               // 共有面の頂点の同一性（Join による対応）
               for F := 1 to 3 do
               begin
                    if C1.Poin[ C0.Join[ K0, F ] ] <> C0.Poin[ VertTable[ K0 ]._[ F ] ] then Inc( Result );
               end;
          end;
     end;
end;

//------------------------------------------------------------------------------

function TTetraCellSet<TPos_>.PoinCode( const Poin_:TPoin_ ) :Integer;
begin
     Result := -1;  // 集合に属さない点は、既定では nil として保存される
end;

function TTetraCellSet<TPos_>.CodePoin( const Code_:Integer ) :TPoin_;
begin
     Result := nil;  // 負の符号は、既定では nil として復元される
end;

function TTetraCellSet<TPos_>.LoadCell :TCell_;
begin
     Result := TCell_.Create( Self );
end;

//------------------------------------------------------------------------------

procedure TTetraCellSet<TPos_>.SaveToFile( const FileName_:String );
// LUXOPHIA コンテナ形式（LUX.Data 参照）。点は座標のみ（アンカーは導出情報なので保存しない）、
// 胞は「頂点番号 ×4 ＋ 隣接胞番号 ×4 ＋ 角・回転・旗（_Corn / _Bond / _Flag）」で、接続構造がそのまま往復する
var
   S :TFileStream;
   I, C :Integer;
   K :Byte;
   T :TCell_;
   P :TPoin_;
   D :Byte;
begin
     S := TFileStream.Create( FileName_, fmCreate );
     try
        WriteHead( S, 'LUXOPHIA TetFlip 1.0', [ 'PoinsN='  + IntToStr( PoinSet.ChildrsN ),
                                                'CellsN='  + IntToStr( ChildrsN         ),
                                                'PosSize=' + IntToStr( SizeOf( TPos_ )  ) ] );

        PoinSet.SaveToStream( S );

        for I := 0 to ChildrsN-1 do
        begin
             T := Childrs[ I ];

             for K := 0 to 3 do  // 点 → 番号（集合の中 = 添字、外 = 負の符号）
             begin
                  P := T._Poin[ K ];

                  if      P = nil            then C := -1
                  else if P.Parent = PoinSet then C := P.Order
                                             else C := PoinCode( P );

                  S.WriteBuffer( C, 4 );
             end;

             for K := 0 to 3 do
             begin
                  if T._Cell[ K ] = nil then C := -1
                                        else C := T._Cell[ K ].Order;

                  S.WriteBuffer( C, 4 );
             end;

             D := T._Corn;  S.WriteBuffer( D, 1 );
             D := T._Bond;  S.WriteBuffer( D, 1 );
             D := T._Flag;  S.WriteBuffer( D, 1 );
        end;
     finally
        S.Free;
     end;
end;

procedure TTetraCellSet<TPos_>.LoadFromFile( const FileName_:String );
var
   S :TFileStream;
   PoinsN, CellsN, PosSize :Integer;
   I, C, E :Integer;
   K :Byte;
   T :TCell_;
   P :TPoin_;
   D :Byte;
   L, N :String;
begin
     S := TFileStream.Create( FileName_, fmOpenRead or fmShareDenyWrite );
     try
        PoinsN  := -1;
        CellsN  := -1;
        PosSize := SizeOf( TPos_ );

        for L in ReadHead( S, 'LUXOPHIA TetFlip 1.0' ) do  // オプション行（名前=値）
        begin
             E := Pos( '=', L );

             if E <= 0 then Continue;  // 知らない行は読み飛ばす

             N := Copy( L, 1, E-1 );

             if N = 'PoinsN'  then PoinsN  := StrToIntDef( Copy( L, E+1, MaxInt ), -1 ) else
             if N = 'CellsN'  then CellsN  := StrToIntDef( Copy( L, E+1, MaxInt ), -1 ) else
             if N = 'PosSize' then PosSize := StrToIntDef( Copy( L, E+1, MaxInt ), -1 );
        end;

        if ( PoinsN < 0 ) or ( CellsN < 0 ) then raise EInOutError.Create( 'TTetraCellSet.LoadFromFile: PoinsN / CellsN が無い: ' + FileName_ );

        if PosSize <> SizeOf( TPos_ ) then raise EInOutError.Create( 'TTetraCellSet.LoadFromFile: 座標の型が合わない: ' + FileName_ );

        Clear;  // 胞 → 点の順で全て置き換える（胞の破棄は頂点のアンカーに触れる）

        PoinSet.LoadFromStream( S, PoinsN );

        for I := 1 to CellsN do LoadCell;  // 生成順 = 保存順 = 胞の番号

        for I := 0 to CellsN-1 do
        begin
             T := Childrs[ I ];

             for K := 0 to 3 do
             begin
                  S.ReadBuffer( C, 4 );

                  if C >= PoinsN then raise EInOutError.Create( 'TTetraCellSet.LoadFromFile: 頂点番号が壊れている: ' + FileName_ );

                  if C >= 0 then T._Poin[ K ] := PoinSet[ C ]
                            else T._Poin[ K ] := CodePoin( C );
             end;

             for K := 0 to 3 do
             begin
                  S.ReadBuffer( C, 4 );

                  if C >= CellsN then raise EInOutError.Create( 'TTetraCellSet.LoadFromFile: 隣接胞番号が壊れている: ' + FileName_ );

                  if C >= 0 then T._Cell[ K ] := Childrs[ C ]
                            else T._Cell[ K ] := nil;
             end;

             S.ReadBuffer( D, 1 );  T._Corn := D;
             S.ReadBuffer( D, 1 );  T._Bond := D;
             S.ReadBuffer( D, 1 );  T._Flag := D;
        end;

        for I := 0 to CellsN-1 do  // アンカー（導出情報）を張り直す
        begin
             T := Childrs[ I ];

             for K := 0 to 3 do
             begin
                  P := T._Poin[ K ];

                  if Assigned( P ) then begin  P._Cell := T;  P._Corn := K;  end;
             end;
        end;
     finally
        S.Free;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
