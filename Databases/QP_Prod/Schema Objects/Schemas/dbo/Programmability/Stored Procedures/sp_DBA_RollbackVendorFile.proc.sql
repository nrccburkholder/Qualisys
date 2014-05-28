CREATE PROCEDURE sp_DBA_RollbackVendorFile @vendorFile_ID int
AS        
/*********************************************************************************
Name:		sp_DBA_RollbackVendorFile
Date:		1/15/10
Purpose:	Remove a Vendor file and all associated tables if a partial load occurs
			or if sp_dba_rollbackgeneration finds multiple occurances of a vendorFile_ID
*********************************************************************************/        


   BEGIN TRAN        
     PRINT 'VendorFile_Freqs'        
     DELETE VendorFile_Freqs          
     WHERE vendorFile_ID = @VendorFile_ID         
	
	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
        
               
     PRINT 'VendorFile_nullCounts'        
     DELETE VendorFile_nullCounts          
     WHERE vendorFile_ID = @VendorFile_ID         

	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
       
              
     PRINT 'VendorPhoneFile_data'        
     DELETE VendorPhoneFile_data          
     WHERE vendorFile_ID = @VendorFile_ID         
       
	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
                  
     PRINT 'VendorWebFile_data'        
     DELETE VendorWebFile_data          
     WHERE vendorFile_ID = @VendorFile_ID         
 
 	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
      
     PRINT 'VendorFile_Messages'        
     DELETE VendorFile_Messages          
     WHERE vendorFile_ID = @VendorFile_ID         

	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
        
     PRINT 'VendorFileTracking'        
     DELETE VendorFileTracking          
     WHERE vendorFile_ID = @VendorFile_ID         

	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
       
     PRINT 'VendorFile_TelematchLog'        
     DELETE VendorFile_TelematchLog          
     WHERE vendorFile_ID = @VendorFile_ID         

	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
         
     PRINT 'VendorFileCreationQueue'        
     DELETE VendorFileCreationQueue          
     WHERE vendorFile_ID = @VendorFile_ID         

	if @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	
	
	--if no errors have occured commit the delete.
	COMMIT TRAN


