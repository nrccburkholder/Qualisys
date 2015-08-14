program Ppdemo;

uses
  Forms,
  Ppdem in 'PPDEM.PAS' {MultPageDlg};

{$R *.RES}

begin
  Application.Title := 'PowerPanel Demo';
  Application.CreateForm(TMultPageDlg, MultPageDlg);
  Application.Run;
end.
