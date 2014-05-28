CREATE procedure SP_SYS_MailingStep_Fix
as
SELECT strclient_nm, s.study_id, sd.survey_id, methodology_id, COUNT(*) as cnt
into #mailingstep
FROM client c, study s, survey_def sd, mailingstep ms
WHERE c.client_id = s.client_id
AND s.study_id = sd.study_id
AND sd.survey_id = ms.survey_id
AND (SELECT MAX(intsequence) FROM mailingstep ms2 WHERE intintervaldays = 0 AND ms2.methodology_id = ms.methodology_id GROUP BY survey_id) = 
    (SELECT MAX(intsequence) FROM mailingstep ms2 WHERE ms2.methodology_id = ms.methodology_id GROUP BY survey_id)
and (select count(*) from mailingstep where survey_id = sd.survey_id) > 1
GROUP BY strclient_nm, s.study_id, sd.survey_id, methodology_id

while (select count(*) from #mailingstep) > 0
begin --Loop 1
declare @methodology int

set @methodology = (select top 1 methodology_id from #mailingstep)

select methodology_id, mailingstep_id, intsequence, intintervaldays, 0 as newint, 0 as processed
into #update
from mailingstep
where methodology_id = @methodology
order by intsequence

while (select count(*) from #update where processed = 0) > 0
begin --Loop2

declare @seq1 int, @seq2 int
set @seq1 = (select max(intsequence) from #update where processed = 0)

if @seq1 = (select max(intsequence) from #update)
set @seq2 = (select min(intsequence) from #update)
else
set @seq2 = (select min(intsequence) from #update where intsequence > @seq1)


update #update
set newint = (select intintervaldays from #update where intsequence = @seq1)
where intsequence = @seq2

update #update set processed = 1 where intsequence = @seq1

end --Loop2

update ms
set ms.intintervaldays = newint
from mailingstep ms, #update u
where u.mailingstep_id = ms.mailingstep_id

delete #mailingstep where methodology_id = (select top 1 methodology_id from #update)

drop table #update

end --Loop1

drop table #mailingstep


