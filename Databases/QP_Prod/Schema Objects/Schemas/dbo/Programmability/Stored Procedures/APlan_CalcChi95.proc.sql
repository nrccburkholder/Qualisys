CREATE procedure APlan_CalcChi95
as
create table #chitemp (sampunit int, qstncore int, response int, b1 int, b2 int, n1 float, n2 float, 
chie int, chif int, chig int, chih int, chii int, 
chij float, chik float, chil float, chim float, chin float, chip float, sig char(1))

insert into #chitemp (sampunit,qstncore,response,b1,b2,n1,n2,chin)
  select sampunit,qstncore,response,ss1,ss2,n1,n2,0
  from #sigtest where response is not null

update #chitemp set chie = n2-b2
update #chitemp set chif = n1-b1
update #chitemp set chig = chie+chif
update #chitemp set chih = b2+b1
update #chitemp set chii = n2+n1
update #chitemp set chij = chih*(n1/(0.0+chii)) where chii > 0
update #chitemp set chik = chih*(n2/(0.0+chii)) where chii > 0
update #chitemp set chil = chig*(n1/(0.0+chii)) where chii > 0
update #chitemp set chim = chig*(n2/(0.0+chii)) where chii > 0

update #chitemp set chin = 
   (square(b1-chij))/chij + 
   (square(b2-chik))/chik + 
   (square(chif-chil))/chil + 
   (square(chie-chim))/chim
where chij>0 and chik>0 and chil>0 and chim>0

update #chitemp set chip = b2*100/n2 where n2 > 0
update #chitemp set sig = '='

update #chitemp set sig = '<' 
where (chin>=3.841 and n1>0 and b1*100/n1<chip) 

update #chitemp set sig = '>'
where (chin>=3.841 and n1>0 and b1*100/n1>chip) 

update #chitemp set sig = '='
where (chin< 3.841 ) 

update #chitemp set sig = '='
where (n1>0 and chip = b1*100/n1 and chip>=0) 

update #sigtest
set sig = #chitemp.sig
from #chitemp
where #sigtest.sampunit = #chitemp.sampunit 
  and #sigtest.qstncore = #chitemp.qstncore
  and #sigtest.response = #chitemp.response

drop table #chitemp


