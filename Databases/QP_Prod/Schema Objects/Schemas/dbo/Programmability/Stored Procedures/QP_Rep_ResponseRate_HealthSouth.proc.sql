CREATE PROCEDURE dbo.QP_Rep_ResponseRate_HealthSouth
--DECLARE
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50),  
 @FirstSampleSet varchar(50),  
 @LastSampleSet varchar(50)  
AS  

-- SELECT
--  @Associate 		= 'SSPICKA',  
--  @Client 			='HEALTHSOUTH CORPORATION',  
--  @Study 			= 'SURG',  
--  @Survey 			= '7893PSCC',  
--  @FirstSampleSet 	=  '1/11/2005 2:23:56 PM',  
--  @LastSampleSet 	= '3/11/2005 4:01:14 PM'
-- 

set transaction isolation level read uncommitted  
Declare @intSurvey_id int, @intSampleSet_id1 int, @intSampleSet_id2 int, @intSamplePlan_id int, @srv VARCHAR(42), @sql VARCHAR(8000)
select @intSurvey_id=sd.survey_id   
from survey_def sd, study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and sd.strsurvey_nm=@survey  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  
select @intSampleSet_id1=SampleSet_id  
from SampleSet  
where Survey_id=@intSurvey_id  
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@FirstSampleSet)))<=1  
  
select @intSampleSet_id2=SampleSet_id  
from SampleSet  
where Survey_id=@intSurvey_id  
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@LastSampleSet)))<=1  

CREATE TABLE #RR (survey_id INT, sampleset_id INT, sampleunit_Id INT, intSampled INT, intUD INT, intReturned INT, datSampleCreate_dt DATETIME)

SELECT @srv = strParam_Value FROM qualpro_params where strparam_grp = 'DATAMART'

SET @SQL = ''
SET @SQL = '
INSERT INTO #rr (survey_Id, sampleset_id, sampleunit_id, intSampled, intUD, intReturned, datSampleCreate_dt) ' + CHAR(10) + 
'select rrc.survey_id, rrc.sampleset_id, rrc.sampleunit_id, rrc.intSampled, rrc.intUD, rrc.intReturned, rrc.datSampleCreate_dt ' + CHAR(10) + 
'from ' + @srv + '.qp_comments.dbo.respratecount rrc, SampleSet ss, SampleUnit su '   + CHAR(10) + 
'where ss.survey_id=' + CONVERT(VARCHAR,@intSurvey_id)    + CHAR(10) + 
'  and ss.sampleset_id between ' + CONVERT(VARCHAR,@intSampleSet_id1) + ' and  ' + CONVERT(VARCHAR,@intSampleSet_id2)    + CHAR(10) + 
'  and ss.sampleset_id = rrc.sampleset_id '   + CHAR(10) + 
'  and rrc.sampleunit_id=su.sampleunit_id '   + CHAR(10) + 
'  and su.bitsuppress=0 '   + CHAR(10) + 
'UNION '  + CHAR(10) + 
'select rrc.survey_id, rrc.sampleset_id, rrc.sampleunit_id, rrc.intSampled, rrc.intUD, rrc.intReturned, rrc.datSampleCreate_dt '   + CHAR(10) + 
'from ' + @srv + '.qp_comments.dbo.respratecount rrc, SampleSet ss '  + CHAR(10) + 
'where ss.survey_id=' + CONVERT(VARCHAR,@intSurvey_id)  + CHAR(10) + 
'  and ss.sampleset_id between ' + CONVERT(VARCHAR,@intSampleSet_id1) + ' and ' + CONVERT(VARCHAR,@intSampleSet_id2)  + CHAR(10) + 
'  and ss.sampleset_id = rrc.sampleset_id '  + CHAR(10) + 
'  and rrc.sampleunit_id=0'

EXEC (@sql)
  
select @intSamplePlan_id=SamplePlan_id   
from SamplePlan   
where Survey_id=@intSurvey_id  
  
create table #SampleUnits  
 (SampleUnit_id int,  
  strSampleUnit_nm varchar(255),  
  intTier int,  
  intTreeOrder int,  
  intTargetReturn int,
  strCriteriaString TEXT)  
 
exec sp_SampleUnits @intSamplePlan_id  
  
update su set inttargetreturn = s.inttargetreturn  
from #sampleunits su, sampleunit s  
where su.sampleunit_id = s.sampleunit_id  

UPDATE su2 SET strcriteriastring = c.strcriteriastring from #sampleunits su2, sampleunit su, criteriastmt c where su2.sampleunit_id = su.sampleunit_Id and  su.criteriastmt_id = c.criteriastmt_id

select ''''+isnull(convert(varchar,LTRIM(RTRIM(strSampleUnit_nm))),'Total outgo') as SampleUnit, 
  #rr.sampleunit_id as [Unit ID],  
  su.intTreeOrder as dummyOrder,  
  sum(intsampled) as Sampled,   
  sum(intUD) as Nondel,   
  sum(intReturned) as Returned,  
  su.inttargetreturn as Target,  
--  sum(intReturned)/convert(float,sum(intSampled)) as RespRate,  
  sum(intReturned)/convert(float,sum(intSampled-intUD)) as 'Current RespRate',
  CONVERT(VARCHAR(3750),strCriteriaString) CriteriaStmt
from #rr left outer join #sampleunits su on #rr.sampleunit_id=su.sampleunit_id
group by strSampleUnit_nm, CONVERT(VARCHAR(3750),strCriteriaString) , #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder  
having sum(intsampled)-sum(intUD)>0  
union  
select ''''+isnull(convert(varchar,LTRIM(RTRIM(strSampleUnit_nm))),'Total outgo') as SampleUnit,
  #rr.sampleunit_id as [Unit ID],  
  su.intTreeOrder as dummyOrder,  
  sum(intsampled) as Sampled,   
  sum(intUD) as Nondel,   
  sum(intReturned) as Returned,  
  su.inttargetreturn as Target,  
--  sum(intReturned)/convert(float,sum(intSampled)) as RespRate,  
  convert(int,null) as 'Current RespRate',
  CONVERT(VARCHAR(3750),strCriteriaString) CriteriaStmt
from #rr left outer join #sampleunits su on #rr.sampleunit_id=su.sampleunit_id  
group by strSampleUnit_nm, CONVERT(VARCHAR(3750),strCriteriaString), #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder  
having sum(intsampled)-sum(intUD)=0  
order by su.intTreeOrder  
 
drop table #rr  
drop table #sampleunits  
set transaction isolation level read committed


