unit Words;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TWordForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnOk: TBitBtn;
    lblWords: TLabel;
    lblUniqueWords: TLabel;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WordForm: TWordForm;

implementation

{$R *.DFM}

procedure TWordForm.btnOkClick(Sender: TObject);
begin
  Close;
end;

end.
