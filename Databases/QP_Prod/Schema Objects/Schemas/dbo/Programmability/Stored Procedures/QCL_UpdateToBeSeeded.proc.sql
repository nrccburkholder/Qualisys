CREATE PROCEDURE [dbo].[QCL_UpdateToBeSeeded]
    @Seed_id       INT,
    @Survey_id     INT,
    @IsSeeded      BIT,
    @datSeeded     DATETIME,
    @SurveyType_id INT,
    @YearQtr       VARCHAR(6)
AS

SET NOCOUNT ON

UPDATE [dbo].ToBeSeeded 
SET	Survey_id = @Survey_id,
    IsSeeded = @IsSeeded,
    datSeeded = @datSeeded,
    SurveyType_id = @SurveyType_id,
    YearQtr = @YearQtr
WHERE Seed_id = @Seed_id

SET NOCOUNT OFF


