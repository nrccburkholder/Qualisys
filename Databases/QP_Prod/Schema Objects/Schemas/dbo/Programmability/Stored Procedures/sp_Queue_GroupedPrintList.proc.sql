CREATE PROCEDURE dbo.sp_Queue_GroupedPrintList
@QueueType CHAR(1)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

IF @QueueType='P'
BEGIN
   SELECT gp.Survey_id, gp.PaperConfig_id, CONVERT(VARCHAR,gp.datBundled,120) datBundled, 
   strClient_nm, strSurvey_nm, pc.strPaperConfig_nm, LEFT(SurveyType_dsc,15) SurveyType, 
   COUNT(*) numPieces, MIN(sm.datMailed) datMailed
   FROM dbo.GroupedPrint gp, Survey_def sd, Study s, Client c, PaperConfig pc, NPSentMailing sm, 
   MailingMethodology mm, SurveyType st
   WHERE gp.Survey_id=sd.Survey_id
   AND sd.Study_id=s.Study_id
   AND s.Client_id=c.Client_id
   AND gp.PaperConfig_id=pc.PaperConfig_id
   AND sm.datBundled<'4000'
   AND ABS(DATEDIFF(SECOND,gp.datBundled,sm.datBundled))<=1
   AND gp.PaperConfig_id=sm.PaperConfig_id
   AND gp.Survey_id=mm.Survey_id
   AND mm.Methodology_id=sm.Methodology_id
   AND gp.datPrinted IS NULL
   AND sd.SurveyType_id=st.SurveyType_id
   GROUP BY gp.Survey_id, gp.PaperConfig_id, gp.datBundled, strClient_nm, strSurvey_nm, 
            pc.strPaperConfig_nm, LEFT(SurveyType_dsc,15)
   ORDER BY strClient_nm, strSurvey_nm, strPaperConfig_nm
END
ELSE
BEGIN
   SELECT gp.Survey_id, gp.PaperConfig_id, CONVERT(VARCHAR,gp.datPrinted,120) datPrinted, 
   strClient_nm, strSurvey_nm, pc.strPaperConfig_nm, LEFT(SurveyType_dsc,15) SurveyType, 
   COUNT(*) numPieces, MIN(sm.datMailed) datMailed
   FROM dbo.GroupedPrint gp, Survey_def sd, Study s, Client c, PaperConfig pc, NPSentMailing sm, 
   MailingMethodology mm, QualPro_params qp, SurveyType st
   WHERE gp.Survey_id=sd.Survey_id
   AND sd.Study_id=s.Study_id
   AND s.Client_id=c.Client_id
   AND gp.PaperConfig_id=pc.PaperConfig_id
   AND sm.datbundled<'4000'
   AND ABS(DATEDIFF(SECOND,gp.datBundled,sm.datBundled))<=1
   AND gp.PaperConfig_id=sm.PaperConfig_id
   AND gp.Survey_id=mm.Survey_id
   AND mm.Methodology_id=sm.Methodology_id
   AND ISNULL(gp.datPrinted,'4000')<>'4000'
   AND QP.strParam_nm='MailedDaysInQ'
   AND (sm.datMailed='4000' OR DATEDIFF(DAY,SM.datMailed,GETDATE())<=QP.numParam_Value)
   AND sd.SurveyType_id=st.SurveyType_id
   GROUP BY gp.Survey_id, gp.PaperConfig_id, gp.datPrinted, strClient_nm, strSurvey_nm, 
            pc.strPaperConfig_nm, LEFT(SurveyType_dsc,15)
   ORDER BY datPrinted, strPaperConfig_nm, LEFT(SurveyType_dsc,15), strClient_nm, strSurvey_nm
END


