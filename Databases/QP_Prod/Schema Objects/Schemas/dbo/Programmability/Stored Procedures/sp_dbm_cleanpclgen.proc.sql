/* This procedure will clean the pclgen tables of all entries older than 7 days.*/
create procedure sp_dbm_cleanpclgen
as
select pclgenrun_id
into #p
from pclgenrun
where start_dt < dateadd(day,-7,getdate())

delete pgl
from pclgenlog pgl, #p p
where p.pclgenrun_id = pgl.pclgenrun_id

delete pgr
from pclgenrun pgr, #p p
where p.pclgenrun_id = pgr.pclgenrun_id

drop table #p


