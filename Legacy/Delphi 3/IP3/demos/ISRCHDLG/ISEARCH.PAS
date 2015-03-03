unit Isearch;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Wwdbdlg, wwdblook, DB, DBTables, Wwtable,
  Wwdatsrc, wwidlg, Wwmemo, wwcommon, Grids, Wwdbigrd, Wwdbgrid, Buttons,
  DBCtrls, Wwdbcomb, Mask;

type
  TSearchForm = class(TForm)
    CustomerShadowTable: TwwTable;
    GroupBox1: TGroupBox;
    OKCancelCheckBox: TCheckBox;
    FixFirstColumnCheckBox: TCheckBox;
    ShowStatusBarCheckBox: TCheckBox;
    ShowUserButtonCheckBox: TCheckBox;
    ShowSearchByCheckbox: TCheckBox;
    GroupControlsCheckBox: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    wwDataSource1: TwwDataSource;
    CustomerTable: TwwTable;
    BitBtn1: TBitBtn;
    wwSearchDialog1: TwwSearchDialog;
    EditCustomerNo: TDBEdit;
    Label2: TLabel;
    EditCompanyName: TDBEdit;
    Label3: TLabel;
    EditFirstName: TDBEdit;
    Label4: TLabel;
    EditLastName: TDBEdit;
    Label5: TLabel;
    EditStreet: TDBEdit;
    Label6: TLabel;
    EditCity: TDBEdit;
    Label7: TLabel;
    EditState: TDBEdit;
    Label8: TLabel;
    EditZip: TDBEdit;
    Label9: TLabel;
    EditPhoneNumber: TDBEdit;
    Label11: TLabel;
    EditFirstContactDate: TDBEdit;
    Label10: TLabel;
    EditBuyer: TDBEdit;
    Label12: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure wwSearchDialog1UserButton1Click(Sender: TObject;
      LookupTable: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SearchForm: TSearchForm;

implementation

{$R *.DFM}

procedure TSearchForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CustomerTable.checkBrowseMode;
end;

procedure TSearchForm.BitBtn1Click(Sender: TObject);
var userButtonCaption: string;
begin
   with wwSearchDialog1 do begin
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

      userButtonCaption:= UserButton1Caption;
      if not ShowUserButtonCheckBox.checked then UserButton1Caption:= '';

      execute;

      UserButton1Caption:= userButtonCaption;

   end

end;

procedure TSearchForm.wwSearchDialog1UserButton1Click(Sender: TObject;
  LookupTable: TDataSet);
begin
   MessageDlg('Attach any code you want to this button.', mtinformation, [mbok], 0);
end;

end.
