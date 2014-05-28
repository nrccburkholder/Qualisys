CREATE FUNCTION [dbo].[HCAHPSCompleteness] (@QuestionForm_id INT)
RETURNS BIT
AS
BEGIN

DECLARE @Cnt INT, @Complete BIT

SELECT @Cnt=COUNT(*)
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss
WHERE qr.QuestionForm_id=@QuestionForm_id
AND qr.QstnCore IN (18876,18878,18879,18882,18875,18877,18884,18888,18889,18894,18907,18916,18929,18941,18943,46863,46864,46865)
AND qr.QuestionForm_id=qf.QuestionForm_id
AND qf.Survey_id=sq.Survey_id
AND qr.QstnCore=sq.QstnCore
AND sq.subType=1
AND sq.Language=1
AND sq.Scaleid=ss.Qpc_id
AND sq.Survey_id=ss.Survey_id
AND ss.Language=1
AND qr.intResponseVal=ss.Val

IF @cnt>=9
SELECT @Complete=1
ELSE 
SELECT @Complete=0

RETURN @Complete

END


