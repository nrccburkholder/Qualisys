unit FSearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls;

type
  TfrmSearch = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    CBCore: TCheckBox;
    CBShort: TCheckBox;
    CBHeading: TCheckBox;
    CBScale: TCheckBox;
    CBLong: TCheckBox;
    rgAndOr: TRadioGroup;
    Bevel1: TBevel;
    SearchFor: TStringGrid;
    FirstBtn: TButton;
    NextBtn: TButton;
    Cancel: TButton;
    ClearBtn: TButton;
    Label1: TLabel;
    procedure CancelClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FirstBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SearchForKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSearch: TfrmSearch;
  FromTheTop : boolean;

implementation

{$R *.DFM}

procedure TfrmSearch.CancelClick(Sender: TObject);
begin
  ClearBtnClick(sender);
  close;
end;

procedure TfrmSearch.NextBtnClick(Sender: TObject);
begin
  FromTheTop := false;
  close;
end;

procedure TfrmSearch.FirstBtnClick(Sender: TObject);
begin
  FromTheTop := true;
  close;
end;

procedure TfrmSearch.ClearBtnClick(Sender: TObject);
var i : integer;
begin
  CBCore.checked := false;
  CBHeading.checked := false;
  CBLong.checked := false;
  CBScale.checked := false;
  CBShort.checked := false;
  for i := 0 to SearchFor.RowCount-1 do searchfor.cells[0,i] := '';
end;

procedure TfrmSearch.SearchForKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_return then FirstBtnClick(Sender);
end;

end.
