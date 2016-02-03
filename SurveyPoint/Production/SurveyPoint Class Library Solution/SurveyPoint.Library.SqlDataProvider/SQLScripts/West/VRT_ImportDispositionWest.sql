CREATE PROCEDURE [dbo].[VRT_ImportDispositionWest]      
	@respondentID int,      
	@index int,      
	@callOutcome varchar(500),      
	@dateStamp datetime,
	@CallType varchar(20)       
AS      
BEGIN       
	SET NOCOUNT ON;      
	DECLARE @myErrors TABLE (ErrorID int identity,ErrDescription varchar(1500)) /* table of all the error codes */        
	Begin Tran        
	  
	Declare @respID int      
	Declare @errCount int      
	Declare @eventCount int       
	Declare @surveyInstanceID int      
	Declare @surveyID int      
	Declare @clientID int      
	Declare @eventID int      
	set @eventID = 0      
	Set @respID = 0      
	Set @surveyInstanceID = 0      
	Set @surveyID = 0      
	Set @clientID = 0   
	
	DECLARE @INBOUND_EVENTID INT  
	DECLARE @OUTBOUND_EVENTID INT
	SET @INBOUND_EVENTID = 2208
	SET @OUTBOUND_EVENTID = 2203
       
	Select @respID = isnull(RespondentID, 0) from Respondents Where RespondentID = @respondentID      
	Select @errCount=Count(ErrorID) from @myErrors  
     
	print 'Respondent ID Check'      
	if ((@respID is null) or (@respID = 0))      
	begin      
		insert into @myErrors (ErrDescription) Values ('Line ' + cast(@index as varchar(10)) + ' respondent ID does not exist.')         
		Select @errCount=Count(ErrorID) from @myErrors      
	end   
	   
	if (@errCount = 0)      
	begin 
	     
		--Get Respondent values you'll need.      
		Select	@surveyInstanceID = isnull(SI.SurveyInstanceID, 0), 
				@surveyID = isnull(SI.SurveyID, 0), 
				@clientID = isnull(SI.ClientID, 0)      
		From SurveyInstances SI inner join Respondents R on SI.SurveyInstanceID = R.SurveyInstanceID      
		Where R.RespondentID = @respondentID  
    
		print 'Set Respondent Variables'      
		if ((@@ERROR <> 0) or (@surveyInstanceID is null) or (@surveyID is null) or (@clientID is null)  or (@surveyInstanceID = 0) or (@surveyID = 0) or (@clientID = 0))      
		begin      
			insert into @myErrors (ErrDescription) Values ('Line ' + cast(@index as varchar(10)) + ' respondent data is invalid.')         
			Select @errCount=Count(ErrorID) from @myErrors      
			print 'Invalid Respondent variables'      
		end      

		--Now, get flags that tell us what to insert.    
		if (@errCount = 0)      
		begin      

			if (@CallType = '')--default to outbound
			begin
				set @CallType = 'OUTBOUND'
			end

			Declare @eventEntryExists int    
			Declare @callAttempts int      
			Declare @completesExist int     
			Declare @eventCallOutcomeCode int 
			Set @eventEntryExists = 0    
			Set @callAttempts = 0    
			Set @completesExist = 0    
			set @eventCallOutcomeCode = 0  
			print 'Check for complete events'   
			 
			Select @eventCallOutcomeCode = isnull(EventID, 0) 
			from VRT_CallOutcomeEventCodeMap_West 
			Where CallOutcome = Upper(@callOutcome) and CallType = Upper(@CallType)
         
			if exists (Select 'x' 
						from EventLog 
						Where 
							RespondentID = @respondentID and 
							( EventID in (@OUTBOUND_EVENTID, @INBOUND_EVENTID) or EventID = @eventCallOutcomeCode) and EventDate = @dateStamp 
						)    
			begin    
				set @eventEntryExists = 1    
			end    

			if exists (Select 'x' from EventLog where RespondentID = @respondentID and EventID in (3022,3020,5014,5003,5015,5017,5016)) -- aa (3070, 3072, 6067, 6070))      
			begin      
				set @completesExist = 1    
			end      

			Select @callAttempts = isnull(Count(*), 0) from EventLog where RespondentID = @respondentID and EventID in(@OUTBOUND_EVENTID, @INBOUND_EVENTID)      

		end  

		if (@errCount = 0)      
		begin      
			--Insert the Event Code(s)     
			if ((@callAttempts < 3) and (@eventEntryExists = 0))      
			begin      
				declare @CallTypeEventID int

				if (upper(@CallType) = 'INBOUND')
				begin
					set @CallTypeEventID = @INBOUND_EVENTID
				end
				else
				begin
					set @CallTypeEventID = @OUTBOUND_EVENTID
				end 
			
				print 'Insert ' + Convert(Varchar(20), @CallTypeEventID)      
				set @callAttempts = (@callAttempts + 1)           

				insert into EventLog(EventDate, EventID, UserID, RespondentID, SurveyInstanceID, ClientID, SurveyID, EventTypeID) 
				Values (@dateStamp, @CallTypeEventID, 1, @respondentID, @surveyInstanceID, @clientID, @surveyID, 2)      
				print 'Insert call 1 '+ Convert(Varchar(20), @CallTypeEventID)

				if (@@ERROR <> 0)      
				begin      
					insert into @myErrors (ErrDescription) Values ('Line ' + cast(@index as varchar(10)) + ' error entering '+ Convert(Varchar(20), @CallTypeEventID) +' code.')         
					Select @errCount=Count(ErrorID) from @myErrors      
				end    
			
				if (@errCount = 0)    
				begin    

					if ((@eventCallOutcomeCode > 0))    
					begin    
						insert into EventLog (EventDate, EventID, UserID, RespondentID, SurveyInstanceID, ClientID, SurveyID, EventTypeID) Values       
						(@dateStamp, @eventCallOutcomeCode, 1, @respondentID, @surveyInstanceID, @clientID, @surveyID, 2)     
					end    

					if (@@ERROR <> 0)      
					begin      
						insert into @myErrors (ErrDescription) Values ('Line ' + cast(@index as varchar(10)) + ' error entering event code.')         
						Select @errCount=Count(ErrorID) from @myErrors      
					end   
					    
				end            
			end     

			--Check for Max call attempts and insert if neccesary.    
			print 'Call Attempts = ' + cast(@callAttempts as varchar(20))  
			print 'Completes Exist = ' + cast(@completesExist as varchar(20))  
			print 'Event Call Outcome Code = ' + cast(@eventCallOutcomeCode as varchar(20))  

			if ((@callAttempts >= 3) and (@completesExist = 0) and (@eventCallOutcomeCode <> 5017))      -- aa was 6067 for Tuvox
			begin    
				insert into EventLog(EventDate, EventID, UserID, RespondentID, SurveyInstanceID, ClientID, SurveyID, EventTypeID) 
				Values (getdate(), 2063, 1, @respondentID, @surveyInstanceID, @clientID, @surveyID, 5)       -- aa was 6070  for Tuvox
				if (@@ERROR <> 0)      
				begin      
					insert into @myErrors (ErrDescription) Values ('Line ' + cast(@index as varchar(10)) + ' error entering max call code.')         
					Select @errCount=Count(ErrorID) from @myErrors      
				end       
			end          
		end    
	end                                         
 
	if (@errCount != 0)      
	begin      
		print 'rollback'      
		rollback tran      
	end      
	else      
	begin      
		print 'commit'      
		commit tran      
	end 
	     
	Select Top 1 ErrDescription from @myErrors      

END
