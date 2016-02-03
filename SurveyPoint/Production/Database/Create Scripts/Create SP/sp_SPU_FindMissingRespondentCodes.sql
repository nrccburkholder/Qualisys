/*    
MWB 11/7/2007    
This procedure is desinged to take in a comma seperated list of respondentIDs and check if they have     
a completed or incomplete event code in the event log.  Those that do not are reported back to the calling     
procedure and marked with a 3010 code.  This is a incomplete Mail code.  From there a utility can be used to update    
this code to what they need it to be.    
*/    
CREATE procedure [dbo].[sp_SPU_FindMissingRespondentCodes]        
(        
 @RespondentIDs as varchar(7700),        
 @UserID as int = 1,  
 @Update3010Code as int = 1    
)        
as         
Begin        
    
declare @SQL varchar(8000)    
declare @EventDate datetime    
    
set @EventDate = getDate()    
    
create table #RespondentsWithCodes (RespondentID varchar(10))    
create table #RespodentsWithoutCodes (FirstName varchar(100), LastName varchar(100), EventDate  datetime, EventID  int, UserID  int, RespondentID  int, SurveyInstanceID  int, SurveyID  int, ClientID  int, EventTypeID  int)    
    
set @SQL = 'insert into #RespondentsWithCodes select Distinct R.RespondentID     
from Respondents R, EventLog E    
where R.RespondentID = E.RespondentID and E.EventID in (3012,3022,3035,3038, 3010,3020,3033,3036)    
and R.respondentID in (' + @RespondentIDs + ')'    
    
--print @SQL    
Exec (@SQL)    
    
set @SQL = 'Insert into #RespodentsWithoutCodes (RespondentID, FirstName, LastName, EventDate, EventID, UserID, SurveyInstanceID, SurveyID, ClientID, EventTypeID)    
Select R.RespondentID, R.FirstName, R.LastName, getDate() as EventDate, 3010 as EventID, ' + cast(@UserID as varchar(10)) + ' as UserID, SI.SurveyInstanceID as SurveyInstanceID, SI.SurveyID as SurveyID, SI.ClientID as clientID, 4 as EventTypeID    
from Respondents R, surveyinstances SI    
where R.SurveyInstanceID = SI.SurveyInstanceID and R.respondentID in (' + @RespondentIDs + ') and R.RespondentID not in (Select RespondentID from #RespondentsWithCodes)'    
    
--print @SQL    
Exec (@SQL)    
    
IF OBJECT_ID('tempdb..#RespodentsWithoutCodes') IS NOT NULL        
     begin     
  if exists (select 'x' from #RespodentsWithoutCodes)    
  begin   
   if @Update3010Code = 1  
 begin  
      insert into EventLog (EventDate, EventID, UserID, RespondentID, SurveyInstanceID, SurveyID, ClientID, EventTypeID)    
      select EventDate, EventID, UserID, RespondentID, SurveyInstanceID, SurveyID, ClientID, EventTypeID from #RespodentsWithoutCodes    
 end  
  end    
    
  select RespondentID, FirstName, LastName from #RespodentsWithoutCodes    
  drop table #RespodentsWithoutCodes    
  end    
else    
 begin    
  select 0 as respondentID, 'No Respondents Found missing a Complete or incomplete Code' as FirstName, '' as LastName    
 end    
    
    
drop table #RespondentsWithCodes    
    
    
end