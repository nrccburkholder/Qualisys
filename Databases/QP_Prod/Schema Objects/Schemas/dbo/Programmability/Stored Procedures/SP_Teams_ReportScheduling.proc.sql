create procedure SP_Teams_ReportScheduling
as
truncate table teamstatus_reportscheduling 

insert into teamstatus_reportscheduling 
select c.strclient_nm as Client, s.strstudy_nm as Study, s.study_id as StudyID, cc.strcontactname as Contact, 
  convert(varchar,sdd.datdelivery_dt,101) as [Due Date], replace(sdd.strdelivery_dsc,char(13),'') as Deliverable
from studydeliverydate sdd, study s, client c, client_contact cc
where sdd.study_id=s.study_id
  and s.client_id=c.client_id
  and sdd.contact_id=cc.contact_id
  and datdelivery_dt between dateadd(dd,-1,getdate()) and dateadd(dd,28,getdate())
order by datdelivery_dt, strclient_nm, strStudy_nm


