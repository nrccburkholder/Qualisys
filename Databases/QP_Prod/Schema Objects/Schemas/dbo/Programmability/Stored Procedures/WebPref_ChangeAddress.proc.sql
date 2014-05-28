-- Mod 1/28/2005 SS - Set Nul varibles to empty string for dynamic sql (ie. Del_pt, AddrStat, AddrErr, etc.)

CREATE PROCEDURE WebPref_ChangeAddress @Litho VARCHAR(20), @Disposition_id INT, @Addr VARCHAR(42), @Addr2 VARCHAR(42), @City VARCHAR(42),  
@Del_Pt CHAR(3), @ST CHAR(2), @Zip4 CHAR(4), @ZIP5 CHAR(5), @AddrStat VARCHAR(42), @AddrErr VARCHAR(42)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
DECLARE @sql VARCHAR(8000), @Study VARCHAR(10), @Pop VARCHAR(20)  

INSERT INTO WebPref_ChangeAddress_ParamLog (log_dt, litho, Disposition_id, Addr, Addr2, City, Del_pt, ST, Zip4, ZIP5, AddrStat, AddrErr)
SELECT GETDATE(), @litho, @Disposition_id, @Addr, @Addr2, @City, @Del_pt, @ST, @Zip4, @ZIP5, @AddrStat, @AddrErr

-- Set any null variables to empty strings for the dynamic SQL
SELECT @Addr = ISNULL(@Addr,''), @Addr2 = ISNULL(@Addr2,''), @City = ISNULL(@City,''), @Del_Pt = ISNULL(@Del_Pt,''), @ST = ISNULL(@ST,''), 
	  @ZIP4 = ISNULL(@Zip4,''), @ZIP5 = ISNULL(@ZIP5,''), @AddrStat = ISNULL(@AddrStat,''), @AddrErr =ISNULL(@AddrErr,'')
  
SELECT @Study=LTRIM(STR(Study_id)), @Pop=LTRIM(STR(Pop_id))  
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp  
WHERE sm.strLithoCode=@Litho  
AND sm.SentMail_id=schm.SentMail_id  
AND schm.SamplePop_id=sp.SamplePop_id  

BEGIN TRAN  
  
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
SELECT @sql='UPDATE S'+@Study+'.Population   
 SET Addr='''+LEFT(@Addr+@Addr2,42)+''',   
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
 @Addr+' '+@Addr2+' '+@City+' '+  
 @ST+' '+@Zip5+' '+@Zip4+' '+  
 @Del_pt  
  
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


