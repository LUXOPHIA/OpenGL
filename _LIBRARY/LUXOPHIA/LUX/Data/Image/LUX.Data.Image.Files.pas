unit LUX.Data.Image.Files;

interface //#################################################################### ■

{$POINTERMATH ON}

uses System.Classes,
     System.Skia,
     LUX.Data.Image;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageFiler

     ///// TLuxImage のファイル入出力
     ///// ・PNG は自前実装（行単位のストリーミング。8/16bit、サイズ制限は実質無し）
     ///// ・JPEG は Skia のコーデック（規格上 65,535 角まで。画像１枚分の連続バッファを一時的に要する）

     TLuxImageFiler = class
     private
     protected
     public
       ///// M E T H O D
       class procedure LoadFromFile( const Image_:TLuxImage; const FileName_:String );
       class procedure SaveToFile  ( const Image_:TLuxImage; const FileName_:String; const Quality_:Integer = 90 );
       ///// P N G
       class procedure LoadFromPng( const Image_:TLuxImage; const Stream_:TStream );
       class procedure SaveToPng  ( const Image_:TLuxImage; const Stream_:TStream );
       ///// J P E G
       class procedure LoadFromJpg( const Image_:TLuxImage; const FileName_:String );
       class procedure SaveToJpg  ( const Image_:TLuxImage; const FileName_:String; const Quality_:Integer );
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function LuxSkColorType( const Kind_:TLuxPixel ) :TSkColorType;  // 画素形式に対応する Skia のカラータイプ

function LuxImageSize( const FileName_:String; out Width_,Height_:Integer ) :Boolean;  // 画素を読まずに寸法だけ得る

implementation //############################################################### ■

uses System.SysUtils, System.Math, System.ZLib,
     LUX, LUX.Color;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPngHead

     ///// IHDR ＋ PLTE ＋ tRNS をまとめた、復号に必要な情報

     TPngHead = record
     public
       Width     :Integer;
       Height    :Integer;
       Depth     :Integer;   // 1 / 2 / 4 / 8 / 16
       Color     :Integer;   // 0=グレイ 2=RGB 3=パレット 4=グレイ+α 6=RGBA
       Interlace :Integer;   // 0=無し 1=Adam7
       Chans     :Integer;   // 標本の数／画素
       BitsPix   :Integer;   // ビット数／画素
       FiltBpp   :Integer;   // フィルタ用のバイト数／画素（最低 1 ）
       MaxVal    :Integer;   // ( 1 shl Depth ) - 1
       /////
       Pal       :array [ 0..255 ] of TSingleRGBA;  // カラータイプ 3 用（ tRNS 適用済み）
       PalN      :Integer;
       /////
       HasTrns   :Boolean;                          // カラータイプ 0 / 2 用の透明色
       Trns      :array [ 0..2 ] of Integer;        // 標本値そのもの（ Depth の単位）
       ///// M E T H O D
       function RowBytes( const W_:Integer ) :Integer;  // W_ 画素ぶんのバイト数
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPngIdatReader

     ///// 連続する IDAT チャンクの中身だけを繋げて読み出すストリーム

     TPngIdatReader = class( TStream )
     private
       _Stream :TStream;
       _Rest   :Integer;   // 現チャンクの残りバイト数
       _Pos    :Int64;     // 読み出した総バイト数（＝このストリーム上の位置）
       _Ended  :Boolean;
       ///// M E T H O D
       function NextChunk :Boolean;
     public
       constructor Create( const Stream_:TStream; const Rest_:Integer );
       ///// M E T H O D
       function Read( var Buffer; Count:Longint ) :Longint; override;
       function Write( const Buffer; Count:Longint ) :Longint; override;
       function Seek( const Offset:Int64; Origin:TSeekOrigin ) :Int64; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPngIdatWriter

     ///// 書き込まれたバイト列を IDAT チャンクに小分けして出力するストリーム

     TPngIdatWriter = class( TStream )
     private
       _Stream :TStream;
       _Buffer :TBytes;
       _Count  :Integer;
       _Pos    :Int64;     // 書き込んだ総バイト数（＝このストリーム上の位置）
     public
       constructor Create( const Stream_:TStream );
       destructor Destroy; override;
       ///// M E T H O D
       procedure Flush;
       function Read( var Buffer; Count:Longint ) :Longint; override;
       function Write( const Buffer; Count:Longint ) :Longint; override;
       function Seek( const Offset:Int64; Origin:TSeekOrigin ) :Int64; override;
     end;

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      PNG_SIGN :array [ 0..7 ] of Byte = ( $89, $50, $4E, $47, $0D, $0A, $1A, $0A );

      PNG_IDAT_MAX = 1 shl 20;  // IDAT チャンク１個の最大バイト数

      ///// Adam7 インターレースの７つのパス（開始位置と刻み）

      PNG_PASS_X0 :array [ 0..6 ] of Integer = ( 0, 4, 0, 2, 0, 1, 0 );
      PNG_PASS_Y0 :array [ 0..6 ] of Integer = ( 0, 0, 4, 0, 2, 0, 1 );
      PNG_PASS_DX :array [ 0..6 ] of Integer = ( 8, 8, 4, 4, 2, 2, 1 );
      PNG_PASS_DY :array [ 0..6 ] of Integer = ( 8, 8, 8, 4, 4, 2, 2 );

var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

    _CrcTab :array [ 0..255 ] of UInt32;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CRC-32

procedure InitCrcTab;
var
   I, J :Integer;
   C    :UInt32;
begin
     for I := 0 to 255 do
     begin
          C := I;

          for J := 1 to 8 do
          begin
               if ( C and 1 ) <> 0 then C := $EDB88320 xor ( C shr 1 )
                                   else C :=              ( C shr 1 );
          end;

          _CrcTab[ I ] := C;
     end;
end;

function UpdateCrc( const Crc_:UInt32; const Data_:PByte; const Size_:Integer ) :UInt32;
var
   I :Integer;
begin
     Result := Crc_;

     for I := 0 to Size_-1 do Result := _CrcTab[ ( Result xor Data_[ I ] ) and $FF ] xor ( Result shr 8 );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ビッグエンディアン

function SwapU32( const V_:UInt32 ) :UInt32; inline;
begin
     Result := ( V_ shr 24 ) or ( ( V_ shr 8 ) and $0000FF00 )
                              or ( ( V_ shl 8 ) and $00FF0000 ) or ( V_ shl 24 );
end;

function ReadU32( const Stream_:TStream ) :UInt32;
begin
     Stream_.ReadBuffer( Result, 4 );  Result := SwapU32( Result );
end;

function ReadU08( const Stream_:TStream ) :Byte;
begin
     Stream_.ReadBuffer( Result, 1 );
end;

procedure WriteU32( const Stream_:TStream; const V_:UInt32 );
var
   T :UInt32;
begin
     T := SwapU32( V_ );  Stream_.WriteBuffer( T, 4 );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PNG の復号

///// 1 / 2 / 4 / 8 / 16 ビットの標本を取り出す（ PNG は上位ビットから詰める）

function PngSample( const P_:PByte; const I_,Depth_:Integer ) :Integer; inline;
var
   B, S :Integer;
begin
     case Depth_ of
       16: Result := ( P_[ I_ * 2 ] shl 8 ) or P_[ I_ * 2 + 1 ];
        8: Result :=   P_[ I_ ];
     else
       B := ( I_ * Depth_ ) shr 3;                  // 何バイト目か
       S := 8 - Depth_ - ( ( I_ * Depth_ ) and 7 ); // そのバイト内で何ビット右へ寄せるか
       Result := ( P_[ B ] shr S ) and ( ( 1 shl Depth_ ) - 1 );
     end;
end;

///// 行フィルタを解除する（ Cur_ を書き換える。Prv_ は解除済みの前行）

procedure PngUnfilter( const Filt_:Byte; const Cur_,Prv_:PByte; const N_,Bpp_:Integer );
var
   I, A, B, C, P, PA, PB, PC :Integer;
begin
     case Filt_ of
       0: ;                                                                                  // None
       1: for I := Bpp_ to N_-1 do Cur_[ I ] := ( Cur_[ I ] + Cur_[ I - Bpp_ ] ) and $FF;     // Sub
       2: for I := 0    to N_-1 do Cur_[ I ] := ( Cur_[ I ] + Prv_[ I        ] ) and $FF;     // Up
       3: for I := 0    to N_-1 do                                                            // Average
          begin
               if I >= Bpp_ then A := Cur_[ I - Bpp_ ] else A := 0;

               Cur_[ I ] := ( Cur_[ I ] + ( A + Prv_[ I ] ) div 2 ) and $FF;
          end;
       4: for I := 0    to N_-1 do                                                            // Paeth
          begin
               if I >= Bpp_ then begin  A := Cur_[ I - Bpp_ ];  C := Prv_[ I - Bpp_ ];  end
                            else begin  A := 0               ;  C := 0               ;  end;

               B := Prv_[ I ];

               P := A + B - C;  PA := Abs( P - A );  PB := Abs( P - B );  PC := Abs( P - C );

               if ( PA <= PB ) and ( PA <= PC ) then P := A
                                                else if PB <= PC then P := B
                                                                 else P := C;

               Cur_[ I ] := ( Cur_[ I ] + P ) and $FF;
          end;
     else raise EInOutError.Create( 'PNG のフィルタ種別 ' + Filt_.ToString + ' が不正' );
     end;
end;

///// 解除済みの 1 行を色へ変換する（全ビット深度・全カラータイプ）

procedure PngRowToColors( const H_:TPngHead; const Raw_:PByte; const N_:Integer; const Dst_:PSingleRGBA );
var
   X, I, S :Integer;
   V       :array [ 0..3 ] of Integer;
   M       :Single;
begin
     M := 1 / H_.MaxVal;

     for X := 0 to N_-1 do
     begin
          if H_.Color = 3 then
          begin
               S := PngSample( Raw_, X, H_.Depth );

               if S < H_.PalN then Dst_[ X ] := H_.Pal[ S ]
                              else Dst_[ X ] := TSingleRGBA.Create( 0, 0, 0, 1 );  // 範囲外は黒

               Continue;
          end;

          for I := 0 to H_.Chans-1 do V[ I ] := PngSample( Raw_, X * H_.Chans + I, H_.Depth );

          case H_.Color of
            0: begin  // グレイ
                    Dst_[ X ] := TSingleRGBA.Create( V[0] * M, V[0] * M, V[0] * M, 1 );

                    if H_.HasTrns and ( V[0] = H_.Trns[0] ) then Dst_[ X ].A := 0;
               end;
            2: begin  // RGB
                    Dst_[ X ] := TSingleRGBA.Create( V[0] * M, V[1] * M, V[2] * M, 1 );

                    if H_.HasTrns and ( V[0] = H_.Trns[0] )
                                  and ( V[1] = H_.Trns[1] )
                                  and ( V[2] = H_.Trns[2] ) then Dst_[ X ].A := 0;
               end;
            4:      // グレイ ＋ α
                    Dst_[ X ] := TSingleRGBA.Create( V[0] * M, V[0] * M, V[0] * M, V[1] * M );
            6:      // RGBA
                    Dst_[ X ] := TSingleRGBA.Create( V[0] * M, V[1] * M, V[2] * M, V[3] * M );
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WriteChunk

procedure WriteChunk( const Stream_:TStream; const Kind_:array of Byte; const Data_:PByte; const Size_:Integer );
var
   C :UInt32;
begin
     WriteU32( Stream_, Size_ );

     Stream_.WriteBuffer( Kind_[ 0 ], 4 );

     if Size_ > 0 then Stream_.WriteBuffer( Data_^, Size_ );

     C := UpdateCrc( $FFFFFFFF, @Kind_[ 0 ], 4 );
     C := UpdateCrc( C, Data_, Size_ );

     WriteU32( Stream_, C xor $FFFFFFFF );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LuxSkColorType

function LuxSkColorType( const Kind_:TLuxPixel ) :TSkColorType;
begin
     case Kind_ of
       bpUInt08: Result := TSkColorType.BGRA8888;      // TByteRGBA   の記憶順は B,G,R,A
       bpUInt16: Result := TSkColorType.RGBA16161616;  // TWordRGBA
       bpSFlo16: Result := TSkColorType.RGBAF16;       // THalfRGBA
       bpSFlo32: Result := TSkColorType.RGBAF32;       // TSingleRGBA
     else        Result := TSkColorType.Unknown;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LuxImageSize

function LuxImageSize( const FileName_:String; out Width_,Height_:Integer ) :Boolean;
var
   E :String;
   S :TFileStream;
   B :array [ 0..7 ] of Byte;
   C :ISkCodec;
begin
     Result := False;  Width_ := 0;  Height_ := 0;

     E := LowerCase( ExtractFileExt( FileName_ ) );

     if E = '.png' then
     begin
          S := TFileStream.Create( FileName_, fmOpenRead or fmShareDenyWrite );
          try
               S.ReadBuffer( B[ 0 ], 8 );

               if not CompareMem( @B[ 0 ], @PNG_SIGN[ 0 ], 8 ) then Exit;

               ReadU32( S );  S.Seek( 4, soCurrent );  // 長さ ＋ 'IHDR'

               Width_  := ReadU32( S );
               Height_ := ReadU32( S );

               Result := True;
          finally
               S.Free;
          end;
     end
     else
     begin
          C := TSkCodec.MakeFromFile( FileName_ );

          if not Assigned( C ) then Exit;

          Width_  := C.Width;
          Height_ := C.Height;

          Result := True;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPngHead

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TPngHead.RowBytes( const W_:Integer ) :Integer;
begin
     Result := ( W_ * BitsPix + 7 ) div 8;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPngIdatReader

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////////// M E T H O D

function TPngIdatReader.NextChunk :Boolean;
var
   N :UInt32;
   K :array [ 0..3 ] of Byte;
begin
     _Stream.Seek( 4, soCurrent );  // 直前チャンクの CRC

     if _Stream.Position + 8 > _Stream.Size then Exit( False );

     N := ReadU32( _Stream );

     _Stream.ReadBuffer( K[ 0 ], 4 );

     if ( K[0] = Ord( 'I' ) ) and ( K[1] = Ord( 'D' ) ) and ( K[2] = Ord( 'A' ) ) and ( K[3] = Ord( 'T' ) ) then
     begin
          _Rest := N;  Result := True;
     end
     else Result := False;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPngIdatReader.Create( const Stream_:TStream; const Rest_:Integer );
begin
     inherited Create;

     _Stream := Stream_;
     _Rest   := Rest_;
     _Pos    := 0;
     _Ended  := False;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TPngIdatReader.Read( var Buffer; Count:Longint ) :Longint;
var
   D :PByte;
   C :Longint;
begin
     Result := 0;  D := @Buffer;

     while ( Result < Count ) and not _Ended do
     begin
          if _Rest = 0 then
          begin
               if not NextChunk then
               begin
                    _Ended := True;  Break;
               end;
          end;

          C := Min( Count - Result, _Rest );

          C := _Stream.Read( D^, C );

          if C = 0 then
          begin
               _Ended := True;  Break;
          end;

          Inc( D, C );  Dec( _Rest, C );  Inc( Result, C );
     end;

     Inc( _Pos, Result );
end;

function TPngIdatReader.Write( const Buffer; Count:Longint ) :Longint;
begin
     raise EInOutError.Create( 'TPngIdatReader は読み込み専用' );
end;

function TPngIdatReader.Seek( const Offset:Int64; Origin:TSeekOrigin ) :Int64;
begin
     ///// TZDecompressionStream は読み出しの度に Position を照会し、ずれていれば
     ///// 引き戻そうとする。現在位置を正しく返せば、その引き戻しは起こらない。

     case Origin of
       soBeginning: if Offset = _Pos then Exit( _Pos );
       soCurrent  : if Offset = 0    then Exit( _Pos );
       soEnd      : ;
     end;

     raise EInOutError.Create( 'TPngIdatReader は順次読み込み専用' );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPngIdatWriter

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPngIdatWriter.Create( const Stream_:TStream );
begin
     inherited Create;

     _Stream := Stream_;
     _Count  := 0;
     _Pos    := 0;

     SetLength( _Buffer, PNG_IDAT_MAX );
end;

destructor TPngIdatWriter.Destroy;
begin
     Flush;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPngIdatWriter.Flush;
begin
     if _Count > 0 then
     begin
          WriteChunk( _Stream, [ Ord( 'I' ), Ord( 'D' ), Ord( 'A' ), Ord( 'T' ) ], @_Buffer[ 0 ], _Count );

          _Count := 0;
     end;
end;

function TPngIdatWriter.Read( var Buffer; Count:Longint ) :Longint;
begin
     raise EInOutError.Create( 'TPngIdatWriter は書き込み専用' );
end;

function TPngIdatWriter.Write( const Buffer; Count:Longint ) :Longint;
var
   S :PByte;
   C :Longint;
begin
     Result := Count;  S := @Buffer;

     while Count > 0 do
     begin
          C := Min( Count, PNG_IDAT_MAX - _Count );

          Move( S^, _Buffer[ _Count ], C );

          Inc( _Count, C );  Inc( S, C );  Dec( Count, C );

          if _Count = PNG_IDAT_MAX then Flush;
     end;

     Inc( _Pos, Result );
end;

function TPngIdatWriter.Seek( const Offset:Int64; Origin:TSeekOrigin ) :Int64;
begin
     ///// TZCompressionStream も Position を照会する（読み出し側と同じ理由）

     case Origin of
       soBeginning: if Offset = _Pos then Exit( _Pos );
       soCurrent  : if Offset = 0    then Exit( _Pos );
       soEnd      : ;
     end;

     raise EInOutError.Create( 'TPngIdatWriter は順次書き込み専用' );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageFiler

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class procedure TLuxImageFiler.LoadFromFile( const Image_:TLuxImage; const FileName_:String );
var
   E :String;
   S :TFileStream;
begin
     E := LowerCase( ExtractFileExt( FileName_ ) );

     if E = '.png' then
     begin
          S := TFileStream.Create( FileName_, fmOpenRead or fmShareDenyWrite );
          try
               LoadFromPng( Image_, S );
          finally
               S.Free;
          end;
     end
     else
     if ( E = '.jpg' ) or ( E = '.jpeg' ) or ( E = '.jpe' ) then LoadFromJpg( Image_, FileName_ )
     else raise EInOutError.Create( '未対応の拡張子： ' + E );
end;

class procedure TLuxImageFiler.SaveToFile( const Image_:TLuxImage; const FileName_:String; const Quality_:Integer = 90 );
var
   E :String;
   S :TFileStream;
begin
     E := LowerCase( ExtractFileExt( FileName_ ) );

     if E = '.png' then
     begin
          S := TFileStream.Create( FileName_, fmCreate );
          try
               SaveToPng( Image_, S );
          finally
               S.Free;
          end;
     end
     else
     if ( E = '.jpg' ) or ( E = '.jpeg' ) or ( E = '.jpe' ) then SaveToJpg( Image_, FileName_, Quality_ )
     else raise EInOutError.Create( '未対応の拡張子： ' + E );
end;

//////////////////////////////////////////////////////////////////////// P N G

class procedure TLuxImageFiler.LoadFromPng( const Image_:TLuxImage; const Stream_:TStream );
var
   Sign     :array [ 0..7 ] of Byte;
   Kind     :array [ 0..3 ] of Byte;
   Size     :UInt32;
   Hd       :TPngHead;
   Buf      :TBytes;
   Idat     :TPngIdatReader;
   Zlib     :TZDecompressionStream;
   Raw0, Raw1, Swap :TBytes;
   Row      :TArray<TSingleRGBA>;
   Filt     :Byte;
   I, X, Y  :Integer;
   Pass     :Integer;
   PW, PH   :Integer;
   RowN     :Integer;
   Done, All :Integer;
   Found    :Boolean;

   ///// パスの 1 行を読んで解除し、色へ変換して Row へ入れる

   procedure ReadPassRow( const W_:Integer );
   begin
        RowN := Hd.RowBytes( W_ );

        Zlib.ReadBuffer( Filt, 1 );
        Zlib.ReadBuffer( Raw0[ 0 ], RowN );

        PngUnfilter( Filt, @Raw0[ 0 ], @Raw1[ 0 ], RowN, Hd.FiltBpp );

        PngRowToColors( Hd, @Raw0[ 0 ], W_, @Row[ 0 ] );

        Swap := Raw1;  Raw1 := Raw0;  Raw0 := Swap;  // 解除済みの行が次の「前行」になる
   end;

begin
     Stream_.ReadBuffer( Sign[ 0 ], 8 );

     if not CompareMem( @Sign[ 0 ], @PNG_SIGN[ 0 ], 8 ) then raise EInOutError.Create( 'PNG の署名ではない' );

     FillChar( Hd, SizeOf( Hd ), 0 );

     Size  := 0;
     Found := False;

     ///// IHDR ～ 最初の IDAT まで（ PLTE と tRNS を拾う）

     repeat
           if Stream_.Position + 8 > Stream_.Size then Break;

           Size := ReadU32( Stream_ );

           Stream_.ReadBuffer( Kind[ 0 ], 4 );

           ///// IHDR

           if ( Kind[0] = Ord('I') ) and ( Kind[1] = Ord('H') ) and ( Kind[2] = Ord('D') ) and ( Kind[3] = Ord('R') ) then
           begin
                Hd.Width  := ReadU32( Stream_ );
                Hd.Height := ReadU32( Stream_ );

                Hd.Depth     := ReadU08( Stream_ );
                Hd.Color     := ReadU08( Stream_ );

                Stream_.Seek( 2, soCurrent );  // 圧縮法・フィルタ法（ともに 0 のみ）

                Hd.Interlace := ReadU08( Stream_ );

                Stream_.Seek( 4, soCurrent );  // CRC
           end
           else
           ///// PLTE

           if ( Kind[0] = Ord('P') ) and ( Kind[1] = Ord('L') ) and ( Kind[2] = Ord('T') ) and ( Kind[3] = Ord('E') ) then
           begin
                Hd.PalN := Min( Integer( Size ) div 3, 256 );

                SetLength( Buf, Size );  Stream_.ReadBuffer( Buf[ 0 ], Size );

                for I := 0 to Hd.PalN-1 do
                  Hd.Pal[ I ] := TSingleRGBA.Create( Buf[ I*3 ] / 255, Buf[ I*3+1 ] / 255, Buf[ I*3+2 ] / 255, 1 );

                Stream_.Seek( 4, soCurrent );  // CRC
           end
           else
           ///// tRNS

           if ( Kind[0] = Ord('t') ) and ( Kind[1] = Ord('R') ) and ( Kind[2] = Ord('N') ) and ( Kind[3] = Ord('S') ) then
           begin
                SetLength( Buf, Size );  if Size > 0 then Stream_.ReadBuffer( Buf[ 0 ], Size );

                case Hd.Color of
                  0: if Size >= 2 then
                     begin
                          Hd.HasTrns := True;
                          Hd.Trns[0] := Buf[0] * 256 + Buf[1];
                     end;
                  2: if Size >= 6 then
                     begin
                          Hd.HasTrns := True;
                          Hd.Trns[0] := Buf[0] * 256 + Buf[1];
                          Hd.Trns[1] := Buf[2] * 256 + Buf[3];
                          Hd.Trns[2] := Buf[4] * 256 + Buf[5];
                     end;
                  3: for I := 0 to Min( Integer( Size ), Hd.PalN ) - 1 do Hd.Pal[ I ].A := Buf[ I ] / 255;
                end;

                Stream_.Seek( 4, soCurrent );  // CRC
           end
           else
           ///// IDAT

           if ( Kind[0] = Ord('I') ) and ( Kind[1] = Ord('D') ) and ( Kind[2] = Ord('A') ) and ( Kind[3] = Ord('T') ) then
           begin
                Found := True;  Break;
           end
           else Stream_.Seek( Size + 4, soCurrent );  // 中身 ＋ CRC
     until False;

     if not Found then raise EInOutError.Create( 'PNG に IDAT が無い' );

     ///// ビット深度とカラータイプの組み合わせを検証する

     case Hd.Color of
       0: begin  Hd.Chans := 1;  if not ( Hd.Depth in [ 1, 2, 4, 8, 16 ] ) then Found := False;  end;
       2: begin  Hd.Chans := 3;  if not ( Hd.Depth in [       8, 16 ] ) then Found := False;  end;
       3: begin  Hd.Chans := 1;  if not ( Hd.Depth in [ 1, 2, 4, 8     ] ) then Found := False;  end;
       4: begin  Hd.Chans := 2;  if not ( Hd.Depth in [       8, 16 ] ) then Found := False;  end;
       6: begin  Hd.Chans := 4;  if not ( Hd.Depth in [       8, 16 ] ) then Found := False;  end;
     else raise EInOutError.Create( 'PNG のカラータイプ ' + Hd.Color.ToString + ' が不正' );
     end;

     if not Found then raise EInOutError.Create( 'PNG のカラータイプ ' + Hd.Color.ToString +
                                                 ' とビット深度 ' + Hd.Depth.ToString + ' の組み合わせが不正' );

     if Hd.Interlace > 1 then raise EInOutError.Create( 'PNG のインターレース法 ' + Hd.Interlace.ToString + ' が不正' );

     if ( Hd.Color = 3 ) and ( Hd.PalN = 0 ) then raise EInOutError.Create( 'PNG のパレット（ PLTE ）が無い' );

     Hd.BitsPix := Hd.Chans * Hd.Depth;
     Hd.FiltBpp := Max( 1, Hd.BitsPix div 8 );
     Hd.MaxVal  := ( 1 shl Hd.Depth ) - 1;

     Image_.SetSize( Hd.Width, Hd.Height );

     ///// 行バッファは、どのパスでも足りるように最大幅で確保する

     SetLength( Raw0, Hd.RowBytes( Hd.Width ) + 1 );
     SetLength( Raw1, Hd.RowBytes( Hd.Width ) + 1 );
     SetLength( Row , Hd.Width );

     Idat := TPngIdatReader.Create( Stream_, Integer( Size ) );
     try
          Zlib := TZDecompressionStream.Create( Idat );
          try
               if Hd.Interlace = 0 then
               begin
                    FillChar( Raw1[ 0 ], Length( Raw1 ), 0 );

                    for Y := 0 to Hd.Height-1 do
                    begin
                         ReadPassRow( Hd.Width );

                         Image_.SetRow( 0, 0, Y, Hd.Width, @Row[ 0 ] );

                         Image_.DoProgress( ( Y + 1 ) / Hd.Height );
                    end;
               end
               else
               begin
                    ///// Adam7 ： 7 つのパスを順に読み、画素を最終位置へ散らす

                    All := 0;

                    for Pass := 0 to 6 do
                    begin
                         PH := ( Hd.Height - PNG_PASS_Y0[ Pass ] + PNG_PASS_DY[ Pass ] - 1 ) div PNG_PASS_DY[ Pass ];

                         if ( Hd.Width - PNG_PASS_X0[ Pass ] ) > 0 then Inc( All, Max( PH, 0 ) );
                    end;

                    Done := 0;

                    for Pass := 0 to 6 do
                    begin
                         PW := ( Hd.Width  - PNG_PASS_X0[ Pass ] + PNG_PASS_DX[ Pass ] - 1 ) div PNG_PASS_DX[ Pass ];
                         PH := ( Hd.Height - PNG_PASS_Y0[ Pass ] + PNG_PASS_DY[ Pass ] - 1 ) div PNG_PASS_DY[ Pass ];

                         if ( PW <= 0 ) or ( PH <= 0 ) then Continue;

                         FillChar( Raw1[ 0 ], Length( Raw1 ), 0 );  // パス毎に前行は 0 から

                         for Y := 0 to PH-1 do
                         begin
                              ReadPassRow( PW );

                              for X := 0 to PW-1 do
                                Image_.SetRow( 0, PNG_PASS_X0[ Pass ] + X * PNG_PASS_DX[ Pass ],
                                                  PNG_PASS_Y0[ Pass ] + Y * PNG_PASS_DY[ Pass ], 1, @Row[ X ] );

                              Inc( Done );

                              Image_.DoProgress( Done / All );
                         end;
                    end;
               end;
          finally
               Zlib.Free;
          end;
     finally
          Idat.Free;
     end;

     Image_.Changed;
end;

class procedure TLuxImageFiler.SaveToPng( const Image_:TLuxImage; const Stream_:TStream );
var
   Head       :TBytes;
   W, H       :Integer;
   Depth, Bpp :Integer;
   RowN       :Integer;
   Idat       :TPngIdatWriter;
   Zlib       :TZCompressionStream;
   Raw0, Raw1 :TBytes;
   Out_       :TBytes;
   Row        :TArray<TSingleRGBA>;
   X, Y, I    :Integer;
   A, B, C, P, PA, PB, PC :Integer;
   Q          :PByte;
   U          :UInt32;
begin
     W := Image_.Width;
     H := Image_.Height;

     if ( W < 1 ) or ( H < 1 ) then raise EInOutError.Create( '空の画像は保存できない' );

     if Image_.PixelKind = bpUInt08 then Depth := 8 else Depth := 16;

     Bpp  := 4 * ( Depth div 8 );
     RowN := W * Bpp;

     ///// 署名

     Stream_.WriteBuffer( PNG_SIGN[ 0 ], 8 );

     ///// IHDR

     SetLength( Head, 13 );

     U := SwapU32( W );  Move( U, Head[ 0 ], 4 );
     U := SwapU32( H );  Move( U, Head[ 4 ], 4 );

     Head[  8 ] := Depth;
     Head[  9 ] := 6;  // RGBA
     Head[ 10 ] := 0;  // 圧縮法
     Head[ 11 ] := 0;  // フィルタ法
     Head[ 12 ] := 0;  // 非インターレース

     WriteChunk( Stream_, [ Ord('I'), Ord('H'), Ord('D'), Ord('R') ], @Head[ 0 ], 13 );

     ///// IDAT

     SetLength( Raw0, RowN     );
     SetLength( Raw1, RowN     );
     SetLength( Out_, RowN + 1 );
     SetLength( Row , W        );

     FillChar( Raw1[ 0 ], RowN, 0 );

     Idat := TPngIdatWriter.Create( Stream_ );
     try
          Zlib := TZCompressionStream.Create( Idat );
          try
               for Y := 0 to H-1 do
               begin
                    Image_.GetRow( 0, 0, Y, W, @Row[ 0 ] );

                    Q := @Raw0[ 0 ];

                    if Depth = 8 then
                    begin
                         for X := 0 to W-1 do
                         begin
                              Q[ 0 ] := Round( Clamp( Row[X].C.R, 0, 1 ) * $FF );
                              Q[ 1 ] := Round( Clamp( Row[X].C.G, 0, 1 ) * $FF );
                              Q[ 2 ] := Round( Clamp( Row[X].C.B, 0, 1 ) * $FF );
                              Q[ 3 ] := Round( Clamp( Row[X].A  , 0, 1 ) * $FF );

                              Inc( Q, 4 );
                         end;
                    end
                    else
                    begin
                         for X := 0 to W-1 do
                         begin
                              I := Round( Clamp( Row[X].C.R, 0, 1 ) * $FFFF );  Q[ 0 ] := I shr 8;  Q[ 1 ] := I and $FF;
                              I := Round( Clamp( Row[X].C.G, 0, 1 ) * $FFFF );  Q[ 2 ] := I shr 8;  Q[ 3 ] := I and $FF;
                              I := Round( Clamp( Row[X].C.B, 0, 1 ) * $FFFF );  Q[ 4 ] := I shr 8;  Q[ 5 ] := I and $FF;
                              I := Round( Clamp( Row[X].A  , 0, 1 ) * $FFFF );  Q[ 6 ] := I shr 8;  Q[ 7 ] := I and $FF;

                              Inc( Q, 8 );
                         end;
                    end;

                    ///// Paeth フィルタ

                    Out_[ 0 ] := 4;

                    for I := 0 to RowN-1 do
                    begin
                         if I >= Bpp then begin  A := Raw0[ I - Bpp ];  C := Raw1[ I - Bpp ];  end
                                     else begin  A := 0             ;  C := 0             ;  end;

                         B := Raw1[ I ];

                         P := A + B - C;  PA := Abs( P - A );  PB := Abs( P - B );  PC := Abs( P - C );

                         if ( PA <= PB ) and ( PA <= PC ) then P := A
                                                          else if PB <= PC then P := B
                                                                           else P := C;

                         Out_[ I + 1 ] := ( Raw0[ I ] - P ) and $FF;
                    end;

                    Zlib.WriteBuffer( Out_[ 0 ], RowN + 1 );

                    Image_.DoProgress( ( Y + 1 ) / H );

                    Move( Raw0[ 0 ], Raw1[ 0 ], RowN );
               end;
          finally
               Zlib.Free;
          end;
     finally
          Idat.Free;
     end;

     ///// IEND

     WriteChunk( Stream_, [ Ord('I'), Ord('E'), Ord('N'), Ord('D') ], nil, 0 );
end;

//////////////////////////////////////////////////////////////////// J P E G

class procedure TLuxImageFiler.LoadFromJpg( const Image_:TLuxImage; const FileName_:String );
var
   Codec :ISkCodec;
   W, H  :Integer;
   Buf   :TBytes;
   Row   :TArray<TSingleRGBA>;
   S     :PByteRGBA;
   X, Y  :Integer;
begin
     Codec := TSkCodec.MakeFromFile( FileName_ );

     if not Assigned( Codec ) then raise EInOutError.Create( 'JPEG を開けない： ' + FileName_ );

     W := Codec.Width;
     H := Codec.Height;

     Image_.SetSize( W, H );

     ///// Skia のコーデックは画像１枚分の連続バッファを要求する。
     ///// また変換先は 8bit（ BGRA8888 ）しか確実に対応していないので、
     ///// JPEG が 8bit であることを踏まえて常に BGRA8888 で受け、必要なら書式変換する。

     SetLength( Buf, NativeInt( W ) * H * SizeOf( TByteRGBA ) );

     if not Codec.GetPixels( @Buf[ 0 ], NativeUInt( W ) * SizeOf( TByteRGBA ),
                             TSkColorType.BGRA8888, TSkAlphaType.Unpremul ) then
       raise EInOutError.Create( 'JPEG を復号できない： ' + FileName_ );

     ///// Skia の復号は途中経過を返さない不可分な呼び出しなので、
     ///// ここまでで一気に 0.8 まで進む（実際に所要時間の大半を占めるのもここ）

     Image_.DoProgress( 0.8 );

     if Image_.PixelKind = bpUInt08 then
     begin
          for Y := 0 to H-1 do
          begin
               Image_.SetRaws( 0, 0, Y, W, @Buf[ NativeInt( Y ) * W * SizeOf( TByteRGBA ) ] );

               Image_.DoProgress( 0.8 + 0.2 * ( Y + 1 ) / H );
          end;
     end
     else
     begin
          SetLength( Row, W );

          for Y := 0 to H-1 do
          begin
               S := @Buf[ NativeInt( Y ) * W * SizeOf( TByteRGBA ) ];

               for X := 0 to W-1 do
               begin
                    Row[ X ] := S^;  Inc( S );
               end;

               Image_.SetRow( 0, 0, Y, W, @Row[ 0 ] );

               Image_.DoProgress( 0.8 + 0.2 * ( Y + 1 ) / H );
          end;
     end;

     Buf := nil;

     Image_.Changed;
end;

class procedure TLuxImageFiler.SaveToJpg( const Image_:TLuxImage; const FileName_:String; const Quality_:Integer );
var
   W, H    :Integer;
   Buf     :TBytes;
   Row     :TArray<TSingleRGBA>;
   X, Y    :Integer;
   Q       :PByteRGBA;
   Pixmap  :ISkPixmap;
   Image   :ISkImage;
begin
     W := Image_.Width;
     H := Image_.Height;

     if ( W < 1 ) or ( H < 1 ) then raise EInOutError.Create( '空の画像は保存できない' );

     if ( W > 65535 ) or ( H > 65535 ) then raise EInOutError.Create( 'JPEG は 65,535 画素を超えられない' );

     SetLength( Buf, NativeInt( W ) * H * SizeOf( TByteRGBA ) );
     SetLength( Row, W );

     for Y := 0 to H-1 do
     begin
          Image_.GetRow( 0, 0, Y, W, @Row[ 0 ] );

          Q := @Buf[ NativeInt( Y ) * W * SizeOf( TByteRGBA ) ];

          for X := 0 to W-1 do
          begin
               Q^ := TByteRGBA( Row[ X ] );  Q^.A := $FF;  Inc( Q );
          end;

          Image_.DoProgress( 0.9 * ( Y + 1 ) / H );  // 残り 0.1 は Skia による符号化
     end;

     Pixmap := TSkPixmap.Create( TSkImageInfo.Create( W, H, TSkColorType.BGRA8888, TSkAlphaType.Opaque ),
                                 @Buf[ 0 ], NativeUInt( W ) * SizeOf( TByteRGBA ) );

     Image := TSkImage.MakeFromRaster( Pixmap );

     if not Assigned( Image ) then raise EInOutError.Create( 'JPEG 用の画像を作れない' );

     if not Image.EncodeToFile( FileName_, TSkEncodedImageFormat.JPEG, Quality_ ) then
       raise EInOutError.Create( 'JPEG を書き出せない： ' + FileName_ );
end;

initialization //############################################################### ■

     InitCrcTab;

end. //######################################################################### ■
