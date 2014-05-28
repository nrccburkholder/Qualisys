/****** Object:  Stored Procedure dbo.QCL_LogContactRequest       Script Date: 10/11/05 ******/
/************************************************************************************************/
/*            											*/
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It logs     */
/*            the contact request to the dispositionlog table.  The actual email is sent by	*/
/*            the application.									*/
/* Date Created:  10/11/2005           								*/
/*            											*/
/* Created by:  Brian Dohmen           								*/
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*            											*/
/************************************************************************************************/
CREATE PROCEDURE QCL_LogContactRequest 
 @Litho VARCHAR(20), 
 @DispositionID INT, 
 @Comment VARCHAR(256),
 @ReceiptTypeID INT,
 @UserName VARCHAR(42)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRAN

--Log it  
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)  
SELECT @Litho,@DispositionID,GETDATE(),'Contact: '+@Comment  

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
  
COMMIT TRAN
SELECT 1  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


