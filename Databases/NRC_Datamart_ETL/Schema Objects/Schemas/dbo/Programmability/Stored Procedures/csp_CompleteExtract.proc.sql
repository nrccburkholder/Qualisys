-- =============================================
-- Author:		Kathleen Nussrallah
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[csp_CompleteExtract]
	@ExtractFileID int,
    @RetainExtractQueueData bit

AS
BEGIN
	SET NOCOUNT ON
    
     declare @ErrorMessage NVarChar(100) 
     declare @IsEventRun bit  

     set @IsEventRun = (select IncludeEventData from dbo.ExtractFile where ExtractFileID = @ExtractFileID )
    
	 if (select count(*)
         from dbo.ExtractHistoryError with (NOLOCK)
         where ExtractFileID = @ExtractFileID) 
        + (select count(*)
           from dbo.BackgroundTempError with (NOLOCK)
           where ExtractFileID = @ExtractFileID)
        +  (select count(*)
            from dbo.CommentTextTempError with (NOLOCK)
            where ExtractFileID = @ExtractFileID) > 0  
	 begin
		if @IsEventRun = 0 set @ErrorMessage = 'META ERRORS!!  Check ExtractHistoryError table'
        else set @ErrorMessage = 'EVENT ERRORS!!  Run event error script - csp_ListEventErrors'
	 end
	 else set @ErrorMessage = ''
    
	update ExtractFile
	   set ErrorMessage = @ErrorMessage,
       EndTime = getdate()
	 where ExtractFileID = @ExtractFileID

	if @RetainExtractQueueData = 0
	  begin
	     
		delete from ExtractQueue
		where ExtractFileID = @ExtractFileID

        DBCC DBREINDEX(ExtractQueue,' ',90) 

	  end
 
END
 


/*

 exec csp_CompleteExtract 5

select *
from ExtractFile
*/


