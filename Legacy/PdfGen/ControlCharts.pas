unit ControlCharts;

interface
uses comobj,sysutils,textmeasure,constants,divlines,Graphics,classes,drawing;

function Cntrl(var y:double;PageNumber:integer;cn:variant;Job_id:string;Section:string;CompDetail:variant):string;

implementation
  procedure DecTimePoint(var d:tdatetime;dectype:string;cnt:integer);
  const DaysPerMonth: array[1..12] of Integer =
        (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  var dtype:char;
      year,month,day:Word;
      i,j:integer;
  begin
    for i:= 1 to cnt do
    begin
      decodedate(d,year,month,day);
      if isLeapYear(year) then inc(DaysPerMonth[2]);
      dtype:=upcase(dectype[1]);
      case dtype of
        'D': d:=d-1;
        'W': d:=d-7;
        'M': d:=d-DaysPerMonth[month];
        'Q': for j:= 1 to 3 do
             begin
               DaysPerMonth[2]:=28;
               decodedate(d,year,month,day);
               if isLeapYear(year) then inc(DaysPerMonth[2]);
               d:=d-DaysPerMonth[month];
             end;
      end;
    end;
  end;



  function Cntrl(var y:double;PageNumber:integer;cn:variant;job_id:string;Section:string;CompDetail:variant):string;
  const PreriodColor : array [-1..9] of tcolor = (clblack,0,clOlive,clMaroon,clNavy,clTeal,clLime,clPurple,clRed,clRed,clRed);
        PeriodShape : array [-1..9] of string = ('','','1','2','3','4','5','6','7','8','9' );
        lx: array [-3..10] of double =(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  var save_np : array [1..12] of string;
      LastDataPoint,new_point :tdatetime;
      //dtFormats:array[1..4] of string =('yyyy','q yyyy','mmm yyyy','m/d/yyyy';
      rs:variant;
      datestr,DataPointTime,CustomTimeIncrement, s,s1,sql,s2:string;
      CustomTimeNumber,j,i,k:integer;
      l,h,x:double;
      componentid,ymax,ymin:integer;
      fs,xlabeldist:double;
      ylabeldist:double;
      xPoints:array [1..12] of double;
      prevx,prevy:double;
      thisx,thisy:double;
      x_bar,lower_cl,upper_Cl,Min_Lower_cl,Max_Upper_Cl:double;
      HasMeanLine:boolean;
      HasControlLimits:boolean;
      r, BaseY:double;
      NumberOfLegends:integer;
      strMeanLines,strLines,strTrendLines,strDataLabels:string;
      strTrendLines2:string;
      strWarningLown:string;
      strWarningExeedsSDCL:string;            
      x1:double;
      CurrentColor:tcolor;
      LegendList:tStringList;
      strValueFormat:string;
      ComponentXY : array [1..6,1..2] of double;
      ExceedSdCl : boolean;
      LowNSize : boolean;
      ChartType:integer;
      strShape:string;
      strColor:string;
      PreviousDataPoint:integer;

  begin
    ComponentXY[1,2] :=  7.3*inch;
    ComponentXY[2,2] :=  ComponentXY[1,2];
    ComponentXY[3,2] :=  ComponentXY[1,2] - (inch*3);
    ComponentXY[4,2] :=  ComponentXY[3,2];
    ComponentXY[5,2] :=  ComponentXY[3,2] - (inch*3);
    ComponentXY[6,2] :=  ComponentXY[5,2];

    LegendList := tStringList.Create;
    result:='';
    s:='';
    try
    rs :=CreateOleObject('ADODB.Recordset');
    while (not Compdetail.eof) do
    begin

      for i := 1 to high(ComponentXY) do
         ComponentXY[i,1] := LeftMargin+((i-1) mod 2 * ((PageWidth*0.5)-22))+inch*0.25;
      h:=inch*2;
      componentid:=strtoint(trim(vartostr(CompDetail.fields['component_id'].value)));

      //determine high and low limits of y axis;
      sql:=format('select ceiling(max(cast(value as decimal(5,1)))/10)*10 as ymax, '+
                 'floor(min(cast(value as decimal(5,1)))/10)*10-10 as ymin,'+
                 'isNull(max(Upper_CL),0) as Max_Upper_CL,'+
                 'isNull(min(Lower_CL),0) as Min_Lower_CL '+
                 'from apo_CntlFinalDetailCurrent '+
                'where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:d',
                [job_id,PageNumber,componentid]);

      sql:=format('select '+
                  'ceiling(max(cast(value as decimal(5,1)))/10)*10 as ymax, '+
                  'floor(min(cast(value as decimal(5,1)))/10)*10-10 as ymin, '+
                  'isNull(max(Upper_CL),0) as Max_Upper_CL, '+
                  'isNull(min(Lower_CL),0) as Min_Lower_CL '+
                  'from '+
                  '(select distinct '+
                  'value, '+
                  'Upper_CL, '+
                  'Lower_CL '+
                  'from apo_CntlFinalDetailCurrent '+
                  'where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:d' +
                  'union all '+
                  'select distinct '+
                  'value, '+
                  'null as Upper_CL, '+
                  'null as Lower_CL '+
                  'from apo_CntlFinalDetailComparison '+
                  'where Job_id = ''%0:s'' and page_number=%1:d and component_id = %2:d) as a ',
                  [job_id,PageNumber,componentid]);

      rs:=cn.execute(sql);

      Min_lower_cl := rs.fields['Min_lower_cl'].value;
      Max_upper_cl := rs.fields['Max_upper_cl'].value;

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

      sql:=format('select '+
                 'case DateStyle when 1 then datename(yy, new_point) '+
	         'when 2 then ''Q''+datename(q, new_point) +'' ''+ datename(yy, new_point) '+
		 'when 3 then upper(cast(datename(mm, new_point) as varchar(3))) +'' ''+ datename(yy, new_point) '+
		 'when 4 then cast(datepart(mm, new_point) as varchar(2))+''/''+datename(dd, new_point)+''/'' + datename(yy, new_point) '+
                 'end as New_Point, '+
                 'case ValueFormat when 1 then ''0'' '+
	         'when 2 then ''0.0'' '+
		 'when 3 then ''0.0%%'' '+
                 'end as ValueFormat, '+
                 'isnull(ShowCenterLine,0) as HasMeanLine,'+
                 'isnull(ShowControlLimits,0) as HasControlLimits,'+
                 'isnull(ChartType,1) as ChartType,'+
                 'QuestionLabel as qlabel,'+
                 'Scale_description as _scale_description,'+
                 'isnull(X_Bar,-999.0) as _x_bar '+
                 'from %0:s f inner join APO_CntlFinalInterval i on f.job_id = i.job_id and f.Page_number = i.Page_number and f.Component_id = i.Component_id '+
                 'where f.Job_ID=%1:s '+
                 'and f.Page_Number=%2:d '+
                 'and f.Component_ID=%3:d and f.job_id = %1:s '+
                 'order by Interval_id',
                 [cntl_final,job_id,PageNumber,componentid]);

      rs.open(sql,cn,2,2);

      if not(rs.eof and rs.bof) then
      begin
        HasMeanLine := rs.fields['HasMeanLine'].value;
        HasControlLimits := rs.fields['HasControlLimits'].value;
        ChartType := rs.fields['ChartType'].value;

        x_bar    := rs.fields['_x_bar'].value;
        strValueFormat:=rs.fields['ValueFormat'].value;

        if HasControlLimits then
        begin
          if ymax <= ymin then
            ymax := ymin+10;
          if Min_lower_cl < ymin then
            if Min_Lower_cl < 0 then
              ymin := -round(int((abs(Min_lower_cl)+10) * 0.1)*10)
            else
              ymin := round((int(Min_lower_cl/10) *10));

          if Max_upper_cl > ymax then
            ymax := round((Max_upper_cl/10)+0.5)*10;
        end
        else
        begin
          if ymax <= ymin then
            ymax := ymin+50;
          if ymax<=100 then ymax:=100;
          if ymin>=50 then ymin:=50;
        end;

        r:=h/ymax;

        //here is where we build our chart(s)...
        x:=ComponentXY[Componentid,1];
        y:=ComponentXY[Componentid,2];

        if section = 'MAIN' then
          l:=230
        else
          l:=pagewidth-120;

        s:=s+'.75 w'#10'1 j'#10;

        //draw graph rectangle
        s:=s+format('%g %g %g %g re s'#10,[x,y,l,h]);


        fs:=8;
        activefont:='/F1';
        h:=h-15;

        ylabeldist:=h/(ymax-ymin);

        thisy:=y+5;
        BaseY:=thisy+2.5;

        j:=0;
        //yaxis labels and tick marks
        strLines:='q .75 w 0.1 0.5 0.1 RG'#10'[3]1 d'#10;
        x1:=x+l-1;
        s:=s+'q 0 g'#10;
        for i:=ymin to ymax do
        begin
          //thisy:=Thisy+ylabeldist;
          inc(j);
          if i mod 10 = 0 then
          begin
            thisy:= basey + ((i-ymin)*ylabeldist);
            s:=s+format('%g %g m'#10'%g %g l s'#10,[x,ThisY,x-3,ThisY]);
            s:=s+TextAt(x-3,ThisY-fs*0.35,'',fs,inttostr(i),100,'R',false,'');
            strLines:=strLines+format('q %g %g m'#10'%g %g l s Q'#10,[x+1,ThisY,x1,ThisY]);
          end;
        end;

        strLines:=strLines+'Q'#10;

        if section = 'MAIN' then
        begin
          fs:=6;
          s:=s+Format('/F1 %f Tf 0 g'#10,[fs]);
        end;
        activefont:='/F1';

        //xaxis labels and tick marks
        xlabeldist:=l/12;
        x:=ComponentXY[Componentid,1]-xlabeldist;
        i:=1;
        rs.movefirst;
        for i:= high(xPoints) downto 1 do
        begin
          datestr:=vartostr(rs.fields['New_point'].value);
          x:= x+xlabeldist;
          xPoints[i]:=x+(xlabeldist/2);
          if section = 'MAIN' then
            s:=s+TextAt(xPoints[i],y-fs*1.5,'',fs,datestr,round(xlabeldist),'C',false,'')
          else
            s:=s+TextAt(xPoints[i],y-fs*1.5,'',fs,datestr,round(xlabeldist),'C',false,'');

          s:=s+format('%g %g m'#10'%g %g l s'#10,[xPoints[i],y,xPoints[i],y-3]);
          rs.movenext;
        end;

        rs.movefirst;


        if section = 'MAIN' then
        begin
          fs:=8;
          s:=s+Format('/F1 %f Tf 0 g'#10,[fs]);
        end;
      end;
      s:=s+'Q'#10;
      if not rs.eof then
      begin
        s1:=vartostr(rs.fields['qlabel'].value);
        s2:=vartostr(rs.fields['_scale_description'].value);

        thisx:=ComponentXY[Componentid,1];
        thisy:=ComponentXY[Componentid,2]+h+20;
        prevx:=GetTextWidth(s1,'',fs);
        if s1 = '' then
           s1:= 'Unknown Question or Theme';

        s1:=TextAt(thisx+l/2,Thisy+fs,'',fs,s1,500,'CU',false,'');

        if s2 = '' then s2:= 'Unable to match scale';

        s2:=TextAt(thisx+l/2,thisy,'',fs,s2,500,'C',false,'');

        thisx:=(thisx+l*0.5)-prevx*0.5;
        s:=s+s1+s2;
      end;
      i:=1;
      prevx:=0;prevy:=0;
      rs.close;
  //  'inner join APO_CntlFinalDetailComparison dc '+
//   'on c.job_id = dc.job_id and c.Page_number = dc.Page_number and c.Component_id = dc.Component_id  and c.ColumnType = dc.columnType '+


     //Get for Current period
      sql := format('select Value as value,'+
             //'case when  Lower_CL < 0 then 0 else isnull(Lower_CL,0) end as Lower_cl, '+
             //'case when Upper_CL  < 0 then 0 when Upper_CL > 100 then 100 else isnull(Upper_CL,0) end as Upper_cl, '+
             'isnull(Lower_CL,-999) as Lower_cl,' +
             'isnull(Upper_CL,-999) as Upper_CL,' +
             'isnull(ExceedSdCl,0) as ExceedSdCl,'+
             'isnull(LowNSize,0) as LowNSize,'+
             'c.ColumnType,'+
             'i.interval_id,'+
             'c.columnLabel '+
             'from APO_CntlFinal f '+
             'inner join APO_cntlFinalColumn c '+
             'on f.job_id = c.job_id and f.Page_number = c.Page_number and f.Component_id = c.Component_id '+
             'inner join APO_CntlFinalDetailCurrent d '+
             'on c.job_id = d.job_id and c.Page_number = d.Page_number and c.Component_id = d.Component_id '+
             'inner join APO_CntlFinalInterval i '+
             'on d.job_id = i.job_id and d.Page_number = i.Page_number and d.Component_id = i.Component_id and d.interval_id = i.interval_id '+
             'where f.job_id = %s and f.component_id = %d and f.Page_number = %d and c.ColumnType = 3 '+
             'order by c.ColumnType, i.Interval_ID',[job_id,componentid,PageNumber]);



      strTrendLines := format('q %0:s rg %0:s RG /F5 5 Tf .75 w'#10'1 j'#10,[getRGB(PreriodColor[3])]);
      strTrendLines2 := 'q 1 g /F5 7 Tf'#10;
      strWarningLown := 'q /F5 7 Tf 1 0 0 rg'#10;
      strWarningExeedsSDCL := 'q /F5 7 Tf 1 .5 0 rg'#10;
      fs:=6.0;
      strDataLabels:=format('q 0 g /F1 %f Tf ',[fs]);
      CurrentColor:=clBlack;
      j:=0;
      strMeanLines:='q 1.5 w 1 0 0 RG'#10'2 j'#10;
      ExceedSdCl := false;
      LowNSize := false;
      PreviousDataPoint :=0;
      rs.open(sql,cn,2,2);
      if not rs.eof then
      begin
        rs.movelast;
        while not rs.bof do //write data labels and draw trend lines
        begin
          if HasControlLimits then
          begin
            ExceedSdCl := rs.fields['ExceedSdCl'].value;
          end;

          LowNSize := rs.fields['LowNSize'].value;

          thisy:=y-ylabeldist*1.5;
          datestr:=getval(rs.fields['value'].value);
          i:=rs.fields['Interval_id'].value;
          if j <> rs.fields['ColumnType'].value then
          begin
            j:=rs.fields['ColumnType'].value;
          end;
          i:=12-i+1;

          inc(PreviousDataPoint);

          if strtofloat(datestr) >=0.0 then
          begin
            r:=strToFloat(datestr);
            datestr:= formatfloat(strValueFormat,round(r*10000)*0.0001);
           thisy:=basey + ((r-ymin)*ylabeldist);

          strDataLabels:=strDataLabels+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i]-(GetTextWidth(datestr,'',fs)*0.5),thisy+2,datestr]); //value label

            if LowNSize or ExceedSdCl then
            begin
              if LowNSize then
              begin
                 strWarningLowN:= strWarningLowN+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i]{-fs*0.35},thisy,'8']);
              end;
             // ExceedSdCl := boolean(random(5));
              if ExceedSdCl then
              begin
               strWarningExeedsSDCL:= strWarningExeedsSDCL+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i]{+fs*0.35},thisy,'9']);
            end;

            strTrendLines2:= strTrendLines2+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i],thisy,PeriodShape[3]]);

            end
            else
            strTrendLines:= strTrendLines+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i],thisy,PeriodShape[3]]);

            if (prevx>0) and (prevy>=0) and (i=PreviousDataPoint) then
            strTrendLines:=strTrendLines+format('q %g %g m'#10'%g %g l s Q'#10,[prevx,prevy,xPoints[i],thisy]); //draw line

            prevy := thisy;
          end
          else
          prevy := -1;

          PreviousDataPoint:=i;
          if HasControlLimits then
          begin
            Lower_Cl := rs.fields['Lower_Cl'].value;
            Upper_Cl := rs.fields['Upper_Cl'].value;

            if Lower_Cl <> -999 then
            begin
              thisy := basey + ((Lower_Cl-ymin)*ylabeldist);
              strMeanLines := strMeanLines+format('q %g %g m'#10'%g %g l s Q'#10,[xPoints[i]-2.5,thisy,xPoints[i]+2.5,thisy]); //draw line for Lower_CL
            end;
            if Upper_Cl <> -999 then
            begin
              thisy := basey + ((Upper_Cl-ymin)*ylabeldist);
              strMeanLines := strMeanLines+format('q %g %g m'#10'%g %g l s Q'#10,[xPoints[i]-2.5,thisy,xPoints[i]+2.5,thisy]); //draw line for Upper_CL
            end
          end;

          prevx:=xPoints[i];

          rs.moveprevious;
          //inc(i);
          end;
      end;
      rs.close;

      strTrendLines :=   strTrendLines +'Q'#10{+strTrendLines2+'Q '#10};
      NumberOfLegends:=1;

      ////////////////////////////////////////////



      if (HasControlLimits) and ((Max_upper_cl <=  ymax) ) then
      begin
        NumberOfLegends := NumberOfLegends+1;
      end;

      if HasMeanLine then
      begin
        if x_bar >0 then
        begin
          strMeanLines := strMeanLines+format('q 0 G %g %g m'#10'%g %g l s Q'#10,[prevx,basey + ((x_bar-ymin)*ylabeldist),x1,basey + ((x_bar-ymin)*ylabeldist)]);
          NumberOfLegends := NumberOfLegends+1;
        end;
      end;


     //Get Comparison Data

     sql := format('SELECT  c.ColumnType,'+
            'i.interval_id,'+
            'c.ColumnLabel,'+
            'd.Value '+
            'FROM APO_CntlFinalColumn AS c '+
            'INNER JOIN (APO_CntlFinalDetailComparison AS d '+
            'INNER JOIN APO_CntlFinalInterval AS i ON (d.Job_ID = i.Job_ID) '+
            'AND (d.AP_ID = i.AP_ID) AND (d.Page_Number = i.Page_Number) '+
            'AND (d.Component_ID = i.Component_ID) '+
            'AND (d.Interval_ID = i.Interval_ID)) ON (c.Job_ID = d.Job_ID) '+
            'AND (c.AP_ID = d.AP_ID) AND (c.Page_Number = d.Page_Number) '+
            'AND (c.Component_ID = d.Component_ID) '+
            'AND (c.ColumnType = d.ColumnType) '+
            'where d.job_id = %s and d.component_id = %d and d.Page_number = %d  and c.ColumnType <> 3 '+
            'order by c.ColumnType, i.Interval_ID ',[job_id,componentid,PageNumber]);


      rs.open(sql,cn,2,2);
      if not rs.eof then
         rs.movelast;


      strTrendLines2 := 'q /F5 5 Tf .75 w'#10'1 j'#10;
      CurrentColor := clGray;
      fs:=6.0;
      j := 0;
      while not rs.bof do //draw comparison trend lines
      begin
        thisy := y-ylabeldist*1.5;
        datestr := getval(rs.fields['Value'].value);
        i := rs.fields['Interval_id'].value;
        if j <> rs.fields['ColumnType'].value then
        begin
          j := rs.fields['ColumnType'].value;
        end;
        i := 12-i+1;
        if strtofloat(datestr) >=0.0 then
        begin
          r := strToFloat(datestr);
          datestr := formatfloat(strValueFormat,round(r*10000)*0.0001);
          thisy := basey + ((r-ymin)*ylabeldist);
          if CurrentColor <> PreriodColor[j] then
          begin
            CurrentColor := PreriodColor[j];
            strTrendLines2 := strTrendLines2+Format('BT %0:s rg %1:g %2:g Td(%3:s)'' ET'#10,[getRGB(PreriodColor[j]),xPoints[i],thisy,PeriodShape[j]]);
            strTrendLines2 := strTrendLines2+format('%s RG'#10,[getRGB(PreriodColor[j])]); //draw line
            prevy := -1;
          end
          else
          begin
            strTrendLines2 := strTrendLines2+Format('BT %g %g Td(%s)'' ET'#10,[xPoints[i],thisy,PeriodShape[j]]);
            if (prevx>0) and (prevy>=0) then
              strTrendLines2 := strTrendLines2+format('q %g %g m'#10'%g %g l s Q'#10,[prevx,prevy,xPoints[i],thisy]); //draw line
          end;
          prevy := thisy;
        end
        else
          prevy := -1;

        
        prevx := xPoints[i];

        rs.moveprevious;
        //inc(i);
      end;

      rs.close;


      ///////////////////////////////////////////




      strMeanLines := strMeanLines+'Q'#10;
      strTrendLines2 := strTrendLines2 +'Q'#10;
      //strTrendLines := strTrendLines +'Q'#10;
      strDataLabels := strDataLabels +'Q'#10;
      strWarningLowN := strWarningLowN +'Q'#10;
      strWarningExeedsSDCL := strWarningExeedsSDCL +'Q'#10;

      s := strLines+strMeanLines+strTrendLines+strTrendLines2+
           strWarningLowN+strWarningExeedsSDCL+strDataLabels+s;


      //////////////////////////// BUILD LEGENDS HERE //////////////////////////////////

      y := y-35;
      for i := 1 to high(ComponentXY) do
         ComponentXY[i,1] := LeftMargin+((i-1) mod 2 * ((PageWidth*0.5)-22));


      if section = 'MAIN' then
      begin
        y := ComponentXY[Componentid,2];
        y := y-40;
 //       s:=s+DivLine(y);
        y := y+15;
      end;
      LegendList.Clear;

      if HasMeanLine then
        if x_bar >0 then
          LegendList.Add('-1=Mean');

      LegendList.Add('8=Warning! Low n');

      if ((ChartType = 1) and HasControlLimits)  then
         LegendList.Add('9=Exceeds SDCL');


      if HasControlLimits then
      begin
        LegendList.Add('0=Upper/Lower Limits');
      end;

      //determine if we have any comparison columns to build legend
      sql := format('select distinct '+
               'ColumnType,'+
               'columnLabel '+
               'from APO_cntlFinalColumn '+
               'where job_id = %s and component_id = %d and Page_number = %d '+
               'order by ColumnType',[job_id,componentid,PageNumber]);

      fs := 8;
      rs.open(sql,cn,2,2);
      i := LegendList.count;
      while not rs.eof do
      begin
        LegendList.Add(vartostr(rs.fields['ColumnType'].value)+'='+trim(vartostr(rs.fields['columnLabel'].value)));
        rs.movenext;
      end;

      rs.close;
      k:=-1;
      lx[k]:=0;
      x := 0;
      for i := 0 to LegendList.count-1 do
      begin
        s1 := LegendList.Values[LegendList.names[i]];
        lx[i] := GetTextWidth(s1 ,'',fs)+inch * 0.30;
        if x+lx[i] > l then
        begin
          x := 0;
          dec(k);
        end;
        x := x+lx[i];
        lx[k] := ComponentXY[Componentid,1]+((l-x)*0.5);

      end;

      //////////////////////////////////////////

      strTrendLines:='q /F5 8 Tf 1 w'#10'2 j'#10;
      strDataLabels:=format('q %s rg /F1 %f Tf ',[getRGB(clBlack),fs]);
      k := -1;
      x := 0;
      thisx := 0;
      for i := 0 to LegendList.Count-1 do
      begin

        j := strtointdef(LegendList.names[i],-2);
        if (j+2 in[1..11]) then
          strColor := getRGB(PreriodColor[j]);

        if j=9 then  strColor := '1 .5 0';

        strShape := trim(LegendList.names[i]);
        s1 := LegendList.Values[LegendList.names[i]];
        if thisx+lx[i] > l then
        begin
          thisx := 0;
          x := 0;
          dec(k);
          y := y-fs;
        end;
        thisx := thisx+lx[i];
        x := lx[k]+thisx-lx[i];

        try

          strDataLabels := strDataLabels+Format('BT %g %g Td(%s)'' ET'#10,[x+inch*0.22,y,s1]);  //label
          if not (j+1 in [0,4,5,6,7,8]) then
            x := x+inch*0.15;
          case j of
            -1:begin
               strTrendLines := strTrendLines+format('q %s RG %g %g m'#10'%g %g l s Q'#10,[strColor,x,y+fs*0.5,x+inch*0.2,y+fs*0.5]); //draw line
            end;
            0: begin
                 strTrendLines := strTrendLines+format('q 1.5 w 1 0 0 RG'#10'%g %g m %g %g l s Q'#10,[x,y,x+4,y]);//Upper/Lower Limits
               end;
            1,2,3,4,5,6,7:begin
                strTrendLines := strTrendLines+Format('BT %0:s rg %1:g %2:g Td(%3:s)'' ET'#10,[strColor,x+inch*0.1,y+fs*0.5,strShape]); //shape
                strTrendLines := strTrendLines+format('q %s RG %g %g m'#10'%g %g l s Q'#10,[strColor,x,y+fs*0.5,x+inch*0.2,y+fs*0.5]); //draw line
              end;
            8,9 : strTrendLines := strTrendLines+Format('BT %0:s rg %1:g %2:g Td(%3:s)'' ET'#10,[strColor,x,y+fs*0.5,strShape]); //shape

          end;

        finally
        end;
      end;

      strDataLabels := strDataLabels+'Q'#10;
      strTrendLines := strTrendLines+'Q'#10;
      s:=s+strDataLabels+strTrendLines;

      //////////////////////////////////////////////////////////////////////////////////


      if (section <> 'MAIN')  then break;
      CompDetail.movenext;
    end;
    s := s+DivLine(inch*0.7);
    except
      s := textat( pagewidth*0.5,y,'',50,'Unable to generate Control Chart',200,'C',true,'');
    end;

    rs := unassigned;
    LegendList.Free;

    /////////////////////////////////////////////

    //s:=s+'q'#10+DataPointTime+CustomTimeIncrement+textat( x+thisy,y,Arial,fs,datestr,200,'C',false);



//    AP0330306030000


    y:=y+20;
    result:=s;

  end;



end.
