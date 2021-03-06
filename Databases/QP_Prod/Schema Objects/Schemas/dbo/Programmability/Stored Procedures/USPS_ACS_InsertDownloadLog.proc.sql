USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertDownloadLog]    Script Date: 12/10/2014 12:17:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USPS_ACS_InsertDownloadLog]
	@Key varchar(20), 
	@FileId varchar(20),
	@FileName varchar(255), 
	@Size varchar(20), 
	@Code varchar(20), 
	@Name varchar(50), 
	@FulfilledDate varchar(10), 
	@ModifiedDate varchar(10), 
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
