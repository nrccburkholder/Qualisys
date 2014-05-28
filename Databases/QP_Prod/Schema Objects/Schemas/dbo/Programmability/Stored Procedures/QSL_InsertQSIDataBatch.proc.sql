CREATE PROCEDURE [dbo].[QSL_InsertQSIDataBatch]
    @Locked        BIT,
    @DateEntered   DATETIME,
    @EnteredBy     VARCHAR(50),
    @DateFinalized DATETIME,
    @FinalizedBy   VARCHAR(50)
AS

--Setup the environment
SET NOCOUNT ON

--Insert the new batch
INSERT INTO [dbo].QSIDataBatch (Locked, DateEntered, EnteredBy, DateFinalized, FinalizedBy)
VALUES (@Locked, @DateEntered, @EnteredBy, @DateFinalized, @FinalizedBy)

--Return the batch_id
SELECT SCOPE_IDENTITY()

--Reset the environment
SET NOCOUNT OFF


