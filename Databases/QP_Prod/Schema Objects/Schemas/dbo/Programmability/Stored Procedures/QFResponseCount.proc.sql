CREATE procedure [dbo].[QFResponseCount] 
AS
BEGIN
	-- assumes a #QFResponseCount table already exists and at least has the following columns:
	-- QuestionForm_id int
	-- ResponseCount int 
	
	update #QFResponseCount set ResponseCount=0
	
	update qfa
	set ResponseCount=sub.cnt 
	from #QFResponseCount qfa
	inner join (select QuestionForm_id, count(distinct qstncore) as cnt
				from QuestionResult2
				where intResponseVal >= 0
				group by QuestionForm_id) sub
			on qfa.QuestionForm_id=sub.QuestionForm_id

	update qfa
	set ResponseCount=sub.cnt 
	from #QFResponseCount qfa
	inner join (select QuestionForm_id, count(distinct qstncore) as cnt
				from QuestionResult
				where intResponseVal >= 0
				group by QuestionForm_id) sub
			on qfa.QuestionForm_id=sub.QuestionForm_id
END
