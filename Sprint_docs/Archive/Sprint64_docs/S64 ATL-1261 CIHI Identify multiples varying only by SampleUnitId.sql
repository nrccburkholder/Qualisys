/*

S64 ATL-1261 CIHI Identify multiples varying only by SampleUnitId.sql

Chris Burkholder

12/9/2016

*/
-- people who were directly sampled at multiple sample units which were both designated as CIHI units
update q set SampleUnitId = -q.SampleUnitId 
--select qcs.FacilityNum, q.CIHI_PID, q.SampleUnitId as [patient was sampled for multiple CIHI units]
from CIHI.QA_QuestionnaireCycleAndStratum qcs
	inner join CIHI.QA_Questionnaire q on abs(q.SampleUnitId) = qcs.SampleunitId and qcs.submissionid=q.submissionid
	inner join
			  (select FacilityNum, CIHI_PID, count(*) [Cnt] 
			  from CIHI.QA_QuestionnaireCycleAndStratum qcs2
			  inner join CIHI.QA_Questionnaire q2 on q2.SampleUnitId = qcs2.SampleunitId and qcs2.submissionid=q2.submissionid
			  where qcs2.submissionID = @submissionID
			  group by FacilityNum, CIHI_PID, SamplesetID
			  having count(*) > 1) a 
		on a.FacilityNum = qcs.FacilityNum and a.CIHI_PID = q.CIHI_PID
where q.SampleUnitId > 0
and qcs.submissionID = @submissionID

