CREATE PROCEDURE [dbo].[csp_PrepareCommentExtractData]
	@ExtractFileID int 
AS
	SET NOCOUNT ON 

--	declare @ExtractFileID int 
--    set @ExtractFileID = 5	

	delete CommentTemp where ExtractFileID = @ExtractFileID
	delete CommentCodeTemp where ExtractFileID = @ExtractFileID
    delete CommentTextTemp where ExtractFileID = @ExtractFileID
	
	---------------------------------------------------------------------------------------
	-- Collect all comments for the selected Sample Pop records
	--   - IsSuppressedOnWeb defaults to FALSE when left NULL as it is here.
	--     QP_Prod does not contain that flag.
	---------------------------------------------------------------------------------------
	insert CommentTemp 
		(ExtractFileID, LithoCode, sampleunit_id, Cmnt_id, nrcQuestionCore, commentType, commentValence,datEntered)
		select distinct @ExtractFileID, QuestionFormTemp.strLithoCode, c.sampleunit_id, c.Cmnt_id, c.QstnCore, 
			   case
				when CmntType_id = 2 then 'Contact Requested'
				when CmntType_id = 3 then 'Service Alert'
				else 'General'
			   end, 
			   case
				when CmntValence_id = 1 then 'Positive'
				when CmntValence_id = 2 then 'Negative'
				when CmntValence_id = 3 then 'Both'
				else 'Neutral'
			   end	
           ,c.datEntered		      
		  from QuestionFormTemp With (NOLOCK)
			inner join QP_Prod.dbo.COMMENTS c With (NOLOCK)
				on c.questionform_id = QuestionFormTemp.questionform_id
	     where ExtractFileID = @ExtractFileID

	---------------------------------------------------------------------------------------
	-- get comment codes	
	---------------------------------------------------------------------------------------
	insert CommentCodeTemp (ExtractFileID, LithoCode, Cmnt_id, code)
		select distinct @ExtractFileID, ct.LithoCode, ct.Cmnt_id, csc.CmntCode_id
           from CommentTemp ct With (NOLOCK)
			inner join QP_Prod.dbo.CommentSelCodes csc With (NOLOCK)
				on ct.cmnt_id = csc.cmnt_id
	     where ExtractFileID = @ExtractFileID


