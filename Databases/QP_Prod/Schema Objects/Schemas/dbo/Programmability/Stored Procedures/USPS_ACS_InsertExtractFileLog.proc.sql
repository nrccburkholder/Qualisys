/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertExtractFileLog]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_InsertExtractFileLog]
	@FileName varchar(255),
	@FilePath varchar(255),
	@Version varchar(2),
	@DetailRecordIndicator varchar(1),
	@CustomerID varchar(6),
	@RecordCount varchar(9),
	@CreatedDate varchar(8),
	@HeaderText varchar(1000),
	@ZipFileName varchar(255),
	@Status varchar(20)
AS
BEGIN


	INSERT INTO [dbo].[USPS_ACS_ExtractFileLog]
           ([FileName]
           ,[FilePath]
           ,[Version]
           ,[DetailRecordIndicator]
           ,[CustomerID]
           ,[RecordCount]
           ,[HeaderDate]
		   ,[HeaderText]
		   ,[ZipFileName]
           ,[Status]
		   ,[DateCreated])
     VALUES
           (@FileName
           ,@FilePath
           ,@Version
           ,@DetailRecordIndicator
           ,@CustomerID
           ,@RecordCount
           ,@CreatedDate
		   ,@HeaderText
		   ,@ZipFileName
           ,@Status
		   ,GETDATE())

END
GO