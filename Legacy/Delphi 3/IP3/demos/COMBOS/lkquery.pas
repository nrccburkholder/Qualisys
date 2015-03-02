unit Lkquery;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, Wwtable, Wwdatsrc, StdCtrls, wwdblook,
  Wwkeycb, Grids, Wwdbigrd, Wwdbgrid, Wwdbdlg, wwidlg, Wwquery, ExtCtrls,
  ComCtrls, wwriched;

type
  TTableQueryForm = class(TForm)
    Button1: TButton;
    ZipDS: TwwDataSource;
    ZipQuery: TwwQuery;
    CustDS: TwwDataSource;
    CustQuery: TwwQuery;
    CustQueryCustomerNo: TIntegerField;
    CustQueryBuyer: TStringField;
    CustQueryCompanyName: TStringField;
    CustQueryFirstName: TStringField;
    CustQueryLastName: TStringField;
    CustQueryStreet: TStringField;
    CustQueryCity: TStringField;
    CustQueryState: TStringField;
    CustQueryZip: TStringField;
    CustQueryFirstContactDate: TDateField;
    CustQueryPhoneNumber: TStringField;
    CustQueryInformation: TMemoField;
    CustQueryRichEdit: TBlobField;
    CustQueryRequestedDemo: TStringField;
    CustQueryLogical: TBooleanField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    wwDBGrid1: TwwDBGrid;
    wwDBLookupCombo1: TwwDBLookupCombo;
    wwDBRichEdit1: TwwDBRichEdit;
    RadioGroup1: TRadioGroup;
    wwDBLookupComboDlg1: TwwDBLookupComboDlg;
    wwDBLookupCombo2: TwwDBLookupCombo;
    wwQuery1: TwwQuery;
    Label1: TLabel;
    wwDBLookupComboDlg2: TwwDBLookupComboDlg;
    Label2: TLabel;
    wwDBRichEdit2: TwwDBRichEdit;
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TableQueryForm: TTableQueryForm;

implementation

{$R *.DFM}

procedure TTableQueryForm.RadioGroup1Click(Sender: TObject);
begin
   if (Sender as TRadioGroup).itemIndex=0 then
      wwDBGrid1.SetControlType('Zip', fctCustom, 'wwDBLookupCombo1')
   else
      wwDBGrid1.SetControlType('Zip', fctCustom, 'wwDBLookupComboDlg1');

end;



end.
