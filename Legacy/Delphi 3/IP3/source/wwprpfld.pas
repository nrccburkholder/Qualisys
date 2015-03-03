unit Wwprpfld;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, db, dbtables;

type
  TwwSelectField = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    ListBox1: TListBox;
    SortAvailCheckbox: TCheckBox;
    Label1: TLabel;
    procedure SortAvailCheckboxClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    MyDataSet: TDataSet;
    CurrentList: TStrings;
    FilterListFlag: boolean;
    AvailList: TStrings;
    procedure RefreshList;
    procedure RefreshFilteredList;
  public
  end;

var
  wwSelectField: TwwSelectField;

Function wwDlgSelectFields(AMyDataSet: TDataSet;
                           ACurrentList, selectedList: TStrings): boolean;
Function wwDlgSelectFilterFields(AAvailList: TStrings;
      ACurrentList, selectedList: TStrings): boolean;

implementation

{$R *.DFM}

uses wwstr, wwcommon;

Procedure TwwSelectField.RefreshList;
var i: integer;
begin
   Listbox1.items.clear;
   Listbox1.sorted:= not SortAvailCheckbox.checked;

   for i:= 0 to MyDataSet.FieldCount-1 do begin
      if wwGetListIndex(CurrentList, MyDataSet.Fields[i].FieldName)<0 then
         ListBox1.items.add(MyDataSet.Fields[i].FieldName);
   end;
end;

Procedure TwwSelectField.RefreshFilteredList;
var i: integer;
begin
   Listbox1.items.clear;
   Listbox1.sorted:= not SortAvailCheckbox.checked;

   for i:= 0 to AvailList.count-1 do begin
      if wwGetListIndex(CurrentList, AvailList[i])<0 then
         ListBox1.items.add(AvailList[i]);
   end;
end;


Function wwDlgSelectFields(AMyDataSet: TDataSet;
                           ACurrentList, selectedList: TStrings): boolean;
var i: integer;
begin
   with TwwSelectField.create(Application) do try
      FilterListFlag:= False;
      CurrentList:= ACurrentList;
      MyDataSet:= AMyDataSet;
      RefreshList;
      result:= showModal=mrOK;

      if result then begin
          with Listbox1 do begin
             for i:= 0 to Items.Count-1 do begin
                if Selected[I] then selectedList.add(Items[i]);
             end
          end;
      end
   finally
      Free;
   end;
end;

procedure TwwSelectField.SortAvailCheckboxClick(Sender: TObject);
begin
   if FilterListFlag then RefreshFilteredList
   else RefreshList;
end;

Function wwDlgSelectFilterFields(AAvailList: TStrings;
      ACurrentList, selectedList: TStrings): boolean;
var i: integer;
begin
   with TwwSelectField.create(Application) do try
      FilterListFlag:= True;
      CurrentList:= ACurrentList;
      AvailList:= AAvailList;
      RefreshFilteredList;
      result:= showModal=mrOK;

      if result then begin
          with Listbox1 do begin
             for i:= 0 to Items.Count-1 do begin
                if Selected[I] then selectedList.add(Items[i]);
             end
          end;
      end
   finally
      Free;
   end;
end;


procedure TwwSelectField.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Add Fields Dialog Box')
end;

end.
