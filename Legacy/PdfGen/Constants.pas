unit Constants;

interface
uses forms,stdctrls,messages,windows;

Type
  tllist=array[0..7] of string;


  TColorRGB = packed record
    Red, Green, Blue, Alpha: Byte;
  end;

  PString=^String;

  tCol = class(tobject)
     x:double;
     y:double;
     w:double;
     text:string;
  end;


  PProgress = ^TProgress;
  TProgress = record
       Possition:Integer;
       Max:Integer;
  end;


Const inch=72.0;
const PageWidth : double = 8.5*inch;
      PageHeight:double = 11*inch;
      LeftMargin : double = inch*0.33;
      RightMargin:double = ((8.5*inch) - (inch*0.33));
      FooterHeight:double=1.2*inch;
      Mockup:boolean = false;


      TH_MESSAGE     = WM_USER + 1;          //Thread message
      TH_NEWAP       = 1;                    //Thread Submessage : Started new file
      TH_UPDATE      = 2;
      TH_LABEL       = 3;
      TH_FINISHED    = 4;                    //Thread SubMessage : End of thread  WParam = ThreadID
      TH_THISPROGRESSPOS = 5;
      TH_THISPROGRESSMAX = 6;
      TH_ALLPROGRESSPOS  = 7;
      TH_ALLPROGRESSMAX  = 8;
      TH_ERROR       = 9;                    //Thread SubMessage : Error WParam = Error
      ERROR_COULD_NOT_OPEN_FILE = 10;      //Error file could not be opened


      DataPath : string  = '\sasphase2\pdfdataset\';


      step:integer = 4;


      comp_detail:string         = '#comp_detail';
      vbar_final:string          = '#vbar_final';
      quad_final:string          = '#quad_final';
      Quad_quest:string          = '#Quad_Quest';
      Quad_Theme:string          = '#Quad_Theme';
      hbar_stats_final:string    = '#hbar_stats_final';
      hbar_labels_final:string   = '#hbar_labels_final';
      cntl_final:string          = '#cntl_final';
      dupe_table:string          = '#dupe_table';
      Global_Run_Table:string    = '#Global_Run_Table';
      actionplan:string          = '#actionplan';
      Job_list:string = '';

      Objects :integer = 13;

var
      PageHeaderLines   : array[0..3] of string;
      strPageHeaderOverride : string;
      strOutLineTitle : array [0..1] of string;
      Landscape:Boolean;
      LandscapePages: set of 0..255;
      NoLegendPages: set of 0..255;
      rr    : double;
      UseClientLogo:boolean;
      ImageWidth1,ImageHeight1:double;
      ImageWidth2,ImageHeight2:double;
      UseCaution:boolean;
      ImageWidth3,ImageHeight3:double;
      fHandle:HWND;
      MeasureType:integer;
      LastGoodDate:double;
      strClient_Nm:string;
      MoreHBars : boolean;
      HBarsCounter:integer;
      MissingColumns : set of 1..7;
      cn:variant;
      rs2:variant;
      DrawHBLegend:Boolean;
      MaxNCount:double;
      activefont:string;
      lbl:string;
      ColPos:array[0..7] of double;
      CurColWidth : double;
      ColWidth : Array[0..7] of double;
      ActualColWidth:double;
      CurCol:integer;
      ColsCount:integer;
      PrevCnt:integer;
      CompCnt:integer;
      MaxPrevCnt:integer;
      MaxCompCnt:integer;
      IsPercent:array[0..7] of boolean;
      IsCor:array[1..7] of boolean;
      IsSampleSize:array[1..7] of boolean;
      sig:array[0..7] of char;
      list1:tllist;
      list2:tllist;
      Scale:string;
      TitleStr:string;
      Componentid:string;
      Job_Id:string;
      CorrelationLabel:string;
      PositiveYAxis:boolean;
      strGrouping,grouping:string;
      LinesHeight:double;
      QuestionstoDisplay:Integer;
      qstncore:string;
      list:tllist;
      fs:double;
      SigArrowPos : double;
      //boolPrimaryOverlap : boolean;
      //boolSecondaryOverlap : boolean;
      bool3D:boolean;
      ShowSig:boolean;
      NewPage:boolean=true;
      ShowRR:boolean=true;
      yGlobal:double;
      formats:array[1..4] of string = ('0','0.0','0.0%','0.000');
      intFormat:integer;
      row:integer;
      ipdf:variant;
      OnePage:boolean=false;
      Fit:boolean=True;
      UseHbarLegend:boolean;
      SortLegend:string;
      AppPath:string;
      IsPepC:boolean;
      
Procedure UpdateForm(m:integer;var v:integer;s:string);

implementation

Procedure UpdateForm(m:integer;var v:integer;s:string);
var strMsg:PString;
begin
  case m of
    TH_NEWAP..TH_LABEL:
      begin
        new(strMsg);
        strMsg^ := s;
        PostMessage(fHandle, TH_MESSAGE, m, LongInt(strMsg));
        //dispose(strMsg);
      end;
    TH_THISPROGRESSPOS,TH_ALLPROGRESSPOS:
      begin
        inc(v);
        PostMessage(fHandle, TH_MESSAGE, m, v);
      end;
    else
    begin
      PostMessage(fHandle, TH_MESSAGE, m, v);
    end;
  end;
  
end;

end.
