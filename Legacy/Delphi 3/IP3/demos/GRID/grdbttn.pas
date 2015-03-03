unit Grdbttn;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, Wwdbigrd, Wwdbgrid, DB, DBTables, Wwtable,
  Wwdatsrc, StdCtrls, Wwkeycb, Buttons, wwrcdvw,
  ComCtrls, wwriched;

type
  TBtnGridForm = class(TForm)
    wwDataSource1: TwwDataSource;
    wwTable1: TwwTable;
    wwDBGrid1: TwwDBGrid;
    wwDBGrid1IButton: TwwIButton;
    wwRecordViewDialog1: TwwRecordViewDialog;
    wwDBRichEdit1: TwwDBRichEdit;
    procedure wwDBGrid1TitleButtonClick(Sender: TObject;
      AFieldName: string);
    procedure wwDBGrid1CalcTitleAttributes(Sender: TObject;
      AFieldName: string; AFont: TFont; ABrush: TBrush;
      var ATitleAlignment: TAlignment);
    procedure wwDBGrid1IButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BtnGridForm: TBtnGridForm;

implementation

{$R *.DFM}

uses wwstr;

procedure TBtnGridForm.wwDBGrid1TitleButtonClick(Sender: TObject;
  AFieldName: string);
begin
   wwtable1.IndexFieldName:= AFieldName;
end;

procedure TBtnGridForm.wwDBGrid1CalcTitleAttributes(Sender: TObject;
  AFieldName: string; AFont: TFont; ABrush: TBrush;
  var ATitleAlignment: TAlignment);
begin
   if (uppercase(AFieldName)=uppercase(wwtable1.indexFieldName)) then
      ABrush.Color:= clYellow;
end;

procedure TBtnGridForm.wwDBGrid1IButtonClick(Sender: TObject);
begin
  wwRecordViewDialog1.execute;
end;

end.
