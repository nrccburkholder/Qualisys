/****** Object:  Stored Procedure dbo.QCL_LogDisposition Script Date: 8/22/06 ******/
/************************************************************************************************/
/*            											*/
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It inserts  */
/*            into the DispositionLog, and is the central procedure for that function, but is	*/
/* 		      is called from many other diposition procedures.			                       	*/
/* Date Created:  08/22/2006           								                            */
/*            											                                        */
/* Created by:  Steve Spicka									                                */
/*            											                                        */
/************************************************************************************************/
CREATE PROCEDURE [dbo].[QCL_LogDisposition]
  @SentMailID    INT,
  @SamplePopID   INT,
  @DispositionID INT,
  @ReceiptTypeID INT,
  @UserName      VARCHAR(42),
  @datLogged     DATETIME = NULL
AS
  IF @datLogged IS NULL
    SET @datLogged = GETDATE()

  --Lee Kohrs 2013-07-16: HCAHPS2012 Audit TR#3: Added code to default bitExtracted to 0
  INSERT INTO DispositionLog
              (SentMail_id,
               SamplePop_id,
               Disposition_id,
               ReceiptType_id,
               datLogged,
               LoggedBy,
               bitExtracted)
  SELECT @SentMailID,
         @SamplePopID,
         @DispositionID,
         @ReceiptTypeID,
         @datLogged,
         @UserName,
         0

  UPDATE DispositionLog
  SET    DaysFromFirst = dbo.fn_DispDaysFromFirst(@SentMailID, @datLogged, @DispositionID),
         DaysFromCurrent = dbo.fn_DispDaysFromCurrent(@SentMailID, @datLogged, @DispositionID)
  WHERE  SentMail_id = @SentMailID
         AND Disposition_id = @DispositionID
         AND datLogged = @datLogged


