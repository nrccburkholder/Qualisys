unit fOpenStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmOpenStatus = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    ProgressBar: TProgressBar;
    Label1: TLabel;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOpenStatus: TfrmOpenStatus;

implementation

{$R *.DFM}

end.
