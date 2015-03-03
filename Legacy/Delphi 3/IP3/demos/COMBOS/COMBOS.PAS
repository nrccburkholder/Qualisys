unit Combos;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Wwdbdlg, wwdblook, DB, DBTables, Wwtable,
  Wwdatsrc, wwidlg, Wwmemo, wwcommon, ExtCtrls, DBCtrls, ComCtrls, wwriched;

type
  TLookupForm = class(TForm)
    wwTable1: TwwTable;
    GroupBox1: TGroupBox;
    OKCancelCheckBox: TCheckBox;
    FixFirstColumnCheckBox: TCheckBox;
    ShowStatusBarCheckBox: TCheckBox;
    ShowUserButtonCheckBox: TCheckBox;
    ShowSearchByCheckbox: TCheckBox;
    GroupControlsCheckBox: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    wwDBLookupComboDlg1: TwwDBLookupComboDlg;
    GroupBox3: TGroupBox;
    AlignRightCheckBox: TCheckBox;
    FillCheckBox: TCheckBox;
    GroupBox4: TGroupBox;
    Zip: TEdit;
    City: TEdit;
    State: TEdit;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    wwDBLookupCombo1: TwwDBLookupCombo;
    wwDBLookupCombo2: TwwDBLookupCombo;
    Label3: TLabel;
    Label4: TLabel;
    wwDataSource1: TwwDataSource;
    CustomerTable: TwwTable;
    Button1: TButton;
    AutoDropDownCheckBox: TCheckBox;
    ShowButton: TCheckBox;
    QuickenStyle1: TCheckBox;
    QuickenStyle2: TCheckBox;
    procedure wwDBLookupComboDlg1DropDown(Sender: TObject);
    procedure wwDBLookupComboDlg1UserButton1Click(Sender: TObject;
      LookupTable: TDataSet);
    procedure wwDBLookupCombo1DropDown(Sender: TObject);
    procedure wwDBLookupCombo2DropDown(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wwDBLookupCombo1CloseUp(Sender: TObject;
      LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
    procedure AutoDropDownCheckBoxClick(Sender: TObject);
    procedure ShowButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure QuickenStyle2Click(Sender: TObject);
    procedure QuickenStyle1Click(Sender: TObject);
    procedure wwDBLookupComboDlg1InitDialog(Dialog: TwwLookupDlg);
  private
    { Private declarations }
    initialized: boolean;
  public
    { Public declarations }
  end;

var
  LookupForm: TLookupForm;

implementation

{$R *.DFM}

procedure TLookupForm.wwDBLookupComboDlg1DropDown(Sender: TObject);
begin
   with wwDBLookupComboDlg1 do begin
      if OkCancelCheckBox.checked then Options:= Options + [opShowOKCancel]
      else Options:= Options - [opShowOKCancel];

      if FixFirstColumnCheckBox.checked then Options:= Options + [opFixFirstColumn]
      else Options:= Options - [opFixFirstColumn];

      if GroupControlsCheckBox.checked then Options:= Options + [opGroupControls]
      else Options:= Options - [opGroupControls];

      if ShowStatusBarCheckBox.checked then Options:= Options + [opShowStatusBar]
      else Options:= Options - [opShowStatusBar];

      if ShowSearchByCheckBox.checked then Options:= Options + [opShowSearchBy]
      else Options:= Options - [opShowSearchBy];

      if ShowUserButtonCheckBox.checked then UserButton1Caption:= 'New'
      else UserButton1Caption:= '';

   end
end;

procedure TLookupForm.wwDBLookupComboDlg1UserButton1Click(Sender: TObject;
  LookupTable: TDataSet);
begin
     MessageDlg('Attach your own code to these programmable buttons to expand this dialog''s capabilities.',
                        mtInformation, [mbok], 0);
end;

procedure TLookupForm.wwDBLookupCombo1DropDown(Sender: TObject);
begin
    if AlignRightCheckBox.checked then
       wwDBLookupCombo1.dropDownAlignment:= taRightJustify
    else wwDBLookupCombo1.dropDownAlignment:= taLeftJustify;
end;

procedure TLookupForm.wwDBLookupCombo2DropDown(Sender: TObject);
begin
    if AlignRightCheckBox.checked then
       wwDBLookupCombo2.dropDownAlignment:= taRightJustify
    else wwDBLookupCombo2.dropDownAlignment:= taLeftJustify;
end;

procedure TLookupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CustomerTable.checkBrowseMode;
end;

procedure TLookupForm.wwDBLookupCombo1CloseUp(Sender: TObject;
  LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
begin
   if not FillCheckBox.checked then exit;
   if not modified then exit;

   Zip.text:= LookupTable.fieldbyname('Zip').asString;
   City.text:= LookupTable.fieldbyname('City').asString;
   State.text:= LookupTable.fieldbyname('State').asString;
end;

procedure TLookupForm.AutoDropDownCheckBoxClick(Sender: TObject);
begin
    wwDBLookupCombo1.AutoDropDown:= AutoDropDownCheckBox.checked;
    wwDBLookupCombo2.AutoDropDown:= AutoDropDownCheckBox.checked;
end;

procedure TLookupForm.ShowButtonClick(Sender: TObject);
begin
    wwDBLookupCombo1.ShowButton:= ShowButton.checked;
    wwDBLookupCombo2.ShowButton:= ShowButton.checked;
end;

procedure TLookupForm.FormActivate(Sender: TObject);
begin
   if not initialized then begin
      ShowButton.checked:= True;
      AutoDropDownCheckBox.checked:= True;
      initialized:= True;
   end;
end;



procedure TLookupForm.QuickenStyle2Click(Sender: TObject);
begin
   wwDBLookupComboDlg1.ShowMatchText:= (Sender as TCheckBox).checked;
end;

procedure TLookupForm.QuickenStyle1Click(Sender: TObject);
begin
   wwDBLookupCombo1.ShowMatchText:= (Sender as TCheckBox).checked;
   wwDBLookupCombo2.ShowMatchText:= (Sender as TCheckBox).checked;
end;

procedure TLookupForm.wwDBLookupComboDlg1InitDialog(Dialog: TwwLookupDlg);
begin
   Dialog.wwIncrementalSearch1.ShowMatchText:= wwDBLookupComboDlg1.ShowMatchText;
end;

end.
