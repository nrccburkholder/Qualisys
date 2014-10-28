unit APPath;

interface
function GetAPPath(apid,client,study,survey,APDesc,outputlevel,location,HtmlPathRoot:string):string;

function GetURL(apid,client,study,survey,APDesc,outputlevel,location,URLRoot:string):string;
implementation

function GetAPPath(apid,client,study,survey,APDesc,outputlevel,location,HtmlPathRoot:string):string;
var i:integer;
begin

  for i:=1 to length(apdesc) do
    if apdesc[i] in[' ','.','/','<','>',',','?',';','''',':','"',
                    '[',']','\','{','}','|',  '`',  '-',  '=',
                    '~','!','@','#','$','%','^','&','*','(',')','+'] then
       apdesc[i]:='_';

    if outputlevel = 'SURVEY' then
      Result :=  '_'+client+'\Study_'+study+'\Survey_'+Survey+'\'
    else if outputlevel = 'STUDY' then
      Result :=  '_'+client+'\Study_'+study+'\'
    else
      Result :=  '_'+client+'\';


    result:=HtmlPathRoot+'\'+location+'\'+result;
    if apdesc<>'' then result:=result+apdesc+'_'+apid+'\';


end;


function GetURL(apid,client,study,survey,APDesc,outputlevel,location,URLRoot:string):string;
var i:integer;
begin
  for i:=1 to length(apdesc) do
    if apdesc[i] in[' ','.','/','<','>',',','?',';','''',':','"',
                    '[',']','\','{','}','|',  '`',  '-',  '=',
                    '~','!','@','#','$','%','^','&','*','(',')','+'] then
       apdesc[i]:='_';

    if outputlevel = 'SURVEY' then
      Result :='/_'+client+'/Study_'+study+'/Survey_'+Survey+'/'
    else if outputlevel = 'STUDY' then
      Result := '/_'+client+'/Study_'+study+'/'
    else
      Result :=  '/_'+client+'/';

    result:=URLRoot+location+result;
    if apdesc<>'' then result:=result+apdesc+'_'+apid+'/';

end;

end.
