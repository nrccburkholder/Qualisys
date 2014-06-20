﻿create procedure SampleStatusReport as              
                 
update t set employee_id = e.employee_id,                  
 stremail = e.stremail                  
from msm_statusreports t inner join employee e                  
 on t.firstname = e.stremployee_first_nm                  
 and t.lastname = e.stremployee_last_nm
 where active = 1                  
                  
--to redirect, if necessary                
--update msm_statusreports set stremail = 'SBaltensperger@NRCPicker.com' where firstname = 'rachel'                  

drop table msm_data                  
select c.strclient_nm, employee_id, firstname, lastname, s.study_id, isnull(strstudy_dsc, strstudy_nm) as strstudy_nm, sd.survey_id, isnull(strsurvey_dsc, strsurvey_nm) as strsurvey_nm,                  
 cast('1/1/1900' as datetime) as datsamplecreate_dt, cast('1/1/1900' as datetime) as datdaterange_fromdate, cast('1/1/1900' as datetime) as datdaterange_todate,                  
 '   ' as Ind, surveytype_id                  
into msm_data                  
from survey_def sd inner join study s                  
 on sd.study_id = s.study_id                  
inner join msm_statusreports t                  
 on s.ademployee_id = t.employee_id                  
inner join client c                  
 on s.client_id = c.client_id                  
where sd.active = 1                   
and s.active = 1                  
and c.active = 1 and t.active = 1
       
         
select ss.survey_id, max(ss.datsamplecreate_dt) as datsamplecreate_dt                  
into #tmp3                  
from msm_data t inner join sampleset ss                  
 on t.survey_id = ss.survey_id                  
group by ss.survey_id                  
                  
update t2                  
set datsamplecreate_dt = t3.datsamplecreate_dt                  
from msm_data t2 inner join #tmp3 t3                  
 on t2.survey_id = t3.survey_id                  
                  
                  
update t2                  
set datdaterange_fromdate = ss.datdaterange_fromdate,                  
 datdaterange_todate = ss.datdaterange_todate                  
from msm_data t2 inner join sampleset ss                  
 on t2.survey_id = ss.survey_id                  
 and t2.datsamplecreate_dt = ss.datsamplecreate_dt                
                  
                  
update msm_data set Ind = ' *'                  
where datsamplecreate_dt >= cast(floor(cast(getdate()-7 as float)) as datetime)     
                  
update msm_data set Ind = ''                  
where Ind <> ' *'                  
                  

                  
declare @fname varchar(50)            
declare @lname varchar(50)                  
declare @stremail varchar(50)                  
declare @sql varchar(4000)                  
declare @sub varchar(50)                  
declare @count int                  
                  
declare cEmployee cursor for                   
select firstname, lastname, stremail from msm_statusreports                 

                  
open cEmployee                                                    
fetch next from cEmployee into @fname, @lname, @stremail                  
                  
while @@fetch_status = 0                                                    
begin                                                    
                  
 select @count = count(*)                  
 from msm_data                  
 where datsamplecreate_dt <> '1/1/1900'                  
 and datsamplecreate_dt >= cast(floor(cast(getdate()-60 as float)) as datetime)                  
 and firstname = @fname                 
 and lastname = @lname                  
                  
 if @count > 1                  
 begin                  
                  
  select 'Samples for ' + @fname + ' ' + @lname                  
  select @sql = 'select cast(strclient_nm as varchar(34)) as [Client], cast(strsurvey_nm as varchar(34)) as [Survey],               
  cast(survey_id as varchar(5)) as [ID], convert(varchar(9),datsamplecreate_dt,1) + Ind as ''Sample Date'',               
  cast(convert(varchar,datdaterange_fromdate,1) + '' - '' + convert(varchar,datdaterange_todate,1) +                  
   case                   
    when surveytype_id = 2 then ''  (H)''                  
    when surveytype_id = 3 then ''  (HH)''                  
    else ''''                  
   end as varchar(32)) as DateRange                  
  from msm_data                  
  where datsamplecreate_dt <> ''1/1/1900''                  
  and datsamplecreate_dt >= cast(floor(cast(getdate()-60 as float)) as datetime)                  
  and firstname = ''' + @fname + '''                  
  and lastname = ''' + @lname + '''                  
  order by strclient_nm, survey_id'                  
                  
  select @sub = 'Sample Status Report for ' + @fname + ' ' + @lname                  
              
  --To add leads            
  if @stremail in ('KRea@NRCPicker.com', 'HWood@NRCPicker.com')             
 select @stremail = @stremail + ';LWitt@NRCPicker.com'            
            
            
  EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',                  
--  @recipients='kosmera@nrcpicker.com',                  
  @recipients=@stremail,                  
  @subject=@sub,                  
  @body_format='HTML',                  
  @importance='High',                  
  @execute_query_database = 'qp_prod',                  
  @attach_query_result_as_file = 1,                  
  @query_attachment_filename = 'SampleUpdate.txt',                  
  @Query=@sql                  
 end                  
                  
 fetch next from cEmployee into @fname, @lname, @stremail                  
end                  
                  
close cEmployee                                                    
deallocate cEmployee                                                    
                  
                  
select @sql = 'select cast(firstname as varchar(12)) as [First Name], cast(lastname as varchar(15)) as [Last Name],               
cast(strclient_nm as varchar(34)) as [Client], cast(strsurvey_nm as varchar(34)) as [Survey], cast(survey_id as varchar(5)) as [ID],               
convert(varchar(9),datsamplecreate_dt,1) + Ind as ''Sample Date'',               
cast(convert(varchar,datdaterange_fromdate,1) + '' - '' + convert(varchar,datdaterange_todate,1) +                  
   case                   
    when surveytype_id = 2 then ''  (H)''                  
    when surveytype_id = 3 then ''  (HH)''                  
    else ''''                  
   end as varchar(32)) as DateRange                  
from msm_data                  
where datsamplecreate_dt <> ''1/1/1900''                  
and datsamplecreate_dt >= cast(floor(cast(getdate()-60 as float)) as datetime)                  
order by firstname, lastname, strclient_nm, survey_id'                  
                  
select @sub = 'Sample Status Report for ' + convert(varchar, getdate(), 101)                  
              
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',                  
--@recipients='kosmera@nrcpicker.com',                    
@recipients='hmyers@nrcpicker.com;spietzyk@nrcpicker.com;hhrdy@nationalresearch.com;sbaltensperger@nationalresearch.com',          
@subject=@sub,                  
@body_format='HTML',                  
@importance='High',          
@execute_query_database = 'qp_prod',                  
@attach_query_result_as_file = 1,                  
@query_attachment_filename = 'SampleUpdate.txt',                  
@Query=@sql                  
                  
                  
--drop table msm_statusreports                  
drop table #tmp3

