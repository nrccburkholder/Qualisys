-- ================================================================================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_PrepareForExtract
-- Create date: 3/01/2009
-- Description:	Updates ExtractQueue for data extracted, copies rows to ExtractHistory table 
-- History: 1.0  3/01/2009  
--          1.1  3/22/2011  - added client groups
-- =================================================================================================
CREATE PROCEDURE [dbo].[csp_PrepareForExtract]
@IncludeMetaData BIT, @IncludeEventData BIT, @ProcessDeletes BIT, @ClientListFromExtractExcludeClientTable BIT=NULL, @ClientListFromExtractIncludeClientTable BIT=NULL, @ReturnMessage NVARCHAR (500) OUTPUT

/*
declare @ExtractFileID int,@ReturnMessage NVARCHAR (500)
EXEC @ExtractFileID= csp_PrepareForExtract 1, 0, 0,NULL,NULL,@ReturnMessage Output
select @ExtractFileID,@ReturnMessage
*/
AS
BEGIN
	SET NOCOUNT ON 
	
	---------------------------------------------------------------------------------------
	-- Prepares data for estract, moves data from ExtractQueue to ExtractHistory
	-- Changed on 2009.11.09 by kmn added Source Column to ExtractHistory move and added call to csp_PrepareDispositionLog sp
	---------------------------------------------------------------------------------------
  begin try
	if @IncludeMetaData =	@IncludeEventData 
	begin
		raiserror ('csp_PrepareForExtract: You can only extract metadata or event data.  Not both or neither.', 10, 1)	
		Set @ReturnMessage = 'csp_PrepareForExtract: You can only extract metadata or event data.  Not both or neither.'	
		return -4
	end

    if @ClientListFromExtractIncludeClientTable = 1 And @ClientListFromExtractExcludeClientTable = 1
	begin
		raiserror ('csp_PrepareForExtract: You can only include or exclude clients via ExtractClient_xxx table, not both.', 10, 1)	
		Set @ReturnMessage = 'csp_PrepareForExtract: You can only include or exclude clients via ExtractClient_xxx table, not both.'	
		return -4
	end
	
	-------------------------------------------------------------------------------------------------
	-- Determine the last record in the extract queue that can be extracted in this job
	-------------------------------------------------------------------------------------------------
	
	declare @MaxExtractQueueID int
	if @IncludeMetaData = 1
	begin
		select @MaxExtractQueueID = max(ExtractQueueID) 
		  from ExtractQueue--StudyListe	
		 where IsMetaData = 1 
	end
	else -- @IncludeEventData
	begin
		-- We can only extract event data up until the point where the last un-extracted metadata change
		-- was made.  Find the oldest record for metadata and only take event records from before that record.
--		declare @MaxExtractQueueID  int
		declare @OldestMetaChange int

		select @OldestMetaChange = min(ExtractQueueID)
		  from ExtractQueue with (NOLOCK)
		 where IsMetaData = 1 And ExtractFileID Is NULL
    
		set @OldestMetaChange = Isnull(@OldestMetaChange, 2147483647)
      
		select @MaxExtractQueueID = max(ExtractQueueID) 
		  from ExtractQueue	
		 where IsMetaData = 0
		   and ExtractQueueID < @OldestMetaChange

	 --print @MaxExtractQueueID 

	end
  --print @OldestMetaChange,@ClientListFromExtractClientTable

	-------------------------------------------------------------------------------------------------
	-- Create the ExtractFile record
	-------------------------------------------------------------------------------------------------
	declare @ExtractFileID int

	if @MaxExtractQueueID is null
	begin
		exec csp_CompleteExtract @ExtractFileID, 'There is no data to extract - @MaxExtractQueueID is null.'
		raiserror ('csp_PrepareForExtract: There is no data to extract before filtering - @MaxExtractQueueID is null.', 10, 1)
		Set @ReturnMessage = 'csp_PrepareForExtract: There is no data to extract before filtering - @MaxExtractQueueID is null.'	
		return -4
	end

	insert ExtractFile (StartTime, IncludeMetaData, IncludeEventData, MaxExtractQueueID)
		values (getdate(), @IncludeMetaData, @IncludeEventData, @MaxExtractQueueID)
	set @ExtractFileID = SCOPE_IDENTITY()

	-------------------------------------------------------------------------------------------------
	-- Run stored procedures to mark the correct entities to extract
	-------------------------------------------------------------------------------------------------
	if @IncludeMetaData = 1
	begin
		exec dbo.csp_PrepareClientGroups @ExtractFileID, @MaxExtractQueueID
		exec dbo.csp_PrepareClients @ExtractFileID, @MaxExtractQueueID	
		exec dbo.csp_PrepareClientContacts @ExtractFileID, @MaxExtractQueueID	
		exec dbo.csp_PrepareStudies @ExtractFileID, @MaxExtractQueueID	
		exec dbo.csp_PrepareSurveys @ExtractFileID, @MaxExtractQueueID	
		exec dbo.csp_PrepareSurveyQuestions @ExtractFileID, @MaxExtractQueueID	
		exec dbo.csp_PrepareSampleUnits @ExtractFileID, @MaxExtractQueueID
		exec dbo.csp_PrepareMetaTable @ExtractFileID, @MaxExtractQueueID
		exec dbo.csp_PrepareMetaStructure @ExtractFileID, @MaxExtractQueueID
		exec dbo.csp_PrepareMetaField @ExtractFileID, @MaxExtractQueueID
	end
	else -- @IncludeEventData
	begin
        declare @ExcludeFlag int
        set @ExcludeFlag = 0
        --set @ClientListFromExtractClientTable = IsNull(@ClientListFromExtractClientTable,0)

        truncate table dbo.tempsurvey 

		if  @ClientListFromExtractIncludeClientTable = 1 Or @ClientListFromExtractExcludeClientTable = 1
		  begin
			declare @cmd varchar(7000)
            
            If @ClientListFromExtractExcludeClientTable = 1 Or @ClientListFromExtractIncludeClientTable = 1--getting client list from ExtractClient_Include table
             begin
				   If @ClientListFromExtractExcludeClientTable = 1
                    begin
						set @cmd = 	  'insert into dbo.tempsurvey
									   select Survey_id 
									   from QP_PROD.dbo.Study Study With (NOLOCK)
									   inner join QP_PROD.dbo.SURVEY_DEF Survey With (NOLOCK) On Study.Study_ID = Survey.Study_ID
									   left join ExtractClient_Exclude With (NOLOCK) On Study.Client_id = ExtractClient_Exclude.Client_ID
									   where ExtractClient_Exclude.Client_ID is null'	
				   end
                  else --@ClientListFromExtractIncludeClientTable = 1
				   begin
						  set @cmd = 'insert into dbo.tempsurvey
									  select Survey_id 
									  from QP_PROD.dbo.Study Study With (NOLOCK)
									  inner join QP_PROD.dbo.SURVEY_DEF Survey With (NOLOCK) On Study.Study_ID = Survey.Study_ID
									  inner join ExtractClient_Include With (NOLOCK) On Study.Client_id = ExtractClient_Include.Client_ID'
					end						   
            end              
					           
			exec(@cmd)
 
--          print @cmd

            set @ExcludeFlag = 1
		end     
          --return @ExtractFileID
        exec csp_PrepareSampleSet @ExtractFileID, @MaxExtractQueueID, @ExcludeFlag
		exec csp_PrepareQuestionForm @ExtractFileID, @MaxExtractQueueID, @ExcludeFlag
		exec csp_PrepareSamplePopulation @ExtractFileID, @MaxExtractQueueID, @ExcludeFlag	
		exec csp_PrepareDispositionLog @ExtractFileID, @MaxExtractQueueID, @ExcludeFlag	                   
		
	end

	-------------------------------------------------------------------------------------------------
	-- Verify that we have data to extract
	-------------------------------------------------------------------------------------------------
	declare @cnt int
	select @cnt = count(*) from ExtractQueue where ExtractFileID = @ExtractFileID
	if @cnt = 0
	begin
		raiserror ('csp_PrepareForExtract: There is no data to extract after filtering.', 10, 1)
		Set @ReturnMessage = 'csp_PrepareForExtract: There is no data to extract after filtering.'	
        exec csp_CompleteExtract @ExtractFileID,1--'There is no data to extract after filtering.'
		return -4
	end

	-------------------------------------------------------------------------------------------------
	-- Move the records to the history table for extraction
	-- Note: A group by is used so dup change rows are not moved to the history table
	-------------------------------------------------------------------------------------------------
   
	insert ExtractHistory(ExtractHistoryID,EntityTypeID, PKey1, PKey2,IsMetaData, ExtractFileID, IsDeleted,Created,Source)
      select ExtractQueue.ExtractQueueID,ExtractQueue.EntityTypeID, ExtractQueue.PKey1
        , ExtractQueue.PKey2,IsMetaData,@ExtractFileID, ExtractQueue.IsDeleted,ExtractQueue.Created,ExtractQueue.Source
       from ExtractQueue with (NOLOCK)
       inner join (select max(ExtractQueueID) As ExtractQueueID-- ,EntityTypeID, PKey1, PKey2,IsMetaData,@ExtractFileID, IsDeleted,Max(Created)
                   from ExtractQueue with (NOLOCK)
		           where ExtractFileID = @ExtractFileID 
	            	 And IsDeleted =  Case When @ProcessDeletes = 1 THEN IsDeleted --includes deletes
                            Else 0 --excludes deletes 
                         End        
		            group by EntityTypeID, PKey1, PKey2,IsMetaData--, IsDeleted--need to get the max and determine if insert or delete
                  ) x on ExtractQueue.ExtractQueueId = x.ExtractQueueID

    -------------------------------------------------------------------------------------------------
	-- Special logic for question form deletes.  
	-- Note: A group by is used so dup change rows are not moved to the history table
	-------------------------------------------------------------------------------------------------
    insert ExtractHistory(ExtractHistoryID,EntityTypeID, PKey1, PKey2,IsMetaData, ExtractFileID, IsDeleted,Created,Source)
      select ExtractQueue.ExtractQueueID,ExtractQueue.EntityTypeID, ExtractQueue.PKey1
        , ExtractQueue.PKey2,ExtractQueue.IsMetaData,@ExtractFileID, ExtractQueue.IsDeleted,ExtractQueue.Created,ExtractQueue.Source
       from ExtractQueue with (NOLOCK)
       inner join (select max(ExtractQueueID) As ExtractQueueID-- ,EntityTypeID, PKey1, PKey2,IsMetaData,@ExtractFileID, IsDeleted,Max(Created)
                   from ExtractQueue with (NOLOCK)
		           where ExtractFileID = @ExtractFileID 
		             And EntityTypeID = 11--question form
	            	 And IsDeleted =  Case When @ProcessDeletes = 1 THEN 1-- only  includes deletes
                            Else NULL --excludes deletes, should get no rows returned
                         End        
		            group by EntityTypeID, PKey1, PKey2,IsMetaData--, IsDeleted--need to get the max and determine if insert or delete
                  ) x on ExtractQueue.ExtractQueueId = x.ExtractQueueID
        left join ExtractHistory eh  with (NOLOCK) on ExtractQueue.ExtractQueueID = eh.ExtractHistoryID
        where eh.ExtractHistoryID is null         
		         
    DBCC DBREINDEX(ExtractHistory,' ',90)     

	return @ExtractFileID
	
   end try
	
	begin catch
	   Set @ReturnMessage = 'csp_PrepareForExtract-- '  +  ERROR_MESSAGE() 
	   return -4
	end catch
END


