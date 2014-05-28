CREATE PROCEDURE [dbo].[QSL_InsertVendorPhoneFile_Data]
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
@PhServInd12 VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorPhoneFile_Data (VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12)
VALUES (@VendorFile_ID, @HCAHPSSamp, @Litho, @Survey_ID, @Sampleset_ID, @Phone, @AltPhone, @FName, @LName, @Addr, @Addr2, @City, @St, @Zip5, @PhServDate, @LangID, @Telematch, @PhFacName, @PhServInd1, @PhServInd2, @PhServInd3, @PhServInd4, @PhServInd5, @PhServInd6, @PhServInd7, @PhServInd8, @PhServInd9, @PhServInd10, @PhServInd11, @PhServInd12)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


