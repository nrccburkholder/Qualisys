/*

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
	SET datEncounterEnd_dt = '2016-12-31 00:00:00.000'
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] stqm
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore 


  IF not exists ( SELECT * FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] where SurveyType_id = @SurveyType_ID and QstnCore = @NewQstnCore)
  begin 

	INSERT INTO [dbo].[SurveyTypeQuestionMappings]
           ([SurveyType_id]
           ,[QstnCore]
           ,[intOrder]
           ,[bitFirstOnForm]
           ,[bitExpanded]
           ,[datEncounterStart_dt]
           ,[datEncounterEnd_dt]
           ,[SubType_ID]
           ,[isATA]
           ,[isMeasure])
     VALUES
           (@SurveyType_ID
           ,@NewQstnCore
           ,47
           ,0
           ,0
           ,'2017-01-01 00:00:00.000'
           ,'2999-12-31 00:00:00.000'
           ,0
           ,1
           ,0)
	end

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @NewQstnCore 

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

SET @OldQstnCore = 55137 
SET @NewQstnCore = 56642

SET @NewScale_id =  9212 -- this id comes from the new scale created in QuestionLibrary - old Scale id (qpc_id) was 9029

-- the current list of surveys using the old question core

SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language]
  INTO #sel_qstns    
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[SURVEY_DEF] sd on sd.survey_id = sq.survey_id
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = @OldQstnCore
and sq.survey_id not in (?????????) -- excluding this survey as per Rachel 5/25/2016
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
		WHEN 7 THEN 9
		ELSE ss.ITEM
	END 'ITEM'
	,ss.[Language]
	, CASE ss.VAL
		WHEN 7 THEN 9
		ELSE ss.VAL
	END 'VAL'
	,ss.LABEL
	,ss.RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, CASE ss.SCALEORDER
		WHEN 7 THEN 9
		ELSE ss.SCALEORDER
	END 'SCALEORDER'
	,ss.INTRESPTYPE
INTO #sel_scls
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)



CREATE TABLE #sel_scls_new
(
	[SURVEY_ID] [int] NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[ITEM] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[VAL] [int] NOT NULL,
	[LABEL] [char](60) NULL,
	[RICHTEXT] [varchar](500) NULL,
	[MISSING] [bit] NOT NULL,
	[CHARSET] [int] NULL,
	[SCALEORDER] [int] NULL,
	[INTRESPTYPE] [int] NULL
)
  


-- temp table containing what will be the new second set of new sel_scls records -- the polish entries that we need to add
print '---------------------------------------'
print 'temp table containing what will be the new second set of new sel_scls records -- the actual Polish entries that we need to add'
INSERT INTO #sel_scls_new
select ss.SURVEY_ID
	, @NewScale_id 'QPC_ID'
	, 7 'ITEM'
	,ss.[Language]
	, 7 'VAL'
	,'Polish' Label
	,CASE 
		WHEN ss.[Language] IN (2,8,18,19) THEN 
		'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil MS Sans Serif;}}\viewkind4\uc1\pard\lang1033\f0\fs16 Polaco\par }'
		ELSE '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil MS Sans Serif;}}
\viewkind4\uc1\pard\lang1033\f0\fs16 Polish
\par }
'
	END RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, 7 'SCALEORDER'
	,ss.INTRESPTYPE
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid, [language] from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)


-- temp table containing what will be the new second set of new sel_scls records -- the actual Korean entries that we need to add
print '---------------------------------------'
print 'temp table containing what will be the new second set of new sel_scls records -- the actual Korean entries that we need to add'

INSERT INTO #sel_scls_new
select ss.SURVEY_ID
	, @NewScale_id 'QPC_ID'
	, 8 'ITEM'
	,ss.[Language]
	, 8 'VAL'
	,'Korean' Label
	,CASE 
		WHEN ss.[Language] IN (2,8,18,19) THEN 
		'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil MS Sans Serif;}}\viewkind4\uc1\pard\lang1033\f0\fs16 Coreano\par }'
		ELSE '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil MS Sans Serif;}}
\viewkind4\uc1\pard\lang1033\f0\fs16 Korean
\par }
'
	END RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, 8 'SCALEORDER'
	,ss.INTRESPTYPE
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid, [language] from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)


select '#sel_scls_new',*
from #sel_scls_new
order by SURVEY_ID, item, [language]

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

---- just testing the union to make sure it looks okay
INSERT INTO #temp
SELECT * 
from #sel_scls
union all
select distinct *
from #sel_scls_new
order by SURVEY_ID, item, [language]

print '---------------------------------------'
print 'total records to be inserted (#temp)'
select 'total records to be inserted (#temp)',* 
from #temp

-- rows to be deleted
print '---------------------------------------'
print 'rows to be deleted'
select 'rows to be deleted',*
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)
order by ss.SURVEY_ID, ss.item, ss.[language]


IF @DO_IT = 1
BEGIN


IF not EXISTS (SELECT 1 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'dbo' 
           AND TABLE_NAME='bak_SEL_QSTNS_AllCAHPS_Release068') 
begin

	print '---------------------------------------'
	print 'backup for SEL_QSTNS'
		select sq.*
		into bak_SEL_QSTNS_AllCAHPS_Release068
		from SEL_QSTNS sq
		INNER JOIN [dbo].[SURVEY_DEF] sd on sd.survey_id = sq.survey_id
		and sd.surveytype_id = @SurveyType_ID


end

IF not EXISTS (SELECT 1 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'dbo' 
           AND TABLE_NAME='bak_SEL_SCLS_AllCAHPS_Release068') 
begin

	print '---------------------------------------'
	print 'backup for SEL_SCLS'
		select ss.*
		into bak_SEL_SCLS_AllCAHPS_Release068
		from SEL_SCLS ss
		INNER JOIN [dbo].[SURVEY_DEF] sd on sd.survey_id = ss.survey_id
		and sd.surveytype_id = @SurveyType_ID

end
	BEGIN tran

	print 'We are doing it!'
	-- update sel_qstns with new core and scale id
	update sq
		SET 
			sq.QSTNCORE = @NewQstnCore,
			sq.SCALEID = @NewScale_id,
			sq.NUMBUBBLECOUNT = 7
	FROM [dbo].[SEL_QSTNS] sq
	INNER JOIN #sel_qstns sqx on (sqx.[SELQSTNS_ID] = sq.[SELQSTNS_ID] AND sqx.SURVEY_ID = sq.SURVEY_ID and sqx.[LANGUAGE] = sq.[LANGUAGE])
	print 'SQL_QSTNS updated'

	-- Insert new records into sel_scls
	INSERT INTO SEL_SCLS
	SELECT * from #sel_scls
	union all
	select distinct *
	from #sel_scls_new
	order by SURVEY_ID, item, [language]
	print 'new rows inserted into SEL_SCLS'

	-- Delete all sel_scls records for surveys using the old question core 
	delete ss
	from [dbo].[SEL_SCLS] ss
	inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)
	print 'rows deleted'
	print ''
	print 'We did it.  !'

	commit tran


	select *
	from [dbo].[SEL_SCLS] ss
	inner join (SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language] 
		FROM [dbo].[SEL_QSTNS] sq
		INNER JOIN [dbo].[SURVEY_DEF] sd on sq.survey_id = sq.survey_id
		INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
		INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
		where sq.QSTNCORE = @NewQstnCore
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