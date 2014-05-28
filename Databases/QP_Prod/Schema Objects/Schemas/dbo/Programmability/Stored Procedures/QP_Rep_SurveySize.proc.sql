CREATE procedure QP_Rep_SurveySize
@Associate varchar(42), @startdate datetime, @enddate datetime
as
set transaction isolation level read uncommitted
declare @startyear int, @startmonth int, @endyear int, @endmonth int

set @startyear = datepart(year,@startdate)
set @startmonth = datepart(month,@startdate)
set @endyear = datepart(year,@enddate)
set @endmonth = datepart(month,@enddate)

select *
into #display
from surveysize
where genyear >= @startyear

delete #display
where genyear = @startyear
and genmonth < @startmonth

delete #display
where genyear = @endyear
and genmonth > @endmonth

select * from #display
order by genyear, genmonth, client_id, study_id, papersize

drop table #display

set transaction isolation level read committed


