--Returns a list of IDs for the Sample Status Report.  These IDs are used to populate drop down boxes for filters.
--DRM 07/27/2011

CREATE proc [dbo].[SSRS_SR_GetIDs] 
	@ID_type int
	--1 = employee ids
	--2 = client ids
as

select employee_id, stremployee_first_nm, stremployee_last_nm, 
 s.study_id, sd.survey_id, c.client_id, c.strclient_nm,
 cast('1/1/1900' as datetime) as datsamplecreate_dt
 --, *
into #sample_data
from survey_def sd inner join study s
 on sd.study_id = s.study_id
inner join client c
 on s.client_id = c.client_id
inner join employee e
 on e.employee_id = s.ademployee_id
where sd.active = 1
and s.active = 1
and c.active = 1 

select ss.survey_id, max(ss.datsamplecreate_dt) as datsamplecreate_dt                    
into #tmp3                    
from #sample_data t inner join sampleset ss                    
 on t.survey_id = ss.survey_id                    
group by ss.survey_id                    
                    
update t2                    
set datsamplecreate_dt = t3.datsamplecreate_dt                    
from #sample_data t2 inner join #tmp3 t3                    
 on t2.survey_id = t3.survey_id                    

if @ID_type = 1
	select distinct employee_id, stremployee_first_nm + ' ' + stremployee_last_nm as employee_nm
	from #sample_data
	where datsamplecreate_dt >= getdate() - 365
	order by employee_nm


if @ID_type = 2
	select distinct client_id, strclient_nm
	from #sample_data
	where datsamplecreate_dt >= getdate() - 365
	order by strclient_nm

--drop temp tables 
drop table #tmp3
drop table #sample_data


