unit Ppabout;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TPowerPanelAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    Copyright: TLabel;
    Comments: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PowerPanelAboutBox: TPowerPanelAboutBox;

implementation

{$R *.DFM}

end.
 
