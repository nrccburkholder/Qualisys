CREATE PROCEDURE [dbo].[CIHICompleteness] 
AS
-- =============================================
-- Author:	Dave Gilsdorf
-- Procedure Name: CIHICompleteness
-- Create date: 4/2015
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  4/2015  by Dave Gilsdorf (modeled after ACOCAHPSCompleteness)
-- =============================================
BEGIN
	DECLARE @MinDate DATE;
	SET @MinDate = DATEADD(DAY, -4, GETDATE());

	WITH CTE_Returns AS
	(
		SELECT DISTINCT PKey1 
		FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
		WHERE eq.ExtractFileID IS NULL AND eq.EntityTypeID = 11 AND eq.Created > @MinDate
	)

	--SELECT * FROM CTE_Returns
	-- list of everybody who returned a CIHI CPES-IC survey today
	select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
		, scm.*, qf.QuestionForm_id, sm.datExpire 
		, qf.ReceiptType_id, ms.strMailingStep_nm, qf.bitComplete
		, sstx.Subtype_id, sstx.Subtype_nm
		into #TodaysReturns
	from CTE_Returns eq
	inner join QuestionForm qf on qf.QuestionForm_id=eq.PKey1 
	inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
	inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
	inner join Survey_def sd on qf.Survey_id=sd.Survey_id
	inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
	left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm from [dbo].[SurveySubtype] sst INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)) sstx on sstx.Survey_id = qf.SURVEY_ID --> new: 1.6
	inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
	where qf.datResultsImported is not null
	and st.Surveytype_dsc in ('CIHI CPES-IC')
	and sm.datExpire > getdate()
	order by qf.datResultsImported desc

	-- CIHI Processing
	select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition, Subtype_nm
	into #CIHIQF
	from #TodaysReturns
	where Surveytype_dsc='CIHI CPES-IC'

	create table #QR (Questionform_id int, qstncore int, intResponseVal int)
	insert into #QR (questionform_id, qstncore, intResponseVal)
			select qr.questionform_id, QstnCore,intResponseVal from QuestionResult qr, #CIHIQF qf where qr.QuestionForm_id=qf.QuestionForm_id
			union all select qr.questionform_id, QstnCore,intResponseVal from QuestionResult2 qr, #CIHIQF qf where qr.QuestionForm_id=qf.QuestionForm_id
	
	update #CIHIQF set ATAcnt=0, ATAcomplete=0, MeasureCnt=0, MeasureComplete=0, Disposition=0

	update #CIHIQF set disposition=255
	from #CIHIQF qf
	left join #QR qr on qf.questionform_id=qr.questionform_id
	where qr.questionform_id is null
		
	update qf
	set ATAcnt=sub.cnt
		, ATAcomplete=case when sub.cnt >= (27 * 0.50) then 1 else 0 end
	from #CIHIQF qf
	inner join (SELECT questionform_id, COUNT(distinct qstncore) as cnt
				FROM #QR 
				where intResponseVal>=0
				AND QstnCore IN (
					51377,	--1		Q1
					51378,	--2		Q2
					51379,	--3		Q3
					51380,	--4		Q4
					51381,	--5		Q5
					51382,	--6		Q6
					51383,	--7		Q7
					51384,	--8		Q8
					51385,	--9		Q9
					51386,	--10	Q10
					51388,	--11	Q12
					51391,	--12	Q15
					51394,	--13	Q18
					51397,	--14	Q21
					51399,	--15	Q23
					51406,	--16	Q30
					51407,	--17	Q31
					51408,	--18	Q32
					51409,	--19	Q33
					51410,	--20	Q34
					51411,	--21	Q35
					51412,	--22	Q36
					51413,	--23	Q37
					51414,	--24	Q38
					51415,	--25	Q39
					51416,	--26	Q40
					51417	--27	Q41
					)
				group by questionform_id) sub
		on qf.questionform_id=sub.questionform_id

	update #CIHIQF 
	set Disposition=
		case when ATAComplete=1 
			then 13 -- complete (NRC disposition_id)
		when ATAComplete=0
			then 11 -- not complete (NRC disposition_id)
		end
	where Disposition=0
	
	update qf
	set bitComplete=c.ATAComplete
	from dbo.questionform qf
	inner join #CIHIqf c on qf.questionform_id=c.questionform_id
	where c.ATAComplete in (1,0)
	
	insert into DispositionLog (sentmail_id, samplepop_id, disposition_id, ReceiptType_id, datlogged, loggedby, daysFromCurrent)
	select tr.sentmail_id, tr.samplepop_id, qf.disposition, tr.ReceiptType_id, getdate() as datlogged, 'CIHICompleteness' as loggedby, 0 as daysFromCurrent
	from #CIHIQF qf
	inner join #todaysreturns tr on qf.questionform_id=tr.questionform_id
	where qf.disposition in (11,13)	

END