CREATE PROCEDURE [dbo].[csp_PrepareSampleUnits]
	@ExtractFileID int,
	@MaxExtractQueueID int
	--,	@StudyList as nvarchar(4000) = NULL
AS
	SET NOCOUNT ON  
	
	declare @EntityTypeID int
	set @EntityTypeID = 6 -- SampleUnit
		
	--if ISNULL(@StudyList, '') <> ''
	--	begin
	--		create table #ttt (id int)
	
	--		insert #ttt
	--			exec ('select distinct SURVEY_ID 
	--					 from QP_PROD.dbo.SURVEY_DEF with (NOLOCK)
	--				    where STUDY_ID in (' + @StudyList + ')')			   
			
	--		update ExtractQueue
	--		   set ExtractFileID = @ExtractFileID
	--		  from ExtractQueue eq with (NOLOCK)
	--				inner join QP_Prod.dbo.SAMPLEUNIT su with (NOLOCK) on eq.PKey1 = su.SAMPLEUNIT_ID
	--				inner join QP_Prod.dbo.SAMPLEPLAN sp with (NOLOCK) on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID	  			  
	--				inner join #ttt with (NOLOCK) on #ttt.id = sp.SURVEY_ID
	--		 where eq.ExtractQueueID <= @MaxExtractQueueID
	--		   and eq.ExtractFileID is null
	--		   and eq.EntityTypeID = @EntityTypeID
	
	--		drop table #ttt
	--	end
	--else 
	-- No filter, mark all records for extraction
		update ExtractQueue
		   set ExtractFileID = @ExtractFileID
		 where ExtractQueueID <= @MaxExtractQueueID
		   and ExtractFileID is null
		   and EntityTypeID = @EntityTypeID
	
	RETURN


