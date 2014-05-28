-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets a count of the surveys that have 
--              been marked returned but have not been transferred.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetCount] 

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT Count(*) AS QtyRec 
FROM QuestionForm 
WHERE datReturned > '1/1/1900' 
  AND datResultsImported IS NULL 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


