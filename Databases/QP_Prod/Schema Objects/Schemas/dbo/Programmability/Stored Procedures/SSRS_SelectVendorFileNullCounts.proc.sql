create proc SSRS_SelectVendorFileNullCounts (@VendorFile_ID int)
as
begin

	Select VendorFile_NULLCounts_id,VendorFile_ID,Field_id,strField_nm,Occurrences
	from vendorfile_NullCounts 
	where VendorFile_ID = @VendorFile_ID
	order by strField_nm, Occurrences

end


