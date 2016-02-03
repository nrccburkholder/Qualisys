ALTER PROCEDURE sp_SPU_UpdateRespondentEventLog      
 (@RespondentID  [int],     
  @OldCode  [int],     
  @NewCode  [int]    
  )    
AS       
BEGIN      
    
declare @trancount int      
set @trancount = @@trancount      
if @trancount =0      
  begin      
  begin tran      
  end      
else      
  begin      
  SAVE TRANSACTION elusavepoint      
  end      
      
 Update EventLog set EventID =@NewCode where EventID=@OldCode and RespondentID=@RespondentID    
  
 select @@rowcount    
  
if @trancount =0      
  begin      
  commit      
  end      
END