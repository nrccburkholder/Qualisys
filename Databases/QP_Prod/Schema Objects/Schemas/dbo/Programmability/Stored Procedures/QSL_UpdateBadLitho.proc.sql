CREATE PROCEDURE [dbo].[QSL_UpdateBadLitho]
@BadLitho_ID INT,
@DataLoad_ID INT,
@BadstrLithoCode VARCHAR(50),
@DateCreated DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].DL_BadLithos SET
	DataLoad_ID = @DataLoad_ID,
	BadstrLithoCode = @BadstrLithoCode,
	DateCreated = @DateCreated
WHERE BadLitho_ID = @BadLitho_ID

SET NOCOUNT OFF


