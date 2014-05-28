CREATE PROCEDURE QP_QFL_LastSample_dt @client VARCHAR(50), @study VARCHAR(50), @survey VARCHAR(50), @firstsampleset DATETIME
AS
-- 6/30/05 - SS
-- Returns a list of SampleSet dates for Dashboard based upon a client,study,survey selection.
SELECT strParamList = datsamplecreate_dt
FROM sampleset X,Client c,Study s,Survey_def D 
WHERE c.client_id=s.client_id AND strClient_nm=@Client AND strStudy_nm=@Study 
AND s.study_id=d.study_id 
AND d.strSurvey_nm = CASE WHEN @Survey = '_ALL' THEN d.strSurvey_nm ELSE @survey END
AND d.survey_id=x.survey_id AND DATSAMPLECREATE_DT>=@FirstSampleSet 
ORDER BY datSampleCreate_dt


