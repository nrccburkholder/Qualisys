unit zlibStr;

interface
uses zlib;

function CompressStr(s:string):string;
procedure DecompressStr(var s:string);

implementation

function CompressStr(s:string):string;
var cnt:integer;
    p1,p2:pointer;
    i:integer;
begin
  p1:=@s[1];
  p2:=nil;
  CompressBuf(p1,length(s),p2,cnt);
  setlength(result,cnt);
  move(p2^,result[1],cnt);
  p1:=nil;
  p2:=nil;
end;

procedure DecompressStr(var s:string);
var est,cnt:integer;
    OutBuff:pchar;
    i:integer;
begin
  DecompressBuf(@s[1],length(s),est,Pointer(OutBuff),cnt);
  setlength(s,cnt);
  move(OutBuff[0],s[1],cnt);
end;

end.
