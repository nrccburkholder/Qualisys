CREATE PROCEDURE QP_Rep_WorkPerformed
 @Associate varchar(20),
 @FirstDay datetime,
 @LastDay datetime
AS
set transaction isolation level read uncommitted
  if @firstday = @lastday
	begin
		set @firstday = dateadd(day, -45, @firstday)
	end


 select @LastDay=dateadd(day,1,@lastday)

 create table #sampled (
   dummy_id int,
   strClient_nm varchar (40),
   strStudy_nm char (10),
   strSurvey_nm char (10),
   survey_id integer,
   datSampleCreate_dt datetime,
   Sampled char(10),
   dummySS_id int)

 insert #sampled (strClient_nm, strStudy_nm, strSurvey_nm, Survey_id, datSampleCreate_Dt, sampled, dummySS_id)
 (select c.strclient_nm, s.strstudy_nm, sd.strsurvey_nm, ss.survey_id,ss.datsamplecreate_dt, convert(char (10),count(*)) as Sampled, ss.sampleset_id
  from sampleset ss, samplepop sp, survey_def sd, study s, study_employee se, employee e, client c
  where ss.sampleset_id=sp.sampleset_id
    and ss.survey_id=sd.survey_id
    and sd.study_id=s.study_id
    and s.client_id=c.client_id
    and s.study_id=se.study_id
    and se.employee_id=e.employee_id
    and e.strNTLogin_nm=@associate
--  and datediff(day,ss.datsamplecreate_dt,getdate())<=@days
    and ss.datsamplecreate_dt between @FirstDay and @LastDay
  group by c.strclient_nm, s.strstudy_nm, sd.strsurvey_nm, ss.survey_id,ss.datsamplecreate_dt,ss.sampleset_id)

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
         order by strClient_nm, strStudy_nm, strSurvey_nm, survey_id, datSampleCreate_dt) sub
   where #sampled.survey_id=sub.survey_id
     and #sampled.datSampleCreate_dt=sub.datSampleCreate_dt     
 end

 select mm.survey_id, #sampled.datsamplecreate_dt, ms.strmailingstep_nm, ms.intSequence,
    sm.datgenerated, sm.datprinted, sm.datmailed, 0 as numGenerated, 0 as numPrinted, 0 as numMailed
 into #prodreport
 from sentmailing SM, scheduledmailing schm, mailingstep MS, mailingmethodology MM, samplepop sp, #sampled
    --sampleset SS, survey_def sd, study_employee se, employee e
 where SM.scheduledmailing_id=schm.scheduledmailing_id
   and schm.mailingstep_id=MS.mailingstep_id
   and MS.methodology_id=MM.methodology_id
   and schm.samplepop_id=sp.samplepop_id
   and sp.sampleset_id=#sampled.dummySS_id
/*
   and MM.survey_id=sd.survey_id
   and sd.study_id=se.study_id
   and se.employee_id=e.employee_id
   and e.strNTLogin_nm=@associate
*/
-- and datediff(day,ss.datsamplecreate_dt,getdate())<=@days
-- and ss.datsamplecreate_dt between @FirstDay and @LastDay

 update #prodreport set numGenerated=1 where datGenerated is not null
 update #prodreport set numprinted=1 where datprinted is not null
 update #prodreport set nummailed=1 where datmailed is not null

 select s.dummy_id, s.strclient_nm as Client, s.strstudy_nm as Study, s.strsurvey_nm as Survey, s.Sampled, convert(varchar,s.datsamplecreate_dt,100) as [Sample Date], pr.intSequence as dummy_Step, pr.strmailingstep_nm as [Mailing Step],
    sum(pr.numGenerated) as Generated, sum(pr.numPrinted) as Printed,sum(pr.numMailed) as Mailed
 from #sampled s, #prodreport pr
 where pr.intsequence=1 and s.survey_id=pr.survey_id and s.datsamplecreate_dt=pr.datsamplecreate_dt
 group by s.dummy_id,s.strclient_nm,s.strstudy_nm,s.strsurvey_nm,s.Sampled,s.datsamplecreate_dt,pr.intSequence, pr.strmailingstep_nm
 union
 select s.dummy_id, '' as Client, '' as Study, '' as Survey, '' as Sampled, '' as [Sample Date], pr.intSequence as dummy_Step, pr.strmailingstep_nm as [Mailing Step],
    sum(pr.numGenerated) as Generated, sum(pr.numPrinted) as Printed,sum(pr.numMailed) as Mailed
 from #sampled s, #prodreport pr
 where pr.intsequence<>1 and s.survey_id=pr.survey_id and s.datsamplecreate_dt=pr.datsamplecreate_dt
 group by s.dummy_id,s.strclient_nm,s.strstudy_nm,s.strsurvey_nm,s.Sampled,s.datsamplecreate_dt,pr.intSequence, pr.strmailingstep_nm
 order by s.dummy_id,pr.intSequence

 drop table #prodreport
 drop table #sampled

set transaction isolation level read committed


