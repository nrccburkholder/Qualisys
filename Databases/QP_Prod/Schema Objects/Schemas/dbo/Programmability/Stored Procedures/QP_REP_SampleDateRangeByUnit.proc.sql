CREATE PROCEDURE QP_REP_SampleDateRangeByUnit @associate VARCHAR(20), @client VARCHAR(40), @study VARCHAR(10), @survey VARCHAR(10)
AS

-- Created 6/17/05 - SS - User provides sampleunit_id, and result set shows the first and last sample create dates, and first and last encounter dates sampled.
-- declare @survey varchar (10), @study varchar(10), @client varchar(40)
-- set @client = 'healthsouth corporation'
-- set @study = 'diagnostic'
-- set @survey = '7891DC'

SELECT /*sd.strSurvey_nm Survey, sd.survey_id SurveyID, */ LEFT(su.strSampleUnit_nm,42) SampleUnit, spw.sampleunit_id SampleUnitID, COUNT(spw.sampleset_id) AS 'SampleCount', 
	'''' + CONVERT(VARCHAR(23),MIN(datSampleCreate_dt),121) FirstSample, '''' + CONVERT(VARCHAR(23),MAX(datSampleCreate_dt),121) LastSample, '''' + CONVERT(VARCHAR(23),MIN(minenc_dt),121) MinEncDate, 
	'''' + CONVERT(VARCHAR(23),MAX(maxenc_dt),121) MaxEncDate 
		FROM Sampleplanworksheet spw, Sampleset ss, Sampleunit su, SamplePlan sp, Client c, Study s, Survey_Def sd
	WHERE c.strclient_nm = @client AND s.strstudy_nm = @study and sd.strsurvey_nm = @survey 
	AND spw.sampleset_id = ss.sampleset_id AND spw.sampleunit_id = su.sampleunit_id AND  su.sampleplan_id = sp.sampleplan_id
	AND c.client_id = s.client_id and s.study_id = sd.study_id and sp.survey_id = sd.survey_id
	GROUP BY sd.strSurvey_nm, sd.survey_id, su.strSampleUnit_nm, spw.sampleunit_id
	ORDER BY spw.sampleunit_id


