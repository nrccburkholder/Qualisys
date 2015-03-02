unit Packtest;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, DBTables, Wwtable, packdlgs,
  Grids, Wwdbigrd, Wwdbgrid, Wwdatsrc, ExtCtrls;

type
  TPackMain = class(TForm)
    PackTable: TwwTable;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    wwDataSource1: TwwDataSource;
    TableList: TwwDBGrid;
    ResultsTable: TwwTable;
    Panel1: TPanel;
    AliasLabel: TLabel;
    Panel2: TPanel;
    AliasName: TLabel;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
     initialized: boolean;
     procedure CreateResultsTable;
  public
    { Public declarations }
  end;

var
  PackMain: TPackMain;

implementation

{$R *.DFM}

procedure TPackMain.BitBtn1Click(Sender: TObject);
var statusMsg: string;
begin
   PackTable.databaseName:= AliasName.caption;

   ResultsTable.first;
   while not ResultsTable.eof do begin
      PackTable.tableName:= ResultsTable.fieldByName('Table Name').text;
      ResultsTable.edit;
      if not PackTable.pack(StatusMsg) then
         ResultsTable.fieldByName('Pack Status').text:= StatusMsg
      else ResultsTable.fieldByName('Pack Status').text:= 'Success';
      ResultsTable.post;
      ResultsTable.next;
   end;
end;

procedure TPackMain.BitBtn2Click(Sender: TObject);
var databaseName: string;
    tableList: TStrings;
    i: integer;
begin
   tableList:= TStringList.create;
   databaseName:= Aliasname.caption;

   ResultsTable.disableControls;
   ResultsTable.first;
   while not ResultsTable.eof do begin
      tableList.add(ResultsTable.fieldByName('Table Name').text);
      resultsTable.next;
   end;
   ResultsTable.enableControls;

   if wwGetTablesDlg(databaseName, tableList) then begin
      CreateResultsTable;
      for i:= tableList.count-1 downto 0 do begin
         ResultsTable.insert;
         ResultsTable.fieldByName('Table Name').text:= tableList[i];
         ResultsTable.post;
      end;
      AliasName.caption:= databaseName;
      tableList.free;
   end
end;

procedure TPackMain.CreateResultsTable;
begin
   with ResultsTable do begin
      ResultsTable.active:= False;
      databaseName:= Session.PrivateDir;
      tableName:= 'packrslt.db';
      TableType:= ttDefault;
      FieldDefs.clear;
      FieldDefs.add('Table Name', ftString,  15, False);
{      FieldDefs.add('Table Size', ftInteger,  0, False);}
      FieldDefs.add('Pack Status', ftString, 35, False);
      IndexDefs.clear;
      CreateTable;
      Active:= True;
   end
end;

procedure TPackMain.FormActivate(Sender: TObject);
begin
   if not initialized then CreateResultsTable;
   initialized:= True;
end;

end.
