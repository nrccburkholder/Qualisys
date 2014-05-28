CREATE PROCEDURE [dbo].[csp_PrepareStudies]
	@ExtractFileID int,
	@MaxExtractQueueID int
	--,@StudyList as nvarchar(4000) = NULL
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 15 -- Study Entity
		
   update ExtractQueue
   set ExtractFileID = @ExtractFileID
   where ExtractQueueID <= @MaxExtractQueueID
   and ExtractFileID is null
   and EntityTypeID = @EntityTypeID
	
	RETURN


