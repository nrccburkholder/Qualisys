{
//
// Components : TwwFilterDialogView
//
// Copyright (c) 1996, 1997 by Woll2Woll Software
//
//
}
unit Wwfltvw;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, Sysutils, wwdbgrid, dialogs, wwtypes, wwcommon;

type
  TwwFilterDialogView = class(TForm)
    StringGrid1: TStringGrid;
    CancelBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1Enter(Sender: TObject);
  private
     Procedure ApplyIntl;
  public
     OKBtn: TButton;
     constructor create(AOwner: TComponent); override;
  end;

  procedure wwFilterDialogView(tc: TComponent;FieldInfo: TList);

implementation

{$R *.DFM}
uses wwfltdlg, wwstr, wwintl;

constructor TwwFilterDialogView.create(AOwner: TComponent);
begin
   inherited Create(AOwner);

    { 3/20/97 - Added for Large Font Adjustment}
   width := wwAdjustPixels(489,PixelsPerInch);
   StringGrid1.Width := wwAdjustPixels(464,PixelsPerInch);
   StringGrid1.ColWidths[0]:= wwAdjustPixels(120,PixelsPerInch);
   StringGrid1.ColWidths[1]:= wwAdjustPixels(140,PixelsPerInch);
   StringGrid1.ColWidths[2]:= wwAdjustPixels(197,PixelsPerInch);

   OkBtn:= TButton(wwCreateCommonButton(Self, bkOK));
   OKBtn.TabOrder := 0;
   OKBtn.Top := stringgrid1.top + stringgrid1.height + (screen.pixelsperinch * 9) div 96;
   OkBtn.Left:= (Width - OKBtn.width) div 2;
   OKBtn.visible:= True;
end;

procedure wwFilterDialogView(tc:TComponent;FieldInfo: TList);
var tempStr: string;
    i: integer;
    NotStr: string;
    fd: TwwFilterDialog;
    SearchDelimiter: string;
    OrFlg,AndFlg,parens:boolean;

   Function MatchTypeStr(MatchType: TwwFilterMatchType): string;
   begin
      result:= '';
      case MatchType of
         fdMatchExact: result:= strRemoveChar(wwInternational.FilterDialog.MatchExactLabel, '&');
         fdMatchStart: result:= strRemoveChar(wwInternational.FilterDialog.MatchStartLabel, '&');
         fdMatchAny: result:= strRemoveChar(wwInternational.FilterDialog.MatchAnyLabel, '&');
      end
   end;

begin
   fd := (TC as TwwFilterDialog);

   with TwwFilterDialogView.create(Application) do begin

      NotStr := wwInternational.FilterDialog.ViewSummaryNotText;
      StringGrid1.RowCount:= FieldInfo.count + 1;

      for i:= 0 to FieldInfo.count-1 do begin
         with TwwFieldInfo(FieldInfo[i]), StringGrid1 do
         begin
            case MatchType of
               fdMatchExact, fdMatchStart, fdMatchAny: begin
                  Cells[0, i+1]:= DisplayLabel;
                  Cells[1, i+1]:= MatchTypeStr(MatchType);

                  parens:=false;
                  SearchDelimiter := wwGetFilterOperator(FilterValue,fd.FieldOperators,OrFlg,AndFlg);
                  if (SearchDelimiter <> '') then parens := true;

                  if NonMatching then begin
                    if parens then
                      Cells[2, i+1]:= NotStr + ' (' + FilterValue + ')'
                    else
                      Cells[2, i+1]:= NotStr + ' ' + FilterValue;
                  end
                  else
                    Cells[2, i+1]:= FilterValue;
               end;

               fdMatchRange: begin
                  Cells[0, i+1]:= DisplayLabel;
                  Cells[1, i+1]:= strRemoveChar(wwInternational.FilterDialog.ByRangeLabel, '&');

                  tempStr:= '';
                  if (MinValue<>'') then
                     tempStr:= '>=' + MinValue;
                  if (MaxValue<>'') then
                  begin
                     if tempStr<>'' then tempStr:= tempStr + ', ';
                     tempStr:= tempStr + '<=' + MaxValue;
                  end;
                  Cells[2, i+1]:=  tempStr;
               end;
            end { Case MatchType}
         end; {With TwwFieldInfo(FieldInfo[i]) }
      end; {For}

      ShowModal;
      Free;
   end
end;

procedure TwwFilterDialogView.FormCreate(Sender: TObject);
begin
  with stringgrid1 do begin
     rows[0].strings[0]:= wwInternational.FilterDialog.SummaryFieldLabel;
     rows[0].strings[1]:= wwInternational.FilterDialog.SummarySearchLabel;
     rows[0].strings[2]:= wwInternational.FilterDialog.SummaryValueLabel;
  end
end;

procedure TwwFilterDialogView.StringGrid1DrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var S: array[0..255] of Char;
    grid: TStringGrid;
begin
  Grid:= Sender as TStringGrid;
  strpcopy(s, Grid.cells[Col, Row]);
  if Row>0 then begin
     with Grid do begin
        Canvas.Brush.Color:= clWhite;
        Canvas.Font.Color:= clBlack;
        ExtTextOut(Canvas.Handle, Rect.Left + 2, Rect.Top + 2, ETO_OPAQUE or
            ETO_CLIPPED, @Rect, s, strlen(s), nil)
     end
  end
end;

Procedure TwwFilterDialogView.ApplyIntl;
begin
   Font.Style:= wwInternational.DialogFontStyle;
end;

procedure TwwFilterDialogView.FormShow(Sender: TObject);
begin
   ApplyIntl;
end;

procedure TwwFilterDialogView.StringGrid1Enter(Sender: TObject);
begin
   StringGrid1.EditorMode:= True;
   TEdit(TwwDBGrid(StringGrid1).InplaceEditor).readonly:= True;
   StringGrid1.EditorMode:= False;
end;

end.
