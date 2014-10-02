unit TextMeasure_saved;
interface
uses SysUtils,windows,constants,classes;
type carray = array [1..3] of string;

function GetTextWidth(s,fn:string;fs:integer):double;
Function TextAt(x,y:double;fn:string;fs:integer;s:string;MaxWidth:integer;alignment:string;WrapUp:boolean):string;
Function GetShade(rgb:array of double;c:string):carray;
Function GetVal(v:variant):string;
function isColString(s:string):boolean;
Function CrossHatch(x,y,h,w,d:double):string;

implementation

function WideChars(s:string;fs:integer): double;
 var i:integer;
     l:integer;
     c:integer;
begin
   l:=length(s);
   c:=0;
   result:=0;
   for i:= 1 to l do
     if s[i] in ['m','w','A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','2','3','4','5','6','7','8','9','0'] then
      inc(c);

   Result:=c*fs*0.1;

end;

function GetTextWidth(s,fn:string;fs:integer):double;
begin
  form1^.canvas.Font.Name := fn;
  form1^.canvas.Font.Size := fs;
  result:=(form1^.Canvas.TextWidth(s)) //+WideChars(s,fs);
end;

Function TextAt(x,y:double;fn:string;fs:integer;s:string;MaxWidth:integer;alignment:string;WrapUp:boolean):string;
var tw:double;
    i:integer;
    p:integer;
    this:string;
    t:string;
    underline:boolean;
    lc:integer; //linecount
    sl:tstringlist;
begin
  sl:=tstringlist.create ;
  memo1.Width := MaxWidth;
  memo1.Text := s;
  //m.WordWrap:=true;
  this:='';
  Alignment:=UpperCase(Alignment);
  Underline:= pos('U',Alignment)>0;


  {  MaxWidth:=MaxWidth-5;
  Alignment:=UpperCase(Alignment);
  Underline:= pos('U',Alignment)>0;


  repeat
    this:='';
    for i:=1 to length(s) do
    begin
      this:=this+s[i];
      tw:=gettextwidth(this,fn,fs);
      if tw>=MaxWidth then break;
    end;
    delete(s,1,length(this));
    if this<> '' then sl.Add(this);

  until s='';

  this:='';}




  for i:= 0 to memo1.Lines.Count-1  do
  begin
    if trim(memo1.lines[i]) = '' then

    else
    begin
      if lc > i then
      begin
        if length(memo1.lines[i+1])<3 then
        begin
          sl.Add(memo1.Lines[i]+memo1.Lines[i+1]);
          memo1.Lines.Delete(i+1);
        end
        else
        if pos(' ',memo1.Lines[i+1]) in [2,3] then
        begin
          sl.Add(memo1.Lines[i]+copy(memo1.Lines[i+1],1,pos(' ',memo1.Lines[i+1])));
          memo1.Lines[i+1]:=copy(memo1.Lines[i+1],pos(' ',memo1.Lines[i+1]),length(memo1.Lines[i+1]));
        end
        else
          sl.Add(memo1.Lines[i]);
      end
      else
       sl.Add(memo1.Lines[i]);
    end;
  end;

  lc:=sl.Count-1;

  if WrapUp then
     y:=y+(fs*lc);

  for i:= 0 to lc do
  begin
      t:=trim(sl.Strings[i]);
      case Alignment[1] of
        'R': tw:=gettextwidth(t,fn,fs);
        'C': tw:=gettextwidth(t,fn,fs)*0.5;
        else tw:=0;
      end;
      p:= pos('(',t);
      if p>0 then insert('\',t,p);
      p:= pos(')',t);
      if p>0 then insert('\',t,p);

      if Underline then this:=this+format('0.5 w %g %g m %g %g l s'#10,[x-tw,y-1,x-tw+gettextwidth(t,fn,fs),y-1]);

      this:=this+Format('q BT %g %g  Td(%s)Tj ET Q'#10,  [x-tw,y,t]);

      y:=y-fs;
  end;
  sl.Free;
  result:=this;
end;

Function GetVal(v:variant):string;
begin
  if varisnull(v) then
    Result:='-1'
  else
    Result:=formatFloat('0.0',double(v));

end;



Function GetShade(rgb:array of double;c:string):carray;
begin
  if ((c <>'RG') and (c<>'rg')) then c:='rg';
  result[1]:=format('%0.1g %0.1g %0.1g %s'#10,[rgb[0],rgb[1],rgb[2],c]);
  result[2]:=format('%0.1g %0.1g %0.1g %s'#10,[rgb[0]*0.5,rgb[1]*0.5,rgb[2]*0.5,c]);
  result[3]:=format('%0.1g %0.1g %0.1g %s'#10,[rgb[0]*1.5,rgb[1]*1.5,rgb[2]*1.5,c]);
end;

function isColString(s:string):boolean;
const c:array[1..7] of string =('TOP BOX',
                                'TOP 2 BOX',
                                'TOP 3 BOX',
                                'BOTTOM BOX',
                                'BOTTOM 2 BOX',
                                'SECOND BOX',
                                'THIRD BOX');
var i:integer;
begin
  s:=uppercase(s);
  for i:=1 to high(c) do
  begin
    result:=s=c[i];
    if result then break;
  end;
end;

Function CrossHatch(x,y,h,w,d:double):string;
var
  py:double;
  px:double;
  d1:double;
  d2:double;
  i:integer;
begin
  py:=y-w;
  px:=x;
  result:='q .25 w .5 G'#10;   //save graphic state
  for i:=round(0-w) {go below y} to round(h-1.5) do
    if i mod step = 0 then
    begin
      py:=py+step;
      if py+w>y+h then
        d1:=(py+w)-(y+h)
      else
        d1:=0;

      if py < y then
      begin
        d2:=y-py;
      end
      else
        d2:=0;

      result:=result+format('%g %g m %g %g l s'#10,[px+d2,py+d2,px+w-d1,py+w-d1]); //fill rectangle wih cross-hatch
      if py>y then
       result:=result+format('%g %g m %g %g l s'#10,[x+w,y+i,x+w+d,(y+d)+i]); //fill side
    end;

  for i := 1 to round(w-0.5) do
    if i mod step = 0 then
     result:=result+format('%g %g m %g %g l s'#10,[x+i,y+h,x+d+i,y+h+d]);//fill top

  result:=result+'Q'#10; //restore graphic state
end;

end.
