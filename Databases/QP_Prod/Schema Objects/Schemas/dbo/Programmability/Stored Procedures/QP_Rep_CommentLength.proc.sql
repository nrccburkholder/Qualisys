CREATE PROCEDURE QP_Rep_CommentLength @Associate VARCHAR(50), @client VARCHAR(50), @STUDY VARCHAR(50), @SURVEY VARCHAR(50), @BeginDate DATETIME, @EndDate DATETIME
AS
	
	SET @EndDate = DATEADD(hh,23,@EndDate)
	SET @EndDate = DATEADD(mi,59,@EndDate)

IF @client = '_ALL'

	SELECT LEFT(sd.strSurvey_Nm, 4) AS [Project Number], 
	       COUNT(*) AS [Qty Comments], 
	       MIN(DATALENGTH(strCmntText)) AS [Min Length], 
	       MAX(DATALENGTH(strCmntText)) AS [Max Length], 
	       AVG(DATALENGTH(strCmntText)) AS [Avg Length], 
	       SUM(DATALENGTH(strCmntText)) AS [Total Length]
	FROM Survey_Def sd 
	INNER JOIN  QuestionForm qf ON sd.Survey_id = qf.Survey_id
	INNER JOIN Comments cm ON qf.QuestionForm_id = cm.QuestionForm_id
	INNER JOIN Study s ON sd.study_id = s.study_id
	INNER JOIN Client c ON s.client_id = c.client_id
	WHERE datEntered BETWEEN @BeginDate AND @EndDate
	GROUP BY LEFT(sd.strSurvey_Nm, 4)
	ORDER BY LEFT(sd.strSurvey_Nm, 4)

ELSE IF @study = '_ALL'

	SELECT LEFT(sd.strSurvey_Nm, 4) AS [Project Number], 
	       COUNT(*) AS [Qty Comments], 
	       MIN(DATALENGTH(strCmntText)) AS [Min Length], 
	       MAX(DATALENGTH(strCmntText)) AS [Max Length], 
	       AVG(DATALENGTH(strCmntText)) AS [Avg Length], 
	       SUM(DATALENGTH(strCmntText)) AS [Total Length]
	FROM Survey_Def sd 
	INNER JOIN  QuestionForm qf ON sd.Survey_id = qf.Survey_id
	INNER JOIN Comments cm ON qf.QuestionForm_id = cm.QuestionForm_id
	INNER JOIN Study s ON sd.study_id = s.study_id
	INNER JOIN Client c ON s.client_id = c.client_id
	WHERE datEntered BETWEEN @BeginDate AND @EndDate
	AND c.strclient_nm = @client 
	GROUP BY LEFT(sd.strSurvey_Nm, 4)
	ORDER BY LEFT(sd.strSurvey_Nm, 4)

ELSE IF @survey = '_ALL'

	SELECT LEFT(sd.strSurvey_Nm, 4) AS [Project Number], 
	       COUNT(*) AS [Qty Comments], 
	       MIN(DATALENGTH(strCmntText)) AS [Min Length], 
	       MAX(DATALENGTH(strCmntText)) AS [Max Length], 
	       AVG(DATALENGTH(strCmntText)) AS [Avg Length], 
	       SUM(DATALENGTH(strCmntText)) AS [Total Length]
	FROM Survey_Def sd 
	INNER JOIN  QuestionForm qf ON sd.Survey_id = qf.Survey_id
	INNER JOIN Comments cm ON qf.QuestionForm_id = cm.QuestionForm_id
	INNER JOIN Study s ON sd.study_id = s.study_id
	INNER JOIN Client c ON s.client_id = c.client_id
	WHERE datEntered BETWEEN @BeginDate AND @EndDate
	AND c.strclient_nm = @client AND s.strstudy_nm = @study
	GROUP BY LEFT(sd.strSurvey_Nm, 4)
	ORDER BY LEFT(sd.strSurvey_Nm, 4)

ELSE
	SELECT LEFT(sd.strSurvey_Nm, 4) AS [Project Number], 
	       COUNT(*) AS [Qty Comments], 
	       MIN(DATALENGTH(strCmntText)) AS [Min Length], 
	       MAX(DATALENGTH(strCmntText)) AS [Max Length], 
	       AVG(DATALENGTH(strCmntText)) AS [Avg Length], 
	       SUM(DATALENGTH(strCmntText)) AS [Total Length]
	FROM Survey_Def sd 
	INNER JOIN  QuestionForm qf ON sd.Survey_id = qf.Survey_id
	INNER JOIN Comments cm ON qf.QuestionForm_id = cm.QuestionForm_id
	INNER JOIN Study s ON sd.study_id = s.study_id
	INNER JOIN Client c ON s.client_id = c.client_id
	WHERE datEntered BETWEEN @BeginDate AND @EndDate
	AND c.strclient_nm = @client AND s.strstudy_nm = @study AND sd.strsurvey_nm = @survey
	GROUP BY LEFT(sd.strSurvey_Nm, 4)
	ORDER BY LEFT(sd.strSurvey_Nm, 4)


