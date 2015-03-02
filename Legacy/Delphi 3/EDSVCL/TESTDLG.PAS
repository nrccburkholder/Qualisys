unit Testdlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, SpellGbl, ExtCtrls;

type
  TEditSpellDialog = class(TForm)
    OKBtn: TBitBtn;
    Bevel1: TBevel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditSpellDialog: TEditSpellDialog;

implementation

{$R *.DFM}

uses
  TstMain;

procedure TEditSpellDialog.FormShow(Sender: TObject);
begin
  case Form1.SpellDlg1.DialogStyle of
    dtWordPerfect: RadioButton1.Checked := TRUE;
    dtMSWord: RadioButton2.Checked := TRUE;
    dtWordPro96: RadioButton3.Checked := TRUE;
  end;  { case }
end;

procedure TEditSpellDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if RadioButton1.Checked then Form1.SpellDlg1.Dialogstyle := dtWordPerfect
  else
  if RadioButton2.Checked then Form1.SpellDlg1.Dialogstyle := dtMSWord
  else
  if RadioButton3.Checked then Form1.SpellDlg1.Dialogstyle := dtWordPro96;
  Form1.SpellDlg1.Suggestions := 10;
end;

end.
