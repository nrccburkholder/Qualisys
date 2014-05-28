CREATE PROCEDURE [dbo].[Get_CGCAHPS_MNCM_Data]
 @survey_id int,    
 @begindate varchar(10),
 @enddate varchar(10)
as    
    
--exec Get_CGCAHPS_MNCM_Data 13645, '9/1/2012', '11/30/2012'
--declare @survey_id int, @begindate datetime, @enddate datetime
--select @survey_id = 13645, @begindate = '9/1/2012', @enddate = '11/30/2012'
    
declare @study varchar(10)
declare @survey varchar(10)
declare @sql varchar(8000)
    
select @survey = cast(@survey_id as varchar)    
select @study = cast(study_id as varchar) from survey_def where survey_id = @survey_id    

if @survey_id is null
begin    
 print '@survey_id can not be null.  Exiting...'    
 return    
end    

if @begindate is null or isdate(@begindate)=0
begin    
 print '@begindate is null or invalid.  Exiting...'    
 return    
end    

if @enddate is null or isdate(@enddate)=0
begin    
 print '@enddate is null or invalid.  Exiting...'    
 return    
end    

if @study is null
begin    
 print 'Study_id for survey '+@survey+' not found.  Exiting...'    
 return    
end    


select @sql = '
select distinct e.pop_id, e.enc_id, e.servicedate
into #tmp1
from s'+@study+'.encounter e inner join Sampling_ExclusionLog sel
 on e.pop_id = sel.Pop_ID
 and e.enc_id = sel.Enc_ID
where sel.survey_id = '+@survey+'
and e.servicedate between '''+@begindate+''' and '''+@enddate+'''
and sel.samplingexclusiontype_id in (1, 3, 4, 7, 9)

select t.pop_id, max(t.enc_id) enc_id, t.servicedate
into #tmp2
from #tmp1 t inner join (select pop_id, max(servicedate) servicedate from #tmp1 group by pop_id) t2
 on t.pop_id = t2.pop_id
 and t.servicedate = t2.servicedate
group by t.pop_id, t.servicedate

alter table #tmp2 add samplingexclusiontype_id int

update t
set samplingexclusiontype_id = sel.samplingexclusiontype_id
from #tmp2 t 
	cross apply (select top 1 SamplingExclusionType_ID 
				from sampling_exclusionlog 
				where survey_id = '+@survey+'
				and pop_id = t.pop_id 
				and enc_id = t.enc_id 
				order by datecreated) sel

select e.cg_groupid		--Medical Group ID
,e.cg_siteid			--Clinic Site ID
,'''+@study+'''+cast(e.pop_id as varchar)	--Patient ID, study_id + pop_id
,tot.num_visits		--Number of visits
,t.servicedate		--Date of most recent visit
,e.drnpi			--Provider ID
,case				--Exclusion reason
	when t.SamplingExclusionType_ID	in (1, 9) then 4
	when t.SamplingExclusionType_ID	in (3, 4, 7) then 6
end ExclusionReason
from s'+@study+'.encounter e inner join #tmp2 t
 on e.pop_id = t.pop_id
 and e.enc_id = t.enc_id
cross apply (select count(*) num_visits from s'+@study+'.encounter where servicedate between '''+@begindate+''' and '''+@enddate+''' and pop_id = e.pop_id group by pop_id) tot
order by 3

drop table #tmp1
drop table #tmp2'

exec(@sql)


