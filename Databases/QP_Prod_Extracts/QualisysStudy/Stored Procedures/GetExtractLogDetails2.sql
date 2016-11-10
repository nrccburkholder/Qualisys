CREATE PROCEDURE [QualisysStudy].[GetExtractLogDetails2]
	@ExtractLogID INT
AS
BEGIN

SET NOCOUNT ON;
EXEC [QualisysStudy].[AddExtractLogDetails] @ExtractLogID

	SELECT AuditLogText
	FROM [QualisysStudy].tempAuditLog

	

END
