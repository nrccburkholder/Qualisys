﻿CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileOutgoTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFileOutgoType_ID, OutgoType_nm, OutgoType_desc, FileExtension
FROM [dbo].VendorFileOutgoTypes

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


