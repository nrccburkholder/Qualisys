unit Wwstr;
{
//
// Commonly used string manipulation functions
//
// Copyright (c) 1995 by Woll2Woll Software
//
}

interface
uses classes, dialogs, wwtypes;

type
  strCharSet = Set of char;

procedure strBreakApart(s: string; delimeter: string; parts: TStrings);
Function strGetToken(s: string; delimeter: string; var APos: integer): string;
Procedure strStripPreceding(var s: string; delimeter: strCharSet);
Procedure strStripTrailing(var s: string; delimeter: strCharSet);
Procedure strStripWhiteSpace(var s: string);
Function strRemoveChar(str: string; removeChar: char): string;
Function strReplaceChar(field1Name: string; removeChar, replaceChar: char): string;
Function strReplaceCharWithStr(str: string; removeChar: char;replaceStr: string): string;
Function wwEqualStr(s1, s2: string): boolean;
Function strCount(s: string; delimeter: char): integer;
Function strWhiteSpace : strCharSet;
Function wwGetWord(s: string; var APos: integer; Options: TwwGetWordOptions;
                   DelimSet: strCharSet): string;
Function strTrailing(s: string; delimeter: char): string;

implementation

uses sysutils;

  Function strWhiteSpace : strCharSet;
  begin
     Result := [' ',#9];
  end;

  Function strGetToken(s: string; delimeter: string; var APos: integer): string;
  var tempStr: string;
      endStringPos: integer;
  begin
     result:= '';
     if APos<=0 then exit;
     if APos>length(s) then exit;

     tempStr:= copy(s, APos, length(s)+1-APos);
       {Converts to Uppercase for check if delimeter more than one character}
     if (length(delimeter)=1) then
     {$IFNDEF VER100}
        endStringPos:= pos(delimeter, tempStr)
     {$ELSE}
        endStringPos:= AnsiPos(delimeter, tempStr)
     {$ENDIF}
     else begin
        delimeter := ' ' + delimeter + ' ';
        {$IFNDEF VER100}
        endStringPos:= pos(UpperCase(delimeter),UpperCase(tempStr));
        {$ELSE}
        endStringPos:= AnsiPos(UpperCase(delimeter),UpperCase(tempStr));
        {$ENDIF}
     end;

     if endStringPos<=0 then begin
        result:= tempStr;
        APos:= -1;
     end
     else begin
        result:= copy(tempStr, 1, endStringPos-1);
        APos:= APos + endStringPos + length(delimeter) - 1;
     end
  end;

  procedure strBreakApart(s: string; delimeter : string; parts : TStrings);
  var curpos: integer;
      curStr: string;
  begin
     parts.clear;
     curStr:= s;
     repeat
        {$IFNDEF VER100}
        curPos:= pos(delimeter, curStr);
        {$ELSE}
        curPos:= AnsiPos(delimeter, curStr);
        {$ENDIF}
        if (curPos>0) then begin
           parts.add(copy(curStr, 1, curPos-1));
           curStr:= copy(curStr, curPos+1, length(curStr)-(curPos));
        end
        else parts.add(curStr);

     until curPos=0;

  end;

  Procedure strStripWhiteSpace(var s: string);
  var tempstr: string;
  begin
     tempstr := s;
     strStripPreceding(tempstr,strWhiteSpace);
     strStripTrailing(tempstr,strWhiteSpace);
     s := tempstr;
  end;

  Procedure strStripPreceding(var s: string; delimeter: strCharSet);
  var i,len: integer;
  begin
    i:= 1;
    len:= length(s);
    while (i<=length(s)) and (s[i] in delimeter) do i:= i+1;
    if ((len<>0) and (i<=len)) then
       s:= copy(s,i,len-i+1)
    else if (len<>0) then s:='';
  end;

  Procedure strStripTrailing(var s: string; delimeter: strCharSet);
  var len: integer;
  begin
     len:= length(s);
     while (len>0) and (s[len] in delimeter) do len:= len-1;

     {$IFDEF WIN32}
     setLength(s, len);
     {$ELSE}
     s[0]:= char(len);
     {$ENDIF}

  end;

Function strRemoveChar(str: string; removeChar: char): string;
var i,j: integer;
    s: string;
begin
   j:= 0;
   {$IFDEF WIN32}
   setLength(s, length(str));
   {$ENDIF}

   for i:= 1 to length(str) do begin
      if (str[i] <> removeChar) then
      begin
         j:= j + 1;
         s[j]:= str[i]
      end
   end;

   {$IFDEF WIN32}
   setLength(s, j);
   {$ELSE}
   s[0]:= char(j);
   {$ENDIF}

   result:= s;
end;

Function strReplaceChar(field1Name: string; removeChar, replaceChar: char): string;
var i,j: integer;
    s: string;
begin
   j:= 0;
   {$IFDEF WIN32}
   setLength(s, length(field1name));
   {$ENDIF}

   for i:= 1 to length(field1Name) do begin
      j:= j + 1;
      if (field1Name[i] <> removeChar) then
         s[j]:= field1Name[i]
      else s[j]:= replaceChar;
   end;

   {$IFDEF WIN32}
   setLength(s, j);
   {$ELSE}
   s[0]:= char(j);
   {$ENDIF}

   result:= s;
end;

Function strReplaceCharWithStr(str: string; removeChar: char;replaceStr: string): string;
var i: integer;
begin
   Result := '';
   for i:= 1 to length(str) do begin
      if (str[i] <> removeChar) then
         Result := Result + str[i]
      else Result:= Result + replaceStr;
   end;
end;

Function strAddDoublequote(str: string):string;
var i,j: integer;
    s: string;
begin
   j:= 0;
  { s:='';}

   for i:= 1 to length(str) do begin



   end;

   {$IFDEF WIN32}
    setLength(s, length(str));
   {$ENDIF}

   for i:= 1 to length(str) do begin
      j:= j + 1;
      if (str[i] <> '''') then
         s[j]:= str[i]
      else begin
        s[j]:= str[i];
        s[j+1]:=str[i];
        j:= j+1;
      end;
   end;

   {$IFDEF WIN32}
   setLength(s, j);
   {$ELSE}
   s[0]:= char(j);
   {$ENDIF}

   result:= s;
end;

Function wwEqualStr(s1, s2: string): boolean;
begin
   result:= uppercase(s1)=uppercase(s2);
end;

Function strCount(s: string; delimeter: char): integer;
var i, count: integer;
begin
   count:= 0;
   for i:= 1 to length(s) do
      if s[i]=delimeter then inc(count);
   result:= count;
end;

Function wwGetWord(s: string; var APos: integer;
                   Options: TwwGetWordOptions; DelimSet: strCharSet): string;
var i: integer;

   Function max(x,y: integer): integer;
   begin
     if x>y then result:= x
     else result:= y;
   end;

   Procedure StripQuotes;
   begin
      if not (wwgwStripQuotes in Options) then exit;
      if (Result[1]='"') or (Result[1]='''') then
         if (Result[length(Result)] = '"') or
            (Result[length(Result)] = '''') then
            Result:= copy(Result, 2, length(Result)-2)
         else
            Result:= copy(Result, 2, length(Result)-1);
   end;

begin
   result:= '';
   if APos<=0 then exit;
   if APos>length(s) then exit;

   i:= APos;
   if (wwgwSkipLeadingBlanks in Options) then
   begin
      while (i<=length(s)) and ((s[i]=' ') or (s[i]=#9)) do inc(i);
      APos:= i;
   end;

   if (wwgwQuotesAsWords in Options) then
   begin
      if s[i]='"' then begin
         inc(i);
         while (i<=length(s)) and (s[i]<>'"') do inc(i);
         if s[i]='"' then begin
            result:= copy(s, APos, i+1-APos);
            APos:= i+1;
         end
         else if (i>length(s)) then begin
            result:= copy(s, APos, length(s));
            APos:= length(s)+1;
         end;
         StripQuotes;
         exit;
      end
   end;

   while (i<=length(s)) and (s[i] in [#33..#255]) do begin
      if (s[i] in DelimSet) then break
      else inc(i);
   end;

   result:= copy(s, APos, max(i-APos, 1));

   if length(result)>1 then APos:= i
   else APos:= i+1;

end;

Function strTrailing(s: string; delimeter: char): string;
var apos: integer;
begin
   apos:= pos(s, delimeter);
   if apos>=1 then
      result:= copy(s, apos+1, length(s)-apos)
   else result:= '';
end;

end.
