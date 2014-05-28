CREATE PROCEDURE [dbo].[QSL_DeleteQSIDataBatch]
    @Batch_ID INT
AS

--Setup the environment
SET NOCOUNT ON

--Delete the results for all of the forms in the batch
DELETE FROM [dbo].QSIDataResults
WHERE Form_ID IN (SELECT df.Form_ID 
                  FROM [dbo].QSIDataBatch db, [dbo].QSIDataForm df
                  WHERE db.Batch_ID = df.Batch_ID
                    AND db.Batch_ID = @Batch_ID
                 )

--Clear the retun dates for the forms being deleted
UPDATE qf
SET datReturned = NULL, strScanBatch = NULL
FROM QSIDataForm df, QuestionForm qf
WHERE df.QuestionForm_ID = qf.QuestionForm_ID
  AND df.Batch_ID = @Batch_ID

--Delete all of the forms in the batch
DELETE FROM [dbo].QSIDataForm
WHERE Batch_ID = @Batch_ID

--Delete the batch
DELETE [dbo].QSIDataBatch
WHERE Batch_ID = @Batch_ID

--Reset the environment
SET NOCOUNT OFF


