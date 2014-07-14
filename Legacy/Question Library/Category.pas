unit Category;

{ A tabbed dialog box used for locating, editing, and deleting Services and Themes }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, StdCtrls, Mask, DBCtrls, DBTables,
  DB, Wwkeycb;

type
  TfrmCategory = class(TForm)
    staCategory: TStatusBar;
    panToolBar: TPanel;
    btnClose: TSpeedButton;
    pclCategory: TPageControl;
    shtService: TTabSheet;
    dgrService: TDBGrid;
    shtTheme: TTabSheet;
    dgrTheme: TDBGrid;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    btnDelete: TSpeedButton;
    btnNew: TSpeedButton;
    btnCancel: TSpeedButton;
    Label3: TLabel;
    detService: TDBEdit;
    Bevel2: TBevel;
    Label4: TLabel;
    wincSearch: TwwIncrementalSearch;
    detTheme: TDBEdit;
    procedure CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure SearchExit(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure AfterSearch(Sender: TwwIncrementalSearch; MatchFound: Boolean);
    procedure NewClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditEnter(Sender: TObject);
    procedure SearchEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    vTable : TTable;
    procedure CategoryHint( Sender : TObject );
  public

  end;

var
  frmCategory: TfrmCategory;

implementation

uses Data, Support;

{$R *.DFM}

{ INITIALIZATION SECTION }

{ sets the initial state of the service and theme dialog:
    1. filter tables to exclude 'all' and 'none' from modification
    2. locates the service and theme for the current question
         (necessary after setting filters)
    3. loads the service as the current working table variable (vTable)
    4. set the OnChange event handlers for service and theme edit boxes
         (avoiding the initial firing of event on opening)
    5. set hints to display in the status bar
    6. clears the incremental search edit box }

procedure TfrmCategory.FormCreate(Sender: TObject);
begin
  with modLibrary do
  begin
    tblService.Filtered := True;
    tblTheme.Filtered := True;
    tblService.Locate( 'ServID', wtblQuestionServID.Value, [ ] );
    tblTheme.Locate( 'ThemID', wtblQuestionThemID.Value, [ ] );
    vTable := tblService;
  end;
  detService.OnChange := EditingChange;
  detTheme.OnChange := EditingChange;
  Application.OnHint := CategoryHint;
  wincSearch.Clear;
end;

{ displays flyover hints in the status bar }

procedure TfrmCategory.CategoryHint( Sender : TObject );
begin
  staCategory.SimpleText := Application.Hint;
end;

{ PAGE/TAB SECTION }

{ changes settings in response to selecting a new tabbed page:
    1. clears the incremental search edit box
    2. resets the working table variable (vTable)
    3. changes button hints
    4. changes the incremental search DataSource and Field
    5. sets the focus to first edit box in the tab order }

procedure TfrmCategory.PageChange(Sender: TObject);
begin
  wincSearch.Clear;
  if pclCategory.ActivePage = shtService then
  begin
    vTable := modLibrary.tblService;
    btnNew.Hint := 'Create Service|Adds a new Service to Library';
    btnCancel.Hint := 'Cancel Service|Cancels changes made to Service';
    btnDelete.Hint := 'Delete Service|Permanently removes Service from Library';
    wincSearch.Hint := 'Search Service|Performs incremental search on Service';
    wincSearch.DataSource := modLibrary.srcService;
    wincSearch.SearchField := 'Service';
    detService.SetFocus;
  end
  else
  begin
    vTable := modLibrary.tblTheme;
    btnNew.Hint := 'Create Theme|Adds a new Theme to Library';
    btnCancel.Hint := 'Cancel Theme|Cancels changes made to Theme';
    btnDelete.Hint := 'Delete Theme|Permanently removes Theme from Library';
    wincSearch.Hint := 'Search Theme|Performs incremental search on Theme';
    wincSearch.DataSource := modLibrary.srcTheme;
    wincSearch.SearchField := 'Theme';
    detTheme.SetFocus;
  end;
end;

{ SEARCH SECTION }

procedure TfrmCategory.AfterSearch(Sender: TwwIncrementalSearch; MatchFound: Boolean);
begin
  if not MatchFound and ( wincSearch.Text <> '' ) then
  begin
    staCategory.SimpleText := 'No matches found';
    Beep;
  end;
end;

procedure TfrmCategory.SearchEnter(Sender: TObject);
begin
  staCategory.SimpleText := 'Type the first few letters of the word to find';
end;

procedure TfrmCategory.SearchExit(Sender: TObject);
begin
  wincSearch.Clear;
  staCategory.SimpleText := '';
end;

{ EDIT BOX SECTION }

procedure TfrmCategory.EditEnter(Sender: TObject);
begin
  staCategory.SimpleText := 'Press "Enter" to save changes';
end;

{ responses to changes in the service and theme edit boxes:
    1. sets the cancel button depending on state table is in
    2. sets font color to default (it is red if an unrecognized word is entered) }

procedure TfrmCategory.EditingChange(Sender: TObject);
begin
  btnCancel.Enabled := ( vTable.State <> dsBrowse );
  ( Sender as TDBEdit ).Font.Color := clWindowText;
end;

{ responses to leaving the service and theme edit boxes:
    1. posts changes made to service or theme
    2. clears the status bar
    3. sets font color to default (it is red if an unrecognized word is entered) }

procedure TfrmCategory.EditExit(Sender: TObject);
begin
  if detservice.text = '' then begin
    if tDBEdit(Sender) = detService then begin
      messagedlg('Field ''Service'' must have a value.',mterror,[mbok],0);
      activecontrol := detService;
    end else begin
      messagedlg('Field ''Theme'' must have a value.',mterror,[mbok],0);
      activecontrol := detTheme;
    end;
  end else begin
    with vTable do if Modified then Post;
    staCategory.SimpleText := '';
    ( Sender as TDBEdit ).Font.Color := clWindowText;
  end;
end;

{ responses to enter key in service and theme edit boxes:
    1. checks spelling dictionary for word, sets font to red if not found }

procedure TfrmCategory.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with vTable do
    if ( State <> dsBrowse ) and ( Key = VK_RETURN ) then
    begin
      Post;
      btnCancel.Enabled := False;
      with modSupport.dlgSpell do
        if OpenDictionary then
        begin
          with ( Sender as TDBEdit ) do
            if not InDictionary( Text ) then
            begin
              Font.Color := clRed;
              staCategory.SimpleText := '"' + Text + '" is not in the dictionary';
              Beep;
              Beep;
            end
            else
            begin
              Font.Color := clWindowText;
              staCategory.SimpleText := '';
            end;
          CloseDictionary;
        end;
    end;
end;

{ BUTTON SECTION }

procedure TfrmCategory.NewClick(Sender: TObject);
begin
  vTable.Insert;
  if pclCategory.ActivePage = shtService then
    detService.SetFocus
  else
    detTheme.SetFocus;
end;

procedure TfrmCategory.CancelClick(Sender: TObject);
begin
  vTable.Cancel;
end;

procedure TfrmCategory.DeleteClick(Sender: TObject);
begin
  vTable.Delete;
end;

procedure TfrmCategory.CloseClick(Sender: TObject);
begin
  Close;
end;

{ FINALIZATION SECTION }

procedure TfrmCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  try
    with vTable do if Modified then Post;
    with modLibrary do
    begin
      tblService.Filtered := False;
      tblTheme.Filtered := False;
    end;
  except  
    on EDatabaseError do
    begin
      Action := caNone;
      Show;
      Raise;
    end;
  end;
end;

end.
