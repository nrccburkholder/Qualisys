CREATE procedure qp_Rep_ReportScheduling
  @BeginDate datetime
as
set transaction isolation level read uncommitted
select c.strclient_nm as Client, s.strstudy_nm as Study, cc.strcontactname as Contact, 
  convert(varchar,sdd.datdelivery_dt,101) as [Due Date], replace(sdd.strdelivery_dsc,char(13),'') as Deliverable
from studydeliverydate sdd, study s, client c, client_contact cc
where sdd.study_id=s.study_id
  and s.client_id=c.client_id
  and sdd.contact_id=cc.contact_id
  and datdelivery_dt >= @BeginDate
order by datdelivery_dt, strclient_nm, strStudy_nm

set transaction isolation level read committed


