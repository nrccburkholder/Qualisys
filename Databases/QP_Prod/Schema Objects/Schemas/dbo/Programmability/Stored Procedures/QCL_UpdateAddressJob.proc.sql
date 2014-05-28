CREATE PROCEDURE QCL_UpdateAddressJob   
AS  
  
DECLARE @sql VARCHAR(8000), @Study VARCHAR(10), @Pop VARCHAR(20), @ACID INT          
DECLARE  @Litho VARCHAR(20),         
 @Disposition_id INT,         
 @Addr VARCHAR(42),         
 @Addr2 VARCHAR(42),         
 @City VARCHAR(42),          
 @Del_Pt CHAR(3),         
 @ST CHAR(2),         
 @Zip4 CHAR(4),         
 @ZIP5 CHAR(5),         
 @AddrStat VARCHAR(42),         
 @AddrErr VARCHAR(42),        
 @CountryID INT,        
 @Province VARCHAR(42),        
 @PostalCode VARCHAR(42),    
 @ReceiptTypeID INT,    
 @UserName VARCHAR(42)    
          
SELECT TOP 1 @ACID=AddressChange_id, @Litho=Litho, @Addr=ISNULL(Addr,''), @Addr2=ISNULL(Addr2,''), @City=ISNULL(City,''), @Del_Pt=ISNULL(Del_Pt,''),  
			@ST=ISNULL(ST,''), @Zip4=ISNULL(Zip4,''), @Zip5=ISNULL(Zip5,''), @AddrStat=ISNULL(AddrStat,''), @AddrErr=ISNULL(AddrErr,''),  
			@CountryID=ISNULL(CountryID,1), @Province=ISNULL(Province,''), @PostalCode=ISNULL(PostalCode,''),  
			@ReceiptTypeID=ReceiptTypeID, @UserName=UserName  
FROM tbl_QCL_AddressChange  
WHILE @@ROWCOUNT>0  
BEGIN -- Loop 1  
  
	--Need to get the study_id and the pop_id for the given litho  
	SELECT @Study=LTRIM(STR(Study_id)), @Pop=LTRIM(STR(Pop_id))          
	FROM SentMailing sm, ScheduledMailing schm, SamplePop sp          
	WHERE sm.strLithoCode=@Litho          
	AND sm.SentMail_id=schm.SentMail_id          
	AND schm.SamplePop_id=sp.SamplePop_id          
	  
	--Now to update the address fields in the population table  
	IF @CountryID=1        
	BEGIN -- Loop 2  
		 --Check to see if the Addr2 field is valid for the study.  If so, it becomes part of the update statement.  
		 IF EXISTS(SELECT * FROM MetaData_View WHERE Study_id=@Study AND strTable_nm='Population' AND strField_nm='Addr2')        
		 BEGIN   
		   SELECT @sql='UPDATE S'+@Study+'.Population           
			SET Addr='''+@Addr+''',  
			 Addr2='''+@Addr2+''',  
			 City='''+@City+''',  
			 Del_Pt='''+@Del_Pt+''',  
			 ST='''+@ST+''',  
			 Zip4='''+@Zip4+''',  
			 Zip5='''+@Zip5+''',  
			 AddrStat='''+@AddrStat+''',  
			 AddrErr='''+@AddrErr+'''  
			WHERE Pop_id='+@Pop  
		 END   
		 ELSE        
		  --No Addr2 field  
		  SELECT @sql='UPDATE S'+@Study+'.Population           
		   SET Addr='''+LEFT(@Addr+' '+@Addr2,42)+''',           
			City='''+@City+''',          
			Del_Pt='''+@Del_Pt+''',          
			ST='''+@ST+''',          
			Zip4='''+@Zip4+''',          
			Zip5='''+@Zip5+''',          
			AddrStat='''+@AddrStat+''',          
			AddrErr='''+@AddrErr+'''          
		   WHERE Pop_id='+@Pop          
		         
		 EXEC (@sql)          
		        
		 IF @@ERROR<>0          
		 BEGIN   
		  ROLLBACK TRAN          
		  SELECT -1          
		  RETURN          
		 END   
		        
		 --Log it          
		 INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)          
		 SELECT @Litho,@Disposition_id,GETDATE(),'Updated Address: '+          
		  ISNULL(@Addr,'')+' '+ISNULL(@Addr2,'')+' '+ISNULL(@City,'')+' '+          
		  ISNULL(@ST,'')+' '+ISNULL(@Zip5,'')+' '+ISNULL(@Zip4,'')+' '+          
		  ISNULL(@Del_pt,'')          
		           
		 IF @@ERROR<>0          
		 BEGIN          
		  ROLLBACK TRAN          
		  SELECT -1          
		  RETURN          
		 END          
	        
	END -- Loop 2        
	ELSE        
	--If Canadian, then this section will run.  It updates Province and Postal_Code instead of State and Zip.  
		BEGIN -- Loop 3  
		 --Check to see if the Addr2 field is valid for the study.  If so, it becomes part of the update statement.  
		 IF EXISTS(SELECT * FROM MetaData_View WHERE Study_id=@Study AND strTable_nm='Population' AND strField_nm='Addr2')        
		  SELECT @sql='UPDATE S'+@Study+'.Population           
		   SET Addr='''+@Addr+''',           
			Addr2='''+@Addr2+''',          
			City='''+@City+''',          
			Province='''+@Province+''',          
			Postal_Code='''+@PostalCode+''',        
			AddrStat='''+@AddrStat+''',          
			AddrErr='''+@AddrErr+'''          
		   WHERE Pop_id='+@Pop          
		 ELSE        
		  --No Addr2 field  
		  SELECT @sql='UPDATE S'+@Study+'.Population           
		   SET Addr='''+LEFT(@Addr+' '+@Addr2,42)+''',           
			City='''+@City+''',          
			Province='''+@Province+''',          
			Postal_Code='''+@PostalCode+''',        
			AddrStat='''+@AddrStat+''',          
			AddrErr='''+@AddrErr+'''          
		   WHERE Pop_id='+@Pop          
		        
		 EXEC (@sql)          
		        
		 IF @@ERROR<>0          
		 BEGIN          
		  ROLLBACK TRAN          
		  SELECT -1          
		  RETURN          
		 END         
		 --Log it          
		 INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)          
		 SELECT @Litho,@Disposition_id,GETDATE(),'Updated Address: '+          
		  ISNULL(@Addr,'')+' '+ISNULL(@Addr2,'')+' '+ISNULL(@City,'')+' '+          
		  ISNULL(@Province,'')+' '+ISNULL(@PostalCode,'')          
		           
		 IF @@ERROR<>0          
		 BEGIN          
		  ROLLBACK TRAN          
		  SELECT -1          
		  RETURN          
		 END          
		        
	END -- Loop 3  

	--insert into Catalyst extract queue so new address will be updated
	insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, source)  
	select distinct 7, sp.SAMPLEPOP_ID, NULL, 0, 'QCL_UpdateAddressJob'  
	from  samplepop sp
	where sp.study_Id = @study and
		sp.pop_ID = @pop


	DELETE tbl_QCL_AddressChange WHERE AddressChange_id=@ACID  
	  
	SELECT TOP 1 @ACID=AddressChange_id, @Litho=Litho, @Addr=ISNULL(Addr,''), @Addr2=ISNULL(Addr2,''), @City=ISNULL(City,''), @Del_Pt=ISNULL(Del_Pt,''),  
		@ST=ISNULL(ST,''), @Zip4=ISNULL(Zip4,''), @Zip5=ISNULL(Zip5,''), @AddrStat=ISNULL(AddrStat,''), @AddrErr=ISNULL(AddrErr,''),  
		@CountryID=ISNULL(CountryID,1), @Province=ISNULL(Province,''), @PostalCode=ISNULL(PostalCode,''),  
		@ReceiptTypeID=ReceiptTypeID, @UserName=UserName  
	FROM tbl_QCL_AddressChange  
END -- Loop 1


