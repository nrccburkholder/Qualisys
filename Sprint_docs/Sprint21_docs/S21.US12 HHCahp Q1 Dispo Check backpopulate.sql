


-- this index was created in stage, but I'm not sure we want to create a single-use index in production on such a large table.
/*
CREATE NONCLUSTERED INDEX [idx_qstncore]
ON [dbo].[QUESTIONRESULT] ([QSTNCORE],[INTRESPONSEVAL])
INCLUDE ([QUESTIONRESULT_ID],[QUESTIONFORM_ID],[SAMPLEUNIT_ID],[QPC_TIMESTAMP])
*/

-- drop table #HHQF
go

use qp_prod

--> first, run this in stage to get the min sampleset_id for the sampleencounterdate
--> Once you ge the min(sampleset_id) then uncomment the last line of the select below and run this is production.

select distinct qr.questionform_id, qf.samplepop_id, sd.study_id, qr.qstncore, sp.sampleset_id, qr.intResponseVal as Response, ss.sampleencounterdate
      , CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1
into #HHQF
from questionform qf 
inner join survey_def sd on qf.survey_id=sd.survey_id
inner join samplepop sp on qf.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.pop_id=ss.pop_id and sp.sampleset_id=ss.sampleset_id
inner join questionresult qr 
      on qf.questionform_id=qr.questionform_id and qr.qstncore=38694 
where sd.surveytype_id=3
and sampleencounterdate>='1/1/15' --> cutoff date provided by James
-- and sp.sampleset_id>=(whatever the stage min is)

select min(sampleset_id) from #HHQF --> run this in stage to find the earliest sampleset that we need to look at.

select * from #HHQF 

exec dbo.HHCAHPSCompleteness

select * from #HHQF  
where STUDY_ID in (2802, 3144)


-- return query to list out all the people who need their disposition changed to 220
select distinct 'select HHDisposition,* 
-- update btv set HHDisposition=220
from datamart.qp_comments.s'+convert(varchar,study_id)+'.big_table_view btv
where HHDisposition<>220
and samplepop_id in (   select samplepop_id
                                    from #hhqf
                                    where q1=2 and complete=0 and numanswersafterq1=0)'   -- this is the WHERE clause from the 3rd update command in sp_phase3_questionresult_for_extract
from #hhqf
where q1=2 and complete=0 and numanswersafterq1=0


-- the resulting query will look like this:
                              select HHDisposition, * 
                              from datamart.qp_comments.s3097.big_table_view   --> in the update statement, big_table_view will need to be changed in the update to be the value from the TableName column
                              where samplepop_id in ( select samplepop_id
                                                                  from #hhqf
                                                                  where q1=2 and complete=0 and numanswersafterq1=0)



-- return query to list out all the people who need their disposition changed to 310
select distinct 'select HHDisposition,* 
-- update btv set HHDisposition=310
from datamart.qp_comments.s'+convert(varchar,study_id)+'.big_table_view btv
where HHDisposition<>310
and samplepop_id in (   select samplepop_id
                                    from #hhqf                                                                    
                                    where complete=0 AND (numAnswersAfterQ1 > 0 or Q1=1))'      -- this is the WHERE clause from the 4th update command in sp_phase3_questionresult_for_extract
from #hhqf 
where complete=0 AND (numAnswersAfterQ1 > 0 or Q1=1)

-- the resulting queries will look like this:
            select HHDisposition,* 
            -- update btv set HHDisposition=310
            from datamart.qp_comments.s2418.big_table_view  --> in the update statement, big_table_view will need to be changed in the update to be the value from the TableName column
            where HHDisposition<>310
            and samplepop_id in (   select samplepop_id
                                                from #hhqf 
                                                where complete=0 AND (numAnswersAfterQ1 > 0 or Q1=1))
            select HHDisposition,* 
            -- update btv set HHDisposition=310
            from datamart.qp_comments.s2442.big_table_view --> in the update statement, big_table_view will need to be changed in the update to be the value from the TableName column
            where samplepop_id in ( select samplepop_id
                                                from #hhqf 
                                                where complete=0 AND (numAnswersAfterQ1 > 0 or Q1=1))





GO


--ALTER PROCEDURE dbo.HHCAHPSCompleteness
--AS  
--BEGIN  

----- this initial preset is for people who returned the survey but didn't answer any questions
--update hh 
--set complete = 0
--      , ATACnt=0
--      , Q1=-9
--      , numAnswersAfterQ1=0
--from #HHQF hh
--inner join (SELECT qf.questionform_id
--                  FROM QuestionResult qr
--                  inner join QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id  
--                  inner join #HHQF hh on qf.questionform_id=hh.questionform_id
--                  where qf.datreturned is not null
--                  group by qf.questionform_id) sub
--            on hh.questionform_id=sub.questionform_id
----- /inital preset            
  
--update hh
--set complete = case when sub.ATAcnt>9 then 1 else 0 end
--      , ATACnt=sub.ATACnt
--      , Q1=sub.Q1
--      , numAnswersAfterQ1=sub.numAnswersAfterQ1
--from #HHQF hh
--inner join (SELECT qf.questionform_id
--                  , count(distinct case when sq.qstncore in (38694,38695,38696,38697,38698,38699,38700,38701,38702,38703,38704,38708,38709,38710,38711,38712,38713,38714,38717,38718) then sq.qstncore end) as ATACnt
--                  , isnull(max(case when sq.qstncore=38694 then intResponseVal end),-9) as Q1
--                  , count(distinct case when sq.qstncore<>38694 then sq.qstncore end) as numAnswersAfterQ1
--                  FROM QuestionResult qr
--                  inner join QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id  
--                  inner join Sel_Qstns sq on qf.Survey_id=sq.Survey_id and qr.QstnCore=sq.QstnCore  
--                  inner join Sel_Scls ss on sq.Scaleid=ss.Qpc_id and sq.Survey_id=ss.Survey_id AND qr.intResponseVal=ss.Val  AND sq.Language=ss.Language
--                  inner join #HHQF hh on qf.questionform_id=hh.questionform_id
--                  WHERE sq.subType=1  
--                  AND sq.Language=1 
--                  group by qf.questionform_id) sub
--            on hh.questionform_id=sub.questionform_id

            
--END

--GO
