unit foptions;

{
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
03-01-2006  GN01   Since this is a modal form changed the Form's BorderStyle to bsDialog
                   Set the ModalResult property of OK and Cancel button's.

11-10-2006  GN02   Handentry mapping

}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ComCtrls, ExtCtrls, checklst, Db,
  DBTables, DBGrids, Spin, Buttons;

type
  Tf_options = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    tsSequencing: TTabSheet;
    OKbtn: TButton;
    CancelBtn: TButton;
    tsLanguages: TTabSheet;
    tsFonts: TTabSheet;
    gbQuestionfont: TGroupBox;
    rbQstnArial: TRadioButton;
    rbQstnArialNarrow: TRadioButton;
    cbQstnSize: TComboBox;
    gbScaleFont: TGroupBox;
    rbScaleArial: TRadioButton;
    rbScaleArialNarrow: TRadioButton;
    cbScaleSize: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    LangCheckListBox: TCheckListBox;
    Label3: TLabel;
    tsPaperChoices: TTabSheet;
    rgPaperChoice: TRadioGroup;
    pnlPaperChoiceNote: TPanel;
    dsSectOrder: TDataSource;
    DBGridSectOrder: TDBGrid;
    gbResponseShape: TGroupBox;
    rbBubbles: TRadioButton;
    rbBoxes: TRadioButton;
    lblPaperChoiceNote: TLabel;
    gbShading: TGroupBox;
    rbShadingOn: TRadioButton;
    rbShadingOff: TRadioButton;
    gbTwoColumn: TGroupBox;
    chbTwoCols: TCheckBox;
    tsAdvanced: TTabSheet;
    cbSpreadQuestions: TCheckBox;
    Label4: TLabel;
    editExtraSpace: TSpinEdit;
    Label5: TLabel;
    tsMap: TTabSheet;
    lbMetaFields: TListBox;
    reHandEntry: TRichEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    procedure OKbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LangCheckListBoxClickCheck(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure cbSpreadQuestionsClick(Sender: TObject);
    procedure cbSpreadQuestionsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    //lstMapFields : TStringList;
  public
    { Public declarations }
  end;

var
  f_options: Tf_options;

implementation

uses datamod, fdynaq, DOpenQ;

{$R *.DFM}

procedure Tf_options.OKbtnClick(Sender: TObject);
var i : integer;
  procedure DeleteAllForeignRecs(const Lang:string);
  begin
    dmOpenQ.cn.execute('delete from sel_qstns where language='+lang);
    dmOpenQ.cn.execute('delete from sel_Scls where language='+lang);
    dmOpenQ.cn.execute('delete from sel_Textbox where language='+lang);
    dmOpenQ.cn.execute('delete from sel_PCL where language='+lang);
  end;
begin
  with LangCheckListBox, dmOpenQ.t_Language do begin
    first;
    i := 0;
    while not eof do begin
      if fieldbyname('UseLang').asboolean <> checked[i] then begin
        if not checked[i] then begin
          if messagedlg('By unchecking '+fieldbyname('language').text+
              ', you will delete any translations done on the cover '+
              'letters, postcards and comment boxes.  Do you really want '+
              'to uncheck '+fieldbyname('language').text+'?',mtconfirmation,
              [mbyes,mbno],0)=mrYes then
            DeleteAllForeignRecs(fieldbyname('Langid').asString)
          else
            checked[i] := true;
        end;
        edit;
        fieldbyname('UseLang').asboolean := checked[i];
        post;
        dmOpenQ.SaveDialog.tag := 2;
      end;
      inc(i);
      next;
    end;
  end;
  if rbQstnArial.Checked then dmOpenQ.QstnFont := 'Arial'
  else dmOpenQ.QstnFont := 'Arial Narrow';
  if rbScaleArial.Checked then dmOpenQ.SclFont := 'Arial'
  else dmOpenQ.SclFont := 'Arial Narrow';
  dmOpenQ.QstnPoint := strtoint(cbQstnSize.text);
  dmOpenQ.SclPoint := strtoint(cbScaleSize.text);
  if rbBubbles.checked then dmOpenQ.ResponseShape := 1
  else dmOpenQ.ResponseShape := 2;
  dmOpenQ.ShadingOn := rbShadingOn.checked;
  dmOpenQ.ConsiderDblLegal := (rgPaperChoice.itemindex=0);
  dmOpenQ.TwoColumns  := chbTwoCols.Checked;
  if {QPV2}(1=2) then dmOpenQ.SaveSectionOrder;
  dmOpenQ.ExtraSpace := editExtraSpace.value;
  dmOpenQ.SpreadToFillPages := cbSpreadQuestions.checked;
  //close; GN01
end;

procedure Tf_options.FormCreate(Sender: TObject);
  procedure LanguageOptions;
  begin
    with LangCheckListBox, dmOpenQ.t_Language do begin
      first;
      Items.clear;
      while not eof do begin
        items.AddObject(fieldbyname('Language').text,tobject(fieldbyname('LangID').asinteger));
        checked[items.count-1] := fieldbyname('UseLang').asboolean;
        next;
      end;
    end;
  end;
  procedure ScaleOptions;
  begin
    if dmOpenQ.QstnFont = 'Arial Narrow' then rbQstnArialNarrow.checked := true
    else rbQstnArial.checked := true;
    if dmOpenQ.SclFont = 'Arial Narrow' then rbScaleArialNarrow.checked := true
    else rbScaleArial.checked := true;
    if (dmOpenQ.QstnPoint>=9) and (dmOpenQ.QstnPoint<=12) then
      cbQstnSize.itemindex := dmOpenQ.QstnPoint - 9
    else
      cbQstnSize.itemindex := 2;
    if (dmOpenQ.SclPoint>=9) and (dmOpenQ.SclPoint<=12) then
      cbScaleSize.itemindex := dmOpenQ.SclPoint - 9
    else
      cbScaleSize.itemindex := 1;
    if (dmOpenQ.ResponseShape=2) then
      rbBoxes.checked := true
    else
      rbBubbles.checked := true;
    if (dmOpenQ.ShadingOn) then
      rbShadingOn.checked := true
    else
      rbShadingOff.checked := true;
  end;
  procedure PaperChoiceOptions;
  begin
    if dmOpenQ.ConsiderDblLegal then
      rgPaperChoice.itemindex := 0
    else
      rgPaperChoice.itemindex := 1;
    lblPaperChoiceNote.caption :=
      '14" x 17" paper (double-legal) is more difficult to deal with in the printing'+#10+
      'and inserting processes than other sizes of paper.  If you select "Don''t'+#10+
      'consider 14" x 17" paper," questionnaires that are long enough to'+#10+
      'warrant a 14" x 17" sheet will be printed in an 11" x 17" booklet.'+#10+
      ''+#10+
      'In general, only select "Consider 14" x 17" paper" if the client requires'+#10+
      'that page size.';
  end;
  procedure SequencingOptions;
  begin
    dmOpenQ.DefaultSectionOrder(true);
    with dmOpenQ.tmptbl do
      indexfieldnames := 'newOrder';
  end;
  procedure AdvancedOptions;
  begin
    chbTwoCols.Checked := dmOpenQ.TwoColumns;
    cbSpreadQuestions.Checked := dmOpenQ.SpreadToFillPages;
    editExtraSpace.value := dmOpenQ.ExtraSpace;
    cbSpreadQuestionsClick(Sender);
  end;

   function LoadRichText(richTxt : TBlobField) : string;
   var
      bStream : TBlobStream;
   begin
      result := '';
      bStream := TBlobStream.Create(richTxt, bmRead);
      try
         reHandEntry.Lines.LoadFromStream(bStream);
      finally
         bStream.Free;
      end;
   end;

  //gntest
  procedure GetScaleHandEntry;
  var
     sScaleText:string;
     sItem : string;
     i : integer;

  begin
    with dqDataModule.wwT_ScaleText do begin
      MasterSource := nil;
      indexFieldNames := 'Scale;Item;LangID';
      dmOpenQ.wwt_scls.first;
      i :=0;
      while not dmOpenQ.wwt_scls.eof do
      begin
        if findkey([dmOpenQ.wwt_Scls.fieldbyname('QPC_ID').value,dmOpenQ.wwt_Scls.fieldbyname('Item').value,1]) then
        begin
            sScaleText := {dmOpenQ.wwt_Scls.fieldbyname('Item').AsString  + }dqDataModule.wwT_ScaleTextText.AsString ;
            if reHandEntry.Lines.Count = 0 then
               reHandEntry.selStart := Length(sScaleText);

            if Pos('___',sScaleText) >0 then
            begin
               Inc(i);
               sItem := IntToStr(i);
               sScaleText[Pos('_', sScaleText)] := '[' ;
               sScaleText[Pos('_', sScaleText)] :=  sItem[1];
               sScaleText[Pos('_', sScaleText)] := ']' ;

               reHandEntry.selText := sScaleText + #13#10;
            end;
        end;
        dmOpenQ.wwt_Scls.next;
      end;
      indexFieldNames := 'Scale;Item';
      Mastersource := dqDataModule.wwDS_ScaleValues;
    end;
  end;

  //GN02: Hand entry
  procedure ScaleMapping;
  begin
     dmOpenQ.GetMappingMetaFields();
     lbMetaFields.Items.Clear ;
     with dmOpenQ.sp_QPProd do
     begin
        while not(EOF) do
        begin
           lbMetaFields.Items.Add(FieldByName('strField_Nm').AsString + '=' + FieldByName('Field_id').AsString) ;
           Next;
        end;
     end;
     GetScaleHandEntry;
  end;

begin
  //lstMapFields := TStringList.Create;
  PageControl1.ActivePage := tsFonts ;
  LanguageOptions;
  ScaleOptions;
  PaperchoiceOptions;
  // see OpenSQLQstns in DMOpenQ
  if {QPV2}(1=2) then SequencingOptions
  else tsSequencing.tabvisible := false;
  AdvancedOptions;
  //ScaleMapping; gntest
end;

procedure Tf_options.LangCheckListBoxClickCheck(Sender: TObject);
begin
  LangCheckListBox.checked[0] := true;
end;

procedure Tf_options.CancelBtnClick(Sender: TObject);
begin
  dmOpenQ.tmptbl.close;
  //close;
end;

procedure Tf_options.cbSpreadQuestionsClick(Sender: TObject);
begin
  if not cbSpreadQuestions.Checked then
    editExtraSpace.Enabled := true
  else begin
    editExtraSpace.Value := 0;
    editExtraSpace.Enabled := false;
  end;
end;

procedure Tf_options.cbSpreadQuestionsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  cbSpreadQuestionsClick(Sender);
end;


end.
