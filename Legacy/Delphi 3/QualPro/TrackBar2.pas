unit TrackBar2;  { TDQTrackBar component. }
{ Created 12/23/97 3:19:26 PM }
{ Eagle Software CDK, Version 2.02 Rev. C }

{$D-}
{$L-}
interface

uses
  Windows, 
  SysUtils, 
  Messages, 
  Classes, 
  Graphics, 
  Controls, 
  Forms, 
  Dialogs, 
  Menus, 
  ComCtrls;

type
  TDQTrackBar = class(ttrackbar)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published properties and events }
    { Inherited events: }
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;  { TDQTrackBar }

procedure Register;

implementation

destructor TDQTrackBar.Destroy;
begin
  { CDK: Free allocated memory and created objects here. }
  inherited Destroy;
end;  { Destroy }

constructor TDQTrackBar.Create(AOwner: TComponent); 
{ Creates an object of type TDQTrackBar, and initializes properties. }
begin
  inherited Create(AOwner);
  { CDK: Add your initialization code here. }
end;  { Create }

procedure Register;
begin
  RegisterComponents('NRC', [TDQTrackBar]);
end;  { Register }

end.
