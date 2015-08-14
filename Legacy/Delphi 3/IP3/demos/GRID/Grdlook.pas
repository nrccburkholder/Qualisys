unit GrdLook;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DBTables, DB, wwstr, StdCtrls,
  Buttons, {dbiProcs, dbiTypes,} DBLookup, Wwkeycb, Wwdbgrid,
  Wwtable, Wwdblook, Wwdbigrd, Wwdatsrc, Wwdbdlg, ExtCtrls,
  TabNotBk, DBCtrls, IniFiles, wwidlg, wwcaldlg, Wwdotdot, Wwdbcomb, Mask,
  Wwdbedit, ComCtrls, wwrcdvw, Menus;

type
  TGridDemo = class(TForm)
    CustomerTable: TwwTable;
    ZipTable: TwwTable;
    CustomerSource: TwwDataSource;
    wwDBLookupCombo1: TwwDBLookupCombo;
    TabbedNotebook1: TTabbedNotebook;
    wwDBGrid1: TwwDBGrid;
    wwDBGrid2: TwwDBGrid;
    Memo1: TMemo;
    Memo2: TMemo;
    wwDBLookupCombo2: TwwDBLookupCombo;
    wwLookupDialog1: TwwLookupDialog;
    Button1: TButton;
    wwDBGrid3: TwwDBGrid;
    wwDBComboDlg1: TwwDBComboDlg;
    BitBtn2: TBitBtn;
    Memo3: TMemo;
    CustomerTableCustomerNo: TIntegerField;
    CustomerTableBuyer: TStringField;
    CustomerTableCompanyName: TStringField;
    CustomerTableFirstName: TStringField;
    CustomerTableLastName: TStringField;
    CustomerTableStreet: TStringField;
    CustomerTableCity: TStringField;
    CustomerTableState: TStringField;
    CustomerTableZip: TStringField;
    CustomerTableFirstContactDate: TDateField;
    CustomerTablePhoneNumber: TStringField;
    CustomerTableInformation: TMemoField;
    CustomerTableRequestedDemo: TStringField;
    CustomerTableLogical: TBooleanField;
    ZipTableZIP: TStringField;
    ZipTableCITY: TStringField;
    ZipTableSTATE: TStringField;
    CustomerTableZipCity: TStringField;
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure wwLookupDialog1UserButton1Click(Sender: TObject;
      LookupTable: TDataSet);
    procedure wwDBComboDlg1CustomDlg(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure wwDBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
  public
  end;

var
  GridDemo: TGridDemo;

implementation

{$R *.DFM}


{ Demo program uses two grids connected to the same table              }
{ This code causes each grid to display slightly different fields      }
procedure TGridDemo.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
   { Post to prevent record from locking twice}
   if CustomerTable.modified then CustomerTable.post;
end;

procedure TGridDemo.FormShow(Sender: TObject);
begin
   TabbedNotebook1.pageIndex:= 0;
end;

{Lookup and fill when button is clicked }
procedure TGridDemo.Button1Click(Sender: TObject);
begin
   with wwLookupDialog1 do begin
      (LookupTable as TwwTable).indexname:= '';
      (LookupTable as TwwTable).wwFindKey([CustomerTableZip.asString]);
      if execute then begin
         CustomerTable.edit;
         CustomerTableZip.asString := LookupTable.fieldByName('Zip').asString;
         CustomerTableCity.asString := LookupTable.fieldByName('City').asString;
         CustomerTableState.asString:= LookupTable.fieldByName('State').asString;
      end
   end
end;

procedure TGridDemo.wwLookupDialog1UserButton1Click(Sender: TObject;
  LookupTable: TDataSet);
begin
   MessageDlg('Attach any code you want to this button.', mtinformation, [mbok], 0);
end;

procedure TGridDemo.wwDBComboDlg1CustomDlg(Sender: TObject);
begin
   wwCalendarComboDlg(Sender as TwwDBComboDlg);
end;

procedure TGridDemo.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

procedure TGridDemo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CustomerTable.CheckBrowseMode;
end;

{ The following code, though not executed in the demo, shows how you
  can force an automatic exit of a grid column after a certain number of
  characters have been entered.
}
procedure TGridDemo.wwDBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);

   Function isValidChar(key: word): boolean;
   begin
      result:= (key = VK_BACK) or (key=VK_SPACE) or (key=VK_DELETE) or
               ((key >= ord('0')) and (key<=VK_DIVIDE));
   end;

begin
  { Exits grid column after 2 characters typed into City field }
   with (Sender as TwwDBGrid) do begin
      if GetActiveField.FieldName='City' then
      begin
         if not isValidChar(key) then exit;
         if length(InplaceEditor.Text)>=2 then begin
           SelectedIndex:= SelectedIndex + 1;
         end
      end
   end
end;

end.
