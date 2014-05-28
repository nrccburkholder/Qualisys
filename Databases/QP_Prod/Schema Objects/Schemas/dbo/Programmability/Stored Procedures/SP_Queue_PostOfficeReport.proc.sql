--Created 9/10/2002 BD This procedure creates the Post Office report.
CREATE PROCEDURE SP_Queue_PostOfficeReport @datBundled DATETIME, @datMailed DATETIME, @Survey_id varchar(10), @PaperConfig INT
AS

if @survey_id='GP'
	SELECT 'Grouped Print (' + pc.strPaperconfig_nm + ' - ' + convert(varchar, gp.datPrinted) + ')' AS strProjName, 
	PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, NP.strPostalBundle, left(NP.strPostalBundle,1) AS TrayType, 
	NP.strPostalBundle AS TrayLvl, ' ' + NP.strGroupDest AS strGroupDest, COUNT(*) AS Pieces, 2 as intOrder
	FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, GroupedPrint gp
	WHERE NP.Methodology_id = MM.Methodology_id 
	AND NP.PaperConfig_id = PC.PaperConfig_id 
	AND MM.Survey_id = gp.Survey_id
	and np.paperconfig_id=gp.paperconfig_id
	and np.datbundled=gp.datbundled
	and np.datprinted=gp.datprinted
	AND NP.PaperConfig_id = @PaperConfig
	AND ABS(datediff(second,GP.datPrinted,@datBundled)) <= 1 
--	AND NP.datMailed = @datMailed
	GROUP BY PC.strPaperConfig_nm, NP.datBundled, np.datMailed, gp.datprinted, NP.strPostalBundle, NP.strGroupDest 
   union all
	SELECT /*1*/C.strClient_nm + ' (' + rtrim(SD.strSurvey_nm) + ' - ' + CONVERT(VARCHAR,MM.Survey_id) + ')' as strProjName,
		/*2*/PC.strPaperConfig_nm, /*3*/NP.datBundled, /*4*/NP.datMailed, /*5*/null as strPostalBundle, 
		/*6*/left(NP.strPostalBundle,1) AS TrayType, /*7*/null as traylvl, /*8*/null as strGroupDest, /*9*/COUNT(*) AS Pieces, 
		/*10*/3 as intOrder 
	FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, GroupedPrint gp, survey_def sd, study s, client c
	WHERE NP.Methodology_id = MM.Methodology_id 
	AND NP.PaperConfig_id = PC.PaperConfig_id 
	AND MM.Survey_id = gp.Survey_id
	and np.paperconfig_id=gp.paperconfig_id
	and np.datbundled=gp.datbundled
	and np.datprinted=gp.datprinted
	AND NP.PaperConfig_id = @PaperConfig
	AND ABS(datediff(second,GP.datPrinted,@datBundled)) <= 1 
	and mm.survey_id=sd.survey_id
	and sd.study_id=s.study_id
	and s.client_id=c.client_id
	GROUP BY c.strclient_nm, sd.strsurvey_nm, mm.survey_id,PC.strPaperConfig_nm, NP.datBundled, np.datMailed, gp.datprinted, left(NP.strPostalBundle,1) 
	ORDER BY 10, 1, 6, 5, 8
else
	SELECT C.strClient_nm + ' (' + rtrim(SD.strSurvey_nm) + ' - ' + CONVERT(VARCHAR,MM.Survey_id) + ')' AS strProjName, 
	PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, NP.strPostalBundle, left(NP.strPostalBundle,1) AS TrayType, 
	NP.strPostalBundle AS TrayLvl, ' ' + NP.strGroupDest AS strGroupDest, COUNT(*) AS Pieces, 1 as intOrder
	FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, Survey_def SD, Study S, Client C 
	WHERE NP.Methodology_id = MM.Methodology_id 
	AND NP.PaperConfig_id = PC.PaperConfig_id 
	AND MM.Survey_id = SD.Survey_id 
	AND SD.Study_id = S.Study_id 
	AND S.Client_id = C.Client_id 
	AND SD.Survey_id = @Survey_id
	AND NP.PaperConfig_id = @PaperConfig
	AND ABS(datediff(second,NP.datBundled,@datBundled)) <= 1 
	AND NP.datMailed = @datMailed
	GROUP BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, 
	NP.strPostalBundle, NP.strGroupDest 
	ORDER BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, 
	NP.strPostalBundle, NP.strGroupDest


