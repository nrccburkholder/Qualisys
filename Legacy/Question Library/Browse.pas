unit Browse;

{*******************************************************************************
Description: main form, used for viewing and finding questions, and accessing all funcitonality

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
11-17-2005  GN01     Added Program Version info

12-20-2006  GN02     Some admin functionality

*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Mask, DBCtrls, DBCGrids, ExtCtrls, ComCtrls, Grids,
  DBGrids, Buttons, DB, Wwfltdlg, dbtables;

type
  TfrmLibrary = class(TForm)
    menLibrary: TMainMenu;
    mniFile: TMenuItem;
    mniExit: TMenuItem;
    mniReports: TMenuItem;
    mniNavigate: TMenuItem;
    mniSearch: TMenuItem;
    mniSort: TMenuItem;
    staLibrary: TStatusBar;
    panTools: TPanel;
    dgrLibrary: TDBGrid;
    mniOptions: TMenuItem;
    mniHints: TMenuItem;
    btnCategory: TSpeedButton;
    btnRecode: TSpeedButton;
    btnFollowed: TSpeedButton;
    btnPreceded: TSpeedButton;
    btnFind: TSpeedButton;
    btnSort: TSpeedButton;
    btnEdit: TSpeedButton;
    btnNew: TSpeedButton;
    btnReplicate: TSpeedButton;
    btnDelete: TSpeedButton;
    mniTasks: TMenuItem;
    mniQuestion: TMenuItem;
    mniScale: TMenuItem;
    mniRecode: TMenuItem;
    mniCategory: TMenuItem;
    mniUsage: TMenuItem;
    btnUsage: TSpeedButton;
    btnFilter: TSpeedButton;
    mniFilter: TMenuItem;
    mniCodes: TMenuItem;
    btnRelated: TSpeedButton;
    btnTrans: TSpeedButton;
    btnScale: TSpeedButton;
    mniTranslate: TMenuItem;
    mniRelated: TMenuItem;
    btnEditRecode: TSpeedButton;
    N3: TMenuItem;
    Bevel1: TBevel;
    mniEdit: TMenuItem;
    mniEdit2: TMenuItem;
    mniNew: TMenuItem;
    mniCopy: TMenuItem;
    mniDelete: TMenuItem;
    N6: TMenuItem;
    mniFirst: TMenuItem;
    mniPrior: TMenuItem;
    mniNext: TMenuItem;
    mniLast: TMenuItem;
    N7: TMenuItem;
    mniPreced: TMenuItem;
    mniFollow: TMenuItem;
    mniHeading: TMenuItem;
    N8: TMenuItem;
    N1: TMenuItem;
    mniMap: TMenuItem;
    btnHeading: TSpeedButton;
    btnCode: TSpeedButton;
    wdlgFilter: TwwFilterDialog;
    Find1: TMenuItem;
    mniBuild: TMenuItem;
    rtfWords: TRichEdit;
    mniOpenBuild: TMenuItem;
    btnFindPrior: TSpeedButton;
    btnFindNext: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    Duplicate1: TMenuItem;
    Sort1: TMenuItem;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    Translate1: TMenuItem;
    editCurrentClient: TEdit;
    Personalization1: TMenuItem;
    Recodeinto1: TMenuItem;
    ReloadTemplateUsage1: TMenuItem;
    AutoCloseTimer: TTimer;
    UpdateProblemScores1: TMenuItem;
    mniImportScaleRanking: TMenuItem;
    mniAdmin: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure UsageClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure RecodeClick(Sender: TObject);
    procedure GoToQuestion(Sender: TObject);
    procedure CategoryClick(Sender: TObject);
    procedure HintsClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ReplicateClick(Sender: TObject);
    procedure RelatedClick(Sender: TObject);
    procedure ScaleClick(Sender: TObject);
    procedure TransClick(Sender: TObject);
    procedure EditRecodeClick(Sender: TObject);
    procedure CodesClick(Sender: TObject);
    procedure SortClick(Sender: TObject);
    procedure HeadingClick(Sender: TObject);
    procedure FirstClick(Sender: TObject);
    procedure PriorClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure LastClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure TasksClick(Sender: TObject);
    procedure NavigateClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FindClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure FilterInitDialog(Dialog: TwwFilterDlg);
    procedure PrecedClick(Sender: TObject);
    procedure FollowClick(Sender: TObject);
    procedure LanguageClick(Sender: TObject);
    procedure BrowseGridButtonClick(Sender: TObject);
    procedure LibraryDblClick(Sender: TObject);
    procedure BuildClick(Sender: TObject);
    procedure WordsProtectChange(Sender: TObject; StartPos, EndPos: Integer; var AllowChange: Boolean);
    procedure OpenBuildClick(Sender: TObject);
    procedure UpClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    procedure Sort1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Personalization1Click(Sender: TObject);
    procedure Recodeinto1Click(Sender: TObject);
    procedure mniSearchClick(Sender: TObject);
    procedure staLibraryDblClick(Sender: TObject);
    procedure ReloadTemplateUsage1Click(Sender: TObject);
    procedure AutoCloseTimerTimer(Sender: TObject);
    procedure dgrLibraryCellClick(Column: TColumn);
    procedure mniFileClick(Sender: TObject);
    procedure mniReportsClick(Sender: TObject);
    procedure mniOptionsClick(Sender: TObject);
    procedure UpdateProblemScores1Click(Sender: TObject);
    procedure mniImportScaleRankingClick(Sender: TObject);
    {procedure mniAdminClick(Sender: TObject);}
  private
    vOrigin, vRecode : TBookmarkStr;
    FinalCountdown : boolean;
    procedure BrowseHint(Sender: TObject);
    procedure EnableButtons( vEnable : Boolean );
    function IncDescription( vStr : string ) : string;
    procedure Replicate;
    procedure SyncQuestion;
    procedure ResetAutoCloseTimer;
  public
    procedure SetGoToButtons( vHasPreceding, vHasFollowing : Boolean );
    procedure StartRecode;
  end;

var
  frmLibrary : TfrmLibrary;

implementation

uses Data, Usage, Recode, Related, Edit, EditCode, Code, Sort, Category,
  Translation, Heading, Common, Lookup, PersRpt,
  NewScale, fViewData, FileUtil{, uAdmin};

 
{$R *.DFM}

{ INITIALIZATION }

procedure TfrmLibrary.FormCreate(Sender: TObject);
var
   sVer : string;
begin
  frmLibrary.windowState := wsMaximized;
  Application.OnHint := BrowseHint;
  FinalCountDown := false;
  mniAdmin.Visible := False;  //GN02
  mniImportScaleRanking.Visible := False;
  if modLibrary.userrights=urTranslator then begin
    frmLibrary.Caption := 'National Research Corporation''s QualPro Question Library - Translator version';
    dgrLibrary.OnDblClick := TransClick;
    Recodeinto1.enabled := false;
    Edit1.Enabled := false;
    Insert1.enabled := false;
    Duplicate1.enabled := false;
    Delete1.enabled := false;
    mniEdit.enabled := false;
    mniHeading.enabled := false;
    mniQuestion.enabled := false;
    mniScale.enabled := false;
    mniRecode.enabled := false;
    mniCategory.enabled := false;
    mniUsage.enabled := false;
    mniRelated.enabled := false;
    btnEdit.enabled := false;
    btnNew.enabled := false;
    btnReplicate.enabled := false;
    btnDelete.enabled := false;
    btnRecode.enabled := false;
    btnEditRecode.enabled := false;
    btnHeading.enabled := false;
    btnScale.enabled := false;
    btnCategory.enabled := false;
    btnRelated.enabled := false;
    btnUsage.enabled := false;
  end;
  GetFileVersion(Application.ExeName, sVer); //GN01
  staLibrary.Panels.Items[3].Text := sVer;
end;

procedure TfrmLibrary.BrowseHint(Sender: TObject);
begin
  staLibrary.Panels.Items[ 2 ].Text := Application.Hint;
end;

{ ACTIVATION }

{ configures tables to function with form }

procedure TfrmLibrary.FormActivate(Sender: TObject);
begin
  with modLibrary do
  begin
    EnableButtons( wtblQuestion.RecordCount > 0 );
    wsrcQuestion.OnDataChange := QuestionMainDataChange;
    wtblQuestion.Refresh; { ?? }
  end;
end;

procedure TfrmLibrary.EnableButtons( vEnable : Boolean );
begin
  if modLibrary.userrights <> urTranslator then begin
    btnEdit.Enabled := vEnable;
    btnNew.Enabled := vEnable;
    btnReplicate.Enabled := vEnable;
    btnRecode.Enabled := vEnable;
    btnRelated.Enabled := vEnable;
  end;
  btnTrans.Enabled := vEnable;
end;

{ GENERAL METHODS }

{ controls GoTo (preced and follow) button behavior (called by QuestionDataChange)
    1. changes hint for down state
    2. enables if has question to go to }

procedure TfrmLibrary.SetGoToButtons( vHasPreceding, vHasFollowing : Boolean );
begin
  if btnPreceded.Down then
  begin
    btnPreceded.Hint := 'Go To Preceding|Moves to the question which always preceds the current question';
    btnPreceded.Down := False;
  end;
  if btnFollowed.Down then
  begin
    btnFollowed.Hint := 'Go To Following|Moves to the question which always follows the current question';
    btnFollowed.Down := False;
  end;
  btnPreceded.Enabled := not vHasPreceding;
  btnFollowed.Enabled := not vHasFollowing;
end;

{ MENU INITIALIZATION }

procedure TfrmLibrary.EditMenuClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  mniEdit2.Enabled := btnEdit.Enabled;
  mniCopy.Enabled := btnReplicate.Enabled;
  mniDelete.Enabled := btnDelete.Enabled;
  mniPreced.Enabled := btnPreceded.Enabled;
  mniFollow.Enabled := btnFollowed.Enabled;
  mniMap.Enabled := btnRecode.Enabled;
end;

procedure TfrmLibrary.TasksClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  mniQuestion.Enabled := btnEdit.Enabled;
  mniRecode.Enabled := btnEditRecode.Enabled;
  mniTranslate.Enabled := btnTrans.Enabled;
  mniUsage.Enabled := btnUsage.Enabled;
  mniRelated.Enabled := btnRelated.Enabled;
end;

procedure TfrmLibrary.NavigateClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  with modLibrary.wtblQuestion do
  begin
    mniFirst.Enabled := not BOF;
    mniPrior.Enabled := not BOF;
    mniNext.Enabled := not EOF;
    mniLast.Enabled := not EOF;
  end;
end;

{ BUTTON METHODS }

{ opens question editing dialog, first moves to found question if needed }

procedure TfrmLibrary.EditClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      if btnFind.Down then SyncQuestion;
      frmEdit := TfrmEdit.Create( Self );
      with frmEdit do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens question editing dialog with a new question inserted }

procedure TfrmLibrary.NewClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      modLibrary.wtblQuestion.Append;
      frmEdit := TfrmEdit.Create( Self );
      with frmEdit do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
      if not btnEdit.Enabled then EnableButtons( True );
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens question editing with a duplicate of the previous question }

procedure TfrmLibrary.ReplicateClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      Replicate;
      frmEdit := TfrmEdit.Create( Self );
      with frmEdit do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ REPLICATION }

{ gets a value from end of the description field (vStr) and returns it as an integer
     called by IncDescription }

function ExtractVal( vStr : string ) : Integer;
var
  vLeft, vRight : Word;
  vCode, vVal : Integer;
begin
  vLeft := Pos( '«', vStr );
  vRight := Pos( '»', vStr );
  Val( Copy( vStr, Succ( vLeft ), Pred( vRight - vLeft )), vVal, vCode );
  if vCode <> 0 then vVal := 1;
  Result := vVal;
end;

{ creates or increments the number at the end of the description field (vStr)
    called by ReplicateClick}

function TfrmLibrary.IncDescription( vStr : string ) : string;
var
  vVal, vTest : Integer;
begin
  if Pos( '«', vStr ) > 0 then
  begin
    vVal := ExtractVal( vStr );
    vStr := Copy( vStr, 1, Pos( '«', vStr ));
  end
  else
  begin
    vVal := 1;
    vStr := vStr + '«';
  end;
  with modLookup.tblQuestion do
  begin
    IndexName := 'ByDescription';
    SetRange( [ vStr ], [ vStr + 'a' ] );  // limit to question starting with same description
    while not EOF do
    begin
      vTest := ExtractVal( FieldByName( 'Description' ).Value );
      if vVal < vTest then vVal := vTest;
      Next;
    end;
    CancelRange;
    IndexName := '';
    Inc( vVal );
  end;
  Result := vStr + IntToStr( vVal ) + '»';
end;

{ duplicates an existing question as a new question, with some updates
    1. copy existing question to new, updated core, user, date, and description
          note: does not include recodes
    2. copy question text (in various languages) with updated reveiw and fielded
    3. opens the question edit dialog }

procedure TfrmLibrary.Replicate;
var
  i : Integer;
  vText : string;
begin
  with modLibrary do begin
    vText := wtblQuestionDescription.Value;
    GenerateCore( modLookup.tblQuestion );
    modLookup.tblQuestion.AppendRecord(
      [ vNewCore,
        IncDescription( vText ),
        0,
        wtblQuestionScale.Value,
        wtblQuestionShort.Value,
        wtblQuestionHeadID.Value,
        wtblQuestionFollowedBy.Value,
        wtblQuestionPrecededBy.Value,
        GetUser,
        nil,
        Null,
        Null,
        wtblQuestionServID.Value,
        wtblQuestionThemID.Value,
        wtblQuestionRestrict.Value,
        wtblQuestionTested.value,
        'Duplicate of ' + wtblQuestionCore.asString+#13+
          wtblQuestionNotes.value,
        wtblQuestionLevel.value ]);
    with wtblQstnText do begin
      DisableControls;
      for i := 1 to RecordCount do begin
        //wtblQstnTextText.savetofile('c:\QstnText.dbg');
        if wtblQstnTextLangID.Value = 1 then
          modLookup.tblQstnText.AppendRecord(
            [ vNewCore,
              wtblQstnTextLangID.Value,
              wtblQstnTextText.value,
              True ]);
        //modLookup.tblQstnTextText.loadfromfile('c:\QstnText.dbg');
        Next;
      end;
      EnableControls;
    end;
    wtblQuestion.Last;
  end;
end;

procedure TfrmLibrary.DeleteClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    modLibrary.DeleteQuestion;
    if modLibrary.wtblQuestion.RecordCount = 0 then EnableButtons( False );
  end;
end;

procedure TfrmLibrary.SortClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  Screen.Cursor := crHourGlass;
  try
    frmSort := TfrmSort.Create( Self );
    with frmSort do
    try
      wwTable := modlibrary.wtblQuestion;
      ShowModal;
      if cmbSort.Text = 'DefaultIndex' then
        staLibrary.Panels[ 1 ].Text := 'ByCore'
      else
        staLibrary.Panels[ 1 ].Text := cmbSort.Text;
      modlibrary.wtblQuestion.indexname := wwTable.indexname;  
    finally
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ moves to the preceding or following question of current question }

procedure TfrmLibrary.GoToQuestion(Sender: TObject);
var
  btnActive : TSpeedButton;
begin
  with modLibrary do
  begin
    btnActive := Sender as TSpeedButton;
    if btnActive.Down then
    begin
      btnActive.Down := False;
      vOrigin := wtblQuestion.Bookmark;
      if btnActive = btnPreceded then
        wtblQuestion.Locate( 'Core', wtblQuestionPrecededBy.Value, [ ] )
      else
        wtblQuestion.Locate( 'Core', wtblQuestionFollowedBy.Value, [ ] );
      btnActive.Down := True;
      btnActive.Hint := 'Go Back|Returns to the question previously selected';
      btnActive.Enabled := True;
    end
    else
    begin
      wtblQuestion.Bookmark := vOrigin;
      if btnActive = btnPreceded then
        btnPreceded.Hint := 'Preceding|Moves to the question which always preceds the current question'
      else
        btnFollowed.Hint := 'Following|Moves to the question which always follows the current question';
    end;
  end;
end;

{ starts the recoding process:
    1. if recode already exists for current question, display recode dialog
    2. otherwise allows user to select a second to recode the current question to
         (rest of code executes from the datasource datachange event) }

procedure TfrmLibrary.RecodeClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    if Sender is TMenuItem then btnRecode.Down := not btnRecode.Down;
    if btnRecode.Down then begin
      if MessageDlg( 'Right-click on a second question into which to recode the currently '
          + 'selected question', mtInformation, mbOKCancel, 0 ) = mrOK then begin
        vRecode := modLibrary.wtblQuestion.Bookmark;
        btnRecode.Hint := 'Cancel Recode|Exits recode mode and returns to normal browse mode';
      end else begin
        btnRecode.Hint := 'Create Recode|Map one response scale to another in the recode dialog box';
        btnRecode.Down := False;
      end;
    end else
      btnRecode.Hint := 'Create Recode|Map one response scale to another in the recode dialog box';
  end;
end;

{ initializes recode process and opens the recode dialog (called in question OnDataChange) }

procedure TfrmLibrary.StartRecode;
var
  vTarget : integer;
  vfind,vContinuous1,vContinuous2:boolean;
begin
  {DG -> }
  btnRecode.Down := False;
  with modlibrary do begin
    vTarget := wtblQuestionCore.Value;
    tblvalues.filter := 'Type=2';
    tblvalues.filtered := true;
    vFind := tblScale.Findkey([wtblQuestionScale.Value]);
    vContinuous1 := (tblvaluesType.value = stICR);
    wtblQuestion.Bookmark := vRecode;
    vFind := (vFind) and (tblScale.Findkey([wtblQuestionScale.Value]));
    vContinuous2 := (tblvaluesType.value = stICR);
    tblValues.filtered := false;
    tblvalues.filter := '';
  end;
  if (not vFind) or (vContinuous1 or vContinuous2) {either question has a continuous scale} then
    if not vFind then
      MessageDlg('The scale for one of the questions couldn''t be found'+
        ' in the Scales table.  Contact Tech Support.', mtError, [ mbOK ], 0 )
    else
      MessageDlg('Questions with continuous scales cannot be involved '
        +'in recodes at this time.', mtWarning, [ mbOK ], 0 )
  else begin
  {<- DG}
    Screen.Cursor := crHourGlass;
    try
      btnRecode.Down := False;
      with modLibrary do begin
        {vTarget := wtblQuestionCore.Value;
        wtblQuestion.Bookmark := vRecode;   DG}
        wtblRecode.AppendRecord([ nil, vTarget ]); { post }
      end;
      frmRecode := TfrmRecode.Create( Self );
      with frmRecode do
      try
        vEditing := True;
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the recode dialog }

procedure TfrmLibrary.EditRecodeClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      frmRecode := TfrmRecode.Create( Self );
      with frmRecode do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the Usage dialog }

procedure TfrmLibrary.UsageClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      if btnFind.Down then SyncQuestion;
      frmUsage := TfrmUsage.Create( Self );
      with frmUsage do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the service and theme dialog }

procedure TfrmLibrary.CategoryClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      frmCategory := TfrmCategory.Create( Self );
      with frmCategory do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the related questions dialog }

procedure TfrmLibrary.RelatedClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      frmRelated := TfrmRelated.Create( Self );
      with frmRelated do
      try
        ShowModal;
      finally
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the heading dialog }

procedure TfrmLibrary.HeadingClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      frmHeading := TfrmHeading.Create( Self );
      with frmHeading do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the Scale dialog }

procedure TfrmLibrary.ScaleClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  if modLibrary.userrights <> urTranslator then begin
    Screen.Cursor := crHourGlass;
    try
      frmNewScale := TfrmNewScale.Create( Self );
      with frmNewScale do
      try
        ShowModal;
      finally
        Application.OnHint := BrowseHint;
        Release;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

{ opens the translation dialog }

procedure TfrmLibrary.TransClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  Screen.Cursor := crHourGlass;
  try
    frmTranslate := TfrmTranslate.Create( Self );
    with frmTranslate do
    try
      ShowModal;
    finally
      Application.OnHint := BrowseHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ opens the code editing dialog }

procedure TfrmLibrary.CodesClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  Screen.Cursor := crHourGlass;
  try
    frmCodeEdit := TfrmCodeEdit.Create( Self );
    with frmCodeEdit do
    try
      { GoToCode }
      ShowModal;
    finally
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ searchs back to find question matching criteria }

procedure TfrmLibrary.UpClick( Sender: TObject );
begin
{  with modSearch.tblMatch do
    if BOF then
      btnFindPrior.Enabled := False
    else begin
      Prior;
      SyncQuestion;
      btnFindNext.Enabled := True;
    end;
}
end;

{ searchs forwaard to find questions matching criteria }

procedure TfrmLibrary.DownClick(Sender: TObject);
begin
{  with modSearch.tblMatch do
    if EOF then
      btnFindNext.Enabled := False
    else
    begin
      Next;
      SyncQuestion;
      btnFindPrior.Enabled := True;
    end;
}
end;

{ moves to a question matching the search criteria }

procedure TfrmLibrary.SyncQuestion;
begin
//  modLibrary.wtblQuestion.Locate( 'Core', modSearch.tblMatch.FieldByName( 'Core' ).Value, [ ] );
end;

procedure TfrmLibrary.ExitClick(Sender: TObject);
begin
  Close;
end;

{ MENU ROUTINES }

    { navigation }

procedure TfrmLibrary.FindClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
{
  if btnFind.Down then begin
    Screen.Cursor := crHourGlass;
    try
      frmFind := TfrmFind.Create( Self );
      frmFind.Show;
      btnFindPrior.Enabled := False;
      btnFindNext.Enabled := False;
    finally
      Screen.Cursor := crDefault;
    end;
  end else
    frmFind.Close;
}
end;

procedure TfrmLibrary.FilterClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
  with wdlgFilter do
    if Execute then
    begin
      if FieldInfo.Count > 0 then
        staLibrary.Panels[ 0 ].Text := 'Filtered'
      else
        staLibrary.Panels[ 0 ].Text := 'No Filter';
    end;
end;

procedure TfrmLibrary.FilterInitDialog(Dialog: TwwFilterDlg);
begin
  Dialog.Font.Style := [ ];
end;

procedure TfrmLibrary.FirstClick(Sender: TObject);
begin
  modLibrary.wtblQuestion.First;
end;

procedure TfrmLibrary.PriorClick(Sender: TObject);
begin
  modLibrary.wtblQuestion.Prior;
end;

procedure TfrmLibrary.NextClick(Sender: TObject);
begin
  modLibrary.wtblQuestion.Next;
end;

procedure TfrmLibrary.LastClick(Sender: TObject);
begin
  modLibrary.wtblQuestion.Last;
end;

    { editing }

procedure TfrmLibrary.PrecedClick(Sender: TObject);
begin
  btnPreceded.Down := not btnPreceded.Down;
  GoToQuestion( btnPreceded );
end;

procedure TfrmLibrary.FollowClick(Sender: TObject);
begin
  btnFollowed.Down := not btnFollowed.Down;
  GoToQuestion( btnFollowed );
end;

    { options }

{ determines if will build word table on opening the find dialog }

procedure TfrmLibrary.OpenBuildClick(Sender: TObject);
begin
  mniOpenBuild.Checked := not mniOpenBuild.Checked;
end;

{ builds the word table for later searching }

procedure TfrmLibrary.BuildClick(Sender: TObject);
begin
{  Screen.Cursor := crHourGlass;
  try
    with modLookup.tblQstnText do begin
      Filtered := False;
      try
        modSearch.rubMake.Execute;
      finally
        Filtered := True;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
}
end;

procedure TfrmLibrary.HintsClick(Sender: TObject);
begin
  mniHints.Checked := not mniHints.Checked;
  Application.ShowHint := mniHints.Checked;
end;

procedure TfrmLibrary.LanguageClick(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    vTranslate := Tag;
    Checked := True;
  end;
end;

{ COMPONENT HANDLERS }

procedure TfrmLibrary.WordsProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  AllowChange := True;
end;

procedure TfrmLibrary.BrowseGridButtonClick(Sender: TObject);
begin
  { go to first instance of review = true for question }
end;

procedure TfrmLibrary.LibraryDblClick(Sender: TObject);
begin

end;

{ FINALIZATION }

{ close all tables }

procedure TfrmLibrary.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Screen.Cursor := crHourGlass;
    try
      modLibrary.UpdateDataMartProblemScores;
      modLookup.dbQstnLib.Connected := False;
      modLibrary.dbSurvey.Connected := False;
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TfrmLibrary.Sort1Click(Sender: TObject);
begin
  with modlibrary.wtblquestion, dgrlibrary.selectedfield do begin
    if fieldname = 'Description' then begin
      indexname := 'ByDescription';
    end else if fieldname = 'Core' then begin
      indexname := '';
    end else if fieldname = 'Label' then begin
      indexname := 'ByScale';
    end else if fieldname = 'Follow' then begin
      indexname := 'ByFollowing';
    end else if fieldname = 'AddedOn' then begin
      indexname := 'ByAddDate';
    end else if fieldname = 'Short' then begin
      indexname := 'ByReportText';
    end else if fieldname = 'Theme' then begin
      indexname := 'ByTheme';
    end else if fieldname = 'Service' then begin
      indexname := 'ByService';
    end else if fieldname = 'Heading' then begin
      indexname := 'ByHeading';
    end else if fieldname = 'Preced' then begin
      indexname := 'ByPreceding';
    end else if fieldname = 'Follow' then begin
      indexname := 'ByFollowing';
    end;
    if fieldname = 'Core' then
      staLibrary.Panels[ 1 ].Text := 'ByCore'
    else
      staLibrary.Panels[ 1 ].Text := indexname;
  end;
end;

procedure TfrmLibrary.PopupMenu1Popup(Sender: TObject);
begin
  ResetAutoCloseTimer;
  sort1.enabled :=
      pos(dgrlibrary.selectedfield.fieldname,'Fielded,Review,Usage,'+
      'Restrict,AddedBy,ModifiedBy,ModifiedOn')=0;
  RecodeInto1.visible := btnRecode.down;
  delete1.enabled := btndelete.enabled;
end;

procedure TfrmLibrary.Personalization1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmPersRpt := TfrmPersRpt.Create( Self );
    with frmPersRpt do
    try
      ShowModal;
    finally
      Application.OnHint := BrowseHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmLibrary.Recodeinto1Click(Sender: TObject);
begin
  StartRecode;
end;

procedure TfrmLibrary.mniSearchClick(Sender: TObject);
begin
//  btnFind.Down := true;
//  FindClick(Sender);
end;

procedure TfrmLibrary.staLibraryDblClick(Sender: TObject);
begin
  staLibrary.Panels[2].text := 'Environment: '+modlibrary.envname+'  Net File Directory: '+session.netfiledir;
end;

procedure TfrmLibrary.ReloadTemplateUsage1Click(Sender: TObject);
var orgdb : string;

  procedure parsedirs(fn:string);
    procedure GetTemplateUsage(dirname:string);
    var sr:tSearchRec;
        s : string;
    begin
      dirname := extractfiledir(dirname);
      if dirname[length(dirname)] <> '\' then dirname := dirname + '\';
      modlibrary.ww_Query.databasename := dirname;
      s := dirname;
      delete(s,1,length(modlibrary.basedir));
      if findfirst(dirName+'*.db', faAnyfile, SR) = 0 then
        repeat
          try
            if modLibrary.SurveyDB(dirname+sr.name) then
              with modlibrary.ww_Query do begin
                staLibrary.Panels[2].text := 'Loading '+s+sr.name;
                sql.clear;
                sql.add('select distinct miscint1 from '''+sr.name+''' where X=1 and type=''Question''');
                open;
                while not eof do begin
                  modlibrary.t_TemplateUsage.AppendRecord([nil,fieldbyname('MiscInt1').value,s+sr.name,'(template)']);
                  next;
                end;
                close;
              end;
          except
            frmViewData.memo1.lines.add('Can''t process ' + dirname+sr.name);
          end;
        until findnext(sr)<>0;
      FindClose(SR);
    end;

  var sr:tSearchRec;
  begin
    screen.cursor := crHourglass;
    staLibrary.Panels[2].text := 'Searching '+fn;
    fn := extractfiledir(fn);
    if fn[length(fn)] <> '\' then fn := fn + '\';
    gettemplateusage(fn+'*.db');
    if findfirst(fn+'*.*', faDirectory, SR) = 0 then
      repeat
        if ((sr.attr=faDirectory) or (sr.attr=48)) and (sr.name <> '.') and (sr.name <> '..') then
          parsedirs(fn+sr.name+'\*.*');
      until (findnext(sr)<>0);
    FindClose(SR);
  end;

begin
  if modlibrary.basedir <> '' then begin
   try
    screen.cursor := crHourglass;
    orgDB := modlibrary.ww_Query.databasename;
    staLibrary.Panels[2].text := 'Clearing TemplateUsage.db';
    modlibrary.t_templateusage.close;
    with tTable.create(self) do
      try
        DatabaseName := 'QstnLib';
        TableType := ttParadox;
        TableName := 'TemplateUsage.db';
        with fielddefs do begin
          clear;
          add('Usage_id',ftAutoInc,0,false);
          add('QstnCore',ftinteger,0,false);
          add('Client',ftString,50,false);
          add('Study',ftString,50,false);
          add('Survey',ftString,50,false);
        end;
        with indexdefs do begin
          clear;
          add('Usage_id','Usage_id',[ixprimary]);
          add('QstnCore','QstnCore',[]);
        end;
        CreateTable;
      finally
        free;
      end;
    with modlibrary, ww_Query do begin
      close;
      databasename := 'dbQualPro';
      staLibrary.Panels[2].text := 'Loading survey data from SQL';
      sql.clear;
      sql.add('select c.strClient_nm as Client, s.strStudy_nm as Study, sd.strSurvey_nm as Survey, sq.QstnCore');
      sql.add('from sel_qstns sq, survey_def sd, study s, client c');
      sql.add('where sq.subtype=1 and sq.survey_id=sd.survey_id');
      sql.add(' and sd.study_id=s.study_id and s.client_id=c.client_id');
      open;
      t_templateUsage.Open;
      while not eof do begin
        t_TemplateUsage.appendRecord([nil,
        fieldbyname('QstnCore').value,
        fieldbyname('Client').asstring,
        fieldbyname('Study').asstring,
        fieldbyname('Survey').asstring]);
        next;
      end;
      close;
    end;

    frmViewData := TfrmViewData.Create( Self );
    try
      frmViewData.memo1.lines.clear;
      frmViewData.dbgrid1.visible := false;
      frmViewData.Caption := 'Reload Template Usage';
      ParseDirs(modlibrary.basedir+'*.*');
      if frmViewData.memo1.lines.count>0 then
        frmViewData.showmodal;
    finally
      frmViewData.release;
    end;
    modlibrary.ww_Query.databasename := orgDB;
    modlibrary.t_templateUsage.close;
   finally
    screen.cursor := crDefault;
    staLibrary.Panels[2].text := '';
   end;
  end else
    Messagedlg('TemplateBaseDir not defined in user table.',mterror,[mbok],0);
end;

procedure TfrmLibrary.AutoCloseTimerTimer(Sender: TObject);
var OrgInterval : cardinal;
begin
  if FinalCountDown then
    application.Terminate
  else begin
    OrgInterval := AutoCloseTimer.Interval;
    FinalCountDown := true;
    AutoCloseTimer.Interval := 60000;
    messagedlg('Question Library will close in 60 seconds, unless you press the OK button.',mtinformation,[mbok],0);
    AutoCloseTimer.Interval := orgInterval;
    FinalCountDown := false;
  end;
end;

procedure TfrmLibrary.ResetAutoCloseTimer;
begin
  AutoCloseTimer.enabled:=false;
  AutoCloseTimer.enabled:=true;
end;

procedure TfrmLibrary.dgrLibraryCellClick(Column: TColumn);
begin
  ResetAutoCloseTimer;
end;

procedure TfrmLibrary.mniFileClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
end;

procedure TfrmLibrary.mniReportsClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
end;

procedure TfrmLibrary.mniOptionsClick(Sender: TObject);
begin
  ResetAutoCloseTimer;
end;

procedure TfrmLibrary.UpdateProblemScores1Click(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;
    try
      modLibrary.UpdateDataMartProblemScores;
    finally
      Screen.Cursor := crDefault;
    end;
end;



procedure TfrmLibrary.mniImportScaleRankingClick(Sender: TObject);
var
  InputString: string;
begin
    InputString := InputBox('Input Box', 'Please enter your password', '');

    if InputString = 'magic' then
    begin
       Screen.Cursor := crHourGlass;
       try
         modLibrary.ImportScaleRanking;
       finally
         Screen.Cursor := crDefault;
       end;
    end
    else
    begin
       MessageDlg('Sorry you do not have access to this functionality.', mtInformation, [mbOK],0);
    end;

end;

//GN02
{procedure TfrmLibrary.mniAdminClick(Sender: TObject);
begin
  // to do Language and users table
  frmAdmin := TfrmAdmin.Create(self);
  frmAdmin.ShowModal;
  frmAdmin.Free;


end;
 }
end.
