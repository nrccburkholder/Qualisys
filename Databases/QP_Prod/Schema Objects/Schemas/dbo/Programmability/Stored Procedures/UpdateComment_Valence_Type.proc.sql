CREATE PROCEDURE UpdateComment_Valence_Type  
     @LithoCode varchar(25),  
     @Chg varchar(10),  
     @Text varchar(20),  
     @Incident varchar(30)  
AS  
BEGIN  
SET XACT_ABORT ON   
/********************************************************************************************************************        
Unit Test:        
        
SELECT cmntType_id,cmnt_id,* from COMMENTS where questionform_id =  77341883        
select cmntType_ID,* from datamart.QP_Comments.s1650.comments where cmnt_id = 6358149        
        
select * from dbo.CommentTypes  --3       
select * from dbo.CommentValences    --2      
        
        
--Parameters:LithoCode,Type/Valence,General/Positive,IncidentNumber        
--EXEC UpdateComment_Valence_Type '100000','Type','Service Alert',INC99999999        
        
--EXEC #UpdateComment_Valence_Type '100000318','Type','Service Alert',INC99999999        
        
--EXEC UpdateComment_Valence_Type '100000','VALENCE','Negative',INC99999999            
        
SELECT cmntType_id,CmntValence_ID,* from COMMENTS where questionform_id =  77341883        
        
select * from dbo.CommentTypes         
select * from dbo.CommentValences         
        
--DROP procedure #UpdateComment_Valence_Type         
***********************************************************************************************************************/     
DECLARE @Study_ID varchar(10)        
DECLARE @questionformID int        
DECLARE @CommentID Varchar(10)        
DECLARE @SqlStr varchar(500)        
DECLARE @TypeValence int   
  
  
IF @LithoCode IN (SELECT STRLITHOCODE FROM SENTMAILING WHERE STRLITHOCODE = ''+@LithoCode+'')  
BEGIN  
 SELECT @questionformID=qf.questionform_id,  
     @Study_ID= 's'+CAST(sd.study_id AS VARCHAR(10)),  
     @CommentID= CAST(Cmnt_id AS VARCHAR(10))  
    FROM sentmailing sm        
    inner join questionform qf        
    on qf.sentmail_id = sm.sentmail_id        
    inner join comments c        
    on c.questionform_id = qf.questionform_id        
    inner join survey_def sd        
    on sd.survey_id = qf.survey_id        
    where sm.strlithocode = ''+@LithoCode+''        
      
    PRINT '@LithoCode: '+cast(@LithoCode as varchar)        
 PRINT '@CommentID: '+cast(@CommentID as varchar)      
  
END    
ELSE    
BEGIN    
PRINT 'LithoCode does not exist.'    
RETURN    
END    
  
  
--Update CommentType        
IF @Chg = 'Type' and @Text IN (SELECT strCmntType_Nm FROM dbo.CommentTypes)        
BEGIN        
select @TypeValence=CmntType_id         
from dbo.CommentTypes         
Where strCmntType_Nm = @Text        
  
  
BEGIN TRY        
 BEGIN TRANSACTION    
  --NRC10    
  UPDATE COMMENTS         
  SET CmntType_id = @TypeValence         
  WHERE cmnt_id = @CommentID        
  --MEDUSA        
  SELECT @SqlStr = 'UPDATE DATAMART.QP_Comments.'+@Study_ID+'.comments SET CmntType_ID  ='+cast(@TypeValence as varchar)+' WHERE  Cmnt_ID =' +@CommentID        
  EXEC(@SqlStr)      
  PRINT 'Comment Type has been successfully updated to "'+@Text+'" in QLOADER & DATAMART'         
 COMMIT TRANSACTION    
END TRY    
BEGIN CATCH    
 IF @@TRANCOUNT > 0     
 ROLLBACK TRANSACTION    
 PRINT('Comemnt Type Transaction has been rolledback')    
END CATCH    
END    
  
  
--Update CommentValence        
ELSE IF @Chg = 'Valence' and @Text IN (SELECT strCmntValence_Nm FROM dbo.CommentValences)        
BEGIN        
select @TypeValence=CmntValence_id         
from dbo.CommentValences         
Where strCmntValence_Nm = @Text        
        
    
BEGIN TRY    
 BEGIN TRANSACTION    
  --NRC10      
  UPDATE COMMENTS         
  SET cmntvalence_id = @TypeValence         
  WHERE questionform_id = @questionformID        
    
  --For Catalyst        
  INSERT NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,IsDeleted,Source)        
  SELECT 11,@questionformID,@LithoCode,0,0,'Comment Valence Update -'+@Incident        
      
  --MEDUSA        
  SELECT @SqlStr = 'UPDATE DATAMART.QP_Comments.'+@Study_ID+'.comments SET CmntValence_id  ='+cast(@TypeValence as varchar)+' WHERE  questionform_id ='+cast(@questionformID as varchar)        
  EXEC(@SqlStr)        
      
  PRINT 'Comment Valence has been successfully updated to "'+@Text+'" in QLOADER ,DATAMART & CATALYST'         
    COMMIT TRANSACTION    
END TRY    
BEGIN CATCH    
 IF @@TRANCOUNT > 0     
 ROLLBACK TRANSACTION    
 PRINT('Comemnt Valence Transaction has been rolledback')    
END CATCH    
END    
    
ELSE        
Print 'Did not update, Please check'        
END


