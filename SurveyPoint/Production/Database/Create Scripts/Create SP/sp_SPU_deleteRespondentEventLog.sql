  
Create PROCEDURE [sp_SPU_deleteRespondentEventLog]    
 (@RespondentID  [int], @EventID [int])    
/* Hib version 1.2     
Versions:    
1.2 Jan 2006 Hib - made this do a savepoint or a full transaction depending on if we are     
inside a transaction or not     
This way we preserve the transaction if we are doing a trigger     
*/    
AS begin    
    
/* start a transaction or savepoint */    
declare @trancount int    
set @trancount = @@trancount    
if @trancount =0    
  begin    
  begin tran    
  end    
else    
  begin    
  SAVE TRANSACTION delEventlogSavepoint    
  end    
    
    
    
declare abc cursor for select 1    
from respondents    
where    
respondentID in (select RespondentID from eventlog where [RespondentID]  = @RespondentID and [EventID] = @EventID)    
for update    
    
declare @x int    
open abc    
fetch abc into @x    
close abc    
deallocate abc    
  
  
  DELETE [QMS].[dbo].[EventLog]     
  WHERE     
  ([RespondentID]  = @RespondentID and [EventID] = @EventID)    
   
    
/* commit if we should */    
if @trancount =0    
  begin    
  commit    
  end    
end    