CREATE procedure [dbo].[SV_VerifyCardinality]
@survey_id int
as
select distinct 1 as bitError, 'ERROR!  Criteria Statement for "'+strSampleUnit_nm+'" sample unit requires more than one client record to satisfy' as strMessage
from   (SELECT SU.strSampleUnit_nm
	FROM SamplePlan SP, SampleUnit SU, CriteriaClause CC, CriteriaStmt CS
	WHERE SP.Survey_id = @Survey_id
	AND SU.SamplePlan_id = SP.SamplePlan_id
	AND CC.CriteriaStmt_id = SU.CriteriaStmt_id
	AND CS.CriteriaStmt_id = CC.CriteriaStmt_id
	GROUP BY SU.SampleUnit_id,SU.strSampleUnit_nm,  SU.CriteriaStmt_id, CS.strCriteriaStmt_nm, CriteriaPhrase_id, Table_id, Field_id 
	HAVING count(*) > 1) sub


