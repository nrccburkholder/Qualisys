CREATE FUNCTION [dbo].[ABCCompleteness] (@QuestionForm_id INT,@Company VARCHAR(10))
RETURNS BIT
AS
BEGIN

DECLARE @Cnt INT, @Complete BIT

IF @Company = 'HCAHPS'
BEGIN

SELECT @Cnt=COUNT(*)
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss
WHERE qr.QuestionForm_id=@QuestionForm_id
AND qr.QstnCore IN (18876,18878,18879,18882,18875,18877,18884,18888,18889,18894,18907,18916,18929,18941,18943)
AND qr.QuestionForm_id=qf.QuestionForm_id
AND qf.Survey_id=sq.Survey_id
AND qr.QstnCore=sq.QstnCore
AND sq.subType=1
AND sq.Language=1
AND sq.Scaleid=ss.Qpc_id
AND sq.Survey_id=ss.Survey_id
AND ss.Language=1
AND qr.intResponseVal=ss.Val

IF @cnt>7
SELECT @Complete=1
ELSE 
SELECT @Complete=0


END

	
IF @Company = 'HHCAHPS'
BEGIN

SELECT @Cnt=COUNT(*)  
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss  
WHERE qr.QuestionForm_id=@QuestionForm_id  
AND qr.QstnCore IN (38694,38695,38696,38697,38698,38699,38700,38701,38702,38703,38704,
					38708,38709,38710,38711,38712,38713,38714,38717,38718)  
AND qr.QuestionForm_id=qf.QuestionForm_id  
AND qf.Survey_id=sq.Survey_id  
AND qr.QstnCore=sq.QstnCore  
AND sq.subType=1  
AND sq.Language=1  
AND sq.Scaleid=ss.Qpc_id  
AND sq.Survey_id=ss.Survey_id  
AND ss.Language=1  
AND qr.intResponseVal=ss.Val  
  
IF @cnt>9  
SELECT @Complete=1  
ELSE   
SELECT @Complete=0  
  
  
END  
  



IF @Company = 'MNCM'
 BEGIN 
      
SELECT @Cnt=COUNT(*)      
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss      
WHERE qr.QuestionForm_id=@QuestionForm_id      
AND qr.QstnCore IN   
 (39113,39114,39115,39116,39117,39119,39121,39123,39125,39128,39130,39131,39132,39134,
  39135,39136,39137,39140,39151,39152,39154,39156,39157,39158,39159,39160,40716)  
AND qr.QuestionForm_id=qf.QuestionForm_id      
AND qf.Survey_id=sq.Survey_id      
AND qr.QstnCore=sq.QstnCore      
AND sq.subType=1      
AND sq.Language=1      
AND sq.Scaleid=ss.Qpc_id      
AND sq.Survey_id=ss.Survey_id      
AND ss.Language=1      
AND qr.intResponseVal=ss.Val      
      
--must answer 16 out of 31 questions      
IF @cnt>13       
SELECT @Complete=1      
ELSE       
SELECT @Complete=0      
      
 
END

RETURN @Complete 
	END


