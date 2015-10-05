unit DOpenQ;

{ --this will be defined in the project options from now on.  CJB 1/17/2014 $D E F I N E FormLayout }


{*******************************************************************************
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
11-01-2005  GN01   Commented the display warnings, need to find a better solution
                   as to when these messages needs to be displayed.

11-09-2005  GN02   Didn't make sense displaying the change in bitMeanable to the end-user

11-22-2005  GN03   Setting the database connection properties runtime instead of design time.
                   This was done to eliminate the deadlock issue running QuestionLib, FormLayout & DashBoard

12-12-2005  GN04   To do: Add Survey Auditing

12-20-2005  GN05   Scales dropping from the template when a translation exist.
                   Due to this problem when you do a print preview, an error
                   message would pop-up "Cannot find scale".
                   An alternative solution to this issue is to validate the layout
                   and save the template under a different name.

02-01-2006  GN06   Make sure this Temp directory exists

02-13-2006  GN07   Removed the limit for the number of subsections.
                   This fixed the problem faced by Ada Hui when her template
                   had 1 Section with 27 subsections, when you cut & paste
                   subsections the program didn't resequence the susbsections correctly

08-16-2006  GN08   Nobody cares about this info, and it was causing problems in the staging/testing
                   environment 'coz it didnt have access to Q:\Production\Template Load Report\*.txt


10-09-2006  GN09   Check to see if the translation text is not empty

12-06-2006  GN10   Language Parameterization

12-07-2006  GN11   Handentry mapping

12-20-2006  GN12   FormLayout version updates

02-25-2007  GN13   Check for missing translation in the cover letter
                   Fix for the No record found message when loading templates with different header
********************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Wwquery, DB, Wwtable, DBRichEdit, Wwdatsrc, stdctrls, Clipbrd, comctrls,
  mxarrays,comobj, FileUtil,ShellAPI, FileCtrl
{$IFDEF FormLayout}
  , tMapping
{$ENDIF}
  ;

const
  {Scale Placement}
  spRight = 1;
  spBelow = 2;
  spBelow2 = 3;
  spBelow3 = 4;
  {Section Type: The sel_qstns.subtype field can contain the following values:}
  stItem = 1; {aka question - see sel_qstns.qstncore for id}
  stSubSection = 2;
  stSection = 3;
  stComment = 4;
  stFOUO = 5; {not used}
  stAddress = 6;
    {The Section, Subsection, and Item fields have the following relationship with subtype field
    Section	Subsection	Item		Subtype
    x		0		0		3		(section x)
    x		y		0		2		(subsection y of section x)
    x		y		z		1 or 4		(item z of subsection y of section x)
    -1		1		0		6		(address information)
    -1		2		0		5		(For Office Use Only area information)}



  {Scale Type}
  stBubble = 1;
  stICR = 2;
  stCmntLine = 3;
  {Skip Types}
  skNone = 0;
  skQuestion = 1;
  skSubsection = 2;
  skSection = 3;

type
  TDQTableType = (F,Q,S,V,C,L,T,P,K);
  {(Full,Question,Scale,surVey,Cover,Logo,Textbox,Pcl,sKip info)}
  TDMOpenQ = class(TDataModule)
    wwDS_Qstns: TwwDataSource;
    wwT_Qstns: TwwTable;
    ww_Query: TwwQuery;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    wwDS_Scls: TwwDataSource;
    wwT_Scls: TwwTable;
    tmptbl: TwwTable;
    BatchMove: TBatchMove;
    wwDS_Logo: TwwDataSource;
    wwT_Logo: TwwTable;
    wwDS_TextBox: TwwDataSource;
    wwT_TextBox: TwwTable;
    wwDS_PCL: TwwDataSource;
    wwT_PCL: TwwTable;
    wwDS_TableDef: TwwDataSource;
    wwT_TableDef: TwwTable;
    wwDS_Cover: TwwDataSource;
    wwT_Cover: TwwTable;
    wwT_LogoX: TIntegerField;
    wwT_LogoY: TIntegerField;
    wwT_LogoScaling: TIntegerField;
    wwT_LogoID: TIntegerField;
    wwT_LogoType: TStringField;
    wwT_LogoCoverID: TIntegerField;
    wwT_LogoDescription: TStringField;
    wwT_LogoWidth: TIntegerField;
    wwT_LogoHeight: TIntegerField;
    wwT_LogoVisible: TBooleanField;
    wwT_PCLID: TIntegerField;
    wwT_PCLType: TStringField;
    wwT_PCLCoverID: TIntegerField;
    wwT_PCLDescription: TStringField;
    wwT_PCLLanguage: TIntegerField;
    wwT_PCLX: TIntegerField;
    wwT_PCLY: TIntegerField;
    wwT_PCLWidth: TIntegerField;
    wwT_PCLHeight: TIntegerField;
    wwT_PCLPCLStream: TBlobField;
    wwT_PCLKnownDimensions: TBooleanField;
    wwT_TextBoxID: TIntegerField;
    wwT_TextBoxType: TStringField;
    wwT_TextBoxCoverID: TIntegerField;
    wwT_TextBoxLanguage: TIntegerField;
    wwT_TextBoxX: TIntegerField;
    wwT_TextBoxY: TIntegerField;
    wwT_TextBoxWidth: TIntegerField;
    wwT_TextBoxHeight: TIntegerField;
    wwT_TextBoxRichText: TBlobField;
    wwT_TextBoxBorder: TIntegerField;
    wwT_TextBoxShading: TIntegerField;
    wwT_LogoSurvey_ID: TIntegerField;
    wwT_TextBoxSurvey_ID: TIntegerField;
    wwT_PCLSurvey_ID: TIntegerField;
    wwT_TextBoxBitLangReview: TBooleanField;
    wwDS_TransTB: TwwDataSource;
    wwt_TransTB: TwwTable;
    wwt_TransTBID: TIntegerField;
    wwt_TransTBType: TStringField;
    wwt_TransTBCoverID: TIntegerField;
    wwt_TransTBLanguage: TIntegerField;
    wwt_TransTBX: TIntegerField;
    wwt_TransTBY: TIntegerField;
    wwt_TransTBWidth: TIntegerField;
    wwt_TransTBHeight: TIntegerField;
    wwt_TransTBRichText: TBlobField;
    wwt_TransTBBorder: TIntegerField;
    wwt_TransTBShading: TIntegerField;
    wwt_TransTBSurvey_id: TIntegerField;
    wwt_TransTBBitLangReview: TBooleanField;
    wwDS_TransQ: TwwDataSource;
    wwT_TransQ: TwwTable;
    wwt_TransQPlusMinus: TStringField;
    wwt_TransQLabel: TStringField;
    wwt_TransQScaleID: TIntegerField;
    wwt_TransQType: TStringField;
    wwt_TransQSection: TIntegerField;
    wwt_TransQSubsection: TIntegerField;
    wwt_TransQItem: TIntegerField;
    wwt_TransQLanguage: TIntegerField;
    wwt_TransQWidth: TIntegerField;
    wwt_TransQRichText: TBlobField;
    wwt_TransQQstnCore: TIntegerField;
    wwt_TransQScalePos: TIntegerField;
    wwt_TransQSubtype: TIntegerField;
    wwt_TransQHeight: TIntegerField;
    wwt_TransQSurvey_ID: TIntegerField;
    wwt_TransQSelQstns_ID: TIntegerField;
    wwt_TransQnumMarkCount: TIntegerField;
    wwt_TransQbitLangReview: TBooleanField;
    wwDS_TransS: TwwDataSource;
    wwT_TransS: TwwTable;
    wwt_TransSSurvey_id: TIntegerField;
    wwt_TransSID: TIntegerField;
    wwt_TransSType: TStringField;
    wwt_TransSItem: TIntegerField;
    wwt_TransSLabel: TStringField;
    wwt_TransSCharSet: TIntegerField;
    wwt_TransSVal: TIntegerField;
    wwt_TransSLanguage: TIntegerField;
    wwt_TransSRichText: TBlobField;
    wwt_TransSScaleOrder: TIntegerField;
    wwt_TransSMissing: TBooleanField;
    wwT_QstnsSurvey_ID: TIntegerField;
    wwT_QstnsID: TIntegerField;
    wwT_QstnsLanguage: TIntegerField;
    wwT_QstnsSection: TIntegerField;
    wwT_QstnsType: TStringField;
    wwT_QstnsLabel: TStringField;
    wwT_QstnsPlusMinus: TStringField;
    wwT_QstnsSubsection: TIntegerField;
    wwT_QstnsItem: TIntegerField;
    wwT_QstnsSubtype: TIntegerField;
    wwT_QstnsScaleID: TIntegerField;
    wwT_QstnsWidth: TIntegerField;
    wwT_QstnsHeight: TIntegerField;
    wwT_QstnsRichText: TBlobField;
    wwT_QstnsQstnCore: TIntegerField;
    wwT_QstnsScalePos: TIntegerField;
    wwT_QstnsbitLangReview: TBooleanField;
    wwT_QstnsnumMarkCount: TIntegerField;
    wwT_SclsSurvey_ID: TIntegerField;
    wwT_SclsID: TIntegerField;
    wwT_SclsItem: TIntegerField;
    wwT_SclsLanguage: TIntegerField;
    wwT_SclsType: TStringField;
    wwT_SclsLabel: TStringField;
    wwT_SclsCharSet: TIntegerField;
    wwT_SclsVal: TIntegerField;
    wwT_SclsRichText: TBlobField;
    wwT_SclsScaleOrder: TIntegerField;
    wwT_SclsMissing: TBooleanField;
    t_Language: TTable;
    wwDS_TransP: TwwDataSource;
    wwT_TransP: TwwTable;
    wwT_QstnsSubSectNum: TStringField;
    wwDS_Skip: TwwDataSource;
    wwT_Skip: TwwTable;
    wwT_SkipSurvey_ID: TIntegerField;
    wwT_SkipSelQstns_ID: TIntegerField;
    wwT_SkipSelScls_ID: TIntegerField;
    wwT_SkipScaleItem: TIntegerField;
    wwT_SkipType: TStringField;
    wwT_SkipnumSkip: TIntegerField;
    wwT_SkipnumSkipType: TIntegerField;
    dbQualPro: TDatabase;
    wwT_QstnsbitMeanable: TBooleanField;
    wwT_QstnsnumBubbleCount: TIntegerField;
    wwT_TransQbitMeanable: TBooleanField;
    wwT_TransQnumBubbleCount: TIntegerField;
    wwT_SclsIntRespType: TIntegerField;
    wwT_TransSintRespType: TIntegerField;
    wwT_LogoBitmap: TGraphicField;
    BatchMove_SelLogo: TBatchMove;
    t_Logo_SQL: TTable;
    wwT_LogoPCLStream: TBlobField;
    dbPriv: TDatabase;
    t_PCLObject: TTable;
    t_PCLObjectPCLObject_dsc: TStringField;
    t_PCLObjectPCLStream: TBlobField;
    wwT_QstnsScaleFlipped: TIntegerField;
    wwT_QstnsSampleUnit_id: TIntegerField;
    wwT_TransQScaleFlipped: TIntegerField;
    wwT_TransQSampleUnit_id: TIntegerField;
    t_PCLObjectPCLOBJECT_ID: TIntegerField;
    wwt_PopSection: TwwTable;
    wwt_PopCover: TwwTable;
    wwt_PopCode: TwwTable;
    dbScan: TDatabase;
    dbQueue: TDatabase;
    wwT_QstnsstrScalePos: TStringField;
    wwT_QstnsSkipFrom: TStringField;
    wwDS_ProblemScores: TwwDataSource;
    wwT_ProblemScores: TwwTable;
    dbDataMart: TDatabase;
    wwT_QstnsProblemScore: TStringField;
    wwT_ProblemScoresCore: TIntegerField;
    wwT_ProblemScoresVal: TIntegerField;
    wwT_ProblemScoresProblem_Score_Flag: TIntegerField;
    wwT_ProblemScoresstrProblemScore: TStringField;
    wwT_ProblemScoresShort: TStringField;
    wwT_ProblemScoresTransferred: TIntegerField;
    sp_QPProd: TStoredProc;
    wwt_TransTBLabel: TStringField;
    wwT_TextBoxLabel: TStringField;
    procedure tabledef(var tbl:twwtable; TblType: TDQTableType; WithIndex:boolean);
    procedure DMOpenQCreate(Sender: TObject);
    procedure wwT_QstnsFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure wwT_QstnsAfterOpen(DataSet: TDataSet);
    procedure wwT_QstnsBeforeClose(DataSet: TDataSet);
    procedure wwT_SclsAfterOpen(DataSet: TDataSet);
    procedure wwT_SclsBeforeClose(DataSet: TDataSet);
    procedure wwT_TextBoxAfterOpen(DataSet: TDataSet);
    procedure wwT_TextBoxBeforeClose(DataSet: TDataSet);
    procedure EnglishFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure LanguageFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure AfterPost(DataSet: TDataSet);
    procedure wwT_QstnsRichTextChange(Sender: TField);
    procedure wwT_TextBoxRichTextChange(Sender: TField);
    procedure wwT_TextBoxBeforeDelete(DataSet: TDataSet);
    procedure wwT_PCLBeforeDelete(DataSet: TDataSet);
    procedure wwT_SclsBeforeDelete(DataSet: TDataSet);
    procedure wwT_QstnsBeforeDelete(DataSet: TDataSet);
    procedure wwT_PCLAfterOpen(DataSet: TDataSet);
    procedure wwT_PCLAfterClose(DataSet: TDataSet);
    procedure wwT_QstnsSubSectNumGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DMOpenQDestroy(Sender: TObject);
    procedure FoxProPRG(fn:string);
    function SubOrInsertPoundSignForQuestionForSurveyType(var formatOverride : string; var skipRepeatsScaleText : boolean): boolean;
{$IFDEF FormLayout}
    function MappedSections:boolean;
    function MappedSampleUnitsByCL(coverLetter : string) : string;
    function MappedTextBoxesByCL(coverLetter : string) : MappingSet;
    procedure CodeReport(const fn:string);
    function FindNextUntranslated:char;
    function QuestionProperties:boolean;
    function SubsectionProperties:boolean;
    function SectionProperties:boolean;
    procedure QstnMoveUp;
    procedure QstnMoveDown;
    procedure ExpandCollapse;
    procedure DeleteThis;
    function CutQuestions:integer;
    procedure UnCutQuestions;
    function PasteQuestions:integer;
    procedure AddSection;
    procedure AddSubSection(const SSName:string;AutoCreate:boolean);
    procedure AddComment;
    procedure EditComment(const LinesVisible:boolean; const cptn:string);
    procedure EditFOUO;
    procedure AddScale(newScaleID:integer);
    function AddQstn:boolean;
    procedure CheckQstnFieldedFlags;
    procedure CheckAgainstLibrary;
    procedure CheckItemNumbering;
    procedure OpenSurvey(template:string);
    procedure CloseSurvey;
    procedure NewSurvey;
    procedure AssignCmntBoxNums;
    procedure SaveSurvey;
    procedure SaveSurveyAs;
    procedure OpenAllTables;
    procedure GetSQLSurveyName;
    procedure OpenAllSQLTables(const SID:integer);
    procedure GetProblemScores;
    procedure GetAProblemScore(const qstncore:integer);
    procedure LoadFromSQL(const SID:integer;const showstatus:boolean);
    function SaveSQLSurvey(const NowValid,Closing:boolean):boolean;
{$ENDIF}
    procedure CreateProblemScoreTable;
    procedure tmptblAfterClose(DataSet: TDataSet);
    procedure wwT_QstnsstrScalePosGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure wwT_QstnsSkipFromGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure wwT_QstnsProblemScoreGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    { Private declarations }
    aBblLoc : array[1..30,1..9] of integer;
    aCmntLoc : array[1..6,1..7] of integer;
    aHWLoc : array[1..30,1..8] of integer;
    nBblLoc,nCmntLoc,nHWLoc : integer;
{$IFDEF FormLayout}
    OpenFileName,SaveFileName:string;
    procedure OpenQuery(const DQType:TDQTableType; var IntoTable:twwTable);
    procedure OpenQstns;
    procedure OpenScales;
    procedure OpenLogos;
    procedure OpenTextBox;
    procedure OpenPCL;
    procedure OpenCover;
    procedure OpenSkip;
    procedure OpenSQLQuery(const DQType:TDQTableType; var IntoTable:twwTable; Const SID:integer);
    procedure OpenSQLQstns(const SID:integer);
    procedure OpenSQLScales(const SID:integer);
    procedure OpenSQLLogos(const SID:integer);
    procedure OpenSQLTextBox(const SID:integer);
    procedure GetPCLDimensions;
    procedure OpenSQLPCL(const SID:integer);
    procedure OpenSQLCover(const SID:integer);
    procedure OpenSQLSkip(const SID:integer);
    procedure DeleteSQLSurvey;
    function ValidateCodes:boolean;
    function ValidateSkips:boolean;
    function LabelOrID(id : TIntegerField; name : TStringField) : string;
    function ValidateTranslation:boolean;
    procedure wwt_QstnsUpdateLangInfo;
    function getItemsinSubsection:integer;
    function GetPlainText(richTxt : TBlobField) : string;
{$ENDIF}
    procedure ProtectChange(Sender: TObject; StartPos,EndPos: Integer;
                            var AllowChange: Boolean);
    procedure UpdateOtherLanguageComment;
  public
    { Public declarations }
    OpenDateTime:tDateTime;
    ShowOpenStatus : boolean;
    UnMapAllSections : boolean;
    DeletedAddedSections : boolean;
    cn:variant;
    sqlcn:variant;
    glbStudyID : integer;
    glbSurveyID : integer;
    glbClientID : integer;
    Validated : boolean;
    tempdir : string;
    CurrentLanguage : integer;
//    SkipGoPhrase, SkipEndPhrase : string;
    FindTransUponCreate : boolean;
    errorlist:tstringlist;
    QstnFont : string;
    QstnPoint : integer;
    SclFont : string;
    SclPoint : integer;
    ResponseShape : byte;
    ShadingOn : boolean;
    GenError : integer;
    ConsiderDblLegal : boolean;
    LapTop : boolean;
    EnvName:string;
    FormLayoutVer : string;
    createok:boolean;
    currentSampleUnit_id : integer;
    TwoColumns : boolean;
    ExtraSpace : integer;
    SpreadToFillPages : boolean;
    InsertSkipArrowDoD : boolean;
    ClipboardQuestions : boolean;
    function SurveyDB(const fn:string):boolean;
    function GetUserParam(const prm:string):string;
    procedure AnalyzePCLString(s:string; var w,h:integer; var KD:boolean);
    function AnalyzePCL(const fn:string; var w,h:integer;var KD:boolean):string;
    procedure wwt_QstnsEnableControls;
    procedure QPQuery(const Qry:string; const Exe:boolean);
    {$IFNDEF FormLayout}
    procedure ScanQuery(const Qry:string; const Exe:boolean);
    procedure QueueQuery(const Qry:string; const Exe:boolean);
    {$ENDIF}
    procedure LibQuery(const Qry:string; const Exe:boolean);
    procedure LocalQuery(const Qry:string; const Exe:boolean);
    function personalize(const s,LD,RD:string):string;
    procedure SaveSectionOrder;
    procedure DefaultSectionOrder(const Mock_up:boolean);
    function SQLString(const s:string; const delim:boolean):string;
    procedure DownLoadLogo(const whereclause:string);
    procedure BubbleLocAppend(const vSelQstns_id,vItem,vSampUnit,vCharset,vValue,vRespType,vRelX,vRelY,vScaleID:integer);
    procedure HandwrittenAppend(const vSelQstns_id,vItem,vSampUnit,vline,vRelX,vRelY,vWidth,vScaleID:integer);
    procedure CmntLocAppend(const vSelQstns_id,vLine,vSampUnit,vRelX,vRelY,vWidth,vHeight:integer);
    function BblLocFlush:integer;
    function HWLocFlush:integer;
{$IFDEF FormLayout}
    procedure wwt_QstnsEnableControlsDammit;
    procedure newLangPCL(CoverID,PCLID,LangID:integer;FileName:string);
    function PCLHints:string;
    function ValidateSurvey(const SaveToo:boolean):boolean;
    procedure PrintMockup;
    function VerifySave:boolean;
    function VerifyLoad:boolean;
    function VerifyLoadSave:string;
    function PRNDir : string;
    function PDFDir : string;
    function CheckAuditInfo : Boolean;
    function GetMappingMetaFields : Boolean;
{$ELSE}
    procedure CmntLocFlush;
{$ENDIF}
    procedure ViewData(var ds:tDataset; const s:tStringList; const s2:array of string);
  end;

var
  DMOpenQ: TDMOpenQ;

implementation

uses
{$IFDEF FormLayout}
FDynaQ, REEdit, fQstnProperties, fSectProperties, fMyPrintDlg, dataMod,
fOpenStatus, fInvalid, f_ShowProps,
{$ELSE}
dPCLGen,
{$ENDIF}
common, fViewData;

{$R *.DFM}

procedure TDMOpenQ.ViewData(var ds:tDataset; const s:tStringList; const s2:array of string);
var i : integer;
begin

  frmViewData := TfrmViewData.Create( Self );
  with frmViewData do
  try
    memo1.lines.clear;
    if ((s2[0] <> '') or (high(s2)>0)) then
      for i := 0 to high(s2) do
        memo1.lines.add(s2[i]);
    if s <> nil then
      memo1.lines.addstrings(s);
    datasource1.dataset := ds;
    caption := ds.name;
    showmodal;
  finally
    Release;
  end;
end;

function TDMOpenQ.personalize(const s,LD,RD:string):string;
var Code : integer;
{$IFDEF FormLayout}
  function nospaces(s:string):string;
  begin
    while pos(' ',s)>0 do s[pos(' ',s)] := '0';
    result := s;
  end;
  function lookupcode:string;
  var constant : string;
    function lookupconstant : string;
    begin
      with DQDataModule do begin
        if t_Constants.findkey([Constant]) then begin
          result := t_ConstantsValue.text;
          if vSex='Female' then begin
            while pos('Billy',result)>0 do begin
              insert('Sa',result,pos('Billy',result));
              delete(result,pos('Billy',result),2);
            end;
            while pos('BILLY',result)>0 do begin
              insert('SA',result,pos('BILLY',result));
              delete(result,pos('BILLY',result),2);
            end;
            while pos('Christopher',result)>0 do begin
              insert('ina',result,11+pos('Christopher',result));
              delete(result,6+pos('Christopher',result),5);
            end;
            while pos('CHRISTOPHER',result)>0 do begin
              insert('INA',result,11+pos('CHRISTOPHER',result));
              delete(result,6+pos('CHRISTOPHER',result),5);
            end;
          end;
        end else
          result := #2+'Can''t find tag '''+constant+'''»'
      end;
    end;
  var B,L : integer;
  begin
    with DQDataModule do begin
      if t_CodeText.findkey([Code]) then begin
        result := t_CodeTextText.value;
        while pos('°',result)>0 do delete(result,pos('°',result),1);
        while pos('«',result)>0 do begin
          B := pos('«',result);
          L := 2;
          while (B+L < length(result)) and (result[B+L] <> '»') do inc(L);
          if L = 2 then
            result[B] := #2
          else begin
            constant := copy(result,B+1,L-1);
            delete(result,B,L+1);
            insert(lookupconstant,result,B);
          end;
        end;
      end else
        result := #1+'Can''t find code '+inttostr(code)+'}';
    end;
  end;
{$ELSE}
  function LookupCode:string;
  begin
    LocalQuery('select codetext'+
              ' from localpopcode'+
              ' where SentMail_id='+dmPCLGen.wwt_MyPCLNeeded.fieldbyname('SentMail_id').asstring+
              ' and sampleunit_id='+inttostr(currentSampleUnit_id)+
              ' and Language='+dmPCLGen.wwt_MyPCLNeeded.fieldbyname('language').asstring+
              ' and Code='+inttostr(code),false);
    if ww_Query.eof then begin
      GenError := 35;
      raise Exception.Create( 'FormGenError 35 (Code not found)');
    end else
      result := trimright(ww_query.fieldbyname('codetext').asstring);
  end;
{$ENDIF}
var B,L : integer;
begin
  result := s;

  b:=pos('\protect0', result);
  while b > 0 do
  begin
     delete(result,b,9);
     b:=pos('\protect0', result);
  end;

  b:=pos('\protect', result);
  while b > 0 do
  begin
     delete(result,b,8);
     b:=pos('\protect', result);
  end;


{$IFDEF FormLayout}
  while pos(LD,result) > 0 do begin
    B := pos(LD,result);
    L := 2;
    while (B+L < length(result)) and (copy(result,B+L,length(RD)) <> RD) do inc(L);
    code := strtointdef(copy(result,B+length(LD),L-length(rd)),0);
    if code = 0 then begin
      delete(result,b,length(ld));
      insert('!!'+#1,result,b);
    end else begin
      delete(result,B,L+length(rd));
      insert(lookupcode,result,B);
      if (b>1) and (result[b-1] <> ' ') then
        insert(' ',result,b);
    end;
  end;
  while pos(#1,result)>0 do begin
    insert(ld,result,pos(#1,result));
    delete(result,pos(#1,result),1);
  end;
  while pos(#2,result)>0 do begin
    result[pos(#2,result)] := '«';
  end;
{$ELSE}
  while pos(LD,result) > 0 do begin
    B := pos(LD,result);
    L := 2;
    while (B+L < length(result)) and (copy(result,B+L,length(RD)) <> RD) do inc(L);
    code := strtointdef(copy(result,B+length(LD),L-length(rd)),0);
    if code = 0 then begin
      GenError := 32;
      raise Exception.Create( 'FormGenError 32 (Invalid Code)');
    end else begin
      delete(result,B,L+length(rd));
      insert(lookupcode,result,B);
      if (b>1) and (result[b-1] <> ' ') then
        insert(' ',result,b);
    end;
  end;
{$ENDIF}
end;

procedure TDMOpenQ.FoxProPRG(fn:string);
{$IFDEF FormLayout}
var f : textfile;
    tagg,code,i,p,q : integer;
    s,s2 : string;
    SL : tStringList;
    anyDocs : boolean;
{$ENDIF}
begin
{$IFDEF FormLayout}
  CodeReport(fn);
  errorlist.sorted := false;
  for i := 0 to errorlist.count-1 do begin
    code := strtoint(errorlist[i])-1000;
    if dqdatamodule.t_Codes.findkey([code]) then begin
      if dqdatamodule.t_CodesAge.asBoolean then
        s := '1' else s := '0';
      if dqdatamodule.t_CodesSex.asBoolean then
        s := s + '1' else s := s + '0';
      if dqdatamodule.t_CodesDoctor.asBoolean then
        s := s + '1' else s := s + '0';
      s := s + inttostr(1000+code)+'"'+Base26(code,2) + '"    && ' + dqdatamodule.t_CodesDescription.asString;
      errorlist[i] := s;
    end;
  end;
  errorlist.sort;
  assignfile(f,fn+'.prg');
  rewrite(f);
  for i := 0 to errorlist.count-1 do begin
    writeln(f,'tagg('+inttostr(i+1)+')='+copy(errorlist[i],8,99));
    errorlist[i] := copy(errorlist[i],1,7) + inttostr(i+1001);
  end;
  i := errorlist.count;
  writeln(f,'tagg('+inttostr(i+1)+')="M0"    && Match Code');
  writeln(f,'tagg('+inttostr(i+2)+')="L0"    && Lithocode');
  writeln(f,'tagg('+inttostr(i+3)+')="B1"    && Barcode, page 1');
  writeln(f,'tagg('+inttostr(i+4)+')="B2"    && Barcode, page 2');
  writeln(f,'tagg('+inttostr(i+5)+')="B3"    && Barcode, page 3');
  writeln(f,'tagg('+inttostr(i+6)+')="B4"    && Barcode, page 4');
  writeln(f);
  SL := tStringList.create;
  SL.clear;
  dqdatamodule.t_codeText.filtered := false;
  for i := 0 to errorlist.count-1 do begin
    code := strtoint(copy(errorlist[i],4,4))-1000;
    tagg := strtoint(copy(errorlist[i],8,4))-1000;
    if dqdatamodule.t_CodeText.findkey([code]) then begin
      while (not dqdatamodule.t_codeText.eof) and (dqdatamodule.t_codetextcode.value=code) do begin
        s := copy(errorlist[i],1,11);
        if s[1]='1' then s2 := dqdatamodule.t_CodetextAge.asstring
        else s2 := ' ';
        if s[2]='1' then s2 := s2 + dqdatamodule.t_CodetextSex.asstring
        else s2 := s2 + ' ';
        if s[3]='1' then s2 := s2 + dqdatamodule.t_CodetextDoctor.asstring
        else s2 := s2 + ' ';
        s := s2 + s + dqdatamodule.t_Codetexttext.asstring;
        SL.add(s);
        dqdatamodule.t_codetext.next;
      end;
    end;
  end;
  ErrorList.clear;
  dqdatamodule.t_codeText.filtered := true;
  SL.sort;
  s := 'xxx';
  AnyDocs := false;
  for i := 0 to SL.count-1 do begin
    if s <> copy(SL[i],1,3) then begin
      if s <> 'xxx' then writeln(f,'endif');
      s := copy(SL[i],1,3);
      s2 := 'if ';
      if s[1]='A' then s2 := s2 + 'mrd.Age>=18 and '
      else if s[1]='M' then s2 := s2 + 'mrd.Age<18 and ';
      if s[2]='F' then s2 := s2 + 'mrd.Sex="F" and '
      else if s[2]='M' then s2 := s2 + 'mrd.Sex="M" and ';
      if s[3]='D' then s2 := s2 + 'm.IndivDoc and '
      else if s[3]='G' then s2 := s2 + '(not m.IndivDoc) and ';
      if s2 = 'if ' then s2 := 'if .t.'
      else s2 := copy(s2,1,length(s2)-4);
      writeln(f,s2);
      AnyDocs := AnyDocs or (s[3]='D') or (s[3]='G');
    end;
    s2 := '"' +copy(SL[i],15,length(SL[i]))+'"';
    while pos('«',s2)>0 do begin
      p := pos('«',s2);
      delete(s2,p,1);
      errorlist.add(copy(s2,p,pos('»',s2)-p));
      insert('"+m.',s2,p);
    end;
    while pos('»',s2)>0 do begin
      p := pos('»',s2);
      delete(s2,p,1);
      insert('+"',s2,p);
    end;
    while pos('""+',s2) > 0 do
      delete(s2,pos('""+',s2),3);
    while pos('+""',s2) > 0 do
      delete(s2,pos('+""',s2),3);
    if pos('+"''s"',s2)>0 then begin
      p := pos('+"''s"',s2);
      q := p;
      while (q>1) and (s2[q] <> '.') do dec(q);
      if (q>1) and (copy(s2,q-1,2)='m.') then begin
        mydelete(s2,p,5);
        myinsert(')',s2,p);
        myinsert('psv(',s2,q-1);
      end;
    end;
    writeln(f,'  txxt('+copy(SL[i],12,3)+') = ' + s2);
  end;
  writeln(f,'endif');
  writeln(f);
  errorlist.sort;
  s2 := 'x';
  for i := 0 to errorlist.count-1 do
    if s2<>errorlist[i] then begin
      s2 := errorlist[i];
      if s2 <> '' then writeln(f,'m.'+s2+'=');
    end;
  if AnyDocs then
    writeln(f,'m.IndivDoc=');
  errorlist.clear;
  SL.Free;
  closefile(f);
{$ENDIF}
end;

function TDMOpenQ.SubOrInsertPoundSignForQuestionForSurveyType(var formatOverride : string; var skipRepeatsScaleText : boolean):boolean;
var rs:variant;
begin
  rs := sqlcn.execute( 'exec dbo.UsePoundSignForSkipInstructions @survey_id='+inttostr(glbSurveyID)+ ', @lang_id='+ inttostr(CurrentLanguage));
  result := rs.fields[0].value;
  formatOverride := vartostr(rs.fields[1].value);
  skipRepeatsScaleText := rs.fields[2].value;
//  result := (not rs.eof);
  rs.close;
  rs:=unassigned;
end;

{$IFDEF FormLayout}
procedure tdmopenq.CodeReport(const fn:string);
var f : textfile;
    s : string;
    lastSQ : integer;
  function subtype(const st:integer):string;
  begin
    case st of
      1: result := 'Question  ';
      2: result := 'Subsection';
      3: result := 'Section   ';
      4: result := 'Comment   ';
      5: result := 'FOUO      ';
      6: result := 'Address   ';
      else result := '          ';
    end;
  end;
begin
  localquery('select sq.selqstns_id, sq.subtype, SQ.QstnCore,p.qnmbr, SQ.Label,SQ.Scaleid, ss.val, ss.label as scalelbl, ss.missing, SQ.'+qpc_section+', SQ.Subsection, SQ.Item, ss.scaleorder '+
     'from pclresults p, sel_Qstns SQ right OUTER JOIN Sel_Scls SS ON sq.scaleid=ss.'+qpc_id+' '+
     'where '+qpc_section+'>0 and sq.language=1 and ss.language=1 and p.selQstns_id=sq.selqstns_id '+
     'union '+
     'select selqstns_id, subtype, 0 as qstncore,p.qnmbr, label, 0 as scaleid,0 as val, ''                                                            '' as scalelbl, 0 as missing, '+qpc_section+',subsection,item,1 as scaleorder '+
     'from sel_qstns SQ, pclresults p '+
     'where sq.selQstns_id=p.SelQstns_id and subtype<>1 and '+qpc_section+'>0 '+
     'order by '+qpc_section+',subsection,item,scaleorder',false);
  assignfile(f,fn+'.cds');
  rewrite(f);
  writeln(f,#27,'&l0h0o2a6d1E',#27,'(0N',#27,'(s0t0b0s08.50v16.66h0P');
  writeln(f,'Type       Core  #    Question                                                     Bubble');
  writeln(f,'---------- ----- ---- ------------------------------------------------------------ --------------------------------------');
  lastSQ := -12345;
  with ww_Query do begin
    while not eof do begin
      if lastSQ <> fieldbyname('SelQstns_id').asinteger then begin
        s := subtype(fieldbyname('subtype').asinteger)+' ';
        if fieldbyname('subtype').asinteger=1 then
          s := s + copy(fieldbyname('QstnCore').asstring+'      ',1,6)
        else
          s := s + '      ';
        s := s + copy(fieldbyname('Qnmbr').asstring+'     ',1,5)+
          fieldbyname('Label').asstring;
      end else
        s := '';
      while length(s)<83 do s := s + ' ';
      if fieldbyname('subtype').asinteger=1 then begin
        s := s + fieldbyname('val').asstring + ' ' + fieldbyname('scalelbl').asstring;
        if fieldbyname('missing').asboolean then
          s := s + ' (missing)';
      end;
      writeln(f,s);
      lastSQ := fieldbyname('SelQstns_id').asinteger;
      next;
    end;
    close;
    writeln(f,#12);
    closefile(f);
  end;
end;

procedure TDMOpenQ.QstnMoveDown;
var thisid,thisOne,nextid,nextOne : integer;
    thisSection : integer;
begin
  with wwT_Qstns do begin
    DisableControls;
    thisid := wwt_QstnsId.value;
    if wwt_QstnsItem.value > 0 then begin
      {move Item}
      thisOne := wwt_QstnsItem.value;
      next;
      if (not eof) and (wwt_QstnsItem.value > 0) then begin
        nextid := wwt_QstnsId.value;
        nextOne := wwt_QstnsItem.value;
        indexFieldName := 'Survey_ID;SelQstns_Id';
        if findkey([glbSurveyID,nextid]) then begin
          edit;
          wwt_QstnsItem.value := thisOne;
          post;
          if findkey([glbSurveyID,thisid]) then begin
            edit;
            wwt_QstnsItem.value := nextOne;
            post;
          end;
        end;
      end else begin
        prior;
        messagebeep(0);
      end;
    end else if wwt_QstnsSubsection.value > 0 then begin
      {Move subsection}
      thisOne := wwt_QstnsSubSection.value;
      ThisSection := wwt_QstnsSection.value;
      filtered := false;
      if findkey([thisSection,succ(thisOne),0]) then begin
        nextid := wwt_QstnsId.value;
        nextOne := wwt_QstnsSubSection.value;
        indexFieldName := 'Survey_ID;SelQstns_Id';
        first;
        while not eof do begin
          if wwt_QstnsSection.value = thisSection then begin
            if (wwt_Qstnssubsection.value = thisOne) then begin
              edit;
              wwt_Qstnssubsection.value := nextOne;
              post;
            end else if (wwt_Qstnssubsection.value = nextOne) then begin
              edit;
              wwt_Qstnssubsection.value := thisOne;
              post;
            end;
          end;
          next;
        end;
        findkey([glbSurveyID,thisid]);
      end else begin
        indexFieldName := 'Survey_id;SelQstns_Id';
        findkey([glbSurveyID,thisid]);
        messagebeep(0);
      end;
    end else begin
      {Move Section}
      thisOne := wwt_QstnsSection.value;
      filtered := false;
      if (findkey([succ(thisOne),0,0])) then begin
        nextid := wwt_QstnsId.value;
        nextOne := wwt_QstnsSection.value;
        indexFieldName := 'Survey_ID;SelQstns_Id';
        first;
        while not eof do begin
          if (wwt_Qstnssection.value = thisOne) then begin
            edit;
            wwt_Qstnssection.value := nextOne;
            post;
          end else if (wwt_Qstnssection.value = nextOne) then begin
            edit;
            wwt_Qstnssection.value := thisOne;
            post;
          end;
          next;
        end;
        findkey([glbSurveyID,thisid]);
      end else begin
        indexFieldName := 'Survey_ID;SelQstns_Id';
        findkey([glbSurveyID,thisid]);
        messagebeep(0);
      end;
    end;
    if not filtered then filtered := true;
    if indexFieldName <> 'Survey_ID;SelQstns_Id' then indexFieldName := 'Survey_ID;SelQstns_Id';
    findkey([glbSurveyID,ThisId]);
    indexFieldName := qpc_Section+';SubSection;Item';
    refresh;
    wwt_QstnsEnableControls;
  end;
end;

procedure TDMOpenQ.QstnMoveUp;
var thisid,thisOne,priorid,PriorOne : integer;
    thisSection : integer;
begin
  with wwT_Qstns do begin
    DisableControls;
    thisid := wwt_QstnsId.value;
    if wwt_QstnsItem.value > 0 then begin
      {move Item}
      thisOne := wwt_QstnsItem.value;
      prior;
      if wwt_QstnsItem.value > 0 then begin
        priorid := wwt_QstnsId.value;
        priorOne := wwt_QstnsItem.value;
        indexFieldName := 'Survey_ID;SelQstns_Id';
        if findkey([glbSurveyID,Priorid]) then begin
          edit;
          wwt_QstnsItem.value := thisOne;
          post;
          if findkey([glbSurveyID,thisid]) then begin
            edit;
            wwt_QstnsItem.value := PriorOne;
            post;
          end;
        end;
      end else begin
        next;
        messagebeep(0);
      end;
    end else if wwt_QstnsSubsection.value > 0 then begin
      {Move subsection}
      thisOne := wwt_QstnsSubSection.value;
      ThisSection := wwt_QstnsSection.value;
      filtered := false;
      if (thisOne > 1) and (findkey([thisSection,pred(thisOne),0])) then begin
        priorid := wwt_QstnsId.value;
        priorOne := wwt_QstnsSubSection.value;
        indexFieldName := 'Survey_ID;SelQstns_Id';
        first;
        while not eof do begin
          if wwt_QstnsSection.value = thisSection then begin
            if (wwt_Qstnssubsection.value = thisOne) then begin
              edit;
              wwt_Qstnssubsection.value := priorOne;
              post;
            end else if (wwt_Qstnssubsection.value = priorOne) then begin
              edit;
              wwt_Qstnssubsection.value := thisOne;
              post;
            end;
          end;
          next;
        end;
        findkey([glbSurveyID,thisid]);
      end else begin
        indexFieldName := 'Survey_ID;SelQstns_Id';
        findkey([glbSurveyID,thisid]);
        messagebeep(0);
      end;
    end else begin
      {Move Section}
      thisOne := wwt_QstnsSection.value;
      filtered := false;
      if (thisOne > 1) and (findkey([pred(thisOne),0,0])) then begin
        priorid := wwt_QstnsId.value;
        priorOne := wwt_QstnsSection.value;
        indexFieldName := 'Survey_id;SelQstns_Id';
        first;
        while not eof do begin
          if (wwt_Qstnssection.value = thisOne) then begin
            edit;
            wwt_Qstnssection.value := priorOne;
            post;
          end else if (wwt_Qstnssection.value = priorOne) then begin
            edit;
            wwt_Qstnssection.value := thisOne;
            post;
          end;
          next;
        end;
        findkey([glbSurveyID,thisid]);
      end else begin
        indexFieldName := 'Survey_id;SelQstns_Id';
        findkey([glbSurveyID,thisid]);
        messagebeep(0);
      end;
    end;
    if not filtered then filtered := true;
    if indexFieldName <> 'Survey_ID;SelQstns_Id' then indexFieldName := 'Survey_ID;SelQstns_Id';
    findkey([glbSurveyID,ThisId]);
    indexFieldName := qpc_Section+';SubSection;Item';
    refresh;
    wwt_QstnsEnableControls;
  end;
end;

procedure TDMOpenQ.ExpandCollapse;
var section,subsection : integer;
  mybookmark : tbookmark;
  orgfiltered : boolean;
begin
  orgfiltered := wwT_Qstns.filtered;
  section := wwT_Qstnssection.value;
  subsection := wwT_Qstnssubsection.value;
  wwT_Qstns.DisableControls;
  if copy(wwT_Qstnsplusminus.text,length(wwT_Qstnsplusminus.text),1) = '+' then begin
    with wwT_Qstns do begin
      MyBookmark := GetBookMark;
      filtered := false;
      GotoBookMark(MyBookMark);
      edit;
      if subsection = 0 then
        wwT_Qstnsplusminus.text := '-'
      else
        wwT_Qstnsplusminus.text := '  -';
      post;
      next;
      if subsection = 0 then begin
        while (not eof) and (wwT_Qstnssection.value = section) do begin
          edit;
          if wwT_Qstnsitem.value = 0 then
            wwT_Qstnsplusminus.text := '  +'
          else
            wwT_Qstnsplusminus.text := '*';
          post;
          next;
        end;
      end else begin
        while (not eof) and (wwT_Qstnssection.value = section) and (wwT_Qstnssubsection.value=subsection) do begin
          edit;
          wwT_Qstnsplusminus.text := ' ';
          post;
          next;
        end;
      end;
      filtered := orgfiltered;
      GotoBookMark(MyBookMark);
      FreeBookmark(MyBookmark);
    end;
  end else if copy(wwT_Qstnsplusminus.text,length(wwT_Qstnsplusminus.text),1) = '-' then begin
    with wwT_Qstns do begin
      MyBookmark := GetBookMark;
      filtered := false;
      GotoBookMark(MyBookMark);
      edit;
      if subsection = 0 then
        wwT_Qstnsplusminus.text := '+'
      else
        wwT_Qstnsplusminus.text := '  +';
      post;
      next;
      if subsection = 0 then begin
        while (not eof) and (wwT_Qstnssection.value = section) do begin
          edit;
          wwT_Qstnsplusminus.text := '*';
          post;
          next;
        end;
      end else begin
        while (not eof) and (wwT_Qstnssection.value = section) and (wwT_Qstnssubsection.value = subsection) do begin
          edit;
          wwT_Qstnsplusminus.text := '*';
          post;
          next;
        end;
      end;
      filtered := orgfiltered;
      GotoBookMark(MyBookMark);
      FreeBookmark(MyBookmark);
    end;
  end;
  wwT_QstnsEnableControls;
end;

function TDMOpenQ.MappedSections:boolean;
var rs:variant;
begin
  result:=false;
  rs := sqlcn.execute('select top 1 selqstnssection from sampleunitsection where selqstnssurvey_id='+inttostr(glbSurveyID));
  result := (not rs.eof);
  rs.close;
  rs:=unassigned;
end;

function TDMOpenQ.MappedSampleUnitsByCL(coverLetter : string) : string;
begin
  result := '';

  if not laptop then
    {with ww_Query do }begin
      {ww_Query.close;}
      ww_Query.databasename := '_QualPro';
      ww_Query.sql.clear;
      ww_Query.sql.add('select SampleUnit_ID, STRSampleUnit_NM from SampleUnit where sampleunit_id in'+
              ' (select SampleUnit_id from CoverLetterItemArtifactUnitMapping where survey_id = ' + inttostr(glbSurveyID) );
      if coverLetter <> '' then
         ww_Query.sql.add(' and (CoverLetter_dsc = ''' + coverLetter + ''')' );
      ww_Query.sql.add(')');
      ww_Query.sql.add(' order by STRSampleUnit_NM');
      ww_Query.open;
      while not ww_Query.eof do begin
         result := result + trimright(ww_Query.fieldbyname('SampleUnit_id').AsString) + '=';
         result := result + trimright(ww_Query.fieldbyname('STRSampleUnit_NM').AsString) + ';';
         ww_Query.next;
      end;
      ww_Query.close;
    end;
end ;

function TDMOpenQ.MappedTextBoxesByCL(coverLetter : string) : MappingSet;
var
  bMapping : BasicMapping;
  i : integer;
begin
  fillchar(result, sizeof(result), #0);
  i := 0;

  if not laptop then
    {with ww_Query do }begin
      {ww_Query.close;}
      ww_Query.databasename := '_QualPro';
      ww_Query.sql.clear;
      ww_Query.sql.add('select SampleUnit_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label'+
              ' from CoverLetterItemArtifactUnitMapping' +
              ' where CoverLetterItemType_id = 1 and survey_id = ' + inttostr(glbSurveyID));
      if coverLetter <> '' then
         ww_Query.sql.add(' and ((CoverLetter_dsc = ''' + coverLetter + ''')' +
                 ' or (Artifact_dsc = ''' + coverLetter + '''))');
      ww_Query.sql.add(' order by CoverLetter_dsc, CoverLetterItem_label');
      ww_Query.open;
      while not ww_Query.eof do begin
        bMapping := AssignBasicMapping(ww_Query.fieldbyname('SampleUnit_id').AsInteger,
          trimright(ww_Query.fieldbyname('CoverLetter_dsc').AsString),
          trimright(ww_Query.fieldbyname('CoverLetterItem_label').AsString),
          trimright(ww_Query.fieldbyname('Artifact_dsc').AsString),
          trimright(ww_Query.fieldbyname('ArtifactItem_label').AsString));

        result[i] := bMapping;
        inc(i);
        ww_Query.next;
      end;
      ww_Query.close;
    end;
end ;

procedure TDMOpenQ.DeleteThis;
var
   this_section,this_subsection,this_item,this_id,i : integer;

  function FieldList(tablename,fieldname:string):string;
  var i,c  : integer;
      rs,flds: variant;
  begin
    result := '';
    rs := cn.execute('select distinct '+fieldname+' from '+tablename);
    //if not rs.eof then begin
    //  flds := rs.getrows;
    //  c := VarArrayHighBound(flds,2);
    //  for i := 0 to c-1 do
    //    result := result + vartostr(flds[0,i]) + ',';
    //end;
    while not rs.eof do begin
        result := result+vartostr(rs.fields[0].value) + ',';
        rs.movenext;
    end;
    rs.close;
    rs:=unassigned;
    flds:=unassigned;
    setlength(result,length(result)-1);
  end;

  procedure delScale;
  var List : string;
  begin
    { the following delete command takes a little too long:
      "delete from sel_scls where qpc_id not in (select distinct scaleid from sel_qstns where subtype=1)"
      Presumably, the subquery is being re-run for each sel_scls record.  The delete runs quite a bit faster
      if we build the List string first.
    }
    List := FieldList('sel_qstns where subtype=1','scaleid');
    if List <> '' then
      cn.execute('delete from sel_scls where qpc_id not in ('+List+')');

    List := fieldlist('Sel_qstns','Selqstns_id');
    if List <> '' then
      cn.execute('delete from sel_skip where selqstns_id not in ('+list+')');
  end;

  procedure delItem(const thissection:integer; const thissubsection:integer; const thisitem:integer; const thisid:integer);
  begin
      cn.execute(format('delete from Sel_qstns '+
                        'where '+qpc_section+'=%d '+
                        'and subsection=%d '+
                        'and item=%d '+
                        'and selqstns_id=%d',
                 [thissection,thissubsection,thisitem,thisid]));
      SaveDialog.tag := 2;
  end;

  procedure delSubsection(const thissection:integer; const thissubsection:integer);
  begin
      cn.execute('delete from Sel_qstns '+
         'where '+qpc_section+'='+inttostr(thissection)+
         '  and subsection='+inttostr(thissubsection));
      cn.execute('update sel_qstns set subsection=subsection-1 '+
         'where '+qpc_section+'='+inttostr(thissection)+
         '  and subsection>'+inttostr(thissubsection));
      SaveDialog.tag := 2;
  end;

  procedure delSection(const thissection:integer);
  begin
    with wwT_Qstns do begin
      if thisSection = 1 then begin
        if not findkey([2,0,0]) then begin
          wwt_QstnsEnableControls;
          refresh;
          messagebeep(0);
          messagedlg('Can''t delete the last section!',mterror,[mbok],0);
          exit;
        end;
      end;
    end;
      cn.execute('delete from Sel_qstns '+
         'where '+qpc_section+'='+inttostr(thissection));
      cn.execute('update sel_qstns set '+qpc_section+'='+qpc_section+'-1 '+
         'where '+qpc_section+'>'+inttostr(thissection));
      SaveDialog.tag := 2;
  end;

  procedure delProblemScores;
  var corelist : string;
  begin
    CoreList := fieldlist('Sel_qstns where subtype=1','qstncore');
    if CoreList <> '' then
      cn.execute('delete from ProblemScores where core not in ('+corelist+')');
  end;

  var _st,_s,_ss,_i,_id : array[0..40] of integer;
      j : integer;
begin
  with wwT_Qstns do begin
    disablecontrols;
    this_section := wwt_Qstnssection.value;
    this_subsection := wwt_Qstnssubsection.value;
    this_item := wwt_Qstnsitem.value;
    this_id := wwt_QstnsID.value;
    _st[0] := wwt_qstnsSubType.value;
    _s[0] := wwt_Qstnssection.value;
    _ss[0] := wwt_Qstnssubsection.value;
    _i[0] := wwt_Qstnsitem.value;
    _id[0] := wwt_QstnsID.value;

    with f_DynaQ.wwdbgrid1 do begin
      i := 1;
      while i <= SelectedList.Count do begin
        GotoBookmark(SelectedList.items[i-1]);
        _st[i] := wwt_QstnsSubType.value;
        _s[i] := wwt_Qstnssection.value;
        _ss[i] := wwt_Qstnssubsection.value;
        _i[i] := wwt_Qstnsitem.value;
        _id[i] := wwt_QstnsID.value;
        if _id[i] = _id[0] then _st[0] := -1;
        inc(i);
      end;
    end;

    indexfieldname := qpc_Section+';SubSection;Item';
    for j := i downto 0 do begin
        if (_st[j]=stItem) or (_st[j]=stComment) then
          delItem(_s[j],_ss[j],_i[j],_id[j])
        else if (_st[j]=stSubSection) then
          delSubsection(_s[j],_ss[j])
        else if (_st[j]=stSection) then
          delSection(_s[j]);
    end;
    delScale;
    delProblemScores;
    CheckItemNumbering;
    if not findkey([this_section,this_subsection,this_item]) then
      if not findkey([this_section,this_subsection+1,0]) then
        if not findkey([this_section+1,0,0]) then
          findkey([this_section,0,0]);
    wwt_QstnsEnableControls;
    refresh;
  end;
end;

function TDMOpenQ.CutQuestions:integer;
var i, this_section, this_subsection, this_item, this_id : integer;
begin
  CutQuestions := 0;
  with wwT_Qstns do begin
    disablecontrols;
    this_section := wwt_Qstnssection.value;
    this_subsection := wwt_Qstnssubsection.value;
    this_item := wwt_Qstnsitem.value;
    this_id := wwt_QstnsID.value;
    indexfieldname := qpc_Section+';SubSection;Item';
    // cut the current record
    if fieldbyname('subtype').value <> 3 then begin
      edit;
      fieldbyname('sampleunit_id').value := 11;
      post;
    end;
    // cut all selected records
    with f_DynaQ.wwdbgrid1 do begin
      i := 0;
      while i < SelectedList.Count do begin
        GotoBookmark(SelectedList.items[i]);
        if fieldbyname('subtype').value <> 3 then begin
          edit;
          fieldbyname('sampleunit_id').value := 11;
          post;
        end;
        inc(i);
      end;
    end;
    // if any subsection are cut, also cut all their contents
    localquery('select distinct section_id, subsection, subtype '+
               'from sel_qstns '+
               'where subtype=2 '+
               'and sampleunit_id=11',false);
    while not ww_Query.eof do begin
      localquery('update sel_qstns '+
                 'set sampleunit_id=11 '+
                 'where section_id='+ww_Query.fieldbyname('section_id').asstring+' '+
                 'and subsection='+ww_Query.fieldbyname('subsection').asstring,true);
      ww_Query.next;
    end;
    // also cut any translated questions
    localquery('UPDATE sel_qstns frgn '+
               'SET sampleunit_id = (SELECT eng.sampleunit_id '+
                                    'FROM sel_qstns eng '+
                                    'WHERE frgn.section_id=eng.section_id '+
                                      'and frgn.subsection=eng.subsection '+
                                      'and frgn.item=eng.item '+
                                      'and eng.language=1 '+
                                      'and eng.sampleunit_id=11) '+
               'WHERE frgn.language>1',true);
    // check to make sure all cut questions have the same header
    localquery('select min(h.qstncore) as minHeader, max(h.qstncore) as maxHeader '+
               'from sel_qstns q, sel_qstns h '+
               'where q.subtype=1 and q.sampleunit_id in (10,11) '+
               'and h.subtype=2 '+
               'and q.section_id=h.section_id '+
               'and q.subsection=h.subsection',false);
    if (ww_Query.fieldbyname('minHeader').value<>ww_Query.fieldbyname('maxHeader').value) then begin
      CutQuestions := 1;  // can't cut 'cuz of different headers
      localquery('update Sel_qstns set sampleunit_id=0 where sampleunit_id=11',true);
    end else begin
      CutQuestions := 0;
      localquery('update Sel_qstns set sampleunit_id=10 where sampleunit_id=11',true);
      ClipboardQuestions := true;
    end;

    if not findkey([this_section,this_subsection,this_item]) then
      if not findkey([this_section,this_subsection+1,0]) then
        if not findkey([this_section+1,0,0]) then
          findkey([this_section,0,0]);
    wwt_QstnsEnableControls;
    refresh;
  end;
end;

procedure TDMOpenQ.UnCutQuestions;
begin
  wwt_Qstns.DisableControls;
  localquery('update sel_qstns '+
             'set sampleunit_id=0 '+
             'where sampleunit_id in (10,11)',true);
  wwt_Qstns.EnableControls;
  wwT_Qstns.Refresh;
end;

function TDMOpenQ.PasteQuestions:integer;
var i, this_section, this_subsection, this_item : integer;
begin
  with wwT_Qstns do begin
    disablecontrols;
    if wwt_Qstnsitem.value=0 then begin
      wwt_qstns.Prior;
      this_section := wwt_Qstnssection.value;
      this_subsection := wwt_Qstnssubsection.value;
      this_item := wwt_Qstnsitem.value+1;
    end else begin
      this_section := wwt_Qstnssection.value;
      this_subsection := wwt_Qstnssubsection.value;
      this_item := wwt_Qstnsitem.value;
    end;

    indexfieldname := qpc_Section+';SubSection;Item';
    //move cut subsection(s)
    localquery('select count(*) as cnt from sel_qstns where subtype=2 and sampleunit_id=10',false);
    i := ww_Query.FieldByName('cnt').asinteger;
  //  if (wwT_QstnsSubtype.value = 3) and (i=0) then begin
  //    result := 2;
  //    exit;  //if not pasting a subsection
  //  end;
    if i>0 then begin
      localquery('update sel_Qstns '+
                 'set subsection = subsection+'+inttostr(i)+' '+
                 'where section_id='+inttostr(this_section)+' '+
                 'and subsection>'+inttostr(this_subsection),true);
      localquery('select distinct section_id, subsection from sel_qstns where subtype=2 and sampleunit_id=10',false);
      i := this_subsection;
      while not ww_Query.eof do begin
        inc(i);
        localquery('update sel_qstns '+
                 'set section_id='+inttostr(this_section)+', subsection='+inttostr(i)+', sampleunit_id=0 '+
                 'where section_id='+ww_query.fieldbyname('section_id').asstring+' '+
                 'and subsection='+ww_query.fieldbyname('subsection').asstring,true);
        ww_Query.next;
      end;
    end;

    localquery('select count(*) as cnt from sel_qstns where subtype in (1,4) and sampleunit_id=10',false);
    if ww_Query.FieldByName('cnt').asinteger>0 then begin
      // move cut questions & comments to current section
      if (wwT_QstnsSubtype.value = 3) then begin
        result := 2;
        wwt_QstnsEnableControls;
        refresh;
        exit;  //trying to paste directly under a section
      end;
      wwt_Qstns.FindKey([this_section,this_subsection,0]);
      i := wwt_qstnsqstncore.AsInteger;
      localquery('select min(h.qstncore) as minHeader, max(h.qstncore) as maxHeader, count(*) as cnt '+
                 'from sel_qstns q, sel_qstns h '+
                 'where q.subtype=1 and q.sampleunit_id=10 '+
                 'and h.subtype=2 '+
                 'and q.subtype=1 '+
                 'and q.section_id=h.section_id '+
                 'and q.subsection=h.subsection',false);
      if ww_Query.fieldbyname('cnt').value=0 then
        result := 0 // there are no questions on the clipboard, only comments
      else if ww_Query.fieldbyname('maxHeader').asinteger=i then
        result := 0 // headers match
//      else if ((ww_Query.fieldbyname('maxHeader').asinteger<=0) and (i<=0)) then
//        result := 0 // headers are both 0 or -1
      else begin
        // headers don't match
        localquery('select count(*) as cnt '+
                   'from sel_qstns '+
                   'where section_id='+inttostr(this_section)+' '+
                   'and subsection='+inttostr(this_subsection)+' '+
                   'and subtype=1',false);
        if (ww_Query.FieldByName('cnt').asinteger=0) then begin
           // subsection doesn't have any questions in it, so copy the header from whereever the cut questions are from
           localquery('select h.* '+
                      'from sel_qstns q, sel_qstns h '+
                      'where q.subtype=1 and q.sampleunit_id=10 '+
                      'and h.subtype=2 '+
                      'and q.section_id=h.section_id '+
                      'and q.subsection=h.subsection '+
                      'and h.language=1',false);
           wwt_qstns.Locate('section_id;subsection;item;language',VarArrayOf([this_section,this_subsection,0,1]), []);
           wwt_qstns.edit;
           wwt_qstns.FieldByName('Label').value := ww_Query.fieldbyname('Label').value;
           wwt_qstns.FieldByName('PlusMinus').value := ww_Query.fieldbyname('PlusMinus').value;
           wwt_qstns.FieldByName('RichText').value := ww_Query.fieldbyname('RichText').value;
           wwt_qstns.FieldByName('QstnCore').value := ww_Query.fieldbyname('QstnCore').value;
           wwt_qstns.FieldByName('ScalePos').value := ww_Query.fieldbyname('ScalePos').value;
           wwt_qstns.FieldByName('bitLangReview').value := ww_Query.fieldbyname('bitLangReview').value;
           wwt_qstns.FieldByName('bitMeanable').value := ww_Query.fieldbyname('bitMeanable').value;
           wwt_qstns.post;
           localquery('delete from sel_qstns '+
                      'where section_id='+inttostr(this_section)+' '+
                      'and subsection='+inttostr(this_subsection)+' '+
                      'and item=0 '+
                      'and language>1',true);
           result := 0;
        end else
          result := 1;
      end;

      if result=0 then begin
        localquery('select count(*) as cnt from sel_qstns where subtype in (1,4) and sampleunit_id=10 and language=1',false);
        i := ww_Query.FieldByName('cnt').asinteger;
        if i>0 then begin
          with wwT_Qstns do begin
            first;
            while not eof do begin
              if (wwt_qstnssection.value=this_section) and
                 (wwt_qstnssubsection.value=this_subsection) and
                 (wwt_qstnsitem.Value>=this_item) then begin
                edit;
                wwt_qstnsitem.Value := wwt_qstnsitem.value + i;
                post;
              end;
              next;
            end;
            indexfieldname := qpc_Section+';SubSection;Item';
          end;
{
          localquery('update sel_Qstns '+
                     'set item = item+'+inttostr(i)+' '+
                     'where section_id='+inttostr(this_section)+' '+
                     'and subsection='+inttostr(this_subsection)+' '+
                     'and item>'+inttostr(this_item),true);
}
          localquery('select distinct section_id, subsection, item from sel_qstns where subtype in (1,4) and sampleunit_id=10 order by section_id, subsection, item',false);
          i := this_item;
          while not ww_Query.eof do begin
            localquery('update sel_qstns '+
                       'set section_id='+inttostr(this_section)+', '+
                           'subsection='+inttostr(this_subsection)+', '+
                           'item='+inttostr(i)+', '+
                           'sampleunit_id=0 '+
                       'where section_id='+ww_Query.fieldbyname('section_id').asstring+' '+
                       'and subsection='+ww_Query.fieldbyname('subsection').asstring+' '+
                       'and item='+ww_Query.fieldbyname('item').asstring,true);
            inc(i);
            ww_Query.next;
          end;
        end;
      end;
    end;
  end;
  CheckItemNumbering;
  wwt_qstns.findkey([this_section,this_subsection,this_item]);
  wwT_Qstns.Refresh;
end;

procedure TDMOpenQ.AddSection;
var SectOrder,current : integer;
    SectionName:string;
begin
  SectionName := InputBox('New Section Name', 'What name do you want for the new section?', '');
  if SectionName <> '' then
    with wwT_Qstns do begin
      disablecontrols;
      current := wwt_Qstnssection.value;
      SectOrder := wwt_QstnsnumMarkCount.asinteger;
      indexfieldnames := qpc_Section+';SubSection;Item';
      if findkey([succ(current),0,0]) then begin
        indexfieldname := 'Survey_ID;SelQstns_Id';
        filtered := false;
        first;
        while not eof do begin
          if wwt_QstnsSection.value > current then begin
            edit;
            wwt_QstnsSection.value := succ(wwt_QstnsSection.value);
            if wwt_QstnsSubtype.value=stSection then
              wwt_QstnsnumMarkCount.value := succ(wwt_QstnsnumMarkCount.asinteger);
            post;
          end;
          next;
        end;
      end;
      indexfieldname := qpc_Section+';SubSection;Item';
      filtered := true;
      Append;
      wwt_qstns.tag := wwt_qstns.tag + 1;
      wwt_QstnsSurvey_ID.value := glbSurveyID;
      wwt_QstnsID.value := wwt_Qstns.tag;
      wwt_QstnsType.text := 'Question';
      wwt_QstnsSection.value := succ(current);
      wwt_QstnsSubsection.value := 0;
      wwt_QstnsItem.value := 0;
      wwt_QstnsLabel.text := SectionName;
      wwt_QstnsPlusMinus.text := '-';
      wwt_QstnsSubType.value := stSection;
      wwt_QstnsLanguage.value := 1;
      wwt_QstnsScaleID.value := 0;
      wwt_QstnsQstnCore.value := 0;
      wwt_QstnsbitMeanable.value := false;
      wwt_QstnsbitLangReview.value := false;
      wwt_QstnsnumMarkCount.value := succ(SectOrder);
      post;
      wwt_QstnsEnableControls;
    end;
end;

procedure TDMOpenQ.AddSubSection(const SSName:string;AutoCreate:boolean);
var current,section : integer;
    SubsectionName : string;
begin
  if not AutoCreate then
    SubsectionName := InputBox('New Subsection Name', 'What name do you want for the new subsection?', SSName)
  else
    SubsectionName := SSName;
  if SubsectionName <> '' then
    with wwT_Qstns do begin
      disablecontrols;
      current := wwt_Qstnssubsection.value;
      section := wwt_Qstnssection.value;
      indexfieldnames := qpc_Section+';SubSection;Item';
      if findkey([section,succ(current),0]) then begin
        indexfieldname := 'Survey_ID;SelQstns_Id';
        filtered := false;
        first;
        while not eof do begin
          if (wwt_QstnsSection.value = Section) and
              (wwt_QstnsSubsection.value > current) then begin
            edit;
            wwt_QstnsSubsection.value := succ(wwt_QstnsSubsection.value);
            post;
          end;
          next;
        end;
      end;
      indexfieldname := qpc_Section+';SubSection;Item';
      filtered := true;
      Append;
      wwt_qstns.tag := wwt_qstns.tag + 1;
      wwt_QstnsSurvey_ID.value := glbSurveyID;
      wwt_QstnsID.value := wwt_Qstns.tag;
      wwt_QstnsType.text := 'Question';
      wwt_QstnsSection.value := section;
      wwt_QstnsSubsection.value := succ(current);
      wwt_QstnsItem.value := 0;
      wwt_QstnsLabel.text := SubsectionName;
      wwt_QstnsPlusMinus.text := '  -';
      wwt_QstnsQstnCore.value := -1; {no header specified yet}
      wwt_QstnsScalePos.value := spRight;
      wwt_QstnsSubType.value := stSubsection;
      wwt_QstnsLanguage.value := 1;
      wwt_QstnsScaleID.value := 0;
      wwt_QstnsbitMeanable.value := false;
      wwt_QstnsbitLangReview.value := false;
      post;
      wwt_QstnsEnableControls;
    end;
end;

function tdmOpenQ.getItemsinSubsection:integer;
begin
  with ww_Query do begin
    close;
    databasename := '_PRIV';
    SQL.clear;
    SQL.add('select max(item) as mx from Sel_Qstns');
    SQL.add('where '+qpc_section+'='+inttostr(dmOpenq.wwT_QstnsSection.value));
    SQL.add('and subsection='+inttostr(dmOpenq.wwT_QstnsSubsection.value));
    SQL.add('group by '+qpc_section+',subsection');
    open;
    result := fieldbyname('mx').asInteger;
    close;
  end;
end;

procedure tDMOpenQ.AddScale(newScaleID:integer);
var BubbleCount,ColumnNeed : integer;
    MinVal,MaxVal : integer;
begin
  with DQDataModule, wwT_Scls do begin
    indexfieldname := qpc_ID;
    BubbleCount := 0;
    MinVal := 9999;
    MaxVal := 0;
    if findkey([newScaleID]) then begin
      while (not eof) and (wwT_SclsID.value = newScaleID) do begin
        inc(BubbleCount);
        if wwt_SclsVal.value < MinVal then MinVal := wwt_SclsVal.value;
        if wwt_SclsVal.value > MaxVal then MaxVal := wwt_SclsVal.value;
        next;
      end;
    end else begin
      if wwt_ScalesScale.value <> newScaleID then begin
        wwt_Scales.MasterSource := nil;
        wwt_scales.FindKey([newscaleid]);
      end;
      if wwt_ScalesFielded.value <> 1 then begin
        wwt_Scales.edit;
        wwt_scalesfielded.value := 1;
        wwt_scales.post;
      end;
      wwt_scalevalues.first;
      while (not wwT_ScaleValues.eof) and
          (wwT_ScaleValues.fieldbyname('Scale').value = newScaleID) do begin
        {add records to wwT_Scls here}
        append;
        wwt_Scls.tag := wwt_Scls.tag + 1;
        wwt_SclsSurvey_ID.value := glbSurveyID;
        wwt_SclsID.value := newScaleID;
        wwt_SclsItem.value := wwT_ScaleValuesItem.Value;
        wwt_SclsLanguage.value := 1;
        wwt_SclsType.value := 'Scale';
        wwt_SclsLabel.value := wwT_ScaleValuesShort.Value;
        wwt_SclsMissing.value := wwT_ScaleValuesMissing.Value;
        wwt_SclsVal.value := wwT_ScaleValuesBubbleValue.Value;
        wwt_SclsCharset.value := wwt_ScaleValuesCharset.Value;
        wwt_SclsScaleOrder.Value := wwt_ScaleValuesScaleOrder.Value;
        wwt_SclsintRespType.Value := wwt_ScaleValuesType.Value;
        wwt_SclsRichText.assign(wwT_ScaleTextText);
        post;
        inc(BubbleCount);
        if wwt_ScaleValuesBubbleValue.value < MinVal then MinVal := wwt_ScaleValuesBubbleValue.value;
        if wwt_ScaleValuesBubbleValue.value > MaxVal then MaxVal := wwt_ScaleValuesBubbleValue.value;
        wwT_ScaleValues.next;
      end;
      wwt_scales.MasterSource := wwDS_Questions;
    end;
    indexfieldname := 'Survey_ID;'+qpc_ID;
    ColumnNeed := length(inttostr(maxval));
    if MinVal<0 then
      inc(ColumnNeed);
    cn.execute('update Sel_qstns set '+
        'numBubbleCount='+inttostr(bubblecount)+', '+
        'ScaleFlipped='+inttostr(ColumnNeed)+' '+
        'where scaleid='+inttostr(newscaleid));
  end;
end;

function TDMOpenQ.AddQstn:boolean;
var current,section,subsection : integer;
    NewHeadID : integer;
begin
  result := true;
  with DQDataModule do begin
    with wwt_ScaleText do if not active then open;
    with wwt_ScaleValues do if not active then open;
    with wwt_Scales do if not active then open;
    with wwt_QuestionText do if not active then open;
  end;
  if getItemsinSubsection>25 then begin
    result := false;
    messagedlg('You can only have 26 questions in a subsection.',mterror,[mbok],0);
  end;
  if result then begin
    with wwT_Qstns do begin
      current := wwt_QstnsItem.value;
      subsection := wwt_QstnsSubsection.value;
      section := wwt_QstnsSection.value;
      disablecontrols;
      if (subsection=0) and (messagedlg('Questions must be added to subsections.  '+
          'Do you want to create a subsection?',mtconfirmation,[mbyes,mbno],0) = mrYes) then
        with DQDataModule, wwT_Headings do begin
          if not active then open;
          findkey([wwT_QuestionsHeadID.value]);
          AddSubsection(wwT_HeadingsName.value,false);
          subsection := wwt_QstnsSubsection.value;
        end;
      if subsection > 0 then begin
        indexname := 'BySection';
        if findkey([section,subsection,0]) then begin
          NewHeadID := wwt_QstnsQstnCore.value;
          {check for similar header}
          if (NewHeadID>=0) and
              (NewHeadID <> DQDataModule.wwT_QuestionsHeadID.value) then
            if not (findkey([section,subsection,1])) then
              NewHeadID := -1
            else begin
              if (messagedlg('All questions in a subsection must have similar headers.  '+
                  'Do you want to create a new subsection with the new header?',
                  mtconfirmation,[mbYes,mbNo],0)=mrYes) then begin
                with DQDataModule, wwT_Headings do begin
                  if not active then open;
                  findkey([wwT_QuestionsHeadID.value]);
                  AddSubsection(wwT_HeadingsName.value,false);
                end;
                NewHeadID := -1;
                current := 0;
                subsection := wwt_Qstnssubsection.value;
              end else begin
                wwt_QstnsEnableControls;
                result := false;
                exit;
              end;
            end;
        end else begin
          Messagedlg('Can''t find Subsection '+inttostr(section)+'.'+inttostr(subsection)+' definition.',mterror,[mbok],0);
          wwt_QstnsEnableControls;
          result := false;
          exit;
        end;
         {
         localQuery('update sel_qstns set plusminus=''  -'' '+
             'where section_id='+inttostr(section)+
             ' and subsection='+inttostr(subsection)+
             ' and item=0',true);

         localQuery('update sel_qstns set plusminus='''', '+
             'item=item+1 '+
             'where section_id='+inttostr(section)+
             ' and subsection='+inttostr(subsection)+
             ' and item>'+inttostr(current),true);
        }

        if findkey([section,subsection,succ(current)]) then begin
          indexfieldname := 'Survey_ID;SelQstns_Id';
          filtered := false;
          first;
          while not wwt_qstns.eof do begin
            if (wwt_QstnsSection.value = Section) and
               (wwt_QstnsSubsection.value = Subsection) then begin
              wwt_qstns.edit;
              if wwt_Qstnsitem.value=0 then
                wwt_QstnsPlusMinus.value := '  -'
              else
                wwt_QstnsPlusMinus.value := '';
              if wwt_qstnsitem.value>current then
                wwt_Qstnsitem.value := succ(wwt_Qstnsitem.value);
              wwt_qstns.post;
            end;
            wwt_qstns.next;
          end;
          filtered := true;
          IndexName := 'BySection';
        end;

        first;
        if NewHeadID = -1 then begin
          if findkey([section,subsection,0]) then begin
            with DQDataModule do begin
               with wwT_HeadText do if not active then open;
               with wwT_Headings do begin
                 if not active then open;
                 findkey([wwT_QuestionsHeadID.value]);
               end;
            end;
            if DQDataModule.wwt_HeadingsFielded.value <> 1 then begin
              DQDataModule.wwt_Headings.edit;
              DQDataModule.wwt_HeadingsFielded.value := 1;
              DQDataModule.wwt_Headings.post;
            end;
            edit;
            wwt_QstnsQstnCore.value := DQDataModule.wwT_QuestionsHeadID.value;
            wwt_QstnsRichText.assign(DQDataModule.wwT_HeadText.fieldbyname('Text'));
            wwt_QstnsScalePos.value := -1;
            wwt_QstnsLanguage.value := 1;
            post;
          end;
        end;
        filtered := true;
        if dqdatamodule.wwt_QuestionsFielded.value <> 1 then begin
          dqdatamodule.wwt_Questions.edit;
          dqdatamodule.wwt_QuestionsFielded.value := 1;
          dqdatamodule.wwt_Questions.post;
        end;
        Append;
        wwt_qstns.tag := wwt_qstns.tag + 1;
        wwt_QstnsID.value := wwt_Qstns.tag;
        wwt_QstnsType.text := 'Question';
        wwt_QstnsSection.value := section;
        wwt_QstnsSubsection.value := subsection;
        wwt_QstnsItem.value := succ(current);
        wwt_QstnsLabel.text := DQDataModule.wwT_QuestionsShort.text;
        wwt_QstnsScaleID.value := DQDataModule.wwt_QuestionsScale.value;
        wwt_QstnsRichText.assign(DQDataModule.wwT_QuestionText.fieldbyname('Text'));
        wwt_QstnsPlusMinus.text := '';
        wwt_QstnsLanguage.value := 1; {english}
        wwt_QstnsQstnCore.value := DQDataModule.wwt_QuestionsCore.value;
        wwt_QstnsSubType.value := stItem;
        wwt_QstnsbitLangReview.value := False;
        if DQDataModule.wwT_Scales.fieldbyname('Right').asBoolean then
          wwt_QstnsScalePos.value := spRight
        else
          wwt_QstnsScalePos.value := spBelow;
        wwt_QstnsWidth.value := DQDataModule.wwt_ScalesWidth.Value;
        wwt_QstnsSurvey_ID.value := glbSurveyID;
        wwt_QstnsnumMarkCount.value := DQDataModule.wwt_ScalesMarkCount.Value;
        wwt_QstnsbitMeanable.value := DQDataModule.wwt_ScalesMean.Value;
        wwt_Qstns.post;
        GetAProblemScore(DQDataModule.wwt_QuestionsCore.value);
        wwt_QstnsEnableControls;
      end else begin
        wwt_QstnsEnableControls;
        result := false;
        exit;
      end; {if subsection>0 .. else}
    end; {with}
    AddScale(wwt_QstnsScaleID.value);
  end;
end;

procedure tdmOpenQ.AddComment;
var current,section,subsection : integer;
    loc:string;
begin
  if getItemsinSubsection>25 then
    messagedlg('You can only have 26 questions in a subsection.',mterror,[mbok],0)

  else begin
   with wwT_Qstns do begin
    disablecontrols;
    current := wwt_Qstnsitem.value;
    subsection := wwt_Qstnssubsection.value;
    section := wwt_Qstnssection.value;
    if subsection > 0 then begin
      frmREEdit := TfrmREEdit.Create( Self );
      with frmREEdit do
      try
        lblBlankLines.visible := true;
        editBlankLines.visible := true;
        seBorderWidth.Visible := true;
        Label2.Visible := true;
        seBorderWidth.Visible := true;
        btnLeftJustify.visible := false;
        btnCenter.visible := false;
        btnRightJustify.visible := false;
        cbFonts.visible := false;
        cbFontSize.visible := false;
        btnSpellCheck.left := 109;
        DBEdit1.Visible := true;
        editblanklines.value := 0;
        seBorderWidth.Value := 0;
        pnlShading.Color := clWhite;
        pnlShading.Visible := true;
        wtText.Edit;
        wtText.fieldbyname('Text').asString := '';
        wTTextLabel.text := '';
        wtText.post;
        caption := 'New Comment Box';
        with clDBRichCodeBtn1 do begin
          font.name := 'MS Sans Serif' {QstnFont};
          font.size := 8 {QstnPoint};
          font.style := [];
          DefAttributes.name := 'MS Sans Serif' {QstnFont};
          DefAttributes.size := 8 {QstnPoint};
          DefAttributes.style := [];
          Paragraph.Alignment := taLeftJustify;
        end;

        if (frmREEdit.ShowModal = mrOK) then
        begin
         //using a dbo connection object fixes the problem of inserting
         //comment boxes in the middle of a section.
         //felix gomez 7/29/03
         {
         localQuery('update sel_qstns set plusminus=''  -'' '+
             'where section_id='+inttostr(section)+
             ' and subsection='+inttostr(subsection)+
             ' and item=0',true);



         localQuery('update sel_qstns set plusminus='''', '+
             'item=item+1 '+
             'where section_id='+inttostr(section)+
             ' and subsection='+inttostr(subsection)+
             ' and item>'+inttostr(current),true);
          }

         cn.Execute('update sel_qstns set plusminus=''  -'' '+
             'where section_id='+inttostr(section)+
             ' and subsection='+inttostr(subsection)+
             ' and item=0');


          cn.execute('update sel_qstns set plusminus='''', '+
             'item=item+1 '+
             'where section_id='+inttostr(section)+
             ' and subsection='+inttostr(subsection)+
             ' and item>'+inttostr(current));
          IndexName := 'BySection';
          first;
          filtered := true;
          Append;
          wwt_qstns.tag := wwt_qstns.tag + 1;
          wwt_QstnsSurvey_ID.value := glbSurveyID;
          wwt_QstnsID.value := wwt_Qstns.tag;
          wwt_QstnsType.text := 'Question';
          wwt_QstnsSection.value := section;
          wwt_QstnsSubsection.value := subsection;
          wwt_QstnsItem.value := succ(current);
          wwt_QstnsLabel.text := wTTextLabel.text;
          if (wwt_QstnsLabel.text='') or (wwt_QstnsLabel.text='Comment Box') then
            if (clDBRichCodeBtn1.Lines[0]<>'') then
              wwt_QstnsLabel.text := trim(clDBRichCodeBtn1.Lines[0])
            else
              wwt_QstnsLabel.text := 'Comment Box';
          wwt_QstnsRichText.LoadFromFile(tempdir+'\RichEdit.rtf');
          wwt_QstnsPlusMinus.text := '';
          wwt_QstnsLanguage.value := 1; {english}
          wwt_QstnsSubType.value := stComment;
          wwt_QstnsHeight.value := editblanklines.value;

          wwT_QstnsWidth.value := seBorderWidth.value;
          wwT_QstnsScaleFlipped.Value := pnlShading.Color;

          wwt_QstnsScaleID.value := 0;
          wwt_QstnsQstnCore.value := 0;
          wwt_QstnsbitMeanable.value := false;
          wwt_QstnsbitLangReview.value := false;
          post;
        end;
      finally
        Release;
      end;
    end else begin
      messagebeep(0);
      wwt_QstnsEnableControls;
      exit;
    end;
    wwt_QstnsEnableControls;
   end;
  end;
end;
procedure tdmOpenQ.EditComment(const LinesVisible:boolean; const cptn:string);
var w,h,s:string;
    q:integer;
begin
  with wwt_Qstns do begin
    wwt_QstnsRichText.SaveToFile(tempdir+'\RichEdit.rtf');
    frmREEdit := TfrmREEdit.Create( Self );
    with frmREEdit do
    try
      lblBlankLines.visible := LinesVisible;
      editBlankLines.visible := LinesVisible;
      btnLeftJustify.visible := false;
      btnCenter.visible := false;
      btnRightJustify.visible := false;
      cbFonts.visible := false;
      cbFontSize.visible := false;
      btnSpellCheck.left := 117;
      DBEdit1.Visible := true;
      editblanklines.value := wwt_QstnsHeight.value;
      seBorderWidth.Visible := true;
      Label2.Visible := true;
      pnlShading.Visible := true;
      if varisnull(wwT_QstnsScaleFlipped.asVariant) then
         pnlShading.Color := clWhite
      else
        pnlShading.Color := wwT_QstnsScaleFlipped.Value;

      editBlankLinesChange(pnlShading);

      if not varisnull(wwT_QstnsWidth.AsVariant) then
         seBorderWidth.Value := wwT_QstnsWidth.value
      else if editblanklines.value > 0 then
        seBorderWidth.Value := 1;

      wtText.Edit;
      wtTextText.LoadFromFile(tempdir+'\RichEdit.rtf');
      wTTextLabel.text := wwt_QstnsLabel.text;
      wtText.Post;
      caption := cptn;
      if ShowModal = mrOK then begin
        Edit;

        w:=inttostr(seBorderWidth.value);
        h:=inttostr(editblanklines.value);
        s:=inttostr(pnlShading.Color);
        q:=wwT_QstnsID.value;

        if w='' then w:='null';
        if s='' then s:='null';
        if h='' then h:='null';

       // wwT_QstnsWidth.value := BorderWidth.value;
       // wwT_QstnsScaleFlipped.Value := pnlShading.Color;
       // wwt_QstnsHeight.value := editblanklines.value;



        wwt_QstnsRichText.LoadFromFile(tempdir+'\RichEdit.rtf');
        wwt_QstnsLabel.text := wTTextLabel.text;
        if (wwt_QstnsLabel.text='') or (wwt_QstnsLabel.text='Comment Box') then
          if (clDBRichCodeBtn1.Lines[0]<>'') then
            wwt_QstnsLabel.text := trim(clDBRichCodeBtn1.Lines[0])
          else
            wwt_QstnsLabel.text := 'Comment Box';
        post;
        //when a comment box is edited we need to update foreing laguages properties also
        s:= format('update sel_qstns set width = %s, Height = %s, ScaleFlipped = %s where SELQSTNS_ID = %d',[w,h,s,q]);
        cn.execute(s);
      end;
    finally
      Release;
    end;
  end;
end;

procedure tdmOpenQ.EditFOUO;
begin
  with wwt_Qstns do begin
    filtered := false;
    indexfieldnames := qpc_Section+';SubSection;Item';
    Findkey([-1,2,0]);
    wwt_QstnsRichText.SaveToFile(tempdir+'\RichEdit.rtf');
    frmREEdit := TfrmREEdit.Create( Self );
    with frmREEdit do
    try
      lblBlankLines.visible := false;
      editBlankLines.visible := false;
      btnLeftJustify.visible := false;
      btnCenter.visible := false;
      btnRightJustify.visible := false;
      cbFonts.visible := false;
      cbFontSize.visible := false;
      btnSpellCheck.visible := false;
      wtText.Edit;
      wtTextText.LoadFromFile(tempdir+'\RichEdit.rtf');
      wtText.Post;
      caption := 'Edit "For Office Use Only" Area';
      with clDBRichCodeBtn1 do begin
        font.name := 'Courier New' {QstnFont};
        font.size := 8 {QstnPoint};
        font.style := [];
        DefAttributes.name := 'Courier New' {QstnFont};
        DefAttributes.size := 8 {QstnPoint};
        DefAttributes.style := [];
        Paragraph.Alignment := taLeftJustify;
      end;
      if ShowModal = mrOK then begin
        Edit;
        wwt_QstnsRichText.LoadFromFile(tempdir+'\RichEdit.rtf');
        post;
      end;
    finally
      Release;
    end;
    filtered := true;
  end;
end;
{$ENDIF}

function TypeString(const DQT: TDQTableType):string;
begin
  case DQT of
    F: TypeString:='Full';
    Q: TypeString:='Question';
    S: TypeString:='Scale';
    V: TypeString:='Survey';
    C: TypeString:='Cover';
    L: TypeString:='Logo';
    T: TypeString:='TextBox';
    P: TypeString:='PCL';
    K: TypeString:='Skip';
  end;
end;

procedure tdmOpenQ.tabledef(var tbl:twwtable; TblType: TDQTableType; WithIndex:boolean);
  function fieldtype(s:string):tFieldType;
  begin
    fieldtype := ftUnknown;
    if s = 'Integer' then fieldtype := ftInteger
    else if s = 'String' then fieldtype := ftString
    else if s = 'Boolean' then fieldtype := ftBoolean
    else if s = 'AutoInc' then fieldtype := ftAutoInc
    else if s = 'Blob' then fieldtype := ftBlob
    else if s = 'Memo' then fieldtype := ftMemo
    else if s = 'Graphic' then fieldtype := ftGraphic;
  end;
begin
  with tbl do begin
    TableType := ttParadox;
    with FieldDefs do begin
      Clear;
      wwT_TableDef.first;
      while not wwT_TableDef.eof do begin
        if trim(wwt_tableDef.fieldbyname(typeString(TblType)).asString) <> '' then begin
          add(wwt_tableDef.fieldbyname(typeString(TblType)).text,
              fieldtype(wwt_tableDef.fieldbyname('FieldType').text),
              wwt_tableDef.fieldbyname('FieldLen').value,
              wwt_tableDef.fieldbyname('FieldRequired').value);
        end;
        wwt_tableDef.next
      end;
      if TblType=L then
        add('PCLStream',ftBlob,100,false);
{ $ IFDEF FormLayout}
      if tbltype=q then begin
        add('SampleUnit_id',ftInteger,0,false);
        add('SAMPLEUNITSECTION_ID',ftString,100,false);
      end;
{ $ ENDIF}
    end;
    if WithIndex then
      with IndexDefs do begin
        Clear;
        if TblType = F then        Add('ByID', 'Survey_ID;ID;Language;Section;Type', [ixPrimary])
        else if TblType = S then   Add('ByID', 'Survey_ID;'+QPC_ID+';Item;Language', [ixPrimary])
        else if TblType = Q then   Add('ByID', 'Survey_ID;SelQstns_ID;Language', [ixPrimary])
        else if (TblType=L) then   Add('ByID', 'Survey_ID;'+qpc_ID+';CoverID', [ixPrimary])
        else if (TblType=C) then   Add('ByID', 'Survey_ID;SelCover_ID', [ixPrimary])
        else if (TblType=K) then   add('ByID', 'Survey_ID;SelQstns_ID;SelScls_ID;ScaleItem', [ixPrimary])
        else if (TblType=T) then   Add('ByID', 'Survey_ID;'+QPC_ID+';Language;CoverID', [ixPrimary])
        else                       Add('ByID', 'Survey_ID;'+qpc_ID+';Language;CoverID', [ixPrimary]);
        if TblType = Q then begin
          Add('ScaleID', 'ScaleID', []);
          Add('BySection', qpc_Section+';SubSection;Item', []);
        end;
        if TblType = S then
          Add('ID', QPC_ID+';Item', []);
        if (TblType=L) or (TblType=P) or (TblType=T) then
          Add('ByCover', 'Survey_ID;CoverID', []);
      end;
    createtable;
  end;
end;

function tdmOpenQ.SurveyDB(const fn:string):boolean;
var pcFilename : pchar;
begin
  pcFilename := pchar(fn);
  // getshortpathname(pchar(fn),pcFilename,length(fn));
  with tmptbl do begin
    close;
    Databasename := ExtractFilePath(pcFilename);
    TableName := ExtractFileName(pcFilename);
    try
      DelDotStar(databasename+'p*.lck');
    except
    end;
    try
      Open;
      with fieldDefs do
        if (indexOf('Survey_ID') >= 0) and
           (indexOf('ID') >= 0) and
           (indexOf('Language') >= 0) and
           (indexOf('Section') >= 0) and
           (indexOf('Type') >= 0) and
           (indexOf('Label') >= 0) and
           (indexOf('PlusMinus') >= 0) and
           (indexOf('Subsection') >= 0) and
           (indexOf('Item') >= 0) and
           (indexOf('X') >= 0) and
           (indexOf('Y') >= 0) and
           (indexOf('Width') >= 0) and
           (indexOf('Height') >= 0) and
           (indexOf('RichText') >= 0) and
           (indexOf('MiscInt1') >= 0) and
           (indexOf('MiscInt2') >= 0) and
           (indexOf('MiscBool1') >= 0) and
           (indexOf('MiscBool2') >= 0) and
           (indexOf('MiscInt3') >= 0) and
           (indexOf('MiscInt4') >= 0) and
           (indexOf('MiscInt5') >= 0) and
           (indexOf('Bitmap') >= 0) then
          result := true
        else
          result := false;
      close;
    except
      result := false;
    end;
  end;
end;

procedure tdmOpenQ.UpdateOtherLanguageComment;
var s:string;
    rs:variant;
    q,w,h:string;
begin
  s:='select SELQSTNS_ID, ScaleFlipped,width,height from sel_qstns where subtype = '+inttostr(stComment)+' and language = 1 and ((width>0) or (ScaleFlipped >0) or (height>0) )';
  try
  rs:=createOleObject('ADODB.Recordset');
  rs.open(s,cn,1,1);
  while not rs.eof do
  begin
    q:=vartostr(rs.fields['SELQSTNS_ID'].value);
    w:=vartostr(rs.fields['width'].value);
    h:=vartostr(rs.fields['height'].value);
    s:=vartostr(rs.fields['ScaleFlipped'].value);
    if s = '' then s := 'NULL';
    if w = '' then w := 'NULL';
    if h = '' then h := 'NULL';
    s:= 'update sel_qstns set width = '+w+',height = '+h+',ScaleFlipped = '+s+' where SELQSTNS_ID = ' +q+' and language >1';
    cn.execute(s);
    rs.movenext;
  end;
  finally
    rs.close;
    rs:=unassigned;
  end;
end;

{$IFDEF FormLayout}
procedure tdmOpenQ.OpenQstns;
begin
  OpenQuery(Q, wwT_Qstns);
  //because of new border and shading we need translations to be
  //the same as english
  UpdateOtherLanguageComment;
end;

procedure tdmOpenQ.OpenScales;
begin
  OpenQuery(S, wwT_Scls);
end;

procedure tdmOpenQ.OpenLogos;
begin
  OpenQuery(L, wwt_Logo);
end;

procedure tdmOpenQ.OpenTextBox;
begin
  OpenQuery(T, wwt_TextBox);
end;

procedure tdmOpenQ.OpenPCL;
begin
  OpenQuery(P, wwt_PCL);
  GetPCLDimensions;
end;

procedure tdmOpenQ.OpenCover;
begin
  OpenQuery(C, wwt_Cover);
end;

procedure tdmOpenQ.OpenSkip;
begin
  OpenQuery(K, wwt_Skip);
end;

procedure tdmOpenQ.OpenQuery(const DQType:TDQTableType; var IntoTable:twwTable);
var tbl : twwTable;
    tg : integer;
    qryfld : string;
    orgfiltered : boolean;
    pcFilename : pchar;
begin
  IntoTable.Close;
  pcFilename := pchar(OpenFileName);
  //getshortpathname(pchar(OpenDialog.Filename),pcFilename,length(OpenDialog.Filename));
  with ww_Query do begin
    Close;
    Databasename := ExtractFilePath(pcFilename);
    SQL.Clear;
    SQL.Add('Select');
    wwt_TableDef.first;
    qryfld := '';
    if ShowOpenStatus then
      with frmOpenStatus do begin
        label1.caption := 'New Survey.  Opening ' + typeString(DQType) + ' information ...';
        progressbar.position := progressbar.position + 12;
        refresh;
      end;
    while not wwt_TableDef.eof do begin
      if trim(wwt_tableDef.fieldbyname(typeString(DQType)).text) <> '' then
        if wwt_TableDef.fieldbyname('Full').text = 'Survey_ID' then
          QryFld := qryfld + inttostr(glbSurveyID) + ' as Survey_ID, '
        else if wwt_TableDef.fieldbyname('Full').text = wwt_tableDef.fieldbyname(typeString(DQType)).text then
          QryFld := qryfld + wwt_TableDef.fieldbyname('Full').text + ', '
        else
          QryFld := qryfld + wwt_TableDef.fieldbyname('Full').text + ' as ' + wwt_tableDef.fieldbyname(typeString(DQType)).text + ', ';
      wwt_TableDef.next;
    end;
    qryfld := copy(qryfld,1,length(qryfld)-2);
    sql.add(qryfld);
    SQL.ADD('from "'+ExtractFileName(pcFilename)+'"');
    SQL.ADD('where Type='''+TypeString(DQType)+'''');
    ExecSQL;
    tbl := twwTable.create(Self);
    with tbl do
      try
        DatabaseName := '_PRIV';
        TableName := 'Sel_'+copy(IntoTable.name,5,255);
        TableDef(tbl,DQType,true);
        Active := True;
        if batchMove(ww_Query, batAppend) > 0 then {};
      finally
        free;
      end;
  end;
  with IntoTable do begin
    tag := 0;
    open;
    disablecontrols;
    orgfiltered := filtered;
    filtered := false;
    first;
    if DQType <> K then
      while not eof do begin
        if DQType = Q then begin
          if tag < fieldbyname('SelQstns_ID').value then tag := fieldbyname('SelQstns_ID').value;
        end else if DQType = C then begin
          if tag < fieldbyname('SelCover_ID').value then tag := fieldbyname('SelCover_ID').value;
        end else
          if tag < fieldbyname(qpc_ID).value then tag := fieldbyname(qpc_ID).value;
        next;
      end;
    filtered := orgfiltered;
    first;
    if DQType=Q then
      wwt_QstnsEnableControls
    else
      enablecontrols;
  end;
end;

procedure TDMOpenQ.OpenAllTables;
begin
  with f_DynaQ.ProgressBar do begin
    Position := Position + 12;
    OpenLogos;
    Position := Position + 13;
    OpenTextBox;
    Position := Position + 12;
    OpenPCL;
    Position := Position + 13;
    OpenCover;
    Position := Position + 12;
    OpenScales;
    Position := Position + 13;
    OpenSkip;
    Position := Position + 12;
    OpenQstns;
    wwt_qstns.indexname := 'BySection';
    Position := Position + 13;
  end;
end;

procedure TDMOpenQ.CheckQstnFieldedFlags;
var SavePlace : tBookMark;
    orgIndex : string;
    orgFilter : boolean;
begin
  with DQDataModule.wwt_Questions do begin
    disablecontrols;
    orgIndex := indexfieldnames;
    orgFilter := filtered;
    SavePlace := getBookmark;
    if OrgFilter then filtered := false;
    if orgIndex <> 'Core' then indexfieldnames := 'Core';
  end;
  if not dqdatamodule.wwt_questions.Active then dqdatamodule.wwt_questions.open;
  if not dqdatamodule.wwt_Scales.Active then dqdatamodule.wwt_Scales.open;
  if not dqdatamodule.wwt_Headings.Active then dqdatamodule.wwt_Headings.open;
  with ww_Query do begin
    close;
    databasename := '_PRIV';
    SQL.clear;
    SQL.add('select sq.QstnCore,Q.fielded as Qfielded, S.Fielded as Sfielded, H.Fielded as Hfielded');
    SQL.add('from ::PRIV::sel_Qstns SQ, ::Question::Questions Q, ::Question::Scales S, ::Question::Headings H');
    SQL.add('where (SQ.Subtype=1 and SQ.QstnCore=Q.Core and Q.Scale=S.Scale and Q.HeadID=H.HeadID)');
    SQL.add('  and (Q.Fielded=0 or S.fielded=0 or H.fielded=0)');
    open;
    while not eof do begin
      if dqdatamodule.wwt_questions.findkey([wwt_QstnsQstnCore.value]) then begin
        if fieldbyname('Qfielded').value <> 0 then begin
          DQDataModule.wwt_questions.edit;
          DQDataModule.wwt_questionsfielded.Value := 1;
          DQDataModule.wwt_questions.post;
        end;
        if fieldbyname('Sfielded').value <> 0 then begin
          DQDataModule.wwt_Scales.edit;
          DQDataModule.wwt_Scalesfielded.Value := 1;
          DQDataModule.wwt_Scales.post;
        end;
        if fieldbyname('Hfielded').value <> 0 then begin
          DQDataModule.wwt_Headings.edit;
          DQDataModule.wwt_HeadingsFielded.Value := 1;
          DQDataModule.wwt_Headings.post;
        end;
      end;
      next;
    end;
    close;
  end;
  with DQDataModule.wwt_Questions do begin
    if orgIndex <> 'Core' then indexfieldnames := orgIndex;
    if OrgFilter then filtered := true;
    GotoBookmark(SavePlace);
    FreeBookmark(SavePlace);
    EnableControls;
  end;
end;

procedure TDMOpenQ.CheckAgainstLibrary;
{NOTE: Joe said he didn't want to give the user any options when updating the survey.
  This procedure was originally written to give the users some options (such as
  keeping non-standard headers, etc.)  I left the messagedlg's etc. in the code, but
  just commented them out with a "//opt:" at the beginning of the line.  Should we
  need to give the users some options in the future, remove any references to errorlist
  and uncomment the //opt: lines. }

var LanguageList : string;
    CheckScale : tSmallIntArray;
    AllOK : byte;
  function MyMessageDlg(const Msg: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
  begin
    if AllOK = mrNone then begin
      if messagedlg('There is at least one header, question or scale that doesn''t match the library.  '+
         'Do you want to correct all differences?  (Press "No" if you''d like to be asked about each item.)',
         mtConfirmation,[mbyes,mbno],0) = mrYes then begin
        allOK := mrYesToAll;
        wwt_Qstns.disablecontrols;
      end else
        allOK := mrNo;
    end;
    if AllOK = mrYesToAll then begin
      if aType = mtConfirmation then
        result := mrYes
      else
        result := mrOK;
    end else
      result := Messagedlg(msg,atype,abuttons,helpctx);
  end;
  procedure CheckHeaders;
  var HeaderList : string;
  begin
    localquery('select distinct qstncore from sel_qstns where subtype=2',false);
    HeaderList := '(';
    while not ww_query.eof do begin
      HeaderList := HeaderList + ww_query.fieldbyname('qstncore').asstring + ',';
      ww_query.next;
    end;
    if headerlist <> '(' then begin
      HeaderList := copy(HeaderList,1,length(HeaderList)-1) + ') ';
      LibQuery('Select headid as qstncore, langid as language, text as richtext '+
          'from headtext '+
          'where headid in ' + HeaderList +
          ' and langid in ' + LanguageList,false);
      with wwt_Qstns do begin
        first;
        while not eof do begin
          if (wwt_QstnsSection.value>0) and (wwt_QstnsSubtype.value=2) then begin
            if ww_Query.Locate('QstnCore;Language', VarArrayOf([wwT_QstnsQstnCore.value,wwT_QstnsLanguage.value]),[]) then begin
              if wwt_qstnsrichtext.asString = tBlobField(ww_query.fieldbyname('RichText')).asString then begin
                {everything matches}
              end else begin
                {RichText doesn't match}
                //opt: if mrYes = mymessagedlg('Header text for "'+wwt_QstnsLabel.AsString+'" doesn''t match the Library.  Do you want to use the Library entry?',mtConfirmation,[mbYes,mbNo],0) then begin
                errorlist.add('Header text for "'+wwt_QstnsLabel.AsString+'"');
                  wwt_Qstns.edit;
                  tBlobField(ww_query.fieldbyname('RichText')).savetofile(tempdir+'\richtext.rtf');
                  wwt_Qstnsrichtext.loadfromfile(tempdir+'\richtext.rtf');
                  wwt_qstns.post;
                //opt: end;
              end;
            end else begin
              {Can't find header in the library}
            end;
          end;
          next;
        end;
        first;
      end;
    end;
  end;
  procedure CheckQuestions;


  type
  rQProp = record
     Section_id:integer;
     SubSection:integer;
     QstnCore:integer;
     QstnsID:integer;
     Head_id:integer;
     HeadLabel:string;
     HeadText:string;
     Language:integer;
  end;
  tQprop = ^rQProp;

  var s,CoreList : string;
      OKmeanable, OKlabel, OKrichtext, OKscaleid, OKheadID, OKnumMarkCount, OKScalePos : boolean;
      //opt: OptionalUpdate : boolean;
      curHeader : integer;
      QList:tlist;
      bm:Tbookmark;
      NewSS:integer;
  begin
    localquery('select distinct qstncore from sel_qstns where subtype=1',false);
    CoreList := '(';
    QList:=tlist.Create;
    while not ww_query.eof do begin
      CoreList := CoreList + ww_query.fieldbyname('qstncore').asstring + ',';
      ww_query.next;
    end;
    if CoreList <> '(' then begin
      CoreList := copy(CoreList,1,length(CoreList)-1) + ') ';
      LibQuery('select q.core as qstncore, qt.langid as language, q.short as label, qt.text as richtext, '+
          ' q.scale as scaleid, q.headid as HeadID, s.MarkCount as numMarkCount, '+
          'h.name as HeadLabel, ht.Text as HeadText, s.* '+
          'from questions q, questiontext qt, scales s, Headings h,HeadText ht '+
          'where q.core=qt.core '+
          '  and q.scale=s.scale '+
          '  and q.HeadId=h.HeadId '+
          '  and q.HeadId=ht.HeadId '+
          '  and q.core in ' + corelist +
          '  and qt.langid in ' + languagelist,false);
      with wwt_Qstns do begin

        first;
        curHeader := 0;
        while not eof do begin
          if (wwt_QstnsSection.value>0) and (wwt_QstnsSubtype.value=2) then begin
            curHeader := wwt_QstnsQstncore.AsInteger;
          end; 
          if (wwt_QstnsSection.value>0) and (wwt_QstnsSubtype.value=1) then begin
            if ww_Query.Locate('QstnCore;Language', VarArrayOf([wwT_QstnsQstnCore.value,wwT_QstnsLanguage.value]),[]) then begin
              OKlabel := (trim(wwt_QstnsLabel.asstring) = trim(ww_Query.fieldbyname('label').asstring));
              OKrichtext := (wwt_qstnsrichtext.asString = tBlobField(ww_query.fieldbyname('RichText')).asString);
              OKscaleid := (wwt_QstnsScaleid.AsInteger = ww_Query.fieldbyname('Scaleid').asinteger);
              OKscalePos := (wwt_QstnsScalePos.AsInteger in[spRight,spBelow,spBelow2,spBelow3]) ;
              OKheadID := (curHeader = ww_Query.fieldbyname('headid').asinteger);
              OKnumMarkCount := (wwt_qstnsnumMarkCount.AsInteger = ww_Query.fieldbyname('numMarkCount').asinteger);
              OKmeanable := (wwt_qstnsbitmeanable.AsBoolean = ww_Query.fieldbyname('mean').asboolean);
              if OKlabel and OKrichtext and OKscaleid and OKheadID and OKnumMarkCount and OKScalePos and OKmeanable then begin
                {everything matches}
              end else begin
                if not okHeadID then begin
                  qList.Add(new(tqprop));
                  with tqprop(qlist.Last)^ do begin
                    Section_id :=wwt_QstnsSection.value;
                    SubSection := wwT_QstnsSubsection.value;
                    QstnCore := wwT_QstnsQstnCore.value;
                    QstnsID  := wwt_QstnsID.value;
                    Head_id  := ww_Query.fieldbyname('headid').asinteger;
                    HeadText := tBlobField(ww_Query.fieldbyname('HeadText')).asstring;
                    HeadLabel := trim(ww_Query.fieldbyname('HeadLabel').asstring);
                    Language := wwT_QstnsLanguage.value;
                  end;
                end;

                s := '';
                if (not okScaleID) or (not oknumMarkCount) or (not oKScalePos) then begin
                  //opt: s := 'The following properties of "'+wwt_qstnsLabel.asstring+'" don''t match the Library:' + chr(13) + '     ';
                  if not okScaleID then begin
                    s := s + 'Assigned Scale, ';
                    CheckScale.add(ww_Query.fieldbyname('Scaleid').asinteger);
                  end;
                  if not oknumMarkCount then s := s + 'Multi-respone setting, ';
                  if not OKScalePos then s := s + 'Scale position, ';
                  //opt: s := copy(s,1,length(s)-2) + chr(13) + 'They will now be corrected to match the library.';
                  //opt: mymessagedlg(s,mtinformation,[mbok],0);
                end;

                {GN02
                if (not OKmeanable) then begin
                   s:=s+'Meanable Flag, ';
                end;}

                //opt: OptionalUpdate := false;
                if (not oklabel) or (not okRichText) then begin
                  //opt: s := 'The following properties of "'+wwt_qstnsLabel.asstring+'" don''t match the Library:' + chr(13) + '     ';
                  if not OKlabel then s := s + 'Report Text, ';
                  if not OKRichtext then s := s + 'Survey Text, ';
                  //opt: s := copy(s,1,length(s)-2) + chr(13) + 'Do you want to correct them?';
                  //opt: OptionalUpdate := (mymessagedlg(s,mtconfirmation,[mbyes,mbno],0) = mrYes);
                end;

                if s <> '' then  begin
                  s := copy(s,1,length(s)-2);
                  errorlist.add( s + ' for "'+wwt_qstnsLabel.asstring+'" ('+wwT_QstnsQstnCore.asstring+')');
                end;

                //opt: if (OptionalUpdate) or (not okScaleID) or (not oknumMarkCount) then begin
                if (not okLabel) or (not okRichText) or (not okScaleID) or (not oknumMarkCount) or (not okScalePos) or (not OKmeanable) then begin
                  wwt_qstns.Edit;
                  //opt: if OptionalUpdate then begin
                    if not OKLabel then
                      wwt_QstnsLabel.Value := ww_Query.fieldbyname('label').asstring;
                    if (not okrichtext) then begin
                      tBlobField(ww_query.fieldbyname('RichText')).savetofile(tempdir+'\richtext.rtf');
                      wwt_Qstnsrichtext.loadfromfile(tempdir+'\richtext.rtf');
                    end;
                  //opt: end;
                  wwt_qstnsbitmeanable.AsBoolean := ww_Query.fieldbyname('mean').asboolean;
                  wwt_QstnsScaleid.value := ww_Query.fieldbyname('Scaleid').asinteger;
                  wwt_qstnsnumMarkCount.value := ww_Query.fieldbyname('numMarkCount').asinteger;
                  if not OKScalePos then begin
                    if ww_Query.fieldbyname('right').value then
                      wwt_QstnsScalePos.value := spRight
                    else
                      wwt_QstnsScalePos.value := spBelow;
                  end;
                  wwt_qstns.post;
                end;
              end;
            end else begin
              {Can't find question in the library}
            end;
          end;
          next;
        end;
        if qlist.Count >0 then
          errorlist.add('The following questions don''t use the same header as defined in the library and  were moved to a new subsection.');
        While qlist.Count > 0 do begin
          with tqprop(qlist.Items[0])^ do begin
            NewSS:=0;
            //locate the QstnsID
            if (locate('SelQstns_ID;Language;Section_id;subtype', VarArrayOf([QstnsID,Language,Section_id,1]),[])) then begin
              bm := GetBookmark;
              //move to existint subsection if it already exists under same section
              if (locate('QstnCore;Language;Section_id;subtype', VarArrayOf([Head_id,Language,Section_id,2]),[])) then
              else begin
                AddSubsection(HeadLabel,true); //add a new subsection with NewHeaderLabel if it does not exist
                bm := GetBookmark; //GN13, the bookmark has changed
                edit;
                wwT_QstnsRichText.AsString  := HeadText;
                wwt_QstnsQstnCore.value := Head_id;
                post;
              end;
              NewSS := wwT_QstnsSubsection.value;

              gotobookmark(bm);
              edit;
              wwT_QstnsSubsection.value := NewSS;
              post;
              errorlist.add('    "'+wwt_qstnsLabel.asstring+'" ('+wwT_QstnsQstnCore.asstring+').  Moved to: "'+HeadLabel+'"');
            end;
          end;
          Dispose(qlist.Items[0]);
          qlist.Delete(0);
        end;
        qlist.free;
        first;
      end;
    end;
  end;
  procedure CheckScales;
  var s,ScaleList : string;
      i : integer;
      OKmean,OKlabel, OKrichtext, OKval, OKmissing : boolean;
      sid,mni,mxi,mnv,mxv,c : integer;
  begin
    if CheckScale.count > 0 then
      for i := 0 to CheckScale.count-1 do begin
        LocalQuery('Select distinct qpc_ID from sel_scls where qpc_id = '+inttostr(CheckScale[i]),false);
        if ww_Query.EOF then
          AddScale(CheckScale[i]);
      end;
    CheckScale.Clear;
    localquery('select distinct qpc_id from sel_scls',false);
    ScaleList := '(';
    while not ww_query.eof do begin
      ScaleList := ScaleList + ww_query.fieldbyname('qpc_id').asstring + ',';
      ww_query.next;
    end;
    if ScaleList <> '(' then begin
      ScaleList := copy(ScaleList,1,length(ScaleList)-1) + ') ';
      LibQuery('select sv.scale,sv.item,st.langid,s.label,sv.bubblevalue,sv.short,sv.missing,st.text,s.mean '+
          'from scalevalues sv, scaletext st, scales s '+
          'where sv.scale=st.scale '+
          '  and sv.item=st.item '+
          '  and sv.scale=s.scale '+
          '  and sv.scale in ' + scalelist +
          '  and st.langid in '+languagelist,false);
      with wwt_Scls do begin
        filtered := false;
        first;
        s := '';
        while not eof do begin
          if ww_Query.Locate('Scale;Item;LangID', VarArrayOf([wwT_SclsID.value,wwt_sclsItem.value,wwT_sclsLanguage.value]),[]) then begin
            OKlabel := (wwt_sclsLabel.asstring = ww_Query.fieldbyname('short').asstring);
            //if Pos('print', wwt_sclsrichtext.asString) > 0 then         //gntest
              //ShowMessage('Found hand entry' + wwt_sclsrichtext.asString);
            OKrichtext := (wwt_sclsrichtext.asString = tBlobField(ww_query.fieldbyname('text')).asString);
            OKmissing := (wwt_sclsmissing.Asboolean = ww_Query.fieldbyname('missing').asboolean);
            OKval := (wwt_sclsVal.AsInteger = ww_Query.fieldbyname('bubblevalue').asinteger);
            if OKlabel and OKrichtext and okMissing and okVal then begin
              {everything matches}
            end else begin
              i := wwt_SclsID.asinteger;
              if checkscale.indexof(i)=-1 then begin
                //opt: s := s + chr(13)+'     '+ww_Query.fieldbyname('label').asstring;
                errorlist.add('Scale "'+ww_Query.fieldbyname('label').asstring+'"');
                CheckScale.add(wwT_SclsID.value);
              end;
            end;
          end else begin
            {Can't find scale in the library}
            i := wwt_SclsID.asinteger;
            if checkscale.indexof(i)=-1 then begin
              //opt s := s + chr(13)+'     scale #' + wwt_sclsid.asstring;
              errorlist.add('Scale #'+wwt_sclsid.asstring);
              CheckScale.add(wwT_SclsID.value);
            end;
          end;
          next;
        end;
        filtered := true;
        first;
      end;
    end;

    localquery('select ''L'' as db, scale as qpc_id, min(item) as minitem, max(item) as maxitem, min(bubblevalue) as minval, max(bubblevalue) as maxval, count(*) as cnt '+
        'from ::question::scalevalues '+
        'where scale in ' + scalelist + ' ' +
        'group by scale '+
        'union '+
        'select ''S'' as db, qpc_id, min(item) as minitem, max(item) as maxitem, min(val) as minval, max(val) as maxval, count(*) as cnt '+
        'from sel_scls '+
        'where language=1 '+
        'group by qpc_id '+
        'order by qpc_id',false);
    while not ww_Query.eof do begin
      sid := ww_Query.fieldbyname('qpc_id').asinteger;
      mni := ww_Query.fieldbyname('minitem').asinteger;
      mxi := ww_Query.fieldbyname('maxitem').asinteger;
      mnv := ww_Query.fieldbyname('minval').asinteger;
      mxv := ww_Query.fieldbyname('maxval').asinteger;
      c := ww_Query.fieldbyname('cnt').asinteger;
      ww_Query.next;
      if (ww_Query.eof) or (sid <> ww_Query.fieldbyname('qpc_id').asinteger) then begin
        if checkscale.indexof(sid)=-1 then begin
          CheckScale.add(sid);
          //opt: s := s + chr(13)+'     scale #' + inttostr(sid);
          errorlist.add('Scale #'+wwt_sclsid.asstring);
        end;
      end else begin
        if (mni <> ww_Query.fieldbyname('minitem').asinteger) or
           (mxi <> ww_Query.fieldbyname('maxitem').asinteger) or
           (mnv <> ww_Query.fieldbyname('minval').asinteger) or
           (mxv <> ww_Query.fieldbyname('maxval').asinteger) or
           (c <> ww_Query.fieldbyname('cnt').asinteger) then begin
          if checkscale.indexof(sid)=-1 then begin
            CheckScale.add(sid);
            //opt: s := s + chr(13)+'     scale #' + inttostr(sid);
            errorlist.add('Scale #'+inttostr(sid));
          end;
        end;
        ww_Query.next;
      end;
    end;
    if CheckScale.count > 0 then begin
      //opt: s := 'The following scales did not match the library and will be corrected:' + s;
      //opt: mymessagedlg(s,mtinformation,[mbok],0);
      for i := 0 to checkscale.count-1 do begin
        cn.execute('delete from sel_scls where qpc_id = ' + inttostr(checkscale[i]));
        addscale(checkscale[i]);
      end;
      ValidateTranslation;//GN05
    end;
  end;
begin
  if not DQDataModule.wwT_ScaleValues.active then dqdatamodule.wwT_ScaleValues.open;
  LocalQuery('select distinct language from Sel_Qstns where subtype in (1,2)',false);
  with ww_Query do begin
    LanguageList := '(';
    while not eof do begin
      LanguageList := LanguageList + fieldbyname('language').asstring + ',';
      next;
    end;
  end;
  wwt_Qstns.DisableControls;
  wwt_Qstns.filtered := false;
  errorlist.clear;
  errorlist.add('The following items did not match the library and have been updated:');
  LanguageList := copy(LanguageList,1,length(LanguageList)-1) + ') ';
  CheckScale := tSmallIntArray.create(10,2);
  CheckScale.SortOrder := TS_ASCENDING;
  AllOK := mrNone;
  CheckHeaders;
  CheckQuestions;
  CheckScales;
  CheckScale.free;
  wwt_Qstns.Filtered := true;
  wwt_QstnsEnableControlsDammit;
  wwt_Qstns.first;
  if errorlist.count>1 then begin
    frmInvalid := TfrmInvalid.Create( Self );
    {GN08
    if not laptop then begin
      QPQuery(
        'select strParam_value + '''+inttostr(glbSurveyID)+'_'' + convert(varchar,getdate(),10) + ''_'' + convert(varchar,employee_id) as strFileName ' +
        'from QualPro_Params, employee e '+
        'where strParam_nm=''TemplateLoadReport'' '+
        '  and e.strNTLogin_nm='''+getuser()+'''',false);
      if not ww_Query.eof then
        dmopenq.errorlist.SaveToFile(ww_Query.fieldbyname('strFileName').asstring+'.txt');
      ww_Query.close;
    end;}
    with frmInvalid do
    try
      caption := 'Survey has been updated to match library!';
      Memo1.lines.clear;
      memo1.lines.Add('Loaded ' + opendialog.filename);
      Memo1.lines.addstrings(dmopenq.errorlist);
      ShowModal;
    finally
      Release;
    end;
  end;
  errorlist.clear;
end;

procedure TDMOpenQ.CheckItemNumbering;
var thissection,thissubsection,thisitem,thisid,i, thismaxsubsect, cnt: integer;
    ww_Query: TwwQuery;
    s:string;

  procedure LocalQuery(const Qry:string; const Exe:boolean);
  begin
    try
      if EXE then begin
        with TWWQuery.Create(self) do
          try
            close;
            databasename := '_Priv';
            sql.clear;
            sql.add(qry);
            ExecSQL;
          finally
            free;
          end;
      end else
        with ww_Query do begin
          close;
          databasename := '_Priv';
          sql.clear;
          sql.add(qry);
          open;
        end;
    except
  {$IFDEF FormLayout}
      on e:exception do
        messagedlg('CheckItemNumbering.LocalQuery: '+e.message+#13+qry,mterror,[mbok],0);
  {$ENDIF}
    end;
  end;

begin
  ww_Query := TwwQuery.Create(self);

  localQuery('select section_id, subsection,item,count(*) as cnt, max(selqstns_id) as selqstns_id '+
     'from sel_qstns '+
     'where language=1 ' +
     'group by section_id, subsection,item ' +
     'having count(*)>1',false);
  while ww_Query.RecordCount>0 do begin
    thissection := ww_Query.fieldbyname('section_id').asinteger;
    thissubsection := ww_Query.fieldbyname('subsection').asinteger;
    thisitem := ww_Query.fieldbyname('item').asinteger;
    thisid := ww_Query.fieldbyname('selqstns_id').asinteger;
    with wwT_Qstns do begin
      indexname := 'BySection';
      if findkey([thissection,thissubsection,thisitem]) then begin
        indexfieldname := 'Survey_ID;SelQstns_Id';
        filtered := false;
        first;
        while not wwt_qstns.eof do begin
          if (wwt_QstnsSection.value = thisSection) and
             (wwt_QstnsSubsection.value = thisSubsection) and
             ((wwt_QstnsItem.value>thisitem) or (wwt_QstnsID.value=thisid)) then begin
            wwt_qstns.edit;
            wwt_Qstnsitem.value := succ(wwt_Qstnsitem.value);
            wwt_qstns.post;
          end;
          wwt_qstns.next;
        end;
        filtered := true;
        IndexName := 'BySection';
      end else begin
        ww_Query.close;
        exit;
      end;
      {
      localquery('update sel_qstns set item=item+1 where section_id='+inttostr(thissection)+
        ' and subsection='+inttostr(thissubsection)+
        ' and (item>'+inttostr(thisitem)+' or selqstns_id='+inttostr(thisid)+')',true);
      }
    end;
    ww_Query.close;
    ww_Query.open;
  end;
  ww_Query.close;
  localQuery('select section_id, subsection,min(item) as minitem, max(item) as maxitem,count(*) as cnt '+
     'from sel_qstns '+
     'where language=1 '+
     'and item>0 '+
     'group by section_id, subsection '+
     'having max(item)<>count(*)',false);
  while not ww_Query.eof do begin
    thissection := ww_Query.fieldbyname('section_id').asinteger;
    thissubsection := ww_Query.fieldbyname('subsection').asinteger;
    thisitem := ww_Query.fieldbyname('minitem').asinteger;
    with wwT_Qstns do begin
      indexname := 'BySection';
      i := 0;
      while thisitem<=26 do begin
        if findkey([thissection,thissubsection,thisitem]) then begin
          inc(i);
          if i <> thisitem then
             localquery('update sel_qstns set item='+inttostr(i)+' '+
                 'where section_id='+inttostr(thissection)+' '+
                 'and subsection='+inttostr(thissubsection)+' '+
                 'and item='+inttostr(thisitem),true);
        end;
        inc(thisitem);
      end;
    end;
    ww_Query.Next;
  end;

  localQuery('select section_id, min(subsection) as minsubsection, max(subsection) as maxsubsection,count(*) as cnt '+
     'from sel_qstns '+
     'where language=1 '+
     'and subsection>0 '+
     'and subtype=2 '+
     'group by section_id '+
     'having max(subsection)<>count(*)',false);
  while not ww_Query.eof do begin
    thissection := ww_Query.fieldbyname('section_id').asinteger;
    thissubsection := ww_Query.fieldbyname('minsubsection').asinteger;
    thismaxsubsect := ww_Query.fieldbyname('maxsubsection').asinteger;
    cnt            := ww_Query.fieldbyname('cnt').asinteger;
    if cnt > thismaxsubsect then thismaxsubsect := cnt;
    with wwT_Qstns do begin
      indexname := 'BySection';
      i := 0;
      //GN07: while thissubsection<=26 do begin
      while thissubsection<= thismaxsubsect do begin
        if findkey([thissection,thissubsection]) then begin
          inc(i);
          if i <> thissubsection then
             localquery('update sel_qstns set subsection='+inttostr(i)+' '+
                 'where section_id='+inttostr(thissection)+' '+
                 'and subsection='+inttostr(thissubsection),true);
        end;
        inc(thissubsection);
      end;
    end;
    ww_Query.Next;
  end;
  ww_Query.close;
  ww_Query.free;
end;

procedure TDMOpenQ.OpenSurvey(template:string);
var s : string;
    zExeName : array[0..255] of char;
    Ext,WildFilename:string;
    src,dest:string;
    srcDir:string;
    destDir:string;
begin
UnMapAllSections := false;
  DeletedAddedSections := false;
if template = '' then begin
    OpenDialog.FileName := '';
    OpenDialog.InitialDir := GetPath('Load Template');
    if OpenDialog.Execute then
       Template := OpenDialog.FileName
    else
     exit;
  end
  else
    OpenDialog.FileName := template;

  srcDir := ExtractFilePath(Template);
  OpenDialog.InitialDir := srcDir;

  SetPath('Load Template', srcDir);
  OpenFileName := ExtractFileName(Template);

  Ext:= '';
  WildFilename := OpenFileName;
  Ext := ExtractFileExt(Template);
  if Ext <> '' then  begin
    SetLength(WildFilename,Pos(Ext,WildFileName));
    WildFilename := WildFilename +'*';
  end;

  DestDir := trim(TempDir);
  if DestDir <> '' then
     if DestDir[length(DestDir)] <> '\' then
       DestDir := DestDir + '\';

  Template := DestDir + OpenFileName;

  src := srcDir+WildFileName;
  dest := DestDir;

  if uppercase(srcDir) <> uppercase(DestDir) then
     CopyFiles(src+#0#0,dest+#0#0);

  OpenFileName := Template;

  if (template<>'') and SurveyDB(template) then begin
    CloseSurvey;
    if SaveDialog.Tag = 1 then
      if (DQDataModule.numOpened<1) or (template<>'') then
        with F_DynaQ do begin
          inc(DQDataModule.numOpened);
          Screen.cursor := crHourglass;
          myMessage('Opening "'+extractfilename(opendialog.filename)+'"');
          ProgressBar.Position := 0;
          ProgressBar.left := StatusPanel.Width - 160;
          ProgressBar.Visible := true;
          CreateProblemScoreTable;
          OpenAllTables;
          CheckQstnFieldedFlags;
          CheckAgainstLibrary;
          CheckItemNumbering;
          GetProblemScores;
          myMessage('');
          ProgressBar.Visible := false;
          ProgressBar.Position := 0;
          Screen.cursor := crDefault;
          if laptop then
            f_DynaQ.caption := 'QualPro Form Layout - ' + opendialog.filename;

          SetPath('Load Template', ExtractFilePath(OpenDialog.Filename));
        end
      else begin
        s := application.exeName + ' ';
        s := s + '"' + opendialog.filename + '" ';
        s := s + inttostr(glbSurveyID) + ' ';
        s := s + '"' + session.netfiledir + '" ';
        if DQDataModule.cmdLineLaptop then
          s := s + '/L'
        else
          s := s + '/D';
        winExec(strpcopy(zExeName,s),sw_shownormal);
        F_DynaQ.Close;
      end;
    OpenDateTime := now;
  end else
    messagedlg('That file doesn''t appear to be a QualiSys Survey.', mtError, [mbOK], 0);

end;

procedure tdmOpenQ.CloseSurvey;
var SaveMe : word;
begin
  if SaveDialog.Tag = 2 then begin
    SaveMe := messagedlg('The survey has changed.  Do you want to save it?',mtconfirmation,mbyesnocancel,0);
    if SaveMe = mrYes then begin
      if laptop then
        SaveSurveyAs
      else
        SaveSQLSurvey(false,true);
    end else if SaveMe = mrNo then SaveDialog.Tag := 1;
  end;
end;

procedure tdmOpenQ.NewSurvey;
begin
  CloseSurvey;
  UnMapAllSections := false;
  DeletedAddedSections := false;
  if SaveDialog.Tag = 1 then begin
    with tmptbl do begin
      close;
      DatabaseName := '_PRIV';
      TableName := 'MTSurv.db';
      TableDef(tmptbl,F,true);
      Active := True;
      {Section -1 defn}
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('ID').value := 1;
      fieldbyname('Type').text := 'Question';
      fieldbyname('Section').value := -1;
      fieldbyname('Subsection').value := 0;
      fieldbyname('Item').value := 0;
      fieldbyname('Label').text := 'Address and FOUO information';
      fieldbyname('PlusMinus').text := '*';
      fieldbyname('X').value := stSection;
      fieldbyname('Y').value := 0;
      fieldbyname('MiscBool1').value := false;
      fieldbyname('MiscBool2').value := false;
      fieldbyname('MiscInt1').value := 0;
      fieldbyname('Language').value := 1;
      fieldbyname('RichText').asstring :=
        '{\rtf1\ansi\deff0\deftab720{\fonttbl{\f4\fswiss\fcharset1 Arial;}{\f6\fswiss\fcharset1 Arial Narrow;}}'+
        '{\colortbl\red0\green0\blue0;\red0\green128\blue0;}'+
        '\deflang1033\pard\plain\f4\fs22\cf0 ·\plain\f6\fs20\cf0 ·\plain\f4\fs20\cf0 \par }';
      post;
      {Address tags}
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('ID').value := 2;
      fieldbyname('Type').text := 'Question';
      fieldbyname('Section').value := -1;
      fieldbyname('Subsection').value := 1;
      fieldbyname('Item').value := 0;
      fieldbyname('Label').text := 'Address information';
      fieldbyname('PlusMinus').text := '*';
      fieldbyname('X').value := stAddress;
      fieldbyname('Y').value := 0;
      fieldbyname('MiscBool1').value := false;
      fieldbyname('MiscBool2').value := false;
      fieldbyname('MiscInt1').value := 0;
      fieldbyname('Language').value := 1;
      fieldbyname('RichText').asstring :=
        '{\rtf1\ansi\deff0\deftab720'#10+
        '{\fonttbl{\f4\fswiss\fcharset1 Arial;}}'#10+
        '{\colortbl\red0\green0\blue0;\red0\green128\blue0;}'#10+
        '\deflang1033\pard\plain\f4\fs22\cf1\protect \{31\}\plain\f4\fs22\cf0'#10+
        '\par \plain\f4\fs22\cf1\protect \{33\}\plain\f4\fs22\cf0'#10+
        '\par \plain\f4\fs22\cf1\protect \{28\}\{29\}\plain\f4\fs22\cf0'#10+
        //'\par \plain\f4\fs22\cf1\protect \{29\}\plain\f4\fs22\cf0'#10+
        //addrStreet2:// '\par \plain\f4\fs22\cf1\protect \{29\}\plain\f4\fs22\cf0'+#10+
        '\par \plain\f4\fs22\cf1\protect \{30\}\plain\f4\fs22\cf0'#10+
        '\par }';
      post;
      {FOUO tags}
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('ID').value := 3;
      fieldbyname('Type').text := 'Question';
      fieldbyname('Section').value := -1;
      fieldbyname('Subsection').value := 2;
      fieldbyname('Item').value := 0;
      fieldbyname('Label').text := 'FOUO information';
      fieldbyname('PlusMinus').text := '*';
      fieldbyname('X').value := stFOUO;
      fieldbyname('Y').value := 0;
      fieldbyname('MiscBool1').value := false;
      fieldbyname('MiscBool2').value := false;
      fieldbyname('MiscInt1').value := 0;
      fieldbyname('Language').value := 1;
      fieldbyname('RichText').asstring := '';
      post;
      {Section 1 defn}
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('ID').value := 4;
      fieldbyname('Type').text := 'Question';
      fieldbyname('Section').value := 1;
      fieldbyname('Subsection').value := 0;
      fieldbyname('Item').value := 0;
      fieldbyname('Label').text := 'Section 1';
      fieldbyname('PlusMinus').text := '-';
      fieldbyname('X').value := stSection;
      fieldbyname('Y').value := 0;
      fieldbyname('MiscBool1').value := false;
      fieldbyname('MiscBool2').value := false;
      fieldbyname('MiscInt1').value := 0;
      fieldbyname('Language').value := 1;
      fieldbyname('RichText').asstring := '';
      post;
      {Cover 1 defn}
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('ID').value := 0+1{};
      fieldbyname('Type').text := 'Cover';
      fieldbyname('Label').text := '1st Survey Cover';
      fieldbyname('Section').value := 1;
      fieldbyname('MiscBool1').asBoolean := true;
      fieldbyname('MiscBool2').asBoolean := false;
      post;
      close;
    end;
    OpenDialog.filename := tempdir+'\MTSurv.db';
    OpenFileName := OpenDialog.filename;
    CreateProblemScoreTable;
    OpenAllTables;
    OpenDialog.Filename := '';
    SaveDialog.Filename := '';
    OpenFileName := '';
    SaveFileName := '';
  end;
end;

procedure tdmOpenQ.AssignCmntBoxNums;
var num:integer;
    orgfilt :boolean;
begin
  num := 0;
  with wwt_Qstns do begin
    disablecontrols;
    orgfilt := filtered;
    filtered := false;
    first;
    while not eof do begin
      if (wwt_QstnsSubtype.value=stComment) and (wwt_QstnsHeight.value>0) then begin
        inc(num);
        edit;
        wwt_QstnsQstnCore.value := num;
        post;
      end;
      next;
    end;
    filtered := orgfilt;
    enablecontrols;
  end;
end;

procedure tdmOpenQ.SaveSurvey;
  procedure MoveFlds(DQType:TDQTableType;var tbl:twwTable);
  var orgfiltered : boolean;
  begin
    with F_DynaQ.ProgressBar do
      Position := Position + 12;
    orgFiltered := tbl.filtered;
    tbl.filtered := false;
    with batchmove do begin
      source := tbl;
      mappings.clear;
      with wwT_TableDef do begin
        first;
        while not eof do begin
          if trim(fieldbyname(typeString(DQType)).value)<>'' then
            if fieldbyname('Full').text <> fieldbyname(typeString(DQType)).text then
              mappings.add(fieldbyname('Full').text + '=' + fieldbyname(typeString(DQType)).text)
            else
              mappings.add(fieldbyname('Full').text);
          next;
        end;
      end;
      execute;
    end;
    tbl.filtered := orgFiltered;
  end;
var pc : pchar;
begin

  if (SaveDialog.Filename = '') then begin
    SaveDialog.InitialDir := trim(GetPath('Save Template'));
    if SaveDialog.Execute then begin
      SetPath('Save Template', ExtractFilePath(SaveDialog.Filename));
      OpenFileName := ExtractFileName(SaveDialog.Filename);
    end;
  end;

  if (SaveDialog.Filename <> '') then begin
    pc := pchar(SaveDialog.Filename);
    //getshortpathname(pchar(SaveDialog.Filename),pc,length(SaveDialog.Filename));
    with tmptbl do begin
      Close;
      DatabaseName := ExtractFilePath(pc);
      TableName := ExtractFileName(pc);
      TableDef(tmptbl,F,true);
      open;
    end;
    with F_DynaQ do begin
      Screen.cursor := crHourglass;
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'"');
      ProgressBar.Position := 14;
      ProgressBar.left := StatusPanel.Width - 160;
      ProgressBar.Visible := true;
      wwt_QstnsUpdateLangInfo;
      AssignCmntBoxNums;
      BatchMove.destination := tmptbl;
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" Questions');
      MoveFlds(Q,wwt_Qstns);
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" Scales');
      MoveFlds(S,wwT_Scls);
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" Skip Patterns');
      MoveFlds(K,wwT_Skip);
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" Logos && Signatures');
      MoveFlds(L,wwT_Logo);
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" Text Boxes');
      cn.execute('delete from sel_TextBox where Type is null');
      MoveFlds(T,wwT_TextBox);
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" PCL Inserts');
      MoveFlds(P,wwT_PCL);
      myMessage('Saving "'+extractfilename(Savedialog.filename)+'" Cover Letters && Postcards');
      MoveFlds(C,wwT_Cover);
      myMessage('');
      ProgressBar.Visible := false;
      ProgressBar.Position := 0;
      Screen.cursor := crDefault;
    end;
    SaveDialog.Tag := 1;
    tmptbl.Close;
  end;
  UnMapAllSections := false;
  DeletedAddedSections := false;
end;

procedure TdmOpenQ.SaveSurveyAs;
begin

  SaveDialog.Filename := '';
  SaveSurvey;
  if laptop then
     f_DynaQ.caption := 'QualPro Form Layout - ' + SaveDialog.filename;
  f_DynaQ.ShowProps;
end;
{$ENDIF}

procedure TDMOpenQ.CreateProblemScoreTable;
begin
  with wwt_ProblemScores do begin
    Close;
    TableType := ttParadox;
    with FieldDefs do begin
      clear;
      add('Core',ftInteger,0,true);
      add('Val',ftInteger,0,true);
      add('Problem_Score_Flag',ftInteger,0,false);
      add('strProblemScore',ftString,20,false);
      add('Short',ftString,60,false);
      add('Transferred',ftinteger,0,false);
    end;
    indexdefs.Clear;
    indexdefs.Add('ByCoreVal','Core;Val',[ixPrimary]);
    CreateTable;
    IndexFieldNames := 'Core;Val';
  end;
end;

function TDMOpenQ.GetUserParam(const prm:string):string;
begin
  Session.AddPassword( 'Dave' );
  Session.AddPassword( '(uU\`rlvLHh4Au]' );
  result := '';
  with TTable.create(self) do begin
    try
      databasename := 'Question';
      tablename := 'Users.db';
      Open;
      if Locate('User',Prm,[]) then
        result := fieldbyname('Name').value;
      close;
    finally
      free;
    end;
  end;
  session.RemoveAllPasswords;
end;

procedure TDMOpenQ.DMOpenQCreate(Sender: TObject);
var
  UserID, PassWord : string;
{$IFDEF FormLayout}
var
  s1, s2 : string;
  loc:string;
{$ENDIF}
begin
  try
    createok := false;
    if (uppercase(wwt_LogoID.FieldName) <> uppercase(qpc_ID)) then
      wwt_LogoID.FieldName := qpc_ID;
    if (uppercase(wwt_PCLID.FieldName) <> uppercase(qpc_ID)) then
      wwt_PCLID.FieldName := qpc_ID;
    if (uppercase(wwt_TextBoxID.FieldName) <> uppercase(qpc_ID)) then
      wwt_TextBoxID.FieldName := qpc_ID;
    if (uppercase(wwt_SclsID.FieldName) <> uppercase(qpc_ID)) then
      wwt_SclsID.FieldName := qpc_ID;
    if (uppercase(wwt_QstnsSection.FieldName) <> uppercase(qpc_Section)) then
      wwt_QstnsSection.FieldName := qpc_Section;
    if (uppercase(wwt_TransSID.fieldname) <> uppercase(qpc_ID)) then
      wwt_TransSID.FieldName := qpc_ID;
    if (uppercase(wwt_TransTBID.fieldname) <> uppercase(qpc_ID)) then
      wwt_TransTBID.FieldName := qpc_ID;
    if (uppercase(wwt_TransQSection.FieldName) <> uppercase(qpc_Section)) then
      wwt_TransQSection.FieldName := qpc_Section;

    if uppercase(wwt_Scls.IndexFieldNames) <> 'SURVEY_ID;'+uppercase(qpc_ID) then
      wwt_Scls.IndexFieldNames := 'Survey_ID;'+qpc_ID;
    if uppercase(wwt_TransS.IndexFieldNames) <> 'SURVEY_ID;'+uppercase(qpc_ID)+';ITEM;LANGUAGE' then
      wwt_TransS.IndexFieldNames := 'Survey_ID;'+qpc_ID+';Item;Language';
    if uppercase(wwt_TransP.IndexFieldNames) <> 'SURVEY_ID;'+uppercase(qpc_ID)+';LANGUAGE' then
      wwt_TransP.IndexFieldNames := 'Survey_ID;'+qpc_ID+';Language';
    if uppercase(wwt_TransTB.IndexFieldNames) <> 'SURVEY_ID;'+uppercase(qpc_ID)+';LANGUAGE' then
      wwt_TransTB.IndexFieldNames := 'Survey_ID;'+qpc_ID+';Language';
    if uppercase(t_Logo_SQL.IndexFieldNames) <> uppercase(qpc_ID)+';COVERID;SURVEY_ID' then
      t_Logo_SQL.IndexFieldNames := qpc_ID+';CoverID;Survey_id';

    if uppercase(BatchMove_SelLogo.Mappings[1]) <> uppercase(qpc_id) then
      BatchMove_SelLogo.Mappings[1] := qpc_id;

      {$IFDEF FormLayout}
    if not DQDataModule.cmdLineLaptop then begin
      dbQualPro.params.add('APP=FormLayout');
      {$ELSE}
      dbQualPro.params.add('APP=PCLGen');
      dbScan.AliasName := 'Scan';
      dbScan.databasename := '_Scan';
      with dbScan.Params do begin
        clear;
        add('DATABASE NAME=');
        add('ODBC DSN=Scan');
        add('OPEN MODE=READ/WRITE');
        add('BATCH COUNT=200');
        add('LANGDRIVER=');
        add('MAX ROWS=-1');
        add('SCHEMA CACHE DIR=');
        add('SCHEMA CACHE SIZE=8');
        add('SCHEMA CACHE TIME=-1');
        add('SQLPASSTHRU MODE=SHARED AUTOCOMMIT');
        add('SQLQRYMODE=');
        add('ENABLE SCHEMA CACHE=FALSE');
        add('ENABLE BCD=FALSE');
        add('ROWSET SIZE=20');
        add('BLOBS TO CACHE=64');
        add('BLOB SIZE=32');
      end;
      dbQueue.AliasName := 'Queue';
      dbQueue.databasename := '_Queue';
      with dbQueue.Params do begin
        clear;
        add('DATABASE NAME=');
        add('ODBC DSN=Queue');
        add('OPEN MODE=READ/WRITE');
        add('BATCH COUNT=200');
        add('LANGDRIVER=');
        add('MAX ROWS=-1');
        add('SCHEMA CACHE DIR=');
        add('SCHEMA CACHE SIZE=8');
        add('SCHEMA CACHE TIME=-1');
        add('SQLPASSTHRU MODE=SHARED AUTOCOMMIT');
        add('SQLQRYMODE=');
        add('ENABLE SCHEMA CACHE=FALSE');
        add('ENABLE BCD=FALSE');
        add('ROWSET SIZE=20');
        add('BLOBS TO CACHE=64');
        add('BLOB SIZE=32');
      end;
      {$ENDIF}
      dbQualPro.params.add('WSID='+ComputerName);
      dbScan.params.add('WSID='+ComputerName);
      dbQueue.params.add('WSID='+ComputerName);
      UserID := GetUserParam('DATAMART_UID&PW');
      if UserID <> '' then begin;
        Password := UserID;
        mydelete(UserID,pos(';',UserID),length(UserID));
        mydelete(Password,1,pos(';',Password));
        dbDataMart.params.add('USER NAME='+UserID);
        dbDataMart.params.add('PASSWORD='+password);
      end;
      UserID := GetUserParam('USERID&PASSWORD');
      if UserID <> '' then begin
        Password := UserID;
        mydelete(UserID,pos(';',UserID),length(UserID));
        mydelete(Password,1,pos(';',Password));
        dbQualPro.params.add('USER NAME='+UserID);
        dbQualPro.params.add('PASSWORD='+password);
        dbScan.params.add('USER NAME='+UserID);
        dbScan.params.add('PASSWORD='+password);
        dbQueue.params.add('USER NAME='+UserID);
        dbQueue.params.add('PASSWORD='+password);
      end else
        Password := '';
      EnvName := GetUserParam('ENVIRONMENTNAME');
      if EnvName <> '' then begin
        QPQuery('select strParam_value from QualPro_params where strParam_nm=''EnvName'' and strParam_grp=''Environment''',false);
        if ww_Query.fieldbyname('strParam_value').value <> EnvName then begin
          MessageDlg('SQL Environment ('+ww_Query.fieldbyname('strParam_value').value+
              ') doesn''t match Paradox Environment ('+EnvName+').  Please '+
              'notify Tech Services.',mterror,[mbok],0);
          Application.Terminate;
        end;
        ww_Query.close;
      end else begin
        MessageDlg('Environment (ENVIRONMENTNAME) isn''t registered in Paradox '+
            'Tables.  Please notify Tech Services.',mterror,[mbok],0);
        Application.Terminate;
      end;
  {$IFDEF FormLayout}
    end;
    laptop := false;
    if DQDataModule.cmdLineLaptop then
      with dbQualPro do begin
        connected := false;
        {
        AliasName := 'QualProLocal';
        params.clear;
        params.add('PATH='+AliasPath('QualProLocal'));
        params.add('DEFAULT DRIVER=PARADOX');
        params.add('ENABLE BCD=FALSE');
        connected := true;
        t_Logo_SQL.tablename := 'Sel_Logo';
        }
        t_PCLObject.databasename := 'DataLib';
        t_PCLObject.tablename := 'PCLObject';
        Laptop := true;
      end;

    glbSurveyID:=0;
    UserID := lowercase(getuser);
    s1:=GetFileVersion(application.exename, s2);
    FormLayoutVer := s1; //GN12
    qpQuery('select STRPARAM_VALUE from QualPro_Params where STRPARAM_NM = ''FormLayoutVersion''',false);
    if (not ww_Query.eof) then
      s2 := ww_Query.fieldbyname('STRPARAM_VALUE').asstring else s2 := s1;
    ww_Query.Close;
    //s1 := s2;
    if s1<>s2 then
    begin
      if (UserID='dgilsdorf') or (UserID='cburkholder') or (UserID='jwilley') or (UserID='dpetersen') then begin
        if MessageDlg('Your version of FormLayout (v'+s1+') is outdated!'#13#10#10'Do you want to run this version anyway?.',mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
          MessageDlg('Please launch FormLayout from LaunchPad to upgrade to version '+s2+'.',mtInformation,[mbOK],0);
          exit;
        end;
      end else begin
        MessageDlg('Your version of FormLayout (v'+s1+') is outdated!'#13#10#10'Please launch FormLayout from LaunchPad to upgrade to version '+s2+'.',mtError,[mbOK],0);
        exit;
      end;
    end;

    if DQDataModule.cmdLineSurveyID = 0 then
      dmOpenQ.glbSurveyID := strtointdef(inputbox('SurveyID','Survey_ID?',''),0)
    else
      DMOpenQ.glbSurveyID := DQDataModule.cmdLineSurveyID;
    if glbSurveyID=0 then
      exit;

    glbClientid := 0;
    if not laptop then
      with ww_Query do begin
        close;
        databasename := '_QualPro';
        sql.clear;
        sql.add(format('select client_id from clientstudysurvey_view where survey_id=%d',[glbSurveyid]));
        open;
        if not eof then
          glbClientID := fieldbyname('client_id').value;
        close;
      end;

    tempdir := AliasPath('PRIV');
    ForceDirectories(tempdir); //GN06: Temporary working folder for FormLayout
    //DelDotStar(tempdir + '*.*');
    
    dbPriv.Connected := True; //GN03
    with tmptbl do begin
      DatabaseName := '_PRIV';
      TableName := 'Constants.DB';
      TableType := ttParadox;
      with FieldDefs do begin
        Clear;
        add('Constant',ftString,20,false);
        add('Value',ftString,250,false);
        add('Altered',ftinteger,0,false);
      end;
      with IndexDefs do begin
        Clear;
        Add('Consant', 'Constant', [ixPrimary]);
      end;
      //GN03: make sure the lock files(.lck) are deleted if an exception is raised.
      //If that doesn't help close Delphi and re-open
      createtable;
      batchMove(DQDataModule.T_Constants, batAppend);
      close;
    end;
    with DQDataModule.T_Constants do begin
      close;
      databasename := '_PRIV';
      open;
    end;
    if not laptop then
      with ww_Query do begin
        close;
        databasename := '_QualPro';
        sql.clear;
        sql.add('select tag.tag, tf.strReplaceLiteral');
        sql.add('from tag, tagfield tf, survey_def sd');
        sql.add('where tf.study_id=sd.study_id and');
        sql.add('  sd.survey_id='+inttostr(DMOpenQ.glbSurveyID)+' and');
        {if laptop then
          sql.add('  ((tf.strReplaceLiteral<>'''') or (tf.strReplaceLiteral<>'''')) and')
        else}
          sql.add('  ((tf.strReplaceLiteral<>'''') or (tf.strReplaceLiteral<>null)) and');
        sql.add('  tag.tag_id=tf.tag_id');
        open;
        while not eof do begin
          if DQDataModule.t_constants.locate('Constant',fieldbyname('tag').value,[loCaseInsensitive]) then begin
            DQDataModule.t_constants.edit;
            DQDataModule.t_constantsValue.value := fieldbyname('strReplaceLiteral').value;
            DQDataModule.t_constants.post;
          end;
          next;
        end;
        close;
      end;
  {$ENDIF}
  {$IFNDEF FormLayout}
    dmPCLGen.MakePopSection('PopSection.db',wwt_PopSection);
    dmPCLGen.MakePopCover('PopCover.db',wwt_PopCover);
    dmPCLGen.MakePopCode('PopCode.db',wwt_PopCode);
    {PCLGen: close BDE connection & re-establish a local .NET file}
    if dbQualPro.connected then dbQualPro.connected := false;
    if dbScan.connected then dbScan.connected := false;
    if dbQueue.connected then dbQueue.connected := false;
    if dbPriv.connected then dbPriv.connected := false;
    session.netfiledir := ExtractFilePath(application.exename);
  {$ENDIF}
//    t_Language.open;
    ConsiderDblLegal := false;
    ResponseShape := 1; {Bubbles}
    ShadingOn := true;
    CurrentLanguage := -1; {Spanish}
    SpreadToFillPages := true;
    InsertSkipArrowDoD := false;
    ExtraSpace := 0;
    FindTransUponCreate := true;
    Errorlist := tStringlist.create;
    if (not laptop) and (not dbQualPro.connected) then
      dbQualPro.connected := true;
    {$IFNDEF FormLayout}
    if (not laptop) and (not dbScan.connected) then dbScan.connected := true;
    if (not laptop) and (not dbQueue.connected) then dbQueue.connected := true;
    {$ENDIF}
    with wwt_tabledef do begin
      close;
      Databasename := '_PRIV';
      tabletype := ttParadox;
      TableName := 'TableDef.db';

  {$IFNDEF FormLayout}
      if fileexists(aliaspath('PRIV')+'\TableDef.db') then begin
        exclusive := true;
        repeat
          try
            if fileexists(aliaspath('PRIV')+'\TableDef.db') then
              open;
            close;
            exclusive := false;
          except
          end;
        until not exclusive;
      end;
  {$ENDIF}

      with FieldDefs do begin
        clear;
        add('ID',ftInteger,0,false);
        add('Full',ftString,20,false);
        add('FieldType',ftString,10,false);
        add('FieldLen',ftFloat,0,false);
        add('FieldRequired',ftBoolean,0,false);
        add('Question',ftString,20,false);
        add('Scale',ftString,20,false);
        add('Logo',ftString,20,false);
        add('TextBox',ftString,20,false);
        add('PCL',ftString,20,false);
        add('Cover',ftString,20,false);
        add('Skip',ftString,20,false);
      end;
      with IndexDefs do begin
        clear;
        Add('ByID', 'ID', [ixPrimary]);
      end;
      createTable;
      open;
    end;
    tempdir := AliasPath('PRIV'); 

    sqlCn:=CreateOleObject('ADODB.Connection');
    sqlcn.connectionstring:='DSN=Qualpro;uid=qpsa;pwd=qpsa';
    sqlcn.open;

    Cn:=CreateOleObject('ADODB.Connection');
    cn.Open('Driver={Microsoft Paradox Driver (*.db )};' +
            'DriverID=538;' +
            'Fil=Paradox 5.X;' +
            'DefaultDir='+tempdir+';' +
            'Dbq='+tempdir+';' +
            'CollatingSequence=ASCII');

    with ww_Query do begin
      close;
(* 9/24/2014 CJB We will always want to pull the TABLEDEF fields from QualPro, even in template("laptop") mode
      if laptop then begin
        Databasename := 'DataLib';
        sql.clear;
        sql.add('Select * from TableDef');
      end else begin
*)
        Databasename := '_QualPro';
        sql.clear;
        sql.add('Select '+QPC_ID+', strFull, FieldType, FieldLen, FieldRequired, Question, Scale, Logo, TextBox, PCL, Cover, '+qpc_Skip+' from TableDef');
(*
      end;
*)
      open;
      wwt_TableDef.batchMove(ww_Query, batAppend);
      localQuery('update tabledef set Scale="'+QPC_ID+'" where Scale="ID"',true);
      localQuery('update tabledef set TextBox="'+QPC_ID+'" where TextBox="ID"',true);
      localQuery('update tabledef set Logo="'+QPC_ID+'" where Logo="ID"',true);
      localQuery('update tabledef set PCL="'+QPC_ID+'" where PCL="ID"',true);
      localQuery('update tabledef set Question="'+QPC_SECTION+'" where Question="Section"',true);
    end;

    with tmptbl do begin
      Databasename := tempdir;
      tabletype := ttParadox;
      TableName := 'TBCntnts.db';
      with fielddefs do begin
        clear;
        add('ID',ftAutoInc,0,false);
        add('label',ftString,60,false);
        add('Text',ftMemo,100,false);
      end;
      indexdefs.clear;
      createtable;
      open;
      append;
      post;
      close;
    end;
    nBblLoc := 0;
    nCmntLoc := 0;
    ClipboardQuestions := false;


    createok := true;
  except
    on E:Exception do
    begin
       createok := false;
    end;

  end;
end;

procedure TDMOpenQ.wwT_QstnsFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  accept := (dataset['PlusMinus'] <> '*') and (dataset['Language']=1);
end;

{$IFDEF FormLayout}
function tDMOpenQ.QuestionProperties:boolean;
var sp : integer;
    corelist : string;
  procedure GetScalePosition;
  var i : integer;
  begin
    sp := wwt_QstnsScalePos.value;
    corelist := wwt_QstnsQstnCore.AsString;
    with f_DynaQ.wwdbgrid1 do begin
      i := 0;
      while i < SelectedList.Count do begin
        wwT_Qstns.GotoBookmark(SelectedList.items[i]);
        if wwt_QstnsSubType.value=1 then begin
          if pos(','+wwt_QstnsQstnCore.AsString+',' , ','+corelist+',')=0 then
            corelist := corelist + ',' + wwt_QstnsQstnCore.AsString;
          if sp <> wwt_QstnsScalePos.value then
            sp := 0;
        end;
        inc(i);
      end;
    end;
  end;
begin
  result := false;
  wwt_Qstns.disablecontrols;
  with TfrmQstnProperties.create(application) do begin
    {HideName(true);}
    GetScalePosition;
    rgScalePosition.ItemIndex := sp-1;
    ShowSkips(pos(',',corelist)=0);
    try
      if showModal = mrOK then
        if (rgScalePosition.ItemIndex <> sp-1) then begin
          cn.execute('update sel_qstns set ScalePos='+inttostr(rgScalePosition.ItemIndex+1)+
          ' where subtype=1 and qstncore in ('+corelist+')');
          result := true;
        end;
    finally
      free;
    end;
  end;
  wwt_QstnsEnablecontrols;
end;

function tDMOpenQ.SubsectionProperties:boolean;
var curSect,curSub,vScalePos,execResult:integer;
    vSubSectName : string;
    s,subList:string;
    rs:variant;
  procedure GetScalePosition;
  var i : integer;
  begin
    vScalePos:=0;
    sublist := format('(section_id=%d and subsection=%d) ', [wwt_QstnsSection.value,wwt_QstnsSubsection.value]);

    with f_DynaQ.wwdbgrid1 do begin
      i := 0;
      while i < SelectedList.Count do begin
        wwT_Qstns.GotoBookmark(SelectedList.items[i]);
        if (wwt_QstnsSubtype.value=2) and (pos(format('(section_id=%d and subsection=%d)',[wwt_QstnsSection.value,wwt_QstnsSubsection.value]),sublist)=0) then begin
          sublist := sublist + format('or (section_id=%d and subsection=%d) ',[wwt_QstnsSection.value,wwt_QstnsSubsection.value]);
          vSubSectName := '(multiple subsections)';
        end;
        inc(i);
      end;
    end;
    s := 'Select min(ScalePos) as minPos, max(ScalePos) as maxPos '+
         'from sel_qstns '+
         'where subtype=1 '+
         'and (' + sublist + ')';

    rs:=cn.execute(s);

    if not rs.eof then
      if strtointdef(vartostr(rs.fields[0].value),0) = strtointdef(vartostr(rs.fields[1].value),0) then
        vScalePos := strtointdef(vartostr(rs.fields[0].value),0);
    rs.close;
    rs:=unassigned;
  end;
begin
  result := false;
  with wwt_qstns do begin
    disablecontrols;
    curSub  := wwt_QstnsSubsection.value;
    curSect := wwt_QstnsSection.value;
    vSubSectName := wwt_QstnsLabel.text;
    indexfieldname := qpc_Section+';SubSection;Item';
    GetScalePosition;

    with TfrmQstnProperties.create(application) do
    begin
      caption := 'Subsection Properties';
      editName.text := vSubSectName;
      ShowName(vSubSectName <> '(multiple subsections)');
      ShowSkips(false);
      rgScalePosition.ItemIndex := vScalePos-1;
      try
        if showModal = mrOK then
          if editname.text <> vSubSectName then
          begin
            result := true;
            s:=format('update sel_qstns set Label=%s where section_id=%d and subsection=%d and subtype=2',
                      [QuotedStr(editName.text),curSect,curSub]);
            vScalePos:=rgScalePosition.itemindex+1;
            cn.execute(s,execResult);
            if execResult > 0 then
            begin
              result := true;
              SaveDialog.tag:=2;
            end;
          end;
          if (rgScalePosition.ItemIndex+1 <> vScalePos) then
          begin
            vScalePos:=rgScalePosition.ItemIndex+1;
            s:=format('update sel_qstns '+
                      'set ScalePos=%d '+
                      'where subtype=1 '+
                      'and (' + sublist + ')', [vScalePos]);
            cn.execute(s,execResult);
            if execResult > 0 then
            begin
              result := true;
              SaveDialog.tag:=2;
            end;
          end;

      finally
        free;
      end;
    end;
    wwt_QstnsEnableControls;
  end;
end;

function tDMOpenQ.SectionProperties:boolean;
begin
  result := false;
  with TfrmSectProperties.create(application) do begin
    EditName.text := wwt_QstnsLabel.text;
    try
      if showModal = mrOK then
        if (Editname.text <> wwt_QstnsLabel.text) then begin
          cn.execute('update sel_qstns set Label='+QuotedStr(editName.text)+
             ' where section_id='+wwt_QstnsSection.asString+' and subtype=3');
          result := true;
        end;
    finally
      free;
    end;
  end;
end;
{$ENDIF}

procedure TDMOpenQ.wwT_QstnsAfterOpen(DataSet: TDataSet);
{$IFDEF FormLayout}
var Languages : set of 0..255;
{$ENDIF}
begin
{$IFDEF FormLayout}
  with ww_Query do begin
    Close;
    if laptop then begin
      Databasename := 'DataLib';
      SQL.Clear;
      SQL.Add('Select LangID,Language,Dictionary,False as UseLang from Languages');
    end else begin
      Databasename := '_QualPro';
      SQL.Clear;
      SQL.Add('Select LangID,Language,Dictionary,''False'' as UseLang from Languages'); //GN10
    end;
    Open;
  end;
  wwt_Qstns.Filtered := false;
  wwt_Qstns.IndexFieldNames := 'Survey_ID;SelQstns_ID;Language';
  with t_Language do begin
    close;
    DatabaseName := '_PRIV';
    TableName := 'Sel_Language';
    TableType := ttParadox;
    with FieldDefs do begin
      Clear;
      add('LangID',ftInteger,0,false);
      add('Language',ftString,20,false);
      add('Dictionary',ftString,20,false);
      add('UseLang',ftBoolean,0,false);
//      add('SkipGoPhrase',ftString,50,false);  //Gn10
//      add('SkipEndPhrase',ftString,50,false);
    end;
    with IndexDefs do begin
      Clear;
      add('','LangID', [ixPrimary,ixUnique]);
    end;
    createTable;
    if batchMove(ww_Query, batAppend) > 0 then {};
    ww_Query.close;

    ww_Query.Databasename := '_Priv';
    ww_Query.SQL.Clear;
    ww_Query.SQL.Add('Select distinct Language from Sel_Qstns where type = "Question" and label = "Address and FOUO information"');
    ww_Query.Open;

    Languages:=[];

    while not ww_Query.EOF do
    begin
      Languages:= Languages+[ww_Query.fieldbyname('Language').asinteger];
      ww_Query.next;
    end;
    ww_Query.close;
    open;
    first;
    while not eof do begin
      edit;
      fieldbyname('UseLang').value := (fieldbyname('LangID').value=1) or
              (fieldbyname('LangID').asinteger in Languages);
      post;
      next;
    end;
  end;
  wwt_Qstns.Filtered := true;
  wwt_TransQ.open;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_QstnsBeforeClose(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwT_TransQ.Close;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_SclsAfterOpen(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwt_TransS.open;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_PCLAfterOpen(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwt_TransP.open;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_SclsBeforeClose(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwT_TransS.Close;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_TextBoxAfterOpen(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwt_TransTB.open;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_TextBoxBeforeClose(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwT_TransTB.Close;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_PCLAfterClose(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  wwt_TransP.close;
{$ENDIF}
end;

procedure TDMOpenQ.EnglishFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := dataset['Language'] = 1;
end;

procedure TDMOpenQ.LanguageFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := dataset['Language'] = CurrentLanguage;
end;

{$IFDEF FormLayout}
function TDMOpenQ.FindNextUntranslated:char;
begin
  result := ' ';
  if wwt_TransTB.state in [dsEdit,dsInsert] then wwt_transTB.post;
  if wwt_TransQ.state in [dsEdit,dsInsert] then wwt_transQ.post;
  if wwt_Qstns.filtered then wwt_Qstns.filtered := false;
  if not wwt_Qstns.eof then begin
    repeat begin
      if (wwt_QstnsSubtype.value = stComment) or (wwt_QstnsSubtype.value = stAddress) then begin
        if not wwt_transQ.findkey([glbSurveyID,wwt_QstnsID.value,CurrentLanguage]) then begin
          with wwt_transQ do begin
            append;
            fieldbyname('Survey_ID').value := wwt_QstnsSurvey_ID.value;
            fieldbyname('SelQstns_ID').value := wwt_QstnsID.value;
            wwt_transQ.fieldbyname('Language').value := CurrentLanguage;
            fieldbyname('PlusMinus').value := wwt_QstnsPlusMinus.value;
            fieldbyname('Label').value := wwt_QstnsLabel.value;
            fieldbyname('ScaleID').value := wwt_QstnsScaleID.value;
            fieldbyname('Type').value := wwt_QstnsType.value;
            fieldbyname(qpc_Section).value := wwt_QstnsSection.value;
            fieldbyname('Subsection').value := wwt_QstnsSubsection.value;
            fieldbyname('Item').value := wwt_QstnsItem.value;
            fieldbyname('Width').value := wwt_QstnsWidth.value;
            fieldbyname('QstnCore').value := wwt_QstnsQstnCore.value;
            fieldbyname('ScalePos').value := wwt_QstnsScalePos.value;
            fieldbyname('Subtype').value := wwt_QstnsSubType.value;
            fieldbyname('Height').value := wwt_Qstnsheight.value;
            fieldbyname('bitMeanable').value := wwt_QstnsbitMeanable.value;
            fieldbyname('numMarkCount').value := wwt_QstnsnumMarkCount.value;
            fieldbyname('numBubbleCount').value := wwt_QstnsnumBubbleCount.value;
            fieldbyname('bitLangReview').value := true;
            post;
            if fieldbyname('Subtype').value = stComment then
              result := 'c'
            else
              result := 'q';
          end;
        end else if (wwt_TransQ.fieldbyname('bitLangReview').isnull) or (wwt_TransQ.fieldbyname('bitLangReview').asboolean) then begin
          if wwt_TransQ.fieldbyname('Subtype').value = stComment then
            result := 'C'
          else
            result := 'Q';
        end;
      end;
      if result = ' ' then wwt_Qstns.next;
    end until (result <> ' ') or (wwt_qstns.eof);
    if result=' ' then wwt_TextBox.first;
  end;
  if (wwt_Qstns.eof) and (result=' ') and (wwt_TextBox.RecordCount>0) then begin
    repeat begin
      if wwt_TextBoxID.asinteger>=0 then
        if (not wwt_TransTB.findkey([glbSurveyID,wwt_TextBoxID.value,CurrentLanguage])) then begin
          with wwt_transTB do begin
            append;
            fieldbyname('Survey_ID').value := wwt_TextBoxSurvey_ID.value;
            fieldbyname(qpc_ID).value := wwt_TextBoxID.value;
            fieldbyname('Language').value := CurrentLanguage;
            fieldbyname('Type').value := wwt_TextBoxType.value;
            fieldbyname('CoverID').value := wwt_TextBoxCoverID.value;
            fieldbyname('X').value := wwt_TextBoxX.value;
            fieldbyname('Y').value := wwt_TextBoxY.value;
            fieldbyname('Width').value := wwt_TextBoxWidth.value;
            fieldbyname('Height').value := wwt_TextBoxHeight.value;
            fieldbyname('Border').value := wwt_TextBoxBorder.value;
            fieldbyname('Shading').value := wwt_TextBoxShading.value;
            fieldbyname('bitLangReview').value := true;
            fieldbyname('Label').value := wwt_TextBoxLabel.value;
            post;
          end;
          result := 't';
        end else if (wwt_TransTB.fieldbyname('bitLangReview').isnull) or (wwt_TransTB.fieldbyname('bitLangReview').asboolean) then begin
          result := 'T';
        end;
      if result = ' ' then wwt_TextBox.next;
    end until (result <> ' ') or (wwt_TextBox.eof);
  end;
  if result = ' ' then begin
    wwt_Qstns.filtered := true;
    wwt_Qstns.first;
  end;
end;
{$ENDIF}

procedure TDMOpenQ.AfterPost(DataSet: TDataSet);
begin
  SaveDialog.tag := 2;
end;

procedure TDMOpenQ.wwT_QstnsRichTextChange(Sender: TField);
begin
{$IFDEF FormLayout}
  with wwt_transQ do
    if findkey([glbSurveyID,wwt_QstnsID.value,1]) then
      while (not eof) and (fieldbyname('SelQstns_ID').value = wwt_QstnsID.value) do begin
        if ((wwt_QstnsSubtype.value=stComment) or (wwt_QstnsSubtype.value=stAddress)) and
           (fieldbyname('Language').value <> 1) and
           ((fieldbyname('bitLangReview').isnull) or (not fieldbyname('bitLangReview').asBoolean)) then begin
          edit;
          fieldbyname('bitLangReview').value := true;
          post;
        end;
        next;
      end;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_TextBoxRichTextChange(Sender: TField);
begin
{$IFDEF FormLayout}
  with wwt_transTB do
    if findkey([glbSurveyID,wwt_TextBoxID.value,1]) then
      while (not eof) and (fieldbyname(qpc_ID).value = wwt_TextBoxID.value) do begin
        if (fieldbyname('Language').value <> 1) and
           ((fieldbyname('bitLangReview').isnull) or (not fieldbyname('bitLangReview').asBoolean)) then begin
          edit;
          fieldbyname('bitLangReview').value := true;
          post;
        end;
        next;
      end;
{$ENDIF}
end;

procedure dup_fields(source,target:TwwTable;fields:array of string);
var i,h : integer;
begin
  h := high(fields);
  for i := 0 to h do
    target.fieldbyname(fields[i]).value := source.fieldbyname(fields[i]).value;
end;

{$IFDEF FormLayout}
function TDMOpenQ.ValidateCodes:boolean;
var aStream:tMemoryStream;
    aRichEdit:tRichEdit;
    ThisCodeOK : boolean;
    LangString : string;
    elc : integer;
  procedure CorruptCodeErrorMessage(eType,LangID:integer);
  var
    coverName : string;
  begin
    wwT_Cover.FindKey([glbSurveyId,wwt_TextBoxCoverID.value]);
    coverName := wwT_Cover.fieldbyname('Description').text;

    if t_Language.FindKey([LangID]) then
      LangString := trim(t_language.fieldbyname('language').asstring)
    else
      LangString := 'Language='+inttostr(LangID);
    case eType of
      stItem {1} :
        errorlist.add('Question #'+wwt_QstnsQstnCore.asstring + ' in section '+wwt_QstnsSection.asstring+'.'+wwt_QstnsSubsection.asstring+
          ' ('+LangString+') contains a corrupted code');
      stSubSection {2} :
        errorlist.add('Header for section '+wwt_QstnsSection.asstring+'.'+wwt_QstnsSubsection.asstring+
          ' ('+LangString+') contains a corrupted code');
      stComment {3} :
        errorlist.add('Comment in section '+wwt_QstnsSection.asstring+'.'+wwt_QstnsSubsection.asstring+
          ' ('+LangString+') contains a corrupted code');
      stAddress {6} :
        errorlist.add('Address  ('+LangString+') contains a corrupted code');
      7 :
        errorlist.add('TextBox "'+LabelOrId(wwt_textboxid, wwt_textboxlabel)+'" (Cover Name="'+coverName+'", '+LangString+') contains a corrupted code');
      8 : begin
            LocalQuery('select qstncore,'+qpc_section+',subsection from sel_qstns where subtype=1 and scaleid='+wwt_sclsID.AsString,false);
            errorlist.add('Scale for question #'+ww_Query.fieldbyname('qstncore').asstring+
              ' in section '+ww_Query.fieldbyname(qpc_section).asstring+'.'+ww_Query.fieldbyname('Subsection').asstring+
              ' ('+LangString+') contains a corrupted code');
            ww_Query.close;
          end;
    else
      errorlist.add('Corrupted code in section '+wwt_QstnsSection.asstring + '.'+wwt_QstnsSection.asstring+'.'+
        wwt_QstnsSubsection.asstring+'.'+wwt_QstnsItem.asstring + ' ('+LangString+')');
    end;
  end;

  function CheckCodes(var wwt_RichText:TBlobField):boolean;
  var i,L : longint;
      incode : integer;
  begin
    result := true;
    wwT_RichText.savetostream(aStream);
    aStream.seek(0,0);
    with aRichEdit do begin
      PlainText := false;
      lines.loadfromstream(aStream);
      selectall;
      if (pos('{',seltext)>0) or (not (caColor in selattributes.consistentattributes))  then begin
        L := length(seltext)-1;
        incode := 0;
        for i := 0 to L do
          if result then begin
            selStart := i;
            SelLength := 1;
            if seltext='{' then
              inc(incode)
            else if seltext='}' then
              dec(incode)
            else if ((seltext<>' ') or (i<L))
                and ((selattributes.color=clGreen) or (incode>0))
                and (strtointdef(seltext,-1)=-1) then
              result := false;
          end;
        if InCode>0 then
          result := false;
      end;
      PlainText := true;
      aStream.seek(0,0);
      lines.loadfromstream(aStream);
      aStream.clear;
      while result and (pos('\{',text) > 0) do begin
        text := copy(text,pos('\{',text),length(text));
        if pos('\}',text)=0 then
          result := false
        else
          if strtointdef(copy(text,3,pos('\}',text)-3),0) = 0 then
            result := false;
        text := copy(text,3,length(text));
      end;
    end;
  end;

  function QstnCodes:boolean;
  begin
    result := true;
    with wwt_Qstns do begin
      disablecontrols;
      filtered := false;
      first;
      while not eof do begin
        ThisCodeOK := checkCodes(wwt_QstnsRichText);
        if not ThisCodeOK then begin
          result := false;
          CorruptCodeErrorMessage(wwt_QstnsSubtype.value,wwt_QstnsLanguage.value);
        end;
        next;
      end;
      filtered := true;
      enablecontrols;
    end;
  end;

  function TextBoxCodes:boolean;
  begin
    result := true;
    with wwt_TextBox do begin
      disablecontrols;
      filtered := false;
      first;
      while not eof do begin
        ThisCodeOK := checkCodes(wwt_TextBoxRichText);
        if not ThisCodeOK then begin
          result := false;
          CorruptCodeErrorMessage(7,wwT_TextBoxLanguage.value);
        end;
        next;
      end;
      filtered := true;
      enablecontrols;
    end;
  end;

  function ScaleCodes:boolean;
  begin
    result := true;
    with wwt_Scls do begin
      disablecontrols;
      filtered := false;
      first;
      while not eof do begin
        ThisCodeOK := checkCodes(wwt_SclsRichText);
        if not ThisCodeOK then begin
          result := false;
          CorruptCodeErrorMessage(8,wwt_SclsLanguage.value);
        end;
        next;
      end;
      filtered := true;
      enablecontrols;
    end;
  end;

begin
  result := true;
  aRichEdit := tRichEdit.create(self);
  aStream := tMemoryStream.create;
  try
    aRichEdit.name := 'tempRichEdit';
    aRichEdit.Parent := f_DynaQ;
    aRichEdit.onProtectChange := F_DynaQ.RichEdit1ProtectChange;
    aRichEdit.top := (screen.height div 2) - (aRichEdit.Height div 2);
    aRichEdit.sendtoback;
    t_Language.indexfieldnames := 'LangID';
    elc := errorlist.Count;
    result := QstnCodes;
    result := ScaleCodes and result;
    if not result then begin
      while errorlist.count > elc do errorlist.Delete(errorlist.count-1);
      CheckAgainstLibrary;
      result := QstnCodes;
      result := ScaleCodes and result;
    end;
    result := TextBoxCodes and result;
  finally
    aRichEdit.free;
    aStream.free;
  end;
end;

function TDMOpenQ.ValidateSkips:boolean;
var SFSection,SFSubsection,SFItem : integer;
    SkipOK : boolean;
    SkipTo : string;
begin
  result := true;
  wwt_Qstns.filtered := false;
  with wwt_Skip do begin
    first;
    while not eof do begin
      wwt_Qstns.IndexFieldName := 'Survey_ID;SelQstns_ID;Language';
      if wwt_Qstns.findkey([glbSurveyID,wwT_SkipSelQstns_ID.value,1]) then begin
        SFSection := wwt_QstnsSection.value;
        SFSubsection := wwt_QstnsSubsection.value;
        SFItem := wwt_QstnsItem.value;
        wwt_Qstns.IndexFieldName := qpc_Section+';SubSection;Item';
        if wwt_SkipnumSkipType.value = skSubsection then begin
          SkipOK := wwt_Qstns.findkey([SFSection,SFSubsection+1,wwt_SkipnumSkip.value]);
          SkipTo := 'Q.'+inttostr(SFSection)+'.'+inttostr(1+SFSubsection)+'.'+wwt_SkipnumSkip.asString;
        end else if wwt_SkipnumSkipType.value = skQuestion then begin
          SkipOK := wwt_Qstns.findkey([SFSection,SFSubsection,SFItem+wwt_SkipnumSkip.value]);
          SkipTo := 'Q.'+inttostr(SFSection)+'.'+inttostr(SFSubsection)+'.'+inttostr(SFItem+wwt_SkipnumSkip.value);
        end else
          SkipOK := true;
        if not SkipOK then begin
          errorlist.add('Q.'+inttostr(SFSection)+'.'+inttostr(SFSubsection)+'.'+
            inttostr(SFItem)+' can''t skip to ' + SkipTo);
          result := false;
        end;
      end;
      next;
    end;
  end;
  wwt_Qstns.filtered := true;
end;

function TDMOpenQ.GetPlainText(richTxt : TBlobField) : string;
var
   bStream : TBlobStream;
begin
   result := '';
   bStream := TBlobStream.Create(richTxt, bmRead);
   try
    with TRichedit.Create(self) do
    begin
       Parent := Application.MainForm  ;
       Lines.LoadFromStream(bStream);
       if Lines.Count > 0 then
       begin
          PlainText := true;
          result := Text;
       end
       else
           result := '';
       Free;
    end;
   finally
      bStream.Free;
   end;
end;

function TDMOpenQ.LabelOrID(id : TIntegerField; name : TStringField) : string;
begin
  if name.AsString <> '' then
    result := name.AsString
  else
    result := id.AsString ;
end;

function TDMOpenQ.ValidateTranslation:boolean;
var CurrentLanguageName,s:string;
    i : integer;
  procedure checkTB;
  var
    coverName : string;
  begin
    with wwt_TextBox do begin
      first;
      while (not eof) do begin
        wwT_Cover.FindKey([glbSurveyId,wwt_TextBoxCoverID.value]);
        coverName := wwT_Cover.fieldbyname('Description').text;

        if (not wwt_transTB.findkey([glbSurveyID,wwt_TextBoxID.value,currentLanguage])) then
          errorlist.add('TextBox "'+LabelOrId(wwt_textboxid, wwt_textboxlabel)+'" (Cover Letter="'+coverName+'") needs to be translated ('+CurrentLanguageName+')')
        else begin

          if (wwt_TransTB.fieldbyname('bitLangReview').isnull) or (wwt_TransTB.fieldbyname('bitLangReview').asBoolean) then
            errorlist.add('TextBox "'+LabelOrId(wwt_textboxid, wwt_textboxlabel)+'" (Cover Letter="'+coverName+'") needs to be reviewed ('+CurrentLanguageName+')');

          //GN13: If the user clears the translation text, the record still exists in the database
          if (GetPlainText(wwt_TransTBRichText) = '') and (GetPlainText(wwt_TextBoxRichText) <> '') then
             errorlist.add('TextBox "'+LabelOrId(wwt_textboxid, wwt_textboxlabel)+'" (Cover Letter="'+coverName+'") needs to be translated ('+CurrentLanguageName+')');
          {make sure Foreign TextBox's x,y,width,height,etc are same as English's}

          wwt_TransTB.Edit;
          dup_fields(wwt_TextBox,wwt_TransTB,['CoverID','Type','X','Y','Width','Height','Border','Shading','Label']);
          wwt_TransTB.post;
        end;
        next;
      end;
    end;
  end;

  procedure CheckQ;
    procedure checksection;
    begin
      if not wwt_TransQ.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]) then
        wwt_TransQ.append
      else
        wwt_transQ.edit;
      dup_fields(wwt_Qstns,wwt_transQ,['Survey_ID','SelQstns_ID','Label',
        'Type',qpc_Section,'Subsection','Item','PlusMinus','SubType','ScaleID',
        'QstnCore','bitMeanable','ScaleFlipped']);
      wwt_transQ.fieldbyname('Language').value := currentLanguage;
      wwt_transQ.fieldbyname('bitLangReview').value := false;
      wwt_transQ.post;
      if wwt_QstnsSection.value=-1 then begin
        wwt_qstnsRichtext.savetofile(tempdir+'\richtext.rtf');
        wwt_qstns.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]);
        wwt_Qstns.Edit;
        wwt_QstnsRichText.loadfromfile(tempdir+'\richtext.rtf');
        wwt_qstns.post;
      end;
    end;

    procedure checksubsection;
    var newrec:boolean;
    begin
      if wwt_Qstns.fieldbyname('QstnCore').value <= 0 then begin
        if not wwt_transQ.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]) then begin
          wwt_transQ.append;
          dup_fields(wwt_qstns,wwt_transQ,['Survey_ID','SelQstns_ID','Type',
            qpc_Section,'Subsection','Item','Label','PlusMinus','QstnCore',
            'ScalePos','Subtype','ScaleID','bitMeanable','ScaleFlipped']);
          wwt_transQ.fieldbyname('Language').value := currentLanguage;
          wwt_transQ.fieldbyname('bitLangReview').value := false;
          wwt_transQ.post;
        end;
      end else
        with dqDataModule.wwT_HeadText do begin
          if findkey([wwt_Qstns.fieldbyname('QstnCore').value,currentLanguage]) then begin
            if fieldbyname('Review').asboolean then
              errorlist.add('Header #'+wwt_Qstns.fieldbyname('QstnCore').asstring+' needs to be reviewed  ('+CurrentLanguageName+')')
            else begin
              newRec := not wwt_transQ.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]);
              if NewRec then
                wwt_transQ.append
              else
                wwt_transQ.edit;
              dup_fields(wwt_qstns,wwt_transQ,['Survey_ID','SelQstns_ID','Type',
                qpc_Section,'Subsection','Item','Label','PlusMinus','QstnCore',
                'ScalePos','Subtype','ScaleID','bitMeanable','ScaleFlipped']);
              wwt_transQ.fieldbyname('Language').value := currentLanguage;
              wwt_transQ.fieldbyname('bitLangReview').value := false;
              wwt_transQ.post;
              if NewRec then begin
                wwt_Qstns.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]);
                wwt_Qstns.edit;
                wwt_QstnsRichText.assign(dqDataModule.wwT_HeadTextText);
                wwt_Qstns.post;
              end;
            end;
          end else begin
            errorlist.add('Header #'+wwt_Qstns.fieldbyname('QstnCore').asString+' has no translation ('+CurrentLanguageName+')');
          end;
        end;
    end;


    procedure checkitem;
    var
       NewRec:boolean;

    begin
      with dqDataModule.wwT_QuestionText do begin
        if findkey([wwt_Qstns.fieldbyname('QstnCore').value,currentLanguage]) then begin
          if fieldbyname('Review').asboolean then
            errorlist.add('Question #'+wwt_Qstns.fieldbyname('QstnCore').asString+' needs to be reviewed ('+CurrentLanguageName+')')
          else begin
            newRec := not wwt_TransQ.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]);
            if not newRec and (GetPlainText(wwt_TransQRichText) = '') then //GN09
            begin
               errorlist.add('Question #'+wwt_Qstns.fieldbyname('QstnCore').asString+' has no translation ('+CurrentLanguageName+')');
            end
            else
            begin
               if NewRec then
                 wwt_transQ.append
               else
                 wwt_transq.edit;
               dup_fields(wwt_qstns,wwt_transQ,['Survey_ID','SelQstns_ID','Label',
                 'PlusMinus',qpc_Section,'Subsection','Item','Subtype','ScaleID',
                 'Width','Height','QstnCore','ScalePos','bitMeanable','numMarkCount',
                 'numBubbleCount','Type','ScaleFlipped']);
               wwt_transQ.fieldbyname('Language').value := currentLanguage;
               wwt_transQ.fieldbyname('bitLangReview').value := false;
               wwt_transQ.post;
               if NewRec then begin
                 wwt_Qstns.findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage]);
                 wwt_Qstns.edit;
                 wwt_QstnsRichText.assign(dqDataModule.wwT_QuestionTextText);
                 wwt_Qstns.post;
               end;
            end;
          end;
        end else begin
          errorlist.add('Question #'+wwt_Qstns.fieldbyname('QstnCore').asString+' has no translation ('+CurrentLanguageName+')');
        end;
      end;
    end;

    procedure checkcomment;
    begin
      if not wwt_transQ.findkey([glbSurveyid,wwt_QstnsID.value,currentLanguage]) then
        errorlist.add('Comment in Section '+wwt_QstnsSection.asstring+'.'+wwt_qstnsSubsection.asstring+' needs to be translated ('+CurrentLanguageName+')')
      else begin
        if (wwt_TransQ.fieldbyname('bitLangReview').isnull) or (wwt_TransQ.fieldbyname('bitLangReview').asBoolean) then
          errorlist.add('Comment in Section '+wwt_QstnsSection.asstring+'.'+wwt_qstnsSubsection.asstring+' needs to be reviewed ('+CurrentLanguageName+')');
        wwt_TransQ.edit;
        dup_fields(wwt_Qstns,wwt_TransQ,[qpc_Section,'Subsection','Item','Label',
           'Subtype','ScaleID','Height','QstnCore','ScalePos','numMarkCount',
           'numBubbleCount','ScaleFlipped','bitMeanable']);
        wwt_TransQ.post;
      end;
    end;

    procedure checkAddress;
    begin
      if not wwt_transQ.findkey([glbSurveyid,wwt_QstnsID.value,currentLanguage]) then
        errorlist.add('Address needs setup with '+CurrentLanguageName+' codes')
      else if (wwt_TransQ.fieldbyname('bitLangReview').isnull) or (wwt_TransQ.fieldbyname('bitLangReview').asBoolean) then
        errorlist.add('Address needs to be reviewed ('+CurrentLanguageName+')');
    end;

  var subtype : integer;
  begin
    with dqDataModule.wwT_QuestionText do begin
      indexFieldNames := 'Core;LangID';
      Mastersource := nil;
    end;
    with dqDataModule.wwT_HeadText do begin
      indexFieldNames := 'HeadID;LangID';
      Mastersource := nil;
    end;
    with wwt_Qstns do begin
      filtered := false;
      indexfieldnames := 'Survey_ID;SelQstns_ID;Language';
      first;
      while (not eof) do begin
        if wwt_QstnsLanguage.value=1 then begin
          subtype := wwt_QstnsSubtype.value;
          case subtype of
            stSection: checkSection;
            stSubsection: checkSubsection;
            stItem: checkItem;
            stComment: checkComment;
            stAddress: checkAddress;
            {stFOUO: nothing;}
          end;
        end;
        next;
      end;
      indexfieldnames := qpc_Section+';SubSection;Item';
      filtered := true;
    end;
    with dqDataModule.wwT_QuestionText do begin
      indexFieldNames := 'Core';
      Mastersource := dqDataModule.wwDS_Questions;
    end;
    with dqDataModule.wwT_HeadText do begin
      indexFieldNames := 'HeadID;LangID';
      Mastersource := dqDataModule.wwDS_Headings;
    end;
  end;

  procedure CheckS;
  begin
    with dqDataModule.wwT_ScaleText do begin
      MasterSource := nil;
      indexFieldNames := 'Scale;Item;LangID';
      wwt_scls.first;
      while not wwt_scls.eof do begin
        if findkey([wwt_Scls.fieldbyname(qpc_ID).value,wwt_Scls.fieldbyname('Item').value,currentLanguage]) then begin
          if fieldbyname('Review').asboolean then
            errorlist.add('Scale #'+wwt_Scls.fieldbyname(qpc_ID).Asstring+'.'+wwt_Scls.fieldbyname('Item').asString+' needs reviewing ('+CurrentLanguageName+')')
          else begin
            if wwt_transs.findkey([glbSurveyID,wwt_SclsID.value,wwt_sclsItem.value,currentLanguage]) then
              wwt_transS.edit
            else
              wwt_transs.append;
            dup_fields(wwt_Scls,wwt_transS,['Survey_ID',qpc_ID,'Type','Label','CharSet',
              'Val','Item','ScaleOrder','intRespType','Missing']);
            wwt_transS.fieldbyname('Language').value := currentLanguage;
            wwt_transS.fieldbyname('RichText').assign(dqDataModule.wwT_ScaleTextText);
            wwt_transS.post;
          end;
        end else begin
          errorlist.add('Scale #'+wwt_Scls.fieldbyname(qpc_ID).Asstring+'.'+wwt_Scls.fieldbyname('Item').asString+' has no translation ('+CurrentLanguageName+')');
        end;
        wwt_Scls.next;
      end;
      indexFieldNames := 'Scale;Item';
      Mastersource := dqDataModule.wwDS_ScaleValues;
    end;
  end;

  procedure CheckP;
  begin
    with wwt_PCL do begin
      first;
      while (not eof) do begin
        if not wwt_transP.findkey([glbSurveyID,wwt_PCLID.value,currentLanguage]) then begin
          if wwT_PCLDescription.value = '*PageBreak*' then
            wwt_transP.AppendRecord([glbSurveyID,wwt_PCLID.value,currentLanguage,
              wwt_PCLCoverid.value,'PCL','*PageBreak*',wwt_PCLX.value,wwt_PCLY.value,
              wwt_PCLWidth.value,wwt_PCLHeight.value,'',true])
          else
            errorlist.add('PCL '+wwt_PCLID.asstring+' ('+wwt_PCLDescription.asstring+') needs a translated equivalent ('+CurrentLanguageName+')');
        end else begin
          wwt_TransP.edit;
          wwt_TransP.fieldbyname('X').value := wwt_PCLX.value;
          wwt_TransP.fieldbyname('Y').value := wwt_PCLY.value;
          wwt_TransP.fieldbyname('Width').value := wwt_PCLWidth.value;
          wwt_TransP.fieldbyname('Height').value := wwt_PCLHeight.value;
          wwt_TransP.fieldbyname('KnownDimensions').value := wwt_PCLKnownDimensions.value;
          wwt_TransP.post;
        end;
        next;
      end;
    end;
  end;

  //gntest
  procedure CheckScaleHandEntry;
  var
     sScaleText:string;
  begin
    with dqDataModule.wwT_ScaleText do begin
      MasterSource := nil;
      indexFieldNames := 'Scale;Item;LangID';
      wwt_scls.first;
      while not wwt_scls.eof do begin
        if findkey([wwt_Scls.fieldbyname(qpc_ID).value,wwt_Scls.fieldbyname('Item').value,1]) then begin
            sScaleText := GetPlainText(dqDataModule.wwT_ScaleTextText);
            if Pos('___',sScaleText) >0 then
               ShowMessage('Found hand ' + sScaleText);
        end;
        wwt_Scls.next;
      end;
      indexFieldNames := 'Scale;Item';
      Mastersource := dqDataModule.wwDS_ScaleValues;
    end;
  end;
begin
  errorlist.sorted := false;
  result := true;
  t_language.first;
  t_language.next;
  if t_language.eof then
    exit;
  while (not t_language.eof) do begin
    if t_language.fieldbyname('UseLang').asBoolean then begin
      CurrentLanguage := t_language.fieldbyname('LangID').value;
      CurrentLanguageName := t_language.fieldbyname('Language').value;
{      try
         SkipGoPhrase := '';
         SkipEndPhrase := '';
         if not t_language.fieldbyname('SkipGoPhrase').IsNull then
            SkipGoPhrase := t_language.fieldbyname('SkipGoPhrase').value;   //GN10
         if not t_language.fieldbyname('SkipEndPhrase').IsNull then
            SkipEndPhrase := t_language.fieldbyname('SkipEndPhrase').value;
      except
         on E:Exception do MessageDlg(E.Message, mtError, [mbOK], 0);
      end;}
      CheckTB;
      CheckP;
      CheckQ;
      CheckS;
      //CheckScaleHandEntry; //gntest
    end;
    t_Language.next;
  end;
  if errorlist.count>0 then
    for i := 0 to errorlist.count-1 do begin
      s := '';
      if pos('Header #',errorlist[i]) > 0 then begin
        s := errorlist[i];
        delete(s,1,8);
        delete(s,pos(' ',s),length(s));
        s := 'select SQ2.QstnCore '+
            'from sel_qstns SQ, sel_Qstns SQ2 '+
            'where SQ.subtype=2 and SQ.Language=1 and '+
            '  SQ.'+qpc_Section+'=SQ2.'+qpc_Section+' and SQ.Subsection=SQ2.Subsection and '+
            '  SQ2.item>0 and SQ2.language=1 and SQ.qstncore='+s;
      end else if pos('Scale #',errorlist[i])>0 then begin
        s := errorlist[i];
        delete(s,1,7);
        delete(s,pos('.',s),length(s));
        s := 'select QstnCore from sel_qstns '+
            'where subtype=1 and Language=1 and ScaleID='+s;
      end;
      if s <> '' then begin
        LocalQuery(s,false);
        if ww_Query.recordcount>0 then
          errorlist[i] := errorlist[i] + ' (used by core #'+ww_Query.fieldbyname('QstnCore').asstring+')';
        ww_Query.close;
      end;
    end;
  result := (errorlist.count=0);
end;

function TDMOpenQ.ValidateSurvey(const SaveToo:boolean):boolean;
  function ValidateSections(var s:string):boolean;
  var rs:variant;
      Section_id,MultipleMapping,unmapped:string;
      i:integer;
  begin

    s:= 'Select distinct SECTION_ID, SAMPLEUNITSECTION_ID '+
                    'from sel_qstns '+
                    'where subtype ='+inttostr(stSection)+
                    ' and language = 1'+
                    ' order by SECTION_ID';
    rs:=cn.execute(s);
    UnMapped := '';
    MultipleMapping:='';
    While not rs.eof do begin
       s := vartostr(rs.fields['SAMPLEUNITSECTION_ID'].value);
       Section_id := vartostr(rs.fields['Section_id'].value);
       if s = '' then
          UnMapped :=  UnMapped + Section_id + ', '
       else if (pos(',',s)>0) then //mapped more than once if there is a ','
           MultipleMapping :=  MultipleMapping + Section_id + ', ';

       rs.movenext;
    end;

    SetLength(MultipleMapping,length(MultipleMapping)-2); //get rid of last ', '
    SetLength(UnMapped,length(UnMapped)-2);

    rs.close;
    rs:=unassigned;

    if MultipleMapping <> '' then
      MultipleMapping := 'The following Sections are mapped more than once:'#13#10 + MultipleMapping+#13#10;

    if UnMapped <> '' then
      UnMapped := 'The following Sections are not mapped:'#13#10 + UnMapped;

    s := MultipleMapping + UnMapped;
    result := (s = '');

    if not result then
      s := 'There are some mapping concerns. Please check your sections mapping.'#13#10+s;
  end;

var vt,vs,vc : boolean;
    s:string;
begin
  // removes any scales that are no longer used:
  cn.execute('delete from sel_scls.db S '+
                     'where s.qpc_id not in '+
                     '(select scaleid from sel_qstns.db where subtype=1)');
  Errorlist.clear;
  vt := ValidateTranslation;
  vs := ValidateSkips;
  vc := ValidateCodes;
  result := vt and vs and vc;
  if result then begin
    //CheckAgainstLibrary;
    LocalQuery('select sq.Section_id as Section, sq.Subsection, q.Core, s.Service, q.RestrictQuestion as Restricted '+
       'from Sel_Qstns sq, ::question::Questions q, ::question::Services s '+
       'where q.Servid=s.Servid '+
       '  and q.Core = sq.QstnCore '+
       '  and sq.Subtype=1 '+
       '  and sq.Language=1 '+
       'order by s.Service, sq.Section_id, sq.Subsection',false);
    viewdata(tDataset(ww_Query),nil,['This is a list of all the services this survey uses.']);
    ww_Query.close;
    if SaveToo then begin
      result := SaveSQLSurvey(true,true);
      if (result) and (not Laptop) then begin
        result := fileexists(extractfilepath(application.exename)+'SaveTagFields.exe');
        if not result then
          errorlist.add('Cannot find '+extractfilepath(application.exename)+'SaveTagFields.exe - survey personalization will not work.');
      end;
    end;
  end;
  {GN01
  if glbSurveyID > 0 then begin
    if (not ValidateSections(s)) then begin
      with tfrmInvalid.Create(application)  do
      try
        caption := 'Warning - Section Mapping!';
        color := clRed;
        memo1.lines.text := s;
        ShowModal;
      finally
        Release;
      end;
    end;
  end;
  }
end;

procedure TDMOpenQ.PrintMockup;
begin
  frmMyPrintDlg := TfrmMyPrintDlg.Create( Self );
  with frmMyPrintDlg do
  try
    ShowModal;
  finally
    Release;
  end;
end;
{$ENDIF}

procedure TDMOpenQ.wwT_TextBoxBeforeDelete(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  SaveDialog.tag := 2;
  with wwt_transTB do begin
    filtered := false;
    first;
    while not eof do
      if (fieldbyname('Language').value > 1) and (wwt_textbox.fieldbyname('qpc_id').value = fieldbyname('qpc_id').value) then
        delete
      else
        next;
    filtered := true;
  end;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_PCLBeforeDelete(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  SaveDialog.tag := 2;
  with wwt_transP do begin
    filtered := false;
    first;
    while not eof do
      if fieldbyname('Language').value > 1 then
        delete
      else
        next;
    filtered := true;
  end;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_SclsBeforeDelete(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  SaveDialog.tag := 2;
  with wwt_transS do begin
    filtered := false;
    first;
    while not eof do
      if fieldbyname('Language').value > 1 then
        delete
      else
        next;
    filtered := true;
  end;
{$ENDIF}
end;

procedure TDMOpenQ.wwT_QstnsBeforeDelete(DataSet: TDataSet);
begin
{$IFDEF FormLayout}
  SaveDialog.tag := 2;
  with wwt_transQ do begin
    filtered := false;
    first;
    while not eof do
      if (fieldbyname(qpc_Section).value=wwt_QstnsSection.value) and
         (fieldbyname('Subsection').value=wwt_QstnsSubsection.value) and
         (fieldbyname('Item').value=wwt_QstnsItem.value) and
         (fieldbyname('Language').value > 1) then
        delete
      else
        next;
    filtered := true;
  end;
{$ENDIF}
end;

{$IFDEF FormLayout}
procedure TDMOpenQ.newLangPCL(CoverID,PCLID,LangID:integer;FileName:string);
var w,h:integer;
    kd : boolean;
begin
  currentLanguage := LangID;
  with wwt_TransP do begin
    refresh;
    if FindKey([wwt_pcl.fieldbyname('Survey_ID').value,PCLID,LangID]) then
      edit
    else
      append;
    dup_fields(wwt_PCL,wwt_transP,['Survey_ID','Type','X','Y']);
    fieldbyname('CoverID').value := CoverID;
    fieldbyname(qpc_id).value := PCLID;
    fieldbyname('Description').value := extractfilename(filename);
    fieldbyname('Language').value := LangID;
    fieldbyname('PCLStream').value := AnalyzePCL(Filename,w,h,kd);
    fieldbyname('KnownDimensions').value := KD;
    fieldbyname('Width').value := round(0.1479*w);
    fieldbyname('Height').value := round(0.1479*h);
    post;
  end;
end;

function TDMOpenQ.PCLHints:string;
begin
  with wwt_TransP do begin
    filtered := false;
    first;
    result := '';
    while not eof do begin
      t_Language.findkey([fieldbyname('Language').value]);
      result := result + t_language.fieldbyname('Language').value + ': ' + fieldbyname('Description').value + '    ';
      next;
    end;
    filtered := true;
  end;
end;
{$ENDIF}

procedure tdmOpenQ.AnalyzePCLString(s:string; var w,h:integer; var KD:boolean);
begin
  w := 600;
  h := 600;
  KD := false;
  if pos('Y',s+'Y') < 25 then begin
    s := copy(s,1,pos('Y',s));
    if pos('+',S) > 0 then begin
      delete(s,1,pos('+',S));
      w := round((strtoint(copy(s,1,pos('x',s)-1)) * 710) / 4800);
      delete(s,1,pos('x',s));
      h := round((strtoint(copy(s,1,pos('Y',s)-1)) * 710) / 4800);
      if (w<=0) or (h<=0) then begin
        w := 89; // 89 = (600*710)/4800
        h := 89;
      end else
        KD := true;
    end;
  end;
end;

function TDMOpenQ.AnalyzePCL(const fn:string; var w,h:integer;var KD:boolean):string;
var f : file of byte;
    s : string;
    b : byte;
begin
  assignfile(f,fn);
  reset(F);
  s := '';
  if eof(f) then
    b := 0
  else begin
    read(f,b);
    s := chr(b);
  end;
//if b = 27 then begin
    while (not eof(f)) {and ((chr(b)<'A') or (chr(b)>'Z'))} do begin
      read(f,b);
      s := s + chr(b);
    end;
//end;
  result := s;
  while not eof(f) do begin
    read(f,b);
    result := result + chr(b);
  end;
  closefile(f);
  AnalyzePCLString(s,w,h,KD);
end;

procedure TDMOpenQ.wwT_QstnsSubSectNumGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if wwt_QstnsItem.value = 0 then begin
    text := wwt_qstnssection.asstring;
    if wwt_QstnsSubsection.value>0 then
      text := text +'.'+wwt_QstnsSubsection.asstring;
  end;
end;

procedure TDMOpenQ.wwt_QstnsEnableControls;
{$IFDEF FormLayout}
var sectnumwidth : integer;
{$ENDIF}
begin
{$IFDEF FormLayout}
  with TwwQuery.create(self) do
  try
    close;
    Databasename := '_PRIV';
    SQL.clear;
    SQL.add('Select survey_id, max('+qpc_Section+') as mxSect, max(Subsection) as mxSub');
    SQL.add(' from ::PRIV::sel_Qstns where PlusMinus <> ''*'' group by survey_ID');
    open;
    SectNumWidth := 3;
    if fieldbyname('mxSect').value > 9 then inc(sectnumwidth);
    if fieldbyname('mxSub').value > 9 then inc(sectnumwidth);
    close;
  finally
    free;
  end;
  wwT_QstnsSubSectNum.displayWidth := sectnumwidth;
  wwt_Qstns.indexfieldnames := qpc_Section+';SubSection;Item';
  {while wwt_Qstns.ControlsDisabled do}
    wwt_Qstns.enableControls;
{$ENDIF}
end;

{$IFDEF FormLayout}
procedure TDMOpenQ.wwt_QstnsEnableControlsDammit;
begin
  while wwt_Qstns.ControlsDisabled do
    wwt_Qstns.enableControls;
end;

procedure TDMOpenQ.GetSQLSurveyName;
begin
  if not laptop then
    with ww_Query do begin
      Close;
      Databasename := '_QualPro';
      SQL.Clear;
      SQL.Add('select study.study_id, (''Study:''+study.strStudy_nm)+'' Survey:''+survey_def.strSurvey_nm as title, survey_def.bitLayoutValid');
      SQL.Add('from study, survey_def');
      SQL.Add('where survey_def.survey_id='+inttostr(glbSurveyID)+' and survey_def.study_id=study.study_id');
      open;
      f_DynaQ.caption := 'QualPro Form Layout - ' + fieldbyname('title').text;
      Validated := fieldbyname('bitLayoutValid').asBoolean;
      glbStudyID := FieldByName('study_id').AsInteger; //gntest
      close;
    end;
end;

procedure TDMOpenQ.OpenAllSQLTables(const SID:integer);
begin
  with f_DynaQ.ProgressBar do begin
    Position := Position + 12;
    //if session.getaliasdrivername('QualPro') <> 'STANDARD' then
    //  QPQuery('SET TEXTSIZE 2560000',true);
    if (sid=glbSurveyID) then GetSQLSurveyName;
    OpenSQLCover(SID);
    if wwt_Cover.recordcount = 0 then begin
      NewSurvey;
    end else begin
      Position := Position + 13;
      OpenSQLLogos(SID);
      Position := Position + 12;
      OpenSQLTextBox(SID);
      Position := Position + 13;
      OpenSQLPCL(SID);
      Position := Position + 12;
      OpenSQLScales(SID);
      Position := Position + 13;
      OpenSQLSkip(SID);
      Position := Position + 12;
      CreateProblemScoreTable;
      OpenSQLQstns(SID);
      wwt_qstns.indexname := 'BySection';
      Position := Position + 13;
      GetProblemScores;
    end;
  end;
end;

procedure TDMOpenQ.GetProblemScores;
begin
  with ww_Query do begin
    close;
    sql.clear;

    databasename := '_PRIV';
    sql.add('select ps.core, ps.val, ps.Problem_Score_Flag, ps.strProblemScore, ps.Short, ps.Transferred '+
            'from sel_qstns sq, '+
            ' ":question:ProblemScores" ps '+
            'where sq.subtype=1 '+
            'and sq.language=1 '+
            'and sq.qstncore=ps.core '+
            'and ps.problem_score_flag in (0,1,9)');
    open;
    if RecordCount>0 then
      wwt_problemscores.BatchMove(ww_Query,batAppend);

    close;
    sql.clear;
    if not laptop then begin
      databasename := '_DataMart';
      sql.add(format('select qstncore as core, Val, Problem_Score_Flag, '+
                     'case Problem_Score_Flag '+
                     '  when 0 then ''Positive'' '+
                     '  when 1 then ''Problem'' '+
                     '  when 9 then ''n/a'' '+
                     '  else ''(undefined)'' '+
                     'end as strProblemScore '+
                     'from lu_problem_score_custom '+
                     'where problem_score_flag in (0,1,9) '+
                     'and client_id=%d', [glbClientID]));
      open;
      if RecordCount>0 then
        wwt_problemscores.BatchMove(ww_Query,batUpdate);
      close;
    end;
  end;
  wwt_ProblemScores.Open;
  
end;

procedure TDMOpenQ.GetAProblemScore(const qstncore:integer);
begin
  with ww_Query do begin
    close;
    sql.clear;

    databasename := 'DataLib';
    sql.add(format('select ps.core, ps.val, ps.Problem_Score_Flag, ps.strProblemScore, ps.Short, ps.Transferred '+
            'from ProblemScores ps '+
            'where ps.core=%d '+
            'and ps.problem_score_flag in (0,1,9)',[qstncore]));
    open;
    if RecordCount>0 then
      wwt_problemscores.BatchMove(ww_Query,batAppendUpdate);

    close;
    sql.clear;
    if not laptop then begin
      databasename := '_DataMart';
      sql.add(format('select qstncore as core, Val, Problem_Score_Flag, '+
                     'case Problem_Score_Flag '+
                     '  when 0 then ''Positive'' '+
                     '  when 1 then ''Problem'' '+
                     '  when 9 then ''n/a'' '+
                     '  else ''(undefined)'' '+
                     'end as strProblemScore '+
                     'from lu_problem_score_custom '+
                     'where problem_score_flag in (0,1,9) '+
                     'and qstncore=%d '+
                     'and client_id=%d', [qstncore,glbClientID]));
      open;
      if RecordCount>0 then
        wwt_problemscores.BatchMove(ww_Query,batAppendUpdate);
      close;
    end;
  end;
end;

procedure TDMOpenQ.LoadFromSQL(const SID:integer;const showstatus:boolean);
begin
  CloseSurvey;
  UnMapAllSections := false;
  DeletedAddedSections := false;
  if SaveDialog.Tag = 1 then begin
    ShowOpenStatus := showstatus;
    if showopenstatus then begin
      frmOpenStatus := TfrmOpenStatus.Create( Self );
      with frmOpenStatus do begin
        ProgressBar.position := 0;
        Label1.caption := 'Opening survey ...';
        show;
      end;
    end;
    with F_DynaQ do begin
      Screen.cursor := crHourglass;
      myMessage('Opening '+inttostr(SID));
      ProgressBar.Position := 0;
      ProgressBar.left := StatusPanel.Width - 160;
      ProgressBar.Visible := true;
      fromanothersurvey1.Enabled := (MappedTextBoxesByCL('')[0].SampleUnit = 0);
      fromatemplate1.Enabled := fromanothersurvey1.Enabled;
      clear1.Enabled := fromanothersurvey1.Enabled;
      OpenAllSQLTables(SID);
      CheckItemNumbering;
      myMessage('');
      ProgressBar.Visible := false;
      ProgressBar.Position := 0;
      SaveDialog.Filename := '';
      Screen.cursor := crDefault;
      SaveDialog.tag := 1;
    end;
    if ShowOpenStatus then
      with frmOpenStatus do begin
        progressbar.position := progressbar.max;
        release;
      end;
  end;
end;

procedure tdmOpenQ.OpenSQLQstns(const SID:integer);
    procedure UpdateSampleSectionField;
      Function UpdateTbl(List,section:string):string;
      var sql:string;
      begin
        SetLength(List,length(List)-1);
        sql := 'update sel_qstns '+
                  'set SAMPLEUNITSECTION_ID = '''+List+
                  ''' where section_id ='+section+
                  ' and subtype ='+inttostr(stSection)+
                  ' and language = 1'#13#10;
        cn.execute(sql);

      end;
    var rs:variant;
        List:string;
        section:string;
        mapped:boolean;
    begin
       try
       mapped := false;
       rs := sqlcn.execute('select SELQSTNSSECTION, SAMPLEUNITSECTION_ID '+
                           'from SAMPLEUNITSECTION '+
                           'where SELQSTNSSURVEY_ID =' + inttostr(sid) +
                           ' order by SELQSTNSSECTION, SAMPLEUNITSECTION_ID');
       section:='';
       List:='';
       while not rs.eof do begin
         mapped := true;
         if section <> vartostr(rs.fields['SELQSTNSSECTION'].value) then begin
           if section <> '' then begin
              UpdateTbl(List,section);
           end;
           section := vartostr(rs.fields['SELQSTNSSECTION'].value);
           List:='';
         end;
         List:=List+vartostr(rs.fields['SAMPLEUNITSECTION_ID'].value)+',';
         rs.movenext;
       end;
       rs.close;
       rs:=unassigned;

       if mapped then begin
         if list<>'' then
           UpdateTbl(List,section);
       end;
       except
       end;

    end;

begin
  OpenSQLQuery(Q, wwT_Qstns, SID);
  // Remove once squencing screen is activated
  cn.execute('Update Sel_Qstns set numMarkCount='+qpc_Section+' where subtype=3 and '+qpc_Section+'>0');
  //because of new border and shading we need translations to be
  //the same as english
  UpdateOtherLanguageComment;
  UpdateSampleSectionField;
end;

procedure tdmOpenQ.OpenSQLScales(const SID:integer);
begin
  OpenSQLQuery(S, wwT_Scls, SID);
end;

procedure tdmOpenQ.OpenSQLLogos(const SID:integer);
var LogoActive:boolean;
begin
  LogoActive := t_Logo_SQL.active;
  if not LogoActive then t_Logo_SQL.open;
  OpenSQLQuery(L, wwt_Logo, SID);
  if not LogoActive then t_logo_sql.close;
end;

procedure tdmOpenQ.OpenSQLTextBox(const SID:integer);
begin
  OpenSQLQuery(T, wwt_TextBox, SID);
end;

procedure tdmOpenQ.OpenSQLPCL(const SID:integer);
begin
  OpenSQLQuery(P, wwt_PCL, SID);
  GetPCLDimensions;
end;

procedure tdmOpenQ.GetPCLDimensions;
var w,h:integer;
    KD:boolean;
begin
  wwt_PCL.Filtered := false;
  wwt_PCL.First;
  while not wwt_PCL.EOF do begin
    if wwt_PCLKnownDimensions.Value = false then begin
      AnalyzePCLString(wwt_PCLPCLStream.value,w,h,kd);
      if kd then begin
        wwt_PCL.Edit;
        wwt_PCLWidth.value := w;
        wwt_PCLHeight.value := h;
        wwt_PCLKnowndimensions.value := kd;
        wwt_PCL.Post;
      end;
    end;
    wwt_PCL.next;
  end;
  wwt_PCL.Filtered := true;
end;

procedure tdmOpenQ.OpenSQLCover(const SID:integer);
begin
  OpenSQLQuery(C, wwt_Cover, SID);
end;

procedure tdmOpenQ.OpenSQLSkip(const SID:integer);
begin
  OpenSQLQuery(K, wwt_Skip, SID);
end;

procedure tdmOpenQ.OpenSQLQuery(const DQType:TDQTableType; var IntoTable:twwTable; const SID:integer);
var tbl : twwTable;
    tg : integer;
    deffld,qryfld : string;
    orgfiltered : boolean;
begin
  IntoTable.Close;
  with ww_Query do begin
    Close;
    Databasename := '_QualPro';
    SQL.Clear;
    SQL.Add('Select');
    wwt_TableDef.close;
    wwt_TableDef.open;
    qryfld := '';
    if ShowOpenStatus then
      with frmOpenStatus do begin
        label1.caption := 'Opening ' + typeString(DQType) + ' information ...';
        progressbar.position := progressbar.position + 12;
        refresh;
      end;
    batchmove.mappings.clear;
    while not wwt_TableDef.eof do begin
      if trim(wwt_tableDef.fieldbyname(typeString(DQType)).text) <> '' then begin
        deffld := wwt_tableDef.fieldbyname(typeString(DQType)).text;
        {if deffld <> 'Bitmap' then} begin
          if (deffld = 'Type') then
            QryFld := QryFld + '''' + typeString(DQType) + ''' as Type, '
          else
            QryFld := qryfld + deffld + ', ';
          if (deffld='Survey_ID') and (SID<>glbSurveyID) then begin
            qryfld := qryfld + inttostr(glbSurveyID) + ' as tempID, ';
            batchmove.mappings.add('Survey_ID=tempID');
          end else
            batchmove.mappings.add(deffld);
        end;
      end;
      wwt_TableDef.next;
    end;
    qryfld := copy(qryfld,1,length(qryfld)-2);
    sql.add(qryfld);
    SQL.ADD('from Sel_'+copy(IntoTable.name,5,255));
    SQL.ADD('where Survey_ID='+inttostr(SID));
    ExecSQL;
    tbl := twwTable.create(Self);
    try
      tbl.DatabaseName := '_PRIV';
      tbl.TableName := 'Sel_'+copy(IntoTable.name,5,255);
      TableDef(tbl,DQType,true);
      tbl.Active := True;
      with batchmove do begin
        source := ww_Query;
        destination := tbl;
        execute;
      end;
    finally
      tbl.free;
    end;
  end;
  with IntoTable do begin
    tag := 0;
    if not active then open;
    disablecontrols;
    orgfiltered := filtered;
    filtered := false;
    first;
    case DQType of
      Q: QryFld := 'SelQstns_ID';
      C: QryFld := 'SelCover_ID';
      else QryFld := qpc_ID;
    end;
    if DQType <> K then
      while not eof do begin
        if tag < fieldbyname(QryFld).value then
          tag := fieldbyname(QryFld).value;
        {if (DQType=L) and (t_logo_sql.findkey([wwt_logoID.value,wwt_logoCoverID,SID])) then begin
          edit;
          fieldbyname('Bitmap').assign(t_Logo_SQL.fieldbyname('Bitmap'));
          post;
        end;}
        next;
      end;
    filtered := orgfiltered;
    first;
    if DQType=Q then
      wwt_QstnsEnableControls
    else
      EnableControls;
  end;
end;
{$ENDIF}

procedure TDMOpenQ.DMOpenQDestroy(Sender: TObject);

begin
  Errorlist.free;
  dbQualpro.connected := false;
  dbScan.connected := false;
  dbQueue.connected := false;
  dbPriv.CloseDataSets;
  dbPriv.Connected := False; //GN03
  wwT_Qstns.close;
  wwT_Scls.close;
  wwT_Logo.close;
  wwT_TextBox.close;
  wwT_PCL.close;
  wwT_TableDef.close;
  wwT_Cover.close;
  wwT_Skip.close;
  wwT_TransQ.close;
  wwT_TransS.close;
  wwT_TransTB.close;
  wwT_TransP.close;
  wwt_ProblemScores.Close;
  t_Language.close;
  {$IFDEF FormLayout}
  DQDataModule.T_Constants.close;
  {$ELSE}
  wwt_PopSection.close;
  wwt_PopCover.close;
  wwt_PopCode.close;
  {$ENDIF}

  DelDotStar(tempdir+'\Sel_*.*');
  DelDotStar(tempdir+'\ProblemScores.*');
  deldotstar(tempdir+'\Verify*.*');
  delDotStar(tempdir+'\TBCntnts.*');
  delDotStar(tempdir+'\Constants.*');
  delDotStar(tempdir+'\MTSurv.*');
  Deletefile(tempdir+'\logo.bmp');
  Deletefile(tempdir+'\richtext.rtf');
  DelDotStar(tempdir+'\richtx*.rtf');
  Deletefile(tempdir+'\richedit.rtf');
  Deletefile(tempdir+'\PCL.prn');
  Deletefile(tempdir+'\DBDWORK.INI');
  Deletefile(tempdir+'\SCompare.rtf');
  Deletefile(tempdir+'\LCompare.rtf');
  Deletefile(tempdir+'\report.tmp');
  {$IFNDEF FormLayout}
  delDotStar(tempdir+'\PopSection.*');
  delDotStar(tempdir+'\PopCover.*');
  delDotStar(tempdir+'\PopCode.*');
  {$ENDIF}
{}
  delDotStar(tempdir+'\Tabledef.*');

  if vartype(cn) <> varEmpty then begin
    cn.close;
    cn:=unassigned;
  end;
  if vartype(sqlcn) <> varEmpty then begin
    if sqlcn.state = 1 then
      sqlcn.close;
    sqlcn:=unassigned;
  end;
  try
    deldotstar(tempdir+'\_QSQ*.?B');
  except
  end;
end;

procedure TDMOpenQ.QPQuery(const Qry:string; const Exe:boolean);
begin
  try
    if EXE then begin
      with TWWQuery.Create(self) do
        try
          close;
          databasename := '_QualPro';
          sql.clear;
          sql.add(qry);
          ExecSQL;
        finally
          free;
        end;
    end else
      with ww_Query do begin
        close;
        databasename := '_QualPro';
        sql.clear;
        sql.add(qry);
        open;
      end;
  except
    {$IFDEF FormLayout}
    on e:exception do
      messagedlg('SQL: '+e.message+#13+qry,mterror,[mbok],0);
    {$ENDIF}
  end;
end;

{$IFNDEF FormLayout}
procedure TDMOpenQ.ScanQuery(const Qry:string; const Exe:boolean);
begin
  try
    with ww_Query do begin
      close;
      databasename := '_Scan';
      sql.clear;
      sql.add(qry);
      if exe then
        ExecSQL
      else
        open;
    end;
  except
  end;
end;

procedure TDMOpenQ.QueueQuery(const Qry:string; const Exe:boolean);
begin
  try
    with ww_Query do begin
      close;
      databasename := '_Queue';
      sql.clear;
      sql.add(qry);
      if exe then
        ExecSQL
      else
        open;
    end;
  except
  end;
end;
{$ENDIF}

procedure TDMOpenQ.LibQuery(const Qry:string; const Exe:boolean);
begin
  with ww_Query do begin
    close;
    databasename := 'DataLib';
    sql.clear;
    sql.add(qry);
    if exe then
      ExecSQL
    else
      open;
  end;
end;

procedure TDMOpenQ.LocalQuery(const Qry:string; const Exe:boolean);
begin
  try
    if EXE then begin
      with TWWQuery.Create(self) do
        try
          close;
          databasename := '_PRIV';
          sql.clear;
          sql.add(qry);
          ExecSQL;
        finally
          free;
        end;
    end else
      with ww_Query do begin
        close;
        databasename := '_PRIV';
        sql.clear;
        sql.add(qry);
        open;
      end;
  except
{$IFDEF FormLayout}
    on e:exception do
      messagedlg('Local: '+e.message+#13+qry,mterror,[mbok],0);
{$ENDIF}
  end;
end;

procedure tDMOpenQ.SaveSectionOrder;
begin
  with tmptbl do begin
    indexfieldnames := qpc_Section;
    first;
    while not eof do begin
      if fieldbyname('numMarkCount').asInteger <> fieldbyname('newOrder').asinteger then
        cn.execute('update sel_qstns set numMarkCount='+fieldbyname('newOrder').asstring+
        ' where '+qpc_Section+'='+fieldbyname(qpc_Section).asString+' and subtype=3');
      next;
    end;
    close;
  end;
end;

procedure tDMOpenQ.DefaultSectionOrder(const Mock_up:boolean);
var cursect,lastsect:integer;
begin
  with tmpTbl do begin
    close;
    DatabaseName := '_PRIV';
    TableName := 'sel_SectOrder.DB';
    TableType := ttParadox;
    with FieldDefs do begin
      Clear;
      add(qpc_Section,ftInteger,0,false);
      add('SampleUnit_id',ftInteger,0,false);
      add('Label',ftString,60,false);
      add('numMarkCount',ftinteger,0,false);
      add('newOrder',ftinteger,0,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('Section', qpc_Section+';SampleUnit_id', [ixPrimary]);
      add('NumMarkCount','NumMarkCount',[]);
      add('NewOrder','NewOrder',[]);
    end;
    createtable;
  end;
  if mock_up then
    dmOpenQ.LocalQuery('Select '+qpc_Section+',1 as SampleUnit_id,label,numMarkCount,numMarkCount as newOrder from Sel_Qstns where subtype=3 and '+qpc_Section+'>0 and language='+inttostr(currentLanguage),false)
  else
    dmOpenQ.LocalQuery('Select '+qpc_Section+',SampleUnit_id,label,numMarkCount,numMarkCount as newOrder from Sel_Qstns where subtype=3 and '+qpc_Section+'>0',false);
  tmptbl.batchmove(dmOpenQ.ww_Query,batAppend);
  dmOpenQ.ww_query.close;
  with tmptbl do begin
    open;
    indexfieldnames := 'numMarkCount';
    first;
    lastsect := 0;
    curSect := 0;
    while not eof do begin
      edit;
      if fieldbyname('numMarkCount').isnull then begin
        inc(curSect);
        fieldbyname('newOrder').value := curSect;
        lastsect := 0;
      end else begin
        if fieldbyname('numMarkCount').value <> lastsect then
          inc(curSect);
        fieldbyname('newOrder').value := curSect;
        lastsect := fieldbyname('numMarkCount').value;
      end;
      next;
    end;
  end;
end;

function tdmOpenQ.SQLString(const s:string; const delim:boolean):string;
var i,c : integer;
begin
  result := '''';
  c := 0;
  for i := 1 to length(s) do begin
    if (s[i]<#32) then begin
      //result := result + '''+char('+inttostr(ord(s[i]))+')+''';
      //c := 0;
    end else if (s[i]>#126) then begin
      result := result + s[i];
      inc(c);
    end else if s[i]='''' then begin
      result := result + '''''';
      inc(c,2);
    end else begin
      result := result + s[i];
      inc(c);
    end;
    if c>=250 then begin
      if delim then result := result + '''' + chr(1) + ''''
      else          result := result + '''+''';
      c := 0;
    end;
  end;
  result := result + '''';
  if delim then result := result + chr(1);
  //while pos('+''''+',result)>0 do delete(result,pos('+''''+',result),3);
end;

{$IFDEF FormLayout}
procedure tdmOpenQ.DeleteSQLSurvey;
begin
  with ww_Query do begin
    Close;
    Databasename := '_QualPro';
    SQL.Clear;
    if not laptop then
      sql.add('execute sp_FL_ClearSurvey '+inttostr(glbSurveyID))
    else begin
      SQL.Add('Delete from Sel_Scls where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from Sel_Qstns where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from Sel_Skip where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from Sel_Logo where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from Sel_TextBox where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from Sel_PCL where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from Sel_Cover where Survey_ID='+inttostr(glbSurveyID));
      ExecSQL; sql.clear;
      SQL.Add('Delete from SurveyLanguage where Survey_ID='+inttostr(glbSurveyID));
    end;
    ExecSQL;
  end;
end;

function tdmOpenQ.VerifySave:boolean;
var s : string;
begin
  s := verifyLoadSave;
  result := (s='');
  if result then begin
    F_DynaQ.MyMessage('Survey was saved successfully.');
  end else begin
    messagedlg(s+#13+'The above items did not save properly.  To avoid losing any work, please save as a template.',mterror,[mbok],0);
  end;
end;

function tdmOpenQ.VerifyLoad:boolean;
var s : string;
begin
  s := verifyLoadSave;
  result := (s='');
  if not result then begin
    messagedlg(s+#13+'The above items did not load properly for survey '+inttostr(glbSurveyid)+'.',mterror,[mbok],0);
  end;
end;

function tdmOpenQ.VerifyLoadSave:String;
var s : string;
    OKQstn,OKScls,OKSkip,OKCover,OKLogo,OKTextBox,OKPCL:boolean;
  function filematch(const fn1,fn2:string):boolean;
  var f1,f2 : file of byte;
      b1,b2 : byte;
  begin
    assignfile(f1,fn1);
    assignfile(f2,fn2);
    reset(f1);
    reset(f2);
    result := true;
    while result and (not eof(f1)) do begin
      read(f1,b1);
      read(f2,b2);
      result := (b1=b2);
    end;
    result := result and (eof(f1)) and (eof(f2));
    closefile(f1);
    closefile(f2);
  end;
  function CompareData(tablename:string; keyflds,compareflds:array of string): boolean;
  var i : integer;
  begin
    F_DynaQ.myMessage('Verifying '+tablename);
    with F_DynaQ.ProgressBar do
      Position := Position + 12;
    if ShowOpenStatus then
      with frmOpenStatus do begin
        label1.caption := 'Verifying '+tablename;
        progressbar.position := progressbar.position + 12;
        refresh;
      end;
    s := 'Select ';
    for i := low(keyflds) to high(keyflds) do s := s + 'convert(int,'+keyflds[i]+') as '+keyflds[i]+',';
    for i := low(compareflds) to high(compareflds) do s := s + compareflds[i]+',';
    delete(s,length(s),1);
    s := s + ' from ' + tablename + ' where survey_id='+inttostr(glbSurveyID);
    QPQuery(s,false);
    with tmpTbl do begin
      DatabaseName := 'PRIV';
      TableName := 'Verify.DB';
      batchMove(TBDEDataSet(ww_Query), batCopy);
      close;
    end;
    s := 'Select ';
    for i := low(keyflds) to high(keyflds) do
      s := s + 'S.'+keyflds[i]+' as S'+keyflds[i]+',';
    for i := low(compareflds) to high(compareflds) do
      s := s + 'S.'+compareflds[i]+' as S'+compareflds[i]+',';
    for i := low(keyflds) to high(keyflds) do
      s := s + 'L.'+keyflds[i]+' as L'+keyflds[i]+',';
    for i := low(compareflds) to high(compareflds) do
      s := s + 'L.'+compareflds[i]+' as L'+compareflds[i]+',';
    delete(s,length(s),1);
    s := s + ' from '+tablename+' L FULL OUTER JOIN Verify S ON ';
    for i := low(keyflds) to high(keyflds) do
      s := s + 'L.'+keyflds[i]+'=S.'+keyflds[i]+' and ';
    delete(s,length(s)-3,4);
    LocalQuery(s,false);
    with tmpTbl do begin
      TableName := 'Verify2.DB';
      batchMove(TBDEDataSet(ww_Query), batCopy);
      open;
    end;
    s := 'Select * from Verify2 where ';
    s := s + 'S'+keyflds[01]+' is null or L'+keyflds[01]+' is null or ';
    for i := low(compareflds) to high(compareflds) do
      if (tmptbl.FieldByName('S'+compareflds[i]).datatype<>ftBlob)
        and (tmptbl.FieldByName('S'+compareflds[i]).datatype<>ftMemo)
        and (tmptbl.FieldByName('S'+compareflds[i]).datatype<>ftGraphic) then
        s := s + 'S'+compareflds[i]+'<>L'+compareflds[i]+' or ';
    delete(s,length(s)-2,3);
    LocalQuery(s,false);
    result := (ww_Query.RecordCount=0);
    if result then begin
      for i := low(compareflds) to high(compareflds) do
        with tmptbl do
          if (FieldByName('S'+compareflds[i]).datatype=ftBlob)
              or (FieldByName('S'+compareflds[i]).datatype=ftMemo)
              or (FieldByName('S'+compareflds[i]).datatype=ftGraphic) then begin
            first;
            while result and (not eof) do begin
              if (FieldByName('S'+compareflds[i]).datatype=ftBlob) then
                tBlobfield(FieldByName('S'+compareflds[i])).SaveToFile(tempdir+'\SCompare.rtf')
              else if (FieldByName('S'+compareflds[i]).datatype=ftMemo) then
                tMemofield(FieldByName('S'+compareflds[i])).SaveToFile(tempdir+'\SCompare.rtf')
              else if (FieldByName('S'+compareflds[i]).datatype=ftGraphic) then
                tGraphicfield(FieldByName('S'+compareflds[i])).SaveToFile(tempdir+'\SCompare.rtf');
              if (FieldByName('L'+compareflds[i]).datatype=ftBlob) then
                tBlobfield(FieldByName('L'+compareflds[i])).SaveToFile(tempdir+'\LCompare.rtf')
              else if (FieldByName('L'+compareflds[i]).datatype=ftMemo) then
                tMemofield(FieldByName('L'+compareflds[i])).SaveToFile(tempdir+'\LCompare.rtf')
              else if (FieldByName('L'+compareflds[i]).datatype=ftGraphic) then
                tGraphicfield(FieldByName('L'+compareflds[i])).SaveToFile(tempdir+'\LCompare.rtf');
              result := filematch(tempdir+'\SCompare.rtf',tempdir+'\LCompare.rtf');
              next;
            end;
          end;
    end;
    //if not result then
    //  viewdata(tdataset(ww_Query),nil);
    tmptbl.close;
  end;

begin
//OKQstn:=true;OKScls := true;OKSkip := true;OKCover := true;OKLogo := true;OKTextBox := true;OKPCL := true;
  f_DynaQ.ProgressBar.Position := 14;
  if ShowOpenStatus then
    frmOpenStatus.progressbar.position := 0;
  OKQstn := CompareData('Sel_Qstns',['SelQstns_id','Language'],['QstnCore','Label','RichText']);
  OKScls := CompareData('Sel_Scls',[qpc_ID, 'Item', 'Language'], ['ScaleOrder','Label','RichText']);
  OKSkip := CompareData('Sel_Skip',['SelQstns_id', 'SelScls_id', 'ScaleItem'], ['numSkip']);
  OKLogo := CompareData('Sel_Logo',[qpc_ID], ['Y','Bitmap']);
  OKTextBox := CompareData('Sel_TextBox',[qpc_ID, 'Language'], ['Y','RichText']);
  OKPCL := CompareData('Sel_PCL',[qpc_ID, 'Language'], ['Y','PCLStream']);
  OKCover := CompareData('Sel_Cover',['SelCover_ID'], ['PageType']);
  if not f_DynaQ.UserPanel.Ctl3d then
    viewdata(tdataset(wwT_Scls),nil,['']);
  localQuery('select '+qpc_Section+',Subsection,QstnCore,ScaleID,'+qpc_ID+' as Scale '+
    'from sel_qstns sq FULL OUTER JOIN sel_scls ss ON sq.scaleid=ss.'+qpc_ID+' '+
    'where sel_qstns.subtype=1 and ss.'+qpc_ID+' is null '+
    'order by '+qpc_Section+',subsection,qstncore',false);
  if ww_Query.recordcount>0 then begin
    OKScls := false;
    viewdata(tdataset(ww_Query),nil,[
      'ERROR: There are some questions on the survey that do not have scales.  The section(s)',
      'and subsection(s) they are in are listed above.  Please delete one of each ScaleID from the',
      'survey and then add it back in.  That should restore the scales.']);
  end;
  ww_Query.close;
  s := '';
  if not OKQstn then s := s + 'Questions, ';
  if not OKScls then s := s + 'Scales, ';
  if not OKSkip then s := s + 'Skips, ';
  if not OKCover then s := s + 'Covers, ';
  if not OKTextBox then s := s + 'TextBoxes, ';
  if not OKLogo then s := s + 'Bitmaps, ';
  if not OKPCL then s := s + 'PCLs, ';
  delete(s,length(s)-1,2);
  result := S;
end;

function tdmOpenQ.SaveSQLSurvey(const NowValid,Closing:boolean):boolean;
var ExePath,SafetyNet : string;
    zExePath : array[0..127] of char;
    i : integer;
  Procedure SaveValidFlag(const flg:boolean);
  begin
    with ww_Query do begin
      close;
      databasename := '_QualPro';
      sql.clear;
      sql.add('UPDATE Survey_def');
      if laptop then
        sql.add('SET bitLayoutValid = false')
      else if flg then
        sql.add('SET bitLayoutValid = 1')
      else
        sql.add('SET bitLayoutValid = 0');
      sql.add('where survey_ID='+inttostr(glbSurveyID));
      ExecSQL;
      Validated := flg;
    end;
  end;
  Procedure SaveSurveyLanguage;
  begin
    ww_Query.close;
    ww_Query.sql.clear;
    with t_language do begin
      first;
      while not eof do begin
        if (fieldbyname('LangID').value=1) or (fieldbyname('UseLang').asboolean) then begin
          ww_Query.sql.add('INSERT into SurveyLanguage (Survey_ID, LangID) '+
              'VALUES (' + inttostr(glbSurveyID) + ', ' +
              fieldbyname('LangID').asstring +')');
          if laptop then begin
            ww_Query.ExecSQL;
            ww_Query.sql.clear;
          end;
        end;
        next;
      end;
    end;
    if not laptop then
      ww_Query.ExecSQL;
  end;
  procedure MoveFlds(DQType:TDQTableType;var tbl:twwTable);
  var LogoActive,orgfiltered : boolean;
      s : string;
  begin
    with F_DynaQ.ProgressBar do
      Position := Position + 12;
    s := 'SELECT ';
    with wwT_TableDef do begin
      first;
      while not eof do begin
        if (trim(fieldbyname(typeString(DQType)).text)<>'') and
           (fieldbyname(typeString(DQType)).text <> 'Type') then
          s := s + fieldbyname(typeString(DQType)).text+',';
        next;
      end;
    end;
    delete(s,length(s),1);
    s := s + ' into #MySel_'+copy(Tbl.name,5,255)+' from Sel_'+copy(Tbl.name,5,255)+' where 1=2';
    QPQuery(s,true);
    if (tbl.recordcount > 0) then begin
      if dqtype=L then begin
        LogoActive := t_Logo_SQL.active;
        if LogoActive then t_Logo_SQL.close;
        t_Logo_SQL.TableName := '#MySel_Logo';
        t_Logo_SQL.open;
        orgFiltered := wwt_logo.filtered;
        wwt_logo.filtered := false;
        BatchMove_SelLogo.execute;
        wwt_logo.filtered := orgfiltered;
        t_Logo_SQL.close;
        t_Logo_SQL.TableName := 'dbo.Sel_Logo';
        if LogoActive then t_logo_sql.open;
      end else begin
        orgFiltered := tbl.filtered;
        tbl.filtered := false;

        //fg- Delete records with null values for these fields...
        //Null values cause batchmove object to fail
        if uppercase(tbl.TableName) = 'SEL_QSTNS.DB' then
           cn.execute('delete from SEL_QSTNS where (SELQSTNS_ID is null) or (SURVEY_ID is null) or (LANGUAGE is null) or (SCALEID is null) or (BITMEANABLE is null) or (QSTNCORE is null) or (BITLANGREVIEW is null)');

        with tmptbl do begin
          Close;
          DatabaseName := '_QualPro';
          TableName := '#MySel_'+copy(Tbl.name,5,255);
          open;
        end;
        with batchmove do begin
          source := tbl;
          destination := tmptbl;
          mappings.clear;
          with wwT_TableDef do begin
            first;
            while not eof do begin
              if (trim(fieldbyname(typeString(DQType)).text)<>'') and
                 (fieldbyname(typeString(DQType)).text <> 'Type') then
                mappings.add(fieldbyname(typeString(DQType)).text);
              next;
            end;
          end;
          execute;
        end;

        tbl.filtered := orgFiltered;

      end;
    end;
  end;
  procedure SQLSaveTransaction;
  var SP_there : boolean;
  begin
    QPQuery('select name from sysobjects where name=''sp_FL_SaveSurvey''',false);
    SP_there := (ww_Query.recordcount=1);
    with ww_Query do begin
      close;
      sql.clear;
      if sp_there then
      begin
       // sql.add('execute sp_FL_AuditSurvey '+ IntToStr(glbSurveyID) +  ', ' + getUser); //GN04
        sql.add('execute sp_FL_SaveSurvey '+inttostr(glbSurveyID));
      end
      else begin
        sql.add('BEGIN TRANSACTION');

        sql.add('EXEC sp_FL_ClearSurvey '+inttostr(glbsurveyid));
        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('END');

        sql.add('INSERT INTO Sel_Qstns (SelQstns_id, Survey_id, Language, ScaleID, '+qpc_Section+', Label, PlusMinus, Subsection, Item, Subtype, Width, Height, RichText, ScalePos, ScaleFlipped, NumMarkCount, bitMeanable, numBubbleCount, QstnCore, bitLangReview)');
        sql.add('  SELECT  SelQstns_id,Survey_id,Language,ScaleID,'+qpc_Section+',Label,PlusMinus,Subsection,Item,Subtype,Width,Height,RichText,ScalePos,ScaleFlipped,numMarkCount,bitMeanable,numBubbleCount,QstnCore,bitLangReview');
        sql.add('    FROM #MySel_Qstns');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('INSERT INTO Sel_Scls (Survey_id, '+qpc_ID+', Item, Language, Val, Label, RichText, Missing, Charset, ScaleOrder, intRespType)');
        sql.add('  SELECT Survey_id,'+qpc_ID+',Item,Language,Val,Label,RichText,Missing,Charset,ScaleOrder,intRespType');
        sql.add('    FROM #MySel_Scls');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('INSERT INTO Sel_Skip (Survey_id,SelQstns_id,SelScls_id,ScaleItem,numSkip,numSkipType)');
        sql.add('  SELECT Survey_id,SelQstns_id,SelScls_id,ScaleItem,numSkip,numSkipType');
        sql.add('    FROM #MySel_Skip');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('INSERT INTO Sel_Logo ('+qpc_ID+',CoverID,Survey_id,Description,X,Y,Width,Height,Scaling,Bitmap,Visible)');
        sql.add('  SELECT '+qpc_ID+',CoverID,Survey_id,Description,X,Y,Width,Height,Scaling,Bitmap,Visible');
        sql.add('    FROM #MySel_Logo');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('INSERT INTO Sel_TextBox ('+qpc_ID+',Survey_id,Language,CoverID,X,Y,Width,Height,RichText,Border,Shading,bitLangReview,Label)');
        sql.add('  SELECT '+qpc_ID+',Survey_id,Language,CoverID,X,Y,Width,Height,RichText,Border,Shading,bitLangReview,Label');
        sql.add('    FROM #MySel_TextBox');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('INSERT INTO Sel_PCL ('+qpc_ID+',Survey_id,Language,CoverID,Description,X,Y,Width,Height,PCLStream,KnownDimensions)');
        sql.add('  SELECT '+qpc_ID+',Survey_id,Language,CoverID,Description,X,Y,Width,Height,PCLStream,KnownDimensions');
        sql.add('    FROM #MySel_PCL');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('INSERT INTO Sel_Cover (SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead)');
        sql.add('  SELECT SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead');
        sql.add('    FROM #MySel_Cover');

        sql.add('if @@error <> 0');
        sql.add('begin');
        sql.add('  ROLLBACK TRANSACTION');
        sql.add('  RETURN');
        sql.add('end');

        sql.add('COMMIT TRANSACTION');
      end;
      sql.add('DROP TABLE #MySel_Qstns');
      sql.add('DROP TABLE #MySel_Scls');
      sql.add('DROP TABLE #MySel_Skip');
      sql.add('DROP TABLE #MySel_Cover');
      sql.add('DROP TABLE #MySel_TextBox');
      sql.add('DROP TABLE #MySel_PCL');
      sql.add('DROP TABLE #MySel_Logo');
      ExecSQL;
    end;
  end;

  procedure UpdateMapping(glbSurveyID:integer);
  var rs:variant;
      List:string;
      sql:string;
      section:string;
      SampleUnits:string;
  begin
    try
    rs:= cn.execute('Select distinct SECTION_ID, SAMPLEUNITSECTION_ID '+
                    'from sel_qstns '+
                    'where subtype ='+inttostr(stSection)+
                    ' and language = 1'+
                    ' and SAMPLEUNITSECTION_ID is not null');

    section:='';
    List:='';
    sql:='';
    while not rs.eof do begin
      section := vartostr(rs.fields['SECTION_ID'].value);
      SampleUnits := vartostr(rs.fields['SAMPLEUNITSECTION_ID'].value);
      List:=List+SampleUnits+',';

      if pos(',',SampleUnits)>0 then
        SampleUnits := 'in ('+SampleUnits+')'
      else
        SampleUnits := '= '+SampleUnits;

      sql:=sql+'Update SAMPLEUNITSECTION '+
               'SET SELQSTNSSECTION = '+section+
               'where SAMPLEUNITSECTION_ID '+SampleUnits+
               ' and SELQSTNSSURVEY_ID = '+inttostr(glbSurveyID)+
               #13#10;


      rs.movenext;
    end;
    rs.close;
    rs:=UnAssigned;
    SetLength(List,Length(List)-1);
    SetLength(sql,Length(sql)-2);
    if (sql <> '') and (List <> '') then
    begin
      List := 'delete '+
              'from SAMPLEUNITSECTION '+
              'where SAMPLEUNITSECTION_ID not in('+List+')'+
              ' and SELQSTNSSURVEY_ID = '+inttostr(glbSurveyID);
      sqlcn.execute(List);
      sqlcn.execute(sql);
    end;
    except
    end;

  end;

var response:integer;
label 1;
begin
  response := ID_YES;
  result := false;

  if (not Validated) or
    (Validated and NowValid) or
    ((Validated) and (not NowValid) and
    (messagedlg('This survey layout has already been validated.  Saving over a '+
      'validated layout will invalidate the survey and prevent further mailings '+
      'until it''s re-validated.'#13#10'Are you sure you want to save your changes?',
      mtConfirmation,[mbYes,mbNo],0)=mrYes)) then
  with F_DynaQ do begin
    if DeletedAddedSections then  begin
      {GN01:
      if Closing then
        response := MessageBox(Screen.ActiveForm.Handle,'You have either Added or Deleted a section to your form.'#13#10+
                                             'Before you proceed please make sure you run a Question Mapping report.'#13#10#13#10+
                                             'Do you want to Save your changes?'#13#10+
                                             '   Yes. Save changes and exit.'#13#10+
                                             '   No. Do not save changes and go back to FormLayout.'#13#10,
                                             'LAST WARNING!!!',
                                             MB_APPLMODAL or MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2)
      else
        response := MessageBox(Screen.ActiveForm.Handle,'You have either Added or Deleted a section to your form.'#13#10+
                                             'Before you proceed please make sure you run a Question Mapping report.'#13#10#13#10+
                                             'Do you want to Save your changes?'#13#10+
                                             '   Yes. Save changes.'#13#10+
                                             '   No. Do not save changes.'#13#10,
                                             'LAST WARNING!!!',
                                             MB_APPLMODAL or MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2);

      if response = ID_NO then
        goto 1;
      }
      UpdateMapping(glbSurveyID);
      DeletedAddedSections := false;
    end;
    Screen.cursor := crHourglass;
    myMessage('Saving '+inttostr(glbSurveyID));
    AssignCmntBoxNums;
    try
      ProgressBar.Position := 14;
      ProgressBar.left := StatusPanel.Width - 160;
      ProgressBar.Visible := true;
      myMessage('Saving '+inttostr(glbSurveyID)+' Questions');
      MoveFlds(Q,wwt_Qstns);
      myMessage('Saving '+inttostr(glbSurveyID)+' Scales');
      MoveFlds(S,wwT_Scls);
      myMessage('Saving '+inttostr(glbSurveyID)+' Skip Patterns');
      MoveFlds(K,wwT_Skip);
      myMessage('Saving '+inttostr(glbSurveyID)+' Logos && Signatures');
      MoveFlds(L,wwT_Logo);
      myMessage('Saving '+inttostr(glbSurveyID)+' Text Boxes');
      cn.execute('delete from sel_TextBox where Type is null');
      cn.execute('update sel_TextBox set Label = ''## NO LABEL ##'' where Label = '''' or Label is null'); // 10/2/2014 CJB these labels get turned back to blanks in SP_FL_SaveSurvey
      MoveFlds(T,wwT_TextBox);
      cn.execute('update sel_TextBox set Label = '''' where Label = ''## NO LABEL ##'' or Label is null'); // 10/2/2014 CJB these labels get turned back to blanks in SP_FL_SaveSurvey
      myMessage('Saving '+inttostr(glbSurveyID)+' PCL Inserts');
      MoveFlds(P,wwT_PCL);
      myMessage('Saving '+inttostr(glbSurveyID)+' Cover Letters && Postcards');
      MoveFlds(C,wwT_Cover);
      myMessage('Saving '+inttostr(glbSurveyID)+' Language options');
      tmptbl.close;
      SQLSaveTransaction;
      SaveSurveyLanguage;
      result := true;
    except
      on e:exception do begin
        MessageDlg(E.Message,mterror,[mbok],0);
        clipboard.astext := e.message;
        SaveValidFlag(false);
        SafetyNet := f_DynaQ.caption;
        delete(safetynet,1,5+pos('Study:',SafetyNet));
        delete(safetynet,pos('Survey:',SafetyNet),7);
        while pos('  ',safetynet)>0 do
          delete(safetynet,pos('  ',safetynet),1);
        while pos('*',Safetynet)>0 do delete(safetynet,pos('*',Safetynet),1);
        while pos('?',Safetynet)>0 do delete(safetynet,pos('?',Safetynet),1);
        while pos('\',Safetynet)>0 do delete(safetynet,pos('\',Safetynet),1);
        while pos('"',Safetynet)>0 do delete(safetynet,pos('"',Safetynet),1);
        while pos('.',Safetynet)>0 do delete(safetynet,pos('.',Safetynet),1);
        while pos('|',Safetynet)>0 do delete(safetynet,pos('|',Safetynet),1);
        while pos('%',Safetynet)>0 do delete(safetynet,pos('%',Safetynet),1);
        while pos('/',Safetynet)>0 do delete(safetynet,pos('/',Safetynet),1);
        while pos(':',Safetynet)>0 do delete(safetynet,pos(':',Safetynet),1);
        while pos('<',Safetynet)>0 do delete(safetynet,pos('<',Safetynet),1);
        while pos('>',Safetynet)>0 do delete(safetynet,pos('>',Safetynet),1);
        for i := 127 to 255 do
          while pos(chr(i),Safetynet)>0 do
            delete(safetynet,pos(chr(i),Safetynet),1);
        SafetyNet := 'c:\'+safetynet + ' ' + FormatDateTime('mm"-"dd"-"yyyy hh"."mm', now) + '.db';
        Savedialog.filename := SafetyNet;
        SaveSurvey;
        MessageDlg('Something went wrong when you tried to save the survey to '+
         'SQL.  The specific error message has been copied to the clipboard and '+
         'your work has been saved as a template file ('+safetynet+')',mterror,[mbok],0);
        result := false;
      end;
    end;
    if result then begin
      result := VerifySave;
      if (not laptop) then begin
        ExePath := extractfilepath(application.exename) + 'SaveTagFields.exe';
        if fileexists(ExePath) then begin
          myMessage('Running SaveTagFields');
          //i := ExecuteFile(ExePath,inttostr(glbSurveyID),'',sw_shownormal);
          //i := -1;
          //i := WinExec(strPcopy(zExePath,ExePath+' '+inttostr(glbSurveyID)),sw_shownormal);
          F_DynaQ.LunchWithHandle(ExePath+' '+inttostr(glbSurveyID));
          myMessage('Saving Valid Flag');
          SaveValidFlag(NowValid);
        end else begin
          messagedlg('Cannot find '+getcurrentdir+'\SaveTagFields.exe - survey personalization will not work.',mterror,[mbok],0);
          SaveValidFlag(false);
        end;
      end;
      SaveDialog.tag := 1;
    end;
    myMessage('');
    ProgressBar.Visible := false;
    ProgressBar.Position := 0;
    Screen.cursor := crDefault;
    SaveDialog.Tag := 1;
  end;
  1:
  tmptbl.Close;
  //SaveDialog.Tag := 1;
end;

procedure tdmOpenQ.wwt_QstnsUpdateLangInfo;
begin
  wwt_TransQ.filtered := false;
  wwt_TransQ.IndexFieldName := 'Survey_ID;SelQstns_ID;Language';
  wwt_Qstns.indexfieldname := 'Survey_ID;SelQstns_ID;Language';
  wwt_Qstns.findkey([glbSurveyID,1,1]);
  with t_Language do begin
    first;
    next;
    while not eof do begin
      if (fieldbyname('UseLang').asboolean) and (not wwt_TransQ.findkey([glbSurveyID,wwt_QstnsID.value,fieldbyname('LangID').value])) then begin
        wwt_TransQ.Append;
        wwt_Transq.fieldbyname('Survey_ID').value := glbSurveyID;
        wwt_Transq.fieldbyname('SelQstns_ID').value := wwt_QstnsID.value;
        wwt_Transq.fieldbyname('Type').text := wwt_QstnsType.value;
        wwt_Transq.fieldbyname(qpc_Section).value := wwt_QstnsSection.value;
        wwt_Transq.fieldbyname('Subsection').value := wwt_QstnsSubsection.value;
        wwt_Transq.fieldbyname('Item').value := wwt_QstnsItem.value;
        wwt_Transq.fieldbyname('Label').text := wwt_QstnsLabel.value;
        wwt_Transq.fieldbyname('PlusMinus').text := wwt_QstnsPlusMinus.value;
        wwt_Transq.fieldbyname('SubType').value := wwt_QstnsSubType.value;
        wwt_Transq.fieldbyname('Language').value := fieldbyname('LangID').value;
        wwt_TransQ.Post;
      end else
        if (not fieldbyname('UseLang').asboolean) and (wwt_TransQ.findkey([glbSurveyID,1,fieldbyname('LangID').value])) then
          wwt_transq.Delete;
      next;
    end;
  end;
  wwt_Qstns.indexfieldname := qpc_Section+';SubSection;Item';
  wwt_TransQ.filtered := true;
end;

function TDMOpenQ.PRNDir : string;
begin
  if dmopenq.LapTop then
    PRNDir := GetUserParam('PRNDir')
  else begin
    QPQuery('select STRPARAM_VALUE from qualpro_params where strParam_nm=''PCLGenPrnLoc_TP''',false);
    PRNDir := ww_Query.fieldbyname('STRPARAM_VALUE').value;
  end;
end;

function TDMOpenQ.PDFDir : string;
begin
  if dmopenq.LapTop then
    PDFDir := GetUserParam('PDFDir')
  else begin
    QPQuery('select STRPARAM_VALUE from qualpro_params where strParam_nm=''PCLGenPdfLoc_TP''',false);
    PDFDir := ww_Query.fieldbyname('STRPARAM_VALUE').value;
  end;
end;
{$ENDIF}

procedure TDMOpenQ.tmptblAfterClose(DataSet: TDataSet);
begin
  with tmptbl do begin
    filtered := false;
    filter := '';
    indexfieldnames := '';
    mastersource := nil;
    masterfields := '';
    //tablename := '';
    //databasename := '';
  end;
end;

procedure tdmOpenQ.DownLoadLogo(const whereclause:string);
begin
{$IFNDEF FormLayout}
  LocalQuery('Select Survey_ID, '+qpc_ID+', CoverID, ''Logo'' as Type, '+
      'Description, X, Y, Width, Height, Scaling, Visible '+
      'from LocalSelLogo ' + whereclause,false);
  if ww_Query.fieldbyname(qpc_ID).isnull then begin
    QPQuery('Select Survey_ID, '+qpc_ID+', CoverID, ''Logo'' as Type, '+
      'Description, X, Y, Width, Height, Scaling, Visible, Bitmap '+
      'from Sel_Logo ' + whereclause,false);
    if ww_Query.recordcount>0 then begin
      tBlobField(ww_Query.fieldbyname('Bitmap')).savetofile(dmopenq.tempdir+'\logo.bmp');
    end else
      {'Can''t find logo '+s};
  end;
{$ENDIF}
end;

procedure tdmOpenQ.BubbleLocAppend(const vSelQstns_id,vItem,vSampUnit,vCharset,vValue,vRespType,vRelX,vRelY,vScaleID:integer);
begin
{$IFNDEF FormLayout}
  inc(nBblLoc);
  aBblLoc[nBblLoc,1] := vSelQstns_id;
  aBblLoc[nBblLoc,2] := vItem;
  aBblLoc[nBblLoc,3] := vSampUnit;
  aBblLoc[nBblLoc,4] := vCharset;
  aBblLoc[nBblLoc,5] := vValue;
  aBblLoc[nBblLoc,6] := vRespType;
  aBblLoc[nBblLoc,7] := vRelX;
  aBblLoc[nBblLoc,8] := vRelY;
  aBblLoc[nBblLoc,9] := vScaleID;
{Remove after unit testing:}
{Also, remove tBubbleLoc & tCommentLoc from uLayoutCalc (?)
  localquery('insert into bblloc (Questionform_id,SelQstns_ID,Item,SampleUnit_id,Charset,Val,IntRespType,RelX,RelY) values ('+dmPCLGen.qf_id+','+
    format('%d,%d,%d,%d,%d,%d,%d,%d)',[vSelQstns_id,vItem,vSampUnit,vCharset,vValue,vRespType,vRelX,vRelY]),true);
{}
{$ENDIF}
end;

procedure tdmOpenQ.HandwrittenAppend(const vSelQstns_id,vItem,vSampUnit,vline,vRelX,vRelY,vWidth,vScaleID:integer);
begin
{$IFNDEF FormLayout}
  inc(nHWLoc);
  aHWLoc[nHWLoc,1] := vSelQstns_id;
  aHWLoc[nHWLoc,2] := vItem;
  aHWLoc[nHWLoc,3] := vSampUnit;
  aHWLoc[nHWLoc,4] := vLine;
  aHWLoc[nHWLoc,5] := vRelX;
  aHWLoc[nHWLoc,6] := vRelY;
  aHWLoc[nHWLoc,7] := vWidth;
  aHWLoc[nHWLoc,8] := vScaleID;
{$ENDIF}
end;

procedure tdmOpenQ.CmntLocAppend(const vSelQstns_id,vLine,vSampUnit,vRelX,vRelY,vWidth,vHeight:integer);
begin
{$IFNDEF FormLayout}
  inc(nCmntLoc);
  aCmntLoc[nCmntLoc,1] := vSelQstns_id;
  aCmntLoc[nCmntLoc,2] := vLine;
  aCmntLoc[nCmntLoc,3] := vSampUnit;
  aCmntLoc[nCmntLoc,4] := vRelX;
  aCmntLoc[nCmntLoc,5] := vRelY;
  aCmntLoc[nCmntLoc,6] := vWidth;
  aCmntLoc[nCmntLoc,7] := vHeight;
{Remove after unit testing:
  localquery('insert into cmntloc (Questionform_id,SelQstns_ID,Line,SampleUnit_id,RelX,RelY,Width,Height) values ('+dmPCLGen.qf_id+','+
    format('%d,%d,%d,%d,%d,%d,%d)',[vSelQstns_id,vLine,vSampUnit,vRelX,vRelY,vWidth,vHeight]),true);
{}
  if nCmntLoc=6 then
    CmntLocFlush;
{$ENDIF}
end;

function tdmOpenQ.BblLocFlush:integer;
var s : string;
    ge_org,n,i,j : integer;
begin
  result := 0;
{$IFNDEF FormLayout}
  if nBblLoc>0 then begin
    ge_org := dmOpenQ.GenError;
    Generror := 29;
    n := 0;
    s := 'exec sp_pcl_insertinto_Bblloc '+dmPCLGen.qf_id;
    for i := 1 to nBblLoc do begin
      for j := 1 to 8 do
        s := s + ','+inttostr(aBblLoc[i,j]);
      inc(n);
      if (n=6) or (i=nBblLoc) then begin
        ScanQuery(s,true);
        n := 0;
        s := 'exec sp_pcl_insertinto_Bblloc '+dmPCLGen.qf_id;
      end;
    end;
    nBblLoc := 0;
    dmOpenQ.GenError := ge_org;
  end;
{$ENDIF}
(*
We could greatly reduce the amount of traffic & storage space by making
"BubbleItemPos"/"BubbleLoc" a lookup table instead of a child table.

If Bubble location information was stored in the following tables:
CREATE TABLE #QuestionPos
  (QuestionForm_id numeric(18,0),   SampleUnit_id numeric(18,0),
   intPage_num integer,             QstnCore integer,
   intBegColumn integer,            ScalePos_id numeric(18,0),
   X_Pos integer,                   Y_Pos integer,
   intResponseCol integer)

CREATE TABLE #ScalePos
  (ScalePos_id numeric(18,0),       Scale integer,
   X_Rel1 integer,                  Y_Rel1 integer,
   X_RelN integer,                  Y_RelN integer,
   ReadMethod_id numeric(18,0))

CREATE TABLE #BubblePos
  (ScalePos_id numeric(18,0),       Item integer,
   Val integer,                     X_Rel integer,
   Y_Rel integer)
   
ScalePos is a lookup table for QuestionPos and BubblePos is a child
table for ScalePos.

You could find a ScalePos to use by:
'select ScalePos_id from scalepos where ' +
  format('Scale_id=%d and x_rel1=%d and y_rel1=%d and x_relN=%d and y_relN=%d',
  [aBblLoc[1,9], aBblLoc[1,7], aBblLoc[1,8], aBblLoc[nBblLoc,7], aBblLoc[nBblLoc,8]]);
  if #RecordsSelected=0 then add new ScalePos
  else if #RecordsSelected=1 then use it (check BubblePos for exact match?)
  else if #RecordsSelected>1 then look in BubblePos for exact match.

You could have a local copy of ScalePos and BubblePos, but only download
records as needed.  That is, look in local tables for a useable ScalePos;
if not found look in SQL for a ScalePos.  If found in SQL, download it
to local & use it.  If not found in SQL, create a new one in SQL & in
Local & use it.

Could create a lot of traffic with a personalized scale?  ?_Rel1 & ?_RelN
might match, but ?_Rel2 .. ?_Rel(N-1) might not.
      O Dr Smith   O Nurse Johnson   O Nobody
      O Dr Johnson   O Nurse Jones   O Nobody

BblLocFlush would return ScalePos_id



*)
end;

function tdmOpenQ.HWLocFlush:integer;
var s : string;
    ge_org,n,i,j : integer;
begin
  result := 0;
{$IFNDEF FormLayout}
  if nHWLoc>0 then begin
    ge_org := dmOpenQ.GenError;
    Generror := 29;
    n := 0;
    s := 'exec sp_pcl_insertinto_HWloc '+dmPCLGen.qf_id;
    for i := 1 to nHWLoc do begin
      for j := 1 to 7 do
        s := s + ','+inttostr(aHWLoc[i,j]);
      inc(n);
      if (n=6) or (i=nHWLoc) then begin
        ScanQuery(s,true);
        n := 0;
        s := 'exec sp_pcl_insertinto_HWloc '+dmPCLGen.qf_id;
      end;
    end;
    nHWLoc := 0;
    dmOpenQ.GenError := ge_org;
  end;
{$ENDIF}
end;

{$IFNDEF FormLayout}
procedure tdmOpenQ.CmntLocFlush;
var s : string;
    i,j : integer;
begin
  if nCmntLoc>0 then begin
    s := 'exec sp_pcl_insertinto_Cmntloc '+dmPCLGen.qf_id;
    for i := 1 to nCmntLoc do
      for j := 1 to 7 do
        s := s + ','+inttostr(aCmntLoc[i,j]);
    nCmntLoc := 0;
    i := dmOpenQ.Generror;
    Generror := 30;
    ScanQuery(s,true);
    Generror := i;
  end;
end;
{$ENDIF}

procedure tdmOpenQ.ProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
 AllowChange:=True;
end;

procedure TDMOpenQ.wwT_QstnsstrScalePosGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if wwt_QstnsSubType.value=1 then
    case wwt_QstnsScalePos.value of
      1: text := 'Right';
      2: text := 'Below';
      3: text := 'Below2';
      4: text := 'Below Left';
      else text := '';
    end
  else
    text := '';
end;

procedure TDMOpenQ.wwT_QstnsSkipFromGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  text := '';
  if (wwt_QstnsSubType.value=1) and (Sender.asstring<>'') then text := '×';

end;

procedure TDMOpenQ.wwT_QstnsProblemScoreGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  text := '';
  if (wwt_QstnsSubType.value=1) then
    if (Sender.asstring<>'') then
      text := '×';

end;

//GN04
{$IFDEF FormLayout}
function TDMOpenQ.CheckAuditInfo : Boolean;
begin

end;

//GN11
function TDMOpenQ.GetMappingMetaFields() : Boolean;
begin
   if glbStudyID > 0 then
   begin
      with sp_QPProd do
      begin
         Close;
         StoredProcName := 'sp_FL_SelectMappingMetaFields';
         Params.Clear ;
         with Params.CreateParam(ftInteger, 'Study_id', ptInput) do
            AsInteger := glbStudyID;
         Prepare;
         Open;
      end;
   end;
end;
{$ENDIF}

end.
