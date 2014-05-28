CREATE PROCEDURE [dbo].[QSL_PhoneVendorListSent]
	@Vendor_Id int = null
AS
BEGIN
  delete from PhoneVendorCancelListLog
  where (@Vendor_Id is null or (Vendor_ID = @Vendor_Id)) 
    and datSentToVendor is not null and DateDiff(week, datSentToVendor, getdate()) > 8

  update PhoneVendorCancelListLog set datSentToVendor = getdate()
  where (@Vendor_Id is null or (Vendor_ID = @Vendor_Id))
    and datSentToVendor is null
END


