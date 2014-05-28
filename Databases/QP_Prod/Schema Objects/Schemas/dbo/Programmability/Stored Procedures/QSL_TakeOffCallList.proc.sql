CREATE PROCEDURE [dbo].[QSL_TakeOffCallList]
@SentMailID INT,
@SamplePopID INT,
@DispositionID INT,
@DispositionDate DATETIME,
@ReceiptTypeID INT,
@UserName VARCHAR(42)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

DECLARE @StudyID INT
DECLARE @PopID INT

--Get the Study and Pop IDs
SELECT @StudyID = Study_id, @PopID = Pop_id
FROM SamplePop
WHERE SamplePop_id = @SamplePopID

--Add this to the TOCL table
IF NOT EXISTS(SELECT * FROM TOCL WHERE Study_id = @StudyID AND Pop_id = @PopID)
BEGIN
    INSERT INTO TOCL (Study_id, Pop_id, datTOCL_dat)
    VALUES (@StudyID, @PopID, @DispositionDate)
END

--Insert the disposition
EXEC dbo.QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @UserName, @DispositionDate

SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


