-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the questions for the specified 
--              survey
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetQuestions] 
    @QuestionFormID int, 
	@QuestionType int
AS

--added by MH 8/28/2009 in an attempt to find the cause of missing lithos
insert into qp_prod.dbo.MH_PCLLOG (QuestionFormID, QuestionType, DT) values (@QuestionFormID, @QuestionType, GetDate())

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
IF (@QuestionType = 0)
BEGIN
	--Return all questions
    SELECT QuestionForm_Id, intPage_Num, QstnCore, ReadMethod_Id, 
           intBegColumn, intRespCol, sampleUnit_id, NumberOfBubbles 
    FROM si_Bubble_View 
    WHERE QuestionForm_Id = @QuestionFormID 
    ORDER BY QuestionForm_Id, intPage_Num, intBegColumn
END
ELSE IF (@QuestionType = 1)
BEGIN
	--Return multiple response questions only
    SELECT QuestionForm_Id, intPage_Num, QstnCore, ReadMethod_Id, 
           intBegColumn, intRespCol, sampleUnit_id, NumberOfBubbles 
    FROM si_Bubble_View 
    WHERE QuestionForm_Id = @QuestionFormID 
	  AND ReadMethod_id = 1 
    ORDER BY QuestionForm_Id, intPage_Num, intBegColumn
END
ELSE
BEGIN
	--Return single response questions only
    SELECT QuestionForm_Id, intPage_Num, QstnCore, ReadMethod_Id, 
           intBegColumn, intRespCol, sampleUnit_id, NumberOfBubbles 
    FROM si_Bubble_View 
    WHERE QuestionForm_Id = @QuestionFormID 
	  AND ReadMethod_id <> 1 
    ORDER BY QuestionForm_Id, intPage_Num, intBegColumn
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


