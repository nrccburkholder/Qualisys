unit Wwgttbl;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, db, dbtables, dialogs, sysutils, ExtCtrls;

type
  TGetTableForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    DBListBox: TListBox;
    TableListBox: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    UseTableExtension: TCheckBox;
    procedure DBListBoxClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TableListBoxDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function wwGetTableDlg(
   var databaseName: string;
   var tablename: string;
   var useExtension: char): Boolean;

implementation

{$R *.DFM}

uses wwcommon;

function wwGetTableDlg(
   var databaseName: string;
   var tablename: string;
   var useExtension: char): Boolean;
begin
   with TGetTableForm.create(Application) do
   try
      Session.getDatabaseNames(DBListBox.Items);
      DBListBox.itemIndex:= DBListBox.items.indexof(databaseName);
      if DBListBox.itemIndex>=0 then begin
         TableListBox.clear;
         Session.getTableNames(DBListBox.Items[DBListBox.itemIndex],
             '', True {Extensions}, False, TableListBox.items);

         TableListBox.itemIndex:= TableListBox.items.indexof(tableName);
      end;

      useTableExtension.checked:= useExtension<>'N';
      Result := ShowModal = IDOK;

      if Result then begin
         databaseName:= DBListBox.items[DBListBox.itemIndex];
         tableName:= TableListBox.items[TableListBox.itemIndex];
         if useTableExtension.checked then useExtension:='Y'
         else useExtension:='N';
      end;

   finally
      Free;
   end
end;


procedure TGetTableForm.DBListBoxClick(Sender: TObject);
var lastIndex: integer;
begin
   lastIndex:= DBListBox.itemIndex;
   TableListBox.clear;
   Session.getTableNames(DBListBox.Items[DBListBox.itemIndex], '', True {Extensions}, False,
          TableListBox.items);

   { A Delphi bug FT5 makes the following line necessary to  }
   { properly retain highlight on selected object!       }
   DBListBox.itemIndex:= lastIndex;
end;

procedure TGetTableForm.OKBtnClick(Sender: TObject);
var table1: TTable;
begin
   if (DBListBox.itemIndex<0) or (TableListBox.itemIndex<0) then begin
      MessageDlg('Please select a table.', mtInformation, [mbok], 0);
      ModalResult:= mrNone;
      exit;
   end;

   table1:= TTable.create(self);
   table1.databasename:= DBListBox.items[DBListBox.itemIndex];
   table1.tableName:= TableListBox.items[TableListBox.itemIndex];
   Table1.IndexDefs.update;  { refreshes Index list }
   if Table1.IndexDefs.count>0 then begin
      table1.free;
      ModalResult:= IDOK;
   end
   else begin
      table1.free;
      MessageDlg('Please select a table with a primary or secondary index.',
                 mtInformation, [mbok], 0);
      ModalResult:= mrNone;
   end

end;

procedure TGetTableForm.TableListBoxDblClick(Sender: TObject);
begin
{   mrResult:= mrOK;}
end;

procedure TGetTableForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Select Linked Table Dialog Box')
end;

end.
