unit LUX.Data;

interface //#################################################################### ■

uses System.Classes;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

procedure WriteLine( const Stream_:TStream; const Line_:String );  // UTF-8 の1行（LF 終端）を書き込む
function ReadLine( const Stream_:TStream ) :String;                // UTF-8 の1行（LF まで。CR は捨てる）を読み込む

procedure WriteHead( const Stream_:TStream; const Magic_:String; const Options_:TArray<String> );  // ヘッダ（magic ＋ オプション行 ＋ 空行）を書き込む
function ReadHead( const Stream_:TStream; const Magic_:String ) :TArray<String>;  // magic を検証し（不一致は EInOutError）、空行までのオプション行を返す

implementation //############################################################### ■

uses System.SysUtils;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WriteLine / ReadLine

procedure WriteLine( const Stream_:TStream; const Line_:String );
var
   B :TBytes;
begin
     B := TEncoding.UTF8.GetBytes( Line_ + Char( 10 ) );

     Stream_.WriteBuffer( B[ 0 ], Length( B ) );
end;

function ReadLine( const Stream_:TStream ) :String;
var
   B :TBytes;
   C :Byte;
begin
     B := [];

     while Stream_.Read( C, 1 ) = 1 do
     begin
          if C = 10 then Break;

          if C <> 13 then B := B + [ C ];
     end;

     Result := TEncoding.UTF8.GetString( B );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WriteHead / ReadHead

procedure WriteHead( const Stream_:TStream; const Magic_:String; const Options_:TArray<String> );
var
   L :String;
begin
     WriteLine( Stream_, Magic_ );

     for L in Options_ do WriteLine( Stream_, L );

     WriteLine( Stream_, '' );  // 空行から後ろはバイナリ
end;

function ReadHead( const Stream_:TStream; const Magic_:String ) :TArray<String>;
var
   L :String;
begin
     if ReadLine( Stream_ ) <> Magic_ then raise EInOutError.Create( 'ヘッダが ' + Magic_ + ' ではない' );

     Result := [];

     while Stream_.Position < Stream_.Size do
     begin
          L := ReadLine( Stream_ );

          if L = '' then Exit;  // 空行から後ろはバイナリ

          Result := Result + [ L ];
     end;
end;

end. //######################################################################### ■
