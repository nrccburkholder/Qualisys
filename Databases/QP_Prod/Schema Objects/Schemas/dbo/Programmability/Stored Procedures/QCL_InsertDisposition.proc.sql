CREATE PROCEDURE [dbo].[QCL_InsertDisposition]
@strDispositionLabel VARCHAR(100),
@Action_id INT,
@strReportLabel VARCHAR(100),
@MustHaveResults BIT
AS

SET NOCOUNT ON

INSERT INTO [dbo].Disposition (strDispositionLabel, Action_id, strReportLabel, MustHaveResults)
VALUES (@strDispositionLabel, @Action_id, @strReportLabel, @MustHaveResults)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


