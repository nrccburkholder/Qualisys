unit Drawing;

interface

uses SysUtils,windows,constants,classes,stdctrls,Dialogs,printers,forms,Graphics;
type carray = array [1..3] of string;

Function CrossHatch(x,y,h,w,d:double):string;
function Circle(x0,y0,r:double;rg:string):string;
Function GetShade(rgb:array of double;c:string):carray;
function GetRGB(c:tColor):string;
function DrawRectangle(x,y,Widdth,Height,LineWidth:double;LineColor,FillColor:TColor):string;
function DrawLine(x1,y1,x2,y2,Width:double;LineColor:TColor):string;

implementation


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

function circle(x0,y0,r:double;rg:string):string;
var x1,x2,
    y1,y2:double;
begin
  x1:= x0+r;
  x2:= x0-r;
  y1:=y0+(r*1.3333);
  y2:=y0-(r*1.3333);

  result:=format('q %s %g %g m'#10,[rg,x1,y0]);
  result:=result+format('%g %g %g %g %g %g c'#10,[x1,y1,x2,y1,x2,y0]);
  result:=result+format('%g %g %g %g %g %g c f Q'#10,[x2,y2,x1,y2,x1,y0]);

end;

Function GetShade(rgb:array of double;c:string):carray;
begin
  if ((c <>'RG') and (c<>'rg')) then c:='rg';
  result[1]:=format('%0.1g %0.1g %0.1g %s'#10,[rgb[0],rgb[1],rgb[2],c]);
  result[2]:=format('%0.1g %0.1g %0.1g %s'#10,[rgb[0]*0.2,rgb[1]*0.2,rgb[2]*0.2,c]);
  result[3]:=format('%0.1g %0.1g %0.1g %s'#10,[rgb[0]*1.2,rgb[1]*1.2,rgb[2]*1.2,c]);
end;

function GetRGB(c:tColor):string;
var r,g,b:integer;
begin
  r:=GetRValue(c);
  g:=GetGValue(c);
  b:=GetBValue(c);
  result:= format('%d %d %d',[r,g,b]);
end;

function DrawRectangle(x,y,Widdth,Height,LineWidth:double;LineColor,FillColor:TColor):string;
var color:string;
    action:string;
begin
  action :='s';

  if LineColor >=0 then begin
    color := SysUtils.format('%s RG',[GetRGB(LineColor)]);
  end;

  if FillColor >=0 then begin
     color := color + SysUtils.format(' %s rg',[GetRGB(FillColor)]);
     action := 'b';
  end;

  result := format('q %6:g w %0:s %1:g %2:g %3:g %4:g re %5:s Q'#10,[color,x,y,Widdth,Height,action,LineWidth])

end;

function DrawLine(x1,y1,x2,y2,Width:double;LineColor:TColor):string;
var color:string;
begin
  if LineColor >=0 then color := SysUtils.format('%s RG',[GetRGB(LineColor)]);
  result:= SysUtils.format('q %4:s 2 w'#10'0 j'#10'%0:g %1:g m'#10'%2:g %3:g l'#10's Q'#10,[x1,y1,x2,y2,color])

end;

end.
