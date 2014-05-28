/****** Object:  Stored Procedure dbo.QCL_ReGenerateMailing       Script Date: 10/11/05 ******/  
/************************************************************************************************/  
/*                       */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It logs     */  
/*            the contact request to the dispositionlog table.  The actual email is sent by */  
/*            the application.         */  
/* Date Created:  10/11/2005                   */  
/*                       */  
/* Created by:  Brian Dohmen                   */  
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*                       */  
/************************************************************************************************/  
CREATE PROCEDURE QCL_ReGenerateMailing  
 @Litho VARCHAR(20),   
 @DispositionID INT,   
 @LangID INT,    
 @ReceiptTypeID INT,  
 @UserName VARCHAR(42)    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
DECLARE @sql VARCHAR(8000), @SentMailID INT, @SamplePopID INT, @PopID INT, @StudyID INT
 
--Get the samplepop_id, pop_id, and study_id for the given litho.  
SELECT @SamplePopID=sp.SamplePop_id, @PopID=Pop_id, @StudyID=Study_id    
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp    
WHERE sm.strLithoCode=@Litho    
AND sm.SentMail_id=schm.SentMail_id    
AND schm.SamplePop_id=sp.SamplePop_id    
    
--Change the langid as necessary    
IF @LangID IS NOT NULL    
BEGIN    
    
INSERT INTO tbl_QCL_LangIDChange (Study_id, Pop_id, LangID)
SELECT @StudyID, @PopID, @LangID
--  SELECT @sql='UPDATE S'+@Study_id+'.Population SET LangID='+LTRIM(STR(@LangID))+' WHERE Pop_id='+@Pop_id    
--  EXEC (@sql)    
    
END    
    
--Check to see if they have a regenerate scheduled to generate.  If they do, exit the proc.    
IF EXISTS (SELECT * FROM ScheduledMailing WHERE SamplePop_id=@SamplePopID AND SentMail_id IS NULL AND OverRideItem_id IS NOT NULL)    
BEGIN    
 SELECT 1    
 RETURN    
END    
    
BEGIN TRANSACTION     
    
--Now to schedule another generation.    
DECLARE @ORI INT    
    
--Add to OverRideItem  
INSERT INTO OverRideItem (intIntervalDays)    
SELECT 0    
  
--Capture the OverRideItem_id so we can insert it into ScheduledMailing    
SELECT @ORI=SCOPE_IDENTITY()    
    
IF @@ERROR<>0     
BEGIN    
 ROLLBACK TRANSACTION    
 SELECT -1    
END    
    
--Schedule the regeneration  
INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, Methodology_id, datGenerate)    
SELECT MIN(ms.MailingStep_id), @SamplePopID, @ORI, schm.Methodology_id, GETDATE()    
FROM ScheduledMailing schm, MailingStep ms    
WHERE schm.SamplePop_id=@SamplePopID    
AND schm.Methodology_id=ms.Methodology_id    
AND ms.bitFirstSurvey=1    
GROUP BY schm.Methodology_id    
    
IF @@ERROR<>0     
BEGIN    
 ROLLBACK TRANSACTION    
 SELECT -1    
END    
    
--Log it    
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)    
SELECT @Litho,@DispositionID,GETDATE(),'Regenerate Form'    
    
IF @@ERROR<>0        
BEGIN        
 ROLLBACK TRAN        
 SELECT -1        
RETURN        
END        
  
--Need to log the disposition for reporting purposes    
SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName 
  
IF @@ERROR<>0        
BEGIN        
 ROLLBACK TRAN        
 SELECT -1        
RETURN        
END        
  
COMMIT TRANSACTION    
SELECT 1    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


