CREATE PROCEDURE DBO.SP_QDE_UpdateBatchIgnoreFlags      
@Batch_id 			INT,  
@strTemplateName 	VARCHAR(60) = '',  
@RunType			BIT --0 =>File load 1=>Ran after key verification
AS      
  
INSERT INTO UpdateBatchIgnoreFlags_log  
SELECT GETDATE(), @Batch_id, @strTemplateName   
  
IF @RunType=0 -- File Loaded
BEGIN
	IF ISNULL(@strTemplateName, '') = ''  
	BEGIN  
	 UPDATE c SET bitIgnore = 1      
	 FROM QDEBatch b, QDEForm f, QDEComments c      
	 WHERE b.Batch_id = @Batch_id      
	 AND b.Batch_id = f.Batch_id      
	 AND f.Form_id = c.Form_id      
	 AND (c.strCmntText IS NULL    
	 OR DATALENGTH(LTRIM(RTRIM(SUBSTRING(strCmntText,1,100))))=0)  
	END  
	ELSE  
	BEGIN  
	 UPDATE c SET bitIgnore = 1      
	 FROM QDEBatch b, QDEForm f, QDEComments c      
	 WHERE b.Batch_id = @Batch_id      
	 AND b.Batch_id = f.Batch_id      
	 AND f.Form_id = c.Form_id      
	 AND f.strTemplateName = @strTemplateName  
	 AND (c.strCmntText IS NULL    
	 OR DATALENGTH(LTRIM(RTRIM(SUBSTRING(strCmntText,1,100))))=0)  
	END  
END
ELSE -- Ran after key verification
BEGIN
	IF ISNULL(@strTemplateName, '') = ''  
	BEGIN  
	 UPDATE c SET bitIgnore = 1      
	 FROM QDEBatch b, QDEForm f, QDEComments c      
	 WHERE b.Batch_id = @Batch_id      
	 AND b.Batch_id = f.Batch_id      
	 AND f.Form_id = c.Form_id      
	 AND c.strKeyVerifiedBy IS NOT NULL
	 AND (c.strCmntText IS NULL    
	 OR DATALENGTH(LTRIM(RTRIM(SUBSTRING(strCmntText,1,100))))=0)  
	END  
	ELSE  
	BEGIN  
	 UPDATE c SET bitIgnore = 1      
	 FROM QDEBatch b, QDEForm f, QDEComments c      
	 WHERE b.Batch_id = @Batch_id      
	 AND b.Batch_id = f.Batch_id      
	 AND f.Form_id = c.Form_id      
	 AND f.strTemplateName = @strTemplateName  
	 AND c.strKeyVerifiedBy IS NOT NULL
	 AND (c.strCmntText IS NULL    
	 OR DATALENGTH(LTRIM(RTRIM(SUBSTRING(strCmntText,1,100))))=0)  
	END  
END


