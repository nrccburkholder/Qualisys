unit DQPnl;  { TDQPanel component. }
{ Created 12/10/97 9:58:00 AM }
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
  ExtCtrls;

type
  TDQPanel = class(TPanel)
  private
    { Private declarations }
    FModified: boolean;
    FKnownDimensions: boolean;
    FTextBoxName: string;
    FTextBoxMappings: string;
    FPCL: string;
    FLanguage: integer;
    FIndent: integer;
    procedure SetIndent(newValue: integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Modified: boolean read FModified write FModified default false;  { Run-time access only }
    property KnownDimensions: boolean read FKnownDimensions write FKnownDimensions default false;  { Run-time access only }
    property TextBoxName: string read FTextBoxName write FTextBoxName;  { Run-time access only }
    property TextBoxMappings: string read FTextBoxMappings write FTextBoxMappings;  { Run-time access only }
    property PCL: string read FPCL write FPCL;  { Run-time access only }
    property Language: integer read FLanguage write FLanguage;  { Run-time access only }
  published
    { Published properties and events }
    property Indent: integer read FIndent write SetIndent default 0;
  end;  { TDQPanel }

procedure Register;

implementation

procedure TDQPanel.SetIndent(newValue: integer);
{ Sets data member FIndent to newValue. }
begin
  if FIndent <> newValue then
  begin
    FIndent := newValue;
    { CDK: Add display update code here if needed. }
  end;
end;  { SetIndent }

destructor TDQPanel.Destroy;
begin
  { CDK: Free allocated memory and created objects here. }
  inherited Destroy;
end;  { Destroy }

constructor TDQPanel.Create(AOwner: TComponent);
{ Creates an object of type TDQPanel, and initializes properties. }
begin
  inherited Create(AOwner);
  { Initialize properties with default values: }
  FTextBoxName := '';
  FModified := false;
  FKnownDimensions := false;
  FIndent := 0;
  { CDK: Add your initialization code here. }
end;  { Create }

procedure Register;
begin
  RegisterComponents('NRC', [TDQPanel]);
end;  { Register }

end.
