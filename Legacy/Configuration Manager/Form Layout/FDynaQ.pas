unit FDynaQ;

{
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
11-01-2005  GN01   Commented the display warning

11-22-2005  GN02   Display the fileVersion

01-02-2006  GN03   Fix for the corrupt code during validate layout.
                   Save option setting's only when click on the OK button.

09-28-2006  GN04   Added the delete all logos functionality to address the phantom logo problem.
                   This is a workaround till I can figure out the actual cause

12-20-2006  GN05   Ability to update FormLayout version during promotes

}


{ DEFINE GraphicsTab}

interface

uses
  Windows,messages, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, DB, Wwdatsrc, DBTables, Wwtable, ComCtrls, ExtCtrls,
  Grids, Dialogs, wwdblook, Wwquery, Mask, Wwdbedit, Wwdotdot,
  Wwdbcomb, Wwdbigrd, Wwdbgrid, Menus, DBCtrls, Ppmain, Ppext,
  WKHandle, DQCommon, CDK_Comp, DBRichEdit, Wwfltdlg, wwidlg,
  fSearch, Spin, Tabs, DQPnl, DQImg, DQRchEdt, TrackBar2, Printers,
  DBGrids, dbpwdlg,fileutil,f_ShowProps;

const
  printPixelsPerInch = 600;
//  defPixelsPerInch = 120;

type
  tPageTabs = record
    pagetype : integer;
    integrated : boolean;
    letterhead : boolean;
    description : string;
  end;
  TF_DynaQ = class(TForm)
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    SelectedQuestions1: TMenuItem;
    CoverLetters1: TMenuItem;
    Tools1: TMenuItem;
    Sort1: TMenuItem;
    Filter1: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    N2: TMenuItem;
    Options1: TMenuItem;
    FindPrior1: TMenuItem;
   BottomPanel: TPanel;
   PageControl1: TPageControl;
   Selection: TTabSheet;
   ButtonPanel: TPanel;
   wwDBLookup_Services: TwwDBLookupCombo;
   wwDBLookup_Themes: TwwDBLookupCombo;
    lblServices: TLabel;
    lblThemes: TLabel;
   StatusPanel: TPanel;
   AliasNamePanel: TPanel;
    lblLanguage: TLabel;
   SectionPopup: TPopupMenu;
   Append1: TMenuItem;
   Insert1: TMenuItem;
   Layout1: TMenuItem;
   Delete1: TMenuItem;
   NewSection1: TMenuItem;
   NewSection2: TMenuItem;
   NewSubSection1: TMenuItem;
   NewSubSection2: TMenuItem;
   UserPanel: TPanel;
   Panel2: TPanel;
   CoverSheets: TTabSheet;
   Panel3: TPanel;
   btnLogo: TSpeedButton;
   btnTextBox: TSpeedButton;
   btnPclBox: TSpeedButton;
    btnTranslate: TSpeedButton;
   wwDBLookup_Languages: TwwDBLookupCombo;
    DBText2: TDBText;
    DBText3: TDBText;
    ppAvailQstns: TPowerPanel;
    ppSelQstns: TPowerPanel;
    ppFullQstn: TPowerPanel;
    pAvailQstns: TPanel;
    LabelAvailable: TLabel;
    ShowQstnBtn: TSpeedButton;
    ppHeader: TPowerPanel;
    ppQstnText: TPowerPanel;
    ppScale: TPowerPanel;
    MemoScale: TMemo;
    DBREQstnText: TclDBRichCode;
    DBREHeader: TclDBRichCode;
    wwFilterDialog: TwwFilterDialog;
    FilterPanel: TPanel;
    SortBtn: TSpeedButton;
    FilterBtn: TSpeedButton;
    wwDBEditAvailCore: TwwDBEdit;
    FindBtn: TSpeedButton;
    SpinButton1: TSpinButton;
    ppSelFullQstn: TPowerPanel;
    Panel6: TPanel;
    LabelSelected: TLabel;
    ppSelQstnText: TPowerPanel;
    ppSelScale: TPowerPanel;
    DBRESelQstnText: TclDBRichCode;
    MemoSelScale: TMemo;
    ShowSelQstnBtn: TSpeedButton;
    N4: TMenuItem;
    ViewRestrictedQuestions: TMenuItem;
    AdministrationMenu: TMenuItem;
    Edit1: TMenuItem;
    Delete2: TMenuItem;
    ppQstnLayout: TPowerPanel;
    PopupTextBox: TPopupMenu;
    Bringtofront: TMenuItem;
    Sendtoback: TMenuItem;
    DeleteBox: TMenuItem;
    menuEdit: TMenuItem;
    BorderShading: TMenuItem;
    PopupLogo: TPopupMenu;
    Bringtofront2: TMenuItem;
    Sendtoback2: TMenuItem;
    DeleteLogo: TMenuItem;
    Visible1: TMenuItem;
    DPI: TMenuItem;
    N300: TMenuItem;
    N600: TMenuItem;
    ChangeLogo: TMenuItem;
    OpenPCLDialog: TOpenDialog;
    ScrollBoxCovers: TScrollBox;
    CoverBorder2: TBevel;
    WLKHandle: TWLKHandle;
    ProgressBar: TProgressBar;
    btnSpellCheck: TSpeedButton;
    Insert2: TMenuItem;
    TextBox1: TMenuItem;
    Graphic1: TMenuItem;
    PCLCode1: TMenuItem;
    N5: TMenuItem;
    CoverLetter1: TMenuItem;
    PopupPageTab: TPopupMenu;
    NewCoverLetter1: TMenuItem;
    Delete3: TMenuItem;
    Properties1: TMenuItem;
    CoverBorder1: TBevel;
    pnlAddress: TPanel;
    ShapeAddrLbl: TShape;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CoverBorder3: TBevel;
    ScrollBoxQstns: TScrollBox;
    Section1: TMenuItem;
    Comment1: TMenuItem;
    SelectedQuestion2: TMenuItem;
    Subsection1: TMenuItem;
    SelQstnsPopup: TPopupMenu;
    InsertSection1: TMenuItem;
    InsertSubsection1: TMenuItem;
    InsertCommentBox1: TMenuItem;
    N6: TMenuItem;
    EditCommentBox1: TMenuItem;
    Delete4: TMenuItem;
    clCodeToggle1: TclCodeToggle;
    pnlTrackBar: TPanel;
    DQTrackBar: TDQTrackBar;
    pnlThumbPos: TPanel;
    Label1: TLabel;
    cbLayoutPercentage: TComboBox;
    btnNew2: TSpeedButton;
    btnSave2: TSpeedButton;
    btnNew: TSpeedButton;
    btnSave: TSpeedButton;
    Panel4: TPanel;
    btnSelQPgUp: TSpeedButton;
    btnSelQUp: TSpeedButton;
    btnSelQDn: TSpeedButton;
    btnSelQPgDn: TSpeedButton;
    srcList: TwwDBGrid;
    pnlLevelCheckBoxes: TPanel;
    cbLevelKey: TCheckBox;
    cbLevelCore: TCheckBox;
    cbLevelDrillDown: TCheckBox;
    cbLevelBehavioral: TCheckBox;
    cbLevelUnassigned: TCheckBox;
    lblLevel: TLabel;
    editFilterLevel: TEdit;
    btnTranslate2: TSpeedButton;
    EditTextBoxTranslations: TMenuItem;
    Validate: TMenuItem;
    N8: TMenuItem;
    FOUOArea1: TMenuItem;
    File1: TMenuItem;
    Clear1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    SaveAsTemplate1: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Fromanothersurvey1: TMenuItem;
    Fromatemplate1: TMenuItem;
    btnPrintLayout: TSpeedButton;
    btnLayout: TSpeedButton;
    TranslateCommentBox1: TMenuItem;
    PopupAddress: TPopupMenu;
    EditAddressCodes1: TMenuItem;
    TranslateAddress1: TMenuItem;
    PageBreak1: TMenuItem;
    shapeRegPt: TShape;
    ImageMatchCode: TImage;
    pnlIndicia: TPanel;
    shpIndicia: TShape;
    lblIndicia1: TLabel;
    lblIndicia2: TLabel;
    lblIndicia3: TLabel;
    lblIndicia4: TLabel;
    lblIndicia5: TLabel;
    lblIndicia6: TLabel;
    PrintMockup1: TMenuItem;
    N7: TMenuItem;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    btnCode: TSpeedButton;
    DSCodes: TDataSource;
    tCodes: TTable;
    tCodesCode: TAutoIncField;
    tCodesLangID: TIntegerField;
    tCodesDescription: TStringField;
    tCodesFielded: TSmallintField;
    tCodesAge: TBooleanField;
    tCodesSex: TBooleanField;
    tCodesDoctor: TBooleanField;
    tConstant: TTable;
    tConstantConstant: TStringField;
    tConstantValue: TStringField;
    tCodeText: TTable;
    DBQstnsNavigator: TDBNavigator;
    ValidateSaveLayout: TMenuItem;
    btnLogoRef: TSpeedButton;
    RenameLogo: TMenuItem;
    pnlTabset: TPanel;
    TabSet1: TTabSet;
    ReloadAllQuestions1: TMenuItem;
    ScrollBox1: TScrollBox;
    wwDBGrid1: TwwDBGrid;
    VersionPanel: TPanel;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    N10: TMenuItem;
    n11: TMenuItem;
    SurveyProps: TMenuItem;
    mniAlign: TMenuItem;
    mniLeft: TMenuItem;
    mniTop: TMenuItem;
    mniDeletePLogo: TMenuItem;
    mniDeleteAllLogos: TMenuItem;
    mniAdmin: TMenuItem;
   procedure OKBtnClick(Sender: TObject);
   procedure CancelBtnClick(Sender: TObject);
   procedure wwDBLookup_ThemesCloseUp(Sender: TObject; LookupTable,
    FillTable: TDataSet; modified: Boolean);
   procedure FormCreate(Sender: TObject);
   procedure doHint(Sender: TObject);
   procedure SrclistRefresh;
   procedure myMessage(str: string);
   procedure wwT_DyQuestFilterRecord(DataSet: TDataSet;
    var Accept: Boolean);
   procedure PageControl1Change(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure DatabaseInit;
   procedure btnLogoClick(Sender: TObject);
   procedure btnTextBoxClick(Sender: TObject);
   procedure PageControl1Changing(Sender: TObject;
    var AllowChange: Boolean);
   procedure LoadAvailableQuestions;
   procedure wwQ_QuestionsAfterOpen(DataSet: TDataSet);
   procedure wwQ_HeadingsAfterOpen(DataSet: TDataSet);
   procedure wwT_Available2FilterRecord(DataSet: TDataSet;
    var Accept: Boolean);
   procedure btnPclBoxClick(Sender: TObject);
   procedure getPCLWidthHeight(str: string; var w, h: integer);
   procedure WLKHandleMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
   procedure wwDBLookup_LanguagesDropDown(Sender: TObject);
   procedure wwDBLookup_LanguagesCloseUp(Sender: TObject; LookupTable,
    FillTable: TDataSet; modified: Boolean);
   procedure SaveCover(const pg:integer);
    procedure ShowQstnBtnClick(Sender: TObject);
    procedure wwDBEditAvailCoreChange(Sender: TObject);
    procedure ppFullQstnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppFullQstnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SortBtnClick(Sender: TObject);
    procedure wwT_Available2AfterOpen(DataSet: TDataSet);
    procedure FilterBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure Sort1Click(Sender: TObject);
    procedure Filter1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure FindPrior1Click(Sender: TObject);
    procedure SelectedQuestions1Click(Sender: TObject);
    procedure CoverLetters1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure ShowSelQstnBtnClick(Sender: TObject);
    procedure ViewRestrictedQuestionsClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure wwDBGrid1DblClick(Sender: TObject);
    procedure wwDBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure wwDBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure wwDBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Delete2Click(Sender: TObject);
    procedure NewSection3Click(Sender: TObject);
    procedure NewSubsection3Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure SrcListDblClick(Sender: TObject);
    procedure DBRESelQstnTextChange(Sender: TObject);
    procedure ScrollBoxCoversMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupTextBoxPopup(Sender: TObject);
    procedure PopupLogoPopup(Sender: TObject);
    procedure BringtofrontClick(Sender: TObject);
    procedure SendtobackClick(Sender: TObject);
    procedure DeleteBoxClick(Sender: TObject);
    procedure menuEditClick(Sender: TObject);
    procedure BorderShadingClick(Sender: TObject);
    procedure Visible1Click(Sender: TObject);
    procedure N300Click(Sender: TObject);
    procedure N600Click(Sender: TObject);
    procedure ChangeLogoClick(Sender: TObject);
    procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Logo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Logo2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function findemptyslot:integer;
    function newLogo(const ID,w,h:integer):integer;
    function newPCL(const ID,w,h:integer):integer;
    function newTextBox(Const ID:integer):integer;
    function newLogoRef(const ID,w,h:integer):integer;
    procedure RichEdit2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RichEdit1ProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    function isTextBox(const obj:TControl):boolean;
    function isLogo(const obj:TControl):boolean;
    function isLogoRef(const obj:TControl):boolean;
    function isPCL(const obj:TControl):boolean;
    procedure LoadCover(const pg:integer);
    procedure ClearElementList;
    procedure LeavingCoverPage;
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSpellCheckClick(Sender: TObject);
    procedure CoverLetter1Click(Sender: TObject);
    procedure Delete3Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    function GetBackInside(obj:tcontrol):integer;
    procedure Comment1Click(Sender: TObject);
    procedure SelQstnsPopupPopup(Sender: TObject);
    procedure EditCommentBox1Click(Sender: TObject);
    procedure Layout;
    procedure LayoutSection;
    procedure LayoutSubsection;
    function AddSectionToElementList(const VertOffset:integer):integer;
    procedure TrackBarChange(Sender: TObject);
    procedure DQTrackBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbLayoutPercentageChange(Sender: TObject);
    procedure btnSelQDnClick(Sender: TObject);
    procedure btnSelQUpClick(Sender: TObject);
    procedure btnSelQPgUpClick(Sender: TObject);
    procedure btnSelQPgDnClick(Sender: TObject);
    procedure wwDBLookup_ServicesCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure srcListCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure editFilterLevelEnter(Sender: TObject);
    procedure pnlLevelCheckBoxesExit(Sender: TObject);
    procedure pnlLevelCheckBoxesDblClick(Sender: TObject);
    procedure btnTranslateClick(Sender: TObject);
    procedure EditTextBoxTranslationsClick(Sender: TObject);
    procedure ValidateClick(Sender: TObject);
    procedure fromanothersurvey1Click(Sender: TObject);
    procedure FOUOArea1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure fromatemplate1Click(Sender: TObject);
    procedure btnLayoutClick(Sender: TObject);
    procedure btnPrintLayoutClick(Sender: TObject);
    procedure TranslateCommentBox1Click(Sender: TObject);
    procedure EditAddressCodes1Click(Sender: TObject);
    procedure TranslateAddress1Click(Sender: TObject);
    procedure pnlThumbPosDblClick(Sender: TObject);
    procedure PageBreak1Click(Sender: TObject);
    procedure AliasNamePanelDblClick(Sender: TObject);
    procedure DBRESelQstnTextMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnCodeClick(Sender: TObject);
    procedure tCodeTextFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure UserPanelDblClick(Sender: TObject);
    procedure btnLogoRefClick(Sender: TObject);
    procedure RenameLogoClick(Sender: TObject);
    procedure ReloadAllQuestions1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure SurveyPropsClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure wwDBGrid1CalcTitleAttributes(Sender: TObject;
      AFieldName: String; AFont: TFont; ABrush: TBrush;
      var ATitleAlignment: TAlignment);
    procedure mniLeftClick(Sender: TObject);
    procedure mniTopClick(Sender: TObject);
    procedure mniDeletePLogoClick(Sender: TObject);
    procedure mniDeleteAllLogosClick(Sender: TObject);
    procedure mniAdminClick(Sender: TObject);
  private
   { Private declarations }
    curServID, curThemID, curLangID: integer;
    SurveyRecordChanged: boolean;
    CoreList: TStringList;
    SearchDown : boolean;
    ElementList : TList;
    pagetabs : array[0..9] of tPageTabs;
    procedure ChangeMenu(const TF:boolean);
    procedure SetTabs;
    procedure SaveOptionInfo;
    function newPage(vID:integer; vDesc:string; vIntegrated,vLetterhead:boolean; vPagetype:integer):boolean;
    procedure HighlightCurrentQ;
    procedure wwDBGrid1RecordChange;
    function PrnToScr(prn:integer):integer;
    function ResizeFont(const fullsize:integer):integer;
    procedure AdjustTrackBar;
    procedure updatecorelist;
    Function GetRawText(r:trichedit):string;
    procedure DeleteAllForeignRecs(const Lang:string);
  public
   procedure ShowProps;
   function LunchWithHandle(s:string):boolean;
   { Public declarations }
  end;

var
  F_DynaQ: TF_DynaQ;
  hndl:hwnd;
implementation

{$R *.DFM}
uses
  dataMod, DOpenQ, common,
  foptions, uLoadBMP, REEdit, TBAttrib,
  Support, PgAttrib, uLayoutCalc, Sort,
  fTrans, fInvalid, Code, fPssWrd, fLogoRef, fValidMsg;

const
  ptLetter = 1;
  ptLetterCard = 2;
  ptLegalCard = 3;
  ptArtifacts = 4;

function GetWin(Handle: HWND; LParam: Longint): Bool; stdcall;
var
  S: string;
begin
  Setlength(S, 255);
  Setlength(S, getwindowtext(handle, pchar(s), 255));
  if (Pos('Survey Personalization', S) > 0) then begin
    hndl := Handle;
    result := False;
  end;
end;

function TF_DynaQ.LunchWithHandle(s:string):boolean;
var
   msg: TMsg;
   ret: DWORD;
   SUInfo: TStartupInfo;
   ProcInfo: TProcessInformation;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_NORMAL;
  end;
  hndl := 0;  
  result := CreateProcess(nil,PChar(S),nil, nil, False,
                          NORMAL_PRIORITY_CLASS, nil, nil,
                          SUInfo, ProcInfo);
  if result then begin
    while EnumThreadWindows(ProcInfo.dwThreadid, @Getwin, 0) do
      Application.ProcessMessages;
  end;
end;

var FireTabChangeEvent : boolean;
    dbGridCurSect,dbGridCurSub,dbGridCurQ : integer;

function nSections(curTree: TTreeView): integer;
var
  ii:   integer;
begin
  result := 0;
  with curTree do
    if items.count > 0 then
      for ii := 0 to items.count-1 do
        if items[ii].level = 0 then
          result := result + 1;
end;


Function TF_DynaQ.GetRawText(r:trichedit):string;
var stream:tmemorystream;
    PlainText:boolean;
begin
   result:='';
   stream:= tmemorystream.Create;
   PlainText := r.PlainText;
   try
     r.PlainText:=False;
     r.Lines.SaveToStream(stream);
     SetLength(result, Stream.Size-1);
     Move(Stream.Memory^, result[1], Stream.Size-1);
   finally
     Stream.Free;
     r.PlainText := PlainText;
   end;

end;

procedure TF_DynaQ.ShowProps;
begin
  SurveyPropsClick(self);
end;

procedure TF_DynaQ.DatabaseInit;
begin
  with DQDataModule do begin
    with DataLib do begin
{      close;
      DatabaseName := 'DataLib';
      if dbAliasName[length(dbAliasName)] = '\' then
        with params do begin
          clear;
          add('Path='+dbAliasName);
        end
      else
        AliasName := dbAliasName;}
      try
        open;
      except
        showmessage('Cannot open the '+AliasName+' BDE alias!');
      end;
    end;

(*    with DqDB do begin
      {close;
      DatabaseName := 'DqDB';
      DriverName := 'STANDARD';
      if DataPath[length(DataPath)] = '\' then
        with params do begin
          clear;
          add('Path='+DataPath);
        end
      else
        AliasName := DataPath;}
      try
        open;
      except
        showmessage('Cannot open the '+AliasName+' BDE Alias!');
      end;
    end;
*)
    with DQDataModule.wwT_Services do begin
      open;
      locate('Service', 'All', [loCaseInsensitive]);
      wwDBLookup_Services.text := fieldByName('Service').asString;
      curLangID := fieldByName('ServID').value;
    end;

    with DQDataModule.wwT_Themes do begin
      open;
      locate('Theme', 'All', [loCaseInsensitive]);
      wwDBLookup_Themes.text := fieldByName('Theme').asString;
      curLangID := fieldByName('ThemID').value;
    end;

    with DQDataModule.wwT_Languages do begin
      open;
      Findkey([1]);
      curLangID := fieldByName('LangID').value;
    end;

{    wwDS_Surveys.OnDataChange := wwDS_SurveysDataChange;}
  end;
  lblLanguage.caption := lowercase( DMOpenQ.EnvName );
  AliasNamePanel.Width := lblLanguage.width+20;
  AliasNamePanel.caption := lblLanguage.caption;
  lblLanguage.caption := 'Languages:';
end;

procedure TF_DynaQ.OKBtnClick(Sender: TObject);
begin
  close;
end;

procedure TF_DynaQ.CancelBtnClick(Sender: TObject);
begin
  close;
end;

procedure TF_DynaQ.myMessage(str: string);
begin
  with StatusPanel do begin
    if str = '' then
      caption := str
    else
      caption := str+'...';
    refresh;
  end;
end;

procedure TF_DynaQ.wwDBLookup_ServicesCloseUp(Sender: TObject; LookupTable,
  FillTable: TDataSet; modified: Boolean);
begin
  if modified then begin
    curServID := LookupTable.fieldbyname('ServID').value;
    DQDataModule.filterService := curServID;
    DQDataModule.updateQstnFilter;
    SrcListRefresh;
    dqdatamodule.wwT_Questions.enablecontrols;
  end;
end;

procedure TF_DynaQ.wwDBLookup_ThemesCloseUp(Sender: TObject; LookupTable,
  FillTable: TDataSet; modified: Boolean);
begin
  if modified then begin
    curThemID := LookupTable.fieldbyname('ThemID').value;
    DQDataModule.filterTheme := curThemID;
    DQDataModule.updateQstnFilter;
    SrcListRefresh;
    dqdatamodule.wwT_Questions.enablecontrols;
  end;
end;

procedure TF_DynaQ.doHint(Sender: TObject);
begin
  StatusPanel.caption := Application.hint;
end;

procedure TF_DynaQ.FormCreate(Sender: TObject);
  function IsNewSurvey:boolean;
  begin
    with dmOpenQ do
      result := (wwt_Scls.recordcount+
                 wwt_Skip.recordcount+
                 wwt_textbox.recordcount+
                 wwt_Logo.recordcount+
                 wwt_PCL.RecordCount=0) and
                (wwt_Qstns.recordcount=1) and
                (wwt_Cover.recordcount=1);
  end;
var
   sVer : string;
begin
  hndl:=0;
  mniAdmin.Visible := False; //GN05
  if dmopenq.laptop then begin
    Fromanothersurvey1.enabled := false;
    Save1.enabled := false;
    ValidateSaveLayout.enabled := false;
    btnSave2.enabled := false;
    btnSave.enabled := false;
  end;
  //versionPanel.caption:=GetFileVersion(application.exename);
  //if versionPanel.caption <> '' then versionPanel.caption:='v'+versionPanel.caption;
  //GN02
  GetFileVersion(application.exename, sVer);
  versionPanel.caption := sVer;

  cbLayoutPercentage.ItemIndex := 1;
  cbLayoutPercentage.visible := false;
  AdjustTrackbar;
  ViewRestrictedQuestions.checked := DQDataModule.filterRestrict;
//  showMessage('TF_DynaQ.FormCreate');
  ElementList := tList.create;
  FireTabChangeEvent := true;
  f_DynaQ.windowState := wsMaximized;

{ if doIniTableSetup then begin}
    Application.Onhint := doHint;
    lblLanguage.caption := getUser;
    UserPanel.Width := lblLanguage.width+20;
    UserPanel.caption := lblLanguage.caption;
    lblLanguage.caption := 'Languages:';

    CoreList := TStringList.create;

    curServID := -1;
    curThemID := -1;
    curLangID := 1;

    ShowQstnBtnClick(Sender);
    ShowSelQstnBtnClick(Sender);
{    dmOpenQ.SaveDialog.tag := 1;}
    if (not dmopenq.laptop) and (DQDataModule.cmdLineTemplate='') then
      with dmOpenQ do begin
        LoadFromSQL(glbSurveyID,true);
        //if (not IsNewSurvey) then VerifyLoad;
        ShowOpenStatus := false;
      end
    else begin
      if DMOpenQ.SurveyDB(DQDataModule.cmdLineTemplate) then begin
        dmOpenQ.OpenSurvey(DQDataModule.cmdLineTemplate);
        //frmLayoutCalc.setfonts;
      end else
        dmOpenQ.NewSurvey;
      setTabs;
      updatecorelist;
    end;
    frmLayoutCalc := TfrmLayoutCalc.Create( Self );
    frmLayoutCalc.setfonts;
    setTabs;
    SurveyRecordChanged := true;
{ end else begin
    messageDlg( 'IniTable Setup Error!'+#13#13+
            'Cannot start the application.', mtError, [mbOK], 0);
    application.terminate;
  end;}
  if pagecontrol1.activepage.pageindex = coversheets.pageindex then
    LoadCover(tabset1.tabindex);
  Databaseinit;
  DQdatamodule.OpenLibraryTables;
  wwFilterDialog.datasource := DQDataModule.wwDS_Questions;
  wwFilterDialog.defaultfield := 'Short';
  PageControl1.ActivePage := Selection;
  PageControl1Change(Sender);
  ppAvailQstns.width := screen.width-300;
  updatecorelist;
{  with dmOpenQ do begin
    CloseSurvey;
    OpenDialog.filename := 'c:\DQ\DynaQuest\Development\hcpartners.db';
    SaveDialog.Filename := OpenDialog.Filename;
    OpenAllTables;
  end;
}
{$IFDEF GraphicsTab}
  tabset1.Align := alClient;
  btnLogoRef.left := btnLogo.left;
  btnLogoRef.visible := true;
{$ENDIF}
  DeleteAllForeignRecs('-1');
end;

procedure TF_DynaQ.SrclistRefresh;
begin
  try
    Screen.cursor := crHourglass;
    with dqdatamodule.wwT_Questions do
      if active then refresh;
  finally
    Screen.cursor := crDefault;
  end;
end;

procedure TF_DynaQ.wwT_DyQuestFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  r1,
  r2: boolean;
begin
  Screen.cursor := crHourGlass;
  with dataset do begin
    accept := (FieldByName('LangID').value = curLangID);

    if (wwDBLookup_Services.text = '') or
        (trim(wwDBLookup_Services.text) = 'All') then
      r1 := True
    else
      r1 := (FieldByName('Service').asString = wwDBLookup_Services.text);

    if (wwDBLookup_Themes.text = '') or
      (trim(wwDBLookup_Themes.text) = 'All') then
      r2 := True
    else
      r2 := (FieldByName('Theme').asString = wwDBLookup_Themes.text);

    accept := (accept and r1 and r2);

    if not ViewRestrictedQuestions.checked then
      accept := accept and (not FieldByName('Restrict').asBoolean);

    accept := accept and (not FieldByName('Selected').asBoolean);
  end;
  Screen.cursor := crDefault;
end;

procedure TF_DynaQ.LoadAvailableQuestions;
begin
{
  Screen.cursor := crHourGlass;

  wwT_Available.close;
  wwQ_Headings.close;
  wwQ_Questions.close;

  myMessage('Loading Available Questions');
  wwQ_Questions.open; }
end;

procedure tF_DynaQ.ChangeMenu(const TF:boolean);
begin
  {Menu items for coverletter page}
  TextBox1.visible := TF;
  Graphic1.visible := TF;
  PCLCode1.visible := TF;
  PageBreak1.visible := TF;
  N5.visible := TF;
  Coverletter1.visible := TF;

  {Menu items for QuestionSelection page}
  Section1.visible := not TF;
  Subsection1.visible := not TF;
  SelectedQuestion2.visible := not TF;
  Comment1.visible := not TF;
  ViewRestrictedQuestions.enabled := not TF;
  Sort1.enabled := not TF;
  Filter1.enabled := not TF;
  Find1.enabled := not TF;
  FindNext1.enabled := not TF;
  FindPrior1.enabled := not TF;
end;

procedure TF_DynaQ.PageControl1Change(Sender: TObject);
begin
  FilterPanel.caption := '';
  with PageControl1 do begin
    if activepage.pageindex = coversheets.pageindex then begin
      LoadCover(tabset1.tabindex);
      ChangeMenu(True);
    end;

    if activepage.pageindex = Selection.pageindex then begin
      if SurveyRecordChanged then begin
        LoadAvailableQuestions;
        {LoadSurveyData;}
        SurveyRecordChanged := False;
      end;
      wwFilterDialog.ClearFilter;
      wwFilterDialog.ApplyFilter;
      FilterPanel.caption := 'No Filter';
      changeMenu(false);
      printmockup1.enabled := true;
      if (ppAvailQstns.width>0) and (ppQstnLayout.width>0) then
        btnLayoutClick(Sender);
    end;
  end;
  Screen.cursor := crDefault;
  myMessage('');
end;

procedure tf_DynaQ.LeavingCoverPage;
begin
  SaveCover(tabset1.tabindex);
  ClearElementList;
end;

procedure TF_DynaQ.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := True;
  with PageControl1 do
  if activepage.pageIndex = Coversheets.pageindex then
    LeavingCoverPage;
end;

procedure SetFontField(aField: TBytesField; aFont: TFont);
var
  p:      ^TFont;
begin
  p := @aFont;
  if assigned(aFont) then
    aField.setdata(p)
  else
    aField.setdata(nil);
end;

procedure TF_DynaQ.FormDestroy(Sender: TObject);
begin
  clearElementList;
  if printer.printing then frmLayoutCalc.EndCalc;
end;

procedure ResizeLogo(const ratio:integer);
var i : integer;
begin
  with F_DynaQ.WLKHandle do
    for i := 0 to childcount-1 do
      if (children[i] is tDQPanel) and (tDQPanel(children[i]).controlcount > 0) then
        with tDQPanel(children[i]) do begin
          if ratio = 1479 then
            tDQImage(controls[0]).DPI := 600
          else
            tDQImage(controls[0]).DPI := 300;
          height := round(tDQImage(controls[0]).picture.height * (ratio / 10000));
          Width := round(tDQImage(controls[0]).picture.width * (ratio / 10000));
          if F_DynaQ.tabset1.tabindex=0 then begin
            {Graphics page}
            tDQImage(controls[0]).width := width;
            tDQImage(controls[0]).height := height;
            tEdit(controls[1]).width := width;
            tEdit(controls[1]).top := height;
            height := height + 14;
          end;
          modified := True;
          dmOpenQ.SaveDialog.tag := 2;
        end;
end;

procedure TF_DynaQ.btnLogoClick(Sender: TObject);
var i : integer;
    GraphicsPage:boolean;
begin
  frmOpenPictureDialog := TfrmOpenPictureDialog.Create( Self );
  with frmOpenPictureDialog do
  try
    if ShowModal = mrOK then begin
      I := newLogo(0,round(0.1479*image.picture.width),round(0.1479*image.picture.height));
      with WLKHandle do begin
        detach;
        attach(tcontrol(ElementList[i]));
        Resizable := false;
      end;
      with tDQPanel(WLKHandle.children[0]) do begin
        if OpenDialog.Filename <> '' then
          caption := ExtractFileName(OpenDialog.filename);
        GraphicsPage := (tabset1.tabindex=0);
        with tDQImage(Controls[0]) do begin
          picture := Image.Picture;
          if GraphicsPage then align := alNone;
        end;
        if GraphicsPage then begin
          tDQImage(Controls[0]).width := width;
          tDQImage(controls[0]).height := height;
          Height := Height + 14;
          insertcontrol(tEdit.create(F_DynaQ));
          with tEdit(Controls[1]) do begin
            left := 0;
            top := tDQPanel(elementlist[i]).height-14;
            width := tDQPanel(elementlist[i]).width;
            text := ExtractFileName(OpenDialog.filename);
            enabled := false;
            borderstyle := bsNone;
            font.Size := 8;
          end;
        end;
      end;
      ResizeLogo(1479)
    end;
  finally
    Release;
  end;
end;

procedure TF_DynaQ.btnTextBoxClick(Sender: TObject);
var i : integer;
begin
  frmREEdit := TfrmREEdit.Create( Self );
  with frmREEdit do
  try
    wtText.Edit;
    wtText.fieldbyname('Text').asString := '';
    wtText.post;
    clDBRichCodeBtn1.font := ScrollboxCovers.font;
    caption := 'New Text Box';
    if ShowModal = mrOK then begin
      I := newTextBox(0);
      with WLKHandle do begin
        detach;
        attach(tcontrol(ElementList[i]));
        Resizable := false;
      end;
      with tRichEdit(tDQPanel(Elementlist[i]).Controls[0]).lines do begin
        LoadFromFile(dmOpenQ.tempdir+'\RichEdit.rtf');
      end;
    end;
  finally
    Release;
  end;
end;

procedure TF_DynaQ.getPCLWidthHeight(str: string; var w, h: integer);
var
  ii: integer;
   ss:  string;
begin
  ss := copy(str, 1, length(str));
  ii := pos(chr(27)+'*p', ss);

  if ii = 0 then
    begin
      w := F_DynaQ.pixelsPerInch;
      h := F_DynaQ.pixelsPerInch;
    end
  else
    begin
         ss := copy(ss, ii+3, length(ss));
      ii := pos(chr(27), ss);
      ss := copy(ss, 1, ii-1);

         if upperCase(ss[length(ss)]) = 'X' then
          begin
          ii := rPos('+', ss);
          w := strToInt(copy(ss, ii+1, length(ss)-ii-1));
          w := (w * pixelsPerInch) div printPixelsPerInch;

          ss := copy(ss, 1, ii-2);
          ii := rPos('+', ss);
          h := strToInt(copy(ss, ii+1, length(ss)));
               h := (h * pixelsPerInch) div printPixelsPerInch;
            end
      else
          begin
          ii := rPos('+', ss);
               h := strToInt(copy(ss, ii+1, length(ss)-ii-1));
               h := (h * pixelsPerInch) div printPixelsPerInch;

          ss := copy(ss, 1, ii-2);
             ii := rPos('+', ss);
          w := strToInt(copy(ss, ii+1, length(ss)));
          w := (w * pixelsPerInch) div printPixelsPerInch;
            end;
    end;
end;


procedure TF_DynaQ.btnPclBoxClick(Sender: TObject);
var i,w,h : integer;
    vPCL : string;
    KD:boolean;
begin
  OpenPCLDialog.filename := '';
  OpenPCLDialog.InitialDir := GetPath('Load PCL');
  if OpenPCLDialog.execute then begin
    SetPath('Load PCL', ExtractFilePath(OpenPCLDialog.Filename));
    vPCL := dmOpenq.AnalyzePCL(openPCLDialog.filename,w,h,KD);
    //I := newPCL(0,round(0.1479*w),round(0.1479*h));
    I := newPCL(0,w,h);
    with WLKHandle do begin
      detach;
      attach(tcontrol(ElementList[i]));
      Resizable := false;
    end;
    with tDQPanel(WLKHandle.children[0]) do begin
      caption := ExtractFileName(OpenPCLDialog.filename);
      hint := 'English: '+caption;
      showhint := true;
      PCL := vPCL;
      KnownDimensions := KD;
      if not KnownDimensions then color := clMaroon;
    end;
  end;
end;

procedure TF_DynaQ.wwQ_QuestionsAfterOpen(DataSet: TDataSet);
begin
{  with TTable.create(self) do
    try
      DatabaseName := 'dqPRIV';
      TableName := 'T1.DB';
      if batchMove(tBDEDataset(dataset), batCopy) > 0 then
        wwQ_Headings.open;
    finally
      free;
    end;
}
end;

procedure TF_DynaQ.wwQ_HeadingsAfterOpen(DataSet: TDataSet);
begin
{
  with TTable.create(self) do
    try
      DatabaseName := 'dqPRIV';
      TableName := 'T2.DB';
      if batchMove(TBDEDataSet(dataset), batCopy) > 0 then
        wwT_Available.open
      else
        messageDlg('No ''Headings'' available!', mtError, [mbOK], 0);
    finally
      free;
    end;
}
end;

procedure TF_DynaQ.wwT_Available2FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  r1,
  r2: boolean;
begin
{  Screen.cursor := crHourGlass;}
  with dataset do
    begin
      if bof then Screen.cursor := crHourGlass;
      accept := (FieldByName('LangID').value = curLangID);

      if (wwDBLookup_Services.text = '') or
        (trim(wwDBLookup_Services.text) = 'All') then
        r1 := True
      else
        r1 := (FieldByName('ServID').value = curServID);

      if (wwDBLookup_Themes.text = '') or
        (trim(wwDBLookup_Themes.text) = 'All') then
        r2 := True
      else
        r2 := (FieldByName('ThemID').value = curThemID);

      accept := (accept and r1 and r2);

      if not ViewRestrictedQuestions.checked then
        accept := accept and (not FieldByName('Restrict').asBoolean);

 {     accept := accept and ( CoreList.indexOf(FieldByName('Core').value) = -1 );}
      if eof then Screen.cursor := crDefault;
    end;
{  Screen.cursor := crDefault;}
end;

Function TF_DynaQ.GetBackInside(obj:tcontrol):integer;
begin
  result := 0;
  with tDQPanel(obj) do begin
    if left+width+ScrollboxCovers.horzScrollBar.Position > CoverBorder3.width then begin
      left := CoverBorder3.width-width-ScrollboxCovers.horzScrollBar.Position;
      result := 1;
    end;
    //if top+height+ScrollboxCovers.VertScrollBar.Position > CoverBorder2.height then begin
    //  top := CoverBorder2.height-height-ScrollboxCovers.VertScrollBar.Position;
    //  result := 1;
    //end;
    if left+ScrollboxCovers.horzScrollBar.Position < 0 then begin
      left := -ScrollboxCovers.horzScrollBar.Position;
      result := 1;
    end;
    if top+ScrollboxCovers.VertScrollBar.Position < 0 then begin
      top := -ScrollboxCovers.VertScrollBar.Position;
      result := 1;
    end;
    Modified := True;
  end;
end;

procedure TF_DynaQ.WLKHandleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var I: integer;
begin
  dmOpenQ.SaveDialog.tag := 2;
  with WLKHandle do
    for i := 0 to childcount-1 do begin
      GetBackInside(children[i]);
    end;
end;

procedure TF_DynaQ.wwDBLookup_LanguagesDropDown(Sender: TObject);
begin
  with TwwDBLookupCombo(sender).LookupTable as TwwTable do
    begin
      wwFilter.clear;
      wwFilter.add('YesNo=True');
      FilterActivate;
    end;
end;

procedure TF_DynaQ.wwDBLookup_LanguagesCloseUp(Sender: TObject; LookupTable,
  FillTable: TDataSet; modified: Boolean);
begin
  if modified then
    begin
      with LookupTable as TwwTable do
        begin
          curLangID := FieldByName('LangID').value;
        end;
      SrclistRefresh;
{      LoadSurveyData; }
    end;
end;

procedure TF_DynaQ.SaveCover(const pg:integer);
var i,curTag:   integer;

  procedure UpdateTextBoxes;
  var s:string;
  begin
   {look for record, if there edit else append}
    with tDQPanel(elementlist[i]), DMOpenQ.wwt_TextBox do begin
      if CurTag = 0 then
        messagedlg('TextBox "'+copy(tRichEdit(controls[0]).lines[0],1,20)+
                   '..." doesn''t have an ID# and will not be saved',mtError,[mbOK],0);
      if tDQPanel(elementlist[i]).modified then begin
        if findkey([DMOpenQ.glbSurveyID,curTag]) then
          edit
        else begin
          append;
          fieldbyname('Survey_ID').value := DMOpenQ.glbSurveyID;
          fieldbyname(qpc_ID).value := curTag;
          fieldbyname('Type').value := 'TextBox';
          fieldbyname('bitLangReview').value := false;
          fieldbyname('Label').value := TextBoxName;
        end;
        tDQPanel(elementlist[i]).modified := false;
        fieldbyname('Language').value := 1;
        fieldbyname('RichText').value := GetRawText(tRichEdit(controls[0]));
        post;
        s:=Format('UPDATE %s set CoverID = %d, X = %d, Y = %d, Width = %d, Height = %d,'+
                  'Shading = %d, Border = %d, Label = ''%s'', bitLangReview = false '+
                  'where Survey_ID = %d and %s= %d and Type = ''TextBox''',
                  [DMOpenQ.wwT_TextBox.tablename,pg,Left+ScrollboxCovers.horzScrollBar.Position,
                   Top+ScrollboxCovers.VertScrollBar.Position,Width,Height,
                   integer(tRichEdit(controls[0]).color),BorderWidth,TextBoxName,DMOpenQ.glbSurveyID,
                   qpc_ID,curTag]);
         dopenq.DMOpenQ.cn.execute(s);
      end;
    end;
  end;
  (*
  procedure UpdateTextBoxes;
  begin
   {look for record, if there edit else append}
    with tDQPanel(elementlist[i]), DMOpenQ.wwt_TextBox do begin
      if CurTag = 0 then
        messagedlg('TextBox "'+copy(tRichEdit(controls[0]).lines[0],1,20)+'..." doesn''t have an ID# and will not be saved',mtError,[mbOK],0);
      if tDQPanel(elementlist[i]).modified then begin
        if findkey([DMOpenQ.glbSurveyID,curTag]) then
          edit
        else begin
          append;
          fieldbyname('Survey_ID').value := DMOpenQ.glbSurveyID;
          fieldbyname(qpc_ID).value := curTag;
          fieldbyname('Type').value := 'TextBox';
          fieldbyname('bitLangReview').value := false;
        end;
        fieldbyname('CoverID').value := pg;
        fieldbyname('Language').value := 1;
        fieldbyname('X').value := Left+ScrollboxCovers.horzScrollBar.Position;
        fieldbyname('Y').value := Top+ScrollboxCovers.VertScrollBar.Position;
        fieldbyname('Width').value := Width;
        fieldbyname('Height').value := Height;
        fieldbyname('Shading').value := tRichEdit(controls[0]).color;
        fieldbyname('Border').value := BorderWidth;
        fieldbyname('bitLangReview').value := false;
        tRichEdit(controls[0]).lines.savetofile(dmOpenQ.tempdir+'\RichEdit.rtf');
        tBlobField(fieldbyname('RichText')).loadfromfile(dmOpenQ.tempdir+'\RichEdit.rtf');
         post;
        tDQPanel(elementlist[i]).modified := false;
      end;
    end;
  end;
   *)
  procedure UpdateLogoRefs;
  var SelLogoID,PersCode:integer;
      s,CodeName : string;
  begin
    with tDQPanel(elementlist[i]), DMOpenQ.wwt_TextBox do begin
      if CurTag = 0 then
        messagedlg('LogoRef "'+copy(tRichEdit(controls[0]).lines[0],1,20)+'..." doesn''t have an ID# and will not be saved',mtError,[mbOK],0);
      if tDQPanel(elementlist[i]).modified then begin
        if findkey([DMOpenQ.glbSurveyID,curTag]) then
          edit
        else begin
          append;
          fieldbyname('Survey_ID').value := DMOpenQ.glbSurveyID;
          fieldbyname(qpc_ID).value := curTag;
          fieldbyname('Type').value := 'TextBox';
          fieldbyname('bitLangReview').value := false;
        end;
        fieldbyname('CoverID').value := pg;
        fieldbyname('Language').value := 1;
        fieldbyname('X').value := Left+ScrollboxCovers.horzScrollBar.Position;
        fieldbyname('Y').value := Top+ScrollboxCovers.VertScrollBar.Position;
        fieldbyname('Width').value := Width;
        fieldbyname('Height').value := Height;
        fieldbyname('Shading').value := clGreen;
        s := caption;
        mydelete(s,1,7);
        if pos('.',s)>0 then begin
          sellogoid := strtoint(copy(s,1,pos('.',s)-1));
          mydelete(s,1,pos('.',s));
          perscode := strtoint(copy(s,1,pos('.',s)-1));
          mydelete(s,1,pos('.',s));
          CodeName := s;
        end else begin
          sellogoid := strtoint(s);
          perscode := -1;
          CodeName := '';
        end;
        fieldbyname('Border').value := sellogoid;
        fieldbyname('bitLangReview').value := false;
        if perscode = -1 then
          tBlobField(fieldbyname('RichText')).value := ''
        else
          tBlobField(fieldbyname('RichText')).value := CodeName + '::\{'+inttostr(perscode)+'\}';
        post;
        tDQPanel(elementlist[i]).modified := false;
      end;
    end;
  end;

  procedure UpdateLogos;
  begin
   {look for record, if there edit else append}
    with tDQPanel(elementlist[i]), DMOpenQ.wwt_Logo do begin
      if CurTag = 0 then
        messagedlg('Logo "'+caption+'" doesn''t have an ID# and will not be saved',mtError,[mbOK],0);
      if tDQPanel(elementlist[i]).modified then begin
        if findkey([DMOpenQ.glbSurveyID,curTag]) then
          edit
        else begin
          append;
          fieldbyname('Survey_ID').value := DMOpenQ.glbSurveyID;
          fieldbyname(qpc_ID).value := curTag;
          fieldbyname('Type').value := 'Logo';
        end;
        fieldbyname('CoverID').value := pg;
        fieldbyname('Description').value := caption;
        fieldbyname('X').value := Left+ScrollboxCovers.horzScrollBar.Position;
        fieldbyname('Y').value := Top+ScrollboxCovers.VertScrollBar.Position;
        fieldbyname('Width').value := Width;
        fieldbyname('Height').value := Height;
        fieldbyname('Scaling').value := tDQImage(controls[0]).DPI;
        fieldbyname('Visible').value := tDQImage(controls[0]).visible;
        tDQImage(controls[0]).picture.savetofile(dmOpenQ.tempdir+'\Logo.bmp');
        tBlobField(fieldbyname('BitMap')).loadfromfile(dmOpenQ.tempdir+'\Logo.bmp');
        post;
        tDQPanel(elementlist[i]).modified := false;
      end;
    end;
  end;

  procedure UpdatePCL;
  begin
   {look for record, if there edit else append}
    with tDQPanel(elementlist[i]), DMOpenQ.wwt_PCL do begin
      if CurTag = 0 then
        messagedlg('PCL "'+caption+'" doesn''t have an ID# and will not be saved',mtError,[mbOK],0);
      if tDQPanel(elementlist[i]).modified then begin
        if findkey([DMOpenQ.glbSurveyID,curTag]) then
          edit
        else begin
          append;
          fieldbyname('Survey_ID').value := DMOpenQ.glbSurveyID;
          fieldbyname(qpc_ID).value := curTag;
          fieldbyname('Type').value := 'PCL';
        end;
        fieldbyname('CoverID').value := pg;
        if color=clBlue then
          fieldbyname('Description').value := '*PageBreak*'
        else
          fieldbyname('Description').value := caption;
        fieldbyname('Language').value := 1;
        fieldbyname('X').value := Left+ScrollboxCovers.horzScrollBar.Position;
        fieldbyname('Y').value := Top+ScrollboxCovers.VertScrollBar.Position;
        fieldbyname('KnownDimensions').value := KnownDimensions;
        fieldbyname('Width').value := width;
        fieldbyname('Height').value := height;
        fieldbyname('PCLStream').value := PCL;
        post;
        tDQPanel(elementlist[i]).modified := false;
      end;
    end;
  end;

begin
  WLKHandle.detach;
  if ElementList.count > 0 then
    for i := 0 to ElementList.count-1 do begin
      curTag := tDQPanel(ElementList[i]).tag;
      if isLogoRef(elementlist[i]) then
        updateLogoRefs
      else if isTextBox(ElementList[i]) then
        updateTextBoxes
      else if isLogo(ElementList[i]) then
        updateLogos
      else if isPCL(ElementList[i]) then
        updatePCL;
    end;
end;

procedure FullQstnPanels(var SB : tSpeedButton; var all, Hdr, Qstn, Scl : tPowerPanel; var Shape:tShape);
begin
  if sb.Caption = 'ò' then begin
    sb.Caption := 'ñ';
    if hdr.name <> Qstn.name then all.Height := 101
    else all.Height := 75;
    if hdr.name <> Qstn.name then hdr.visible := true;
    Qstn.visible := true;
    Scl.visible := true;
    if hdr.name <> Qstn.name then Hdr.height := 26;
    Qstn.height := 26;
    Scl.height := 26;
    if hdr.name <> Qstn.name then begin
      Hdr.top := 2;
      Qstn.top := 28;
    end else
      Qstn.Top := 2;
    Shape.visible := true;
  end else begin
    sb.Caption := 'ò';
    all.Height := 24;
    if hdr.name <> Qstn.name then Hdr.visible := false;
    Qstn.visible := false;
    Scl.visible := false;
    Shape.visible := false;
  end;
  with f_dynaq do
    if ppQstnText.visible or ppSelQstnText.visible then
      clCodeToggle1.top := 4
    else
      clCodeToggle1.Top := 35;
end;
procedure TF_DynaQ.ShowQstnBtnClick(Sender: TObject);
begin
  FullQstnPanels(ShowQstnBtn,ppFullQstn,ppHeader,ppQstnText,ppScale,Shape1);
  wwDBEditAvailCoreChange(Sender);
end;

procedure TF_DynaQ.ShowSelQstnBtnClick(Sender: TObject);
begin
  DBRESelQstnText.readonly := true;
  DBRESelQstnText.PopupMenu := modsupport.popRTF;
  btnCode.visible := false;
  DBQstnsNavigator.visible := false;
  tCodes.close;
  tCodeText.close;
  tConstant.close;
  dqDataModule.OpenCodeTables;
  FullQstnPanels(ShowSelQstnBtn,ppSelFullQstn,ppSelQstnText,ppSelQstnText,ppSelScale,Shape4);
end;
          
function AllScaleValues(scl:integer):string;
var s : string;
begin
  AllScaleValues := '';
  with DQDataModule, wwT_ScaleValues do begin
    first;
{    if not DQDataModule.wwT_Scales.Findkey([scl]) then
      ShowMessage('Scale ' + inttostr(scl) + ' Not Found')
    else} begin
      s := '';
      while (not eof) and (wwT_ScaleValuesScale.value = scl) do begin
        s := s + (wwT_ScaleValuesShort.asstring) + ' | '; {¤}
        next;
      end;
      AllScaleValues := copy(s,1,length(s)-3);
    end;
  end;
end;

procedure TF_DynaQ.wwDBEditAvailCoreChange(Sender: TObject);
begin
  if ppQstnText.visible then begin
    with DQDataModule do begin
      OpenCodeTables;
      OpenLibraryTables;
    end;
{
    with DQDataModule.wwT_Questions do
      if not FindKey([wwT_AvailableCore.text]) then
         ShowMessage(wwT_AvailableCore.text + ' Question Not Found in Library');
}
{    with dqDataModule.wwT_Questions do
      if not FindKey([wwT_AvailableCore.value]) then
         ShowMessage('Header ' + inttostr(wwT_AvailableHeadID.value) + ' Not Found');}
    with memoScale do begin
      lines.clear;
      lines[0] := allScaleValues(dqdatamodule.wwT_QuestionsScale.value);
    end;
  end;
  Screen.cursor := crDefault;
end;

procedure TF_DynaQ.ppFullQstnMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var orgH,orgQ,orgS : word;
begin
  orgH := ppHeader.height;
  orgQ := ppQstnText.height;
  orgS := ppScale.height;
  if (ppFullQstn.height-23) <> (orgH+orgQ+orgS) then begin
    ppHeader.height := (orgH*(ppFullQstn.height-23)) div (orgH+orgQ+orgS) ;
    ppQstnText.height := (orgQ*(ppFullQstn.height-23)) div (orgH+orgQ+orgS) ;
  { ppScale.height := (orgS*(ppFullQstn.height-23)) div (orgH+orgQ+orgS) ;}
  end;
  ppScale.align := alClient;
end;

procedure TF_DynaQ.ppFullQstnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ppScale.align := alNone;
end;

procedure TF_DynaQ.SortBtnClick(Sender: TObject);
var FullQstnVisible:boolean;
begin
  Screen.Cursor := crHourGlass;
  FullQstnVisible := (ShowQstnBtn.Caption <> 'ò');
  if FullQstnVisible then ShowQstnBtnClick(Self);
  try
    frmSort := TfrmSort.Create( Self );
    with frmSort do
    try
      wwTable := DQDataModule.wwT_Questions;
      ShowModal;
    finally
      Release;
    end;
  finally
    if FullQstnVisible then ShowQstnBtnClick(Self);
    Screen.Cursor := crDefault;
  end;

(*
type
  torder = record
    field : string;
    position : word;
  end;
var s : string;
    order : array[-1..5] of tOrder;
    i,j,n : integer;

  procedure IsIn(var s : string; const f,c : string);
  begin
    if pos(f,s) > 0 then begin
      order[n].field := c;
      order[n].position := pos(f,s);
      inc(n);
    end;
  end;
begin
(*
  n := 0;
  s := 'Core, Description, Scale, Heading, Service, Theme';
  if InputQuery('Sort On ...', 'Which field(s) do you want sorted?',s) then begin
    s := uppercase(s);
    IsIn(s,'CORE','d.Core');
    IsIn(s,'DESCRIPTION','d.Short');
    IsIn(s,'SCALE','d.ScaleLabel');
    IsIn(s,'HEADING','d1.HShort');
    IsIn(s,'SERVICE','d.Service');
    IsIn(s,'THEME','d.Theme');
    if n = 0 then begin
      MessageDlg('Couldn''t recognize fieldname(s).  Reverting to Core ordering.',
         mtError, [mbOk], 0);
      n := 1;
      order[0].field := 'CORE';
    end else
      for i := 0 to n-1 do
        for j := i to n-1 do
          if order[i].position > order[j].position then begin
            order[-1] := order[i];
            order[i] := order[j];
            order[j] := order[-1];
          end;
    order[-1].field := '';
    for i := 0 to n-1 do
      order[-1].field := order[-1].field + order[i].field + ', ';
    order[-1].field := copy(order[-1].field,1,length(order[-1].field)-2);
    Screen.cursor := crHourglass;
    dqdatamodule.wwT_Questions.Close;
    with wwt_Available.Query do begin
      clear;
      add('SELECT  d.ServID, d.ThemID, d.Short, d.LangID,');
      add('  d.Core, d.Fielded, d.FollowedBy, d.PrecededBy,');
      add('  d.Restrict, d.Scale, d.ScaleLabel,');
      add('  d.HeadID, d.Service, d.Theme, d1.HShort, d1.HFielded');
      add('FROM');
      add('  "T1.db" d Left Outer Join "T2.db" d1 on');
      add('      ((d1.HeadID = d.HeadID)');
      add('  AND (d1.LangID = d.LangID))');
      add('ORDER BY');
      add('  ' + order[-1].field);
    end;
    wwt_Available.open;
    srcList.update;
    Screen.cursor := crDefault;
  end;
*)
end;

procedure TF_DynaQ.wwT_Available2AfterOpen(DataSet: TDataSet);
begin
(*
  with wwt_Available.indexdefs do begin
    create(wwt_available);
    add('IndexDescription','Short',[]);
    add('IndexCore','Core',[]);
    add('IndexScale','ScaleLabel',[]);
    add('IndexService','Service',[]);
    add('IndexTheme','Theme',[]);
    add('IndexHeading','HShort',[]);
  end;
  lblThemes.caption := inttostr(wwt_Available.indexdefs.count);
*)
end;

procedure TF_DynaQ.FilterBtnClick(Sender: TObject);
begin
  with wwfilterdialog do
    if Execute then
      if FieldInfo.Count > 0 then
        FilterPanel.caption := 'Filtered'
      else
        FilterPanel.caption := 'No Filter';

end;

procedure findnext(down:boolean);
var t : string;
    fnd : boolean;
    i : integer;
begin
  fnd := false;
  with f_DynaQ, dqdatamodule, wwT_Questions do begin
    statuspanel.caption := 'Found: ';
    screen.cursor := crHourGlass;
    if frmSearch.cbLong.checked then
      wwt_QuestionText.mastersource := nil;
    while not fnd and not ((eof and down) or (bof and not down)) do begin
      t := '';
      with frmSearch do begin
        if cbCore.checked then t := t + uppercase(wwT_QuestionsCore.text) + ' ';
        if cbShort.checked then t := t + uppercase(wwT_QuestionsShort.text) + ' ';
        if cbHeading.checked then t := t + uppercase(wwT_QuestionsHeading.text) + ' ';
        if cbScale.checked then t:= t + uppercase(AllScaleValues(wwT_QuestionsScale.value)) + ' ';
        if cbLong.checked then
          if wwt_QuestionText.FindKey([wwT_QuestionsCore.value]) then
            t := t + uppercase(wwt_QuestionTextText.asstring);
        if rgAndOr.itemIndex = 0 then begin {AND}
          fnd := true;
          for i := 0 to SearchFor.RowCount-1 do begin
            if searchfor.cells[0,i] <> '' then begin
              fnd := fnd and (pos(uppercase(SearchFor.Cells[0,i]),t) > 0);
              if pos(uppercase(SearchFor.Cells[0,i]),t) > 0 then
                statuspanel.caption := statuspanel.caption + ''''+ searchfor.cells[0,i] + '''  ';
            end;
          end;
        end else begin {OR}
          fnd := false;
          for i := 0 to SearchFor.RowCount-1 do
            if searchfor.cells[0,i] <> '' then begin
              fnd := fnd or (pos(uppercase(SearchFor.Cells[0,i]),t) > 0);
              if pos(uppercase(SearchFor.Cells[0,i]),t) > 0 then
                statuspanel.caption := statuspanel.caption + ''''+ searchfor.cells[0,i] + '''  ';
            end;
        end;
      end;
      if not fnd then
        if down then next else prior;
    end;
    if frmSearch.cbLong.checked then
      wwt_QuestionText.mastersource := wwDS_Questions;
    if not fnd then begin
      statuspanel.caption := 'Not Found';
      messagebeep(0);
    end;
    screen.cursor := crDefault;
  end;
  dqDataModule.wwt_Questions.enablecontrols;
  dqDataModule.wwT_QuestionText.enablecontrols;
  dqDataModule.wwT_HeadText.enablecontrols;
end;

procedure TF_DynaQ.FindBtnClick(Sender: TObject);
begin
  frmSearch.showmodal;
  with frmSearch do
    if CBCore.checked or CBHeading.checked or CBLong.checked or
        CBScale.checked or CBShort.checked then begin
      dqDataModule.wwt_Questions.disablecontrols;
      dqDataModule.wwT_QuestionText.disablecontrols;
      dqDataModule.wwT_HeadText.disablecontrols;
      if FromTheTop then DQDataModule.wwT_Questions.first;
      findnext(true);
      SearchDown := true;
    end;
end;

procedure TF_DynaQ.SpinButton1DownClick(Sender: TObject);
begin
  dqDataModule.wwt_Questions.disablecontrols;
  dqDataModule.wwT_QuestionText.disablecontrols;
  dqDataModule.wwT_HeadText.disablecontrols;
  if not DQDataModule.wwT_Questions.eof then DQDataModule.wwT_Questions.next;
  findnext(true);
  searchdown := true;
end;

procedure TF_DynaQ.SpinButton1UpClick(Sender: TObject);
begin
  dqDataModule.wwt_Questions.disablecontrols;
  dqDataModule.wwT_QuestionText.disablecontrols;
  dqDataModule.wwT_HeadText.disablecontrols;
  if not DQDataModule.wwT_Questions.bof then DQDataModule.wwT_Questions.prior;
  findnext(false);
  searchdown := false;
end;

procedure TF_DynaQ.Sort1Click(Sender: TObject);
begin
  SortBtnClick(Sender);
end;

procedure TF_DynaQ.Filter1Click(Sender: TObject);
begin
  FilterBtnClick(Sender);
end;

procedure TF_DynaQ.Find1Click(Sender: TObject);
begin
  FindBtnClick(Sender);
end;

procedure TF_DynaQ.FindNext1Click(Sender: TObject);
begin
  SpinButton1DownClick(Sender);
end;

procedure TF_DynaQ.FindPrior1Click(Sender: TObject);
begin
  SpinButton1UpClick(Sender);
end;

procedure TF_DynaQ.SelectedQuestions1Click(Sender: TObject);
begin
  if Pagecontrol1.ActivePage <> Selection then begin
    LeavingCoverPage;
    Pagecontrol1.ActivePage := Selection;
    PageControl1Change(Sender);
  end;
end;

procedure TF_DynaQ.CoverLetters1Click(Sender: TObject);
begin
  if Pagecontrol1.ActivePage <> CoverSheets then begin
    ClearElementList;
    Pagecontrol1.ActivePage := CoverSheets;
    PageControl1Change(Sender);
  end;
end;

procedure TF_DynaQ.Options1Click(Sender: TObject);
begin
  with TF_options.create(application) do
    try
      showModal;
      //GN03: Save the options only when the user clicks OK
      if ModalResult = mrOK then
         SaveOptionInfo;
    finally
      free;
    end;
end;


procedure TF_DynaQ.ViewRestrictedQuestionsClick(Sender: TObject);
begin
  ViewRestrictedQuestions.checked := not ViewRestrictedQuestions.checked;
  DQDataModule.FilterRestrict := ViewRestrictedQuestions.checked;
  DQDataModule.updateQstnFilter;
  SrclistRefresh;
end;

procedure TF_DynaQ.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TF_DynaQ.wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
  if field.fieldname = 'PlusMinus' then
    afont.style := [fsBold]
  else
    afont.style := [];
  Abrush.color := clWhite;

  with DMOpenQ.wwT_Qstns do begin
    if fieldbyname('item').value = 0 then begin
      if (fieldByName('subsection').value = 0) then begin
        {Section color}
        abrush.color := clTeal;
        Afont.color := clwhite;
      end else begin
        {Subsection color}
        abrush.color := clSilver;
        aFont.color := clmaroon;
      end;
    end else
      if (fieldbyname('subtype').value=4) and (aBrush.color<>clPurple) then
        afont.color := clNavy;
    if fieldbyname('sampleunit_id').asinteger=10 then begin
      afont.Style := afont.style + [fsItalic];
      afont.Color := clGray;
    end;
  end;

  with Sender as TwwDBGrid do begin
    if CalcCellRow = GetActiveRow then begin
      ABrush.Color := clPurple;
      aFont.Color := clWhite;
    end;
    if isSelected then begin
      ABrush.Color := clPurple;
      aFont.Color := clWhite;
    end;
  end;
end;

procedure TF_DynaQ.wwDBGrid1DblClick(Sender: TObject);
begin
  DMOpenQ.ExpandCollapse;
end;

procedure TF_DynaQ.wwDBGrid1RecordChange;
var
  dbGridSectChng,dbGridSubChng,dbGridQChng : boolean;
begin
  dbGridSectChng := false;
  dbGridSubChng := false;
  dbGridQChng := false;
  with dmOpenQ.wwt_Qstns do begin
    if fieldbyname(qpc_Section).value <> dbGridCurSect then begin
      dbGridSectChng := true;
      dbGridSubChng := true;
      dbGridQChng := true;
    end;
    if fieldbyname('SubSection').value <> dbGridCurSub then begin
      dbGridSubChng := true;
      dbGridQChng := true;
    end;
    if fieldbyname('Item').value <> dbGridCurQ then
      dbGridQChng := true;
    if dbGridSectChng then dbGridCurSect := fieldbyname(qpc_Section).value;
    if dbGridSubChng then begin
      dbGridCurSub := fieldbyname('Subsection').value;
      DQTrackBar.Position := 54{8};
      if ppQstnLayout.width > 0 then
        Layout{SubSection};
    end;
    if dbGridQChng then begin
      dbGridCurQ := fieldbyname('Item').value;
      if ppQstnLayout.width > 0 then HighLightCurrentQ;
    end;
  end;
end;

procedure TF_DynaQ.wwDBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_escape then dmOpenQ.UnCutQuestions;
  if (ssctrl in shift) then
    if (key=vk_up) or (key=vk_down) then begin
      wwdbgrid1.Tag := DMOpenQ.wwT_QstnsID.value;
      DMOpenQ.wwT_Qstns.disablecontrols;
    end else
      wwdbgrid1.Tag := 0
  else if not (ssShift in shift) then
    wwdbgrid1.UnselectAll;
  wwdbgrid1.refresh;
end;

procedure TF_DynaQ.wwDBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssctrl in shift) then begin
    if wwdbgrid1.Tag > 0 then
      with DMOpenQ, wwT_Qstns do begin
        indexFieldName := 'Survey_ID;SelQstns_ID';
        findkey([DMOpenQ.glbSurveyID,wwdbgrid1.Tag]);
        indexFieldName := qpc_Section+';SubSection;Item';
        wwdbgrid1.Tag := 0;
        wwt_QstnsEnableControlsDammit;
      end;
    if key = vk_up then
      DMOpenQ.QstnMoveUp
    else
      if key = VK_DOWN then
        DMOpenQ.QstnMoveDown;
  end;
  wwdbgrid1.refresh;
  wwDBGrid1RecordChange;
end;

procedure TF_DynaQ.wwDBGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{
  if Button = mbLeft then begin
    if DMOpenQ.wwT_Qstnsitem.value > 0 then
      with sender as twwDBGrid do begin
        //BeginDrag(False);
        //lblThemes.caption := inttostr(y) + ', ' + inttostr(((y-2) div 15) + 1);
        if shift = [ssctrl,ssLeft] then begin
          if isselected then
            selectrecord
          else
            unselectrecord;
        end else begin
          if (not isselected) then begin
            SelectedList.clear;
            selectrecord;
          end;
        end;
        wwdbgrid1.refresh;
      end;
  end;
}
  //wwDBGrid1RecordChange;
end;

procedure TF_DynaQ.updatecorelist;
var
  orgfilterstate : boolean;
  orgS,orgSS,orgI : integer;
begin
  corelist.clear;
  with dmopenq,wwt_Qstns do begin
    DisableControls;
    orgFilterState := filtered;
    orgS := wwt_QstnsSection.value;
    orgSS := wwt_QstnsSubsection.value;
    orgI := wwt_QstnsItem.value;
    filtered := false;
    first;
    while not eof do begin
      if (wwt_Qstnssubtype.value = 1) and (wwt_QstnsQstnCore.value <> null) then
        corelist.add(wwt_QstnsQstnCore.text);
      next;
    end;
    filtered := orgFilterState;
    findkey([orgS,orgSS,orgI]);
    wwt_QstnsEnableControls;
  end;
  srclistrefresh;
end;

procedure TF_DynaQ.Delete2Click(Sender: TObject);
begin
  if PageControl1.ActivePage.PageIndex = CoverSheets.PageIndex then begin
    if WLKHandle.childcount > 0 then
      DeleteBoxClick(Sender);
  end else begin
    if ActiveControl=wwDBGrid1 then begin
      {GN01 
      if (DMOpenQ.glbSurveyID > 0) and (DMOpenQ.wwt_qstnsSubType.value = stSection) then  begin
        if DMOpenQ.MappedSections then
           if MessageBox(Screen.ActiveForm.Handle,
                               'Deleting a section will change the mapping of your survey.'#13#10#13#10+
                               'Do you want proceed?'#13#10#13#10,
                               'WARNING!',
                               MB_APPLMODAL or MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2) = ID_NO then
           Exit;
      end; }

      DMOpenQ.DeleteThis;
      DMOpenQ.DeletedAddedSections := true;
      updatecorelist;
      if ppQstnLayout.width > 0 then Layout{Subsection};
    end;
  end;
end;

procedure TF_DynaQ.NewSection3Click(Sender: TObject);
begin
  if (DMOpenQ.glbSurveyID > 0) then  begin
        if DMOpenQ.MappedSections then
           if MessageBox(Screen.ActiveForm.Handle, 'Inserting a section will change the mapping of your survey.'#13#10#13#10+
                               'Do you want proceed?'#13#10#13#10,
                               'WARNING!',
                               MB_APPLMODAL or MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2) = ID_NO then
              Exit;
      end;

  DMOpenQ.DeletedAddedSections := true;
  DMOpenQ.AddSection;
end;

procedure TF_DynaQ.NewSubsection3Click(Sender: TObject);
begin
  DMOpenQ.AddSubSection('',false);
end;

procedure TF_DynaQ.SetTabs;
  procedure clearpagetabs;
  var I:integer;
  begin
    for i := 0 to 9 do
      with pagetabs[i] do begin
        integrated := true;
        letterhead := false;
        PageType := -1;
        description := '';
      end;
  end;
var i : integer;
begin
  with DMOpenQ.wwT_Cover do begin
    first;
    tabset1.tabs.clear;
    clearpagetabs;
    i := 0;
    tabset1.tabs.add('Graphics');
    pagetabs[0].pagetype:=ptArtifacts;
    pagetabs[0].description := 'Graphics';
    while not eof do begin
      inc(i);
      if fieldbyname('PageType').value = ptArtifacts then
        tabset1.tabs.add('[' + fieldbyname('Description').text + ']')
      else
        tabset1.tabs.add(fieldbyname('Description').text);
      with pagetabs[i] do begin
        integrated := fieldbyname('Integrated').value;
        letterhead := fieldbyname('bitLetterhead').value;
        Pagetype := fieldbyname('PageType').value;
        Description := fieldbyname('Description').text;
      end;
      next;
    end;
    FireTabChangeEvent := false;
    tabset1.tabindex := 1;
    FireTabChangeEvent := true;
  end;
end;

procedure TF_DynaQ.SaveOptionInfo;
var orgfiltered : boolean;
    s,orgindex : string;
begin
  if dmOpenQ.wwt_Qstns.active then
    with dmOpenq, DBRESelQstnText do begin
      orgfiltered := wwt_Qstns.filtered;
      orgindex := wwt_Qstns.indexfieldnames;
      if orgfiltered then wwt_Qstns.filtered := false;
      wwt_Qstns.indexfieldnames := 'Section_ID;Subsection;Item';
      wwt_Qstns.first;
      while (wwt_qstns.FieldByName(qpc_section).value=-1)
          and (wwt_qstns.FieldByName('Subsection').value=0)
          and (wwt_qstns.FieldByName('Item').value=0) do begin
        wwt_Qstns.edit;
        if ConsiderDblLegal then S := '··Y'
        else                     S := '··N';

        if ResponseShape = 2 then s := s + '2'
        else                      s := s + '1';

        if ShadingOn then s := s + 'T'
        else              s := s + 'F';

        if TwoColumns  then s := s + 'T'
        else              s := s + 'F';

        if SpreadToFillPages then s := s + 'T'
        else                      s := s + 'F';

        if ExtraSpace>0 then s := s + format('%5d',[ExtraSpace])
        else s := s + '00000';
        //GN03: Save the most recent option as it was causing a corrupt code exception during Validate Layout
        // This info is stored in Address and FOUO information section of the survey
        DBRESelQstnText.Lines.Clear;
        DBRESelQstnText.Lines.Add(s);
        {
        if DBRESelQstnText.Lines.Count > 0 then
          Lines[0] := s
        else
          Lines.Add(s);}
        SelStart := 0;
        SelLength := 1;
        SelAttributes.name := QstnFont;
        SelAttributes.size := QstnPoint;
        SelStart := 1;
        SelLength := 1;
        SelAttributes.name := SclFont;
        SelAttributes.size := SclPoint;
        SelStart := 0;
        SelLength := 0;  
        wwt_Qstns.post;
        wwt_Qstns.next;
      end;
      wwt_Qstns.indexfieldnames := orgindex;
      if orgfiltered then wwt_Qstns.filtered := true;
    end;
end;

procedure TF_DynaQ.Save1Click(Sender: TObject);
begin
  if not dmOpenQ.laptop then begin
    SaveOptionInfo;
    if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
      SaveCover(tabset1.tabindex);
    dmOpenQ.SaveSQLSurvey(false,false);
  end;
end;

procedure TF_DynaQ.Saveas1Click(Sender: TObject);
var orgfiltered : boolean;
    orgindex : string;
    RichEdit:tRichedit;
    s:tMemoryStream;

begin
  SaveOptionInfo;

  with dmOpenq do begin
    orgfiltered := wwt_Qstns.filtered;
    orgindex := wwt_Qstns.indexfieldnames;
    if orgfiltered then wwt_Qstns.filtered := false;
    wwt_Qstns.indexfieldnames := 'Section_ID;Subsection;Item';
    with tRichedit.Create(self) do
    begin
      s:= tMemoryStream.create;
      parent:=self;
      Text := wwt_Qstns.FieldByName('RichText').value;
      Lines.Add('User Name =' +GetUser+', PC=' + computername + ', Opened on '+ formatDatetime('mm/dd/yyyy hh:nn:ss',OpenDateTime) + ' and Saved on ' + formatDatetime('mm/dd/yyyy hh:nn:ss',now) ) ;
      Lines.SaveToStream(s);
      wwt_Qstns.edit;
      wwT_QstnsRichText.LoadFromStream(s);
      wwt_Qstns.post;
      s.free;
      free;
    end;
    wwt_Qstns.indexfieldnames := orgindex;
    if orgfiltered then wwt_Qstns.filtered := true;
  end;


  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    SaveCover(tabset1.tabindex);
  dmOpenQ.SaveSurveyAs;
end;

procedure TF_DynaQ.SrcListDblClick(Sender: TObject);
begin
  with DQDataModule do
    if CoreList.indexOf(wwT_QuestionsCore.text) = -1 then begin
      if DMOpenQ.AddQstn then begin
        Corelist.add(wwT_QuestionsCore.text);
        wwDBGrid1.UnselectAll;
      end;
      srclistrefresh;
    end else
      messagebeep(0);
end;

procedure TF_DynaQ.DBRESelQstnTextChange(Sender: TObject);
var s : string;
begin
  if ppSelQstnText.visible then begin
    s := '';
    with dmOpenQ, wwt_scls do
      if active then begin
        IndexFieldNames := 'Survey_id;'+qpc_ID;
        if findkey([glbsurveyid,wwT_QstnsScaleID.value]) then begin
          while (not eof) and (wwt_QstnsScaleID.value = wwt_SclsID.value) do begin
            s := s + wwt_SclsLabel.value + ' | ';
            next;
          end;
          s := copy(s,1,length(s)-3);
        end;
      end;
    MemoSelScale.lines.clear;
    MemoSelScale.lines[0] := s;
  end;
end;

procedure TF_DynaQ.ScrollBoxCoversMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  WLKHandle.detach;
end;

function TF_DynaQ.isTextBox(const obj:TControl):boolean;
begin
  result := (obj <> nil) and (tDQPanel(obj).controlcount = 1) and (tDQPanel(obj).controls[0] is tRichEdit);
end;

function TF_DynaQ.isLogo(const obj:TControl):boolean;
begin
  result := (obj <> nil) and (
    ((tDQPanel(obj).controlcount = 1) and (tDQPanel(obj).controls[0] is tDQImage)) or
    ((tDQPanel(obj).controlcount = 2) and (tDQPanel(obj).controls[0] is tDQImage) and (tDQPanel(obj).controls[1] is tEdit))
   );
end;

function TF_DynaQ.isLogoRef(const obj:TControl):boolean;
begin
  result := (obj <> nil) and (tDQPanel(obj).controlcount = 1) and (copy(tDQPanel(obj).caption,1,7) = 'LogoRef') and (tDQPanel(obj).controls[0] is tDQImage);
end;

function TF_DynaQ.isPCL(const obj:TControl):boolean;
begin
  result := (obj <> nil) and (tDQPanel(obj).controlcount = 0);
end;

procedure TF_DynaQ.PopupTextBoxPopup(Sender: TObject);
var i : integer;
begin

  with WLKHandle do begin
    menuEdit.Enabled := ((childcount = 1) and isTextBox(children[0]));
    if menuEdit.Enabled then
      filterpanel.caption := 'TB#' + inttostr(tDQPanel(children[0]).tag);
    EditTextBoxTranslations.Enabled := menuEdit.Enabled;
    EditTextBoxTranslations.caption := 'Edit Translations ...';
    BorderShading.Enabled := true;
    EditTextBoxTranslations.visible := true;
    for i := 0 to childcount-1 do
      if not isTextBox(children[i]) then
        BorderShading.Enabled := false;
    if ((childcount = 1) and isPCL(children[0])) then begin
      if tDQPanel(children[0]).color = clBlue then begin
        EditTextBoxTranslations.visible := false;
      end else begin
        EditTextBoxTranslations.caption := 'Choose Translated PCL file ...';
        EditTextBoxTranslations.Enabled := true;
      end;
    end;
  end;
end;

procedure TF_DynaQ.PopupLogoPopup(Sender: TObject);
begin
  with WLKHandle do begin
    changeLogo.Enabled := ((childcount = 1) and isLogo(children[0]));
    renameLogo.enabled := changelogo.enabled;
    dpi.visible := ((childcount = 1) and isLogo(children[0]) and (not isLogoRef(children[0])));
    renamelogo.visible := dpi.visible;
    visible1.checked := (isLogo(children[0]) and tDQImage(tDQPanel(children[0]).controls[0]).visible);
    n300.checked := (tDQImage(tDQPanel(children[0]).controls[0]).DPI = 300);
    n600.checked := not n300.checked;
  end;
end;

procedure TF_DynaQ.BringtofrontClick(Sender: TObject);
begin
  WLKHandle.BringToFront;
end;

procedure TF_DynaQ.SendtobackClick(Sender: TObject);
begin
  WLKHandle.SendToBack;
end;

procedure TF_DynaQ.ClearElementList;
var I : integer;
begin
  WLKHandle.detach;
  if elementlist.count > 0 then
    for i := 0 to elementlist.count-1 do
      if (elementList[i]<>nil) then begin
        if tComponent(elementlist[i]) is tDQPanel then
          tDQPanel(elementlist[i]).free
        else if tComponent(elementlist[i]) is tDQRichEdit then
          tDQRichEdit(elementlist[i]).free
        else if tComponent(elementlist[i]) is tLabel then
          tLabel(elementlist[i]).free;
        elementlist[i] := nil;
      end;
  elementlist.pack;
end;

procedure TF_DynaQ.DeleteBoxClick(Sender: TObject);
var I,J : integer;
begin
  with WLKHandle do begin
    for i := 0 to childcount-1 do
      tDQPanel(children[i]).bevelWidth := 10;
    detach;
  end;
  for i := 0 to elementlist.count-1 do
    if (elementList[i]<>nil) and (tDQPanel(elementlist[i]).BevelWidth = 10) then begin
      j := 0;
      if isTextbox(elementlist[i]) then begin
        with DMOpenQ.wwT_TextBox do
          if findkey([DMOpenQ.glbSurveyID,tDQPanel(elementlist[i]).tag]) then
            delete;
      end else if isLogoRef(elementlist[i]) then begin
        with DMOpenQ.wwT_TextBox do
          if findkey([DMOpenQ.glbSurveyID,tDQPanel(elementlist[i]).tag]) then
            delete;
      end else if isLogo(elementlist[i]) then begin
        if tabset1.tabindex=0 then begin
          dmopenq.localquery('Select border from sel_textbox where border='+inttostr(tDQPanel(elementlist[i]).tag),false);
          j := dmopenq.ww_Query.recordcount;
          if (J>0) and (messagedlg('"'+tDQPanel(elementlist[i]).caption+'" is referenced on one or more cover letters.  Are you sure you want to delete it?',mtconfirmation,[mbyes,mbno],0)=mrYes) then begin
            dmopenq.cn.execute('delete from sel_textbox where border='+inttostr(tDQPanel(elementlist[i]).tag));
            j := 0;
          end;
        end;
        if j = 0 then
          with DMOpenQ.wwT_Logo do
            if findkey([DMOpenQ.glbSurveyID,tDQPanel(elementlist[i]).tag]) then
              delete;
      end else if isPCL(elementlist[i]) then begin
        with DMOpenQ.wwT_PCL do
          if findkey([DMOpenQ.glbSurveyID,tDQPanel(elementlist[i]).tag]) then
            delete;
        if (tDQPanel(elementlist[i]).color = clBlue) and (pagetabs[tabset1.tabindex].pagetype=ptLetter) then
          PageBreak1.enabled := true;
      end;
      if j = 0 then begin
        with tDQPanel(elementlist[i]) do begin
          if controlcount > 0 then
            for j := controlcount-1 downto 0 do
              controls[j].free;
          free;
        end;
        elementlist[i] := nil;
      end;
    end;
  elementlist.pack;
end;


//GN04: to remove all logos from the selected cover letter
procedure TF_DynaQ.mniDeleteAllLogosClick(Sender: TObject);
var I,J : integer;
begin
  //use this to delete all logos
  with WLKHandle do begin
    for i := 0 to childcount-1 do
      tDQPanel(children[i]).bevelWidth := 10;
    detach;
  end;
  for i := 0 to elementlist.count-1 do
  begin
    if (elementList[i]<>nil) {and (tDQPanel(elementlist[i]).BevelWidth = 10)} then
    begin
      j := 0;
      if isLogo(elementlist[i]) then
      begin
        if tabset1.tabindex=0 then
        begin
          dmopenq.localquery('Select border from sel_textbox where border='+inttostr(tDQPanel(elementlist[i]).tag),false);
          j := dmopenq.ww_Query.recordcount;
          if (J>0) and (messagedlg('"'+tDQPanel(elementlist[i]).caption+'" is referenced on one or more cover letters.  Are you sure you want to delete it?',mtconfirmation,[mbyes,mbno],0)=mrYes) then
          begin
            dmopenq.cn.execute('delete from sel_textbox where border='+inttostr(tDQPanel(elementlist[i]).tag));
            j := 0;
          end;
        end;

        if j = 0 then
        begin
           //delete from the table
           with DMOpenQ.wwT_Logo do
           if findkey([DMOpenQ.glbSurveyID,tDQPanel(elementlist[i]).tag]) then
           begin
              delete;
           end;

           //update the screen
          with tDQPanel(elementlist[i]) do
          begin
             if controlcount > 0 then
               for j := controlcount-1 downto 0 do
                 controls[j].free;
             free;
          end;
          elementlist[i] := nil;
         end;
      end;
    end;
  end;
  elementlist.pack;

end;

//GN04: to remove the phantom logo from the cover letter
procedure TF_DynaQ.mniDeletePLogoClick(Sender: TObject);
var I,J : integer;
begin

  //use this to delete only the phantom logo
  with WLKHandle do begin
    for i := 0 to childcount-1 do
      tDQPanel(children[i]).bevelWidth := 10;
    detach;
  end;

  for i := 0 to elementlist.count-1 do
  begin
    if (elementList[i]<>nil) {and (tDQPanel(elementlist[i]).BevelWidth = 10)} then
    begin
      j := 0;
      if isLogo(elementlist[i]) then
      begin
         with DMOpenQ.wwT_Logo do
         if findkey([DMOpenQ.glbSurveyID,tDQPanel(elementlist[i]).tag]) then
         begin
            //this property
            if (FieldByName('Description').AsString = '(none)') and
               (FieldByName('Width').AsInteger = 0) and
               (FieldByName('Height').AsInteger = 0) then
            delete;
         end;
      end;
    end;
  end;

end;


procedure TF_DynaQ.menuEditClick(Sender: TObject);
begin
  if WLKHandle.childcount = 1 then begin
    tRichEdit(tDQPanel(WLKHandle.children[0]).Controls[0]).lines.SaveToFile(dmOpenQ.tempdir+'\RichEdit.rtf');

    frmREEdit := TfrmREEdit.Create( Self );
    with frmREEdit do
    try
      lblTextBoxName.Visible := true;
      edTextBoxName.Visible := true;
      edTextBoxName.Text := tDQPanel(WLKHandle.children[0]).TextBoxName;
      wtText.Edit;
      wtTextText.LoadFromFile(dmOpenQ.tempdir+'\RichEdit.rtf');
      wtText.Post;
      caption := 'Edit Text Box';
      if ShowModal = mrOK then begin
        dmOpenQ.SaveDialog.tag := 2;
        tDQPanel(WLKHandle.children[0]).modified := true;
        tDQPanel(WLKHandle.children[0]).TextBoxName := edTextBoxName.Text;
        with tRichEdit(tDQPanel(WLKHandle.Children[0]).Controls[0]) do begin
          lines.LoadFromFile(dmOpenQ.tempdir+'\RichEdit.rtf');
          refresh;
        end;
      end;
      lblTextBoxName.Visible := false;
      edTextBoxName.Visible := false;
    finally
      Release;
    end;
  end;
end;

procedure TF_DynaQ.BorderShadingClick(Sender: TObject);
var i : integer;
    border : integer;
    borderT : string;
    shadecolor : integer;
begin
  with WLKHandle do begin
    border := tDQPanel(children[0]).borderwidth;
    shadecolor := tRichEdit(tDQPanel(children[0]).controls[0]).color;
    for i := 0 to childcount-1 do begin
      if border <> tDQPanel(children[i]).borderwidth then border := -1;
      if shadecolor <> tRichEdit(tDQPanel(children[i]).controls[0]).color then Shadecolor := -1;
    end;
    frmTextBoxAttributes := TfrmTextBoxAttributes.Create( Self );
    with frmTextBoxAttributes do
    try
      if border = -1 then BorderT := ''
      else BorderT := inttostr(border);
      edBorderWidth.text := BorderT;
      pnlShading.tag := shadecolor;
      if ShowModal = mrOK then
        dmOpenQ.SaveDialog.tag := 2;
        for i := 0 to childcount - 1 do begin
          tDQPanel(children[i]).modified := true;
          if trim(edBorderWidth.text) <> trim(BorderT) then
            tDQPanel(children[i]).borderwidth := strtoint(edborderwidth.text);
          if pnlshading.tag <> shadecolor then
            tRichEdit(tDQPanel(children[i]).controls[0]).color := pnlShading.tag;
        end;
    finally
      Release;
    end;
  end;
end;

procedure TF_DynaQ.Visible1Click(Sender: TObject);
var i : integer;
begin
  visible1.checked := (not visible1.checked);
  with WLKHandle do
    for i := 0 to childcount-1 do
      if isLogo(children[i]) then begin
        tDQPanel(children[i]).modified := true;
        with tDQImage(tDQPanel(children[i]).controls[0]) do
          visible := visible1.checked;
      end;
end;

procedure TF_DynaQ.N300Click(Sender: TObject);
begin
  if not n300.checked then begin
    n300.checked := true;
    n600.checked := false;
    ResizeLogo(2958);
  end;
end;

procedure TF_DynaQ.N600Click(Sender: TObject);
begin
  if not n600.checked then begin
    n600.checked := true;
    n300.checked := false;
    ResizeLogo(1479);
  end;
end;

procedure TF_DynaQ.ChangeLogoClick(Sender: TObject);
var sellogoid,perscode : integer;
    codename,s : string;
begin
  if (WLKHandle.childcount = 1) then
    if isLogoRef(WLKHandle.children[0]) then begin
      perscode := -1;
      dmopenq.LocalQuery('Select Description,Bitmap,scaling,'+qpc_ID+' from sel_logo where coverID=0 order by description',false);
      s := tDQPanel(WLKHandle.children[0]).caption;
      delete(s,1,7);
      sellogoid := strtoint(copy(s,1,pos('.',s)-1));
      delete(s,1,pos('.',s));
      PersCode := strtoint(copy(s,1,pos('.',s)-1));
      delete(s,1,pos('.',s));
      CodeName := s;
      dmopenq.ww_query.Locate(qpc_ID,sellogoid,[]);
      frmLogoRef := TfrmLogoRef.Create( Self );
      with frmLogoRef do
      try
        dsGraphics.dataset := dmopenq.ww_Query;
        if perscode <> -1 then
          with rbDynamic do begin
            OnClick := nil;
            checked := true;
            Caption := 'Personalize ('+codename+')';
            tag := perscode;
            hint := codename;
            OnClick := rbDynamicClick;
          end;
        if ShowModal = mrOK then begin
          tDQImage(tDQPanel(WLKHandle.children[0]).controls[0]).picture := Image1.Picture;
          tDQPanel(WLKHandle.children[0]).caption := 'LogoRef' + dmopenq.ww_Query.fieldbyname(qpc_ID).asstring;
          tDQPanel(WLKHandle.children[0]).width := image1.width;
          tDQPanel(WLKHandle.children[0]).height := image1.height;
          if rbDynamic.checked then
            tDQPanel(WLKHandle.children[0]).caption := tDQPanel(WLKHandle.children[0]).caption + '.' + inttostr(rbDynamic.tag) + '.' + rbdynamic.hint;
        end;
      finally
        Release;
      end;
    end else if isLogo(WLKHandle.children[0]) then begin
      frmOpenPictureDialog := TfrmOpenPictureDialog.Create( Self );
      with frmOpenPictureDialog do
      try
        Image.Picture := tDQImage(tDQPanel(WLKHandle.children[0]).controls[0]).picture;
        lblFileName.Caption := tDQPanel(WLKHandle.children[0]).caption;
        SaveDialog.filename := tDQPanel(WLKHandle.children[0]).caption;
        if ShowModal = mrOK then begin
          tDQImage(tDQPanel(WLKHandle.children[0]).controls[0]).picture := Image.Picture;
          if OpenDialog.Filename <> '' then begin
            tDQPanel(WLKHandle.children[0]).caption := ExtractFileName(OpenDialog.filename);
            if tDQPanel(WLKHandle.children[0]).controlcount=2 then
              tEdit(tDQPanel(WLKHandle.children[0]).controls[1]).text := ExtractFileName(OpenDialog.filename);
          end;
          if n600.checked then
            ResizeLogo(1479)
          else
            ResizeLogo(2958);
        end;
      finally
        Release;
      end;
    end;
end;


procedure TF_DynaQ.RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not (ssShift in shift) then WLKHandle.detach;
  WLKHandle.attach(tDQPanel(Sender));
end;

procedure TF_DynaQ.Logo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not (ssShift in shift) then WLKHandle.detach;
  WLKHandle.attach(tcontrol(Sender));
  WLKHandle.Resizable := false;
end;

procedure TF_DynaQ.Logo2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Logo1MouseDown(tDQImage(Sender).parent, Button, shift, x, y);
end;

function tF_DynaQ.findemptyslot:integer;
var i : integer;
begin
  result := -1;
  if elementlist.count > 0 then
    for i := 0 to elementlist.count-1 do
      if elementlist[i] = nil then
        result := i;
end;

function TF_DynaQ.newLogo(const ID,w,h:integer):integer;
begin
  ElementList.add(TDQPanel.create(F_DynaQ));
  result := elementlist.count-1;
  with TDQPanel(ElementList[result]) do begin
    parent := ScrollboxCovers;
    Caption := '(none)';
    BevelOuter := bvNone;
    Ctl3D := false;
    left := 100;
    top := 100;
    width := w;
    height := h;
    modified := false;
    KnownDimensions := true;
    if ID=0 then begin
      DMOpenQ.wwt_logo.tag := DMOpenQ.wwt_logo.tag + 1;
      tag := DMOpenQ.wwt_logo.tag;
      modified := true;
      dmOpenQ.SaveDialog.tag := 2;
    end else
      tag := ID;
    PopupMenu := PopupLogo;
    OnMouseDown := Logo1MouseDown;
    insertcontrol(tDQImage.create(F_DynaQ));
    with tDQImage(Controls[0]) do begin
      Align := alClient;
      PopupMenu := PopupLogo;
      Stretch := true;
      Visible := true;
      OnMouseDown := Logo2MouseDown;
    end;
  end;
end;

function TF_DynaQ.newPCL(const ID,w,h:integer):integer;
begin
  ElementList.add(TDQPanel.create(F_DynaQ));
  result := elementlist.count-1;
  with TDQPanel(ElementList[result]) do begin
    parent := ScrollboxCovers;
    Caption := '(none)';
    BevelOuter := bvNone;
    Ctl3D := false;
    color := clTeal;
    font.color := clAqua;
    left := 100;
    top := 100;
    width := abs(w);
    height := abs(h);
    showhint := true;
    PopupMenu := PopupTextBox;
    OnMouseDown := Logo1MouseDown;
    modified := false;
    knownDimensions := false;
    if ID=0 then begin
      DMOpenQ.wwt_PCL.tag := DMOpenQ.wwt_PCL.tag + 1;
      tag := DMOpenQ.wwt_PCL.tag;
      modified := true;
      dmOpenQ.SaveDialog.tag := 2;
    end else
      tag := ID;
  end;
end;

function TF_DynaQ.newTextBox(Const ID:integer):integer;
begin
  ElementList.add(TDQPanel.create(F_DynaQ));
  result := elementlist.count-1;
  with TDQPanel(ElementList[result]) do begin
    parent := ScrollBoxCovers;
    Caption := '';
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    BorderWidth := 0;
    Color := clBlack;
    Ctl3D := false;
    left := 100;
    top := 100;
    width := 400;
    height := 200;
    modified := false;
    knowndimensions := true;
    if ID=0 then begin
      DMOpenQ.wwt_TextBox.tag := DMOpenQ.wwt_TextBox.tag + 1;
      tag := DMOpenQ.wwt_TextBox.tag;
      modified := true;
      dmOpenQ.SaveDialog.tag := 2;
    end else
      tag := ID;
    OnMouseDown := RichEdit1MouseDown;
    PopupMenu := PopupTextBox;
    insertcontrol(TRichEdit.create(F_DynaQ));
    with tRichEdit(Controls[0]) do begin
      BorderStyle := bsNone;
      Color := clWhite;
      Ctl3D := false;
      ReadOnly := True;
      WordWrap := True;
      Align := alClient;
      OnMouseDown := RichEdit2MouseDown;
      PopupMenu := PopupTextBox;
      onProtectChange := RichEdit1ProtectChange;
    end;
  end;
end;

procedure TF_DynaQ.RichEdit2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RichEdit1MouseDown(tRichEdit(Sender).parent, Button, shift, x, y);
end;

procedure TF_DynaQ.RichEdit1ProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  AllowChange := true;
end;

procedure TF_DynaQ.LoadCover(const pg:integer);
var I : integer;

  procedure getTextBoxes;
    procedure loadTB;
    begin
      with tDQPanel(Elementlist[i]), DMOpenQ.wwt_TextBox do begin
        left := fieldbyname('X').value-ScrollboxCovers.horzScrollBar.Position;
        Top := fieldbyname('Y').value-ScrollboxCovers.VertScrollBar.Position;
        Width := fieldbyname('Width').value;
        Height := fieldbyname('Height').value;
        BorderWidth := fieldbyname('Border').value;
        if not fieldbyname('Label').isnull then
           TextBoxName := fieldbyname('Label').value;
        Language := fieldbyname('Language').value;
        tBlobField(fieldbyname('RichText')).SaveTofile(dmOpenQ.tempdir+'\RichEdit.rtf');
        with tRichEdit(controls[0]) do begin
          lines.Loadfromfile(dmOpenQ.tempdir+'\RichEdit.rtf');
          color := fieldbyname('Shading').value;
        end;
      end;
    end;
    procedure LoadLR;
    var sellogoid,s,codename : string;
    begin
      {with WLKHandle do begin
        detach;
        attach(tcontrol(elementlist[i]));
        resizable := false;
      end;}
      with tDQPanel(Elementlist[i]), DMOpenQ.wwt_TextBox do begin
        left := fieldbyname('X').value-ScrollboxCovers.horzScrollBar.Position;
        Top := fieldbyname('Y').value-ScrollboxCovers.VertScrollBar.Position;
        sellogoid := fieldbyname('Border').asstring;
        caption := 'LogoRef' + sellogoid;
        if tBlobField(fieldbyname('RichText')).value <> '' then begin
          s := tBlobField(fieldbyname('RichText')).value;
          codename := copy(s,1,pos('::',s)-1);
          mydelete(s,1,pos('{',s));
          caption := caption + '.' + copy(s,1,length(s)-2)+'.'+codename;
        end;
      end;
      dmopenq.localquery('select scaling, visible, bitmap, width, height from sel_logo where '+qpc_ID+'='+sellogoid,false);
      with tDQImage(tDQPanel(Elementlist[i]).Controls[0]), DMOpenQ.ww_Query do begin
        DPI := fieldbyname('Scaling').value;
        visible := fieldbyname('Visible').asBoolean;
        {try}
          picture.assign(tBlobField(fieldbyname('BitMap')));
        {except
          tBlobField(fieldbyname('BitMap')).savetofile(dmopenq.tempdir+'\logo.jpg');
          picture.loadfromfile(dmopenq.tempdir+'\logo.jpg');
        end;}
      end;
      with tDQPanel(Elementlist[i]), DMOpenQ.ww_Query do begin
        Width := fieldbyname('Width').value;
        Height := fieldbyname('Height').value;
        close;
      end;
    end;
  begin
    with DMOpenQ.wwt_TextBox do begin
      first;
      while not eof do begin
        if (fieldbyname('CoverID').value = pg)
            and (fieldbyname('Language').value = 1) then
          if fieldbyname('Shading').value = clGreen then begin
            i := newLogoRef(fieldbyname(qpc_ID).value,fieldbyname('width').value,fieldbyname('height').value);
            LoadLR;
          end else begin
            i := newTextBox(fieldbyname(qpc_ID).value);
            loadTB;
          end;
        next;
      end;
    end;
  end;

  procedure getLogos;
    procedure load;
    var GraphicsPage:boolean;
    begin
      with tDQPanel(Elementlist[i]), DMOpenQ.wwt_Logo do begin
        GraphicsPage := (fieldbyname('CoverID').value=0);
        caption := fieldbyname('Description').value;
        Left := fieldbyname('X').value-ScrollboxCovers.horzScrollBar.Position;
        Top := fieldbyname('Y').value-ScrollboxCovers.VertScrollBar.Position;
        with tDQImage(Controls[0]) do begin
          DPI := fieldbyname('Scaling').value;
          visible := fieldbyname('Visible').asBoolean;
          tBlobField(fieldbyname('BitMap')).SaveToFile(dmOpenQ.tempdir+'\Logo.bmp');
          {try}
            picture.LoadFromFile(dmOpenQ.tempdir+'\Logo.bmp');
          {except
            deletefile(dmOpenQ.tempdir+'\Logo.jpg');
            renamefile(dmOpenQ.tempdir+'\Logo.bmp',dmOpenQ.tempdir+'\Logo.jpg');
            picture.LoadFromFile(dmOpenQ.tempdir+'\Logo.jpg');
          end;}
          //picture.assign(tBlobField(fieldbyname('BitMap')));
          if GraphicsPage then align := alNone;
        end;
        if GraphicsPage then begin
          tDQImage(Controls[0]).width := width;
          tDQImage(controls[0]).height := height;
          Height := Height + 14;
          insertcontrol(tEdit.create(F_DynaQ));
          with tEdit(Controls[1]) do begin
            left := 0;
            top := tDQPanel(elementlist[i]).height-14;
            width := tDQPanel(elementlist[i]).width;
            text := fieldbyname('Description').value;
            enabled := false;
            borderstyle := bsNone;
            font.Size := 8;
          end;
        end;
      end;
    end;
  begin
    with DMOpenQ.wwt_Logo do begin
      first;
      while not eof do begin
        if fieldbyname('CoverID').value = pg then begin
          i := newLogo(fieldbyname(qpc_ID).value,fieldbyname('width').AsInteger,fieldbyname('height').AsInteger);
          load;
        end;
        next;
      end;
    end;
  end;

  procedure getPCL;
    procedure load;
    begin
      with tDQPanel(Elementlist[i]), DMOpenQ.wwt_PCL do begin
        caption := fieldbyname('Description').value;
        Left := fieldbyname('X').value-ScrollboxCovers.horzScrollBar.Position;
        Top := fieldbyname('Y').value-ScrollboxCovers.VertScrollBar.Position;
        KnownDimensions := fieldbyname('KnownDimensions').asBoolean;
        if not KnownDimensions then begin

          color := clMaroon;
        end;
        if caption = '*PageBreak*' then begin
          caption := '';
          color := clBlue;
          hint := 'Put the rest of the letter at the top of the survey.'+#10+
                  'Has no effect on integrated cover letters';
          PageBreak1.enabled := false;
        end else
          hint := {'English: '+caption+trim('    '+}dmOpenQ.PCLHints;
        PCL := fieldbyname('PCLStream').value;
        showhint := true;
      end;
    end;
  begin
    with DMOpenQ.wwt_PCL do begin
      first;
      while not eof do begin
        if (fieldbyname('CoverID').value = pg)
            and (fieldbyname('Language').value = 1) then begin
          i := newPCL(fieldbyname(qpc_ID).value,fieldbyname('width').asInteger,fieldbyname('height').asInteger);
          load;
        end;
        next;
      end;
    end;
  end;

begin
  ScrollboxCovers.visible := false;
  printmockup1.enabled := true;
  ClearElementList;
  PageBreak1.enabled := true;
  getTextBoxes;
  getLogos;
  getPCL;
  case pagetabs[pg].pagetype of
    ptLetter:
      begin
        pnlAddress.visible := true;
        pnlAddress.left := 70-ScrollboxCovers.horzscrollbar.position;
        pnlAddress.top := 179-ScrollboxCovers.vertscrollbar.position;
        pnlAddress.height := 89;
        CoverBorder1.left := 710-ScrollboxCovers.horzscrollbar.position;
        CoverBorder2.left := 710-ScrollboxCovers.horzscrollbar.position;
        Coverborder1.height := 1008;
        shapeRegPt.visible := true;
        ImageMatchCode.visible := true;
        pnlIndicia.visible := false;
      end;
    ptLetterCard:
      begin
        pnlAddress.visible := true;
        pnlAddress.left := 123-ScrollboxCovers.horzscrollbar.position;
        pnlAddress.top := 157-ScrollboxCovers.vertscrollbar.position;
        pnlAddress.height := 89;
        CoverBorder1.left := 444-ScrollboxCovers.horzscrollbar.position;
        CoverBorder2.left := 888-ScrollboxCovers.horzscrollbar.position;
        Coverborder1.height := 333;
        shapeRegPt.visible := false;
        ImageMatchCode.visible := false;
        pnlIndicia.visible := true;
        pnlIndicia.left := 340-ScrollboxCovers.horzscrollbar.position;
        PageBreak1.enabled := false;
      end;
    ptLegalCard:
      begin
        pnlAddress.visible := true;
        pnlAddress.left := 256-ScrollboxCovers.horzscrollbar.position;
        pnlAddress.top := 157-ScrollboxCovers.vertscrollbar.position;
        pnlAddress.height := 89;
        CoverBorder1.left := 577-ScrollboxCovers.horzscrollbar.position;
        CoverBorder2.left := 1154-ScrollboxCovers.horzscrollbar.position;
        Coverborder1.height := 333;
        shapeRegPt.visible := false;
        ImageMatchCode.visible := false;
        pnlIndicia.visible := true;
        pnlIndicia.left := 473-ScrollboxCovers.horzscrollbar.position;
        PageBreak1.enabled := false;
      end;
    ptArtifacts:
      begin
        pnlAddress.visible := false;
        pnlAddress.height := 0;
        CoverBorder1.left := 710-ScrollboxCovers.horzscrollbar.position;
        CoverBorder2.left := 710-ScrollboxCovers.horzscrollbar.position;
        Coverborder1.height := 1008;
        shapeRegPt.visible := false;
        ImageMatchCode.visible := false;
        pnlIndicia.visible := false;
        PageBreak1.enabled := false;
        printmockup1.enabled := false;
      end;
  end;
  btnTextBox.Enabled := (pagetabs[pg].pagetype <> ptArtifacts);
  btnPCLBox.Enabled := (pagetabs[pg].pagetype <> ptArtifacts);
{$IFDEF GraphicsTab}
  btnLogo.visible := (pagetabs[pg].pagetype = ptArtifacts);
  btnLogoRef.visible := not btnlogo.visible;
  if btnlogo.visible then
    graphic1.OnClick := btnLogoClick
  else
    graphic1.OnClick := btnLogoRefClick;
{$ENDIF}
  textbox1.enabled := (pagetabs[pg].pagetype <> ptArtifacts);
  pclcode1.enabled := (pagetabs[pg].pagetype <> ptArtifacts);
  Coverborder2.height := Coverborder1.height;
  Coverborder3.left := 0-ScrollboxCovers.horzscrollbar.position;
  Coverborder3.top := Coverborder2.height-ScrollboxCovers.vertscrollbar.position;
  Coverborder3.width := 2+CoverBorder2.left+ScrollboxCovers.horzscrollbar.position;
  ScrollboxCovers.visible := true;
end;

procedure TF_DynaQ.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
{$IFNDEF GraphicsTab}
  if newtab=0 then
    allowchange := false
  else
{$ENDIF}
    if FireTabChangeEvent then begin
      SaveCover(tabset1.tabindex);
      AllowChange := true;
      LoadCover(newTab);
    end;
end;

procedure TF_DynaQ.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    SaveCover(tabset1.tabindex);
  if dmopenq.savedialog.tag = 2 then begin
    SaveOptionInfo;
    dmOpenQ.CloseSurvey;
  end;
  if dmOpenQ.SaveDialog.tag = 1 then
    Action := caFree
  else
    Action := caNone;
end;

procedure TF_DynaQ.btnSpellCheckClick(Sender: TObject);
var I : integer;
begin
  if elementlist.count > 0 then
    for i := 0 to elementlist.count-1 do
      if isTextBox(Elementlist[i]) then
        with tDQPanel(Elementlist[i]) do begin
          ScrollboxCovers.VertScrollBar.Position := top;
          with modsupport.dlgSpell do begin
            closewin := false;
            show;
            if SpellCheck(tRichEdit(controls[0])) = mrOK then begin
              dmOpenQ.SaveDialog.tag := 2;
              tDQPanel(Elementlist[i]).modified := true;
            end;
            close;
          end;
        end;

end;

function tf_dynaq.newPage(vID:integer; vDesc:string; vIntegrated,vLetterhead:boolean; vPagetype:integer):boolean;
begin
  if tabset1.tabs.count < 10 then begin
    with PageTabs[tabset1.tabs.count] do begin
      integrated := vIntegrated;
      letterhead := vLetterhead;
      Pagetype := vPageType;
      Description := vDesc;
    end;
    tabset1.tabs.add(vDesc);
    with dmOpenQ.wwt_cover do begin
      append;
      fieldbyname('Survey_ID').value := dmOpenQ.glbSurveyID;
      fieldbyname('SelCover_ID').value := vID;
      fieldbyname('Type').value := 'Cover';
      fieldbyname('Description').value := vDesc;
      fieldbyname('Integrated').value := vIntegrated;
      fieldbyname('bitletterhead').value := vletterhead;
      fieldbyname('PageType').value := vPagetype;
      post;
    end;
    NewPage := true;
  end else begin
    newpage := false;
    MessageDlg('Can only have 10 tabs!',mterror,[mbok],0);
  end;
end;

procedure TF_DynaQ.CoverLetter1Click(Sender: TObject);
var s : string;
    i : integer;
  procedure AssignNewID(const ii:integer);
  begin
    if isTextBox(elementlist[ii]) then begin
      DMOpenQ.wwt_TextBox.tag := DMOpenQ.wwt_TextBox.tag + 1;
      tDQPanel(elementlist[ii]).tag := DMOpenQ.wwt_TextBox.tag;
      tDQPanel(elementlist[ii]).modified := true;
    end else if isLogoRef(elementlist[ii]) then begin
      DMOpenQ.wwt_TextBox.tag := DMOpenQ.wwt_TextBox.tag + 1;
      tDQPanel(elementlist[ii]).tag := DMOpenQ.wwt_TextBox.tag;
      tDQPanel(elementlist[ii]).modified := true;
    end else if isLogo(elementlist[ii]) then begin
      DMOpenQ.wwt_logo.tag := DMOpenQ.wwt_logo.tag + 1;
      tDQPanel(elementlist[ii]).tag := DMOpenQ.wwt_logo.tag;
      tDQPanel(elementlist[ii]).modified := true;
    end else if isPCL(elementlist[ii]) then begin
      DMOpenQ.wwt_PCL.tag := DMOpenQ.wwt_PCL.tag + 1;
      tDQPanel(elementlist[ii]).tag := DMOpenQ.wwt_PCL.tag;
      tDQPanel(elementlist[ii]).modified := true;
    end;
  end;
begin
  s := InputBox('Enter Name','What''s the new letter''s name?','Cover'+inttostr(tabset1.tabs.count+1));
  if s <> '' then
    with Tabset1 do begin
      SaveCover(tabindex);
      if NewPage(tabs.count,s,pagetabs[tabindex].integrated,pagetabs[tabindex].letterhead,1) then begin
        if elementlist.count > 0 then
          if MessageDlg('Do you want to copy everything from '+tabs[tabindex]+'?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
            for i := 0 to elementlist.count-1 do
              AssignNewID(i);
            SaveCover(tabs.count-1);
          end;
        FireTabChangeEvent := false;
        TabIndex := tabs.count-1;
        FireTabChangeEvent := true;
        LoadCover(tabs.count-1);
      end;
    end;
end;

procedure TF_DynaQ.Delete3Click(Sender: TObject);
  procedure DeleteAllAfter(const tbl:string; const fld:string; const cvrID:integer);
  var s : string;
  begin
    s := 'delete from ' + tbl + ' where ' + fld + '=' + inttostr(cvrID);
    dmOpenQ.cn.execute(s);
    s := 'update ' + tbl + ' set ' + fld + '=' + fld + '-1 where ' + fld + '>' + inttostr(cvrID);
    dmOpenQ.cn.execute(s);
  end;
var i : integer;
begin
  if tabset1.tabindex=0 then
    messagedlg('You can''t delete the "Graphics" tab.',mterror,[mbok],0)
  else if tabset1.tabs.count=2 then
    messagedlg('You must keep at least one cover letter',mterror,[mbok],0)
  else begin
    DeleteAllAfter('Sel_Cover','SelCover_ID',tabset1.tabindex);
    DeleteAllAfter('Sel_TextBox','CoverID',tabset1.tabindex);
    DeleteAllAfter('Sel_PCL','CoverID',tabset1.tabindex);
    DeleteAllAfter('Sel_Logo','CoverID',tabset1.tabindex);
    if tabset1.tabindex < 9 then
      for i := tabset1.tabindex to 8 do
        Pagetabs[i] := pagetabs[i+1];
    FireTabChangeEvent := false;
    tabset1.tabs.delete(tabset1.tabindex);
    Loadcover(tabset1.tabindex);
    FireTabChangeEvent := true;
    dmOpenQ.SaveDialog.tag := 2;
  end;
end;

procedure TF_DynaQ.Properties1Click(Sender: TObject);
var PT,i,outside,NeedToDelete:integer;
begin
  frmPageAttributes := TfrmPageAttributes.Create( Self );
  with frmPageAttributes do
  try
    with Pagetabs[tabset1.tabindex] do begin
      cbArtifactsPage.checked := (pagetype = ptArtifacts);
      if cbArtifactsPage.checked then
        edPagename.text := copy(tabset1.tabs[tabset1.tabindex],2,length(tabset1.tabs[tabset1.tabindex])-2)
      else
        edPagename.text := tabset1.tabs[tabset1.tabindex];

      if pagetype = ptLetter then
        rgPaperType.itemindex := 0
      else begin
        rgPaperType.itemindex := 1;
        if pagetype = ptLetterCard then rgPostCardSize.itemindex := 0
        else                            rgPostCardSize.itemindex := 1;
      end;
      PT := pageType;
      if Integrated then
        rgIntegrated.itemindex := 0
      else if letterhead then
        rgIntegrated.itemindex := 2
      else
        rgIntegrated.itemindex := 1;
      if ShowModal = mrOK then begin
        dmOpenQ.SaveDialog.tag := 2;

        description := edPageName.text;
        tabset1.tabs[tabset1.tabindex] := edPageName.text;

        if cbArtifactsPage.checked then
        begin
          tabset1.tabs[tabset1.tabindex] := '[' + edPageName.text + ']';
          pagetype := ptArtifacts
        end
        else
          if rgPaperType.Itemindex = 0 then
            pagetype := ptLetter
          else
            if rgPostcardsize.itemindex = 0 then
              pagetype := ptLetterCard
            else
              pagetype := ptLegalCard;
        Integrated := (rgIntegrated.itemindex = 0);
        Letterhead := (rgIntegrated.itemindex = 2);
        with dmOpenQ.wwt_cover do
          if findkey([DMOpenQ.glbSurveyID,tabset1.tabindex]) then begin
            edit;
            fieldbyname('Description').text := description;
            fieldbyname('PageType').value := Pagetype;
            fieldbyname('Integrated').value := Integrated;
            fieldbyname('bitLetterhead').value := Letterhead;
            post;
          end;
        SaveCover(tabset1.tabindex);
        LoadCover(tabset1.tabindex);
        outside := 0;
        NeedToDelete := -1;
        if (PT <> PageType) and (ElementList.count > 0) then
          for i := 0 to ElementList.count-1 do begin
            if (pagetype<>ptLetter) and (tDQPanel(ElementList[i]).color=clBlue) then
              NeedToDelete := i
            else
              outside := outside + GetBackInside(ElementList[i]);
          end;
        if NeedToDelete <> -1 then begin
           WLKHandle.detach;
           WLKHandle.attach(ElementList[NeedToDelete]);
           DeleteBoxClick(Sender);
        end;
        if (outside>0) or (NeedToDelete <> -1) then
          SaveCover(tabset1.tabindex);
        if outside > 0 then
          messagedlg('There were '+inttostr(outside)+' objects outside the new borders.  They have been moved in.',mtinformation,[mbOK],0);
      end;
    end;
  finally
    Release;
  end;
end;

procedure TF_DynaQ.Comment1Click(Sender: TObject);
begin
  DMOpenQ.AddComment;
end;

procedure TF_DynaQ.SelQstnsPopupPopup(Sender: TObject);
begin
  with DMOpenQ do
    if wwt_QstnsSubType.value = stItem then
      EditCommentBox1.caption := 'Question Properties'
    else if wwt_QstnsSubType.value = stSubsection then
      EditCommentBox1.caption := 'Subsection Properties'
    else if wwt_QstnsSubType.value = stSection then
      EditCommentBox1.Caption := 'Section Properties'
    else if wwt_QstnsSubType.value = stComment then
      EditCommentBox1.caption := 'Edit Comment Box';
  TranslateCommentBox1.visible := (DMOpenq.wwt_QstnsSubType.value = stComment);
  Paste1.Enabled := dmOpenq.ClipboardQuestions;
end;

procedure TF_DynaQ.EditCommentBox1Click(Sender: TObject);
begin
  with DMOpenQ do
    if EditCommentBox1.caption = 'Edit Comment Box' then begin
      EditComment(true,'Edit Comment Box');
    end else if EditCommentBox1.caption = 'Question Properties' then begin
      if QuestionProperties then layoutSubSection;
    end else if EditCommentBox1.caption = 'Subsection Properties' then begin
      if SubSectionProperties then layoutsubsection;
    end else if EditCommentBox1.Caption = 'Section Properties' then begin
      if SectionProperties then {LayoutSection};
    end;
  wwDBGrid1.DataSource.DataSet.Refresh;
  wwDBGrid1.Refresh;
end;

function TF_DynaQ.PrnToScr(prn:integer):integer;
begin
  case cbLayoutPercentage.ItemIndex of
    0: result := round(prn * 355 / 4800); {50%}
    1: result := round(prn * 533 / 4800); {75%}
  else
    result := round(prn * 710 / 4800); {100%}
  end;
end;

function tf_dynaQ.ResizeFont(const fullsize:integer):integer;
begin
  case cbLayoutPercentage.ItemIndex of
    0: result := round(fullsize * 0.50);
    1: result := round(fullsize * 0.75);
  else
    result := fullsize;
  end;
end;

procedure TF_DynaQ.HighlightCurrentQ;
var i : integer;
    curQ,CurST : integer;
begin
  if (ppQstnLayout.width > 0) and (Elementlist.count>0) then begin
    curQ := dmopenq.wwT_QstnsQstnCore.value;
    curST := dmopenQ.wwt_QstnsSubtype.value;
    for i := 0 to pred(elementlist.count) do begin
      if tControl(elementlist[i]) is tDQRichEdit then begin
        with tDQRichEdit(elementlist[i]) do begin
          if (qstncore = curQ) and (strtoint(hint)=curST) then
            color := clYellow
          else if WantReturns then
            color := clWhite
          else
            color := $00E9E9E9;
        end;
      end else if tControl(elementlist[i]) is tDQPanel then begin
        with tDQPanel(elementlist[i]) do begin
          if (tag = curQ) and (curST=stItem) then
            color := clYellow
          else
            color := clWhite;
        end;
      end;
    end;
  end;
end;

procedure TF_DynaQ.Layout;
begin
  frmLayoutCalc.mockup := 1;
  with DMOpenQ do
    if (wwt_QstnsSubsection.value=0) and (wwt_QstnsItem.value=0) then
      LayoutSection
    else
      LayoutSubSection;
end;

procedure TF_DynaQ.LayoutSection;
var
  TBPos,i,VertOffset,ThisSection,QstnNmbr : integer;
  ThisSubsection,ThisItem : integer;
  orgFiltered : boolean;
begin
  DQTrackBar.Enabled := false;
  with DMOpenQ, wwt_Qstns do begin
    disablecontrols;
    ThisSection := wwt_QstnsSection.value;
    ThisSubsection := wwt_QstnsSubsection.value;
    ThisItem := wwt_QstnsItem.value;
    indexfieldname := qpc_Section+';Subsection;Item';
    orgFiltered := filtered;
    filtered := false;
    i := 1;
    QstnNmbr := 1;
    ScrollBoxQstns.HorzScrollBar.Position := 0;
    ScrollBoxQstns.VertScrollBar.Position := 0;
    ScrollBoxQstns.visible := false;
    ClearElementList;
    VertOffset := pnlTrackBar.height;
    frmLayoutCalc.CalcScaleWidth;
    while findkey([ThisSection,i,0]) do begin
      //TBPos := 54{8};
      label1.caption := frmLayoutCalc.CalcSubSection(TBPos,QstnNmbr);
      VertOffset := 10+AddSectionToElementList(VertOffset);
      inc(i);
    end;
    filtered := orgFiltered;
    findkey([ThisSection,ThisSubsection,ThisItem]);
    wwt_QstnsEnablecontrols;
  end;
  ScrollBoxQstns.visible := true;
  pnlThumbPos.caption := '';
end;

procedure TF_DynaQ.LayoutSubsection;
var TBPos,QstnNmbr : integer;
    ThisSection,ThisSubsection,ThisItem : integer;
begin
  if printer.printing then begin
    DQTrackBar.Enabled := true;
    TBPos := DQTrackBar.Position;
    QstnNmbr := 1;
    dmOpenQ.wwt_Qstns.disablecontrols;
    ThisSection := dmOpenQ.wwt_QstnsSection.value;
    ThisSubsection := dmOpenQ.wwt_QstnsSubsection.value;
    ThisItem := dmOpenQ.wwt_QstnsItem.value;
    //if TBPos <= 100 then
      frmLayoutCalc.CalcScaleWidth;
    with dmOpenQ.wwt_Qstns do begin
      filtered := false;
      if indexfieldnames <> qpc_Section+';Subsection;Item' then
        indexfieldnames := qpc_Section+';Subsection;Item';
      findkey([thisSection,ThisSubsection,ThisItem]);
    end;
    label1.caption := frmLayoutCalc.CalcSubSection(TBPos,QstnNmbr);
    DQTrackBar.Position := TBPos;
    ScrollBoxQstns.HorzScrollBar.Position := 0;
    ScrollBoxQstns.VertScrollBar.Position := 0;
    ScrollBoxQstns.visible := false;
    ClearElementList;
    AddSectionToElementList(pnlTrackBar.height);
    ScrollBoxQstns.visible := true;
    HighLightCurrentQ;
    pnlThumbPos.Caption := inttostr(DQTrackBar.position);
    with dmOpenQ, wwt_Qstns do begin
      filtered := true;
      wwt_QstnsEnablecontrols;
      findkey([thisSection,ThisSubsection,ThisItem]);
    end;
  end;
end;

function TF_DynaQ.AddSectionToElementList(const VertOffset:integer):integer;
var
  i,L,S,P,j,T : integer;
  R: TextFile;
begin
  with frmLayoutCalc do begin
    result := 0;
    for i := 1 to nDQRichEdit do begin
      if (rDQRichEdit[i].Subtype <> stComment) or
        ((rDQRichEdit[i].Subtype = stComment) and (rDQRichEdit[i].ScaleID=0))
      then begin
        {The following "if" statement is a bit of a bear so, in plain English:
        We want to put the question number on the survey if:
          there is no question character
          and there is a question number
          OR
          we're on the first question in a subsection (i.e. 'a')
          and there is a question number
          and either (there is no previous richedit or the previous richedit is not a header)
        }
        if ((rDQRichEdit[i].QChar=' ')
           and (rDQRichEdit[i].QNmbr>0))
           {or
           ((rDQRichEdit[i].QChar='a')
           and (rDQRichEdit[i].QNmbr>0)
           and ((i=1) or ((i>1) and (rDQRichEdit[i-1].Subtype<>stSubsection))))}
        then begin
          ElementList.add(TLabel.create(F_DynaQ));
          with TLabel(ElementList[elementlist.count-1]) do begin
            parent := ScrollBoxQstns;
            left := PrnToScr(54);
            top := VertOffset+PrnToScr(rDQRichEdit[i].top);
            font.name := rDQRichEdit[i].fontname;
            font.size := ResizeFont(rDQRichEdit[i].fontsize);
            if rDQRichEdit[i].Subtype=stSubsection then
              font.style := font.style + [fsbold];
            Caption := inttostr(rDQRichEdit[i].QNmbr)+'.';
            tag := rDQRichEdit[i].QstnCore;
          end;
        end;
        if (rDQRichEdit[i].QChar<>' ') then begin
          ElementList.add(TLabel.create(F_DynaQ));
          with TLabel(ElementList[elementlist.count-1]) do begin
            parent := ScrollBoxQstns;
            left := PrnToScr(204);
            top := VertOffset+PrnToScr(rDQRichEdit[i].top);
            font.name := rDQRichEdit[i].fontname;
            font.size := ResizeFont(rDQRichEdit[i].fontsize);
            if rDQRichEdit[i].Subtype=stSubsection then
              font.style := font.style + [fsbold];
            Caption := rDQRichEdit[i].QChar+'.';
            tag := rDQRichEdit[i].QstnCore;
          end;
        end;
        ElementList.add(TDQRichEdit.create(F_DynaQ));
        with TDQRichEdit(ElementList[elementlist.count-1]) do begin
          parent := ScrollBoxQstns;
          OnProtectChange := RichEdit1ProtectChange;
          left := PrnToScr(rDQRichedit[i].left);
          top := VertOffset+PrnToScr(rDQRichEdit[i].top);
          width := PrnToScr(rDQRichEdit[i].width);
          height := PrnToScr(rDQRichEdit[i].height);
          tag := rDQRichEdit[i].tag;
          QstnCore := rDQRichEdit[i].QstnCore;
          ScaleID := rDQRichEdit[i].ScaleID;
          ScalePos := rDQRichEdit[i].ScalePos;
          BorderStyle := rDQRichEdit[i].BorderStyle;
          Color := rDQRichEdit[i].Color;
          Hint := inttostr(rDQRichEdit[i].SubType);
          WantReturns := (color=clwhite);
          assignfile(r,dmOpenQ.tempdir+'\richtext.rtf');
          rewrite(r);
          write(r,rDQRichEdit[i].RichText);
          closefile(r);
          lines.loadfromfile(dmOpenQ.tempdir+'\richtext.rtf');
          SelectAll;
          SelAttributes.name := rDQRichEdit[i].fontname;
          SelAttributes.size := ResizeFont(rDQRichEdit[i].fontsize);
          if rDQRichEdit[i].Subtype=stSubsection then
            if [caUnderline,caItalic] <= selattributes.ConsistentAttributes then
              selAttributes.style := selAttributes.style + [fsbold]
            else
              for j := 0 to length(text) do begin
                SelStart := j;
                SelLength := 1;
                selAttributes.style := selAttributes.style + [fsbold];
              end;
          SelLength := 0;
          enabled := false;
          if top+height>result then result := top+height;
        end;
      end else {rDQRichedit[i].subtype=stComment} begin
        ElementList.add(tDQPanel.create(F_DynaQ));
        with TDQPanel(ElementList[elementlist.count-1]) do begin
          parent := ScrollBoxQstns;
          left := prntoScr(20);
          Top := vertoffset+prntoscr(rDQRichedit[i].top);
          width := prntoscr((frmLayoutCalc.PageWidth div frmLayoutCalc.ColumnCnt)-40);
          height := PrnToScr(rDQRichEdit[i].height);
          BorderStyle := bsSingle;
          Color := clWhite;
          BevelOuter := bvNone;
          Ctl3D := false;
          if rDQRichEdit[i].ScaleID > 0 then
            for L := 1 to rDQRichEdit[i].ScaleID do begin
              t := prntoscr(rDQRichEdit[i].height-30-round(LineSpacing*1.5*(L-1)));
              insertControl(tShape.create(f_DynaQ));
              with tShape(controls[controlcount-1]) do begin
                top := t;
                left := PrnToScr(rDQRichEdit[i].left-20);
                width := PrnToScr(4542);
                height := 1;
                Shape := stRectangle;
              end;
            end;
          insertControl(TLabel.create(F_DynaQ));
          with TLabel(controls[controlcount-1]) do begin
            top := PrnToScr(34);
            font.name := rDQRichEdit[i].fontname;
            font.size := ResizeFont(rDQRichEdit[i].fontsize);
            if (rDQRichEdit[i].QChar=' ') then begin
              left := PrnToScr(34);
              Caption := inttostr(rDQRichEdit[i].QNmbr)+'.';
            end else begin
              left := PrnToScr(184);
              Caption := rDQRichEdit[i].QChar+'.';
            end;
          end;
          insertControl(tDQRichEdit.create(f_DynaQ));
          with tDQRichEdit(controls[controlcount-1]) do begin
            top := prntoscr(34);
            left := PrnToScr(rDQRichEdit[i].left-20);
            width := PrnToScr(4542);
            height := PrnToScr(rDQRichEdit[i].height-30-round(1.5*LineSpacing*rDQRichEdit[i].ScaleID));
            BorderStyle := rDQRichEdit[i].BorderStyle;
            Color := clWhite;
            assignfile(r,dmOpenQ.tempdir+'\richtext.rtf');
            rewrite(r);
            write(r,rDQRichEdit[i].RichText);
            closefile(r);
            lines.loadfromfile(dmOpenQ.tempdir+'\richtext.rtf');
            SelectAll;
            SelAttributes.name := rDQRichEdit[i].fontname;
            SelAttributes.size := ResizeFont(rDQRichEdit[i].fontsize);
            SelLength := 0;
            enabled := false;
          end;
          if top+height>result then result := top+height;
        end;
      end;
    end;
    L := 1;
    S := 1;
    for i := 1 to nDQPanel do begin
      ElementList.add(TDQPanel.create(F_DynaQ));
      with TDQPanel(ElementList[elementlist.count-1]) do begin
        parent := ScrollBoxQstns;
        left := PrnToScr(rDQPanel[i].left);
        top := VertOffset+PrnToScr(rDQPanel[i].top);
        width := PrnToScr(rDQPanel[i].width);
        height := PrnToScr(rDQPanel[i].height);
        font.name := rDQPanel[i].fontname;
        font.size := ResizeFont(rDQPanel[i].fontsize);
        BorderStyle := bsNone;
        Color := clWhite;
        BevelOuter := bvNone;
        Ctl3D := false;
        tag := rDQRichEdit[rDQPanel[i].Question].qstncore;
        while rDQLabel[L].panel = i do begin
          insertControl(tlabel.create(f_DynaQ));
          with tLabel(controls[controlcount-1]) do begin
            caption := rDQLabel[L].caption;
            top := PrnToScr(rDQLabel[L].top);
            left := PrnToScr(rDQLabel[L].left);
          end;
          inc(L);
        end;
        while rDQShape[S].panel = i do begin
          if rDQShape[s].shape=stEllipse then begin
            insertControl(tShape.create(f_DynaQ));
            with tShape(controls[controlcount-1]) do begin
              top := PrnToScr(rDQShape[S].top);
              left := PrnToScr(rDQShape[S].left);
              width := PrnToScr(bubbleWidth);
              Height := PrnToScr(BubbleHeight);
              if dmopenq.ResponseShape=2 then
                Shape := stSquare
              else
                Shape := stEllipse;
            end;
          end else begin
            for j := 1 to rdqshape[s].width div icrWidth do begin
              insertControl(tShape.create(f_DynaQ));
              with tShape(controls[controlcount-1]) do begin
                top := PrnToScr(rDQShape[S].top);
                left := PrnToScr(rDQShape[S].left+((J-1)*ICRWidth));
                width := PrnToScr(ICRWidth);
                Height := PrnToScr(ICRHeight);
                Shape := stRectangle;
              end;
            end;
          end;
          inc(S);
        end;
        if top+height>result then result := top+height;
      end;
    end;
  end;
end;

procedure TF_DynaQ.TrackBarChange(Sender: TObject);
begin
  if DQTrackbar.position < 500 then DQTrackbar.position := 500;
  DQTrackbar.position := (DQTrackbar.position div 50) * 50;
  pnlThumbPos.caption := inttostr(DQtrackbar.position);
end;

procedure TF_DynaQ.DQTrackBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlThumbPos.caption := inttostr(DQtrackbar.position);
  Layout{SubSection};
end;

procedure TF_DynaQ.AdjustTrackBar;
begin
  case cbLayoutPercentage.ItemIndex of
    0: begin DQTrackBar.width := 358; pnlTrackBar.width := 355; end; {50%}
    1: begin DQTrackBar.width := 536; pnlTrackBar.width := 533; end; {75%}
  else
    begin DQTrackBar.width := 715; pnlTrackBar.width := 710; end; {100%}
  end;
end;

procedure TF_DynaQ.cbLayoutPercentageChange(Sender: TObject);
begin
  AdjustTrackBar;
  Layout;
  if (screen.width - pnlTrackbar.width - 14) > 75 then
    ppSelQstns.width := screen.width - pnlTrackbar.width - 14
  else
    ppSelQstns.width := 75;
end;

procedure TF_DynaQ.btnSelQDnClick(Sender: TObject);
begin
  dmopenQ.wwt_Qstns.next;
  wwDBGrid1RecordChange;
  dmOpenQ.wwt_QstnsEnableControlsDammit;
end;

procedure TF_DynaQ.btnSelQUpClick(Sender: TObject);
begin
  dmopenQ.wwt_Qstns.prior;
  wwDBGrid1RecordChange;
  dmOpenQ.wwt_QstnsEnableControlsDammit;
end;

procedure TF_DynaQ.btnSelQPgUpClick(Sender: TObject);
var i : byte;
begin
  with dmopenQ, wwt_Qstns do begin
    disablecontrols;
    for i := 1 to ((wwdbgrid1.height-39) div 15) do
      if not bof then prior;
    wwt_QstnsEnableControlsDammit;
  end;
  wwDBGrid1RecordChange;
end;

procedure TF_DynaQ.btnSelQPgDnClick(Sender: TObject);
var i : byte;
begin
  with DMOpenQ, wwt_Qstns do begin
    disableControls;
    for i := 1 to ((wwdbgrid1.height-39) div 15) do
      if not eof then next;
    wwt_QstnsEnableControlsDammit;
  end;
  wwDBGrid1RecordChange;
end;

procedure TF_DynaQ.srcListCalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
  with DQDataModule do begin
    if wwt_QuestionsRestrictQuestion.asBoolean then begin
      afont.color := clTeal;
      aBrush.color := $00EBEBF8;
    end;
    if CoreList.indexOf(wwt_QuestionsCore.text) >= 0 then
      aFont.style := [fsStrikeout];
  end;
end;

procedure TF_DynaQ.editFilterLevelEnter(Sender: TObject);
begin
  pnlLevelCheckBoxes.top := 4;
  activecontrol := cbLevelKey;
end;

procedure TF_DynaQ.pnlLevelCheckBoxesExit(Sender: TObject);
begin
  with DQDataModule do begin
    filterLevelK := not cbLevelKey.checked;
    filterLevelC := not cbLevelCore.checked;
    filterLevelDD := not cbLevelDrillDown.checked;
    filterLevelB := not cbLevelBehavioral.checked;
    filterLevelU := not cbLevelUnassigned.checked;
    editFilterLevel.text := FilterLevelText;
    UpdateQstnFilter;
  end;
  pnlLevelCheckBoxes.top := 30;
//  activeControl := srcList;
end;

procedure TF_DynaQ.pnlLevelCheckBoxesDblClick(Sender: TObject);
begin
  cbLevelKey.checked := not cbLevelKey.checked;
  cbLevelcore.checked := cbLevelKey.checked;
  cbLevelDrillDown.checked := cbLevelKey.checked;
  cbLevelBehavioral.checked := cbLevelKey.checked;
  cbLevelUnassigned.checked := cbLevelKey.checked;
end;

procedure TF_DynaQ.btnTranslateClick(Sender: TObject);
begin
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    SaveCover(tabset1.tabindex);
  frmTranslation := TfrmTranslation.Create( Self );
  with frmTranslation do
  try
    if tag<>1 then ShowModal;
  finally
    Release;
  end;
end;

procedure TF_DynaQ.EditTextBoxTranslationsClick(Sender: TObject);
var i,SelectedID:integer;
    isTB:boolean;
    LangID:array[1..20] of integer;
begin
  if WLKHandle.childcount = 1 then begin
    isTB := isTextBox(WLKHandle.children[0]);
    SelectedID:= tDQPanel(WLKHandle.children[0]).tag;
    SaveCover(tabset1.tabindex);
    dmOpenQ.FindTransUponCreate := false;
    frmTranslation := TfrmTranslation.Create( Self );
    dmOpenQ.FindTransUponCreate := true;
    if frmTranslation.cmbLanguage.Items.Count = 0 then
    begin
      application.MessageBox('You need to select at least 1 foreign language'#13#10'from the Languages box in Tools/Options/Languages','Translation Warning',0);
      frmTranslation.Release;
      exit;
    end;
    if isTB then begin
      if (dmOpenQ.wwT_TextBox.FindKey([dmOpenQ.glbSurveyID,SelectedID])) then begin
        with dmOpenQ, wwt_TransTB do
          if (not findkey([glbSurveyID,SelectedID,currentLanguage])) then begin
            append;
            fieldbyname('Survey_ID').value := glbSurveyID;
            fieldbyname(qpc_ID).value := SelectedID;
            fieldbyname('Language').value := currentLanguage;
            fieldbyname('Type').value := wwt_TextBoxType.value;
            fieldbyname('CoverID').value := tabset1.tabindex;
            fieldbyname('X').value := wwt_TextBoxX.value;
            fieldbyname('Y').value := wwt_TextBoxY.value;
            fieldbyname('Width').value := wwt_TextBoxWidth.value;
            fieldbyname('Height').value := wwt_TextBoxHeight.value;
            fieldbyname('Border').value := wwt_TextBoxBorder.value;
            fieldbyname('Label').value := wwt_TextBoxLabel.value;
            fieldbyname('Shading').value := wwt_TextBoxShading.value;
            fieldbyname('bitLangReview').value := true;
            post;
          end;
        with frmTranslation do
        try
          DBTextLangReview.DataSource := dmopenq.wwds_transTB;
          clDBRichCodeBtnEng.DataSource := dmopenq.wwds_TextBox;
          clDBRichCodeBtnFrgn.DataSource := dmopenq.wwds_transTB;
          SetFrgnFont;
          ShowModal;
        finally
          Release;
        end;
      end else
        messagedlg('Can''t find textbox '+inttostr(SelectedID),mterror,[mbok],0);
    end else begin {isPCL}
      with dmOpenQ.t_Language do begin
        first;
        next;
        OpenPCLDialog.filter := 'English PCL Image (*.pcl, *.bin)|*.pcl;*.bin';
        LangID[1] := 1;
        i := 1;
        while not eof do begin
          OpenPCLDialog.filter := openPCLDialog.filter +
            '|'+fieldbyname('Language').value+' PCL Image (*.pcl, *.bin)|*.pcl;*.bin';
          inc(i);
          langid[i] := fieldbyname('LangID').value;
          if langid[i] = dmOpenQ.currentLanguage then
            OpenPCLDialog.filterindex := i;
          next;
        end;
      end;
      with OpenPCLDialog do begin
        if execute then begin
          dmOpenQ.newLangPCL(tabset1.tabindex,SelectedID,langid[filterindex],FileName);
          for i := 0 to elementlist.count-1 do
            if (isPCL(ElementList[i])) and (tDQPanel(ElementList[i]).tag=SelectedID) then
              tDQPanel(elementlist[i]).hint := dmOpenQ.pclHints;
        end;
        filter := 'PCL Image (*.pcl, *.bin)|*.pcl;*.bin';
        filterindex := 1;
      end;
    end;
  end;
end;

procedure TF_DynaQ.ValidateClick(Sender: TObject);
var SaveToo:boolean;
    s,ss,i : integer;
begin
  s := dmopenq.wwT_QstnsSection.value;
  ss := dmopenq.wwT_QstnsSubsection.value;
  i := dmopenq.wwT_QstnsItem.value;
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    SaveCover(tabset1.tabindex);
  SaveOptionInfo;
  SaveToo := (tMenuItem(Sender).name='ValidateSaveLayout');
  if DMOpenQ.ValidateSurvey(SaveToo) then begin
    if SaveToo then begin
      with TfrmValidMsg.Create(Self) do
      try
        PersonalizationHandle:=hndl;
        ShowModal;
      finally
        Release;
      end;
      close;
    end else
      messagedlg('Survey layout is valid.',mtinformation,[mbok],0);
  end else begin
    frmInvalid := TfrmInvalid.Create( Self );
    with frmInvalid do
    try
      Memo1.lines.clear;
      Memo1.lines.addstrings(dmopenq.errorlist);
      ShowModal;
    finally
      Release;
    end;
  end;
  dmopenq.wwt_QstnsEnableControlsDammit;
  wwdbgrid1.UnselectAll;
  wwDBGrid1.RefreshDisplay;
  dmopenq.wwT_Qstns.FindKey([s,ss,i]);
end;

procedure TF_DynaQ.fromanothersurvey1Click(Sender: TObject);
var SrvID:integer;
begin
  srvID := strtointdef(inputbox('Enter Survey ID','What is the ID of the survey you want to load?','0'),0);
  if srvID>0 then begin
    dmOpenQ.LoadFromSQL(SrvID,false);
    frmLayoutCalc.setfonts;
    setTabs;
    updatecorelist;
    if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
      LoadCover(tabset1.tabindex);
  end;
end;

procedure TF_DynaQ.FOUOArea1Click(Sender: TObject);
begin
  DMOpenQ.EditFOUO;
end;

procedure TF_DynaQ.Clear1Click(Sender: TObject);
begin
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then begin
    SaveCover(tabset1.tabindex);
    clearElementList;
    ScrollboxCovers.VertScrollBar.Position := 0;
    ScrollboxCovers.HorzScrollBar.Position := 0;
  end else
    if ppQstnLayout.Width > 0 then
      btnLayoutClick(Sender);
  dmOpenQ.NewSurvey;
  frmLayoutCalc.setfonts;
  setTabs;
  updatecorelist;
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    LoadCover(tabset1.tabindex);
end;

procedure TF_DynaQ.fromatemplate1Click(Sender: TObject);
begin
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then begin
    SaveCover(tabset1.tabindex);
    clearElementList;
    ScrollboxCovers.VertScrollBar.Position := 0;
    ScrollboxCovers.HorzScrollBar.Position := 0;
  end else
    if ppQstnLayout.Width > 0 then
      btnLayoutClick(Sender);
  dmOpenQ.OpenSurvey('');
  frmLayoutCalc.setfonts;
  setTabs;
  updatecorelist;
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    LoadCover(tabset1.tabindex);
  DeleteAllForeignRecs('-1');
end;

procedure TF_DynaQ.btnLayoutClick(Sender: TObject);
begin
  ppQstnLayout.align := alNone;
  ppSelQstns.align := alNone;
  ppAvailQstns.align := alNone;
  if ppQstnLayout.width = 0 then begin
    if not printer.printing then frmLayoutCalc.StartCalc;
    pnlThumbPos.hint := format('%7.5f, %7.5f',[frmLayoutCalc.PrinterAdjustmentArial,frmLayoutCalc.PrinterAdjustmentArialnarrow]);
    pnlThumbPos.showHint := true;
    ppQstnLayout.width := ppAvailQstns.width;
    ppAvailQstns.width := 0;
    ppSelQstns.align := alLeft;
    ppQstnLayout.align := alClient;
    buttonpanel.visible := false;
    cbLayoutPercentage.visible := true;
    Layout{Subsection};
  end else begin
    if printer.printing then frmLayoutCalc.EndCalc;
    ppAvailQstns.width := ppQstnLayout.width;
    ppQstnLayout.width := 0;
    ppAvailQstns.align := alLeft;
    ppSelQstns.align := alClient;
    buttonpanel.visible := true;
    cbLayoutPercentage.visible := false;
  end;
  dmOpenQ.wwt_QstnsEnableControlsDammit;
end;

procedure TF_DynaQ.btnPrintLayoutClick(Sender: TObject);
begin
  if PageControl1.ActivePage.pageindex = CoverSheets.pageindex then
    SaveCover(tabset1.tabindex);
  dmOpenQ.PrintMockup;
end;

procedure TF_DynaQ.DeleteAllForeignRecs(const Lang:string);
begin
  dmOpenQ.cn.execute('delete from sel_qstns where language='+lang);
  dmOpenQ.cn.execute('delete from sel_Scls where language='+lang);
  dmOpenQ.cn.execute('delete from sel_Textbox where language='+lang);
  dmOpenQ.cn.execute('delete from sel_PCL where language='+lang);
end;

procedure TF_DynaQ.TranslateCommentBox1Click(Sender: TObject);

begin
  dmOpenQ.FindTransUponCreate := false;
  frmTranslation := TfrmTranslation.Create( Self );
  dmOpenQ.FindTransUponCreate := true;

  if frmTranslation.cmbLanguage.Items.Count = 0 then
  begin
    application.MessageBox('You need to select at least 1 foreign language'#13#10'from the Languages box in Tools/Options/Languages','Translation Warning',0);
    frmTranslation.Release;
    exit;
  end;
  with dmOpenQ, wwt_TransQ do
    if (not findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage])) then begin
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('SelQstns_ID').value := wwt_QstnsID.value;
      fieldbyname('Language').value := currentLanguage;
      fieldbyname('PlusMinus').value := wwt_QstnsPlusMinus.value;
      fieldbyname('Label').value := wwt_QstnsLabel.value;
      fieldbyname(qpc_Section).value := wwt_QstnsSection.value;
      fieldbyname('Type').value := wwt_QstnsType.value;
      fieldbyname('Subsection').value := wwt_QstnsSubsection.value;
      fieldbyname('Item').value := wwt_QstnsItem.value;
      fieldbyname('Subtype').value := wwt_QstnsSubtype.value;
      fieldbyname('ScaleID').value := wwt_QstnsScaleID.value;
      fieldbyname('Width').value := wwt_QstnsWidth.value;
      fieldbyname('Height').value := wwt_QstnsHeight.value;
      fieldbyname('ScaleFlipped').value := wwT_QstnsScaleFlipped.value;
      fieldbyname('QstnCore').value := wwt_QstnsQstnCore.value;
      fieldbyname('ScalePos').value := wwt_QstnsScalePos.value;
      fieldbyname('numMarkCount').value := wwt_QstnsnumMarkCount.value;
      fieldbyname('bitMeanable').value := wwt_QstnsbitMeanable.value;
      fieldbyname('numBubbleCount').value := wwt_QstnsnumBubbleCount.value;
      fieldbyname('bitLangReview').value := true;
      post;
    end;

  with frmTranslation do
  try
    DBTextLangReview.DataSource := dmopenq.wwds_transQ;
    clDBRichCodeBtnEng.DataSource := dmopenq.wwds_Qstns;
    clDBRichCodeBtnFrgn.DataSource := dmopenq.wwds_transQ;
    SetFrgnFont;
    ShowModal;
  finally
    Release;
    DeleteAllForeignRecs('-1'); //Delete temp record;
  end;
end;

procedure TF_DynaQ.EditAddressCodes1Click(Sender: TObject);
begin
  with dmOpenQ do begin
    with wwt_Qstns do begin
      filtered := false;
      if indexfieldnames <> qpc_Section+';Subsection;Item' then
        indexfieldnames := qpc_Section+';Subsection;Item'; 
      if findkey([-1,1,0]) then
        EditComment(false,'Edit Address Codes')
      else
        messagedlg('Can''t find address information',mterror,[mbok],0);
      filtered := true;
    end;
  end;
end;

procedure TF_DynaQ.TranslateAddress1Click(Sender: TObject);
begin
  with dmOpenQ, wwt_TransQ do begin
    wwt_Qstns.filtered := false;
    wwt_Qstns.IndexFieldName := 'Survey_ID;SelQstns_ID;Language';
    wwt_Qstns.findkey([glbSurveyID,2,1]);

    dmOpenQ.FindTransUponCreate := false;
    frmTranslation := TfrmTranslation.Create( Self );
    dmOpenQ.FindTransUponCreate := true;
    if frmTranslation.cmbLanguage.Items.Count = 0 then
    begin
      application.MessageBox('You need to select at least 1 foreign language'#13#10'from the Languages box in Tools/Options/Languages','Translation Warning',0);
      frmTranslation.Release;
      exit;
    end;

    if (not findkey([glbSurveyID,wwt_QstnsID.value,currentLanguage])) then begin
      append;
      fieldbyname('Survey_ID').value := glbSurveyID;
      fieldbyname('SelQstns_ID').value := wwt_QstnsID.value;
      fieldbyname('Language').value := currentLanguage;
      fieldbyname('PlusMinus').value := wwt_QstnsPlusMinus.value;
      fieldbyname('Label').value := wwt_QstnsLabel.value;
      fieldbyname(qpc_Section).value := wwt_QstnsSection.value;
      fieldbyname('Type').value := wwt_QstnsType.value;
      fieldbyname('Subsection').value := wwt_QstnsSubsection.value;
      fieldbyname('Item').value := wwt_QstnsItem.value;
      fieldbyname('Subtype').value := wwt_QstnsSubtype.value;
      fieldbyname('ScaleID').value := wwt_QstnsScaleID.value;
      fieldbyname('Width').value := wwt_QstnsWidth.value;
      fieldbyname('Height').value := wwt_QstnsHeight.value;
      fieldbyname('QstnCore').value := wwt_QstnsQstnCore.value;
      fieldbyname('ScalePos').value := wwt_QstnsScalePos.value;
      fieldbyname('numMarkCount').value := wwt_QstnsnumMarkCount.value;
      fieldbyname('bitMeanable').value := wwt_QstnsbitMeanable.value;
      fieldbyname('numBubbleCount').value := wwt_QstnsnumBubbleCount.value;
      fieldbyname('bitLangReview').value := true;
      post;
    end;
  end;

  with frmTranslation do
  try
    DBTextLangReview.DataSource := dmopenq.wwds_transQ;
    clDBRichCodeBtnEng.DataSource := dmopenq.wwds_Qstns;
    clDBRichCodeBtnFrgn.DataSource := dmopenq.wwds_transQ;
    SetFrgnFont;
    ShowModal;
    //delete record if no translation was made
    dmOpenQ.cn.execute('Delete from Sel_Qstns where language = -1');
  finally
    Release;
  end;
  dmOpenQ.wwt_Qstns.IndexFieldName := qpc_Section+';Subsection;Item';
  dmOpenq.wwt_Qstns.filtered := true;

end;

procedure TF_DynaQ.pnlThumbPosDblClick(Sender: TObject);
begin
  frmLayoutCalc.CalcScaleWidth;
end;

procedure TF_DynaQ.PageBreak1Click(Sender: TObject);
var i : integer;
begin
  I := newPCL(0,710,2);
  TDQPanel(ElementList[i]).left := 0;
  with WLKHandle do begin
    detach;
    attach(tcontrol(ElementList[i]));
    Resizable := false;
  end;
  with tDQPanel(WLKHandle.children[0]) do begin
    caption := '';
    hint := 'Put the rest of the letter at the top of the survey.'+#10+'Has no effect on integrated cover letters';
    showhint := true;
    PCL := '';
    KnownDimensions := true;
    color := clBlue;
  end;
  PageBreak1.enabled := false;


end;

procedure TF_DynaQ.AliasNamePanelDblClick(Sender: TObject);
begin
  messagedlg('Current survey_id:'+inttostr(dmopenq.glbsurveyid)+#13+'Net File Directory: '+session.netfiledir,mtinformation,[mbok],0);
end;

procedure TF_DynaQ.DBRESelQstnTextMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var pw : string;
begin
  if (DBRESelQstnText.readonly) and (shift=[ssLeft,ssCtrl,ssAlt]) then begin
    PW := DMOpenQ.GetUserParam('LAYOUTEDITPASSWORD');
    if pw = '' then PW := 'beagle';
    frmPassWord := TfrmPassWord.Create( Self );
    with frmPassWord do begin
      showmodal;
      if editPassWord.text = PW then begin
        DBRESelQstnText.readonly := false;
        DBRESelQstnText.PopupMenu := modsupport.popRTF;
        tCodes.open;
        tCodeText.open;
        tConstant.open;
        btnCode.visible := true;
        DBQstnsNavigator.visible := true;
      end;
      close;
    end;
  end;
end;

procedure TF_DynaQ.btnCodeClick(Sender: TObject);
begin
  if btnCode.Down then begin
    if vAsText then begin
      clCodeToggle1.text.down := false;
      clCodeToggle1.Text_ClickTransfer(sender);
    end;
    clCodeToggle1.enabled := false;
    frmCode := TfrmCode.Create( Self );
    frmCode.vForm := F_DynaQ;
    Hide;
    frmCode.DBGrid1.Datasource := DSCodes;
    frmCode.Top := ( Screen.Height - frmCode.Height ) div 2;
    frmCode.Left := 2;
    Show;
    frmCode.Show;
  end else begin
    clCodeToggle1.enabled := false;
    frmCode.Close;
  end;
end;

procedure TF_DynaQ.tCodeTextFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := ((( DataSet[ 'Age' ] = vAge[1] ) OR ( DataSet[ 'Age' ] = Null )) AND
            (( DataSet[ 'Sex' ] = vSex[1] ) OR ( DataSet[ 'Sex' ] = Null )) AND
            (( DataSet[ 'Doctor' ] = vDoc[1] ) OR ( DataSet[ 'Doctor' ] = Null )));
end;

procedure TF_DynaQ.UserPanelDblClick(Sender: TObject);
begin
  UserPanel.Ctl3d := not UserPanel.Ctl3d;
end;

function TF_DynaQ.newLogoRef(const ID,w,h:integer):integer;
begin
  ElementList.add(TDQPanel.create(F_DynaQ));
  result := elementlist.count-1;
  with TDQPanel(ElementList[result]) do begin
    parent := ScrollboxCovers;
    Caption := '(none)';
    BevelOuter := bvNone;
    Ctl3D := false;
    left := 100;
    top := 100;
    width := w;
    height := h;
    modified := false;
    KnownDimensions := true;
    if ID=0 then begin
      DMOpenQ.wwt_textbox.tag := DMOpenQ.wwt_textbox.tag + 1;
      tag := DMOpenQ.wwt_textbox.tag;
      modified := true;
      dmOpenQ.SaveDialog.tag := 2;
    end else
      tag := ID;
    PopupMenu := PopupLogo;
    OnMouseDown := Logo1MouseDown;
    insertcontrol(tDQImage.create(F_DynaQ));
    with tDQImage(Controls[0]) do begin
      Align := alClient;
      PopupMenu := PopupLogo;
      Stretch := true;
      Visible := true;
      OnMouseDown := Logo2MouseDown;
    end;
  end;
end;

procedure TF_DynaQ.btnLogoRefClick(Sender: TObject);
var i : integer;
begin
  dmopenq.LocalQuery('Select Description,Bitmap,scaling,'+qpc_ID+' from sel_logo where coverID=0 order by description',false);
  frmLogoRef := TfrmLogoRef.Create( Self );
  with frmLogoRef do
  try
    dsGraphics.dataset := dmopenq.ww_Query;
    if ShowModal = mrOK then begin
      i := newLogoRef(0,image1.width,image1.height);
      with WLKHandle do begin
        detach;
        attach(tcontrol(elementlist[i]));
        resizable := false;
      end;
      tDQImage(tDQPanel(WLKHandle.children[0]).controls[0]).picture := Image1.Picture;
      tDQPanel(WLKHandle.children[0]).caption := 'LogoRef' + dmopenq.ww_Query.fieldbyname(qpc_ID).asstring;
      if rbDynamic.checked then
        tDQPanel(WLKHandle.children[0]).caption := tDQPanel(WLKHandle.children[0]).caption + '.' + inttostr(rbDynamic.tag) + '.' + rbdynamic.hint;
      //resizeLogo(1479/?);
    end;
  finally
    Release;
  end;
end;

procedure TF_DynaQ.RenameLogoClick(Sender: TObject);
begin
  if (WLKHandle.childcount = 1) and isLogo(WLKHandle.children[0]) then begin
    tEdit(tDQPanel(WLKHandle.children[0]).controls[1]).text :=
        inputbox('Rename','New name:',tEdit(tDQPanel(WLKHandle.children[0]).controls[1]).text);
    tDQPanel(WLKHandle.children[0]).caption := tEdit(tDQPanel(WLKHandle.children[0]).controls[1]).text;
  end;
end;

procedure TF_DynaQ.ReloadAllQuestions1Click(Sender: TObject);
begin
  try
    screen.Cursor := crHourglass;
    dmopenQ.CheckAgainstLibrary;
  finally
    screen.cursor := crDefault;
  end;
end;

procedure TF_DynaQ.File1Click(Sender: TObject);
begin
  DMOpenQ.wwT_Scls.First;
  ReloadAllQuestions1.Enabled := not (DMOpenQ.wwt_Scls.eof);
end;

procedure TF_DynaQ.SurveyPropsClick(Sender: TObject);
var rs : variant;
    allmatch:boolean;
begin
  allmatch:=true;
  with TShowProps.create(application) do
    try
      if dmopenq.glbSurveyID = -1 then
      begin
        table1.DatabaseName := dmopenq.tmptbl.DatabaseName;
        table1.TableName := dmopenq.tmptbl.TableName;
        table1.Active := true;
        Table1.Filter := 'Language = 1 and Section = -1 and Type = ''Question'' and Label = ''Address and FOUO information''';
        Table1.Filtered := true;
        table1.First;
        Richedit1.text:= table1.FieldByName('RichText').value;
        table1.Active := false;
      end
      else
      begin
        rs := dmopenq.sqlcn.execute('Select RichText from sel_qstns where Label = ''Address and FOUO information'' and Section_id = -1 and survey_id = ' + inttostr(dmopenq.glbSurveyID));
        if not rs.eof then
            Richedit1.text := rs.Fields[0].value;
      end;

      //Saved Survey properties
      with Richedit1 do
      begin
        SelStart := 0;
        SelLength := 1;
        lblQuestionFontName.Caption := SelAttributes.name;
        lblQuestionFontSize.Caption  := inttostr(SelAttributes.size);

        SelStart := 1;
        SelLength := 1;
        lblScaleFontName.Caption := SelAttributes.name;
        lblScaleFontSize.Caption  := inttostr(SelAttributes.size);

        SelStart := 2;
        SelLength := 1;
        if (SelText='Y') then
          LblConsiderLegal.Caption := 'R'
        else
          LblConsiderLegal.Caption := '£';


        SelStart := 3;
        SelLength := 1;
        if strtointdef(seltext,1) = 1 then
           pnlShape.Caption := 'Bubbles'
        else
          pnlShape.Caption := 'Boxes';

        SelStart := 4;
        SelLength := 1;
        if not (SelText='F') then
           pnlShading.Caption := 'On'
        else
        pnlShading.Caption := 'Off';

        SelStart := 5;
        SelLength := 1;
        if (SelText='T') then
          lblTwoCol.Caption := 'R'
        else
          lblTwoCol.Caption := '£';

        SelStart := 6;
        SelLength := 1;
        if ((SelText='T') or (SelText='')) then
          lblSpreadQuestions.caption := 'R'
        else
          lblSpreadQuestions.caption := '£';

        SelStart := 7;
        SelLength := 5;
        pnlExtraSpace.caption := inttostr(strtointdef(seltext,0));
      end;

      //In-Memory properties
      with dmopenQ do
      begin

        lblQuestionFontName1.Caption :=  QstnFont;
        lblQuestionFontSize1.Caption  := inttostr(qstnPoint);


        lblScaleFontName1.Caption := SclFont;
        lblScaleFontSize1.Caption  := inttostr(SclPoint);

        if ConsiderDblLegal then
          LblConsiderLegal1.Caption := 'R'
        else
          LblConsiderLegal1.Caption := '£';

        if ResponseShape = 1 then
           pnlShape1.Caption := 'Bubbles'
        else
          pnlShape1.Caption := 'Boxes';

        if ShadingOn then
           pnlShading1.Caption := 'On'
        else
           pnlShading1.Caption := 'Off';

        if TwoColumns then
          lblTwoCol1.Caption := 'R'
        else
          lblTwoCol1.Caption := '£';

        if SpreadToFillPages then
          lblSpreadQuestions1.caption := 'R'
        else
          lblSpreadQuestions1.caption := '£';

        pnlExtraSpace1.caption := inttostr(ExtraSpace);
      end;


      if lblQuestionFontName1.Caption <> lblQuestionFontName.Caption then
      begin
        AllMatch:= False;
        pnl1_1.color := clRed;
        pnl2_1.color := clRed;
      end;

      if lblQuestionFontSize1.Caption <> lblQuestionFontSize.Caption then
      begin
        AllMatch:= False;
        pnl1_2.color := clRed;
        pnl2_2.color := clRed;
      end;

      if lblScaleFontName1.Caption <> lblScaleFontName.Caption then
      begin
        AllMatch:= False;
        pnl1_3.color := clRed;
        pnl2_3.color := clRed;
      end;

      if lblScaleFontSize1.Caption <> lblScaleFontSize.Caption then
      begin
        AllMatch:= False;
        pnl1_4.color := clRed;
        pnl2_4.color := clRed;
      end;

      if pnlShading1.Caption <> pnlShading.Caption then
      begin
        AllMatch:= False;
        pnl1_5.color := clRed;
        pnl2_5.color := clRed;
      end;

      if pnlShape1.Caption <> pnlShape.Caption then
      begin
        AllMatch:= False;
        pnl1_6.color := clRed;
        pnl2_6.color := clRed;
      end;

      if lblTwoCol1.Caption <> lblTwoCol.Caption then
      begin
        AllMatch:= False;
        pnl1_7.color := clRed;
        pnl2_7.color := clRed;
      end;

      if lblSpreadQuestions1.Caption <> lblSpreadQuestions.Caption then
      begin
        AllMatch:= False;
        pnl1_8.color := clRed;
        pnl2_8.color := clRed;
      end;

      if pnlExtraSpace1.Caption <> pnlExtraSpace.Caption then
      begin
        AllMatch:= False;
        pnl1_9.color := clRed;
        pnl2_9.color := clRed;
      end;

      if LblConsiderLegal1.Caption <> LblConsiderLegal.Caption then
      begin
        AllMatch:= False;
        pnl1_10.color := clRed;
        pnl2_10.color := clRed;
      end;
      if AllMatch then
      begin
        Label14.Caption := 'In-memory and Saved Properties match.';
        Label14.Font.Color := clblue;
      end
      else
      begin
        Label14.Caption := 'Warning! In Memory and Saved Properties don''t match.';
        Label14.Font.Color := clRed;
      end;
      showModal;
    finally
      free;
    end;
end;

procedure TF_DynaQ.Cut1Click(Sender: TObject);
begin
  if DMOpenQ.CutQuestions=1 then
    messagedlg('All questions you cut must have the same header.',mterror,[mbok],0);
end;

procedure TF_DynaQ.Paste1Click(Sender: TObject);
begin
  Case DMOpenQ.PasteQuestions of
    1 : messagedlg('Can''t paste questions here; headers don''t match.',mterror,[mbok],0);
    2 : messagedlg('Can''t paste questions here; Please paste below a subsection.',mterror,[mbok],0);
    else dmopenq.ClipboardQuestions := false;
  end;


  dmopenq.wwt_QstnsEnableControlsDammit;
  wwdbgrid1.UnselectAll;
  wwDBGrid1.RefreshDisplay;
end;

procedure TF_DynaQ.wwDBGrid1CalcTitleAttributes(Sender: TObject;
  AFieldName: String; AFont: TFont; ABrush: TBrush;
  var ATitleAlignment: TAlignment);
begin
   if (aFieldName='QstnCore') then
     ATitleAlignment:= taRightJustify
   else if (aFieldName='strScalePos') or (aFieldName='Skips') or (aFieldName='ProblemScore') then
     ATitleAlignment:= taCenter;
end;

procedure TF_DynaQ.mniLeftClick(Sender: TObject);
var
   i : integer;
begin
   with WLKHandle do begin
    for i := 1 to childcount-1 do
      //don't include page breaks
      if not isPCL(children[i]) then
         tDQPanel(children[i]).Left := tDQPanel(children[0]).Left;
   end;
end;

procedure TF_DynaQ.mniTopClick(Sender: TObject);
var
   i : integer;
begin
   with WLKHandle do begin
    for i := 1 to childcount-1 do
      //don't include page breaks
      if not isPCL(children[i]) then
         tDQPanel(children[i]).Top := tDQPanel(children[0]).Top;
   end;

end;

//Gn05: some admin functions
procedure TF_DynaQ.mniAdminClick(Sender: TObject);
var
  sInput: string;
begin
   //add a screen later based on the request, right now an input box is good enough
   sInput:= Trim(InputBox('Input Box', 'Please enter the version number(example 2.5)', ''));
   if sInput <> '' then
   begin
      if sInput <> DMOpenQ.FormLayoutVer then
      begin
         if MessageDlg('The current file version is ' + DMOpenQ.FormLayoutVer +  '. Do you want to update to version ' + sInput, mtWarning, [mbYes,mbNo], 0 ) = mrNo then exit;
      end;
      DMOpenQ.qpQuery('Update QualPro_Params set STRPARAM_VALUE = ' + QuotedStr(sInput) + ' where STRPARAM_NM = ''FormLayoutVersion''',True);
   end;

end;

end.
