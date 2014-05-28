CREATE procedure dbo.QP_Rep_LoadVolume
@BeginDate datetime, @EndDate datetime
as

set @enddate = dateadd(day, 1, @enddate)

declare @dataset table (dataset_id int, LoadDay datetime)

insert into @dataset
select dataset_id, convert(datetime,floor(convert(float,datload_dt))) as LoadDay
from data_set
where datload_dt between @BeginDate and @EndDate

select LoadDay, count(distinct dataset_id) as FileCount, sum(recCount) as RecCount
from (select ds.dataset_id, LoadDay, count(*) as RecCount
		from datasetmember dsm, @dataset ds
		where ds.dataset_id=dsm.dataset_id
		group by ds.dataset_id, LoadDay) q
group by LoadDay
order by LoadDay


