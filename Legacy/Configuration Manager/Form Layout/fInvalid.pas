unit fInvalid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Common;

type
  TfrmInvalid = class(TForm)
    Panel1: TPanel;
    cmdOK: TButton;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInvalid: TfrmInvalid;

implementation

{$R *.DFM}

procedure TfrmInvalid.FormResize(Sender: TObject);
begin
  cmdOK.left := (width div 2) - (cmdOK.width div 2);
end;

procedure TfrmInvalid.SpeedButton1Click(Sender: TObject);
var
  zExePath : array[0..127] of char;
begin
  memo1.Lines.SaveToFile(aliaspath('PRIV')+'\report.tmp');
  WinExec(strPcopy(zExePath,'notepad ' + aliaspath('PRIV')+'\report.tmp'),sw_shownormal);
end;

end.
