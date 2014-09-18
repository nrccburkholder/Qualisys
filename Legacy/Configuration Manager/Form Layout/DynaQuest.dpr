program DynaQuest;

uses
  forms,
  BDE,
  dbtables,
  filectrl,
  controls,
  Dialogs,
  sysutils,
  dataMod in 'dataMod.pas' {DQDataModule: TDataModule},
  FDynaQ in 'FDynaQ.pas' {F_DynaQ},
  FSearch in 'FSearch.pas' {frmSearch},
  foptions in 'foptions.pas' {f_options},
  DOpenQ in '..\..\Delphi Shared Code\FP\DOpenQ.pas' {DMOpenQ: TDataModule},
  Common in '..\..\Delphi Shared Code\QFP\Common.pas',
  Code in 'Code.pas' {frmCode},
  REEdit in 'REEdit.pas' {frmREEdit},
  Support in 'Support.pas' {modSupport: TDataModule},
  TBAttrib in 'TBAttrib.pas' {frmTextBoxAttributes},
  uLoadBMP in 'uLoadBMP.pas' {frmOpenPictureDialog},
  PgAttrib in 'PgAttrib.pas' {frmPageAttributes},
  fSectProperties in 'fSectProperties.pas' {frmSectProperties},
  uLayoutCalc in '..\..\Delphi Shared Code\FP\uLayoutCalc.pas' {frmLayoutCalc},
  fQstnProperties in 'fQstnProperties.pas' {frmQstnProperties},
  fTrans in 'fTrans.pas' {frmTranslation},
  fInvalid in 'fInvalid.pas' {frmInvalid},
  fMyPrintDlg in 'fMyPrintDlg.pas' {frmMyPrintDlg},
  Sort in '..\..\Delphi Shared Code\QF\Sort.pas' {frmSort},
  fOpenStatus in 'fOpenStatus.pas' {frmOpenStatus},
  fPssWrd in 'fPssWrd.pas' {frmPassWord},
  fLogoRef in 'fLogoRef.pas' {frmLogoRef},
  fValidMsg in 'fValidMsg.pas' {frmValidMsg},
  fViewData in '..\..\Delphi Shared Code\FQP\fViewData.pas' {frmViewData},
  uPCLString in '..\..\Delphi Shared Code\FP\uPCLString.pas',
  f_ShowProps in 'f_ShowProps.pas' {ShowProps};

{$R *.RES}

procedure xx(t:integer);
begin
  try
    if fileexists(paramstr(1)) then pause(1);
    Application.CreateForm(TDQDataModule, DQDataModule);
  except
    if t<10 then
      xx(t+1)
    else
      raise;
  end;
end;
begin
  Application.Initialize;
  Application.Title := 'QualPro Form Layout';
  if DebugHook <> 0 then {Check if running in debug mode (from Delphi IDE) }
  begin
    Application.CreateForm(TDQDataModule, DQDataModule);
  Application.Title := 'Debugging Form Layout';
  end
  else
  begin {Run this code only in compiled application... otherwise delphi will crash in debug mode. }
    session.PrivateDir := TempDir(session.PrivateDir);
    xx(1);
  end;

  Application.CreateForm(TDMOpenQ, DMOpenQ);
  if DMOpenQ.glbSurveyID <> 0 then begin
    Application.CreateForm(TmodSupport, modSupport);
    Application.CreateForm(TF_DynaQ, F_DynaQ);
    Application.CreateForm(TfrmSearch, frmSearch);
    Application.CreateForm(TfrmSort, frmSort);
    Application.Run;

  end else
    Application.Terminate;


end.



