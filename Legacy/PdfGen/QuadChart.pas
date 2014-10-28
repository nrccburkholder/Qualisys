unit QuadChart;

interface

uses SysUtils,TextMeasure,constants,classes;

function quad(var y:double;PageNumber:integer;cn:variant;Job_id:string):string;

implementation
  function quad(var y:double;PageNumber:integer;cn:variant;Job_id:string):string;
  var s,s1,s2:string;
  xbar,ybar,yaxis:double;
  TempY,thisx,thisy,xmin,ymin:double;
  x,h,l,xmax,ymax:double;
  savedx:double; //yes, memory is cheap!
  i:integer;
  TR1,BR1:string;
  TR2,BR2:string;
  TL1,BL1:string;
  TL2,BL2:string;
  fs:double;
  step:integer;
  LegendCount:integer;
  ChartTitle,LegendTitle:string;
  ProblemScore:boolean;
  PositiveScore:boolean;
  LR,HR:double; //Length and Height ratios;
  Measure:char;
  ZeroPos:double;
  r:double;
  code1,code2:integer;
  min_y,d:double;
  GoodValue:boolean;
  Legends:tstringlist;
  LegendX:double;
  LegendL:double;
  MaxLegenHeight:double;
  strDataPoints:string;
  begin
    Legends:=tstringlist.Create;
    h:=2.25*inch;
    l:=6.5*inch;
    ymax:=100;
    ymin:=-100;
    ybar:=0.1;
    x:=(PageWidth-l)/2; //center this graph
    x:= x+inch*0.2;
    ActiveFont:='/F1';
    result:=format('%s %f Tf 0 g'#10,[ActiveFont,fs]);
    //get min max for proportioning axis
    s:=format( 'select max(x_bar) as x_bar, ceiling(max(cast(mean_val as decimal(5,1)))/10)*10 as xmax,'+
               'floor(min(cast(mean_val as decimal(5,1)))/10)*10 as xmin '+
               'from %s '+
               'WHERE  page_number = %d '+
               'and job_id= %s and component_id =1',
               [quad_final,PageNumber,job_id]);

    try
      if rs2.state = 1 then rs2.close;
      rs2.open(s,cn,1,1);
      xbar:= strtofloat(getval(rs2.fields['x_bar'].value));
      xmax:= strtofloat(getval(rs2.fields['xmax'].value));
      xmin:=strtofloat(getval(rs2.fields['xmin'].value));
      rs2.close;
      if xbar>xmax then xmax := xbar+1;
      if xbar<xmin then xmin := xbar-1;
    /// if (xmin=-1) and (xmax=-1) then exit;

      rs2.open('select count(*) as cnt from tempdb..syscolumns where [id] in (select OBJECT_ID(''tempdb..#temp''))',
                  cn,1,1);
      if rs2.fields['cnt'].value>0 then
        cn.execute('drop table #temp');

      rs2.close;

      s:= format('SELECT case when stryAxis = ''Positive'' then 1 else 0 end as isPos '+
                 'FROM %s AS s '+
                 'WHERE page_number = %d '+
                 'and Job_id= %s and component_id =%s',
                 [comp_detail,PageNumber,Job_id,Componentid]);
      rs2.open(s,cn,1,1);

      PositiveYAxis:=true;
      if not((rs2.eof) and (rs2.bof)) then
        PositiveYAxis:= strtofloat(vartostr(rs2.fields['isPos'].value)) = 1;

      rs2.close;

      s:= format('SELECT DISTINCT '+
                 'sequence, '+
                 'questionlabel, '+
                 'Scale_Description, '+
                 's.xaxis_label, '+
                 'isnull(Corr_val,0) as Corr_val, '+
                 'case when x_bar is null then 0 else x_bar end as x_bar, '+
                 'case when y_bar is null then 0 else y_bar end as y_bar, '+
                 'case when mean_val is null then 0 else mean_val end as mean_val '+
                 'FROM %s AS s '+
                 'WHERE ([page_section]=''key'') and page_number = %d '+
                 'and Job_id = %s and component_id =%s '+
                 'order by sequence',[quad_final,PageNumber,Job_id,Componentid]);


      rs2.open(s,cn,1,1);
      //PositiveYAxis:=  strtofloat(vartostr(rs2.fields['y_bar'].value)) >0;
      //Measure:=string(uppercase(MeasureType)+' ')[1];

      ProblemScore:= (trim(vartostr(rs2.fields['xaxis_label'].value))='% PROB SCORE') and (Measure ='P') ;
      PositiveScore:= trim(vartostr(rs2.fields['xaxis_label'].value))='% POS SCORE';

      ProblemScore:= (uppercase(trim(strgrouping))='% PROB SCORE') and (Measure ='P') ;
      PositiveScore:= uppercase(trim(strgrouping))='% POS SCORE';

      rs2.movelast;
      LegendTitle:=trim(vartostr(rs2.fields['xaxis_label'].value));
      ChartTitle := format('Relationship of "%s" and Overall Satisfaction',[trim(CorrelationLabel)]);
      //xbar:=rs2.fields['x_bar'].value;
      ybar:=rs2.fields['y_bar'].value;
      ybar:=ybar*100;

    except

      if rs2.state > 0 then rs2.close;
      s:='q'#10'.75 w'#10'1 j'#10'0 G 1 g'#10;
      s:=s+TextAt(PageWidth*0.5,y+h+20,'Helvetica',15,'No data to display',500,'CU',false,'');
      s:=s+format('%g %g %g %g re b* Q'#10,[x,y,l,h]);//rectangle
      result:=Result+s;
      y:=y-10;
      exit;

    end;

    fs:=8;

    s:=TextAt(PageWidth*0.5,y+h+20,'Helvetica',fs,ChartTitle,500,'CU',false,'');


    y:=y+10;
    h:=h-20;

    //y axis labels
    ActiveFont:='/F1';
    s1:=format('q %s %f Tf 0 g'#10,[ActiveFont,fs]);
    //PositiveYAxis:=false;
    if PositiveYAxis then
    begin
      ZeroPos:=y;
      yaxis:=-0.1;
      for i:= 0 to 50 do
      begin
         thisy:=y+(i*2*h/100);
        if (i mod 5) =0 then
        begin
          yaxis:=yaxis+0.1;
          tr1:=format('%1.2f',[yaxis]);
          thisx:=x-3;
          s1:=s1+TextAt(thisx-2,thisy-fs*0.35,'Helvetica',fs,tr1,200,'R',true,'');
        end
        else
          thisx:=x-1.5;
        s:=s+format('%g %g m'#10'%g %g l s'#10,[thisx,thisy,x,thisy]);
      end;
    end
    else
    begin
      yaxis:=-1.2;
      for i:= -25 to 25 do
      begin
        if i=0 then
        begin
          thisy:=(y+h/2);
          ZeroPos:=thisy;
        end
        else
          thisy:=(y+h/2)+(i*h/50);
        if (i mod 5) =0 then
        begin
          yaxis:=yaxis+0.2;
          tr1:=format('%1.2f',[yaxis]);
          thisx:=x-3;
          s1:=s1+TextAt(thisx-2,thisy-fs*0.35,'Helvetica',fs,tr1,200,'R',true,'');
        end
        else
          thisx:=x-1.5;
        s:=s+format('%g %g m'#10'%g %g l s'#10,[thisx,thisy,x,thisy]);
      end;
    end;


    y:=y-10;
    h:=h+20;

    savedx:=x;

    s2:='q .75 w'#10'1 j'#10'0 G 1 g'#10;
    LegendX:=x;
    LegendL:=l;
    s2:=s2+format('%g %g %g %g re s Q'#10,[x,y,l,h]);//rectangle

    y:=y+10;
    h:=h-20;

    x:=x+10;
    l:=l-20;

    if xmax <=xmin then xmax:=xmin+10;

    r:=l/(xmax-xmin);
    thisx:=x-xmin*r;

    if PositiveYAxis then
      thisy:=y+(ybar*h/100)   //proportion y coordinate;
    else
      thisy:=ZeroPos+(ybar*h/100*0.5);  //proportion y coordinate;

    s:=s+#10'q 0.4 0.6 0.4 RG'#10;
    if (thisx+xbar*r) > x then
      s:=s+format('%g %g m'#10'%g %g l'#10,[thisx+xbar*r,y-10,thisx+xbar*r,y+h+10]);

    if thisy>(y) then
      s:=s+format('%g %g m'#10'%g %g l'#10's Q'#10,[x-10,thisy,x+l+10,thisy]);


    if (xmax - xmin <80) then step:=5 else step:=10;



    x:=x-xmin*r;
    y:=y-10;
    min_y:=y-3;
    for i:= round(xmin) to round(xmax) do
    begin
        thisx:=x+i*r;
      if (i mod step) =0 then
      begin
        thisy:=y-3;
        if measure ='P' then
          tr1:=format('%3.1f%%',[i*1.0])
        else
          tr1:=format('%3.1f',[i*1.0]);
        s1:=s1+TextAt(thisx,thisy-fs,'Helvetica',fs,tr1,100,'C',false,'');
//        s1:=s1+format('BT%s%g %g Td (%s)''%sET%s',[#10,thisx-(GetTextWidth(tr1,'Helvetica',fs)/2),thisy,tr1,#10,#10]);
      end
      else
        thisy:=y-1.5;
      s:=s+format('%g %g m'#10'%g %g l'#10,[thisx,thisy,thisx,y]);
    end;
    x:=x+xmin*r;

    if step = 5 then
    begin
      x:=x-(xmin*r)+(0.5*r);
      thisy:=y-1.5;
      for i:= round(xmin) to round(xmax)-1 do
      begin
        thisx:=x+i*r;
        s:=s+format('%g %g m'#10'%g %g l'#10,[thisx,thisy,thisx,y]);
      end;

      x:=x+(xmin*r)+(0.5*r);

    end;

    y:=y+10;

    x:=x-10;
    l:=l+20;

    if ProblemScore then
    begin
      TR1 := 'Top Priority';
      TR2 := '(High Problem Score, High Correlation)';
      BR1 := 'Medium Priority';
      BR2 := '(High Problem Score, Low Correlation)';

      TL1 := 'High Priority';
      TL2 := '(Low Problem Score, High Correlation)';
      BL1 := 'Low Priority';
      BL2 := '(Low Problem Score, Low Correlation)';
    end
    else
    if PositiveScore then
    begin
      TL1 := 'Top Priority';
      TL2 := '(Low Positive Score, High Correlation)';
      BL1 := 'Medium Priority';
      BL2 := '(Low Positive Score, Low Correlation)';

      TR1 := 'High Priority';
      TR2 := '(High Positive Score, High Correlation)';
      BR1 := 'Low Priority';
      BR2 := '(High Positive Score, Low Correlation)';
    end
    else
    begin
      TR1 := 'Higher Satisfaction';
      TR2 := 'Higher Importance';
      BR1 := 'Higher Satisfaction';
      BR2 := 'Lower Importance';

      TL1 := 'Lower Satisfaction';
      TL2 := 'Higher Importance';
      BL1 := 'Lower Satisfaction';
      BL2 := 'Lower Importance';
    end;

    x:= savedx;
    fs:=8;
    s:=s+'s'#10;
    thisx:=x+l;
    ActiveFont:='/F1';
    s:=s+format('BT %s %f Tf%s 0 0 1 rg'#10'%g %g Td 8 TL (%s)''(%s)''%sET%s',
      [ActiveFont,fs,#10,x,y+h+30,TL1,TL2,#10,#10]);
    s:=s+format('BT%s%g %g Td 8 TL (%s)''(%s)''%sET%s',
      [#10,x,y-8-12,BL1,BL2,#10,#10]);

    s:=s+TextAt(thisx,y+h+10+fs*1.5,'Helvetica',fs,tr1,200,'R',true,'');
    s:=s+TextAt(thisx,y+h+10+fs*0.5,'Helvetica',fs,tr2,200,'R',true,'');
    s:=s+TextAt(thisx,y-fs*2-12,'Helvetica',fs,br1,200,'R',true,'');
    s:=s+TextAt(thisx,y-fs*3-12,'Helvetica',fs,br2,200,'R',true,'');
    ActiveFont:='/F1';
    s:=s+Format('q 0 g BT %s %f Tf 0 1 -1 0 %g %g Tm (Correlation Coefficient) Tj ET Q'#10,[activefont,fs+3,x-inch*0.4,y]);

    rs2.movefirst;
    s:=s+s1+'Q'#10+s2;
    s2:='';
    s1:='';

    strDataPoints:='q /F5 6 Tf 1 w'#10'1 j'#10;
    x:=x+10;
    l:=l-20;
    //dots numbers
    LegendCount:=0;
    fs:=8;
    s:=s+'3 w'#10'1 j'#10'0 g'#10;
    ActiveFont:='/F1';
    tr1:=format('%s %f Tf%s',[ActiveFont,fs,#10]);
    x:=x-xmin*r;
    while not rs2.eof do
    begin
      val(floattostr(rs2.fields['mean_val'].value),xbar,code1);
      val(Floattostr(rs2.fields['corr_val'].value),ybar,code2);

      if (code1=0) and (code2=0) then
      begin
        ybar:=ybar*100;
        thisx:=x+xbar*r;
        if PositiveYAxis then
          thisy:=ZeroPos+(ybar*h/100)
        else
          thisy:=ZeroPos+(ybar*h/100*0.5);

        GoodValue:= Thisy>=min_y;

        if goodValue then
        begin
        inc(LegendCount);
        Legends.Add(trim(vartostr(rs2.fields['questionlabel'].value)));
        //s:=s+circle(thisx,thisy,2*1.0,'0 g');
        strDataPoints:= strDataPoints+Format('BT %g %g Td(3)'' ET'#10,[thisx,thisy+fs]);
        tr1:=tr1+textat(thisx,thisy+fs*0.5,'Helvetica',fs,inttostr(LegendCount),30,'C',false,'');
        end;
      end;
      rs2.movenext;
    end;
    strDataPoints := strDataPoints+'Q'#10;
    s:=s+tr1+strDataPoints;
    x:=x+xmin*r;
    y:=y-40;
    fs:=10;

    //write legend title
    if LegendTitle <> '' then
    begin
      activeFont:='/F2';
      s:=s+TextAt(PageWidth*0.5,y,'Helvetica',fs,LegendTitle,300,'C',false,'');
      y:=y-20;
    end;

    rs2.movefirst;
    LegendCount:= Legends.Count;
    LegendCount:=round((LegendCount*0.5)+0.1);
    i:=0;
    fs:=8;
    activeFont:='/F1';
    thisx:=x+10;
    thisy:=y-fs*1.2;

    //find out how much room this legend is going to take
    yGlobal:= Thisy;
    for i:=0 to Legends.Count-1 do
    begin
      TextAt(thisx,yGlobal,'Helvetica',fs,Legends.Strings[i] ,225,'L',false,'');
    end;

    MaxLegenHeight:= (thisy-yGlobal);
    MaxLegenHeight:= MaxLegenHeight * 0.5;
    yGlobal:= Thisy;
    for i:=0 to Legends.Count-1 do
    begin
      if (thisy-yGlobal) >=MaxLegenHeight then
      begin
        thisx:=PageWidth*0.5+30;
        thisy:=yGlobal;
        yGlobal:=y-fs*1.2;
      end;
      Tempy:=yGlobal;
      activeFont:='/F2';
      s:=s+TextAt(thisx-1,Tempy,'Helvetica',fs,inttostr(i+1),30,'r',false,'');
      yGlobal:=tempy;
      activeFont:='/F1';
      s:=s+TextAt(thisx,yGlobal,'Helvetica',fs,Legends.Strings[i] ,225,'L',false,'');
      //thisy:=thisy-fs;
    end;

//    legend box
    if thisy>yGlobal then thisy:=yGlobal;
    if Legends.Count > 0 then
    begin
      MaxLegenHeight:= (y-thisy){+fs*0.25};
      y:= thisy + fs*0.1; //=y-((LegendCount*fs)+fs*0.75);
      //s:=s+format('%g %g %g %g re %s',[LegendX,y,LegendL,((LegendCount*fs)+fs*0.75),#10]);
      s:=s+format('%g %g %g %g re %s',[LegendX,y,LegendL,MaxLegenHeight,#10]);
    end;

    Legends.Destroy;
    y:=y-10;
    result:=result+s;
    rs2.close;
  end;
end.
