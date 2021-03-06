---------------------------------------------------------------------------------------
--QSL_DeleteFutureMailings
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteFutureMailings]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteFutureMailings]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteFutureMailings]
@SentMailID INT,
@SamplePopID INT,
@DispositionID INT,
@DispositionDate DATETIME,
@ReceiptTypeID INT,
@UserName VARCHAR(42)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

--Update the undeliverable date
UPDATE SentMailing 
SET datUndeliverable = @DispositionDate
WHERE SentMail_id = @SentMailID

--Delete any ungenerated steps for this samplepop_id    
DELETE ScheduledMailing    
WHERE SamplePop_id = @SamplePopID    
  AND SentMail_id IS NULL    

--Insert the disposition
EXEC dbo.QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @UserName, @DispositionDate

SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF
GO
