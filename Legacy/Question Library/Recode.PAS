unit Recode;

{ dialog used for recoding one questions scale values into anothers }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DB, DBTables, Spin, ComCtrls, Grids, DBGrids, ExtCtrls,
  DBCtrls, Menus, Math, Wwdatsrc, Wwdbigrd, Wwdbgrid, Wwtable, Wwquery,
  Mask, Wwdbedit, Wwdbspin;

type
  TfrmRecode = class(TForm)
    lblSpin: TLabel;
    lblSpinTo: TLabel;
    panHeader: TPanel;
    btnAll: TSpeedButton;
    btnClose: TSpeedButton;
    btnRemove: TSpeedButton;
    btnAdd: TSpeedButton;
    staRecode: TStatusBar;
    lblTarget: TLabel;
    lblSource: TLabel;
    lblDefined: TLabel;
    cmbRecode: TComboBox;
    wdgrTarget: TwwDBGrid;
    wsrcSource: TwwDataSource;
    wsrcTarget: TwwDataSource;
    wtblMap: TwwTable;
    wsrcMap: TwwDataSource;
    wdgrDefined: TwwDBGrid;
    wtblMapMinimum: TSmallintField;
    wtblMapMaximum: TSmallintField;
    wtblMapNewValue: TSmallintField;
    wtblMapTo: TStringField;
    wtblMapEquals: TStringField;
    wtblTarget: TwwTable;
    wqrySource: TwwQuery;
    wdgrSource: TwwDBGrid;
    edtMin: TEdit;
    edtMax: TEdit;
    spnMin: TUpDown;
    spnMax: TUpDown;
    wtblMapSource: TStringField;
    wtblMapTarget: TStringField;
    tblValues: TTable;
    btnDelete: TSpeedButton;
    wtblMapCore: TIntegerField;
    wtblMapRecode: TIntegerField;
    wtblTargetScale: TIntegerField;
    wtblTargetItem: TIntegerField;
    wtblTargetBubbleValue: TSmallintField;
    wtblTargetShort: TStringField;
    wqrySourceBubbleValue: TSmallintField;
    wqrySourceShort: TStringField;
    wqrySourceScale: TIntegerField;
    procedure AddClick(Sender: TObject);
    procedure RemoveClick(Sender: TObject);
    procedure ShowSpinEdit( vShow : Boolean );
    procedure AllClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure MapCalcFields(DataSet: TDataSet);
    procedure ComboClick(Sender: TObject);
    procedure SourceFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure UpdateScrollBar( vGrid : TwwDBGrid );
    procedure DisplayHint(Sender: TObject);
    procedure DefinedExit(Sender: TObject);
    procedure AddGridsExit(Sender: TObject);
    procedure TargetFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure UpdateAdd;
    procedure UpdateRemove;
    procedure DefinedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TargetMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SourceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpinChange(Sender: TObject);
    procedure SpinEnter(Sender: TObject);
    procedure InitVariables( vEditing : Boolean );
    procedure OpenDataSets;
    procedure LoadScaleCombo;
    procedure ShowControls;
    procedure InitControls( vEditing : Boolean );
    procedure GetSpinStatus;
    procedure UpdateSource;
    procedure UpdateSpin;
    procedure FormCreate(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    vTarget : Integer; { use in filters }
    vSpinVisible, vSpinFull : Boolean;
  public
    vEditing : Boolean;   // indicates whether dialog opened to edit or create
  end;

const
  cGridSize = 7;       //  number of grid items displayed
  cNull = 'Null';      //  !!! string that appears in grid indicating a missing value
                                        { might change to 'SysMis' }
var
  frmRecode: TfrmRecode;

implementation

uses Data, Browse, Lookup;

{$R *.DFM}

{ INITIALIZATION }

procedure TfrmRecode.FormCreate(Sender: TObject);
begin
  LoadScaleCombo;
  InitVariables( vEditing );
  OpenDataSets;
  ShowControls;
  InitControls( vEditing );
end;

{ loads all questions recode to the current question into the recode combo box }

procedure TfrmRecode.LoadScaleCombo;
begin
  cmbRecode.Items.Clear;
  with modLibrary do begin
    while not wtblRecode.EOF do begin
      cmbRecode.Items.Add( wtblQuestion.Lookup( 'Core', wtblRecodeRecode.value, 'Short' ));
      wtblRecode.Next;
    end;
    cmbRecode.ItemIndex := Pred( cmbRecode.Items.Count );
  end;
end;

procedure TfrmRecode.InitVariables( vEditing : Boolean );
begin
  with modLibrary do begin
    vSpinVisible := tblValuesType.value=stICR;
    vSpinFull := vEditing and vSpinVisible;
    vTarget := modLookup.tblQuestion.Lookup( 'Core', wtblRecodeRecode.value, 'Scale' );
  end;
end;

procedure TfrmRecode.OpenDataSets;
begin
  tblValues.Open;
  wtblTarget.Open;
  wqrySource.Open;
  wtblMap.Open;
  wqrySource.Filtered := True;
end;

procedure TfrmRecode.ShowControls;
begin
  if vSpinVisible then with modLibrary do
  begin
    spnMin.Max := Pred( Trunc( Power( 10, tblValuesBubbleValue.value )));
    spnMax.Max := spnMin.Max;
    lblSpin.Caption := tblValuesShort.value + ' (0 - ' + IntToStr( spnMin.Max ) + ')';
    ShowSpinEdit( True );
  end;
end;

procedure TfrmRecode.InitControls( vEditing : Boolean );
begin
  Application.OnHint := DisplayHint;
  if not vSpinVisible then UpdateScrollBar( wdgrSource );
  UpdateScrollBar( wdgrTarget );
  UpdateScrollBar( wdgrDefined );
  btnAll.Enabled := vEditing;
  if vEditing then
    staRecode.SimpleText := 'Select a recoded scale to edit from the drop-down list'
  else
    staRecode.SimpleText := 'Select a source value and a target value in which to recode it';
end;

procedure TfrmRecode.DisplayHint(Sender: TObject);
begin
  staRecode.SimpleText := Application.Hint;
end;

{ BUTTON METHODS }

{ add all selected source and target values to the recode list }

procedure TfrmRecode.AddClick(Sender: TObject);
var
  i : Integer;
begin
  with wtblMap do begin
    DisableControls;
    try
      if vSpinVisible then begin
        {InsertRecord([ nil, nil, spnMin.Position, spnMax.Position, wtblTargetValue.value ]);}
        insert;
        {fieldbyname('Core').AsString := '';
        fieldbyname('Recode').AsString := '';}
        fieldbyname('Minimum').value := spnMin.Position;
        fieldbyname('Maximum').value := spnMax.Position;
        fieldbyname('NewValue').value := wtblTargetBubbleValue.value;
        post;
        GetSpinStatus;
        UpdateSpin;
      end else begin
        wqrySource.DisableControls;
        try
          with wdgrSource do begin
            SortSelectedList;
            for i := 0 to Pred( SelectedList.Count ) do begin
              wqrySource.GoToBookmark( SelectedList.Items[ i ] );
              wqrySource.FreeBookmark( SelectedList.Items[ i ] );
              wtblmap.insert;
              {wtblmap.fieldbyname('Core').AsString := '';
              wtblmap.fieldbyname('Recode').AsString := '';}
              wtblmap.fieldbyname('Minimum').value := wqrySourceBubbleValue.value;
              {wtblmap.fieldbyname('Maximum').value := '';}
              wtblmap.fieldbyname('NewValue').value := wtblTargetBubbleValue.value;
              wtblmap.post;
              {wtblMap.InsertRecord([ nil, nil, wqrySourceValue.value, Null, wtblTargetValue.value ]);
              wtblMap.InsertRecord([ Null, Null, wqrySourceValue.value, Null, wtblTargetValue.value ]); {DG}
            end;
            SelectedList.Clear;
            wdgrTarget.SelectedList.Clear;
          end;
        finally
          wqrySource.EnableControls;
        end;
      end;
      UpdateSource;
      wdgrTarget.Refresh;
      UpdateScrollBar( wdgrDefined );
      if not btnAll.Enabled then btnAll.Enabled := True;
      if wqrySource.RecordCount > 0 then
        staRecode.SimpleText := 'Continue recoding until all source values have been used';
    finally
      EnableControls;
    end;
    btnAdd.Enabled := False;
  end;
end;

{ removes selected recodes, and puts them in source and target lists }

procedure TfrmRecode.RemoveClick(Sender: TObject);
var
  i : Integer;
begin
  with wdgrDefined, wtblMap do
  begin
    DisableControls;
    try
      SortSelectedList;
      for i := 0 to Pred( SelectedList.Count ) do
      begin
        GoToBookmark( SelectedList.Items[ i ]);
        FreeBookmark( SelectedList.Items[ i ]);
        Delete;
      end;
      SelectedList.Clear;
    finally
      EnableControls;
    end;
  end;
  vSpinFull := False;
  UpdateSource;
  UpdateScrollBar( wdgrDefined );
  btnRemove.Enabled := False;
  if wtblMap.RecordCount = 0 then btnAll.Enabled := False;
  staRecode.SimpleText := 'Either recode remaining source values or delete recoded values';
end;

{ removes all recodes from list, and resests source and target lists }

procedure TfrmRecode.AllClick(Sender: TObject);
begin
  with wtblMap do while not EOF do Delete;
  vSpinFull := False;
  wdgrTarget.SelectedList.Clear;
  wtblTarget.Refresh;
  UpdateSource;
  UpdateScrollBar( wdgrDefined );
  btnRemove.Enabled := False;
  btnAll.Enabled := False;
  staRecode.SimpleText := 'Close dialog or change target to delete recode altogether';
end;

{ switches to the recode question shown in the combo box }

procedure TfrmRecode.ComboClick(Sender: TObject);
begin
  if wqrySource.active then
    if ( wqrySource.RecordCount = 0 ) or ( wtblMap.RecordCount = 0 ) then begin
      with modLibrary do begin
        wtblRecode.First;
        wtblRecode.MoveBy( cmbRecode.ItemIndex );
        vTarget := modLookup.tblQuestion.Lookup( 'Core', wtblRecodeRecode.value, 'Scale' );
        wtblTarget.Refresh;
      end;
      UpdateScrollBar( wdgrTarget );
    end else
      MessageDlg( 'The current recoding session is incomplete: Source Values ' +
          'must be assigned to a Target Value or Recoded Values must be removed ' +
          'before the dialog can be closed.', mtWarning, [ mbOK ], 0 );
end;

{ deletes the recode link altogether }

procedure TfrmRecode.DeleteClick(Sender: TObject);
begin
  with modLibrary.wtblRecode do
  begin
    Delete;
    btnDelete.Enabled := ( RecordCount > 0 );
  end;
  with cmbRecode do
  begin
    Items.Delete( ItemIndex );
    { will this default to the correct list item?
    ItemIndex := IndexOf( modLibrary.wtblRecode ); }
  end;
end;

procedure TfrmRecode.CloseClick(Sender: TObject);
begin
  Close;
end;

{ GENERAL METHODS }

{ shows either source list or two spin boxes }

procedure TfrmRecode.ShowSpinEdit( vShow : Boolean );
begin
  vSpinVisible := vShow;
  if vSpinVisible then UpdateSpin;
  wqrySource.Filtered := not vShow;
  wdgrSource.Visible := not vShow;
  edtMin.Visible := vShow;
  edtMax.Visible := vShow;
  spnMin.Visible := vShow;
  spnMax.Visible := vShow;
  lblSpin.Visible := vShow;
  lblSpinTo.Visible := vShow;
  wtblMapMinimum.Visible := vShow;
  wtblMapMaximum.Visible := vShow;
  wtblMapTo.Visible := vShow;
  wtblMapSource.Visible := not vShow;
end;

{ determines whether or not the spin boxes contain full range of values (sets vSpinFull) }

procedure TfrmRecode.GetSpinStatus;
var
  vLastMax : SmallInt;
begin
  with wtblMap do
  begin
    vSpinFull := True;
    First;
    if wtblMapMinimum.value = -1 then
    begin
      vLastMax := wtblMapMaximum.value;
      while not EOF do
      begin
        Next;
        if Pred( wtblMapMinimum.value ) <> vLastMax then
        begin
          vSpinFull := False;
          Break;
        end;
      end;
      if vSpinFull and ( wtblMapMaximum.value <> spnMax.Max ) then
        vSpinFull := False;
    end
    else
      vSpinFull := False;
  end;
end;

{ shows scroll bar if list can't display all items it contains }

procedure TfrmRecode.UpdateScrollBar( vGrid : TwwDBGrid );
begin
  with vGrid do ShowVertScrollBar := ( DataSource.DataSet.RecordCount > cGridSize );
end;

{ resets the spin boxes or source list }

procedure TfrmRecode.UpdateSource;
begin
  if vSpinVisible then
    UpdateSpin
  else
  begin
    wqrySource.Refresh;
    UpdateScrollBar( wdgrSource );
  end;
end;

{ increments spin boxes if entire range is not accounted for
  (this method should be expanded on to check range state better) }

procedure TfrmRecode.UpdateSpin;
begin
  if vSpinFull then
  begin
    edtMin.Text := '';
    edtMax.Text := '';
  end
  else
  begin
    if wtblMap.RecordCount > 0 then
      edtMin.Text := IntToStr( Succ( spnMax.Position ))
    else
      edtMin.Text := '0';
    edtMax.Text := IntToStr( spnMax.Max );
  end;
  edtMin.ReadOnly := vSpinFull;
  edtMax.ReadOnly := vSpinFull;
  spnMin.Enabled := not vSpinFull;
  spnMax.Enabled := not vSpinFull;
end;

{ reset source list or spin boxes after adding to recode list }

procedure TfrmRecode.UpdateAdd;
begin
  if vSpinVisible then
    btnAdd.Enabled := ( edtMin.Text <> '' ) and ( edtMax.Text <> '' ) and ( wdgrTarget.SelectedList.Count > 0 )
  else
    btnAdd.Enabled := ( wdgrSource.SelectedList.Count > 0 ) and ( wdgrTarget.SelectedList.Count > 0 );
end;

{ reset source list or spin boxes after removing from the recode list }

procedure TfrmRecode.UpdateRemove;
begin
  btnRemove.Enabled := ( wdgrDefined.SelectedList.Count > 0 );
end;

{ DATA EVENTS }

{ set various calculated fields for the recode map table }

procedure TfrmRecode.MapCalcFields(DataSet: TDataSet);
begin
  if wtblMapMinimum.value = -100 then
    wtblMapSource.value := cNull
  else if not vSpinVisible then
    wtblMapSource.value := tblValues.Lookup( 'Scale;BubbleValue', VarArrayOf
        ([ modLibrary.wtblQuestionScale.value, wtblMapMinimum.value ]), 'Short' );
  if wtblMapNewValue.value = -100 then
    wtblMapTarget.value := cNull
  else
    wtblMapTarget.value := tblValues.Lookup( 'Scale;BubbleValue', VarArrayOf
        ([ vTarget, wtblMapNewValue.value ]), 'Short' );
  if wtblMapMinimum.IsNull then
    wtblMapEquals.value := ''
  else
    wtblMapEquals.value := '->';
  wtblMapTo.value := 'to';
 end;

{ remove items from source list that are added to recode list }

procedure TfrmRecode.SourceFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := not wtblMap.Locate( 'Minimum', wqrySourceBubbleValue.value, [ ] );
end;

{ display correct items in the target list }

procedure TfrmRecode.TargetFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := ( wtblTargetScale.value = 0 ) or ( wtblTargetScale.value = vTarget );
end;

{ CONTROL HANDLERS }

{ multi-select items in the recode list }

procedure TfrmRecode.DefinedMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  vCoord : TGridCoord;
begin
  vCoord := wdgrDefined.MouseCoord( x, y );
  if ( Button = mbLeft ) and ( vCoord.Y > -1 ) then
  begin
    with wdgrDefined do if IsSelected then UnselectRecord else SelectRecord;
    UpdateRemove;
  end;
end;

{ single select item in Target list }

procedure TfrmRecode.TargetMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  vCoord : TGridCoord;
begin
  vCoord := wdgrTarget.MouseCoord( x, y );
  if ( Button = mbLeft ) and ( vCoord.Y > -1 ) then
  begin
    with wdgrTarget do
    begin
      SelectedList.Clear;
      SelectRecord;
      Refresh;
    end;
    UpdateAdd;
  end;
end;

{ multi-select items in the source list }

procedure TfrmRecode.SourceMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  vCoord : TGridCoord;
begin
  vCoord := wdgrSource.MouseCoord( x, y );
  if ( Button = mbLeft ) and ( vCoord.Y > -1 ) then
  begin
    with wdgrSource do if IsSelected then UnselectRecord else SelectRecord;
    UpdateAdd;
  end;
end;

procedure TfrmRecode.SpinEnter(Sender: TObject);
begin
  if vSpinFull then
    MessageDlg( 'The entire value range is in use. To edit range assignments, ' +
        'remove the encompassing range(s) from the recoded list',
        mtWarning, [ mbOK ], 0 )
  else
    UpdateAdd;
end;

procedure TfrmRecode.DefinedExit(Sender: TObject);
begin
  wdgrDefined.SelectedList.Clear;
  wdgrDefined.Refresh;
  btnRemove.Enabled := False;
end;

procedure TfrmRecode.AddGridsExit(Sender: TObject);
begin
  if vSpinVisible then
  begin
    if not ( edtMin.Focused or edtMax.Focused or wdgrTarget.Focused ) then
    begin
      wdgrTarget.SelectedList.Clear;
      wdgrTarget.Refresh;
      btnAdd.Enabled := False;
    end;
  end
  else
    if not ( wdgrSource.Focused or wdgrTarget.Focused ) then
    begin
      wdgrSource.SelectedList.Clear;
      wdgrSource.Refresh;
      wdgrTarget.SelectedList.Clear;
      wdgrTarget.Refresh;
      btnAdd.Enabled := False;
    end;
end;

procedure TfrmRecode.SpinChange(Sender: TObject);
begin
  with ( Sender as TEdit ) do if Text = '-1' then
  begin
    edtMin.Text := cNull;
    edtMax.Text := cNull;
  end
  else if Text = cNull then
  begin
    spnMin.Position := -1;
    spnMax.Position := -1;
  end;
end;

{ FINALIZATION }

{ do not close until all fields are recode or no fields are recode (delete) }

procedure TfrmRecode.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if wqrySource.active and ( wqrySource.RecordCount > 0 ) and ( wtblMap.RecordCount > 0 ) then
  begin
    MessageDlg( 'The current recoding session is incomplete: Source Values ' +
        'must be assigned to a Target Value or Recoded Values must be removed ' +
        'before the dialog can be closed.', mtWarning, [ mbOK ], 0 );
    CanClose := False;
  end;
end;

procedure TfrmRecode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tblValues.Close;
  wtblMap.Close;
  wqrySource.Close;
  wtblTarget.Close;
end;

procedure TfrmRecode.FormShow(Sender: TObject);
var s : string;
begin
  s := 'Recoding ' + modLibrary.wtblQuestion.Lookup( 'Core', modLibrary.wtblRecodeCore.value, 'Short' );
  caption := s;
end;

end.
