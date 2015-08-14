CREATE PROCEDURE dbo.HHCAHPSCompleteness
AS  
BEGIN  

-- this initial preset is for people who returned the survey but didn''t answer any questions
update hh 
set complete = 0
      , ATACnt=0
      , Q1=-9
      , numAnswersAfterQ1=0
from #HHQF hh
inner join (SELECT qf.questionform_id
                  FROM QuestionResult qr
                  inner join QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id  
                  inner join #HHQF hh on qf.questionform_id=hh.questionform_id
                  where qf.datreturned is not null
                  group by qf.questionform_id) sub
            on hh.questionform_id=sub.questionform_id
-- /inital preset 
  
update hh
set complete = case when sub.ATAcnt>9 then 1 else 0 end
	, ATACnt=sub.ATACnt
	, Q1=sub.Q1
	, numAnswersAfterQ1=sub.numAnswersAfterQ1
from #HHQF hh
inner join (SELECT qf.questionform_id
				, count(distinct case when sq.qstncore in (38694,38695,38696,38697,38698,38699,38700,38701,38702,38703,38704,38708,38709,38710,38711,38712,38713,38714,38717,38718) then sq.qstncore end) as ATACnt
				, isnull(max(case when sq.qstncore=38694 then intResponseVal end),-9) as Q1
				, count(distinct case when sq.qstncore<>38694 then sq.qstncore end) as numAnswersAfterQ1
			FROM QuestionResult qr
			inner join QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id  
			inner join Sel_Qstns sq on qf.Survey_id=sq.Survey_id and qr.QstnCore=sq.QstnCore  
			inner join Sel_Scls ss on sq.Scaleid=ss.Qpc_id and sq.Survey_id=ss.Survey_id AND qr.intResponseVal=ss.Val  AND sq.Language=ss.Language
			inner join #HHQF hh on qf.questionform_id=hh.questionform_id
			WHERE sq.subType=1  
			AND sq.Language=1 
			group by qf.questionform_id) sub
		on hh.questionform_id=sub.questionform_id
END