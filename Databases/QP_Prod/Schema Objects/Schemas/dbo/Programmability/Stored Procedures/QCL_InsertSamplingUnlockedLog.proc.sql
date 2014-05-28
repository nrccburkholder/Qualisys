CREATE PROCEDURE [dbo].[QCL_InsertSamplingUnlockedLog]
@MedicareNumber Varchar(20),
@MemberID INT,
@DateUnlocked DATETIME
AS

SET NOCOUNT ON

INSERT INTO dbo.SamplingUnlocked_log (MedicareNumber, MemberID, DateUnlocked)
VALUES (@MedicareNumber, @MemberID, @DateUnlocked)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


