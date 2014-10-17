/****** Object:  StoredProcedure [dbo].[USPS_ACS_UpdateExtractFileLogStatus]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_UpdateExtractFileLogStatus]
	@extractFileLog_id int,
	@status varchar(20)
AS
BEGIN

UPDATE [dbo].[USPS_ACS_ExtractFileLog]
   SET [Status] = @status
		,[DateModified] = GETDATE()
   WHERE USPS_ACS_ExtractFileLog_ID = @extractFileLog_id
END

GO