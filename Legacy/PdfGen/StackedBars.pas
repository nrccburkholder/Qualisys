unit StackedBars;

interface
uses sysutils,textmeasure,constants,arrows,ScaleLabels,DivLines,HBHeaders,hbars;

function hbarmn(x:double; var y:double;h,w:double;pagenumber,apid:string;cn:variant;stacked_bars:boolean;componentid:string;Job_ID:string):string;

implementation

type tHbar = class(tobject)
       lbl:string;
       count:integer;
       values : array[1..10] of double;
       x:array[1..10] of double;
       y:array[1..10] of double;
       CurrCol,ColsCount:integer;
//       ColPos:array[0..7] of double;
       ColNum:array[0..7] of integer;
       list:array[0..7] of string;
     end;

  function hbarmn(x:double; var y:double;h,w:double;pagenumber,apid:string;cn:variant;stacked_bars:boolean;componentid:string;Job_id:string):string;
  var x1,x2,x3,
      y1,y2,y3:double;

      s:string;
      s1:string;
      s2:string;
      hbarcount:integer;
      row:integer;
      r:double;
      bg:carray;
      stackedbg: array [1..4] of carray;
      fs:integer;
      fn:string;
      i,j:integer;
      num_compare_labels:integer;
      mys:string;
      thislabel,fld:string;
      thisx:double;
      whilecount:integer;
      l:double;//BarLength
      Drawline:Boolean;
      T2:string;
      rs:variant;
      joinstr:string;
      HasComparison:boolean;
      bars:string;
      ValueFormat:array[1..7] of integer;
  begin
     fs:=8;
     fn:='Helvetica';
     l:=inch*1.65;
     row:=0;
     y1 := y + (h/2);

     if Stacked_Bars then    //put out a legend
     begin
       stackedbg[1]:=GetShade([0.7, 0.7, 2],'rg');//GetShade([0.5, 0.5, 1],'rg');  //blue
       stackedbg[2]:=GetShade([1.2, 0, 0],'rg'); //GetShade([1, 0.1, 0],'rg');    //red
       stackedbg[3]:= GetShade([1.6, 1.6, 0.6],'rg'); //GetShade([0.9, 0.9, 0.2],'rg');  //yellow
       stackedbg[4]:=GetShade([0.7, 0.7, 0.7],'rg');
       s:= format('select distinct class_label, cast(Order_Num as integer) from %s '+
       'where page_number = %s and ap_id= ''%s'' and component_id =%s and not class_label is null order by cast(Order_Num as integer)',
       [hbar_stats_final,pagenumber,apid,componentid]);
       rs:=cn.execute(s);
       s:='';
       thisx:=x;
       x:=80;
       w:=25;
       y:=y-30;
       whilecount:=0;
       ActiveFont:='/F1';
       s1:=format('q 0 g %s %d Tf'#10,[ActiveFont,fs]);
       while not rs.eof do
       begin
           inc(whilecount);
           x1 := x+w;
           x2 := x1 +(h/2);
           x3 := x + (h/2);
           y1 := y + (h/2);
           y2 := y1 + h;
           y3 := y + h;
           lbl:=trim(vartostr(rs.fields['class_label'].value));
           s1:=s1+'q'#10'.75 w'#10'1 j'#10'0 G'#10+stackedbg[whilecount][1];
           s1:=s1+format('%g %g %g %g re'#10'b'#10,[x,y,w,h]);//rectangle
           s1 := s1+stackedbg[whilecount][2]; //bacground color for end of hbar
           s1:=s1+format('%g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'b'#10+stackedbg[whilecount][3],[x1,y,x2,y1,x2,y2,x1,y3]);
           s1:=s1+format('%g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'b Q'#10,[x1,y3,x2,y2,x3,y2,x,y3]);
           s1:=s1+textat(x1+h/2+1,y1,'Helvetica',fs,lbl,100,'L',true);
           x:=x1+100;
           rs.movenext;
       end;
       s1:=s1+'Q'#10;
       rs.close;
       rs:=unassigned;
       x:=thisx;
       y:=y+10;
     end;


       s:=format('select count(*) from %0:s '+
       'where page_number = %1:s and ap_id= ''%2:s'' and component_id =%3:s',
       [hbar_stats_final,pagenumber,apid,componentid]);

       rs:=cn.execute(s);

       s:='';
       hbarcount:=strtoint(trim(vartostr(rs.fields[0].value)));
       rs.close;
       rs:=unassigned;
       //if hbarcount>0 then
       begin
         if hbarcount>4 then
           hbarcount:=3
         else
         hbarcount:=1;
       {
       if not mockup then

       begin
         s:=format('UPDATE  s SET s.[scale] = [d].[scaleid] '+
                 'from '+
                   '%s as d INNER JOIN %s as s ON d.[QT_Number] = s.[qstncore] '+
                   'where s._page_number = %s and s._ap_id= ''%s'' and s._component_id =%s',
                   [comp_detail,hbar_stats_final,pagenumber,apid,componentid]);

         cn.execute(s);
         joinstr:='d.[QT_Number] = s.[qstncore]'
       end
       else
       }
       joinstr:='d._questionlabel = s._component_label';


       s:=format('SELECT '+
                 's.Sequence,'+
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
                 's.Sig7 '+
                 'FROM %5:s AS l INNER JOIN %4:s AS s '+
                 'ON (s.Order_Num = l.Order_Num) '+
                 'AND (l.Sequence = s.Sequence) '+
                 'AND (l.Component_ID = s.Component_ID) '+
                 'AND (l.Page_Number = s.Page_Number) '+
                 'AND (l.AP_ID = s.AP_ID) '+
                 'AND (l.Job_ID = s.Job_ID) '+
                 'WHERE (((s.Job_ID)=%0:s) '+
                 'AND ((s.AP_ID)=''%1:s'') '+
                 'AND ((s.Page_Number)=%2:s) '+
                 'AND ((s.Component_ID)=%3:s)) '+
                 'order by S.sequence, S.Order_Num, rank ',
                 [Job_ID,apid,pagenumber,componentid,hbar_stats_final,hbar_labels_final]);

       if (rs2.state = 1) then       if rs2.eof and rs2.bof then rs2.close;
       if (not morehbars)  and ( not (rs2.state = 1)) then
       begin

         //rs2.open('select count(*) as cnt from tempdb..syscolumns where [id] in (select OBJECT_ID(''tempdb..#temp''))',
        //          cn,1,1);
        // if rs2.fields['cnt'].value>0 then
        //   cn.execute('drop table #temp');

        // rs2.close;

       //  cn.execute(s);
        {
         s:=format('Select numQuestionstoDisplay as qd '+
                   'from %0:s as d where d.[component_id] = %1:s and d.[Page_number] = %2:s '+
                   'and d.[ap_id] = ''%3:s''',[comp_detail,componentid,pagenumber,apid]);
         rs2.open(s,cn,1,1);
         }
         QuestionstoDisplay := 100;

         //s:='Select * from #temp order by sequence, Order_Num, rank';
         rs2.open(s,cn,1,1)

       end;

       s:='';

       if rs2.eof and rs2.bof then exit;
       
       if QuestionstoDisplay <1 then QuestionstoDisplay:=rs2.recordcount;

       if (not(stacked_bars)) then
       begin
          Measure:=uppercase(trim(MeasureType)+' ');
          Grouping:=strGrouping;
       end
       else
       begin
         Measure := 'P';
         Grouping:= ' ';
       end;

       s:='';

       if not rs2.eof then
         CurrCol:=strtoint(vartostr(rs2.fields['current_label'].value));

       while not rs2.eof do
       begin
         inc(row);
         GetLabels(List2);
         s2:='';
         if (HeaderChanged(List1,List2) or (Scale <> trim(vartostr(rs2.fields['label'+inttostr(currcol)].value))) or NewPage) then
         begin
            if drawLine then
            begin
              y:=y+h*1.5;
              s2:=divLine(y);
            end;
            t2:='Detail';
            Scale:=trim(vartostr(rs2.fields['label'+inttostr(currcol)].value));
            s2:=s2+GetHeader(y,List2,TitleStr,t2,fs,CurrCol,ColsCount,ColPos,CorrelationLabel);
            y:=y-5;
            s2:=s2+divLine(y);
            y:=y-25;
            if not stacked_bars then
            begin
              y:=y-15;
              s2:=s2+Scale_label(Measure[1],Scale,Grouping,ColPos[CurrCol]+20 ,y+30,stacked_bars);
            end;
            DrawLine:=true;
            List1:=List2;
            NewPage:=false;
            if (y<FooterHeight) then
            begin
              s2:='';
              break;
            end;
         end;
         s:=s+s2;


         if (row <= hbarcount) and (correlationLabel <> '') and (not morehbars) then
             bg:=  GetShade([0, 0.4, 0],'rg') //'0 .7 0 rg'#10;
           else
             bg:=  GetShade([0.7, 0.7, 2],'rg'); //blue


         for i:=1 to high(List2) do
         begin
           List2[i]:=GetVal(rs2.fields[Format('value%d',[i])].value);
           if not varisnull(rs2.fields[Format('ValueFormat%d',[i])].value) then
             ValueFormat[i]:=rs2.fields[Format('ValueFormat%d',[i])].value;

         end;
         lbl:=trim(vartostr(rs2.fields['component_label'].value));

         thislabel:=lbl;

         x:=ColPos[CurrCol];
         HasComparison:=varisnull(rs2.Fields['class_label'].value);

         if (not(HasComparison and stacked_bars)) then
           s:=s+TextAt( x-3,y+h*0.25,'Helvetica',fs,lbl,round(ColPos[CurrCol]-ColPos[CurrCol-1])-2,'R',true);


         if stacked_bars and (not(HasComparison)) then
         begin
            ActiveFont:='/F1';
            //s:=s+format('q .05 w 0 g .5 G'#10'%s 2 Tr %d Tf '#10,[ActiveFont,fs])
            s:=s+'q .05 w 0 g 0 G 2 Tr'#10;
         end
         else
           ActiveFont:='/F1';

         whilecount:=0;
         if (Measure[1] in ['M','P']) or stacked_bars then
            r:=l/100
         else r:= l/MaxNCount;
         x:=ColPos[CurrCol];
         bars:='';
         while (thislabel = lbl) and (not rs2.eof) and (not(HasComparison and stacked_bars)) do
         begin
           inc(whilecount);

           w:= strtofloat(GetVal(rs2.fields[Format('value%d',[CurrCol])].value));

           if w > -1 then
             x1 := x+w*r
           else
             x1:=x;
           x2 := x1 +(h/2);
           x3 := x + (h/2);
           y1 := y + (h/2);
           y2 := y1 + h;
           y3 := y + h;
           if stacked_bars then
             bg:=stackedbg[whilecount];

           if w > -1 then
           begin
             bars:=bars+hbar(x,y,h,w*r,bg);

             lbl:=FormatFloat(Formats[ValueFormat[CurrCol]],round(w*10000)*0.0001);

             if stacked_bars then
               s:=s+textat(x1-(w/2),y+h*0.3,'Helvetica',fs,lbl,50,'C',false)
             else
               s:=s+textat(x1+h*0.5+1,y1,'Helvetica',fs,lbl,50,'L',false);
           end;

           inc(HBarsCounter);
           rs2.movenext;
           if not rs2.eof then
           begin
             lbl:=trim(vartostr(rs2.fields['component_label'].value));
           end;
           x:=x1;
           if not stacked_bars then break;
         end; //while (thislabel = lbl) and (not rs2.eof)
         if stacked_bars and (not(HasComparison)) then
           s:=s+'Q'#10;

         s:=bars+s;

         x:=ColPos[CurrCol];

         if (HasComparison and stacked_bars) then
           rs2.movenext;
         //values other than hbarmn's
         if HasComparison then
         begin
         for i:=1 to high(List2) do
          if (i <> CurrCol) and ( strtofloat(getval(List2[i]))>-1) and (not (i in MissingColumns))then
          begin
             w:=strToFloat(GetVal(List2[i]));


              if IsCor[i] then
               intFormat:=4
             else
               intFormat:=ValueFormat[i];

             List2[i]:=FormatFloat(Formats[intFormat],round(w*10000)*0.0001);

             if i>currcol then
               s:=s+TextAt( ColPos[i]-coldist*0.5,y + (h*0.5),'Helvetica',fs,List2[i],round(coldist-3),'C',false)
             else
               s:=s+TextAt( ColPos[i]-(ColPos[i]-ColPos[i-1]+0.5)*0.5,y + (h*0.5),'Helvetica',fs,List2[i],round(ColPos[i]-ColPos[j]+0.5),'C',false);
             if ShowSig then
               s:=s+DrawArrow(SigArrowPos-2,y1,fs,'0 g',sig[i]);
          end;
         end;

         if not (HasComparison and stacked_bars) then
           y:=y-(h*2);

         if (y<FooterHeight) or  (HBarsCounter=QuestionstoDisplay) then break;
       end; //while not rs.eof
       
       Morehbars:=HBarsCounter<QuestionstoDisplay;
       if Morehbars then
         Morehbars:= rs2.eof = false
       else
         HBarsCounter:=0;
       if not MoreHbars then
         rs2.close;
     end;//if hbcount>0;
     result:=s1+s;
  end;

end.

