program Question;

uses
  Forms,
  DB,
  DBTables,
  filectrl,
  Browse in 'Browse.pas' {frmLibrary},
  Category in 'Category.pas' {frmCategory},
  Code in 'Code.pas' {frmCode},
  Common in '..\Delphi Shared Code\QFP\Common.pas',
  Edit in 'Edit.PAS' {frmEdit},
  EditCode in 'EditCode.pas' {frmCodeEdit},
  Heading in 'Heading.pas' {frmHeading},
  Range in 'Range.pas' {frmRange},
  Recode in 'Recode.PAS' {frmRecode},
  Related in 'Related.pas' {frmRelated},
  Sort in '..\Delphi Shared Code\QF\Sort.pas' {frmSort},
  Translation in 'Translation.pas' {frmTranslate},
  Usage in 'Usage.pas' {frmUsage},
  RRelated in 'RRelated.pas' {rptRelated},
  Support in 'Support.pas' {modSupport: TDataModule},
  Lookup in 'Lookup.pas' {modLookup: TDataModule},
  Data in 'Data.pas' {modLibrary: TDataModule},
  PersRpt in 'PersRpt.pas' {frmPersRpt},
  NewScale in 'NewScale.pas' {frmNewScale},
  fViewData in '..\Delphi Shared Code\QFP\fViewData.pas' {frmViewData},
  DBRichEdit in 'DBRichEdit.pas',
  FileUtil in '..\Delphi Shared Code\FP\Fileutil.pas'{,
  uAdmin in 'uAdmin.pas' {frmAdmin};

{$R *.RES}

{var
  Splash : TfrmSplash;}
begin
  Application.Initialize;
  Application.Title := 'QualPro Question Library';
  Application.CreateForm(TmodLookup, modLookup);
  Application.CreateForm(TmodLibrary, modLibrary);
  Application.CreateForm(TmodSupport, modSupport);
  Application.CreateForm(TfrmLibrary, frmLibrary);
  Application.Run;
end.
