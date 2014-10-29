 unit PlotCharts;
 
{*******************************************************************************
Program Modifications:
--------------------------------------------------------------------------------
Date        UserId   Description
-------------------------------------------------------------------------------
05-02-2006   GN01    Fixed the SQL that determines high and low limits of y axis
*******************************************************************************}

interface
uses comobj,sysutils,textmeasure,constants,divlines,Graphics,classes,drawing;
function PlotChart(var y:double;job_id:string;componentid:string;PageNumber:integer;cn:variant):string;

implementation

  procedure DrawBoxPlot(x,BaseY,ymin,ylabeldist,w,avg,pc10,pc25,pc50,pc75,pc90:double;pPlotBoxes,pMeanLines,pPc50:Pointer);
  var thisy,h:double;
      strpPlotBoxes,strpMeanLines,strpPc50: ^string;
  begin
    strpPlotBoxes:= pPlotBoxes;
    strpMeanLines:= pMeanLines;
    strpPc50:=pPc50;
    //draw horizontal line for 10th percentile
    thisy := basey + ((Pc10-ymin)*ylabeldist);
    strpPlotBoxes^ := strpPlotBoxes^ + format('%g %g m'#10'%g %g l s'#10,[x-w*0.5,thisy,x+w*0.5,thisy]);

    //draw vertical line from 10th to 25th percentile
    h := basey + ((Pc25-ymin)*ylabeldist);
    strpPlotBoxes^ := strpPlotBoxes^ + format('%g %g m'#10'%g %g l s'#10,[x,thisy,x,h]);

    //draw rectangle for plot box
    thisy := h;
    h := basey + ((Pc75-ymin)*ylabeldist);
    strpPlotBoxes^ := strpPlotBoxes^ + format('%g %g %g %g re b'#10,[x-w*0.5,thisy,w,h-thisy]);
    //strPlotBoxes := strPlotBoxes + format('%g %g %d %g re s'#10,[x-5,thisy,10,h-thisy]);

    //draw vertical line from 75th to 90th percentile
    thisy := h;
    h := basey + ((Pc90-ymin)*ylabeldist);
    strpPlotBoxes^ := strpPlotBoxes^ + format('%g %g m'#10'%g %g l s'#10,[x,thisy,x,h]);

    //draw horizontal line for 90th percentile
    thisy := basey + ((Pc90-ymin)*ylabeldist);
    strpPlotBoxes^ := strpPlotBoxes^ + format('%g %g m'#10'%g %g l s'#10,[x-w*0.5,thisy,x+w*0.5,thisy]);

    //draw mean
    if Not (strpMeanLines = nil) then
    begin
      thisy := basey + ((avg-ymin)*ylabeldist);
      strpMeanLines^ := strpMeanLines^ + format('%g %g %d %g re f'#10,[x-2.5,thisy-2.5,5,5.0]);
    end;

    //draw 50th Percentile
    if not (strpPc50 = nil) then
    begin
      thisy := basey + ((Pc50-ymin)*ylabeldist);
      strpPc50^ :=  strpPc50^ + format('%g %g m'#10'%g %g l s'#10,[x-2,thisy,x+2,thisy]);
      strpPc50^ :=  strpPc50^ + format('%g %g m'#10'%g %g l s'#10,[x,thisy-2,x,thisy+2]);
    end;
  end;

  function PlotChart(var y:double;job_id:string;componentid:string;PageNumber:integer;cn:variant):string;
  const lx: array [-3..10] of double =(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  var save_np : array [1..12] of string;
      strPlotBoxesArray : array [0..1] of string;
      rs:variant;
      datestr, s,s1,sql,s2:string;
      j,i,k:integer;
      l,h,x,w:double;
      ymax,ymin:integer;
      fs,xlabeldist:double;
      ylabeldist:double;
      xPoints:array [1..12] of double;
      prevx,prevy:double;
      thisx,thisy:double;
      x_bar:double;
      r, BaseY:double;
      NumberOfLegends:integer;
      NumberOfQuestions:integer;
      strMeanLines,strLines,strTrendLines,strPlotBoxes, strPc50,
      strCurrDataPoints,strCompDataPoints,strDataLabels:string;
      x1:double;
      CurrentColor:tcolor;
      LegendList:tStringList;
      strValueFormat:string;
      strMeasureTypeLabel:string;
      QuestionLabel:string;
      avg  : double;
      Pc10 : double;
      Pc25 : double;
      Pc50 : double;
      Pc75 : double;
      Pc90 : double;
      ChartTitle : String;
      LowestLabelPos:double;
      LegendLeft:double;
      ReverseScale:boolean;

  begin

    LegendList := tStringList.Create;
    LegendLeft := inch*1.5;
    result:='';
    s:='';
    //ChartTitle := TextAt(PageWidth*0.5,y, 'Helvetica',10.0,'Your Clinic Compared to All Specialty Care Departments',PageWidth,'C',False)
    try

      rs :=CreateOleObject('ADODB.Recordset');

      //determine high and low limits of y axis;
      {GN01:
      sql:=format('select ceiling(max(cast(value as decimal(5,1)))/10)*10 as ymax, '+
                 'floor(min(cast(value as decimal(5,1)))/10)*10-10 as ymin from %0:s '+
                'where Job_id = ''%1:s'' and page_number=%2:d and component_id = %3:s',
                ['APO_BoxPlotFinalDetailCurrentPeriod',job_id,PageNumber,componentid]);
      }
      sql:=format('select ceiling(max(cast(value as decimal(5,1)))/10)*10 as ymax,' +
       ' floor(min(cast(value as decimal(5,1)))/10)*10-10 as ymin ' +
       ' from (                                                     ' +
       '  select Value                                              ' +
       '    from APO_BoxPlotFinalDetailCurrentPeriod                ' +
       '   where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:s ' +
       '                                                            ' +
       '  UNION ALL                                                 ' +
       '                                                            ' +
       '  select Percentile10th * 100                               ' +
       '    from APO_BoxPlotFinalDetailComparison                   ' +
       '   where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:s ' +
       '                                                            ' +
       '  UNION ALL                                                 ' +
       '                                                            ' +
       '  select Percentile90th * 100                               ' +
       '    from APO_BoxPlotFinalDetailComparison                   ' +
       '   where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:s ' +
       ' ) A                                                        ',
       [job_id,PageNumber,componentid]);

      rs:=cn.execute(sql);
      if not varisnull(rs.fields['ymin'].value)   then
       ymin := rs.fields['ymin'].value
      else
        ymin:=50;
      if not varisnull(rs.fields['ymax'].value)   then
       ymax := rs.fields['ymax'].value
      else
        ymax:=110;

      if ymin<0 then ymin:=0;
      rs.close;

      sql := format('select MeasureTypeLabel,'+
                 'ValueFormat,' +
                 'ReverseScale '+
                 'from APO_BoxPlotFinal '+
                 'where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:s',
                 [job_id,PageNumber,componentid]);

      rs.open(sql,cn,2,2);

      if not(rs.eof and rs.bof) then
      begin
        ReverseScale := rs.fields['ReverseScale'].value;
        strValueFormat:=rs.fields['ValueFormat'].value;
        strMeasureTypeLabel:=rs.fields['MeasureTypeLabel'].value;

        rs.close;

        sql := format('select QuestionLabel, '+
                 'Sequence '+
                 'from APO_BoxPlotFinalQuestion '+
                 'where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:s '+
                 'order by sequence',
                 [job_id,PageNumber,componentid]);

        rs.Open(sql,cn,1,1);

        fs:=8;
        x:=LeftMargin+GetTextWidth('100',Arial,fs)+5;
        l:=pagewidth-x-LeftMargin;

        xlabeldist:=1;
        if not rs.eof then
        begin
          rs.movelast;
          NumberOfQuestions := rs.recordcount;
          rs.movefirst;
          xlabeldist:=l/NumberOfQuestions;
        end;


        if ymax<=100 then ymax:=100;
        if ymin>=50 then ymin:=50;
        r:=h/ymax;

        //Start drawning Plot Chart
        s:=s+'.75 w'#10'0 j 0 J'#10;
        fs:=15;
        y:=y-fs*0.5;
        s:=s+TextAt(PageWidth*0.5,y-fs,Arial,fs,strMeasureTypeLabel,round(PageWidth*0.5),'C',false,'/F2');
        y:=yGlobal+fs*0.5;
        h:=inch*2;
        y:=y-inch*2;

        fs:=8;

        //draw graph rectangle for chart
        s:=s+format('%g %g %g %g re s'#10,[x,y,l,h]);


        activefont:='/F1';
        h:=h-15;
        ylabeldist:=h/(ymax-ymin);

        thisy:=y+5;
        BaseY:=thisy+2.5;

        j:=0;

        //yaxis labels and tick marks
        strLines:='q .75 w 0.1 0.5 0.1 RG'#10'[3]1 d'#10;
        x1:=x+l-1;
        for i:=ymin to ymax do
        begin
          //thisy:=Thisy+ylabeldist;
          inc(j);
          if i mod 10 = 0 then
          begin
            thisy:= basey + ((i-ymin)*ylabeldist);
            s:=s+format('%g %g m'#10'%g %g l s'#10,[x,ThisY,x-3,ThisY]);
            s:=s+TextAt(x-5,ThisY-fs*0.35,Arial,fs,inttostr(i),100,'R',false,'');
            strLines:=strLines+format('%g %g m'#10'%g %g l s'#10,[x+1,ThisY,x1,ThisY]);
          end;
        end;
        strLines:=strLines+'Q'#10;

        activefont:='/F1';
        //xaxis labels and tick marks
        x:=(LeftMargin-xlabeldist)+10;
        LowestLabelPos := y;
        While not rs.eof do
        begin
          i:=strtointdef(vartostr(rs.fields['sequence'].value),0);
          datestr := vartostr(rs.fields['QuestionLabel'].value);
          x:= x+xlabeldist;
          xPoints[i]:=x+(xlabeldist*0.5);
          s:=s+Format('%g %g m'#10'%g %g l s'#10,[xPoints[i],y,xPoints[i],y-3]);
          s:=s+TextAt(xPoints[i],y-fs*1.5,Arial,fs,datestr,round(xlabeldist),'C',false,'');

          if LowestLabelPos > yGlobal then LowestLabelPos := yGlobal;

          rs.movenext;
        end;



      end;



      i:=1;
      prevx:=0;prevy:=0;

      rs.close;

             {
      sql := format('select Value '+
             'f.Sequence,'+
             'SubGroupOrder_ID, '+
             'Avg, '+
             'Percentile10th, '+
             'Percentile25th, '+
             'Percentile50th, '+
             'Percentile75th, '+
             'Percentile90th '+
             'from APO_BoxPlotFinalDetailCurrentPeriod f '+
             'inner join APO_BoxPlotFinalComparison c
             'on f.job_id = c.job_id and f.Page_number = c.Page_number and f.Component_id = c.Component_id '+
             'where f.job_id = %s and f.component_id = %s and f.Page_number = %d '+
             'order by sequence',[job_id,componentid,PageNumber]);
              }
      sql := format('select Value, '+
             'Sequence '+
             'from APO_BoxPlotFinalDetailCurrentPeriod f '+
             'where f.job_id = %s and f.component_id = %s and f.Page_number = %d '+
             'order by sequence',[job_id,componentid,PageNumber]);


      rs.open(sql,cn,2,2);

      strCurrDataPoints:=format('q 0 g /F5 5 Tf 1.5 w'#10'0 j 0 J'#10,[fs]);
      fs:=6.0;
      strDataLabels:=format('q %s rg /F1 %f Tf ',[getRGB(clBlack),fs]);
      CurrentColor:=clBlack;
      j:=0;

      while not rs.eof do //write data labels and draw trend lines
      begin

        datestr:=getval(rs.fields['value'].value);
        i:=rs.fields['Sequence'].value;

        if strtofloat(datestr) >=0.0 then
        begin
          r:=strToFloat(datestr);
          //datestr:= formatfloat(strValueFormat,round(r*10000)*0.0001);
          thisy:=basey + ((r-ymin)*ylabeldist);
          // strDataLabels:=strDataLabels+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i]-(GetTextWidth(datestr,Arial,fs)*0.5),thisy+2,datestr]);
          strCurrDataPoints:= strCurrDataPoints+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i],thisy,'3']);
          if (prevx>0) and (prevy>=0) then
             strCurrDataPoints:=strCurrDataPoints+format('%g %g m'#10'%g %g l s'#10,[prevx,prevy,xPoints[i],thisy]); //draw line

          prevy:=thisy;
        end
        else
          prevy:=-1;
        prevx:=xPoints[i];

        rs.movenext;
      end;

      rs.close;

      strCurrDataPoints := strCurrDataPoints + 'Q'#10+strDataLabels+'Q'#10;

      sql := format('select distinct '+
               'Sequence,'+
               'SubGroupOrder_ID, '+
               'Avg * 100 as Avg, '+
               'Percentile10th * 100 as Pc10, '+
               'Percentile25th * 100 as Pc25, '+
               'Percentile50th * 100 as Pc50, '+
               'Percentile75th * 100 as Pc75, '+
               'Percentile90th * 100 as Pc90 '+
               'from APO_BoxPlotFinalDetailComparison '+
               'where job_id = %s and component_id = %s and Page_number = %d '+
               'order by SubGroupOrder_ID,Sequence',[job_id,componentid,PageNumber]);

      rs.open(sql,cn,1,1);
      strPlotBoxes := 'q 0 G .75 w'#10'0 j 0 J'#10;
      strPlotBoxesArray[0] := 'q 0 .6 0 rg'#10;
      strPlotBoxesArray[1] := 'q 1.3 1.3 .6 rg'#10;
      strMeanLines := 'q .8 .8 .8 rg 0 w'#10'0 j 0 J'#10;
      strPc50 := 'q 1 G 0.75 w'#10'0 j 0 J'#10;

      while not rs.eof do //Draw all Plot Boxes
      begin

        j := rs.fields['SubGroupOrder_ID'].value;
        i:=rs.fields['sequence'].value;

        j := j-1;
        x := xPoints[i] + 10;
        x := x - (j*20);

        avg  := strToFloat(getval(rs.fields['Avg'].value));
        Pc10 := strToFloat(getval(rs.fields['Pc10'].value));
        Pc25 := strToFloat(getval(rs.fields['Pc25'].value));
        Pc50 := strToFloat(getval(rs.fields['Pc50'].value));
        Pc75 := strToFloat(getval(rs.fields['Pc75'].value));
        Pc90 := strToFloat(getval(rs.fields['Pc90'].value));


        DrawBoxPlot(x,BaseY,ymin,ylabeldist,10,avg,pc10,pc25,pc50,pc75,pc90,@strPlotBoxesArray[j],@strMeanLines,@strPc50);


        rs.movenext;
      end;
      strMeanLines := strMeanLines+'Q'#10;
      strPc50 := strPc50+'Q'#10;
      strPlotBoxes := strPlotBoxesArray[0]+'Q'#10+strPlotBoxesArray[1]+'Q'#10+strMeanLines+strPc50;
      s:=strLines+strPlotBoxes+strCurrDataPoints+s;

      rs.close;

      NumberOfLegends:=1;


      //////////////////////////// BUILD LEGENDS HERE //////////////////////////////////

      y:=y-35;

      //////////////////////////////////////////

      strPlotBoxes := 'q 0 G .75 w'#10'0 j 0 J'#10;
      strPlotBoxesArray[0] := 'q 0 .6 0 rg'#10;
      strPlotBoxesArray[1] := 'q 1.3 1.3 .6 rg'#10;
      strLines := 'q 0 G .25 w'#10'0 j 0 J'#10;
      strMeanLines := 'q .8 .8 .8 rg 0 w'#10'0 j 0 J'#10;
      strPc50 := 'q 1 G 0.75 w'#10'0 j 0 J'#10;

      y:= LowestLabelPos-fs*1.5;


      x := LegendLeft+5;

      fs:=8;
      s:=s+TextAt(x,y,Arial,fs,'Box Plot',100,'L',false,'');
      s:=s+TextAt(x,y-fs,Arial,fs,'Description',100,'L',false,'');
      //fs:=5;
      x:=x+GetTextWidth('Description' ,Arial,fs)+15;

      avg  :=  -(fs*3.5);
      Pc10 :=  0.0;
      Pc25 :=  -(fs*1.5);
      Pc50 :=  -(fs*3.5);
      Pc75 :=  -(fs*5.5);
      Pc90 :=  -(fs*7);

      DrawBoxPlot(x,y,0,1,fs*2,avg,Pc10,Pc25,Pc50,Pc75,Pc90,@strPlotBoxesArray[1],nil,@strPc50);

      x := x+5;
      strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y,x+12,y]);
      strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y+Pc25,x+12,y+Pc25]);
      strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y+Pc50,x+12,y+Pc50]);
      strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y+Pc75,x+12,y+Pc75]);
      strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y+Pc90,x+12,y+Pc90]);

      x:=x+15;
      if ReverseScale then
      begin
        s:=s+TextAt(x,y+Pc10-fs*0.35,Arial,fs,'10th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc25-fs*0.35,Arial,fs,'25th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc50-fs*0.35,Arial,fs,'50th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc75-fs*0.35,Arial,fs,'75th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc90-fs*0.35,Arial,fs,'90th percentile',100,'L',false,'');
      end
      else
      begin
        s:=s+TextAt(x,y+Pc10-fs*0.35,Arial,fs,'90th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc25-fs*0.35,Arial,fs,'75th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc50-fs*0.35,Arial,fs,'50th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc75-fs*0.35,Arial,fs,'25th percentile',100,'L',false,'');
        s:=s+TextAt(x,y+Pc90-fs*0.35,Arial,fs,'10th percentile',100,'L',false,'');
      end;

      x:=x+GetTextWidth('90th percentile' ,Arial,fs)+30;
      //fs := 8;

      x:=x+GetTextWidth('LEGEND' ,Arial,fs);

      //determine if we have any comparison columns to build legend
      sql := format('select distinct '+
               'SubGroupOrder_ID, '+
               'UnitGroupLabel '+
               'from APO_BoxPlotFinalComparison '+
               'where job_id = %s and component_id = %s and Page_number = %d '+
               'order by SubGroupOrder_ID desc',[job_id,componentid,PageNumber]);

      fs:= 8;
      rs.open(sql,cn,1,1);
      if not rs.eof then
      begin
        rs.movelast;
        rs.movefirst;
      end;

      w := (PageWidth - x - (LegendLeft))/(rs.recordcount+1);

      k := -1;
      x := x+w*0.5;

      s:=s+Format('q /F2 %g Tf BT %g %g Td(%s)'' ET Q'#10,[fs,x-fs*2-GetTextWidth('LEGEND' ,Arial,fs),y,'LEGEND']);

      thisx:=0;

      j:=0;
      while not rs.eof do
      begin
        i := rs.fields['SubGroupOrder_ID'].value-1;
        s:=s+textat(x,y+(pc90-fs),Arial,fs,trim(vartostr(rs.fields['UnitGroupLabel'].value)),round(w-fs),'C',false,'');
        if LowestLabelPos > yGlobal then LowestLabelPos := yGlobal;
        if j = 0 then
        begin
          s:=s+textat(x+w*0.5,y+(pc50-fs*0.35),Arial,fs,'Mean',round(w-fs),'C',false,'');
          strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y+Pc50,((x+w*0.5)-GetTextWidth('Mean' ,Arial,fs)*0.5)-2 ,y+Pc50]);
        end
        else
         strLines := strLines+format('%g %g m'#10'%g %g l s'#10,[x,y+Pc50,((x-w*0.5)+GetTextWidth('Mean' ,Arial,fs)*0.5)+2 ,y+Pc50]);

        DrawBoxPlot(x,y,0,1,fs*2,avg,Pc10,Pc25,Pc50,Pc75,Pc90,@strPlotBoxesArray[i],@strMeanLines,nil);
        x:=x+w;
        inc(j);
        rs.movenext;
      end;
      rs.close;


      s:= s+Format('q 0 g /F5 16 Tf BT %g %g Td(%s)'' ET Q'#10,[x,y+pc50,'3']); //draw a circle for Your Module;

      strTrendLines:=strTrendLines+format('%s RG %g %g m'#10'%g %g l s'#10,[getRGB(clBlack),x,y+fs*0.5,x+inch*0.2,y+fs*0.5]); //draw line

      s:=s+textat(x,y+(pc90-fs),Arial,fs,'Current Period',round(w-fs),'C',false,'');
      if LowestLabelPos > yGlobal then LowestLabelPos := yGlobal;

      w := PageWidth - LegendLeft * 2;


      s := s + format('q 0 G .25 w'#10'0 j 0 J'#10'%g %g %g %g re s Q'#10,[LegendLeft,LowestLabelPos+fs*0.5,w,(y-LowestLabelPos)+fs]);


      y := LowestLabelPos;

      strMeanLines := strMeanLines+'Q'#10;
      strLines := strLines+'Q'#10;
      strPc50 := strPc50+'Q'#10;
      strPlotBoxes := strPlotBoxesArray[0]+'Q'#10+strPlotBoxesArray[1]+'Q'#10+strMeanLines+strPc50;
      s:=s+strPlotBoxes+strLines+strMeanLines;

      //////////////////////////////////////////////////////////////////////////////////

      s:=s+DivLine(y);

      except
        s:=textat( pagewidth*0.5,y,Arial,30,'Error Creating Box Plot Chart',200,'C',false,'');
        y := yGlobal;
        s:=s+DivLine(y);
      end;

      rs:=unassigned;
      LegendList.Free;

      /////////////////////////////////////////////

      result:=s;

    end;

end.
