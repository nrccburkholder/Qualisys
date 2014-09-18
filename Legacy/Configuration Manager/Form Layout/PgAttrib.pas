unit PgAttrib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmPageAttributes = class(TForm)
    PageControl1: TPageControl;
    tsBorder: TTabSheet;
    pnlButtons: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edPageName: TEdit;
    rgPaperType: TRadioGroup;
    rgPostcardSize: TRadioGroup;
    rgIntegrated: TRadioGroup;
    procedure rgPaperTypeClick(Sender: TObject);
    procedure edPageNameExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPageAttributes: TfrmPageAttributes;

implementation

{$R *.DFM}

procedure TfrmPageAttributes.rgPaperTypeClick(Sender: TObject);
begin
  rgIntegrated.enabled := (rgPaperType.itemindex = 0);
  rgPostcardSize.enabled := not (rgPaperType.itemindex = 0);
  if (rgIntegrated.enabled) and (rgIntegrated.itemindex = -1) then
    rgIntegrated.itemindex := 0;
  if rgPostcardSize.enabled and (rgPostcardSize.itemindex = -1) then
    rgPostcardSize.itemindex := 0;
end;

procedure TfrmPageAttributes.edPageNameExit(Sender: TObject);
begin
  if edpageName.text = '' then begin
    messagebeep(0);
    messagedlg('The Page Name cannot be empty!',mterror,[mbok],0);
    frmPageAttributes.activecontrol := edPageName;
  end;
end;

end.
