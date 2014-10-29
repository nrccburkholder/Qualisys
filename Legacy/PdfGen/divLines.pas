unit divLines;

interface
uses sysutils,constants;
function DivLine(y:double):string;

implementation

  function DivLine(y:double):string;
  begin
    result:= SysUtils.format('q 0 0 1 RG 2 w'#10'0 j'#10'%1:g %0:g m'#10'%2:g %0:g l'#10's Q'#10,[y,LeftMargin,RightMargin]) ;
  end;


end.
