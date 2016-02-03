/*
12/2/07 MWB
Purpose:
Generic CRUD Statement to insert records into SPU_FileTrackingLog
Version 1.0 Original
*/
CREATE PROCEDURE [dbo].[insert_FileTrackingLog]      
 (@FileName  varchar(100),     
  @NumRecordsInFile  [int],     
  @NumRecordsUpdated [int],  
  @NumMissingEventCodes  [int],     
  @UpdateTypeID  [int],    
  @UserID  [int] = 1,   
  @Username varchar(50) = null   
  )    
      
AS       
BEGIN      
/* version 1.2      
history:      
1.2 - hib - Jan 2006 -- added proper handling for transactions      
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
      
      
      
INSERT INTO [SPU_FileTrackingLog]       
  ([DatFileLoaded],      
  [FileName],      
  [UserID],    
  [UserName],  
  [NumRecordsInFile],   
  [NumRecordsUpdated],  
  [NumMissingEventCodes],      
  [UpdateTypeID])       
       
VALUES       
 (GetDate(),      
  @FileName,      
  @UserID,      
  @UserName,    
  @NumRecordsInFile,      
  @NumRecordsUpdated,  
  @NumMissingEventCodes,    
  @UpdateTypeID)      
      
SELECT SCOPE_IDENTITY()  
      
if @trancount =0      
  begin      
  commit      
  end      
END 