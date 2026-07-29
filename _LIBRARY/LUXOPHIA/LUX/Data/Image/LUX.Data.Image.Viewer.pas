unit LUX.Data.Image.Viewer;

interface //#################################################################### ■

{$POINTERMATH ON}

uses System.Classes, System.Types, System.UITypes, System.Math.Vectors,
     System.Generics.Collections,
     FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
     System.Skia, FMX.Skia, FMX.Skia.Canvas,
     LUX, LUX.Color, LUX.Data.Image;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageViewer

     ///// TLuxImage をリアルタイムに表示するフレーム
     /////
     ///// ・Skia への描画機構（TSkCustomControl 相当）をこのクラス自身が実装する。
     /////   子コントロールは持たない。FMX キャンバスが Skia なら同じサーフェスへ
     /////   直接描くので転写が発生しない。
     ///// ・可視タイルだけを ISkImage 化して Skia に描かせるので、画像の大きさに関わらず
     /////   １フレームあたりの描画コストは画面の大きさだけで決まる。
     ///// ・段（ミップマップ）は「段内では常に等倍～２倍の拡大」になるように選ぶので、
     /////   縮小によるエイリアシングが原理的に発生しない。
     ///// ・タイル境界の継ぎ目を防ぐため、キャッシュするタイル画像は周囲１画素の
     /////   のりしろ（エプロン）を隣のタイルから集めて持つ。
     ///// ・トーンマッピングとガンマ補正は SkSL のランタイム効果（GPU）で行う。

     TLuxImageViewer = class( TFrame )
     private type
       TTileKey = record
         L :Integer;
         X :Integer;
         Y :Integer;
       end;
       TTileImg = record
         Img   :ISkImage;
         Stamp :Integer;
       end;
     private
       _Image      :TLuxImage;
       _Version    :Cardinal;
       _Scale      :Single;
       _Origin     :TPointF;      // 表示領域の左上に対応する画像座標
       _Gamma      :Single;
       _ToneMap    :Boolean;
       _White      :Single;
       _Background :TAlphaColor;
       _MinScale   :Single;
       _MaxScale   :Single;
       /////
       _Cache  :TDictionary<TTileKey,TTileImg>;
       _Apron  :TArray<Byte>;
       _Stamp  :Integer;
       _Effect :ISkRuntimeEffect;
       ///// TSkCustomControl 相当の描画機構
       _Buffer        :TBitmap;           // Skia キャンバスでない環境用の中間ラスタ
       _DrawCached    :Boolean;
       _DrawCacheKind :TSkDrawCacheKind;
       _OnDraw        :TSkDrawEvent;
       /////
       _Draggin :Boolean;
       _DragP   :TPointF;
       _DragO   :TPointF;
       _MouseP  :TPointF;
       _MouseOn :Boolean;   // _MouseP が有効か（一度も動かされていない間は中心を使う）
       _ViewW   :Single;    // 直前に描いた領域の大きさ
       _ViewH   :Single;
       _NeedFit :Boolean;   // 次の描画時に窓へ合わせる（実際の描画矩形が判るのは描画時なので）
       ///// A C C E S S O R
       procedure SetImage( const Image_:TLuxImage );
       procedure SetGamma( const Gamma_:Single );
       procedure SetToneMap( const ToneMap_:Boolean );
       procedure SetWhite( const White_:Single );
       procedure SetBackground( const Background_:TAlphaColor );
       procedure SetScale( const Scale_:Single );
       procedure SetOrigin( const Origin_:TPointF );
       procedure SetDrawCacheKind( const Value_:TSkDrawCacheKind );
       procedure SetOnDraw( const Value_:TSkDrawEvent );
       ///// E V E N T
       procedure ImageChanged( Sender_:TObject );
       ///// M E T H O D
       function TileImage( const L_,TX_,TY_:Integer ) :ISkImage;
       function ViewCenter :TPointF;
       procedure CenterImage;
       procedure DoFit( const W_,H_:Single );
       procedure SweepCache;
       procedure DropCache;
     protected
       ///// M E T H O D
       procedure Draw( const ACanvas:ISkCanvas; const ADest:TRectF; const AOpacity:Single ); virtual;
       function NeedsRedraw :Boolean; virtual;
       procedure Paint; override;
       procedure MouseDown( Button:TMouseButton; Shift:TShiftState; X,Y:Single ); override;
       procedure MouseMove( Shift:TShiftState; X,Y:Single ); override;
       procedure MouseUp( Button:TMouseButton; Shift:TShiftState; X,Y:Single ); override;
       procedure MouseWheel( Shift:TShiftState; WheelDelta:Integer; var Handled:Boolean ); override;
     public
       constructor Create( AOwner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property DrawCacheKind :TSkDrawCacheKind read _DrawCacheKind write SetDrawCacheKind default TSkDrawCacheKind.Never;
       property OnDraw        :TSkDrawEvent     read _OnDraw        write SetOnDraw;
       /////
       property Image      :TLuxImage   read _Image      write SetImage     ;
       property Gamma      :Single      read _Gamma      write SetGamma     ;  // 表示ガンマ（out = in^(1/Gamma)）
       property ToneMap    :Boolean     read _ToneMap    write SetToneMap   ;  // Reinhard のトーンマッピング
       property White      :Single      read _White      write SetWhite     ;  // トーンマッピングの白色点
       property Background :TAlphaColor read _Background write SetBackground;
       property Scale      :Single      read _Scale      write SetScale     ;  // 画面画素／画像画素
       property Origin     :TPointF     read _Origin     write SetOrigin    ;
       property MinScale   :Single      read _MinScale   write _MinScale    ;
       property MaxScale   :Single      read _MaxScale   write _MaxScale    ;
       ///// M E T H O D
       procedure FitToWindow;
       procedure ZoomAt( const P_:TPointF; const Factor_:Single );  // 表示座標 P_ を固定して拡大縮小
       procedure ZoomWheel( const WheelDelta_:Integer );            // 直前のマウス位置を固定して拡大縮小
       function ViewToImage( const P_:TPointF ) :TPointF;
       function ImageToView( const P_:TPointF ) :TPointF;
       procedure Redraw;
     end;

implementation //############################################################### ■

{$R *.fmx}

uses System.SysUtils, System.Math,
     LUX.Data.Image.Files;

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      CACHE_MAX = 512;  // 保持するタイル画像の上限

      ///// 中間ラスタが GPU テクスチャの上限を超えたときの警告（TSkCustomControl と同趣旨）

      LUXIMAGEVIEWER_EXCEEDED = 'A control has exceeded the size allowed for a bitmap ' +
                                '(class %s, name "%s"). We will reduce the drawing quality ' +
                                'to avoid this exception. Consider using "GlobalUseSkia := True" ' +
                                'to avoid this kind of problem.';

      ///// トーンマッピング（Reinhard 2002）とガンマ補正
      ///// uP = ( 1/Gamma, 1/White², トーンマップの有無, 予備 )

      SKSL_TONE =
        'uniform float4 uP;'                                                      + sLineBreak +
        ''                                                                        + sLineBreak +
        'half4 main( half4 c )'                                                   + sLineBreak +
        '{'                                                                       + sLineBreak +
        '    float  a = float( c.a );'                                            + sLineBreak +
        '    float3 v = ( a > 0.0 ) ? float3( c.rgb ) / a : float3( 0.0 );'       + sLineBreak +
        ''                                                                        + sLineBreak +
        '    if ( uP.z > 0.5 )'                                                   + sLineBreak +
        '    {'                                                                   + sLineBreak +
        '        v = clamp( v * ( 1.0 + v * uP.y ) / ( 1.0 + v ), float3( 0.0 ), float3( 1.0 ) );' + sLineBreak +
        '    }'                                                                   + sLineBreak +
        ''                                                                        + sLineBreak +
        '    v = pow( max( v, float3( 0.0 ) ), float3( uP.x ) );'                 + sLineBreak +
        ''                                                                        + sLineBreak +
        '    return half4( half3( v * a ), half( a ) );'                          + sLineBreak +
        '}';

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLuxImageViewer

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TLuxImageViewer.SetImage( const Image_:TLuxImage );
begin
     if _Image = Image_ then Exit;

     if Assigned( _Image ) then _Image.OnChange.Del( ImageChanged );

     _Image := Image_;

     DropCache;

     if Assigned( _Image ) then
     begin
          _Image.OnChange.Add( ImageChanged );

          _Version := _Image.Version;
          _Gamma   := _Image.DefaultGamma;
          _ToneMap := _Image.IsFloat;

          SetLength( _Apron, ( LUXIMAGE_TILE + 2 ) * ( LUXIMAGE_TILE + 2 ) * _Image.PixelSize );

          FitToWindow;
     end
     else Redraw;
end;

procedure TLuxImageViewer.SetGamma( const Gamma_:Single );
begin
     if _Gamma = Gamma_ then Exit;

     _Gamma := Gamma_;  Redraw;
end;

procedure TLuxImageViewer.SetToneMap( const ToneMap_:Boolean );
begin
     if _ToneMap = ToneMap_ then Exit;

     _ToneMap := ToneMap_;  Redraw;
end;

procedure TLuxImageViewer.SetWhite( const White_:Single );
begin
     if _White = White_ then Exit;

     _White := White_;  Redraw;
end;

procedure TLuxImageViewer.SetBackground( const Background_:TAlphaColor );
begin
     if _Background = Background_ then Exit;

     _Background := Background_;  Redraw;
end;

procedure TLuxImageViewer.SetScale( const Scale_:Single );
var
   S :Single;
begin
     S := Clamp( Scale_, _MinScale, _MaxScale );

     if _Scale = S then Exit;

     _Scale := S;

     ///// 画像の中心を基準にする。
     ///// 表示の中心を固定すると、画像を隅へずらして表示中心が画像の外にある状態で
     ///// 拡大したとき、その外の点を軸に拡大されて画像を見失う。

     CenterImage;

     Redraw;
end;

procedure TLuxImageViewer.SetOrigin( const Origin_:TPointF );
begin
     if _Origin = Origin_ then Exit;

     _Origin := Origin_;  Redraw;
end;

//////////////////////////////////////////////////////////////////// E V E N T

procedure TLuxImageViewer.ImageChanged( Sender_:TObject );
begin
     DropCache;  Redraw;
end;

procedure TLuxImageViewer.SetDrawCacheKind( const Value_:TSkDrawCacheKind );
begin
     if _DrawCacheKind = Value_ then Exit;

     _DrawCacheKind := Value_;

     if _DrawCacheKind <> TSkDrawCacheKind.Always then Repaint;
end;

//------------------------------------------------------------------------------

procedure TLuxImageViewer.SetOnDraw( const Value_:TSkDrawEvent );
begin
     if TMethod( _OnDraw ) = TMethod( Value_ ) then Exit;

     _OnDraw := Value_;  Redraw;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

///// Skia への実際の描画。TSkCustomControl.Draw の override に相当する。

procedure TLuxImageViewer.Draw( const ACanvas:ISkCanvas; const ADest:TRectF; const AOpacity:Single );
var
   L, TX, TY, TX0, TX1, TY0, TY1, TW, TH :Integer;
   S, OX, OY                             :Single;
   Paint                                 :ISkPaint;
   Samp                                  :TSkSamplingOptions;
   Img                                   :ISkImage;
   Unif                                  :TSkRuntimeEffectFloat4;
begin
     ACanvas.Save;
     try
          ACanvas.ClipRect( ADest );
          ACanvas.Clear( _Background );

          if ( csDesigning in ComponentState ) and not Locked then
          begin
               FMX.Skia.DrawDesignBorder( ACanvas, ADest, AOpacity );  Exit;
          end;

          if not Assigned( _Image ) or ( _Image.Width < 1 ) or ( _Image.Height < 1 ) then Exit;

          if _Image.Busy then Exit;  // 非同期の読み書き中は別スレッドが画素を触っているので描かない

          if _Version <> _Image.Version then
          begin
               DropCache;  _Version := _Image.Version;
          end;

          _ViewW := ADest.Width;
          _ViewH := ADest.Height;

          if _NeedFit then
          begin
               _NeedFit := False;  DoFit( _ViewW, _ViewH );
          end;

          Inc( _Stamp );

          ///// 段は「段内では常に等倍～２倍の拡大」になるように選ぶ

          L := Max( 0, Ceil( -Log2( _Scale ) ) );
          L := Min( L, _Image.LevelsN - 1 );

          _Image.NeedLevel( L );

          S := _Scale * ( 1 shl L );  // 段 L の１画素あたりの画面画素数（１≦ S ＜２）

          OX := ADest.Left - _Origin.X * _Scale;  // 画面X ＝ OX ＋ 段L座標X × S
          OY := ADest.Top  - _Origin.Y * _Scale;

          TX0 := Max( Floor( ( ADest.Left   - OX ) / S / LUXIMAGE_TILE ), 0 );
          TX1 := Min( Floor( ( ADest.Right  - OX ) / S / LUXIMAGE_TILE ), _Image.LevelTilesX( L ) - 1 );
          TY0 := Max( Floor( ( ADest.Top    - OY ) / S / LUXIMAGE_TILE ), 0 );
          TY1 := Min( Floor( ( ADest.Bottom - OY ) / S / LUXIMAGE_TILE ), _Image.LevelTilesY( L ) - 1 );

          ///// トーンマッピングとガンマ補正

          Paint := TSkPaint.Create;
          Paint.AlphaF := AOpacity;

          if Assigned( _Effect ) then
          begin
               Unif.V1 := 1 / _Gamma;
               Unif.V2 := 1 / Pow2( _White );
               Unif.V3 := Ord( _ToneMap );
               Unif.V4 := 0;

               Paint.ColorFilter := _Effect.MakeColorFilter( Unif, [] );
          end;

          ///// 等倍以上は画素の四角が見えるように最近傍、縮小側は線形

          if _Scale >= 1 then Samp := TSkSamplingOptions.Create( TSkFilterMode.Nearest, TSkMipmapMode.None )
                         else Samp := TSkSamplingOptions.Create( TSkFilterMode.Linear , TSkMipmapMode.None );

          ///// 可視タイルを並べる

          for TY := TY0 to TY1 do
          for TX := TX0 to TX1 do
          begin
               Img := TileImage( L, TX, TY );

               if not Assigned( Img ) then Continue;

               TW := _Image.TileWidth ( L, TX );
               TH := _Image.TileHeight( L, TY );

               ACanvas.DrawImageRect( Img,
                                      RectF( 1, 1, 1 + TW, 1 + TH ),
                                      RectF( OX +   TX       * LUXIMAGE_TILE         * S,
                                             OY +   TY       * LUXIMAGE_TILE         * S,
                                             OX + ( TX       * LUXIMAGE_TILE + TW  ) * S,
                                             OY + ( TY       * LUXIMAGE_TILE + TH  ) * S ),
                                      Samp, Paint, TSkSrcRectConstraint.Fast );
          end;

          SweepCache;
     finally
          ACanvas.Restore;
     end;
end;

//------------------------------------------------------------------------------

///// TSkCustomControl.NeedsRedraw に相当する。

function TLuxImageViewer.NeedsRedraw :Boolean;
begin
     Result := ( not _DrawCached ) or ( _DrawCacheKind = TSkDrawCacheKind.Never );
end;

//------------------------------------------------------------------------------

///// TSkCustomControl.Paint に相当する。
///// FMX キャンバスが Skia なら、そのキャンバスへ直接描く（中間ラスタも転写も無し）。
///// そうでない環境では、いったんラスタへ描いてから転写する。

procedure TLuxImageViewer.Paint;
var
   AbsoluteBimapSize :TSize;
   AbsoluteScale     :TPointF;
   AbsoluteSize      :TSize;
   ExceededRatio     :Single;
   MaxBitmapSize     :Integer;
   SceneScale        :Single;
begin
     if ( ( _DrawCacheKind = TSkDrawCacheKind.Never  ) and ( Canvas is TSkCanvasCustom ) ) or
        ( ( _DrawCacheKind = TSkDrawCacheKind.Raster ) and ( Canvas is TGrCanvas       ) ) then
     begin
          Draw( TSkCanvasCustom( Canvas ).Canvas, LocalRect, AbsoluteOpacity );

          if Assigned( _OnDraw ) then _OnDraw( Self, TSkCanvasCustom( Canvas ).Canvas, LocalRect, AbsoluteOpacity );

          FreeAndNil( _Buffer );
     end
     else
     begin
          if Assigned( Scene ) then SceneScale := Scene.GetSceneScale
                               else SceneScale := 1;

          AbsoluteScale := Self.AbsoluteScale;
          AbsoluteSize  := TSize.Create( Round( Width  * AbsoluteScale.X * SceneScale ),
                                         Round( Height * AbsoluteScale.Y * SceneScale ) );

          MaxBitmapSize := Canvas.GetAttribute( TCanvasAttribute.MaxBitmapSize );

          if ( AbsoluteSize.Width > MaxBitmapSize ) or ( AbsoluteSize.Height > MaxBitmapSize ) then
          begin
               AbsoluteBimapSize := RectF( 0, 0, AbsoluteSize.Width, AbsoluteSize.Height )
                                    .FitInto( RectF( 0, 0, MaxBitmapSize, MaxBitmapSize ), ExceededRatio ).Size.Round;

               Log.d( Format( LUXIMAGEVIEWER_EXCEEDED, [ ClassName, Name ] ) );
          end
          else
          begin
               AbsoluteBimapSize := AbsoluteSize;  ExceededRatio := 1;
          end;

          if NeedsRedraw or ( _Buffer = nil )
                         or ( TSize.Create( _Buffer.Width, _Buffer.Height ) <> AbsoluteBimapSize ) then
          begin
               if _Buffer = nil then _Buffer := TBitmap.Create( AbsoluteBimapSize.Width, AbsoluteBimapSize.Height )
               else
               if TSize.Create( _Buffer.Width, _Buffer.Height ) <> AbsoluteBimapSize then
                 _Buffer.SetSize( AbsoluteBimapSize.Width, AbsoluteBimapSize.Height );

               _Buffer.SkiaDraw( procedure ( const ACanvas:ISkCanvas )
                                 var
                                    AbsoluteScale :TPointF;
                                 begin
                                      ACanvas.Clear( TAlphaColors.Null );

                                      AbsoluteScale := Self.AbsoluteScale * SceneScale / ExceededRatio;

                                      ACanvas.Concat( TMatrix.CreateScaling( AbsoluteScale.X, AbsoluteScale.Y ) );

                                      Draw( ACanvas, LocalRect, 1 );

                                      if Assigned( _OnDraw ) then _OnDraw( Self, ACanvas, LocalRect, 1 );
                                 end, False );

               _DrawCached := True;
          end;

          Canvas.DrawBitmap( _Buffer,
                             RectF( 0, 0, _Buffer.Width, _Buffer.Height ),
                             RectF( 0, 0, _Buffer.Width  / ( AbsoluteScale.X * SceneScale / ExceededRatio ),
                                          _Buffer.Height / ( AbsoluteScale.Y * SceneScale / ExceededRatio ) ),
                             AbsoluteOpacity );
     end;
end;

//------------------------------------------------------------------------------

procedure TLuxImageViewer.MouseDown( Button:TMouseButton; Shift:TShiftState; X,Y:Single );
begin
     inherited;

     if Button <> TMouseButton.mbLeft then Exit;

     _Draggin := True;
     _DragP   := PointF( X, Y );
     _DragO   := _Origin;
end;

procedure TLuxImageViewer.MouseMove( Shift:TShiftState; X,Y:Single );
begin
     inherited;

     _MouseP := PointF( X, Y );  _MouseOn := True;

     if not _Draggin then Exit;

     ///// 枠外で放されるなどして MouseUp を取り逃がした場合の保険

     if not ( ssLeft in Shift ) then
     begin
          _Draggin := False;  Exit;
     end;

     _Origin := PointF( _DragO.X - ( X - _DragP.X ) / _Scale,
                        _DragO.Y - ( Y - _DragP.Y ) / _Scale );

     Redraw;
end;

procedure TLuxImageViewer.MouseUp( Button:TMouseButton; Shift:TShiftState; X,Y:Single );
begin
     inherited;

     _Draggin := False;
end;

procedure TLuxImageViewer.MouseWheel( Shift:TShiftState; WheelDelta:Integer; var Handled:Boolean );
begin
     inherited;

     if Handled then Exit;

     ZoomWheel( WheelDelta );

     Handled := True;
end;

//------------------------------------------------------------------------------

function TLuxImageViewer.TileImage( const L_,TX_,TY_:Integer ) :ISkImage;
var
   Key           :TTileKey;
   Ent           :TTileImg;
   TW, TH, Z     :Integer;
   LW, LH        :Integer;
   X0, Y, SY, SX :Integer;
   D             :PByte;
   Pixmap        :ISkPixmap;
begin
     Key.L := L_;  Key.X := TX_;  Key.Y := TY_;

     if _Cache.TryGetValue( Key, Ent ) then
     begin
          Ent.Stamp := _Stamp;  _Cache.AddOrSetValue( Key, Ent );  Exit( Ent.Img );
     end;

     TW := _Image.TileWidth ( L_, TX_ );
     TH := _Image.TileHeight( L_, TY_ );

     if ( TW < 1 ) or ( TH < 1 ) then Exit( nil );

     Z  := _Image.PixelSize;
     LW := _Image.LevelWidth ( L_ );
     LH := _Image.LevelHeight( L_ );

     X0 := TX_ * LUXIMAGE_TILE;

     ///// 周囲１画素ののりしろ付きで集める（隣のタイルの画素。外側は端をクランプ）

     for Y := -1 to TH do
     begin
          SY := Clamp( TY_ * LUXIMAGE_TILE + Y, 0, LH - 1 );

          D := @_Apron[ ( Y + 1 ) * ( TW + 2 ) * Z ];

          SX := Clamp( X0 - 1, 0, LW - 1 );                 // 左ののりしろ
          _Image.GetRaws( L_, SX, SY, 1, D );

          _Image.GetRaws( L_, X0, SY, TW, D + Z );          // 中身

          SX := Clamp( X0 + TW, 0, LW - 1 );                // 右ののりしろ
          _Image.GetRaws( L_, SX, SY, 1, D + ( TW + 1 ) * Z );
     end;

     Pixmap := TSkPixmap.Create( TSkImageInfo.Create( TW + 2, TH + 2,
                                                     LuxSkColorType( _Image.PixelKind ),
                                                     TSkAlphaType.Unpremul ),
                                 @_Apron[ 0 ], NativeUInt( TW + 2 ) * NativeUInt( Z ) );

     Ent.Img   := TSkImage.MakeRasterCopy( Pixmap );  // Skia 側にコピーさせる
     Ent.Stamp := _Stamp;

     _Cache.AddOrSetValue( Key, Ent );

     Result := Ent.Img;
end;

function TLuxImageViewer.ViewCenter :TPointF;
var
   W, H :Single;
begin
     W := _ViewW;  if W < 1 then W := Width ;  // まだ一度も描いていない場合
     H := _ViewH;  if H < 1 then H := Height;

     Result := PointF( W / 2, H / 2 );
end;

procedure TLuxImageViewer.CenterImage;
var
   C :TPointF;
begin
     if not Assigned( _Image ) or ( _Image.Width < 1 ) or ( _Image.Height < 1 ) then Exit;

     C := ViewCenter;

     _Origin := PointF( ( _Image.Width  - C.X * 2 / _Scale ) / 2,
                        ( _Image.Height - C.Y * 2 / _Scale ) / 2 );
end;

procedure TLuxImageViewer.DoFit( const W_,H_:Single );
begin
     if not Assigned( _Image ) or ( _Image.Width < 1 ) or ( _Image.Height < 1 ) then Exit;

     if ( W_ < 1 ) or ( H_ < 1 ) then Exit;

     _Scale := Clamp( Min( W_ / _Image.Width, H_ / _Image.Height ), _MinScale, _MaxScale );

     _Origin := PointF( ( _Image.Width  - W_ / _Scale ) / 2,
                        ( _Image.Height - H_ / _Scale ) / 2 );
end;

procedure TLuxImageViewer.SweepCache;
var
   Key  :TTileKey;
   Ent  :TTileImg;
   Dies :TArray<TTileKey>;
begin
     if _Cache.Count <= CACHE_MAX then Exit;

     Dies := [];

     for Key in _Cache.Keys do
     begin
          _Cache.TryGetValue( Key, Ent );

          if Ent.Stamp < _Stamp then Dies := Dies + [ Key ];
     end;

     for Key in Dies do _Cache.Remove( Key );
end;

procedure TLuxImageViewer.DropCache;
begin
     _Cache.Clear;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TLuxImageViewer.Create( AOwner_:TComponent );
var
   E :String;
begin
     inherited;

     _Image      := nil;
     _Version    := 0;
     _Scale      := 1;
     _Origin     := PointF( 0, 0 );
     _Gamma      := 1;
     _ToneMap    := False;
     _White      := 1;
     _Background := $FF202020;
     _MinScale   := 1 / 4096;
     _MaxScale   := 256;
     _Stamp      := 0;
     _Draggin    := False;
     _MouseOn    := False;
     _ViewW      := 0;
     _ViewH      := 0;

     _DrawCached    := False;
     _DrawCacheKind := TSkDrawCacheKind.Never;  // 画は毎フレーム描き直す（拡縮・移動が主用途）

     _Cache := TDictionary<TTileKey,TTileImg>.Create;

     _Effect := TSkRuntimeEffect.MakeForColorFilter( SKSL_TONE, E );

     if not Assigned( _Effect ) then
       raise Exception.Create( 'SkSL のコンパイルに失敗： ' + E );

     HitTest     := True;   // フレーム自身がマウスを受け取る
     CanFocus    := True;
     AutoCapture := True;   // 枠外で放しても MouseUp を受け取る
end;

destructor TLuxImageViewer.Destroy;
begin
     if Assigned( _Image ) then _Image.OnChange.Del( ImageChanged );

     _Cache.Free;
     _Buffer.Free;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TLuxImageViewer.FitToWindow;
begin
     _NeedFit := True;  Redraw;  // 実際の描画矩形が判る描画時に行う
end;

procedure TLuxImageViewer.ZoomAt( const P_:TPointF; const Factor_:Single );
var
   Q :TPointF;
   S :Single;
begin
     Q := ViewToImage( P_ );  // 固定したい画像座標

     S := Clamp( _Scale * Factor_, _MinScale, _MaxScale );

     if S = _Scale then Exit;

     _Scale  := S;
     _Origin := PointF( Q.X - P_.X / S, Q.Y - P_.Y / S );

     Redraw;
end;

procedure TLuxImageViewer.ZoomWheel( const WheelDelta_:Integer );
var
   P :TPointF;
begin
     if _MouseOn then P := _MouseP
                 else P := ViewCenter;  // マウスがまだ乗っていないうちは中心を固定

     ZoomAt( P, Power( 2, -WheelDelta_ / 120 / 4 ) );  // 手前へ回すと拡大。ノッチ４段で２倍
end;

function TLuxImageViewer.ViewToImage( const P_:TPointF ) :TPointF;
begin
     Result := PointF( _Origin.X + P_.X / _Scale,
                       _Origin.Y + P_.Y / _Scale );
end;

function TLuxImageViewer.ImageToView( const P_:TPointF ) :TPointF;
begin
     Result := PointF( ( P_.X - _Origin.X ) * _Scale,
                       ( P_.Y - _Origin.Y ) * _Scale );
end;

///// TSkCustomControl.Redraw に相当する。キャッシュを捨てて描き直させる。

procedure TLuxImageViewer.Redraw;
begin
     _DrawCached := False;  Repaint;
end;

end. //######################################################################### ■
