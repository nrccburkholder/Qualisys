unit dPCLGen;

{*******************************************************************************
Program Modifications:

--------------------------------------------------------------------------------
Date        UserID  Description
--------------------------------------------------------------------------------
11-07-2005  GN01    Reading the SMTP Host information from the database instead of
                    the registry

12-19-2005  GN02    Add Survey Name to the subject line of the test print emails.

10-03-2006  GN03    Attempt to find the missing questions from BubblePos

12-06-2006  GN04    @message NVARCHAR(4000), VARCHAR(8000)
                    Body text of the email message. The maximum line length is 1000 characters.
                    Lines need to be separated using a carriage return linefeed (\r\n or using T-SQL char(13) | char(10)).

********************************************************************************}

{$DEFINE TrapErrors}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls,Db, DBTables, Wwquery, Wwtable, ExtCtrls, Filectrl, BDE,isp3,comobj,math;

type
  TdmPCLGen = class(TDataModule)
    wwQ_NextBatch: TwwQuery;
    wwT_MyPCLNeeded: TwwTable;
    wwSQLQuery: TwwQuery;
    wwT_LocalSelCover: TwwTable;
    wwT_LocalSelLogo: TwwTable;
    wwT_LocalSelPCL: TwwTable;
    wwT_LocalSelSkip: TwwTable;
    wwT_LocalSelQstns: TwwTable;
    wwT_LocalSelScls: TwwTable;
    wwT_LocalSelTextBox: TwwTable;
    wwLocalQuery: TwwQuery;
    wwT_LocalPCLOutput: TwwTable;
    wwT_SQLPCLOutput: TwwTable;
    BatchMove: TBatchMove;
    wwT_KVPopSection: TwwTable;
    wwT_KVPopCover: TwwTable;
    wwT_KVPopCode: TwwTable;
    Timer: TTimer;
    wwQ_Log: TwwQuery;
    t_PCLr: TTable;
    wwt_LocalPopSection: TwwTable;
    wwt_LocalPopCover: TwwTable;
    wwt_LocalPopCode: TwwTable;
    procedure dmPCLGenCreate(Sender: TObject);
    procedure dmPCLGenDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations}
    PageCount : array[1..6] of integer;
    logSQLQuery : boolean;
    DODSurveys : string;
    SMTPHost   : string;
    function GetNextBatch:integer;
    procedure MakeLocalTables;
    procedure MainLoop;
    procedure LoadStaticTables;
    procedure LoadPersonalizedTables;
    procedure Generate;
    procedure LocalQuery(const Qry:string; const Exe:boolean);
    procedure ExecSQL_with_Deadlocks;
    procedure QPQuery(const Qry:string; var wwQry:TwwQuery;const Exe:boolean);
    procedure ScanQuery(const Qry:string; const Exe:boolean);
    procedure QueueQuery(const Qry:string; const Exe:boolean);
    procedure LoadSQL(const Qry,PCLNeededField,KeyViolationTbl:string; var tbl:twwTable);
    procedure LoadAPatient;
    procedure processBMPs;
    procedure emptytable(var tbl:twwTable);
    procedure CreateMyTables;
    procedure deletebatch;
    procedure CleanMockupDirectory;
{$IFDEF TrapErrors}
    procedure LogError;
{$ENDIF}
    procedure ViewData(var ds:tDataset);
    function sp_exists(strDB: string; const s:string):boolean;
    procedure myBatchMove(var TS,TD:twwTable);
    procedure Notify;
    procedure MoveFiles;
  public
    CurrentBatch,CurrentRun : integer;
    TestPrints : boolean;
    whereField:string;
    strTP : string;
    reload,shutdown : boolean;
    sp_PCL_NextBatch,
    sp_PCL_CleanBatch,
    sp_PCL_EndRun,
    sp_PCL_insertinto_bblloc,
    sp_PCL_insertinto_cmntloc,
    sp_PCL_insertinto_PCLresults,
    sp_PCL_insertinto_PCLqstnfrm,
    sp_PCL_CleanUpErrors,
    sp_RaiseError,
    sp_PCL_RaiseError,
    sp_Load_Sel_PCL : boolean;
    QF_id, S_id, SM_id, SP_id, Pat_id : string;
    QstnCnt, BubbleCnt : integer;
    LithoCode:integer;
    Bundle,GroupDest:string;
    createok:boolean;
    SMTPAvailable:boolean;
    procedure PCLGeneration;
    procedure ShowErrorLog;
    Procedure MakePopSection(const tblnm:string; var tbl:TwwTable);
    Procedure MakePopCover(const tblnm:string; var tbl:TwwTable);
    Procedure MakePopCode(const tblnm:string; var tbl:TwwTable);
    { Public declarations }
  end;

const
  {PaperSizes - from dbo.PaperSize}
  psLtr = 1;
  psLgl = 2;
  psTbld = 3;
  psLtrHd = 4;
  psDblLgl = 5;
  psPostcard = 6;

var
  //filelist:tstringlist;
  fiesrs:variant;
  dmPCLGen: TdmPCLGen;
  smtp1 : tsmtp;
  PdfPath,PrnPath:string;
  Email,Survey_id:string;
  Mockup:boolean;
  ww_sql:TwwQuery;
  
implementation

uses DOpenQ, uLayoutCalc, fViewData, fPCLGen, common;

{$R *.DFM}


procedure tdmPCLGen.ViewData(var ds:tDataset);
begin
  frmViewData := TfrmViewData.Create( Self );
  with frmViewData do
  try
    datasource1.dataset := ds;
    caption := ds.name;
    showmodal;
  finally
    Release;
  end;
end;

procedure tdmPCLGen.CleanMockupDirectory;
var numDays:integer;
begin
  QPQuery('select numParam_value, datediff(hour,datParam_value,getdate()) as HoursSinceLastCleaning '+
          'from qualpro_params '+
          'where strParam_nm =''PCLGenCleanMockupDir''',wwSQLQuery,false);
  if (wwSQLQuery.recordcount > 0) and (wwSQLQuery.FieldByName('HoursSinceLastCleaning').value >= 24) then begin
    numDays := wwSQLQuery.FieldByName('numParam_value').value;
    QPQuery('update QualPro_params '+
            'set datParam_value=getdate() '+
            'where STRPARAM_NM =''PCLGenCleanMockupDir''',wwSQLQuery,true);
    DelOlderThan(pdfpath+'*.pdf',numDays);
  end;
  wwSQLQuery.Close;
end;

procedure tdmPCLGen.PCLGeneration;
begin
{$IFDEF TrapErrors}
  try
{$ENDIF}
    frmPCLGeneration.ProgressReport('ComputerName: '+frmPCLGeneration.CompName,'','');
    frmPCLGeneration.ProgressReport('ExecutableName: '+ExtractFileName(Application.ExeName),'','');
    frmPCLGeneration.ProgressReport('Net File Dir: '+session.netfiledir,'','');
    frmPCLGeneration.ProgressReport('Environment: '+dmOpenQ.EnvName,'','');
    sp_Load_Sel_PCL := sp_exists('Q','sp_PCL_load_sel_PCL');
    sp_RaiseError := sp_exists('Q','sp_RaiseError');
    sp_PCL_RaiseError := sp_exists('Q','sp_PCL_RaiseError');
    sp_PCL_NextBatch := sp_exists('Q','sp_PCL_NextBatch');
    sp_PCL_CleanBatch := sp_exists('Q','sp_PCL_CleanBatch');
    sp_PCL_EndRun := sp_exists('Q','sp_PCL_EndRun');
    sp_PCL_insertinto_bblloc := sp_exists('S','sp_PCL_insertinto_bblloc');
    sp_PCL_insertinto_cmntloc := sp_exists('S','sp_PCL_insertinto_cmntloc');
    sp_PCL_insertinto_PCLresults := sp_exists('S','sp_PCL_insertinto_PCLresults');
    sp_PCL_insertinto_PCLqstnfrm := sp_exists('S','sp_PCL_insertinto_PCLqstnfrm');
    sp_PCL_CleanUpErrors := sp_exists('Q','sp_PCL_CleanUpErrors');
    if (not sp_PCL_nextbatch) or
       (not sp_PCL_cleanbatch) or
       (not sp_PCL_EndRun) or
       (not sp_PCL_insertinto_bblloc) or
       (not sp_PCL_insertinto_cmntloc) or
       (not sp_PCL_insertinto_PCLresults) or
       (not sp_PCL_insertinto_PCLqstnfrm) then begin
      messagedlg('Required stored procedure doesn''t exist in this environment.  PCLGen will be shut down.',mterror,[mbok],0);
      halt(1);
    end else begin
      QPQuery('select strParam_value from Qualpro_params where strParam_nm=''DODSurveys''',wwSQLQuery,false);
      with wwSQLQuery do begin
        if fieldbyname('strParam_value').isNull then
          DODSurveys := ''
        else begin
          DODSurveys := ','+fieldbyname('strParam_value').asString+',';
          while pos(' ',DODSurveys)>0 do
            mydelete(DODSurveys,pos(' ',DODSurveys),1);
        end;
        close;
      end;
      CreateMyTables;
      if GetNextBatch>0 then
        MainLoop
      else begin
        Timer.Enabled := true;
        CleanMockupDirectory;
        dmopenq.dbQualPro.keepconnection := false;
        dmopenq.dbQualPro.close;
        dmopenq.dbScan.keepconnection := false;
        dmopenq.dbScan.close;
        frmPCLGeneration.ProgressReport('Waiting for PCLNeeded'+strTP+' to be populated','','');
      end;
    end;
{$IFDEF TrapErrors}
  except
    on e:exception do begin
      frmPCLGeneration.progressreport('Error! '+e.message,'','');
      if sp_RaiseError then
        //GN03
        QPQuery('exec sp_RaiseError 1, ' + dmopenq.sqlstring(frmPCLGeneration.CompName + ' PCLGen', false) + ', ' + dmopenq.sqlstring(e.message,false),wwSQLQuery,true);
      //MessageDlg(E.Message,mterror,[mbok],0);
    end;
  end;
{$ENDIF}
  frmPCLGeneration.progressreport('End of PCLGeneration procedure','','');
end;

procedure tdmPCLGen.LocalQuery(const Qry:string; const Exe:boolean);
begin
    with wwLocalQuery do begin
      close;
      sql.clear;
      sql.add(qry);
      if logSQLQuery then
        frmPCLGeneration.ProgressReport('[L] '+qry,'','');
      if Exe then
        ExecSQL
      else
        open;
    end;
end;

procedure tdmPCLGen.ExecSQL_with_Deadlocks;
var success : boolean;
begin
  success := false;
  repeat begin
    with wwSQLQuery do begin
      close;
      try
        ExecSQL;
        success := true;
      except
        on e:exception do
          if pos('deadlock',lowercase(e.message))=0 then
            raise
          else begin
            frmPCLGeneration.ProgressReport('  deadlock .. try again','','');
          end;
      end;
    end;
  end until
    success;
end;

procedure tdmPCLGen.QPQuery(const Qry:string; var wwQry:TwwQuery;const Exe:boolean);
var success : boolean;
begin
  success := false;
  repeat begin
    with wwQry  do begin
      close;
      databasename := '_QualPro';
      sql.clear;
      sql.add(qry);
      if logSQLQuery then
         frmPCLGeneration.ProgressReport('[S] '+qry,'','');
      try
        if exe then
          ExecSQL
        else
          open;
        success := true;
      except
        on e:exception do
          if pos('deadlock',lowercase(e.message))=0 then
            raise
          else begin
            if not logSQLQuery then
              frmPCLGeneration.ProgressReport('[S] '+qry,'','');
            frmPCLGeneration.ProgressReport('  deadlock .. try again','','');
          end;
      end;
    end;
  end until
    success;
end;

procedure tdmPCLGen.ScanQuery(const Qry:string; const Exe:boolean);
var success : boolean;
begin
  success := false;
  repeat begin
    with wwSQLQuery do begin
      close;
      databasename := '_Scan';
      sql.clear;
      sql.add(qry);
      if logSQLQuery then
         frmPCLGeneration.ProgressReport('[S] '+qry,'','');
      try
        if exe then
          ExecSQL
        else
          open;
        success := true;
      except
        on e:exception do
          if pos('deadlock',lowercase(e.message))=0 then
            raise
          else begin
            if not logSQLQuery then
              frmPCLGeneration.ProgressReport('[S] '+qry,'','');
            frmPCLGeneration.ProgressReport('  deadlock .. try again','','');
          end;
      end;
    end;
  end until
    success;
end;

procedure tdmPCLGen.QueueQuery(const Qry:string; const Exe:boolean);
var success : boolean;
begin
  success := false;
  repeat begin
    with wwSQLQuery do begin
      close;
      databasename := '_Queue';
      sql.clear;
      sql.add(qry);
      if logSQLQuery then
         frmPCLGeneration.ProgressReport('[S] '+qry,'','');
      try
        if exe then
          ExecSQL
        else
          open;
        success := true;
      except
        on e:exception do
          if pos('deadlock',lowercase(e.message))=0 then
            raise
          else begin
            if not logSQLQuery then
              frmPCLGeneration.ProgressReport('[S] '+qry,'','');
            frmPCLGeneration.ProgressReport('  deadlock .. try again','','');
          end;
      end;
    end;
  end until
    success;
end;

function tdmPCLgen.sp_exists(strDB: string; const s:string):boolean;
begin
  if strDB='Q' then
    QPQuery('select name from sysobjects where lower(name)='''+lowercase(s)+'''',wwSQLQuery,false)
  else
    ScanQuery('select name from sysobjects where lower(name)='''+lowercase(s)+'''',false);
  result := (wwSQLQuery.recordcount=1);
  if result then
    frmPCLGeneration.progressreport(s+' exists','','')
  else
    frmPCLGeneration.progressreport(s+' doesn''t exist','','');
  wwSQLQuery.close;
end;

procedure tdmPCLGen.LoadSQL(const Qry,PCLNeededField,KeyViolationTbl:string; var tbl:twwTable);
var delquery : string;
    errortime : string;
begin
  frmPCLGeneration.ProgressReport('  '+tbl.tablename,'','');
  emptytable(tbl);
  if (tbl.tablename=wwt_LocalSelPCL.tablename) and sp_load_sel_PCL then begin
    if TestPrints then
      QPQuery('exec sp_PCL_Load_Sel_PCL_tp '+inttostr(currentBatch),wwSQLQuery,false)
    else
      QPQuery('exec sp_PCL_Load_Sel_PCL '+inttostr(currentBatch),wwSQLQuery,false);
  end else
    QPQuery(Qry,wwSQLQuery,false);

  with batchmove do begin
    source := wwSQLQuery;
    destination := tbl;
    if KeyViolationTbl = '' then begin
      KeyViolTableName := '';
      AbortOnKeyViol := true;
    end else begin
      KeyViolTableName := KeyViolationTbl;
      AbortOnKeyViol := false;
      localquery('delete from '+KeyViolationTbl,true);
    end;
    mode := batAppend;
    mappings.clear;
    if tbl.name = 'wwT_LocalSelLogo' then begin
      mappings.add('Survey_ID');
      mappings.add(qpc_ID);
      mappings.add('CoverID');
      mappings.add('Type');
      mappings.add('Description');
      mappings.add('X');
      mappings.add('Y');
      mappings.add('Width');
      mappings.add('Height');
      mappings.add('Scaling');
      {mappings.add('Bitmap');}
      mappings.add('Visible');
    end;

    //frmPCLGeneration.ProgressReport('  start batchmove','','');
    execute;
    //frmPCLGeneration.ProgressReport('  finished batchmove,'','');
    if (KeyViolationTbl <> '') and (KeyViolCount>0) then begin
      LocalQuery('Select distinct '+PCLNeededField+' from '+KeyViolationTbl,false);
      with wwLocalQuery do begin
        delQuery := 'update #MyPCLNeeded set Batch_id=-'+inttostr(dmopenq.GenError)+' where (';
        while not eof do begin
          delQuery := delQuery + PCLNeededField + '='+fieldbyname(PCLNeededField).text+' or ';
          next;
        end;
        close;
        delQuery := delQuery + '1=2)';
      end;
      errortime := ''''+FormatDateTime('mm/dd/yyyy hh:mm:ss".'+copy(inttostr(1000+random(1000)),2,3)+'" AM/PM', now)+'''';
      with wwSQLQuery do begin
        close;
        sql.clear;
        sql.add(delQuery);
        sql.add('insert into FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)');
        sql.add('(select SM.ScheduledMailing_id, convert(datetime,'+errortime+') as datGenerated, '+inttostr(dmopenq.GenError)+' as FGErrorType_id');
        sql.add(' from #MyPCLNeeded, ScheduledMailing SM');
        sql.add(' where #MyPCLNeeded.SentMail_id=SM.SentMail_id and #MyPCLNeeded.batch_id=-'+inttostr(dmopenq.GenError)+')');

        {on second thought, let's leave error'd records in PCLNeeded, but keep bitDone=true.
         This way, investigating what went wrong will be easier, and if we need to
         clear them out, we'll call sp_PCL_CleanUpErrors
        sql.add('delete PCLNeeded from PCLNeeded, #MyPCLNeeded');
        sql.add(' where #MyPCLNeeded.'+PCLNeededField+'=PCLNeeded.'+PCLNeededField);
        sql.add(' and #MyPCLNeeded.batch_id=-'+inttostr(dmopenq.GenError));
        }

        sql.add('delete from #MyPCLNeeded where Batch_id=-'+inttostr(dmopenq.GenError)+'');
        ExecSQL_with_Deadlocks;
        { sp_PCL_CleanUpErrors deletes records out of PCLGen's output tables, PCLOutput, BubblePos, etc.
          If a questionnaire has failed at this level (i.e. because of key violations when downloading
          the *_Individual tables) there won't have been any inserts into the output tables.  Therefore,
          a call to sp_PCL_CleanUpErrors is unneccesary.
        sql.clear;
        sql.add('execute sp_PCL_CleanUpErrors '+errortime);
        ExecSQL;
        }
      end;
      delete(delQuery,8,1); {Gets rid of the "#" before #MyPCLNeeded}
      LocalQuery(delQuery,true);
      LocalQuery('Delete from MyPCLNeeded where Batch_id=-'+inttostr(dmopenq.GenError)+'',true);
      reload := true;
      frmPCLGeneration.ProgressReport('  Error! (Key Violation records written to '+KeyViolationTbl+')','','');
    end;
  end;
end;

procedure tdmPCLGen.LoadStaticTables;
var vID,vCover,vSurvey : integer;
    vBitmapName : string;
begin
  frmPCLGeneration.ProgressReport('Load Static Tables','','');
  LoadSQL('Select Q.Survey_ID, Q.SelQstns_ID, '+
     'Q.Language, Q.Section_id, ''Question'' as Type, Q.Label, Q.PlusMinus, '+
     'Q.Subsection, Q.Item, Q.Subtype, Q.ScaleID, Q.Width, Q.Height, Q.RichText, '+
     'Q.QstnCore, Q.ScalePos, Q.bitLangReview, Q.bitMeanable, Q.numMarkCount, '+
     'Q.numBubbleCount, Q.ScaleFlipped '+
     'From PCL_Qstns'+strTP+' Q '+
     'where Q.survey_id in '+
     '(select P.survey_id From #MyPCLNeeded P where P.Batch_id='+inttostr(currentBatch)+')',
     '','',wwt_LocalSelQstns);

  LoadSQL('Select S.Survey_ID, S.QPC_ID, S.Item, S.Language, '+
    '''Scale'' as Type, S.Label, S.CharSet, S.Val, S.RichText, S.ScaleOrder, '+
    'S.intRespType, S.Missing '+
    'From PCL_Scls'+strTP+' S '+
    'where s.survey_id in '+
    '(select P.survey_id From #MyPCLNeeded P where P.Batch_id='+inttostr(currentBatch)+')',
    '','',wwt_LocalSelScls);

  LoadSQL('Select T.Survey_ID, T.QPC_ID, T.Language, T.CoverID, '+
    '''Textbox'' as Type, ''dont care'' as Label, T.X, T.Y, T.Width, T.Height, T.RichText, T.Border, '+
    'T.Shading, T.bitLangReview '+
    'From PCL_TextBox'+strTP+' T, (select distinct Survey_id, SelCover_id, Language From #MyPCLNeeded where Batch_id='+inttostr(currentBatch)+') P '+
    'where T.Survey_id = P.Survey_id and T.CoverID=P.SelCover_id and T.Language=P.Language',
    '','',wwt_LocalSelTextBox);

  LoadSQL('Select distinct sc.Survey_ID, sc.SelCover_ID, PageType, ''Cover'' as Type, '+
     'Description, Integrated, bitLetterHead from PCL_Cover'+strTP+' SC, PCLNeeded'+strTP+' P '+
     'where P.survey_id = SC.survey_id and SC.Selcover_id=P.selcover_id '+
     'and P.Batch_id='+inttostr(currentBatch),'','',wwt_LocalSelCover);

  LoadSQL('Select distinct sl.Survey_ID, sl.'+qpc_ID+', sl.CoverID, ''Logo'' as Type, Description, X, Y, '+
     'Width, Height, Scaling, /*Bitmap,*/ Visible /*, '''' as PCLStream*/ '+
     'from PCL_Logo'+strTP+' SL, PCLNeeded'+strTP+' P '+
     'where P.survey_id = SL.survey_id and SL.Coverid=P.selcover_id '+
     'and P.Batch_id='+inttostr(currentBatch),'','',wwt_LocalSelLogo);

  if (TestPrints) then
     DMOpenQ.t_Logo_SQL.tablename := 'dbo.PCL_Logo_tp'
  else
     DMOpenQ.t_Logo_SQL.tablename := 'dbo.PCL_Logo';
  DMOpenQ.t_Logo_SQL.open;
  with wwt_LocalSelLogo do begin
    first;
    while not eof do begin
      vID := fieldbyname(qpc_ID).value;
      vCover := fieldbyname('CoverID').value;
      vSurvey := fieldbyname('Survey_id').value;
      vBitmapName := fieldbyname('Description').value;
      frmPCLGeneration.ProgressReport(format('  Loading Logo %d-%d-%d (%s)',[vSurvey,vCover,vID,vBitmapName]),'','');
      dmOpenQ.t_Logo_SQL.findkey([vID,vCover,vSurvey]);
      edit;
      fieldbyname('Bitmap').assign(dmopenq.t_logo_sql.fieldbyname('Bitmap'));
      post;
      next;
    end;
  end;
  DMOpenQ.t_Logo_SQL.close;

  // uses "exists"
  LoadSQL('Select Survey_ID, '+qpc_id+', Language, CoverID, ''PCL'' as Type, '+
     'Description, X, Y, Width, Height, PCLStream, KnownDimensions '+
     'from PCL_PCL'+strTP+' SP where exists (Select * from PCLNeeded'+strTP+' P '+
     'where P.survey_id = SP.survey_id and SP.Coverid=P.selcover_id '+
     'and P.Batch_id='+inttostr(currentBatch)+')','','',wwt_LocalSelPCL);

  LoadSQL('Select distinct ss.Survey_ID, ss.SelQstns_ID, ss.SelScls_ID, ScaleItem, '+
     '''Skip'' as Type, numSkip, numSkipType from PCL_Skip'+strTP+' SS, '+
     'PCLNeeded'+strTP+' P where P.survey_id = SS.survey_id '+
     'and P.Batch_id='+inttostr(currentBatch),'','',wwt_LocalSelSkip);
end;

procedure tdmPCLGen.LoadPersonalizedTables;
var s:string;
begin
//  try
    frmPCLGeneration.ProgressReport('Load Personalized Tables','','');
    s:='select ps.'+WhereField+' as SentMail_id, section_id, sampleunit_id, ps.survey_id, langid '+
        'from FGPopSection'+strTP+' PS, #MyPCLNeeded PN '+
        'where PS.'+WhereField+'=PN.SentMail_id '+
        'and PN.batch_id='+
        inttostr(currentBatch);
    dmopenQ.GenError := 32;
    LoadSQL(s,'SentMail_id',wwt_KVPopSection.tablename,wwt_LocalPopSection);

    dmopenQ.GenError := 33;
    LoadSQL('select pc.'+WhereField+' as SentMail_id, pc.SelCover_id, pc.survey_id, langid '+
        'from FGPopCover'+strTP+' PC, #MyPCLNeeded PN '+
        'where PC.'+WhereField+'=PN.SentMail_id '+
        'and PN.batch_id='+
        inttostr(currentBatch),'SentMail_id',wwt_KVPopCover.tablename,wwt_LocalPopCover);

    dmopenQ.GenError := 34;
    LoadSQL('select pc.'+WhereField+' as SentMail_id, pc.sampleunit_id, code, pc.survey_id, pc.language, codetext '+
        'from FGPopCode'+strTP+' PC, #MyPCLNeeded PN '+
        'where PC.'+WhereField+'=PN.SentMail_id '+
        'and PN.batch_id='+
        inttostr(currentBatch),'SentMail_id',wwt_KVPopCode.tablename,wwt_LocalPopCode);

//  except
//    shutdown := true;
//    frmPCLGeneration.ProgressReport('  Error loading personalized tables','','');
//    frmPCLGeneration.ProgressReport('  Reseting bitdone to 0 for batch '+inttostr(currentbatch),'','');
//    QPQuery('Update PCLNeeded set bitdone=0 where batch_id='+inttostr(currentbatch),true);
//    frmPCLGeneration.ProgressReport('  beginning PCLGen shutdown','','');
//  end;
end;

procedure tdmPCLGen.emptytable(var tbl:twwTable);
begin
  with tbl do begin
    filtered := false;
    indexfieldnames := '';
  end;
  LocalQuery('Delete from '+tbl.tablename,true);
end;

procedure tdmPCLGen.LoadAPatient;
var CoverID : integer;
  procedure LoadQuery(qry:string; var desttbl:twwTable);
  var i : integer;
  begin
    emptytable(desttbl);
    LocalQuery(qry,false);
    with dmOpenQ.batchmove do begin
      source := wwLocalQuery;
      destination := desttbl;
      mode := batAppend;
      mappings.clear;
      for i := 0 to wwLocalQuery.FieldCount - 1 do
        if (lowercase(wwLocalQuery.Fields[i].FieldName) <> 'bitmap') then
          mappings.add(wwLocalQuery.Fields[i].FieldName);
      execute;
    end;
    wwLocalQuery.close;
  end;
  procedure LoadTable(const key:string; var srctbl,desttbl:twwTable; const Cvr,Lang:byte);
  var q : string;
      //i : integer;
  begin
    q := 'Select * from '+srctbl.tablename+
      ' where Survey_id='+S_ID;
    if key<>'' then
      q := q + ' and '+key+'='+wwt_MyPCLNeeded.fieldbyname(key).asString;
    if lang=1 then
      q := q + ' and language='+wwt_MyPCLNeeded.fieldbyname('language').asstring;
    case cvr of
      1 : q := q + ' and SelCover_ID='+inttostr(CoverID);
      2 : q := q + ' and CoverID='+inttostr(CoverID);
    end;
    LoadQuery(q,desttbl);
  end;

  //GN03: Expected count for questions and bubbles 
  procedure LogQuestionCount;
  begin
    QstnCnt   := 0;
    BubbleCnt := 0;
    //QF_id is null for cover letter, pre notes
    if StrToIntDef(qf_id,0) > 0 then 
    begin
       LocalQuery('select Count(QstnCore) as QstnCnt'+
               ' from LocalSelQstns'+
               ' where Survey_id='+S_ID+
               ' and section_id in (select section_id from LocalPopSection where SentMail_id='+pat_id+')'+
               ' and language='+wwt_MyPCLNeeded.fieldbyname('language').asstring +
               ' and  subtype=1', false);
       if wwLocalQuery.RecordCount > 0 then
          QstnCnt := wwLocalQuery.Fields[0].Value ;

       {LocalQuery('select Sum(numBubbleCount) as BubbleCnt'+
               ' from LocalSelQstns'+
               ' where Survey_id='+S_ID+
               ' and section_id in (select section_id from LocalPopSection where SentMail_id='+pat_id+')'+
               ' and language='+wwt_MyPCLNeeded.fieldbyname('language').asstring +
               ' and  subtype=1', false);}
       LocalQuery('select count(*) as BubbleCnt                                  '+
               ' from LocalSelQstns q left join LocalSelScls s                   '+
               ' on (q.scaleid = s.qpc_id and q.SURVEY_ID = s.survey_id and q.language = s.language) '+
               ' where q.Survey_id='+S_ID+
               ' and q.section_id in (select section_id from LocalPopSection where SentMail_id='+pat_id+')'+
               ' and q.language='+wwt_MyPCLNeeded.fieldbyname('language').asstring +
               ' and q.subtype=1', false);

       if wwLocalQuery.RecordCount > 0 then
          BubbleCnt := wwLocalQuery.Fields[0].Value ;

       wwLocalQuery.Close;

       QPQuery('update questionform set QstnCoreCnt='+IntToStr(QstnCnt)+ ' ,BubbleCnt='+IntToStr(BubbleCnt) + ' where QuestionForm_id='+QF_id,wwSQLQuery,true);
    end;
  end;
begin
  CoverID := wwt_MyPCLNeeded.fieldbyname('SelCover_id').value;
  S_ID := wwt_MyPCLNeeded.fieldbyname('Survey_id').asstring;
  SM_id := wwt_myPCLNeeded.fieldbyname('SentMail_id').asstring;
  QF_id := wwt_myPCLNeeded.fieldbyname('QuestionForm_id').asstring;
  SP_id := wwt_myPCLNeeded.fieldbyname('Samplepop_id').asstring;
  Pat_id := wwt_myPCLNeeded.fieldbyname('SentMail_id').asstring;
  LithoCode:=wwt_myPCLNeeded.fieldbyname('LithoCode').asInteger;
  Bundle:=wwt_myPCLNeeded.fieldbyname('Bundle').asstring;
  GroupDest:=wwt_myPCLNeeded.fieldbyname('GroupDest').asstring;
  dmOpenQ.CurrentLanguage := wwt_myPCLNeeded.fieldbyname('Language').value;
  dmOpenQ.glbSurveyID := strtoint(s_id);
  LoadTable('',wwt_LocalSelCover,dmOpenQ.wwt_Cover,1,0);
  LoadTable('',wwt_LocalSelLogo,dmOpenQ.wwt_logo,2,0);
  LoadTable('',wwt_LocalSelPCL,dmOpenQ.wwt_PCL,2,1);
  LoadTable('',wwt_localSelTextBox,dmopenq.wwt_textbox,2,1);
  LoadQuery('select *'+
            ' from LocalSelQstns'+
            ' where Survey_id='+S_ID+
            ' and section_id in (select section_id from LocalPopSection where SentMail_id='+pat_id+')'+
            ' and language='+wwt_MyPCLNeeded.fieldbyname('language').asstring,dmopenq.wwt_Qstns);
  LogQuestionCount;
  LoadTable('SentMail_id',wwt_localPopSection,dmOpenQ.wwt_PopSection,0,0);
  LoadTable('SentMail_id',wwt_localPopCover,dmOpenQ.wwt_PopCover,0,0);
  LoadTable('SentMail_id',wwt_localPopCode,dmOpenQ.wwt_PopCode,0,0);
  if not wwt_myPCLNeeded.fieldbyname('QuestionForm_id').isnull then begin
    LoadTable('',wwt_localSelScls,dmopenq.wwt_scls,0,1);
    LoadTable('',wwt_LocalSelSkip,dmOpenq.wwt_Skip,0,0);
    FrmLayoutCalc.IncludeQstns := true;
  end else begin
    emptytable(dmopenq.wwt_scls);
    emptytable(dmopenq.wwt_skip);
    FrmLayoutCalc.IncludeQstns := false;
  end;
  frmLayoutCalc.setfonts;
end;

{$IFDEF TrapErrors}
procedure tdmPCLGen.LogError;
begin
  if dmOpenQ.generror=0 then dmOpenQ.GenError:=24;
  frmPCLGeneration.ProgressReport('Error! (' + inttostr(dmopenq.generror)+')','','');
  if SM_id <> '' then begin
    QPQuery('update #MyPCLNeeded set Batch_id=-'+inttostr(abs(dmOpenq.genError))+' where SentMail_id='+SM_ID,wwSQLQuery,true);
    if strtointdef(qf_id,0) > 0 then begin
      ScanQuery('delete from bubbleloc where questionform_id='+qf_id,true);
      ScanQuery('delete from commentloc where questionform_id='+qf_id,true);
      ScanQuery('delete from pclresults where questionform_id='+qf_id,true);
      ScanQuery('delete from pclquestionform where questionform_id='+qf_id,true);
      //GN03, delete from QP_Prod.PCLOutput table before the batch job transfers to QP_Queue.PCLOutput for printing 
//      if dmOpenQ.generror=40 then
//         QPQuery('delete from pcloutput2 where SentMail_id='+SM_ID,wwSQLQuery,true);
    end;
    LocalQuery('delete from LocalPCLOutput where SentMail_id='+SM_ID,true);
  end;
end;
{$ENDIF}

function getreportlines(qry:string{;var Summary:string};includeFields:boolean ):string;
var rs:variant;
    fldlst,fld,s2:string;
    fldszs:array [0..50] of integer;
    i:integer;
begin
    //the reason i'm using adodb.recordset adodb.connection is because I need to
    //get the actual fields sizes and the fielddefs of Wwquery object does not
    //return that information correctly.
    rs:=createoleobject('adodb.recordset');
    s2:='';
    result:='';
    rs.open(qry,dmopenq.sqlcn);
    fldlst:='';
    if not ((rs.eof) and (rs.bof)) then
    begin
      if includefields then
      begin
        for i:=0 to rs.Fields.Count -1 do
        begin
          fld:=rs.Fields[i].name;
          fldszs[i]:=round(MaxValue([rs.Fields[i].ActualSize*1.0,length(fld)*1.0]))+2;
          qry:=format('%%-%ds',[fldszs[i]]);
          fld:=format(qry,[fld]);
          fldlst:=fldlst+fld;
          fillchar(fld[1],fldszs[i]-2,'-');
          s2:=s2+fld;
        end;
        //if (summary = '') then
          //summary:=fldlst+#13#10+s2+#13#10;
        result:=result+fldlst+#13#10+s2+#13#10;
      end;
      while not rs.eof do
      begin
        fldlst:='';
        for i:=0 to rs.Fields.Count -1 do
        begin
          fld:=vartostr(rs.Fields[i].value);
          qry:=format('%%-%ds',[fldszs[i]]);
          fld:=format(qry,[fld]);
          fldlst:=fldlst+fld;
        end;
        //summary:=summary+fldlst+#13#10;
        result:=result+fldlst+#13#10;
        rs.movenext;
      end;
    end;
    rs.close;
    rs:=unassigned;
end;

procedure TdmPCLGen.Notify;
var
 t:tdatetime;
 i, j, k :integer;
 strTo,strSubject,strBody:string;
 s{,fn,summary}:string;
 SurveyNM      :string;
begin
  //GN01
  {
  if SMTPAvailable then begin
    SMTPHost := GetRegistryEntry(HKEY_CURRENT_USER,'Software\National Research\PCLGen','SMTPHost');
    if SMTPHost='' then
      SMTPAvailable := false;
  end;
  }

  strBody:='';
  if mockup then
    strSubject:='your Test Print mockups'
  else
  begin
    strSubject:='your Test Prints';
    strBody:='These documents contain protected health information.  Please safeguard this information '#13#10+
           'in accordance with NRC''s policies and procedures.  Access to these documents is restricted '#13#10+
           'to authorized associates only and they shall not be transmitted outside National Research '#13#10+
           'Corporation. '#13#10#13#10;
  end;

  strTo:=email;
  if (length(strTo) >0) and (pos('@', strTo) = 0) then
  begin
    strTo:=strTo+'@nationalresearch.com';
  end;
  QPQuery('select * from #printfiles',ww_sql,false) ;
  while not ww_sql.eof do
  begin
    strBody:=strBody+'------------------------------------------------------------------------------------------'#13#10;
    if ww_sql.fieldbyname('Copied').asboolean then
       strBody:=strBody+pdfpath+trim(ww_sql.fieldbyname('FileName').asstring)+#13#10
    else
       strBody:=strBody+'There was a problem creating '+pdfpath+trim(ww_sql.fieldbyname('FileName').asstring)+#13#10#13#10;

    strBody:=strBody+getreportLines('sp_TP_PopInfo1 @Survey_id='+Survey_id+', @tp_id ='+ww_sql.fieldbyname('tp_id').asstring,false)+#13#10;
    s:=getreportLines('sp_TP_PopInfo2 @Survey_id='+Survey_id+', @tp_id ='+ww_sql.fieldbyname('tp_id').asstring,true);
    if s= '' then
      s:='There was a problem with tp_id '+ww_sql.fieldbyname('tp_id').asstring;
    strBody:=strBody+s+#13#10+#13#10;

    j := Pos('Survey:', strBody);
    k := Pos('Cover Letter:', strBody );
    SurveyNM := Copy(strBody, j, k-j);

    ww_sql.Next;
  end;
  ww_sql.close;

  strBody:=strBody+#13#10'This is an automated email. Please do not reply.';
  strSubject := strSubject + ': ' +  SurveyNM; //GN02
  strSubject[1]:='Y';

  if SMTPAvailable then begin
    frmPCLGeneration.progressreport('Sending email notification to <' + strTo +'> using SMTP ' + SMTPHost,'','');

    SMTP1.RemoteHost := SMTPHost;  //10.10.70.107
    SMTP1.DocInput.headers.Add('From', 'TestPrint@'+frmPCLGeneration.CompName+'.com');
    SMTP1.DocInput.headers.Add('To', strTo);
    SMTP1.DocInput.headers.Add('Subject', strSubject);
    SMTP1.SendDoc( 0,SMTP1.DocInput.headers,strBody,0,0);
    t:=now;
    i:= SMTP1.State;
    while t+15/1440/60> now do     //wait 15 seconds
    begin                         //to allow for email to be sent;
       SMTP1.State;
       Application.ProcessMessages;
    end;
  end else begin
    frmPCLGeneration.progressreport('sending email notification using sp_send_dbmail to ' + strTo + ' subject length=' + IntToStr(Length(strBody)),'','');
    strTo := substitute(strTo,'''','''''');
    strSubject := substitute(strSubject,'''','''''');
    strBody := substitute(strBody,'''','''''');
    if Length(strBody) > 8000 then
       strBody := Copy(strBody,1,7900) + '***data truncated***' ;//gn04
//    QPQuery(format('exec master.dbo.xp_sendmail @recipients = ''%s'', @subject = ''%s'', @message = ''%s''',[strto, strSubject, strBody]),wwSQLQuery,true);
//    QPQuery(format('exec msdb.dbo.sp_send_dbmail @profile_name = ''ApptixQualisysEmail'', @recipients = ''%s'', @subject = ''%s'', @body = ''%s''',[strto, strSubject, strBody]),wwSQLQuery,true);
    QPQuery(format('exec qp_prod.dbo.NRC10_send_dbmail @recipients = ''%s'', @subject = ''%s'', @body = ''%s''',[strto, strSubject, strBody]),wwSQLQuery,true);
  end;
end;

procedure TdmPCLGen.MoveFiles;
var i:integer;
    fn:string;
    MovedAll:boolean;
begin
  QPQuery('select * from #printfiles where copied=0',ww_sql,false) ;
  for i:= 1 to 30 do
  begin
    frmPCLGeneration.progressreport('checking for complete PDFs','','');
    //dmopenq.sqlcn.execute('waitfor delay ''00:00:20.00'''); //wait 20 secs
    pause(20);
    MovedAll:=true;             //so that we don't create too much network traffic
    while not ww_sql.eof do     //and allow time for pdfs to be created
    begin
      fn:=ww_sql.fieldbyname('FileName').asstring;
      if movefile(pchar(prnpath+fn),pchar(pdfpath+fn)) then
      begin //update flag if file is moved successfully
        frmPCLGeneration.progressreport('copying PDF for tp_id '+ww_sql.fieldbyname('tp_id').asstring ,s_id,ww_sql.fieldbyname('tp_id').asstring);
        QPQuery('update #printfiles set Copied = 1 where tp_id ='+ww_sql.fieldbyname('tp_id').asstring,wwSQLQuery,true);
        fn := copy(fn,1,pos('.prn',lowercase(fn))) + 'log';
        deletefile(pchar(prnpath+fn));
      end
      else
        MovedAll:=false; //not all moved if movedfile failed
      ww_sql.next;
    end;

    if MovedAll then break; //or untill all files are moved;
    ww_sql.close;
    ww_sql.open; //reopen to refress updated records

  end;
  ww_sql.close;
end;


procedure tdmPCLGen.Generate;
const
  PCLCross = #27+'*p-50X'+#27+'*c100a3b0P'+#27+'*p+50x-50Y'+#27+'*c3a100b0P';
  chkPosOn = false;
var chkpos : array[1..10] of string;
    i : integer;
    //reset,pcini,svyini:string;
    //rs,cn:variant;
  function PaperConfig:integer;
  var nm:string;
      i,pages:integer;
      qry : string;
  begin
    Qry := 'Select Paperconfig_id from Paperconfig where'+
      ' intLetterHead='+inttostr(PageCount[psLtrHd])+
      ' and intLetter='+inttostr(PageCount[psLtr])+
      ' and intLegal='+inttostr(PageCount[psLgl])+
      ' and intTabloid='+inttostr(PageCount[psTbld])+
      ' and intDoubleLegal='+inttostr(PageCount[psDblLgl])+
      ' and intPostcard='+inttostr(pagecount[psPostcard]);
    QPQuery(Qry,wwSQLQuery,false);
    if wwSQLQuery.fieldbyname('Paperconfig_id').isnull then begin
      nm := '';
      if PageCount[psLtrHd] = 1 then nm := 'letterhead + ';
      if PageCount[psLtr] >= 1 then nm := nm + inttostr(PageCount[psLtr]) + ' letter + ';
      if PageCount[psLgl] >= 1 then nm := nm + inttostr(PageCount[psLgl]) + ' legal + ';
      if PageCount[psTbld] >= 1 then nm := nm + inttostr(PageCount[psTbld]) + ' tabloid + ';
      if PageCount[psDblLgl] >= 1 then nm := nm + inttostr(PageCount[psDblLgl]) + ' double-legal + ';
      if PageCount[psPostcard] >= 1 then nm := nm + inttostr(PageCount[psPostcard]) + ' postcard + ';
      nm := copy(nm,1,length(nm)-3);
      pages := PageCount[1]+PageCount[2]+PageCount[3]+PageCount[4]+PageCount[5]+PageCount[6];
      QPQuery('insert PaperConfig (strPaperConfig_nm,intLetterHead,intLetter,'+
        'intLegal,intTabloid,intDoubleLegal,intPages,intPostcard) values ('''+nm+''', '+
        inttostr(PageCount[psLtrHd])+', '+inttostr(PageCount[psLtr])+', '+
        inttostr(PageCount[psLgl])+', '+inttostr(PageCount[psTbld])+', '+
        inttostr(PageCount[psDblLgl])+', '+inttostr(pages) + ', ' +
        inttostr(PageCount[psPostcard])+')',wwSQLQuery,true);
      QPQuery(Qry,wwSQLQuery,false);
      result := wwSQLQuery.fieldbyname('Paperconfig_id').value;
      pages := 0;
      if PageCount[psLtr] > 0 then
        inc(pages);
        if PageCount[psLgl]+PageCount[psTbld]+PageCount[psDblLgl]=0 then begin
          QPQuery(format('insert into PaperConfigSheet (paperconfig_id,intSheet_num,papersize_id,intpa,intpb,intpc,intpd) values (%d,%d,1,1,2,0,0)',[result,pages]),wwSQLQuery,true);
        end;
      if PageCount[psLgl] > 0 then
        for i := 1 to PageCount[psLgl] do begin
          inc(pages);
          QPQuery(format('insert into PaperConfigSheet '+
            '(paperconfig_id,intSheet_num,papersize_id,intpa,intpb,intpc,intpd) '+
            'values (%d,%d,2,%d,%d,0,0)',[result,pages,(i*2)-1,i*2]),wwSQLQuery,true);
        end;
      if PageCount[psTbld] > 0 then
        for i := 1 to PageCount[psTbld] do begin
          inc(pages);
          QPQuery(format('insert into PaperConfigSheet '+
             '(paperconfig_id,intSheet_num,papersize_id,intpa,intpb,intpc,intpd) '+
             'values (%d,%d,3,%d,%d,0,0)',[result,pages,(i*2)-1,i*2]),wwSQLQuery,true);
        end;
      if PageCount[psDblLgl] > 0 then
        for i := 1 to PageCount[psDblLgl] do begin
          inc(pages);
          QPQuery(format('insert into PaperConfigSheet '+
             '(paperconfig_id,intSheet_num,papersize_id,intpa,intpb,intpc,intpd) '+
             'values (%d,%d,5)',[result,pages,(i*4)-3,(i*4)-2,(i*4)-1,i*4]),wwSQLQuery,true);
        end;
    end else
      result := wwSQLQuery.fieldbyname('Paperconfig_id').value;
  end;

  //GN03, checks the question count against the local tables
  procedure CheckLocalQuestionCount;
  var
     FinalQstnCnt : integer;
  begin
    if StrToIntDef(qf_id,0) > 0 then
    begin
      localQuery('select QstnCore'+
                 ' from PCLResults p, sel_Qstns SQ  where p.selQstns_id=sq.selqstns_id and p.item>0 and p.QstnCore > 0 and p.Qnmbr<>''BMP'' ' +
                 ' and p.Qnmbr<>''PCL'' and p.Qnmbr<>''Hdr'' and p.Qnmbr<>'''' ' ,false);

      FinalQstnCnt := wwLocalQuery.RecordCount ;
      if (QstnCnt <> FinalQstnCnt) then
      begin
        raise EQuestionMismatchError.Create( 'FormGenError '+inttostr(40) + '(Local) Survey_id='+ S_id + ' Qf_Id=' + qf_id + ' QstnCnt=' + IntToStr(FinalQstnCnt));
      end;
    end;
  end;

  procedure SavePCLResults;
  var s : string;
      i,n : integer;
  begin
    dmOpenQ.GenError := 27;
{remove after unit testing:
    localQuery('select ' + QF_id + ' as QuestionForm_id,ID,Section,Subsection,'+
      'Item,QstnCore,X,Y,Height,Width,QNmbr,Pagenum,Side,Sheet,SelQstns_id,'+
      'BegColumn,ReadMethod,Yadj,intRespCol,orgSection,SampleUnit_id '+
      'from PCLResults ',false);
    t_PCLr.batchmove(wwLocalQuery,batAppend);
{}
    //CheckLocalQuestionCount; GN03

    localQuery('select ' + QF_id + ' as QuestionForm_id,ID,QstnCore,X,Y,Height,'+
      'Width,Pagenum,Side,Sheet,SelQstns_id,BegColumn,ReadMethod,intRespCol,SampleUnit_id '+
      'from PCLResults where item>0 and Qnmbr<>''BMP'' and Qnmbr<>''PCL'' and Qnmbr<>''Hdr'' and Qnmbr<>''''',false);

    //viewdata(tdataset(wwLocalQuery)); //gntest

    n := 0;
    s := 'exec sp_pcl_insertinto_PCLresults ' + qf_id;
    with wwLocalQuery do begin
      first;
      while not eof do begin
        inc(n);
        for i := 1 to 14 do
          if fields[i].isnull then
            s := s + ',null'
          else
            s := s + ','+fields[i].asstring;
        if n=6 then begin
          ScanQuery(s,true);
          n := 0;
          s := 'exec sp_pcl_insertinto_PCLresults ' + qf_id;
        end;
        next;
      end;
      if n>0 then
        ScanQuery(s,true);
      close;
    end;

  end;

  Procedure SavePCLOutput;
  var Srvy:string;
      stv,SheetNum : integer;
      PageA,PageB,PageC,PageD:integer;
      f:textfile;
      TempDir,fn:string;
      //isSurvey:boolean;
  begin

    dmOpenQ.GenError := 23;
    PageCount[1] := 0;
    PageCount[2] := 0;
    PageCount[3] := 0;
    PageCount[4] := 0;
    PageCount[5] := 0;
    PageCount[6] := 0;
    TempDir:=trim(dmopenq.tempdir);
    if tempdir[length(tempdir)] <> '\' then
       tempdir:=tempdir+'\';
    if testprints then
    begin
      fn:=Survey_id+'_'+sm_id+'_TestPrint';
      if Mockup then
        fn:=fn+'_Mockup';
      //filelist.addobject(fn+'.pdf',tobject(false));
      QPQuery('update #printfiles set FileName = '''+fn+'.pdf'', copied = 0 where tp_id ='+sm_id,ww_sql,true);
      //dmOpenQ.sqlcn.execute('update #printfiles set FileName = '''+fn+'.pdf'', copied = 0 where tp_id ='+sm_id);
      fn:=fn+'.prn';
      if FileExists(Tempdir+fn) then
        deletefile(TempDir+fn);
    end;
    //assignfile(f,'c:\QPprint\'+sm_id+'.prn');
    //dmOpenQ.cn.execute('insert into printfiles (Email,FileName) values(''FGomez@nationalResearch.com'',''c:\QPprint\'+sm_id+'.prn'')');
    //rewrite(f);



    with frmLayoutCalc, tPCL do begin
      indexfieldnames := 'Sheet;Side;Pagenum';
      first;


      //write(f,svyini);
      dmOpenQ.t_PCLObject.Active := true;
      if dmOpenQ.wwt_Cover.fieldbyname('PageType').value = 1 then begin
        if testprints and (dmOpenQ.t_PCLObject.locate('PCLObject_dsc','INITIALIZATION',[loCaseInsensitive])) then
        begin
          dmOpenQ.t_PCLObjectPCLStream.Savetofile(tempdir+fn);
          assignfile(f,tempdir+fn);
          System.append(f);
        end;
        SheetNum := 0;

        if (not IntegratedCover) or (not includeqstns) then begin
          inc(Sheetnum);
          if letterhead then
            inc(PageCount[psLtrHd])
          else
            inc(Pagecount[psLtr]);

          Srvy := GetCoverLetter;
          if Letterhead then
            wwt_LocalPCLOutPut.appendrecord([SM_id,sheetnum,psLtrHd,1,nil,nil,nil,Srvy,true])
          else
            wwt_LocalPCLOutPut.appendrecord([SM_id,sheetnum,psLtr,1,nil,nil,nil,Srvy,true]);
          //tBlobField(wwt_LocalPCLOutput.fieldbyname('PCLStream')).savetofile('c:\QPprint\QP'+sm_id+'-'+inttostr(sheetnum)+'.prn');
          if testprints then
            write(f, CreateLithoText(strtoint(Survey_id),LithoCode,Bundle,GroupDest,[1])+srvy);
        end;

        if includeqstns then begin
          while not eof do begin
            Srvy := GetNextSheet(PageA,PageB,PageC,PageD);
            inc(sheetnum);
            STV := SheetTypeVal;
            inc(PageCount[STV]);
            wwt_LocalPCLOutPut.appendrecord([SM_id,sheetnum,STV,PageA,PageB,PageC,PageD,Srvy,false]);
            //tBlobField(wwt_LocalPCLOutput.fieldbyname('PCLStream')).savetofile('c:\QPprint\QP'+sm_id+'-'+inttostr(sheetnum)+'.bin');
           // tBlobField(wwt_LocalPCLOutput.fieldbyname('PCLStream')).savetofile('c:\QPprint\QP'+sm_id+'-'+inttostr(sheetnum)+'.prn');
            if testprints then
              write(f, CreateLithoText(strtoint(Survey_id),LithoCode,Bundle,GroupDest,[PageA,PageB,PageC,PageD])+srvy);

          end;
          dmOpenQ.GenError := 28;
          ScanQuery('exec sp_PCL_insertinto_PCLqstnfrm '+
            inttostr(currentbatch)+','+
            qf_id+','+
            s_id+','+
            inttostr(STV)+','+
            wwt_MyPCLNeeded.fieldbyname('language').asstring,true);
          if not testprints then
            SavePCLResults;
        end;
        dmOpenQ.GenError := 23;
        if not TestPrints then
          QPQuery('update SentMailing set'+
            ' PaperConfig_id='+inttostr(paperconfig)+','+
            ' intResponseShape='+inttostr(dmOpenQ.ResponseShape)+','+
            ' intPages='+inttostr(sheetnum)+
            ' where SentMail_id='+sm_id,wwSQLQuery,true);
      end else begin {Postcard}
        if testprints then
          if dmOpenQ.t_PCLObject.locate('PCLObject_dsc','POSTCARD_INITIALIZATION',[loCaseInsensitive]) then
          begin
            dmOpenQ.t_PCLObjectPCLStream.Savetofile(tempdir+fn);
            assignfile(f,tempdir+fn);
            System.append(f);
          end;

        pageCount[psPostcard] := 1;
        Srvy := getpostcardside;
        Srvy := getPostCardSide + #27 + '&f1X' + Srvy;
        wwt_LocalPCLOutPut.appendrecord([SM_id,1,6,1,0,0,0,Srvy,true]);
        //tBlobField(wwt_LocalPCLOutput.fieldbyname('PCLStream')).savetofile('c:\QPprint\QP'+sm_id+'-pc.bin');
        //tBlobField(wwt_LocalPCLOutput.fieldbyname('PCLStream')).savetofile('c:\QPprint\QP'+sm_id+'-pc.prn');
        if testprints then
          write(f, CreateLithoText(strtoint(Survey_id),LithoCode,Bundle,GroupDest,[1])+srvy);
        if not TestPrints then
          QPQuery('update SentMailing set'+
            ' PaperConfig_id='+inttostr(paperconfig)+','+
            ' intResponseShape=0,'+
            ' intPages=1'+
            ' where SentMail_id='+sm_id,wwSQLQuery,true);
      end;
    end;

    dmOpenQ.t_PCLObject.Active := false;

    if not TestPrints then
       myBatchMove(wwt_LocalPCLOutput,wwt_SQLPCLOutPut)
    else
    begin
      closefile(f);
      movefile(pchar(tempdir+fn),pchar(prnpath+fn))
    end;
    emptytable(wwt_localPCLOutput);
  end;

  //GN03: Check against the expected count of Questions and Bubbles
  procedure CheckQuestionCount;
  var
     FinalQstnCnt,
     FinalBubbleCnt : integer;
  begin
     FinalQstnCnt   := 0;
     FinalBubbleCnt := 0;

     if StrToIntDef(qf_id,0) > 0 then
     begin
        ScanQuery('select count(distinct(A.SelQstns_id)) as QstnCoreCnt ' +
                  ' from PCLResults A, BubbleLoc B                      ' +
                  ' where A.QuestionForm_id = B.QuestionForm_id         ' +
                  ' and A.selQstns_id       = B.selQstns_id             ' +
                  ' and A.QuestionForm_id   =' + qf_id, false);

        if wwSQLQuery.recordcount > 0 then
           FinalQstnCnt := wwSQLQuery.Fields[0].Value ;

        ScanQuery('select count(Item) as BubbleCnt from BubbleLoc where QuestionForm_id=' + qf_id, false);
        if wwSQLQuery.recordcount > 0 then
           FinalBubbleCnt := wwSQLQuery.Fields[0].Value ;

        if (QstnCnt <> FinalQstnCnt) or (FinalBubbleCnt <> BubbleCnt) then
        begin
           raise EQuestionMismatchError.Create( 'FormGenError '+inttostr(40) + '(Scan) Survey_id='+ S_id + ' Qf_Id=' + qf_id + ' QstnCnt=' + IntToStr(FinalQstnCnt) + ' BubbleCnt='+ IntToStr(FinalBubbleCnt));
        end;
     end;

  end;

begin
{$IFDEF TrapErrors}
  try
{$ENDIF}

    dmOpenQ.GenError := 0;
    LoadAPatient;
    frmLayoutCalc.DOD := (pos(','+s_id+',',DODSurveys)>0);
    frmPCLGeneration.ProgressReport(frmPCLGeneration.CompName + ' Process '+s_id+'.'+sm_id,s_id,sm_id );
    frmLayoutCalc.SurveyGen(sp_id);
{$IFDEF TrapErrors}
    try
{$ENDIF}
      if not wwt_myPCLNeeded.fieldbyname('QuestionForm_id').isnull then begin
        if not TestPrints then
        begin
          dmOpenQ.bblLocFlush;
          dmOpenQ.cmntLocFlush;
          dmOpenQ.HWLocFlush;
        end;
        if ChkPosOn then
          for i := 1 to 10 do
            if length(chkpos[i]) > 5 then
              with frmLayoutCalc.tPCL do begin
                append;
                fieldbyname('Sheet').value := (i+1) div 2;
                fieldbyname('Side').value := i;
                fieldbyname('Pagenum').value := 9999;
                fieldbyname('PCLStream').value := chkpos[i];
                post;
              end;
      end;
{$IFDEF TrapErrors}
    finally
{$ENDIF}
      SavePCLOutput;
      if not testprints then //GN03
         CheckQuestionCount;
      QPQuery('delete from PCLNeeded'+strTP+' where '+WhereField+'='+sm_id,wwSQLQuery,true);
{$IFDEF TrapErrors}
    end;
  except
    on e:exception do begin
      if e is eOrphanTagError then
        dmOpenQ.GenError:=strtoint(trim(copy(e.message,14,2)));

      if e is EQuestionMismatchError then //GN03
        dmOpenQ.GenError:=40;

      //MessageDlg(E.Message,mterror,[mbok],0);
      LogError;
      frmPCLGeneration.progressreport(e.message,s_id,sm_id);
    end;
  end;
{$ENDIF}
end;

procedure tdmPCLGen.processBMPs;
begin
  with wwt_LocalSelLogo do begin
    first;
    while not eof do begin
      frmLayoutCalc.BMPtoPCL(wwt_LocalSelLogo,'Bitmap','PCLStream');
      next;
    end;
  end;
end;

procedure tdmPCLGen.MainLoop;
  procedure createKVTables;
  begin
    frmPCLGeneration.ProgressReport('Load KV Tables','','');
    makePopSection('KVPopSection.db', wwt_KVPopSection);
    makePopCover('KVPopCover.db',wwt_KVPopCover);
    makePopCode('KVPopCode.db',wwt_KVPopCode);
    wwt_KVPopSection.Close;
    wwt_KVPopCover.close;
    wwt_KVPopCode.close;
  end;
begin
  frmPCLGeneration.progressreport('Start of MainLoop procedure','','');
  wwT_SQLPCLOutput.open;
  frmLayoutCalc := TfrmLayoutCalc.Create( Self );
  frmLayoutCalc.TestPrints := testprints;
  if not frmLayoutcalc.createok then
    createok := false
  else
    repeat begin
      frmLayoutCalc.StartCalc;
      repeat begin
        reload := false;
        shutdown := false;
        createKVtables;
        LoadPersonalizedTables;
      end until (shutdown) or (not reload);
      if not shutdown then begin
        LoadStaticTables;
        dmOpenQ.GenError := 0;
        ProcessBMPs;
        with wwt_MyPCLNeeded do begin
          first;
          while not eof do begin
            Generate;
            next;
          end;
        end;
        DeleteBatch;


        {GN03: create a log file
        with frmPCLGeneration do
        begin
           if Assigned(frmPCLGeneration ) then
           begin
              Memo1.Lines.SaveToFile(IntToStr(CurrentBatch)+'.txt');
           end;
        end; }

      end;
      frmLayoutCalc.EndCalc;
      if copy(paramstr(3),1,2)='/1' then shutdown := true;
    end until (shutdown) or (GetNextBatch=0);
  frmLayoutCalc.Release;
  wwT_SQLPCLOutput.close;
  frmPCLGeneration.progressreport('End of MainLoop procedure','','');
end;

procedure tdmPCLGen.CreateMyTables;
var s : string;
begin
  s := 'CREATE TABLE #MyPCLNeeded (Survey_id integer,SelCover_id integer, '+
       'Language integer,SentMail_id integer,SamplePop_id integer,'+
       'QuestionForm_id integer,Batch_id integer,PCLGenRun_id integer,'+
       'bitDone bit,bitTestPrints bit,LithoCode integer,Bundle varchar(10),'+
       'GroupDest varchar(9))';
  QPQuery(s,wwSQLQuery,true);
end;

procedure tdmPCLGen.myBatchMove(var TS,TD:twwTable);
begin
  with BatchMove do begin
    mappings.clear;
    Source := ts;
    Destination := td;
    mode := batappend;
    KeyViolTableName := '';
    AbortOnKeyViol := true;
    execute;
  end;
end;

procedure tdmPCLGen.DeleteBatch;
var errortime : string;
    errorCount : integer;
begin
  logSQLQuery := true;
  frmPCLGeneration.progressreport('DeleteBatch','','');
  errortime := ''''+FormatDateTime('mm/dd/yyyy hh:mm:ss".'+copy(inttostr(1000+random(1000)),2,3)+'" AM/PM', now)+'''';
  QPQuery('select count(*) as cnt from #MyPCLNeeded where batch_id<0',wwSQLQuery,false);
  with wwSQLQuery do begin
    errorcount := fieldbyname('cnt').asinteger;
    close;
    sql.clear;
    if errorCount>0 then begin
      if sp_PCL_RaiseError then
        sql.add('exec sp_PCL_RaiseError')
      else if sp_RaiseError then
        sql.add('exec sp_RaiseError 5, ''PCLGen'', ''PCLGen run '+inttostr(currentrun)+' errored on '+inttostr(errorcount)+' questionnaires''');
      {Move errored patients from #MyPCLNeeded to FormGenError}
      sql.add('insert into FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)');
      sql.add('(select SM.ScheduledMailing_id, convert(datetime,'+errortime+') as datGenerated,');
      sql.add('   abs(#MyPCLNeeded.batch_id) as FGErrorType_id');
      sql.add(' from #MyPCLNeeded, ScheduledMailing SM');
      sql.add(' where #MyPCLNeeded.SentMail_id=SM.SentMail_id and');
      sql.add('   #MyPCLNeeded.batch_id<0)');
      ExecSQL_with_deadlocks;
      sql.clear;
      {Call stored procedure to move records from *_Individual to bad_*_Individual}
      sql.add('execute sp_PCL_CleanUpErrors '+errortime);
      ExecSQL_with_deadlocks;
      sql.clear;
      {Delete errored patients from #MyPCLNeeded}
      sql.add('delete from #MyPCLNeeded where Batch_id<0');
      ExecSQL_with_deadlocks;
      sql.clear;
    end;
    {remove current batch from PCLNeeded:
      -- now deleted one at a time at the end of the Generate procedure
    frmPCLGeneration.progressreport('  delete from PCLNeeded','','');
    sql.add('delete from PCLNeeded where batch_id='+inttostr(currentbatch));
    ExecSQL;
    frmPCLGeneration.progressreport('    '+inttostr(rowsaffected)+' records deleted','','');
    sql.clear;

    {empty #MyPCLNeeded}
    frmPCLGeneration.progressreport('  truncate #MyPCLNeeded','','');
    QPQuery('TRUNCATE TABLE #MyPCLNeeded',wwSQLQuery,true);
    frmPCLGeneration.progressreport('  execute sp_PCL_EndRun','','');

{$IFDEF TrapErrors}
    try
{$ENDIF}
      QPQuery('execute sp_PCL_EndRun '+inttostr(currentRun),wwSQLQuery,true);
{$IFDEF TrapErrors}
    except
      on e:exception do begin
        //MessageDlg(E.Message,mterror,[mbok],0);
        QPQuery('update #MyPCLNeeded set batch_id=-25 where batch_id='+inttostr(currentbatch),wwSQLQuery,true);
        frmPCLGeneration.progressreport('sp_PCL_EndRun exception ' + e.message,'','');
      end;
    end;
{$ENDIF}
  end;
  logSQLQuery := false;
  if testprints then
  begin
    MoveFiles;
    notify;
  end;
  frmPCLGeneration.progressreport('DeleteBatch done','','');
  currentRun := -1;
end;

function tdmPCLGen.GetNextBatch:integer;
var success : boolean;
begin
  success := true;
  repeat begin
    try
      if not dmopenq.dbQualPro.Connected then begin
        success := false;
        dmopenq.dbQualPro.keepconnection := true;
        dmopenq.dbQualPro.open;
        CreateMyTables;
        success := true;
      end;
    except
      on e:exception do
        if pos('timeout',lowercase(e.message))=0 then
          raise
        else
          frmPCLGeneration.ProgressReport('  connection timeout .. try again','','');
    end;
  end until success;
  logSQLQuery := true;
  if strtointdef(frmPCLGeneration.txtSurvey_id.text,0) = 0 then
    frmPCLGeneration.txtSurvey_id.text := '0'
  else
    frmPCLGeneration.ProgressReport('  waiting for a batch for survey_id='+frmPCLGeneration.txtSurvey_id.text,'','');
  QPQuery('execute sp_PCL_NextBatch ''' + frmPCLGeneration.CompName + ''', '+frmPCLGeneration.txtSurvey_id.text + ', ''' + frmPCLGeneration.Version + '''',wwSQLQuery,true);
  QPQuery('execute sp_PCL_CleanBatch',wwSQLQuery,true);

  ww_sql.SQL.Add('Update #MyPCLNeeded set #MyPCLNeeded.LithoCode = cast(sm.strLithoCode as integer),'+
                  'Bundle = sm.strpostalbundle, GroupDest = sm.strGroupDest '+
                  'from #MyPCLNeeded pn, SentMailing sm  where pn.SentMail_id=sm.SentMail_id and bitTestPrints = 1');
   ww_sql.ExecSQL;
   ww_sql.SQL.Clear;

  QPQuery('Select Survey_id,SelCover_id,Language,SentMail_id,Samplepop_id, '+
          'QuestionForm_id,Batch_id,PCLGenRun_id,bitTestPrints,LithoCode,Bundle,GroupDest '+
          'from #MyPCLNeeded',wwSQLQuery,false);


  with wwSQLQuery do begin
    result := recordcount;
    CurrentBatch := fieldbyname('Batch_id').asInteger;
    CurrentRun := fieldbyname('PCLGenRun_id').asInteger;
    TestPrints := fieldbyname('bitTestPrints').asBoolean;
    Survey_id := fieldbyname('Survey_id').asString;
  end;

  emptytable(wwt_MyPCLNeeded);
  wwt_MyPCLNeeded.batchmove(wwSQLQuery,batAppend);

  strTP:='';
  PdfPath:='';
  PrnPath:='';
  Email:='';
  Mockup:=false;
  WhereField:='SentMail_id';
  if TestPrints then
  begin
    ww_sql.SQL.Add('Create table #printfiles (tp_id int, pop_id int, FileName varchar(50),copied bit )');
    ww_sql.ExecSQL;
    ww_sql.SQL.Clear;
    ww_sql.SQL.Add('insert into #printfiles(tp_id,pop_id,copied) select pn.SentMail_id, pop_id, 0 as copied from scheduled_TP ps, #MyPCLNeeded pn where ps.tp_id=pn.SentMail_id');
    ww_sql.ExecSQL;
    ww_sql.SQL.Clear;
   //filelist.Clear;
   strTP:='_TP';
   WhereField:='TP_id';
   QPQuery('select top 1 s.bitMockup,p.strEmail from #mypclneeded mp inner join pclneeded_tp p on mp.SentMail_id = p.tp_id inner join scheduled_tp s on p.tp_id = s.tp_id where p.batch_id ='+inttostr(CurrentBatch),wwSQLQuery,false);
   Email:=wwSQLQuery.fieldbyname('strEmail').asString;
   Mockup:=wwSQLQuery.fieldbyname('bitMockup').asBoolean;
  end;
  QPQuery('select STRPARAM_NM,STRPARAM_VALUE from qualpro_params where STRPARAM_NM in (''PCLGenPDFLoc_TP'',''PCLGenPrnLoc_TP'')',wwSQLQuery,false);
  if wwSQLQuery.locate('STRPARAM_NM','PCLGenPDFLoc_TP',[loCaseInsensitive]) then
    PdfPath:=trim(wwSQLQuery.fieldbyname('STRPARAM_VALUE').asString);
  if wwSQLQuery.locate('STRPARAM_NM','PCLGenPrnLoc_TP',[loCaseInsensitive]) then
    PrnPath:=trim(wwSQLQuery.fieldbyname('STRPARAM_VALUE').asString);
  if PdfPath[length(PdfPath)] <> '\' then
    PdfPath:=PdfPath+'\';
  if PrnPath[length(PrnPath)] <> '\' then
    PrnPath:=PrnPath+'\';

  wwSQLQuery.close;
  if (result>0) and (currentbatch > 0) then
    frmPCLGeneration.ProgressReport('Load Batch '+inttostr(currentbatch)+
                                    ' - '+inttostr(result)+' mail items','','')
  else
    frmPCLGeneration.ProgressReport('Waiting for PCLNeeded'+strTP+
                                    ' to be populated','','');
  logSQLQuery := false;
end;

Procedure tdmPCLGen.MakePopSection(const tblnm:string; var tbl:TwwTable);
begin
  with tbl do begin
    TableType := ttParadox;
    tablename := tblnm;
    with FieldDefs do begin
      Clear;
      add('SentMail_id',ftInteger,0,false);
      add('section_id',ftInteger,0,false);
      add('sampleunit_id',ftInteger,0,false);
      add('survey_id',ftInteger,0,false);
      add('langid',ftInteger,0,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('ByID', 'SentMail_id;Section_id;Sampleunit_id', [ixPrimary]);
    end;
    createtable;
    open;
  end;
end;

Procedure tdmPCLGen.MakePopCover(const tblnm:string; var tbl:TwwTable);
begin
  with tbl do begin
    TableType := ttParadox;
    tablename := tblnm;
    with FieldDefs do begin
      Clear;
      add('SentMail_id',ftInteger,0,false);
      add('SelCover_id',ftInteger,0,false);
      add('survey_id',ftInteger,0,false);
      add('langid',ftInteger,0,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('ByID', 'SentMail_id;SelCover_id', [ixPrimary]);
    end;
    createtable;
    open;
  end;
end;

Procedure tdmPCLGen.MakePopCode(const tblnm:string; var tbl:TwwTable);
begin
  with tbl do begin
    TableType := ttParadox;
    tablename := tblnm;
    with FieldDefs do begin
      Clear;
      add('SentMail_id',ftInteger,0,false);
      add('sampleunit_id',ftInteger,0,false);
      add('code',ftInteger,0,false);
      add('survey_id',ftInteger,0,false);
      add('language',ftInteger,0,false);
      add('codetext',ftString,255,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('ByID', 'SentMail_id;Sampleunit_id;code', [ixPrimary]);
    end;
    createtable;
    open;
  end;
end;

procedure tdmPCLGen.MakeLocalTables;
begin
  with wwt_MyPCLNeeded do begin
    TableType := ttParadox;
    tablename := 'MyPCLNeeded.db';
    with FieldDefs do begin
      Clear;
      add('Survey_id',ftInteger,0,false);
      add('SelCover_id',ftInteger,0,false);
      add('Language',ftInteger,0,false);
      add('SentMail_id',ftInteger,0,false);
      add('Samplepop_id',ftInteger,0,false);
      add('QuestionForm_id',ftInteger,0,false);
      add('Batch_id',ftInteger,0,false);
      add('PCLGenRun_id',ftInteger,0,false);
      add('BitTestPrints',ftInteger,0,false);
      add('LithoCode',ftInteger,0,false);
      add('Bundle',ftString,10,false);
      add('GroupDest',ftString,9,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('ByID', 'Survey_id;SelCover_id;Language;SentMail_id', [ixPrimary]);
    end;
    createtable;
    open;
  end;
  with wwT_LocalPCLOutput do begin
    TableType := ttParadox;
    tablename := 'LocalPCLOutput.db';
    with FieldDefs do begin
      Clear;
      add('SentMail_id',ftInteger,0,false);
      add('intSheet_num',ftInteger,0,false);
      add('PaperSize_id',ftInteger,0,false);
      add('intPA',ftInteger,0,false);
      add('intPB',ftInteger,0,false);
      add('intPC',ftInteger,0,false);
      add('intPD',ftInteger,0,false);
      add('PCLStream',ftBlob,100,false);
      add('bitCover',ftBoolean,0,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('ByID', 'SentMail_id;intSheet_num', [ixPrimary]);
    end;
    createtable;
    open;
  end;
  MakePopSection('localPopSection.db',wwt_LocalPopSection);
  frmPCLGeneration.progressreport('MakePopSection localPopSection.db','','');
  MakePopCover('localPopCover.db',wwt_LocalPopCover);
  frmPCLGeneration.progressreport('MakePopCover localPopCover.db','','');
  MakePopCode('localPopCode.db',wwt_LocalPopCode);
  frmPCLGeneration.progressreport('MakePopCode localPopCode.db','','');
  wwt_LocalSelCover.tablename := 'LocalSelCover.db';
  dmOpenQ.tabledef(wwt_LocalSelCover,C,true);
  wwt_LocalSelLogo.tablename := 'LocalSelLogo.db';
  dmOpenQ.tabledef(wwt_LocalSelLogo,L,true);
  wwt_LocalSelPCL.tablename := 'LocalSelPCL.db';
  dmOpenQ.tabledef(wwt_LocalSelPCL,P,true);
  wwt_LocalSelSkip.tablename := 'LocalSelSkip.db';
  dmOpenQ.tabledef(wwt_LocalSelSkip,K,true);
  wwt_LocalSelQstns.tablename := 'LocalSelQstns.db';
  dmOpenQ.tabledef(wwt_LocalSelQstns,Q,true);
  wwt_LocalSelScls.tablename := 'LocalSelScls.db';
  dmOpenQ.tabledef(wwt_LocalSelScls,S,true);
  wwt_LocalSelTextBox.tablename := 'LocalSelTextBox.db';
  dmOpenQ.tabledef(wwt_LocalSelTextBox,T,true);

  dmOpenQ.CreateProblemScoreTable;
  frmPCLGeneration.progressreport('dmOpenQ.CreateProblemScoreTable','','');

  wwt_LocalSelCover.open;
  wwt_LocalSelLogo.open;
  wwt_LocalSelPCL.open;
  wwt_LocalSelSkip.open;
  wwt_LocalSelQstns.open;
  wwt_LocalSelScls.open;
  wwt_LocalSelTextBox.open;
  frmPCLGeneration.progressreport('LocalSel[Cover/Logo/PCL/Skip/Qstns/Scls/TextBox].open','','');

  with dmOpenQ do begin
    tabledef(wwt_Cover,C,true);
    tabledef(wwt_Logo,L,true);
    tabledef(wwt_PCL,P,true);
    tabledef(wwt_Skip,K,true);
    tabledef(wwt_Qstns,Q,true);
    tabledef(wwt_Scls,S,true);
    tabledef(wwt_TextBox,T,true);
    frmPCLGeneration.progressreport('tabledef wwt_[Cover/Logo/PCL/Skip/Qstns/Scls/TextBox]','','');
    with wwt_Cover do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    with wwt_Logo do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    with wwt_PCL do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    with wwt_Skip do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    with wwt_Qstns do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    with wwt_Scls do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    with wwt_TextBox do begin
      filtered := false;
      IndexFieldNames := '';
      open;
    end;
    frmPCLGeneration.progressreport('wwt_[Cover/Logo/PCL/Skip/Qstns/Scls/TextBox] open','','');
  end;
end;

procedure TdmPCLGen.dmPCLGenCreate(Sender: TObject);
var nd:string;
begin
  try
    //filelist := tstringlist.Create;
    //filelistrs:=CreateOleObject('ADODB.Recordset');
    createok := false;
    TestPrints := false;
    logSQLQuery := false;
    Session.AddPassword( 'Dave' );
    Session.AddPassword( '(uU\`rlvLHh4Au]' );
    Check(dbiInit(Nil));
    if directoryexists(paramstr(2)) then
      nd := paramstr(2)
    else if (directoryexists(copy(aliaspath('Question'),1,length(aliaspath('Question'))-7)+'net')) then
      nd := copy(aliaspath('Question'),1,length(aliaspath('Question'))-7)+'net'
    else if directoryexists('\\capmts\capgemini\NRC\DATA\NET') then
      nd := '\\capmts\capgemini\NRC\DATA\NET'
    else if directoryexists('\\nrc1\nrc1\NET') then
      nd := '\\nrc1\nrc1\NET';

    if uppercase(session.netfiledir) <> uppercase(nd) then begin
      try
        session.netfiledir := nd;
        with wwt_LocalSelTextBox do begin
          DataBaseName := 'Question';
          TableName := 'Users.db';
          open;
        end;
      except
        on e:eDBEngineError do begin
          nd := uppercase(e.message);
          delete(nd,1,pos('DIRECTORY: ',nd)+10);
          delete(nd,pos('FILE:',nd)-2,length(nd));
          session.netfiledir := ND;
        end;
      end;
      with wwt_LocalSelTextBox do begin
        close;
        DataBaseName := '_PRIV';
        TableName := '';
      end;
    end;
    DMOpenQ := TDMOpenQ.Create( Self );
    if dmopenq.createOK then begin
      randomize;
      QF_id := '';
      S_id := '';
      SM_id := '';
      currentRun := -1;
      reload := false;
      shutdown := false;
      MakeLocalTables;
      QPQuery('select numParam_value from qualpro_params where strParam_nm=''PCLGenWaitSecs''',wwSQLQuery,false);
      with wwSQLQuery do begin
        if fieldbyname('numParam_value').isNull then
          timer.interval := 600000
        else
          timer.interval := 1000 * fieldbyname('numParam_value').asInteger;
        close;
      end;
      ww_sql:=TwwQuery.Create(self);
      ww_sql.DataSource:=  dmOpenQ.ww_Query.DataSource;
      ww_sql.DatabaseName :=  dmOpenQ.ww_Query.DatabaseName;
      ww_sql.SessionName  :=  dmOpenQ.ww_Query.SessionName ;
      //ww_sql:=TwwQuery(dmOpenQ.ww_Query.NewInstance);


    end;
    session.RemoveAllPasswords;
    createok := true;

    SMTPAvailable := false;
{$IFNDEF SMTPBLOCK}
    try
      smtp1:=TSMTP.Create(nil);
      //GN01
      QPQuery('select StrParam_value from qualpro_params where strParam_nm=''PCLGenSMTPServer''',wwSQLQuery,false);
      with wwSQLQuery do begin
        if fieldbyname('StrParam_value').IsNull then
        begin
          SMTPHost := 'smtp.nationalresearch.com';  //Default Value
          SMTPAvailable := false;
        end
        else
        begin
          SMTPHost := FieldByName('StrParam_value').AsString;
          SMTPAvailable := true;
        end;
        close;
      end;

    except
       //if you get class not registered error, do Regsvr32 nmocod.dll first and then regsvr32.exe /s  c:\windows\system\smtpct.ocx
       on E:EOleSysError do
       begin
          frmPCLGeneration.ProgressReport(E.Message + ' Error creating SMTP','','');
          SMTPAvailable := false;
       end;
    end;
{$ENDIF}
  except
    on E:Exception do
    begin
       createok := false;
    end;
  end;
end;

procedure TdmPCLGen.dmPCLGenDestroy(Sender: TObject);
var tempdir : string;
begin
//  frmLayoutCalc.Release;
  if SMTPAvailable then smtp1.Free;
  //if filelistrs.state = 1 then
  //  filelistrs.close;
  //filelistrs := unassgined;

  tempdir := dmopenq.tempdir;
  dmOpenQ.free;
  ww_sql.Free;
  wwt_LocalSelCover.close;
  wwt_LocalSelLogo.close;
  wwt_LocalSelPCL.close;
  wwt_LocalSelSkip.close;
  wwt_LocalSelQstns.close;
  wwt_LocalSelScls.close;
  wwt_LocalSelTextBox.close;
  wwt_KVPopSection.close;
  wwt_KVPopCover.close;
  wwt_KVPopCode.close;
  wwt_LocalPopSection.close;
  wwt_LocalPopCover.close;
  wwt_LocalPopCode.close;
  wwT_LocalPCLOutput.close;
  wwt_MyPCLNeeded.close;

  DelDotStar(tempdir+'\MyPCLNeeded.*');
  DelDotStar(tempdir+'\LocalPCLOutput.*');
  DelDotStar(tempdir+'\LocalSel*.*');
  DelDotStar(tempdir+'\KVPop*.*');
  DelDotStar(tempdir+'\LocalPop*.*');

end;

procedure tdmPCLGen.ShowErrorLog;
begin
  QPQuery('select'+
    ' sm.ScheduledMailing_id,sm.MailingStep_id,sm.SentMail_id,sm.datGenerate,sm.SentMail_id,sm.Methodology_id,'+
    ' FGE.datGenerated as datError, FGE.FGErrorType_id as ErrorNum, FGET.FGErrorType_dsc'+
    ' from formgenerror FGE, FormGenErrorType FGET, ScheduledMailing SM'+
    ' where FGE.ScheduledMailing_id=SM.ScheduledMailing_id and'+
    ' FGE.FGErrorType_id=FGEt.FGErrorType_id',wwSQLQuery,false);
  viewdata(tdataset(wwSQLQuery));
end;

procedure TdmPCLGen.TimerTimer(Sender: TObject);
var zExeName,zParams : array[0..79] of char;
begin
{$IFDEF TrapErrors}
  try
{$ENDIF}
    if GetNextBatch>0 then begin
      timer.enabled := false;
      MainLoop;
      MessageBeep(0); MessageBeep(0); MessageBeep(0);
      frmPCLGeneration.btnErrorLog.Enabled := true;
      if dmopenq.createok and frmLayoutcalc.createok and createok then begin
        frmPCLGeneration.progressreport('Relaunching PCLGen (from dPCLGen)','','');
        winExec(strpcopy(zExeName,application.exename+' /2 '+paramstr(2)+' '+paramstr(3)),sw_shownormal)
      end;
      frmPCLGeneration.close;
    end else begin
      dmopenq.dbQualPro.keepconnection := false;
      dmopenq.dbQualPro.close;
      dmopenq.dbScan.keepconnection := false;
      dmopenq.dbScan.close;
    end;
{$IFDEF TrapErrors}
  except
    on e:exception do begin
      frmPCLGeneration.progressreport('Error! '+e.message,'','');
      if sp_RaiseError then
        //GN03
        QPQuery('exec sp_RaiseError 1, ' + dmopenq.sqlstring(frmPCLGeneration.CompName + ' PCLGen', false) + ', ' + dmopenq.sqlstring(e.message,false),wwSQLQuery,true);
        //QPQuery('exec sp_RaiseError 1, ''PCLGen'', '+dmopenq.sqlstring(e.message,false),wwSQLQuery,true);
      //MessageDlg(E.Message,mterror,[mbok],0);
    end;
  end;
{$ENDIF}
end;

end.
