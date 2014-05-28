﻿CREATE PROCEDURE [dbo].[csp_PrepareMetaField]
	@ExtractFileID int,
	@MaxExtractQueueID int
	--,@StudyList as nvarchar(4000) = NULL
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 19 -- MetaField
	
	
	-- No filter, mark all records for extraction
		update ExtractQueue
		   set ExtractFileID = @ExtractFileID
		 where ExtractQueueID <= @MaxExtractQueueID
		   and ExtractFileID is null
		   and EntityTypeID = @EntityTypeID
	
	RETURN


