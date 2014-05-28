/********************************************************************************************************/  
/*                       										*/  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It adds the         */ 
/*   		     recipient to the TOCL table.							*/
/*                       										*/  
/* Date Created:  10/17/2005                  								*/  
/*                       										*/  
/* Created by:  Joe Camp                   								*/  
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table  		*/
/*                       										*/  
/********************************************************************************************************/  
CREATE PROCEDURE QCL_TakeOffCallList 
 @Litho VARCHAR(20), 
 @DispositionID INT,  
 @ReceiptTypeID INT,
 @UserName VARCHAR(42)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRANSACTION  
  
--Add to TOCL
INSERT INTO TOCL (Study_id, Pop_id, datTOCL_dat)  
SELECT Study_id, Pop_id, GETDATE()  
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp  
WHERE sm.strLithoCode=@Litho  
AND sm.SentMail_id=schm.SentMail_id  
AND schm.SamplePop_id=sp.SamplePop_id  
  
IF @@ERROR<>0  
BEGIN  
 ROLLBACK TRANSACTION  
 SELECT -1  
 RETURN  
END  
  
--Log it  
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)  
SELECT @Litho,@DispositionID,GETDATE(),'Added to TOCL'  
  
IF @@ERROR<>0  
BEGIN  
 ROLLBACK TRANSACTION  
 SELECT -1  
 RETURN  
END  

--Log it to dispositionlog for reporting purposes

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


