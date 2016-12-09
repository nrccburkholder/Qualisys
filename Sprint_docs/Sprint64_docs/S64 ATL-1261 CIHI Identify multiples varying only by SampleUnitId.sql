/*

S64 ATL-1261 CIHI Identify multiples varying only by SampleUnitId.sql

Chris Burkholder

12/9/2016

*/

  update q set SampleUnitId = q.SampleUnitId + '*'
  --select q.SampleUnitId, q.*
  from CIHI.QA_QuestionnaireCycleAndStratum qcs
	inner join CIHI.QA_Questionnaire q on q.SampleUnitId = qcs.SampleunitId
	inner join
  (select FacilityNum, CIHI_PID, count(*) [Cnt] from CIHI.QA_QuestionnaireCycleAndStratum qcs2
  inner join CIHI.QA_Questionnaire q2 on q2.SampleUnitId = qcs2.SampleunitId
  group by FacilityNum, CIHI_PID, SamplesetID
  having count(*) > 1) a on a.FacilityNum = qcs.FacilityNum and a.CIHI_PID = q.CIHI_PID
  where q.SampleUnitId not like '%*'



