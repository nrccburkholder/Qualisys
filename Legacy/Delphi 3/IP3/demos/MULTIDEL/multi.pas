unit Multi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBTables, DB, Grids, Wwdbigrd, Wwdbgrid,
  Wwtable, Wwdatsrc, Buttons, ComCtrls, wwriched;

type
  TMultiSelectForm = class(TForm)
    wwDataSource1: TwwDataSource;
    wwTable1: TwwTable;
    wwDBGrid1: TwwDBGrid;
    DeleteButton: TButton;
    wwTable1Code: TStringField;
    wwTable1Description: TStringField;
    wwTable1Selected: TBooleanField;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    BitBtn2: TBitBtn;
    wwDBRichEdit1: TwwDBRichEdit;
    procedure DeleteButtonClick(Sender: TObject);
    procedure PopulateTableButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure CheckBox3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    procedure PopulateTable;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  MultiSelectForm: TMultiSelectForm;

implementation

{$R *.DFM}

{ Delete Selected Records }
procedure TMultiSelectForm.DeleteButtonClick(Sender: TObject);
var i: integer;
begin
   with wwdbgrid1, wwdbgrid1.datasource.dataset do begin
      DisableControls;     { Disable controls to improve performance }
      for i:= 0 to SelectedList.Count-1 do begin
         GotoBookmark(SelectedList.items[i]);
         Freebookmark(SelectedList.items[i]);
         Delete;           { Delete Record }
      end;
      SelectedList.clear;  { Clear selected record list since they are all deleted}
      EnableControls;      { Reenable controls }
   end;
end;

procedure TMultiSelectForm.PopulateTableButtonClick(Sender: TObject);
begin
   PopulateTable;
end;

{ Regenerate table for demo  - This code would not be needed in your application.}
Procedure TMultiSelectForm.PopulateTable;
var i: integer;
    computeCode: integer;
begin
   wwdbgrid1.SelectedList.clear;  { Clear selected list }

   { Create table for demo }
   with wwtable1 do begin
      wwtable1.active:= False;
      databaseName:= 'infodemo';
      tableName:= 'multitst.db';
      TableType:= ttDefault;
      FieldDefs.clear;
      FieldDefs.add('Code', ftString,  5, False);
      FieldDefs.add('Description', ftString, 25, False);
      IndexDefs.clear;
      IndexDefs.add('', 'Code', [ixPrimary, ixUnique]);
      CreateTable;
      Active:= True;
   end;

   { Add 100 random records }
   Randomize;
   wwtable1.DisableControls;
   for i:= 1 to 100 do begin
      computeCode:= Random(32767);
      if not wwtable1.findkey([computeCode]) then
      begin
         wwtable1.insert;
         wwtable1.fieldbyName('Code').asString:= inttostr(computeCode);
         wwtable1.fieldbyName('Description').asString:= 'Description for ' + inttostr(computeCode);
         wwtable1.checkBrowseMode;
      end
   end;
   wwtable1.EnableControls;

   wwtable1.First;

end;

procedure TMultiSelectForm.FormShow(Sender: TObject);
begin
   PopulateTable;
end;

procedure TMultiSelectForm.wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
   if (Field.FieldName='Selected') then
      ABrush.Color:= clBtnFace
   else if  (not highlight) and (Sender as TwwDBGrid).isSelected then begin
      ABrush.Color:= clYellow;
      AFont.Color:= clBlack;
   end;
end;

procedure TMultiSelectForm.CheckBox3Click(Sender: TObject);
begin
   with wwdbgrid1, wwdbgrid1.datasource.dataset do
   begin
      fieldByName('selected').visible:= TCheckbox(Sender).checked;
      SizeLastColumn;
   end;
end;

procedure TMultiSelectForm.Button1Click(Sender: TObject);
begin
   wwdbgrid1.selectAll;
end;

procedure TMultiSelectForm.Button2Click(Sender: TObject);
begin
   wwdbgrid1.unselectAll;
end;

procedure TMultiSelectForm.CheckBox1Click(Sender: TObject);
begin
   with wwdbgrid1 do
      if TCheckbox(Sender).checked then
          MultiSelectOptions:= MultiSelectOptions + [msoShiftSelect]
      else
          MultiSelectOptions:= MultiSelectOptions - [msoShiftSelect]
end;

procedure TMultiSelectForm.CheckBox2Click(Sender: TObject);
begin
   with wwdbgrid1 do
      if TCheckbox(Sender).checked then
          MultiSelectOptions:= MultiSelectOptions + [msoAutoUnselect]
      else
          MultiSelectOptions:= MultiSelectOptions - [msoAutoUnselect]

end;

procedure TMultiSelectForm.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

end.
