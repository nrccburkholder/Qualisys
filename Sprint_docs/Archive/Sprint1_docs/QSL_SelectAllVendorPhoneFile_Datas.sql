USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QSL_SelectAllVendorPhoneFile_Datas]    Script Date: 3/13/2014 9:50:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QSL_SelectAllVendorPhoneFile_Datas]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*
	Modified:  03/13/2014 TSB -- to be country-aware for CA Qualisys Upgrade, Phone Vendor File data, requirement #13
*/

DECLARE @Country as varchar(2)

SELECT @Country = strParam_Value
FROM QualPro_Params 
WHERE strParam_nm='Country'

IF @Country = 'CA'
BEGIN
	SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, Province, PostalCode, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
	FROM [dbo].VendorPhoneFile_Data
END
ELSE
BEGIN
	SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
	FROM [dbo].VendorPhoneFile_Data
END

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
