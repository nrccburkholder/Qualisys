program QPDE;

uses
  Forms,
  fQPDE in 'fQPDE.pas' {frmQPDE},
  Common in '..\..\library\source\common.pas',
  fViewData in '..\..\PCLGen\Source\fViewData.pas' {frmViewData};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'QualPro Data Entry';
  Application.CreateForm(TfrmQPDE, frmQPDE);
  Application.CreateForm(TfrmViewData, frmViewData);
  Application.Run;
end.
