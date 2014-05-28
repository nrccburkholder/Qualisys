-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the additional information required 
--              to process a non-deliverable survey
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetAddInfoNDL] 
    @LithoInList varchar(7000)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @Sql varchar(8000)

--Build the select statement
SET @Sql = 'SELECT sm.strLithoCode, sm.SentMail_id, qf.QuestionForm_id, qf.datReturned ' +
           'FROM SentMailing sm LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id ' +
           'WHERE sm.strLithoCode IN (' + @LithoInList + ')'
--PRINT @Sql
EXEC (@Sql)

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


