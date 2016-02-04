/*
12/2/07 MWB
Purpose:
Generic CRUD Statement to insert records into SPU_RespondentsUpdated
Version 1.0 Original
*/
  
CREATE procedure [dbo].[Insert_RespondentsUpdated]  
(  
 @RespondentID int,  
 @FileLogID int  
)  
as  
BEGIN      
/* version 1.2      
history:      
1.1 original      
*/      
-- check this inserting survey audit      
    
declare @trancount int      
set @trancount = @@trancount      
if @trancount =0      
  begin      
  begin tran      
  end      
else      
  begin      
  SAVE TRANSACTION elsavepoint      
  end      
      
      
      
INSERT INTO [SPU_RespondentsUpdated]       
  ([RespondentID],      
  [FileLogID],      
  [UpdatedDate])       
VALUES       
 (@RespondentID,  
  @FileLogID,  
  GetDate())      
      
SELECT SCOPE_IDENTITY()  
      
if @trancount =0      
  begin      
  commit      
  end      
END 