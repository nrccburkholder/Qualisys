-- ================================================================================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_PrepareClientGroups
-- Create date: 3/22/2011 
-- Description:	Extracts study data from Extract Queue
-- History: 1.0  3/22/2011   
-- =================================================================================================
CREATE PROCEDURE [dbo].[csp_PrepareClientGroups]
	@ExtractFileID int,
	@MaxExtractQueueID int
	--,@StudyList as nvarchar(4000) = NULL
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 16 -- Client Group
		
   update ExtractQueue
   set ExtractFileID = @ExtractFileID
   where ExtractQueueID <= @MaxExtractQueueID
   and ExtractFileID is null
   and EntityTypeID = @EntityTypeID
	
	RETURN


