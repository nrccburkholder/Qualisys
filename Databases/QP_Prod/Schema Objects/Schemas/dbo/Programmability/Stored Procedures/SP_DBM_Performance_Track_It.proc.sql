CREATE procedure SP_DBM_Performance_Track_It
as
set nocount on

select *
into #tasks
from tasks
where respons not in ('dave gilsdorf','felix gomez', 'jeff fleming', 'brad clevenger', 'ted smidberg', 'hui holay')

select count(*) as openedcurrentweek from #tasks where reqdate >= dateadd(d,-8,getdate())

select (sum(datediff(d,reqdate,getdate()))/(count(*)*1.0)) as avgopencurrentweek from #tasks where reqdate >= dateadd(d,-8,getdate())

select count(*) as openandclosedcurrentweek from #tasks where reqdate >= dateadd(d,-8,getdate()) and completed >= dateadd(d,-8,getdate()) 

select (sum(datediff(d,reqdate,completed))/(count(*)*1.0)) as avgopenandclosedcurrentweek from #tasks where reqdate >= dateadd(d,-8,getdate()) and completed >= dateadd(d,-8,getdate()) 

select count(*) as numberopen from #tasks where completed is null

select (sum(datediff(d,reqdate,getdate()))/(count(*)*1.0)) as avgdaysopennotclosed from #tasks where completed is null

select count(*) as numberclosed from #tasks where completed is not null

select (sum(datediff(d,reqdate,completed))/(count(*)*1.0)) as avgdaysopenedandclosed from #tasks where completed is not null

select * into #tasks2 from #tasks
where reqdate >= dateadd(d,-8,getdate())

select reqdate, count(*) as opennotclosedthisday from #tasks2 group by reqdate

select reqdate, count(*) as openandclosedthisday from #tasks2 where completed = reqdate group by reqdate

drop table #tasks
drop table #tasks2


