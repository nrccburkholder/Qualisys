/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectExtractFilesByStatus]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USPS_ACS_SelectExtractFilesByStatus]
	@status varchar(20) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT efl.[USPS_ACS_ExtractFileLog_ID]
		  ,[FileName]
		  ,[FilePath]
		  ,[Version]
		  ,[DetailRecordIndicator]
		  ,[CustomerID]
		  ,[RecordCount]
		  ,[HeaderDate]
		  ,[HeaderText]
		  ,[ZipFileName]
		  ,efl.[Status]
	  FROM [dbo].[USPS_ACS_ExtractFileLog] efl
	  WHERE @status is null or efl.[Status] = @status
END

GO