/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S68 ATL-1363 Hospice CAHPS Survey Lang Question Update

	As the Manager of Corporate Compliance, I want all Hospice CAHPS questionnaires updated with the new Language Speak 
	question instead of the existing, so that we do not have discrepancies for fielding an incorrect question.

	Old core # is 55137; new core # is 56642.
	Need to update survey validation.
	Need to check if it's an ATA question.
	Must be promoted to production after December decedents' second surveys generate and before January decedents first surveys generate, i.e. a 2-3 day window near the end of March.

	ATL-1392 Survey Validation
	ATL-1393 CEM Template
	ATL-1394 Script to update questionnaires
	ATL-1395 Modify completeness function - CheckForCAHPSIncompletes
*/

USE QP_Prod
GO

DECLARE @surveytype_id int

select @surveytype_id = SurveyType_ID 
from dbo.surveytype
where SurveyType_dsc = 'Hospice CAHPS'

select *
from dbo.SurveyTypeQuestionMappings
where SurveyType_id = @surveytype_id
and QstnCore in ( 55137,56642)

DECLARE @OldQstnCore int
DECLARE @NewQstnCore int


SET @OldQstnCore = 55137 
SET @NewQstnCore = 56642

 begin tran

 update stqm
	SET datEncounterEnd_dt = '2999-12-31 00:00:00.000'
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] stqm
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore 

   DELETE
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @NewQstnCore 


  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore



commit tran

GO


USE [QP_Prod]
GO

IF OBJECT_ID('tempdb..#sel_qstns') IS NOT NULL DROP TABLE #sel_qstns
IF OBJECT_ID('tempdb..#sel_scls') IS NOT NULL DROP TABLE #sel_scls
IF OBJECT_ID('tempdb..#sel_scls_new') IS NOT NULL DROP TABLE #sel_scls_new
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc

DECLARE @DO_IT as bit

SET @DO_IT = 0   -- set to 1 to do the actual updates, otherwise it will skip the update/insert/delete statements

DECLARE @OldQstnCore int
DECLARE @NewQstnCore int
DECLARE @NewScale_id int
DECLARE @OldScale_id int

SET @OldQstnCore = 55137 
SET @NewQstnCore = 56642

SET @NewScale_id = 9212  -- this id comes from the new scale created in QuestionLibrary - old Scale id (qpc_id) was 9029
SET @OldScale_id = 9029

-- the current list of surveys using the old question core

SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language]
  INTO #sel_qstns    
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[SURVEY_DEF] sd on sd.survey_id = sq.survey_id
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = @NewQstnCore
--and sq.survey_id not in (17458) -- excluding this survey as per Rachel 5/25/2016
and sd.surveytype_id = @SurveyType_ID


select 'sel_qstns with old QstnCore', sq.*
FROM #sel_qstns sq
order by sq.SELQSTNS_ID


-- temp table containing what will be the new first set of new sel_scls records - existing records with updated qpc_id and shifted item, val and scaleorder values
-- shifts "Some other language' down two positions
print '---------------------------------------'
print 'temp table containing what will be the new first set of new sel_scls records'
select ss.SURVEY_ID
	, @NewScale_id 'QPC_ID'
	, CASE ss.item
		WHEN 9 THEN 7
		ELSE ss.ITEM
	END 'ITEM'
	,ss.[Language]
	, CASE ss.VAL
		WHEN 9 THEN 7
		ELSE ss.VAL
	END 'VAL'
	,ss.LABEL
	,ss.RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, CASE ss.SCALEORDER
		WHEN 9 THEN 7
		ELSE ss.SCALEORDER
	END 'SCALEORDER'
	,ss.INTRESPTYPE
INTO #sel_scls
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)



CREATE TABLE #temp
(
	[SURVEY_ID] [int] NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[ITEM] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[VAL] [int] NOT NULL,
	[LABEL] [char](60) NULL,
	[RICHTEXT] [text] NULL,
	[MISSING] [bit] NOT NULL,
	[CHARSET] [int] NULL,
	[SCALEORDER] [int] NULL,
	[INTRESPTYPE] [int] NULL
)


-- rows to be deleted
print '---------------------------------------'
print 'rows to be deleted'
select 'rows to be deleted',*
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)
order by ss.SURVEY_ID, ss.item, ss.[language]


IF @DO_IT = 1
BEGIN

	BEGIN tran

	print 'We are doing it!'
	-- update sel_qstns with new core and scale id
	update sq
		SET 
			sq.QSTNCORE = @OldQstnCore,
			sq.SCALEID = @OldScale_id,
			sq.NUMBUBBLECOUNT = 7
	FROM [dbo].[SEL_QSTNS] sq
	INNER JOIN #sel_qstns sqx on (sqx.[SELQSTNS_ID] = sq.[SELQSTNS_ID] AND sqx.SURVEY_ID = sq.SURVEY_ID and sqx.[LANGUAGE] = sq.[LANGUAGE])
	print 'SQL_QSTNS updated'

	-- Insert new records into sel_scls
	INSERT INTO SEL_SCLS
	SELECT * from #sel_scls

	print 'new rows inserted into SEL_SCLS'

	-- Delete all sel_scls records for surveys using the new question core 
	delete ss
	from [dbo].[SEL_SCLS] ss
	inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)
	print 'rows deleted'
	print ''
	print 'We did it.  '

	commit tran


	select *
	from [dbo].[SEL_SCLS] ss
	inner join (SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language] 
		FROM [dbo].[SEL_QSTNS] sq
		INNER JOIN [dbo].[SURVEY_DEF] sd on sq.survey_id = sq.survey_id
		INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
		INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
		where sq.QSTNCORE = @OldQstnCore
		and sd.surveytype_id = @SurveyType_ID
	) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)

END else print 'We did NOT do it.'


IF OBJECT_ID('tempdb..#sel_qstns') IS NOT NULL DROP TABLE #sel_qstns
IF OBJECT_ID('tempdb..#sel_scls') IS NOT NULL DROP TABLE #sel_scls
IF OBJECT_ID('tempdb..#sel_scls_new') IS NOT NULL DROP TABLE #sel_scls_new
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

/*

rollback transaction T1

*/

GO