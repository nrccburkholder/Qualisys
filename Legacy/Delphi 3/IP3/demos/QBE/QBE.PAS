unit Qbe;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, Wwdbigrd, Wwdbgrid, DB, Wwqbe, Wwdatsrc, StdCtrls,
  DBTables;

type
  TQBEForm = class(TForm)
    wwDataSource1: TwwDataSource;
    wwQBE1: TwwQBE;
    wwDBGrid1: TwwDBGrid;
    Memo1: TMemo;
    Button1: TButton;
    wwQBE1IND_NAME: TStringField;
    wwQBE1SYMBOL: TStringField;
    wwQBE1CO_NAME: TStringField;
    wwQBE1EXCHANGE: TStringField;
    wwQBE1CUR_PRICE: TFloatField;
    wwQBE1YRL_HIGH: TFloatField;
    wwQBE1YRL_LOW: TFloatField;
    wwQBE1P_E_RATIO: TFloatField;
    wwQBE1BETA: TFloatField;
    wwQBE1PROJ_GRTH: TFloatField;
    wwQBE1INDUSTRY: TSmallintField;
    wwQBE1PRICE_CHG: TSmallintField;
    wwQBE1SAFETY: TSmallintField;
    wwQBE1RATING: TStringField;
    wwQBE1RANK: TFloatField;
    wwQBE1OUTLOOK: TSmallintField;
    wwQBE1RCMNDATION: TStringField;
    wwQBE1RISK: TStringField;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QBEForm: TQBEForm;

implementation

{$R *.DFM}

procedure TQBEForm.FormActivate(Sender: TObject);
begin
   wwQBE1.active:= True;
end;

end.
