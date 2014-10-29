unit Main;

{*******************************************************************************
Program Modifications:
--------------------------------------------------------------------------------
Date        UserId   Description
-------------------------------------------------------------------------------
11-16-2005   GN01    In debug mode don't notify user

12-08-2005   GN02    Install CDO.dll

12-20-2005   GN03    Attempting to free the Thread/Memory Resource

03-24-2006   GN04    Options to send email through local or remote SMTP Server

04-04-2006   GN05    Include legends for Boxplots

10-02-2006   GN06    EOleException Operation is not allowed when the object is open
                     EOleException Operation cannot be performed when executing asynchronously
                     EoleError variant does not reference an automation object
                     Msado15.dll  - Data Access
                     Msdasql.dll  - Data Access - OLE DB provider for ODBC drivers

11-29-06     GN07    changed the name of stored procedures sp_APB_OT_OverrideOldReport & sp_APB_CM_SetMailing

01-04-07     GN08    Fixed the problem with line wraps in email causing the url links to break(%20)

*******************************************************************************}

interface

uses
  isp3,
  SysUtils ,
  ExtCtrls,
  Grids,
  comobj,
  QuadChart,
  divLines,
  VBars,
  HBarmns,
  HBarpcs,
  Narrative,
  TabularRanking,
  HSRankingReport,
  TabularTitle,
  PlotCharts,
  TextMeasure,
  Constants,
  JpgReader,
  zlibStr,
  Arrows,
  AddNewPage,
  forms,
  stdctrls,
  controls ,
  windows ,
  dialogs,
  ControlCharts,
  Activex,
  appath,
  fontreader,
  richedit,
  inifiles,
  Fileutil,
  Classes,FileCtrl, OleCtrls, ComCtrls,graphics, Menus,messages;

type
  //Records for communication between Threads and MainForm, the pointer for the

  //Record to hold the information from one thread
//  EBadRun = class(Exception);
  PThreadInfo = ^TThreadInfo;
  TThreadInfo = record
                  Active       : Boolean;
                  ThreadHandle : integer;
                  ThreadId     : integer;
                  AP_ID        : string;
                  Job_ID       : string;
                  Client_ID    : string;
                  UserName     : string;
                  Caption      : TCaption;
                end;

  PFormInfo = ^TFormInfo;
  TFormInfo = record
                  AP_ID        : string;
                  Job_ID       : string;
                  Client_ID    : string;
                  UserName     : string;
                  Caption      : TCaption;
                  Msg          : string; 
                end;



  SelRangeType =
    Record
      SStart: LongInt;
      SEnd:   LongInt;
    end;

  TServers = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  Tmainform = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    re1: TRichEdit;
    Panel7: TPanel;
    re2: TRichEdit;
    Timer1: TTimer;
    Panel4: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    cbGenSpecific: TCheckBox;
    mAPs: TMemo;
    Panel8: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    UpDown1: TUpDown;
    eInterval: TEdit;
    cbOnePage: TCheckBox;
    rgServers: TRadioGroup;
    cbNotify: TCheckBox;
    Panel5: TPanel;
    pnlAll: TPanel;
    lblAll: TLabel;
    AllProgress: TProgressBar;
    Panel9: TPanel;
    Start: TButton;
    pnlThis: TPanel;
    lblThis: TLabel;
    ThisProgress: TProgressBar;
    cbCompress: TCheckBox;
    LabelVersion: TLabel;
    procedure StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eIntervalKeyPress(Sender: TObject; var Key: Char);
    procedure eIntervalExit(Sender: TObject);
    procedure eIntervalClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mAPsChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure GetServers;
    procedure rgServersClick(Sender: TObject);
  private
    { Private declarations }

    procedure ThreadMessage( var Message : TMessage ); message TH_MESSAGE;
    function CheckMem : Boolean;
    procedure HandleException(Sender: TObject; E: Exception);
  public
    { Public declarations }
  end;

  function CreatePDF:boolean;
  procedure Notify(strBody,strTo,strCC,strFrom,strSubject,ExtractLateHtml:string);


const
  ThreadHandle:LongInt = 0;

var mainform:tmainform;
    studyid : string;
    surveyid : string;
    outputlevel: string;
    location : string;
    apdesc:string;
    CriticalSection : TRTLCriticalSection;  //Critical section protects the global vars
    Servers: TServers;
    x,y,w:double;
    strAppath,
    Kids:string;
    xref:string;
    buf,buf2:string;
    ClientLogo:string;
    CautionImage:string;
    ClientLogoPath : string;
    NRCLogoPath : string;
    ClientLogoName:string;
    NRCLogoName:string;
    ArrowsPath : string;
    PageSection:string;
    clientID:string;
    NrcJpeg:string;
    f:textfile;
    xrefPos:longint;
    p:integer;
    rs:variant;
    aprs:variant;
    useMeasureHBar  : boolean;
    cntlmain        :boolean;
    ObjCount:Integer;
    OutlineCount:Integer;
    LogoWidth:double;
    LogoHeight:double;
    sucessfull:boolean;
    strContactName,
    strContactPhone,
    strContactEmail:string;
    SelRange     : SelRangeType;
    iPos         : LongInt;
    OptionSet    : set of TSearchType;
    strNotify:string;
    apid:string;
    User0,User1,Server,Database:String;
    AllComponentsCounter:integer;
    HtmlPathRoot:string;
    URLRoot:string;
    sMailServer:string;
    sMailServerType : string;
    sMemSize : string;
    strCC:string;
    StartTime: LongInt;
    MilliSecondsToWait: LongInt = 90000;
    sAutoStart : string;
    MemUsageStart : integer;
    UseNRCLogo : boolean;
    MeasureTypeSub : integer;
    ProcessID : DWord;
    InstanceCount : integer;
    AppStartDateTime : TDateTime;

   // ThreadVar Defines variables that are given separate instances per thread

implementation

uses psapiunit;

{$R *.DFM}

procedure TMainForm.ThreadMessage( var Message : TMessage );
var s:PString;
    ThreadIndex: integer;
begin
  case message.WParam of
    TH_FINISHED :
      begin
        re1.Lines.Add('Done Generating PDFs');
        re1.Lines.SaveToFile('PDFGen.log');
        re1.Clear;
        Start.Enabled := True;
        Timer1.Enabled:=(not cbGenSpecific.Checked);
        CloseHandle(ThreadHandle);
        ThreadHandle:= 0;

        if UpDown1.Position>0 then
         Timer1.Interval :=1000*60*UpDown1.Position
        else
         Timer1.Interval :=1000*10;
        
         exit;
      end;
    TH_UPDATE :
      begin
        s:= PString(Message.LParam);
        if s^='-1' then
          re1.Lines.Clear
        else
          re1.Lines.Add(s^);
        Dispose(s);
      end;

    TH_NEWAP :
      begin
        s:= PString(Message.LParam);
        re2.text:=s^;
        Dispose(s);
      end;

    TH_THISPROGRESSPOS:
    begin
      inc(message.LParam);
      ThisProgress.Position := message.LParam;
    end;
    TH_THISPROGRESSMAX:
    begin
      ThisProgress.Max := message.LParam;
      ThisProgress.Position := 0;
    end;

    TH_ALLPROGRESSPOS:
      AllProgress.Position := message.LParam;

    TH_ALLPROGRESSMAX:
    begin
      AllProgress.Max := message.LParam;
      AllProgress.Position := 0;
      ThisProgress.Position := 0;
      pnlThis.Visible := true;
      pnlAll.Visible := true;
    end;

    TH_LABEL:
    begin
      s:= PString(Message.LParam);
      tLabel(TH_MESSAGE-message.Msg).Caption:=s^;
      dispose(s);
    end;

    //GN03
    TH_ERROR:
    begin
      ThreadIndex:= Message.LParam;
      if ThreadIndex = -1 then Exit;
	   //Invalid threadID should never appear
      re1.Lines.Add('Error: Could not open file ');
    end;
  end;
  SendMessage(re1.Handle, EM_SCROLLCARET, 0, 0 );

end;

function isnumeric(s:string):boolean;
var i:integer;
begin
  result:=true;
  for i := 1 to length(s) do
  begin
    result := s[i] in ['0','1','2','3','4','5','6','7','8','9'];
    if not result then break;
  end;


end;

Function CreateList(m:tmemo):string;
var s,s1:string;
  ap_ids:string;
  i{,v},c:integer;
  rs:variant;
begin
  c:=m.Lines.Count-1;
  s:='';
  ap_ids:='';
  for i:=0 to c do
  begin
    s1:=trim(m.lines[i]);
    if isnumeric(s1) then
      s := s + s1 + ','
    else
      if s1 <> '' then
         ap_ids := ap_ids+format('''%s'',',[s1]);
  end;

  if ap_ids <> '' then
  begin
    ap_ids[length(ap_ids)] := ')';
    ap_ids := '('+ap_ids;
    rs := cn.execute('Select ap_id, max(job_id) as job_id from tbl_apjoblist where ap_id in ' + ap_ids + ' group by ap_id');
    while not rs.eof do
    begin
      s := s + vartostr(rs.fields['job_id'].value) + ',';
      rs.movenext;
    end;
    rs.close;
    rs:=unassigned;
  end;


  if length(trim(s))>0 then
  begin
    delete(s,length(s),1);
    {s:= format('select '+
      'case when ((isnull(returned_survey_n,-1) < isnull(CautionBubbleNSize,'+
      'isnull(returned_survey_n,0))) and isnull(ShowCautionBubble,0) <> 0) '+
      'then 1 else 0 end as bCaution,'+
      'g.*,case numnrc_logo_flag '+
               ' when 1 then ''Nrc-clr2.jpg'''+
               ' when 2 then ''NRC_Picker.jpg''' +
               ' when 3 then ''NRC_smallerWorld.jpg'''+
               ' when 4 then ''NRC+PICKER.jpg'''+
               ' when 5 then ''NRC+PICKER_Canada.jpg'''+
               ' else '''' end  as nrclogo ,'+
               'l.status,l.notify from %0:s g inner join %1:s l on l.job_id = g.job_id '+
               'where l.status in (4,5,6,7,105,107) and l.job_id in (select max(job_id) from tbl_apjoblist where ap_id in (%s) group by ap_id) order by l.job_id',[Global_Run_Table,Job_list,s]);
      }
      s:= format('select '+
        'case when ((isnull(returned_survey_n,-1) < isnull(CautionBubbleNSize,'+
        'isnull(returned_survey_n,0))) and isnull(ShowCautionBubble,0) <> 0) '+
        'then 1 else 0 end as bCaution,'+
        'g.*,case numnrc_logo_Flag '+
        'when 1 then ''Nrc-clr2.jpg'''+
        ' when 2 then ''NRC_Picker.jpg''' +
        ' when 3 then ''NRC_smallerWorld.jpg'''+
        ' when 4 then ''NRC+PICKER.jpg'''+
        ' when 5 then ''NRC+PICKER_Canada.jpg'''+
        ' else '''' end  as nrclogo ,'+
        'l.status,l.notify '+
        'from %0:s g inner join %1:s l on l.job_id = g.job_id '+
        'where l.status = 50 order by l.job_id',[Global_Run_Table,Job_list]);

  end;
  result:=s;

end;


Procedure ClearHBHeaders;
var i:integer;
begin
  for i:=1 to high(list1) do
  begin
    list[i]:='';
    list1[i]:='';
    list2[i]:='';
  end;
end;

procedure SetItemsUsed(WhatAP:string);
  var s:string;
  rs:variant;
  v:integer;
begin
  s:='Select distinct upper(component_type) as c from ['+comp_detail+'] where component_type between 1 and 7 '+WhatAP;
  rs:=cn.execute(s);
  while not rs.eof do
  begin
    v:= rs.fields[0].value;
    case  v of
//       1:useVBar         := true;
       2:useMeasureHBar  := true;
//       3:useStackHBar    := true;
//       5:UseRankingHBar  := true;
//       6:useQuad         := true;
//       7:useCntl         := true;
        8:;
    end;
    rs.movenext;
  end;
  rs.close;
  rs:=unassigned;

end;


  procedure dropTable(t:string);
  var db:string;
       s:string;
  begin
     if t[1] = '#' then db:='tempdb..' else db:='';
     s:=format('if not -1 in(select isnull(OBJECT_ID(''%0:s%1:s''),-1))'#13#10+
               'begin'#13#10+
               'drop table %1:s'#13#10+
               'end',[db,t]);
     cn.execute(s);
  end;


procedure CreateTrailer;

begin
    Kids:=Kids+']>>'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+format('%d 0 obj'#10,[ObjCount+1]);
    buf:=buf+'<</Type/Pages'#10;
    buf:=buf+format('/Count %d'#10,[p]);
    buf:=buf+Kids;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+format('%d 0 obj'#10,[ObjCount+2]);
    buf:=buf+'<</Type/Catalog'#10;
    buf:=buf+format('/Pages %d 0 R'#10,[ObjCount+1]);
    buf:=buf+'/PageMode /UseOutlines'#10;
    buf:=buf+'/Outlines 6 0 R'#10;
   // buf:=buf+'/ViewerPreferences << /HideToolbar false /HideMenubar false /HideWindowUI false>>'#10;
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+format('%d 0 obj'#10,[ObjCount+3]);
    buf:=buf+'<</CreationDate (D:';
    buf:=buf+ FormatDateTime('yyyymmddhhmmss)'#10,now);
    buf:=buf+'/Producer (National Research Corporation)'#10;
    buf:=buf+'/Author (National Research Corporation)'#10;
    buf:=buf+'/Creator (Action Plan Builder)'#10;
    buf:=buf+Format('/AP_ID (%s)'#10,[APID]);
    buf:=buf+Format('/JOB_ID (%s)'#10,[Job_ID]);
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xrefpos:=length(buf);
    buf:=buf+format('xref'#10'0 %d',[ObjCount+4]);
    buf:=buf+#10'0000000000 65535 f'#13#10+xref;

    buf:=buf+'trailer'#10;
    buf:=buf+format('<</Size %d'#10'/Info %d 0 R'#10,[ObjCount+4,ObjCount+3]);
    buf:=buf+format('/Root %d 0 R'#10'>>'#10'startxref'#10'%d'#10,[ObjCount+2,xrefpos]);
    buf:=buf+'%%EOF';
end;

function CreatePDF:boolean;
var
   curvbar,vbarcount:integer;
   PatternStr,FooterStr,s:string;
   FooterLine1,FooterLine2:string;
   ConfidenceInterval:string;
   fs,ArrowX1,ArrowX2,tempX:double;
   i,j:integer;
   strContactLine:string;
   FontStream:string;
   Length1:integer;
   lstAPs:TList;
   CurrVal:integer;
   pages:tstringlist;
   Outlines:tstringlist;
   PagesRs:variant;
   ContactY:double;
   HBarHight:double;
   HBarFs:double;
   thishbar:string;
   tempy:double;
   hbarRatio:double;
   CautionBubbleNSize:integer;
   CompType:byte;
   ComponentsCounter:integer;
   ColsRs:variant;

      procedure VerticalBars;
      begin
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating VBARS on page %d',[i]));
          inc(curVbar);
          x:=50;
          if vbarcount = 1 then x:= 168 else
          if curvbar = 2 then x:= 356;
          y:=PageHeight-(inch * 4);
          buf2:=buf2+GetVbars(x,y,inttostr(curVbar),cn,p);
          buf2:=buf2+DivLine(y);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        Procedure QuadrantChars;
        begin
          y:=PageHeight-(inch * 4);
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating QUADCHARTS on page %d',[i]));
          buf2:=buf2+quad(y,p,cn,Job_id);
          buf2:=buf2+divline(y);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        Procedure MeasureHorizontalBars;
        begin
          
          HBarRatio:= 0.17;
          HBarHight:= inch*HBarRatio;
          HBarFs:=8;
          onepage:=mainform.cbOnePage.Checked;
          fit:=true;
          if (OnePage and (p = 1)) then
          begin
            repeat
              ClearHBHeaders;
              thisHbar:='';
              DrawHBLegend:=True;
              morehbars:=false;
              HBarsCounter:=0;
              if rs2.state=1 then
                rs2.close;

              HBarHight:= inch*HBarRatio;
              tempy:=y;
              thisHbar:= hbarmn(220,y,HBarHight,w,p,cn,false,componentid,Job_id,HBarFs);
              y:=tempy;
              HBarRatio:=HBarRatio-0.002;
              if HBarFs > 5.6 then
                HBarFs:=HBarFs-0.02;
            until fit;
          end
          else
          begin
            thisHbar:='';
            thisHbar:= hbarmn(220,y,HBarHight,w,p,cn,false,componentid,Job_id,HBarFs);
          end;
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating HBARMN on page %d',[i]));
          buf2:=buf2+thisHbar;
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');

        end;

        procedure StackedHorizontalBars;
        begin

          HBarFs:=8;
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating Stacked HBars on page %d',[i]));
          buf2:=buf2+thisHbar;
          buf2:=buf2+hbarmn(220,y,inch*0.17,w,p,cn,true,componentid,Job_id,HBarFs);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
          
        end;

        procedure BreakoutRankingHorizontalBars;
        begin
          DrawHBLegend:=True;
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating HBARPCs on page %d',[i]));
          buf2:=buf2+hbarpc(220,y,inch*0.12,w,p,Job_id,cn,componentid,CompType = 4);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');

        end;

        procedure ControlCharts;
        begin
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating CONTROL CHARTS on page %d',[i]));
          buf2:=buf2+Cntrl(y,p,cn,Job_id,PageSection,rs);
          y:=y-30;
          cntlmain := PageSection='MAIN';
          if not cntlmain then
            buf2:=buf2+divline(y);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        procedure Narrative;
        begin
          if not (i in NoLegendPages) then
            NoLegendPages:=NoLegendPages+[i];

          if (strOutLineTitle[1] <> strOutLineTitle[0]) then
          begin
            strOutLineTitle[1] := strOutLineTitle[0];
            outlines.AddObject(strOutLineTitle[0],tobject(i));
          end;

          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating NARRATIVE on page %d',[i]));
          buf2:=buf2+GetNarrative(y,Job_id,componentid,p,cn);
          buf2:=buf2+DivLine(y);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        procedure TabularRankingTitle;
        begin
          if not (i in NoLegendPages) then
            NoLegendPages:=NoLegendPages+[i];

          if (strOutLineTitle[1] <> strOutLineTitle[0]) then
          begin
            strOutLineTitle[1] := strOutLineTitle[0];
            outlines.AddObject(strOutLineTitle[0],tobject(i));
          end;

          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating TABULAR RANKING TITLE on page %d',[i]));
          GetTabularTitle(y,Job_id,componentid,p,cn,pages,buf2);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        procedure TabularRankingSection;
        begin
          if not (i in NoLegendPages) then
            NoLegendPages:=NoLegendPages+[i];
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating TABULAR RANKING SECTION on page %d',[i]));
          GetTabularRankingSection(y,Job_id,componentid,p,cn,pages,buf2);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        procedure BoxPlot;
        begin
          //GN05: if not (i in NoLegendPages) then
          //  NoLegendPages:=NoLegendPages+[i];
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating BOX PLOT CHART on page %d',[i]));

          buf2 := buf2 + PlotChart(y,job_id,componentid,p,cn);

          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
        end;

        procedure HSRankingReport;
        begin
          UpdateForm(TH_UPDATE,ComponentsCounter,format('Creating TABULAR RANKING SECTION on page %d',[i]));
          GetHSRankingReport(y,Job_id,componentid,p,cn,pages);
          UpdateForm(TH_THISPROGRESSPOS,ComponentsCounter,'');
          UpdateForm(TH_ALLPROGRESSPOS,AllComponentsCounter,'');
          buf2:='';
        end;


begin
  try
    pages:=tstringlist.Create;
    Kids:='';
    xref:='';
    buf:='';
    buf2:='';
    ClientLogo:='';
    Componentid:='';
    PageSection:='';
    NrcJpeg:='';
    FooterStr:='';
    s:='';
    MaxNCount:=0;
    FooterLine1:='';
    FooterLine2:='';
    ConfidenceInterval:='';
    ClientLogoName:='';
    NRCLogoName:='';
    UseNRCLogo:=false;
    UseClientLogo:=false;
    ObjCount := Objects;
    CautionImage:='';
    PageSection:='';
//    useVBar         :=false;//
    useMeasureHBar  :=false;
//    useStackHBar    :=false;//
//    UseRankingHBar  :=false;
//    useQuad         :=false;
//    useCntl         :=false;
    cntlmain:=false;
    sucessfull:=false;
    strOutLineTitle[0]:='';
    strOutLineTitle[1]:='';
    strContactName:='';
    strContactPhone:='';
    strContactEmail:='';
    MeasureType:=-1;
    MeasureTypeSub:=-1;
    LastGoodDate:=double(now);
    MoreHBars:=false;
    HBarsCounter:=0;
    MissingColumns :=[];
    DrawHBLegend:=false;
    lbl:='';
    Scale:='';
    TitleStr:='';
    CorrelationLabel:='';
    strGrouping:='';
    grouping:='';
    QuestionstoDisplay:=100;
    qstncore:='';
    ShowSig:=true;
    NewPage:=true;
    ShowRR:=true;
    strContactName  :=VarToStr(aprs.fields['strContactName'].value);
    strContactPhone :=VarToStr(aprs.fields['strContactPhone'].value);
    strContactEmail :=VarToStr(aprs.fields['strContactEmail'].value);
    Mockup:=UpperCase(trim(VarToStr(aprs.fields['gen_type'].value))) <> 'STAND';
    ConfidenceInterval:=trim(VarToStr(aprs.fields['numConfidenceInterval'].value));
    if ConfidenceInterval ='' then ConfidenceInterval :='95 %' else ConfidenceInterval := ConfidenceInterval+' %';
    ClientLogoName:=trim(VarToStr(aprs.fields['strClientLogo_nm'].value));
    NrcLogoName:=trim(aprs.fields['nrclogo'].value);
    UseNRCLogo:= NrcLogoName <> '';


    UseCaution:= aprs.fields['bCaution'].value;

    ShowSig:= aprs.fields['PerformSigTest'].value;
    ShowRR:= aprs.fields['showresponserate'].value;

    UpdateForm(TH_NEWAP,ComponentsCounter,format('{\rtf1{\colortbl\0;\blue230;}\cf0\b Creating PDF for \cf1%s\cf0\b0}',[apid]));

    SetItemsUsed(format('and job_id = %s',[job_id]));

    if useMeasureHBar then
    begin
       s:=format('select distinct Current_Value from '+hbar_stats_final+' where job_id = %s',[job_id]);
       if rs.state = 1 then rs.close;
       rs.Open(s,cn,1,1);
       if not rs.eof then
       begin
         CurrVal:=strtoint(Trim(VarToStr(rs.fields[0].value)));
         rs.close;
         s:=format('SELECT Max(cast([value%d] as decimal(8,2))) AS Expr1 '+
            'FROM %s AS a INNER JOIN %s AS b ON '+
            'a.[job_id] = b.[job_id] AND '+
            'a.[Page_number] = b.[Page_number] AND '+
            'a.[component_id] = b.[component_id] '+
            'WHERE a.[component_type]=2 AND '+
            'a.MeasureType = 3 '+ //MeasureType 3 = N-Size
            'AND a.job_id = %s',[CurrVal,comp_detail,hbar_stats_final,job_id]);


         rs.Open(s,cn,1,1);
         if not varisnull(rs.fields[0].value) then
           MaxNCount:=strToFloat(Trim(VarToStr(rs.fields[0].value)));
       end;
       rs.close;
       s:='';
    end;

    strappath:=getappath(apid,clientid,studyid,surveyid,apdesc,outputlevel,location,HtmlPathRoot);

    Kids:='/Kids[';
    xref:='';
    buf:='%PDF-1.2'#13#10;

    LogoWidth:=100.0;
    if UseNRCLogo then
      begin
      NrcJpeg:=GetImageData(NrcLogoPath+NrcLogoName,ImageWidth1,ImageHeight1,UseNRCLogo,'/Im1');
      LogoHeight:=(LogoWidth/imagewidth1)*ImageHeight1;
    end;


    UseClientLogo:= true;
    ClientLogo:=GetImageData(ClientLogoPath+'_'+Clientid+'\'+ClientLogoName,ImageWidth2,ImageHeight2,UseClientLogo,'/Im2');

    CautionImage:='';
//    UseCaution:=true;
    if UseCaution then
    begin
      CautionImage:=GetImageData(NrcLogoPath+'Caution.jpg',ImageWidth3,ImageHeight3,UseCaution,'/Im3');
    end;


    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;
    buf:=buf+'1 0 obj'#10'<<'#10'/ProcSet [ /PDF /Text /ImageC]'#10;
    buf:=buf+'/XObject <</Im1 11 0 R /Im2 12 0 R /Im3 13 0 R>>'#10;
    buf:=buf+'/Font << /F1 2 0 R /F2 3 0 R /F5 8 0 R >>'#10;
    buf:=buf+'/Pattern << /P1 4 0 R >>'#10;
    buf:=buf+'/ColorSpace << /CS1 [/Pattern /DeviceRGB] >>'#10;
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;
    buf:=buf+'2 0 obj'#10;
    buf:=buf+'<<'#10;
    buf:=buf+'/Type /Font'#10;
    buf:=buf+'/Subtype /Type1'#10;
    buf:=buf+'/Name /F1'#10;
    buf:=buf+'/Encoding /WinAnsiEncoding'#10;
    buf:=buf+'/BaseFont /Arial'#10;
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;
    buf:=buf+'3 0 obj'#10;
    buf:=buf+'<<'#10;
    buf:=buf+'/Type /Font'#10;
    buf:=buf+'/Subtype /Type1'#10;
    buf:=buf+'/Name /F2'#10;
    buf:=buf+'/Encoding /WinAnsiEncoding'#10;
    buf:=buf+'/BaseFont /Arial,Bold'#10;
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    PatternStr:='0.5 w 1 J 0.2 G 1 0 0 rg'#10;

    for j:= -20 to 20 do
    begin
      PatternStr:=PatternStr+format('%d 0 m'#10,[j*5]) ;
      PatternStr:=PatternStr+format('%d 100 l'#10,[100+(j*5)]);
      PatternStr:=PatternStr+'b'#10;
    end;

    if mainform.cbCompress.Checked then
      PatternStr:=CompressStr(PatternStr);

    buf:=buf+'4 0 obj'#10;
    buf:=buf+'<<'#10;
    buf:=buf+'/Type /Pattern'#10;
    buf:=buf+'/PatternType 1'#10;
    buf:=buf+'/Resources 5 0 R'#10;
    buf:=buf+'/PaintType 1 /TilingType 1'#10;
    buf:=buf+'/BBox [0 0 100 100]'#10;
    buf:=buf+'/XStep 100 /YStep 100'#10;
    if mainform.cbCompress.Checked then
      buf:=buf+format('/Filter /FlateDecode /Length %d'#10,[length(PatternStr)])
    else
      buf:=buf+format('/Length %d'#10,[length(PatternStr)]);
    buf:=buf+'>>'#10;
    buf:=buf+'stream'#10;
    buf:=buf+PatternStr;
    buf:=buf+'endstream'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'5 0 obj'#10;
    buf:=buf+'<< /ProcSet [/PDF] >>'#10;
    buf:=buf+'endobj'#10;



    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'6 0 obj'#10+
             '<<'#10+
             '/First 7 0 R'#10+
             '/Last 7 0 R'#10+
             '>>'#10+
             'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    PagesRs :=CreateOleObject('ADODB.Recordset');
    PagesRs.Open('select count(distinct Page_Title) as cnt from '+comp_detail+' where job_id ='+job_id,cn,1,1);

    p:= PagesRs.fields['cnt'].value;

    PagesRs.close;

    buf:=buf+'7 0 obj'#10+
             format('<<'#10'/Title (%s)'#10,[strClient_Nm])+
             '/Parent 6 0 R'#10+
             '/First 14 0 R'#10+
             format('/Dest [%d 0 R /XYZ null null null]'#10,[Objects+p+1])+
             format('/Count %d'#10,[p])+
             format('/Last %d 0 R'#10,[Objects+p])+
             '>>'#10+
             'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'8 0 obj'#10;
    buf:=buf+'<<'#10;
    buf:=buf+'/Type /Font'#10;
    buf:=buf+'/Subtype /TrueType'#10;
    buf:=buf+'/FirstChar 72'#10;
    buf:=buf+'/LastChar 76'#10;
    buf:=buf+'/Widths [300 300 300 300 300]'#10;
    buf:=buf+'/Encoding /PDFDocEncoding'#10;
    buf:=buf+'/BaseFont /NRCArrows'#10;
    buf:=buf+'/FontDescriptor 9 0 R'#10;
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'9 0 obj'#10;
    buf:=buf+'<<'#10;
    buf:=buf+'/Type /FontDescriptor'#10;
    buf:=buf+'/Ascent 300'#10;
    buf:=buf+'/CapHeight 600'#10;
    buf:=buf+'/Descent -300'#10;
    buf:=buf+'/Flags 98'#10;
    buf:=buf+'/FontBBox [ -300 -300 300 300 ]'#10;
    buf:=buf+'/FontName /NRCArrows'#10;
    buf:=buf+'/ItalicAngle 0'#10;
    buf:=buf+'/StemV 65.153'#10;
    buf:=buf+'/FontFile2 10 0 R'#10;
    buf:=buf+'>>'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;
    FontStream:=GetFontStream(ArrowsPath+'Arrows.ttf');
    length1:=length(FontStream);
    if mainform.cbCompress.Checked then
      FontStream:=CompressStr(FontStream)+#10;

    buf:=buf+'10 0 obj'#10;
    if mainform.cbCompress.Checked then
       buf:=buf+format('<</Filter /FlateDecode /Length %d /Length1 %d>>'#10,[length(FontStream),Length1])
    else
       buf:=buf+format('<</Length %d /Length1 %d>>'#10,[length(FontStream),Length1]);

    buf:=buf+'stream'#10;
    buf:=buf+FontStream+#10;
    buf:=buf+'endstream'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'11 0 obj'#10;
    buf:=buf+Format('<< /Type /XObject /Subtype /Image /Name /Im1 /Width %g /Height %g /BitsPerComponent 8 /ColorSpace /DeviceRGB /Length %d /Filter /DCTDecode >>'#10,[ImageWidth1,ImageHeight1,Length(NrcJpeg)]);
    buf:=buf+'stream'#10;
    buf:=buf+NrcJpeg;
    buf:=buf+#10'endstream'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'12 0 obj'#10;
    buf:=buf+Format('<< /Type /XObject /Subtype /Image /Name /Im2 /Width %g /Height %g /BitsPerComponent 8 /ColorSpace /DeviceRGB /Length %d /Filter /DCTDecode >>'#10,[ImageWidth2,ImageHeight2,Length(ClientLogo)]);
    buf:=buf+'stream'#10;
    buf:=buf+ClientLogo;
    buf:=buf+#10'endstream'#10;
    buf:=buf+'endobj'#10;

    xref:=xref+FormatFloat( '0000000000',Length(buf));
    xref:=xref+' 00000 n'#13#10;

    buf:=buf+'13 0 obj'#10;
    buf:=buf+Format('<< /Type /XObject /Subtype /Image /Name /Im3 /Width %g /Height %g /BitsPerComponent 8 /ColorSpace /DeviceRGB /Length %d /Filter /DCTDecode >>'#10,[ImageWidth3,ImageHeight3,Length(CautionImage)]);
    buf:=buf+'stream'#10;
    buf:=buf+CautionImage;
    buf:=buf+#10'endstream'#10;
    buf:=buf+'endobj'#10;

    outlines:=tstringlist.create;

    MoreHbars:=false;
    HBarsCounter:=0;
    i:=0;
    PagesRs :=CreateOleObject('ADODB.Recordset');
    PagesRs.Open(Format('select count(*) from APO_CompDetail where job_id = %s',[Job_id]) ,cn,1,1);

    p:=PagesRs.fields[0].value;

    UpdateForm(TH_THISPROGRESSMAX,p,'');

    PagesRs.close;

    PagesRs.Open(Format('select distinct page_number,orientation from APO_ActionPlan where job_id =%s order by page_number',[Job_id]) ,cn,1,1);

    //PagesRs.Open(Format('select distinct page_number,0 as Orientation from APO_ActionPlan where job_id =%s order by page_number',[Job_id]) ,cn,1,1);


    LandscapePages:=[];
    NoLegendPages:=[];
    //HSReport := [];
    while not PagesRs.eof do
    begin


      p:=pagesrs.fields[0].value;
      Landscape:=pagesrs.fields[1].value;
      //Landscape:=true;

      ColsRs := cn.execute( 'SELECT '+
                            'isnull(max(Current_Column_Number - 1),0) AS prevCnt, '+
                            'isnull(max(Column_Number - Current_Column_Number),0) AS CompCnt '+
                            'FROM APO_CompDetail '+
                            'WHERE Job_ID = '+ Job_id + ' ' +
                            'AND Component_Type BETWEEN 1 AND 5 '+
                            'AND Page_Number = '+IntToStr(p));
      if not ColsRs.eof then
      begin
        MaxPrevCnt := ColsRs.Fields['prevCnt'].value;
        MaxCompCnt := ColsRs.Fields['CompCnt'].value;
      end;
      ColsRs.close;
      ColsRs := UnAssigned;

      activeFont:='/F1';
      if not Morehbars then
      begin
        HBarsCounter:=0;
        inc(i);
        if Landscape then
          LandscapePages:=LandscapePages+[i];
        DrawHBLegend:=True;
        rs.open(format('select count(*) from %s where component_type=1 and job_id =%s and page_Number =%d',[comp_detail,job_id,p]),cn,1,1);

        vbarcount:=strtointdef(vartostr(rs.fields[0].value),0);
        rs.close;
        s:=format('select distinct component_type, component_id,strtitle_line1,strtitle_line2,page_title,'+
                       'cast(dtiCurrentTimeBegin as datetime) as dtiCurrentTimeBegin,'+
                       'cast(dtiCurrentTimeEnd as datetime) as dtiCurrentTimeEnd,'+
                       'cast(dtiPrimaryTimeEnd as datetime) as dtiPrimaryTimeEnd,'+
                       'cast(dtiSecondaryTimeEnd as datetime) as dtiSecondaryTimeEnd,'+
                       'MeasureType,'+
                       'MeasureTypeSub,'+
                       'strGrouping,'+
                       'case when OrderBy = 50 then 1 else 0 end as UseHbarLegend,'+
                       'ComparisonColumn,'+
                       'SortLegend,'+
                       'stacked_bars,page_section,dtiLastDataPoint,'+
                       'case when strYAxis =''Positive'' then 1 else 0 end as posyAxis, '+
                       'strDataPointTime,strCustomTimeIncrement,numCustomTimeNumber, strpageheaderoverride, '+
                       'correlation_question_label '+
                       'from %s where Job_id =%s '+
                       'and page_Number =%d '+
                       'and component_id > 0   order by component_id',
                       [comp_detail,job_id,p]);
        rs.open(s,cn,1,1);
        s:='';
      end;

      case Landscape of
        true : begin
                 PageWidth  := 11*inch;
                 PageHeight := 8.5*inch;
               end;
        False: begin
                 PageWidth  := 8.5*inch;
                 PageHeight := 11*inch;
               end;
      end;

      RightMargin:= (PageWidth - LeftMargin);
      x:=LeftMargin;
      y:=PageHeight-LeftMargin;
      w:= 100;
      curvbar:=0;


    PageHeaderLines[0]:='';
    PageHeaderLines[1]:='';
    PageHeaderLines[2]:='';
    PageHeaderLines[3]:='';

    strPageHeaderOverride := '';

    if not rs.eof then
    begin
      strPageHeaderOverride := trim(VarToStr(rs.fields['strPageHeaderOverride'].value));

      strOutLineTitle[0] := VarToStr(rs.fields['page_title'].value);
      PageHeaderLines[0]:= VarToStr(rs.fields['strtitle_line1'].value)+'-'+VarToStr(rs.fields['page_title'].value);
      isPepC := pos('Pep-C', PageHeaderLines[0]) > 0;
      if not varisnull(rs.fields['strtitle_line2'].value) then
      PageHeaderLines[1]:= rs.fields['strtitle_line2'].value;

      if  strPageHeaderOverride = '' then
         PageHeaderLines[2]:= FormatDateTime('mmm d, yyyy',rs.fields['dtiCurrentTimeBegin'].value)+' - '+FormatDateTime('mmm d, yyyy',rs.fields['dtiCurrentTimeEnd'].value)
      else
        PageHeaderLines[2]:= strPageHeaderOverride;
      PageHeaderLines[2]:=PageHeaderLines[2]+' (n=';
      PageHeaderLines[2]:=PageHeaderLines[2]+VarToStr(aprs.fields['returned_survey_n'].value);
      if showrr then
      begin
        PageHeaderLines[2]:=PageHeaderLines[2]+', Response Rate= ';

        if (not varisnull(aprs.fields['response_rate'].value))  and (not mockup) then
        begin
           rr:= strtofloat(VarToStr(aprs.fields['response_rate'].value));
           PageHeaderLines[2]:=PageHeaderLines[2]+formatfloat('0.0%',round(rr*10000)*0.0001);
        end;

        if mockup then
          PageHeaderLines[2]:=PageHeaderLines[2]+'50.0%';



      end;
      if uppercase(VarToStr(aprs.fields['strTitleType'].value)) = 'STD' then
        PageHeaderLines[2]:=PageHeaderLines[2]+')'
      else
        PageHeaderLines[3] := format('Non-Deliverables=%s)',[VarToStr(aprs.fields['non_deliverables'].value)]);

    end;



      if CompType <> 13 then
      begin
        buf2:=PageHeader(y,MoreHbars);
      end;

      cntlmain:=false;
      TitleStr:='';
      ClearHBHeaders;
      while not rs.eof do
      begin
        SortLegend:=VarToStr(rs.fields['SortLegend'].value);
        UseHbarLegend:=boolean(rs.fields['UseHbarLegend'].value);
        PositiveYAxis:=boolean(rs.fields['posyaxis'].value);
        //boolPrimaryOverlap := rs.fields['dtiPrimaryTimeEnd'].value >= rs.fields['dtiCurrentTimeBegin'].value ;
        //boolSecondaryOverlap := rs.fields['dtiSecondaryTimeEnd'].value >= rs.fields['dtiCurrentTimeBegin'].value ;
        componentid:=trim(VarToStr(rs.fields['component_id'].value));
        MeasureType:=strToIntDef(VarToStr(rs.fields['MeasureType'].value),1);
        MeasureTypeSub:=strToIntDef(VarToStr(rs.fields['MeasureTypeSub'].value),1);
        strGrouping:=trim(VarToStr(rs.fields['strGrouping'].value));
        PageSection:=uppercase(trim(VarToStr(rs.fields['page_section'].value)));
        CorrelationLabel:=trim(VarToStr(rs.fields['correlation_question_label'].value));

        CompType:=strToIntDef(VarToStr(rs.fields['component_type'].value),0);
          
        case CompType of
          1  : VerticalBars;
          2  : MeasureHorizontalBars;
          3  : StackedHorizontalBars;
          4,5: BreakoutRankingHorizontalBars;
          6  : QuadrantChars;
          7  : ControlCharts;
          8  : Narrative;
          10 : TabularRankingTitle;
          11 : TabularRankingSection;
          12 : BoxPlot;
          13 : HSRankingReport;
        end;

        if MoreHbars or (rs.eof) then break;

        rs.movenext;
      end; //This page

      if buf2 <> '' then
      begin
        if Mockup then buf2:= buf2 + buf2+'q 0.8 g /F1 100 Tf BT 0.5 0.866 -0.866 0.5 250 186 Tm (DRAFT) Tj ET Q'#10;
        pages.AddObject(buf2,tobject(cntlmain));
      end;

      buf2:='';

      if (strOutLineTitle[1] <> strOutLineTitle[0]) and (not(CompType in [10,11]))  then
      begin
        strOutLineTitle[1] := strOutLineTitle[0];
        outlines.AddObject(strOutLineTitle[0],tobject(pages.Count));
      end;

      if rs.eof then
       rs.close;
    if not morehbars then
    pagesrs.movenext;
   /////////////////////////////////////////////////////////////////////////////
    end; //All pages
    pagesrs.close;
    pagesrs:=unassigned;
////////////////////////////////////////////////////////////
    OutlineCount:=outlines.Count;
    for i := 0 to OutlineCount-1 do
    begin
      inc(ObjCount);

      xref:=concat(xref,FormatFloat( '0000000000',Length(buf)),' 00000 n'#13#10);

      buf:=buf+format('%d 0 obj'#10,[ObjCount]);
      buf:=buf+format('<< /Title (%s)'#10,[outlines.strings[i]]);
      buf:=buf+'/Parent 7 0 R'#10;
      if i < OutlineCount-1 then
        buf:=buf+format('/Next %d 0 R'#10,[ObjCount+1]);
      if i > 0 then
        buf:=buf+format('/Prev %d 0 R'#10,[ObjCount-1]);

      buf:=buf+format('/Dest [%d 0 R /XYZ 0 792 null]'#10,[(integer(outlines.objects[i])*2)+OutlineCount+objects-1]);
      buf:=buf+'>>'#10;
      buf:=buf+'endobj'#10;
    end;

//////////////////////////////////////////////////////


    p:=pages.Count;
    OutlineCount:=p*2+ObjCount+1;
    for i := 0 to p-1 do
    begin
      case (i+1 in Landscapepages) of
        true : begin
                 PageWidth  := 11*inch;
                 PageHeight := 8.5*inch;
               end;
        False: begin
                 PageWidth  := 8.5*inch;
                 PageHeight := 11*inch;
               end;
      end;


      RightMargin:= (PageWidth - LeftMargin);

      inc(ObjCount,2);
      Kids:=Kids+format('%d 0 R'#10,[ObjCount-1]);

      xref:=concat(xref,FormatFloat( '0000000000',Length(buf)),' 00000 n'#13#10);

      buf:=buf+format('%d 0 obj'#10'<</Type /Page'#10'/Parent ',[ObjCount-1]);
      buf:=buf+format('%d 0 R'#10'/Resources 1 0 R'#10'/MediaBox[0 0 %g %g]'#10,[OutlineCount,PageWidth,PageHeight]);
      buf:=buf+format('/Contents[%d 0 R]'#10'>>'#10'endobj'#10,[ObjCount]);

      xref:=concat(xref,FormatFloat( '0000000000',Length(buf)),' 00000 n'#13#10 );

      ActiveFont:='/F1';
      buf2:=textat(33,pageheight-0.4*inch,'',8,formatdatetime('mmmm dd, yyyy',now),100,'L',false,'');
      buf2:=buf2+textat(PageWidth-33,pageheight-0.4*inch,'',8,format('Page %d of %d',[i+1,p]),100,'R',false,'');

      pages.Strings[i]:=buf2+pages.Strings[i];
      buf2:='';

      cntlmain := boolean(pages.Objects[i]);
      FooterStr:='';
      if not cntlmain then
      begin
        fs:=8;
        FooterLine1:='Your current score is: higher     or lower   .';
        TempX:=GetTextWidth(FooterLine1,'',fs );
        TempX:=(PageWidth*0.5)-(tempx*0.5);
        ArrowX1:=TempX+GetTextWidth('Your current score is: higher.','',fs);
        ArrowX2:=TempX+GetTextWidth('Your current score is: higher or lower A','',fs);

        ActiveFont:='/F1';

        FooterLine1:=TextAt(TempX,70-fs*1.25,'',fs,FooterLine1,500,'L',false,'');


        if not (i+1 in NoLegendPages) then
        begin
          FooterLine2:=Format('Arrow represents statistically significant differences, at the %s confidence level, from your current score.',[ConfidenceInterval]);
          FooterLine2:=TextAt(PageWidth/2,70,'',fs,FooterLine2,600,'C',False,'');
          FooterLine2:=FooterLine2+FooterLine1;
          FooterStr:=FooterStr+DrawArrow(ArrowX1,70-fs*1.25,fs,'0 g','H');
          FooterStr:=FooterStr+DrawArrow(ArrowX2+2,70-fs*1.25,fs,'0 g','L');
          FooterStr:=FooterStr+FooterLine2;
          FooterStr:=DivLine(85)+FooterSTr;
        end;




        Contacty:=40.0;
        strContactLine:='';
         if strContactName <> '' then
        begin  // print contact information if it exists //
           if clientid <> '246' then
           begin
             strContactLine := TextAt(33.0,Contacty,'',8,'For more information contact:',200,'L',false,'');
             Contacty:=Contacty-10;
           end;

           if strContactPhone <> '' then
              strContactLine := strContactLine+TextAt(33.0,Contacty,'',8,strContactName+' at '+strContactPhone,200,'L',false,'')
           else
             strContactLine := strContactLine+TextAt(33.0,Contacty,'',8,strContactName,200,'C',false,'');

           Contacty:=Contacty-10;
           if strContactEMail <> '' then
              strContactLine := strContactLine+TextAt(33.0,Contacty,'',8,'at '+strContactEMail,200,'L',false,'');
        end;

        footerstr:=footerstr+strContactLine;

      end;
      //if not (i+1 in HSReport) then
      begin
         FooterStr:=FooterSTr+DivLine(50);
         pages.Strings[i]:=pages.Strings[i]+FooterStr;
      end;
     // if (usenrclogo) and (not (i+1 in HSReport)) then
       //  pages.strings[i]:=Format( #10'q %g 0 0 %g %g %g cm /Im1 Do Q'#10,[ImageWidth1/96*72,ImageHeight1/96*72,PageWidth-(ImageWidth1/96*72)-33,50-(ImageHeight1/96*72)-2  ] )+pages.strings[i];

      if mainform.cbCompress.Checked then
      begin
        pages.strings[i]:=CompressStr(pages.strings[i])+#10;
        buf := buf+format('%d 0 obj'#10'<< /Length %d /Filter [/FlateDecode]>>'#10,[ObjCount,Length(pages.strings[i])]);
      end
      else
        buf := buf+format('%d 0 obj'#10'<< /Length %d >>'#10,[ObjCount,Length(pages.strings[i])]);

      buf:=buf+'stream'#10;
      buf:=buf+pages.strings[i];
      buf:=buf+'endstream'#10;
      buf:=buf+'endobj'#10;
    end;

    CreateTrailer;

    if not DirectoryExists(strappath) then
       ForceDirectories(strappath);

    buf2:=strappath+apid+'.pdf';
    if paramstr(1)='DEBUGMODE' then
      buf2:='c:\temp\'+apid+'.pdf';
      
//    repeat
      //sucessfull:=true;
      try
         AssignFile(f,buf2);
         Rewrite(f);
         Write(f,buf);
         result:=true;
         buf:='';
         s:='';
      except
       // sucessfull:=true;
        result:=false;
        {i:=messagebox(form1.handle,pchar(buf2+' is open by another user.'#13#10'Would you like to specify a different name?'),'Write error',MB_YESNO );
        if i=IDYES then
        begin
          savedialog:=tsavedialog.create(form1);
          savedialog.FileName := buf2;
          if savedialog.Execute then
          begin
             buf2:=savedialog.FileName;
          end;
        end
        else
         sucessfull:=true;}
      end;
   // until (sucessfull) or (i = idcancel);
    //if i <> idno then closefile(f);
    if result then closefile(f);
    pages.free;
    //re:=nil;
  except
    result:=false;
    //re:=nil;
  end;

end; //CreatePDF

procedure Notify(strBody,strTo,strCC,strFrom,strSubject,ExtractLateHtml:string);
var
   myMail:Variant; //??OleVariant VarNull
   x:variant;
begin
   if paramstr(1)='DEBUGMODE' then
   begin
      strTo:='gnelson';
      strCC:='';
   end;

   if ExtractLateHtml <> '' then
   begin
      strBody:= '<p><font color=red><B>WARNING!</B> Some reports may contain old data.</font><br>'+
      'Scroll to the end or <A HREF="#reports with old data">CLICK HERE</A>'+
      ' for details<br><br></p>' + strBody;
      
      strBody := strBody + '<br><br><br>'+
      '<p><FONT Color=Red><A NAME="reports with old data">'+
      'Action Plans with possible old data</A></font><br></p>'+
      '<p><table border="1">'+ExtractLateHtml+'</table></p>'
   end;

   if not mainform.cbNotify.Checked  then exit;

   //GN04: CDO for Exchange 2000 object library (Cdoex.dll)
   //use the Addressee object to resolve an address
   x := CreateOleObject('CDO.Addressee');
   try
      x.EmailAddress:=strTo; //Indicate the email address to check
      if not x.CheckName ('LDAP://'+sMailServer) then    //if the name exists in the Active Directory, CheckName returns True.
      begin
         mainform.re1.Lines.Add('Unable to resolve addressee directory LDAP://' + sMailServer + ' This mailbox doesn''t exist in the current domain');
         x.EmailAddress :=  strTo + '@NationalResearch.com'
      end;

      strTo := x.EmailAddress;
      mainform.re1.Lines.Add('**Notify: ' +  strTo + ' EmailAddress>> ' + x.EmailAddress);
      strSubject := strSubject + x.DisplayName;
      x     := UnAssigned;
   except
      on E:Exception do
      begin
         //SMTP server needs the fully qualified email address 
         if Pos('@NationalResearch.com',strTo) = 0 then
            strTo := strTo + '@NationalResearch.com';

         mainform.re1.Lines.Add(E.Message);
         strSubject := 'Action Plan Reports'; //For Canada as they don't support LDAP
         x     := UnAssigned;
      end;
   end;

   {GN04: Collaboration Data Objects scripting-object library cdo.dll / Microsoft CDO for Exchange 2000 Library
   Microsoft Outlook 2002 includes CDO 1.21 as an optional component install
   1. Copy the appropriate CDO.DLL file to the Windows\System32 Directory.
   2. Register the CDO.DLL by executing REGSVR32.EXE CDO.DLL.
   }
   myMail := CreateOleObject('CDO.Message');
   try
      myMail.Subject  := strSubject;
      myMail.From     := strFrom;
      myMail.CC       := strCC;
      myMail.To       := strTo;
      myMail.HTMLBody := '<html><body><p nowrap>'+strBody+'</p></body></html>'; //GN08: added the nowrap
  //    if sMailServerType = 'REMOTE' then
   //   begin
  //       myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusing') := cdoSendUsingPort;
  //       //Name or IP of remote SMTP server
  //       myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserver') := sMailServer;
  //       //Server port
  //       myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserverport') := 25;
  //       myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory') := 'c:\Inetpub\mailroot\pickup';

         //myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpauthenticate') := cdoBasic;
         //myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusername') := 'your-username';
         //myMail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendpassword') := 'your-password';

         //myMail.Configuration.Fields('urn:schemas:mailheader:disposition-notification-to') := strFrom;
         //myMail.Configuration.Fields('urn:schemas:mailheader:return-receipt-to') := strFrom;
  //       myMail.DSNOptions := cdoDSNSuccessFailOrDelay;
  //       myMail.Configuration.Fields.Update;
  //    end;
      try
         myMail.Send;
         mainform.re1.Lines.Add('Mail successfully sent to ' + strto);
      except
         on E:Exception do
            mainform.re1.Lines.Add(DateToStr(Date) + ' >> Error creating EMail component*** ' + E.Message);
      end;
   finally
      myMail := VarNull;
   end;

end; //Procedure Notify

function StartThread(data : Pointer):integer;
//////////////////////////////////////////////////////////////////////////////
/////////////////          main program begins here           /////////////////
///////////////////////////////////////////////////////////////////////////////



var
   strHTML:String;
   strURL:String;
   s,strTemp:string;
   iAllBatches,iThisBatch:integer;
   all_job_cnt:integer;
   JobsInList:string;
   LocalRs:variant;
   ExtractLate : boolean;
   ExtractLastUpdate : String;
   ExtractLateHTML:string;
   strClientLogoName:string;
begin

  AllComponentsCounter:=0;
  JobsInList:='(-99,';
  result:=0;
  CoInitialize(nil);
  fHandle:=MainForm.Handle;
  mainform.Start.enabled:=false;
  Job_Id:= 'NULL';
//  try
    try


      Cn:=CreateOleObject('ADODB.Connection');

      rs :=CreateOleObject('ADODB.Recordset');
      rs2 :=CreateOleObject('ADODB.Recordset');

      UpdateForm(TH_NEWAP,all_job_cnt,format('{\rtf1{\colortbl\0;\blue230;}\cf1\b Connecting to Server\cf0\b0}',[apid]));

      cn.CommandTimeout:=0;
      cn.Open('driver={SQL Server};SERVER='+server+';DATABASE='+Database,user0,user1,-1);

      mainform.re1.Lines.add('ADODB Connected');
      aprs :=CreateOleObject('ADODB.Recordset');
      UpdateForm(TH_NEWAP,all_job_cnt,format('{\rtf1{\colortbl\0;\blue230;}\cf1\b Connected to Server \cf1(%s)\cf0\b0}',
                                   [vartostr(cn.Properties['Server Name'].Value)]));

      s:='a';

      if MainForm.cbGenSpecific.Checked then
      begin
        s:=CreateList(MainForm.mAPs);
      end
      else
      begin

        s:= format('select '+
        'case when ((isnull(returned_survey_n,-1) < isnull(CautionBubbleNSize,'+
        'isnull(returned_survey_n,0))) and isnull(ShowCautionBubble,0) <> 0) '+
        'then 1 else 0 end as bCaution,'+
        'g.*,case numnrc_logo_Flag '+
        'when 1 then ''Nrc-clr2.jpg'''+
        ' when 2 then ''NRC_Picker.jpg''' +
        ' when 3 then ''NRC_smallerWorld.jpg'''+
        ' when 4 then ''NRC+PICKER.jpg'''+
        ' when 5 then ''NRC+PICKER_Canada.jpg'''+
        ' else '''' end  as nrclogo ,'+
        'l.status,l.notify '+
        'from %0:s g inner join %1:s l on l.job_id = g.job_id '+
        'where l.status = 50 order by l.job_id',[Global_Run_Table,Job_list]);
      end;

      if s='' then
      begin
        UpdateForm(TH_UPDATE,all_job_cnt,'No valid AP_ID entered.');
        SysUtils.beep;
        exit;
      end;
      aprs.open(s,cn,1,1);
      if not aprs.eof then
      begin
        While not aprs.eof do
        begin
           JobsInList:=JobsInList+vartostr(aprs.fields['Job_id'].value)+',';
           aprs.movenext;
        end;

        JobsInList[length(JobsInList)] := ')';
        LocalRs := cn.execute('select count(*) from APO_CompDetail where job_id in '+JobsInList);

        iAllBatches := LocalRs.Fields[0].value;

        LocalRs.close;
        LocalRs := Unassigned;

        aprs.movefirst;
        UpdateForm(TH_NEWAP,all_job_cnt,'Generating PDFs');
        UpdateForm(TH_ALLPROGRESSMAX,iAllBatches,'');

      end
      else
        UpdateForm(TH_NEWAP,all_job_cnt,'No PDFs to generate at this time.');

      iThisBatch:=0;
      while not aprs.eof do
      begin
        strClient_Nm:='';
        strAppath:='';
        clientID:='';
        apdesc:='';
        apid:=trim(aprs.fields['ap_id'].value);
        Job_Id:=trim(aprs.fields['Job_id'].value);
        apdesc := uppercase(trim(VarToStr(aprs.fields['strAP_Description'].value)));
        strClient_Nm := trim(VarToStr(aprs.fields['strClient_Nm'].value));
        ClientID:=trim(VarToStr(aprs.fields['Client_id'].value));
        outputlevel  := uppercase(trim(VarToStr(aprs.fields['output_level'].value)));
        location  := uppercase(trim(VarToStr(aprs.fields['HTML_Loc'].value)));
        studyid := trim(VarToStr(aprs.fields['study_id'].value));
        surveyid := trim(VarToStr(aprs.fields['survey_id'].value));
        UpdateForm(TH_UPDATE,all_job_cnt ,'-1');
        cn.execute(format('Update %0:s set status = 510 where job_id= %1:s',[Job_list,job_id]));
        UpdateForm(TH_NEWAP,all_job_cnt,format('{\rtf1{\colortbl\0;\blue230;}\cf0\Generating PDFs (%d of %d) - cf1\b %s\cf0\b0}',[iThisBatch,All_job_cnt,apid]));

        strURL:=GetUrl(apid,clientid,studyid,surveyid,apdesc,outputlevel,location,URLRoot);
        strappath:=getappath(apid,clientid,studyid,surveyid,apdesc,outputlevel,location,HtmlPathRoot);

        if CreatePDF then
          cn.execute(format('Update %0:s set status = 520, path = ''%2:s'', url = ''%3:s'' where job_id= %1:s',[Job_list,job_id,strappath,strURL]))
        else
        begin
          cn.execute(format('Update %0:s set status = 1510, path = ''%2:s'', url = ''%3:s'' where job_id= %1:s',[Job_list,job_id,strappath,strURL]));
        end;

        cn.execute('APB_OT_OverrideOldReport ' + job_id); //gn07

        inc(iThisBatch);
        aprs.moveNext;
      end; //while not aprs.eof

      UpdateForm(TH_UPDATE,all_job_cnt ,'Done');

    finally
      if (not VarIsNull(cn)) and (cn.state = 1) then
      begin
        if aprs.state = 1 then
          aprs.close;

        cn.execute('APB_CM_SetMailing'); //gn07
        s:='select '+
            'l.Job_ID,'+
            'l.AP_ID,'+
            'Survey_ID,'+
            'strClient_Nm,'+
            'l.status,' +
            'l.Mailing,' +
            'l.notify,' +
            'l.path,' +
            'l.url,' +
            'ExtractLate,' +
            'ExtractLastUpdate,' +
            'case when isnull(strClientLogo_nm,'''') <> '''' then '''+ClientLogoPath+'_''+cast(Client_ID as varchar(10))+''\''+strClientLogo_nm else '''' end as LogoPath,'+
            'g.strAP_Description,'+
            'g.output_level,'+
            'g.HTML_Loc,'+
            'g.study_id,'+
            'g.Client_id '+
            'from apo_globalruntable g '+
            'right join tbl_apjoblist l on l.job_id = g.job_id '+
            'where l.status in (520,1510,1511,1020,1030,1040,2001,2002,2003,2999) and l.mailing in (2,4) order by notify, g.Client_id, l.AP_id';

        aprs.open(s,cn,1,1);
        s:='(';
        strNotify:='';
        strHTML:='';
        strTemp:='x';
        while not aprs.eof do
        begin
          apdesc := uppercase(trim(VarToStr(aprs.fields['strAP_Description'].value)));
          apid:=trim(vartostr(aprs.fields['ap_id'].value));
          Job_Id:=trim(vartostr(aprs.fields['Job_id'].value));
          strClientLogoName:=trim(vartostr(aprs.fields['LogoPath'].value));
          outputlevel  := uppercase(trim(VarToStr(aprs.fields['output_level'].value)));
          location  := uppercase(trim(VarToStr(aprs.fields['HTML_Loc'].value)));
          studyid := trim(VarToStr(aprs.fields['study_id'].value));
          surveyid := trim(VarToStr(aprs.fields['survey_id'].value));
          ClientID:=trim(VarToStr(aprs.fields['Client_id'].value));

          strappath:=trim(VarToStr(aprs.fields['path'].value));
          strURL:=trim(VarToStr(aprs.fields['url'].value));

          ExtractLate:=boolean(strtointdef(vartostr(aprs.fields['ExtractLate'].value),0));
          ExtractLastUpdate:=trim(VarToStr(aprs.fields['ExtractLastUpdate'].value));

          { sql string to get url from path
          select path, replace(REPLACE( path , '\' , '/' ), '//neptune/qualisys/sasphase2/html' , 'http://corp/apb' )
          from tbl_apjoblist where job_id between 112651 and 112671
           }

          //strappath:=getappath(apid,clientid,studyid,surveyid,apdesc,outputlevel,location,HtmlPathRoot);
          //strURL:=GetUrl(apid,clientid,studyid,surveyid,apdesc,outputlevel,location,URLRoot);

          if uppercase(strNotify) <> uppercase(trim(VarToStr(aprs.fields['notify'].value))) then
          begin
            if strNotify <> '' then
              Notify(strHTML,strNotify,strCC,'apb@nationalresearch.com','Action Plans generated for ',ExtractLateHtml);
            strHTML:='';
            ExtractLateHtml:='';
            strNotify := trim(VarToStr(aprs.fields['notify'].value));
          end;
          case strtoint(vartostr(aprs.fields['status'].value)) of
              520  : if strClientLogoName=strTemp then
                       strHTML:=strHTML+format('%2:s <a href="%1:s%2:s.pdf">%0:s</a><br>',[apdesc,strURL,apid])
                     else
                     begin
                       strHTML:=strHTML+format('<img src ="%0:s"><br>%2:s <a href="%1:s%2:s.pdf">%3:s</a><br>',[strClientLogoName,strURL,apid,apdesc]);
                       strTemp:=strClientLogoName;
                     end;
              1510 : strHTML:=strHTML+format('%0:s - Error Creating PDF (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              1511 : strHTML:=strHTML+format('%0:s - Timeout Ceating PDF (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              1020 : strHTML:=strHTML+format('%0:s - Error while pulling (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              1030 : strHTML:=strHTML+format('%0:s - Error while generating statistics (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              1040 : strHTML:=strHTML+format('%0:s - Error while saving statistical results (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              2001 : strHTML:=strHTML+format('%0:s - AP no longer exists (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              2002 : strHTML:=strHTML+format('%0:s - AP has no template assigned (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              2003 : strHTML:=strHTML+format('%0:s - Template no longer exists (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
              2999 : strHTML:=strHTML+format('%0:s - Unknown error while generating report (AP_ID = %1:s; Job_ID = %2:s)<br>',[apdesc,apid,job_id]);
          end;
          if ExtractLate then
            ExtractLateHtml := ExtractLateHtml + format('<tr><td>%s</td><td>%s</td><td>%s</td></tr>',[apid,job_id,ExtractLastUpdate]);

          s:=s+job_id+',';
          aprs.movenext;
        end;

        if  strHTML <> '' then
          Notify(strHTML,strNotify,strCC,'apb@nationalresearch.com','Action Plans generated for ',ExtractLateHtml);

        if s<>'(' then
        begin
          s[length(s)]:=')';
          cn.execute('update tbl_apjoblist set Mailing = 3 where job_id in'+s);
        end;

        aprs.close;

        if (not varisnull(rs2)) and (rs2.state = 1) then
          rs2.close;

        if (not varisnull(rs)) and (rs.state = 1) then
          rs.close;
        cn.close;//!!??
      end;

      cn:=unassigned;
      rs:=unassigned;
      rs2:=unassigned;
      aprs:=unassigned;
      CoUninitialize;
      PostMessage(fHandle, TH_MESSAGE, TH_FINISHED, 0);
      //EndThread(0); //GN03
    end;

//  except
//      on E: Exception  do
//        UpdateForm(TH_UPDATE,this_job_cnt, E.message);
//  end;

end;

function Tmainform.CheckMem : Boolean;
var
   MemUsageNow : integer;
   sBody : string;

//  pmc: PPROCESS_MEMORY_COUNTERS;
//  cb: Integer;

begin
{  cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
  GetMem(pmc, cb);
  pmc^.cb := cb;
  if GetProcessMemoryInfo(GetCurrentProcess(), pmc, cb) then
    Caption := 'PDFGen ' + IntToStr(pmc^.WorkingSetSize) + ' Bytes'
  else
    Caption := 'PDFGen ' + 'Unable to retrieve memory usage structure';

  FreeMem(pmc);
}

  //Caption := 'PDFGen Memory Lost '+ IntToStr((ProcessMemoryUsage(ProcessID) - MemUsageStart) div 1024) +' kbytes Loaded. Instance #'+IntToStr(InstanceCount);
//  MemUsageNow := ProcessMemoryUsage(ProcessID) div 1024;
//  Caption := 'PDFGen Memory Usage ('+ IntToStr(MemUsageStart div 1024) + ' / ' + IntToStr(MemUsageNow) + ') kbytes. Instance #'+IntToStr(InstanceCount);
  Application.ProcessMessages;
  Inc(InstanceCount);
/////////////////
  MemUsageNow := 0;
/////////////////
  if MemUsageNow > StrToInt(sMemSize) then
  begin
     //Launch the second app and close the current application
     winexec(pchar(application.ExeName+' AUTO'),sw_shownormal);
     sBody := 'PDFGen Application has been restarted as it was running low on memory. '  + #10#13;
     sBody := sBody + 'Computer: ' + GetComputerNetName + ' User currently logged in : ' + GetUserFromWindows;
     sBody := sBody + 'Application started on ' + DateTimeToStr(AppStartDateTime) + ' Terminated on ' + DateTimeToStr(Now);
     sBody := sBody + ' Instance count = '+ IntToStr(InstanceCount);

     Notify(sBody,strCC,'','apb@nationalresearch.com','APB Memory alert','');
     //Wait for a 30 secs to make sure the email has been sent.
     Sleep(30000);
     Application.Terminate;
  end;

end;

(*
function Tmainform.CheckMem : Boolean;
var
   MemoryStatus: TMemoryStatus;
   sBody : string;
begin
  //Memo1.Lines.Clear;
  MemoryStatus.dwLength := SizeOf(MemoryStatus) ;
  GlobalMemoryStatus(MemoryStatus) ;
  Caption := 'PDFGen ' + IntToStr(MemoryStatus.dwMemoryLoad) + '% memory in use';

  //GN06:MilliSecondsToWait is an arbitrary way to check the prev PDFGen instance is freed from the memory
  if  (MemoryStatus.dwMemoryLoad > StrToInt(sMemSize)) and (GetTickCount > StartTime+MilliSecondsToWait) then
  begin
     //Launch the second app and close the current application
     winexec(pchar(application.ExeName+' AUTO'),sw_shownormal);
     sBody := 'PDFGen Application is running low on memory on Computer: ' + GetComputerNetName + ' User currently logged in : ' + GetUserFromWindows;
     Notify(sBody,strCC,'','apb@nationalresearch.com','APB Memory alert','');
     //Wait for a 30 secs to make sure the email has been sent.
     Sleep(30000);
     application.Terminate;
  end;

  {
  with MemoryStatus do begin
    Memo1.Lines.Add(IntToStr(dwLength) +
      ' Size of ''MemoryStatus'' record') ;
    Memo1.Lines.Add(IntToStr(dwMemoryLoad) +
      '% memory in use') ;
    Memo1.Lines.Add(IntToStr(dwTotalPhys) +
      ' Total Physical Memory in bytes') ;
    Memo1.Lines.Add(IntToStr(dwAvailPhys) +
      ' Available Physical Memory in bytes') ;
    Memo1.Lines.Add(IntToStr(dwTotalPageFile) +
      ' Total Bytes of Paging File') ;
    Memo1.Lines.Add(IntToStr(dwAvailPageFile) +
      ' Available bytes in paging file') ;
    Memo1.Lines.Add(IntToStr(dwTotalVirtual) +
      ' User Bytes of Address space') ;
    Memo1.Lines.Add(IntToStr(dwAvailVirtual) +
      ' Available User bytes of address space') ;
   end;
   }
end;
*)

procedure Tmainform.StartClick(Sender: TObject);
var
   ThreadId:LongInt;
   arial:variant;
   arialbold:variant;
begin
  CheckMem;
  if cbGenSpecific.Checked and (length(trim(mAPs.text)) = 0) then
  begin
     ShowMessage('You must either Uncheck '#13#10'"Generate PDFs for these Action Plans only" box'#13#10+
                 'or enter Ation Plan ID(s) to generate.');
     exit;
  end;
  try
    if ThreadHandle > 0 then
      try
         CloseHandle(ThreadHandle);
         ipdf := UnAssigned;
      finally
      end;
    pnlThis.Visible := false;
    pnlAll.Visible := false;
    ipdf := CreateOleObject('iSED.QuickPDF');
    Arial := ipdf.AddTrueTypeFont('', 0);
    ArialBold := ipdf.AddTrueTypeFont('', 0);
    //NRCArrows := ipdf.AddTrueTypeFontFromFile(ArrowsPath+'Arrows.ttf');
    ipdf.SetTextSize(fs);
    ipdf.DrawText (10, 10, 'dummy');

    begin
      comp_detail        := 'APO_CompDetail';
      vbar_final         := 'APO_VBarFinal';
      quad_final         := 'APO_QuadFinal';
      Quad_quest         := 'APO_QuadQuest';
      Quad_Theme         := 'APO_QuadTheme';
      hbar_stats_final   := 'APO_HBarStatsFinal';
      hbar_labels_final  := 'APO_HBarLabelsFinal';
      cntl_final         := 'APO_CntlFinal';
      Global_Run_Table   := 'APO_GlobalRunTable';
      Job_list           := 'tbl_APJobList';
      actionplan         := 'APO_actionplan';
    end;
   ThreadId := -1;
   // Start the first thread, You can have more than one thread -
   // each thread is another, independent variation on the main line of code execution.
   ThreadHandle := BeginThread(nil,
                  0,
                  @StartThread,
                  nil,
                  0,
                  ThreadId);
  except
    // Finally, tidy up by closing the threads
    if ThreadHandle > 0 then
      try
         CloseHandle(ThreadHandle);
      finally
      end;
    //winexec(pchar(application.ExeName+' AUTO'),sw_shownormal);
    //application.Terminate;
  end;

end;


procedure Tmainform.eIntervalKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in['0'..'9',#8,#13]) then
   key:=#0;
end;

procedure Tmainform.eIntervalExit(Sender: TObject);
begin
  if length(trim(eInterval.text))=0 then
    eInterval.text:=inttostr(UpDown1.position);
end;



procedure Tmainform.eIntervalClick(Sender: TObject);
begin
  eInterval.SelectAll;
end;

procedure Tmainform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Start.enabled then Action:=caNone;

end;

procedure Tmainform.FormCreate(Sender: TObject);
begin
  //GN06
  StartTime := GetTickCount;
  AppStartDateTime := Now;
  Application.OnException    := HandleException;
  ProcessID := GetCurrentProcessID;
 // MemUsageStart := ProcessMemoryUsage(ProcessID);

  GetServers;
  AppPath:=ExtractFilePath(application.ExeName);
  LabelVersion.Caption := 'PDFGen - ' + GetFileVersion(application.ExeName);
  if (paramcount > 0) then
  begin
    LabelVersion.Caption := LabelVersion.Caption  + ' Mode: ' + paramstr(1);
    //GN01: In debug mode, do not notify the user and execute the report for the selected JobID's
    if (uppercase(paramstr(1))='DEBUGMODE') then
    begin
       cbGenSpecific.Checked := mAPs.Lines.Count > 0;
       cbNotify.Checked := False;
    end
    else
    begin if (uppercase(paramstr(1))='AUTO') then
        mAPs.Lines.Clear ;
        cbGenSpecific.Checked := False;
        cbNotify.Checked := True;
        StartClick(self);
    end;
  end
  else if sAutoStart = 'Y' then
  begin
     cbNotify.Checked := True;  
     cbGenSpecific.Checked := False;
     mAPs.Lines.Clear ;
     StartClick(self);
  end;
end;

//GN06
procedure Tmainform.HandleException(Sender: TObject; E: Exception);
var
   sBody : string;
begin
   if (E is EOleException) or (E is EOleError) then
   begin
     //Launch the second app and close the current application
     winexec(pchar(application.ExeName+' AUTO'),sw_shownormal);
     sBody := 'PDFGen Unhandled exception ' + E.Message + '  Computer: ' + GetComputerNetName + ' User currently logged in : ' + GetUserFromWindows; 
     Notify(sBody,strCC,'','apb@nationalresearch.com','APB Memory alert','');
     //Wait for a 30 secs to make sure the email has been sent.
     Sleep(30000);
     application.Terminate;
   end;

end;



procedure SetServerInfo(i:integer);
var
   ini:TIniFile;
begin
  bool3D:=True;

  ini:=TIniFile.Create(ExtractFileDir(application.ExeName)+'\pdfgen.ini');
  try
     ini.WriteInteger('SELECTED SERVER','Server',i);
     Database:=ini.ReadString('DATABASE',inttostr(i),'QP_Comments');

     server:=ini.ReadString('SERVER',inttostr(i),'C:');

     HtmlPathRoot:=ini.ReadString('HTML PATH ROOT',inttostr(i),'C:');
     ClientLogoPath := ini.ReadString('CLIETN LOGO PATH ROOT',inttostr(i),'C:');
     NRCLogoPath := ini.ReadString('NRC LOGO PATH',inttostr(i),'C:');
     ArrowsPath  := ini.ReadString('ARROWS PATH',inttostr(i),'C:');


     URLRoot:=ini.ReadString('URLROOT',inttostr(i),'');
     User0:=ini.ReadString('USER',inttostr(i),'sa');
     User1:=ini.ReadString('USER',inttostr(i+10),'sa');
  finally
     ini.free;
  end;
end;

procedure Tmainform.GetServers;
var
   ini:TIniFile;
   i:integer;
begin
  ini:=TIniFile.Create(ExtractFileDir(application.ExeName)+'\pdfgen.ini');

  try
     rgServers.Items.Clear;

     ini.ReadSectionValues('SERVER',rgServers.items);
     for i:=0 to rgServers.items.Count-1 do
     begin
       rgServers.items.Strings[i] := rgServers.items.Values[inttostr(i)];
       rgServers.items.Strings[i] := rgServers.items.Strings[i]+' ('+ini.ReadString('SERVER TYPE',inttostr(i),'-')+')';
     end;
     sMemSize := UpperCase(ini.ReadString('APP','MemSize','80'));
     sAutoStart := UpperCase(ini.ReadString('APP','AUTO_START','Y'));

     strCC:=ini.ReadString('EMAIL','CC','');
     sMailServer := ini.ReadString('EMAIL','Server','NRC50');
     sMailServerType := UpperCase(ini.ReadString('EMAIL','Type','Remote'));

     rgServers.ItemIndex:=ini.ReadInteger('SELECTED SERVER','Server',0);
  finally
     ini.free;
  end;
  SetServerInfo(rgServers.ItemIndex);
end;

procedure Tmainform.rgServersClick(Sender: TObject);
begin
  SetServerInfo(rgServers.ItemIndex);
end;

procedure Tmainform.mAPsChange(Sender: TObject);
begin
  cbGenSpecific.Checked := mAPs.Text <> '';
end;

procedure Tmainform.PageControl1Change(Sender: TObject);
begin
  GetServers;
end;


end.
