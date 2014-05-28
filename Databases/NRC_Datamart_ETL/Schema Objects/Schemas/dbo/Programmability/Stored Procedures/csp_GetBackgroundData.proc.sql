CREATE PROCEDURE [dbo].[csp_GetBackgroundData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 	
 	
--	declare @ExtractFileID int
--	set @ExtractFileID= 20 -- test only

    select BackgroundTemp.*
     from BackgroundTemp with (NOLOCK)
      left join BackgroundTempError with (NOLOCK) 
       on BackgroundTemp.ExtractFileID = BackgroundTempError.ExtractFileID 
          and BackgroundTemp.samplepop_id = BackgroundTempError.samplepop_id
          --and BackgroundTemp.sampleunit_id = BackgroundTempError.sampleunit_id 
          and BackgroundTemp.name = BackgroundTempError.name                    
      where BackgroundTemp.ExtractFileID = @ExtractFileID
       and BackgroundTempError.samplepop_id is null

--exec csp_GetBackgroundData 20


