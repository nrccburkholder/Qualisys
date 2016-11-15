/*
	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S62 ATL-1103
	Disposition TOCLs for ACO & PQRS

	As an authorized vendor for ACO & PQRS, we need to disposition records that didn't generate due to TOCL as "40 - excluded from survey", so that we submit accurate data.

	ATL-1120 Backpopulate ACO and PQRS patients that should be dispositioned thusly

	Tim Butler

*/

use QP_Prod

DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'

IF OBJECT_ID('tempdb..#Survey') IS NOT NULL DROP TABLE #Survey

SELECT * 
INTO #Survey
FROM dbo.Survey_Def sd
WHERE SurveyType_id = @Surveytype_id

--SELECT * FROM #Survey

IF OBJECT_ID('tempdb..#SampleSet') IS NOT NULL DROP TABLE #SampleSet

SELECT ss.* 
INTO #SampleSet
FROM dbo.SampleSet ss 
INNER JOIN #Survey s on s.SURVEY_ID = ss.SURVEY_ID

--select * from #SampleSet order by SURVEY_ID

IF OBJECT_ID('tempdb..#SelectedSample') IS NOT NULL DROP TABLE #SelectedSample

SELECT ss.study_id
, ss.POP_ID
, sp.SAMPLEPOP_ID
, sm.SENTMAIL_ID
, sm.DATGENERATE
INTO #SelectedSample
FROM dbo.SELECTEDSAMPLE ss
INNER JOIN #SampleSet s on s.SAMPLESET_ID = ss.SAMPLESET_ID
INNER JOIN dbo.SAMPLEPOP sp on sp.STUDY_ID = ss.STUDY_ID and sp.POP_ID = ss.POP_ID
INNER JOIN dbo.SCHEDULEDMAILING sm on sm.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
WHERE sm.SENTMAIL_ID = -1
and ss.SampleEncounterDate between '2016-01-01' and GETDATE()


--select * from #SelectedSample


GO

DECLARE @Disposition_id int
DECLARE @label varchar(100) = 'TOCL During Generation'

SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = @label

update dl 
	SET Disposition_id = 8
from dbo.DispositionLog dl
inner join #SelectedSample ss on ss.SAMPLEPOP_ID = dl.SamplePop_id
inner join dbo.TOCL t on t.STUDY_ID = ss.STUDY_ID and t.POP_ID = ss.POP_ID
where dl.SentMail_id = -1 and LoggedBy in ('SP_FG_FormGen','SP_FG_NonMailGen')
and dl.Disposition_id = @Disposition_id

GO

use QP_Prod

DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'PQRS CAHPS'

IF OBJECT_ID('tempdb..#Survey') IS NOT NULL DROP TABLE #Survey

SELECT * 
INTO #Survey
FROM dbo.Survey_Def sd
WHERE SurveyType_id = @Surveytype_id

--SELECT * FROM #Survey

IF OBJECT_ID('tempdb..#SampleSet') IS NOT NULL DROP TABLE #SampleSet

SELECT ss.* 
INTO #SampleSet
FROM dbo.SampleSet ss 
INNER JOIN #Survey s on s.SURVEY_ID = ss.SURVEY_ID

--select * from #SampleSet order by SURVEY_ID

IF OBJECT_ID('tempdb..#SelectedSample') IS NOT NULL DROP TABLE #SelectedSample

SELECT ss.study_id
, ss.POP_ID
, sp.SAMPLEPOP_ID
, sm.SENTMAIL_ID
, sm.DATGENERATE
INTO #SelectedSample
FROM dbo.SELECTEDSAMPLE ss
INNER JOIN #SampleSet s on s.SAMPLESET_ID = ss.SAMPLESET_ID
INNER JOIN dbo.SAMPLEPOP sp on sp.STUDY_ID = ss.STUDY_ID and sp.POP_ID = ss.POP_ID
INNER JOIN dbo.SCHEDULEDMAILING sm on sm.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
WHERE sm.SENTMAIL_ID = -1
and ss.SampleEncounterDate between '2016-01-01' and GETDATE()


--select * from #SelectedSample


GO

DECLARE @Disposition_id int
DECLARE @label varchar(100) = 'TOCL During Generation'

SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = @label

update dl 
	SET Disposition_id = 8
from dbo.DispositionLog dl
inner join #SelectedSample ss on ss.SAMPLEPOP_ID = dl.SamplePop_id
inner join dbo.TOCL t on t.STUDY_ID = ss.STUDY_ID and t.POP_ID = ss.POP_ID
where dl.SentMail_id = -1 and LoggedBy in ('SP_FG_FormGen','SP_FG_NonMailGen')
and dl.Disposition_id = @Disposition_id

GO