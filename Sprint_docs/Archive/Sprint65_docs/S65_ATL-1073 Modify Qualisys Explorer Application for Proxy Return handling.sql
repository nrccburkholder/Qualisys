/*

S65_ATL-1073 Modify Qualisys Explorer Application for Proxy Return handling.sql

Chris Burkholder

12/28/2016

CREATE PROCEDURE [dbo].[QCL_LogDispositionByLitho] 

*/

CREATE PROCEDURE [dbo].[QCL_LogDispositionByLitho] 
 @Litho VARCHAR(20), 
 @DispositionID INT,  
 @ReceiptTypeID INT,
 @UserName VARCHAR(42)  
AS  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/********************************************************************************************************/  
/*                       										*/  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It writes the       */ 
/*   		     disposition to the DispositionLog table.							*/
/*                       										*/  
/* Date Created:  12/28/2016                  								*/  
/*                       										*/  
/* Created by:  Chris Burkholder               								*/  
/*                       										*/  
/********************************************************************************************************/  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRANSACTION  
  
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

