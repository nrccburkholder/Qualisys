-- =============================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_PrepareQuestionForm
-- Create date: 3/01/2009 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 4/1/2011 modifed logic to handle deletes
-- =============================================
CREATE PROCEDURE [dbo].[csp_PrepareQuestionForm]
	@ExtractFileID int,
	@MaxExtractQueueID int,
	@ExcludeFlag int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 11 -- QuestionForm

	if @ExcludeFlag = 1
	begin
		
		 update ExtractQueue
			set ExtractFileID = @ExtractFileID
		--select *
		 from dbo.tempsurvey survey with (NOLOCK)
			 inner join QP_Prod.dbo.QUESTIONFORM qf with (NOLOCK) on survey.Survey_id = qf.Survey_id
			 inner join ExtractQueue eq with (NOLOCK) on eq.PKey1 = qf.QUESTIONFORM_ID
		 where eq.ExtractQueueID <= @MaxExtractQueueID
			 and eq.ExtractFileID is null
    		 and eq.EntityTypeID = @EntityTypeID
    		  --and eq.IsDeleted = 0 	    		 
    		 
    	 --so we don't miss any deletes associated with a deleted survey	 
		-- update ExtractQueue
		--	set ExtractFileID = @ExtractFileID
		----select *
		-- from ExtractQueue eq with (NOLOCK) 
		-- where eq.ExtractQueueID <= @MaxExtractQueueID
		--	 and eq.ExtractFileID is null
		--	 and eq.EntityTypeID = @EntityTypeID	
		--	 and eq.IsDeleted = 1 		
	end 
	else -- No filter, mark all records for extraction
	begin
		update ExtractQueue
		set ExtractFileID = @ExtractFileID
		 where ExtractQueueID <= @MaxExtractQueueID
		 and ExtractFileID is null
		 and EntityTypeID = @EntityTypeID
	end 				
	-- Do not copy any question forms that have not been returned yet
    --updated code on 12/9 - the questionform trigger excludes rows where datReturned is null - trg_NRC_DataMart_ETL_dbo_QUESTIONFORM
--	update ExtractQueue
--	   set ExtractFileID = NULL
--	  from ExtractQueue eq with (NOLOCK)
--			inner join QP_Prod.dbo.QUESTIONFORM qf with (NOLOCK) on qf.QUESTIONFORM_ID = eq.PKey1
--	 where eq.ExtractFileID = @ExtractFileID
--	   and eq.EntityTypeID = @EntityTypeID
--	   and qf.datReturned is null
--	
	RETURN


