unit HBHeaders;

interface
uses constants,sysutils,TextMeasure,hbars,Drawing;

procedure GetLabels(var List:tllist;stacked_bars:boolean);

function HeaderChanged(L1,L2:array of string):boolean;

function GetHeader(var y:double;List:Array of string;var Title1:string;Title2:string;fs:double;CurCol,ColsCount:integer;var ColPos:Array of double;HbarLength:double;Correlation:string;stacked_bars:boolean ):string;

implementation

procedure GetLabels(var List:tllist;stacked_bars:boolean);
var i:integer;
begin
  PrevCnt:=0;  //Previous period comparison count
  CompCnt:=0; //Comparison columns count
  MissingColumns:=[];
  CompCnt := 0;
  prevCnt := 0;

  for i:= 1 to ColsCount do
  begin
    sig[i]:=#20;
    lbl:=trim(vartostr(rs2.fields[format('label%d',[i])].value))+' ';
    if i <> CurCol then
      if (lbl <> ' ')then begin
         if i > CurCol then
           inc(CompCnt)
         else
           inc(PrevCnt);

      end
      else
        MissingColumns:=MissingColumns+[i];

    List[i]:=trim(lbl);

    if stacked_bars then
      IsPercent[i]:= (lbl[1]='%') or (CurCol = i)
    else
      IsPercent[i]:= (lbl[1]='%') or (MeasureType = 2);

    IsSampleSize[i] := ((uppercase(trim(lbl)) = 'SAMPLE SIZE') or (uppercase(trim(lbl)) = 'N SIZE'));

    Sig[i]:=(trim(vartostr(rs2.fields[format('Sig%d',[i])].value))+' ')[1];
    IsCor[i]:=uppercase(trim(vartostr(rs2.fields[format('Label%d',[i])].value))) = 'CORRELATION COEFFICIENT';
  end;
end;


function GetHeader(var y:double;List:Array of string;var Title1:string;Title2:string;fs:double;CurCol,ColsCount:integer;var ColPos:Array of double;HbarLength:double;Correlation:string;stacked_bars:boolean):string;
var s:string;
    LegendWidth,i,j:integer;
    HBarWidth:double;
    CurrentColumnWidth:double;
    x,x1,x2,ColDist:double;
    CompWidth:double;
    LegendPos:double;
    LastPrevPos,FirstCompPos:double;
    bg:carray;
    StackedTileLines:array [1..3] of string;
    HasTitle:boolean;
    ComparisonCount:integer;
    HeaderHeight:double;
begin
  LinesHeight:=0;
  if ((Correlation <> '') and DrawHBLegend)  or Stacked_bars then
    HeaderHeight:=10
  else
    HeaderHeight:=5;

  begin

    //1 0 .3 1 50 50 Tm
    HasTitle:=false;
    if Title1 <> Title2 then
    begin
      Title1:=Title2;
      if Title1 <> '' then
      begin
        HasTitle:=true;
        y:=y-(fs+5);
        s:=format('BT/F2 %f Tf 1 0 .3 1 %g %g Tm 0 0 Td (%s) Tj ET'#10,[fs,(PageWidth-GetTextWidth(Title1,'Helvetica',fs))/2,y,Title1]);
        y:=y+(fs+5);
        if ((Correlation <> '') and DrawHBLegend)  or Stacked_bars then
          HeaderHeight:=20+fs
        else
          HeaderHeight:=fs+5;
      end;
    end;

    j := PrevCnt+CompCnt;
    ComparisonCount:= j;
    ColDist := 12;
    x1:=LeftMargin+10;
    x2 := RightMargin - 10;
    for i := low(ColPos) to high(ColPos) do
      ColPos[i]:=x1;

    for i := low(ColWidth) to high(ColWidth) do
      ColWidth[i] := inch*0.7;

    HBarWidth := HbarLength + GetTextWidth('100.1000','Arial',fs);

    Case MaxPrevCnt of
       0 : begin
             Case MaxCompCnt of
               0 : begin
                     CompWidth := 80;
                     ColPos[CurCol] := 306;
                   end;
               1 : begin
                     CompWidth := 71;
                     ColPos[CurCol] := 295;
                   end;
               2 : begin
                     CompWidth := 63;
                     ColPos[CurCol] := 280;
                   end;
               3 : begin
                     CompWidth := 56;
                     ColPos[CurCol] := 265;
                   end;
               4 : begin
                     CompWidth := 48;
                     ColPos[CurCol] := 255;
                   end;

             end;
             ColPos[0] := x1;
             LastPrevPos := x1;
           end;
       1 : begin
             Case MaxCompCnt of
               0 : begin
                     CompWidth := 76;
                     ColPos[CurCol] := 306;
                   end;
               1 : begin
                     CompWidth := 70;
                     ColPos[CurCol] := 302;
                   end;
               2 : begin
                     CompWidth := 60;
                     ColPos[CurCol] := 285;
                   end;
               3 : begin
                     CompWidth := 53;
                     ColPos[CurCol] := 265;
                   end;
               4 : begin
                     CompWidth := 46;
                     ColPos[CurCol] := 240;
                   end;
             end;
             CompWidth := CompWidth + fs;
             textat(0,0,'Helvetica',fs,List[1],Round(CompWidth),'L',False,'');
             ColPos[1] := x1+ActualColWidth*0.5;
             ColWidth[1] := ActualColWidth;
             LastPrevPos := ColPos[1]+GetTextWidth('100.','Arial',fs);
           end;
       2 : begin
             Case MaxCompCnt of
               0 : begin
                     CompWidth := 74;
                     ColPos[CurCol] := 330;
                   end;
               1 : begin
                     CompWidth := 64;
                     ColPos[CurCol] := 324;
                   end;
               2 : begin
                     CompWidth := 56;
                     ColPos[CurCol] := 315;
                   end;
               3 : begin
                     CompWidth := 48;
                     ColPos[CurCol] := 300;
                   end;
               4 : begin
                     CompWidth := 40;
                     ColPos[CurCol] := 265;
                   end;
             end;
             CompWidth := CompWidth + fs;
             textat(0,0,'Helvetica',fs,List[1],Round(CompWidth),'L',False,'');
             ColPos[1] := x1+ActualColWidth*0.5;
             ColWidth[1] := ActualColWidth;
             ColPos[2] := ColPos[1]+CompWidth;
             ColWidth[2] := ActualColWidth;
             LastPrevPos := ColPos[2]+GetTextWidth('100.','Arial',fs);
           end;
    end;


    ColWidth[0] := CompWidth;
    CompWidth := CompCnt * CompWidth;

    //if (ColPos[CurCol] + HBarWidth) > (x2-CompWidth) then
    //   ColPos[CurCol] :=  (x2-CompWidth - HBarWidth);

    ColPos[CurCol] := ColPos[CurCol] - ColWidth[0]*0.5;

    FirstCompPos := x2 - (ColPos[CurCol]+HBarWidth+CompWidth);
    FirstCompPos := x2 - (FirstCompPos * 0.5);


    x := FirstCompPos+ColWidth[0]*0.5;
    for i:= ColsCount downto CurCol+1 do
    begin
      if not (i in MissingColumns) then
      begin
          x:=x-(ColWidth[0]);
          ColWidth[i] := ColWidth[0];
          ColPos[i]:=x;
      end;
    end;

    if x > x2 then //in case there are no comp cols
      x:=x2;

    FirstCompPos := x-GetTextWidth('100.','Arial',fs);
    ColWidth[0] := ColWidth[0] - ColDist;
    CurColWidth := ColPos[CurCol] - (LastPrevPos+fs);

     //Calculate Header Height
     j:=0;

     if HeaderChanged(List1,List) then
     begin
       y:=y-fs;

       j:=0;
       for i:=1 to ColsCount do
        if (CurCol <> i) and (not (i in MissingColumns)) then
        begin
          TextAt(ColPos[i],y,'Helvetica',fs,List[i],round(ColWidth[i]),'C',false,'');
          if HeaderHeight < LinesHeight then
            HeaderHeight := LinesHeight;
        end;

       y:=y-HeaderHeight;

       if ComparisonCount > 0 then s:=s+format('/F1 %f Tf'#10,[fs]);
       for i:=1 to ColsCount do
         if (CurCol <> i) and (not (i in MissingColumns)) then
           s := s + TextAt(ColPos[i],y,'Helvetica',fs,List[i],round(ColWidth[i]),'C',true,'');

    end
    else
    begin
      if HasTitle then
         if HeaderHeight < fs+3 then  HeaderHeight := fs+3;
       y:=y-HeaderHeight;
    end;

    if Stacked_bars then
    begin
      i:=1;
      j:=1;
      while i>0 do
      begin
        i:=pos('<br>',List[CurCol]);
        if i> 0 then
        begin
          StackedTileLines[j] := copy(List[CurCol],1,i-1);
          delete(List[CurCol],1,i+3);
          inc(j);
        end
        else
          StackedTileLines[j] := List[CurCol];
      end;

      for i := 1 to j do                                           //abs(i-j)+1 is to reverse the order                                                                  //of the array... get last first
        s:=s+TextAt(150,y+(fs*(i-1)),'Helvetica',fs,StackedTileLines[abs(i-j)+1],300,'L',true,'');
    end
    else
    if (Correlation <> '') and DrawHBLegend and (uppercase(Correlation)<>'DETAIL')then
    begin
      bg:=  GetShade([0, 0.4, 0],'rg'); //'0 .7 0 rg'#10;
      LegendPos := ColPos[CurCol]-HBarLength*0.5;
      LegendWidth := round(FirstCompPos - (LegendPos + 35));

      if UseHbarLegend then
         s:=s+hbar(LegendPos,y,10,20,bg);

      if UseHbarLegend then
        s:=s+TextAt(LegendPos+35,y,'Helvetica',fs,Correlation, LegendWidth,'L',true,'')
      else
        s:=s+TextAt(ColPos[CurCol],y,'Helvetica',fs,Correlation, round(HBarLength*2),'C',true,'');
      //s:=s+TextAt(205,y+fs,'Helvetica',fs,'Highest correlation with',300,'L',true);
      DrawHBLegend:=False;
    end
  end;
  result:=s;
end;



function HeaderChanged(L1,L2:array of string):boolean;
var i :integer;
begin
  for i:=low(l1) to high(l1) do
  begin
    result:=l1[i]<>l2[i];
    if result then break;
  end;
end;


end.
