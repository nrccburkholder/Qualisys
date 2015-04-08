unit HSRankingReport;

{
Program Modifications:
--------------------------------------------------------------------------------
Date      UserID  Description
--------------------------------------------------------------------------------
10-01-05  GN01    An up arrow was randomly getting displayed on the report whenever
                  column overflow event occured.

}


interface

uses SysUtils,constants,classes,comobj,textmeasure,Drawing,Graphics,Arrows, Dialogs;

procedure GetHSRankingReport(var y:double; Job_id, componentid:string; page:integer; cn:variant;var pages:tstringlist);

implementation

function Max(a,b:double):double;
begin
  if a>b then result := a else result := b;
end;

function Min(a,b:double):double;
begin
  if a>b then result := b else result := a;
end;

procedure GetHSRankingReport(var y:double; Job_id, componentid:string; page:integer; cn:variant;var pages:tstringlist);

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

type
  tCol = record
    ID:integer;
    Text:String;
    Pos:double;
  end;


var rs:variant;
    colsrs:variant;
    s:string;
    x:double;
    fs:double;
    v:double;
    Title,Lbl:string;
    Font:string;
    ColY:double;
    ColCount:integer;
    ColPos:array [-2..MaxCols] of double;
    LabelHeight:double;
    ColumnLabels : array[-2..MaxCols] of string;
    ValueFormat : array [-2..MaxCols] of string;
    i, j : integer;
    NumberOfColumns:integer;
    NumberOfRankingColumns:integer;
    strCols:string;
    strUpdate:string;
    NumberOfRows:integer;
    LabelsFit,isFirstPage:boolean;
    index:integer;
    TempDouble,LeftMargin, InnerLeftMargin, BottomMargin, InnerBottomMargin, TopMargin:double;
    ShadedLine : boolean;
    isNewPage:boolean;
    PerformSigTest : boolean;
    SigTestComparisonName : string;
    MeasureTypeLabel : string;
    DateRange : string;
    ShowRankingNum:Boolean;
    OrderBy:integer;
    RowDataCategory:integer;
    Title1, Title2 : string;
    RankingWidth : double;
    RowLabel:string;
    Lines:string;

    Columns:array [0..20] of tCol;
    ColumnsCount:integer;

    procedure WriteColumnLabels;
    var i : integer;
        s:string;
        x:double;
    begin
      LabelsFit:=false;
     // if Not isNewPage then
     //   y := y-fs*2;
      x := colPos[-1];
      x := x+11;
      fs := 11;
      RowLength := GetTextWidth(Title,'',fs);
      textat(x,y,'',fs,'Something' ,round(QuestionWidth),'LB',True,'/F2');
      LabelHeight := y-yGlobal;
      fs:=9;
      for i := FirstCol to LastCol do
      begin
        textat(ColPos[i],y,'',fs,ColumnLabels[i],round(ColWidth-fs),'LB',false,'/F2');
        LabelHeight := max(LabelHeight, y-yGlobal);
      end;
      y:=y-LabelHeight;
      y := y-fs*2;
      if y < BottomMargin+fs*5 then exit;
      LabelsFit := true;
      fs:=11;
      s:='q 1 1 1 rg ';
      fs:=9;

      if ShowRankingNum then
         s := s+textat(ColPos[-1],y,'',fs,'Rank',round(RankingWidth),'L',true,'/F2');

      s := s+textat(ColPos[0],y,'',fs,'Facility',round(QuestionWidth),'L',true,'/F2');



      for i := FirstCol to LastCol do
      begin
        s := s+textat(ColPos[i],y,'',fs,ColumnLabels[i],round(ColWidth-fs),'C',true,'/F2');
      end;
      s := s+'Q'#10;

      y := y-fs;
      x := innerLeftMargin;
      LabelHeight := LabelHeight + fs*2;
      //pages[index] := pages[index]+{DrawRectangle(x,y,PageWidth-inch*2,LabelHeight,0.75,clBlack) +} s;
      s := format('q 0 J %g w 0 G %g %g m'#10'%g %g l s Q'#10,[LabelHeight,x,y+LabelHeight*0.5,pagewidth-x,y+LabelHeight*0.5])+s; //draw line
      pages[index] := pages[index]+s;
      y := y-fs;

    end;

    procedure NewPage;
    var fontsize:double;
        LegendWidth : double;
        KeyWidth : double;
        FirstKeyWidth : double;
        LegendHeight : double;
        KeysPerCol:integer;
        KeyCols:integer;
        ExtraKeyCols:integer;
        NumberOfKeys:integer;

        s,s1:string;
        Title:string;
        i:integer;
        j:integer;
        k:integer;
        h:integer;
    begin
      //Add Current page to pages collection
      Landscape := true;

      //if pages[index] <> '' then begin
      index := pages.AddObject('',tobject(true));
      NoLegendPages:=NoLegendPages+[pages.count];
//      HSReport:=HSReport+[pages.count];

      if Landscape then
        LandscapePages:=LandscapePages+[pages.count];

      BottomMargin := inch*0.75;
      //end;

      TopMargin:=PageHeight - inch*0.75;
      y := TopMargin;
      x:=LeftMargin;

      pages[index]:='';

      //Draw rectangle
      pages[index] := DrawRectangle(x,BottomMargin,PageWidth-x*2,y-BottomMargin,2,clBlack,-1);
      s := '';
      //Insert Legend
      if PerformSigTest then
      begin
        s:='AAAAAA Significantly Higher Than '+SigTestComparisonName;
        LegendWidth := GetTextWidth(s,'',fs);
        LegendHeight := fs*4;
        x:=PageWidth-(InnerLeftMargin+LegendWidth);
        y := y-fs*5;

        pages[index] := pages[index] + DrawRectangle(x+3,y-3,LegendWidth-fs,LegendHeight,2,clBlack,clBlack);
        pages[index] := pages[index] + DrawRectangle(x,y,LegendWidth-fs,LegendHeight,2,clBlack,clWhite);
        y:=y+fs*2.5;
        s:='Significantly Higher Than '+SigTestComparisonName;
        pages[index] := pages[index] + DrawArrow(x+5,y,fs,'0 g','H') + textat(x+fs*2,y,'',fs,s,Round(LegendWidth+0.4),'L',False,'');
        y:=y-fs*1.5;
        s:='Significantly Lower Than '+SigTestComparisonName;
        pages[index] := pages[index] + DrawArrow(x+5,y,fs,'0 g','L') + textat(x+fs*2,y,'',fs,s,Round(LegendWidth+0.4),'L',False,'');
      end;

      x := LeftMargin;
      fontsize :=fs;
      fs:=16;
      //insert client logo and NRC logo
      if useClientLogo then
      begin
         y := TopMargin;
         y:=y - (ImageHeight2/96*72);
         y := y-10;
         pages[index] := pages[index] + Format( #10'q %g 0 0 %g %g %g cm /Im2 Do Q'#10,[imagewidth2/96*72,ImageHeight2/96*72,InnerLeftMargin,y]);
         y := y - fs;

      end;
//      if usenrclogo then
        pages[index] := pages[index] + Format( #10'q %g 0 0 %g %g %g cm /Im1 Do Q'#10,[ImageWidth1/96*72,ImageHeight1/96*72,PageWidth-(ImageWidth1/96*72)-LeftMargin,BottomMargin-(ImageHeight1/96*72)-10  ] );

      //write titles
      if isFirstPage then
        Title:= Title1
      else
        Title:= Title1 + ' (continued)';

      fs:=16;
      x := LeftMargin+inch*0.5;
      pages[index] := pages[index] + textat(x,y,'',fs,Title,400,'L',False,'');
      y := yGlobal;
      pages[index] := pages[index] + textat(x,y,'',fs,Title2,400,'L',False,'');
      y := yGlobal;

      fs:=fontsize;

      //division line
      pages[index] := pages[index] + format('q 0 J 3.5 w 0 G %g %g m'#10'%g %g l s Q'#10,[x,y+fs*0.5,PageWidth-InnerLeftMargin,y+fs*0.5]);

      fs:= 16;

      //write date
      y := y - fs;
      pages[index] := pages[index] + textat(PageWidth-InnerLeftMargin,y,'',fs,DateRange,300 ,'R',False,'');
      fs:=fontsize;

      //write Ranking Key
      TopMargin := y;


      if (NumberOfRankingColumns > 0) And ShowRankingNum and (OrderBy in[5,6,7]) then  begin
        fs := 7;
        BottomMargin := BottomMargin + fs*1.5;
        y := BottomMargin + fs * 0.5;
        x := InnerLeftMargin;
        s1 := format('q 1 w 0 G %g %g m'#10'%g %g l s Q'#10,[x,y,PageWidth-x,y]);
        y := y - fs*1.5;
        s1:=s1+TextAt(x+inch,y,'',fs,'Total point = (Number of up arrows) - (Number of down arrows)',300 ,'L',False,'');

        NumberOfKeys := (NumberOfRankingColumns * 2 +1);
        KeysPerCol := NumberOfKeys div 4;
        ExtraKeyCols := NumberOfKeys mod 4;

        if ExtraKeyCols > 0 then inc(KeysPerCol);
        KeyCols := Round(NumberOfKeys/KeysPerCol+0.5);


        BottomMargin := BottomMargin + KeysPerCol*fs;

        k:=1;

        s:= '10 = 1 total points';
        KeyWidth := GetTextWidth(s,'',fs);
        s:= Format('1 = %0:d total points (statistically greater on all %0:d items/themes)',[NumberOfRankingColumns]);
        FirstKeyWidth := GetTextWidth(s,'',fs)+KeyWidth;
        KeyWidth := KeyWidth * 2;
        k:=NumberOfRankingColumns;
        x := InnerLeftMargin;
        y := BottomMargin;
        s1 := s1 + TextAt(x,y,'',fs,s,Round(FirstKeyWidth+0.5) ,'L',False,'');
        y := y - fs;
        j:=1;

        for i := 1 to ExtraKeyCols do begin
           While (j < KeysPerCol) do begin
              dec(k);
              h := NumberOfRankingColumns-k;
              if (h+1) = NumberOfKeys then break;
              s:=Format('%d = %d total points',[h+1,k]);
              s1:=s1+TextAt(x,y,'',fs,s,300 ,'L',False,'');
              inc(j);
              y := y - fs;
           end;
           j:=0;
           if (h+1) = NumberOfKeys then break;
           y := BottomMargin;
           x:=x+FirstKeyWidth;
           FirstKeyWidth := KeyWidth;
        end;

        if ExtraKeyCols > 0 then begin
          dec(KeysPerCol);
          BottomMargin := BottomMargin - fs;
          y := BottomMargin;
        end;

        for i := ExtraKeyCols+1 to KeyCols do begin
           While (j < KeysPerCol) do begin
              dec(k);
              h := NumberOfRankingColumns-k;
              if (h+1) = NumberOfKeys then break;
              s:=Format('%d = %d total points',[h+1,k]);
              s1:=s1+TextAt(x,y,'',fs,s,300 ,'L',False,'');
              inc(j);
              y := y - fs;
           end;

           if (h+1) = NumberOfKeys then break;

           j:=0;
           y := BottomMargin;
           x:=x+FirstKeyWidth;
           FirstKeyWidth := KeyWidth;
        end;

        s:= Format('%0:d = %1:d total points (statistically less on all %2:d items/themes)',[NumberOfKeys,k,NumberOfRankingColumns]);
        s1:=s1+TextAt(x,y,'',fs,s,300 ,'L',False,'');

        if ExtraKeyCols > 0 then
          BottomMargin := BottomMargin + fs;

        //make room for KEY TO RANKING label and dividing line
        BottomMargin := BottomMargin + fs * 2;
        y := BottomMargin;
        x := InnerLeftMargin;
        s1:=s1+TextAt(x,y,'',fs,'KEY TO RANKING',300 ,'L',False,'/F2');
        y := y - fs*0.5;
        s1 := s1 + format('q 0 J 1 w 0 G %g %g m'#10'%g %g l s Q'#10,[x,y,PageWidth-InnerLeftMargin,y]);
        y := TopMargin;

        pages[index] := pages[index] + s1;

      end;

      x := LeftMargin;

    end;

begin
  Landscape := true;
  rs := CreateOleObject('ADODB.Recordset');
  ColsRs := CreateOleObject('ADODB.Recordset');
  ShadedLine := True;
  cn.execute('if not OBJECT_ID(''tempdb..#temp'') is null'#13#10+
             'begin'#13#10+
             'drop table #temp'#13#10+
             'end'#13#10+
             'if not OBJECT_ID(''tempdb..#detail'') is null'#13#10+
             'begin'#13#10+
             'drop table #detail'#13#10+
             'end');

  s := format('SELECT ' +
             'Title1, Title2, isnull(PerformSigTest,0) as PerformSigTest,isnull(SigTestComparisonName, ''No Comparison Name'') as SigTestComparisonName,MeasureTypeLabel,DateRange,ShowRankingNum,OrderBy '+
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


  Title1 := rs.fields['Title1'].value;
  Title2 := rs.fields['Title2'].value;
  PerformSigTest := rs.fields['PerformSigTest'].value;
  SigTestComparisonName := rs.fields['SigTestComparisonName'].value;
  MeasureTypeLabel := rs.fields['MeasureTypeLabel'].value;
  DateRange := rs.fields['DateRange'].value;
  ShowRankingNum := rs.fields['ShowRankingNum'].value;
  OrderBy := rs.fields['OrderBy'].value;
  rs.close;


  if Landscape then
      begin
        MaxColsPerPage := 8;
        PageWidth  := 11*inch;
        PageHeight := 8.5*inch;
      end;

  LeftMargin := inch*0.75;
  InnerLeftMargin := LeftMargin+8;

  ColPos[-1] := InnerLeftMargin+5;
  RankingWidth :=0;
  if ShowRankingNum then
  begin
     RankingWidth :=inch*0.4;
     ColPos[0]:=ColPos[-1]+RankingWidth+fs*1.5;
     s := format('SELECT Count(*) as cnt '+
             'FROM APO_HSRankingFinalColumn '+
             'WHERE ColumnDataCategory = 1 '+
             'and Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);

     rs.open(s,cn,1,1);
     NumberOfRankingColumns := rs.fields['cnt'].value;
     rs.close;

  end
  else
    ColPos[0]:=ColPos[-1];


  s := format('SELECT ' +
             'Column_ID,Row_ID, [Value],'+
             'case isnull(sig,3) when 3 then ''X'' when 0 then ''L'' else ''H'' end as sig '+
             'into #detail '+
             'FROM APO_HSRankingFinalDetail '+
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
             'FROM APO_HSRankingFinalColumn '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d '+
             'order by Column_ID' ,
             [Job_id,Componentid,page]);
  ColsRs.open(s,cn,1,1);
  ColsRs.movelast;

  NumberOfColumns:=ColsRs.recordcount;

  ColsPerPage := MaxColsPerPage;
  if NumberOfColumns < ColsPerPage then
    ColsPerPage := NumberOfColumns;

  if ColWidth > inch*2 then ColWidth := inch*2;

  ColsRs.movefirst;

  strCols:=',';
  strUpdate := '';


  ColWidth :=   (PageWidth-(ColPos[0]+InnerLeftMargin+QuestionWidth)) / ColsPerPage;
  ColWidth := ColWidth - ColWidth * 0.5 / ColsPerPage;
  x:=(ColPos[0]+QuestionWidth)-ColWidth*0.5;

  j := 1;
  while not ColsRs.eof do
  begin
    i := strtointdef(vartostr(ColsRs.fields['Column_ID'].value),0);
    if ((j-1) mod ColsPerPage = 0) then
    begin
      x:=(ColPos[0]+QuestionWidth)-ColWidth*0.5;
    end;
    ColumnLabels[j] := vartostr(ColsRs.fields['ColumnLabel'].value);
    x := x + ColWidth;
    ColPos[j] := x;
    ValueFormat[j]:=ColsRs.fields['ValueFormat'].value;

    strCols := strCols+format('cast(null as decimal(12,5)) as Col%0:d, cast(null as char(1)) as sig%0:d,',[j]);
    strUpdate := strUpdate+format('UPDATE #temp SET Col%0:d = B.VALUE, sig%0:d = b.sig FROM #temp A,'+
                                  '(select Row_ID, [value], sig from #detail '+
                                  'where COLUMN_ID = %1:d) AS B WHERE A.Row_ID = B.Row_ID'#13#10,
                                  [j,i]);
    inc(j);
    ColsRs.movenext;
  end;

  strCols[length(strCols)]:=' ';



  s := format('SELECT ' +
             'Row_ID, RowLabel, RankingNum,isnull(RowDataCategory,0) as RowDataCategory '+strCols+
             'into #temp '+
             'FROM APO_HSRankingFinalRow '+
             'WHERE Job_id = %s '+
             'and component_id = %s '+
             'and page_number = %d ',
             [Job_id,Componentid,page]);

  cn.execute(s,NumberOfRows);
  s:=inttostr(NumberOfRows);
  cn.execute(strUPdate);

  s := 'SELECT * from #temp';
  rs.open(s,cn,1,1);

  FirstCol := 1;
  LastCol := round(min(ColsPerPage,NumberOfColumns));
  isFirstPage:=True;
  y:=0;
  While NumberOfColumns > 0 do
  begin
    fs := 9;
    while not rs.eof do
    begin

      if ((y<BottomMargin+fs*2)  or (not LabelsFit) or isNewPage) then
      begin
        NewPage;
        WriteColumnLabels;
        ShadedLine:=false;
        isFirstPage:=false;
        isNewPage := False;
      end;
      if ShowRankingNum then
      begin
        x := ColPos[-1];
        s := vartostr(rs.fields['RankingNum'].value);
        if s <> '' then  //GN01
        pages[index] := pages[index]+textat(x+fs,y,'',fs,s,round(RankingWidth)-5,'C',False,'');
      end;
      s := vartostr(rs.fields['RowLabel'].value);
      RowLabel:=s;
      x := ColPos[0];
      pages[index] := pages[index]+textat(x,y,'',fs,s,round(QuestionWidth)-5,'L',False,'');
      LinesHeight := fs;
      if LabelHeight > LinesHeight then
         LabelHeight := LinesHeight;

      y:=yGlobal+fs;
      Coly:=y;

      for j := FirstCol to LastCol do begin
         if not varisnull(rs.fields['Col'+inttostr(j)].value) then
         begin
           if ValueFormat[j] = '0' then begin
             v := STRTOFLOAT(VARTOSTR(rs.fields['Col'+inttostr(j)].value));
             s:=formatfloat(ValueFormat[j],v);
           end
           else
           begin
             v := rs.fields['Col'+inttostr(j)].value;
             s:=formatfloat(ValueFormat[j],round(v*10000)*0.0001);
           end;
           pages[index] := pages[index]+textat(ColPos[j],y,'',fs,s,round(ColWidth),'C',False,'');
           pages[index] := pages[index]+DrawArrow(SigArrowPos-2,y,fs,'0 g',vartostr(rs.fields['sig'+inttostr(j)])[1] );
         end;
      end;

      RowLength := max(RowLength, GetTextWidth(s,'',fs));
      RowDataCategory := rs.fields['RowDataCategory'].value;

      x := InnerLeftMargin;
      y := Coly-fs*0.5;

      if (RowDataCategory = 1) then begin
        if ShadedLine then
          pages[index] := format('q 0 J %g w 0.6 G %g %g m'#10'%g %g l s Q'#10,[fs*1.5,x,y+fs*0.75,pagewidth-x,y+fs*0.75])+pages[index]; //draw line
        ShadedLine := not ShadedLine;
      end
      else
       ShadedLine := true;
      Lines:=format('0 J q 0.5 w 0 0 0 RG %g %g m'#10'%g %g l s Q'#10,[x,y,pagewidth-x,y]); //draw line
      pages[index] := pages[index]+Lines;
      //pages[index] := pages[index]+textat(pagewidth-x,y,Arial,fs,RowLabel,round(QuestionWidth),'C',False,'');
      y := y-fs;
      rs.movenext;
    end;
    rs.movefirst;

    inc(FirstCol,ColsPerPage);
    inc(LastCol,ColsPerPage);

    if FirstCol> NumberOfColumns then
      break;

    if LastCol > NumberOfColumns then
    begin
      LastCol := NumberOfColumns;
    end;
    //WriteColumnLabels;
    isNewPage:=true;
  end;

  rs.close;
  rs := unassigned;

end;


end.
