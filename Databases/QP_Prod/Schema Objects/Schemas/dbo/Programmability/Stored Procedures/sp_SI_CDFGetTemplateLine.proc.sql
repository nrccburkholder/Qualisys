-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the template line
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetTemplateLine] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT TOP 1 qf.Survey_id, ps.strTemplateCode, sd.strSurvey_nm, 
             cl.strClient_nm, sm.LangID 
FROM SentMailing sm, QuestionForm qf, PaperConfigSheet pcs, 
     PaperSize ps, Survey_def sd, Study st, Client cl 
WHERE sm.SentMail_id = qf.SentMail_id 
  AND sm.PaperConfig_id = pcs.PaperConfig_id 
  AND pcs.PaperSize_id = ps.PaperSize_id 
  AND qf.Survey_id = sd.Survey_id 
  AND sd.Study_id = st.Study_id 
  AND st.Client_id = cl.Client_id 
  AND sm.SentMail_id = @SentMailID
ORDER BY pcs.intSheet_num DESC 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


