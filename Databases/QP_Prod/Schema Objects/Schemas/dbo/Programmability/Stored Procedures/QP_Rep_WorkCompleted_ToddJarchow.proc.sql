CREATE PROCEDURE QP_Rep_WorkCompleted_ToddJarchow
 @Associate varchar(20),
 @FirstDay datetime,
 @LastDay datetime,
 @AD varchar(20)
AS
set transaction isolation level read uncommitted
  if @firstday = @lastday
	begin
		set @firstday = dateadd(day, -45, @firstday)
	end

 select @LastDay=dateadd(day,1,@lastday)

 create table #sampled (
   dummy_id int,
   AcctDir varchar(20), 
   strClient_nm varchar (40),
   client_id integer,
   strStudy_nm char (10),
   study_id integer,
   strSurvey_nm char (10),
   survey_id integer,
   datSampleCreate_dt datetime,
   Sampled char(10),
   dummySS_id int)

if @ad = 'All'
begin

 insert #sampled (AcctDir, strClient_nm, strStudy_nm, strSurvey_nm, Survey_id, datSampleCreate_Dt, sampled, dummySS_id, client_id, study_id)
 (select AD.strNTLogin_nm, c.strclient_nm, s.strstudy_nm, ss.strsamplesurvey_nm, ss.survey_id,ss.datsamplecreate_dt, convert(char (10),count(*)) as Sampled, ss.sampleset_id, c.client_id, s.study_id
  from sampleset ss, samplepop sp, survey_def sd, study s, study_employee se, employee e, client c, employee AD
  where s.ADEmployee_ID = ad.employee_id
    and ss.sampleset_id=sp.sampleset_id
    and ss.survey_id=sd.survey_id
    and sd.study_id=s.study_id
    and s.client_id=c.client_id
    and s.study_id=se.study_id
    and se.employee_id=e.employee_id
    and e.strNTLogin_nm=@associate
    and ss.datsamplecreate_dt between @FirstDay and @LastDay
  group by AD.strNTLogin_nm, c.strclient_nm, s.strstudy_nm, ss.strsamplesurvey_nm, ss.survey_id,ss.datsamplecreate_dt,ss.sampleset_id, c.client_id, s.study_id)

end
else
begin

select se2.study_id
into #studycombo
from (select study_id from study_employee se, employee e
where e.strNTLogin_nm = @ad
and e.employee_id = se.employee_id) se,
(select study_id from study_employee se, employee e
where e.strNTLogin_nm = @associate
and e.employee_id = se.employee_id) se2
where se.study_id = se2.study_id

 insert #sampled (AcctDir, strClient_nm, strStudy_nm, strSurvey_nm, Survey_id, datSampleCreate_Dt, sampled, dummySS_id, client_id, study_id)
 (select AD.strNTLogin_nm, c.strclient_nm, s.strstudy_nm, ss.strsamplesurvey_nm, ss.survey_id,ss.datsamplecreate_dt, convert(char (10),count(*)) as Sampled, ss.sampleset_id, c.client_id, s.study_id
  from sampleset ss, samplepop sp, survey_def sd, study s, #studycombo sc, client c, employee AD
  where s.ADEmployee_ID = ad.employee_id
    and ss.sampleset_id=sp.sampleset_id
    and ss.survey_id=sd.survey_id
    and sd.study_id=s.study_id
    and s.client_id=c.client_id
    and s.study_id=sc.study_id
    and ss.datsamplecreate_dt between @FirstDay and @LastDay
  group by AD.strNTLogin_nm, c.strclient_nm, s.strstudy_nm, ss.strsamplesurvey_nm, ss.survey_id,ss.datsamplecreate_dt,ss.sampleset_id, c.client_id, s.study_id)
end


 declare @i integer
 select @i=0
 while @@rowcount>0 
 begin
   select @i=@i+1
   update #sampled
   set dummy_id=@i
   from (select top 1 strClient_nm, strStudy_nm, strSurvey_nm, survey_id, datSampleCreate_dt
         from #sampled
         where dummy_id is null
         order by AcctDir, strClient_nm, strStudy_nm, strSurvey_nm, survey_id, datSampleCreate_dt) sub
   where #sampled.survey_id=sub.survey_id
     and #sampled.datSampleCreate_dt=sub.datSampleCreate_dt     
 end

 select #sampled.AcctDir, #sampled.client_id, #sampled.study_id, mm.survey_id, #sampled.datsamplecreate_dt, ms.strmailingstep_nm, ms.intSequence,
    sm.datgenerated, sm.datprinted, sm.datmailed, 0 as numGenerated, 0 as numPrinted, 0 as numMailed
 into #prodreport
 from sentmailing SM, scheduledmailing schm, mailingstep MS, mailingmethodology MM, samplepop sp, #sampled
 where SM.scheduledmailing_id=schm.scheduledmailing_id
   and schm.mailingstep_id=MS.mailingstep_id
   and MS.methodology_id=MM.methodology_id
   and schm.samplepop_id=sp.samplepop_id
   and sp.sampleset_id=#sampled.dummySS_id

 update #prodreport set numGenerated=1 where datGenerated is not null
 update #prodreport set numprinted=1 where datprinted is not null
 update #prodreport set nummailed=1 where datmailed is not null

 select s.dummy_id, s.AcctDir, s.strclient_nm as Client, convert(char(5),s.client_id) as ClientID, 
    s.strstudy_nm as Study, convert(char(5),s.study_id) as StudyID, s.strsurvey_nm as Survey, 
    convert(char(5),s.survey_id) as SurveyID, s.Sampled, 
    convert(varchar,s.datsamplecreate_dt,100) as [Sample Date], pr.intSequence as dummy_Step, 
    pr.strmailingstep_nm as [Mailing Step],
    case when convert(varchar,min(pr.datGenerated),1)=convert(varchar,max(pr.datGenerated),1) then '' else '* ' end + convert(varchar,min(pr.datGenerated),1) as [GenDate], 
    sum(pr.numGenerated) as Generated, 
    case when convert(varchar,min(pr.datPrinted),1)=convert(varchar,max(pr.datPrinted),1) then '' else '* ' end + convert(varchar,min(pr.datPrinted),1) as [PrintDate], 
    sum(pr.numPrinted) as Printed,
    case when convert(varchar,min(pr.datMailed),1)=convert(varchar,max(pr.datMailed),1) then '' else '* ' end + convert(varchar,min(pr.datMailed),1) as [MailDate], 
    sum(pr.numMailed) as Mailed
 from #sampled s, #prodreport pr
 where pr.intsequence=1 and s.survey_id=pr.survey_id and s.datsamplecreate_dt=pr.datsamplecreate_dt
 group by s.dummy_id,s.AcctDir, s.strclient_nm,s.strstudy_nm,s.strsurvey_nm,s.Sampled,s.datsamplecreate_dt,pr.intSequence, pr.strmailingstep_nm, s.client_id, s.study_id, s.survey_id
 union
 select s.dummy_id, '' as AcctDir, '' as Client, '' as ClientID, '' as Study, '' as StudyID, '' as Survey, 
    '' as SurveyID, '' as Sampled, '' as [Sample Date], pr.intSequence as dummy_Step, 
    pr.strmailingstep_nm as [Mailing Step],
    case when convert(varchar,min(pr.datGenerated),1)=convert(varchar,max(pr.datGenerated),1) then '' else '* ' end + convert(varchar,min(pr.datGenerated),1) as [GenDate], 
    sum(pr.numGenerated) as Generated, 
    case when convert(varchar,min(pr.datPrinted),1)=convert(varchar,max(pr.datPrinted),1) then '' else '* ' end + convert(varchar,min(pr.datPrinted),1) as [PrintDate], 
    sum(pr.numPrinted) as Printed,
    case when convert(varchar,min(pr.datMailed),1)=convert(varchar,max(pr.datMailed),1) then '' else '* ' end + convert(varchar,min(pr.datMailed),1) as [MailDate], 
    sum(pr.numMailed) as Mailed
 from #sampled s, #prodreport pr
 where pr.intsequence<>1 and s.survey_id=pr.survey_id and s.datsamplecreate_dt=pr.datsamplecreate_dt
 group by s.dummy_id,s.strclient_nm,s.strstudy_nm,s.strsurvey_nm,s.Sampled,s.datsamplecreate_dt,pr.intSequence, pr.strmailingstep_nm, s.client_id, s.study_id, s.survey_id, s.AcctDir 
 order by s.dummy_id,pr.intSequence

update dashboardlog
set procedureend = getdate()
where report = 'Work Completed'
and associate = @associate
and startdate = @firstday
and enddate = @lastday
and procedureend is null

drop table #prodreport
drop table #sampled

set transaction isolation level read committed


