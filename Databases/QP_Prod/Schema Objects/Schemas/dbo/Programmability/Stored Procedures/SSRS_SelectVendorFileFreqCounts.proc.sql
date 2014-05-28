create proc SSRS_SelectVendorFileFreqCounts (@VendorFile_ID int)
as
begin


	Select	vf.VendorFile_Freqs_id,vf.VendorFile_ID,vf.Field_id,vf.strField_nm,vf.strValue,vf.Occurrences, 
			va.TotalCount, ((va.TotalCount * 1.00) / vf.Occurrences) as Percentage
			--va.TotalCount, cast(((va.TotalCount * 1.00) / vf.Occurrences) as double) as  Percentage 
	from	vendorfile_freqs vf,
			(select strField_nm, sum(Occurrences) TotalCount from vendorfile_freqs where VendorFile_ID = @VendorFile_ID group by strfield_nm) va
	where	vf.strfield_nm = va.strfield_nm and
			VendorFile_ID = @VendorFile_ID 

end


