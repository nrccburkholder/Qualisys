program Prjdemo;

uses
  Forms,
  Demo in 'DEMO.PAS' {MainDemo},
  Combos in '..\combos\COMBOS.PAS' {LookupForm},
  Demoloc in '..\locate\DEMOLOC.PAS' {Locate},
  Grdmemo in '..\gridmemo\GRDMEMO.PAS' {GridMemoApp},
  Isearch in '..\isrchdlg\ISEARCH.PAS' {SearchForm},
  Packdlgs in '..\tblpack\PACKDLGS.PAS' {GetTablesForm},
  Packtest in '..\tblpack\PACKTEST.PAS' {PackMain},
  Search in '..\search\SEARCH.PAS' {IncrSearch},
  Wwcaldlg in '..\grid\WWCALDLG.PAS' {MyCalendar},
  Qbe in '..\qbe\QBE.PAS' {QBEForm},
  Fltevent in '..\filters\FLTEVENT.PAS' {FilterEventForm},
  GrdLook in '..\grid\GRDLOOK.PAS' {GridDemo},
  Grdbitmp in '..\GRID\GRDBITMP.PAS' {BitmapForm},
  Pictures in '..\PICMASK\PICTURES.PAS',
  Multi in '..\multidel\multi.PAS',
  FiltDlg in '..\fltdlg\filtdlg.PAS',
  Lkquery in '..\combos\lkquery.pas',
  LkDtl in '..\combos\lkdtl.pas',
  grdbttn in '..\grid\grdbttn.pas',
  rcdvw in '..\rcdvw\rcdvw.pas' {RecordViewDemoForm},
  savefilt in '..\savefilt\savefilt.pas' {SaveFilterDemo},
  selfilt in '..\savefilt\selfilt.pas' {SelectSaveFilter},
  wwsavflt in '..\savefilt\wwsavflt.pas';

{$R *.RES}

begin
  Application.CreateForm(TMainDemo, MainDemo);
  Application.Run;
end.
