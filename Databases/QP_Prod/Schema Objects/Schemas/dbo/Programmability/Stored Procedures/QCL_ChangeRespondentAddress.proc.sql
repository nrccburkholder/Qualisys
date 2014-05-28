/****** Object:  Stored Procedure dbo.QCL_ChangeRespondentAddress    Script Date: 10/11/05 ******/  
/************************************************************************************************/  
/*                       */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It updates  */  
/*            the address for the given litho.        */  
/* Date Created:  10/11/2005                   */  
/*                       */  
/* Created by:  Brian Dohmen                   */  
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*                       */  
/************************************************************************************************/  
CREATE PROCEDURE dbo.QCL_ChangeRespondentAddress         
 @Litho VARCHAR(20),         
 @DispositionID INT,         
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
AS          
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
SET NOCOUNT ON          

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRAN  
  
INSERT INTO tbl_QCL_AddressChange (Litho,Disposition_id,Addr,Addr2,City,Del_Pt,ST,Zip4,ZIP5,  
AddrStat,AddrErr,CountryID,Province,PostalCode,ReceiptTypeID,UserName)  
SELECT @Litho, @DispositionID, @Addr, @Addr2, @City, @Del_Pt, @ST, @Zip4, @Zip5,   
@AddrStat, @AddrErr, @CountryID, @Province, @PostalCode, @ReceiptTypeID, @UserName  
  
/*          
DECLARE @sql VARCHAR(8000), @Study VARCHAR(10), @Pop VARCHAR(20)          
          
--Need to get the study_id and the pop_id for the given litho  
SELECT @Study=LTRIM(STR(Study_id)), @Pop=LTRIM(STR(Pop_id))          
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp          
WHERE sm.strLithoCode=@Litho          
AND sm.SentMail_id=schm.SentMail_id          
AND schm.SamplePop_id=sp.SamplePop_id          
          
BEGIN TRAN          
  
--Now to update the address fields in the population table  
IF @CountryID=1        
BEGIN        
 --Check to see if the Addr2 field is valid for the study.  If so, it becomes part of the update statement.  
 IF EXISTS(SELECT * FROM MetaData_View WHERE Study_id=@Study AND strTable_nm='Population' AND strField_nm='Addr2')        
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
        
END        
ELSE        
--If Canadian, then this section will run.  It updates Province and Postal_Code instead of State and Zip.  
BEGIN   
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
        
END        
*/  
IF @@ERROR<>0          
BEGIN          
 ROLLBACK TRAN          
 SELECT -1          
RETURN          
END          
  
--Need to log the disposition for reporting purposes    
SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName

IF @@ERROR<>0          
BEGIN          
 ROLLBACK TRAN          
 SELECT -1          
RETURN          
END          
          
COMMIT TRAN          
SELECT 1          
          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF


