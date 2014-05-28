CREATE PROCEDURE [dbo].[csp_GetBackgroundData] 
	@ExtractFileID int
AS
BEGIN

	SET NOCOUNT ON 	
 	
--	declare @ExtractFileID int
--	set @ExtractFileID= 20 -- test only
	declare @rbCount int
	set @rbCount = 0


	Select @rbCount = COUNT(*)   
	from BackgroundTemp with (NOLOCK)
      left join BackgroundTempError with (NOLOCK) 
       on BackgroundTemp.ExtractFileID = BackgroundTempError.ExtractFileID 
          and BackgroundTemp.samplepop_id = BackgroundTempError.samplepop_id
          --and BackgroundTemp.sampleunit_id = BackgroundTempError.sampleunit_id 
          and BackgroundTemp.name = BackgroundTempError.name                    
      where BackgroundTemp.ExtractFileID = @ExtractFileID
       and BackgroundTempError.samplepop_id is null

	If @rbCount > 0
	Begin
	 select BackgroundTemp.*
     from BackgroundTemp with (NOLOCK)
      left join BackgroundTempError with (NOLOCK) 
       on BackgroundTemp.ExtractFileID = BackgroundTempError.ExtractFileID 
          and BackgroundTemp.samplepop_id = BackgroundTempError.samplepop_id
          --and BackgroundTemp.sampleunit_id = BackgroundTempError.sampleunit_id 
          and BackgroundTemp.name = BackgroundTempError.name                    
      where BackgroundTemp.ExtractFileID = @ExtractFileID
       and BackgroundTempError.samplepop_id is null    
	End
	Else
	Begin
		select @ExtractFileID as ExtractFileID,0 as SAMPLEPOP_ID,0 as name,0 as value,0 as sourcetable
	End

END
--exec csp_GetBackgroundData 20

