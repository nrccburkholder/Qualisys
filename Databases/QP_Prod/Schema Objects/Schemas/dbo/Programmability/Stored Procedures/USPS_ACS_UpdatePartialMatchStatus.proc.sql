CREATE PROCEDURE USPS_ACS_UpdatePartialMatchStatus
	@Id as int
	,@status as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE [dbo].[USPS_ACS_ExtractFile_PartialMatch]
	   SET[UpdateStatus] = @status
		  ,[DateUpdated] = Getdate()
	 WHERE USPS_ACS_ExtractFile_PartialMatch_id = @Id


END
GO