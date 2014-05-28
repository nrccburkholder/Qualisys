CREATE PROCEDURE QP_Rep_QueueMailed @Associate VARCHAR(50), @Client VARCHAR(50), @Study VARCHAR(50), @Survey VARCHAR(50), @BeginDate datetime, @EndDate datetime
AS

	DECLARE @Today DATETIME
	SET @Today = CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),120))

	SET @EndDate = DATEADD(hh,23,@EndDate)
	SET @EndDate = DATEADD(mi,59,@EndDate)

IF @client = '_ALL'
	-- Determine if we can run against NPSentmailing rather than SentMailing
	IF (@BeginDate =  @Today)
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM NPsentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND sm.datMailed BETWEEN @BeginDate AND @EndDate
		AND sm.datMailed IS NOT NULL
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
	ELSE
	
		SELECT * FROM (
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM sentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND  sm.datMailed BETWEEN @BeginDate AND @EndDate
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
		) T2 WHERE datMailed IS NOT NULL
		ORDER BY datBundled, datmailed


ELSE IF @study = '_ALL'
	-- Determine if we can run against NPSentmailing rather than SentMailing
	IF (@BeginDate =  @Today)
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM NPsentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND c.strClient_nm = @client
		AND sm.datMailed BETWEEN @BeginDate AND @EndDate
		AND sm.datMailed IS NOT NULL
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
	ELSE
	
		SELECT * FROM (
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM sentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND c.strClient_nm = @client
		AND  sm.datMailed BETWEEN @BeginDate AND @EndDate
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
		) T2 WHERE datMailed IS NOT NULL
		ORDER BY datBundled, datmailed



ELSE IF @survey = '_ALL'
	-- Determine if we can run against NPSentmailing rather than SentMailing
	IF (@BeginDate =  @Today)
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM NPsentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND c.strClient_nm = @client AND s.strStudy_nm = @study
		AND sm.datMailed BETWEEN @BeginDate AND @EndDate
		AND sm.datMailed IS NOT NULL
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
	ELSE
	
		SELECT * FROM (
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM sentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND c.strClient_nm = @client AND s.strStudy_nm = @study
		AND  sm.datMailed BETWEEN @BeginDate AND @EndDate
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
		) T2 WHERE datMailed IS NOT NULL
		ORDER BY datBundled, datmailed


ELSE 
	-- Determine if we can run against NPSentmailing rather than SentMailing
	IF (@BeginDate =  @Today)
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM NPsentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND c.strClient_nm = @client AND s.strStudy_nm = @study AND sd.strSurvey_nm = @survey
		AND sm.datMailed BETWEEN @BeginDate AND @EndDate
		AND sm.datMailed IS NOT NULL
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
	ELSE
	
		SELECT * FROM (
		SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.PaperConfig_id, pc.strPaperConfig_nm, sm.datMailed, COUNT(*) AS Mailed
		FROM sentmailing sm (NOLOCK), mailingmethodology mm (NOLOCK) , client c (NOLOCK) , study s (NOLOCK) , survey_def sd (NOLOCK), PaperConfig pc (NOLOCK)
		WHERE sm.methodology_id = mm.methodology_id
		AND mm.survey_id = sd.survey_id AND sd.study_id = s.study_id AND s.client_id = c.client_id AND sm.paperconfig_id = pc.paperconfig_id
		AND c.strClient_nm = @client AND s.strStudy_nm = @study AND sd.strSurvey_nm = @survey
		AND  sm.datMailed BETWEEN @BeginDate AND @EndDate
		GROUP BY c.strClient_nm, c.client_id, s.strStudy_nm, s.study_id, sd.strSurvey_nm, sd.Survey_id, sm.datBundled, sm.paperconfig_id, pc.strPaperConfig_nm, datMailed
		) T2 WHERE datMailed IS NOT NULL
		ORDER BY datBundled, datmailed


