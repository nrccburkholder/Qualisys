CREATE procedure sp_sys_accountingreport2 @month int = null, @year int = null
as
if @month is null
begin
 set @month = (datepart(month, getdate())-1)
end

if @year is null
begin
 set @year = datepart(year,(dateadd(month,-1,getdate())))
end

set nocount on
/*
declare @firstdate datetime, @lastdate datetime
set @firstdate = (dateadd(day,-1,getdate()))
set @lastdate = (getdate())
*/
create table #status
(study_id int, survey_id int, Project varchar(4), Returns int, Ignored int)

insert into #status
select study_id, sd.survey_id, left(strsurvey_nm,4), 
	count(*), 0
from questionform qf, survey_def sd
where qf.survey_id = sd.survey_id
and datreturned is not null
and datepart(month,datreturned) = @month
and datepart(year,datreturned) = @year
--and dateadd(day,-1,datreturned) <= @lastdate
--and datreturned >= @firstdate
group by study_id, sd.survey_id, left(strsurvey_nm,4)
order by study_id, sd.survey_id, left(strsurvey_nm,4)
--compute sum(count(*))

select study_id, sd.survey_id, left(strsurvey_nm,4) as project, 
	count(*) as ignored
into #status2
from questionform qf, survey_def sd
where qf.survey_id = sd.survey_id
and datreturned is null
and datepart(month,datunusedreturn) = @month
and datepart(year,datunusedreturn) = @year
--and dateadd(day,-1,datunusedreturn) <= @lastdate
--and datunusedreturn >= @firstdate
group by study_id, sd.survey_id, left(strsurvey_nm,4)
order by study_id, sd.survey_id, left(strsurvey_nm,4)

update s 
set s.ignored = s2.ignored
from #status s, #status2 s2
where s.project = s2.project
and s.survey_id = s2.survey_id
and s.study_id = s2.study_id

update #status
set project = '6025'
where study_id = 377

select project, sum(returns) as Returns, sum(ignored) as Ignored 
into #display
from #status 
group by project

declare @strMonth varchar(20)

select @strMonth = case @month when 1 then 'January' when 2 then 'February' when 3 then 'March' when 4 then 'April'
  when 5 then 'May' when 6 then 'June' when 7 then 'July' when 8 then 'August' when 9 then 'September' 
  when 10 then 'October' when 11 then 'November' when 12 then 'December' end

print 'This report is for the month of: ' + @strMonth + ', ' + convert(varchar,@year)
print ''

select *
from #display
order by project
compute sum(returns)
compute sum(ignored)
drop table #status
drop table #status2
drop table #display


