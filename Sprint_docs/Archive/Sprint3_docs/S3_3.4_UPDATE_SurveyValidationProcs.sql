
/*
-- Make backup of current table
select *
INTO bak_SurveyValidationProcs
from surveyvalidationprocs

*/

SELECT *
FROM SurveyValidationProcs

UPDATE SurveyValidationProcs
	SET ProcedureName = 'SV_ALL_CAHPS',
	ValidMessage = 'PASSED!  CAHPS Ready'
WHERE SurveyValidationProcs_id = 11

DELETE SurveyValidationProcs
WHERE SurveyValidationProcs_id IN (18,19,20)

SELECT *
FROM SurveyValidationProcs
