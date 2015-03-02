unit Packdlgs;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, db, dbtables, dialogs, sysutils, ExtCtrls;

type
  TGetTablesForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    TableListBox: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    DBListBox: TComboBox;
    SelectedTables: TListBox;
    Label3: TLabel;
    IncludeBtn: TBitBtn;
    ExcludeBtn: TBitBtn;
    procedure DBListBoxClick(Sender: TObject);
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure TableListDblClick(Sender: TObject);
    procedure SelectedTablesDblClick(Sender: TObject);
    procedure SelectedTablesClick(Sender: TObject);
  private
    { Private declarations }
    procedure IncludeItems;
{    procedure IncludeAllItems;}
    procedure ExcludeItems;
{    procedure ExcludeAllItems;}
    function InDestList(Value: string): Boolean;
    function InSrcList(Value: string): Boolean;
    procedure SelectDest(index: integer);

  public
    { Public declarations }
  end;

function wwGetTablesDlg(
   var databaseName: string;
   tableNames: TStrings): Boolean;

implementation

{$R *.DFM}

function wwGetTablesDlg(
   var databaseName: string;
   tableNames: TStrings): Boolean;
var i, thisIndex: integer;
begin
   with TGetTablesForm.create(Application) do
   try
      Session.getDatabaseNames(DBListBox.Items);
      DBListBox.itemIndex:= DBListBox.items.indexof(databaseName);
      if DBListBox.itemIndex>=0 then begin
         TableListBox.clear;
         Session.getTableNames(DBListBox.Items[DBListBox.itemIndex],
             '', True {Extensions}, False, TableListBox.items);

         { remove tableNames form list }
         for i:= 0 to tableNames.count-1 do begin
            SelectedTables.items.add(tableNames[i]);
            thisIndex:= TableListBox.items.indexOf(tableNames[i]);
            TableListBox.items.delete(thisIndex);
         end;
      end;

      Result := ShowModal = IDOK;

      if Result then begin
         databaseName:= DBListBox.items[DBListBox.itemIndex];
         tableNames.assign(SelectedTables.items);
      end;

   finally
      Free;
   end
end;



procedure TGetTablesForm.DBListBoxClick(Sender: TObject);
var lastIndex: integer;
begin
   lastIndex:= DBListBox.itemIndex;
   TableListBox.clear;
   Session.getTableNames(DBListBox.Items[DBListBox.itemIndex], '', True {Extensions}, False,
          TableListBox.items);
   SelectedTables.items.clear;
   { A Delphi bug FT5 makes the following line necessary to  }
   { properly retain highlight on selected object!       }
   DBListBox.itemIndex:= lastIndex;
end;

procedure TGetTablesForm.IncludeItems;
var
  I, LastPicked: Integer;
begin
  LastPicked:= 0; {Make compiler happy}

  with TableListBox do
  begin
    I := 0;
    while I < Items.Count do
    begin
      if Selected[I] and (not InDestList(Items[I])) then
      begin
        LastPicked := I;
        SelectedTables.Items.Add(Items[I]);

        Items.Delete(I);  {comment out to Copy items instead of Move}
      end
      else
        Inc(I);
    end;
    if Items.Count > 0 then
      if LastPicked = Items.Count then
        Selected[LastPicked-1] := True
      else
        Selected[LastPicked] := True;
{    ExAllBtn.Enabled := True;}
  end;
end;

procedure TGetTablesForm.ExcludeItems;
var
  I: Integer;
begin
  with SelectedTables do
  begin
    I := 0;
    while SelCount > 0 do
    begin
      if Selected[I] then
      begin
        TableListBox.Items.Add(Items[I]); {comment out to Copy items instead of Move}
        Items.Delete(I);
      end
      else
        Inc(I);
    end;
    ExcludeBtn.Enabled := False;
    if Items.Count = 0 then begin
{      ExAllBtn.Enabled := False;}
    end
    else begin
      SelectedTables.ItemIndex:= 0;
      SelectDest(i);  { Select close to last entry }
    end
  end;
end;


procedure TGetTablesForm.SelectDest(index: integer);
begin
   if SelectedTables.items.count=0 then index:= -1;

   if (index>=0) then begin
      with SelectedTables do begin
         if (items.count>0) and (index>=items.count) then
            index:= items.count-1; {Limit to range }

         if not Selected[index] then
            Selected[index]:= True;
      end;

      ExcludeBtn.Enabled := True;
   end
end;


function TGetTablesform.InDestList(Value: string): Boolean;
begin
  Result := False;
  if SelectedTables.Items.IndexOf(Value) > -1 then
    Result := True;
end;

function TGetTablesForm.InSrcList(Value: string): Boolean;
begin
  Result := False;
  if TableListBox.Items.IndexOf(Value) > -1 then
    Result := True;
end;


procedure TGetTablesForm.IncludeBtnClick(Sender: TObject);
begin
  IncludeItems;
end;

procedure TGetTablesForm.ExcludeBtnClick(Sender: TObject);
begin
   ExcludeItems;
end;

procedure TGetTablesForm.TableListDblClick(Sender: TObject);
var LastPicked : integer;
begin
  LastPicked:= 0; {Make compiler happy}

  with TableListBox do
  begin
    if (ItemIndex<0) then exit;

    if (not InDestList(Items[ItemIndex])) then
    begin
      begin
        LastPicked := ItemIndex;
        SelectedTables.Items.Add(Items[ItemIndex]);
        Items.Delete(ItemIndex);  {comment out to Copy items instead of Move}
      end
    end;

    if Items.Count > 0 then
      if LastPicked = Items.Count then
        Selected[LastPicked-1] := True
      else
        Selected[LastPicked] := True;
{    ExAllBtn.Enabled := True;}
  end;
end;


procedure TGetTablesForm.SelectedTablesDblClick(Sender: TObject);
var LastPicked : integer;
begin
  LastPicked:= 0;

  with SelectedTables do
  begin
    if (ItemIndex<0) then exit;

    if (not InSrcList(Items[ItemIndex])) then
    begin
      begin
        LastPicked := ItemIndex;
        TableListBox.Items.Add(Items[ItemIndex]);
        Items.Delete(ItemIndex);  {comment out to Copy items instead of Move}
      end
    end;

    if Items.Count > 0 then
      if LastPicked = Items.Count then
        Selected[LastPicked-1] := True
      else
        Selected[LastPicked] := True;
{    ExAllBtn.Enabled := True;}
  end;
end;

procedure TGetTablesForm.SelectedTablesClick(Sender: TObject);
begin
   SelectDest(SelectedTables.itemIndex)
end;

end.
