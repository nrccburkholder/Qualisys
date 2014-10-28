program PdfGen;

uses
  Forms,
  Windows,
  Main in 'Main.pas' {mainform},
  Narrative in 'Narrative.pas',
  TabularRanking in 'TabularRanking.pas',
  TabularTitle in 'TabularTitle.pas',
  Constants in 'constants.pas',
  PlotCharts in 'PlotCharts.pas',
  HBarmns in 'HBarmns.pas',
  VBars in 'VBars.pas',
  psapiunit in 'psapiunit.pas',
  FileUtil in 'Fileutil.pas',
  ControlCharts in 'ControlCharts.pas',
  HBarpcs in 'HBarpcs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PdfGen';
  Application.CreateForm(Tmainform, mainform);
  Application.run;

end.
