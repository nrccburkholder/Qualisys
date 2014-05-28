CREATE PROCEDURE [dbo].[QSL_SaveDispositionToQualiSys]  
@LithoCodeID INT,  
@VendorDispositionID INT,  
@LithoCode VARCHAR(10),  
@SentMailID INT,  
@SamplePopID INT,  
@DispositionDate DATETIME,  
@ReceiptTypeID INT,  
@UserName VARCHAR(42),  
@DispositionID INT,  
@ActionID INT,  
@IsFinal BIT  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
  
DECLARE @VendorID INT  
DECLARE @SurveyDataLoadID INT  
  
SELECT @SurveyDataLoadID = lc.SurveyDataLoad_ID, @VendorID = dl.Vendor_ID  
FROM DL_LithoCodes lc, DL_SurveyDataLoad sd, DL_DataLoad dl  
WHERE lc.SurveyDataLoad_ID = sd.SurveyDataLoad_ID  
  AND sd.DataLoad_ID = dl.DataLoad_ID  
  AND lc.DL_LithoCode_ID = @LithoCodeID  
  
--Check to see if this disposition already exists  
IF NOT EXISTS(SELECT * FROM DispositionLog WHERE SentMail_id = @SentMailID AND Disposition_id = @DispositionID AND datLogged = @DispositionDate)  
BEGIN  
  
 --Determine which procedure to call based on the action  
 IF @ActionID = 1  --Take Off Call List  
 BEGIN  
  EXEC QSL_TakeOffCallList @SentMailID, @SamplePopID, @DispositionID, @DispositionDate, @ReceiptTypeID, @UserName  
 END  
 ELSE IF @ActionID = 5 --Cancel Mailings  
 BEGIN  
  EXEC QSL_DeleteFutureMailings @SentMailID, @SamplePopID, @DispositionID, @DispositionDate, @ReceiptTypeID, @UserName  
 END  
 ELSE     --All Others  
 BEGIN  
  EXEC QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @UserName, @DispositionDate  
 END  
END  
  
IF NOT EXISTS(SELECT * FROM VendorDispositionLog WHERE VendorDisposition_ID = @VendorDispositionID AND DL_LithoCode_ID = @LithoCodeID AND DispositionDate = @DispositionDate)  
BEGIN  
 --Insert this record into the VendorDispositionLog  
 INSERT INTO VendorDispositionLog (Vendor_ID, DL_LithoCode_ID, DispositionDate, VendorDisposition_ID, DateCreated, SurveyDataLoad_ID, IsFinal)  
 VALUES (@VendorID, @LithoCodeID, @DispositionDate, @VendorDispositionID, GetDate(), @SurveyDataLoadID, @IsFinal)  
END
ELSE
BEGIN
  --this is a rare case where the isfinal dispostion is manually reloaded via a file loaded twice but in
  --the second file the same disposition is marked final (and was previously a 0)
  UPDATE VendorDispositionLog set IsFinal = @IsFinal
  WHERE VendorDisposition_ID = @VendorDispositionID AND DL_LithoCode_ID = @LithoCodeID AND DispositionDate = @DispositionDate
END

SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF


