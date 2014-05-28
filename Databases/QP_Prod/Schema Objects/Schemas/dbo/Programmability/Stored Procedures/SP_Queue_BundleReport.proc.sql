--Created 9/10/2002 BD This procedure creates the bundling report.
CREATE PROCEDURE SP_Queue_BundleReport @datBundled DATETIME, @Survey_id varchar(10), @PaperConfig INT
AS

if @survey_id='GP'
	select 'Grouped Print (' + pc.strPaperconfig_nm + ' - ' + convert(varchar, gp.datPrinted) + ')' as strProjName, 
		0 as Survey_id, 
		gp.datBundled, 
		pc.strPaperconfig_nm, 
		np.strPostalBundle, 
		np.strGroupDest, 
		min(np.strLithocode) as minLitho,
		max(np.strLithocode) as MaxLitho, 
		count(np.sentmail_id) as pieces
	FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, GroupedPrint GP
	WHERE NP.strPostalBundle IS NOT NULL 
	AND ABS(datediff(second,gp.datPrinted,@datBundled)) <= 1 
	AND NP.Methodology_id = MM.Methodology_id 
	AND NP.PaperConfig_id = @PaperConfig
	AND NP.PaperConfig_id = PC.PaperConfig_id 
	and mm.survey_id=gp.survey_id
	and np.paperconfig_id=gp.paperconfig_id
	and ABS(datediff(second,NP.datBundled,gp.datBundled)) <= 1 
	GROUP BY GP.datPrinted, gp.datBundled, PC.strPaperConfig_nm, NP.strPostalBundle, NP.strGroupDest 
   union all
	SELECT C.strClient_nm + ' (' + rtrim(SD.strSurvey_nm) + ' - ' + CONVERT(VARCHAR,MM.Survey_id) + ')' AS strProjName, 
		MM.Survey_id, NP.datBundled, PC.strPaperConfig_nm, char(250), char(250), MIN(NP.strLithoCode) AS MinLitho, 
		MAX(NP.strLithoCode) AS MaxLitho, COUNT(NP.SentMail_id) AS Pieces
	FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, Survey_def SD, Study S, Client C, GroupedPrint gp
	WHERE NP.strPostalBundle IS NOT NULL 
	AND ABS(datediff(second,NP.datBundled,@datBundled)) <= 1 
	AND ABS(datediff(second,gp.datPrinted,@datBundled)) <= 1 
	AND NP.Methodology_id = MM.Methodology_id 
	AND NP.PaperConfig_id = @PaperConfig
	AND NP.PaperConfig_id = PC.PaperConfig_id 
	AND MM.Survey_id = SD.Survey_id 
	AND SD.Study_id = S.Study_id 
	AND S.Client_id = C.Client_id 
	and mm.survey_id=gp.survey_id
	and np.paperconfig_id=gp.paperconfig_id
	and ABS(datediff(second,NP.datBundled,gp.datBundled)) <= 1 
	GROUP BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, NP.datBundled, PC.strPaperConfig_nm--, ISNULL(datPrinted,Getdate()), NP.strPostalBundle, NP.strGroupDest 
	ORDER BY 3, 4, 5, 6, 7
else
	SELECT C.strClient_nm + ' (' + rtrim(SD.strSurvey_nm) + ' - ' + CONVERT(VARCHAR,MM.Survey_id) + ')' AS strProjName, 
		MM.Survey_id, NP.datBundled, PC.strPaperConfig_nm, NP.strPostalBundle, NP.strGroupDest, MIN(NP.strLithoCode) AS MinLitho, 
		MAX(NP.strLithoCode) AS MaxLitho, COUNT(NP.SentMail_id) AS Pieces 
	FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, Survey_def SD, Study S, Client C 
	WHERE NP.strPostalBundle IS NOT NULL 
	AND ABS(datediff(second,NP.datBundled,@datBundled)) <= 1 
	AND SD.Survey_id = @Survey_id
	AND NP.Methodology_id = MM.Methodology_id 
	AND NP.PaperConfig_id = @PaperConfig
	AND NP.PaperConfig_id = PC.PaperConfig_id 
	AND MM.Survey_id = SD.Survey_id 
	AND SD.Study_id = S.Study_id 
	AND S.Client_id = C.Client_id 
	GROUP BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, NP.datBundled, PC.strPaperConfig_nm, --ISNULL(datPrinted,Getdate()), 
		NP.strPostalBundle, NP.strGroupDest 
	ORDER BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, NP.datBundled, PC.strPaperConfig_nm, --ISNULL(datPrinted,Getdate()), 
		NP.strPostalBundle, NP.strGroupDest


