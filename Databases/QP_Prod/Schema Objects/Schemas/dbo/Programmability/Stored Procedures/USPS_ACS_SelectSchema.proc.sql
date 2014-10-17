/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectSchema]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USPS_ACS_SelectSchema]
	@recordtype varchar(1),
	@version varchar(2)
AS
BEGIN

	DECLARE @schema_id int

	SELECT @schema_id = [USPS_ACS_Schema_ID]
	  FROM [dbo].[USPS_ACS_Schemas]
	  WHERE FileVersion = @version
	  

	SELECT [USPS_ACS_Schema_ID]
		  ,[SchemaName]
		  ,[FileVersion]
		  ,[DetailRecordIndicator]
		  ,[RecordLength]
		  ,[ExpiryDate]
	  FROM [dbo].[USPS_ACS_Schemas]
	  WHERE [USPS_ACS_Schema_ID] = @schema_id

	SELECT [USPS_ACS_SchemaMapping_ID]
		  ,[USPS_ACS_Schema_ID]
		  ,[RecordType]
		  ,[DataType]
		  ,[ColumnName]
		  ,[ColumnStart]
		  ,[ColumnWidth]
	  FROM [dbo].[USPS_ACS_SchemaMapping]
	  WHERE [USPS_ACS_Schema_ID] = @schema_id
	  AND RecordType = @recordtype

END


GO