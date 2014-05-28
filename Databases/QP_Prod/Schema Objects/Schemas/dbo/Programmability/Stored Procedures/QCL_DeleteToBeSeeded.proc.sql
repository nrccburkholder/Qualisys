CREATE PROCEDURE [dbo].[QCL_DeleteToBeSeeded]
    @Seed_id INT
AS

SET NOCOUNT ON

DELETE [dbo].ToBeSeeded
WHERE Seed_id = @Seed_id

SET NOCOUNT OFF


