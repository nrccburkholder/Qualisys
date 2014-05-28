CREATE PROCEDURE [dbo].[QCL_DeleteMedicareRecalc_History]
@MedicareReCalcLog_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].MedicareRecalc_History
WHERE MedicareReCalcLog_ID = @MedicareReCalcLog_ID

SET NOCOUNT OFF


