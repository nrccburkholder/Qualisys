unit VBars;

{*******************************************************************************
Program Modifications:
--------------------------------------------------------------------------------
Date        UserId   Description
-------------------------------------------------------------------------------
03-22-2006  GN01     Display label on the Y-Axis

*******************************************************************************}


interface
uses sysutils,textmeasure,math,constants,Drawing;

Function GetVbars(var x,y:double;ComponentID:string;cn:variant;PageNumber:integer):String;

implementation
const VBoxHeight = inch*2;
      VBoxLength = inch*3;
      VBarDepth:double = inch*0.2;
      fs:double = 8;
var BarWidth,BarDist:double;
    BarsXpos:array [1..10] of double;
    MaxValue:double;
    MaxScale:integer;
    tmp3D:boolean;

  function vBox(x,y:double;bg1,bg2,l1,l2:string;r:double):string;
  var i : integer;
      thisy:double;
      x1,x2,x3,
      y1,y2,y3:double;

  begin
     x1 := x+VBoxLength;
     x2 := x1+VBarDepth;
     x3 := x+VBarDepth;

     y1 := y + VBarDepth;
     y2 := y + VBoxHeight;
     y3 := y2 + VBarDepth;

      Result:= #10'q 1 w'#10'1 j'#10'0 G'#10;
      if bool3D then
      begin
        result:=result+format('%s %g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'b'#10,  [bg1,x,y,x,y2,x3,y3,x3,y1]);
        result:=result+'b'#10+bg2;
        //draw bottom of vbox
        result:=result+format('%s %g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'b Q'#10,[bg2,x,y,x1,y,x2,y1,x3,y1]);
      end
      else
      begin
       result:=result+format('%g %g m'#10'%g %g l'#10,  [x,y,x1,y]);
       result:=result+format('%g %g m'#10'%g %g l'#10,  [x,y,x,y2]);
      end;
      Result:=Result+format('q /F1 %f Tf'#10,[fs]);


      //draw ticks
      for i:=0 to MaxScale do
      begin
        thisy:=y+(i*r*MaxValue/MaxScale);
        result:=result+format('%g %g m'#10'%g %g l'#10's'#10,[x-2,thisy,x,thisy]);//draw tick marks of vbar
        //if maxvalue > 100 then
        //  result:=result+TextAt(x-2,thisy,Arial,fs,FormatFloat('0',(i*(maxvalue/10))),100,'R',false,'')
        //else
        result:=result+TextAt(x-2,thisy,Arial,fs,FormatFloat(Formats[intFormat],(i*MaxValue/MaxScale)),100,'R',false,'');


      end;

      y:=y+VBoxHeight+40;
      x:= x+VBoxLength*0.5;

      result:=result+TextAt(x,y,Arial,fs,l1,round(VBoxLength),'CU',false,'');
      result:=result+TextAt( x,yGlobal,Arial,fs,l2,round(VBoxLength),'C',false,'');
      result:=result+'Q'#10;
  end;

  function Vbar(x,y,h,w:double;bg1,bg2,bg3:string;sig:boolean;r:double):string;
    var x1,x2,x3,
        y1,y2,y3:double;
        p:string;
        i:integer;
        tempY:double;
  begin
     x1 := x+w;
     x2 := x1 +(VBarDepth);
     x3 := x + (VBarDepth);

     y1 := y + (VBarDepth);
     y2 := y1 + h*r;
     y3 := y + h*r;

     result:='q 1 w'#10'1 j'#10;

     result:=result+format(bg1+'q %g %g %g %g re'#10' W b'#10,[x,y,w,h*r]);//rectangle

     if sig then
     begin
       result:=Result+'.8 G 1.2 w'#10;
       tempy:=y-40;
       for i:= 1 to 50 do
       begin
          result:=result+format('%g %g m %g %g l S'#10' b'#10,[x,TempY,x+w,TempY+34.2]);
          tempy:=tempy+5;
       end;
       result:=result+format('0 G 1 w %g %g %g %g re'#10's'#10,[x,y,w,h*r]);//rectangle
     end;
     result:=Result+'Q'#10   ;

     if bool3D then
     begin
       result:=result+format(bg2+'q %g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'W b'#10,[x1,y,x2,y1,x2,y2,x1,y3]);
       if sig then
       begin
        // result:=result+'/Pattern cs /P1 scn'#10;
         result:=Result+'.8 G 1.2 w'#10;
         tempy:=y-0.5;
         for i:= 1 to 50 do
         begin
          result:=result+format('%g %g m %g %g l s'#10,[x1,TempY,x2,y1+(tempy-y)]);
          tempy:=tempy+5;
         end;
         result:=result+format('0 G %g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10's'#10,[x1,y,x2,y1,x2,y2,x1,y3]);
       end;
       result:=Result+'Q'#10;

       result:=result+format(bg3+'%g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'W b'#10,[x1,y3,x2,y2,x3,y2,x,y3]);
       if sig then
       begin
         tempy:=x;
         result:=Result+'.8 G 1.2 w'#10;
         for i:= 1 to MaxScale do
         begin
          result:=result+format('%g %g m %g %g l s'#10,[Tempy,y3,tempy+w,y3+34.2]);
          tempy:=tempy+5;
         end;
         result:=result+format('0 G %g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10's'#10,[x1,y3,x2,y2,x3,y2,x,y3]);
       end;
     end;
     result:=result+'Q '#10;
     result:=result+p;

  end;


  Function GetVbars(var x,y:double;ComponentID:string;cn:variant;PageNumber:integer):String;
  var
    i:integer;
    Lbl, YAxisLabel :string;
    h: double;
    sig: boolean;
    Curr:  boolean;
    InitialX:double;
    s2:string;
    rs:variant;

    bg:array[1..4] of carray;
    c:integer;
    BarsCount:integer;
    s:string;
    s1,s3:string;
    r:double;
    MeasureType:integer;
    DisplayYAxisLabel : Boolean;
  begin
    s1:='';
    bg[1]:=GetShade([0.7, 0.7, 2],'rg'); //blue
    bg[2]:=GetShade([1.2, 0, 0], 'rg'); //red
    bg[3]:=GetShade([1.6, 1.6, 0.6], 'rg'); //yellow
    result:=Format('0 g /F1 %f Tf'#10,[fs]);

    s:= format('select count(distinct column_nbr) from %s where job_id =''%s'' and component_id =%s and page_number = %d',
        [vbar_final,job_id,ComponentID,PageNumber]);

    rs:=cn.execute(s);

    BarsCount := rs.fields[0].value;
    rs.close;
    rs:=UnAssigned;
    case BarsCount of
      0 : begin BarDist:=inch*0.5; BarsCount:=1; end;
      1 : BarDist:=inch*0.5;
      2 : BarDist:=inch*0.4;
      3 : BarDist:=inch*0.3;
      4 : BarDist:=inch*0.2;
      else BarDist:=inch*0.1;
    end;

    BarWidth:=(VBoxLength/BarsCount)-bardist*1.25;
    if BarWidth > inch*0.75 then BarWidth := inch*0.75;

    s:=Format('select '+
              'Job_ID,'+
              'AP_ID,'+
              'Page_Number,'+
              'Component_ID,'+
              'Column_Nbr,'+
              'Label,'+
              'Label1,'+
              'Labelb,'+
              'ScaleID,'+
              'Value,'+
              'isnull(MaxValue,100) as MaxValue,'+
              'ValueFormat,'+
              'IsCurrent,'+
              'Sig, '+
              'VBarMeasureLabelAlignment ' +
              ' from %s where job_id =''%s'' and component_id =''%s'' and page_number = %d '+
              'AND (Job_id=''%s'') '+
              'ORDER BY [column_nbr]',
              [vbar_final,job_id,ComponentID,PageNumber,job_id]);

    rs:=cn.execute(s);

    if ((rs.eof) and (rs.bof))then
    begin
        result:=result+vbox(x,y,'.4 g'#10,'.7 g'#10,'','',r);
        y:=y-60;
        rs.close;
        rs:=UnAssigned;
        Exit;
    end;

    intFormat := rs.fields['ValueFormat'].value;

    if intFormat > 2 then intFormat := 2;//do not want to display %

//    if MeasureType = 1 then
      MaxValue := rs.fields['MaxValue'].value;
//    else
//      MaxValue := 100;


    if MaxValue <=0 then MaxValue := 100;
    MaxScale := ceil(MaxValue);

    for i := 15 downto 1 do
      if ((MaxScale mod i) = 0) then
      begin
        MaxScale := i;
        break;
      end;
    //

    if ((MaxScale = 1) and (intFormat>1)) then
      MaxScale := 10;  //do this only if not dealing with whole numbers


    r:= vboxHeight/MaxValue;
    InitialX:=x;
    s2:='';
    s3:='';
    //GN01: Y-Axis Label
    DisplayYAxisLabel := (rs.fields['VBarMeasureLabelAlignment'].Value = 2); //1-Top, 2- Left
    if DisplayYAxisLabel then
    begin
       s2:=vbox(x,y,'.4 g'#10,'.7 g'#10,vartostr(rs.fields['label1'].value),'',r);
       ActiveFont:='/F1';
       s3:=s3+Format('q 0 g BT %s %f Tf 0 1 -1 0 %g %g Tm (%s) Tj ET Q'#10,[ActiveFont, fs+1, x-inch*0.3,
       y+(VBoxHeight- GetTextWidth(VarToStr(rs.fields['labelb'].Value),Arial, fs+1))/2, //Center the text in the Y-CoOrd
       VarToStr(rs.fields['labelb'].Value)]);

    end
    else
    begin
       s3 := '';
       s2:=vbox(x,y,'.4 g'#10,'.7 g'#10,vartostr(rs.fields['label1'].value),VarToStr(rs.fields['labelb'].Value),r);
    end;
    x:=x+bardist;
    i:=1;
   while not rs.eof do
    begin
       if varisnull(rs.fields['value'].value) then
         h:= -1
       else
         h:=StrToFloat(trim(vartostr(rs.fields['value'].value)));
       //h:=100;
       lbl:=trim(vartostr(rs.fields['label'].value));
       sig :=(not varisnull(rs.fields['sig'].value)) and (showsig);
       Curr:=rs.fields['IsCurrent'].value;
       if Curr then c:= 1
       else if sig then c:=2
       else c:=3;
       if h > -1 then
       begin
         s2:=s2+vbar(x,y,h,BarWidth,bg[c][1],bg[c][2],bg[c][3],Sig,r);
         //if maxvalue >100 then
         //  s:=FormatFloat('0',round(h*10000)*0.0001)
        // else
           s:=FormatFloat(Formats[intFormat],round(h*10000)*0.0001);


         if sig then s:=s+'*';

         if bool3D then
         begin
           //s1:=s1+format('q 1 g 1 w %g %g %g %g re f Q'#10,[x+VBarDepth,y+VBarDepth+h*r+1,barwidth,fs]);

           s1:=s1+'q 2 w 1 G 2 Tr'#10;     //this will print white stroked text first
           s1:=s1+TextAt(x+VBarDepth+barwidth*0.5,y+VBarDepth+h*r+2,Arial,fs,s,round(barwidth+bardist),'C',false,'');
           s1:=s1+'0 Tr'#10;              //then black filled text
           s1:=s1+TextAt(x+VBarDepth+barwidth*0.5,y+VBarDepth+h*r+2,Arial,fs,s,round(barwidth+bardist),'C',false,'');
           s1:=s1+'Q'#10;
         end
         else
         begin
           //s1:=s1+format('q 1 g 1 w %g %g %g %g re b Q'#10,[x,y+h*r+1,barwidth,fs]);
           s1:=s1+'q 2 w 1 G 2 Tr'#10; //this will print white stroked text first
           s1:=s1+TextAt(x+barwidth*0.5,y+h*r+2,Arial,fs,s,round(barwidth+bardist),'C',false,'');
           s1:=s1+'0 Tr'#10;          //then black filled text
           s1:=s1+TextAt(x+barwidth*0.5,y+h*r+2,Arial,fs,s,round(barwidth+bardist),'C',false,'');
           s1:=s1+'Q'#10;
         end;

       end;
       if lbl <> '' then //print lables
         s2:=s2+textat(x+barwidth*0.5,y-10,Arial,fs,lbl,round((barwidth+bardist)+0.5)-1,'C',false,'');

       x:=x+barwidth+bardist;
       inc(i);
       rs.movenext;
    end;
    x:=InitialX+bardist+barwidth*0.5;


    y:=y-65;
    lbl:='';

    if componentid = '1' then
    begin
      x:=x-10;
      Lbl:='* Significantly Different from Your Current Score';
      if bool3D then
        Lbl:='/F1 8 Tf'#10+textat(pagewidth*0.5+VBarDepth+20,y+15,Arial,8,lbl,300,'L',false,'')
      else
        Lbl:='/F1 8 Tf'#10+textat(pagewidth*0.5+20,y+15,Arial,8,lbl,300,'L',false,'');

      tmp3d:=bool3D;
      bool3D:=false;
      Lbl:=Lbl+vbar(pagewidth*0.5+VBarDepth-BarWidth,y+10,11,BarWidth,bg[2][1],bg[2][2],bg[2][3],true,1);
      bool3d:=tmp3d;
    end;
    y:=y+5;
    s2:=s3+s2+s1+lbl;
    result:=result+s2;
  end;



end.
