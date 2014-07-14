unit NewScale;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, Grids, DBGrids, StdCtrls, DBCtrls, ExtCtrls, Mask,
  ToolWin, db, Spin, DBCGrids, DBRichEdit, CDK_Comp;

type
  TfrmNewScale = class(TForm)
    PageControl: TPageControl;
    tsScaleSelection: TTabSheet;
    gridScaleName: TDBGrid;
    FindDialog: TFindDialog;
    Panel1: TPanel;
    btnFind: TSpeedButton;
    btnFindNext: TSpinButton;
    tsEditValues: TTabSheet;
    DBCtrlGrid: TDBCtrlGrid;
    editOrder: TDBEdit;
    editValue: TDBEdit;
    editShort: TDBEdit;
    comboType: TDBComboBox;
    comboCharset: TDBComboBox;
    CheckBoxMissing: TDBCheckBox;
    Panel2: TPanel;
    HeaderControl1: THeaderControl;
    GroupBox1: TGroupBox;
    clDBRichCodeBtn: TclDBRichCodeBtn;
    btnInsert: TSpeedButton;
    DBText1: TDBText;
    rgScalePosition: TRadioGroup;
    cbFielded: TDBCheckBox;
    rgResponseRule: TRadioGroup;
    dbMean: TDBCheckBox;
    dbeScaleLabel: TDBEdit;
    Bevel1: TBevel;
    btnDelete: TSpeedButton;
    clCodeToggle1: TclCodeToggle;
    btnCode: TSpeedButton;
    btnSpellCheck: TSpeedButton;
    tsSpellCheck: TTabSheet;
    DBEdit1: TDBEdit;
    DBRichEdit1: TDBRichEdit;
    procedure dbeScaleLabelChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rgScalePositionClick(Sender: TObject);
    procedure rgResponseRuleClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure btnFindNextDownClick(Sender: TObject);
    procedure btnFindNextUpClick(Sender: TObject);
    procedure comboCharsetDropDown(Sender: TObject);
    procedure editOrderExit(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure gridScaleNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure clDBRichCodeBtnChange(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure editShortExit(Sender: TObject);
    procedure DBCtrlGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCodeClick(Sender: TObject);
    procedure btnSpellCheckClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBRichEdit2ProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure editShortKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure UpdateRadioGroups;
    procedure CheckHeaders;
  public
    { Public declarations }
  end;

var
  frmNewScale: TfrmNewScale;

implementation

{$R *.DFM}

uses data, lookup, Code, Support;

var FirstFind : boolean;
    orgValuesIndex : string;

procedure TfrmNewScale.dbeScaleLabelChange(Sender: TObject);
begin
  UpdateRadioGroups;
  if modlibrary.tblScaleFielded.value>0 then begin
    clDBRichCodeBtn.ReadOnly := true;
    editorder.readonly := true;
    editValue.readonly := true;
    editShort.readonly := true;
    comboType.readonly := true;
    comboCharset.readonly := true;
    checkboxMissing.readonly := true;
    dbMean.enabled := false;
    rgResponseRule.enabled := false;
    //btnDelete.enabled := false; {handled in btnDeleteClick}
  end else begin
    clDBRichCodeBtn.ReadOnly := false;
    editorder.readonly := false;
    editValue.readonly := false;
    editShort.readonly := false;
    comboType.readonly := false;
    comboCharset.readonly := false;
    checkboxMissing.readonly := false;
    dbMean.enabled := true;
    rgResponseRule.enabled := true;
    //btnDelete.enabled := true; {handled in btnDeleteClick}
  end;
end;

procedure tfrmNewScale.UpdateRadioGroups;
begin
  with modlibrary do begin
    if tblScaleright.value then
      rgScalePosition.ItemIndex := 0
    else
      rgScalePosition.ItemIndex := 1;
    if tblScaleMarkCount.value = 1 then
      rgResponseRule.ItemIndex := 0
    else
      rgResponseRule.ItemIndex := 1;
    rgResponseRule.enabled := (tblScaleFielded.value=0);
  end;
end;

procedure TfrmNewScale.FormActivate(Sender: TObject);
begin
  UpdateRadioGroups;
end;

procedure TfrmNewScale.rgScalePositionClick(Sender: TObject);
var EditState : boolean;
begin
  with modLibrary do begin
    EditState := (tblScale.state in dsEditModes);
    if not EditState then tblScale.edit;
    tblScaleRight.value := (rgScalePosition.ItemIndex=0);
    if not EditState then tblScale.post;
  end;
end;

procedure TfrmNewScale.rgResponseRuleClick(Sender: TObject);
var EditState : boolean;
begin
  with modLibrary do begin
    EditState := (tblScale.state in dsEditModes);
    if not EditState then tblScale.edit;
    tblScaleMarkCount.value := 1+rgResponseRule.ItemIndex;
    if not EditState then tblScale.post;
  end;
end;

procedure TfrmNewScale.btnFindClick(Sender: TObject);
begin
  FindDialog.Execute;
end;

procedure TfrmNewScale.FindDialogFind(Sender: TObject);
var searchfor : string;
    SearchDown : boolean;
    CaseSensitive : boolean;
    bm : tbookmark;

  function InThere:boolean;
  begin
    with modlibrary do
      if CaseSensitive then
        InThere := (pos(SearchFor,tblScaleLabel.value)>0)
      else
        InThere := (pos(SearchFor,uppercase(tblScaleLabel.value))>0)
  end;

begin
  with FindDialog do begin
    CaseSensitive := frMatchCase in Options;
    SearchDown := frDown in Options;
    if CaseSensitive then
      SearchFor := FindText
    else
      SearchFor := uppercase(FindText);
  end;
  with ModLibrary.tblScale do begin
    disablecontrols;
    bm := getbookmark;
    if (not FirstFind) then
      if SearchDown then begin
        if (not eof) then next;
      end else
        if (not bof) then prior;
    FirstFind := false;
    if SearchDown then begin
      repeat begin
        if InThere then break;
        next;
      end until eof;
      if not InThere then begin
        gotoBookmark(bm);
        messagebeep(MB_ICONASTERISK);
      end;
    end else begin
      repeat begin
        if InThere then break;
        prior;
      end until bof;
      if not InThere then begin
        gotoBookmark(bm);
        messagebeep(MB_ICONASTERISK);
      end;
    end;
    freebookmark(bm);
    enablecontrols;
  end;
end;

procedure TfrmNewScale.btnFindNextDownClick(Sender: TObject);
begin
  if not FirstFind then begin
    finddialog.options := finddialog.options + [frDown];
    FindDialogFind(sender);
  end;
end;

procedure TfrmNewScale.btnFindNextUpClick(Sender: TObject);
begin
  if not FirstFind then begin
    finddialog.options := finddialog.options - [frDown];
    FindDialogFind(sender);
  end;
end;

procedure TfrmNewScale.comboCharsetDropDown(Sender: TObject);
begin
  comboCharSet.items.clear;
  if modlibrary.tblValuesType.value = stBubble then
    comboCharSet.items.add('Not applicable')
  else begin
    comboCharSet.items.add('Numeric');
    comboCharSet.items.add('Alpha');
    comboCharSet.items.add('Alpha/Numeric');
  end;
end;

procedure TfrmNewScale.editOrderExit(Sender: TObject);
begin
  with modLibrary.tblValues do
    if state in dsEditModes then
      post;
end;

procedure TfrmNewScale.CheckHeaders;
begin
  if Modlibrary.tblValuesType.value = stBubble then
    HeaderControl1.Sections[2].text := 'Value'
  else
    HeaderControl1.Sections[2].text := 'Width'
end;

procedure TfrmNewScale.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = tsScaleSelection then begin
    btnFind.enabled := true;
    btnFindNext.enabled := true;
    btnInsert.Enabled := true;
    //btnDelete.Enabled := (modlibrary.tblScaleFielded.value=0); {handled in btnDeleteClick}
    btnCode.enabled := false;
  end else begin
    btnFind.enabled := false;
    btnFindNext.enabled := false;
    btnCode.enabled := (modLibrary.tblScalefielded.value=0);
    btnInsert.Enabled := btnCode.enabled;
    //btnDelete.Enabled := btnCode.enabled; {handled in btnDeleteClick}
    CheckHeaders;
  end;
end;

procedure TfrmNewScale.gridScaleNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if modlibrary.tblScale.eof and (Key=vk_Down) then key := vk_Right;
end;

procedure TfrmNewScale.clDBRichCodeBtnChange(Sender: TObject);
begin
  CheckHeaders;
end;

procedure TfrmNewScale.btnInsertClick(Sender: TObject);
var maxItem,maxValue,NewKey : integer;
begin
  with modLibrary do begin
{
    if tblScale.state in dsEditModes then tblScale.post;
    if tblvalues.state in dsEditModes then tblValues.post;
    if tblScaleText.state in dsEditModes then tblScaleText.post;
}
    if PageControl.ActivePage = tsScaleSelection then begin
      tblScale.IndexFieldNames := 'Scale';
      tblScale.last;
      NewKey := tblScaleScale.Value;
      tblScale.append;
      tblScaleScale.Value := succ(NewKey);
      tblScaleFielded.value := 0;
      tblScaleMean.value := true;
      tblScaleRight.value := true;
      tblScaleMarkCount.value := 1;
      frmNewScale.ActiveControl := dbeScaleLabel;
      tblScale.post;
    end else begin
      if tblScaleFielded.value <> 0 then begin
        if not modLookup.tblQuestion.Locate( 'Scale', tblScaleScale.value, [ ] ) then begin
          tblScale.Edit;
          tblScaleFielded.value := 0;
          tblScale.post;
        end else
          messagedlg('Scale cannot be modified if it is used in a question.',mtwarning,[mbok],0);
      end;
      if tblScaleFielded.value = 0 then begin
        frmNewScale.activecontrol := editShort;
{
        if tblScaleText.state in dsEditModes then
          tblScaleText.post;
        if tblvalues.state in dsEditModes then
          tblValues.post;
}
        while (not tblValues.bof) and (tblvaluesscale.value=tblScalescale.value) do
          tblValues.prior;
        maxItem := -9999;
        maxValue := -9999;
        while (not tblValues.eof) and (tblvaluesscale.value=tblScalescale.value) do begin
          if maxItem < tblValuesItem.value then
            maxItem := tblValuesItem.value;
          if maxValue < tblValuesBubbleValue.value then
            maxValue := tblValuesBubbleValue.value;
          tblValues.next;
        end;
        NewKey := succ(tblValuesOrder.value);
        tblValues.insert;
        {tblValuesScale.value := tblScaleScale.value;}
        tblValuesItem.value := succ(MaxItem);
        tblValuesType.value := stBubble;
        tblValuesBubbleValue.value := succ(MaxValue);
        tblValuesCharSet.value := 1;
        tblValuesMissing.value := false;
        tblValuesOrder.value := NewKey;
        tblValues.post;
        tblScaleText.edit {insert};
        tblScaleTextScale.value := tblScaleScale.value;
        tblScaleTextItem.value := succ(MaxItem);
        tblScaleTextLangID.value := 1;
        tblScaleTextReview.value := False;
        tblScaleText.post;
      end;
    end;
  end;
end;


procedure TfrmNewScale.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
type
  tValLbl = record
    report,survey : string[50];
    val : integer;
  end;
var
  ValLbl : array[1..40] of tValLbl;
  i : integer;
  orgfilter, s : string;
  orgfiltered : boolean;
begin
  if (PageControl.ActivePage = tsEditValues) then begin
    if (not clDBRichCodeBtn.ReadOnly) then begin
      with modlibrary, tblValues do begin
        orgfilter := tblScaleText.filter;
        orgfiltered := tblScaleText.filtered;
        tblScaleText.filter := 'langid=1';
        tblScaleText.filtered := true;
        first;
        i := 0;
        s := '';
        clDBRichCodeBtn.wordwrap := false;
        repeat begin
          inc(i);
          vallbl[i].val := tblValuesBubbleValue.value;
          vallbl[i].report := tblValuesShort.value;
          vallbl[i].survey := clDBRichCodeBtn.lines[0];
          if vallbl[i].report = '' then vallbl[i].report := '<empty>';
          if vallbl[i].survey = '' then vallbl[i].survey := '<empty>';
          if (vallbl[i].report <> vallbl[i].survey) then
            s := s + '('+inttostr(vallbl[i].val)+') '+vallbl[i].report + ' <> ' + vallbl[i].survey + #13
          else
            if (vallbl[i].report = '<empty>') then
              s := s + '('+inttostr(vallbl[i].val)+') no labels defined' + #13;
          next;
        end until eof;
        clDBRichCodeBtn.wordwrap := true;
        if s <> '' then
          if messagedlg('Some labels are undefined or report labels are different from survey labels.' + #13 +
              s + 'Is this OK?',mtConfirmation,[mbYes,mbNo],0)=mrNo then
            Allowchange := false;
        tblScaleText.filter := orgfilter;
        tblScaleText.filtered := orgfiltered;
      end;
    end;
  end else {(PageControl.ActivePage <> tsEditValues)}
    with modlibrary do begin
      if tblScale.state in dsEditModes then tblScale.post;
      if tblScaleLabel.value = '' then begin
        AllowChange := false;
        messagedlg('You must supply a name for each scale.',mterror,[mbok],0);
      end;
    end;
end;

procedure TfrmNewScale.FormClose(Sender: TObject; var Action: TCloseAction);
var AllowClose:boolean;
begin
  Allowclose := true;
  PageControlChanging(Sender, AllowClose);
  if not AllowClose then Action := caNone;
end;

procedure TfrmNewScale.FormCreate(Sender: TObject);
begin
  PageControl.ActivePage := tsScaleSelection;
  if not clDBRichCodeBtn.Codedata.Active then
    clDBRichCodeBtn.Codedata.open;
  if not clDBRichCodeBtn.ConstData.Active then
    clDBRichCodeBtn.ConstData.open;
  orgValuesIndex := modLibrary.tblValues.IndexFieldNames;
  modLibrary.tblValues.IndexFieldNames := 'Scale;ScaleOrder';
  FirstFind := true;
end;

procedure TfrmNewScale.btnDeleteClick(Sender: TObject);
var reallydoit:boolean;
begin
  with modlibrary do begin
    reallydoit := false;
    if not modLookup.tblQuestion.Locate( 'Scale', tblScaleScale.value, [ ] ) then begin
      if tblScaleFielded.value <> 0 then begin
        tblScale.Edit;
        tblScaleFielded.value := 0;
        tblScale.post;
      end;
      reallydoit := (messagedlg('Do you really want to delete this scale?',mtconfirmation,[mbyes,mbno],0)=mrYes);
    end else begin
      if tblScaleFielded.value = 0 then begin
        tblScale.Edit;
        tblScaleFielded.value := 1;
        tblScale.post;
      end;
      messagedlg('Scale cannot be deleted or modified if it is used in a question. '+modLookup.tblQuestion.fieldbyname('Core').text,mtwarning,[mbok],0);
    end;
    if (reallydoit) and (tblScaleFielded.value = 0) then
      if PageControl.ActivePage = tsScaleSelection then
        tblScale.delete
      else
        if DBCtrlGrid.panelcount > 1 then
          tblValues.delete
        else
          messagedlg('Can''t delete the last value!',mterror,[mbok],0);
  end;
end;

procedure TfrmNewScale.editShortExit(Sender: TObject);
begin
  with modlibrary do
    if clDBRichCodeBtn.lines[0] = '' then begin
      if not (tblScaleText.state in dsEditModes) then tblScaleText.edit;
      clDBRichCodeBtn.lines[0] := editshort.text;
      tblScaleText.post;
    end;
end;

procedure TfrmNewScale.DBCtrlGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (key=ord('I')) then
    btnInsertClick(Sender);
end;

procedure TfrmNewScale.btnCodeClick(Sender: TObject);
begin
  if vAsText then begin            {DG}
    vAsText := False;              {DG}
    clDBRichCodeBtn.UpdateRichText(cText); {DG}
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

procedure TfrmNewScale.btnSpellCheckClick(Sender: TObject);
begin
  if PageControl.ActivePage = tsEditValues then
    with modlibrary do begin
      if tblScale.state in dsEditModes then tblScale.post;
      if tblValues.state in dsEditModes then tblValues.post;
      if tblScaleText.state in dsEditModes then tblScaleText.post;
      PageControl.ActivePage := tsSpellCheck;
      tblValues.First;
      modsupport.dlgSpell.closewin := false;
      modsupport.dlgSpell.show;
      while not tblValues.eof do begin
        modsupport.checkme(DBEdit1,DBEdit1.datasource,false,false);
        modsupport.checkme(DBRichEdit1,DBRichEdit1.datasource,false,false);
        tblValues.next;
      end;
      modsupport.dlgSpell.close;
      modsupport.dlgSpell.closewin := true;
      PageControl.ActivePage := tsEditValues;
    end;
end;

procedure TfrmNewScale.FormDestroy(Sender: TObject);
begin
  modLibrary.tblValues.IndexFieldNames := orgValuesIndex;
end;

procedure TfrmNewScale.DBRichEdit2ProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  allowchange := true;
end;

procedure TfrmNewScale.editShortKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not modlibrary.srcvalues.autoedit then begin
     if messagedlg('This scale is already used for one or more questions.  You shouldn''t edit it unless you''re fixing a typo or otherwise understand what questions this will impact.  Do you want to edit it?', mtconfirmation, [mbYes,mbNo],0) = mrYes then begin
       editShort.ReadOnly := false;
       clDBRichCodeBtn.ReadOnly := false;
       modlibrary.srcvalues.autoedit := true;
       modLibrary.srcScaleText.AutoEdit := true;
     end;
  end;
end;

end.
