unit Usage;

{ modal dialog used for displaying number of surveys a question was used on }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Buttons, StdCtrls, DBCtrls, ExtCtrls, Mask;

type
  TfrmUsage = class(TForm)
    dgrUsage: TDBGrid;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    ckbFielded: TDBCheckBox;
    SpeedButton1: TSpeedButton;
    btnSurvey: TSpeedButton;
    btnFilter: TSpeedButton;
    btnFind: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Bevel1: TBevel;
    Label1: TLabel;
    Label4: TLabel;
    edtRange: TEdit;
    btnFirst: TSpeedButton;
    btnNext: TSpeedButton;
    edtCount: TEdit;
    procedure CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FindClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure SurveyClick(Sender: TObject);
    procedure FirstClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure UsageDblClick(Sender: TObject);
  private
    procedure GoToSurvey( Survey : Integer );
  public
    { Public declarations }
  end;

var
  frmUsage: TfrmUsage;

implementation

uses Data, Common, Support, Range;

{$R *.DFM}

{ INITIALIZATION }

{ configure tables to function with dialog:
    1. pass in default parameter to the qurey
    2. return recordcount }

procedure TfrmUsage.FormCreate(Sender: TObject);
begin
  with modLibrary do
  begin
    with wqryClient do
    begin
      ParamByName( 'start' ).AsDate := 0;
      ParamByName( 'end' ).AsDate := Date;
      Open;
      edtCount.Text := IntToStr( RecordCount );
    end;
    wtblUsage.Open;
  end;
end;

{ BUTTON METHODS }

procedure TfrmUsage.FindClick(Sender: TObject);
begin
  with modLibrary, modSupport.dlgLocate do
  begin
    DataSource := wsrcUsage;
    SearchField := 'Survey';
    Caption := 'Locate Question Usage';
    btnFirst.Enabled := Execute;
    btnNext.Enabled := btnFirst.Enabled;
  end;
end;

procedure TfrmUsage.FirstClick(Sender: TObject);
begin
  modSupport.dlgLocate.FindFirst;
  btnFirst.Enabled := False;
end;

procedure TfrmUsage.NextClick(Sender: TObject);
begin
  btnNext.Enabled := modSupport.dlgLocate.FindNext;
  btnFirst.Enabled := btnNext.Enabled;
end;

{ setsup a date filter on the usage query:
    1. opens the range dialog ( which set the filter )
    2. report filter in range text box }

procedure TfrmUsage.FilterClick(Sender: TObject);
begin
  frmRange := TfrmRange.Create( Self );
  with frmRange, modLibrary.wqryClient do
  try
    ShowModal;
    if ModalResult = mrOK then
    begin
      if lblInterval.Enabled then
        if edtInterval.Text = '' then
          edtRange.Text := 'All dates'
        else
          edtRange.Text := 'From ' + ParamByName( 'start' ).AsString
      else
        edtRange.Text := ParamByName( 'start' ).AsString + ' to ' + ParamByName( 'end' ).AsString;
      edtCount.Text := IntToStr( RecordCount );
      modLibrary.wtblUsage.Refresh;
    end;
  finally
    Release;
  end;
end;

procedure TfrmUsage.SurveyClick(Sender: TObject);
begin
  GoToSurvey( modLibrary.wtblUsageSurvey_ID.Value );
end;

{ COMPONENT HANDLERS }

procedure TfrmUsage.UsageDblClick(Sender: TObject);
begin
  if dgrUsage.SelectedField.FieldName = 'Survey' then
    GoToSurvey( modLibrary.wtblUsageSurvey_ID.Value );
end;

procedure TfrmUsage.GoToSurvey( Survey : Integer );
begin
  { optional: open form for viewing surveys detials }
end;

procedure TfrmUsage.CloseClick(Sender: TObject);
begin
  Close;
end;

{ FINALIZATION }

{ remove database configuration for dialog }

procedure TfrmUsage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with modLibrary do
  begin
    wtblUsage.Close;
    wqryClient.Close;
  end;
end;

end.
