CREATE PROCEDURE [dbo].[csp_GetDispositionLogExtractData] 
	@ExtractFileID int 
AS
	SET NOCOUNT ON 
    
	declare @EntityTypeID int
	set @EntityTypeID = 14 -- DispositionLog
    	
	--declare @ExtractFileID int
	--set @ExtractFileID = 2
	
	delete DispositionLogTemp where ExtractFileID = @ExtractFileID

	insert DispositionLogTemp 
			(ExtractFileID,SAMPLEPOP_ID, Disposition_id,ReceiptType_id,datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst )
		select distinct @ExtractFileID,dl.SAMPLEPOP_ID, dl.Disposition_id,dl.ReceiptType_id,dl.datLogged,dl.LoggedBy,dl.DaysFromCurrent,dl.DaysFromFirst
		 from (select distinct PKey1, PKey2
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID
	           and IsDeleted = 0 ) eh
	      inner join QP_Prod.dbo.DispositionLog dl with (NOLOCK) on eh.PKey1 = dl.samplepop_id And eh.PKey2 = dl.Disposition_id --And dl.datLogged > @PrevStartTime
		  inner join QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on  dl.samplepop_id	 = sp.samplepop_id 
          left join SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     and sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
          where sst.sampleset_id is NULL --excludes sample pops that will be deleted due to sampleset deletes  
           and sp.POP_ID > 0	

    ---------------------------------------------------------------------------------------
	-- Rows are not deleted from the DispositionLog table
	---------------------------------------------------------------------------------------
    --exec csp_GetDispositionLogExtractData 2


