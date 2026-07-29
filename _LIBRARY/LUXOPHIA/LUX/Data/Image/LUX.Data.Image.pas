unit LUX.Data.Image;

interface //#################################################################### ■

{$POINTERMATH ON}

uses System.Classes, System.SysUtils, System.Threading,
     LUX, LUX.D1.Half, LUX.Color, LUX.Color.Half;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxPixel

     TLuxPixel = ( bpUInt08,    // TByteRGBA    ： 8bit 符号無整数 ×4
                   bpUInt16,    // TWordRGBA    ：16bit 符号無整数 ×4
                   bpSFlo16,    // THalfRGBA    ：16bit 符号付浮動小数 ×4
                   bpSFlo32 );  // TSingleRGBA  ：32bit 符号付浮動小数 ×4

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxLevel

     TLuxLevel = record
     public
       Width  :Integer;              // この段の画素数（横）
       Height :Integer;              // この段の画素数（縦）
       TilesX :Integer;              // この段のタイル数（横）
       TilesY :Integer;              // この段のタイル数（縦）
       Tiles  :TArray<TArray<Byte>>; // TilesY * TilesX 個。未確保のタイルは長さ 0
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImage

     ///// 超高解像度画像の基底クラス
     ///// ・画素は LUXIMAGE_TILE 角のタイルに分割して保持する（巨大な連続確保を避けるため）
     ///// ・縮小ピラミッド（ミップマップ）を段として保持し、必要な段だけ遅延生成する
     ///// ・GPU を一切前提としないので、CPU メモリの許す限りの大きさを扱える

     TLuxImage = class
     private
       ///// A C C E S S O R
       function GetLevelsN :Integer;
       function GetColors( const X_,Y_:Integer ) :TSingleRGBA;
       procedure SetColors( const X_,Y_:Integer; const C_:TSingleRGBA );
     protected
       _Width   :Integer;
       _Height  :Integer;
       _Levels  :TArray<TLuxLevel>;
       _LevelUp :TArray<Boolean>;   // 段が最新なら True（段 0 は常に True）
       _Version :Cardinal;
       ///// 非同期
       _Task     :ITask;
       _Busy     :Boolean;
       _Closing  :Boolean;
       _Progress :Single;
       _Fired    :Single;   // 直前に通知した進捗（間引き用）
       _ProgA    :Single;   // DoProgress の 0 が対応する全体進捗
       _ProgB    :Single;   // DoProgress の 1 が対応する全体進捗
       ///// E V E N T
       _OnChange   :TDelegates;
       _OnProgress :TDelegates;
       _OnLoaded   :TDelegates;
       _OnSaved    :TDelegates;
       ///// M E T H O D
       procedure InitLevels;
       procedure StartAsync( const Work_:TProc; const Saving_:Boolean );
       procedure ProgRange( const A_,B_:Single );  // 以降の DoProgress を全体の A_〜B_ に割り当てる
       procedure DoChange;                         // 段を無効化せずに変更だけ通知する
     public
       constructor Create; overload;
       constructor Create( const W_,H_:Integer ); overload;
       destructor Destroy; override;
       ///// C L A S S
       class function PixelKind :TLuxPixel; virtual; abstract;   // 画素形式
       class function PixelSize :Integer; virtual; abstract;     // １画素のバイト数
       class function IsFloat :Boolean; virtual;                 // 浮動小数形式か
       class function DefaultGamma :Single; virtual;             // 表示ガンマの既定値
       ///// P R O P E R T Y
       property Width                       :Integer      read _Width           ;
       property Height                      :Integer      read _Height          ;
       property LevelsN                     :Integer      read GetLevelsN       ;
       property Version                     :Cardinal     read _Version         ;  // 内容の版（変わったら表示側の資源を破棄する）
       property Busy                        :Boolean      read _Busy            ;  // 非同期の読み書きが進行中
       property Progress                    :Single       read _Progress        ;  // 0 〜 1
       property Colors[ const X_,Y_:Integer ] :TSingleRGBA read GetColors write SetColors; default;
       ///// M E T H O D
       procedure SetSize( const W_,H_:Integer );
       procedure Clear;
       procedure Changed;
       /////
       function LevelWidth ( const L_:Integer ) :Integer;
       function LevelHeight( const L_:Integer ) :Integer;
       function LevelTilesX( const L_:Integer ) :Integer;
       function LevelTilesY( const L_:Integer ) :Integer;
       function TileWidth  ( const L_,TX_:Integer ) :Integer;
       function TileHeight ( const L_,TY_:Integer ) :Integer;
       /////
       function TileData( const L_,TX_,TY_:Integer ) :Pointer;  // タイルの先頭（未確保なら確保して 0 埋め）
       function TilePeek( const L_,TX_,TY_:Integer ) :Pointer;  // タイルの先頭（未確保なら nil）
       /////
       procedure GetRaws( const L_,X_,Y_,N_:Integer; const Dst_:Pointer );  // 生画素を N_ 個読む（タイル跨ぎ対応）
       procedure SetRaws( const L_,X_,Y_,N_:Integer; const Src_:Pointer );  // 生画素を N_ 個書く（タイル跨ぎ対応）
       /////
       procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA ); virtual; abstract;  // 書式非依存の行読み
       procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA ); virtual; abstract;  // 書式非依存の行書き
       procedure MakeTileMip( const L_,TX_,TY_:Integer ); virtual; abstract;  // 段 L_-1 から段 L_ のタイルを作る
       procedure GetMipRows( const L_,TX_,TY_,Y_:Integer; const Row0_,Row1_:Pointer; out N_:Integer );
       /////
       procedure NeedLevel( const L_:Integer );  // 段 L_ までを最新にする
       /////
       procedure LoadFromFile( const FileName_:String );
       procedure SaveToFile( const FileName_:String; const Quality_:Integer = 90 );
       /////
       procedure LoadFromFileAsync( const FileName_:String );                            // 別スレッドで読む
       procedure SaveToFileAsync( const FileName_:String; const Quality_:Integer = 90 );  // 別スレッドで書く
       procedure WaitFor;                                                                 // 非同期処理の完了を待つ
       procedure DoProgress( const Ratio_:Single );                                       // 入出力側から進捗を報せる
       ///// E V E N T
       property OnChange   :TDelegates read _OnChange  ;
       property OnProgress :TDelegates read _OnProgress;  // 進捗値は Progress を読む
       property OnLoaded   :TDelegates read _OnLoaded  ;
       property OnSaved    :TDelegates read _OnSaved   ;
     end;

     TLuxImageClass = class of TLuxImage;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageUInt08

     TLuxImageUInt08 = class( TLuxImage )
     private
       ///// A C C E S S O R
       function GetPixels( const X_,Y_:Integer ) :TByteRGBA;
       procedure SetPixels( const X_,Y_:Integer; const P_:TByteRGBA );
     protected
     public
       ///// C L A S S
       class function PixelKind :TLuxPixel; override;
       class function PixelSize :Integer; override;
       ///// P R O P E R T Y
       property Pixels[ const X_,Y_:Integer ] :TByteRGBA read GetPixels write SetPixels;
       ///// M E T H O D
       procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA ); override;
       procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA ); override;
       procedure MakeTileMip( const L_,TX_,TY_:Integer ); override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageUInt16

     TLuxImageUInt16 = class( TLuxImage )
     private
       ///// A C C E S S O R
       function GetPixels( const X_,Y_:Integer ) :TWordRGBA;
       procedure SetPixels( const X_,Y_:Integer; const P_:TWordRGBA );
     protected
     public
       ///// C L A S S
       class function PixelKind :TLuxPixel; override;
       class function PixelSize :Integer; override;
       ///// P R O P E R T Y
       property Pixels[ const X_,Y_:Integer ] :TWordRGBA read GetPixels write SetPixels;
       ///// M E T H O D
       procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA ); override;
       procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA ); override;
       procedure MakeTileMip( const L_,TX_,TY_:Integer ); override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageSFlo16

     TLuxImageSFlo16 = class( TLuxImage )
     private
       ///// A C C E S S O R
       function GetPixels( const X_,Y_:Integer ) :THalfRGBA;
       procedure SetPixels( const X_,Y_:Integer; const P_:THalfRGBA );
     protected
     public
       ///// C L A S S
       class function PixelKind :TLuxPixel; override;
       class function PixelSize :Integer; override;
       class function IsFloat :Boolean; override;
       class function DefaultGamma :Single; override;
       ///// P R O P E R T Y
       property Pixels[ const X_,Y_:Integer ] :THalfRGBA read GetPixels write SetPixels;
       ///// M E T H O D
       procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA ); override;
       procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA ); override;
       procedure MakeTileMip( const L_,TX_,TY_:Integer ); override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageSFlo32

     TLuxImageSFlo32 = class( TLuxImage )
     private
       ///// A C C E S S O R
       function GetPixels( const X_,Y_:Integer ) :TSingleRGBA;
       procedure SetPixels( const X_,Y_:Integer; const P_:TSingleRGBA );
     protected
     public
       ///// C L A S S
       class function PixelKind :TLuxPixel; override;
       class function PixelSize :Integer; override;
       class function IsFloat :Boolean; override;
       class function DefaultGamma :Single; override;
       ///// P R O P E R T Y
       property Pixels[ const X_,Y_:Integer ] :TSingleRGBA read GetPixels write SetPixels;
       ///// M E T H O D
       procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA ); override;
       procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA ); override;
       procedure MakeTileMip( const L_,TX_,TY_:Integer ); override;
     end;

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LUXIMAGE_TILE

      LUXIMAGE_TILE = 256;  // タイルの一辺（２の冪であること）

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function LuxImageClass( const Kind_:TLuxPixel ) :TLuxImageClass;  // 画素形式に対応するクラス

implementation //############################################################### ■

uses System.Math,
     LUX.Data.Image.Files;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImage

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TLuxImage.GetLevelsN :Integer;
begin
     Result := Length( _Levels );
end;

//------------------------------------------------------------------------------

function TLuxImage.GetColors( const X_,Y_:Integer ) :TSingleRGBA;
begin
     GetRow( 0, X_, Y_, 1, @Result );
end;

procedure TLuxImage.SetColors( const X_,Y_:Integer; const C_:TSingleRGBA );
begin
     SetRow( 0, X_, Y_, 1, @C_ );  Changed;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImage.InitLevels;
var
   W, H, N :Integer;
begin
     _Levels  := nil;
     _LevelUp := nil;

     if ( _Width < 1 ) or ( _Height < 1 ) then Exit;

     W := _Width;  H := _Height;  N := 0;

     repeat
           SetLength( _Levels , N+1 );
           SetLength( _LevelUp, N+1 );

           with _Levels[ N ] do
           begin
                Width  := W;
                Height := H;
                TilesX := ( W + LUXIMAGE_TILE - 1 ) div LUXIMAGE_TILE;
                TilesY := ( H + LUXIMAGE_TILE - 1 ) div LUXIMAGE_TILE;

                SetLength( Tiles, TilesX * TilesY );
           end;

           _LevelUp[ N ] := ( N = 0 );

           if ( W = 1 ) and ( H = 1 ) then Break;

           W := Max( 1, ( W + 1 ) div 2 );
           H := Max( 1, ( H + 1 ) div 2 );

           Inc( N );
     until False;
end;

//------------------------------------------------------------------------------

procedure TLuxImage.StartAsync( const Work_:TProc; const Saving_:Boolean );
begin
     if _Busy then raise EInvalidOpException.Create( '前の非同期処理がまだ終わっていない' );

     _Busy     := True;
     _Progress := 0;
     _Fired    := -1;

     ProgRange( 0, 1 );

     _Task := TTask.Run( procedure
                         var
                            M :String;
                         begin
                              M := '';

                              try
                                   Work_;
                              except
                                   on X:Exception do M := X.ClassName + ' ： ' + X.Message;
                              end;

                              TThread.Queue( nil, procedure
                                                  begin
                                                       _Busy     := False;
                                                       _Progress := 1;

                                                       if _Closing then Exit;  // 破棄中なら何も通知しない

                                                       if M <> '' then raise EInOutError.Create( M );

                                                       if not Saving_ then DoChange;  // 段は作業スレッドで作り終えているので無効化しない

                                                       if Saving_ then _OnSaved .Run( Self )
                                                                  else _OnLoaded.Run( Self );
                                                  end );
                         end );
end;

//------------------------------------------------------------------------------

procedure TLuxImage.ProgRange( const A_,B_:Single );
begin
     _ProgA := A_;
     _ProgB := B_;
end;

procedure TLuxImage.DoChange;
begin
     Inc( _Version );

     ///// 別スレッドからの通知はメインスレッドへ回す

     if TThread.CurrentThread.ThreadID = MainThreadID then _OnChange.Run( Self )
     else TThread.Queue( nil, procedure
                              begin
                                   if not _Closing then _OnChange.Run( Self );
                              end );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TLuxImage.Create;
begin
     inherited;

     _Width    := 0;
     _Height   := 0;
     _Version  := 0;
     _Busy     := False;
     _Closing  := False;
     _Progress := 0;
     _Fired    := -1;
     _ProgA    := 0;
     _ProgB    := 1;
end;

constructor TLuxImage.Create( const W_,H_:Integer );
begin
     Create;

     SetSize( W_, H_ );
end;

destructor TLuxImage.Destroy;
begin
     _Closing := True;

     WaitFor;

     inherited;
end;

//////////////////////////////////////////////////////////////////////// C L A S S

class function TLuxImage.IsFloat :Boolean;
begin
     Result := False;
end;

class function TLuxImage.DefaultGamma :Single;
begin
     Result := 1;  // 整数形式は既に表示用に符号化されているとみなす
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImage.SetSize( const W_,H_:Integer );
begin
     if ( _Width = W_ ) and ( _Height = H_ ) then
     begin
          Clear;  Exit;
     end;

     if ( W_ < 0 ) or ( H_ < 0 ) then raise EArgumentException.Create( '画像サイズが負である' );

     _Width  := W_;
     _Height := H_;

     InitLevels;

     Changed;
end;

procedure TLuxImage.Clear;
var
   L, I :Integer;
begin
     for L := 0 to LevelsN-1 do
     begin
          for I := 0 to High( _Levels[ L ].Tiles ) do _Levels[ L ].Tiles[ I ] := nil;

          _LevelUp[ L ] := ( L = 0 );
     end;

     Changed;
end;

procedure TLuxImage.Changed;
var
   L :Integer;
begin
     for L := 1 to LevelsN-1 do _LevelUp[ L ] := False;

     DoChange;
end;

//------------------------------------------------------------------------------

function TLuxImage.LevelWidth( const L_:Integer ) :Integer;
begin
     Result := _Levels[ L_ ].Width;
end;

function TLuxImage.LevelHeight( const L_:Integer ) :Integer;
begin
     Result := _Levels[ L_ ].Height;
end;

function TLuxImage.LevelTilesX( const L_:Integer ) :Integer;
begin
     Result := _Levels[ L_ ].TilesX;
end;

function TLuxImage.LevelTilesY( const L_:Integer ) :Integer;
begin
     Result := _Levels[ L_ ].TilesY;
end;

function TLuxImage.TileWidth( const L_,TX_:Integer ) :Integer;
begin
     Result := Min( LUXIMAGE_TILE, _Levels[ L_ ].Width - TX_ * LUXIMAGE_TILE );
end;

function TLuxImage.TileHeight( const L_,TY_:Integer ) :Integer;
begin
     Result := Min( LUXIMAGE_TILE, _Levels[ L_ ].Height - TY_ * LUXIMAGE_TILE );
end;

//------------------------------------------------------------------------------

function TLuxImage.TileData( const L_,TX_,TY_:Integer ) :Pointer;
var
   I :Integer;
begin
     with _Levels[ L_ ] do
     begin
          I := TY_ * TilesX + TX_;

          if Tiles[ I ] = nil then SetLength( Tiles[ I ], LUXIMAGE_TILE * LUXIMAGE_TILE * PixelSize );  // 動的配列は 0 埋めされる

          Result := @Tiles[ I, 0 ];
     end;
end;

function TLuxImage.TilePeek( const L_,TX_,TY_:Integer ) :Pointer;
var
   I :Integer;
begin
     with _Levels[ L_ ] do
     begin
          I := TY_ * TilesX + TX_;

          if Tiles[ I ] = nil then Exit( nil );

          Result := @Tiles[ I, 0 ];
     end;
end;

//------------------------------------------------------------------------------

procedure TLuxImage.GetRaws( const L_,X_,Y_,N_:Integer; const Dst_:Pointer );
var
   S, I, C, TX, PX, TY, PY :Integer;
   D, T                    :PByte;
begin
     S := PixelSize;
     D := Dst_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TilePeek( L_, TX, TY );

          if Assigned( T ) then Move( ( T + ( PY * LUXIMAGE_TILE + PX ) * S )^, D^, C * S )
                           else FillChar( D^, C * S, 0 );

          Inc( D, C * S );
          Inc( I, C );
     end;
end;

procedure TLuxImage.SetRaws( const L_,X_,Y_,N_:Integer; const Src_:Pointer );
var
   Z, I, C, TX, PX, TY, PY :Integer;
   S, T                    :PByte;
begin
     Z := PixelSize;
     S := Src_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TileData( L_, TX, TY );

          Move( S^, ( T + ( PY * LUXIMAGE_TILE + PX ) * Z )^, C * Z );

          Inc( S, C * Z );
          Inc( I, C );
     end;
end;

//------------------------------------------------------------------------------

procedure TLuxImage.GetMipRows( const L_,TX_,TY_,Y_:Integer; const Row0_,Row1_:Pointer; out N_:Integer );
var
   W, H, X, Y :Integer;
begin
     W := _Levels[ L_-1 ].Width;
     H := _Levels[ L_-1 ].Height;

     X := ( TX_ * LUXIMAGE_TILE     ) * 2;
     Y := ( TY_ * LUXIMAGE_TILE + Y_ ) * 2;

     N_ := Min( LUXIMAGE_TILE * 2, W - X );

     GetRaws( L_-1, X, Y, N_, Row0_ );

     if Y + 1 < H then GetRaws( L_-1, X, Y+1, N_, Row1_ )
                  else Move( Row0_^, Row1_^, N_ * PixelSize );
end;

//------------------------------------------------------------------------------

procedure TLuxImage.NeedLevel( const L_:Integer );
const
      CHUNK = 8;  // 一度に並列処理するタイル行数
var
   L, LL, NX, TY, Y0, Y1, N, I :Integer;
begin
     ///// 作る必要のあるタイル行の総数（進捗の分母）

     N := 0;

     for L := 1 to Min( L_, LevelsN-1 ) do
       if not _LevelUp[ L ] then Inc( N, _Levels[ L ].TilesY );

     if N = 0 then Exit;

     I := 0;

     for L := 1 to Min( L_, LevelsN-1 ) do
     begin
          if _LevelUp[ L ] then Continue;

          LL := L;                        // 無名メソッドは for の制御変数を捕捉できない
          NX := _Levels[ L ].TilesX;

          TY := 0;

          while TY < _Levels[ L ].TilesY do
          begin
               Y0 := TY;
               Y1 := Min( Y0 + CHUNK, _Levels[ L ].TilesY ) - 1;

               ///// 段内のタイルは互いに独立（各自のタイルだけを書き、下の段は読むだけ）

               TParallel.For( Y0, Y1, procedure( Y:Integer )
                                      var
                                         TX :Integer;
                                      begin
                                           for TX := 0 to NX-1 do MakeTileMip( LL, TX, Y );
                                      end );

               Inc( I, Y1 - Y0 + 1 );

               TY := Y1 + 1;

               if _Busy then DoProgress( I / N );  // 非同期処理中のみ（描画中の再入を避ける）
          end;

          _LevelUp[ L ] := True;
     end;
end;

//------------------------------------------------------------------------------

procedure TLuxImage.LoadFromFile( const FileName_:String );
begin
     _Progress := 0;  _Fired := -1;

     TLuxImageFiler.LoadFromFile( Self, FileName_ );

     DoProgress( 1 );
end;

procedure TLuxImage.SaveToFile( const FileName_:String; const Quality_:Integer = 90 );
begin
     _Progress := 0;  _Fired := -1;

     TLuxImageFiler.SaveToFile( Self, FileName_, Quality_ );

     DoProgress( 1 );
end;

//------------------------------------------------------------------------------

procedure TLuxImage.LoadFromFileAsync( const FileName_:String );
var
   F :String;
begin
     F := FileName_;

     StartAsync( procedure
                 begin
                      ProgRange( 0, 0.75 );  TLuxImageFiler.LoadFromFile( Self, F );

                      ///// 表示に要る縮小段も、ここで作り終えてしまう。
                      ///// 最初の描画時に作ると、その分だけ UI が止まってしまうため。

                      ProgRange( 0.75, 1 );  NeedLevel( LevelsN - 1 );

                      ProgRange( 0, 1 );
                 end, False );
end;

procedure TLuxImage.SaveToFileAsync( const FileName_:String; const Quality_:Integer = 90 );
var
   F :String;
   Q :Integer;
begin
     F := FileName_;  Q := Quality_;

     StartAsync( procedure
                 begin
                      TLuxImageFiler.SaveToFile( Self, F, Q );
                 end, True );
end;

procedure TLuxImage.WaitFor;
begin
     if Assigned( _Task ) then
     begin
          _Task.Wait;  _Task := nil;
     end;

     ///// 保留中の通知を、まだ自分が生きているうちに流し切る

     if TThread.CurrentThread.ThreadID = MainThreadID then CheckSynchronize;
end;

procedure TLuxImage.DoProgress( const Ratio_:Single );
begin
     _Progress := _ProgA + ( _ProgB - _ProgA ) * Clamp( Ratio_, 0, 1 );

     if Abs( _Progress - _Fired ) < 0.01 then Exit;  // 1% 刻みに間引く

     _Fired := _Progress;

     if TThread.CurrentThread.ThreadID = MainThreadID then _OnProgress.Run( Self )
     else TThread.Queue( nil, procedure
                              begin
                                   if not _Closing then _OnProgress.Run( Self );
                              end );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageUInt08

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TLuxImageUInt08.GetPixels( const X_,Y_:Integer ) :TByteRGBA;
begin
     GetRaws( 0, X_, Y_, 1, @Result );
end;

procedure TLuxImageUInt08.SetPixels( const X_,Y_:Integer; const P_:TByteRGBA );
begin
     SetRaws( 0, X_, Y_, 1, @P_ );  Changed;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////////// C L A S S

class function TLuxImageUInt08.PixelKind :TLuxPixel;
begin
     Result := bpUInt08;
end;

class function TLuxImageUInt08.PixelSize :Integer;
begin
     Result := SizeOf( TByteRGBA );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImageUInt08.GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA );
var
   I, C, J, TX, PX, TY, PY :Integer;
   T                       :PByteRGBA;
   D                       :PSingleRGBA;
begin
     D := Dst_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TilePeek( L_, TX, TY );

          if Assigned( T ) then
          begin
               Inc( T, PY * LUXIMAGE_TILE + PX );

               for J := 1 to C do
               begin
                    D^ := T^;  Inc( D );  Inc( T );
               end;
          end
          else
          begin
               FillChar( D^, C * SizeOf( TSingleRGBA ), 0 );  Inc( D, C );
          end;

          Inc( I, C );
     end;
end;

procedure TLuxImageUInt08.SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA );
var
   I, C, J, TX, PX, TY, PY :Integer;
   T                       :PByteRGBA;
   S                       :PSingleRGBA;
begin
     S := Src_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TileData( L_, TX, TY );  Inc( T, PY * LUXIMAGE_TILE + PX );

          for J := 1 to C do
          begin
               T^ := TByteRGBA( S^ );  Inc( S );  Inc( T );
          end;

          Inc( I, C );
     end;
end;

procedure TLuxImageUInt08.MakeTileMip( const L_,TX_,TY_:Integer );
var
   R0, R1  :TArray<TByteRGBA>;
   D       :PByteRGBA;
   TW, TH  :Integer;
   X, Y, N :Integer;
   I0, I1  :Integer;
begin
     TW := TileWidth ( L_, TX_ );
     TH := TileHeight( L_, TY_ );

     if ( TW < 1 ) or ( TH < 1 ) then Exit;

     SetLength( R0, LUXIMAGE_TILE * 2 );
     SetLength( R1, LUXIMAGE_TILE * 2 );

     D := TileData( L_, TX_, TY_ );

     for Y := 0 to TH-1 do
     begin
          GetMipRows( L_, TX_, TY_, Y, @R0[ 0 ], @R1[ 0 ], N );

          for X := 0 to TW-1 do
          begin
               I0 := X * 2;
               I1 := I0 + 1;  if I1 >= N then I1 := I0;

               with D[ Y * LUXIMAGE_TILE + X ] do
               begin
                    R := ( R0[I0].R + R0[I1].R + R1[I0].R + R1[I1].R + 2 ) div 4;
                    G := ( R0[I0].G + R0[I1].G + R1[I0].G + R1[I1].G + 2 ) div 4;
                    B := ( R0[I0].B + R0[I1].B + R1[I0].B + R1[I1].B + 2 ) div 4;
                    A := ( R0[I0].A + R0[I1].A + R1[I0].A + R1[I1].A + 2 ) div 4;
               end;
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageUInt16

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TLuxImageUInt16.GetPixels( const X_,Y_:Integer ) :TWordRGBA;
begin
     GetRaws( 0, X_, Y_, 1, @Result );
end;

procedure TLuxImageUInt16.SetPixels( const X_,Y_:Integer; const P_:TWordRGBA );
begin
     SetRaws( 0, X_, Y_, 1, @P_ );  Changed;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////////// C L A S S

class function TLuxImageUInt16.PixelKind :TLuxPixel;
begin
     Result := bpUInt16;
end;

class function TLuxImageUInt16.PixelSize :Integer;
begin
     Result := SizeOf( TWordRGBA );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImageUInt16.GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA );
var
   I, C, J, TX, PX, TY, PY :Integer;
   T                       :PWordRGBA;
   D                       :PSingleRGBA;
begin
     D := Dst_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TilePeek( L_, TX, TY );

          if Assigned( T ) then
          begin
               Inc( T, PY * LUXIMAGE_TILE + PX );

               for J := 1 to C do
               begin
                    D^ := T^;  Inc( D );  Inc( T );
               end;
          end
          else
          begin
               FillChar( D^, C * SizeOf( TSingleRGBA ), 0 );  Inc( D, C );
          end;

          Inc( I, C );
     end;
end;

procedure TLuxImageUInt16.SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA );
var
   I, C, J, TX, PX, TY, PY :Integer;
   T                       :PWordRGBA;
   S                       :PSingleRGBA;
begin
     S := Src_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TileData( L_, TX, TY );  Inc( T, PY * LUXIMAGE_TILE + PX );

          for J := 1 to C do
          begin
               T^ := S^;  Inc( S );  Inc( T );
          end;

          Inc( I, C );
     end;
end;

procedure TLuxImageUInt16.MakeTileMip( const L_,TX_,TY_:Integer );
var
   R0, R1  :TArray<TWordRGBA>;
   D       :PWordRGBA;
   TW, TH  :Integer;
   X, Y, N :Integer;
   I0, I1  :Integer;
begin
     TW := TileWidth ( L_, TX_ );
     TH := TileHeight( L_, TY_ );

     if ( TW < 1 ) or ( TH < 1 ) then Exit;

     SetLength( R0, LUXIMAGE_TILE * 2 );
     SetLength( R1, LUXIMAGE_TILE * 2 );

     D := TileData( L_, TX_, TY_ );

     for Y := 0 to TH-1 do
     begin
          GetMipRows( L_, TX_, TY_, Y, @R0[ 0 ], @R1[ 0 ], N );

          for X := 0 to TW-1 do
          begin
               I0 := X * 2;
               I1 := I0 + 1;  if I1 >= N then I1 := I0;

               with D[ Y * LUXIMAGE_TILE + X ] do
               begin
                    R := ( Cardinal( R0[I0].R ) + R0[I1].R + R1[I0].R + R1[I1].R + 2 ) div 4;
                    G := ( Cardinal( R0[I0].G ) + R0[I1].G + R1[I0].G + R1[I1].G + 2 ) div 4;
                    B := ( Cardinal( R0[I0].B ) + R0[I1].B + R1[I0].B + R1[I1].B + 2 ) div 4;
                    A := ( Cardinal( R0[I0].A ) + R0[I1].A + R1[I0].A + R1[I1].A + 2 ) div 4;
               end;
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageSFlo16

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TLuxImageSFlo16.GetPixels( const X_,Y_:Integer ) :THalfRGBA;
begin
     GetRaws( 0, X_, Y_, 1, @Result );
end;

procedure TLuxImageSFlo16.SetPixels( const X_,Y_:Integer; const P_:THalfRGBA );
begin
     SetRaws( 0, X_, Y_, 1, @P_ );  Changed;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////////// C L A S S

class function TLuxImageSFlo16.PixelKind :TLuxPixel;
begin
     Result := bpSFlo16;
end;

class function TLuxImageSFlo16.PixelSize :Integer;
begin
     Result := SizeOf( THalfRGBA );
end;

class function TLuxImageSFlo16.IsFloat :Boolean;
begin
     Result := True;
end;

class function TLuxImageSFlo16.DefaultGamma :Single;
begin
     Result := 2.2;  // 浮動小数形式はリニアとみなす
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImageSFlo16.GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA );
var
   I, C, J, TX, PX, TY, PY :Integer;
   T                       :PHalfRGBA;
   D                       :PSingleRGBA;
begin
     D := Dst_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TilePeek( L_, TX, TY );

          if Assigned( T ) then
          begin
               Inc( T, PY * LUXIMAGE_TILE + PX );

               for J := 1 to C do
               begin
                    D^ := T^;  Inc( D );  Inc( T );
               end;
          end
          else
          begin
               FillChar( D^, C * SizeOf( TSingleRGBA ), 0 );  Inc( D, C );
          end;

          Inc( I, C );
     end;
end;

procedure TLuxImageSFlo16.SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA );
var
   I, C, J, TX, PX, TY, PY :Integer;
   T                       :PHalfRGBA;
   S                       :PSingleRGBA;
begin
     S := Src_;

     TY := Y_ div LUXIMAGE_TILE;
     PY := Y_ mod LUXIMAGE_TILE;

     I := 0;

     while I < N_ do
     begin
          TX := ( X_ + I ) div LUXIMAGE_TILE;
          PX := ( X_ + I ) mod LUXIMAGE_TILE;

          C := Min( LUXIMAGE_TILE - PX, N_ - I );

          T := TileData( L_, TX, TY );  Inc( T, PY * LUXIMAGE_TILE + PX );

          for J := 1 to C do
          begin
               T^ := S^;  Inc( S );  Inc( T );
          end;

          Inc( I, C );
     end;
end;

procedure TLuxImageSFlo16.MakeTileMip( const L_,TX_,TY_:Integer );
var
   R0, R1  :TArray<THalfRGBA>;
   D       :PHalfRGBA;
   TW, TH  :Integer;
   X, Y, N :Integer;
   I0, I1  :Integer;
begin
     TW := TileWidth ( L_, TX_ );
     TH := TileHeight( L_, TY_ );

     if ( TW < 1 ) or ( TH < 1 ) then Exit;

     SetLength( R0, LUXIMAGE_TILE * 2 );
     SetLength( R1, LUXIMAGE_TILE * 2 );

     D := TileData( L_, TX_, TY_ );

     for Y := 0 to TH-1 do
     begin
          GetMipRows( L_, TX_, TY_, Y, @R0[ 0 ], @R1[ 0 ], N );

          for X := 0 to TW-1 do
          begin
               I0 := X * 2;
               I1 := I0 + 1;  if I1 >= N then I1 := I0;

               with D[ Y * LUXIMAGE_TILE + X ] do
               begin
                    R := ( Single( R0[I0].R ) + Single( R0[I1].R ) + Single( R1[I0].R ) + Single( R1[I1].R ) ) / 4;
                    G := ( Single( R0[I0].G ) + Single( R0[I1].G ) + Single( R1[I0].G ) + Single( R1[I1].G ) ) / 4;
                    B := ( Single( R0[I0].B ) + Single( R0[I1].B ) + Single( R1[I0].B ) + Single( R1[I1].B ) ) / 4;
                    A := ( Single( R0[I0].A ) + Single( R0[I1].A ) + Single( R1[I0].A ) + Single( R1[I1].A ) ) / 4;
               end;
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageSFlo32

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TLuxImageSFlo32.GetPixels( const X_,Y_:Integer ) :TSingleRGBA;
begin
     GetRaws( 0, X_, Y_, 1, @Result );
end;

procedure TLuxImageSFlo32.SetPixels( const X_,Y_:Integer; const P_:TSingleRGBA );
begin
     SetRaws( 0, X_, Y_, 1, @P_ );  Changed;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////////// C L A S S

class function TLuxImageSFlo32.PixelKind :TLuxPixel;
begin
     Result := bpSFlo32;
end;

class function TLuxImageSFlo32.PixelSize :Integer;
begin
     Result := SizeOf( TSingleRGBA );
end;

class function TLuxImageSFlo32.IsFloat :Boolean;
begin
     Result := True;
end;

class function TLuxImageSFlo32.DefaultGamma :Single;
begin
     Result := 2.2;  // 浮動小数形式はリニアとみなす
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImageSFlo32.GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA );
begin
     GetRaws( L_, X_, Y_, N_, Dst_ );  // 記憶形式そのもの
end;

procedure TLuxImageSFlo32.SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA );
begin
     SetRaws( L_, X_, Y_, N_, Src_ );  // 記憶形式そのもの
end;

procedure TLuxImageSFlo32.MakeTileMip( const L_,TX_,TY_:Integer );
var
   R0, R1  :TArray<TSingleRGBA>;
   D       :PSingleRGBA;
   TW, TH  :Integer;
   X, Y, N :Integer;
   I0, I1  :Integer;
begin
     TW := TileWidth ( L_, TX_ );
     TH := TileHeight( L_, TY_ );

     if ( TW < 1 ) or ( TH < 1 ) then Exit;

     SetLength( R0, LUXIMAGE_TILE * 2 );
     SetLength( R1, LUXIMAGE_TILE * 2 );

     D := TileData( L_, TX_, TY_ );

     for Y := 0 to TH-1 do
     begin
          GetMipRows( L_, TX_, TY_, Y, @R0[ 0 ], @R1[ 0 ], N );

          for X := 0 to TW-1 do
          begin
               I0 := X * 2;
               I1 := I0 + 1;  if I1 >= N then I1 := I0;

               D[ Y * LUXIMAGE_TILE + X ] := ( R0[I0] + R0[I1] + R1[I0] + R1[I1] ) / 4;
          end;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LuxImageClass

function LuxImageClass( const Kind_:TLuxPixel ) :TLuxImageClass;
begin
     case Kind_ of
       bpUInt08: Result := TLuxImageUInt08;
       bpUInt16: Result := TLuxImageUInt16;
       bpSFlo16: Result := TLuxImageSFlo16;
       bpSFlo32: Result := TLuxImageSFlo32;
     else        Result := nil;
     end;
end;

end. //######################################################################### ■
