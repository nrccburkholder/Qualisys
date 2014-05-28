CREATE PROCEDURE [dbo].[csp_PrepareBubbleDataForExtract]
	@ExtractFileID int 
AS
	SET NOCOUNT ON 

--	declare @ExtractFileID int 
--    set @ExtractFileID = 5

	delete BubbleTemp where ExtractFileID = @ExtractFileID
	
	---------------------------------------------------------------------------------------
	-- Load the Bubble Data
	---------------------------------------------------------------------------------------	
	insert BubbleTemp (ExtractFileID, LithoCode, sampleunit_id, nrcQuestionCore, responseVal,QUESTIONFORM_ID)
		select @ExtractFileID, QuestionFormTemp.strLithoCode, qr.sampleunit_id, qr.QSTNCORE, qr.INTRESPONSEVAL ,QuestionFormTemp.QUESTIONFORM_ID      
		  from QuestionFormTemp with(NOLOCK)
			inner join QP_Prod.dbo.QUESTIONRESULT qr  with(nolock, index(IDX_QRESLT_QFORMSAMPLEUNIT))
				on qr.questionform_id = QuestionFormTemp.questionform_id
	     where ExtractFileID = @ExtractFileID


