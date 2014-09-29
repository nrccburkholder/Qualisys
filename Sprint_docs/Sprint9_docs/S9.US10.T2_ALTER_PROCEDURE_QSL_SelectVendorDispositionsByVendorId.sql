USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QSL_SelectVendorDispositionsByVendorId]    Script Date: 9/29/2014 11:01:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QSL_SelectVendorDispositionsByVendorId]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorDisposition_ID
	, Vendor_ID, Disposition_ID
	, VendorDispositionCode
	, VendorDispositionLabel
	, VendorDispositionDesc
	, DateCreated
	, isFinal
FROM VendorDispositions
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
