CREATE PROCEDURE qp_rep_TOCLReport
 @Associate VARCHAR(50),
 @Client VARCHAR(50),
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @FirstSampleSet DATETIME,
 @LastSampleSet DATETIME
AS

-- Created: 4/29/05 SJS
-- Testing Variables
	-- DECLARE  @Associate VARCHAR(50), @Client VARCHAR(50), @Study VARCHAR(50), @Survey VARCHAR(50), @FirstSampleSet DATETIME, @LastSampleSet DATETIME
	-- SELECT  @Associate = 'SSPICKA', @Client = 'NORMET', @Study ='PhelpsIPER', @Survey ='7938PhlpER', @FirstSampleSet = '1/1/00 1:35:18 PM', @LastSampleSet = '3/7/05 1:35:18 PM'

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @SQL VARCHAR(2000), @Study_id INT, @Survey_id INT
SELECT @study_id = study_id FROM study s WHERE strStudy_nm = @study 
SELECT @survey_id = survey_id FROM survey_def WHERE strSurvey_nm = @survey

	 SELECT t.TOCL_id, t.datTOCL_dat, ss.datsamplecreate_dt, ss.sampleset_id, p.* 
	 FROM s991.population p, samplepop sp, sampleset ss, TOCL t 
	 WHERE sp.pop_id = p.pop_id and sp.study_id = @study_id
	 AND sp.sampleset_id = ss.sampleset_id
	 AND p.pop_id = t.pop_id AND  t.study_id = @study_id
	 AND ss.survey_id = @survey_id
	 AND CONVERT(VARCHAR,ss.datsamplecreate_dt,120) BETWEEN CONVERT(VARCHAR,@FirstSampleSet,120) AND CONVERT(VARCHAR,@LastSampleSet,120)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


