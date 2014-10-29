unit TabularTitle;

interface

uses SysUtils,constants,classes,comobj,textmeasure,AddNewPage;

procedure GetTabularTitle(var y:double; Job_id, componentid:string; page:integer; cn:variant;pages:tstringlist;var buf:string);

implementation

procedure GetTabularTitle(var y:double; Job_id, componentid:string; page:integer; cn:variant;pages:tstringlist;var buf:string);
var rs:variant;
    s:string;
    x:double;
    Font:string;
begin


  s:= format('SELECT ' +
                 'ComponentTitle '+
                 'FROM apo_tabularRankingTitleFinal '+
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

  while not rs.eof do
  begin

    if y<60+11*4 then
    begin
      pages.AddObject(buf,tobject(true));
      if not (pages.count+1 in NoLegendPages) then
          NoLegendPages:=NoLegendPages+[pages.count+1];

      if Landscape then
          LandscapePages:=LandscapePages+[pages.count+1];

      buf:=PageHeader(y,true);
      y:= y-18;
    end;
    s := trim(vartostr(rs.fields['ComponentTitle'].value));
    Font:=ActiveFont;
    activeFont:='/F2';
    buf:=buf+textat(x,y,'Arial',11.0,s,round(pagewidth-x*2),'LB',False,'');
    activeFont:='/F1';
    y:=y-fs;
    rs.movenext;
  end;
  y:=y-fs;

  ActiveFont:=Font;

  rs.close;
  rs:=unassigned;

end;

end.

