unit uLayoutCalc;

{
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
10-25-2005  GN01   Commented out the code which writes the blob fields
                   contents to the RichEdit and RichText.RTF on the users HD.

10-26-2005  GN02   Fixed the timing issue by streaming the blob field

11-01-2005  GN03   Added a new language MAGNUS Spanish(ID=18)

11-01-2005  GN04   The Alignment gets messed up when the Scale Text has CRLF,
                   as the CRLF is not accounted in WrapLongLines function.

11-15-2005  GN05   The Cover letter was missing the formatting(Ex bold)

12-08-2005  GN06   Increase CurX by 25 if you want indent in the text box.

12-16-2005  GN07   When the spanish scale value with a skip had a paranthesis
                   to denote a male or female, the entire skip value got embedded
                   into the same paranthesis.

12-30-2005  GN08   Added a new language HCAHPS  Spanish(ID=19)

01-19-2006  GN09   Fixed the problem with SkipPatterns overlapping with ScaleText.
                   This happens when the Scale text defined in the library has no consistent attrib

02-02-2006  GN10   experiment with PCL 5 Color(Tech Ref Manual)
                   0 = White
                   1 = Black
                   2 = Red
                   3 = Green
                   4 = Yellow
                   5 = Blue
                   6 = Magenta
                   7 = Cyan
                   n>7 Black

02-08-2006  GN11  Convert sticky spaces to white space for Cover Letter Textbox

02-28-2006  GN12  This problem is related to the QuestionNumber display for QuestionHeader
                  when you have the Add CodeSheet checked.

30-31-2006  GN13  In cover letter, if the PCLTextBox has bubble marking instructions(embedded PCLcommands).
                  The display text wraps to the next line as PCLCmd's were included in calculating the text width.

04-04-2006  GN14  An extra line appeared in the PCLTextBox when you underlined header text "Survey Instructions" in the cover letter.

05-12-2006  GN15  Qstn Nbr appears in bold even though the Question Text didnt contain any bolding.
                  The QstnCores with this problem 25922,23515,19997 in Survey 5382, 5385.

06-08-2006  GN16   Added a new language Sodexho  Spanish(ID=20)

08-16-2006  GN17   FAQSS couldn't capture the comment text as the extra space option increased the Y-CoOrd of the lines
                   Ex: Survey 5838

09-28-2006  GN18   Move the address location on the cover letter by 1/8th of an inch (75 pixels on 600 DPI).
                   Added the x and y constants to QualProParams

12-06-2006  GN19   Remove hardcoding for Skip patterns when a new language is created.
                   Added new language Montfort French(ID=22)
                   Program doesn't support Unicode chars

}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Printers, StdCtrls, ComCtrls, ExtCtrls, DBTables, DB, Math, Wwtable,
  DBRichEdit, common, uPCLString;

const
  MaxNumResps = 99;
  MaxNumScales = 200;
  BubbleWidth = 98;
  BubbleHeight = 60;
  ICRWidth = 150;
  ICRHeight = 150;
  LineSpacing = 108;
  BetweenBblandLbl = 54;
  GutterScaleBelow = 150;
  SplitMarker = #01;
  StartResultsColumn = 34;
  ESC = #27;
  PCLBoldOn = ESC + '(s3B';
  PCLBoldOff = ESC + '(s0B';
  PCLItalicOn = ESC + '(s1S';
  PCLItalicOff = ESC + '(s0S';
  PCLUnderlineOn = ESC + '&d0D';
  PCLUnderlineOff = ESC + '&d@';
  PCLShapeFont = ESC + '(1X';
  PCLBubble = 'E';
  PCLResponseBox = 'F';
  PCLReset = ESC + '&f6X' + ESC + '*c0F' + ESC + 'E';
  PCLReadable = false;
  CRLF = ''; {#13#10;}
  PCLPop = crlf + ESC + '&f1S';
  PCLPush = crlf + ESC + '&f0S';
  PCLPopPush = crlf + ESC + '&f1s0S';
  ptRealSurvey = 0;
  ptMockup = 1;
  ptCodeSheetMockup = 2;
(*Dev )
  CAHPSscale1 = 27; {Health Plan Membership}
  CAHPSscale2 = 28; {How many times?}
  CAHPSscale3 = 29; {Child's age}
  CAHPSscale4 = 31; {Survey Completion help (multi-response)}
  CAHPSscale5 = 32; {Main language used at home}
  CAHPSscale6 = 33; {relationship to policyholder}
(*Prod )
  CAHPSscale1 = 97; {Health Plan Membership}
  CAHPSscale2 = 90; {How many times?}
  CAHPSscale3 = 92; {Child's age}
  CAHPSscale4 = 59; {Survey Completion help (multi-response)}
  CAHPSscale5 = 88; {Main language used at home}
  CAHPSscale6 = 94; {relationship to policyholder}

  CAHPScolumn1 = 20;
  CAHPScolumn2 = 24;
  CAHPScolumn3 = 26;
  CAHPScolumn4 = 28;
  CAHPScolumn5 = 30;
  CAHPScolumn6 = 32;
*)
type
  EGenErr = class(Exception)
    ErrorCode : integer;
  end;
  trDQRichEdit = record
    left,top,width,height,tag,qstncore,item,MarkCount,RespCol,
    SelQstns_ID,scaleid,scalepos:integer;
    QNmbr : byte;
    QChar : char;
    borderstyle:tBorderstyle;
    color:tColor;
    RichText,PlainText:String;
    fontname:tFontName;
    fontsize:integer;
    fontstyle:tFontStyles;
    SubType : byte;
    BorderWidth:integer;
  end;
  trDQLabel = record
    Panel,top,left,scalepos,item:integer;
    caption:string;
  end;
  trDQShape = record
    Panel,top,left,width,item,value,charset:integer;
    shape : tShapeType;
  end;
  trDQPanel = record
    top,left,width,height,Question:integer;
    fontname:tFontName;
    fontsize:integer;
    fontstyle:tFontStyles;
  end;
  tResponse = record
    text : string;
    val,Item,order,resptype,charset: integer;
  end;
  tSheetTypes = (ptNull,Letter,Legal,Tabloid,DblLegal);
  tSkips = record
    SelQstns_ID,
    item,
    skipType,
    skipNum,
    SampleUnit_id : integer;
  end;
  tSW = record
    id,width,lblwidth:integer;
  end;
  TfrmLayoutCalc = class(TForm)
    RichEdit: TRichEdit;
    tPCL: TTable;
    tPCLSection: TIntegerField;
    tPCLSubSection: TIntegerField;
    tPCLItem: TIntegerField;
    tPCLQstnCore: TIntegerField;
    tPCLX: TIntegerField;
    tPCLY: TIntegerField;
    tPCLQNmbr: TStringField;
    tBubbleLoc: TTable;
    LogoImage: TImage;
    tPCLPCLStream: TBlobField;
    tPCLHeight: TIntegerField;
    tPCLWidth: TIntegerField;
    tPCLID: TAutoIncField;
    tPCLSide: TIntegerField;
    tPCLSheet: TIntegerField;
    tPCLSelQstns_id: TIntegerField;
    tCmntLoc: TTable;
    tPCLPagenum: TIntegerField;
    tPCLBegColumn: TIntegerField;
    tPCLReadMethod: TIntegerField;
    tPCLYadj: TIntegerField;
    tPCLIntRespCol: TIntegerField;
    tPCLOrgSection: TIntegerField;
    tPCLSampleUnit_id: TIntegerField;
    procedure RichEditProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    CAHPSNumbering : boolean;
    DoDBenSkips : boolean;
    NextQTop : integer;
    NeedLabels : boolean;
    SurveyItems: integer;
    ResultColumn : integer;
    PageBreakY : integer;
    AfterPageBreakCoverHeight : integer;
    SW : array[1..MaxNumScales] of tSW;
    Set_PCL : array[1..6] of string;
    PCAddrPosX,PCAddrPosY,LgPCAddrPosX,LgPCAddrPosY,AddrPosX,AddrPosY:integer;
    function ScaleWidth(const sID:integer; bolPersonalized : boolean):tSW;
    function CalcOneWidth(const sID:integer):tSW;
    procedure personalizeRTF(Buffer : string);
    function SplitText(s:string; var LineNum:integer; MaxWidth:integer; var SplitWord:boolean; AllowSplitWord:boolean):string;
    function ScalesBelow(P:integer; var lbls:array of tResponse):integer;
    function ScalesBelow3(P:integer; var lbls:array of tResponse):integer;
    procedure createEllipse(P:integer; const vTop,vLeft,vValue,vItem:integer);
    function ScalesRight(P:integer; Rlbls,Mlbls:array of tResponse):integer;
    function ScalesBelow2(P:integer; Rlbls,Mlbls:array of tResponse):integer;
    function newQ(Const ID:integer):integer;
    function newScale(const Qid:integer;const placement:integer):integer;
    procedure ShowQ(Shading:boolean; var TBPos:integer; var QstnNmbr:integer; var QstnChar:char);
    procedure ClearArrays;
    function SplitedTextLine(const s:string; const N:integer):string;
    procedure CreateICRBox(P:integer; const vTop:integer; var vLeft:integer; const vValue,vItem,vCharset:integer);
    function ScalesBelowICR(P:integer; const lbls:array of tResponse):integer;
    function PCLAbsXY(Const x,y:integer):string;
    {
    procedure PCLMove(const Xoffset,Yoffset : integer);
    function PCLAbsX(Const x:integer):string;
    function PCLAbsXRelY(Const x,y:integer):string;
    }
    function PCLRelXY(Const x,y:integer):string;
    function PCLCenter(const s:string):string;
    function PCLRightJustify(const s:string):string;
    function PCLBox(const shade,border,left,top,width,height:integer):string;
    function PCLFont(const name:string; const size:integer; const style:TFontStyles;  color : integer):string;
    function BubblePut(Q,S,RelX,RelY:integer):string;
    function ScalelabelPut(Q,lbl,RelX,RelY:integer; var line:integer; strLabel:string):string;
    function ICRBox(Q,S,RelX,RelY:integer):string;
    function PCLTextBox(const PgType:integer):string;
    function TweakCoverPage:integer;
    function StripAndSavePCLCmnds(const s:string; var commands:string):string;
    function StripPCLCmnds(const s:string):string;
    function StripPCLCmnds2(const s:string; var Cmnds:string):string;
    procedure PaperChoice(const CoverHeight,TotalHeight:integer);
    procedure PrintLogo;
    procedure CoverLetterGen(var CvrHght,Page2Hght:integer);
    procedure PostcardGen(const PgType:integer);
    procedure QuestionGen(var VertOff:integer);
    procedure SpreadOutQstns(const Whitespace:integer);
    procedure FillOutSkips;
    function StartPage(const vSht, vSide, vPg, vPg2 : integer):string;
    function SheetDef(st:integer):string;
    function QualProFunctions(const text,CodeDelim:string; const ErrCode:byte):string;
    function RichTextToPCL(const width:integer):string;
    function PCLItalic(const name:string; const size:integer; style:TFontStyles; const TurnOn: Boolean):string;
    function PCLBold(const name:string; const size:integer; style:TFontStyles; const TurnOn: Boolean):string;
    function ConvertAsciiCodes(s:string):string;
    Procedure MoveAllDown(const delta:integer;p:integer;var bubblesAt: integer);
    procedure SkipError(const skipmsg:string);
    function StripCarriageReturns(const ScaleText:string) : string; //GN03
    function IsPCLText(const s:string):Boolean;                     //GN13

  public
    { Public declarations }
    rDQRichEdit : array[0..50] of trDQRichEdit;
    rDQPanel : array[0..50] of trDQPanel;
    rDQLabel : array[0..350] of trDQLabel;
    rDQShape : array[0..450] of trDQShape;
    nDQRichEdit, nDQPanel, nDQLabel, nDQShape : integer;
    Mockup : byte;
    TestPrints : boolean;
    Match : string[2];  // Match : char;
    SheetType : tSheetTypes;
    IncludeQstns,IntegratedCover,Letterhead : boolean;
    SurveyPages : integer;
    curDevice,curPort : string;
    PrinterAdjustmentArialNarrow,PrinterAdjustmentArial : real;
    PageWidth,ColumnCnt,ColumnGutter :integer;
    UsedFont : array[16535..16554] of boolean;
    createok:boolean;
    DOD:boolean;
    function SheetTypeVal : integer;
    procedure BMPtoPCL(var tbl:twwTable; const bmpfield,PCLfield:string);
    procedure WriteRTF(var BlobField:tBlobField; filename:string);
    procedure LoadRTF(filename:string);
    procedure CalcScaleWidth;
    function CalcSubsection(var TrackBarPos:integer; var QstnNmbr:integer):string;
    function StartCalc : boolean;
    procedure EndCalc;
    procedure PCLMake(var VO:longint; const SectOrder, ThisSect,ThisSub:integer);
    function SurveyGen(sp_id:string):string;
    function PCLRunMacro(const MacID:integer):string;
    function PCLMatchcode:string;
    function PCLReplXY(const PCLStream,Xpos,Ypos:string):string;
    function PCLReplRelXY(const PCLStream : string; const Xpos,Ypos:integer):string;
    procedure WriteNextSheet(var Xi,Xs : textfile);
    procedure WriteCoverLetter(var xi,xs:textfile);
    function GetCoverLetter:string;
    function GetNextSheet(var PageA,PageB,PageC,PageD:integer):string;
    function GetPostcardSide:string;
    procedure SetFonts;
    procedure MakeMockupFile(const init,fn:string);
  end;

const
  LogoMacro = 10000;
  PCLMacro = 11000;
  TopMargin = 250;

var
  frmLayoutCalc: TfrmLayoutCalc;
  NeedQstnChar, TreatQuestionLikeHeader : boolean;
  Skips : array[1..SkipMax] of tSkips;
  nSkip : integer;
  SkipErr : boolean;
  PageItems : array[1..50] of array[1..2] of integer;
  PageLastY : array[1..50] of array[1..2] of integer;

implementation

uses DOpenQ, FileUtil;

{$R *.DFM}

function myStrToDateTime(const s:string):tDateTime;
var mn,dy,yr,hr,mi,ampm : string;
  function monthnum(const s:string):string;
  begin
    result := inttostr(pos(uppercase(copy(s,1,3)),'___JAN.FEB.MAR.APR.MAY.JUN.JUL.AUG.SEP.OCT.NOV.DEC') div 4)
  end;
begin
  mn := monthnum(copy(s,1,3));
  dy := trim(copy(s,5,2));
  yr := trim(copy(s,8,4));
  hr := trim(copy(s,13,2));
  mi := trim(copy(s,16,2));
  ampm := copy(s,18,2);
  result := strToDateTime(mn+'/'+dy+'/'+yr+' '+hr+':'+mi+' '+ampm);
end;

function tFrmLayoutCalc.QualProFunctions(const text,CodeDelim:string; const ErrCode:byte):string;
var s,QPFresult,func : string;
    Tag,Parm1 : string;
    funcpos,funclen : integer;
begin
  if (mockup=ptRealSurvey) and ({pos(codedelim,text) +} pos('«',text) + pos('¯',text) > 0) then
    raise EOrphanTagError.Create( 'FormGenError '+inttostr(errcode)+' (Orphan Tag)');
  result := text;
  while pos('s''s ',result)>0 do delete(result,pos('s''s ',result)+2,1);
  while pos('z''s ',result)>0 do delete(result,pos('z''s ',result)+2,1);
  while pos('s''s\',result)>0 do delete(result,pos('s''s\',result)+2,1);
  while pos('z''s\',result)>0 do delete(result,pos('z''s\',result)+2,1);
  funcpos := pos('QPF_',result);
  while funcpos>0 do begin
    funclen := 1;
    while result[funcpos+funclen-1] <> ']' do begin
      if result[funcpos+funclen-1]='"' then begin
        inc(funclen);
        while result[funcpos+funclen-1] <> '"' do inc(funclen);
      end;
      inc(funclen);
    end;
    s := copy(result,funcpos,funclen);
    delete(result,funcpos,funclen);
    delete(s,1,4); {deletes "QPF_"}
    func := uppercase(copy(s,1,pos('[',s)-1));
    delete(s,1,length(func)+1); {deletes "Possessive[" }
    delete(s,length(s),1); {deletes "]"}
    if func='POSSESSIVE' then begin
      Tag := noquotes(getstring(s));
      if (upcase(Tag[length(Tag)])='S') or (upcase(Tag[length(Tag)])='Z') then
        QPFresult := Tag + ''''
      else
        QPFresult := Tag + '''s';
    end else if func='DATEFORMAT' then begin
      Tag := noquotes(getstring(s));
      Parm1 := noquotes(getstring(s));
      QPFresult := formatdatetime(Parm1,myStrToDateTime(Tag));
    end else
      QPFresult := noquotes(getstring(s));
    insert(QPFresult,result,funcpos);
    funcpos := pos('QPF_',result);
  end;
end;

function tFrmLayoutCalc.SplitText(s:string; var LineNum:integer; MaxWidth:integer; var SplitWord:boolean; AllowSplitWord:boolean):string;
var i,j,PrevLines,last,first : integer;
    arrayoffset : integer;
    fsize : tSize;
    SizeArray : array[0..10000] of integer;
    PCLString : tPCLString;
    bool1, bool2 : boolean;
begin

if pos(#13+#10,s)>0 then begin
  first := pos(#13+#10,s);
  result := splittext(copy(s,       1, first-1  ), i, maxwidth, bool1, AllowSplitWord) + SplitMarker +
            splittext(copy(s, first+2, length(s)), j, maxwidth, bool2, AllowSplitWord);
  LineNum := i + j;
  SplitWord := (bool1 or bool2);
end else begin
  PCLString := tPCLString.Create(  );
  PCLString.text := s;
  SplitWord := false;
  if PCLString.PlainText <> '' then begin
    if printer.canvas.font.name = 'Arial Narrow' then
      MaxWidth := round(maxWidth/PrinterAdjustmentArialNarrow)
    else
      MaxWidth := round(maxWidth/PrinterAdjustmentArial);
    GetTextExtentExPoint(printer.canvas.handle,pchar(PCLString.PlainText),length(PCLString.PlainText),2147483647, i,
      SizeArray[0], fSize);
    SizeArray[length(PCLString.PlainText)] := SizeArray[pred(length(PCLString.PlainText))];
    result := '';
    LineNum := 01;
    prevLines := 0;
    first := 1;
    i := 1;
    arrayoffset := 1;
    while i <= length(PCLString.PlainText) do begin
      //if the character we're at takes us over the maximum width..
      if ((SizeArray[i-arrayoffset] - prevLines) > MaxWidth) then begin
        last := i;
        //look for the most recent space or dash
        while (last>first) and (PCLString.PlainText[last]<>' ') and (PCLString.PlainText[last]<>'-') do
          dec(last);
        if (PCLString.PlainText[last]='-') then
          inc(last);
        if (last<=first) and (last<length(PCLString.PlainText)) then begin
          if AllowSplitword then begin
            // there wasn't a recent space, so put break in the middle of a word
            last := i;
            Splitword := true;
          end else begin
            // there wasn't a recent space, so find the next space
            while (last<=length(PCLString.PlainText)) and (PCLString.PlainText[last]<>' ') and (PCLString.PlainText[last]<>'-') do
              inc(last);
            if (PCLString.PlainText[last]='-') then
              inc(last);
          end;
        end;
        if PCLString.Plaintext[last]=' ' then
          PCLString.DeleteFromPlain(last,1);
        PCLString.InsertIntoPlain(SplitMarker,last);
        inc(linenum);
        inc(arrayoffset);
        i := succ(last);
        while (PCLString.Plaintext[i]=' ') do pclstring.deletefromplain(i,1);
        first := i;
        prevlines := sizearray[last-arrayoffset];
      end else
        inc(i);
    end;
    result := PCLString.Text;
  end else begin
    result := '';
    LineNum := 01;
  end;
  PCLString.Free;
end;
end;

function tFrmLayoutCalc.SplitedTextLine(const s:string; const N:integer):string;
var i : integer;
begin
  result := s + SplitMarker;
  if n > 1 then
    for i := 2 to N do
      if result <> '' then
        delete(result,1,pos(SplitMarker,result));
  result := copy(result,1,pred(pos(SplitMarker,result)));
end;

procedure tFrmLayoutCalc.CreateICRBox(P:integer; const vTop:integer; var vLeft:integer; const vValue,vItem,vCharset:integer);
begin
  inc(nDQShape);
  with rDQShape[ndqShape] do begin
    panel := p;
    top := vTop;
    left := vLeft;
    value := vValue;
    item := vItem;
    charset := vCharset;
    width := ICRWidth*abs(vValue);
    inc(vleft,width+BetweenBblandLbl);
    shape := stRectangle;
  end;
end;

function tFrmLayoutCalc.ScalesBelowICR(P:integer; const lbls:array of tResponse):integer;
var i,curleft : integer;
begin
  with rDQPanel[p] do begin
    fontname := dmOpenQ.QstnFont;
    fontsize := dmOpenQ.QstnPoint;
    curleft := 0;
    result := ICRHeight;
    for i := 1 to lbls[0].val do begin
      if lbls[i].Resptype=stICR then
        createICRBox(P,0,curLeft,lbls[i].val,lbls[i].item,lbls[i].charset)
      else begin
        createEllipse(p,(ICRHeight-bubbleHeight) div 2,curleft,lbls[i].val,lbls[i].item);
        inc(curleft,bubblewidth+BetweenBblandLbl);
      end;
      inc(nDQLabel);
      with rDQLabel[nDQLabel] do begin
        panel := p;
        left := curLeft;
        top := (ICRHeight div 2) - (LineSpacing div 2);
        caption := lbls[i].text;
        scalepos := spBelow;
        item := lbls[i].item;
        if FontName='Arial Narrow' then
          inc(curleft,GutterScaleBelow+BetweenBblandLbl+round(PrinterAdjustmentArialNarrow*printer.canvas.textWidth(strippclcmnds(lbls[i].text))))
        else
          inc(curleft,GutterScaleBelow+BetweenBblandLbl+round(PrinterAdjustmentArial*printer.canvas.textWidth(strippclcmnds(lbls[i].text))));
      end;
    end;
    rDQPanel[P].height := result;
  end;
end;

function tFrmLayoutCalc.ScalesBelow(P:integer; var lbls:array of tResponse):integer;
var i,ttlWidth,rows : integer;
    aLeft : array[1..MaxNumResps] of integer;
    aTop : array[1..MaxNumResps] of integer;
    aWidth: array[1..MaxNumResps] of integer;

  function CalcBblPos(const r:integer):integer;
  var i,j,row,curleft,maxleft : integer;
  begin
    row := 1;
    curLeft := BubbleWidth+BetweenBblandLbl;
    for i := 1 to lbls[0].val do begin
      aLeft[i] := CurLeft;
      aTop[i] := (row-1) * LineSpacing;
      if dmOpenQ.QstnFont='Arial Narrow' then
        aWidth[i] := round(PrinterAdjustmentArialNarrow*printer.canvas.textWidth(strippclcmnds(lbls[i].text)))
      else
        aWidth[i] := round(PrinterAdjustmentArial*printer.canvas.textWidth(strippclcmnds(lbls[i].text)));
      inc(row);
      if (row > r) or (i=lbls[0].val) then begin
        if (row>r) then begin
          row := 1;
        end;
        maxLeft := 0;
        for j := i+1-R to i do
          if (aLeft[j]+aWidth[j])>MaxLeft then
            MaxLeft := (aLeft[j]+aWidth[j]);
        CurLeft := maxLeft + GutterScaleBelow + BubbleWidth + BetweenBblandLbl;
      end;
    end;
    result := CurLeft;
  end;

  function getword( var s : string ) : string;
  var
    i,l : integer;
  begin
    i := 1;
    while ((i <= length(s)) and (s[i] = ' ')) do inc(i);
    l := 0;
    while ((i+l <= length(s)) and (S[I+L] <> ' ')) DO INC(L);
    getword := copy(s,i,l);
    s := copy(s,i+l+1,length(s));
  end;

  procedure WrapLongLines(const MaxWidth:integer);
  var i,j : integer;
      s1,s2,nextword,cmnds : string;
      PrinterAdjustment : real;
  begin
    if dmOpenQ.QstnFont='Arial Narrow' then
      PrinterAdjustment := PrinterAdjustmentArialNarrow
    else
      PrinterAdjustment := PrinterAdjustmentArial;
    for i := 1 to lbls[0].val do begin
      if aWidth[i] > (MaxWidth - (GutterScaleBelow + BubbleWidth + BetweenBblandLbl)) then begin
        s1 := strippclcmnds2(lbls[i].text,cmnds);

        lbls[i].text := '';
        repeat begin
          s2 := '';
          nextWord := getword(s1);
          while round(PrinterAdjustment*printer.canvas.textWidth(s2+nextword)) < (MaxWidth - (GutterScaleBelow + BubbleWidth + BetweenBblandLbl)) do begin
            s2 := s2 + nextWord;
            NextWord := ' ' + getword(s1);
          end;
          delete(nextword,1,1);
          s1 := NextWord + ' ' + s1;
          for j := i+1 to lbls[0].val do
            aTop[j] := aTop[j] + linespacing;
          lbls[i].text := lbls[i].text + s2 + chr(1);
          inc(rows,1);
        end until round(PrinterAdjustment*printer.canvas.textWidth(s1)) < (MaxWidth - (GutterScaleBelow + BubbleWidth + BetweenBblandLbl));

        lbls[i].text := lbls[i].text + s1;

        while pos(#2,lbls[i].text) > 0 do begin
          s1 := copy(cmnds,1,pos(#2,cmnds)-1);
          delete(cmnds,1,pos(#2,cmnds));
          insert(s1,lbls[i].text,pos(#2,lbls[i].text));
          delete(lbls[i].text,pos(#2,lbls[i].text),1);
        end;
      end;
    end;
  end;

begin
  with rDQPanel[P] do begin
    fontname := dmOpenQ.QstnFont;
    fontsize := dmOpenQ.QstnPoint;
    result := 0;
    ttlWidth := rDQPanel[P].width+1;
    rows := 0;
    while (ttlWidth > rDQPanel[P].width) and (rows<lbls[0].val) do begin
      inc(rows);
      ttlWidth := CalcBblPos(rows);
    end;
    if (ttlWidth > rDQPanel[P].width) then
      WrapLongLines(rDQPanel[P].width);

    for i := 1 to lbls[0].val do begin
      inc(nDQLabel);
      with rDQLabel[nDQLabel] do begin
        panel := p;
        left := aleft[i];
        top := atop[i];
        scalepos := spBelow;
        caption := lbls[i].text;
        item := lbls[i].item;
        //if top+height > result then result := top+height;
      end;
      createEllipse(P,atop[i]+((LineSpacing-bubbleHeight) div 2),aLeft[i]-BubbleWidth-BetweenBblandLbl,lbls[i].val,lbls[i].item);
    end;
    result := rows * LineSpacing;
    rDQPanel[P].height := result;
  end;
end;

function tFrmLayoutCalc.ScalesBelow3(P:integer; var lbls:array of tResponse):integer;
var i,ttlWidth,rows : integer;
    aLeft : array[1..MaxNumResps] of integer;
    aTop : array[1..MaxNumResps] of integer;
    aWidth: array[1..MaxNumResps] of integer;

  function CalcBblPos(const r:integer):integer;
  var i,j,row,curleft,maxleft : integer;
  begin
    row := 1;
    curLeft := BubbleWidth+BetweenBblandLbl;
    for i := 1 to lbls[0].val do begin
      aLeft[i] := CurLeft;
      aTop[i] := (row-1) * LineSpacing;
      if dmOpenQ.QstnFont='Arial Narrow' then
        aWidth[i] := round(PrinterAdjustmentArialNarrow*printer.canvas.textWidth(strippclcmnds(lbls[i].text)))
      else
        aWidth[i] := round(PrinterAdjustmentArial*printer.canvas.textWidth(strippclcmnds(lbls[i].text)));
      inc(row);
      if (row > r) or (i=lbls[0].val) then begin
        if (row>r) then begin
          row := 1;
        end;
        maxLeft := 0;
        for j := i+1-R to i do
          if (aLeft[j]+aWidth[j])>MaxLeft then
            MaxLeft := (aLeft[j]+aWidth[j]);
        CurLeft := maxLeft + GutterScaleBelow + BubbleWidth + BetweenBblandLbl;
      end;
    end;
    result := CurLeft;
  end;

  function getword( var s : string ) : string;
  var
    i,l : integer;
  begin
    i := 1;
    while ((i <= length(s)) and (s[i] = ' ')) do inc(i);
    l := 0;
    while ((i+l <= length(s)) and (S[I+L] <> ' ')) DO INC(L);
    getword := copy(s,i,l);
    s := copy(s,i+l+1,length(s));
  end;

  procedure WrapLongLines(const MaxWidth:integer);
  var i,j : integer;
      s1,s2,nextword,cmnds : string;
      PrinterAdjustment : real;
  begin
    if dmOpenQ.QstnFont='Arial Narrow' then
      PrinterAdjustment := PrinterAdjustmentArialNarrow
    else
      PrinterAdjustment := PrinterAdjustmentArial;
    for i := 1 to lbls[0].val do begin
      if aWidth[i] > (MaxWidth - (GutterScaleBelow + BubbleWidth + BetweenBblandLbl)) then begin
        s1 := strippclcmnds2(lbls[i].text,cmnds);
        lbls[i].text := '';
        repeat begin
          s2 := '';
          nextWord := getword(s1);
          while round(PrinterAdjustment*printer.canvas.textWidth(s2+nextword)) < (MaxWidth - (GutterScaleBelow + BubbleWidth + BetweenBblandLbl)) do begin
            s2 := s2 + nextWord;
            NextWord := ' ' + getword(s1);
          end;
          delete(nextword,1,1);
          s1 := NextWord + ' ' + s1;
          if s2 <> '' then begin
             for j := i+1 to lbls[0].val do
               aTop[j] := aTop[j] + linespacing;
             lbls[i].text := lbls[i].text + s2 + chr(1);
             inc(rows,1);
          end;
        end until round(PrinterAdjustment*printer.canvas.textWidth(s1)) < (MaxWidth - (GutterScaleBelow + BubbleWidth + BetweenBblandLbl));

        lbls[i].text := lbls[i].text + s1;

        if copy(lbls[i].text,length(lbls[i].text)-1,2)=#1+' ' then begin
          delete(lbls[i].text,length(lbls[i].text)-1,2);
          for j := i+1 to lbls[0].val do
            aTop[j] := aTop[j] - linespacing;
            dec(rows,1);
        end;

        while pos(#2,lbls[i].text) > 0 do begin
          s1 := copy(cmnds,1,pos(#2,cmnds)-1);
          delete(cmnds,1,pos(#2,cmnds));
          insert(s1,lbls[i].text,pos(#2,lbls[i].text));
          delete(lbls[i].text,pos(#2,lbls[i].text),1);
        end;
      end;
    end;
  end;

begin
  with rDQPanel[P] do begin
    fontname := dmOpenQ.QstnFont;
    fontsize := dmOpenQ.QstnPoint;
    result := 0;
    ttlWidth := rDQPanel[P].width+1;
    rows := 0;
    while (rows<lbls[0].val) do begin
      inc(rows);
      ttlWidth := CalcBblPos(rows);
    end;
    if (ttlWidth > rDQPanel[P].width) then
      WrapLongLines(rDQPanel[P].width);

    for i := 1 to lbls[0].val do begin
      inc(nDQLabel);
      with rDQLabel[nDQLabel] do begin
        panel := p;
        left := aleft[i];
        top := atop[i];
        scalepos := spBelow;
        caption := lbls[i].text;
        item := lbls[i].item;
        //if top+height > result then result := top+height;
      end;
      createEllipse(P,atop[i]+((LineSpacing-bubbleHeight) div 2),aLeft[i]-BubbleWidth-BetweenBblandLbl,lbls[i].val,lbls[i].item);
    end;
    result := rows * LineSpacing;
    rDQPanel[P].height := result;
  end;
end;

procedure tFrmLayoutCalc.createEllipse(P:integer; const vTop,vLeft,vValue,vItem:integer);
begin
  inc(nDQShape);
  with rDQShape[ndqShape] do begin
    panel := p;
    top := vTop;
    left := vLeft;
    width := BubbleWidth;
    value := vValue;
    charset := 0;
    item := vItem;
    shape := stEllipse;
  end;
end;

Procedure tFrmLayoutCalc.MoveAllDown(const delta:integer;p:integer;var bubblesAt: integer);
var i : integer;
begin
  BubblesAt := BubblesAt+Delta;
  i := nDQLabel;
  while rDQLabel[i].Panel=P do
  begin
    inc(rDQLabel[i].top,delta);
    dec(i);
  end;
  i := nDQShape;
  while rDQShape[i].Panel=P do
  begin
    inc(rDQShape[i].top,delta);
    dec(i);
  end;
end;

function tFrmLayoutCalc.ScalesRight(P:integer; Rlbls,Mlbls:array of tResponse):integer;
var
  LblWidth,i,LastBbl,lblLines,L,move : integer;
  ColWidth,HalfColumn : real;
  bubblesAt: integer;
  SplitLbl : string;
  Splitword:boolean;
begin
  BubblesAt := (LineSpacing-BubbleHeight) div 2;
  result := 0;
  if Mlbls[0].val>0 then
    for i := 1 to mlbls[0].val do begin
      inc(rlbls[0].val);
      rlbls[rlbls[0].val] := mlbls[i];
    end;
  LblWidth := ScaleWidth(rDQRichEdit[rDQPanel[p].question].scaleid, true).lblwidth;
  if (Rlbls[0].val>0) and (Rlbls[0].val <= 12 {7}) then
    with rDQPanel[P] do
    begin
      fontname := dmOpenQ.SclFont;
      fontsize := dmOpenQ.SclPoint;
      printer.canvas.font.name := dmOpenQ.SclFont;
      printer.canvas.font.size := dmOpenQ.SclPoint;
      if mlbls[0].val=0 then
        colWidth := rDQPanel[P].width/rlbls[0].val
      else
        colWidth := rDQPanel[P].width/(0.5+rlbls[0].val);
      for i := 1 to Rlbls[0].val do
      begin
        if i >= 1+Rlbls[0].val-mLbls[0].val then
          HalfColumn := colwidth/2
        else
          HalfColumn := 0.0;
        createEllipse(P,
            BubblesAt,
            round(halfcolumn + (colWidth/2) + ((i-1)*colWidth) - (BubbleWidth / 2)),
            rlbls[i].val,rLbls[i].item);
        lastBbl := rDQShape[nDQShape].left;
        if NeedLabels then
        begin
          SplitLbl := rlbls[i].text;
          while pos('  ',SplitLbl)>0 do delete(SplitLbl,pos('  ',SplitLbl),1);
          SplitLbl := SplitText(SplitLbl,lblLines,lblWidth{trunc(colwidth)-27{4},SplitWord,false);
          if BubblesAt-BetweenBblandLbl-(dmOpenQ.SclPoint*9*lblLines) < 0 then
          begin
            Move := abs(BubblesAt-BetweenBblandLbl-(dmOpenQ.SclPoint*9*lblLines));
            MoveAllDown(move,p,BubblesAt);
            rDQPanel[P].height := rDQPanel[P].height+move;
          end;
          inc(nDQLabel,lblLines);
          for L := 1 to lblLines do
            with rDQLabel[nDQLabel+L-lblLines] do
            begin
              panel := p;
              top := BubblesAt-BetweenBblandLbl-(dmOpenQ.SclPoint*9*(1+lbllines-L));
              caption := SplitedTextLine(SplitLbl,L);
              if dmOpenQ.SclFont='Arial Narrow' then
                left := (LastBbl) + (BubbleWidth div 2) - (round(PrinterAdjustmentArialNarrow*(printer.canvas.textwidth(strippclcmnds(caption)))) div 2)
              else
                left := (LastBbl) + (BubbleWidth div 2) - (round(PrinterAdjustmentArial*(printer.canvas.textwidth(strippclcmnds(caption)))) div 2);
              scalepos := spRight;
            end;
        end;
      end;
      NeedLabels := false;
      result := height;
    end;
end;

function tFrmLayoutCalc.ScalesBelow2(P:integer; Rlbls,Mlbls:array of tResponse):integer;
var
  i,LastBbl,lblLines,L,move : integer;
  ColWidth,HalfColumn : real;
  bubblesAt: integer;
  SplitLbl : string;
  Splitword:boolean;
begin
  BubblesAt := (LineSpacing-BubbleHeight) div 2;
  result := 0;
  if Mlbls[0].val>0 then
    for i := 1 to mlbls[0].val do
    begin
      inc(rlbls[0].val);
      rlbls[rlbls[0].val] := mlbls[i];
    end;
  if (Rlbls[0].val>0) and (Rlbls[0].val <= 12 {7}) then
    with rDQPanel[P] do
    begin
      fontname := dmOpenQ.SclFont;
      fontsize := dmOpenQ.SclPoint;
      printer.canvas.font.name := dmOpenQ.SclFont;
      printer.canvas.font.size := dmOpenQ.SclPoint;
      if mlbls[0].val=0 then
        colWidth := rDQPanel[P].width/rlbls[0].val
      else
        colWidth := rDQPanel[P].width/(0.5+rlbls[0].val);
      for i := 1 to Rlbls[0].val do
      begin
        if i >= 1+Rlbls[0].val-mLbls[0].val then
          HalfColumn := colwidth/2
        else
          HalfColumn := 0.0;
        createEllipse(P,
            BubblesAt,
            round(halfcolumn + (colWidth/2) + ((i-1)*colWidth) - (BubbleWidth / 2)),
            rlbls[i].val,rLbls[i].item);
        lastBbl := rDQShape[nDQShape].left;

//      SplitLbl := SplitText(rlbls[i].text,lblLines,lblWidth{trunc(colwidth)-27{4},SplitWord);
        SplitLbl := rlbls[i].text;
        while pos('  ',SplitLbl)>0 do delete(SplitLbl,pos('  ',SplitLbl),1);
        SplitLbl := SplitText(SplitLbl,lblLines,trunc(colwidth),SplitWord,false);
        if BubblesAt-BetweenBblandLbl-(dmOpenQ.SclPoint*9*lblLines) < 0 then
        begin
          Move := abs(BubblesAt-BetweenBblandLbl-(dmOpenQ.SclPoint*9*lblLines));
          MoveAllDown(move,p,BubblesAt);
          rDQPanel[P].height := rDQPanel[P].height+move;
        end;
        inc(nDQLabel,lblLines);
        for L := 1 to lblLines do
          with rDQLabel[nDQLabel+L-lblLines] do
          begin
            panel := p;
            top := BubblesAt-BetweenBblandLbl-(dmOpenQ.SclPoint*9*(1+lbllines-L));
            caption := SplitedTextLine(SplitLbl,L);
            if dmOpenQ.SclFont='Arial Narrow' then
              left := (LastBbl) + (BubbleWidth div 2) - (round(PrinterAdjustmentArialNarrow*(printer.canvas.textwidth(strippclcmnds(caption)))) div 2)
            else
              left := (LastBbl) + (BubbleWidth div 2) - (round(PrinterAdjustmentArial*(printer.canvas.textwidth(strippclcmnds(caption)))) div 2);
            scalepos := spBelow2;
          end;

      end;
      result := height;
    end;
end;

function tFrmLayoutCalc.newQ(Const ID:integer):integer;
//var i : integer;
begin
  inc(nDQRichEdit);
  result := nDQRichEdit;
  with rDQRichEdit[nDQRichEdit] do
  begin
    left := 100;
    top := 100;
    width := 400;
    height := 200;
    tag := ID;
    QstnCore := DMOpenQ.wwt_QstnsQstnCore.asInteger;
    SelQstns_ID := DMOpenQ.wwt_QstnsID.asInteger;
    ScaleID := DMOpenQ.wwt_QstnsScaleID.value;
    ScalePos := DMOpenQ.wwt_QstnsScalePos.value;
    item := dmopenq.wwt_Qstnsitem.value;
    if dmopenq.wwt_QstnsnumMarkCount.value > 1 then
      MarkCount := dmopenq.wwT_QstnsnumBubbleCount.value
    else
      MarkCount := 1;
(*
 // Hack for CAHPS open-ended/handwritten:           //
    if (ScaleID=CAHPSscale1) or
       (ScaleID=CAHPSscale2) or
       (ScaleID=CAHPSscale3) or
    // (ScaleID=CAHPSscale4) or   {multi-response => we want scanner to still process}
       (ScaleID=CAHPSscale5) or
       (ScaleID=CAHPSscale6) then
      MarkCount := 0-MarkCount;
 // ------------------------------------------------ //
*)
    RespCol := dmopenq.wwt_QstnsScaleFlipped.value;
    BorderStyle := bsNone;
    Color := clWhite;
    RichText := '';
    PlainText := '';
    fontname := dmOpenQ.QstnFont;
    fontsize := dmOpenQ.QstnPoint;
    fontstyle := [];
  end;
end;

function tFrmLayoutCalc.PCLItalic(const name:string; const size:integer; style:TFontStyles; const TurnOn: Boolean):string;
begin
  if name='Arial Narrow' then
  begin
    if TurnOn then
      include(style,fsItalic)
    else
      exclude(style,fsItalic);
    result := PCLFont('Arial Narrow',size,style,1);
  end
  else
  if TurnOn then
      result := PCLItalicOn
    else
      result := PCLItalicOff;
end;

function tFrmLayoutCalc.PCLBold(const name:string; const size:integer; style:TFontStyles; const TurnOn: Boolean):string;
begin
  if name='Arial Narrow' then begin
    if TurnOn then include(style,fsBold)
    else exclude(style,fsBold);
    result := PCLFont('Arial Narrow',size,style,1);
  end else
    if TurnOn then result := PCLBoldOn
    else result := PCLBoldOff;
end;

function tFrmLayoutCalc.RichTextToPCL(const width:integer):string;
  var j,LineCnt : integer;
      s : string;
      change,dummy : boolean;
      CurStyle : tFontStyles;
      CurFont : string;
      CurSize,sLen,RESS : integer;
  begin
      RichEdit.SelectAll;
      s := richedit.SelText;
      richedit.SelStart := 0;
      richedit.SelLength := 1;
      curStyle := [];
      curFont := richedit.SelAttributes.Name;
      curSize := richedit.selattributes.Size;
      printer.canvas.font.size := curSize;
      if (uppercase(curfont)='ARIAL NARROW') then
        printer.canvas.font.name := 'Arial Narrow'
      else if (uppercase(curfont)='ARIAL') then
        printer.canvas.font.name := 'Arial'
      else begin
        curFont := dmOpenQ.QstnFont;
        curSize := dmOpenQ.qstnpoint;
        printer.canvas.font.name := curFont;
        printer.canvas.font.size := curSize;
      end;
{      if ([fsBold] <= richedit.selAttributes.style) and (not (fsBold in curStyle)) then
        include(curStyle,fsBold);
      if ([fsItalic] <= richedit.selAttributes.style) then
        include(curStyle,fsItalic);
      if ([fsUnderLine] <= richedit.selAttributes.style) then
        include(curStyle,fsUnderline);
}
      result := ''; {PCLFont(curFont,CurSize,curStyle);}
      change := false;
      printer.canvas.font.style := richedit.selattributes.style;
      s := splittext(s,LineCnt,width{-75},dummy,false) {+ SplitMarker};
      sLen := length(s) + (LineCnt*2);
      richedit.SelectAll;
      if [caBold,caItalic,caUnderline] <= richedit.selattributes.ConsistentAttributes then begin
        j := 0;
        while pos(SplitMarker,s) > 0 do begin
{}        result := result + PCLPopPush + PCLRelXY(0,j) + copy(s,1,pos(SplitMarker,s)-1);
          delete(s,1,pos(SplitMarker,s));
          inc(j,LineSpacing);
        end;
        if length(s)>0{2?} then
{}        result := result + PCLPopPush + PCLRelXY(0,j) + s {copy(s,1,length(s)-2) ?};
      end else begin
        richedit.Selstart := 0;
        richedit.SelLength := 1;
        //GN09
        if (Pos(SplitMarker, s) = 0) or (Copy(s,Length(s)-2,2) <> '#1') then
           s := s + SplitMarker;
        LineCnt := 0;
        while length(s) > 0 do begin
{}        result := result + PCLPopPush + PCLRelXY(0,LineCnt*LineSpacing);
          for j := 1 to pos(SplitMarker,s)-1 do begin
            if ([fsItalic] <= richedit.selattributes.style) and (not (fsItalic in curStyle)) then begin
              change := true;
              include(curStyle,fsItalic);
              result := result + PCLItalic(curfont,curSize,curStyle,true);
            end;
            if (not ([fsItalic] <= richedit.selattributes.style)) and (fsItalic in curStyle) then begin
              change := true;
              exclude(curStyle,fsItalic);
              result := result + PCLItalic(curfont,curSize,curStyle,false);
            end;
            if ([fsUnderline] <= richedit.selattributes.style) and (not (fsUnderline in curStyle)) then begin
              change := true;
              include(curStyle,fsUnderline);
              result := result + PCLUnderLineOn;
            end;
            if (not ([fsUnderline] <= richedit.selattributes.style)) and (fsUnderline in curStyle) then begin
              change := true;
              exclude(curStyle,fsUnderline);
              result := result + PCLUnderLineOff;
            end;
            if ([fsBold] <= richedit.selattributes.style) and (not (fsBold in curStyle)) then begin
              change := true;
              include(curStyle,fsBold);
              result := result + PCLBold(curfont,curSize,curStyle,true);
            end;
            if (not ([fsBold] <= richedit.selattributes.style)) and (fsBold in curStyle) then begin
              change := true;
              exclude(curStyle,fsBold);
              result := result + PCLBold(curfont,curSize,curStyle,false);
            end;
            if change then begin
{           result := result + PCLFont(curfont,cursize,curstyle);}
              change := false;
            end;
{}          result := result + richedit.seltext;
            RESS := richedit.selstart+1;
            repeat
              richedit.selstart := RESS;
              richedit.SelLength := 1;
              inc(RESS);
            until (richedit.sellength>0) or (RESS>sLen);
          end;
          delete(s,1,pos(SplitMarker,s));
          if richedit.seltext = ' ' then begin
            RESS := richedit.selstart+1;
            repeat
              richedit.selstart := RESS;
              richedit.SelLength := 1;
              inc(RESS);
            until (richedit.sellength>0) or (RESS>sLen);
          end;
          inc(LineCnt);
        end;
        if (fsItalic in curStyle) then
          result := result + PCLItalic(curfont,cursize,curstyle,false);
        if (fsUnderline in curStyle) then
          result := result + PCLUnderLineOff;
        if (fsBold in curStyle) then
          result := result + PCLBold(curfont,cursize,curstyle,false);
      end;
    while pos('·',result)>0 do
      result[pos('·',result)] := ' ';
  end;

procedure tFrmLayoutCalc.SkipError(const skipmsg:string);
begin
  dmOpenQ.GenError := 39;
  dmOpenQ.wwt_Qstns.filtered := true;
  dmOpenQ.wwt_QstnsEnableControls;
  raise eGenErr.create(skipmsg + ' not programmed into PCLGen.');
end;

function tFrmLayoutCalc.newScale(const Qid:integer;const placement:integer):integer;
var Resp,Miss : array[0..MaxNumResps] of tResponse;
    Sid : integer;
    i : integer;
    AnyICR : boolean;
    vScaleText:string;
  procedure aConcat(var a:array of integer; const n : integer; var b:array of integer);
  var i : integer;
  begin
    for i := 0 to high(a)-n do
      a[i+n] := b[i];
  end;
begin
  result := 0;
  Resp[0].val := 0;
  Miss[0].val := 0;
  if rDQRichEdit[Qid].ScalePos > 0 then begin
    with dmOpenQ, wwt_scls do begin
      Sid := rDQRichEdit[Qid].ScaleID;
      indexFieldName := qpc_ID;
      AnyICR := false;
      if findkey([Sid]) then begin
        while (not eof) and (wwt_SclsID.value = Sid) and (nSkip<SkipMax) do begin
          {WriteRTF(wwt_SclsRichText,dmOpenQ.tempdir+'\richtext.rtf');
          LoadRTF(dmOpenQ.tempdir+'\richtext.rtf');                  >>GN01}
          RichEdit.lines.LoadFromStream(CreateBlobStream(FieldByName('RichText'),bmRead));  //GN02
          RichEdit.SelectAll;
          if [caBold,caItalic,caUnderline] <= richedit.selattributes.ConsistentAttributes then
            vScaleText := Richedit.Seltext
          else begin
            vScaleText := RichTextToPCL(10000);
            //GN09
            //if copy(vScaleText,1,length(PCLPopPush))=PCLPopPush then
            //   mydelete(vScaleText,1,length(PCLPopPush));
            while Pos(PCLPopPush,vScaleText) > 0 do
               mydelete(vScaleText,Pos(PCLPopPush,vScaleText),length(PCLPopPush));

          end;
          if wwt_Skip.findkey([glbSurveyID,
                               rDQRichEdit[Qid].tag,
                               Sid,
                               wwt_sclsItem.value]) then begin
            //if dmOpenQ.SkipGoPhrase = '' then
            case dmOpenQ.CurrentLanguage of
            2 : // Spanish
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])';
            5 : // Mexican Spanish
                 vScaleText := vScaleText + ' (continuar·con·la·pregunta·[S'+wwt_sclsItem.asString+'])';
            6 : // French
                 vScaleText := vScaleText + ' (Passez·à·la·question·[S'+wwt_sclsItem.asString+'])';
            8 : // PEP-C Spanish
                 vScaleText := vScaleText + ' (Saltar·a·la·pregunta·[S'+wwt_sclsItem.asString+'])';
            9 : // Harris County Spanish
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])';
            10: // Quebeqor
                 vScaleText := vScaleText + ' (Passez·au·n'+#27+'*p-30Yo'+#27+'*p+30Y·[S'+wwt_sclsItem.asString+'])';
            11: //Francophone
                 vScaleText := vScaleText + ' (Passez·à·la·question·n'+#27+'*p-30Yo'+#27+'*p+30Y·[S'+wwt_sclsItem.asString+'])';
            22: // GN19: Montort french
                 vScaleText := vScaleText + ' (procédez·à·la·question·[S'+wwt_sclsItem.asString+'])';
            13: // Harris County Spanish
                 vScaleText := vScaleText + '·[S'+wwt_sclsItem.asString+'])'; //                 SkipError('Italian skips')
            14: //Portuguese
                 vScaleText := vScaleText + ' (vá·para·a·Pergunta·[S'+wwt_sclsItem.asString+'])';
            15: // Hmong
                 vScaleText := vScaleText + ' (Mus·rau·lo·lus·nug·[S'+wwt_sclsItem.asString+'])';
            16: // Somali
                 vScaleText := vScaleText + ' (U·gudub·[S'+wwt_sclsItem.asString+'])';
            18,19,20: // Magnus Spanish GN03, HCAHPS Spanish GN08, Sodexho GN16
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])';
            21: //GN19: Polish
                 vScaleText := vScaleText + ' (Prosze·przejsc·do·nr·[S'+wwt_sclsItem.asString+'])';
            else
                 if CAHPSNumbering or DoDBenSkips then
                   vScaleText := vScaleText + '  ›··Go·to·Question·[S'+wwt_sclsItem.asString+']' // Alt-0155 = ›
                 else
                   vScaleText := vScaleText + ' (Go·to·#·[S'+wwt_sclsItem.asString+'])';
            end; //case dmOpenQ.CurrentLanguage of
{            begin
               if dmOpenQ.CurrentLanguage = 2 then // Spanish
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 5 then // Mexican Spanish
                 vScaleText := vScaleText + ' (continuar·con·la·pregunta·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 6 then // French
                 vScaleText := vScaleText + ' (Passez·à·la·question·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 7 then // VA Spanish
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 8 then // PEP-C Spanish
                 vScaleText := vScaleText + ' (Saltar·a·la·pregunta·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 9 then // Harris County Spanish
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 10 then // Quebeqor
                 vScaleText := vScaleText + ' (Passez·au·n'+#27+'*p-30Yo'+#27+'*p+30Y·[S'+wwt_sclsItem.asString+'])'
               else if (dmOpenQ.CurrentLanguage = 11) or (dmOpenQ.CurrentLanguage = 12) or (dmOpenQ.CurrentLanguage = 17) then  //Francophone
                 vScaleText := vScaleText + ' (Passez·à·la·question·n'+#27+'*p-30Yo'+#27+'*p+30Y·[S'+wwt_sclsItem.asString+'])'
               else if (dmOpenQ.CurrentLanguage = 22) then
                 vScaleText := vScaleText + ' (procédez·à·la·question·[S'+wwt_sclsItem.asString+'])' // GN19: Montort french
               else if dmOpenQ.CurrentLanguage = 13 then // Harris County Spanish
                 vScaleText := vScaleText + '·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 13 then
                 SkipError('Italian skips')
               else if dmOpenQ.CurrentLanguage = 14 then
                 SkipError('Portuguese skips')
               else if dmOpenQ.CurrentLanguage = 15 then // Hmong
                 vScaleText := vScaleText + ' (Mus·rau·lo·lus·nug·[S'+wwt_sclsItem.asString+'])'
               else if dmOpenQ.CurrentLanguage = 16 then // Somali
                 vScaleText := vScaleText + ' (U·gudub·[S'+wwt_sclsItem.asString+'])'
               else if (dmOpenQ.CurrentLanguage = 18) or (dmOpenQ.CurrentLanguage = 19) or (dmOpenQ.CurrentLanguage = 20) then // Magnus Spanish GN03, HCAHPS Spanish GN08, Sodexho GN16
                 vScaleText := vScaleText + ' (Vaya·al·#·[S'+wwt_sclsItem.asString+'])'
               else if (dmOpenQ.CurrentLanguage = 21)  then //GN19: Polish
                 vScaleText := vScaleText + ' (Prosze·przejsc·do·nr·[S'+wwt_sclsItem.asString+'])'
               else
                 if CAHPSNumbering or DoDBenSkips then
                   vScaleText := vScaleText + '  ›··Go·to·Question·[S'+wwt_sclsItem.asString+']' // Alt-0155 = ›
                 else
                   vScaleText := vScaleText + ' (Go·to·#·[S'+wwt_sclsItem.asString+'])';
            end}
{            else
            begin
               vScaleText := vScaleText + ' (' + SkipGoPhrase + '[S'+wwt_sclsItem.asString+'])'; //GN19
            end;}
            if (dmOpenQ.CurrentLanguage > 1) and (CAHPSNumbering or DoDBenSkips) then begin
              if pos(' (',vScaleText)>0 then begin
                myinsert('›··',vScaleText,2+pos(' (',vScaleText));
                mydelete(vScaleText,1+pos(' (',vScaleText),1);
              end else
                vScaleText := '  ›' + vScaleText;
              //if pos(')',vScaleText)>0 then mydelete(vScaletext,pos(')',vScaleText),1);//GN07
              if rpos(')',vScaleText)>0 then mydelete(vScaletext,rpos(')',vScaleText),1);//GN07

            end;
            inc(nSkip);
            with skips[nSkip] do begin
              SelQstns_ID := rDQRichEdit[Qid].tag;
              item := wwt_SclsItem.value;
              skipType := wwt_SkipnumSkipType.value;
              skipnum := wwT_SkipnumSkip.value;
              if mockup > 0 then
                SampleUnit_id := -1
              else
                SampleUnit_id := currentSampleUnit_id;
            end;
          end;
          //if mockup<>ptRealSurvey then
            vScaleText := dmOpenq.Personalize(vScaleText,'{','}');
          vScaleText := QualProFunctions(vScaleText,'{',6);
          if (wwt_SclsMissing.asboolean) and (wwt_QstnsScalePos.AsInteger in [spRight,spBelow2]) then begin
            inc(Miss[0].val);
            Miss[Miss[0].val].text := StripCarriageReturns(vScaleText); //GN04
            Miss[Miss[0].val].val := wwt_SclsVal.value;
            Miss[Miss[0].val].Item := wwt_SclsItem.value;
            Miss[Miss[0].val].order := wwT_SclsScaleOrder.value;
            Miss[Miss[0].val].resptype := wwt_SclsintRespType.value;
            Miss[Miss[0].val].Charset := wwt_SclsCharSet.value;
          end else begin
            inc(Resp[0].val);
            Resp[Resp[0].val].text := StripCarriageReturns(vScaleText); //GN04
            Resp[Resp[0].val].val := wwt_SclsVal.value;
            Resp[Resp[0].val].Item := wwt_SclsItem.value;
            Resp[Resp[0].val].order := wwT_SclsScaleOrder.value;
            Resp[Resp[0].val].resptype := wwt_SclsintRespType.value;
            Resp[Resp[0].val].Charset := wwt_SclsCharSet.value;
          end;
          if wwt_SclsintRespType.value=stICR then AnyICR := true;
          next;
        end;
        if (not eof) and (wwt_SclsID.value = Sid) and (nSkip=SkipMax) then
          SkipErr := true;
      end else {if not findkey([Sid])} begin
        if mockup<>ptRealSurvey then
          messagedlg('Cannot find scale for question '+inttostr(rDQRichEdit[Qid].qstncore)+'.  Check your printout carefully.',mterror,[mbok],0)
        else begin
          dmOpenQ.GenError := 31;
          raise EGenErr.Create('Missing Scale');
        end;
      end;
    end;
    inc(nDQPanel);
    with rDQPanel[nDQPanel] do begin
      if rDQRichEdit[Qid].ScalePos=spRight then begin
        left := rDQRichEdit[Qid].width + rDQRichEdit[Qid].left;
        top := rDQRichEdit[Qid].top + rDQRichEdit[Qid].height - LineSpacing;
      end else begin
        left := rDQRichEdit[Qid].left;
        top := rDQRichEdit[Qid].top+rDQRichEdit[Qid].height;
      end;
      Question := Qid;
      width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt)-left;
      height := LineSpacing;
    end;
    //aConcat(RespVal,Resp.count,MissingVal);
    if rDQRichEdit[Qid].ScalePos=spRight then
    begin
      result := ScalesRight(nDQPanel,Resp,Miss);
      if result > 0 then
      begin
        rDQPanel[nDQPanel].top := rDQRichEdit[Qid].top;
        i := rDQPanel[nDQPanel].height - rDQRichEdit[Qid].height;
        if i < 0 then
          rDQPanel[nDQPanel].top := rDQPanel[nDQPanel].top + abs(i)
        else
          rDQRichEdit[Qid].top := rDQRichEdit[Qid].top + abs(i);
        nextQTop := rDQRichEdit[Qid].top + rDQRichEdit[Qid].height;
        result := 0;
      end;
    end
    else if rDQRichEdit[Qid].ScalePos=spBelow2 then
    begin
      result := ScalesBelow2(nDQPanel,Resp,Miss);
{
      if result > 0 then begin
        rDQPanel[nDQPanel].top := rDQRichEdit[Qid].top;
        i := rDQPanel[nDQPanel].height - rDQRichEdit[Qid].height;
        if i < 0 then
          rDQPanel[nDQPanel].top := rDQPanel[nDQPanel].top + abs(i)
        else
          rDQRichEdit[Qid].top := rDQRichEdit[Qid].top + abs(i);
        nextQTop := rDQRichEdit[Qid].top + rDQRichEdit[Qid].height;
        result := 0;
      end;
}
    end
    else
    begin
      if Miss[0].val>0 then
        for i := 1 to Miss[0].val do
        begin
          inc(Resp[0].val);
          Resp[Resp[0].val] := Miss[i];
        end;
      if AnyICR then
        result := {(LineSpacing div 2) +} ScalesBelowICR(nDQPanel,Resp)
      else if rDQRichEdit[Qid].ScalePos=spBelow3 then
        result := ScalesBelow3(nDQPanel,Resp)
      else
        result := {(LineSpacing div 2) + }ScalesBelow(nDQPanel,Resp);
    end;
  end;

end;

procedure tFrmLayoutCalc.ShowQ(Shading:boolean; var TBPos:integer; var QstnNmbr:integer; var QstnChar:char);
var QstnLines,Qid : integer;
    buffer:pchar;
    MemSize:integer;
    RTFStream:tMemoryStream;
    dummy : boolean;

  procedure TryDiffHeaderLayout(h,q,s : integer);
  var nookwidth,nookheight,headerLines,orgtop,moveup : integer;
  begin
    nookwidth := rDQPanel[s].left - rDQRichEdit[q].left - 300{44};
    nookheight := rDQRichEdit[q].top - rDQRichEdit[h].top;
    if nookwidth > 1350{200} then begin
      with rDQRichEdit[h] do begin
        if (uppercase(fontname)='ARIAL NARROW') then
          printer.canvas.font.name := 'Arial Narrow'
        else
          printer.canvas.font.name := 'Arial';
        printer.canvas.font.size := fontsize;
        printer.canvas.font.style := fontstyle + [fsBold];
        SplitText(plaintext,HeaderLines,nookWidth,dummy,false);
      end;
      if (LineSpacing * HeaderLines) <= nookHeight then begin
        with rdqRichEdit[h] do begin
          width := nookwidth;
          height := LineSpacing * HeaderLines;
          orgtop := top;
          top := rDQRichEdit[q].top-height;
          if rDQPanel[s].top < top then
            moveup := rDQPanel[s].top - orgtop
          else
            moveup := top - orgtop;
          top := top - moveup;
        end;
        with rDQRichEdit[q] do top := top - moveup;
        with rDQPanel[s] do top := top - moveup;
        dec(NextQTop,moveup);
      end;
    end;
  end;
begin
  Qid := newQ(dmOpenQ.wwT_QstnsID.value);
  with rDQRichEdit[Qid], DMOpenQ do begin
    left := 54{8};
    Top := NextQTop;
    if ScalePos = spRight then begin
      TBPos := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 50 - ScaleWidth(rDQRichEdit[Qid].scaleid,true).width;
      if wwt_QstnsWidth.value <> TBPos then begin
        wwt_Qstns.edit;
        wwt_Qstnswidth.value := TBPos;
        wwt_Qstns.post;
      end;
      Width := TBPos;
    end else begin
      Width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 50;
      shading := false;
    end;
    SubType := wwt_QstnsSubtype.value;
    if (SubType = stItem) and (Shading) and (not CAHPSNumbering) then
      color := $00DFDFDF;
    RTFStream := tMemoryStream.create;
    try
      wwt_QstnsRichText.SaveToStream(RTFStream);
      RTFStream.position := 0;
      richedit.lines.clear;
      richedit.lines.LoadFromStream(RTFStream);
      RTFStream.position := 0;
      memSize := rtfStream.size;
      inc(memSize);
      Buffer := allocmem(memsize);
      try
        rtfStream.read(Buffer^,memsize);
        RichText := Buffer;
      finally
        FreeMem(buffer,memsize);
      end;
    finally
      RTFStream.free;
    end;
    richedit.selectall;
    PlainText := richedit.selText;
    //if mockup<>ptRealSurvey then
      PlainText := dmOpenq.personalize(plaintext,'{','}');
    plaintext := QualProFunctions(plaintext,'{',5);
    RichEdit.selLength := 01;
    rDQRichEdit[Qid].fontstyle := richedit.SelAttributes.Style;
    RichEdit.selLength := 0;
    if (subtype=stSubsection) then begin
      if TreatQuestionLikeHeader then begin
        plaintext := '';
        inc(QstnNmbr);
      end else if (trim(PlainText)<>'') and (needQstnChar) then begin
        if not CAHPSNumbering then
          inc(QstnNmbr);
        QNmbr := QstnNmbr; QChar := ' ';
        if CAHPSNumbering then begin
          QChar := 'Ç';
        end else begin
          dec(width,150);
          inc(left,150);
        end;
      end;
    end else
      if (subtype<>stComment) or ((subtype=stComment) and (wwt_QstnsHeight.value>0)) then begin
        if (NeedQstnChar) then begin
          QNmbr := QstnNmbr;
          QChar := QstnChar;
          inc(QstnChar);
          if QstnChar = 'a' then QChar := ' ';
          if CAHPSNumbering then begin
            dec(width,200);
            inc(left,200);
          end else begin
            dec(width,260);
            inc(left,260);
          end;
        end else begin
          inc(QstnNmbr);
          QNmbr := QstnNmbr; QChar := ' ';
          dec(width,150);
          inc(left,150);
        end;
      end;
    if trim(PlainText)<>'' then begin
      if (uppercase(Fontname)='ARIAL NARROW') then
        printer.canvas.font.name := 'Arial Narrow'
      else
        printer.canvas.font.name := 'Arial';
      printer.canvas.font.size := fontsize;
      if Subtype=stSubsection then
        printer.canvas.font.style := fontstyle + [fsbold]
      else
        printer.canvas.font.style := fontstyle;
      if subtype=stComment then begin
        if QstnChar <> ' ' then
          width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 20*2 - 34*2 - 260
        else
          width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 20*2 - 34*2 - 150;
      end;
      SplitText(PlainText,QstnLines,width{-75},dummy,false);
      height := LineSpacing * QstnLines;

      BorderWidth:=0;
      if subtype=stComment then begin
        inc(top,30);
        scaleid := wwt_QstnsHeight.value;

        if not varisnull(wwT_QstnsWidth.AsVariant) then
          BorderWidth := wwT_QstnsWidth.value
        else if scaleid > 0 then
          BorderWidth := 1;

        if (not varisnull(wwT_QstnsScaleFlipped.asVariant)) and (scaleid = 0) then
          Color    := wwT_QstnsScaleFlipped.value
        else
          color := clWhite;

        if scaleid>0 then
          inc(height,round(1.5*LineSpacing*scaleid));
      end;
      inc(NextQTop,Height);
    end;
  end;
  if trim(rDQRichEdit[Qid].PlainText) <> '' then begin
    if rDQRichEdit[Qid].ScalePos <= 0 then begin
      if rDQRichEdit[Qid].Subtype=1 then begin
        if mockup<>ptRealSurvey then
          messagedlg('Undefined scale placement for question '+inttostr(rDQRichEdit[Qid].qstncore)+'.  Check your printout carefully.',mterror,[mbok],0)
        else begin
          dmOpenQ.GenError := 31;
          raise EGenErr.Create('Undefined scale placement');
        end;
      end;
      inc(rDQRichEdit[Qid].Height,dmOpenQ.ExtraSpace);
      inc(nextQTop,dmOpenQ.ExtraSpace);
    end else begin
      if rDQRichEdit[Qid].Subtype=1 then
        nextQTop := nextQTop + NewScale(Qid,0);
      {If this is the first question after a header and the scales are to the
       right, check to see if the header can fit in the nook to the left of
       the scale labels}
      if (nDQRichEdit>=2) and (nDQPanel>=1) {header+question+scales} then
        if (rDQRichedit[nDQRichEdit-1].Subtype=stSubsection) and
           (rDQRichedit[nDQRichEdit].Subtype=stItem) and
           (rDQPanel[nDQPanel].Question = nDQRichEdit) and
           (rDQRichEdit[nDQRichEdit].ScalePos=spRight) then
          TryDiffHeaderLayout(nDQRichEdit-1,
                              nDQRichEdit,
                              nDQPanel);
      inc(rDQRichEdit[Qid].Height,dmOpenQ.ExtraSpace);
      inc(nextQTop,dmOpenQ.ExtraSpace);
    end;
  end else begin
    dec(nDQRichEdit);
  end;
end;

(*
procedure tfrmLayoutCalc.PCLMove(const Xoffset,Yoffset : integer);
var s,x,y : string;
    f : file of byte;
    g : textfile;
    b : byte;
    NextEsc : boolean;

  function NextCmnd:string;
  var r : string;
  begin
    if NextEsc then
      b := 27
    else
      read(f,b);
    r := chr(b);
    if (b=27) then begin
      while (not eof(f)) and ((chr(b)<'@') or (chr(b)>'Z')) do begin
        read(f,b);
        r := r + chr(b);
      end;
      nextEsc := false;
    end else begin
      b := 32;
      while (not eof(f)) and (b<>27) do begin
        read(f,b);
        if b <> 27 then
          r := r + chr(b)
        else
          NextEsc := true;
      end;
    end;
    NextCmnd := r;
  end;

begin
  NextEsc := false;
  tPCL.edit;
  tPCLX.value := tPCLX.value + Xoffset;
  tPCLY.value := tPCLY.value + Yoffset;
  with tPCLPCLStream do begin
    SaveTofile(dmOpenQ.tempdir+'\stream.pcl');
    assignfile(f,dmOpenQ.tempdir+'\stream.pcl');
    assignfile(g,dmOpenQ.tempdir+'\stream2.pcl');
    reset(f);
    rewrite(g);
    while not eof(f) do begin
      x := NextCmnd;
      if copy(x,1,4) = ESC + '*p0' then begin
        delete(x,1,3);
        s := ESC + '*p0';
        if pos('Y',uppercase(X)) > 0 then begin
          Y := copy(x,1,pos('Y',uppercase(X)));
          delete(X,1,pos('Y',uppercase(X)));
          if (y[1]<>'+') and (y[1]<>'-') then
            s := s + inttostr(strtoint(copy(y,1,length(y)-1)) + Yoffset) + y[length(y)]
          else
            s := s + y;
        end;
        if pos('X',uppercase(X)) > 0 then begin
          if (X[1]<>'+') and (X[1]<>'-') then
            s := s + inttostr(strtoint(copy(X,1,length(X)-1)) + Xoffset) + X[length(X)]
          else
            s := s + X;
        end;
        write(g,s);
      end else
        write(g,X);
    end;
    closefile(f);
    closefile(g);
    Loadfromfile(dmOpenQ.tempdir+'\stream2.pcl');
  end;
  tPCL.post;
end;

function tfrmLayoutCalc.PCLAbsX(Const x:integer):string;
begin
  result := ESC + '*p0' + inttostr(x) + 'X';
end;

function tfrmLayoutCalc.PCLAbsXRelY(Const x,y:integer):string;
begin
  result := ESC + '*p0' + inttostr(x)+'x';
  if y>=0 then result := result + '+';
  result := result + inttostr(y)+'Y';;
end;
*)

function tfrmLayoutCalc.PCLAbsXY(Const x,y:integer):string;
begin
  result := ESC + '*p0' + inttostr(y)+'y0'+inttostr(x)+'X';
end;

function tfrmLayoutCalc.PCLRelXY(Const x,y:integer):string;
begin
  result := ESC + '*p';
  if x <> 0 then begin
    if x>0 then result := result + '+';
    result := result + inttostr(x);
    if y=0 then result := result + 'X'
    else        result := result + 'x';
  end;
  if y <> 0 then begin
    if y>0 then result := result + '+';
    result := result + inttostr(y)+'Y';
  end;
  if result = ESC+'*p' then result := '';
end;

function tfrmLayoutCalc.PCLCenter(const s:string):string;
begin
  if printer.Canvas.Font.Name = 'Arial Narrow' then
    result := ESC + '*p-' + inttostr(round(PrinterAdjustmentArialNarrow*printer.canvas.textWidth(strippclcmnds(s))) div 2) + 'X'
  else
    result := ESC + '*p-' + inttostr(round(PrinterAdjustmentArial*printer.canvas.textWidth(strippclcmnds(s))) div 2) + 'X';
end;

function tfrmLayoutCalc.PCLRightJustify(const s:string):string;
begin
  if printer.Canvas.Font.Name = 'Arial Narrow' then
    result := ESC + '*p-' + inttostr(round(PrinterAdjustmentArialNarrow*printer.canvas.textWidth(strippclcmnds(s)))) + 'X'
  else
    result := ESC + '*p-' + inttostr(round(PrinterAdjustmentArial*printer.canvas.textWidth(strippclcmnds(s)))) + 'X';
end;

function tfrmLayoutCalc.PCLBox(const shade,border,left,top,width,height:integer):string;
var colornum:char;
    b:double;
  function HPGLBox(const w,h:integer):string;
  begin
    result := ESC + '%1BPDPM0PR' +
        '0,' + IntToStr(h) + ',' +
        IntToStr(w) + ',0,'+
        '0,' + IntToStr(-h) + ',' +
        IntToStr(-w)+',0' +
        'PM2FT11,'+colornum+'FP' +
        ESC + '%1A';
  end;

begin
  b:=border;
  case shade of
    0,clWhite : colornum := '7';
    $E9E9E9   : colornum := '1';
    $DFDFDF   : colornum := '2';
    $D4D4D4   : colornum := '3';
    $C9C9C9   : colornum := '4';
    $BFBFBF   : colornum := '5';
    $B4B4B4   : colornum := '6';
  else
    colornum := '7';
  end;
  if (top>-1) and (left>-1) then
    result := PCLAbsXY(left,top)
  else
    result := '';

  if border = 0 then
    b:=0.5; //Remove this if condition to stop putting a thin line around no-border boxes
 // result := result+format(#27'%%1B;PW%2:g;TR1FT11,%3:s;PR0,-%5:g;RR%0:d,%1:g;EP;'#27'%%1A',[width,height+b*4,b*0.4,colornum,result,b*4.0]); //GN10
 // colornum :=  '2'; //Eight Pens check the color table above
  result := result+format(#27'%%1B;PW%2:g;TR1FT11,%3:s;PR0,-%5:g;RR%0:d,%1:g;EP;'#27'%%1A',[width,height+b*4,b*0.4,colornum,result,b*4.0]);

end;

//GN10: added the color param
function tfrmLayoutCalc.PCLFont(const name:string; const size:integer; const style:TFontStyles; color : integer):string;
var fn : integer;
begin

  if name = 'Arial Narrow' then begin
    fn := 16537;
    if ([fsBold,fsItalic] <= style) then begin
      case size of
        08: fn := 16550;
        09: fn := 16551;
        10: fn := 16552;
        11: fn := 16553;
        12: fn := 16554;
      end;
    end else if fsBold in style then begin
      case size of
        08: fn := 16540;
        09: fn := 16541;
        10: fn := 16542;
        11: fn := 16543;
        12: fn := 16544;
      end;
    end else if fsItalic in style then begin
      case size of
        08: fn := 16545;
        09: fn := 16546;
        10: fn := 16547;
        11: fn := 16548;
        12: fn := 16549;
      end;
    end else begin
      case size of
        08: fn := 16535;
        09: fn := 16536;
        10: fn := 16537;
        11: fn := 16538;
        12: fn := 16539;
      end;
    end;
    result := crlf + ESC + '(' + inttostr(fn) + 'X';
    UsedFont[fn] := true;
  end else begin
    result := crlf + ESC + '(19U' + ESC + '(s16602t';
    if fsBold in style then result := result + '3b' else result := result + '0b';
    if fsItalic in style then result := result + '1s' else result := result + '0s';
    result := result + inttostr(size) + 'v1P';
    //result := result + ESC + Format('*v%dS',[color]) //GN10
  end;
  if fsUnderline in style then result := result + PCLUnderlineOn else result := result + PCLUnderlineOff;
{  result := ESC + '(19U' + ESC + '(s16602t0b';
  if name = 'Arial Narrow' then begin
    result := result + '4s' + floattostrF(size*1.085265,ffGeneral,2,1) + 'v';
  end else begin
    result := result + '0s' + inttostr(size) + 'v';
  end;
  result := result + '1P';}
end;

function tfrmLayoutCalc.BubblePut(Q,S,RelX,RelY:integer):string;
var ps : string;
begin
  {rDQRichEdit[Q].QstnCore
  }
  if mockup=ptRealSurvey then begin
(*
    // Hack for CAHPS open-ended/handwritten: //
    if rDQRichEdit[Q].MarkCount < 0 then
      rDQShape[S].Charset := rDQRichEdit[Q].MarkCount;
    if (rDQRichEdit[Q].ScaleID=CAHPSscale4) and (rDQShape[S].Item=5) then
      dmOpenQ.BubbleLocAppend(
        rDQRichEdit[Q].SelQstns_ID,
         rDQShape[S].Item,
         -dmOpenQ.wwt_Qstns.fieldbyname('SampleUnit_id').value,
         -1,
         2,
         stICR,
         RelX,
         RelY,
         rDQRichEdit[Q].Scaleid);
    // -------------------------------------- //
*)
      dmOpenQ.BubbleLocAppend(
       rDQRichEdit[Q].SelQstns_ID,
       rDQShape[S].Item,
       dmOpenq.currentSampleUnit_id,
       rDQShape[S].Charset,
       rDQShape[S].Value,
       stBubble,
       RelX+40,
       RelY-35,
       rDQRichEdit[Q].Scaleid);
     { rDQRichEdit[rDQPanel[rDQShape[S].panel].Question].scaleid }
  end;
  if q <> rDQPanel[rDQShape[S].panel].Question then begin
    messagedlg('oops',mterror,[mbok],0);
  end;
  {tBubbleLoc.appendrecord(
    [rDQRichEdit[Q].Scaleid,rDQRichEdit[Q].SelQstns_ID,
     rDQShape[S].Item,
     dmOpenQ.wwt_Qstns.fieldbyname('SampleUnit_id').value,
     rDQShape[S].Charset,
     rDQShape[S].Value,
     stBubble,
     RelX+40,
     RelY-35]);
  }
  if mockup=ptCodeSheetMockup then begin
    if rDQRichEdit[q].markcount>1 then
      result := PCLPopPush + PCLRelXY(RelX,RelY) + PCLResponseBox
    else
      result := PCLPopPush + PCLRelXY(RelX,RelY) + PCLBubble;
    ps := '';
    //GN06 : No need to execute this query when the result is not used
    {
    dmopenq.LocalQuery(format('select problem_score_flag '+
                              'from problemscores '+
                              'where core=%d and val=%d',
                              [rdqrichedit[rdqpanel[rdqshape[s].panel].question].qstncore, rDQShape[s].value]),false);
    }
    { The Project Managers didn't like having problem scores denoted on the mockup.
      If they ever change their minds, un-comment this code.
    if not dmopenq.ww_Query.FieldByName('problem_score_flag').isnull then
      case dmopenq.ww_Query.FieldByName('problem_score_flag').value of
        0: ps := ' +';
        1: ps := ' –';
        -1: ps := ' ¤';
      end;
    }
    result := result + PCLPopPush + PCLRelXY(RelX+50,RelY-10) +
          PCLFont('Arial Narrow',9,[],1) + PCLCenter(inttostr(rDQShape[s].value)) +
          inttostr(rDQShape[s].value) + ps + PCLShapeFont;
  end else if dmOpenq.ResponseShape=2 then
    result := PCLPopPush + PCLRelXY(RelX,RelY) + PCLResponseBox
  else
    result := PCLPopPush + PCLRelXY(RelX,RelY) + PCLBubble;
end;

function tfrmLayoutCalc.ScalelabelPut(Q,lbl,RelX,RelY:integer; var line:integer; strLabel:string):string;
   function PCLWidth(s:string):integer;
   begin
      if printer.Canvas.Font.Name = 'Arial Narrow' then
        result := round(PrinterAdjustmentArialNarrow * printer.canvas.textWidth(s))
      else
        result := round(PrinterAdjustmentArial       * printer.canvas.textWidth(s));
   end;
var s : string;
    MoreX,width : integer;

begin
   result := '';
   if pos('_',strLabel)>0 then begin
      s := strippclcmnds(strLabel);
      MoreX := 0;
      while pos('_',s)>0 do begin
        MoreX := MoreX + PCLWidth(copy(s,1,pos('_',s)-1));
        s := copy(s,pos('_',s),length(s));
        width := 1;
        while (width<length(s)) and (s[width+1] = '_') do inc(width);
        inc(line);
        if mockup=ptRealSurvey then
           dmOpenQ.HandwrittenAppend(
             rDQRichEdit[Q].SelQstns_ID,
             rDQLabel[lbl].Item,
             dmOpenq.currentSampleUnit_id,
             line,
             RelX + MoreX,
             RelY,
             PCLWidth(copy(s,1,width)),
             rDQRichEdit[Q].Scaleid)
        else if mockup=ptCodeSheetMockup then
           result := result + PCLPopPush + PCLRelXY(RelX+MoreX,RelY-81) + PCLBox($D4D4D4,1,-1,-1,pclwidth(copy(s,1,width)),81);

        MoreX := MoreX + PCLWidth(copy(s,1,width));
        s := copy(s,width+1,length(s));
      end;
   end;
   if q <> rDQPanel[rDQLabel[lbl].panel].Question then begin
     messagedlg('oops',mterror,[mbok],0);
   end;
   result := result + PCLPopPush + PCLRelXY(RelX,RelY) + strLabel;
end;


function tfrmLayoutCalc.ICRBox(Q,S,RelX,RelY:integer):string;
var i : integer;
    fldwidth : integer;
begin
(*
  if mockup=ptRealSurvey then begin
    // Hack for CAHPS open-ended/handwritten: //
    if rDQRichEdit[Q].MarkCount < 0 then
      rDQShape[S].Charset := rDQRichEdit[Q].MarkCount;
    // -------------------------------------- //
    dmOpenQ.BubbleLocAppend(
       rDQRichEdit[Q].SelQstns_ID,
       rDQShape[S].Item,
       dmOpenQ.wwt_Qstns.fieldbyname('SampleUnit_id').value,
       rDQShape[S].Charset,
       rDQShape[S].Value,
       stICR,
       RelX,
       RelY,
       rDQRichEdit[Q].Scaleid);
  end;
*)
  result := '';
(*
  // Hack for CAHPS open-ended/handwritten: //
  if (rDQRichEdit[q].MarkCount<0) and (rDQShape[s].value=4) then
    fldWidth := 10
  else
  // -------------------------------------- //
*)
    fldWidth := abs(rDQShape[s].value);
  for i := 1 to fldWidth do
    result := result + PCLPopPush + PCLRelXY(RelX+((i-1)*ICRWidth),RelY+ICRHeight) + PCLBox($B4B4B4,0,-1,-1,ICRWidth,5);
{  result := result + PCLFont('Arial Narrow',8,[]) + PCLPopPush + PCLRelXY(RelX,RelY+Linespacing) + inttostr(rDQShape[s].Item)
     + PCLAbsXRelY(x,2000) + inttostr(QCore)
     + PCLShapeFont;}
end;
                             
function tfrmLayoutCalc.StripPCLCmnds(const s:string):string;
var c : string;
begin
  result := StripAndSavePCLCmnds(s,c);
end;

function tfrmLayoutCalc.StripAndSavePCLCmnds(const s:string; var commands:string):string;
var i : integer;
    t : string;
begin
  result := s;
  while pos('[27]',result)>0 do begin
    insert(#27,result,pos('[27]',result));
    delete(result,pos('[27]',result),4);
  end;
  commands := '';
  while pos(#27,result) >0 do begin
    i := pos(#27,result);
    commands := '«' + inttostr(i)+'»' + commands ;
    t := '';
    repeat
      t := t + result[i];
      result[i] := #1;
      inc(i);
    until (i>length(result)) or ((result[i] >= '@') and (result[i] <= 'Z'));
    if (i<=length(result)) and ((result[i] >= '@') and (result[i] <= 'Z')) then begin
      t := t + result[i];
      result[i] := #1;
    end;
    commands := t + commands;
  end;
  while pos(#1,result)>0 do delete(result,pos(#1,result),1);

end;

//GN13: Checks to see if the string has any PCL Commands
function tfrmLayoutCalc.IsPCLText(const s:string):Boolean;
begin
   result := pos('[27]',s)>0;
end;


function tfrmLayoutCalc.StripPCLCmnds2(const s:string; var Cmnds:string):string;
var b,e : integer;
begin
  result := s;
  while pos('[27]',result)>0 do begin
    insert(#27,result,pos('[27]',result));
    delete(result,pos('[27]',result),4);
  end;
  cmnds := '';
  while pos(#27,result) > 0 do begin
    b := pos(#27,result);
    e := b;
    while (e<length(result)) and ((result[e] < '@') or (result[e] > 'Z')) do
      inc(e);
    cmnds := cmnds + copy(result,b,1+e-b) + #2;
    delete(result,b,1+e-b);
    insert(#2,result,b);
  end;

{
  i := pos(#27,result);
  if i>0 then
    while i<length(result) do begin
      if result[i] = #27 then begin
        while (result[i] < '@') or (result[i] > 'Z') do
          delete(result,i,1);
        delete(result,i,1);
      end else
        inc(i);
    end;
}
end;

procedure tfrmlayoutcalc.personalizeRTF(Buffer : string);
var
//   i : integer;
   s : string;
   MemoryStream: TMemoryStream;
begin
  (*GN05: was losing the formatting when you modify the richText data.
   for i := 0 to RichEdit.Lines.Count - 1 do
   begin
      s := RichEdit.Lines[i];
      s := dmopenq.personalize(s,'{','}');
      s := QualProFunctions(s,'{',7);
      RichEdit.Lines[i] := s;
   end;
   *)                
  s := Buffer;
  s := dmopenq.personalize(s,'\{','\}');
  s := QualProFunctions(s,'\{',7);
  MemoryStream := TMemoryStream.Create;
  try
    MemoryStream.Write(Pointer(s)^, length(s));
    MemoryStream.Seek(0, 0);
    RichEdit.Lines.LoadFromStream(MemoryStream);
  finally
    MemoryStream.Free;
  end;

end;

(* GN01: Method depreciated
procedure tfrmlayoutcalc.personalizeRTF;
  procedure go;
  var
    s : string;
    rtff1,rtff2 : textfile;
  begin
    try
    deletefile(dmOpenQ.tempdir+'\richedit.rtf');
    assignfile(rtff1,dmOpenQ.tempdir+'\richtext.rtf');
    assignfile(rtff2,dmOpenQ.tempdir+'\richedit.rtf');
    reset(rtff1);
    rewrite(rtff2);
    while not eof(rtff1) do begin
      readln(rtff1,s);
//      if mockup<>ptRealSurvey then
        s := dmopenq.personalize(s,'\{','\}');
      s := QualProFunctions(s,'\{',7);
      writeln(rtff2,s);
    end;
    finally
    closefile(rtff1);
    closefile(rtff2);
    end;
  end;
var done:boolean;
    cnt : integer;
    tm : tDateTime;
begin
  done := false;
  cnt := 0;
  repeat
    try
      go;
      done := true;
    except
      inc(cnt);
      tm := time;
      repeat
      until round((time-tm)*60*60*24)>=1;
      if cnt>10 then
        raise;
    end;
  until done or (cnt>10);
end;      *)

function tfrmLayoutCalc.PCLTextBox(const PgType:integer):string;

  function FontChange(const newName:string; const NewSize:integer;
      const attrib:TFontStyles; var CF:string; var CS:integer;
      var BOn,IOn,UOn:boolean):string;
  begin
    if (newName<>CF) or (newSize<>CS) or
       (BOn and (not (fsBold in attrib))) or
       (IOn and (not (fsItalic in attrib))) or
       (UOn and (not (fsUnderline in attrib))) or
       ((not BOn) and (fsBold in attrib) ) or
       ((not IOn) and (fsItalic in attrib) ) or
       ((not UOn) and (fsUnderline in attrib) ) then begin
      result := PCLFont(NewName,NewSize,attrib,1);
      CF := NewName;
      CS := NewSize;
      BOn := (fsBold in attrib);
      IOn := (fsItalic in attrib);
      UOn := (fsUnderline in attrib);
    end else
      result := '';
  end;

type
  tPGraph = record
    text : string;
    alignment : tAlignment;
    Size : integer;
    Name : string[15];
  end;
var i,tbLeft,tbTop,tbWidth,tbHeight,tbBorder,tbShading,curX,curY : integer;
    BoldOn,ItalicOn,UnderlineOn,dummy : boolean;
    curFont,s : string;
    curSize,sBegin,sEnd : integer;
    ParaNum,CharNum,SplittedLines, SplittedLinesPlainText,SplittedLinesPCL,offset:integer;
    PGraph : array[0..35] of tPGraph;
begin
  {WriteRTF(dmOpenQ.wwT_TextBoxRichText,dmOpenQ.tempdir+'\richtext.rtf'); //GN01
  personalizeRTF; //GN01
  LoadRTF(dmOpenQ.tempdir+'\richedit.rtf'); //GN01}

  tbLeft   := (dmOpenQ.wwt_TextBoxX.value*4800) div 710;
  tbTop    := ((dmOpenQ.wwt_TextBoxY.value*4800) div 710)+round(0.75*linespacing);
  tbWidth  := (dmOpenQ.wwt_TextBoxWidth.value*4800) div 710;
  tbHeight := (dmOpenQ.wwt_TextBoxHeight.value*4800) div 710;
  tbBorder := dmOpenQ.wwt_TextBoxBorder.value;
  tbShading:= dmOpenQ.wwt_TextBoxShading.value;
  if tbBorder > 0 then begin
    inc(tbTop,50);
    dec(tbWidth,100);
    dec(tbHeight,100);
  end;
  with Richedit do begin
    //lines.LoadFromStream(dmOpenq.wwT_TextBox.CreateBlobStream(dmOpenq.wwT_TextBox.FieldByName('RichText'),bmRead)); //GN02
    personalizeRTF(dmOpenQ.wwT_TextBoxRichText.Value); //GN02
    SelectAll;
    text := SelText;
    sEnd := length(text);
    SelLength := 1;
    if (mockup=ptRealSurvey) and (pos('{',text) + pos('«',text) + pos('¯',text) > 0) then
      raise EOrphanTagError.Create( 'FormGenError 7 (Orphan Tag)');
    if (uppercase(selAttributes.name)='ARIAL NARROW') then
      printer.canvas.font.name := 'Arial Narrow'
    else
      printer.canvas.font.name := 'Arial';
    printer.canvas.font.size := selAttributes.size;
    printer.canvas.font.style := selAttributes.style;
  end;
  BoldOn := false;
  ItalicOn := false;
  UnderlineOn := false;
  CurFont := '';
  CurSize := 0;
  ParaNum := 0;
  CharNum := 1;
  offset := 0;
  PGraph[ParaNum].text := splittext(richedit.lines[ParaNum],SplittedLines,tbWidth{-75},dummy,false);
  {PGraph[ParaNum].alignment := richedit.paragraph.alignment;}
  for i := 0 to sEnd do
    with Richedit do begin
      SelStart := i;
      SelLength := 1;
      with SelAttributes do
        s := FontChange(name,Size,Style,CurFont,CurSize,BoldOn,ItalicOn,UnderlineOn);

      if copy(PGraph[ParaNum].text,CharNum+offset,2) = '-' + SplitMarker then
        inc(offset);
      if s <> '' then insert(s,PGraph[ParaNum].text,CharNum+offset);
      inc(offset,length(s));
      if SelText = copy(RichEdit.Lines[ParaNum],CharNum,1) then
        inc(CharNum);
      if CharNum > length(RichEdit.Lines[ParaNum]) then begin
        //GN14: Reset the underline command
        if UnderLineOn then
        begin
           PGraph[ParaNum].text := PGraph[ParaNum].text + PCLUnderlineOff;
           UnderLineOn := False;
        end;
        PGraph[ParaNum].alignment := richedit.paragraph.alignment;
        PGraph[ParaNum].size := curSize;
        PGraph[ParaNum].name := curFont;
        inc(ParaNum);
        //PGraph[ParaNum].size := curSize;
        //PGraph[ParaNum].name := curFont;
        selStart := i+3;
        SelLength := 1;
        if SelAttributes.Size <> CurSize then
          printer.canvas.font.size := selattributes.size;
        if SelAttributes.Name <> curFont then begin
          if (uppercase(selAttributes.name)='ARIAL NARROW') then
            printer.canvas.font.name := 'Arial Narrow'
          else
            printer.canvas.font.name := 'Arial';
        end;
        //GN13
        if IsPCLText(richedit.lines[ParaNum]) then
        begin
           SplitText(StripPCLCmnds(richedit.lines[ParaNum]),SplittedLinesPlainText,tbWidth{-75},dummy,false);
           SplitText(richedit.lines[ParaNum],SplittedLinesPCL,tbWidth{-75},dummy,false);

           if (SplittedLinesPCL > SplittedLinesPlainText) then
              PGraph[ParaNum].Text := richedit.lines[ParaNum]
           else
               PGraph[ParaNum].Text := SplitText(richedit.lines[ParaNum],SplittedLines,tbWidth{-75},dummy,false);
        end
        else
          PGraph[ParaNum].text := SplitText(richedit.lines[ParaNum],SplittedLines,tbWidth{-75},dummy,false);
        offset := 0;
        CharNum := 1;
      end;
    end;
  curX := 0;
  curY := 0;
  while (ParaNum>0) and (StripPCLCmnds(PGraph[ParaNum].text) = '') do dec(ParaNum);
  if tbBorder > 0 then begin
    inc(tbWidth,100);
  end;
  for i := 0 to ParaNum do begin
    s := SplitMarker + PGraph[i].text;
    while pos(SplitMarker,s) > 0 do begin
      inc(curY,PGraph[i].size * 9);
      if PGraph[i].alignment = taLeftJustify then
      begin
         if tbBorder > 0 then
            insert(PCLPopPush + PCLRelXY(curx + 25,cury),s,pos(SplitMarker,s))   //GN06
         else
            insert(PCLPopPush + PCLRelXY(curx,cury),s,pos(SplitMarker,s));
      end
      else begin
        if printer.canvas.font.size <> pgraph[i].size then
          printer.canvas.font.size := pgraph[i].size;
        if printer.canvas.font.name <> pgraph[i].name then begin
          if (uppercase(pgraph[i].name)='ARIAL NARROW') then
            printer.canvas.font.name := 'Arial Narrow'
          else
            printer.canvas.font.name := 'Arial';
        end;
        sBegin := pos(SplitMarker,s)+1;
        sEnd := 0;
        while (sBegin+sEnd<=length(s)) and (s[sBegin+sEnd] <> SplitMarker) do
          inc(sEnd);
        if PGraph[i].alignment = taCenter then
          insert(PCLPopPush + PCLRelXY(curX+(tbWidth div 2),curY)+PCLCenter(StripPCLCmnds(copy(s,sBegin,sEnd))),
            s,pos(SplitMarker,s))
        else if PGraph[i].alignment = taRightJustify then
          insert(PCLPopPush + PCLRelXY(curX+tbWidth,curY)+PCLRightJustify(StripPCLCmnds(copy(s,sBegin,sEnd))),
            s,pos(SplitMarker,s))
      end;
      delete(s,pos(SplitMarker,s),1);
    end;
    PGraph[i].text := s;
  end;
  //if (CurY-tbTop)>tbHeight then tbHeight := curY-tbTop;
  if CurY>tbHeight then tbHeight := curY;
  dec(tbTop,round(0.75*linespacing));
  if tbBorder > 0 then begin
    dec(tbTop,50);
    inc(tbHeight,100);
  end;
  if PCLReadable then
    result := ESC + '*p<<'+inttostr(tbleft)+'X>>x<<'+inttostr(tbTop)+'Y>>Y' + PCLPush
  else
    result := ESC + '*p<<X>>x<<Y>>Y' + PCLPush;
  if (tbBorder>0) or (tbShading<>clWhite) then
    result := result + PCLBox(tbShading,tbBorder,-1,-1,tbWidth,tbHeight);
  for i := 0 to ParaNum do
    result := result + PGraph[i].text;
  result := result + PCLPop;
  //GN11: ALT+0183 equals to a sticky space
  while pos('·',result)>0 do
     result[pos('·',result)] := ' ';
  tPCL.append;
  tPCLY.value := tbTop;
  tPCLWidth.value := tbWidth;
  tPCLHeight.value := tbHeight;
  tPCLPCLStream.value := ConvertAsciiCodes(result);
  if PgType=1 then begin
    tPCLQnmbr.value := 'Cvr';
    tPCLX.value := tbLeft;
  end else begin
    if pgType=2 then begin
      if tbLeft<3000 then begin
        tPCLQnmbr.value := 'PC1';
        tPCLX.value := tbLeft;
        tPCLSide.value := 1;
      end else begin
        tPCLQnmbr.value := 'PC2';
        tPCLX.value := tbLeft-3000;
        tPCLSide.value := 2;
      end;
    end else begin
      if tbLeft<3900 then begin
        tPCLQnmbr.value := 'PC1';
        tPCLX.value := tbLeft;
        tPCLSide.value := 1;
      end else begin
        tPCLQnmbr.value := 'PC2';
        tPCLX.value := tbLeft-3900;
        tPCLSide.value := 2;
      end;
    end;
  end;
  tPCLSection.value := 0;
  tPCLSelQstns_id.value := 0;
  tpcl.post;
end;

function tfrmLayoutCalc.ConvertAsciiCodes(s:string):string;
var Tag : string;
    funcpos,funclen : integer;
begin
  result := s;
  while pos('[',result) > 0 do begin
    funcpos := pos('[',result);
    funclen := 1;
    while (funcpos+funclen<=length(result)) and (result[funcpos+funclen] <> ']') do
      inc(funclen);
    tag := copy(result,1+funcpos,funclen-1);
    if (result[funcpos+funclen] <> ']') or (strtointdef(tag,256)>255) then
      result[funcpos] := #1
    else begin
      delete(result,funcpos,funclen+1);
      insert(chr(strtoint(tag)),result,funcpos);
    end;
  end;
  while pos(#1,result) > 0 do
    result[pos(#1,result)] := '[';
end;

procedure tfrmLayoutCalc.PCLMake(var VO:longint; const SectOrder, ThisSect,ThisSub:integer);
var i,l,pnl,shp,lbl,j,underline : integer;
    CurStyle : tFontStyles;
    curFont : string;
    orgVO,curSize,CmntLineRelY,SLen,SclHt,RESS : integer;
    s,sclstrm,r,PCLStream : string;
    QN : string[4];
    allbold : boolean;

  function PCLRichEdit(DQRE:trDQRichEdit; const ForceBold : boolean) : string;
  var j,LineCnt : integer;
      s : string;
      change,dummy : boolean;
      done : boolean;
      cnt,boldcnt : integer;
    procedure go;
    var rt : textfile;
    begin
      assignfile(rt,dmOpenQ.tempdir+'\richtx'+inttostr(cnt)+'.rtf');
      rewrite(rt);
      write(rt,s);
      closefile(rt);
    end;
  begin
    with DQRE do begin
      //if mockup<>ptRealSurvey then
        s := dmopenq.personalize(richtext,'\{','\}');
      //else
        //s := richtext;
      s := qualprofunctions(s,'\{',5);
      done := false;
      cnt := 0;
      repeat
        try
          go;
          done := true;
        except
          inc(cnt);
          if cnt>10 then
            raise;
        end;
      until done or (cnt>10);
      richedit.SelectAll;
      richedit.SelAttributes.Style := [];
      richedit.clear;
      LoadRTF(dmOpenQ.tempdir+'\richtx'+inttostr(cnt)+'.rtf');
      richedit.SelStart := 0;
      richedit.SelLength := 1;
      if (uppercase(fontname)='ARIAL NARROW') then
        printer.canvas.font.name := 'Arial Narrow'
      else
        printer.canvas.font.name := 'Arial';
      printer.canvas.font.size := fontsize;
      if (ForceBold) then begin
        richedit.SelectAll;
        richedit.Selattributes.style := richedit.selattributes.style + [fsBold];
        richedit.selstart := 0;
        richedit.sellength := 1;
      end;
      if ([fsBold] <= richedit.selAttributes.style) and (not (fsBold in curStyle)) then
        include(curStyle,fsBold);
      if ([fsItalic] <= richedit.selAttributes.style) then
        include(curStyle,fsItalic);
      if ([fsUnderLine] <= richedit.selAttributes.style) then
        include(curStyle,fsUnderline);
{}    result := PCLFont(curFont,CurSize,curStyle,1);
      change := false;
      printer.canvas.font.style := richedit.selattributes.style;
      s := splittext(plaintext,LineCnt,width{-75},dummy,false) {+ SplitMarker};
      sLen := length(s) + (LineCnt*2);
      richedit.SelectAll;
      if ([caBold] <= richedit.selattributes.ConsistentAttributes) then
        allBold := true
      else
        allBold := false;
      if ([caBold,caItalic,caUnderline] <= richedit.selattributes.ConsistentAttributes) then begin
        j := 0;
        while pos(SplitMarker,s) > 0 do begin
{}        result := result + PCLPopPush + PCLRelXY(0,j) + copy(s,1,pos(SplitMarker,s)-1);
          delete(s,1,pos(SplitMarker,s));
          inc(j,LineSpacing);
        end;
        if length(s)>0{2?} then
{}        result := result + PCLPopPush + PCLRelXY(0,j) + s {copy(s,1,length(s)-2) ?};
      end else begin
        cnt := 0;
        boldcnt := 0;
        richedit.Selstart := 0;
        richedit.SelLength := 1;
        s := s + SplitMarker;
        LineCnt := 0;
        while length(s) > 0 do begin
{}        result := result + PCLPopPush + PCLRelXY(0,LineCnt*LineSpacing);
          for j := 1 to pos(SplitMarker,s)-1 do begin
            if ([fsItalic] <= richedit.selattributes.style) and (not (fsItalic in curStyle)) then begin
              change := true;
              include(curStyle,fsItalic);
            end;
            if (not ([fsItalic] <= richedit.selattributes.style)) and (fsItalic in curStyle) then begin
              change := true;
              exclude(curStyle,fsItalic);
            end;
            if ([fsUnderline] <= richedit.selattributes.style) and (not (fsUnderline in curStyle)) then begin
              change := true;
              include(curStyle,fsUnderline);
            end;
            if (not ([fsUnderline] <= richedit.selattributes.style)) and (fsUnderline in curStyle) then begin
              change := true;
              exclude(curStyle,fsUnderline);
            end;
            if Subtype<>stSubsection then begin
              if ([fsBold] <= richedit.selattributes.style) and (not (fsBold in curStyle)) then begin
                change := true;
                include(curStyle,fsBold);
              end;
              if (not ([fsBold] <= richedit.selattributes.style)) and (fsBold in curStyle) then begin
                change := true;
                exclude(curStyle,fsBold);
              end;
            end;
            if change then begin
{}           result := result + PCLFont(curfont,cursize,curstyle,1);
              change := false;
            end;
{}          result := result + richedit.seltext;
            inc(cnt,richedit.SelLength);
            if ([fsBold] <= curstyle) then inc(boldcnt,richedit.SelLength);
            RESS := richedit.selstart+1;
            repeat
              richedit.selstart := RESS;
              richedit.SelLength := 1;
              inc(RESS);
            until (richedit.sellength>0) or (RESS>sLen);
          end;
          delete(s,1,pos(SplitMarker,s));

           if (richedit.seltext = ' ') and (s <> '') and (s[1] <> ' ') then begin
            RESS := richedit.selstart+1;
            repeat
              richedit.selstart := RESS;
              richedit.SelLength := 1;
              inc(RESS);
            until ((richedit.sellength>0) and (richedit.seltext <> ' ')) or (RESS>sLen);
          end;
          inc(LineCnt);
        end;
        if (cnt>0) and (BoldCnt/Cnt > 0.9) then
          allBold := true;
      end;
    end;
    while pos('·',result)>0 do
      result[pos('·',result)] := ' ';
  end;

begin
  orgVO := VO;
  curFont := rDQRichEdit[1].fontname;
  curSize := rDQRichEdit[1].fontsize;
  PCLStream := PCLFont(curFont,CurSize,[],1);
  pnl := 1;
  shp := 1;
  lbl := 1;
  for i := 1 to nDQRichEdit do begin
    CurStyle := [];
    QN := '';
    with rDQRichEdit[i] do begin
      if PCLReadable then
        r := ESC + '*p<<'+inttostr(left)+'X>>x<<'+inttostr(orgVO+top)+'Y>>Y' + PCLPush
      else
        r := ESC + '*p<<X>>x<<Y>>Y' + PCLPush;
      if orgVO+top+height>VO then VO := orgVO+top+height;
      if (CurFont<>Fontname) or (curSize<>fontsize) then begin
        r := r + PCLFont(Fontname,fontsize,curStyle,1);
        curFont := FontName;
        curSize := FontSize;
      end;
      if (Subtype <> stComment) or
        ((Subtype = stComment) and (scaleid=0))
      then begin
        if (color <> clwhite) or ((Subtype = stComment) and (BorderWidth>0)) then
          r := r + PCLPopPush + PCLRelXY(15-left,-round(0.75*linespacing)) +
              PCLBox(color,BorderWidth,-1,-1,width+(left-15),height-dmOpenQ.ExtraSpace);
        //if Subtype=stSubsection then begin
        //  include(Curstyle,fsBold);
        //  r := r + PCLFont(curFont,curSize,curStyle,1);
        //end;
        allBold := false;
        r := r + PCLRichEdit(rDQRichEdit[i],Subtype=stSubsection);
        if (mockup=ptCodeSheetMockup) and (SubType <> stComment) then
          r := r + PCLFont('Arial Narrow',9,[],1) + inttostr(rDQRichEdit[i].qstncore);
        if (QChar<>' ') or ((QChar=' ') and (QNmbr>0)) then begin
          if Subtype=stSubsection then begin
            if curstyle <> [fsBold] then
              r := r + PCLFont(curFont,curSize,[fsBold],1)
            else
               r := r + PCLFont(curFont,curSize,[],1); //GN12: ReInitialize the font property
          end else begin
            {curstyle := []; //GN15
            if allBold then
              r := r + PCLFont(curFont,curSize,[fsBold],1)
            else
              r := r + PCLFont(curFont,curSize,[],1);}
            if curstyle = [fsBold] then
               r := r + PCLFont(curFont,curSize,[fsBold],1)
            else
               r := r + PCLFont(curFont,curSize,[],1);
          end;
          if ((QChar=' ') and (QNmbr>0)) then begin
            if Qnmbr<100 then
              r := r + PCLPopPush + PCLRelXY(54-left,0) + inttostr(QNmbr)+'.'
            else
              r := r + PCLPopPush + PCLRelXY(9-left,0) + inttostr(QNmbr)+'.';
            QN := inttostr(QNmbr);
          end;
          if (QChar<>' ') then begin
            QN := inttostr(QNmbr) + QChar;
            if CAHPSNumbering then begin
              if QChar<>'Ç' then
                r := r + PCLPopPush + PCLRelXY(54-left,0) + QN+'.'
            end else if TreatQuestionLikeHeader then begin
              r := r + PCLPopPush + PCLRelXY(54-left,0) + QN+'.';
            end else
              r := r + PCLPopPush + PCLRelXY(204-left,0) + QChar+'.';
          end;
        end;
        if Subtype=stSubsection then begin
          exclude(Curstyle,fsBold);
          r := r + PCLFont(curFont,curSize,curStyle,1);
        end;

      end else {rDQRichedit[i].subtype=stComment} begin
        if BorderWidth > 0 then
        begin
          r := r + ESC + '*p+2x-2X' + PCLPopPush + PCLRelXY(5-left,-round(0.75*linespacing)) +
              PCLBox(clWhite,BorderWidth,-1,-1,((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 25,height - dmOpenQ.ExtraSpace); //GN17
          left:=left+BorderWidth;
        end;
        if (Qchar=' ') and (QNmbr>0) then  {1}
          rDQRichedit[i].width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 258
        else
          if QChar=' ' then {}
            rDQRichedit[i].width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 25
          else  {a.}
            rDQRichedit[i].width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 368;
        rDQRichedit[i].MarkCount := 5-left;
        if scaleid > 0 then begin
         //r := r + PCLPopPush + PCLRelXY(0,height-55-round(0.75*linespacing));  //GN17
         CmntLineRelY := height-55-round(0.75*linespacing) - dmOpenQ.ExtraSpace;
         r := r + PCLPopPush + PCLRelXY(0,CmntLineRelY);


          for L := 1 to scaleid do begin
            r := r + ESC + '*c'+inttostr(((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt)-85-left)+'a5b0P' +
                PCLRelXY(0,-round(LineSpacing*1.5));
            {The scanner doesn't need the X/Y/Width/Height of the actual line,
             rather, it needs the coordinates of the whitespace above the line.
             CmntLineRelY is the Y-position of the actual line.
             Further, we're defining a box 1/4 the height of LineSpacing so
             we don't have to worry about intersecting any printed text.}
            if ((mockup=ptRealSurvey) and (not testprints))  then
              dmOpenQ.CmntLocAppend(
                 rDQRichEdit[i].SelQstns_ID,  {SelQstn_ID}
                 scaleid+1-L,                 {Line#}
                 dmOpenQ.currentSampleUnit_id,
                 0,                           {RelX}
                 CmntLineRelY-20-round(Linespacing*5/8), {RelY}
                 ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt)-85-left, {Width}
                 LineSpacing div 4 );         {Height}
            CmntLineRelY := CmntLineRelY-round(LineSpacing*1.5) ;
          end;
        end;
        r := r + PCLPopPush + PCLRichEdit(rDQRichEdit[i],false);

        curstyle := [];
        if allBold then
          r := r + PCLFont(curFont,curSize,[fsBold],1)
        else
          r := r + PCLFont(curFont,curSize,[],1);

        if ((QChar=' ') and (QNmbr>0)) then begin
          QN := inttostr(QNmbr);
          r := r + PCLPopPush + PCLRelXY(54-left,0) + inttostr(QNmbr) + '.';
        end else if (QChar<>' ') then begin
          QN := inttostr(QNmbr)+QChar;
          if CAHPSNumbering then
            r := r + PCLPopPush + PCLRelXY(54-left,0) + QN + '.'
          else
            r := r + PCLPopPush + PCLRelXY(204-left,0) + QChar + '.';
        end;
      end;
      {Issue 189 fix:} rDQRichEdit[i].width := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 25;
    end;
    PCLStream := PCLStream + r;
    r := '';
    if rDQPanel[pnl].question = i then begin
      with rDQPanel[pnl] do begin
        if orgVO+top+height>VO then VO := orgVO+top+height;
        r := r + PCLShapeFont;
        while rDQShape[shp].panel = pnl do begin
          if rDQShape[shp].shape=stEllipse then begin
            r := r + BubblePut(i, shp,
              left-rDQRichEdit[i].left+rDQShape[shp].left,
              top-rDQRichEdit[i].top+rDQShape[shp].top-24);
          end else
            r := r + ICRBox(i, shp,
              left-rDQRichEdit[i].left+rDQShape[shp].left,
              top-rDQRichEdit[i].top+rDQShape[shp].top-round(0.75*LineSpacing) );
          inc(shp);
        end;
        dmopenq.BblLocFlush;
        dmopenq.HWLocFlush;
        if rDQLabel[lbl].panel = pnl then begin
          curFont := FontName;
          curSize := FontSize;
          curStyle := [];
          if rDQLabel[lbl].ScalePos = spRight then
            r := r + ESC + '*p+1x-1X'
          else begin
            r := r + ESC + '*p+2x-2X';
            rDQRichEdit[i].height := rDQRichEdit[i].height + height;
          end;
          SclStrm := PCLFont(Fontname,fontsize,curStyle,1); //test color
          SclHt := 0;
          while rDQLabel[lbl].panel = pnl do begin
            while pos('·',rDQLabel[lbl].caption) > 0 do
              rDQLabel[lbl].caption[pos('·',rDQLabel[lbl].caption)] := ' ';
            underline := 0;
            if pos(chr(1),rDQLabel[lbl].caption) > 0 then begin
              L := 0;
              while pos(chr(1),rDQLabel[lbl].caption) > 0 do begin
                SclStrm := SclStrm + ScaleLabelPut(i, lbl, left-rDQRichEdit[i].left+rDQLabel[lbl].left, top-rDQRichEdit[i].top+rDQLabel[lbl].top+(L*linespacing), underline, copy(rDQLabel[lbl].caption,1,pos(chr(1),rDQLabel[lbl].caption)-1));
                delete(rDQLabel[lbl].caption,1,pos(chr(1),rDQLabel[lbl].caption));
                inc(L);
              end;
              SclStrm := sclStrm + ScaleLabelPut(i, lbl, left-rDQRichEdit[i].left+rDQLabel[lbl].left,top-rDQRichEdit[i].top+rDQLabel[lbl].top+(L*linespacing), underline, rDQLabel[lbl].caption);

            end else
              SclStrm := SclStrm + ScaleLabelPut(i, lbl,
                left-rDQRichEdit[i].left+rDQLabel[lbl].left,
                top-rDQRichEdit[i].top+rDQLabel[lbl].top,
                underline,
                rDQLabel[lbl].caption);
            if (top-rDQRichEdit[i].top+rDQLabel[lbl].top) < SclHt then
              SclHt := (top-rDQRichEdit[i].top+rDQLabel[lbl].top);
            inc(lbl);
          end;
          if SclHt<0 then
            r := r + ESC + '*p'+inttostr(sclHt)+'X';
          while pos('›',SclStrm)>0 do begin
            insert(PCLShapeFont+'>'+PCLFont(Fontname,fontsize,curStyle,1),SclStrm,pos('›',SclStrm));
            delete(SclStrm,pos('›',SclStrm),1);
          end;
          r := r + SclStrm;
          if rDQLabel[lbl].ScalePos = spRight then
            r := r + ESC + '*p+1y-1Y';
        end;
      end;
      inc(pnl);
    end;
    PCLStream := PCLStream + r + PCLPop;
    tPCL.append;
    tPCLSection.value := SectOrder;
    tPCLorgSection.value := ThisSect;
    tPCLSubsection.value := ThisSub;
    tPCLItem.value := rDQRichedit[i].item;
    tPCLQstnCore.value := rDQRichedit[i].qstncore;
    tPCLX.value := rDQRichEdit[i].left;
    tPCLy.value := rDQRichEdit[i].top + orgVO;
    tPCLWidth.value := rDQRichEdit[i].width;
    tPCLHeight.value := rDQRichEdit[i].height;
    tPCLQNmbr.value := QN;
    tPCLPCLStream.value := ConvertAsciiCodes(PCLStream);
    tPCLSelQstns_id.value := rDQRichEdit[i].selQstns_id;
    if (rDQRichedit[i].subtype=stItem) then begin
(*
      // Hack for CAHPS open-ended/handwritten: //
      if rDQRichEdit[i].MarkCount < 0 then begin
        if rDQRichEdit[i].MarkCount = -1 then
          tPCLReadMethod.value := -5
        else
          tPCLReadMethod.value := -1;
        if rDQRichEdit[i].scaleid=CAHPSscale1 then
          tPCLIntRespCol.value := 4
        else
          tPCLIntRespCol.value := 2;
        case rDQRichEdit[i].scaleid of
          CAHPSscale1 : tPCLBegColumn.value := CAHPScolumn1;
          CAHPSscale2 : tPCLBegColumn.value := CAHPScolumn2;
          CAHPSscale3 : tPCLBegColumn.value := CAHPScolumn3;
          // CAHPSscale4 : tPCLBegColumn.value := CAHPScolumn4;
          CAHPSscale5 : tPCLBegColumn.value := CAHPScolumn5;
          CAHPSscale6 : tPCLBegColumn.value := CAHPScolumn6;
        else
          tPCLBegColumn.value := ResultColumn;
        end;
      end else
      // ------------------------------------- //
*)
       begin
        tPCLIntRespCol.value := rDQRichEdit[i].RespCol*rDQRichEdit[i].MarkCount;
        tPCLBegColumn.value := ResultColumn;
        if rDQRichEdit[i].MarkCount = 1 then
          tPCLReadMethod.value := 5 {most Real response}
        else
          tPCLReadMethod.value := 1; {All that apply}
        inc(resultcolumn,rDQRichEdit[i].RespCol*rDQRichEdit[i].MarkCount);
       end;
    end else if (rDQRichedit[i].subtype=stComment) then begin
      tPCLBegColumn.value := rDQRichEdit[i].MarkCount;
    end;
    if mockup=ptRealSurvey then
      tPCL.fieldbyname('SampleUnit_id').value := dmOpenq.currentSampleUnit_id;
    tPCL.post;
    PCLStream := '';
  end; {for i := 1 to nDQRichEdit}
end;

procedure tfrmLayoutCalc.BMPtoPCL(var tbl:twwTable; const bmpfield,PCLfield:string);
var k,l,b,i,x,y : longint;
    tiff,s,result : string;
    background : integer;
begin
  tGraphicField(tbl.fieldbyname(BMPfield)).savetofile(dmOpenQ.tempdir+'\logo.bmp');
  {try}
    LogoImage.picture.loadfromfile(dmOpenQ.tempdir+'\logo.bmp');
  {except
    logoimage.picture.assign(tJPEGImage(tbl.fieldbyname(bmpfield)));
    //deletefile(dmOpenQ.tempdir+'\logo.jpg');
    //renamefile(dmOpenQ.tempdir+'\logo.bmp',dmOpenQ.tempdir+'\logo.jpg');
    //LogoImage.picture.loadfromfile(dmOpenQ.tempdir+'\logo.jpg');
  end;}
  result := '';
  background := logoimage.canvas.pixels[0,0];
  for y := LogoImage.height-1 downto 0 do begin
    s := '';
    i := 8;
    b := 0;
    for x := 0 to (LogoImage.width-(logoImage.width mod 8)) do begin
      dec(i);
      if LogoImage.canvas.pixels[x,y] <> background then begin
        b := b + round(power(2,i));
      end;
      if i = 0 then begin
        s := s + chr(b);
        b := 0;
        i := 8;
      end;
    end;
    while (length(s)>1) and (s[length(s)]=#1) do
       delete(s,length(s),1);
    s := s + #0;
    tiff := '';
    k := 1;
    while k < length(s) do begin
      L := 0;
      if s[k] = s[k+1] then begin
        while (s[k] = s[k+L]) and (k+L<length(s)) and (L<126) do inc(L);
        tiff := tiff + chr(257-L) + s[k];
        k := k + L;
      end else begin
        while (s[k+L] <> s[k+L+1]) and (k+L<length(s)) and (L<126) do inc(L);
        tiff := tiff + chr(L) + copy(s,k,L+1);
        k := k + L + 1;
      end;
    end;
    if (tiff=#0#0) then
      result := ESC+'*b0W' + result
    else
      result := ESC+'*b'+inttostr(length(tiff))+'W'+tiff + result;
  end;
  result := ESC + '*r1A' + ESC + '*b2M' + result + ESC + '*r0F';
  tbl.edit;
  tbl.fieldbyname(PCLField).value := result;
  tbl.post;
end;

function tfrmLayoutCalc.TweakCoverPage:integer;
{if any elements on the cover page intersect another element, move the
 lower one down far enough so they don't intersect}
type
  tElement = record
    ID : integer;
    Rect : tRect;
    Moved : boolean;
  end;
var i,j,n : integer;
    dummyrect : tRect;
    Element : array[0..100] of tElement;
begin
  with tPCL do begin

    indexfieldnames := 'ID';
    first;
    n := 0;
    while not eof do begin
      if (tPCLX.value + tPCLY.value + tPCLWidth.value + tPCLHeight.value > 0) and (tPCLQnmbr.value<>'Adr') and (tPCLQnmbr.value<>'BMP') then begin
        inc(N);
        with Element[n] do begin
          id := tPCLID.value;
          Rect := Bounds(tPCLX.value, tPCLY.value,
                         tPCLWidth.value, tPCLHeight.value);
          moved := false;
        end;
      end;
      next;
    end;

    if n > 1 then begin

      for i := 1 to n do
        for j := i to n do
          if element[i].rect.top > element[j].rect.top then begin
            element[0] := element[i];
            element[i] := element[j];
            element[j] := element[0];
          end;

      for i := 1 to n do
        for j:=i+1 to n do
        if IntersectRect(dummyrect, element[i].rect, element[j].rect) then
          with element[j] do begin
            OffsetRect(rect,0,element[i].rect.bottom-rect.top);
            Moved := true;
          end;
      result := 0;
      i:=0;
      while i < n do begin
        inc(i);
        if element[i].moved then begin
          findkey([element[i].id]);
          if tPCLQNmbr.value = 'Brk' then
            PageBreakY := element[i].rect.top;
          edit;
          tPCLY.value := element[i].rect.top;
          post;
        end;
        if (result < element[i].rect.bottom) then
          result := element[i].rect.bottom;
      end;
    end else if n = 1 then
      result := element[1].rect.bottom
    else
      result := 0;
  end;
end;

procedure tfrmLayoutCalc.SpreadOutQstns(const Whitespace:integer);
var Offset : real;
begin
  with tPCL do begin
    Offset := 0.0;
    first;
    while not eof do begin
      if (not integratedcover) and (tPCLSection.value=0) and (tPCLY.value>PageBreakY) then
        inc(surveyitems);
      if tPCLSection.value>0 then begin
        if Offset > 0.0 then begin
          edit;
          tPCLY.value := tPCLY.value + round(offset);
          post;
        end;
        offset := offset + (Whitespace/SurveyItems)
      end;
      next;
    end;
  end;

end;

function tfrmLayoutCalc.SheetTypeVal:integer;
begin
  case SheetType of
    Letter: result := 1;
    Legal: result := 2;
    Tabloid: result := 3;
    DblLegal: result := 5;
  else
    result := -1;
  end;
end;

procedure tfrmLayoutCalc.PaperChoice(const CoverHeight,TotalHeight:integer);
{definitions:
  Sheet: a physical sheet of paper
  Side: one side of a sheet
  Page: one 8.5" wide column on a sheet (1 on each side of a letter or legal,
        2 on each side of a tabloid
 }
const
  Pages : array[Letter..DblLegal] of integer = (2,2,4,4);
  PageHeight : array[Letter..DblLegal] of array[0..3] of integer =
    ((5745,5745,0,0),
     (7545,7545,0,0),
     (5745,5745,5745,5745),
     (7545,7545,7545,7545));
  (* ({Page 2},{Page 1},0,0),
     ({Page 2},{Page 1},0,0),
     ({Page 4},{Page 1},{Page 2},{Page 3}),
     ({Page 4},{Page 1},{Page 2},{Page 3}) *)
  HorzOffset : array[Letter..DblLegal] of array[0..3] of integer =
    ((0,0,0,0),
     (0,0,0,0),
     (0,5100,0,5100),
     (0,5100,0,5100));

var SurveyHeight,capacity,TotalPages,PaperTypeAnswer : integer;
    Multisheet : boolean;
    s : string;

  function SmallestPaper(const Height,CoverHeight:integer):tSheetTypes;  // the CoverHeight parameter has no effect on 1-column surveys since it's always involved in calculations with (ColumnCnt-1)*___
  var r : tSheetTypes;
      i,Page1Capacity : integer;
      endType : tSheetTypes;
  begin
    if dmOpenQ.considerDblLegal then
      endtype := dblLegal
    else
      endtype := Tabloid;
    r := ptNull;
    repeat begin
      inc(R);
      capacity := 0;
      for i := 1 to Pages[R] do inc(capacity,ColumnCnt*PageHeight[R][i mod Pages[R]]); // total height of the paper size e.g. 2 col on 2 legal sides = 2*2*7545 = 30180
      dec(capacity,ColumnCnt*LineSpacing*2*pages[R]); // less two lines per column (to make room for potential header repeats)
      dec(Capacity,(ColumnCnt-1)*(AfterPageBreakCoverHeight+CoverHeight)); // less the coverletter (or after page-break cover) for the 2nd column
    end until (capacity >= Height) or (R=endType);
    Multisheet := ( {1 sheet's}capacity < Height );
    if ((MultiSheet and (r=dblLegal)) or (mockup<>ptRealSurvey)) then begin
      if (MultiSheet and (r=dblLegal)) then r := Tabloid;
      if mockup<>ptRealSurvey then begin
        if r=Tabloid then begin
          if PaperTypeAnswer=-1 then
            PaperTypeAnswer := MessageBox(Screen.ActiveForm.Handle, 'This survey would be printed on 11x17 (tabloid).  '+
                               'Do you want to print it on 8.5x11 (letter)?',
                               'Confirm Paper Size', MB_APPLMODAL or MB_ICONQUESTION or MB_YESNO);

            {// use MessageBox because messagedlg does not behave the same in xp. It will often hide behind the form
            PaperTypeAnswer := messagedlg('This survey would be printed on 11x17 (tabloid).  '+
              'Do you want to print it on 8.5x11 (letter)?',mtconfirmation,[mbyes,mbno],0);
            }
          if PaperTypeAnswer = mrYes then
            r := letter;
        end else begin
          if r=dbllegal then begin
            if PaperTypeAnswer=-1 then
              PaperTypeAnswer := MessageBox(Screen.ActiveForm.Handle, 'This survey would be printed on 14x17 (double legal).  '+
                               'Do you want to print it on 8.5x14 (legal)?',
                               'Confirm Paper Size', MB_APPLMODAL or MB_ICONQUESTION or MB_YESNO);

              {// use MessageBox because messagedlg does not behave the same in xp. It will often hide behind the form
              PaperTypeAnswer := messagedlg('This survey would be printed on 14x17 (double legal).  '+
                'Do you want to print it on 8.5x14 (legal)?',mtconfirmation,[mbyes,mbno],0);
              }
            if PaperTypeAnswer = mrYes then
              r := Legal;
          end;
        end;
      end;
      capacity := 0;
      for i := 1 to Pages[R] do
        inc(capacity,{ColumnCnt*}PageHeight[R][i mod Pages[R]]);
      dec(capacity,ColumnCnt*LineSpacing*2*pages[R]);
      Page1Capacity := capacity - ((ColumnCnt-1)*(AfterPageBreakCoverHeight+CoverHeight));
    end else
      Page1Capacity := capacity;
    if Height <= Page1Capacity then begin
      capacity := page1Capacity;
      TotalPages := pages[r];
    end else begin
      TotalPages := (2 + ((Height-Page1Capacity) div capacity)) * pages[r];
      {Total}Capacity := Page1Capacity + ((1 + ((Height-Page1Capacity) div capacity)) * capacity);
    end;
    SmallestPaper := r;
  end;

  procedure PickedTypeMsg;
  var s : string;
  begin
    case SheetType of
      Letter: s := 'Letter';
      Legal: s := 'Legal';
      Tabloid: s := 'Tabloid';
      DblLegal: s := 'DoubleLegal';
    end;
    if Multisheet then s := s + ' Multisheet'
    else s := s + ' Singlesheet';
    if IntegratedCover then s := s + ' Integrated'
    else s := s + ' Separate';
    messagedlg('TotalHeight='+inttostr(totalheight) +
             '  CoverHeight='+inttostr(coverheight) +
             '  SurveyHeight='+inttostr(Surveyheight) +
             '  ' + s,
             mtinformation,[mbok],0);
  end;

  procedure RepeatHeaders;
  var curPage,curY,curSect,curSub,curItem,curCore,curSelQstns_id:integer;
      prevPage,PrevY,prevItem,offset,QstnAHeight,ScaleHeight,HeaderWidth,HeaderHeight : integer;
      SubSectHeader,curScale:string;
  begin
    dmOpenQ.wwt_Qstns.disablecontrols;
    //if mockup<>ptRealSurvey then
      dmOpenQ.wwt_Qstns.indexfieldnames := 'Survey_ID;SelQstns_ID';
    //else
    //  dmOpenQ.wwt_Qstns.indexfieldnames := 'Survey_ID;SampleUnit_id;SelQstns_ID';
    dmOpenQ.wwt_Qstns.filtered := false;
    with tPCL do begin
      indexfieldnames := 'Section;Subsection;Item;QstnCore';
      first;
      curScale := '';
      ScaleHeight := 0;
      QstnAHeight := 0;
      prevItem := -1;
      prevPage := tPCLPagenum.value;
      prevY := tPCLY.value;
      offset := 0;
      headerheight := 0;
      headerwidth := 0;
      repeat begin
        curPage := tPCLPagenum.value;
        curY    := tPCLY.value;
        curSect := tPCLSection.value;
        curSub  := tPCLSubsection.value;
        curItem := tPCLItem.value;
        curCore := tPCLQstnCore.value;
        curSelQstns_id := tPCLSelQstns_id.value;
        s := tPCLPCLStream.value;
        if (curSect>0) and (curSub>0) and (curItem=0) then begin
          SubSectHeader := s;
          HeaderHeight := tPCLHeight.value;
          HeaderWidth := tPCLWidth.value;
        end;
        if (curSect>0) and (curSub>0) and (curItem=1) and (PrevItem <> 0) then
          SubSectHeader := '';
        if pos(ESC+'*p+1x-1X',s)>0 then begin
          if pos(ESC+'*p+1x-1X'+ESC+'*p-',s)>0 then begin
            curScale := copy(s,pos(ESC+'*p+1x-1X'+ESC+'*p-',s)+13,4);
            while (length(curScale)>0) and (strtointdef(curScale[length(curScale)],-1)=-1) do
              mydelete(curscale,length(curscale),1);
            ScaleHeight := strtointdef(curScale,0);
          end else
            ScaleHeight := 0;
          mydelete(s,1,pos(ESC+'*p+1x-1X',s)-1);
          curScale := s;
          QstnAHeight := tPCLHeight.value;
        end else if pos(ESC+'*p+2x-2X',s)>0 then begin
          curScale := '';
          ScaleHeight := 0;
          QstnAHeight := 0;
        end;
        if (curPage <> prevPage) or (curY<prevY) then begin
          offset := 0;
          if (curScale <> '') and (curItem>0) and (curCore>0) then begin
            edit;
            tPCLPCLStream.value := tPCLPCLStream.value + PCLRelXY(0,tPCLHeight.value-QstnAHeight)+PCLPush + curScale;
            if (ScaleHeight > 0) and ((SubSectHeader = '') or (curItem<=0)) then begin
              tPCLY.value := tPCLY.value + scaleHeight;// - LineSpacing;
              offset := scaleHeight;// - LineSpacing;
            end;
            post;
          end;
          if (SubSectHeader <> '') and (curItem>0) then begin
            appendrecord([null,curSect,curSub,curItem,-1,
              tPCLX.value-110,tPCLy.value,null,null,'Hdr',
              SubSectHeader,curPage,null,null,null,curSelQstns_id]);
            if HeaderWidth > 4500 then
              offset := HeaderHeight + ScaleHeight
            else if ScaleHeight>HeaderHeight then
              offset := ScaleHeight
            else
              offset := HeaderHeight;
          end;
          prevPage := curPage;
        end else
          if offset>0 then begin
            edit;
            tPCLY.value := tPCLY.value + offset;
            post;
          end;
        prevY := curY;
        prevItem := curItem;
        next;
      end until eof;
    end;
    dmOpenQ.wwT_QstnsEnableControls;
    dmOpenQ.wwT_Qstns.filtered := true;
  end;

  procedure SplitIntoPages;
  var CLoffset,FirstPageCol2Offset,offset,thispagecap,prevItem,increasedcapacity,prevSub,CoverLetterAfterPageBreak : integer;
      PrevIs0LineCmnt,col2 : boolean;
      LastSec:integer;
      SavePlace: TBookmark;
  begin
    CoverLetterAfterPageBreak := 0;
    with tPCL do begin
      first;
      if IntegratedCover then
        CLoffset := 0
      else begin
        while (not eof) and (tPCLSection.value<=0) do begin
          edit;
          if (PageBreakY=-1) or (tPCLY.value < PageBreakY) then begin
            tPCLSheet.value := 0;
            tPCLSide.value := 0;
            tPCLPagenum.value := 0;
          end else begin
            tPCLPagenum.value := 1;
            tPCLY.value := tPCLY.value + TopMargin - PageBreakY;
            tpclx.Value := tpclx.value + horzoffset[sheettype, 1];
            if (tPCLY.value + tPCLHeight.Value) > CoverLetterAfterPageBreak then
              CoverLetterAfterPageBreak := tPCLY.value + tPCLHeight.Value;
          end;
          post;
          next;
        end;
        if PageBreakY=-1 then
          CLoffset := tPCLY.value-TopMargin
        else begin
          CLoffset := tPCLY.value-TopMargin-(tPCLY.value-PageBreakY);
          //messagedlg('PageBreakY='+inttostr(pagebreaky)+#10+'offset='+inttostr(CLoffset)+#10+'offset was '+inttostr(tPCLY.value-TopMargin),mtinformation,[mbok],0);
        end;
      end;
      if IncludeQstns then begin
        increasedcapacity := 0;
        if dmOpenQ.SpreadToFillPages then begin
          SavePlace := GetBookmark;
          repeat begin
            offset := CLOffset;
            SurveyPages := 1;
            prevItem := -1;
            prevSub := -1;
            PrevIs0LineCmnt := false;
            while not eof do begin
              ThisPageCap := increasedcapacity + PageHeight[SheetType,SurveyPages mod pages[SheetType]];
              if (tPCLY.value+tPCLHeight.value) > offset+ThisPageCap+TopMargin then begin
                if ((tPCLItem.value=1) and (prevItem=0))
                  or ( PrevIs0LineCmnt and (tPCLSubsection.value=prevSub)) {CAHPS hack}
                 then begin
                  prior;
                  if pos(tPCLQNmbr.value,'Adr,Cvr,BMP,PCL')>0 then next;
                end;
                offset := tpclY.value-TopMargin;
                inc(SurveyPages);
              end;
              prevItem := tPCLitem.value;
              prevSub := tPCLSubsection.value;
              PrevIs0LineCmnt := (tPCLQstnCore.value=0) and (tPCLQnmbr.value='');
              next;
            end;
{ tried for two-column surveys:
            if (SurveyPages mod 2=1) or (SurveyPages mod (ColumnCnt*pages[SheetType]) <> 0) then begin // survey is spilling over onto an extra page
              if SurveyPages mod (ColumnCnt*pages[SheetType]) = (ColumnCnt*pages[SheetType])-1 then
                dec(increasedcapacity,100)
              else
                inc(increasedcapacity,100);
}
// ---- original 1-column code:
            if (surveypages mod pages[SheetType] <> 0) then begin // survey is spilling over onto an extra page
              inc(increasedcapacity,100);
// ----
              GotoBookmark(SavePlace);
            end;
{ tried for two-column surveys:
          end until (SurveyPages mod 2=0) and (SurveyPages mod (ColumnCnt*pages[SheetType]) = 0);
}
// ---- original 1-column code:
          end until (SurveyPages mod pages[SheetType] = 0);
// ----
          GotoBookmark(SavePlace);
          FreeBookmark(SavePlace);
        end;
        offset := CLOffset;
        FirstPageCol2Offset := -1;
        SurveyPages := 1;
        prevItem := -1;
        prevSub := -1;
        PrevIs0LineCmnt := false;
        col2 := false;
        while not eof do begin
          ThisPageCap := increasedcapacity + PageHeight[SheetType,SurveyPages mod pages[SheetType]];
          if (tPCLY.value+tPCLHeight.value) > offset+ThisPageCap+TopMargin then begin
            if ((tPCLItem.value=1) and (prevItem=0))
              or ( PrevIs0LineCmnt and (tPCLSubsection.value=prevSub)) {CAHPS hack}
             then begin
              prior;
              if pos(tPCLQNmbr.value,'Adr,Cvr,BMP,PCL')>0 then
                next
              else begin
                edit;
                tpclY.value := tPCLY.value + offset;
                //tpclX.value := tPCLX.value - HorzOffset[SheetType, SurveyPages mod pages[SheetType]];
                if Col2 then
                  tpclX.value := tPCLX.value - HorzOffset[SheetType, SurveyPages mod pages[SheetType]]
                                             - ((PageWidth+(ColumnGutter*(ColumnCnt-1))) div ColumnCnt)
                else
                  tpclX.value := tPCLX.value - HorzOffset[SheetType, SurveyPages mod pages[SheetType]];
                post;
              end;
            end;
            if ColumnCnt=2 then begin
              if col2 then inc(surveyPages);
              col2 := not col2;
            end else
              inc(SurveyPages);
            if col2 and (surveypages=1) and (CoverLetterAfterPageBreak + tPCLHeight.value > ThisPageCap) then begin //((offset + CoverLetterAfterPageBreak) < (tPCLY.value+tPCLHeight.value)) then begin
                col2 := false;
                inc(SurveyPages);
            end;
            if col2 and (surveypages=1) then
              offset := tpclY.value-FirstPageCol2Offset
            else
              offset := tpclY.value-TopMargin;
          end;
          if (ColumnCnt>1) and (FirstPageCol2Offset=-1) and (pos(tPCLQNmbr.value,'Adr,Cvr,BMP,PCL')=0) then begin
            FirstPageCol2Offset := tPCLY.value-CLOffset;

            if (tPCLY.value+tPCLHeight.value) > ThisPageCap+TopMargin then begin
              if col2 and (surveypages=1) and (FirstPageCol2Offset + CoverLetterAfterPageBreak + tPCLHeight.value > ThisPageCap) then begin //((offset + CoverLetterAfterPageBreak) < (tPCLY.value+tPCLHeight.value)) then begin
                  col2 := false;
                  inc(SurveyPages);
              end;
              offset := tpclY.value-FirstPageCol2Offset;
              {
              if col2 and (surveypages=1) then
                offset := tpclY.value-FirstPageCol2Offset
              else
                offset := tpclY.value-TopMargin;
              }
            end;

          end;
          edit;
          tPCLPagenum.value := SurveyPages;
          tpclY.value := tPCLY.value - offset;
          if Col2 then
            tpclX.value := tPCLX.value + HorzOffset[SheetType, SurveyPages mod pages[SheetType]] + ((PageWidth+(ColumnGutter*(ColumnCnt-1))) div ColumnCnt)
          else
            tpclX.value := tPCLX.value + HorzOffset[SheetType, SurveyPages mod pages[SheetType]];
          post;
          prevItem := tPCLitem.value;
          prevSub := tPCLSubsection.value;
          PrevIs0LineCmnt := (tPCLQstnCore.value=0) and (tPCLQnmbr.value='');
          next;
        end;

        //added to solve single sided problem
        if not dmOpenQ.SpreadToFillPages then
        begin
          last;
          LastSec := tPCLSection.value;
          while (SurveyPages mod pages[SheetType] <> 0) do
          begin
            inc(SurveyPages);
            inc(LastSec);
            append;
            tPCLSection.value:=LastSec;
            tPCLSubSection.value:=1;
            tPCLItem.value:=0;
            tPCLQstnCore.value:=0;
            tPCLPagenum.value := SurveyPages;
            if Col2 then
              tpclX.value := tPCLX.value + HorzOffset[SheetType, SurveyPages mod pages[SheetType]] + ((PageWidth+(ColumnGutter*(ColumnCnt-1))) div ColumnCnt)
            else
              tpclX.value := tPCLX.value + HorzOffset[SheetType, SurveyPages mod pages[SheetType]];
            tPCLHeight.value := PageHeight[SheetType,SurveyPages mod pages[SheetType]];
            post;
          end;
        end;

        RepeatHeaders;
        if dmOpenQ.SpreadToFillPages and (SurveyPages mod pages[SheetType] <> 0) then
          if mockup<>ptRealSurvey then
            messagedlg('WARNING: Some items at the end of the survey might not have been printed!',mterror,[mbok],0)
          else begin
            dmOpenQ.GenError := 37;
            raise EGenErr.Create('Some items at the end of the survey might not have been printed');

          end;
      end else begin {Not IncludeQstns}
        dmopenq.cn.execute('delete from PCLResults where Pagenum>0');
      end;
    end;
  end;

  function XtoCol(X:integer):integer;
  begin
    case X of
         0..1400: result := 1;
      1401..4000: result := 2;
      4001..6500: result := 1;
      6501..9000: result := 2;
    end;
  end;

  procedure AssignSides;
  var vSide,vSheet,vPage,prevPage,vCol : integer;
      vTotalPages : integer;
  begin
    if not IntegratedCover then begin
      tPCL.filter := 'PageNum>0';
      tPCL.filtered := true;
    end;
    vTotalPages := SurveyPages;
    while vTotalPages mod pages[SheetType] <> 0 do inc(vTotalPages);
    tPCL.first;
    vSide := 0;
    //vSheet := 0;
    prevPage := -1 {tPCLPagenum.value};
    while not tPCL.eof do begin
      vPage := tPCLpagenum.value;
      if prevPage <> vPage then begin
        PageItems[vPage,1] := 0;
        PageLastY[vPage,1] := 0;
        PageItems[vPage,2] := 0;
        PageLastY[vPage,2] := 0;
        if (SheetType=Letter) or (SheetType=Legal) then
          vSide := vPage
        else {sheettype = Tabloid or DblLegal}
          if vPage <= (vTotalPages div 2) then
            inc(vSide)
          else
            if vPage > succ(vTotalPages div 2) then
              dec(vSide);
      end;
      if tPCLSection.value > 0 then
        inc(PageItems[vPage,XtoCol(tPCLX.value)]);
      if PageLastY[vPage,XtoCol(tPCLX.value)] < tPCLY.value + tPCLHeight.value then
        PageLastY[vPage,XtoCol(tPCLX.value)] := tPCLY.value + tPCLHeight.value;
      vSheet := succ(vSide) div 2;
      tpcl.edit;
      tPCLSide.value := vSide;
      tPCLSheet.value := vSheet;
      tpcl.post;
      prevPage := vPage;
      tPCL.next;
    end;
    if not IntegratedCover then begin
      tPCL.filtered := false;
      tPCL.filter := '';
    end;
  end;
  procedure RemovePagePadding;
  var vPage,prevPage,vCol : integer;
      i,ExtraSpace : array[1..2] of integer;
  begin
    with tPCL do begin
      indexfieldnames := 'Pagenum;Y';
      first;
      prevPage := 0;
      i[1] := 0;
      i[2] := 0;
      ExtraSpace[1] := 0;
      ExtraSpace[2] := 0;
      while not eof do begin
        vPage := tPCLPagenum.value;
        vCol := XtoCol(tPCLX.value);
        if (vPage <> prevPage) then begin
          i[1] := 0;
          i[2] := 0;
          ExtraSpace[1] := TopMargin + PageHeight[SheetType,vPage mod pages[SheetType]] - PageLastY[vPage,1];
          ExtraSpace[2] := TopMargin + PageHeight[SheetType,vPage mod pages[SheetType]] - PageLastY[vPage,2];
        end;
        // for one-column surveys, compress or expand the items on the page to fill the white space at the end
        // for two-column surveys, only compress the items in the column (if needed); don't expand them
        if (tPCLSection.value>0) and ((ColumnCnt=1) or (ExtraSpace[vCol]<0)) then begin
          if (i[vCol]>0) then begin
            edit;
            tPCLYadj.value := (i[vCol] * (ExtraSpace[vCol] div pageitems[vPage,vCol]));
            post;
          end;
          inc(i[vCol]);
        end;
        prevpage := vPage;
        next;
      end;
      indexfieldnames := '';
      dmopenq.localquery('update pclresults set y = y + yAdj where yAdj <> 0',true);
{
      first;
      while not eof do begin
        if tPCLYadj.asInteger<>0 then begin
          edit;
          tPCLY.value := tPCLY.value + tPCLYAdj.value;
          post;
        end;
        next;
      end;
}
    end;
  end;

begin
  IntegratedCover := dmOpenq.wwt_cover.fieldbyname('Integrated').value;
  LetterHead := dmOpenq.wwt_cover.fieldbyname('bitLetterhead').value;
  SurveyHeight := TotalHeight-CoverHeight;
  PaperTypeAnswer := -1;
  if IntegratedCover then begin
    SheetType := SmallestPaper(TotalHeight,TotalHeight-SurveyHeight);
    if Multisheet then begin
      SheetType := SmallestPaper(SurveyHeight,0);
      IntegratedCover := Multisheet;
      if IntegratedCover then SheetType := SmallestPaper(TotalHeight,TotalHeight-SurveyHeight);
    end;
  end else
    SheetType := SmallestPaper(SurveyHeight,0);
  //PickedTypeMsg;
  if SurveyItems>0 then begin
    if dmOpenQ.SpreadToFillPages and IncludeQstns then
      if IntegratedCover then
        SpreadOutQstns(Capacity - TotalHeight {- (TotalPages * (SurveyHeight div (2*SurveyItems)))})
      else
        SpreadOutQstns(Capacity - SurveyHeight {- (TotalPages * (SurveyHeight div (2*SurveyItems)))});

    SplitIntoPages;
    if IncludeQstns then begin
      AssignSides;
      RemovePagePadding;
    end;
  end;
end;

procedure tfrmLayoutCalc.PrintLogo;
var s :string;
begin
  with dmOpenQ, wwt_Logo do begin
    if wwt_LogoPCLStream.value='' then
      BMPtoPCL(wwt_Logo,'Bitmap','PCLStream');
    s := ESC + '&f'+inttostr(LogoMacro+wwt_logoid.value)+'y0X' +
        ESC + '*t' + inttostr(wwt_logoScaling.value) + 'R' +
        wwt_LogoPCLStream.value +
        ESC + '&f1X';
    tPCL.append;
    tPCLSection.value := -1;
    tPCLItem.value := LogoMacro+wwt_logoid.value;
    tPCLPCLStream.value := s;
    tPCLQnmbr.value := 'BMP';
    tPCLSelQstns_id.value := 0;
    tPCLY.value := (wwt_LogoY.value*4800) div 710;
    tPCL.post;
    if PCLReadable then
      s := ESC + '*p<<'+inttostr((wwt_LogoX.value*4800) div 710)+'X>>x<<'+inttostr((wwt_LogoY.value*4800) div 710)+'Y>>Y' +
           ESC + '&f'+inttostr(LogoMacro+wwt_logoid.value)+'y2X'
    else
      s := ESC + '*p<<X>>x<<Y>>Y' +
           ESC + '&f'+inttostr(LogoMacro+wwt_logoid.value)+'y2X';
    tPCL.append;
    tPCLX.value := (wwt_LogoX.value*4800) div 710;
    tPCLY.value := (wwt_LogoY.value*4800) div 710;
    tPCLHeight.value := (wwt_LogoHeight.value*4800) div 710;
    tPCLWidth.value := (wwt_LogoWidth.value*4800) div 710;
    tPCLPCLStream.value := s;
    tPCLQnmbr.value := 'Cvr';
    tPCLSection.value := 0;
    tPCLSelQstns_id.value := 0;
    tPCL.post;
  end;
end;

procedure tfrmLayoutCalc.CoverLetterGen(var CvrHght,Page2Hght:integer);
var s,whereclause : string;
    i,L : integer;
    UseACS:boolean;
begin
  with dmOpenQ, wwt_Logo do begin
    first;
    while not eof do begin
      PrintLogo;
      next;
    end;
  end;
  with dmOpenQ, wwt_PCL do begin
    first;
    PageBreakY := -1;
    while not eof do begin
      if wwT_PCLDescription.Value <> '*PageBreak*' then begin
        s := ESC + '&f'+inttostr(PCLMacro+wwt_PCLID.value)+'y0X' +
            wwt_PCLPCLStream.value +
            ESC + '&f1X';
        tPCL.append;
        tPCLSection.value := -1;
        tPCLItem.value := PCLMacro+wwt_PCLID.value;
        tPCLPCLStream.value := s;
        tPCLQnmbr.value := 'PCL';
        tPCLSelQstns_id.value := 0;
        tPCLY.value := (wwt_PCLY.value*4800) div 710;
        tPCL.post;
      end;
      s := ESC + '*p<<X>>x<<Y>>Y' +
           ESC + '&f'+inttostr(PCLMacro+wwt_PCLID.value)+'y2X';
      tPCL.append;
      tPCLX.value := (wwt_PCLX.value*4800) div 710;
      tPCLY.value := (wwt_PCLY.value*4800) div 710;
      if wwT_PCLKnownDimensions.value then begin
        tPCLHeight.value := (wwt_PCLHeight.value*4800) div 710;
        tPCLWidth.value := (wwt_PCLWidth.value*4800) div 710;
      end else begin
        tPCLHeight.value := 0;
        tPCLWidth.value := 0;
      end;
      if wwT_PCLDescription.Value = '*PageBreak*' then begin
        PageBreakY := (wwt_PCLY.value*4800) div 710;
        tPCLQnmbr.value := 'Brk';
        tPCLPCLStream.value := '';
      end else begin
        tPCLPCLStream.value := s;
        tPCLQnmbr.value := 'Cvr';
      end;
      tPCLSection.value := 0;
      tPCLSelQstns_id.value := 0;
      tPCL.post;
      next;
    end;
  end;
  dmOpenq.wwt_logo.mastersource := nil;
  dmOpenq.wwt_logo.indexfieldnames := 'Survey_ID;'+qpc_ID;
  if mockup<>ptRealSurvey then
    dmopenq.currentSampleUnit_id := 0
  else begin
    dmopenq.LocalQuery('select min(SampleUnit_id) as RootUnit from PopSection',false);
    dmopenq.currentSampleUnit_id := dmOpenQ.ww_Query.fieldbyname('RootUnit').value;
    dmOpenQ.ww_Query.close;
  end;
  with DMOpenQ.wwt_TextBox do begin
    first;
    while not eof do begin
      if fieldbyname('Shading').value <> clGreen then
        PCLTextBox(1)
      else begin
        if mockup<>ptRealSurvey then begin
          if dmopenq.wwt_logo.FindKey([dmopenq.glbsurveyid,fieldbyname('border').value]) then
            printlogo;
        end else begin
          s := dmOpenQ.wwT_TextBoxRichText.value;
          if s = '' then begin
            s := qpc_ID+'='+fieldbyname('border').asstring;
            whereclause := 'where survey_id='+inttostr(dmopenq.glbsurveyid)+' and ' + s;
          end else begin
            mydelete(s,1,pos('::',s)+1);
            whereclause := 'where survey_id='+inttostr(dmopenq.glbsurveyid)+' and ' +
               'upper(description)='''+uppercase(s)+'''';
          end;
          dmopenq.DownLoadLogo(whereclause);
        end;
      end;
      next;
    end;
  end;
  with DMOpenQ, wwt_Qstns do begin
    {Address:}
    if (mockup=ptRealSurvey) and filtered then filtered := false;
    DisableControls;
    if indexfieldnames <> qpc_Section+';Subsection;Item' then
      indexfieldnames := qpc_Section+';Subsection;Item';
    if (findkey([-1,1,0])) then begin
      PersonalizeRTF(FieldByName('RichText').Value); //GN05
      L := 0;
      UseACS:=pos('#',richedit.lines.strings[0])=1;

      s := ESC + '*p<<X>>x<<Y>>Y' + PCLPush + PCLFont('Arial',11,[],1);
      for i := 0 to richedit.lines.count-1 do begin
        if richedit.lines[i] <> '' then begin
          inc(L);
          s := s + PCLPopPush + PCLRelXY(0,LineSpacing*L);

          if copy(richedit.lines[i],1,1)='|' then
          begin
              s := s + PCLRelXY(0,-LineSpacing);

            if UseACS then
               s := s + '#' + PCLRunMacro(497) + '# ';

            s := s + '** ' + PCLRunMacro(500) + '-' + PCLRunMacro(499) + ' **' + PCLPopPush;



{ POST NET BAR CODE removal   POSTNET BARCODE removal
            if AllIn(richedit.lines[i],'|0123456789') then
              s := s + PCLRelXY(0,LineSpacing*L) + ESC + '(1X' + richedit.lines[i] + PCLFont('Arial',11,[],1);}
          end else
            if pos(#27,richedit.lines[i])+pos('[27]',richedit.lines[i])=0 then
              s := s + uppercase(richedit.lines[i])
            else
              s := s + richedit.lines[i];

        end;
      end;
      s := s + PCLPop;
      if (mockup=ptRealSurvey) and (pos('{',s) + pos('«',s) + pos('¯',s) > 0) then
        raise EOrphanTagError.Create( 'FormGenError 7 (Orphan Tag)');
      tPCL.append;
      tPCLX.value := AddrPosX;
      tPCLY.value := AddrPosY;
      tPCLHeight.value := 0;
      tPCLWidth.value := 0;
      tPCLPCLStream.value := ConvertAsciiCodes(s);
      tPCLQnmbr.value := 'Adr';
      tPCLSection.value := 0;
      tPCLSelQstns_id.value := 0;
      tPCL.post;
    end else begin
      dmOpenQ.GenError := 13;
      raise EGenErr.Create('No address information');
    end;
  end;
  CvrHght := TweakCoverPage + LineSpacing;
  if PageBreakY>-1 then begin
    Page2Hght := CvrHght-PageBreakY;
    CvrHght := PageBreakY;
  end else
    Page2Hght := 0;
end;

procedure tfrmLayoutCalc.PostcardGen(const PgType:integer);
var s,s2,PostageStamp : string;
    i,L,split : integer;
begin
  if pgType=2 then split:=444 else split:=577;
  with dmOpenQ, wwt_Logo do begin
    first;
    while not eof do begin
      if wwt_LogoPCLStream.value='' then
        BMPtoPCL(wwt_Logo,'Bitmap','PCLStream');
      s := ESC + '*p<<X>>x<<Y>>Y' +
           ESC + '*t' + inttostr(wwt_logoScaling.value) + 'R' +
           wwt_LogoPCLStream.value;
      tPCL.append;
      if wwt_LogoX.value < split then begin
        tPCLX.value := (wwt_LogoX.value*4800) div 710;
        tPCLSide.value := 1;
        tPCLQnmbr.value := 'PC1';
      end else begin
        tPCLX.value := ((wwt_LogoX.value-split)*4800) div 710;
        tPCLSide.value := 2;
        tPCLQnmbr.value := 'PC2';
      end;
      tPCLY.value := (wwt_LogoY.value*4800) div 710;
      tPCLHeight.value := (wwt_LogoHeight.value*4800) div 710;
      tPCLWidth.value := (wwt_LogoWidth.value*4800) div 710;
      tPCLPCLStream.value := s;
      tPCLSection.value := 0;
      tPCLSelQstns_id.value := 0;
      tPCL.post;
      next;
    end;
  end;
 // WritePrinter
  with dmOpenQ, wwt_PCL do begin
    first;
    while not eof do begin
      s := ESC + '*p<<X>>x<<Y>>Y' + wwt_PCLPCLStream.value;
      tPCL.append;
      if wwt_PCLX.value < split then begin
        tPCLX.value := (wwt_PCLX.value*4800) div 710;
        tPCLSide.value := 1;
        tPCLQnmbr.value := 'PC1';
      end else begin
        tPCLX.value := ((wwt_PCLX.value-split)*4800) div 710;
        tPCLSide.value := 2;
        tPCLQnmbr.value := 'PC2';
      end;
      tPCLY.value := (wwt_PCLY.value*4800) div 710;
      if wwT_PCLKnownDimensions.value then begin
        tPCLHeight.value := (wwt_PCLHeight.value*4800) div 710;
        tPCLWidth.value := (wwt_PCLWidth.value*4800) div 710;
      end else begin
        tPCLHeight.value := 0;
        tPCLWidth.value := 0;
      end;
      tPCLPCLStream.value := s;
      tPCLSection.value := 0;
      tPCLSelQstns_id.value := 0;
      tPCL.post;
      next;
    end;
  end;
  if mockup<>ptRealSurvey then
    dmopenq.currentSampleUnit_id := 0
  else begin
    dmopenq.LocalQuery('select min(SampleUnit_id) as RootUnit from PopSection',false);
    dmopenq.currentSampleUnit_id := dmOpenQ.ww_Query.fieldbyname('RootUnit').value;
    dmOpenQ.ww_Query.close;
  end;
  with DMOpenQ.wwt_TextBox do begin
    first;
    while not eof do begin
      PCLTextBox(PgType);
      next;
    end;
  end;
  with DMOpenQ, wwt_Qstns do begin
    {Address:}
    if (mockup=ptRealSurvey) and filtered then filtered := false;
    DisableControls;
    if indexfieldnames <> qpc_Section+';Subsection;Item' then
      indexfieldnames := qpc_Section+';Subsection;Item';
    if findkey([-1,1,0]) then begin
      {WriteRTF(wwT_QstnsRichText,dmOpenQ.tempdir+'\richtext.rtf');
      if mockup<>ptRealSurvey then begin
        personalizeRTF;
        LoadRTF(dmOpenQ.tempdir+'\richedit.rtf');
      end else
        LoadRTF(dmOpenQ.tempdir+'\richtext.rtf');
      //GN01}
      if mockup<>ptRealSurvey then
         personalizeRTF(FieldByName('RichText').Value) //GN05
      else
         RichEdit.lines.LoadFromStream(CreateBlobStream(FieldByName('RichText'),bmRead));  //GN05
      PostageStamp := '';
      L := 0;
      s := ESC + '*p<<X>>x<<Y>>Y' + PCLPush + PCLFont('Arial',10,[],1);
      for i := 0 to richedit.lines.count-1 do begin
        if richedit.lines[i] <> '' then begin
          s2 := dmopenq.personalize(richedit.lines[i],'{','}');
          inc(L);
          s := s + PCLPopPush + PCLRelXY(0,LineSpacing*L);
          if copy(s2,1,1)='|' then begin
            s := s + PCLRelXY(0,-LineSpacing) + '** ' + PCLRunMacro(500) + '-' + PCLRunMacro(499) + ' **' + PCLPopPush;
            if AllIn(s2,'|1234567890') then begin
              s := s + PCLRelXY(0,LineSpacing*L) + ESC + '(1X' + s2;
              if length(s2)>11 then
                PostageStamp := pclrunmacro(600)
              else
                PostageStamp := pclrunmacro(601);
              s := s + PCLFont('Arial',10,[],1);
            end;
          end else
            s := s + uppercase(s2);
        end;
      end;
      s := s + PCLPop + PCLPopPush{?} + PostageStamp;
      if (mockup=ptRealSurvey) then begin
        s := dmOpenQ.personalize(s,'{','}');
        if (pos('{',s) + pos('«',s) + pos('¯',s) > 0) then
          raise EOrphanTagError.Create( 'FormGenError 7 (Orphan Tag)');
      end;
      tPCL.append;
      if PgType=2 then begin
        tPCLX.value := PCAddrPosX;
        tPCLY.value := PCAddrPosY;
      end else begin
        tPCLX.value := LgPCAddrPosX;
        tPCLY.value := LgPCAddrPosY;
      end;
      tPCLHeight.value := 0;
      tPCLWidth.value := 0;
      tPCLPCLStream.value := ConvertAsciiCodes(s);
      tPCLQnmbr.value := 'PC1';
      tPCLSection.value := 0;
      tPCLSelQstns_id.value := 0;
      tPCLSide.value := 1;
      tPCL.post;
    end else begin
      dmOpenQ.GenError := 13;
      raise EGenErr.Create('No address information');
    end;
    filtered := true;
    EnableControls;
  end;
end;

procedure tfrmLayoutCalc.FillOutSkips;
var i,SectOrder,ThisUnit,ThisSect,ThisSub,ThisItem,TargetSect,TargetSub,TargetItem : integer;
    s,fnd,TargetQnum,qText:string;
    bool:boolean;
begin
//  if dmOpenQ.SkipGoPhrase = '' then
//  begin
     case dmOpenQ.CurrentLanguage of
       2,7,9,18,19,20 : QText := '# '; //Spanish, VA-Spanish, Harris County Spanish, Magnus GN03, HCAHPS Spanish GN08
       5: Qtext := 'continuar con la pregunta '; //Mexican Spanish
       6: QText := 'à la question '; //French
       8: QText := 'Saltar a la pregunta '; //PEP-C Spanish
       10: QText := 'Passez au n'+#27+'*p-30Yo'+#27+'*p+30Y '; // Quebeqor
       11,12,17: QText := 'Passez à la question n'+#27+'*p-30Yo'+#27+'*p+30Y '; // Francophone
       22 : QText := 'procédez à la question '; //gn19: Montort french
       13: SkipError('Italian skips');
       14: QText := 'vá para a Pergunta '; //Portuguese
       15: QText := 'Mus rau lo lus nug '; // Hmong
       16: QText := 'U gudub '; // Somali
       21: QText := 'Prosze przejsc do '; //gn19: Polish

     else
       if CAHPSNumbering or DoDBenSkips then QText := 'Question '
       else QText := '# ';
     end;
//  end
{  else
  begin
     QText := ''; // dmOpenQ.SkipGoPhrase; //GN19
     while Pos('·',QText) > 0 do
     begin
        QText[Pos('·', QText)] := ' ';

     end;
  end;}

  dmOpenQ.wwt_Qstns.indexFieldNames := 'Survey_ID;SelQstns_ID';
  tPCL.indexfieldnames := 'Section;Subsection;Item';
  for i := 1 to nSkip do begin
    bool := dmOpenQ.wwt_qstns.findkey([dmOpenq.glbSurveyID,skips[i].SelQstns_ID]);
    if bool then begin
      ThisSect := dmOpenQ.wwt_QstnsSection.value;
      thisSub := dmOpenQ.wwt_QstnsSubsection.value;
      thisItem := dmOpenQ.wwt_QstnsItem.value;
      ThisUnit := skips[i].SampleUnit_id;
      if mockup<>ptRealSurvey then
        tPCL.locate('orgSection',thissect,[])
      else begin
        //The following line causes "Fatal Error: C:\DQ\DynaQuest\Development\uLayoutCalc.pas(2467): Internal error: C1376."
        //tPCL.locate('orgSection;SampleUnit_id',varArrayof([ThisSect,ThisUnit]),[]);
        tPCL.first;
        while (not tPCL.eof) and
            ((tPCLorgSection.value <> ThisSect) or
             (tPCL.fieldbyname('SampleUnit_id').value <> ThisUnit)) do
          tPCL.next;
      end;
      SectOrder := tPCLSection.value;
      case skips[i].SkipType of
        skQuestion:
          begin
            TargetSect := SectOrder;
            TargetSub := ThisSub;
            TargetItem := ThisItem + skips[i].skipnum;
          end;
        skSubsection:
          begin
            TargetSect := SectOrder;
            TargetSub := ThisSub+1;
            TargetItem := skips[i].skipnum;
          end;
        skSection:
          begin
            TargetSect := SectOrder+1;
            TargetSub := 1;
            TargetItem := 1;
          end;
        else begin
          TargetSect := -2;
          TargetSub := -2;
          TargetItem := -2;
        end;
      end;
      if TargetItem = 1 then begin
        if tPCL.findkey([TargetSect,TargetSub,0]) then
          begin
             while (not tPCL.eof)  and (tPCLQNmbr.value = '') do
               tPCL.Next;
            TargetQnum := QText+tPCLQNmbr.value;
          end
        else if tPCL.findkey([TargetSect,TargetSub,1]) then
          begin
            while (not tPCL.eof)  and (tPCLQNmbr.value = '') do
              tPCL.Next;
            TargetQnum := QText+tPCLQNmbr.value;
          end
        else if (skips[i].SkipType=skSection) then
        begin
          if true {dmOpenQ.SkipEndPhrase = ''} then
          begin
             case dmOpenQ.CurrentLanguage of
               2,7,8,9,18,19,20: TargetQnum := 'final'; //Spanish, VA Spanish, PEP-C Spanish, Harris County Spanish, Magnus GN03, HCAHPS Spanish GN08
               5: TargetQnum := 'vaya a final'; //Mexican Spanish
               6: TargetQnum := 'au fin'; // French
               10,11,12,17: TargetQnum := 'Aller à la fin'; // Quebeqor, Francophone
               22: TargetQnum := 'procédez à la fin de la questionnaire';//GN19: Montort French
               13: SkipError('Italian skip to end');
               14: TargetQnum := 'vá para o fim';//Portuguese
               15: SkipError('Hmong skip to end');
               16: SkipError('Somali skip to end');
               21: TargetQnum := 'Prosze przejsc do konca'; //gn19 polish
             else
               TargetQnum := 'end';
             end;
          end
          else
          begin
             TargetQnum := '';{dmOpenQ.SkipEndPhrase;} //gn19
          end;
        end
        else
          TargetQnum := '?';
        if pos('Ç',TargetQnum)>0 then begin
          tPCL.Next;
          TargetQnum := QText+tPCLQNmbr.value;
        end;
      end else begin
        if tPCL.findkey([TargetSect,TargetSub,TargetItem]) then
          TargetQnum := QText+tPCLQNmbr.value
        else
          TargetQnum := '??';
      end;
      tPCL.findkey([SectOrder,ThisSub,ThisItem]);
      s := tPCLPCLStream.value;
      while pos('# ',TargetQnum) > 0 do delete(targetQnum,pos('# ',TargetQnum)+1,1);
      fnd := QText+'[S'+inttostr(skips[i].Item)+']';
      insert(TargetQnum,s,pos(fnd,s));
      delete(s,pos(fnd,s),length(fnd));
      tPCL.edit;
      tPCLPCLStream.value := s;
      tPCL.post;
    end;
  end; // for i := 1 to nSkip
  dmOpenQ.wwt_Qstns.indexFieldNames := qpc_Section+';Subsection;Item';
end;

procedure tfrmLayoutCalc.QuestionGen(var VertOff:integer);
type tSect = record
  Section,SampleUnit_id,Order,Rndm : integer;
  end;
var
  Sects : array[0..100] of tSect;
  nSects : integer;
  i,j,ThisSect,ThisSub,dummy,QN : integer;
begin
  with dmOpenQ.ww_Query do begin
    dmopenq.localquery('Select '+qpc_Section+',numMarkCount from Sel_Qstns where subtype=3 and '+qpc_Section+'>=0 and numMarkCount is null',false);
    if recordcount > 0 then begin
      dmopenq.defaultSectionOrder(mockup<>ptRealSurvey);
      dmopenq.SaveSectionOrder;
    end;
    close;
    Databasename := '_PRIV';
    sql.clear;
    if mockup<>ptRealSurvey then
      sql.add('Select '+qpc_Section+',1 as SampleUnit_id,numMarkCount from sel_qstns where Subtype=3 and Type=''Mockup'' order by '+qpc_Section)
    else
      sql.add('Select Section_id, SampleUnit_id,0 as numMarkCount from PopSection where Section_id>=0 order by Section_id, SampleUnit_id');
    open;
    nsects := 0;
    randomize;
    while not eof do begin
      inc(nSects);
      sects[nSects].Section := fieldbyname(qpc_Section).value;
      sects[nSects].SampleUnit_id := fieldbyname('SampleUnit_id').value;
      //sects[nSects].Order := fieldbyname('numMarkCount').value;
      sects[nSects].Order := fieldbyname(qpc_Section).value;
      sects[nSects].Rndm := random(100000);
      next;
    end;
    close;
  end;
  for i := 1 to nSects do
    for j := i to nSects do
      if ((sects[i].order*100000) + sects[i].rndm) > ((sects[j].order*100000) + sects[j].rndm) then begin
        sects[0] := sects[i];
        sects[i] := sects[j];
        sects[j] := sects[0];
  end;
  ThisSect := 1;
  ThisSub := 1;
  QN := 0;
  CalcScaleWidth;
  nSkip := 0;
  SkipErr := false;
  resultColumn := StartResultsColumn;
  with dmOpenQ, wwt_Qstns do begin
    if (mockup=ptRealSurvey) and filtered then filtered := false;
    DisableControls;
    if indexfieldnames <> qpc_Section+';SubSection;Item' then
      indexfieldnames := qpc_Section+';SubSection;Item';
    if mockup=ptRealSurvey then begin
      OnFilterRecord := nil;
      //filter := 'SampleUnit_id='+inttostr(sects[ThisSect].SampleUnit_id);
      dmOpenQ.currentSampleUnit_id := sects[ThisSect].SampleUnit_id;
      //messagedlg(format('Lookin for: %d,%d,%d '+#10+'(sampleunit_id=%d)',[sects[ThisSect].section,ThisSub,0,sects[ThisSect].SampleUnit_id]),mtinformation,[mbok],0);
      //viewdata(tdataset(dmOpenQ.wwt_Qstns));
    end;
    filtered := true;
    CAHPSNumbering := findkey([1,0,0]) and (pos('CAHPS',uppercase(wwt_qstnslabel.value))>0);
    DoDBenSkips := findkey([1,0,0]) and (pos('DoD',wwt_qstnslabel.value)>0);
    while (ThisSect<=nSects) and (findkey([sects[ThisSect].section,ThisSub,0])) do begin
      dummy := 54;
      CalcSubsection(dummy,QN);
      inc(SurveyItems,nDQRichEdit);
      PCLMake(VertOff,ThisSect,sects[ThisSect].section,ThisSub);
      inc(thissub);
      if not findkey([sects[thissect].section,thissub,0]) then begin
        inc(thissect);
        thissub := 1;
        {
        if (ThisSect<=nSects) and (mockup=ptRealSurvey) then begin
          filtered := false;
          filter := 'SampleUnit_id='+inttostr(sects[ThisSect].SampleUnit_id);
          filtered := true;
          //messagedlg(format('Lookin for: %d,%d,%d '+#10+'(sampleunit_id=%d)',[sects[ThisSect].section,ThisSub,0,sects[ThisSect].SampleUnit_id]),mtinformation,[mbok],0);
          //viewdata(tdataset(dmOpenQ.wwt_Qstns));
        end;
        }
        dmOpenQ.currentSampleUnit_id := sects[ThisSect].SampleUnit_id;
      end;
      inc(VertOff,dmOpenQ.ExtraSpace);
    end;
    filtered := false;
    filter := '';
    OnFilterRecord := wwT_QstnsFilterRecord;
  end;
  if nSkip > 0 then FillOutSkips;
  if SkipErr then
    messagedlg('Can only support up to '+inttostr(skipMax)+' skips.  Any skips beyond that have been ignored.',mtWarning,[mbok],0);
  dmOpenq.wwt_Qstns.filtered := true;
  dmOpenQ.wwt_Qstnsenablecontrols;
end;

function tfrmLayoutCalc.PCLMatchcode:string;
begin
  //if multipage or (not integatedcover) then
  result := PCLRunMacro(9003)+'*'+Match+'*'
  {else result := ''};
end;

function tfrmLayoutCalc.PCLRunMacro(const MacID:integer):string;
const digits = '123456789ABCDEFGHIJKLMNOPQRTSUVWXYZ0';
var bc,L,KeyLine: string;

begin
  if mockup<>ptRealSurvey then begin
    bc := dmOpenQ.wwt_Cover.fieldbyname('SelCover_id').asString+vAge[1]+vSex[1]+vDoc[1];
    while length(bc)<6 do bc := '0'+bc;
    L := inttostr(UnBase36(bc));
    KeyLine:=formatfloat('0000 0000 000',strtofloat(L));

    while length(l)<7 do L := '0'+L;

    case MacID of
      497 : result := ESC+'&f497y0X'+KeyLine+ESC+'&f1x2X';
      499 : result := ESC+'&f499y0XA12345'+ESC+'&f1x2X';
      500 : result := ESC+'&f500y0X'+L+ESC+'&f1x2X';
      501..536 : begin
        result := BC+digits[macid-500];
        result := ESC+'&f'+inttostr(macID)+'y0X'+result+checkdigit(result)+ESC+'&f1x2X';
        end;
    else
      result := ESC + '&f'+inttostr(macID)+'y2X';
    end;
  end else
    result := ESC + '&f'+inttostr(macID)+'y2X';
end;

function tfrmLayoutCalc.PCLReplXY(const PCLStream,Xpos,Ypos:string):string;
begin
  result := PCLStream;
  while pos('<<X>>x<<Y>>Y',result) > 0 do begin
    insert(Xpos + 'x' + Ypos + 'Y',result,pos('<<X>>x<<Y>>Y',result));
    delete(result,pos('<<X>>x<<Y>>Y',result),12);
  end;
end;

function tfrmLayoutCalc.PCLReplRelXY(const PCLStream : string; const Xpos,Ypos:integer):string;
var XP,YP:string;
begin
  if XPos<0 then XP := inttostr(Xpos) else XP := '+' + inttostr(Xpos);
  if YPos<0 then YP := inttostr(Ypos) else YP := '+' + inttostr(Ypos);
  result := PCLStream;
  while pos('<<X>>x<<Y>>Y',result) > 0 do begin
    insert(XP + 'x' + YP + 'Y',result,pos('<<X>>x<<Y>>Y',result));
    delete(result,pos('<<X>>x<<Y>>Y',result),12);
  end;
end;

procedure tfrmLayoutCalc.WriteCoverLetter(var xi,xs:textfile);
var s,s2,ini : string;
    b,e:integer;
begin
  write(xi,sheetdef(4));
  write(xs,PCLRunMacro(9003)+'*$M0*');
  ini := esc+'&f100y0X';
  write(xs,esc+'&f100y2X');
  while (not tPCL.eof) and (tPCLSheet.value = 0) do begin
    s := PCLReplXY(tPCLPCLStream.value,tPCLX.asString,tPCLY.asString);
    if pos('$SVY',s)>0 then begin
      while pos('$SVY',s)>0 do begin
        b := pos('$SVY',s);
        e := pos('::',s);
        delete(s,b+6,e-b-4);
        delete(s,b+1,3);
        { ...$SVYxx:......::
                   123456789
          123456789012345678  }
        if pos(copy(s,b+1,2),'BF.BH.BC.BE')>0 then begin {address codes}
          if copy(s,b+1,2)='BF' then
            s2 := pclpush + pclrelxy(0,-100) + '$00' + pclpop + esc + '(1X' + '$||' + PCLFont('Arial',11,[],1)
          else if copy(s,b+1,2)='BH' then
            s2 := '$01'
          else if copy(s,b+1,2)='BC' then
            s2 := '$02'
          else if copy(s,b+1,2)='BE' then
            s2 := '$03'
          else
            s2 := copy(s,b,3);
          delete(s,b,3);
          insert(s2,s,b);
        end;
      end;
      write(xs,s);
    end else
      if (tPCLQnmbr.value='BMP') or (tPCLQnmbr.value='PCL') then
        write(xi,s)
      else
        ini := ini + s;
    tPCL.next;
  end;
  write(xi,ini+esc+'&f1X');
  write(xs,#12);
end;

function tfrmLayoutCalc.GetCoverLetter:string;
begin
  result := SheetDef(4) + PCLMatchCode;
  while (not tPCL.eof) and (tPCLSheet.value = 0) do begin
    result := result + PCLReplXY(tPCLPCLStream.value,tPCLX.asString,tPCLY.asString);
    tPCL.next;
  end;
  result := result + #12;
end;

function tfrmLayoutCalc.StartPage(const vSht, vSide, vPg, vPg2 : integer):string;
var RegPtsMacro : word;
begin
 {» Each of the 9000-series macros (defined in PCLObject table - see SheetDef
    function) should place the registration points and Barcode box(es) on the
    page and pushed three macro positions, one each for:
      (1) barcode value (in Code39)
      (2) barcode value (in OCRB)
      (3) lithocode value (in OCRB)
    these are poped in reverse order.  (For double-legal sheets, there are six
    cursor positions pushed; the first 3 popped will be for the left page and
    the next 3 popped will be for the right page.)
  » The 500-series macros are re-defined by Queue Manager for each q'naire:
    • 499 PostalBundle & GroupDestination (not used here, only above address label)
    • 500 lithocode value
    • 500+N barcode value for page N}
  RegPtsMacro := 9002-(vSide mod 2);
  if DOD then inc(RegPtsMacro,3);
  result :=
    PCLRunMacro(RegPtsMacro)+
    PCLFont('Arial',10,[],1)+
    PCLPop + PCLRunMacro(500)+
    PCLPop + '*' + PCLRunMacro(500+vPg) + '*' +
    ESC+'(2X'+
    PCLPop + '*' + PCLRunMacro(500+vPg) + '*';
  if SheetType=DblLegal then
    result := result +
      ESC+'(16535X'+
      PCLPop + PCLRunMacro(500)+
      PCLPop + '*' + PCLRunMacro(500+vPg2) + '*' +
      ESC+'(2X'+
      PCLPop + '*' + PCLRunMacro(500+vPg2) + '*';
  result := result + PCLMatchCode;
end;

function tfrmLayoutCalc.SheetDef(st:integer):string;
var strST : string;
begin
  case st of
    1 : strST := '''SET_LETTER''';
    2 : strST := '''SET_LEGAL''';
    3 : strST := '''SET_TABLOID''';
    4 : strST := '''SET_COVER''';
    5 : strST := '''SET_DOUBLE_LEGAL''';
    6 : strST := '''SET_POSTCARD''';
  else
    strST := '''SET_LETTER''';
    st := 1;
  end;
  if Set_PCL[st]='' then begin
    if not dmopenq.laptop then
      dmOpenQ.QPQuery('Select PCLStream from PCLObject where PCLObject_dsc='+strST,false)
    else
      dmOpenQ.LibQuery('Select PCLStream from PCLObject where PCLObject_dsc='+strST,false);
    result := dmOpenQ.ww_Query.fieldbyname('PCLStream').value;
    dmOpenQ.ww_Query.Close;
    Set_PCL[st] := result;
  end else
    result := Set_PCL[st];
end;

procedure tfrmLayoutCalc.WriteNextSheet(var Xi,Xs : textfile);
var ThisSheet,ThisSide,PageA,PageB,PageC,PageD,b,e,LastBMP:integer;
    s,sq,s2,ini:string;
  procedure startSVYpage(vside,vpg1,vpg2:integer);
  begin
    write(xs,
      PCLRunMacro(9002-(vSide mod 2))+
      PCLFont('Arial',11,[],1) +
      PCLPop + ESC + '*p+450X$L0'+
      PCLPop + ESC + '*p+300X*$B' + inttostr(vPg1) + '*  ' +
      ESC+'(1Xf'+
      ESC+'(2X'+
      PCLPop + '*$B' + inttostr(vPg1) + '*');
    if SheetType=DblLegal then
      write(xs,
        PCLFont('Arial',11,[],1) +
        PCLPop + ESC + '*p+450X$L0'+
        PCLPop + ESC + '*p+300X*$B' + inttostr(vPg2) + '*  ' +
        ESC+'(1Xf'+
        ESC+'(2X'+
        PCLPop + '*$B' + inttostr(vPg2) + '*');
    write(xs,PCLRunMacro(9003)+'*$M0*');
  end;
begin
  ThisSheet := tPCLSheet.value;
  ThisSide := tPCLSide.value;
  PageA := tPCLPageNum.value;
  PageB := succ(PageA);
  if {(SheetType=Tabloid) or} (SheetType=DblLegal) then begin
    PageC := 1 + SurveyPages - PageB;
    PageD := 1 + SurveyPages - PageA;
  end else begin
    PageC := 0;
    PageD := 0;
  end;
  write(xi,SheetDef(SheetTypeVal));
  write(xs,esc+'&f'+inttostr(100+thisside)+'y2X');
  StartSVYPage(ThisSide,PageA,PageD);
  ini := esc+'&f'+inttostr(100+thisside)+'y0X';
  LastBMP := 0;
  with tPCL do begin
    while (not eof) and (ThisSheet = tPCLSheet.value) do begin
      if tPCLSide.value <> ThisSide then begin
        ThisSide := tPCLSide.value;
        ini := ini + esc+'&f1X'+esc+'&f'+inttostr(100+ThisSide)+'y0X';
        write(xs,ESC + '&a0G'+esc+'&f'+inttostr(100+ThisSide)+'y2X');
        StartSVYPage(ThisSide, tPCLPageNum.value, PageC);
      end;
      s := PCLReplXY(tPCLPCLStream.value,tPCLX.asString,tPCLY.asString);
      if pos('$SVY',s) > 0 then begin
        if pos(esc+'(1X',s)>0 then begin
          b := pos(esc+'(1X',s);
          e := length(s);
          sq := copy(s,1,b-1) + esc + '&f1S';
          s := copy(s,1,pos('Y',s)) + esc + '&f0S' + copy(s,b,e);
        end else
          sq := '';
        if pos('$SVY',sq)>0 then begin
          while pos('$SVY',sq)>0 do begin
            b := pos('$SVY',sq);
            e := pos('::',sq);
            mydelete(sq,b+6,e-b-4);
            mydelete(sq,b+1,3);
          end;
          write(xs,sq);
        end else
          ini := ini + sq;
        if pos('$SVY',s)>0 then begin
          while pos('$SVY',s)>0 do begin
            b := pos('$SVY',s);
            e := pos('::',s);
            mydelete(s,b+6,e-b-4);
            mydelete(s,b+1,3);
            if pos(copy(s,b+1,2),'BF.BH.BC.BE')>0 then begin {address codes}
              if copy(s,b+1,2)='BF' then
                s2 := pclpush + pclrelxy(0,-100) + '$00' + pclpop + esc + '(1X' + '$||' + PCLFont('Arial',11,[],1)
              else if copy(s,b+1,2)='BH' then
                s2 := '$01'
              else if copy(s,b+1,2)='BC' then
                s2 := '$02'
              else if copy(s,b+1,2)='BE' then
                s2 := '$03'
              else
                s2 := copy(s,b,3);
              mydelete(s,b,3);
              myinsert(s2,s,b);
            end;
          end;
          write(xs,s);
        end else
          ini := ini + s;
        LastBMP := 0;
      end else begin
        if (tPCLQnmbr.asstring='BMP') or (tPCLQnmbr.asstring='PCL') then begin
          write(xi,s);
          LastBMP := tPCLItem.value;
        end else begin
          if (LastBMP>0) and (pos(#27+'&f'+inttostr(LastBMP)+'y2X',s)>0) then begin
            write(xs,s);
          end else
            ini := ini + s;
          LastBMP := 0;
        end;
      end;
      next;
    end;
    write(xi,ini+esc+'&f1X');
    if not eof then write(xs,#12);
  end;
end;

function tfrmLayoutCalc.GetNextSheet(var PageA,PageB,PageC,PageD:integer):string;
var ThisSheet,ThisSide,GutterLineTop,GutterLineBottom:integer;
    QstnsOnThisSide : boolean;
begin
  ThisSheet := tPCLSheet.value;
  ThisSide := tPCLSide.value;
  QstnsOnThisSide := false;
  PageA := tPCLPageNum.value;
  PageB := succ(PageA);
  if {(SheetType=Tabloid) or} (SheetType=DblLegal) then begin
    PageC := 1 + SurveyPages - PageB;
    PageD := 1 + SurveyPages - PageA;
  end else begin
    PageC := 0;
    PageD := 0;
  end;
  if (SheetType=DblLegal) or (SheetType=Legal) then GutterLineBottom := 7816
  else GutterLineBottom := 6016;
  GutterLineTop := 0;
  result := SheetDef(SheetTypeVal) + StartPage(ThisSheet, ThisSide, PageA, PageD);
  with tPCL do begin
    while (not eof) and (ThisSheet = tPCLSheet.value) do begin
      if ((tPCLPageNum.value=1) or (PageA>1)) and (pos(tPCLQNmbr.value,'Adr,Brk,Cvr,BMP,PCL')=0) and (GutterLineTop = 0) then
        GutterLineTop := tPCLY.value - LineSpacing;
      if tPCLSide.value <> ThisSide then begin
        if (ColumnCnt=2) and QstnsOnThisSide then begin
          result := result + pclunderlineoff;
          if sheettype in [Tabloid,DblLegal] then begin
            result := result +format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,PageWidth*0.5,TopMargin,GutterLineBottom-TopMargin]);
            if PageA>1 then
              result := result +format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,5100+PageWidth*0.5,TopMargin,GutterLineBottom-TopMargin])
            else if GutterLineTop > 0 then
              result := result +format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,5100+(PageWidth * 0.5),GutterLineTop,GutterLineBottom-GutterLineTop])
          end else
            result := result +format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,PageWidth * 0.5,GutterLineTop,GutterLineBottom-GutterLineTop]);
          GutterLineTop := TopMargin;
        end;
        result := result + Esc + '&a0G' +
            StartPage(ThisSheet, tPCLSide.value, tPCLPageNum.value, PageC);
        ThisSide := tPCLSide.value;
        QstnsOnThisSide := false;
      end;
      result := result + PCLReplXY(tPCLPCLStream.value,tPCLX.asString,tPCLY.asString);
      if pos(tPCLQNmbr.value,'Adr,Brk,Cvr,BMP,PCL')=0 then
        QstnsOnThisSide := true;
      next;
    end;
  end;
  if ColumnCnt=2 then begin
    result := result + pclunderlineoff;
    if sheettype in [Tabloid,DblLegal] then
      result := result +format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,PageWidth * 0.5,TopMargin,GutterLineBottom-TopMargin]) +
                        format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,5100+PageWidth * 0.5,GutterLineTop,GutterLineBottom-GutterLineTop])
    else
      result := result +format('%0:s*p%1:gx%2:dY%0:s*c2A%0:s*c%3:dB%0:s*c0P', [#27,PageWidth * 0.5,GutterLineTop,GutterLineBottom-GutterLineTop]);
  end;
  result := result + #12;
end;

function tfrmLayoutCalc.GetPostcardSide:string;
var ThisSide:integer;
begin
  ThisSide := tPCLSide.value;
  result := PCLPush;
  // result := result + SheetDef(6);
  with tPCL do begin
    while (not eof) and (ThisSide = tPCLSide.value) do begin
      result := result + PCLPopPush + PCLReplRelXY(tPCLPCLStream.value,tPCLX.value,tPCLY.value);
      next;
    end;
  end;
  result := result + PCLPop;
end;

procedure tfrmLayoutCalc.MakeMockupFile(const init,fn:string);
var x,x_cvr :textfile;
    PageType,Dummy1,d2,d3,d4 : integer;
    ok : boolean;
    fn_cvr : string;
  procedure writePostcard(const left,width:integer);
  begin
    write(x,sheetdef(1));
    //write(x,ESC+'&l0O');
    write(x,PCLBox(clWhite,1,left,600,width,2550));
    write(x,PCLAbsXY(left+150,600+150));
    write(x,GetPostcardSide);
    write(x,PCLBox(clWhite,1,left,3450,width,2550));
    write(x,PCLAbsXY(left+150,3450+150));
    write(x,GetPostcardSide);
  end;
begin
  PageType := dmOpenQ.wwt_Cover.fieldbyname('PageType').value;
  OK := true;
  fn_cvr := extractfilename(fn);
  if extractfileext(fn_cvr)='' then fn_cvr := fn_cvr + '.prn';
  insert('_cover',fn_cvr,pos(extractfileext(fn_cvr),fn_cvr));
  fn_cvr := extractfilepath(fn)+fn_cvr;
  if init <> '' then begin
    dmOpenQ.t_PCLObject.open;
    if dmOpenQ.t_PCLObject.locate('PCLObject_dsc',init,[loCaseInsensitive]) then begin
      dmOpenQ.t_PCLObjectPCLStream.Savetofile(fn);
      assignfile(x,fn);
      append(x);
      if not IntegratedCover then begin
        dmOpenQ.t_PCLObjectPCLStream.Savetofile(fn_cvr);
        assignfile(x_cvr,fn_cvr);
        append(x_cvr);
      end;
    end else begin
      OK := false;
      messagedlg('Cannot find printer initialization sequence in dbo.PCLObject',mterror,[mbok],0);
    end;
    dmOpenQ.t_PCLObject.close;
  end else begin
    assignfile(x,fn);
    rewrite(x);
    if not IntegratedCover then begin
      assignfile(x_cvr,fn_cvr);
      rewrite(x_cvr);
    end;
  end;
  if OK then begin
    tPCL.indexfieldnames := 'Sheet;Side;Pagenum';
    tPCL.first;
    case PageType of
      1: begin
           if not IntegratedCover then
             write(x_cvr,GetCoverLetter);
           while not tPCL.eof do
             write(x,GetNextSheet(Dummy1,d2,d3,d4));
         end;
      2: WritePostcard(750,3300);
      else
         WritePostcard(300,4200);
    end;
    write(x,PCLReset);
    closefile(x);
    if not integratedcover then begin
      write(x_cvr,PCLReset);
      closefile(x_cvr);
    end;
  end;
end;

function tfrmLayoutCalc.SurveyGen(sp_id:string):string;
var PageType : integer;
    CoverHeight,VerticalOffset : longint;
    t:TDateTime;
  {
  procedure setMatch;
  var x : integer;
  const matchcodes = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0';
  begin
    x := strtointdef(sp_id,0) mod 36;
    match := matchcodes[x+1];
  end;
   }
  procedure setMatch;
  var x1,x2 : integer;
  const matchcodes = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0';
  begin
    x2 := strtointdef(sp_id,0) mod 36;
    x1 := ((strtointdef(sp_id,0)-x2) div 36) mod 36;
    match := matchcodes[x1+1]+matchcodes[x2+1];
  end;




begin
  dmOpenQ.ErrorList.clear;
  dmOpenQ.ErrorList.sorted := true;
  t := time;
  setMatch;
  UsedFont[16535] := true;
  for PageType := 16536 to 16554 do
    UsedFont[PageType] := false;
  //VerticalOffset := 100;
  dmopenq.cn.execute('delete from pclresults');
//  dmopenq.localquery('delete from bblloc',true);
//  dmopenq.localquery('delete from cmntloc',true);
  PageType := dmOpenQ.wwt_Cover.fieldbyname('PageType').value;
  SurveyItems := 0;
  if PageType = 1 then begin
    CoverLetterGen(CoverHeight,AfterPageBreakCoverHeight);
    VerticalOffset := CoverHeight + AfterPageBreakCoverHeight;
    if IncludeQstns then
      QuestionGen(VerticalOffset);
    PaperChoice(CoverHeight,VerticalOffset);
  end else begin
    PostCardGen(PageType);
  end;
  dmOpenQ.wwt_Qstns.filtered := true;
  dmOpenQ.wwt_QstnsEnableControls;
  t := time - t;
  result := floattostr(t*24*60*60);
  if mockup<>ptRealSurvey then
    MakeMockupFile('INITIALIZATION',dmOpenQ.tempdir+'\QPMockup.prn');
end;

function tfrmLayoutCalc.ScaleWidth(const sID:integer; bolPersonalized : boolean):tSW;

var x : integer;
begin
  x := 1;
  while (x<99) and (sw[x].id<>sID) do inc(x);
  if (sw[x].id<>sID) then begin
    if bolPersonalized then
      result := CalcOneWidth(sID)
    else begin
      result.id := sid;
      result.width := -1;
      result.lblwidth := -1;
    end;
  end else
    result := sw[x];
end;

function tfrmLayoutCalc.CalcOneWidth(const sID:integer):tSW;
var CW : array[1..MaxNumScales] of integer;
    lbl : array[1..MaxNumResps] of string;
    st:string;
    j,dummy,i,k,nLbl,missings,colWidth : integer;
    SplitWord,noSplitWords:boolean;
    orgname : string;
    orgsize : integer;
begin
  orgname := printer.canvas.font.name;
  orgsize := printer.canvas.font.size;
  printer.canvas.font.name := dmOpenQ.SclFont;
  printer.canvas.font.size := dmOpenQ.SclPoint;
  with dmOpenQ, wwt_scls do begin
    indexFieldName := qpc_ID;
    if findkey([Sid]) then begin
      result.id := wwt_sclsID.value;
      nlbl := 0;
      missings := 0;
      while (not eof) and (result.id = wwt_sclsID.value) do begin
        inc(nlbl);
        //WriteRTF(wwt_SclsRichText,tempdir+'\richtext.rtf'); GN01
        //LoadRTF(tempdir+'\richtext.rtf'); GN01
        richedit.lines.LoadFromStream(CreateBlobStream(FieldByName('RichText'),bmRead)); //Gn02
        lbl[nlbl] := richedit.lines[0];
        lbl[nlbl] := dmOpenq.personalize(lbl[nlbl],'{','}');
        lbl[nlbl] := qualprofunctions(lbl[nlbl],'{',6);
        if wwt_SclsMissing.asBoolean then
          missings:=1;
        next;
      end;

      colWidth := 225;
      repeat begin
        noSplitWords := true;
        for i := 1 to nlbl do begin
          st := splittext(lbl[i],dummy,colwidth-27,SplitWord,true);
          if SplitWord then NoSplitwords := false;
          cw[i] := BubbleWidth;
          for J := 1 to dummy do begin
            k := printer.canvas.textWidth(SplitedTextLine(st,J));
            if cw[i] < k then
              cw[i] := k;
          end;
        end;
        inc(colWidth,25);
      end until NoSplitWords or (3800<(nlbl*colwidth) + (missings*(colwidth div 2)));
      result.lblwidth := colwidth;
      result.width := (nlbl*colwidth) + (missings*(colwidth div 2));
    end else begin // not findkey([Sid])
      if mockup<>ptRealSurvey then begin
        result.id := sID;
        result.lblwidth := 200;
        result.width := 1000;
      end else begin
        GenError := 31;
        raise EGenErr.Create('Missing Scale');
      end;
    end;
  end;
  printer.canvas.font.name := orgname;
  printer.canvas.font.size := orgsize;
end;


//Gn01: method depreciated
procedure tfrmLayoutCalc.WriteRTF(var BlobField:tBlobField; filename:string);
var
   cnt : integer;
   dStream: TFileStream;
   BlobStream : TBlobStream;

begin
  cnt := 0;
  repeat
    try

      BlobField.savetofile(filename);

      cnt := 11;
    except
      pause(1);
      inc(cnt);
      if cnt>10 then raise;
    end;
  until cnt > 10;
end;

//Gn01: method depreciated
procedure tfrmLayoutCalc.LoadRTF(filename:string);
var
   cnt : integer;
   sStream   : TFileStream;
Begin
  //Gn02: this fixes the EFileOpenError trying to read the RTF file
  Application.ProcessMessages;
  if FileExists(filename) then
  sStream := TFileStream.Create( filename, fmOpenRead or fmShareDenyWrite);  //fmShareExclusive
  try
      //RichEdit.MaxLength := System.MaxInt-2;
      //RichEdit.Lines.BeginUpdate;
      RichEdit.Lines.LoadFromStream(sStream);
      //RichEdit.Lines.EndUpdate;
      //RichEdit.Refresh;
      //except
      // on EFOpenError do

  finally
    sStream.Free;
  end

  {
  cnt := 0;
  repeat
    try
      richedit.lines.loadfromfile(filename);
      cnt := 11;
    except
      pause(1);
      inc(cnt);
      if cnt>10 then raise;
    end;
  until cnt > 10;
  }
end;

procedure tfrmLayoutCalc.CalcScaleWidth;
var CW : array[1..MaxNumScales] of integer;
    lbl : array[1..MaxNumResps] of string;
    st:string;
    i,j,k,dummy,nLbl,nScale,missings,colWidth : integer;
    noSplitWords,SplitWord:boolean;
    orgFilt,skipScale : boolean;
begin
  with dmOpenQ do begin
    printer.canvas.font.name := SclFont;
    printer.canvas.font.size := SclPoint;
    nScale :=0;
    with wwt_Scls do begin
      first;
      while not eof do begin
        inc(nScale);
        SW[nScale].id := wwt_sclsID.value;
        skipScale := false;
        nlbl := 0;
        missings := 0;
        while (not eof) and (SW[nScale].id = wwt_sclsID.value) and (not skipscale) do begin
          inc(nlbl);
          //WriteRTF(wwt_SclsRichText,tempdir+'\richtext.rtf'); GN01
          //LoadRTF(tempdir+'\richtext.rtf');                   GN01
          RichEdit.lines.LoadFromStream(CreateBlobStream(FieldByName('RichText'),bmRead));   //Gn02
          lbl[nlbl] := richedit.lines[0];
          //if mockup<>ptRealSurvey then
          if pos('{',lbl[nlbl])>0 then
            skipscale := true //if a scale has personalization in it, we can't pre-determine it's width
          else begin
            lbl[nlbl] := dmOpenq.personalize(lbl[nlbl],'{','}');
            lbl[nlbl] := qualprofunctions(lbl[nlbl],'{',6);
            if wwt_SclsMissing.asBoolean then
              missings:=1;
          end;
          next;
        end;
        if skipscale then begin
          while (not eof) and (SW[nScale].id = wwt_sclsID.value) do next;
          sw[nscale].id := -1;
          dec(nScale);
        end else begin
          colWidth := 225;
          repeat begin
            noSplitWords := true;
            for i := 1 to nlbl do begin
              st := splittext(lbl[i],dummy,colwidth-27,SplitWord,true);
              if SplitWord then NoSplitwords := false;
              cw[i] := BubbleWidth;
              for J := 1 to dummy do begin
                k := printer.canvas.textWidth(SplitedTextLine(st,J));
                if cw[i] < k then
                  cw[i] := k;
              end;
            end;
            inc(colWidth,25);
          end until NoSplitWords or (3800<(nlbl*colwidth) + (missings*(colwidth div 2)));
          sw[nScale].lblwidth := colwidth;
          sw[nScale].width := (nlbl*colwidth) + (missings*(colwidth div 2));
        end;
      end;
    end;
    with wwt_Qstns do begin
      disablecontrols;
      orgfilt := filtered;
      if orgfilt and (mockup=ptRealSurvey) then filtered := false;
      first;
      while not eof do begin
        if (wwt_QstnsSubtype.value=stItem) and (wwt_QstnsScalePos.value=spRight) then begin
          edit;
          wwt_QstnsWidth.value := ((PageWidth-(ColumnGutter*(ColumnCnt-1))) div ColumnCnt) - 50 - ScaleWidth(wwt_QstnsScaleID.value,false).width;
          post;
        end;
        next;
      end;
      if orgfilt then filtered := true;
      dmOpenQ.wwt_QstnsEnableControls;
    end;
  end;
end;

function tfrmLayoutCalc.CalcSubsection(var TrackBarPos:integer; var QstnNmbr:integer):string;
var curSect,curSub,curQ,curScale,curScalePos:integer;
    Shading,orgPrintingState : boolean;
    t:TDateTime;
    QstnChar : char;
xxx : string;
begin
  ClearArrays;
  NextQTop := 0;
  with dmOpenQ, wwt_qstns do begin
    t := time;
    curSect := fieldbyname(qpc_Section).value;
    curSub := fieldbyname('Subsection').value;
    curQ := fieldbyname('Item').value;
    indexFieldName := qpc_Section+';SubSection;Item';
    if findkey([curSect,curSub,0]) then begin
      needQstnChar := (wwt_QstnsQstnCore.value>0);
      xxx := wwT_QstnsLabel.asstring;
      TreatQuestionLikeHeader := (pos('va non-header',lowercase(xxx))>0);
      if needQstnChar then QstnChar := 'a'
      else QstnChar := ' ';
      if TreatQuestionLikeHeader then dec(QstnChar);
      Shading := false;
      NeedLabels := true;
      orgPrintingState := printer.printing;
      if not orgPrintingState then StartCalc;
      while (not eof) and (fieldbyname(qpc_Section).value=curSect) and (fieldbyname('Subsection').value=curSub) do begin
        if not fieldbyname('RichText').isnull then begin
          if dmOpenq.ShadingOn then Shading := not Shading;
          ShowQ(shading,TrackBarPos,QstnNmbr,QstnChar);
        end;
        curScalePos := wwt_QstnsScalePos.value;
        curScale := wwt_QstnsScaleID.value;
        next;
        needLabels := (curScalePos<>wwt_QstnsScalePos.value) or
                      (curScale<>wwt_QstnsScaleID.value);
      end;
      if not orgPrintingState then EndCalc;
    end;
    findkey([curSect,curSub,curQ]);
    t := time - t;
    result := floattostr(t*24*60*60);
  end;
end;

procedure TfrmLayoutCalc.RichEditProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  Allowchange := true;
end;

procedure TfrmLayoutCalc.ClearArrays;
var i : integer;
begin
  nDQPanel := 0;
  nDQRichEdit := 0;
  nDQLabel := 0;
  nDQShape := 0;
  for i := 0 to 50 do
    with rDQRichEdit[i] do begin
      top := 0; left := 0; width := 0; height := 0;
      tag := 0; QstnCore := 0; ScaleID := 0; ScalePos := 0;
      QNmbr := 0; QChar := ' ';
      plaintext := '';
      richtext := '';
      fontname := '';
      subtype := 0;
    end;
  for i := 0 to 50 do
    with rDQPanel[i] do begin
      top := 0; left := 0; width := 0; height := 0;
      fontname := '';
      Question := 0;
    end;
  for i := 0 to 250 do
    with rDQLabel[i] do begin
      top := 0; left := 0;
      caption := '';
      item := 0;
      Panel := 0;
    end;
  for i := 0 to 350 do
    with rDQShape[i] do begin
      top := 0; left := 0;
      Panel := 0; Value := -32768;
    end;
end;

function TfrmLayoutCalc.StartCalc : boolean;
const TestString : array[1..14] of string =
  ('Thank you for allowing us to provide your health care needs during your visit on September 23, 1998 to',
   'Please use the enclosed envelope',
   'and mail the completed survey to:',
   'ABC MEDICAL CLINIC',
   'Survey Processing Center',
   '1033 O Street, Suite 401',
   'Lincoln, NE  68508',
   '1-800-733-6714',
   'Poor',
   'Fair',
   'Good',
   'Very',
   'Very Good',
   'Excellent');
   ArialLength : array[1..14] of integer =
     (3778, 1262, 1239, 856, 965, 911, 699, 590, 175, 143, 203, 171, 397, 336);
   NarrowLength : array[1..14] of integer =
     (3113, 1039, 1021, 702, 792, 751, 576, 487, 144, 118, 167, 140, 326, 276);
var i : integer;
    Adjust : real;
begin
  i := 0;
  with printer do begin
    while (i<printers.count-1) and (copy(printers[i],1,13)<>'DQCalcPrinter') do
      inc(i);
    result := copy(printers[i],1,13)='DQCalcPrinter';
    if result then begin
      printerindex := i;
      begindoc;
      printer.canvas.font.name := 'Arial';
      printer.canvas.font.size := 10;
      printer.canvas.font.style := [];
      Adjust := 0.0;
      for i := 1 to 14 do
        Adjust := Adjust + (ArialLength[i]/printer.canvas.textWidth(teststring[i]));
      PrinterAdjustmentArial := Adjust / 14;
      printer.canvas.font.name := 'Arial Narrow';
      printer.canvas.font.size := 10;
      printer.canvas.font.style := [];
      Adjust := 0.0;
      for i := 1 to 14 do
        Adjust := Adjust + (NarrowLength[i]/printer.canvas.textWidth(teststring[i]));
      PrinterAdjustmentArialNarrow := Adjust / 14;
    end;
  end;
end;

procedure TfrmLayoutCalc.EndCalc;
begin
  printer.enddoc;
end;

procedure TfrmLayoutCalc.FormCreate(Sender: TObject);
var dvc,drv,port:array[0..79] of char;
    h:thandle;
    i : integer;
const
  defAddrPosX = 534;     defPCAddrPosX = 938;
  defAddrPosY = 1210;    defPCAddrPosY = 1412;
begin
  try
    createok := false;
    DOD := false;
    with tPCL do begin
      TableType := ttParadox;
      with FieldDefs do begin
        Clear;
        add('ID',ftAutoInc,0,false);
        add('Section',ftInteger,0,false);
        add('Subsection',ftInteger,0,false);
        add('Item',ftInteger,0,false);
        add('QstnCore',ftInteger,0,false);
        add('X',ftInteger,0,false);
        add('Y',ftInteger,0,false);
        add('Height',ftInteger,0,false);
        add('Width',ftInteger,0,false);
        add('QNmbr',ftString,4,false);
        add('PCLStream',ftBlob,100,false);
        add('Pagenum',ftInteger,0,false);
        add('Side',ftInteger,0,false);
        add('Sheet',ftInteger,0,false);
        add('SelQstns_id',ftInteger,0,false);
        add('BegColumn',ftInteger,0,false);
        add('ReadMethod',ftInteger,0,false);
        add('Yadj',ftInteger,0,false);
        add('intRespCol',ftInteger,0,false);
        add('orgSection',ftInteger,0,false);
        add('SampleUnit_id',ftInteger,0,false);
      end;
      with IndexDefs do begin
        Clear;
        Add('ByID', 'ID', [ixPrimary]);
        Add('BySection', 'Section;Subsection;Item;QstnCore', []);
        add('BySheet', 'Sheet;Side;Pagenum', []);
        add('ByPage', 'Pagenum;Y', []);
        //Add('BySelQstns', 'SelQstns_id', []);
      end;
      createtable;
      open;
    end;
    with tBubbleLoc do begin
      TableType := ttParadox;
      with FieldDefs do begin
        Clear;
        add('Questionform_id',ftInteger,0,false);
        add('SelQstns_ID',ftInteger,0,false);
        add('Item',ftInteger,0,false);
        add('SampleUnit_id',ftinteger,0,false);
        add('Charset',ftInteger,0,false);
        add('Val',ftInteger,0,false);
        add('IntRespType',ftInteger,0,false);
        add('RelX',ftInteger,0,false);
        add('RelY',ftInteger,0,false);
      end;
      with IndexDefs do begin
        Clear;
        Add('ByID', 'Questionform_id;SelQstns_ID;Item;SampleUnit_id', [ixPrimary]);
      end;
      createtable;
      open;
    end;
    with tCmntLoc do begin
      TableType := ttParadox;
      with FieldDefs do begin
        Clear;
        add('Questionform_id',ftInteger,0,false);
        add('SelQstns_ID',ftInteger,0,false);
        add('Line',ftInteger,0,false);
        add('SampleUnit_id',ftInteger,0,false);
        add('RelX',ftInteger,0,false);
        add('RelY',ftInteger,0,false);
        add('Width',ftInteger,0,false);
        add('Height',ftInteger,0,false);
      end;
      with IndexDefs do begin
        Clear;
        Add('ByID', 'Questionform_id;SelQstns_ID;Line;SampleUnit_id', [ixPrimary]);
      end;
      createtable;
      open;
    end;
    IncludeQstns := true;
    Match := 'AA'; // Match := 'A';
    mockup := 0;
    PageWidth := 4800;

    ColumnCnt := 1;

    ColumnGutter := 150;
    printer.getprinter(dvc,drv,port,h);
    curDevice := dvc;
    curPort := port;
    if (uppercase(copy(dvc,1,7)) = '\\NRC2\') or (uppercase(copy(dvc,1,10)) = '\\NEPTUNE\') or (uppercase(copy(dvc,1,9)) = '\\NRCC02\') then
      curPort := dvc;
    PrinterAdjustmentArial := 1.0;
    PrinterAdjustmentArialNarrow := 1.0;
    for i := 1 to 6 do
      Set_PCL[i] := '';
    if not dmOpenQ.laptop then begin
      dmOpenQ.QPQuery('Select strParam_nm, numParam_Value from QualPro_Params'+
          ' where strParam_grp=''AddressPos'' order by strParam_nm',false);
      if dmOpenQ.ww_Query.fieldbyname('strParam_nm').value = 'AddressPosX' then //GN18
        AddrPosX := dmOpenQ.ww_Query.fieldbyname('numParam_Value').value
      else
        AddrPosX := defAddrPosX;
      dmOpenQ.ww_Query.next;
      if dmOpenQ.ww_Query.fieldbyname('strParam_nm').value = 'AddressPosY' then //GN18 
        AddrPosY := dmOpenQ.ww_Query.fieldbyname('numParam_value').value
      else
        AddrPosY := defAddrPosY;
      dmOpenQ.QPQuery('Select strParam_nm, numParam_Value from QualPro_Params'+
          ' where strParam_grp=''PostcardAddressPos'' order by strParam_nm',false);
      if dmOpenQ.ww_Query.fieldbyname('strParam_nm').value = 'AddressX' then
        PCAddrPosX := dmOpenQ.ww_Query.fieldbyname('numParam_Value').value
      else
        PCAddrPosX := defPCAddrPosX;
      dmOpenQ.ww_Query.next;
      if dmOpenQ.ww_Query.fieldbyname('strParam_nm').value = 'AddressY' then
        PCAddrPosY := dmOpenQ.ww_Query.fieldbyname('numParam_value').value
      else
        PCAddrPosY := defPCAddrPosY;
      dmOpenQ.QPQuery('Select strParam_nm, numParam_Value from QualPro_Params'+
          ' where strParam_grp=''LgPostcardAddressPos'' order by strParam_nm',false);
      if dmOpenQ.ww_Query.fieldbyname('strParam_nm').value = 'AddressX' then
        LgPCAddrPosX := dmOpenQ.ww_Query.fieldbyname('numParam_Value').value
      else
        LgPCAddrPosX := defPCAddrPosX + 900;
      dmOpenQ.ww_Query.next;
      if dmOpenQ.ww_Query.fieldbyname('strParam_nm').value = 'AddressY' then
        LgPCAddrPosY := dmOpenQ.ww_Query.fieldbyname('numParam_value').value
      else
        LgPCaddrPosY := defPCAddrPosY;
      dmOpenQ.ww_Query.close;
    end else begin
      AddrPosX := defAddrPosX;
      AddrPosY := defAddrPosY;
      PCAddrPosX := defPCAddrPosX;
      PCAddrPosY := defPCAddrPosY;
      LgPCAddrPosX := defPCAddrPosX+900;
      LgPCAddrPosY := defPCAddrPosY;
    end;
    createok := true;
  except
    createok := false;
  end;
end;

procedure TfrmLayoutCalc.FormDestroy(Sender: TObject);
begin
  tPCL.close;
  tBubbleLoc.close;
  tCmntLoc.close;

  DelDotStar(dmopenq.tempdir+'\PCLResults.*');
  DelDotStar(dmopenq.tempdir+'\BblLoc.*');
  DelDotStar(dmopenq.tempdir+'\CmntLoc.*');
  Deletefile(dmOpenq.tempdir+'\QPMockup.prn');
{}
end;

procedure TfrmLayoutCalc.SetFonts;
var orgfiltered : boolean;
    orgindex : string;
begin
  with dmOpenq do begin
    orgfiltered := wwt_Qstns.filtered;
    orgindex := wwt_Qstns.indexfieldnames;
    if orgfiltered and (mockup=ptRealSurvey) then wwt_Qstns.filtered := false;
    //wwt_Qstns.indexfieldnames := '';
    wwt_Qstns.indexfieldnames := 'Section_ID;Subsection;Item';
    wwt_Qstns.first;
    //WriteRTF(wwt_QstnsRichText,tempdir+'\richtext.rtf');   //GN01
    RichEdit.lines.LoadFromStream(dmOpenq.wwt_Qstns.CreateBlobStream(dmOpenq.wwt_Qstns.FieldByName('RichText'),bmRead)); //Gn02
    wwt_Qstns.indexfieldnames := orgindex;
    if orgfiltered then wwt_Qstns.filtered := true;
  end;
  with RichEdit do begin
    //lines.LoadFromFile(dmOpenQ.tempdir+'\richtext.rtf');   // GN01


    SelStart := 0;
    SelLength := 1;
    dmOpenQ.QstnFont := SelAttributes.name;
    dmOpenQ.QstnPoint := SelAttributes.size;
    SelStart := 1;
    SelLength := 1;
    dmOpenQ.SclFont := SelAttributes.name;
    dmOpenQ.SclPoint := SelAttributes.size;
    SelStart := 2;
    SelLength := 1;
    dmOpenQ.ConsiderDblLegal := (SelText='Y');
    SelStart := 3;
    SelLength := 1;
    dmOpenQ.ResponseShape := strtointdef(seltext,1);
    SelStart := 4;
    SelLength := 1;
    dmOpenQ.ShadingOn := not (SelText='F');
    SelStart := 5;
    SelLength := 1;
    dmOpenQ.twocolumns := (SelText='T');
    SelStart := 6;
    SelLength := 1;
    dmOpenQ.SpreadToFillPages := ((SelText='T') or (SelText=''));
    SelStart := 7;
    SelLength := 5;
    dmOpenQ.ExtraSpace := strtointdef(seltext,0);
    SelStart := 0;
    SelLength := 0;

    if dmopenq.TwoColumns then
      ColumnCnt := 2
    else ColumnCnt := 1;

  end;
  if (dmOpenQ.QstnFont <> 'Arial Narrow') and (dmOpenQ.QstnFont <> 'Arial') then
    dmOpenQ.QstnFont := 'Arial';
  if (dmOpenQ.SclFont <> 'Arial Narrow') and (dmOpenQ.SclFont <> 'Arial') then
    dmOpenQ.SclFont := 'Arial Narrow';
  if (dmOpenQ.QstnPoint<9) or (dmOpenQ.QstnPoint>12) then
    dmOpenQ.QstnPoint := 11;
  if (dmOpenQ.SclPoint<9) or (dmOpenQ.SclPoint>12) then
    dmOpenQ.SclPoint := 10;
end;


//GN04
function TfrmLayoutCalc.StripCarriageReturns(const ScaleText:string) : string;
var
   tmpStr : string;
begin
   tmpStr := ScaleText;

   while Pos('#$D#$A', tmpStr) > 0 do
      Delete(tmpStr, pos('#$D#$A', tmpStr), 2);

   while pos(#13#10, tmpStr) > 0 do
     Delete(tmpStr, pos(#13#10, tmpStr), 2);

   result := tmpStr;

end;

end.
