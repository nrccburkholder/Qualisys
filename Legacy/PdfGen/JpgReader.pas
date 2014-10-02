unit JpgReader;

interface
uses constants,jpeg,sysutils,graphics,classes,extctrls, Dialogs,windows;

Function GetImageData(fn:string;var w,h:double;var UseClientLogo:boolean;n:string):string;

implementation

Function GetImageData(fn:string;var w,h:double;var UseClientLogo:boolean;n:string):string;
var
  i:integer;
  jpegf:file;
  jbuf:pchar;
  BPC,jcnt:integer;
  img:timage;
  jpeg: TJPegImage;
  Bmp: Graphics.TBitmap;
  strm:tFileStream;
  jpegstrm:tmemorystream;
  s:string;
  isBmp:boolean;
  //isGif:boolean;
begin
    //get image info;
    w:=0;
    h:=0;
    result:='';
    if not UseClientLogo then exit;
    UseClientLogo:=fileexists(fn);

    s:=uppercase(extractfileext(fn));

    if not UseClientLogo then exit;
    try

    img := timage.Create(nil);

    jpeg:= TJPEGImage.Create;
    isbmp := s ='.BMP';

    s:=extractFileName(fn);
    s:=AppPath+'\'+s;
    try
      strm:=tFileStream.Create(fn,fmOpenRead or fmShareDenyNone	);
    except
       copyfile(pchar(fn),pchar(s),false);
       strm:=tFileStream.Create(fn,fmOpenRead or fmShareDenyNone);
    end;

    if isbmp then
    begin
      Bmp := Graphics.TBitmap.Create;
      Bmp.LoadFromStream(strm);
      Jpeg.Assign(bmp);
      bmp.free;
      bmp:=nil;
    end
    else
      jpeg.LoadFromStream(strm);

    strm.Free;
    strm:=nil;

    w:= jpeg.Width;
    h:= jpeg.Height;
    if jpeg.CompressionQuality < 90 then
    begin
       jpeg.CompressionQuality := 90;
       jpeg.compress;
    end;
    case jpeg.PixelFormat of
      jf24Bit:BPC:=8;
      jf8Bit:BPC:=24;
    end;
    jpegstrm:=tmemorystream.Create;
    jpeg.SaveToStream(jpegstrm);
    jpegstrm.Seek(0,soFromBeginning);
    setlength(result,jpegstrm.Size);
    jpegstrm.Read(result[1],jpegstrm.Size);
    jpegstrm.Free;
    jpegstrm:=nil;
  finally
    if  isBmp and (bmp<>nil) then
    begin
      bmp.free;
      bmp:=nil;
    end;
    if strm <> nil then
    begin
      strm.free;
      strm:=nil;
    end;
    if jpegstrm <> nil then
    begin
      jpegstrm.free;
      jpegstrm:=nil;
    end;
    if jpeg <> nil then
    begin
      jpeg.Free;
      jpeg:=nil;
    end;
  end;

end;

end.
