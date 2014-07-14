unit Heading;

{ dialog for creating, modifying, testing and deleting headings }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, ExtCtrls, Grids, DBGrids, StdCtrls, DBCtrls, Mask,
  DBTables, DB, DBRichEdit, CDK_Comp;

type
  TfrmHeading = class(TForm)
    staHeading: TStatusBar;
    Panel1: TPanel;
    btnClose: TSpeedButton;
    btnInsert: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnAdd: TSpeedButton;
    btnFind: TSpeedButton;
    btnSpell: TSpeedButton;
    btnCode: TSpeedButton;
    pclHeading: TPageControl;
    shtHeading: TTabSheet;
    shtDepend: TTabSheet;
    dgrHeading: TDBGrid;
    Label1: TLabel;
    detHeading: TDBEdit;
    chkFielded: TDBCheckBox;
    Label2: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    detDepend: TDBEdit;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBGrid1: TDBGrid;
    btnGoTo: TSpeedButton;
    chkReview: TDBCheckBox;
    Label5: TLabel;
    togHeading: TclCodeToggle;
    rtfText: TclDBRichCodeBtn;
    btnFirst: TSpeedButton;
    btnNext: TSpeedButton;
    btnReview: TSpeedButton;
    procedure CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure HeadingEnter(Sender: TObject);
    procedure HeadingExit(Sender: TObject);
    procedure InsertClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure SpellClick(Sender: TObject);
    procedure CodeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FirstClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure GoToClick(Sender: TObject);
    procedure RTFEnter(Sender: TObject);
    procedure RTFExit(Sender: TObject);
    procedure ReviewClick(Sender: TObject);
    procedure detHeadingChange(Sender: TObject);
  private
    procedure HeadingHint( Sender : TObject );
    procedure HeadIdle(Sender: TObject; var Done: Boolean);
    procedure SetTables;
  public

  end;

var
  frmHeading: TfrmHeading;

implementation

uses Data, Code, Common, Support, Lookup;

{$R *.DFM}

{ INITIALIZATION }

procedure TfrmHeading.FormCreate(Sender: TObject);
begin
  SetTables;
  Application.OnHint := HeadingHint;
  Application.OnIdle := HeadIdle;
  pclHeading.ActivePage := shtHeading;
  ActiveControl := detHeading;
end;

{ initializes tables to support the heading dialog }

procedure TfrmHeading.SetTables;
begin
  with modLibrary do
  begin
    tblHeading.MasterSource := nil;
    tblHeading.Refresh;
    with modLookup.tblQuestion do
    begin
      IndexName := 'ByHeading';
      MasterSource := srcHeading;
      MasterFields := 'HeadID';
    end;
  end;
end;

procedure TfrmHeading.HeadingHint( Sender : TObject );
begin
  staHeading.SimpleText := Application.Hint;
end;

{ maintains button states and disallows editing of fielded headings }

procedure TfrmHeading.HeadIdle(Sender: TObject; var Done: Boolean);
begin
  with modLibrary do
  begin
    btnCancel.Enabled := ( tblHeading.State <> dsBrowse ) or ( wtblHeadText.State <> dsBrowse );
    btnAdd.Enabled := btnCancel.Enabled;
    btnDelete.Enabled := (pclHeading.ActivePage = shtHeading);//( not chkFielded.Checked ) and ( tblHeading.RecordCount > 0 );
    btnCode.Enabled := not chkFielded.Checked;
    srcHeading.AutoEdit := tblHeadingFielded.Value = 0;   { on scroll?? }
    wsrcHeadText.AutoEdit := tblHeadingFielded.Value = 0;
  end;
end;

{ PAGE/TAB }

{ maintains button states and focus when changing page/tab }

procedure TfrmHeading.PageChange(Sender: TObject);
begin
  if pclHeading.ActivePage = shtHeading then
  begin
    btnGoTo.Enabled := False;
    btnInsert.Enabled := True;
    togHeading.Enabled := True;
    detHeading.SetFocus;
    btnDelete.Enabled := true; //( not chkFielded.Checked ) and ( tblHeading.RecordCount > 0 );
    btnSpell.Enabled := True;
  end
  else
  begin
    btnGoTo.Enabled := ( modLookup.tblQuestion.RecordCount <> 0 );
    btnInsert.Enabled := False;
    togHeading.Enabled := False;
    btnSpell.Enabled := False;
    btnCode.Enabled := False;
    btnDelete.Enabled := False;
    detDepend.SetFocus;
  end;
end;

{ COMPONENT HANDLERS }

procedure TfrmHeading.HeadingEnter(Sender: TObject);
begin
  staHeading.SimpleText := 'Click on "Save" to add the edited Heading to the Library';
end;

procedure TfrmHeading.HeadingExit(Sender: TObject);
begin
  staHeading.SimpleText := '';
  modLibrary.tblHeading.Refresh;
end;

{ UpdateInsertBtn enables the insert button on the Insert Code dialog (if it is open) when
  the focus is in a control that can accept code insertions (RichEdits) }

procedure TfrmHeading.RTFEnter(Sender: TObject);
begin
  modLibrary.UpdateInsertBtn( True );
end;

procedure TfrmHeading.RTFExit(Sender: TObject);
begin
  modLibrary.UpdateInsertBtn ( False );
end;

{ BUTTON METHODS }

procedure TfrmHeading.InsertClick(Sender: TObject);
begin
  detHeading.SetFocus;
  with modLibrary do begin
    tblHeading.Insert;
    tblHeadingReview.value := false;
    chkReview.State := cbUnchecked;
    tblHeadingFielded.value := 0;
  end;
end;

procedure TfrmHeading.CancelClick(Sender: TObject);
begin
  with modLibrary do
  begin
    with tblHeading do if State <> dsBrowse then Cancel;
    with wtblHeadText do if State <> dsBrowse then Cancel;
  end;
  btnCancel.Enabled := False;
end;

procedure TfrmHeading.DeleteClick(Sender: TObject);
var reallydoit:boolean;
begin
  with modlibrary do begin
    if not modLookup.tblQuestion.Locate( 'HeadID', tblHeadingHeadID.value, [ ] ) then begin
      if tblHeadingFielded.value <> 0 then begin
        tblHeading.edit;
        tblHeadingFielded.value := 0;
        tblHeading.post;
      end;
      reallydoit := (messagedlg('Do you really want to delete this heading?',mtconfirmation,[mbyes,mbno],0)=mrYes);
    end else begin
      if tblHeadingFielded.value = 0 then begin
        tblHeading.edit;
        tblHeadingFielded.value := 1;
        tblHeading.post;
      end;
      messagedlg('Heading cannot be deleted or modified if it is used in a question.',mtwarning,[mbok],0);
      reallydoit := false;
    end;
    if reallydoit and (tblHeadingFielded.value = 0) then
      with tblHeading do begin
        Delete;
        //btnDelete.Enabled := ( not chkFielded.Checked ) and ( tblHeading.RecordCount > 0 );
      end;
  end;
end;

procedure TfrmHeading.AddClick(Sender: TObject);
begin
  with modLibrary do
  begin
    if tblHeading.State <> dsBrowse then tblHeading.Post;
    if wtblHeadText.State <> dsBrowse then wtblHeadText.Post;
    tblHeading.Refresh;
  end;
end;

procedure TfrmHeading.SpellClick(Sender: TObject);
begin
  with modSupport.dlgSpell do
  begin
    Open;
    Show;
    case pclHeading.ActivePage.PageIndex of
      0 : begin
            SpellCheck( detHeading );
            SpellCheck( rtfText );
          end;
      1 : SpellCheck( detDepend );
    end;
    Close;
  end;
end;

procedure TfrmHeading.CodeClick(Sender: TObject);
begin
  if vAsText then begin            {DG}
    vAsText := False;              {DG}
    rtfText.UpdateRichText(cText); {DG}
  end;                             {DG}
  if btnCode.Down then
  begin
      Screen.Cursor := crHourGlass;
      try
      frmCode := TfrmCode.Create( Self );
      //Hide;
      frmCode.Top := ( Screen.Height - frmCode.Height ) div 2;
      if Screen.Width < ( frmCode.Width + Width ) then
      begin
        frmCode.Left := 2;
        Left := Screen.Width - ( Width + 2 );
      end
      else
      begin
        frmCode.Left := ( Screen.Width - frmCode.Width - Width - 4 ) div 2;
        Left := frmCode.Left + frmCode.Width + 4;
      end;
      frmCode.vForm := Self;
      Show;
      frmCode.Show;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
    frmCode.Close;
end;

procedure TfrmHeading.FirstClick(Sender: TObject);
begin
  if modSupport.dlgLocate.FindFirst then btnNext.Enabled := True;
  btnFirst.Enabled := False;
end;

procedure TfrmHeading.FindClick(Sender: TObject);
begin
  with modSupport.dlgLocate do
  begin
    DataSource := modLibrary.srcHeading;
    SearchField := 'Name';
    Caption := 'Locate Heading';
    if Execute then
    begin
      btnFirst.Enabled := True;
      btnNext.Enabled := True;
    end
    else
    begin
      staHeading.SimpleText := 'No matches found';
      btnFirst.Enabled := False;
      btnNext.Enabled := False;
    end;
  end;
end;

procedure TfrmHeading.NextClick(Sender: TObject);
begin
  if not modSupport.dlgLocate.FindNext then
  begin
    btnNext.Enabled := False;
    staHeading.SimpleText := 'No further matches found';
  end;
end;

procedure TfrmHeading.GoToClick(Sender: TObject);
begin
  modLibrary.wtblQuestion.GoToCurrent( modLookup.tblQuestion );
  Close;
end;

{ move to the next question tagged for review:
    1. if not set, set review table to HeadText.DB and filter for review and language
    2. move to current heading in review table
    3. find subsequent heading matching criteria in review table
    4. move heading table to match review table }

procedure TfrmHeading.ReviewClick(Sender: TObject);
begin
  with modLibrary, modLookup.tblReview do
  begin
    if ( TableName <> 'HeadText' ) and ( Pos( '=', Filter ) = 0 ) then
    begin
      Close;
      TableName := 'HeadText';
      Filter := 'Review AND ( LangID = 1 )';
      Open;
      GoToCurrent( wtblHeadText );
    end;
    if not FindNext then
      if not FindFirst then
        if MessageDlg( 'There are no more Headings in English to be Reviewed',
          mtInformation, [ mbOK ], 0 ) = mrOK then Exit;
    tblHeading.Locate( 'HeadID', FieldByName( 'HeadID' ).Value, [ ] );
  end;
end;

procedure TfrmHeading.CloseClick(Sender: TObject);
begin
  Close;
end;

{ FINALIZATION }

{ remove heading support configurations }

procedure TfrmHeading.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Hide;
  try
    with modLookup do
    begin
      tblQuestion.MasterSource := nil;
      tblQuestion.MasterFields := '';
      tblQuestion.IndexName := '';
    end;
    with modLibrary do
    begin
      tblHeading.MasterSource := nil;
      srcHeading.OnStateChange := nil;
      AddClick( nil );
      wtblQuestion.Refresh;
    end;
  except
    on EDatabaseError do
    begin
      Action := caNone;
      Show;
      Raise;
    end;
  end;
  Application.OnIdle := nil;
end;

procedure TfrmHeading.detHeadingChange(Sender: TObject);
begin
  //btnDelete.Enabled := ( not chkFielded.Checked ) and ( tblHeading.RecordCount > 0 );
end;

end.
