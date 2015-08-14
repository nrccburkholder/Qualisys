unit ScaleLabels;

{*******************************************************************************
Program Modifications:
--------------------------------------------------------------------------------
Date        UserId   Description
-------------------------------------------------------------------------------
11-07-2005   GN01    Adjusted the ScaleLabel to the left as it was not aligned
                     properly with the current data column
*******************************************************************************}

interface
uses TextMeasure,sysutils,constants;

function GetScaleLabel(Measure:Integer;ScaleLabel,group:string;x,y:double;stacked_bars:boolean;fs:double):string;
implementation

    function GetScaleLabel(Measure:Integer;ScaleLabel,group:string;x,y:double;stacked_bars:boolean;fs:double):string;
    var measure_label:string;
        a:char;
    begin
       a:='R';
       //* measure and scale indicator */
       case measure of
         2 : if not stacked_bars then
               begin
                  if group = '' then
                     measure_label := ScaleLabel
                  else
                     measure_label := ScaleLabel;
               end
               else if group <> '' then
               begin
                  measure_label := ScaleLabel;
                  a:='C';
               end;
         else  measure_label := trim(ScaleLabel);
       end;
       if a = 'C' then
         Result:=TextAt(pagewidth*0.5,y,'',fs,Measure_Label,round(pagewidth*0.5)-50,'C',false,'')
       else
        if measure = 1 then
          //Result:=TextAt(pagewidth*0.5,y,Arial,fs,trim(Measure_Label),round(pagewidth*0.5)-50,'CU',False,'') //GN01
          Result:=TextAt( pagewidth*0.4,y,'',fs,trim(Measure_Label),round(inch * 3.0),'CU',False,'') //GN01
       else
        if measure = 2 then
         Result:=TextAt( x,y,'',fs,trim(Measure_Label),round(x-50),a+'I',false,'')
        else
         Result:=TextAt( x,y,'',fs,trim(Measure_Label),round(x-50),a+'U',false,'');

      end;

end.
