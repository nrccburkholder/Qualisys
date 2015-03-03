program Prjcombo;

uses
  Forms,
  Combos in 'COMBOS.PAS' {LookupForm};

{$R *.RES}

begin
  Application.CreateForm(TLookupForm, LookupForm);
  Application.Run;
end.
