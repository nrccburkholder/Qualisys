/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertExtractFileRecord]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_InsertExtractFileRecord]
	@ExtractFileLog_Id int,
	@RecordText varchar(1000),
	@FName varchar(15),
	@LName varchar(20),
	@PrimaryNumberOld varchar(10),
	@PreDirectionalOld varchar(2),
	@StreetNameOld varchar(28),
	@StreetSuffixOld varchar(4),
	@PostDirectionalOld varchar(2),
	@UnitDesignatorOld varchar(4),
	@SecondaryNumberOld varchar(10),
	@CityOld varchar(28),
	@StateOld varchar(2),
	@Zip5Old varchar(5),
	@PrimaryNumberNew varchar(10),
	@PreDirectionalNew varchar(2),
	@StreetNameNew varchar(28),
	@StreetSuffixNew varchar(4),
	@PostDirectionalNew varchar(2),
	@UnitDesignatorNew varchar(4),
	@SecondaryNumberNew varchar(10),
	@CityNew varchar(28),
	@StateNew varchar(2),
	@Zip5New varchar(5),
	@Plus4ZipNew varchar(4),
	@AddressNew varchar(66),
	@Address2New varchar(14)

AS
BEGIN

	DECLARE @ExtractFileRecord_Id int

	INSERT INTO [dbo].[USPS_ACS_ExtractFile]
           ([USPS_ACS_ExtractFileLog_ID]
           ,[RecordText]
           ,[Status]
		   ,[DateCreated])
     VALUES
           (@ExtractFileLog_Id
           ,@RecordText
           ,'New'
		   ,GETDATE())

	SET @ExtractFileRecord_Id = SCOPE_IDENTITY()

	IF @AddressNew <> 'TEMPORARILY AWAY'
	BEGIN
		INSERT INTO [dbo].[USPS_ACS_ExtractFile_Work]
			   ([USPS_ACS_ExtractFile_ID]
			   ,[FName]
			   ,[LName]
			   ,[PrimaryNumberOld]
			   ,[PreDirectionalOld]
			   ,[StreetNameOld]
			   ,[StreetSuffixOld]
			   ,[PostDirectionalOld]
			   ,[UnitDesignatorOld]
			   ,[SecondaryNumberOld]
			   ,[CityOld]
			   ,[StateOld]
			   ,[Zip5Old]
			   ,[PrimaryNumberNew]
			   ,[PreDirectionalNew]
			   ,[StreetNameNew]
			   ,[StreetSuffixNew]
			   ,[PostDirectionalNew]
			   ,[UnitDesignatorNew]
			   ,[SecondaryNumberNew]
			   ,[CityNew]
			   ,[StateNew]
			   ,[Zip5New]  
			   ,[Plus4ZipNew]
			   ,[AddressNew]
			   ,[Address2New])
		 VALUES
			   (@ExtractFileRecord_Id
			    ,@FName
			    ,@LName
				,@PrimaryNumberOld
				,@PreDirectionalOld
				,@StreetNameOld
				,@StreetSuffixOld
				,@PostDirectionalOld
				,@UnitDesignatorOld
				,@SecondaryNumberOld
				,@CityOld
				,@StateOld
				,@Zip5Old
				,@PrimaryNumberNew
				,@PreDirectionalNew
				,@StreetNameNew
				,@StreetSuffixNew
				,@PostDirectionalNew
				,@UnitDesignatorNew
				,@SecondaryNumberNew
				,@CityNew
				,@StateNew
				,@Zip5New
				,@Plus4ZipNew
				,@AddressNew
				,@Address2New)

	END
	ELSE
	BEGIN
		UPDATE [USPS_ACS_ExtractFile]
		SET [Status] = 'TEMPORAILY AWAY'
		where USPS_ACS_ExtractFile_ID =@ExtractFileRecord_Id
	END


END
GO