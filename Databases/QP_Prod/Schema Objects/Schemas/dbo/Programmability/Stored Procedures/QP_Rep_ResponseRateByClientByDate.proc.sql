-- =============================================
-- Author:			Hui Holay
-- Create date:	02-22-2007
-- Description:		
-- =============================================
-- Revision
-- =============================================
CREATE PROCEDURE [dbo].[QP_Rep_ResponseRateByClientByDate]
	@Associate VARCHAR(42),
	@Client VARCHAR(42),
	@FirstDay DATETIME,
	@LastDay DATETIME
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;

	DECLARE @ClientID INT

	SELECT @LastDay=DATEADD(DAY,1,@LastDay)

	SELECT @ClientID = Client_id FROM Client 
	WHERE strClient_nm = @Client

	EXEC datamart.QP_Comments.dbo.RR_ResponseRateByClientByDate @ClientID, @FirstDay, @LastDay
END


