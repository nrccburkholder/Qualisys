/****
S12.US23 USPS Partial and Multiple match resolution

T23.2	Develop as per the design session 

Tim Butler

CREATE PROCEDURE USPS_ACS_UpdatePartialMatchStatus


****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'USPS_ACS_UpdatePartialMatchStatus')
	DROP PROCEDURE dbo.USPS_ACS_UpdatePartialMatchStatus
GO

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
