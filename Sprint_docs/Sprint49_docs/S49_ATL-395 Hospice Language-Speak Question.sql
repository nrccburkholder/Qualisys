/*

S49 ATL-395 Hospice CAHPS Lang Speak Question Update

As an approved Hospice CAHPS vendor, we need to update our processes to handle a change to the language-speak question, so that we comply with mandatory requirements.


ATL-396 - Update Survey Validation

ATL-398 - Update existing surveys (programmatically update all Hospice CAHPS surveys with core 55137 instead of 54067.

Tim Butler


*/

USE [QP_Prod]
GO


-- ATL-396
DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc


DECLARE @OldQstnCore int
DECLARE @NewQstnCore int


SET @OldQstnCore = 54067 
SET @NewQstnCore = 55137

 begin tran

 update stqm
	SET datEncounterEnd_dt = '2016-02-29 00:00:00.000'
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
           ,'2016-03-01 00:00:00.000'
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

-- ATL-398
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
DECLARE @NewScale_id int

SET @OldQstnCore = 54067 
SET @NewQstnCore = 55137

SET @NewScale_id = 9029 -- this id comes from the new scale created in QuestionLibrary - old Scale id (qpc_id) was 8850

-- the current list of surveys using the old question core

SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language]
  INTO #sel_qstns    
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[SURVEY_DEF] sd on sd.survey_id = sq.survey_id
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = @OldQstnCore
--and sq.survey_id not in (17516) -- excluding this survey as per Rachel 12/21/2015
and sd.surveytype_id = @SurveyType_ID


select 'sel_qstns with old QstnCore', sq.*
FROM #sel_qstns sq
order by sq.SELQSTNS_ID


-- temp table containing what will be the new first set of new sel_scls records - existing records with updated qpc_id and shifted item, val and scaleorder values
print '---------------------------------------'
print 'temp table containing what will be the new first set of new sel_scls records'
select ss.SURVEY_ID
	, @NewScale_id 'QPC_ID'
	, CASE ss.item
		WHEN 6 THEN 7
		ELSE ss.ITEM
	END 'ITEM'
	,ss.[Language]
	, CASE ss.VAL
		WHEN 6 THEN 7
		ELSE ss.VAL
	END 'VAL'
	,ss.LABEL
	,ss.RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, CASE ss.SCALEORDER
		WHEN 6 THEN 7
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
  


-- temp table containing what will be the new second set of new sel_scls records -- the actual vietnamese entries that we need to add
print '---------------------------------------'
print 'temp table containing what will be the new second set of new sel_scls records -- the actual vietnamese entries that we need to add'
INSERT INTO #sel_scls_new
select ss.SURVEY_ID
	, @NewScale_id 'QPC_ID'
	, 6 'ITEM'
	,ss.[Language]
	, 6 'VAL'
	,'Vietnamese' Label
	,CASE 
		WHEN ss.[Language] IN (2,8,18,19) THEN -- Spanish
		'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil MS Sans Serif;}}\viewkind4\uc1\pard\lang1033\f0\fs16 Vietnamita\par }'
		ELSE '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil MS Sans Serif;}}
\viewkind4\uc1\pard\lang1033\f0\fs16 Vietnamese
\par }
'
	END RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, 6 'SCALEORDER'
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
           AND TABLE_NAME='bak_SEL_QSTNS_AllCAHPS_Release049') 
begin

	print '---------------------------------------'
	print 'backup for SEL_QSTNS'
		select sq.*
		into bak_SEL_QSTNS_AllCAHPS_Release049
		from SEL_QSTNS sq
		INNER JOIN [dbo].[SURVEY_DEF] sd on sd.survey_id = sq.survey_id
		and sd.surveytype_id = @SurveyType_ID


end

IF not EXISTS (SELECT 1 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'dbo' 
           AND TABLE_NAME='bak_SEL_SCLS_AllCAHPS_Release049') 
begin

	print '---------------------------------------'
	print 'backup for SEL_SCLS'
		select ss.*
		into bak_SEL_SCLS_AllCAHPS_Release049
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


drop table #sel_qstns
drop table #sel_scls    
drop table #sel_scls_new   
drop table #temp

/*

rollback transaction T1

*/

