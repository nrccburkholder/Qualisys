/*
S9.US10	HCAHPS Phone Lag Time Fix
		As an Authorized Vendor, we want to correctly calculate the lag time for phone non-response dispositions, so that we can report correct data to CMS

T10.3	Modify the dispositions processing in QSI transfer results services

Dave Gilsdorf

ALTER PROCEDURE [dbo].[QSL_SelectVendorDispositionsByVendorId]
*/
use qp_prod
go
begin tran
go
ALTER PROCEDURE [dbo].[QSL_SelectVendorDispositionsByVendorId]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorDisposition_ID, Vendor_ID, Disposition_ID, VendorDispositionCode, VendorDispositionLabel, VendorDispositionDesc, DateCreated, isFinal
FROM VendorDispositions
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
go
commit tran

