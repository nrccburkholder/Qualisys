CREATE PROCEDURE [dbo].[QCL_InsertToBeSeeded]
    @Survey_id     INT,
    @IsSeeded      BIT,
    @datSeeded     DATETIME,
    @SurveyType_id INT,
    @YearQtr       VARCHAR(6)
AS

SET NOCOUNT ON

INSERT INTO [dbo].ToBeSeeded (Survey_id, IsSeeded, datSeeded, SurveyType_id, YearQtr)
VALUES (@Survey_id, @IsSeeded, @datSeeded, @SurveyType_id, @YearQtr)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


