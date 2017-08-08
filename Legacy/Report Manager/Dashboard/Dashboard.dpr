program Dashboard;

uses
  Forms,
  fRptMgr in 'fRptMgr.pas' {frmReportManager},
  sheet in 'sheet.pas',
  Fileutil in '..\..\Delphi Shared Code\FP\Fileutil.pas',
  Common in '..\..\Delphi Shared Code\QFP\Common.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'NRC Dashboard';
  Application.CreateForm(TfrmReportManager, frmReportManager);
  Application.Run;
end.
