unit FontReader;

interface
uses constants,jpeg,sysutils,classes;

Function GetFontStream(fn:string):string;

implementation

Function GetFontStream(fn:string):string;
var
  i:integer;
  fStrm:tfileStream;
  fcnt:integer;
begin
    //get image info;
    result:='';
    if not fileexists(fn) then exit;
    try
      fstrm:=tfilestream.Create(fn,fmOpenRead or fmShareDenyNone);
      setlength(result,fstrm.Size);
      fstrm.Seek(0,soFromBeginning);
      fstrm.Read(result[1],fstrm.Size);
    finally
      fstrm.Free;
    end;
end;

end.
