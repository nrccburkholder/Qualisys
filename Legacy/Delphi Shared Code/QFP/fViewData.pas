unit fViewData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, StdCtrls, ExtCtrls;

type
  TfrmViewData = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Splitter1: TSplitter;
    Memo1: TMemo;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
  private
    { Private declarations }
    dbGridHeight : real;
  public
    { Public declarations }
  end;

var
  frmViewData: TfrmViewData;

implementation

{$R *.DFM}

procedure TfrmViewData.DBGrid1DblClick(Sender: TObject);
var s : string;
    i : integer;
begin
    memo1.lines.clear;
    with datasource1.dataset do begin
      disablecontrols;
      first;
      s := '';
      for i := 0 to fieldcount-1 do
        if not (fields[i].datatype in [ftBlob,ftMemo,ftGraphic,ftFmtMemo,ftParadoxOle,ftDBaseOle,ftTypedBinary]) then
          s := s + '"'+Fields[i].fieldname+'",';
      memo1.lines.add(s);
      while not eof do begin
        s := '';
        for i := 0 to FieldCount-1 do
          if not (fields[i].datatype in [ftBlob,ftMemo,ftGraphic,ftFmtMemo,ftParadoxOle,ftDBaseOle,ftTypedBinary]) then
            s := s + '"'+Fields[i].asstring+'",';
        memo1.lines.add(s);
        next;
      end;
      enablecontrols;
    end;
end;

procedure TfrmViewData.FormResize(Sender: TObject);
begin
  dbgrid1.height := round(height * dbGridheight);
end;

procedure TfrmViewData.FormCreate(Sender: TObject);
begin
  splitter1moved(sender);
end;

procedure TfrmViewData.Splitter1Moved(Sender: TObject);
begin
  dbGridHeight := dbGrid1.height / height;
end;

end.
