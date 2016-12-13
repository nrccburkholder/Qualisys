/*

S64 ATL-1261 CIHI Identify multiples varying only by SampleUnitId.sql

Chris Burkholder

12/9/2016

*/

  select q.SampleUnitId, q.*
  --update q set SampleUnitId = -q.SampleUnitId 
  from CIHI.QA_QuestionnaireCycleAndStratum qcs
	inner join CIHI.QA_Questionnaire q on abs(q.SampleUnitId) = abs(qcs.SampleunitId)
	inner join
  (select FacilityNum, CIHI_PID, count(*) [Cnt] from CIHI.QA_QuestionnaireCycleAndStratum qcs2
  inner join CIHI.QA_Questionnaire q2 on abs(q2.SampleUnitId) = abs(qcs2.SampleunitId)
  group by FacilityNum, CIHI_PID, SamplesetID
  having count(*) > 1) a on a.FacilityNum = qcs.FacilityNum and a.CIHI_PID = q.CIHI_PID
  where q.SampleUnitId > 0



