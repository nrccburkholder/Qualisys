CREATE PROCEDURE [dbo].[csp_GetBubbleData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 	
 	
--	declare @ExtractFileID int
--	set @ExtractFileID= 20 -- test only

    select ExtractFileID,LithoCode,nrcQuestionCore,responseVal,QUESTIONFORM_ID--*
     from dbo.BubbleTemp with (NOLOCK)     
     WHERE ExtractFileID = @ExtractFileID               
     

--exec csp_GetBackgroundData 20


