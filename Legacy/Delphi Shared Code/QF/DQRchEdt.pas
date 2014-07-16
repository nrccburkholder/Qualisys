unit DQRchEdt;  { TDQRichEdit component. }
{ Created 12/10/97 10:04:15 AM }
{ Eagle Software CDK, Version 2.02 Rev. C }

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
  TDQRichEdit = class(trichedit)
  private
    { Private declarations }
    FQstnCore: integer;
    FScaleID: integer;
    FScalePos: integer;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property QstnCore: integer read FQstnCore write FQstnCore;  { Run-time access only }
    property ScaleID: integer read FScaleID write FScaleID;  { Run-time access only }
    property ScalePos: integer read FScalePos write FScalePos;  { Run-time access only }
  published
    { Published properties and events }
  end;  { TDQRichEdit }

procedure Register;

implementation

destructor TDQRichEdit.Destroy;
begin
  { CDK: Free allocated memory and created objects here. }
  inherited Destroy;
end;  { Destroy }

constructor TDQRichEdit.Create(AOwner: TComponent); 
{ Creates an object of type TDQRichEdit, and initializes properties. }
begin
  inherited Create(AOwner);
  { CDK: Add your initialization code here. }
end;  { Create }

procedure Register;
begin
  RegisterComponents('NRC', [TDQRichEdit]);
end;  { Register }

end.
