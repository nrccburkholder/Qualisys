unit Narrative;

interface

uses SysUtils,constants,classes,comobj,textmeasure;

function GetNarrative(var y:double; Job_id, componentid:string; page:integer; cn:variant):string;

implementation

function GetNarrative(var y:double; Job_id, componentid:string; page:integer; cn:variant):string;
var rs:variant;
    s:string;
    x:double;
    Font:string;
begin
  Result:='';
  s:= format('SELECT ' +
                 'ComponentTitle,'+
                 'Paragraph '+
                 'FROM APO_NarrativeFinal '+
                 'WHERE Job_id = %s '+
                 'and component_id = %s '+
                 'and page_number = %d ',
                 [Job_id,Componentid,page]);
  rs:=cn.execute(s);

  if rs.eof then
  begin
    rs.close;
    rs:=unassigned;
    exit;
  end;
  y:= y-18;
  x:=LeftMargin+11;
  s := trim(vartostr(rs.fields['ComponentTitle'].value));
  //if pos(':',s) = 0 then s:=s+':';
  Font:=ActiveFont;
  ActiveFont:='/F2';
  result:=textat(x,y,'Arial',11.0,s,round(pagewidth-x*2),'LB',False,'');
  s := vartostr(rs.fields['Paragraph'].value);
  y:=yGlobal-11;
  ActiveFont:='/F1';
  result := result+WriteParagraph(x,y,'Arial',9.0,s,pagewidth-x*2,'L');
  ActiveFont:=Font;
  rs.close;
  rs:=unassigned;  
end;

end.
