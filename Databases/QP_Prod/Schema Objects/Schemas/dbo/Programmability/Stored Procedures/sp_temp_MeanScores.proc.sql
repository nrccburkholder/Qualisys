CREATE PROCEDURE sp_temp_MeanScores 
	@survey_id int
AS

select qstncore, convert(decimal(7,3),avg(convert(float,intresponseval))) as 'Mean', count(*) as 'N' 
from questionresult qr, questionform qf
where qr.questionform_id = qf.questionform_id
and qf.survey_id = @survey_id
and intresponseval > -1
group by qstncore
order by qstncore

select strsampleunit_nm, qstncore, convert(decimal(7,3),avg(convert(float,intresponseval))) as 'Mean', count(*) as 'N' 
from questionresult qr, questionform qf, sampleunit su
where qr.questionform_id = qf.questionform_id
and qr.sampleunit_id = su.sampleunit_id
and qf.survey_id = @survey_id
and intresponseval > -1
group by strsampleunit_nm, qstncore
order by strsampleunit_nm, qstncore


