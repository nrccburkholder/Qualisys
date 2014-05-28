CREATE PROCEDURE [dbo].[QSL_InsertVendorWebFile_Data]
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

INSERT INTO [dbo].VendorWebFile_Data (VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LName, LangID, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor)
VALUES (@VendorFile_ID, @Survey_ID, @Sampleset_ID, @Litho, @WAC, @FName, @LName, @LangID, @EmailAddr, @WbServDate, @wbServInd1, @wbServInd2, @wbServInd3, @wbServInd4, @wbServInd5, @wbServInd6, @ExternalRespondentID, @bitSentToVendor)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


