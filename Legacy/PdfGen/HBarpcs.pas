unit HBarpcs;
{*******************************************************************************
Program Modifications:
--------------------------------------------------------------------------------
Date        UserId   Description
-------------------------------------------------------------------------------
12-20-2006   GN01    Get the MaxValue for each question to calculate the length
                     of the HBar.
*******************************************************************************}


interface
uses sysutils,divlines,TextMeasure,Constants,arrows,scalelabels,hbars,HBHeaders,drawing,windows;

function hbarpc(x:double; var y:double;h,w:double;pagenumber:integer;Job_id:string;cn:variant;componentid:string;BreakOut:boolean):string;

implementation

  function hbarpc(x:double; var y:double;h,w:double;pagenumber:integer;Job_id:string;cn:variant;componentid:string;BreakOut:boolean):string;
  var x1,x2,x3,
      y1,y2,y3:double;
      i,j:integer;
      t2,s,strHeader:string;
      bg:carray;
      QuestionCompareField:string;
      cnt:integer;
      HBarLength:double;//BarLength
      r:double; //ratio
      fs:double;
      HbarPos:Double;
      rsColCount:variant;
      BookMark : Variant;
      strBreakout:string;
      MaxValue:Double;
      TempStr : string;
  begin

     QuestionCompareField := 'qstncore';

     rsColCount:=cn.execute(Format('Select isnull(Column_Number,0) '+
            'from apo_compdetail where job_id = %s and  Page_Number = %d '+
            'and Component_ID = %s',[Job_ID,pagenumber,componentid]));
     ColsCount:=rsColCount.fields[0].value;
     rsColCount.close;
     rsColCount:=Unassigned;


     fs:=8;
     HBarLength:=inch*1.65; 

     bg:=  GetShade([0.7, 0.7, 2],'rg'); //blue

     if (not morehbars) and (rs2.state = 1) then
         rs2.close;

     if (rs2.state = 1) then
        if ((rs2.eof) and (rs2.bof)) then
           rs2.close;
     if (not morehbars)  and ( not (rs2.state = 1)) then
     begin
	    //2013-0318 The compile BINARY was altered on this date on the wsPdfGen machine using a hex editor to execute the
		//the line below, using a permanent x table instead of the # temp table
		//the original line is left here commented
		//because this happens multiple times, the first statement is to delete records out of this new x table
		//the syntax of the queries was such that it would fit exactly into the same length of the existing queries in the binary
        //s:= format('SELECT QstnCore,count(QstnCore) as cnt into #qstncount '+

        s:= format('delete x insert into x SELECT QstnCore,count(QstnCore) '+
                   'FROM %0:s '+
                   'WHERE page_number = %d and Job_id= %s and component_id = %s '+
                   'group by QstnCore',
                   [hbar_stats_final,pagenumber,Job_id,componentid]);

        cn.execute(s);


              s:=format('SELECT '+
                 's.Sequence,'+
                 's.qstncore,'+
                 's.Order_Num,'+
                 's.Rank,'+
                 'l.Scale_Label,'+
                 'l.current_label,'+
                 's.Component_Label,'+
                 'class_label,'+
                 's.Value1,'+
                 's.Value2,'+
                 's.Value3,'+
                 's.Value4,'+
                 's.Value5,'+
                 's.Value6,'+
                 's.Value7,'+
                 's.MaxValue,'+
                 'Label1,'+
                 'Label2,'+
                 'Label3,'+
                 'Label4,'+
                 'Label5,'+
                 'Label6,'+
                 'Label7,'+
                 's.ValueFormat1,'+
                 's.ValueFormat2,'+
                 's.ValueFormat3,'+
                 's.ValueFormat4,'+
                 's.ValueFormat5,'+
                 's.ValueFormat6,'+
                 's.ValueFormat7,'+
                 's.Sig1,'+
                 's.Sig2,'+
                 's.Sig3,'+
                 's.Sig4,'+
                 's.Sig5,'+
                 's.Sig6,'+
                 's.Sig7, '+
                 'q.cnt '+
                 'FROM %4:s AS l INNER JOIN %3:s AS s '+
                 'ON (s.Order_Num = l.Order_Num) '+
                 'AND (l.Sequence = s.Sequence) '+
                 'AND (l.Component_ID = s.Component_ID) '+
                 'AND (l.Page_Number = s.Page_Number) '+
                 'AND (l.Job_ID = s.Job_ID) '+

				 //2013-0318 The compile BINARY was altered on this date on the wsPdfGen machine using a hex editor to execute the
				 //the line below, using a permanent x table instead of the # temp table
				 //the original line is left here commented
                 //'left join #qstncount as q on q.qstncore = s.qstncore '+

                 'left join x          as q on q.qstncore = s.qstncore '+

                 'WHERE s.Job_ID = %0:s '+
                 'AND s.Page_Number = %1:d '+
                 'AND s.Component_ID = %2:s '+
                 'order by s.sequence, s.Order_Num, rank',
                 [Job_ID, pagenumber, componentid, hbar_stats_final, hbar_labels_final]);
                 //0      1           2            3                 4
        rs2.open(s,cn,1,1);
		//2013-0318 The compile BINARY was altered on this date on the wsPdfGen machine using a hex editor to execute the
		//the line below, using a permanent x table instead of the # temp table
		//the original line is left here commented
        //cn.execute('drop table #qstncount');
        cn.execute('/*******************/');
     end;
     qstncore:='-1';

     s:='';

     if rs2.eof then
     begin
       result:='';
       Morehbars:=false;
       exit;
     end;

      if not rs2.eof then
      begin
         CurCol:=strtoint(vartostr(rs2.fields['current_label'].value));
         if ((MeasureType in[1,3]) and (not isPepC)) then
            MaxValue := strtofloat(GetVal(rs2.fields['MaxValue'].value))
         else
           MaxValue := 100;
      end;
     //DrawHBLegend:=false;
     Grouping:=trim(vartostr(rs2.fields['Scale_Label'].value));
     GetLabels(List,false);
     t2:='Detail';
     strHeader:=GetHeader(y,List,TitleStr,t2,fs,CurCol,ColsCount,ColPos,HBarLength,SortLegend,false);
     y:=y-5;


     while not rs2.eof do
     begin
       cnt:=rs2.fields['cnt'].value;
       //GN01
       if ((MeasureType in [1]) and (not isPepC)) then
          MaxValue := strtofloat(GetVal(rs2.fields['MaxValue'].value));
       if MaxValue <= 0 then MaxValue := 1;


       r:= HBarLength/MaxValue;

       if (Scale <> trim(vartostr(rs2.fields['scale_label'].value))) or ((qstncore<>trim(vartostr(rs2.fields[QuestionCompareField].value))) )  then
       begin
         if breakout then
         begin
           Bookmark := rs2.Bookmark;
           strBreakout := s;
         end;

         if (y<(FooterHeight+10+(cnt*h*2))) and (cnt in [1..6]) then break;
         if y<(FooterHeight+40) then break;
         qstncore:=trim(vartostr(rs2.fields[QuestionCompareField].value));
         lbl:=trim(vartostr(rs2.fields['component_label'].value));
         s:=strHeader+s+divline(y);
         HbarPos:= ColPos[CurCol];
         ActiveFont:='/F2';
         y:=y-fs*1.3;
         if breakout then
           s:=s+TextAt(HbarPos,y,'',fs,lbl,round(CurColWidth+HBarLength),'C',false,'')
         else
           s:=s+TextAt(HbarPos,y,'',fs,lbl,round(CurColWidth+HBarLength),'C',false,'');

         ActiveFont:='/F1';
         Scale:=trim(vartostr(rs2.fields['scale_label'].value));
         y:=yGlobal+fs;
         strHeader:='';


         if breakout then
         begin
           s:=s+GetScaleLabel(2,Scale,'',HbarPos+20,y,false,fs);
         end
         else
          s:=s+GetScaleLabel(MeasureType,Scale,Grouping,HbarPos+20,y,false,fs);
         y:=y-20;
       end;
       w:=strToFloat(GetVal(rs2.fields[Format('value%d',[CurCol])].value));
       //w:=100.0;
       x:=HbarPos;

         if w > -1 then
         begin
           x1 := x+w*r;
           intFormat:=rs2.fields[Format('ValueFormat%d',[CurCol])].value;
         end
         else
           x1:=x;

         lbl:=trim(vartostr(rs2.fields['class_label'].value));
         ActiveFont:='/F1';
         s:=s+format('0 g /F1 %f Tf '#10,[fs]);

         //if random(2) = 1 then
        //   lbl := 'this is a very very long lable that will make lines wrap to three or even more lines or even longer than that';


         TempStr := TextAt(x-3,y+h*0.2,'',fs,lbl,round(CurColWidth),'R',true,'');
         if LinesHeight > h*1.25 then
         begin
           y:= y-LinesHeight+fs;
           TempStr := TextAt(x-3,y,'',fs,lbl,round(CurColWidth),'R',true,'');
         end;

         s:=s+TempStr;

         x2 := x1 +(h/2);
         x3 := x + (h/2);
         y1 := y + (h/2);
         y2 := y1 + h;
         y3 := y + h;


         if (w >-1) then
         begin
           s:= s+hbar( x,y,h,w*r,bg);
          
           List[CurCol]:=FormatFloat(Formats[intFormat],round(w*10000)*0.0001);
           s:=s+TextAt(1+x1+h*0.5,y1,'',fs,list[CurCol],50,'L',false,'');

         end;

        //values other than hbarpc's
       j:=0;
       for i:=1 to ColsCount do List[i]:='';
       for i:=1 to ColsCount do
       if ((i<>CurCol) and (not (i in MissingColumns))) then
       begin
         w:=strToFloat(GetVal(rs2.fields[Format('value%d',[i])].value));
         if ShowSig then
           Sig[i]:=(trim(vartostr(rs2.fields[format('Sig%d',[i])].value))+' ')[1];
         if (w > -1) then
         begin
             if IsCor[i] then
               intFormat:=4
             else
               intFormat:=rs2.fields[Format('ValueFormat%d',[i])].value;

             List[i]:=FormatFloat(Formats[intFormat],round(w*10000)*0.0001);

             s:=s+TextAt( ColPos[i],y1,'',fs,List[i],round(ColWidth[i]),'C',false,'');

             if ShowSig then
               s:=s+DrawArrow(SigArrowPos-2,y1,fs,'0 g',sig[i]);

         end;
         j:=i;
       end;
       y:=y-(h*2);
       rs2.movenext;
       if y<(FooterHeight+h) then break;

     end; //while not rs2.eof
     Morehbars:= rs2.eof = false;


     if MoreHbars then
     begin
        if Breakout then
        begin
          s:=StrBreakout;
          rs2.Bookmark := Bookmark;
        end;
     end
     else
       rs2.close;

     result:=s;
  end;

end.

