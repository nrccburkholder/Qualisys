/* 4/16/2015 replaced this function with an SP of the same name

CREATE FUNCTION dbo.HHCAHPSCompleteness (@QuestionForm_id INT)  
RETURNS BIT  
AS  
BEGIN  
  
DECLARE @Cnt INT, @Complete BIT  
  
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
  
RETURN @Complete  
  
END


*/