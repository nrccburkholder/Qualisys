unit HBarmns;

{*******************************************************************************
Program Modifications:
--------------------------------------------------------------------------------
Date        UserId   Description
-------------------------------------------------------------------------------
11-07-2005   GN01    Set the length of the HBar to 1 inch due to the overflow.

11-16-2005   GN02    Get the MaxValue for each question to calculate the length
                     of the HBar.
*******************************************************************************}

interface
uses windows,sysutils,textmeasure,constants,arrows,ScaleLabels,DivLines,HBHeaders,hbars,dialogs,drawing;

function hbarmn(x:double; var y:double;h,w:double;pagenumber:integer;cn:variant;stacked_bars:boolean;componentid:string;Job_ID:string;fs:double):string;

implementation

type tHbar = class(tobject)
       lbl:string;
       count:integer;
       values : array[1..10] of double;
       x:array[1..10] of double;
       y:array[1..10] of double;
       CurCol,ColsCount:integer;
//       ColPos:array[0..7] of double;
       ColNum:array[0..7] of integer;
       list:array[0..7] of string;
     end;

  function hbarmn(x:double; var y:double;h,w:double;pagenumber:integer;cn:variant;stacked_bars:boolean;componentid:string;Job_id:string;fs:double):string;
  var x1,x2,x3,
      y1,y2,y3:double;
      MaxValue:Double;
      s:string;
      s1:string;
      s2:string;
      hbarcount:integer;
      r:double;
      bg:carray;
      stackedbg: array [1..4] of carray;
//      fn:LongInt;
      i,j:integer;
      num_compare_labels:integer;
      mys:string;
      thislabel,fld:string;
      thisx:double;
      whilecount:integer;
      HBarLength:double;//BarLength
      Drawline:Boolean;
      T2:string;
      rs:variant;
      joinstr:string;
      HasComparison:boolean;
      bars:string;
      ValueFormat:array[1..7] of integer;
      HbarPos:Double;
      rsColCount:variant;
      tempstr:string;
  begin
//     fn:='';
     HBarLength:=inch*1.65; //GN01

     y1 := y + (h/2);

     rsColCount:=cn.execute(Format('Select isnull(Column_Number,0) '+
            'from apo_compdetail where job_id = %s and  Page_Number = %d '+
            'and Component_ID = %s',[Job_ID,pagenumber,componentid]));
     ColsCount:=rsColCount.fields[0].value;
     rsColCount.close;
     rsColCount:=Unassigned;

     if Stacked_Bars then    //put out a legend
     begin
       stackedbg[1]:=GetShade([0.7, 0.7, 2],'rg');//GetShade([0.5, 0.5, 1],'rg');  //blue
       stackedbg[2]:=GetShade([1.2, 0, 0],'rg'); //GetShade([1, 0.1, 0],'rg');    //red
       stackedbg[3]:= GetShade([1.6, 1.6, 0.6],'rg'); //GetShade([0.9, 0.9, 0.2],'rg');  //yellow
       stackedbg[4]:=GetShade([0.7, 0.7, 0.7],'rg');
       s:= format('select distinct class_label, cast(Order_Num as integer) from %s '+
       'where page_number = %d and job_id = %s and component_id =%s and not class_label is null order by cast(Order_Num as integer)',
       [hbar_stats_final,pagenumber,job_id,componentid]);
       rs:=cn.execute(s);
       s:='';
       thisx:=x;
       x:=80;
       w:=25;
       y:=y-30;
       whilecount:=0;
       ActiveFont:='/F1';
       s1:=format('q 0 g %s %f Tf'#10,[ActiveFont,fs]);
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
           s1:=s1+textat(x1+h/2+1,y1,'',fs,lbl,100,'L',true,'');
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
       'where job_id = %1:s and page_number = %2:d and component_id =%3:s',
       [hbar_stats_final,Job_id,pagenumber,componentid]);

       rs:=cn.execute(s);

       s:='';

       hbarcount:=strtoint(trim(vartostr(rs.fields[0].value)));
       rs.close;
       rs:=unassigned;
       //if (hbarcount>0)  then
       begin
         if (hbarcount>4) and (not morehbars) then
           hbarcount:=3
         else
         hbarcount:=1;

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
                 's.Sig7,'+
                 'case when l.Highlight = 1 then 1 else 0 end as HighLight '+
                 'FROM %4:s AS l LEFT JOIN %3:s AS s '+
                 'ON (s.Order_Num = l.Order_Num) '+
                 'AND (l.Sequence = s.Sequence) '+
                 'AND (l.Component_ID = s.Component_ID) '+
                 'AND (l.Page_Number = s.Page_Number) '+
                 'AND (l.Job_ID = s.Job_ID) '+
                 'WHERE l.Job_ID = %0:s '+
                 'AND l.Page_Number =%1:d '+
                 'AND l.Component_ID =%2:s '+
                 'order by S.sequence, S.Order_Num, isnull(s.rank ,0)',
                 [Job_ID, pagenumber, componentid, hbar_stats_final, hbar_labels_final]);

       if (not morehbars) and (rs2.state = 1) then
         rs2.close;

       if (rs2.state = 1) then  if rs2.eof and rs2.bof then rs2.close;

       if (not morehbars)  and ( not (rs2.state = 1)) then
       begin

         QuestionstoDisplay := 100;

         try
           rs2.open(s,cn,1,1);
           if  (not morehbars) then  row:=0;
         except
           showmessage(s);
         end;

       end;

       s:='';


       if rs2.eof and rs2.bof then
       begin
          exit;
       end;

       if QuestionstoDisplay <1 then QuestionstoDisplay:=rs2.recordcount;

       if (not(stacked_bars)) then
       begin
          Grouping:=strGrouping;
       end
       else
       begin
         Grouping:= ' ';
       end;

       s:='';
       if not rs2.eof then
       begin
         CurCol:=strtoint(vartostr(rs2.fields['current_label'].value));
         if ((MeasureType in[1,3]) and (not isPepC)) then
           MaxValue := strtofloat(GetVal(rs2.fields['MaxValue'].value))
         else
            MaxValue:=100;
       end;

       while not rs2.eof do
       begin
         inc(row);
         GetLabels(List2,stacked_bars);
         s2:='';
         if (HeaderChanged(List1,List2) or (Scale <> trim(vartostr(rs2.fields['label'+inttostr(CurCol)].value))) or NewPage) then
         begin
            if drawLine then
            begin
              y:=y+h*1.5;
              s2:=divLine(y);
            end;
            t2:='Detail';

            Scale:=trim(vartostr(rs2.fields['label'+inttostr(CurCol)].value));
            s2:=s2+GetHeader(y,List2,TitleStr,t2,fs,CurCol,ColsCount,ColPos,HBarLength,SortLegend,stacked_bars);
            y:=y-fs*0.4;
            s2:=s2+divLine(y);
            //y:=y-25;
            HbarPos:= ColPos[CurCol];
            //if HbarPos+HBarLength+20 > ColPos[CurCol] then
            //     HbarPos:=ColPos[CurCol]-(HBarLength+20); //make sure we have enough room for hbars and data labels
            if not stacked_bars then
            begin
              y:=y-fs*1.2;
              s2:=s2+GetScaleLabel(MeasureType,Scale,Grouping,HbarPos+20,y,stacked_bars,fs);
              y:=y-(h*1.5+fs*2);
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


         if rs2.fields['HighLight'].value = 1  then
             bg:=  GetShade([0, 0.4, 0],'rg') //green
           else
             bg:=  GetShade([0.7, 0.7, 2],'rg'); //blue


         for i:=1 to ColsCount do
         begin
           List2[i]:=GetVal(rs2.fields[Format('value%d',[i])].value);
           if not varisnull(rs2.fields[Format('ValueFormat%d',[i])].value) then
             ValueFormat[i]:=rs2.fields[Format('ValueFormat%d',[i])].value;

         end;
         lbl:=trim(vartostr(rs2.fields['component_label'].value));
         thislabel:=lbl;
         //x is where we want to start printing question labels. Right justified.
         x:=HbarPos;

         HasComparison:=varisnull(rs2.Fields['class_label'].value);

         //print HBar question labels.
         if (not(HasComparison and stacked_bars)) then
         begin
           TempStr := TextAt(x-3,y+h*0.25,'',fs,lbl,round(CurColWidth),'R',true,'');
           if LinesHeight > h*1.25 then
           begin
              y:= y-LinesHeight+fs;
              TempStr := TextAt(x-3,y,'',fs,lbl,round(CurColWidth),'R',true,'');
           end;
           s:=s+TempStr;
         end;

         if stacked_bars and (not(HasComparison)) then
         begin
            ActiveFont:='/F1';
            //s:=s+format('q .05 w 0 g .5 G'#10'%s 2 Tr %f Tf '#10,[ActiveFont,fs])
            s:=s+'q .05 w 0 g 0 G 2 Tr'#10;
         end
         else
           ActiveFont:='/F1';

         whilecount:=0;

         x:=HbarPos;
         bars:='';
         while (thislabel = lbl) and (not rs2.eof) do
         begin
           inc(whilecount);
           //GN02
           if ((MeasureType in [1]) and (not isPepC)) then
              MaxValue := strtofloat(GetVal(rs2.fields['MaxValue'].value));
           if MaxValue <= 0 then MaxValue := 1;

           r:= HBarLength/MaxValue;

           //response value
           w := strtofloat(GetVal(rs2.fields[Format('value%d',[CurCol])].value));
           //w:=100.0;
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
            {
             case measure[1] of
               'P' : lbl:=format('%1.1f%%',[w]);
               'S' : lbl:=format('%1.0f',[w]);
               else lbl:=format('%1.1f',[w]);
             end;
             }

             lbl:=FormatFloat(Formats[ValueFormat[CurCol]],round(w*10000)*0.0001);

             if stacked_bars then
               s:=s+textat(x1-(w/2),y+h*0.3,'',fs,lbl,50,'C',false,'')
             else
               s:=s+textat(x1+h*0.5+1,y1,'',fs,lbl,50,'L',false,'');
           end;

           inc(HBarsCounter);
           rs2.movenext;
           if not rs2.eof then
           begin
             lbl:=trim(vartostr(rs2.fields['component_label'].value));
             morehbars:=true;
           end
           else
             morehbars:=false;

           x:=x1;
           if not stacked_bars then break;
         end; //while (thislabel = lbl) and (not rs2.eof)
         if stacked_bars and (not(HasComparison)) then
           s:=s+'Q'#10;

         s:=bars+s;

         x:=HbarPos;

         if (HasComparison and stacked_bars) and morehbars then
           rs2.movenext;
         //values other than hbarmn's
         if HasComparison then
         begin
         for i:=1 to ColsCount do
          if (i <> CurCol) and ( strtofloat(getval(List2[i]))>-1) and (not (i in MissingColumns))then
          begin
             w:=strToFloat(GetVal(List2[i]));

              if IsCor[i] then
               intFormat:=4
             else
               intFormat:=ValueFormat[i];

             List2[i]:=FormatFloat(Formats[intFormat],round(w*10000)*0.0001);

             s:=s+TextAt( ColPos[i],y + (h*0.5),'',fs,List2[i],round(ColWidth[i]),'C',false,'');

             if ShowSig then
               s:=s+DrawArrow(SigArrowPos-2,y1,fs,'0 g',sig[i]);
          end;
         end;

         y:=y-(h*2);

         if (y<FooterHeight) or  (HBarsCounter=QuestionstoDisplay) then break;
       end; //while not rs.eof


       if rs2.eof then
       begin
         Morehbars:= false;
         HBarsCounter:=0;
         rs2.close;
       end
       else
         Morehbars:= true;
     end;//if hbcount>0;
     fit:=not(Morehbars);
     result:=s1+s;
  end;

end.

