unit Find;

{ small non-modal dialog box used for finding previously entered or duplicate questions }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  Menus, StdCtrls, ExtCtrls, db;

type
  TfrmFind = class(TForm)
    Label1: TLabel;
    memFind: TMemo;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtFound: TEdit;
    btnClose: TButton;
    btnFilter: TSpeedButton;
    btnSearch: TSpeedButton;
    btnFilter2: TButton;
    procedure CloseClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FindChange(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFilter2Click(Sender: TObject);
  private
    procedure Unfilter;
  public
    vAbort : Boolean;
  end;

var
  frmFind: TfrmFind;

implementation

uses Search, Browse, Data, Lookup;

{$R *.DFM}

{ INITIALIZATION SECTION }

{ if menu item 'Build on Open' (under Options|Search) is checked, build a word table to search }

procedure TfrmFind.FormCreate(Sender: TObject);
var
  SearchRec: TSearchRec;
  i,Qtime,QTtime,Wtime : integer;
  libpath : string;
begin
  vAbort := False;
  if frmLibrary.mniOpenBuild.Checked then
    begin
      modLookup.tblQstnText.Filtered := False;
      try
          I := modlookup.dbQstnLib.Params.IndexOfName('PATH');
          Wtime := 0;
          Qtime := 1;
          QTtime := 1;
          if (i>-1) and (modlibrary.wtblQuestion.tag<>1) then begin
            libPath := copy(modlookup.dbQstnLib.Params[i],6,255)+'\';
            if FindFirst(libpath+modlibrary.wtblQuestion.Tablename,faAnyFile,SearchRec) = 0 then begin
              Qtime := SearchRec.Time;
              if FindFirst(libpath+modlibrary.wtblQstnText.Tablename,faAnyFile,SearchRec) = 0 then begin
                QTtime := SearchRec.Time;
                if FindFirst(libpath+modSearch.tblWords.Tablename,faAnyFile,SearchRec) = 0 then
                  Wtime := SearchRec.Time;
              end;
            end;
            FindClose(SearchRec);
          end;
          if (Wtime<Qtime) or (Wtime<QTtime) or (modlibrary.wtblquestion.tag=1) then
            modSearch.rubMake.Execute;
{          with tblWords do begin
            try
              close;
            except
              on EAccessViolation do messagebeep(0);
            end;
            if not active then begin
              Exclusive := FALSE;
              open;
            end;
          end;}

      finally
        modLookup.tblQstnText.Filtered := True;
      end;
    end;
end;

{ BUTTON SECTION }

{ if button reads close then close; if button read cancel then abort and set to read close }

procedure TfrmFind.CloseClick(Sender: TObject);
begin
  if btnClose.Caption = 'Close' then
    Close
  else
  begin
    vAbort := True;
    btnClose.Caption := 'Close';
  end;
end;

{ search for words in the text box
    1. set close button to read cancel
    2. search word table for matching text
    3. return number of matches (show in found text box)
    4. reset close button to read close }

procedure TfrmFind.SearchClick(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  btnClose.Caption := 'Cancel';
  try
    vAbort := False;
    with modSearch.rubSearch do begin
      SearchFor := memFind.Text;
      Execute;
      edtFound.Text := IntToStr( RecordCount );
      btnFilter.Enabled := ( RecordCount > 0 );
      btnFilter2.Enabled := ( RecordCount > 0 );
    end;
  finally
    screen.Cursor := crDefault;
    btnClose.Caption := 'Close';
    btnSearch.Enabled := False;
  end;
end;

{ show questions matching search criteria:
    1. move dialog out of the way
    2. set fields in match table to display correctly in a grid
    3. point grid and controls to match table
    4. disable buttons }

procedure TfrmFind.FilterClick(Sender: TObject);
begin
  if btnFilter.Down then
    with modSearch.tblMatch do begin
      Top := ( Screen.Height - Height - 22 );
      Left := ( Screen.Width - Width - 2 );
      ( FieldByName( 'Core' ) as TIntegerField ).Alignment := taCenter;
      with ( FieldByName( 'Fielded' ) as TSmallIntField ) do begin
        Alignment := taCenter;
        DisplayFormat := 'Layout;Fielded;New';
      end;
      with ( FieldByName( 'Review' ) as TBooleanField ) do begin
        Alignment := taCenter;
        DisplayValues := 'Yes;';
      end;
      with ( FieldByName( 'RestrictQuestion' ) as TBooleanField ) do begin
        Alignment := taCenter;
        DisplayValues := 'Yes;';
      end;
      with ( FieldByName( 'Tested' ) as TBooleanField ) do begin
        Alignment := taCenter;
        DisplayValues := 'Yes;';
      end;
      with ( FieldByName( 'LevelQuest' ) as tSmallintField ) do begin
        OnGetText := modSearch.tblMatchLevelQuestGetText;
        OnSetText := modSearch.tblMatchLevelQuestSetText;
      end;
      ( FieldByName( 'AddedOn' ) as TDateField ).Alignment := taCenter;
      ( FieldByName( 'ModifiedOn' ) as TDateField ).Alignment := taCenter;
      with frmLibrary do begin
        dgrLibrary.DataSource := modSearch.srcMatch;
        {navLibrary.DataSource := modSearch.srcMatch;}
        wdlgFilter.DataSource := modSearch.srcMatch;
        btnDelete.Enabled := False;
        btnNew.Enabled := False;
        btnReplicate.Enabled := False;
        btnSort.Enabled := False;
        btnPreceded.Enabled := False;
        btnFollowed.Enabled := False;
        btnRecode.Enabled := False;
        btnEditRecode.Enabled := False;
        btnRelated.Enabled := False;
        staLibrary.Panels[ 0 ].Text := 'Filtered';
      end;
    end
  else begin
    Unfilter;
    Position := poScreenCenter;
  end;
end;

{ GENERAL MEHTODS }

{ restore browse grid and controls to the question table }

procedure TfrmFind.Unfilter;
begin
  with frmLibrary do begin
    dgrLibrary.DataSource := modLibrary.wsrcQuestion;
    {navLibrary.DataSource := modLibrary.wsrcQuestion;}
    wdlgFilter.DataSource := modLibrary.wsrcQuestion;
    if modLibrary.userrights <> urTranslator then begin
      btnDelete.Enabled := True;
      btnNew.Enabled := True;
      btnReplicate.Enabled := True;
      btnSort.Enabled := True;
      btnPreceded.Enabled := True;
      btnFollowed.Enabled := True;
      btnRecode.Enabled := True;
      btnEditRecode.Enabled := True;
      btnRelated.Enabled := True;
    end;
    staLibrary.Panels[ 0 ].Text := 'No Filter';
  end;
end;

{ COMPONENT HANDLERS }

procedure TfrmFind.FindChange(Sender: TObject);
begin
  btnSearch.Enabled := ( memFind.Text <> '' );
  edtFound.Text := '';
end;

{ FINALIZATION SECTION }

{ set find buttons to normal, turn off matching filter, and close the find dialog }

procedure TfrmFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with frmLibrary do
  begin
    btnFind.Down := False;
    btnFindPrior.Enabled := btnFilter.Enabled;
    btnFindNext.Enabled := btnFilter.Enabled;
    Unfilter;
  end;
  Action := caFree;
end;

procedure TfrmFind.btnFilter2Click(Sender: TObject);
begin
  btnFilter.Down := not btnFilter.Down; 
  FilterClick(Sender);
end;

end.
