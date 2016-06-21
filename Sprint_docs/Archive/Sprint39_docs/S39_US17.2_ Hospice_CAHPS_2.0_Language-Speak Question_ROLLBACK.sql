/*

S39 US 17 Hospice CAHPS 2.0 Language-Speak Question 

As a Hospice CAHPS vendor, we must update the language spoken question, so that we are fielding according to protocols.


Task 2 - Update the table for survey validation

Task 3 - Create a script to programmatically update all Hospice CAHPS surveys with core 54067 instead of 51620.

Tim Butler

ROLLBACK

*/

USE [QP_Prod]
GO


-- TASK 2
DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc


DECLARE @OldQstnCore int
DECLARE @NewQstnCore int


SET @OldQstnCore = 51620 
SET @NewQstnCore = 54067

 begin tran

 update stqm
	SET datEncounterEnd_dt = '2999-12-31 00:00:00.000'
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] stqm
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore 


  IF exists ( SELECT * FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings] where SurveyType_id = @SurveyType_ID and QstnCore = @NewQstnCore)
  begin 

  DELETE FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @NewQstnCore 

end

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @OldQstnCore

  SELECT *
  FROM [QP_Prod].[dbo].[SurveyTypeQuestionMappings]
  where SurveyType_id = @SurveyType_ID
  and QstnCore = @NewQstnCore 

  rollback tran

  GO

-- TASK 3
/*
Languages used for the old question core in production

1		English
2		Spanish
27		Chinese
29		Russian
14		Portuguese
19		HCAHPS Spanish

*/


USE [QP_Prod]
GO

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc

DECLARE @DO_IT as bit

SET @DO_IT = 1   -- set to 1 to do the actual updates, otherwise it will skip the update/insert/delete statements

DECLARE @OldQstnCore int
DECLARE @NewQstnCore int
DECLARE @OldSCale_id int
DECLARE @NewScale_id int

SET @OldQstnCore = 51620 
SET @NewQstnCore = 54067

SET @OldSCale_id = 8615
SET @NewScale_id = 8850

-- the current list of surveys using the old question core
SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language]
  INTO #sel_qstns    
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[SURVEY_DEF] sd on sq.survey_id = sq.survey_id
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = @NewQstnCore
and sd.surveytype_id = @SurveyType_ID

print 'sel_qstns with new QstnCore'
select sq.*
FROM #sel_qstns sq
order by sq.SELQSTNS_ID


-- temp table containing existing records with updated qpc_id and shifted item, val and scaleorder values
print '---------------------------------------'
print 'temp table containing existing records with updated qpc_id and shifted item, val and scaleorder values'
select ss.SURVEY_ID
	, @OldScale_id 'QPC_ID'
	, CASE ss.item
		WHEN 6 THEN 4
		ELSE ss.ITEM
	END 'ITEM'
	,ss.[Language]
	, CASE ss.VAL
		WHEN 6 THEN 4
		ELSE ss.VAL
	END 'VAL'
	,ss.LABEL
	,ss.RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, CASE ss.SCALEORDER
		WHEN 6 THEN 4
		ELSE ss.SCALEORDER
	END 'SCALEORDER'
	,ss.INTRESPTYPE
INTO #sel_scls
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)
where ss.[label] not in ('Russian', 'Portuguese')                                                


select '#sel_scls',*
from #sel_scls
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
			sq.NUMBUBBLECOUNT = 4
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


drop table #sel_qstns
drop table #sel_scls    
drop table #temp

