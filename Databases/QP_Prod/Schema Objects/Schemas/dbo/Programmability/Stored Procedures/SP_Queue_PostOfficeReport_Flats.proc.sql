CREATE PROCEDURE SP_Queue_PostOfficeReport_Flats @datBundled DATETIME, @datMailed DATETIME, @Survey_id INT, @PaperConfig INT  
AS  
  
DECLARE @strsql VARCHAR(7000)  
  
SET @strsql = 'SELECT C.strClient_nm + '' ('' + rtrim(SD.strSurvey_nm) + '' - '' + CONVERT(VARCHAR,MM.Survey_id) + '')'' AS strProjName, ' + CHAR(10) +  
 ' PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, NP.strPostalBundle, left(NP.strPostalBundle,1) AS TrayType, ' + CHAR(10) +  
 ' NP.strPostalBundle AS TrayLvl, NP.strGroupDest AS strGroupDest, COUNT(*) AS Pieces, 1 as intOrder ' + CHAR(10) +  
 ' FROM NPSentMailing NP, MailingMethodology MM, PaperConfig PC, Survey_def SD, Study S, Client C ' + CHAR(10) +  
 ' WHERE NP.Methodology_id = MM.Methodology_id ' + CHAR(10) +  
 ' AND NP.PaperConfig_id = PC.PaperConfig_id ' + CHAR(10) +  
 ' AND MM.Survey_id = SD.Survey_id ' + CHAR(10) +  
 ' AND SD.Study_id = S.Study_id ' + CHAR(10) +  
 ' AND S.Client_id = C.Client_id ' + CHAR(10) +  
 ' AND SD.Survey_id = ' + CONVERT(VARCHAR,@Survey_id) + CHAR(10) +  
 ' AND NP.PaperConfig_id = ' + CONVERT(VARCHAR,@PaperConfig) + CHAR(10) +  
 ' AND ABS(datediff(second,NP.datBundled,''' + CONVERT(VARCHAR,@datBundled,120) + ''')) <= 1 ' + CHAR(10) +  
 ' AND NP.datMailed = ''' + CONVERT(VARCHAR,@datMailed,120) + '''' + CHAR(10) +  
 ' GROUP BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, ' + CHAR(10) +  
 ' NP.strPostalBundle, NP.strGroupDest ' + CHAR(10) +  
 ' ORDER BY C.strClient_nm, SD.strSurvey_nm, MM.Survey_id, PC.strPaperConfig_nm, NP.datBundled, NP.datMailed, ' + CHAR(10) +  
 ' NP.strPostalBundle, NP.strGroupDest '  
  
EXEC (@strsql)


