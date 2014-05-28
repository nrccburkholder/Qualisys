CREATE PROCEDURE [dbo].[QSL_UpdateVendorWebFile_Data]
@VendorWebFile_Data_ID INT,
@VendorFile_ID INT,
@Survey_ID INT,
@Sampleset_ID INT,
@Litho VARCHAR(50),
@WAC VARCHAR(50),
@FName VARCHAR(42),
@LName VARCHAR(42),
@LangID INT,
@EmailAddr VARCHAR(100),
@WbServDate DATETIME,
@wbServInd1 VARCHAR(100),
@wbServInd2 VARCHAR(100),
@wbServInd3 VARCHAR(100),
@wbServInd4 VARCHAR(100),
@wbServInd5 VARCHAR(100),
@wbServInd6 VARCHAR(100),
@ExternalRespondentID VARCHAR(100),
@bitSentToVendor BIT
AS

SET NOCOUNT ON

UPDATE [dbo].VendorWebFile_Data SET
	VendorFile_ID = @VendorFile_ID,
	Survey_ID = @Survey_ID,
	Sampleset_ID = @Sampleset_ID,
	Litho = @Litho,
	WAC = @WAC,
	FName = @FName,
	LName = @LName,
	LangID = @LangID,
	Email_Address = @EmailAddr,
	WbServDate = @WbServDate,
	wbServInd1 = @wbServInd1,
	wbServInd2 = @wbServInd2,
	wbServInd3 = @wbServInd3,
	wbServInd4 = @wbServInd4,
	wbServInd5 = @wbServInd5,
	wbServInd6 = @wbServInd6,
	ExternalRespondentID = @ExternalRespondentID,
	bitSentToVendor = @bitSentToVendor
WHERE VendorWebFile_Data_ID = @VendorWebFile_Data_ID

SET NOCOUNT OFF


