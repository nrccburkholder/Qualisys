/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertDownloadLog]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_InsertDownloadLog]
	@Key varchar(20), 
	@FileId varchar(20),
	@FileName varchar(255), 
	@Size varchar(20), 
	@Code varchar(20), 
	@Name varchar(50), 
	@FulfilledDate varchar(8), 
	@ModifiedDate varchar(8), 
	@URL varchar(255),
	@Status varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	INSERT INTO [dbo].[USPS_ACS_DownloadLog]
			   ([Key]
			   ,[FileId]
			   ,[FileName]
			   ,[Size]
			   ,[Code]
			   ,[Name]
			   ,[FulfilledDate]
			   ,[ModifiedDate]
			   ,[URL]
			   ,[Status]
			   ,[DateCreated])
		 VALUES
			   (@Key
			   ,@FileId
			   ,@FileName
			   ,@Size
			   ,@Code
			   ,@Name
			   ,@FulfilledDate
			   ,@ModifiedDate
			   ,@URL
			   ,@Status
			   ,GETDATE())

END

GO