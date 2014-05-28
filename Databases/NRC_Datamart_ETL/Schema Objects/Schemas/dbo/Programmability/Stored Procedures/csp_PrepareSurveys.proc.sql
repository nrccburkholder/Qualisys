CREATE PROCEDURE [dbo].[csp_PrepareSurveys]
	@ExtractFileID int,
	@MaxExtractQueueID int
	--,	@StudyList as nvarchar(4000) = NULL
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 3 -- Survey
		
	--if ISNULL(@StudyList, '') <> ''
	--	begin
	--		create table #ttt (id int)
	
	--		insert #ttt
	--			exec ('select distinct SURVEY_ID 
	--					 from QP_PROD.dbo.SURVEY_DEF with (NOLOCK)
	--				    where STUDY_ID in (' + @StudyList + ')')			   
			
	--		update ExtractQueue
	--		   set ExtractFileID = @ExtractFileID
	--		  from ExtractQueue with (NOLOCK)
	--				inner join #ttt with (NOLOCK) on #ttt.id = ExtractQueue.PKey1
	--		 where ExtractQueueID <= @MaxExtractQueueID
	--		   and ExtractFileID is null
	--		   and EntityTypeID = @EntityTypeID
	
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


