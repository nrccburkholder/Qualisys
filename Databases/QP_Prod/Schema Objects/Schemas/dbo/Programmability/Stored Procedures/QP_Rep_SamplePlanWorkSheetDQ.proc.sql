CREATE  procedure QP_Rep_SamplePlanWorkSheetDQ
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intSampleSet_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

create table #dq
 (DQ_id int, DQRuleName varchar(20), Cnt int)

IF EXISTS (SELECT sampleset_id from sampleplanworksheet WHERE sampleset_id=@intsampleset_id)
BEGIN
	insert into #DQ (DQRuleName, cnt)
	SELECT DQ, sum(N)
	FROM SPWDQCOUNTs
	WHERE sampleset_id=@intsampleset_id
	GROUP BY DQ
END
ELSE
BEGIN
	
	insert into #DQ (DQ_id, DQRuleName, cnt)
	  SELECT CS.CriteriaStmt_id, CS.strCriteriaStmt_nm, 0 
	  FROM BusinessRule BR, CriteriaStmt CS 
	  WHERE BR.CriteriaStmt_id = CS.CriteriaStmt_id AND 
	        BR.Survey_id = @intSurvey_id AND 
	        BR.BusRule_cd = 'Q'
	
	update #DQ
	set cnt=xx.numDQ
	from (SELECT CS.CriteriaStmt_id, Count(*) AS NumDQ 
	      FROM UnitDQ UD, BusinessRule BR, CriteriaStmt CS
	      WHERE UD.DQRule_id = BR.BusinessRule_id AND 
	            BR.CriteriaStmt_id = CS.CriteriaStmt_id AND 
	            UD.SampleSet_id = @intSampleSet_id
	      GROUP BY CS.CriteriaStmt_id) XX
	where #dq.dq_id=xx.criteriastmt_id
END

select DQRuleName, Cnt from #dq


update  dashboardlog 
set procedureend = getdate()
where report = 'Sample Plan Worksheet'
and associate = @associate
and client = @client
and study = @study
and survey = @survey
and sampleset = @sampleset
and procedureend is null

drop table #dq

set transaction isolation level read committed


