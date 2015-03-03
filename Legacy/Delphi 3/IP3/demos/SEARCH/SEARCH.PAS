unit Search;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Buttons, Wwlocate, DBTables, Wwtable, Mask,
  ExtCtrls, Menus, Wwkeycb;

type
  TIncrSearch = class(TForm)
    DataSource1: TDataSource;
    Panel2: TPanel;
    wwTable1: TwwTable;
    Panel1: TPanel;
    wwKeyCombo1: TwwKeyCombo;
    wwIncrementalSearch1: TwwIncrementalSearch;
    Label12: TLabel;
    Label13: TLabel;
    DBEdit2: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo2: TMemo;
    CancelBtn: TBitBtn;
    procedure wwKeyCombo1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  IncrSearch: TIncrSearch;

implementation

{$R *.DFM}

procedure TIncrSearch.wwKeyCombo1Change(Sender: TObject);
begin
   wwIncrementalSearch1.text:= '';
   wwIncrementalSearch1.setFocus;
end;

end.
