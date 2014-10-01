unit TextMeasure;
interface
uses SysUtils,windows,constants,classes,stdctrls,Dialogs,printers,forms,Graphics;
type carray = array [1..3] of string;

function GetTextWidth(s,fn:string;fs:double):double;
Function TextAt(x,y:double;fn:string;fs:double;s:string;MaxWidth:integer;alignment:string;WrapUp:boolean;ThisFont:string):string;
Function WriteParagraph(x:double; var y:double;fn:string;fs:double;s:string;MaxWidth:Double;alignment:string) : string;
Function GetVal(v:variant):string;
function isColString(s:string):boolean;
function TranslateSasDate(sasdate:double):tdatetime;


implementation


function InStr(Start: integer; Source: string; SubStr: string): integer;
var l:integer;
begin
  result:=0;
  l:=Length(Source);
  if Start=0 then Start:=1;
  if Start>l then exit;

  l := pos(SubStr,copy(Source,Start,l-(Start - 1) ));
  if l>0 then
    result:=l+Start-1;

end;



function FindAndInsert(Source, SubStr, NewStr:string): String;
var
    i: integer;
    lSub: Longint;
    lData: Longint;
begin
   i:=0;
   repeat
     i := InStr(i+1, Source, SubStr);

     If i > 0 Then
     begin
       insert(NewStr,Source,i);
       inc(i);
     end;
   Until i = 0;

   Result := Source;
end;



function TranslateSasDate(sasdate:double):tdatetime;
var  sasbase,delphibase,datedif:tdatetime;
begin
  if sasdate = 0 then
      sasdate:=LastGoodDate
  else LastGoodDate:=sasdate;
  sasbase:=strtodatetime('1/1/1960');
  delphibase:=strtodatetime('12/30/1899');
  datedif:=sasbase-delphibase;
  result:=sasdate+datedif;
end;

function WideChars(s:string;fs:double): double;
 var i:integer;
     l:integer;
     c:integer;
begin
   l:=length(s);
   c:=0;
   result:=0;
   for i:= 1 to l do
     if s[i] in ['A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','2','3','4','5','6','7','8','9','0'] then
       inc(c);
    Result:=c*fs*(fs/72);

end;

function GetTextWidth(s,fn:string;fs:double):double;
begin
  ipdf.SetTextSize(fs);
  result:=ipdf.GetTextWidth(s);
end;


function min(a:array of variant):variant;
  var i:integer;
      t:variant;
begin
  result := 0;
  for i:=0 to high(a) do
  begin
    if result = 0 then result:= a[i];
    if (a[i] > 0) and (a[i]<result) then
      Result:=a[i];
  end;
end;


procedure breakit(var sl:tstringlist;percentage:double);
const cons = ['b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S','T','V','-'];
       vouls = ['a','e','i','o','u','w','A','E','I','O','U','W'];
       breaks =['/','-',' ','_','+'];
var p,b:integer;

    s:string;


begin
  s:=sl.strings[sl.count-1];
  p:=round(length(s)*percentage-0.5)-2;
  while s[p] in cons do
   dec(p);

   if p>2 then
   begin  //check for break points 2 pos backwards
      b:=p;
      if s[p-1] in breaks then dec(b)
      else if s[p-2] in breaks then dec(b,2)
   end;

   if b = p then
   begin //check for break points 3 spaces fordwards
     case p-length(s) of
       0:;
       1,2: p:=length(s);
       else
         if s[p+1] in breaks then inc(p)
           else if s[p+2] in breaks then dec(p,2)
             else if s[p+3] in breaks then dec(p,3);
     end;
   end;
  sl.strings[sl.count-1]:=copy(s,1,p)+'-';
  delete(s,1,p);
  sl.Add(s);

end;

procedure ReplaceStr(var s:string;SearchStr,NewStr:String);
var i,p:integer;
begin
  p := 1;
  while p>0 do
  begin
    p := pos(SearchStr,s);
    if p > 0 then
    begin
      delete(s,p,length(SearchStr));
      if NewStr <> '' then
        insert(NewStr,s,p);
    end;
  end;
end;


function SplitLabel(s:string;MaxWidth:integer;fn:string;fs:double):tstringlist;
  var i,tw,p1,p,p2:integer;
      s1,s2:string;
      sl:tstringlist;
      w2:double;
      HasCustomBreak:boolean;
      canBreak:boolean;


begin
// s:= trim(s);
 result:=tstringlist.create;
 result.addobject('',tobject(0));

 //Handle custome breaks.
 ReplaceStr(s,'<br>',#10);
 ReplaceStr(s,#13#10,#10);
 ReplaceStr(s,'#',#10);

 tw:=1;

 HasCustomBreak := false;
 if Pos(#10,s)>0 then
 begin //make sure all pieces fit column
   HasCustomBreak := true;
   result.SetText(pchar(s));
   for i := 0 to result.Count -1 do
   begin
      s1:=result.Strings[i];
      tw:=round(GetTextWidth(s1,fn,fs)+0.5);
      if (tw > MaxWidth) then
      begin   //if a string does not fit col width, remove custom breaks
        ReplaceStr(s,#10'/','/');
        ReplaceStr(s,'/'#10,'/');
        ReplaceStr(s,#10'-','-');
        ReplaceStr(s,'-'#10,'-');
        ReplaceStr(s,#10'+','+');
        ReplaceStr(s,'+'#10,'+');
        ReplaceStr(s,#10'_','_');
        ReplaceStr(s,'_'#10,'_');
        ReplaceStr(s,#10,' ');
        result.Clear;
        result.Add('');

        HasCustomBreak := false;
        break;
      end;
   end;
 end;

 if not HasCustomBreak then
 while (length(s)>0) do
 begin
   tw:=min([pos(' ',s),pos('/',s),pos('_',s),pos('-',s),pos('+',s),pos(' ',s)]);
   MaxWidth:=abs(MaxWidth);
   if tw=0 then
   begin
     s1:=s;
     if (GetTextWidth(result.Strings[result.Count-1]+s1,fn,fs) < MaxWidth) and (integer(result.objects[result.Count-1]) = 0) then
       result.Strings[result.Count-1]:=result.Strings[result.Count-1]+s1
     else
       result.addObject(s1,tobject(0));
     break;
   end;
   s1:=copy(s,1,tw);
   delete(s,1,tw);

   if (GetTextWidth(result.Strings[result.Count-1]+s1,fn,fs) < MaxWidth) and (integer(result.objects[result.Count-1]) = 0) then
     result.Strings[result.Count-1]:=result.Strings[result.Count-1]+s1
   else
     result.addobject(s1,tobject(0));

   w2:= GetTextWidth(result.Strings[result.Count-1],fn,fs);

   if integer(result.objects[result.Count-1]) = 0 then
   if w2>MaxWidth then
   begin
     w2:=MaxWidth / w2;
     breakit(result,w2);
   end;
 end;

for i:= result.count-1 downto 0 do
   if trim(result.strings[i])='' then
     result.Delete(i);

end;


Function TextAt(x,y:double;fn:string;fs:double;s:string;MaxWidth:integer;alignment:string;WrapUp:boolean;ThisFont:string):string;
var tw:double;
    i:integer;
    p:integer;
    this:string;
    t:string;
    x1,x2:double;
    underline:boolean;
    lc:integer; //linecount
    sl:tstringlist;
begin
  ActualColWidth := MaxWidth;
  if ThisFont = '' then
    ThisFont := ActiveFont;
  if trim(s)='' then exit;
  sl:=tstringlist.create ;
  this:='';
  SigArrowPos:=0;
  Alignment:=UpperCase(Alignment);
  Underline:= pos('U',Alignment)>0;

  sl.Assign(SplitLabel(s,MaxWidth,fn,fs));

  lc:=sl.Count-1;

  if WrapUp then
  begin
     y:=y+(fs*lc);
     yGlobal:=y+fs;
  end;
  
  for i:= 0 to lc do
  begin
      x2:=x;
      t:=trim(sl.Strings[i]);
      tw:=gettextwidth(t,fn,fs);
      if tw > ActualColWidth then
         ActualColWidth := tw;

      case Alignment[1] of
        'R': begin x1:=x; x:=x-tw end;
        'L': x1:=x+tw;
        'C': begin tw:=tw*0.5; x1:=x+tw;x:=x-tw; end;
      end;
      {
      p:=pos(')',t);
      while p > 0 do
      begin
        insert('\',t,p);
        p:=pos(')',t);
      end;
       }
      t:=FindAndInsert(t,'(','\');
      t:=FindAndInsert(t,')','\');
      //ReplaceStr(t,'½','\275');

      if pos('I',Alignment)>0 then
        this:=this+Format('q BT %s %f Tf 1 0 0.3 1 %g %g  Tm 0 0 Td(%s)Tj ET Q'#10,  [ThisFont,fs,x,y,t])
      else
      this:=this+Format('q BT %s %f Tf %g %g  Td(%s)Tj ET Q'#10,  [ThisFont,fs,x,y,t]);
      if  SigArrowPos< x then SigArrowPos:= x+gettextwidth(t,fn,fs)+2;
      if Underline then
         this:=this+format('0.5 w %g %g m %g %g l s'#10,[x,y-1,x1,y-1]);
      x:=x2;
      y:=y-fs;
  end;

  if ActualColWidth <= 0 then ActualColWidth := MaxWidth;

  if not WrapUp then yGlobal:=y;
//  lc:=sl.Count;
  if lc>0 then
   LinesHeight:=lc*fs;
  sl.Free;
  sl:=nil;
  result:=this;

end;


procedure SplitParagraphs(s:string;MaxWidth:Double;fn:string;fs:double;StringList:tstringlist);
  var i,tw,p1,p,p2:integer;
      s1,s2:string;
      w2:double;
      HasCustomBreak:boolean;
      canBreak:boolean;
begin

  //Handle custome breaks.
  ReplaceStr(s,'<br>',#10);
  ReplaceStr(s,#13#10,#10);
  ReplaceStr(s,'#',#10);

  tw:=1;

  //s := ipdf.GetWrappedText(200, #10, s);
  s1:='';
  s2:='';
  while s<>'' do
  begin
    p:=min([pos(' ',s),pos('/',s),pos('_',s),pos('-',s),pos('+',s),pos(' ',s),pos(#10,s),pos('.',s),pos(',',s),pos(';',s),pos(':',s),pos('?',s)]);

    if p>0 then
    begin
      s2 := copy(s,1,p);
      delete(s,1,p);

      if (GetTextWidth(s1+s2,fn,fs) < MaxWidth) then
      begin
        s1:=s1+ s2;
        if s2[length(s2)] = #10 then
        begin
           StringList.Add(trim(s1));
           s1:='';
           s2:='';
        end;
      end
      else
      begin
        StringList.Add(s1);
        p := pos(#10,s2);

        if p>0 then
        begin
          StringList.Add(trim(s2));
        end
        else
        begin
          s1:=s2;
        end;
      end;
    end
    else
      if (GetTextWidth(s1+s,fn,fs) < MaxWidth) then
      begin
         s1:=s1+s;
         s:=''
      end
      else
      begin
        if trim(s) <> '' then
          StringList.Add(s);
      end;
      if s = '' then
        StringList.Add(s1);


  end;
end;

Function WriteParagraph(x:double; var y:double;fn:string;fs:double;s:string;MaxWidth:Double;alignment:string) : string;
var tw:double;
    i:integer;
    p:integer;
    t:string;
    x1,x2:double;
    underline:boolean;
    lc:integer; //linecount
    sl:tstringlist;
begin
  if trim(s)='' then exit;
  sl:=tstringlist.create ;
  result:='';
  SigArrowPos:=0;
  Alignment:=UpperCase(Alignment);
  Underline:= pos('U',Alignment)>0;

  SplitParagraphs(s,MaxWidth,fn,fs,sl);

  lc:=sl.Count-1;

  for i:= 0 to lc do
  begin
      x2:=x;
      t:=trim(sl.Strings[i]);
      case Alignment[1] of
        'R': begin tw:=gettextwidth(t,fn,fs); x1:=x; x:=x-tw end;
        'L': begin tw:=gettextwidth(t,fn,fs); x1:=x+tw end;
        'C': begin tw:=gettextwidth(t,fn,fs)*0.5; x1:=x+tw;x:=x-tw; end;
      end;

      t:=FindAndInsert(t,'(','\');
      t:=FindAndInsert(t,')','\');

      if pos('I',Alignment)>0 then
        result:=result+Format('q BT %s %f Tf 1 0 0.3 1 %g %g  Tm 0 0 Td(%s)Tj ET Q'#10,  [activefont,fs,x,y,t])
      else
      result:=result+Format('q BT %s %f Tf %g %g  Td(%s)Tj ET Q'#10,  [activefont,fs,x,y,t]);

      if Underline then
         result:=result+format('0.5 w %g %g m %g %g l s'#10,[x,y-1,x1,y-1]);
      x:=x2;
      y:=y-fs;
  end;

  sl.Free;
  sl:=nil;
  result:=result;
end;

Function GetVal(v:variant):string;
var r:integer;
    s:string;
    v1:double;
begin
  s:=vartostr(v);
  val(s,v1,r);
  if r>0 then v1:=-1;

  Result:=formatFloat('0.0000000000',v1);

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

end.
