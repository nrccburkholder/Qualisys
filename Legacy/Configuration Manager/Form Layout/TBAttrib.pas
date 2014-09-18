unit TBAttrib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmTextBoxAttributes = class(TForm)
    PageControl1: TPageControl;
    tsBorder: TTabSheet;
    pnlButtons: TPanel;
    UpDown1: TUpDown;
    edBorderWidth: TEdit;
    pnlShading: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure clearPanels(var p:tPanel);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTextBoxAttributes: TfrmTextBoxAttributes;

implementation

{$R *.DFM}

procedure tfrmTextBoxAttributes.clearPanels(var p:tPanel);
begin
  Panel1.caption := '';
  Panel2.caption := '';
  Panel3.caption := '';
  Panel4.caption := '';
  Panel5.caption := '';
  Panel6.caption := '';
  Panel7.caption := '';
  p.caption := 'ü';
  pnlShading.tag := p.color;
end;

procedure TfrmTextBoxAttributes.Panel1Click(Sender: TObject);
begin
  ClearPanels(Panel1);
end;

procedure TfrmTextBoxAttributes.Panel2Click(Sender: TObject);
begin
  ClearPanels(Panel2);
end;

procedure TfrmTextBoxAttributes.Panel3Click(Sender: TObject);
begin
  ClearPanels(Panel3);
end;

procedure TfrmTextBoxAttributes.Panel4Click(Sender: TObject);
begin
  ClearPanels(Panel4);
end;

procedure TfrmTextBoxAttributes.Panel5Click(Sender: TObject);
begin
  ClearPanels(Panel5);
end;

procedure TfrmTextBoxAttributes.Panel6Click(Sender: TObject);
begin
  ClearPanels(Panel6);
end;

procedure TfrmTextBoxAttributes.Panel7Click(Sender: TObject);
begin
  ClearPanels(Panel7);
end;

procedure TfrmTextBoxAttributes.FormActivate(Sender: TObject);
begin
  case pnlShading.tag of
    clWhite : ClearPanels(Panel1);
    $E9E9E9 : ClearPanels(Panel2);
    $DFDFDF : ClearPanels(Panel3);
    $D4D4D4 : ClearPanels(Panel4);
    $C9C9C9 : ClearPanels(Panel5);
    $BFBFBF : ClearPanels(Panel6);
    $B4B4B4 : ClearPanels(Panel7);
  end;
end;

end.
