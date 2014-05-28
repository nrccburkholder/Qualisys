--Returns a data for the Sample Status Report.    
--DRM 07/27/2011    
    
CREATE procedure [dbo].[SSRS_SR_GetSampleData]     
 @client_id varchar(8000)='',    
 @employee_id varchar(1000)='',    
 @encounter_startdate varchar(25)='',    
 @encounter_enddate varchar(25)='',    
 @surveytype_id varchar(20)=''    
as    
    
declare @sql varchar(8000)    
    
select c.client_id, c.strclient_nm, employee_id, stremployee_first_nm, stremployee_last_nm,     
 s.study_id, strstudy_nm,  sd.survey_id, strsurvey_nm, st.surveytype_id, st.surveytype_dsc,     
 isnull(methodologytype, 'Undefined') as methodologytype,  
 cast(0 as int) as sampleset_id,  
 cast('1/1/1900' as datetime) as datsamplecreate_dt, cast('1/1/1900' as datetime) as datdaterange_fromdate,     
 cast('1/1/1900' as datetime) as datdaterange_todate, cast('1/1/1900' as datetime) as datLastMailed,     
 cast('1/1/1900' as datetime) as datScheduled,    
 cast('' as char(1)) as Ind    
 --, *    
into #sample_data    
from survey_def sd inner join study s    
 on sd.study_id = s.study_id    
inner join client c    
 on s.client_id = c.client_id    
inner join employee e    
 on e.employee_id = s.ademployee_id    
inner join surveytype st    
 on sd.surveytype_id = st.surveytype_id    
left join mailingmethodology mm    
 on mm.survey_id = sd.survey_id    
 and mm.bitactivemethodology = 1    
left join standardmethodology sm    
 on mm.standardmethodologyid = sm.standardmethodologyid    
where sd.active = 1    
and s.active = 1    
and c.active = 1     
    

    
if (@encounter_startdate = '' or @encounter_startdate is null) 
begin
	set @encounter_startdate = '1/1/1900'
	set @encounter_enddate = '1/1/4000'
end


select ss.survey_id, max(ss.datsamplecreate_dt) as datsamplecreate_dt                        
into #tmp3                        
from #sample_data t inner join sampleset ss                        
 on t.survey_id = ss.survey_id
where ss.datdaterange_todate >= @encounter_startdate and ss.datdaterange_fromdate <= @encounter_enddate 
group by ss.survey_id

                      
                        
update t2                        
set datsamplecreate_dt = t3.datsamplecreate_dt                        
from #sample_data t2 inner join #tmp3 t3                        
 on t2.survey_id = t3.survey_id                        
    
update t2                        
set datdaterange_fromdate = ss.datdaterange_fromdate,                        
 datdaterange_todate = ss.datdaterange_todate,    
 datscheduled = ss.datscheduled,  
 sampleset_id = ss.sampleset_id  
from #sample_data t2 inner join sampleset ss                        
 on t2.survey_id = ss.survey_id                        
 and t2.datsamplecreate_dt = ss.datsamplecreate_dt     
  
select ss.sampleset_id, MAX(sm.datmailed) as datmailed    
into #tmp4  
from #sample_data t2 inner join sampleset ss                        
 on t2.survey_id = ss.survey_id                        
 and t2.datsamplecreate_dt = ss.datsamplecreate_dt    
inner join SAMPLEPOP sp    
 on ss.SAMPLESET_ID = sp.SAMPLESET_ID    
inner join SCHEDULEDMAILING scm    
 on scm.SAMPLEPOP_ID = sp.SAMPLEPOP_ID    
inner join SENTMAILING sm    
 on scm.SENTMAIL_ID = sm.SENTMAIL_ID    
group by ss.sampleset_id  
  
  
update t2    
set datlastmailed = t4.datmailed    
from #sample_data t2 join #tmp4 t4    
 on t2.sampleset_id = t4.sampleset_id  
    
                        
update #sample_data set Ind = '*'    
where datsamplecreate_dt <= cast(floor(cast(getdate()-40 as float)) as datetime)    
    
    
set @sql = 'select stremployee_first_nm, stremployee_last_nm, strclient_nm, strstudy_nm, study_id, strsurvey_nm, survey_id, surveytype_dsc, methodologytype,     
case     
 when datdaterange_fromdate = ''1/1/1900'' then NULL    
 else convert(varchar,datdaterange_fromdate,1) + '' - '' + convert(varchar,datdaterange_todate,1)     
end as daterange,    
ind,     
case    
 when datsamplecreate_dt = ''1/1/1900'' then NULL    
 else datsamplecreate_dt    
end as datsamplecreate_dt,     
case    
 when datscheduled = ''1/1/1900'' then NULL    
 else datscheduled    
end as datscheduled,     
case    
 when datlastmailed = ''1/1/1900'' then NULL    
 else datlastmailed    
end as datlastmailed    
from #sample_data    
where datsamplecreate_dt >= getdate() - 365'    
    
if @client_id <> '' select @sql = @sql + ' and client_id in (' + @client_id + ')'    
if @employee_id <> '' select @sql = @sql + ' and employee_id in (' + @employee_id + ')'    
--if (@encounter_startdate <> '' and @encounter_enddate <> '') select @sql = @sql + ' and datdaterange_todate >= ''' + @encounter_startdate + ''' and datdaterange_fromdate <= ''' + @encounter_enddate + ''''    
if @surveytype_id <> '' select @sql = @sql + ' and surveytype_id in (' + @surveytype_id + ')'    
    
select @sql = @sql + ' order by stremployee_first_nm, stremployee_last_nm, strclient_nm, strstudy_nm, strsurvey_nm'     
     
print @sql    
exec(@sql)    
    
--drop temp tables     
drop table #tmp3    
drop table #tmp4  
drop table #sample_data


