/****** Object:  StoredProcedure [dbo].[USPS_ACS_UpdateDownloadLogStatus]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_UpdateDownloadLogStatus]
	@filename varchar(255),
	@status varchar(20)
AS
BEGIN

	UPDATE [dbo].[USPS_ACS_DownloadLog]
	   SET [Status] = @Status,
	       [DateModified] = GETDATE()
	 WHERE [FileName] = @filename

END
GO