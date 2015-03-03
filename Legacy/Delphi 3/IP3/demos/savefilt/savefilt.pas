unit savefilt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wwsavflt, Wwfltdlg, StdCtrls, Grids, Wwdbigrd, Wwdbgrid, DB, DBTables,
  Wwtable, Wwdatsrc, selfilt, Menus;

type
  TSaveFilterDemo = class(TForm)
    wwFilterDialog1: TwwFilterDialog;
    wwDataSource1: TwwDataSource;
    wwTable1: TwwTable;
    wwDBGrid1: TwwDBGrid;
    MainMenu1: TMainMenu;
    Filter1: TMenuItem;
    Filter2: TMenuItem;
    ClearFilter1: TMenuItem;
    SaveFilter1: TMenuItem;
    LoadFilter1: TMenuItem;
    Exit1: TMenuItem;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Filter2Click(Sender: TObject);
    procedure ClearFilter1Click(Sender: TObject);
    procedure SaveFilter1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure LoadFilter1Click(Sender: TObject);
  private
    procedure LoadFilter;
    { Private declarations }
  public
    wwSaveFilter1: TwwSaveFilter;
    { Public declarations }
  end;

var
  SaveFilterDemo: TSaveFilterDemo;

implementation

{$R *.DFM}

procedure TSaveFilterDemo.LoadFilter;
var FilterForm: TSelectSaveFilter;
    currentFilterNames : TStrings;
    i: integer;
begin

    FilterForm := TSelectSaveFilter.create(Application);
    if (not wwSaveFilter1.GetFilterNames(FilterForm.FiltersBox.Items)) then
    begin
       ShowMessage('You do not have any saved filters.');
       FilterForm.Free;
       exit;
    end;

    Screen.Cursor := crHourGlass;
    if (FilterForm.ShowModal=mrOk) then
    begin
       { Remove deleted filters from file}
       currentFilterNames := TStringList.create;
       wwSaveFilter1.GetFilterNames(currentFilterNames);
       for i:=0 to currentFilterNames.Count-1 do
          if  (FilterForm.FiltersBox.Items.IndexOf(currentFilterNames.Strings[i])<0) then
             wwSaveFilter1.DeleteFilter(currentFilterNames.Strings[i]);
       currentFilterNames.free;

       // Load selected filter
       if (FilterForm.FiltersBox.ItemIndex <> -1) then
          wwSaveFilter1.LoadFilter(FilterForm.FiltersBox.Items.Strings[FilterForm.FiltersBox.ItemIndex]);

    end;
    FilterForm.Free;
    Screen.Cursor := crArrow;
end;


procedure TSaveFilterDemo.Button2Click(Sender: TObject);
begin
   wwSaveFilter1.SaveFilter(InputBox('Filter Name', 'Name of Filter?',''));
end;

procedure TSaveFilterDemo.Button3Click(Sender: TObject);
begin
   wwfilterdialog1.execute;
end;

procedure TSaveFilterDemo.FormShow(Sender: TObject);
begin
   wwSaveFilter1:= TwwSaveFilter.create(Application);
   wwSaveFilter1.Delimiter := '///';
   wwSaveFilter1.FilePath := 'SaveFilt.txt';
   wwSaveFilter1.wwFilterDialog := wwFilterDialog1;
   Width:= (LongInt(Width) * PixelsPerInch) div 96;
   Height:= (LongInt(Height) * PixelsPerInch) div 96;
end;

procedure TSaveFilterDemo.Button4Click(Sender: TObject);
begin
   Close;
end;

procedure TSaveFilterDemo.Filter2Click(Sender: TObject);
begin
   wwFilterDialog1.execute;
end;

procedure TSaveFilterDemo.ClearFilter1Click(Sender: TObject);
begin
   wwFilterDialog1.ClearFilter;
   wwFilterDialog1.ApplyFilter;
end;

procedure TSaveFilterDemo.SaveFilter1Click(Sender: TObject);
begin
   wwSaveFilter1.SaveFilter(InputBox('Filter Name', 'Name of Filter?',''));
end;

procedure TSaveFilterDemo.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TSaveFilterDemo.LoadFilter1Click(Sender: TObject);
begin
   LoadFilter;
end;

end.
