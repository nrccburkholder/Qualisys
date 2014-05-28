CREATE PROCEDURE [dbo].[csp_GetBubbleData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 	

	 --	declare @ExtractFileID int
	--	set @ExtractFileID= 20 -- test only

    declare @rbCount int
	set @rbCount = 0

	Select @rbCount = COUNT(*) from dbo.BubbleTemp  WHERE ExtractFileID = @ExtractFileID 

	If @rbCount > 0
	Begin
	    select ExtractFileID,LithoCode,nrcQuestionCore,responseVal,QUESTIONFORM_ID--*
		from dbo.BubbleTemp with (NOLOCK)     
		WHERE ExtractFileID = @ExtractFileID       
	End
	Else
	Begin
		select @ExtractFileID,0,0,0,0
	End
        

--exec csp_GetBackgroundData 20
GO