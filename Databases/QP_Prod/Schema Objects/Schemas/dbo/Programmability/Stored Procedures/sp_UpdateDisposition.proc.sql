CREATE PROCEDURE [dbo].[sp_UpdateDisposition]
@Disposition_id INT,
@strDispositionLabel VARCHAR(100),
@Action_id INT,
@strReportLabel VARCHAR(100),
@MustHaveResults BIT
AS

SET NOCOUNT ON

UPDATE [dbo].Disposition SET
	strDispositionLabel = @strDispositionLabel,
	Action_id = @Action_id,
	strReportLabel = @strReportLabel,
	MustHaveResults = @MustHaveResults
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF


