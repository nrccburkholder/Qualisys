USE QP_PROD

SELECT *
from [dbo].[CMSDataSubmissionSchedule]

USE QP_PROD

--SELECT *, DATEADD(d,1,SubmissionDateClose)
--UPDATE [dbo].[CMSDataSubmissionSchedule]
--	SET SubmissionDateClose = DATEADD(d,1,SubmissionDateClose)
IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work  

GO
	SELECT '2016-03-01' DisChargeDate, NULL ServiceDate
	INTO #Work

	DECLARE @GetDate as Date = '2016-07-06 10:27:07.000'

	SELECT *, GETDATE(), DATEDIFF(day, sub.SubmissionDateClose, @GetDate),DATEDIFF(day, @GetDate,sub.SubmissionDateClose),DATEADD(day,1,Sub.SubmissionDateClose)
	FROM #Work w  
	INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,ISNULL(w.DischargeDate,w.ServiceDate)) and sub.[year] = DATEPART(year,ISNULL(w.DischargeDate,w.ServiceDate)) 
	WHERE sub.SurveyType_id = 2 
	--AND DATEDIFF(day, sub.SubmissionDateClose, @GetDate) > 0	--> We could change to use this.  > 0 means we are beyond the SubmissionDateClose
	--and DATEADD(day,1,Sub.SubmissionDateClose) < @GetDate		--> or we could use this.  If SubmissionDateClose + 1 is less than TODAY, then we are beyond the SubmissionDateClose
	--and Sub.SubmissionDateClose < CONVERT(date,@GetDate)		--> or we could use this, which is close to the original, but CONVERT just returns the datepart

	--AND sub.SubmissionDateClose < GETDATE() -- original code

	--Modify [LD_UpdateDRG] to use DATEDIFF
	--Modify [LD_SelectDRGUpdates] to use DATEDIFF
	--Rollback SubmissionDateClose to original dates (one day earlier)

--As the Atlas Team, we want to modify the DRG update and rollback process so we allow updates/rollbacks up to and including the official submission close date. 