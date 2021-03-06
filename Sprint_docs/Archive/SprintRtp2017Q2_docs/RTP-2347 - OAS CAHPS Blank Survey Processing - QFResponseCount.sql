USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QFResponseCount]    Script Date: 6/14/2017 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[QFResponseCount] 
AS
BEGIN
	-- assumes a #QFResponseCount table already exists and at least has the following columns:
	-- QuestionForm_id int
	-- ResponseCount int 
    -- SurveyType_id int
	
	update #QFResponseCount set ResponseCount=0
	
	update qfa
	set ResponseCount=sub.cnt 
	from #QFResponseCount qfa
	inner join (select QuestionForm_id, count(distinct qstncore) as cnt
				from QuestionResult2
				where intResponseVal >= 0
				group by QuestionForm_id) sub
			on qfa.QuestionForm_id=sub.QuestionForm_id
    WHERE SurveyType_id != 16

    update qfa
	set ResponseCount=sub.cnt + ResponseCount
	from #QFResponseCount qfa
	inner join (select QuestionForm_id, count(distinct q.qstncore) as cnt
				from QuestionResult2 q JOIN SurveyTypeQuestionMappings s ON q.qstncore = s.qstncore
				where intResponseVal >= 0 AND s.SurveyType_id = 16
				group by QuestionForm_id) sub
			on qfa.QuestionForm_id=sub.QuestionForm_id
    WHERE SurveyType_id = 16

	update qfa
	set ResponseCount=sub.cnt 
	from #QFResponseCount qfa
	inner join (select QuestionForm_id, count(distinct qstncore) as cnt
				from QuestionResult
				where intResponseVal >= 0
				group by QuestionForm_id) sub
			on qfa.QuestionForm_id=sub.QuestionForm_id
    WHERE SurveyType_id != 16

    update qfa
	set ResponseCount=sub.cnt 
	from #QFResponseCount qfa
	inner join (select QuestionForm_id, count(distinct q.qstncore) as cnt
				from QuestionResult q JOIN SurveyTypeQuestionMappings s ON q.qstncore = s.qstncore
				where intResponseVal >= 0 AND s.SurveyType_id = 16
				group by QuestionForm_id) sub
			on qfa.QuestionForm_id=sub.QuestionForm_id
    WHERE SurveyType_id = 16
END

GO