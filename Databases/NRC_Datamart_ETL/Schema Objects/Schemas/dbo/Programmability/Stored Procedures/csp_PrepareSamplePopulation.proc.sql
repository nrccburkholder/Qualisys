-- =============================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_PrepareSamplePopulation
-- Create date: 3/01/2009 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 4/1/2011 modifed logic to handle deletes
-- =============================================
CREATE PROCEDURE [dbo].[csp_PrepareSamplePopulation]
	@ExtractFileID int,
	@MaxExtractQueueID int,
	@ExcludeFlag int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 7 -- SamplePopulation		
	
	if @ExcludeFlag = 1
	begin	
--        print @MaxExtractQueueID

        update ExtractQueue
			set ExtractFileID = @ExtractFileID
		--select *
		 from dbo.tempsurvey survey with (NOLOCK)
			  inner join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on survey.Survey_id = ss.Survey_id
			   inner join QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on ss.sampleset_id = sp.sampleset_id
			   inner join ExtractQueue eq with (NOLOCK) on eq.PKey1 = sp.samplepop_id
		 where eq.ExtractQueueID <= @MaxExtractQueueID
			 and eq.ExtractFileID is null
			 and eq.EntityTypeID = @EntityTypeID
			 --and eq.IsDeleted = 0			 
			 
	     --so we don't miss any deletes associated with a deleted survey/sample set/sample pop	 
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
		update ExtractQueue
		   set ExtractFileID = @ExtractFileID
		 where ExtractQueueID <= @MaxExtractQueueID
		   and ExtractFileID is null
		   and EntityTypeID = @EntityTypeID
	
	RETURN


