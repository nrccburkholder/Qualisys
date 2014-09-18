unit f_ShowProps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Db, DBTables, ExtCtrls;

type
  TShowProps = class(TForm)
    Table1: TTable;
    RichEdit1: TRichEdit;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label10: TLabel;
    pnl2_9: TPanel;
    Label17: TLabel;
    pnl2_8: TPanel;
    lblSpreadQuestions: TLabel;
    Label18: TLabel;
    pnl2_5: TPanel;
    Label30: TLabel;
    pnl2_7: TPanel;
    lblTwoCol: TLabel;
    Label32: TLabel;
    pnlShading: TPanel;
    pnl2_6: TPanel;
    Label29: TLabel;
    pnlShape: TPanel;
    pnlExtraSpace: TPanel;
    pnl2_10: TPanel;
    LblConsiderLegal: TLabel;
    Label3: TLabel;
    Languages: TGroupBox;
    ScrollBox1: TScrollBox;
    pnl2_1: TPanel;
    pnl2_2: TPanel;
    pnl2_3: TPanel;
    pnl2_4: TPanel;
    Label6: TLabel;
    lblQuestionFontName: TLabel;
    Label8: TLabel;
    lblQuestionFontSize: TLabel;
    lblScaleFontName: TLabel;
    Label11: TLabel;
    lblScaleFontSize: TLabel;
    Label13: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    pnl1_1: TPanel;
    Label7: TLabel;
    lblQuestionFontName1: TLabel;
    pnl1_9: TPanel;
    Label12: TLabel;
    pnlExtraSpace1: TPanel;
    pnl1_8: TPanel;
    lblSpreadQuestions1: TLabel;
    Label15: TLabel;
    pnl1_5: TPanel;
    Label16: TLabel;
    pnlShading1: TPanel;
    pnl1_7: TPanel;
    lblTwoCol1: TLabel;
    Label20: TLabel;
    pnl1_6: TPanel;
    Label21: TLabel;
    pnlShape1: TPanel;
    pnl1_10: TPanel;
    LblConsiderLegal1: TLabel;
    Label23: TLabel;
    GroupBox3: TGroupBox;
    ScrollBox2: TScrollBox;
    pnl1_2: TPanel;
    Label24: TLabel;
    lblQuestionFontSize1: TLabel;
    pnl1_3: TPanel;
    lblScaleFontName1: TLabel;
    Label27: TLabel;
    pnl1_4: TPanel;
    lblScaleFontSize1: TLabel;
    Label31: TLabel;
    Label9: TLabel;
    Button1: TButton;
    Label14: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}


end.
