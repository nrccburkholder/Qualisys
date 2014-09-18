unit fPssWrd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmPassWord = class(TForm)
    Label1: TLabel;
    EditPassWord: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassWord: TfrmPassWord;

implementation

{$R *.DFM}

procedure TfrmPassWord.Button1Click(Sender: TObject);
begin
  close;
end;

end.
