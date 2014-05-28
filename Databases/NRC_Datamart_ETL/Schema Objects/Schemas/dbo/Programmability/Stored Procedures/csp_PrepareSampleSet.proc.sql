-- =============================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_PrepareSampleSet
-- Create date: 3/01/2009 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 4/1/2011 modifed logic to handle deletes
-- =============================================
CREATE PROCEDURE [dbo].[csp_PrepareSampleSet]
	@ExtractFileID int,
	@MaxExtractQueueID int,
	@ExcludeFlag int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 8 -- SampleSet	
	
	if @ExcludeFlag = 1
	begin	
--        print @MaxExtractQueueID

        update ExtractQueue
			set ExtractFileID = @ExtractFileID
		--select *
		 from dbo.tempsurvey survey with (NOLOCK)
			  inner join ExtractQueue eq with (NOLOCK) on eq.PKey2 = survey.survey_id
		 where eq.ExtractQueueID <= @MaxExtractQueueID
			 and eq.ExtractFileID is null
			 and eq.EntityTypeID = @EntityTypeID	
			 --and eq.IsDeleted = 0
			 
		-- --so we don't miss any deletes associated with a deleted survey	 
		-- update ExtractQueue
		--	set ExtractFileID = @ExtractFileID
		----select *
		-- from ExtractQueue eq with (NOLOCK) 
		-- inner join dbo.tempsurvey survey with (NOLOCK) on eq.PKey2 = survey.survey_id
		-- where eq.ExtractQueueID <= @MaxExtractQueueID
		--	 and eq.ExtractFileID is null
		--	 and eq.EntityTypeID = @EntityTypeID	
		--	 and eq.IsDeleted = 1 

		/*
			  'update ExtractQueue
				  set ExtractFileID = ' + convert(varchar,@ExtractFileID) + '
				 from QP_PROD.dbo.SURVEY_DEF sd
				   inner join QP_Prod.dbo.SAMPLESET ss on sd.Survey_id = ss.Survey_id
				   inner join QP_Prod.dbo.SAMPLEPOP sp on ss.sampleset_id = sp.sampleset_id
				   inner join ExtractQueue eq on eq.PKey1 = sp.samplepop_id
			    where sd.STUDY_ID in (' + @StudyList + ')
			      and eq.ExtractQueueID <= ' + convert(varchar,@MaxExtractQueueID) + '
				  and eq.ExtractFileID is null
				  and eq.EntityTypeID = ' + convert(varchar,@EntityTypeID)
		*/
	end
	else -- No filter, mark all records for extraction
		update ExtractQueue
		   set ExtractFileID = @ExtractFileID
--		 select *         
		 from ExtractQueue
		 where ExtractQueueID <= @MaxExtractQueueID
		   and ExtractFileID is null
		   and EntityTypeID = @EntityTypeID
       
	
	RETURN


