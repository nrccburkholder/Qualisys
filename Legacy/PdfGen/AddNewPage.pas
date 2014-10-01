unit AddNewPage;

interface
uses sysutils,divlines,constants,textMeasure;

Function PageHeader(var y:double;continued:boolean):string;

implementation


Function PageHeader(var y:double;continued:boolean):string;
 var i     : integer;
     fs    : double;
     thisy : double;
     thisx : double;
     MaxHeaderLength       : integer;
     images      : string;
     s           : string;
     strContinued: string;
  begin
    images      := '';
    s           := '';
    strContinued:='';
    
    NewPage:=true;
    thisx:=33;
    fs:=10;
    y:=PageHeight-inch*1.3;
    Result:=DivLine(y);

    if continued then
      strContinued := ' (continued)';

    if useClientLogo then
    begin
       {//This code is to resize logos to a standard size
       LogoWidth:=inch*1.5;
       if imagewidth2 > LogoWidth then
       begin
         ImageHeight2:=(LogoWidth/imagewidth2)*ImageHeight2;
         imagewidth2:=LogoWidth;
       end;
       }
       images:=Format( #10'q %g 0 0 %g %g %g cm /Im2 Do Q'#10,[imagewidth2/96*72,ImageHeight2/96*72,33.0,y+fs ] );
       thisx:=thisx + (imagewidth2/96*72) + 10;
    end;

    if UseCaution then
    begin
       images:=Format( #10'q %g 0 0 %g %g %g cm /Im3 Do Q'#10,[ImageWidth3/96*72,ImageHeight3/96*72,PageWidth-33-(ImageWidth3/96*72),y+fs*0.25 ] )+images;
       MaxHeaderLength:=round(pagewidth-((thisx+ImageWidth2/96*72)-30));
    end
    else
      MaxHeaderLength:=round(pagewidth-(thisx+33));

    fs:=13;
    s:='';
    LinesHeight:=fs;
    ActiveFont:='/F1';
    thisy:=y+fs*0.7;
    for i:= high(PageHeaderLines) downto 1 do
      if trim(PageHeaderLines[i]) <> '' then
      begin
        if i>1 then
          s:=TextAt( thisx, thisy,'Arial',fs,PageHeaderLines[i],MaxHeaderLength,'L',true,'')+s
        else
          s:=TextAt( thisx, thisy,'Arial',fs,PageHeaderLines[i],MaxHeaderLength,'L',true,'')+s;
        thisy:=yGlobal;
      end;
    if PageHeaderLines[0] <> '' then
      s := TextAt( thisx, thisy,'Arial',fs,PageHeaderLines[0]+strContinued,MaxHeaderLength,'L',true,'')+s;

    Result:=Result+images+s;

  end;          

end.
