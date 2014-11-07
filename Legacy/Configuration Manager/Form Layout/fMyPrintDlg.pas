unit fMyPrintDlg;

interface

{
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Name            Description
-------------------------------------------------------------------------------
10-19-2005  GN01   George Nelson   when the default DQCalcPrinter is not installed
                                   the user get an error when trying to do a print mockup.
}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBRichEdit, Buttons, checklst, printers, ExtCtrls, Spin, ShellAPI;

type
  TfrmMyPrintDlg = class(TForm)
    CheckListSections: TCheckListBox;
    ComboCoverLtr: TComboBox;
    cbIncludeQstns: TCheckBox;
    btnClearAll: TBitBtn;
    btnMarkAll: TBitBtn;
    gbPrintWhat: TGroupBox;
    lblCoverLtr: TLabel;
    btnChangePrinter: TButton;
    lblPrinter: TLabel;
    PrintDialog: TPrintDialog;
    btnPrint: TButton;
    btnCancel: TButton;
    GBPersonalization: TGroupBox;
    pnlGB1: TPanel;
    rbFemale: TRadioButton;
    rbMale: TRadioButton;
    pnlRG2: TPanel;
    rbAdult: TRadioButton;
    rbMinor: TRadioButton;
    pnlRG3: TPanel;
    rbDoc: TRadioButton;
    rbGroup: TRadioButton;
    cbPrintToFile: TCheckBox;
    SaveDialog: TSaveDialog;
    cbMockupLanguage: TComboBox;
    cbQAInfo: TCheckBox;
    gbCopies: TGroupBox;
    Label1: TLabel;
    seCopies: TSpinEdit;
    btnPreview: TButton;
    checkListSampleUnits: TCheckListBox;
    lblSampleUnits: TLabel;
    procedure btnChangePrinterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboCoverLtrChange(Sender: TObject);
    procedure cbIncludeQstnsClick(Sender: TObject);
    procedure btnMarkAllClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure seCopiesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seCopiesExit(Sender: TObject);
  private
    { Private declarations }
    SectionID,CoverID,SampleUnitID : array[0..100] of integer;
    PageType : array[0..100] of byte;
    procedure IncludeQstns(const PT:integer);
    procedure CheckListSectionsEnable(const en:boolean);
    procedure SetSections;
    procedure ResetSections;
    procedure SetCover;
    procedure ResetCover;
    function installDQCalcPrn : Boolean;
    procedure SetupSampleUnits(coverLetterName : string);
  public
    { Public declarations }
  end;

var
  frmMyPrintDlg: TfrmMyPrintDlg;

implementation

uses DOpenQ, uLayoutCalc, FDynaQ, common;

{$R *.DFM}

procedure TfrmMyPrintDlg.btnChangePrinterClick(Sender: TObject);
var dvc,drv,port:array[0..79] of char;
    h:thandle;
begin
  if PrintDialog.execute then begin
    printer.getprinter(dvc,drv,port,h);
    if (uppercase(copy(dvc,1,7)) = '\\NRC2\') or (uppercase(copy(port,1,7)) = '\\NRC2\')
      or (uppercase(copy(dvc,1,10)) = '\\NEPTUNE\') or (uppercase(copy(port,1,10)) = '\\NEPTUNE\')
      or (uppercase(copy(dvc,1,9)) = '\\NRCC02\') or (uppercase(copy(port,1,9)) = '\\NRCC02\') then begin
      frmLayoutCalc.curDevice := dvc;
      frmLayoutCalc.curPort := port;
      if (uppercase(copy(dvc,1,7)) = '\\NRC2\') or (uppercase(copy(dvc,1,10)) = '\\NEPTUNE\') or (uppercase(copy(dvc,1,9)) = '\\NRCC02\') then
        frmLayoutCalc.curPort := dvc;
      lblPrinter.caption := frmLayoutCalc.curPort;
      btnPrint.Enabled := ((uppercase(copy(frmLayoutCalc.curPort,1,7))='\\NRC2\') or (uppercase(copy(frmLayoutCalc.curPort,1,10))='\\NEPTUNE\') or (uppercase(copy(frmLayoutCalc.curPort,1,9))='\\NRCC02\'));
    end else begin
      messagedlg('Don''t use anything other than a printer on NRC''s network.'+#13+'(dvc='+dvc+' - '+'port='+port+')',mterror,[mbok],0);
    end;
  end;
end;

procedure tFrmMyPrintDlg.IncludeQstns(const PT:integer);
begin
  cbIncludeQstns.enabled := (pt=1);
  cbIncludeQstnsClick(self);
end;

procedure TfrmMyPrintDlg.FormCreate(Sender: TObject);
begin
  with cbMockupLanguage, dmOpenQ.t_Language do begin
    first;
    Items.clear;
    while not eof do begin
      if fieldbyname('UseLang').asboolean then
        items.add(trimleft(fieldbyname('Language').text+' '+fieldbyname('LangID').asstring));
      next;
    end;
    if items.count<=1 then
      visible := false
    else
      itemindex := 0;
  end;
  lblPrinter.caption := frmLayoutCalc.curPort;
  btnPrint.Enabled := ((uppercase(copy(frmLayoutCalc.curPort,1,7))='\\NRC2\') or (uppercase(copy(frmLayoutCalc.curPort,1,10))='\\NEPTUNE\') or (uppercase(copy(frmLayoutCalc.curPort,1,9))='\\NRCC02\'));
  rbFemale.checked := (vSex='Female');
  rbMale.checked := (vSex='Male');
  rbAdult.checked := (vAge='Adult');
  rbMinor.checked := (vAge='Minor');
  rbGroup.checked := (vDoc='Group');
  rbDoc.checked := (vDoc='Doctor');
  cbQAInfo.checked := false;
  with dmOpenQ, wwt_Qstns do begin
    disableControls;
    filtered := false;
    checkListSections.Items.clear;
    first;
    while not eof do begin
      if (wwt_QstnsSubtype.value=stSection) and (wwt_QstnsSection.value>0) and (wwt_QstnsLanguage.value=1) then begin
        checkListSections.Items.add(wwt_QstnsLabel.value);
        checkListSections.checked[checkListSections.Items.count-1] := true;
        SectionID[checkListSections.Items.count-1] := wwt_QstnsSection.value;
      end;
      next;
    end;
    filtered := true;
    EnableControls;
  end;
  with dmOpenQ, wwt_Cover do begin
    disablecontrols;
    filtered := false;
    ComboCoverLtr.Items.clear;
    first;
    while not eof do begin
      if (wwt_Cover.fieldbyname('PageType').value <> 4 {ptArtifacts}) then begin
        ComboCoverLtr.Items.add(fieldbyname('Description').value);
        CoverID[ComboCoverLtr.Items.count-1] := wwt_Cover.fieldbyname('SelCover_ID').value;
        PageType[ComboCoverLtr.Items.count-1] := wwt_Cover.fieldbyname('PageType').value;
      end;
      next;
    end;
    ComboCoverLtr.ItemIndex := 0;
    cbIncludeQstns.checked := (PageType[0]=1);
    IncludeQstns(PageType[0]);
    filtered := true;
    EnableControls;
  end;
  //TODO CJB Populate new checklistSampleUnits from mappings for the selected cover letter from dmOpenQ.MappedSampleUnitsByCL
  SetupSampleUnits(ComboCoverLtr.Items[ComboCoverLtr.ItemIndex]);
end;

procedure TfrmMyPrintDlg.SetupSampleUnits(coverLetterName : string);
var sSampleUnits : string;
    i : integer;
begin
   sSampleUnits := dmOpenQ.MappedSampleUnitsByCL(coverLetterName);
   checklistSampleUnits.Items.Clear();
   i := 0;
   while sSampleUnits <> '' do begin
      SampleUnitId[i] := StrToInt(Copy(sSampleUnits,0,Pos('=',sSampleUnits) - 1));
      checkListSampleUnits.Items.add(Copy(sSampleUnits,Pos('=',sSampleUnits) + 1, Pos(';',sSampleUnits) - Pos('=',sSampleUnits) - 1));

      sSampleUnits := Copy(sSampleUnits, Pos(';', sSampleUnits) + 1, length(sSampleUnits) - Pos(';', sSampleUnits));
      inc(i);
   end ;
end;

procedure TfrmMyPrintDlg.ComboCoverLtrChange(Sender: TObject);
begin
  IncludeQstns(PageType[ComboCoverLtr.itemindex]);
  //TODO CJB update checklistSampleUnits from mappings for the selected cover letter
  SetupSampleUnits(ComboCoverLtr.Items[ComboCoverLtr.ItemIndex]);
end;

procedure TfrmMyPrintDlg.cbIncludeQstnsClick(Sender: TObject);
begin
  CheckListSections.enabled := (cbIncludeQstns.checked);
  btnClearAll.enabled := (cbIncludeQstns.checked);
  btnMarkAll.enabled := (cbIncludeQstns.checked);
  CheckListSectionsEnable(cbIncludeQstns.checked);
end;

procedure TfrmMyPrintDlg.btnMarkAllClick(Sender: TObject);
var i : integer;
begin
  for i := 0 to CheckListSections.Items.count-1 do
    checklistsections.checked[i] := true;
end;

procedure TfrmMyPrintDlg.btnClearAllClick(Sender: TObject);
var i : integer;
begin
  for i := 0 to CheckListSections.Items.count-1 do
    checklistsections.checked[i] := false;
end;

procedure tfrmMyPrintDlg.CheckListSectionsEnable(const en:boolean);
begin
  with checklistsections do
    if en then
      font.color := clWindowText
    else
      font.color := clGrayText;
end;

procedure TfrmMyPrintDlg.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMyPrintDlg.btnPrintClick(Sender: TObject);
  procedure ViewPDF(fn:string);
  var local : string;
      i : integer;
  begin
      local := dmOpenQ.tempdir+'\'+extractFileName(fn);
      i := 0;
      while not fileexists(fn) do begin
        pause(1);
        inc(i);
        if i=10 then begin
          messagedlg('Can''t find ' + fn,mterror,[mbok],0);
          break;
        end;
      end;
      copyfile(pchar(fn),pchar(local),false);
      deletefile(fn);
      ShellExecute(Handle, PChar('Open'), PChar(local),nil , PChar(dmOpenQ.tempdir), SW_SHOWNORMAL);
  end;
  procedure deletepdf(fn:string);
  begin
    repeat
      if fileexists(fn) and not deletefile(fn) then
        if messagedlg('Please close any open print preview windows.'+#13+'('+fn+')',mtWarning,[mbok,mbCancel],0) = mrCancel then
          raise Exception.create('Can''t delete '+fn);
    until not fileexists(fn);
  end;

var PrinterOn:boolean;
    src2,cvr,prn : string;
    copies, i : integer;
    isPreview : boolean;
begin
  try
    isPreview := tButton(sender).name = 'btnPreview';
    screen.cursor := crHourGlass;
    btnPrint.enabled := false;
    btnCancel.enabled := false;
    btnPreview.enabled := false;
    if rbFemale.checked then vSex:='Female' else vSex:='Male';
    if rbAdult.checked then vAge:='Adult' else vAge:='Minor';
    if rbGroup.checked then vDoc:='Group' else vDoc:='Doctor';
    SetCover;
    frmLayoutCalc.IncludeQstns := (cbIncludeQstns.checked) and (cbIncludeQstns.enabled);
    //if frmLayoutCalc.IncludeQstns then
      SetSections;
    if cbQAInfo.checked then
      frmLayoutCalc.mockup := ptCodeSheetMockup
    else
      frmLayoutCalc.mockup := ptMockup;
    frmLayoutCalc.match := 'G';
    PrinterOn := printer.printing;
    if not PrinterOn then begin
       if not installDQCalcPrn then exit;
       frmLayoutCalc.StartCalc;
    end;
    src2 := dmOpenQ.tempdir+'\QPMockup.prn';
    if fileexists(src2) then
      deletefile(src2);
    frmLayoutCalc.SetFonts;
    frmLayoutCalc.SurveyGen('');
    if not PrinterOn then frmLayoutCalc.EndCalc;
    if not fileexists(src2) then
      frmLayoutCalc.makeMockupFile('INITIALIZATION',src2);
    if isPreview then begin
      if fileexists(src2) then begin
        deletepdf(dmopenq.tempdir + '\' + computername + '.pdf');
        deletepdf(dmopenq.tempdir + '\' + computername + '_cover.pdf');
        deletepdf(dmopenq.prndir + '\' + computername + '.pdf');
        deletepdf(dmopenq.prndir + '\' + computername + '_cover.pdf');

        prn := dmopenq.prndir + '\' + computername + '.prn';
        copyfile(pchar(src2),pchar(prn),false);
        if not frmLayoutCalc.integratedcover then begin
          cvr := dmopenq.prndir + '\' + computername + '_cover.prn';
          src2 := dmOpenQ.tempdir+'\QPMockup_cover.prn';
          copyfile(pchar(src2),pchar(cvr),false);
          cvr := copy(cvr,1,pos(extractfileext(cvr),cvr)) + 'pdf';
          ViewPDF(cvr)
        end;
        prn := copy(prn,1,pos(extractfileext(prn),prn)) + 'pdf';
        ViewPDF(prn);
      end;
    end else if cbPrintToFile.checked then begin
      savedialog.DefaultExt := '*.prn';
      savedialog.Filter := 'Print files (*.prn)|*.prn';
      if fileexists(src2) and SaveDialog.execute then begin
        copyfile(pchar(src2),pchar(savedialog.filename),false);
        if not frmLayoutCalc.integratedcover then begin
          cvr := extractfilename(savedialog.filename);
          if extractfileext(cvr)='' then cvr := cvr + '.prn';
          insert('_cover',cvr,pos(extractfileext(cvr),cvr));
          cvr := extractfilepath(savedialog.filename)+cvr;
          src2 := dmOpenQ.tempdir+'\QPMockup_cover.prn';
          copyfile(pchar(src2),pchar(cvr),false);
        end;
      end;
    end else begin
      for copies := 1 to seCopies.Value do begin
        if not frmLayoutCalc.integratedcover then begin
          src2 := dmOpenQ.tempdir+'\QPMockup_cover.prn';
          if fileexists(src2) then
            copyfile(pchar(src2),pchar(frmLayoutCalc.curPort),false);
        end;
        src2 := dmOpenQ.tempdir+'\QPMockup.prn';
        if fileexists(src2) then
          copyfile(pchar(src2),pchar(frmLayoutCalc.curPort),false);
      end;
    end;
  finally
    ResetSections;
    ResetCover;
    dmopenq.wwt_QstnsEnableControls;
    screen.cursor := crDefault;
    if isPreview then begin
      btnPrint.enabled := true;
      btnCancel.enabled := true;
      btnPreview.enabled := true;
    end else
      close;
  end;
end;

procedure tfrmMyPrintDlg.SetCover;
begin
  with dmOpenQ do begin
    wwT_Cover.findkey([glbSurveyID,CoverID[ComboCoverLtr.Itemindex]]);
    wwt_Logo.IndexName := 'ByCover';
    wwt_PCL.IndexName := 'ByCover';
    wwt_TextBox.IndexName := 'ByCover';
    wwt_Logo.masterSource := wwDS_Cover;
    wwt_Logo.masterfields := 'Survey_ID;SelCover_ID';
    wwt_PCL.MasterSource := wwDS_Cover;
    wwt_PCL.Masterfields := 'Survey_ID;SelCover_ID';
    wwt_TextBox.MasterSource := wwDS_Cover;
    wwt_TextBox.Masterfields := 'Survey_ID;SelCover_ID';
  end;
end;

procedure tfrmMyPrintDlg.SetSections;
var i : integer;
begin
  with cbMockupLanguage do
    if visible then
      i := strtointdef(trim(copy(items[itemindex],length(items[itemindex])-1,2)),1)
    else
      i := 1;
  dmOpenQ.CurrentLanguage := i;
  if frmLayoutCalc.IncludeQstns then
    with dmOpenq.ww_Query do begin
      close;
      Databasename := '_PRIV';
      SQL.clear;
      SQL.add('Update Sel_Qstns Set Type=''Mockup'' where Subtype=3 and language='+inttostr(i)+' and (');
      for i := 0 to CheckListSections.Items.count-1 do
        if CheckListSections.Checked[i] then
          SQL.add(' '+qpc_Section+'='+inttostr(sectionid[i])+' OR ');
      if SQL.count = 1 then
        sql.add(' '+qpc_Section+'>0 OR ');
      SQL.add(' 1=2)');
      ExecSQL;
    end;
  dmOpenQ.wwt_Qstns.OnFilterRecord := dmOpenQ.LanguageFilterRecord;
  dmOpenQ.wwt_Scls.OnFilterRecord := dmOpenQ.LanguageFilterRecord;
  dmOpenQ.wwt_Textbox.OnFilterRecord := dmOpenQ.LanguageFilterRecord;
  dmOpenQ.wwt_PCL.OnFilterRecord := dmOpenQ.LanguageFilterRecord;
end;

procedure tfrmMyPrintDlg.ResetCover;
begin
  with dmOpenQ do begin
    wwt_Logo.masterSource := nil;
    wwt_PCL.MasterSource := nil;
    wwt_TextBox.MasterSource := nil;
    wwt_Logo.IndexFieldnames := '';
    wwt_PCL.IndexFieldnames := '';
    wwt_TextBox.IndexFieldnames := '';
  end;
end;

procedure tfrmMyPrintDlg.ResetSections;
begin
  if frmLayoutCalc.IncludeQstns then
    with dmOpenq.ww_Query do begin
      close;
      Databasename := '_PRIV';
      SQL.clear;
      SQL.add('Update Sel_Qstns Set Type=''Question'' where Type=''Mockup''');
      ExecSQL;
    end;
  dmOpenQ.wwt_Qstns.OnFilterRecord := dmOpenQ.wwt_QstnsFilterRecord;
  dmOpenQ.wwt_Scls.OnFilterRecord := dmOpenQ.EnglishFilterRecord;
  dmOpenQ.wwt_Textbox.OnFilterRecord := dmOpenQ.EnglishFilterRecord;
  dmOpenQ.wwt_PCL.OnFilterRecord := dmOpenQ.EnglishFilterRecord;
end;

procedure TfrmMyPrintDlg.seCopiesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if seCopies.value < 1 then seCopies.value := 1;
end;

procedure TfrmMyPrintDlg.seCopiesExit(Sender: TObject);
begin
  if seCopies.value < 1 then seCopies.value := 1;
end;

//GN01: silent install DQCalcPrinter
function TfrmMyPrintDlg.installDQCalcPrn : Boolean;
var
  i        : integer;
  SEInfo   : TShellExecuteInfo;
  ExitCode : DWORD;
  ExecuteFile,
  ParamString,
  StartInString: string;

begin

  i := 0;
  //check if the printer is installed
  while (i<printer.printers.count-1) and (copy(printer.printers[i],1,13)<>'DQCalcPrinter') do
      inc(i);
    result := copy(printer.printers[i],1,13)='DQCalcPrinter';
    if not result then begin

      ChDir('C:\WINDOWS\system32');
      //StartInString := 'C:\WINDOWS\system32';
      ExecuteFile:='C:\WINDOWS\system32\cmd.exe';
      ParamString := '/C cscript prnmngr.vbs -a -p DQCalcPrinter -m "HP LaserJet IIISi" -r c:\temp\pcl.prn ' + #0;

      FillChar(SEInfo, SizeOf(SEInfo), 0);
      SEInfo.cbSize := SizeOf(TShellExecuteInfo);
      with SEInfo do begin
        fMask := SEE_MASK_NOCLOSEPROCESS;
        Wnd := Application.Handle;
        lpFile := PChar(ExecuteFile);

        //ParamString contains the  application parameters.
        lpParameters := PChar(ParamString);

        //StartInString specifies the  name of the working directory.
        //If ommited, the current directory is used.
        //lpDirectory := PChar(StartInString);
        nShow :=  SW_HIDE; //SW_SHOWNORMAL;
      end;
      if ShellExecuteEx(@SEInfo) then begin
        {
        repeat
          Application.ProcessMessages;
          GetExitCodeProcess(SEInfo.hProcess, ExitCode);
        until (ExitCode <> STILL_ACTIVE) or
               Application.Terminated;
        }
        //You can force a rebuild of the printer list the hard way with
        Printer.Free;
        SetPrinter( TPrinter.Create );
        result := true;
      end
      else begin
        ShowMessage('Error installing DQCalc Printer. Please contact Helpdesk!');
        result := false;

      end;
    end;


end;


end.
