--Drop procedure dbo.SPU_CreateAnswerFile

USE [QMS]
GO
/****** Object:  StoredProcedure [dbo].[SPU_CreateAnswerFile]    Script Date: 08/19/2008 08:58:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Version 1.0                      
--  MWB 2/6/08                      
--  This procedure is designed to return the result set for the Coventry Answer File.                      
--  ExportGroupID is the only required Parameter.                      
--                      
--  @RerunUsingLogDates and @ExportLogFileID are required if are re-running a previous export from the log screen.                      
--  @RerunUsingLogDates is a bit field (0) No, (1) Yes                      
--  @ExportLogFileID is the LogFileID from the table SPU_ExportFileLog                      
--                      
--  @Start2401Date and @End2401Date must be sent in if you want to re-run the procedure using all of the respondents found within a given date range                      
--                    
--  @update2401Codes is a bit flag that should be set to 1 if you would like all respondents to be added                    
--  to SPU_Mark2401HoldingTable.  This is a holding table that will be used to update a 2401 code if the                    
--  update 2401 Code checkbox is selected later.                    
--  @ExportLogFileID must be passed in if @update2401Codes is set to 1                    
--      
-- @OrigExportLogFileID is the origional export log file ID that was used.  
--  This is only set when the user selects a record from the log file and selects re-run and if the  
--  origional run was a "marked submitted"  
--  
--Version 1.1        
--  MWB 2/15/08              
--  Removed Dynamic SQL from first Result set to save data going back to client                
--      
--Version 1.2      
--  MWB 4/15/08      
--  Modified Respondent logic so that if @RerunUsingLogDates =1 and @exportLogFileID <> 0      
--  We need to get a list of respondentIDs using date/time from the ExportLogFile Mark2401RangeStartDate and Mark2401RangeEndDate.      
--  as long as the Begin and end dates are not null we do not care about what codes were previously in the list of codes to look for.      
--  if in fact either one of these fields are null we will go to the normal respondent search logic.      

--Version 1.3
--  TP 8/19/2008
--  Modified the procedure to include new respondent fields
--  (Address1, Address2, City, State, PostalCode, TelephoneDay)              
CREATE procedure [dbo].[SPU_CreateAnswerFile] (  
 @ExportGroupID int,   
 @update2401Codes tinyint=0,   
 @RerunUsingLogDates int =0,   
 @ExportLogFileID int =0,   
 @OrigExportLogFileID int =0,   
 @Start2401Date datetime=null,   
 @End2401Date datetime=null)                      
as                      
begin                      
                      
                      
 Declare @BeginTime datetime                      
 Declare @EndTime datetime                      
 Declare @SurveyID int                      
 Declare @SQL varchar(8000)                      
 Declare @SQLSelect varchar(8000)                      
 Declare @SQLName varchar(8000)                      
                      
 create table #Respondents (RespondentID int)                      
                      
select @SurveyID=SurveyID from SPU_Export_ExportGroupsToSurveys where ExportGroupID=@ExportGroupID                      
                      
if @RerunUsingLogDates = 1 and @OrigExportLogFileID <> 0                      
 begin                        
  --We need to get a list of respondentIDs using date/time from the ExportLogFile Mark2401RangeStartDate and Mark2401RangeEndDate.      
  --as long as the Begin and end dates are not null we do not care about what codes were previously in the list of codes to look for.      
  --if in fact either one of these fields are null we will go to the normal respondent search logic.      
  print 'Getting list of Respondents using Saved Export Log Start and stop times'                      
                      
  select @BeginTime=Mark2401RangeStartDate from SPU_ExportFileLog where ExportLogFileID =@OrigExportLogFileID                      
  select @EndTime=Mark2401RangeEndDate from SPU_ExportFileLog where ExportLogFileID =@OrigExportLogFileID                      
      
  if @BeginTime is null or @EndTime is null 
	begin     
		goto DefaultUpdate      
	end
              
  insert into #Respondents
  Select distinct E.RespondentID                  
  from	EventLog E                    
  where convert(varchar,E.EventDate,120) >= convert(varchar,@BeginTime,120) and 
		convert(varchar,E.EventDate,120)<= convert(varchar,@EndTime,120) and 
		eventID = 2401 and e.clientID in                        
			(select ClientID from SPU_Export_SurveysToClients where surveyID = @SurveyID and ExportGroupID=@ExportGroupID)

                      
  print 'Number or Respondents found: ' + cast(@@rowcount as varchar(100))                      
                      
 end                       
else                      
 begin      
  if @Start2401Date is not null and  @End2401Date is not null                      
   begin                      
    print 'Rerun 2401 using date Range parameters'                      
    --Get list of RespondentIDs using only the eventlog (EventID in/Not in and client and studyID)                      
    --The only difference from above is in this setting we will also use a date range.                      
    --This would be used more to limit the result set to a specific request, like I want all of January                      
    --or just last weeks exports again.                      
                      
    insert into #Respondents                      
    Select distinct RespondentID                      
    from Respondents R                      
    where Exists (select 'x' from Eventlog E where E.EventDate >= @Start2401Date and E.EventDate <= @End2401Date and eventID in                       
     (select EventID from SPU_Export_ExportGroupsToEvents where IsIncluded = 1 and ExportGroupID=@ExportGroupID and E.RespondentID = R.RespondentID and E.clientID in                       
    (select ClientID from SPU_Export_SurveysToClients where surveyID = @SurveyID and ExportGroupID=@ExportGroupID))) and                      
   NOT Exists  (select 'x' from Eventlog E where E.EventDate >= @Start2401Date and E.EventDate <= @End2401Date and eventID in                       
     (select EventID from SPU_Export_ExportGroupsToEvents where IsIncluded = 0 and ExportGroupID=@ExportGroupID and E.RespondentID = R.RespondentID and E.clientID in                       
    (select ClientID from SPU_Export_SurveysToClients where surveyID = @SurveyID and ExportGroupID=@ExportGroupID)))                      
                        
                      
      print 'Number or Respondents found: ' + cast(@@rowcount as varchar(100))                                      
   end                      
  else                      
   begin            
DefaultUpdate:                
    print 'Getting list of Respondents using only the default Event parameters'                      
                      
    --Get list of RespondentIDs using only the eventlog (EventID in/Not in and client and studyID)                      
    --This will be what is used the first time (or what is considered a normal run) an export is run.                        
    select @SurveyID=SurveyID from SPU_Export_ExportGroupsToSurveys where ExportGroupID=@ExportGroupID                      
                      
    insert into #Respondents                      
    Select distinct RespondentID                      
    from Respondents R                      
    where Exists      (select 'x' from Eventlog E where eventID in                       
          (select EventID from SPU_Export_ExportGroupsToEvents where IsIncluded = 1 and ExportGroupID=@ExportGroupID and E.RespondentID = R.RespondentID and E.clientID in                       
           (select ClientID from SPU_Export_SurveysToClients where surveyID = @SurveyID and ExportGroupID=@ExportGroupID))) and                      
      NOT Exists  (select 'x' from Eventlog E where eventID in                       
          (select EventID from SPU_Export_ExportGroupsToEvents where IsIncluded = 0 and ExportGroupID=@ExportGroupID and E.RespondentID = R.RespondentID and E.clientID in            
           (select ClientID from SPU_Export_SurveysToClients where surveyID = @SurveyID and ExportGroupID=@ExportGroupID)))                      
                      
      print 'Number or Respondents found: ' + cast(@@rowcount as varchar(100))                      
                      
      
   end                      
 end                      
      
      
CREATE INDEX RespID ON #Respondents (RespondentID)                                        
                      
                
print 'Executing master Query'                      
--master query                       
--select ' R ', r.*, ' Resp ', resp.*, ' S ', s.*,' AC ', AC.*, ' SQ ', SQ.*                      
Select R.RespondentID, si.ClientID, Resp.ResponseID, Resp.ResponseText,        
  Resp.UserID, S.ScriptID, S.SurveyID, AC.AnswerCategoryID,                
  AC.AnswerCategoryTypeID, AC.AnswerText, AC.AnswerValue, SQ.ItemOrder,                 
  SQ.QuestionID, SQ.SurveyQuestionID                
from #Respondents R,responses Resp, answercategories Ac , SurveyQuestions SQ,                       
  Scripts S, SPU_Export_SurveysToScripts ExStS, respondents R2, Surveyinstances Si,        
  ScriptScreens ss, SPU_Export_SurveysToClients ExStC                                  
where                 
  R.RespondentID = R2.RespondentID and               
  R2.SurveyinstanceID = si.SurveyinstanceID and              
  ac.AnswerCategoryID = resp.AnswerCategoryID and                      
  SQ.SurveyQuestionID = resp.SurveyQuestionID and              
  r.respondentID = Resp.RespondentID and                      
  ExStS.ExportGroupID = @ExportGroupID and                      
  ExStS.SurveyID = @SurveyID and                      
  s.ScriptID = ExStS.ScriptID and                     
  s.scriptID = ss.ScriptID and         
  SQ.SurveyQuestionID = ss.SurveyQuestionID and    
  ExStC.clientID =  si.ClientID and    
  ExStC.SurveyID = @SurveyID and       
  ExStC.ExportGroupID = @ExportGroupID     
Order by r.respondentID        
                 
print @SQL                    
Exec (@SQL)                    
                    
                    
                    
print 'Executing Respondent Query'                      
--Return the master Respondent table                      
--select RP.RespondentID,RP.SurveyInstanceID,RP.FirstName,RP.MiddleInitial,RP.LastName,RP.DOB,RP.Gender,RP.ClientRespondentID                
--from Respondents RP, #Respondents R                      
--where RP.respondentID = R.RespondentID                      
--Order by RP.respondentID                      
--TP Change                      
select RP.RespondentID,RP.SurveyInstanceID,RP.FirstName,RP.MiddleInitial,RP.LastName,RP.Address1, RP.Address2, RP.City, RP.State, RP.PostalCode, RP.TelephoneDay, RP.DOB,RP.Gender,RP.ClientRespondentID                
from Respondents RP, #Respondents R                      
where RP.respondentID = R.RespondentID                      
Order by RP.respondentID                      

print 'Executing Respondent property Query'                      
--Return a list of all Respondent properties                      
select RP.RespondentPropertyID,RP.RespondentID,RP.PropertyName,RP.PropertyValue                       
from respondentproperties RP, #Respondents R                      
where RP.respondentID = R.RespondentID                      
Order by RP.RespondentID                
                    
print 'Executing Export Group Query'                      
--Return a list of all ExportGroup Fields                      
Select ExportGroupID,Name,MiscChar1,MiscChar1Name,MiscChar2,MiscChar2Name,MiscChar3,MiscChar3Name,MiscChar4,MiscChar4Name,        
MiscChar5,MiscChar5Name,MiscChar6,MiscChar6Name,MiscNum1,MiscNum1Name,MiscNum2,MiscNum2Name,MiscNum3,MiscNum3Name,MiscDate1,        
MiscDate1Name,MiscDate2,MiscDate2Name,MiscDate3,MiscDate3Name, RemoveHTMLAndEncoding                     
from SPU_ExportGroups                     
where ExportGroupID = @ExportGroupID                      
Order by ExportGroupID                    
                      
print 'Executing Client and Extensions Query'                      
--Return a list of all client and Client extension values for selected clients                      
Exec SPU_GetSelectedClients @ExportGroupID, @SurveyID                      
                      
print 'Executing Script and Extensions Query'                      
--Return a list of all Script and Script extension values for selected clients                      
Exec SPU_GetSelectedscripts @ExportGroupID, @SurveyID                      
                      
      
                      
print 'Executing Max Export Date Query'                      
      
if exists (select EventID from SPU_Export_ExportGroupsToEvents where IsIncluded = 1 and ExportGroupID=@ExportGroupID and eventID  = 2401)       
 begin      
  --This would mean they are running a query where 2401 is in the included list.      
  --be default rules they cannot mark new 2401 codes in this file generation.      
  --Because of the way the tool is set up we cannot use the SPU_Export_ExportGroupsToEvents      
  --table.  Instead we have hardcoded the 'complete' codes in this list.      
  --so whenever a new complete survey code is added this list needs to be modified.      
  select EL.RespondentID, Max(EventDate) as MaxEventDate                       
  from EventLog EL, #Respondents R                       
  where EL.RespondentID = R.RespondentID and                       
   EventID in (3012, 3022, 3032, 3035, 3038)                      
   and eventID <> 2401                  
  group by EL.RespondentID                      
      
      
      
 end      
else      
 begin      
  -- Return max event date for event code that made eligible for export                      
  select EL.RespondentID, Max(EventDate) as MaxEventDate                       
  from EventLog EL, #Respondents R                       
  where EL.RespondentID = R.RespondentID and                       
   EventID in (select EventID from SPU_Export_ExportGroupsToEvents where IsIncluded = 1 and ExportGroupID=@ExportGroupID)                      
   and eventID <> 2401                  
  group by EL.RespondentID                      
    end      
                  
                    
if @update2401Codes = 1 and @ExportLogFileID <> 0          
 begin                    
  insert into SPU_Mark2401HoldingTable (RespondentID, ExportLogFileID)                    
  select R.RespondentID, @ExportLogFileID as ExportLogFileID                    
  from #Respondents R                    
 end                    
                      
drop table #Respondents                      
                      
end           
