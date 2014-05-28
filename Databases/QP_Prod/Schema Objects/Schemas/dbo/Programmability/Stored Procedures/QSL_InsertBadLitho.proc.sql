CREATE PROCEDURE [dbo].[QSL_InsertBadLitho]
@DataLoad_ID INT,
@BadstrLithoCode VARCHAR(50),
@DateCreated DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_BadLithos (DataLoad_ID, BadstrLithoCode, DateCreated)
VALUES (@DataLoad_ID, @BadstrLithoCode, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


