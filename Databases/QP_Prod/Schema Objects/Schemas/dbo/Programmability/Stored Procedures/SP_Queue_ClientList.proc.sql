-- Created 9/10/2 BD This procedure is used to generate the initial client tree view.  
CREATE PROCEDURE [dbo].[SP_Queue_ClientList]   
@PCLOutput VARCHAR(200), @QueueType CHAR(1)  
AS  
  
DECLARE @r INT  
EXEC @r=sp_Queue_CheckPCLOutputLocation 'SP_Queue_ClientList', @PCLOutput  
IF @r=-1   
BEGIN  
 SELECT '' AS strclient_nm, '' AS strSurvey_nm, '' AS Survey_id, 0 AS numPieces, 0 AS numPrinted, 0 AS numMailed, 0 AS numInGroupedPrint  
 RETURN  
END  
  
CREATE TABLE #Bundle0a (
Survey_id INT, 
PaperConfig_id INT, 
datBundled DATETIME, 
numPieces INT, 
numPrinted INT, 
numMailed INT, 
numInGroupedPrint INT)  

INSERT INTO #Bundle0a (Survey_id, PaperConfig_id, datBundled, numPieces, 
                       numPrinted, numMailed, numInGroupedPrint)  
SELECT np.Survey_id, np.PaperConfig_id, np.datBundled, COUNT(*) AS numPieces,   
 SUM(CASE WHEN np.datPrinted='4000' THEN 0 ELSE 1 END) AS numPrinted,  
 SUM(CASE WHEN np.datMailed='4000' THEN 0 ELSE 1 END) AS numMailed,  
 SUM(CASE WHEN gp.Survey_id IS NULL THEN 0 ELSE 1 END) AS numInGroupedPrint  
FROM qp_queue..PCLOutput po, QualPro_Params QP,   
  (SELECT np.Sentmail_id, mm.Survey_id, np.methodology_id, np.PaperConfig_id, np.datBundled, np.datPrinted, np.datMailed  
  FROM MailingMethodology MM, NPSentMailing NP  
  WHERE mm.methodology_id=np.methodology_id) NP LEFT OUTER JOIN GroupedPrint GP   
  ON NP.Survey_id=gp.Survey_id   
  AND np.PaperConfig_id=gp.PaperConfig_id   
  AND ABS(DATEDIFF(SECOND,np.datBundled,gp.datBundled))<=1  
  AND (  (np.datprinted='4000' AND gp.datprinted IS NULL)  
       OR (np.datprinted<'4000' AND ABS(DATEDIFF(SECOND,np.datprinted,ISNULL(gp.datprinted,'4000')))<=1)  
      )  
WHERE po.intSheet_num=1  
AND po.sentmail_id=np.sentmail_id  
AND QP.strParam_nm = 'MailedDaysInQ'  
AND (NP.datMailed = '1/1/4000' or DATEDIFF(DAY,NP.datMailed,GETDATE()) <= QP.numParam_Value)   
GROUP BY np.Survey_id, np.PaperConfig_id, np.datBundled  
  
IF @QueueType='P'  
--  DELETE FROM #Bundle0a WHERE numPrinted>0  
 DELETE FROM #Bundle0a WHERE numPrinted=numPieces
ELSE IF @QueueType='M'  
 DELETE FROM #Bundle0a WHERE numPrinted=0 OR numInGroupedPrint>0  
ELSE  
 RETURN  
  
SELECT strclient_nm, strSurvey_nm, SD.Survey_id, SurveyType_dsc, 
       SUM(numPieces) AS numPieces, SUM(numPrinted) AS numPrinted, 
       SUM(numMailed) AS numMailed, SUM(numInGroupedPrint) AS numInGroupedPrint  
FROM Survey_Def SD, Study S, Client C, #Bundle0a b0a, SurveyType st  
WHERE b0a.Survey_id = SD.Survey_id  
AND SD.Study_id = S.Study_id  
AND S.Client_id = C.Client_id 
AND sd.SurveyType_id=st.SurveyType_id 
GROUP BY strclient_nm, strSurvey_nm, SD.Survey_id, SurveyType_dsc
ORDER BY strClient_nm, SD.Survey_id, left(strSurvey_nm,4)
  
DROP TABLE #Bundle0a


