unit hbars;

interface
uses sysutils,constants;

Function hbar(x,y,h,w:double;bg:array of string):string;

implementation


  Function hbar(x,y,h,w:double;bg:array of string):string;
  var
    x1,  x2,x3,y1,y2,y3 :Double;

  begin
    x1 := x+w;
    x2 := x1 +(h/2);
    x3 := x + (h/2);
    y1 := y + (h/2);
    y2 := y1 + h;
    y3 := y + h;

    Result:='q 0 G'#10'.75 w'#10'1 j'#10;
    if bool3D then
    begin
      Result := Result+bg[1]; //bacground color for end of hbar
      Result:=Result+format('%g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'b'#10+bg[2],[x1,y,x2,y1,x2,y2,x1,y3]);
      Result:=Result+format('%g %g m'#10'%g %g l'#10'%g %g l'#10'%g %g l'#10'b'#10,[x1,y3,x2,y2,x3,y2,x,y3]);
    end
    else
      h:=h*1.5;
    Result:=Result+format('%s %g %g %g %g re'#10'b'#10,[bg[0],x,y,w,h]);//rectangle
    Result := Result + ' Q'#10;

  end;

end.
