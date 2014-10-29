unit RankingReport;

interface

uses SysUtils,constants,classes,comobj,textmeasure,Drawing;

procedure GetHSRankingReport(var y:double; Job_id, componentid:string; page:integer; cn:variant;pages:tstringlist;var buf:string);

implementation

function Max(a,b:double):double;
begin
  if a>b then result := a else result := b;
end;

function Min(a,b:double):double;
begin
  if a>b then result := b else result := a;
end;


procedure GetHSRankingReport(var y:double; Job_id, componentid:string; page:integer; cn:variant;pages:tstringlist;var buf:string);

Const MaxRowLength:double = 0;
      RowLength:double = 0;
      ColWidth:double = 80;
      MaxColWidth:double = 0;
      ColDist : double = 0;
      ColsPerPage : integer = 6;
      MaxColsPerPage : integer = 6;
      FirstCol:integer = 1;
      LastCol:integer = 6;
      MaxRows=1000;
      MaxCols=50;
      QuestionWidth : double = inch*2.5;

    //RowCol : array[0..MaxCols] of string;


var rs:variant;
    s:string;
    x:double;
    fs:double;
    v:double;
    Title,Lbl:string;
    Font:string;
    ColY:double;
    FirstPage:integer;
    ColCount:integer;
    ColPos:array [0..MaxCols] of double;
    LabelHeight:double;
    ColumnLabels : array[0..MaxCols] of string;
    ValueFormat : array [0..MaxCols] of string;
    i, j : integer;
    NumberOfColumns:integer;
    strCols:string;
    strUpdate:string;
    NumberOfRows:integer;
    LabelsFit,isNewPage:boolean;

    PerformSigTest := boolean;
    SigTestComparisonName : string;
    MeasureTypeLabel : string;
    DateRange : string;
    ShowRankingNum:Boolean;

    procedure WriteColumnLabels;
    var i : integer;
    begin
      LabelsFit:=false;
      if Not isNewPage then
        y := y-fs*2;
      x := LeftMargin+11;
      x := x+11;
      fs := 11;
      RowLength := GetTextWidth(Title,'Helvetica',fs);
      activeFont := '/F2';
      textat(x,y,'Arial Bold',fs,Title,round(QuestionWidth),'LB',False,'');
      LabelHeight := y-yGlobal;
      fs:=9;
      for i := FirstCol to LastCol do
      begin
        textat(ColPos[i],y,'Arial Bold',fs,ColumnLabels[i],round(ColWidth-fs),'LB',false,'');
        LabelHeight := max(LabelHeight, y-yGlobal);
      end;
      y:=y-LabelHeight;

      if y < 50+fs*5 then exit;
      LabelsFit := true;
      fs:=11;
      buf := buf+textat(x,y,'Arial Bold',fs,Title,round(QuestionWidth),'LB',true,'');
      fs:=9;
      for i := FirstCol to LastCol do
      begin
        buf := buf+textat(ColPos[i],y,'Arial Bold',fs,ColumnLabels[i],round(ColWidth-fs),'C',true,'');
      end;
      activeFont := '/F1';

      y := y-fs*0.5;
      x := x-11;
      buf := buf+format('q .5 w 0 G %g %g m'#10'%g %g l s Q'#10,[x,y,pagewidth-x,y]); //draw line
      y := y-fs;

    end;

    Function NewPage(Titles:array of string):string;
    var y:double;
    begin
      //Add new page to page collection
      pages.AddObject(buf,tobject(true));
        if not (pages.count+1 in NoLegendPages) then
           NoLegendPages:=NoLegendPages+[pages.count+1];

        if Landscape then
           LandscapePages:=LandscapePages+[pages.count+1];

      //Draw rectangle
      y:=inch*0.75;
      DrawRectangle(inch,y,inch*9.5,inch*6,0.75,clBlack)

      //insert client logo and NRC logo
      if useClientLogo then
      begin
         images:=Format( #10'q %g 0 0 %g %g %g cm /Im2 Do Q'#10,[imagewidth2/96*72,ImageHeight2/96*72,33.0,y+fs ] );
         y:=y + (imagewidth2/96*72) + 10;
      end;


      //write titles

      //division line

      //write date

    end;
begin

  if Landscape then MaxColsPerPage := 10;

  FirstPage:=Pages.count;

  Font := ActiveFont;

  rs := CreateOleObject('ADODB.Recordset');
  s := format('SELECT ' +
             'ComponentTitle,ComponentLabel '+
             'FROM apo_tabularrankingSectionFinal '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);

  rs.open(s,cn,1,1);

  if not rs.eof then
  begin
    Title := trim(vartostr(rs.fields['ComponentTitle'].value));
  end;
  rs.close;

  cn.execute('if not OBJECT_ID(''tempdb..#temp'') is null'#13#10+
             'begin'#13#10+
             'drop table #temp'#13#10+
             'end'#13#10+
             'if not OBJECT_ID(''tempdb..#detail'') is null'#13#10+
             'begin'#13#10+
             'drop table #detail'#13#10+
             'end');

  s := format('SELECT ' +
             'Title1, Title2, PerformSigTest,SigTestComparisonName,MeasureTypeLabel,DateRange,ShowRankingNum '+
             'FROM APO_HSRankingFinal '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);

  rs.open(s,cn,1,1);

  if rs.eof then begin
    rs.close;
    exit;
  end;

  PerformSigTest := rs.fields['PerformSigTest'].value;
  SigTestComparisonName := rs.fields['SigTestComparisonName'].value;
  MeasureTypeLabel := rs.fields['MeasureTypeLabel'].value;
  DateRange := rs.fields['DateRange'].value;
  ShowRankingNum := rs.fields['ShowRankingNum'].value;

  rs.close;

  //////////////////////////////////
  s := format('SELECT ' +
             'Column_ID, ColumnLabel '+
             'FROM APO_HSRankingFinalColumn '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);

  rs.open(s,cn,1,1);

  while not rs.eof do begin


  end;



  rs.close;

  //////////////////////////



  s := format('SELECT ' +
             'sequence, Column_ID, [Value] '+
             'into #detail '+
             'FROM apo_tabularrankingSectionFinalDetail '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);



  cn.execute(s);

  s := format('SELECT ' +
             'Column_ID,ColumnLabel, '+
             'case ValueFormat when 1 then ''0'' '+
             'when 2 then ''0.0'' '+
             'when 3 then ''0.0%%'' '+
             'end as ValueFormat '+
             'FROM apo_tabularrankingSectionFinalColumn '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d '+
             'order by Column_ID' ,
             [Job_id,Componentid,page]);
  rs.open(s,cn,1,1);
  rs.movelast;
  NumberOfColumns:=rs.recordcount;
  ColsPerPage := MaxColsPerPage;
  if NumberOfColumns < ColsPerPage then
    ColsPerPage := NumberOfColumns;

  x := LeftMargin+11;
  ColWidth :=   ((PageWidth-x*2)-QuestionWidth) / ColsPerPage;

  if ColWidth > inch*1.5 then ColWidth := inch*1.5;

  rs.movefirst;
  strCols:=',';
  for i := 1 to NumberOfColumns do
  begin
    strCols := strCols+format('cast(null as decimal(9,5)) as Col%d,',[i]);
    strUpdate := strUpdate+format('UPDATE #temp SET Col%0:d = B.VALUE FROM #temp A,'+
                                  '(select * from #detail '+
                                  'where COLUMN_ID = %0:d) AS B WHERE A.sequence = B.sequence'#13#10,
                                  [i]);

  end;

  strCols[length(strCols)]:=' ';



  s := format('SELECT ' +
             'sequence, QuestionLabel '+strCols+
             'into #temp '+
             'FROM apo_tabularrankingSectionFinalRow '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);

  cn.execute(s,NumberOfRows);
  s:=inttostr(NumberOfRows);
  cn.execute(strUPdate);

  while not rs.eof do
  begin

    i := strtointdef(vartostr(rs.fields['Column_ID'].value),0);
    if ((i-1) mod ColsPerPage = 0) then
    begin
      x:=(LeftMargin+11+QuestionWidth)-(ColWidth);
    end;
    ColumnLabels[i] := vartostr(rs.fields['ColumnLabel'].value);
    x := x + ColWidth;
    ColPos[i] := x;
    ValueFormat[i]:=rs.fields['ValueFormat'].value;
    ColPos[i]:=x+ColWidth*0.5;
    rs.movenext;
  end;

  rs.close;

  s := 'SELECT * from #temp';
  rs.open(s,cn,1,1);


  FirstCol := 1;
  LastCol := round(min(ColsPerPage,NumberOfColumns));
  isNewPage:=false;
  While NumberOfColumns > 0 do
  begin
    WriteColumnLabels;
    fs := 9;
    while not rs.eof do
    begin
      s := vartostr(rs.fields['QuestionLabel'].value);
      x := LeftMargin+22;
      if ((y<50+(fs*2)) or (not LabelsFit)) then
      begin
        pages.AddObject(buf,tobject(true));
        buff := '';
        if not (pages.count+1 in NoLegendPages) then
          NoLegendPages:=NoLegendPages+[pages.count+1];

        if Landscape then
          LandscapePages:=LandscapePages+[pages.count+1];

        buf:=PageHeader(y,true);
        //y:= y-fs*2;
        isNewPage:=true;
        WriteColumnLabels;
        isNewPage:=false;
        x := LeftMargin+22;
      end;
      buf := buf+textat(x,y,'Helvetica',fs,s,round(QuestionWidth)-5,'L',False,'');
      y:=yGlobal+fs;
      for i := FirstCol to LastCol do
      begin
         if not varisnull(rs.fields['Col'+inttostr(i)].value) then
         begin
           v := rs.fields['Col'+inttostr(i)].value;
           s:=formatfloat(ValueFormat[i],round(v*10000)*0.0001);
           buf := buf+textat(ColPos[i],y,'Helvetica',fs,s,round(ColWidth),'C',False,'');
         end;
      end;
      RowLength := max(RowLength, GetTextWidth(s,'Helvetica',fs));
      y := yGlobal;
      x := LeftMargin+11;
      y := yGlobal+fs*0.5;
      buf := buf+format('q 0.5 w 0 0 0 RG %g %g m'#10'%g %g l s Q'#10,[x,y,pagewidth-x,y]); //draw line
      y := y-fs;
      rs.movenext;
    end;

    inc(FirstCol,ColsPerPage);
    inc(LastCol,ColsPerPage);

    if FirstCol> NumberOfColumns then
      break;

    if LastCol > NumberOfColumns then
    begin
      LastCol := NumberOfColumns;
    end;

  end;
  rs.close;
  ActiveFont := Font;
  rs := unassigned;

end;


end.
 