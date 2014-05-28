CREATE procedure SP_DBM_dedup_sampleunitsection
as

begin tran

select min(sampleunitsection_id) as sampleunitsection_id, sampleunit_id, selqstnssection, selqstnssurvey_id  --34082
into #sus
from sampleunitsection
group by sampleunit_id, selqstnssection, selqstnssurvey_id  
 if @@error <> 0
   begin 
     rollback tran
     return
   end

delete sampleunitsection
 if @@error <> 0
   begin 
     rollback tran
     return
   end

set identity_insert dbo.sampleunitsection on
insert into sampleunitsection (sampleunitsection_id, sampleunit_id, selqstnssection, selqstnssurvey_id) 
select sampleunitsection_id, sampleunit_id, selqstnssection, selqstnssurvey_id from #sus
 if @@error <> 0
   begin 
     rollback tran
     return
   end

set identity_insert dbo.sampleunitsection off

commit tran


