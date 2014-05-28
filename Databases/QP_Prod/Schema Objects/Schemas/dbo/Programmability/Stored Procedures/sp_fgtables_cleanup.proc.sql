create procedure sp_fgtables_cleanup
as

select distinct sentmail_id into #sp
from pclneeded

begin tran

delete f
from fgpopsection f left outer join #sp sp
on f.sentmail_id = sp.sentmail_id 
where sp.sentmail_id is null
if @@error<> 0
begin
  rollback transaction
end

delete f
from fgpopcover f left outer join #sp sp
on f.sentmail_id = sp.sentmail_id 
where sp.sentmail_id is null
if @@error<> 0
begin
  rollback transaction
end

delete f
from fgpopcode f left outer join #sp sp
on f.sentmail_id = sp.sentmail_id 
where sp.sentmail_id is null
if @@error<> 0
begin
  rollback transaction
end

commit tran

drop table #sp


