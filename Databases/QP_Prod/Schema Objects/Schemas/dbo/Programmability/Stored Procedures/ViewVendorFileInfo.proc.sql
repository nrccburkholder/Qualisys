CREATE proc ViewVendorFileInfo (@VendorFile_ID int = 0)    
as    
begin    
  
if @vendorFile_ID = 0  
 begin  
  select * from VendorFileCreationQueue  
 end   
else  
 begin  
  select * From vendorfilecreationqueue where vendorFile_ID = @VendorFile_ID    
  select * From VendorFile_Freqs where vendorFile_ID = @VendorFile_ID    
  select * From VendorFile_NULLCounts where vendorFile_ID = @VendorFile_ID    
  select * From VendorFile_Messages where vendorFile_ID = @VendorFile_ID    
  select * From VendorphoneFile_Data where vendorFile_ID = @VendorFile_ID    
  select * From VendorWebFile_Data where vendorFile_ID = @VendorFile_ID    
  select * From VendorFile_TelematchLog where vendorFile_ID = @VendorFile_ID    
  select * From VendorFileTracking where vendorFile_ID = @VendorFile_ID    
 end  
end


