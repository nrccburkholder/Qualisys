CREATE PROCEDURE [dbo].[csp_GetDispositionLogExtractData2] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	---------------------------------------------------------------------------------------
	-- Formmats data for XML export
	---------------------------------------------------------------------------------------
   
	--declare @ExtractFileID int
	--set @ExtractFileID= 2 -- test only        

  	select distinct 1 as Tag, NULL as Parent,  	  		             
           samplePop_id as [dispositionLog!1!samplePop_id]
           ,disposition_id as [dispositionLog!1!disposition_id]
           ,receiptType_id as [dispositionLog!1!receiptType_id]
           ,datLogged as  [dispositionLog!1!datLogged]
           ,loggedBy as [dispositionLog!1!loggedBy]     
           ,daysFromCurrent as [dispositionLog!1!daysFromCurrent]    
           ,daysFromFirst as [dispositionLog!1!daysFromFirst]          
--	  select *	   
	  from DispositionLogTemp dispositionLog with (NOLOCK) 
      where ExtractFileID = @ExtractFileID 
      order by datLogged,samplePop_id,disposition_id
      for xml explicit 

--exec csp_GetDispositionLogExtractData2 2


