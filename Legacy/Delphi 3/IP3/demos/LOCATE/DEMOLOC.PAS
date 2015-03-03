unit Demoloc;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Buttons, Wwlocate, DBTables, Wwtable, Mask,
  ExtCtrls, Menus;

type
  TLocate = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
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
    EditBuyer: TDBEdit;
    Label10: TLabel;
    EditFirstContactDate: TDBEdit;
    Label11: TLabel;
    EditPhoneNumber: TDBEdit;
    DataSource1: TDataSource;
    Panel2: TPanel;
    wwTable1: TwwTable;
    wwLocateDialog1: TwwLocateDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FindFieldValue1: TMenuItem;
    FindNext1: TMenuItem;
    File2: TMenuItem;
    Exit1: TMenuItem;
    DBNavigator1: TDBNavigator;
    procedure LocateBtnClick(Sender: TObject);
    procedure LocateNextBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Locate: TLocate;

implementation

{$R *.DFM}

procedure TLocate.LocateBtnClick(Sender: TObject);
var dbEdit :TDBEdit;
begin
   { Change default search field to be the active field }
   if activeControl is TDBEdit then begin
      dbEdit:= TDBEdit(activeControl);
      if wwLocateDialog1.SearchField<> dbedit.dataField then
      begin
         wwLocateDialog1.fieldValue:= '';
         wwLocateDialog1.SearchField:= dbedit.dataField;
      end
   end;
   wwLocateDialog1.execute;
end;

procedure TLocate.LocateNextBtnClick(Sender: TObject);
begin
   { If first time then change default search field to be the active field }
   if wwLocateDialog1.fieldValue='' then begin
      if activeControl is TDBEdit then begin
         wwLocateDialog1.SearchField:= TDBEdit(activeControl).dataField;
      end
   end;
   wwLocateDialog1.FindNext;
end;

procedure TLocate.Exit1Click(Sender: TObject);
begin
   close;
end;

procedure TLocate.FormShow(Sender: TObject);
begin
   Width:= (LongInt(Width) * PixelsPerInch) div 96;
   Height:= (LongInt(Height) * PixelsPerInch) div 96;
end;

end.
