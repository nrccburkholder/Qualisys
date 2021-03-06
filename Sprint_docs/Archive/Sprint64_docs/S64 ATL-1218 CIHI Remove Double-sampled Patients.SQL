/*

S64 ATL-1218 CIHI Remove Double-sampled Patients.SQL

Chris Burkholder

12/9/2016

*/

	-- Remove Double-sampled Patients - shouldn't be necessary after 2016Q2
	--select qcs.FacilityNum, q.CIHI_PID as [patient was sampled twice!]
	delete q
	from CIHI.QA_QuestionnaireCycleAndStratum qcs
	inner join CIHI.QA_Questionnaire q on q.SampleUnitId = qcs.SampleunitId and qcs.submissionid=q.submissionid
	inner join (select FacilityNum, CIHI_PID, count(*) [Cnt], min(SamplesetID) [FirstSamplesetID], max(SamplesetID) [LastSamplesetID] 
				from CIHI.QA_QuestionnaireCycleAndStratum qcs2
				inner join CIHI.QA_Questionnaire q2 on q2.SampleUnitId = qcs2.SampleunitId and qcs2.submissionid=q2.submissionid
				where qcs2.submissionID = @submissionID
				group by FacilityNum, CIHI_PID
				having count(*) > 1) a 
		on a.FacilityNum = qcs.FacilityNum and a.CIHI_PID = q.CIHI_PID
	where q.SampleSetId > a.FirstSamplesetID
	and qcs.submissionID = @submissionID

--  select * from CIHI.QA_Questionnaire where samplesetid is not null or CIHI_PID in ('34015','91067')
