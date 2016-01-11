program PCLGen;

uses
  Forms,
  fPCLGen in 'fPCLGen.pas' {frmPCLGeneration},
  dPCLGen in 'dPCLGen.pas' {dmPCLGen: TDataModule},
  DOpenQ in '..\Delphi Shared Code\FP\DOpenQ.pas' {DMOpenQ: TDataModule},
  uLayoutCalc in '..\Delphi Shared Code\FP\uLayoutCalc.pas' {frmLayoutCalc},
  Common in '..\Delphi Shared Code\QFP\common.pas',
  fViewData in '..\Delphi Shared Code\QFP\fViewData.pas' {frmViewData},
  FileUtil in '..\Delphi Shared Code\FP\Fileutil.pas',
  uPCLString in '..\Delphi Shared Code\FP\uPCLString.pas',
  Log4Pascal in '..\Delphi 3\log4pascal-master\log4pascal-master\Log4Pascal.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PCLGen';
  Application.CreateForm(TfrmPCLGeneration, frmPCLGeneration);
  Application.Run;
end.
