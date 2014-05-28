CREATE PROCEDURE [dbo].[QSL_UpdateQSIDataBatch]
    @Batch_ID      INT,
    @Locked        BIT,
    @DateEntered   DATETIME,
    @EnteredBy     VARCHAR(50),
    @DateFinalized DATETIME,
    @FinalizedBy   VARCHAR(50)
AS

--Setup the environment
SET NOCOUNT ON

--Update the batch
UPDATE [dbo].QSIDataBatch SET
	Locked = @Locked,
	DateEntered = @DateEntered,
	EnteredBy = @EnteredBy,
	DateFinalized = @DateFinalized,
	FinalizedBy = @FinalizedBy
WHERE Batch_ID = @Batch_ID

--Reset the environment
SET NOCOUNT OFF


