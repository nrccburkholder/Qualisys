CREATE PROCEDURE DBO.SP_QDE_AssignLithoToBatch    
@strLithoCode VARCHAR(10),        
@Batch_id INT    
AS        
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      
DECLARE @Form_id INT, @rc INT      
    
IF NOT EXISTS (SELECT Form_id FROM QDEForm WHERE strLithoCode = @strLithoCode)    
BEGIN    
  INSERT INTO QDEForm (strLithoCode, SentMail_id, QuestionForm_id, Batch_id, Survey_id, strTemplateCode, LangID)        
  SELECT TOP 1 SM.strLithoCode, SM.SentMail_id, QF.QuestionForm_id, @Batch_id, qf.Survey_id, strTemplateCode, LangID        
  FROM SentMailing SM, QuestionForm QF, PaperConfigSheet PCS, PaperSize PS, Survey_def SD, Study ST, Client CL         
  WHERE SM.strLithoCode = @strLithoCode        
  AND SM.SentMail_id = QF.SentMail_id        
  AND SM.PaperConfig_id = PCS.PaperConfig_id         
  AND PCS.PaperSize_id = PS.PaperSize_id         
  AND QF.Survey_id = SD.Survey_id         
  AND SD.Study_id = ST.Study_id         
  AND ST.Client_id = CL.Client_id         
  ORDER BY PCS.intSheet_num DESC        
    
  SELECT @Form_id=SCOPE_IDENTITY(), @rc=@@ROWCOUNT   
  
  IF @rc=0  
 RETURN 0     
  
  SELECT @Form_id AS 'Form_id', CMNTBOX_ID AS 'QstnCore', SampleUnit_id      
  INTO #QDEComments    
  FROM QP_Scan.DBO.CommentPos p, QDEForm f      
  WHERE f.Form_id = @Form_id      
  AND f.QuestionForm_id = p.QuestionForm_id      
  ORDER BY p.CMNTBOX_ID      
    
  INSERT INTO QDEComments (Form_id, QstnCore, SampleUnit_id)      
  SELECT c1.Form_id, c1.QstnCore, c1.SampleUnit_id    
  FROM #QDEComments c1 LEFT OUTER JOIN QDEComments c2 ON (c1.Form_id = c2.Form_id AND c1.QstnCore = c2.QstnCore)    
  WHERE c2.QstnCore IS NULL  

  SELECT 1  
END    
ELSE    
BEGIN    
  IF ISNULL((SELECT Batch_id FROM QDEForm WHERE strLithoCode = @strLithoCode), @Batch_id) <> @Batch_id
  BEGIN
    SELECT 0
  END
  ELSE
  BEGIN
    UPDATE QDEForm SET Batch_id = @Batch_id  
    WHERE strLithoCode = @strLithoCode  

    SELECT 1
  END
END


