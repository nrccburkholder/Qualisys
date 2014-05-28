CREATE PROCEDURE DBO.SP_QDE_RollBackBatch  
@Batch_id INT  
AS  
  
IF (SELECT datFinalized FROM QDEBatch WHERE Batch_id = @Batch_id) IS NOT NULL  
BEGIN  
	RAISERROR ('This batch cannot be deleted because it has already been finalized.', 18, 1)
END  
ELSE
BEGIN
	DELETE sc  
	FROM QDEForm f, QDEComments c, QDECommentSelCodes sc  
	WHERE f.Form_id = c.Form_id  
	AND c.Cmnt_id = sc.Cmnt_id  
	AND f.Batch_id = @Batch_id  
	  
	UPDATE c SET strCmntText = NULL,   
	  CmntType_id = NULL,   
	  CmntValence_id = NULL,   
	  datKeyed = NULL,  
	  strKeyedBy = NULL,  
	  datKeyVerified = NULL,  
	  strKeyVerifiedBy = NULL,  
	  datCoded = NULL,  
	  strCodedBy = NULL,  
	  datCodeVerified = NULL,  
	  strCodeVerifiedBy = NULL,  
	  bitIgnore = 0  
	FROM QDEForm f, QDEComments c  
	WHERE f.Form_id = c.Form_id  
	AND f.Batch_id = @Batch_id  
	  
	UPDATE f SET Batch_id = NULL, bitLocked = 0  
	FROM QDEForm f  
	WHERE f.Batch_id = @Batch_id  
	  
	DELETE QDEBatch WHERE Batch_id = @Batch_id  
END


