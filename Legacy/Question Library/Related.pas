unit Related;

{ a modal dialog used for displaying and deleting all questions related to a question }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, Grids, DBGrids, Buttons, ExtCtrls, ComCtrls;

type
  TfrmRelated = class(TForm)
    panHeader: TPanel;
    btnGoTo: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnDelete: TSpeedButton;
    btnClose: TSpeedButton;
    btnPrint: TSpeedButton;
    dgrRecode: TDBGrid;
    dgrFollow: TDBGrid;
    dgrPreced: TDBGrid;
    srcFollow: TDataSource;
    srcProced: TDataSource;
    srcRecode: TDataSource;
    btnContinue: TSpeedButton;
    qryRecode: TQuery;
    qryPreced: TQuery;
    qryFollow: TQuery;
    staRelated: TStatusBar;
    updRecode: TUpdateSQL;
    qryPrecedCore: TIntegerField;
    qryPrecedDescription: TStringField;
    qryPrecedShort: TStringField;
    qryFollowCore: TIntegerField;
    qryFollowDescription: TStringField;
    qryFollowShort: TStringField;
    qryRecodeCore: TIntegerField;
    qryRecodeDescription: TStringField;
    qryRecodeShort: TStringField;
    procedure FormShow(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure GoToClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ContinueClick(Sender: TObject);
    procedure UpdateRelated;
    function GetRecordCount( vQuery : TQuery ) : Integer;
  private
    { Private declarations }
  public
    vDelete : Boolean;
  end;

const
  cItemHeight = 19;          // height of each entry in a grid
  cMinFormHeight = 79;       // smallest the dialog can be
  cMargin = 5;               // distance to maintain from the edge of the screen
  cTopDefault = 100;         // top if the dialog is not tall enough to hang off the screen
var
  frmRelated: TfrmRelated;

implementation

uses Data, Common, RRelated, Lookup;

{$R *.DFM}

{ ACTIVATION }

procedure TfrmRelated.FormShow(Sender: TObject);
begin
  Left := Screen.Width - ( Width + cMargin );
  UpdateRelated;
end;

{ recalculates and displays the number of related questions:
    1. calls GetRelatedCount (common unit)
    2. displays count and sets button states
    3. calculates height of each grid to display number of questions }

procedure TfrmRelated.UpdateRelated;
var
  vCount : Word;
  vGrid : TDBGrid;
begin
  vCount := GetRelatedCount( modLibrary.wtblQuestionCore.Value, False, modLookup.tblRecode,
      modLookup.tblQuestion );
  staRelated.SimpleText := 'Number of Related Questions: ' + IntToStr( vCount );
  btnPrint.Enabled := ( vCount > 0 );
  btnDelete.Enabled := ( vCount > 0 );
  btnGoTo.Enabled := ( vCount > 0 );
  btnContinue.Enabled := ( vCount > 0 );
  if vCount > 0 then
  begin
    if GetRecordCount( qryPreced ) > 0 then
    begin
      dgrPreced.Visible := True;
      dgrPreced.Height := Succ( qryPreced.RecordCount ) * cItemHeight;
    end
    else
    begin
      dgrPreced.Visible := False;
      dgrPreced.Height := 0;
    end;
    if GetRecordCount( qryFollow ) > 0 then
    begin
      dgrFollow.Visible := True;
      dgrFollow.Height := Succ( qryFollow.RecordCount ) * cItemHeight;
    end
    else
    begin
      dgrFollow.Visible := False;
      dgrFollow.Height := 0;
    end;
    if GetRecordCount( qryRecode ) > 0 then
    begin
      dgrRecode.Visible := True;
      dgrRecode.Height := Succ( qryRecode.RecordCount ) * cItemHeight;
    end
    else
    begin
      dgrRecode.Visible := False;
      dgrRecode.Height := 0;
    end;
    Height := cMinFormHeight + dgrPreced.Height + dgrFollow.Height + dgrRecode.Height;
    while ( Height + cMargin * 2 ) > Screen.Height do
    begin
      if dgrPreced.Height > dgrFollow.Height then
        vGrid := dgrPreced
      else
        vGrid := dgrFollow;
      if dgrRecode.Height > vGrid.Height then vGrid := dgrRecode;
      vGrid.Height := vGrid.Height - cItemHeight;
    end;
  end
  else
  begin
    dgrPreced.Height := 0;
    dgrFollow.Height := 0;
    dgrRecode.Height := 0;
    dgrPreced.Visible := False;
    dgrFollow.Visible := False;
    dgrRecode.Visible := False;
    Height := cMinFormHeight;
  end;
  if ( Height + cTopDefault + cMargin ) < Screen.Height then
    Top := cTopDefault
  else
    Top := ( Screen.Height - Height ) div 2;
end;

{ GENERAL METHODS }

{ executes a query based on question core value and returns the resulting record number }

function TfrmRelated.GetRecordCount( vQuery : TQuery ) : Integer;
begin
  if vQuery.Active then vQuery.Close;
  vQuery.Params[ 0 ].AsInteger := modLibrary.wtblQuestionCore.Value;
  vQuery.Open;
  Result := vQuery.RecordCount;
end;

{ BUTTON METHODS }

procedure TfrmRelated.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRelated.RefreshClick(Sender: TObject);
begin
  UpdateRelated;
end;

{ prints a list of related questions }

procedure TfrmRelated.PrintClick(Sender: TObject);
begin
  qryPreced.DisableControls;
  qryFollow.DisableControls;
  qryRecode.DisableControls;
  try
    rptRelated := TrptRelated.Create( Application );
    rptRelated.qrRelated.Print;
    rptRelated.Release;
  finally
    qryPreced.EnableControls;
    qryFollow.EnableControls;
    qryRecode.EnableControls;
  end;
end;

procedure TfrmRelated.GoToClick(Sender: TObject);
begin
  modLibrary.wtblQuestion.Locate( 'Core',
      ( ActiveControl as TDBGrid ).DataSource.DataSet.FieldByName( 'Core' ).Value, [ ] );
end;

{ deletes (recode) or removes (preced or follow) the related question:
    1. if recode, uses an UpdateSQL component to delete record
    2. otherwise, clears the referencing field }

procedure TfrmRelated.DeleteClick(Sender: TObject);
var
  vControl : string;
begin
  vControl := ActiveControl.Name;
  if vControl = 'dgrRecode' then
    updRecode.Apply( ukDelete )
  else
    with ( ActiveControl as TDBGrid ).DataSource.DataSet do
    begin
      Edit;
      if vControl = 'dgrPreced' then
        FieldByName( 'PrecededBy' ).Clear
      else
        FieldByName( 'FollowedBy' ).Clear;
      Post;
    end;
  UpdateRelated;
end;

{ deletes all related questions (calls GetRelatedCount, passes in true for delete) }

procedure TfrmRelated.ContinueClick(Sender: TObject);
begin
  GetRelatedCount( modLibrary.wtblQuestionCore.Value, True, modLookup.tblRecode, modLookup.tblQuestion );
  Close;
end;

end.
