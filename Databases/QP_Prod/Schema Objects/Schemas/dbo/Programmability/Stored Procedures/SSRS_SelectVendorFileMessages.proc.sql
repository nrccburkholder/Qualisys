create proc SSRS_SelectVendorFileMessages (@VendorFile_ID int)
as
begin

	Select VendorFile_Message_ID,VendorFile_ID,VendorFile_MessageType_ID,Message
	from vendorfile_Messages 
	where VendorFile_ID = @VendorFile_ID
	order by VendorFile_MessageType_ID, Message

end


