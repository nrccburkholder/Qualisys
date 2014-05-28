-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the specified surveys.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetSpecificLithoCodes] 
    @LithoInList varchar(6240)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @Sql varchar(8000)

--Build the select statement
SET @Sql = 'SELECT strLithoCode, strClient_Nm, strSurvey_Nm, datUndeliverable, ' +
           '       datReturned, UnusedReturn_id, datUnusedReturn, datResultsImported, ' +
           '       strSTRBatchNumber, intSTRLineNumber, strScanBatch, SentMail_id, ' +
           '       QuestionForm_id, Convert(varchar, Survey_id) + strTemplateCode + ' +
           '       Right(''00'' + Convert(varchar, LangID), 2) AS Survey_id ' +
           'FROM (SELECT sm.strLithoCode, cl.strClient_nm, sd.strSurvey_nm, ' +
           '             sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id, ' +
           '             qf.datUnusedReturn, qf.datResultsImported, qf.strSTRBatchNumber, ' +
           '             qf.intSTRLineNumber, qf.strScanBatch, sm.SentMail_id, ' +
           '             qf.QuestionForm_id, qf.Survey_id, sm.PaperConfig_id, sm.LangID, ' +
           '             Max(pcs.intSheet_Num) AS intSheet_Num ' +
           '      FROM SentMailing sm (NOLOCK), Survey_def sd (NOLOCK), Study st (NOLOCK), ' +
           '           Client cl (NOLOCK), QuestionForm qf (NOLOCK), ' +
           '           PaperConfigSheet pcs (NOLOCK) ' +
           '      WHERE sm.SentMail_id = qf.SentMail_id ' +
           '        AND qf.Survey_id = sd.Survey_id ' +
           '        AND sd.Study_id = st.Study_id ' +
           '        AND st.Client_id = cl.Client_id ' +
           '        AND SM.strLithoCode IN (' + @LithoInList + ') ' +
           '        AND sm.PaperConfig_id = pcs.PaperConfig_id ' +
           '      GROUP BY sm.strLithoCode, cl.strClient_nm, sd.strSurvey_nm, ' +
           '               sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id, ' +
           '               qf.datUnusedReturn, qf.datResultsImported, qf.strSTRBatchNumber, ' +
           '               qf.intSTRLineNumber, qf.strScanBatch, sm.SentMail_id, ' +
           '               qf.QuestionForm_id, qf.Survey_id, sm.PaperConfig_id, sm.LangID ' +
           '     ) qry, PaperConfigSheet pcs (NOLOCK), PaperSize ps (NOLOCK) ' +
           'WHERE qry.PaperConfig_id = pcs.PaperConfig_id ' +
           '  AND qry.intSheet_num = pcs.intSheet_Num ' +
           '  AND pcs.PaperSize_id = ps.PaperSize_id ' +
           'ORDER BY strLithoCode '
--PRINT @Sql
EXEC (@Sql)

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


