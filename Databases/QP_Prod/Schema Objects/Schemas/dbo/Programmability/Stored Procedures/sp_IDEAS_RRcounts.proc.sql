CREATE PROCEDURE sp_IDEAS_RRcounts AS

select survey_id, ss.sampleset_id, sampleunit_id, count(*) as returned
into #returns
from questionform qf, samplepop sp, selectedsample ss
where qf.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and ss.strunitselecttype = 'D'
and qf.datreturned is not null
group by survey_id, ss.sampleset_id, sampleunit_id

select survey_id, ss.sampleset_id, sampleunit_id, count(*) as total
into #total
from samplepop sp, selectedsample ss, sampleset sset
where sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and ss.sampleset_id = sset.sampleset_id
and ss.strunitselecttype = 'D'
group by survey_id, ss.sampleset_id, sampleunit_id

select survey_id, ss.sampleset_id, sampleunit_id, count(*) as undeliverable
into #undeliverable
from sentmailing sm, scheduledmailing schm, samplepop sp, selectedsample ss, sampleset sset
where sm.sentmail_id = schm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.study_id = ss.study_id
and sp.pop_id = ss.pop_id
and ss.sampleset_id = sset.sampleset_id
and ss.strunitselecttype = 'D'
and sm.datundeliverable is not null
group by survey_id, ss.sampleset_id, sampleunit_id

if exists(select * from sysobjects where name = 'IDEAS_RRcounts' and type = 'U')
   drop table IDEAS_RRcounts

create table IDEAS_RRcounts (survey_id int, sampleset_id int, sampleunit_id int, undeliverable int, returned int, total int)

insert IDEAS_RRcounts
select t.survey_id, t.sampleset_id, t.sampleunit_id, isnull(undeliverable,0) as undeliverable, isnull(returned,0) as returned, total
from #returns r right outer join #total t left outer join #undeliverable u
on t.sampleset_id = u.sampleset_id
and t.sampleunit_id = u.sampleunit_id
on t.sampleset_id = r.sampleset_id 
and t.sampleunit_id = r.sampleunit_id
order by t.survey_id, t.sampleset_id, t.sampleunit_id

drop table #returns
drop table #total
drop table #undeliverable


