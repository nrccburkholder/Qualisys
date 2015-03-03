program psaveflt;

uses
  Forms,
  savefilt in 'savefilt.pas' {Form1},
  selfilt in 'selfilt.pas' {SelectSaveFilter},
  wwsavflt in 'wwsavflt.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSelectSaveFilter, SelectSaveFilter);
  Application.Run;
end.
