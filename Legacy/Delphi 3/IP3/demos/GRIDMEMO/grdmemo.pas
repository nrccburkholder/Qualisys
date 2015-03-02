unit Grdmemo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DBTables, DB, wwstr, StdCtrls,
  Buttons, Wwkeycb, Wwdbgrid,
  Wwtable, Wwdblook, Wwdbigrd, Wwdatsrc, Wwdbdlg, ExtCtrls,
  TabNotBk, DBCtrls, IniFiles, wwidlg;

type
  TGridMemoApp = class(TForm)
    CustomerTable: TwwTable;
    CustomerSource: TwwDataSource;
    wwDBGrid1: TwwDBGrid;
    Memo2: TMemo;
    CancelBtn: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure wwDBGrid1MemoOpen(Grid: TwwDBGrid;
      MemoDialog: TwwMemoDialog);
  private
  public
  end;

var
  GridMemoApp: TGridMemoApp;

implementation

{$R *.DFM}


procedure TGridMemoApp.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

procedure TGridMemoApp.wwDBGrid1MemoOpen(Grid: TwwDBGrid;
  MemoDialog: TwwMemoDialog);
begin
   with MemoDialog do begin
      DlgLeft:= 15;
   end;
end;

end.
