program Spelltst;

uses
  Forms,
  Tstmain in 'TSTMAIN.PAS' {Form1},
  Testdlg in 'TESTDLG.PAS'; {EditSpellDialog}

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TEditSpellDialog, EditSpellDialog);
  Application.Run;
end.
