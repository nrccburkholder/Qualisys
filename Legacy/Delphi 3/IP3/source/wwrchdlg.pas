unit wwrchdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, wwintl,
  StdCtrls, Mask, wwdbedit, Wwdotdot, Wwdbcomb, comctrls, buttons, wwsystem,
  wwstr, wwriched, wwcommon;

type
  TwwRichParagraphDialog = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LeftEdit: TEdit;
    RightEdit: TEdit;
    FirstLineEdit: TEdit;
    AlignmentCombo: TwwDBComboBox;
    Label4: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OKClick(Sender: TObject);
  private
{    OKBtn, CancelBtn: TButton;}
    Procedure ApplyIntl;
  public
    RichEdit: TwwCustomRichEdit;
    { Public declarations }
  end;

var
  wwRichParagraphDialog: TwwRichParagraphDialog;

Function wwRichEditParagraphDlg(richedit1: TwwCustomRichEdit): boolean;

implementation

{$R *.DFM}

Function wwRichEditParagraphDlg(richedit1: TwwCustomRichEdit): boolean;
var templeft, tempRight, tempFirst: integer;  {Twips for better accuracy}
    temp: double;
begin
   with TwwRichParagraphDialog.create(Application) do begin

      RichEdit:= richedit1;
      ApplyIntl;
      richedit1.GetParaIndent(tempLeft, tempRight, tempFirst);
      temp:= richedit.TwipsToUnits(tempLeft) + richedit.TwipsToUnits(tempFirst);;
      LeftEdit.text:= richedit.FormatUnitStr(temp);
      FirstLineEdit.Text:= richedit.FormatUnitStr(richedit.TwipsToUnits(-tempLeft));
      RightEdit.Text:= richedit.FormatUnitStr(richedit.TwipsToUnits(tempRight));
      case richedit1.paragraph.alignment of
         taleftJustify: AlignmentCombo.text:=wwInternational.RichEdit.ParagraphDialog.AlignLeft;
         taRightJustify: AlignmentCombo.text:=wwInternational.RichEdit.ParagraphDialog.AlignRight;
         taCenter: AlignmentCombo.text:=wwInternational.RichEdit.ParagraphDialog.AlignCenter;
      end;
      result:= ShowModal=mrOK;
      if result then begin
         tempLeft:= -richedit.UnitStrToTwips(FirstLineEdit.text);
         tempLeft:= wwmin(tempLeft, richedit.UnitStrToTwips(LeftEdit.text));
         tempFirst:= richedit.UnitStrToTwips(FirstLineEdit.text) +
                     richedit.UnitStrToTwips(LeftEdit.text);
         richedit1.SetParaFormat([rpoLeftIndent, rpoRightIndent, rpoFirstLineIndent, rpoAlignment],
           AlignmentCombo.text, False, tempLeft,
           richedit.UnitStrToTwips(RightEdit.text), tempFirst, 0, nil);
      end
   end

end;

procedure TwwRichParagraphDialog.FormCreate(Sender: TObject);
begin
{   OkBtn:= TButton(wwCreateCommonButton(Self, bkOK));
   OKBtn.TabOrder := 4;
   OKBtn.onClick:= OKClick;
   CancelBtn:= TButton(wwCreateCommonButton(Self, bkCancel));
   CancelBtn.TabOrder := 5;

   OkBtn.Top:= wwAdjustPixels(16, PixelsPerInch);
   CancelBtn.Top:= wwAdjustPixels(52, PixelsPerInch);
   OkBtn.Left:= wwAdjustPixels(180, PixelsPerInch);
   CancelBtn.Left:= wwAdjustPixels(180, PixelsPerInch);
   OkBtn.visible:= True;
   CancelBtn.visible:= True;
}
end;

procedure TwwRichParagraphDialog.OKClick(Sender: TObject);

   Function ValidValue(str: string): boolean;
   var twips: integer;
   begin
      result:= False;
      strStripTrailing(str, ['''', ' ', 'c', 'm', 'C', 'M']);
      if not wwstrtofloat(str) then exit;

      twips:= richedit.UnitStrToTwips(str);
      if (twips<-22*1440) or (twips>22*1440) then exit;
      result:= True;
   end;

begin
   if not ValidValue(leftEdit.text) then begin
      LeftEdit.setFocus;
      modalResult:= mrNone;
   end
   else if not ValidValue(FirstLineEdit.text) then begin
      FirstLineEdit.setFocus;
      modalResult:= mrNone;
   end
   else if not ValidValue(RightEdit.text) then begin
      RightEdit.setFocus;
      modalResult:= mrNone;
   end;
end;

procedure TwwRichParagraphDialog.ApplyIntl;
begin
    with wwInternational.RichEdit do begin

      Caption := ParagraphDialog.ParagraphDlgCaption;

      OKBtn.Caption := wwInternational.BtnOKCaption;
      CancelBtn.Caption := wwInternational.BtnCancelCaption;

      GroupBox1.Caption := ParagraphDialog.IndentationGroupBoxCaption;
      Label1.Caption := ParagraphDialog.LeftEditCaption;
      Label2.Caption := ParagraphDialog.RightEditCaption;
      Label3.Caption := ParagraphDialog.FirstLineEditCaption;
      Label4.Caption := ParagraphDialog.AlignmentCaption;

      if (reoShowHints in RichEdit.EditorOptions) then begin
         LeftEdit.ShowHint := True;
         RightEdit.ShowHint := True;
         FirstLineEdit.ShowHint := True;
         AlignmentCombo.ShowHint := True;

         LeftEdit.Hint := ParagraphDialog.LeftEditHint;
         RightEdit.Hint := ParagraphDialog.RightEditHint;
         FirstLineEdit.Hint := ParagraphDialog.FirstLineEditHint;
         AlignmentCombo.Hint := ParagraphDialog.AlignmentHint;
      end;

      AlignmentCombo.items.clear;
      AlignmentCombo.items.add(ParagraphDialog.AlignLeft);
      AlignmentCombo.items.add(ParagraphDialog.AlignCenter);
      AlignmentCombo.items.add(ParagraphDialog.AlignRight);
      AlignmentCombo.Applylist;

    end;
end;

end.
