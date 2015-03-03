unit rcdvw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, wwrcdvw, Buttons, Wwdbgrid, Grids, Wwdbigrd, Db,
  DBTables, Wwtable, Wwdatsrc, wwdblook, Menus, Mask, wwdbedit, Wwdotdot,
  Wwdbcomb, DBCtrls, ComCtrls, wwriched;

type
  TRecordViewDemoForm = class(TForm)
    wwDataSource1: TwwDataSource;
    wwTable1: TwwTable;
    wwDBGrid1: TwwDBGrid;
    wwDBGrid1IButton: TwwIButton;
    wwRecordViewDialog1: TwwRecordViewDialog;
    GroupBox1: TGroupBox;
    RecordViewStyle: TRadioGroup;
    DialogStyle: TRadioGroup;
    wwDBLookupCombo1: TwwDBLookupCombo;
    wwTable2: TwwTable;
    EmbedControls: TCheckBox;
    RecordViewMenu: TMainMenu;
    First1: TMenuItem;
    Record1: TMenuItem;
    Exit1: TMenuItem;
    First2: TMenuItem;
    Prior1: TMenuItem;
    Next1: TMenuItem;
    Last1: TMenuItem;
    Edit1: TMenuItem;
    Cancel1: TMenuItem;
    Post1: TMenuItem;
    CustomMainMenu: TCheckBox;
    ShowNavigator: TCheckBox;
    Label1: TLabel;
    wwDBComboBox1: TwwDBComboBox;
    Insert1: TMenuItem;
    ShowOKCancel: TCheckBox;
    wwDBRichEdit1: TwwDBRichEdit;
    procedure wwDBGrid1IButtonClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Cancel1Click(Sender: TObject);
    procedure Post1Click(Sender: TObject);
    procedure First2Click(Sender: TObject);
    procedure Prior1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure Last1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RecordViewDemoForm: TRecordViewDemoForm;

implementation

{$R *.DFM}

procedure TRecordViewDemoForm.wwDBGrid1IButtonClick(Sender: TObject);
begin
   if RecordViewStyle.itemIndex=0 then
     wwRecordViewDialog1.Style:= rvsHorizontal
   else
     wwRecordViewDialog1.Style:= rvsVertical;

   if DialogStyle.itemIndex=0 then
     wwRecordViewDialog1.Options:= wwRecordViewDialog1.Options + [rvoModalForm] - [rvoStayOnTopForm]
   else
     wwRecordViewDialog1.Options:= wwRecordViewDialog1.Options - [rvoModalForm] + [rvoStayOnTopForm];

   if EmbedControls.checked then
     wwRecordViewDialog1.Options:= wwRecordViewDialog1.Options + [rvoUseCustomControls]
   else
     wwRecordViewDialog1.Options:= wwRecordViewDialog1.Options - [rvoUseCustomControls];

   if CustomMainMenu.checked then
     wwRecordViewDialog1.Menu:= RecordViewMenu
   else
     wwRecordViewDialog1.Menu:= Nil;

   if ShowNavigator.checked then
     wwRecordViewDialog1.Options:= wwRecordViewDialog1.Options - [rvoHideNavigator]
   else
     wwRecordViewDialog1.Options:= wwRecordViewDialog1.Options + [rvoHideNavigator];

   if ShowOKCancel.checked then
     wwRecordViewDialog1.OKCancelOptions:= wwRecordViewDialog1.OKCancelOptions + [rvokShowOKCancel]
   else
     wwRecordViewDialog1.OKCancelOptions:= wwRecordViewDialog1.OKCancelOptions - [rvokShowOKCancel];

   { Leave grid button depressed for modal dialog until dialog closes }
   if DialogStyle.itemIndex=0 then with (Sender as TSpeedButton) do
   begin
      GroupIndex:= -1;
      Down:= True;
   end;

   wwDBGrid1.FlushChanges; { Save any changes made to the grid to the tfield buffers}
   wwRecordViewDialog1.execute;

   { Raise grid button }
   if DialogStyle.itemIndex=0 then with (Sender as TSpeedButton) do
   begin
      GroupIndex:= 0;
      down:= False;
   end;

end;

procedure TRecordViewDemoForm.Exit1Click(Sender: TObject);
begin
   wwRecordViewDialog1.RecordViewForm.close;
end;

procedure TRecordViewDemoForm.Cancel1Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.Cancel;
end;

procedure TRecordViewDemoForm.Post1Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.checkBrowseMode;
end;

procedure TRecordViewDemoForm.First2Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.First;
end;

procedure TRecordViewDemoForm.Prior1Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.Prior;
end;

procedure TRecordViewDemoForm.Next1Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.Next;
end;

procedure TRecordViewDemoForm.Last1Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.Last;
end;

procedure TRecordViewDemoForm.Edit1Click(Sender: TObject);
begin
   Cancel1.enabled:=
      (wwRecordViewDialog1.datasource.dataset.state = dsEdit) or
      (wwRecordViewDialog1.datasource.dataset.state = dsInsert);
   Post1.enabled:= cancel1.enabled;
end;


procedure TRecordViewDemoForm.Insert1Click(Sender: TObject);
begin
   wwRecordViewDialog1.datasource.dataset.Insert;
end;


end.
