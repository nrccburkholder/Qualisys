USE [QP_Prod]
GO

/*
Languages used for the old question core in production

1		English
2		Spanish
8		Pep-C Spanish
14		Portuguese
15		Hmong
16		Somali
18		MAGNUS Spanish
19		HCAHPS Spanish

*/


DECLARE @DO_IT as bit

SET @DO_IT = 0   -- set to 1 to do the actual updates, otherwise it will skip the update/insert/delete statements

DECLARE @OldQstnCore int
DECLARE @NewQstnCore int
DECLARE @NewScale_id int

SET @OldQstnCore = 43350 
SET @NewQstnCore = 50860
SET @NewScale_id = 8504

-- the current list of surveys using the old question core
SELECT sq.*      
  INTO #sel_qstns    
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = @OldQstnCore
AND sm.MethodologyType <> 'Telephone Only'
order by SURVEY_ID

print 'sel_qstns with old QstnCore'
select sq.*
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


-- temp table containing what will be the new second set of new sel_scls records -- the actual portuguese entries that we need to add
-- For now, the Richtext values are just placeholders until we get the proper translations
print '---------------------------------------'
print 'temp table containing what will be the new second set of new sel_scls records'
select ss.SURVEY_ID
	, @NewScale_id 'QPC_ID'
	, 6 'ITEM'
	,ss.[Language]
	, 6 'VAL'
	,'Portuguese' Label
	,CASE 
		WHEN ss.[Language] = 14 THEN  -- Portuguese
		'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Calibri;}}{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1033\f0\fs20 Português\par }'
		--WHEN ss.[Language] = 15 THEN -- Hmong
		--'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Calibri;}}{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1033\f0\fs20 Hmong Portuguese\par }'
		--WHEN ss.[Language] = 16 THEN	-- Somali
		--'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Calibri;}}{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1033\f0\fs20 Somali Portuguese\par }'
		WHEN ss.[Language] IN (2,8,18,19) THEN -- Spanish
		'{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Calibri;}}{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1033\f0\fs20 Portugués\par }'
		ELSE '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Calibri;}}{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1033\f0\fs20 Portuguese\par }'
	END RICHTEXT
	,ss.MISSING
	,ss.CHARSET
	, 6 'SCALEORDER'
	,ss.INTRESPTYPE
INTO #sel_scls_new
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid, [language] from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)


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

---- just testing the union to make sure it works
INSERT INTO #temp
SELECT * from #sel_scls
union all
select distinct *
from #sel_scls_new
order by SURVEY_ID, item, [language]

print '---------------------------------------'
print 'total records to be inserted (#temp)'
select * 
from #temp

-- rows to be deleted
print '---------------------------------------'
print 'rows to be deleted'
select *
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)
order by ss.SURVEY_ID, ss.item, ss.[language]


IF @DO_IT = 1
BEGIN
	BEGIN Transaction T1

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
	print 'We did it.  DO NOT FORGET TO COMMIT!!!!!'
END else print 'We did NOT do it.'


drop table #sel_qstns
drop table #sel_scls    
drop table #sel_scls_new   
drop table #temp

/*

rollback transaction T1

*/

/*

Commit Transaction T1

*/