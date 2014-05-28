-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets a count of the other steps that may
--              have been returned
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetQtyOtherStepsReturned] 
    @QuestionFormID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT Count(QF2.datReturned) AS QtyRec 
FROM QuestionForm QF, QuestionForm QF2 
WHERE QF.QuestionForm_id = @QuestionFormID
  AND QF2.QuestionForm_id <> QF.QuestionForm_id 
  AND QF2.SamplePop_id = QF.SamplePop_id 
  AND QF2.datReturned IS NOT NULL 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


