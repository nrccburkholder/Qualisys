unit Fltevent;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, Wwdbigrd, Wwdbgrid, DB, DBTables,
  Wwtable, Wwdatsrc, Buttons, ExtCtrls, ComCtrls, wwriched;

type
  TFilterEventForm = class(TForm)
    wwDataSource1: TwwDataSource;
    wwTable1: TwwTable;
    wwDBGrid1: TwwDBGrid;
    GroupBox1: TGroupBox;
    FilterFirstName: TEdit;
    Label1: TLabel;
    FilterLastName: TEdit;
    Label2: TLabel;
    FilterCompanyName: TEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    CaseSensitiveCheckbox: TCheckBox;
    ExactMatch: TRadioButton;
    PartialMatchBeginning: TRadioButton;
    PartialMatchAnywhere: TRadioButton;
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Button1: TButton;
    wwDBRichEdit1: TwwDBRichEdit;
    Procedure wwTable1Filter(table: TwwTable; var accept: boolean);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FilterEventForm: TFilterEventForm;

implementation

{$R *.DFM}

Procedure TFilterEventForm.wwTable1Filter(table: TwwTable; var accept: boolean);

  Function HasFieldValue(fieldName: string; searchText: string): boolean;
  var curText: string;
      matchPos: integer;
  begin
      curText:= table.wwFilterField(fieldName).asString;
      if not CaseSensitiveCheckbox.checked then begin
         searchText:= Uppercase(searchText);
         curText:= Uppercase(curText);
      end;

      if searchText<>'' then begin
         matchPos:= pos(searchText, curText);
         if (PartialMatchAnywhere.checked and (matchPos>0)) then result:= True
         else if (PartialMatchBeginning.checked and (matchPos=1)) then result:= True
         else if searchText=curText then result:= True
         else begin
            result:= False;
            exit;
         end
      end
      else result:= True;
  end;

begin
   if not HasFieldValue('First Name', FilterFirstName.text) then accept:= False;
   if not HasFieldValue('Last Name', FilterLastName.text) then accept:= False;
   if not HasFieldValue('Company Name', FilterCompanyName.text) then accept:= False;
end;

procedure TFilterEventForm.BitBtn1Click(Sender: TObject);
begin
   wwtable1.refresh;
end;

end.
