/*

	S44 US12 CG-CAHPS Completeness 
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	Task 3 - Create new function CGCAHPSCompleteness, based on MNCMCompleteness on QP_Prod, use mappings table, add new subtypes, to check for complete/partial/incomplete using measures & ATAs

	CREATE FUNCTION [dbo].[CGCAHPSCompleteness]

	Tim Butler

*/


USE [QP_Prod]
GO


IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  [name] = 'fn_CGCAHPSCompleteness'
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' )
				  )
		DROP FUNCTION [dbo].[fn_CGCAHPSCompleteness]

GO


CREATE FUNCTION [dbo].[fn_CGCAHPSCompleteness] (@QuestionForm_id INT)      
RETURNS INT      
AS      
BEGIN      

/*

Complete survey: 1
>= 50% of the ATA questions and >= 1 Measure Question.

Partial Survey: 2
< 50% of the ATA questions and >= 1 Measure Question

Incomplete Survey: 3
Any survey return where zero measure questions are answered regardless of the number of ATA questions answered.
>50% of the ATA questions and no Measure Question answered.
<50% of the ATA questions and no Measure Question answered.


*/
  

DECLARE @ATARespCnt INT = 0
DECLARE @MeasRespCnt INT = 0
DECLARE @ATACnt INT = 0

DECLARE @Complete INT 
DECLARE @Surveytype_id int
DECLARE @Subtype_id int = 0

SELECT @Complete=0


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

-- Order of these is IMPORTANT
IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 39113)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = 'Visit Adult 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 44127)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Adult 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 44121)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Adult 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 46278)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Child 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 46265)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Child 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50226)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Adult 3.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50541)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Adult 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50344)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Adult 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50629)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Child 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50500)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Child 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50483)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Child 3.0'
 
END



IF @Subtype_id > 0
BEGIN

	SELECT @ATARespCnt=COUNT(distinct qr.QstnCore)      
	FROM QuestionResult qr
	INNER JOIN QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id
	INNER JOIN Sel_Qstns sq on qf.Survey_id=sq.Survey_id and qr.QstnCore=sq.QstnCore
	INNER JOIN Sel_Scls ss on sq.Scaleid=ss.Qpc_id and sq.Survey_id=ss.Survey_id and qr.intResponseVal=ss.Val
	WHERE qr.QuestionForm_id=@QuestionForm_id      
	AND qr.QstnCore IN   
		(SELECT QSTNCORE
		FROM SurveyTypeQuestionMappings
		WHERE SurveyType_id = @Surveytype_id
		and SubType_ID = @Subtype_id
		and isATA = 1)      
	AND sq.subType=1      
	AND sq.Language=1           
	AND ss.Language=1            


	SELECT @MeasRespCnt=COUNT(distinct qr.QstnCore)      
	FROM QuestionResult qr      
	INNER JOIN QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id
	INNER JOIN Sel_Qstns sq on qf.Survey_id=sq.Survey_id and qr.QstnCore=sq.QstnCore
	INNER JOIN Sel_Scls ss on sq.Scaleid=ss.Qpc_id and sq.Survey_id=ss.Survey_id and qr.intResponseVal=ss.Val
	WHERE qr.QuestionForm_id=@QuestionForm_id      
	AND qr.QstnCore IN   
		(SELECT QSTNCORE
		FROM SurveyTypeQuestionMappings
		WHERE SurveyType_id = @Surveytype_id
		and SubType_ID = @Subtype_id
		and isMeasure = 1)            
	AND sq.subType=1      
	AND sq.Language=1           
	AND ss.Language=1 


	SELECT @ATACnt = count(distinct intOrder)
	FROM SurveyTypeQuestionMappings
	WHERE SurveyType_id = @Surveytype_id
	and SubType_ID = @Subtype_id
	and isATA = 1  

	If @ATACnt = 0 RETURN 0

	SELECT @Complete = case 
		when (cast(@ATARespCnt as float)/cast(@ATACnt as float)) * 100 >= 50 AND @MeasRespCnt >= 1 then 1 
		when (cast(@ATARespCnt as float)/cast(@ATACnt as float)) * 100 < 50 AND @MeasRespCnt >= 1 then 2
		else 3 end      

END

RETURN @Complete      
      
END


GO

