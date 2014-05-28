CREATE procedure QP_Rep_STRSTOCL @associate varchar(42)
as
set transaction isolation level read uncommitted
/*
Brian Dohmen 1/11/1
This procedure is to automatically add deceased and ineligible populations to the TOCL table.
This procedure will only work for studies 125 and 128
*/
declare @start datetime
set @start = getdate()

create table #display (study_id int, cnt int)

select p.pop_id into #pops from s125.population_load pl, s125.population p
where pl.memberid = p.memberid
and pl.benefitpkg = p.benefitpkg
and pl.serviceindicator in ('X', 'N')

delete p 
from #pops p, tocl t
where p.pop_id = t.pop_id
and t.study_id = 125

declare @count int
set @count = (select count(*) from #pops)
insert into #display
select 125,@count

declare @pop_id int
declare pops cursor for
select pop_id from #pops

open pops
fetch next from pops into @pop_id
while @@fetch_status = 0
begin
	insert into tocl
	select 125 , @pop_id, getdate()

fetch next from pops into @pop_id
end

close pops
deallocate pops

select p.pop_id into #pops2 from s128.population_load pl, s128.population p
where pl.memberid = p.memberid
and pl.serviceindicator in ('X', 'N')

delete p 
from #pops2 p, tocl t
where p.pop_id = t.pop_id
and t.study_id = 128


--declare @count int
set @count = (select count(*) from #pops2)
insert into #display
select 128,@count

--declare @pop_id int
declare pops cursor for
select pop_id from #pops2

open pops
fetch next from pops into @pop_id
while @@fetch_status = 0
begin
	insert into tocl
	select 128 , @pop_id, getdate()

fetch next from pops into @pop_id
end

close pops
deallocate pops

select * from #display

drop table #pops
drop table #pops2
drop table #display

insert into dashboardlog (report, associate, procedurebegin, procedureend)
select 'STRSTOCL', @associate, @start, getdate()

set transaction isolation level read committed


