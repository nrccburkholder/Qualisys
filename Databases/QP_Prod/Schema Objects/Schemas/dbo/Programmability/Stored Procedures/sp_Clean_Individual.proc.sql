CREATE Procedure sp_Clean_Individual
as
set nocount on
select top 10 questionform_id, samplepop_id, survey_id, sentmail_id 
into #delindividual 
from delpclneeded (NoLock)
begin transaction
delete si
from #delindividual di, scls_individual si (ROWLOCK) 
where di.questionform_id = si.questionform_id
commit transaction


begin transaction
delete ti
from #delindividual di, textbox_individual ti  (ROWLOCK) 
where di.sentmail_id = ti.sentmail_id
commit transaction

begin transaction 
delete qi
from #delindividual di, qstns_individual qi  (ROWLOCK)
where di.questionform_id = qi.questionform_id
commit transaction

begin transaction
delete dpn
from  #delindividual di, delpclneeded dpn  (ROWLOCK)
where di.samplepop_id = dpn.samplepop_id
and di.questionform_id = dpn.questionform_id
or (di.samplepop_id = dpn.samplepop_id
and dpn.questionform_id is null)
commit transaction

drop table #delindividual


