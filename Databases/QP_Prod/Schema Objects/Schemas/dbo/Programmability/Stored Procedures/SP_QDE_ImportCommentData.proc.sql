CREATE PROCEDURE DBO.SP_QDE_ImportCommentData      
@Batch_id INT,    
@strLithoCode VARCHAR(10),      
@QstnCore INT,      
@strCmntText TEXT      
      
AS      
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
--Can this survey_id accept multiple returns.  0=> Single return only 1=> Multiple returns accepted  
IF (SELECT bitMultReturns   
  FROM SentMailing sm, MailingMethodology mm, Survey_def sd   
  WHERE sm.strLithoCode=@strLithoCode   
  AND sm.Methodology_id=mm.Methodology_id   
  AND mm.Survey_id=sd.Survey_id)=0  
BEGIN  
 --First check for a previous return  
 IF EXISTS (SELECT *   
     FROM SentMailing sm, QuestionForm qf   
     WHERE qf.SamplePop_id=dbo.FN_SamplePopFromLitho(@strLithoCode)  
     AND qf.datReturned>'1/1/1900'  
     AND qf.SentMail_id=sm.SentMail_id  
     AND sm.strLithoCode<>@strLithoCode)  
 BEGIN  
  RAISERROR ('This person has already returned a different survey.',18,1)    
  RETURN  
 END    
END  
    
DECLARE @OldBatch INT    
    
SELECT @OldBatch=Batch_id    
FROM QDEForm    
WHERE strLithoCode=@strLithoCode    
    
IF @OldBatch IS NULL    
BEGIN    
 EXEC dbo.SP_QDE_AssignLithoToBatch @strLithoCode, @Batch_id    
END    
    

IF ISNULL(@OldBatch,@Batch_id)=@Batch_id    
BEGIN    

 if (select count(*) FROM QDEForm f, QDEComments c 
	 WHERE f.Form_id=c.Form_id AND f.strLithoCode=@strLithoCode AND c.QstnCore=@QstnCore) >=1
	begin  
		--record exists so lets update the strCmntText field
		 UPDATE c SET strCmntText=@strCmntText      
		 FROM QDEForm f, QDEComments c      
		 WHERE f.Form_id=c.Form_id      
		 AND f.strLithoCode=@strLithoCode      
		 AND c.QstnCore=@QstnCore  

		 if @@Rowcount = 0
			begin
				RAISERROR ('No Matching Record found to update.',18,1)    
			end
	end
else
	begin
		--no record exists so we are going to add one
		Insert into QDEComments (form_ID, QstnCore, strCmntText, Sampleunit_ID)
		select f.Form_ID, @QstnCore as QstnCore, @strCmntText as strCmntText, dbo.QDE_GetDirectSampleunit(@strLithoCode) 
		from qdeform f where f.strlithocode = @strLithoCode

		 if @@Rowcount = 0
			begin
				RAISERROR ('Attempt to Insert record failed.',18,1)    
			end
	end
	


select top 10 * from qdecomments

END    
ELSE    
BEGIN    
 RAISERROR ('Litho has already been processed in a different batch.',18,1)    
END


