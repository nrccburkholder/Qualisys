unit Arrows;

interface
uses sysutils;

function DrawArrow(x,y,h:double; Color:string;Direction:char):string;

implementation

function DrawArrow(x,y,h:double; Color:string;Direction:char):string;

begin
 direction:=upcase(Direction);
 case direction of
   '0':direction:='L';
   '1':direction:='H';
 end;
 if direction in ['H','L'] then
    Result:=  Format('q %s BT /F5 %g Tf %g %g Td(%s)Tj ET Q'#10,[color,h+2,x,y,Direction])
 else
   result:='';

end;

end.


