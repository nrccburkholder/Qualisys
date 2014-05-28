-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the responses for the specified 
--              survey
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetResponses] 
    @QuestionFormID int, 
	@PageNo int, 
    @SampleUnitID int, 
    @QstnCore int
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT QuestionForm_Id, intPage_Num, SampleUnit_id, 
       QstnCore, x_pos, y_pos, Val, Item 
FROM si_BubbleItem_view 
WHERE QuestionForm_Id = @QuestionFormID 
  AND intPage_num = @PageNo 
  AND sampleunit_id = @SampleUnitID 
  AND qstncore = @QstnCore 
ORDER BY intBegColumn, Item

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


