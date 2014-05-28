CREATE PROCEDURE [dbo].[QCL_DeleteSamplePeriod]
@PeriodDef_id INT
AS

SET NOCOUNT ON

BEGIN TRAN
DELETE [dbo].PeriodDates
WHERE PeriodDef_id = @PeriodDef_id
IF @@ERROR>0 ROLLBACK TRAN

DELETE [dbo].PeriodDef
WHERE PeriodDef_id = @PeriodDef_id
IF @@ERROR>0 ROLLBACK TRAN

COMMIT TRAN

SET NOCOUNT OFF


