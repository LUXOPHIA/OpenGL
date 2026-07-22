unit LUX.Curve.Data.Grid.D1;

interface //#################################################################### ■

uses LUX,
     LUX.Data.Grid.D1,
     LUX.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

     TCurve<_TPoin_> = class
     private
     protected
       type TWector = TDoubleWector<_TPoin_>;
       type TPoins  = TPoins<_TPoin_>;
     protected
       _Poins :TPoins;
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins; virtual;
       procedure SetPoins( const Poins_:TPoins ); virtual;
       ///// M E T H O D
       function Segment( const I_:Integer; const T_:Double ) :_TPoin_; virtual; abstract;
     public
       constructor Create;
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property Poins :TPoins read GetPoins write SetPoins;
       ///// M E T H O D
       function Value( const X_:Double ) :_TPoin_; virtual;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TCurve<_TPoin_>.UpPoins( Sender_:TObject );
begin
     _OnChange.Run( Self );
end;

function TCurve<_TPoin_>.GetPoins :TPoins;
begin
     Result := _Poins;
end;

procedure TCurve<_TPoin_>.SetPoins( const Poins_:TPoins );
begin
     if _Poins = Poins_ then Exit;

     if Assigned( _Poins ) then _Poins.OnChange.Del( UpPoins );

     _Poins := Poins_;

     if Assigned( _Poins ) then _Poins.OnChange.Add( UpPoins );

     UpPoins( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurve<_TPoin_>.Create;
begin
     inherited;

     Poins := nil;
end;

destructor TCurve<_TPoin_>.Destroy;
begin
     Poins := nil;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurve<_TPoin_>.Value( const X_:Double ) :_TPoin_;
var
   i :Integer;
   t :Double;
begin
     i := Floor( X_ );  t := X_ - I;

     Result := Segment( i, t );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■