unit fValidMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmValidMsg = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //ViewState:short;
    { Private declarations }
  public
    PersonalizationHandle:hwnd;
    { Public declarations }
  end;

var
  frmValidMsg: TfrmValidMsg;

implementation

{$R *.DFM}

procedure TfrmValidMsg.Timer1Timer(Sender: TObject);
//var r:tRect;
    //v:LongInt;
begin
  if PersonalizationHandle > 0 then
  begin
    repeat
      application.ProcessMessages;
    until IsWindowVisible(PersonalizationHandle) or (not IsWindow(PersonalizationHandle));
    //if GetWindowRect(PersonalizationHandle,r) then
      //BoundsRect := r;
    //windows.SetParent(PersonalizationHandle,Handle);
    SetWindowPos(PersonalizationHandle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
    Windows.BringWindowToTop(PersonalizationHandle);
    //repeat
    //  application.ProcessMessages;
    //until (not IsWindow(PersonalizationHandle));
  end;
  PersonalizationHandle := 0;
  close;
end;

procedure TfrmValidMsg.FormCreate(Sender: TObject);
begin
  PersonalizationHandle:=0;
{  ViewState := 1;
  top := screen.height+1;
  left := (screen.width div 2) - (width div 2);
}
end;

end.
