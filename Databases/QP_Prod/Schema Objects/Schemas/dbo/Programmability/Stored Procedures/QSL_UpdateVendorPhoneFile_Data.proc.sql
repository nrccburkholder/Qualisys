CREATE PROCEDURE [dbo].[QSL_UpdateVendorPhoneFile_Data]
@VendorFile_Data_ID INT,
@VendorFile_ID INT,
@HCAHPSSamp INT,
@Litho VARCHAR(10),
@Survey_ID INT,
@Sampleset_ID INT,
@Phone VARCHAR(10),
@AltPhone VARCHAR(10),
@FName VARCHAR(42),
@LName VARCHAR(42),
@Addr VARCHAR(42),
@Addr2 VARCHAR(42),
@City VARCHAR(42),
@St VARCHAR(2),
@Zip5 VARCHAR(5),
@PhServDate DATETIME,
@LangID INT,
@Telematch VARCHAR(15),
@PhFacName VARCHAR(100),
@PhServInd1 VARCHAR(100),
@PhServInd2 VARCHAR(100),
@PhServInd3 VARCHAR(100),
@PhServInd4 VARCHAR(100),
@PhServInd5 VARCHAR(100),
@PhServInd6 VARCHAR(100),
@PhServInd7 VARCHAR(100),
@PhServInd8 VARCHAR(100),
@PhServInd9 VARCHAR(100),
@PhServInd10 VARCHAR(100),
@PhServInd11 VARCHAR(100),
@PhServInd12 VARCHAR(100),
@Province VARCHAR(2) = null,
@PostalCode VARCHAR(7) = null,
@AgeRange VARCHAR(10) = NULL
AS

SET NOCOUNT ON

UPDATE [dbo].VendorPhoneFile_Data SET
	VendorFile_ID = @VendorFile_ID,
	HCAHPSSamp = @HCAHPSSamp,
	Litho = @Litho,
	Survey_ID = @Survey_ID,
	Sampleset_ID = @Sampleset_ID,
	Phone = @Phone,
	AltPhone = @AltPhone,
	FName = @FName,
	LName = @LName,
	Addr = @Addr,
	Addr2 = @Addr2,
	City = @City,
	St = @St,
	Zip5 = @Zip5,
	PhServDate = @PhServDate,
	LangID = @LangID,
	Telematch = @Telematch,
	PhFacName = @PhFacName,
	PhServInd1 = @PhServInd1,
	PhServInd2 = @PhServInd2,
	PhServInd3 = @PhServInd3,
	PhServInd4 = @PhServInd4,
	PhServInd5 = @PhServInd5,
	PhServInd6 = @PhServInd6,
	PhServInd7 = @PhServInd7,
	PhServInd8 = @PhServInd8,
	PhServInd9 = @PhServInd9,
	PhServInd10 = @PhServInd10,
	PhServInd11 = @PhServInd11,
	PhServInd12 = @PhServInd12,
	Province = @Province,
	PostalCode = @PostalCode,
	AgeRange = @AgeRange
WHERE VendorFile_Data_ID = @VendorFile_Data_ID

SET NOCOUNT OFF



