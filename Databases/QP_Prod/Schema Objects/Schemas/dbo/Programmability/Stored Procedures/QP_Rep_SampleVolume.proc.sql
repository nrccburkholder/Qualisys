CREATE procedure dbo.QP_Rep_SampleVolume
@BeginDate datetime, @EndDate datetime
as

set @enddate = dateadd(day, 1, @enddate)

declare @SampleSet table (Sampleset_id int, SampleDay datetime)

insert into @SampleSet
select sampleset_id, convert(datetime,floor(convert(float,datsamplecreate_dt))) as SampleDay
from sampleset
where datsamplecreate_dt between @BeginDate and @EndDate

select SampleDay, count(distinct sampleset_id) as SampleCount, sum(recCount) as RecCount
from (select ss.sampleset_id, SampleDay, count(*) as RecCount
		from selectedsample sel, @SampleSet ss
		where sel.sampleset_id=ss.sampleset_id
		group by ss.sampleset_id, SampleDay) q
group by SampleDay
order by SampleDay


