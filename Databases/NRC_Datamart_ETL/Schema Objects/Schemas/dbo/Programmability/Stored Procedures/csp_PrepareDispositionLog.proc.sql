CREATE PROCEDURE [dbo].[csp_PrepareDispositionLog]
	@ExtractFileID int,
	@MaxExtractQueueID int,
	@ExcludeFlag int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 14 -- DispositionLog	
	
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

		
	end
	else -- No filter, mark all records for extraction
		update ExtractQueue
		   set ExtractFileID = @ExtractFileID
		 where ExtractQueueID <= @MaxExtractQueueID
		   and ExtractFileID is null
		   and EntityTypeID = @EntityTypeID
	
	RETURN


