unit fRptMgr;

{*******************************************************************************
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
11-22-2005  GN01   Making sure all the database connections are closed so that
                   Paradox doesn't leave any lock files around.
                   Added statusbar to display version info & Environment.
                   Check for Paradox lock files.

01-25-2006  GN02   When the SQL had the same report Param more than once, the proc
                   replaced the first occurence.
                   Ex: Select * from TableA where @Param1 = 'xyz' and @Param2 = 123 UNION
                       Select * from TableB wheer @Param1 = 'zzz'
                   Before the fix Select query from TableA was getting param value replace.
                   The @Param1 in Select query from TableB did not get replaced.

********************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, StdCtrls, checklst, Menus, mxarrays,  Grids, DBGrids,
  Buttons, ToolWin, ComCtrls, ExtCtrls, Sheet, BDE, Filectrl, OleCtrls,
  vcf1,common;

type
  TfrmReportManager = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    dbQualPro: TDatabase;
    qrySQL: TQuery;
    Reports1: TMenuItem;
    Run1: TMenuItem;
    Reset1: TMenuItem;
    ToolBar1: TToolBar;
    btnReset: TSpeedButton;
    btnRun: TSpeedButton;
    ToolButton1: TToolButton;
    btnExcel: TSpeedButton;
    PageControl1: TPageControl;
    ParameterSheet: TTabSheet;
    ScrlBoxParams: TScrollBox;
    Panel1: TPanel;
    chklistReports: TCheckListBox;
    Panel2: TPanel;
    ComboCategory: TComboBox;
    BtnText: TSpeedButton;
    SaveDialog1: TSaveDialog;
    dbDataMart: TDatabase;
    StatusBar: TStatusBar;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DropDownChange(Sender: TObject);
    function ParamToRemove(const ThisTop:integer):integer;
    procedure EditChangeNum(Sender: TObject);
    procedure EditChangeChar(Sender: TObject);
    procedure EditChangeDate(Sender: TObject);
    procedure EditExitDate(Sender: TObject);
    procedure btnStudyClick(Sender: TObject);
    procedure btnSurveyClick(Sender: TObject);
    procedure Run1Click(Sender: TObject);
    procedure Reports1Click(Sender: TObject);
    procedure chklistReportsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chklistReportsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Reset1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExcelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chklistReportsClickCheck(Sender: TObject);
    procedure ComboCategoryChange(Sender: TObject);
    procedure ParamDropDown(Sender: TObject);
    procedure ScrlBoxParamsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ToolBar1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure DateTimePickerExit(Sender: TObject);
  private
    { Private declarations }
    envname : string;
    ElementList : TList;
    GridList : tList;
    ParamList : tStringlist;
    ReportID_list : tSmallIntArray;
    ExecReports : boolean;
    LastRun : integer;
    pcount : integer;
    baddate, firstrun : boolean;
    last_Rep,last_sp : string;
    TemplateDir : string;
    AutoCreate : integer;
    AutoCreatePath : string;
    procedure GetParameters;
    procedure ResetDependentDropDowns(const prm : string);
    procedure GetNames(var su,st,cl:string; s:string);
    procedure GetIDs(su,st,cl:string; var su_id, st_id, cl_id:string);
    procedure GetCommandLine(var allparams:string; var defaultreps:string);    function SQLString(const s:string):string;
    procedure createspreadsheet(rn:integer);
    procedure NewTabSheet(capt:string);
    procedure NewGrid(proc,parms,dsn:string);
    procedure NewDropDown(const vleft,vtop:integer; vQuery:string; const DefaultText:string);
    procedure NewEdit(const vleft,vtop:integer; const vType:string; const DefaultText:string);
    procedure NewDatePicker(const vleft,vtop:integer; const DefaultDate:tDate);
    procedure NewLabel(const vleft,vtop:integer; const vcaption:string);
    procedure ClearElementList;
    procedure ClearGridList;
    function GetUserParam(const prm:string):string;
    procedure SQLQuery(const Qry:string; const Exe:boolean);
    procedure QPLogIn;
    function CheckParams:boolean;
    procedure LoadCategoryList;
    procedure LoadReportList;
    procedure dbGridSetColumns(const dbg:tDBGrid; const qry:tQuery);
    procedure ExecuteReport(rn:integer);
    procedure GetTemplateDir;
  public
    { Public declarations }
  end;

const
  acNoAutoCreate = 0;
  acExcel = 1;
  acTextFile = 2;

var
  frmReportManager: TfrmReportManager;
  isTextFile:Boolean;
implementation

uses FileUtil;

{$R *.DFM}

procedure TfrmReportManager.Exit1Click(Sender: TObject);
begin
  close;
end;

function TfrmReportManager.GetUserParam(const prm:string):string;
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

procedure TfrmReportManager.SQLQuery(const Qry:string; const Exe:boolean);
begin
  try
    with qrySQL do begin
      close;
      databasename := '_QualPro';
      sql.clear;
      sql.add(qry);
      if exe then
        ExecSQL
      else
        open;
    end;
  except
    on e:exception do
      messagedlg('SQL: '+e.message+#13+qry,mterror,[mbok],0);
  end;
end;

procedure TfrmReportManager.QPLogIn;
var userid,password:string;
    s,nd : string;
begin
  Check(dbiInit(Nil));
  //GN01
  try
    nd := aliaspath('PRIV');
    SaveTempDirInRegistry(nd);
    deldotstar(nd+'\p*.lck')
  except
  end;
  try
    nd := aliaspath('Question');
    deldotstar(nd+'\p*.lck')
  except
  end;

  ND := 'c:\';
  s := AliasPath('Question');
  if directoryexists(paramstr(1)) then
    ND := paramstr(1)
  else if (directoryexists(copy(s,1,length(s)-7)+'net')) then
    ND := copy(s,1,length(s)-7)+'net'
  else if directoryexists('\\capmts\capgemini\NRC\DATA\NET') then
    ND := '\\capmts\capgemini\NRC\DATA\NET'
  else if directoryexists('\\nrc1\nrc1\NET') then
    ND := '\\nrc1\nrc1\NET';
  //if dbQstnLib.connected then dbQstnlib.close;
  try
    session.netfiledir := nd;
    UserID := GetUserParam('USERID&PASSWORD');
  except
    on e:eDBEngineError do begin
      nd := uppercase(e.message);
      delete(nd,1,pos('DIRECTORY: ',nd)+10);
      delete(nd,pos('FILE:',nd)-2,length(nd));
      session.netfiledir := ND;
      UserID := GetUserParam('USERID&PASSWORD');
    end;
  end;

  if UserID <> '' then begin
    Password := UserID;
    delete(UserID,pos(';',UserID),length(UserID));
    delete(Password,1,pos(';',Password));
    dbQualPro.params.add('USER NAME='+UserID);
    dbQualPro.params.add('PASSWORD='+password);
  end else
    Password := '';
  UserID := GetUserParam('DATAMART_UID&PW');
  if UserID <> '' then begin
    Password := UserID;
    delete(UserID,pos(';',UserID),length(UserID));
    delete(Password,1,pos(';',Password));
    dbDataMart.params.add('USER NAME='+UserID);
    dbDataMart.params.add('PASSWORD='+password);
  end else
    Password := '';
  EnvName := GetUserParam('ENVIRONMENTNAME');
  if EnvName <> '' then begin
    SQLQuery('select strParam_value from QualPro_params where strParam_nm=''EnvName'' and strParam_grp=''Environment''',false);
    if qrySQL.fieldbyname('strParam_value').value <> EnvName then begin
      MessageDlg('SQL Environment ('+qrySQL.fieldbyname('strParam_value').value+
          ') doesn''t match Paradox Environment ('+EnvName+').  Please '+
          'notify Tech Services.',mterror,[mbok],0);
      Application.Terminate;
    end;
    qrySQL.close;
  end else begin
    MessageDlg('Environment (ENVIRONMENTNAME) isn''t registered in Paradox '+
        'Tables.  Please notify Tech Services.',mterror,[mbok],0);
    Application.Terminate;
  end;
end;

procedure TfrmReportManager.FormCreate(Sender: TObject);
var
   sVer : string;
begin

  firstrun := true;
  ExcelOpen := false;
  pcount := paramcount;
  qpLogIn;
  ReportID_list := tSmallIntArray.create(40,2);
  ElementList := tList.create;
  GridList := tList.create;
  ParamList := tStringList.create;
  GetTemplateDir;
  LoadCategoryList;
  LoadReportList;
  StatusBar.Panels[1].Text :=  EnvName;
  GetFileVersion(Application.ExeName, sVer);
  StatusBar.Panels[2].Text := sVer;
end;

procedure tfrmReportManager.GetTemplateDir;
begin
  sqlquery('Select strParam_value from qualpro_params where strParam_grp=''Reports'' and strParam_nm=''Template''',false);
  if qrySQL.fieldbyname('strParam_value').isnull then
    TemplateDir := 'C:\'
  else
    Templatedir := qrySQL.fieldbyname('strParam_value').value;
  qrySQL.close;
end;

function tfrmReportManager.SQLString(const s:string):string;
var i,c : integer;
begin
  result := '''';
  c := 0;
  for i := 1 to length(s) do begin
    if (s[i]<#32) then begin
      {ignore character}
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
      result := result + '''+''';
      c := 0;
    end;
  end;
  result := result + '''';
end;

procedure tfrmReportManager.GetCommandLine(var allparams:string; var defaultreps:string);
var i : word;
begin
  allparams := '•';
  Defaultreps := '•';
  AutoCreate := acNoAutoCreate;
  AutoCreatePath := 'C:\';
  if pcount>0 then
    for i := 1 to pcount do
      if pos('=',paramstr(i))>0 then
        allparams := allparams + paramstr(i) +'•'
      else if uppercase(paramstr(i))='/XL' then
        AutoCreate := acExcel
      else if uppercase(paramstr(i))='/T' then
        AutoCreate := acTextFile
      else if (directoryexists(paramstr(i)) and (AutoCreate <> acNoAutoCreate)) then
        AutoCreatePath := paramstr(i)
      else
        defaultreps := defaultreps + paramstr(i) +'•';
  if AutoCreatePath[length(AutoCreatePath)] <> '\' then
    AutoCreatePath := AutoCreatePath + '\';
end;

procedure tfrmReportManager.LoadCategoryList;
var allparams : string;
    defaultreps : string;
    i,ii : integer;
begin
{Default category should be the one with the
 first default report (from the command line) in it}
  GetCommandLine(allparams,defaultreps);
  with qrySQL do begin
    sql.clear;
    sql.add('select c.strReportCategory_nm,');
    sql.add('  max(charindex(r.strReport_nm,'+SQLString(defaultreps)+')) as DefCat');
    sql.add('from QPReportCategory c, QPReport r, UserGroup ug, UserGroupEmployee uge, employee e');
    sql.add('where c.qpreportcategory_id=r.qpreportcategory_id');
    sql.add('  and r.UserGroup_id=uge.UserGroup_id');
    sql.add('  and uge.Employee_id=e.Employee_id');
    sql.add('  and e.strNTLogin_nm='''+getuser()+'''');
    if pos('•study_id',lowercase(allparams))=0 then
      sql.add('  and r.qpreport_id not in (select distinct qpreport_id from QPprocparam where strParam_nm = ''study_id'')');
    if pos('•survey_id',lowercase(allparams))=0 then
      sql.add('  and r.qpreport_id not in (select distinct qpreport_id from QPprocparam where strParam_nm = ''survey_id'')');
    sql.add('group by c.strReportCategory_nm');
    sql.add('order by c.strReportCategory_nm');
    open;
    i := 0;
    ii := 0;
    while not eof do begin
      comboCategory.Items.add(fieldbyname('strReportCategory_nm').asstring);
      if (ii=0) and (fieldbyname('DefCat').asinteger>0) then
        ii := i;
      inc(i);
      next;
    end;
    comboCategory.ItemIndex := ii;
    close;
  end;
end;

procedure tfrmReportManager.LoadReportList;
var allparams : string;
    defaultreps : string;
    AutoGetPrms : boolean;
begin
  AutoGetPrms := false;
  GetCommandLine(allparams,defaultreps);
  LastRun := -1;
  last_rep := '';
  last_sp := '';
  run1.enabled := false;
  btnRun.enabled := false;
  ClearGridList;
  btnExcel.enabled := false;
  btnText.Enabled :=False;
  reportid_list.Clear;
  chklistreports.items.Clear;
  with qrySQL do begin
    close;
    sql.clear;
    sql.add('select r.QPReport_ID, r.strReport_nm');
    sql.add('from QPReport r, UserGroupEmployee uge, Employee e');
    sql.add('where QPReportCategory_id=(select QPReportCategory_id from QPReportCategory where strReportCategory_nm='''+combocategory.Text+''')');
    sql.add('  and r.UserGroup_id=uge.UserGroup_id');
    sql.add('  and uge.Employee_id=e.Employee_id');
    sql.add('  and e.strNTLogin_nm='''+getuser()+'''');
    if pos('•study_id',lowercase(allparams))=0 then
      sql.add('  and r.qpreport_id not in (select distinct qpreport_id from QPprocparam where strParam_nm = ''study_id'')');
    if pos('•survey_id',lowercase(allparams))=0 then
      sql.add('  and r.qpreport_id not in (select distinct qpreport_id from QPprocparam where strParam_nm = ''survey_id'')');
    sql.add('order by r.strReport_nm');
    open;
    while not eof do begin
      chklistReports.items.add(qrySQL.fieldbyname('strReport_nm').asstring);
      if FirstRun and (pos('•'+qrySQL.fieldbyname('strReport_nm').asstring+'•',defaultreps)>0) then begin
        chkListReports.Checked[chkListReports.Items.Count-1] := true;
        AutoGetPrms := true;
      end;
      ReportID_list.add(fieldbyname('qpreport_id').asinteger);
      next;
    end;
    close;
  end;
  clearElementList;
  clearGridList;
  //ParamList.clear;
  ExecReports := false;
  FirstRun := false;
  if AutoGetPrms then
    GetParameters;
end;

procedure TfrmReportManager.ClearElementList;
var I : integer;
begin
  if elementlist.count > 0 then
    for i := 0 to elementlist.count-1 do
      if (elementList[i]<>nil) then begin
        if tComponent(elementlist[i]) is tEdit then
          tEdit(elementlist[i]).free
        else if tComponent(elementlist[i]) is tDateTimePicker then
          tDateTimePicker(elementlist[i]).free
        else if tComponent(elementlist[i]) is tComboBox then
          tComboBox(elementlist[i]).free
        else if tComponent(elementlist[i]) is tLabel then
          tLabel(elementlist[i]).free;
        elementlist[i] := nil;
      end;
  elementlist.pack;
end;

procedure TfrmReportManager.ClearGridList;
var I : integer;
begin
  if GridList.count > 0 then
    for i := GridList.count-1 downto 0 do
      if (GridList[i]<>nil) then begin
        if tComponent(GridList[i]) is tDBGrid then
          tDBGrid(GridList[i]).free
        else if tComponent(GridList[i]) is tQuery then begin
          tQuery(GridList[i]).close;
          tQuery(GridList[i]).free;
        end else if tComponent(GridList[i]) is tDataSource then begin
          tDataSource(GridList[i]).free;
        end;
        GridList[i] := nil;
      end;
  GridList.pack;
  while pagecontrol1.pagecount>1 do
    pagecontrol1.Pages[pagecontrol1.PageCount-1].free;
  pageControl1.ActivePage := ParameterSheet;

end;

procedure tfrmReportManager.NewTabSheet(capt:string);
begin
  with PageControl1 do
    with TTabSheet.Create(Self) do begin
      PageControl := PageControl1;
      Caption := Capt;
    end;
end;

procedure tfrmReportManager.NewGrid(proc,parms,dsn:string);
var q,g,ds : integer;
begin
  NewTabSheet(proc);
  GridList.add(tQuery.create(self));
  q := GridList.count - 1;
  with tQuery(GridList[q]) do begin
    databasename := '_' + DSN;
    sql.clear;
    sql.add('execute QP_Rep_' + proc + parms);
    open;
  end;
  GridList.add(tDataSource.create(self));
  ds := GridList.count - 1;
  tDataSource(GridList[ds]).dataset := tQuery(GridList[q]);
  GridList.add(TdbGrid.create(frmReportManager));
  g := GridList.count - 1;
  with tDBGrid(GridList[g]) do begin
    Parent := pagecontrol1.pages[PageControl1.pagecount-1];
    align := alClient;
    DataSource := tDataSource(GridList[ds]);
  end;
  dbgridsetcolumns(tDBGrid(GridList[g]), tQuery(GridList[q]));
  PageControl1.ActivePage := PageControl1.Pages[PageControl1.PageCount-1];
  PageControl1.Pages[PageControl1.PageCount-1].tag := q;
end;


procedure tfrmReportManager.NewLabel(const vleft,vtop:integer; const vcaption:string);
var i : integer;
begin
  ElementList.add(TLabel.create(frmReportManager));
  i := ElementList.count - 1;
  with tLabel(ElementList[i]) do begin
    Parent := ScrlBoxParams;
    caption := vCaption;
    left := vLeft;
    top := vTop;
  end;
end;

procedure tfrmReportManager.NewDropDown(const vleft,vtop:integer; vQuery:string; const DefaultText:string);
var i : integer;
begin
  ElementList.add(TComboBox.create(frmReportManager));
  i := ElementList.count - 1;
  with tComboBox(ElementList[i]) do begin
    Parent := ScrlBoxParams;
    left := vLeft;
    top := vTop;
    style := csDropDownList;
    hint := vQuery;
    ParentFont := false;
    if DefaultText <> '' then begin
      text := DefaultText;
      tag := abs(tag);
    end;
    OnDropDown := ParamDropDown;
    OnChange := DropDownChange;
  end;
end;

procedure tfrmReportManager.NewEdit(const vleft,vtop:integer; const vType:string; const DefaultText:string);
var i : integer;
begin
  ElementList.add(TEdit.create(frmReportManager));
  i := ElementList.count - 1;
  with tEdit(ElementList[i]) do begin
    Parent := ScrlBoxParams;
    left := vLeft;
    top := vTop;
    if vType='C' then begin
      tag := -1;
      OnChange := EditChangeChar;
    end else if vType='D' then begin
      tag := -2;
      OnChange := EditChangeDate;
      OnExit := EditExitDate;
    end else if vType='T' then begin
      tag := -4;
      OnChange := EditChangeDate;
      OnExit := EditExitDate;
    end else if vType='N' then begin
      tag := -3;
      OnChange := EditChangeNum;
    end;
    if DefaultText <> '' then begin
      text := DefaultText;
      tag := abs(tag);
    end;
  end;
end;

procedure tfrmReportManager.NewDatePicker(const vleft,vtop:integer; const DefaultDate:tDate);
var i : integer;
begin
  ElementList.add(TDateTimePicker.create(frmReportManager));
  i := ElementList.count - 1;
  with tDateTimePicker(ElementList[i]) do begin
    Parent := ScrlBoxParams;
    left := vLeft;
    top := vTop;
    width := 70;
    tag := -2;
    dateMode := dmComboBox;
    Kind := dtkDate;
    OnChange := DateTimePickerChange; //EditChangeDate;
    OnExit := DateTimePickerExit; //EditExitDate;
    if DefaultDate <> strtodate('4/28/1968') then begin
      Date := DefaultDate;
      tag := abs(tag);
    end;
  end;
end;

procedure tfrmReportManager.ResetDependentDropDowns(const prm : string);
var i : integer;
begin
  {set .parentfont=false for any dropdown that uses this parameter
   in it's list definition query}
  for i := 0 to elementlist.count-1 do
    if (tComponent(elementlist[i]) is tComboBox)
        and (pos('@'+lowercase(prm),lowercase(tCombobox(elementlist[i]).hint))>0) then begin
      tCombobox(elementlist[i]).parentfont := false;
      tCombobox(elementlist[i]).items.clear;
    end;
end;

function tFrmReportManager.ParamToRemove(const ThisTop:integer):integer;
var i : integer;
    s : string;
begin
  s := '';
  result := -1;
  for i := 0 to elementlist.count-1 do
    if (tComponent(elementlist[i]) is tLabel) and (tLabel(elementlist[i]).top = ThisTop) then begin
      s := tLabel(elementlist[i]).caption;
      result := paramlist.IndexOfName(s);
    end;
  if s <> '' then
    ResetDependentDropDowns(s);
end;

procedure TfrmReportManager.EditChangeDate(Sender: TObject);
var j : integer;
    NotDateTime : boolean;
begin
  NotDateTime := (abs(tEdit(sender).tag)<>4);
  tEdit(sender).tag := -abs(tEdit(sender).tag);
  run1.enabled := false;
  btnRun.enabled := false;
  btnExcel.enabled := false;
  btnText.enabled := false;
  j := ParamToRemove(tEdit(sender).top);
  if trim(tEdit(sender).text) = '' then begin
    if j > -1 then paramlist.Delete(j);
  end else
    try
      if NotDateTime then
        strtodate(tEdit(sender).text)
      else
        strtodatetime(tEdit(sender).text);
      tEdit(sender).tag := abs(tEdit(sender).tag);
      run1.Enabled := CheckParams;
      btnRun.Enabled := run1.enabled;
      btnExcel.enabled := btnRun.enabled;
      btnText.enabled := btnRun.enabled;
      LastRun := -1;
      BadDate := false;
    except
      on e:EConvertError do begin
        //messagedlg(e.message,mterror,[mbok],0);
        BadDate := true;
        ActiveControl := tEdit(sender);
      end;
    end;
end;

procedure TfrmReportManager.EditExitDate(Sender: TObject);
var j : integer;
    NotDateTime : boolean;
begin
  NotDateTime := (abs(tEdit(sender).tag)<>4);
  tEdit(sender).tag := -abs(tEdit(sender).tag);
  run1.enabled := false;
  btnRun.enabled := false;
  btnExcel.enabled := false;
  btnText.enabled := false;
  j := ParamToRemove(tEdit(sender).top);
  if trim(tEdit(sender).text) = '' then begin
    if j > -1 then paramlist.Delete(j);
  end else
    try
      if NotDateTime then
        strtodate(tEdit(sender).text)
      else
        strtodatetime(tEdit(sender).text);
      tEdit(sender).tag := abs(tEdit(sender).tag);
      run1.Enabled := CheckParams;
      btnRun.Enabled := run1.enabled;
      btnExcel.enabled := btnRun.enabled;
      btnText.enabled := btnRun.enabled;
      LastRun := -1;
      BadDate := false;
    except
      on e:EConvertError do begin
        messagedlg(e.message,mterror,[mbok],0);
        BadDate := true;
        ActiveControl := tEdit(sender);
      end;
    end;
end;

procedure TfrmReportManager.btnStudyClick(Sender: TObject);
begin
  Messagedlg('pick a study',mtinformation,[mbok],0)
end;

procedure TfrmReportManager.btnSurveyClick(Sender: TObject);
begin
  Messagedlg('pick a survey',mtinformation,[mbok],0)
end;

procedure TfrmReportManager.GetParameters;
var i,curTop : integer;
    allparams,st,su,cl,s : string;
begin
  ClearElementList;
  getcommandline(allparams,s);
  st := ''; su := ''; cl := '';
  getnames(su,st,cl,allparams);
  s := '';
  for i := 0 to chklistReports.Items.count-1 do
    if chklistReports.Checked[i] then
      s := s + inttostr(Reportid_list[i])+',';
  if s = '' then begin
    {no reports checked}
  end else begin
    s := copy(s,1,length(s)-1);
    SQLQuery('select strParam_nm, strParam_type, strQueryForList '+
      'from dash_QPprocparam_view '+
      'where QPReport_id in (' + s + ') ' +
      'group by strParam_nm, strParam_type, strQueryForList '+
      'order by min(qpprocparam_id)',false);
    curTop := 10;
    with qrySQL do begin
      while not eof do begin
        newlabel(10,curTop,fieldbyname('strParam_nm').asstring);
        s := '';
        if pcount>0 then
          for i := 1 to pcount do
            if pos(uppercase(fieldbyname('strParam_nm').asstring+'='),uppercase(paramstr(i)))=1 then
              s := copy(paramstr(i),pos('=',paramstr(i))+1,length(paramstr(i)));
        if s <> '' then
          newlabel(100,curTop,s)
        else if fieldbyname('strParam_nm').asstring = 'Associate' then begin
          newlabel(100,curTop,getuser());
        end else begin
          i := paramlist.IndexOfName(fieldbyname('strParam_nm').asstring);
          if i > -1 then
            s := paramlist.values[qrySQL.fieldbyname('strParam_nm').asstring]
          else
            s := '';
          if fieldbyname('strParam_type').asstring='L' then begin
            if (lowercase(fieldbyname('strParam_nm').asstring)='client') and (cl <> '') then
              newlabel(100,curtop,cl)
            else if (lowercase(fieldbyname('strParam_nm').asstring)='study') and (st <> '') then
              newlabel(100,curtop,st)
            else if (lowercase(fieldbyname('strParam_nm').asstring)='survey') and (su <> '') then
              newlabel(100,curtop,su)
            else
              NewDropDown(100,curTop,fieldbyname('strQueryForList').asstring,s);
          end else
            if fieldbyname('strParam_type').asstring = 'D' then begin
              if s = '' then s := datetostr(date());
              newDatePicker(100,curTop,strtoDate(s));
            end else
              newEdit(100,curTop,fieldbyname('strParam_type').asstring,s);
        end;
        inc(curTop,25);
        next;
      end;
    end;
  end;
  Run1.Enabled := CheckParams;
  btnRun.enabled := run1.enabled;
  btnExcel.enabled := btnRun.enabled;
  btnText.enabled := btnRun.enabled;
  if (btnRun.enabled) and (AutoCreate <> acNoAutoCreate) then
    btnExcelMouseUp(nil,mbLeft,[ssctrl],0,0)
  else
    AutoCreate := acNoAutoCreate;
end;

procedure TfrmReportManager.EditChangeNum(Sender: TObject);
var j : integer;
begin
  tEdit(sender).tag := -abs(tEdit(sender).tag);
  run1.enabled := false;
  btnRun.enabled := false;
  btnExcel.enabled := false;
  btnText.enabled := false;
  tEdit(sender).text := trim(tEdit(sender).text);
  j := ParamToRemove(tEdit(sender).top);
  if trim(tEdit(sender).text) = '' then begin
    if j > -1 then paramlist.Delete(j);
  end else begin
    if (strtointdef(tEdit(sender).text,-792140605) = -792140605) then begin
      messagedlg(''''+tEdit(sender).text +''' is not a valid integer',mterror,[mbok],0);
      ActiveControl := tEdit(sender);
    end else begin
      tEdit(sender).tag := abs(tEdit(sender).tag);
      run1.Enabled := CheckParams;
      btnRun.enabled := run1.enabled;
      btnExcel.enabled := btnRun.enabled;
      btnText.enabled := btnRun.enabled;
      LastRun := -1;
    end;
  end;
end;

procedure TfrmReportManager.DropDownChange(Sender: TObject);
var i,j:integer;
begin
  i := -1;
  for j := 0 to elementlist.count-1 do
    if (tComponent(elementlist[j]) is tLabel) and (tLabel(elementlist[j]).top = tComboBox(sender).top) then
      i := j;
  if tComboBox(sender).ItemIndex = -1 then begin
    tComboBox(sender).tag := -abs(tComboBox(sender).tag);
    run1.enabled := false;
    j := paramlist.IndexOfName(tLabel(elementlist[i]).caption);
    if j > -1 then paramlist.Delete(j);
  end else begin
    tComboBox(sender).tag := abs(tComboBox(sender).tag);
    ResetDependentDropDowns(tLabel(elementlist[i]).caption);
    run1.enabled := CheckParams;
    LastRun := -1;
  end;
  btnRun.enabled := run1.enabled;
  btnExcel.enabled := btnRun.enabled;
  btnText.enabled := btnRun.enabled;
end;

procedure TfrmReportManager.EditChangeChar(Sender: TObject);
var j:integer;
begin
  J := ParamToRemove(tEdit(sender).top);
  if trim(tEdit(sender).text) = '' then begin
    tEdit(sender).tag := -abs(tEdit(sender).tag);
    run1.enabled := false;
    if j > -1 then paramlist.Delete(j);
  end else begin
    tEdit(sender).tag := abs(tEdit(sender).tag);
    run1.enabled := CheckParams;
    LastRun := -1;
  end;
  btnRun.enabled := run1.enabled;
  btnExcel.enabled := btnRun.enabled;
  btnText.enabled := btnRun.enabled;
end;

function tfrmReportManager.CheckParams:boolean;
var i,j : integer;
    addparm,addvalue : string;
begin
  if ElementList.count=0 then
    result := false
  else begin
    result := true;
    //ParamList.clear;
    for i := 0 to ElementList.count-1 do begin
      addparm := '';
      addvalue := '';
      if tObject(ElementList[i]) is tDateTimePicker then begin
        if tDateTimePicker(ElementList[i]).tag < 0 then
          result := false
        else begin
          addparm := tLabel(Elementlist[i-1]).caption;
          addvalue := datetostr(tDateTimePicker(elementlist[i]).Date);
        end;
      end else if tObject(Elementlist[i]) is tEdit then begin
        if tEdit(ElementList[i]).tag < 0 then
          result := false
        else begin
          addparm := tLabel(Elementlist[i-1]).caption;
          addvalue := tEdit(elementlist[i]).text
        end;
      end else if tObject(Elementlist[i]) is tLabel then begin
        if (i>0) and (tLabel(Elementlist[i-1]).left=10) then begin
          addparm := tLabel(Elementlist[i-1]).caption;
          addvalue := tLabel(elementlist[i]).caption;
        end;
      end else if tObject(Elementlist[i]) is tComboBox then begin
        if (i>0) and (tLabel(Elementlist[i-1]).left=10) then begin
          if tComboBox(elementlist[i]).itemindex=-1 then
            result := false
          else begin
            addparm := tLabel(Elementlist[i-1]).caption;
            addvalue := tComboBox(elementlist[i]).items[tComboBox(elementlist[i]).itemindex];
          end;
        end;
      end;
      if addparm <> '' then begin
        j := paramlist.IndexOfName(addparm);
        if j=-1 then
          paramlist.add(addparm+'='+addvalue)
        else
          paramlist[j] := addparm+'='+addvalue;
      end;
    end;
  end;
end;

procedure TfrmReportManager.Run1Click(Sender: TObject);
var i : integer;
begin
  i := 0;
  while i<chklistReports.items.Count do begin
    if not chklistreports.Checked[i] then begin
      chklistreports.items.Delete(i);
      reportid_list.Delete(i);
    end else
      inc(i);
  end;
  ExecReports := true;
  chklistreportsmouseup(sender,mbleft,[],0,0);
end;

procedure TfrmReportManager.Reports1Click(Sender: TObject);
begin
  activecontrol := nil;
  run1.enabled := checkparams;
  btnRun.enabled := run1.enabled;
  btnExcel.enabled := btnRun.enabled;
  btnText.enabled := btnRun.enabled;
end;

procedure TfrmReportManager.chklistReportsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key in [34,33,38,37,39,40] then
    chklistreportsmouseup(sender,mbleft,shift,0,0);
end;

procedure TfrmReportManager.dbGridSetColumns(const dbg:tDBGrid; const qry:tQuery);
var i,fc : integer;
begin
  dbg.Columns.Clear;
  fc := 0;
  for i := 0 to qry.FieldCount - 1 do
    if pos('dummy',lowercase(qry.fields[i].fieldname))=0 then begin
      dbg.Columns.Add;
      dbg.Columns.Items[fc].field := qry.Fields[i];
      inc(fc);
    end;
end;

function doublequote(const s:string):string;
begin
  result := s;
  while pos('''',result)>0 do
    result[pos('''',result)] := chr(1);
  while pos(chr(1),result)>0 do
    result := copy(result,1,pos(chr(1),result)-1) + '''''' + copy(result,pos(chr(1),result)+1,length(result));
end;

procedure TfrmReportManager.ExecuteReport(rn:integer);
var sp,spp : string;
    ProcID,i : integer;
    Procs : tQuery;
    DSN : string;
begin
  ClearGridList;
  LastRun := rn;
  Last_Rep := chklistreports.items[rn];
  Procs := tQuery.create(self);
  try
    with Procs do begin
      databasename := qrySQL.databasename;
      sql.clear;
      sql.add('Select QPReportProc_id, strReportProc_nm, strDSN_nm from QPReportProc where QPReport_id = '+inttostr(reportid_list[rn]));
      open;
      while not eof do begin
        sp := fieldbyname('strReportProc_nm').asstring;
        spp := '  ';
        dsn := fieldbyname('strDSN_nm').value;
        ProcID := fieldbyname('QPReportProc_id').asInteger;
        SQLQuery('select QPProcParam_id, strParam_nm, strParam_type from QPProcParam where QPReportProc_id = '+inttostr(ProcID) ,false);
        while not qrySQL.eof do begin
          i := paramlist.IndexOfName(qrySQL.fieldbyname('strParam_nm').asstring);
          if i > -1 then begin
            spp := spp + '@' + qrySQL.fieldbyname('strParam_nm').asstring+'=';
            if pos(qrySQL.fieldbyname('strParam_type').asstring,'DTCL')>0 then
              spp := spp + ''''+doublequote(paramlist.values[qrySQL.fieldbyname('strParam_nm').asstring]) + ''', '
            else
              spp := spp + paramlist.values[qrySQL.fieldbyname('strParam_nm').asstring] + ', ';
          end else begin
            messagedlg('"'+qrySQL.fieldbyname('strParam_nm').asstring+'" parameter wasn''t defined',mterror,[mbok],0);
            exit;
          end;
          qrySQL.next;
        end;
        qrySQL.close;
        spp := copy(spp,1,length(spp)-2);
        last_sp := sp + spp;
        screen.cursor := crHourglass;
        try
          NewGrid(sp,spp,DSN);
        finally
          screen.cursor := crDefault;
        end;
        next;
      end;
      close;
    end;
  finally
    Procs.free;
  end;
end;

procedure TfrmReportManager.chklistReportsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
  if ExecReports and (button=mbLeft) then
    begin
      i := 0;
      while (i < chklistreports.Items.Count) and (not chklistreports.selected[i]) do
      inc(i);
      if (i >= chklistreports.Items.Count) then
        i := 0;
      if (i<>LastRun) then
        ExecuteReport(i);
    end;
end;

procedure TfrmReportManager.Reset1Click(Sender: TObject);
begin
  LoadReportList;
end;

procedure TfrmReportManager.FormDestroy(Sender: TObject);
begin
  CloseExcel;
  ClearGridList;
  ClearElementList;
  //Gn01: cleanup
  dbQualPro.CloseDataSets;
  dbQualPro.Connected := False;
  dbDataMart.CloseDataSets;
  dbDataMart.Connected := False;
  
end;

procedure tfrmReportManager.GetNames(var su,st,cl:string; s:string);
begin
  while pos(',',s)>0 do s[pos(',',s)] := '•';
  with qrySQL do begin
    close;
    sql.clear;
    if pos('survey_id=',s)>0 then begin
      su := copy(s,pos('survey_id=',s)+10,length(s));
      su := copy(su,1,pos('•',su+'•')-1);
      sql.add('select c.strClient_nm, s.strStudy_nm, sd.strSurvey_nm');
      sql.add('from survey_def sd, study s, client c');
      sql.add('where sd.study_id=s.study_id and s.client_id=c.client_id');
      sql.add(' and sd.survey_id='+su);
      open;
      cl := fieldbyname('strClient_nm').asstring;
      st := fieldbyname('strStudy_nm').asstring;
      su := fieldbyname('strSurvey_nm').asstring;
      close;
    end else if pos('study_id=',s)>0 then begin
      st := copy(s,pos('study_id=',s)+9,length(s));
      st := copy(st,1,pos('•',st+'•')-1);
      sql.add('select c.strClient_nm, s.strStudy_nm');
      sql.add('from study s, client c');
      sql.add('where s.client_id=c.client_id');
      sql.add(' and s.study_id='+st);
      open;
      cl := fieldbyname('strClient_nm').asstring;
      st := fieldbyname('strStudy_nm').asstring;
      close;
    end else if pos('client_id=',s)>0 then begin
      cl := copy(s,pos('client_id=',s)+10,length(s));
      cl := copy(cl,1,pos('•',cl+'•')-1);
      sql.add('select c.strClient_nm');
      sql.add('from client c');
      sql.add('where c.client_id='+cl);
      open;
      cl := fieldbyname('strClient_nm').asstring;
      close;
    end;
  end;
end;

procedure tfrmReportManager.GetIDs(su,st,cl:string; var su_id, st_id, cl_id:string);
  function singlequote(varname:string):string;
  begin
    if varname='' then
      result := ''
    else
      if pos(chr(1),varname)>0 then begin
        while pos(chr(1),varname)>0 do varname[pos(chr(1),varname)] := '_';
        result := 'like '''+varname+'''';
      end else
        result := '= '''+varname+'''';
  end;
begin
  cl_id := '';
  st_id := '';
  su_id := '';
  su := singlequote(su);
  st := singlequote(st);
  cl := singlequote(cl);
  with qrySQL do begin
    close;
    sql.clear;
    if su<>'' then begin
      sql.add('select s.client_id, s.Study_id, sd.Survey_id');
      sql.add('from survey_def sd, study s, client c');
      sql.add('where sd.study_id=s.study_id and s.client_id=c.client_id');
      sql.add(' and sd.strsurvey_nm ' + su);
      sql.add(' and s.strstudy_nm ' + st);
      sql.add(' and c.strclient_nm ' + cl);
      open;
      cl_id := fieldbyname('Client_id').asstring;
      st_id := fieldbyname('Study_id').asstring;
      su_id := fieldbyname('Survey_id').asstring;
      close;
    end else if st<>'' then begin
      sql.add('select s.client_id, s.Study_id');
      sql.add('from study s, client c');
      sql.add('where s.client_id=c.client_id');
      sql.add(' and s.strstudy_nm ' + st);
      sql.add(' and c.strclient_nm ' + cl);
      open;
      cl_id := fieldbyname('Client_id').asstring;
      st_id := fieldbyname('Study_id').asstring;
      close;
    end else if cl<>'' then begin
      sql.add('select c.client_id');
      sql.add('from client c');
      sql.add('where c.strclient_nm ' + cl);
      open;
      cl_id := fieldbyname('Client_id').asstring;
      close;
    end;
  end;
end;

procedure tfrmReportManager.createspreadsheet(rn:integer);
var s, cl, st, su, XLTemplate: string;
    cl_id, st_id, su_id : string;
    i,j,FC : integer;
    FieldList:tStringList;
    outTextFile:TextFile;
    RowText:string;
    ds : tDataset;
    additionaltitle : string;
    //tb :ttable;

begin
  if PageControl1.PageCount<=1 then
    exit;
  cl := ''; st := ''; su := '';
  while pos('''''',last_sp)>0 do begin
    i := pos('''''',last_sp);
    delete(last_sp,i,1);
    last_sp[i] := chr(1);
  end;
  if pos('survey=',lowercase(last_sp))>0 then begin
    su := copy(last_sp,pos('survey=',lowercase(last_sp))+8,length(last_sp));
    su := copy(su,1,pos('''',su+'''')-1);
  end;
  if pos('study=',lowercase(last_sp))>0 then begin
    st := copy(last_sp,pos('study=',lowercase(last_sp))+7,length(last_sp));
    st := copy(st,1,pos('''',st+'''')-1);
  end;
  if pos('client=',lowercase(last_sp))>0 then begin
    cl := copy(last_sp,pos('client=',lowercase(last_sp))+8,length(last_sp));
    cl := copy(cl,1,pos('''',cl+'''')-1);
  end;
  GetNames(su,st,cl,lowercase(last_sp));
  GetIDs(su, st, cl, su_id, st_id, cl_id);
  while pos(chr(1),su)>0 do su[pos(chr(1),su)] := '''';
  while pos(chr(1),st)>0 do st[pos(chr(1),st)] := '''';
  while pos(chr(1),cl)>0 do cl[pos(chr(1),cl)] := '''';
  if su_id <> '' then su := su + ' (' + su_id + ')';
  if st_id <> '' then st := st + ' (' + st_id + ')';
  if cl_id <> '' then cl := cl + ' (' + cl_id + ')';

  if fileexists(TemplateDir+chklistreports.items[rn]+'.XLT') then
    XLTemplate := TemplateDir+chklistreports.items[rn]+'.XLT'
  else
    XLTemplate := '';

  if isTextFile then
    begin
      SaveDialog1.FileName := AutoCreatePath + chklistreports.items[rn] + '.dbd';
      if (AutoCreate=acTextFile) or (SaveDialog1.Execute) then
        begin
          FieldList:=tStringList.create;
          FieldList.Sorted:=false;
          //outFileName:='C:\DshBrd'+FormatDateTime('ddmmyyhhmm',now)+'.dbd';
          AssignFile(OutTextFile,SaveDialog1.FileName);
          ReWrite(outTextFile);
          writeln(outTextFile,cl+#9#13#10,st+#9#13#10,su+#9#13#10,'Date: '+FormatDateTime('mmm dd, yyyy; hh:mm AM/PM',now));
          writeln(outTextFile);
          writeln(outTextFile);
        end
      else
        exit;
    end
  else
    NewExcelSheet(XLTemplate,[chklistreports.items[rn],cl,st,su]);

  additionaltitle := '';
  for i := 1 to pagecontrol1.pagecount-1 do begin
    s := tQuery(GridList[PageControl1.pages[i].tag]).sql[0];
    s := copy(s,9,length(s));
    ds:=tDataSet(GridList[PageControl1.pages[i].tag]);

    //The following code is for the potential of saving each tab as a dbf file
    //It actually works but is also saving the "dummy" fieds... so i commented it
    //tb:=ttable.Create(self);
    //tb.TableType:= ttdbase;

    //tb.TableName:='c:\'+PageControl1.pages[i].caption;
    //tb.BatchMove(TBDEDataset(ds),batCopy);
    //tb.Active := true;
    //fc:=tb.FieldCount-1;
    //for j:=0 to fc do
    //  if  pos('dummy',lowercase(tb.Fields[j].fieldname)) > 0 then
    //    begin
    //      outFileName:=tb.Fields[j].fieldname;
    //      tb.active:=false;
    //      tb.fielddefs.items[j].free;
    //    end;
    //tb.Destroy;
    FC:=ds.FieldCount-1;
    if isTextFile then
      begin
        RowText:='';
        FieldList.clear;
        for j:= 0 to FC do
           if pos('dummy',lowercase(ds.Fields[j].fieldname)) = 0 then
             begin
               RowText:= RowText+ds.Fields[j].fieldname+#9;
               FieldList.Add(ds.Fields[j].fieldname);
             end;
        //Delete(RowText,length(RowText),1);
        Writeln(outTextFile,RowText);
        fc:=FieldList.Count-1;
        if not (ds.EOF and ds.BOF) then
          ds.First;
        While Not ds.EOF do
          begin
            RowText:='';
            For j:=0 to FC do
              RowText:=RowText+ds.FieldByName(FieldList.Strings[j]).asString+#9;
            //Delete(RowText,length(RowText),1);
            Writeln(outTextFile,RowText);
            ds.next;
          end;
        Writeln(outTextFile);
      end
    else
      PushToExcel(s,ds,[last_rep,cl,st,su],additionaltitle)
  end;
  if isTextFile then
    CloseFile(outTextFile)
  else
    begin
      ExcelTitles([last_rep,cl,st,su],additionaltitle);
      RunExcelMacro;
      if AutoCreate = acExcel then
        SaveExcel(AutoCreatePath+last_rep+'.xls');
    end;
end;

 ///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

procedure TfrmReportManager.btnExcelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
  if AutoCreate = acNoAutoCreate then
    isTextFile := (lowercase(tSpeedButton(Sender).Name) = 'btntext')
  else
    isTextFile := (AutoCreate = acTextFile);

  ExecReports := ExecReports or CheckParams;
  if ExecReports then begin
    i := 0;
    while i<chklistReports.items.Count do begin
      if not chklistreports.Checked[i] then begin
        chklistreports.items.Delete(i);
        reportid_list.Delete(i);
      end else
        inc(i);
    end;
    if ssctrl in shift then begin
      for i := 0 to chklistreports.Items.Count-1 do begin
        ExecuteReport(i);
        CreateSpreadSheet(i);
      end;
      if AutoCreate = acNoAutoCreate then
        ShowExcel
      else
        if AutoCreate = acExcel then
          ShutDownExcel;
    end else begin
      i := 0;
      while (i < chklistreports.Items.Count) and (not chklistreports.selected[i]) do
        inc(i);

      if (i >= chklistreports.Items.Count) then
        i := 0;

      if i <> lastrun then
        ExecuteReport(i);
      CreateSpreadSheet(i);
      ShowExcel;
    end;
  end;
end;

procedure TfrmReportManager.chklistReportsClickCheck(Sender: TObject);
begin
  GetParameters;
end;

procedure TfrmReportManager.ComboCategoryChange(Sender: TObject);
begin
  LoadReportList;
end;

procedure TfrmReportManager.ParamDropDown(Sender: TObject);
var qry,pval : string;
    i,p : integer;
begin
  qry := tComboBox(sender).hint;
  if tComboBox(sender).ParentFont then exit;
  tComboBox(sender).ParentFont := true;
  if pos('@',qry)>0 then begin
    for i := 0 to elementlist.count-1 do
      if (tComponent(elementlist[i]) is tLabel) and (tLabel(elementlist[i]).left = 10) then begin
        //GN02: substitute all occurence of the report param 
        while pos('@'+lowercase(tlabel(elementlist[i]).caption),lowercase(qry)) > 0 do
        begin
           p := pos('@'+lowercase(tlabel(elementlist[i]).caption),lowercase(qry));
           if p>0 then begin
             if tComponent(elementlist[i+1]) is tLabel then begin
               if abs(tEdit(elementlist[i+1]).tag) = 3 then
                 pval := tLabel(elementlist[i+1]).caption
               else
                 pval := sqlstring(tLabel(elementlist[i+1]).caption);
             end else if tComponent(elementlist[i+1]) is tDateTimePicker then begin
               pval := datetostr(tDateTimePicker(elementlist[i+1]).date);
             end else if tComponent(elementlist[i+1]) is tEdit then begin
               if abs(tEdit(elementlist[i+1]).tag) = 3 then
                 pval := tEdit(elementlist[i+1]).text
               else
                 pval := sqlstring(tEdit(elementlist[i+1]).text);
             end else if tComponent(elementlist[i+1]) is tComboBox then begin
               if tComboBox(elementlist[i+1]).itemindex = -1 then
                 pval := #1#2
               else
                 pval := sqlstring(tComboBox(elementlist[i+1]).items[tComboBox(elementlist[i+1]).itemindex]);
             end else
               pVal := #1#2;
             if pVal <> #1#2 then
               qry := copy(qry,1,p-1)+pval+copy(qry,p+1+length(tlabel(elementlist[i]).caption),length(qry));
             end;
        end;//while
      end;
    if pos('@',qry)>0 then begin
      while pos('=',qry)>0 do qry[pos('=',qry)]:=' ';
      while pos('<',qry)>0 do qry[pos('<',qry)]:=' ';
      while pos('>',qry)>0 do qry[pos('>',qry)]:=' ';
      while pos(')',qry)>0 do qry[pos(')',qry)]:=' ';
      while pos('+',qry)>0 do qry[pos('+',qry)]:=' ';
      while pos('/',qry)>0 do qry[pos('/',qry)]:=' ';
      while pos('-',qry)>0 do qry[pos('-',qry)]:=' ';
      while pos('*',qry)>0 do qry[pos('*',qry)]:=' ';
      qry := qry + ' ';
      pval := '';
      while pos('@',qry)>0 do begin
        delete(qry,1,pos('@',qry));
        pval := pval + copy(qry,1,pos(' ',qry)) + ', ';
      end;
      pval := copy(pval,1,length(pval)-2);
      messagedlg('Can''t define this drop down list.  The following parameters need to be defined:'+chr(13)+pval,mterror,[mbok],0);
      tComboBox(sender).ParentFont := false;
      qry := '@';
    end;//for
  end;//if
  if qry <> '@' then
    with qrySQL do begin
      close;
      sql.clear;
      sql.add(qry);
      open;
      tComboBox(sender).width := fieldbyname('strParamList').displaywidth * tComboBox(sender).font.size + 50;
      while not eof do begin
        tComboBox(sender).items.add(fieldbyname('strParamList').asstring);
        next;
      end;
      close;
    end;
end;

procedure TfrmReportManager.ScrlBoxParamsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if BadDate then begin
    BadDate := false;
    EditExitDate(activecontrol);
  end;
end;


procedure TfrmReportManager.ToolBar1DblClick(Sender: TObject);
var s : string;
    i : integer;
begin
  s := 'Environment: '+envname + #13 +
       'UserID: '+getuser() + #13 +
       'Command Line: ';
  if pcount>0 then
    for i := 1 to pcount do
      s := s + paramstr(i) + ' ';
  messagedlg(s, mtinformation,[mbok],0);
end;

procedure TfrmReportManager.FormShow(Sender: TObject);
begin
  if AutoCreate <> acNoAutoCreate then
    close;
end;

procedure TfrmReportManager.DateTimePickerChange(Sender: TObject);
begin
  tDateTimePicker(sender).tag := abs(tDateTimePicker(sender).tag);
  run1.Enabled := CheckParams;
  btnRun.Enabled := run1.enabled;
  btnExcel.enabled := btnRun.enabled;
  btnText.enabled := btnRun.enabled;
  LastRun := -1;
  BadDate := false;
end;

procedure TfrmReportManager.DateTimePickerExit(Sender: TObject);
begin
  tDateTimePicker(sender).tag := abs(tDateTimePicker(sender).tag);
  run1.Enabled := CheckParams;
  btnRun.Enabled := run1.enabled;
  btnExcel.enabled := btnRun.enabled;
  btnText.enabled := btnRun.enabled;
  LastRun := -1;
  BadDate := false;
end;

end.

