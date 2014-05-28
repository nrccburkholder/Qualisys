create procedure APlan_CalcT90
as
create table #ttemp (sampunit int, qstncore int, m1 float, m2 float, n1 int, n2 int, ss1 int, ss2 int, sig char(1), v1 float, v2 float, t float, dof float)
insert into #tTemp (sampunit,qstncore,m1,m2,n1,n2,ss1,ss2,v1,v2,t,dof)
 select sampunit,qstncore,m1,m2,n1,n2,ss1,ss2,0,0,0,0
 from #sigtest where response is null

update #tTemp
  set V1 = (SS1-(square(M1*N1)/N1))/(N1-1)
  where n1>1
update #tTemp
  set V2 = (SS2-(square(M2*N2)/N2))/(N2-1)
  where n2>1

update #tTemp
  set t = v1/n1 where n1>0 and v1<>0
update #tTemp
  set t = t + (v2/n2)
  where n2>0 and v2<>0

update #tTemp
  set T = (M1-M2)/SQRT(t)
  where t<>0

update #tTemp
  set DOF = 
square((v1/n1)+(v2/n2))
       ------- -------
-----------------------      
/
( (square(v1/n1)/(n1-1)) + (square(v2/n2)/(n2-1)) )
   ------------- ------     ------------- ------
  ----------------------   ----------------------
---------------------------------------------------
where n1>1 and n2>1 and v1+v2>0

update #tTemp
set sig = 
  case 
    when m2 is null then '~'
    when n2=0 then '~'
    when dof >=120 and t>  1.645 then '>'
    when dof >=120 and t< -1.645 then '<'
    when dof >=60 and t >  1.658 then '>'
    when dof >=60 and t < -1.658 then '<'
    when dof >=40 and t >  1.671 then '>'
    when dof >=40 and t < -1.671 then '<'
    when dof >=35 and t >  1.684 then '>'
    when dof >=35 and t < -1.684 then '<'
    when dof >=30 and t >  1.690 then '>'
    when dof >=30 and t < -1.690 then '<'
    when dof >=29 and t >  1.697 then '>'
    when dof >=29 and t < -1.697 then '<'
    when dof >=28 and t >  1.699 then '>'
    when dof >=28 and t < -1.699 then '<'
    when dof >=27 and t >  1.701 then '>'
    when dof >=27 and t < -1.701 then '<'
    when dof >=26 and t >  1.703 then '>'
    when dof >=26 and t < -1.703 then '<'
    when dof >=25 and t >  1.706 then '>'
    when dof >=25 and t < -1.706 then '<'
    when dof >=24 and t >  1.708 then '>'
    when dof >=24 and t < -1.708 then '<'
    when dof >=23 and t >  1.711 then '>'
    when dof >=23 and t < -1.711 then '<'
    when dof >=22 and t >  1.714 then '>'
    when dof >=22 and t < -1.714 then '<'
    when dof >=21 and t >  1.717 then '>'
    when dof >=21 and t < -1.717 then '<'
    when t >  1.721 then '>'
    when t < -1.721 then '<'
    else ' '
  end

update #sigtest
set sig = #ttemp.sig
from #ttemp
where #sigtest.sampunit=#ttemp.sampunit
  and #sigtest.qstncore=#ttemp.qstncore

drop table #ttemp


