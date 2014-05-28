CREATE PROCEDURE [dbo].[QCL_SelectDisposition]
@Disposition_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Disposition_id, strDispositionLabel, Action_id, strReportLabel, MustHaveResults
FROM [dbo].Disposition
WHERE Disposition_id = @Disposition_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


