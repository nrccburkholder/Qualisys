

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

SET @DO_IT = 1   -- set to 1 to do the actual updates, otherwise it will skip the update/insert/delete statements

DECLARE @OldQstnCore int
DECLARE @NewQstnCore int


SET @OldQstnCore = 51620 
SET @NewQstnCore = 54067


-- the current list of surveys using the old question core
SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label     
  INTO #sel_qstns    
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[SURVEY_DEF] sd on sq.survey_id = sq.survey_id
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = @OldQstnCore
AND sm.MethodologyType <> 'Telephone Only'
and sd.surveytype_id = 11

order by SURVEY_ID

print 'sel_qstns with old QstnCore'
select sq.*
FROM #sel_qstns sq
order by sq.SELQSTNS_ID

select *
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct survey_id, scaleid from #sel_qstns) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)


select *
from [dbo].[SEL_SCLS] ss
where QPC_ID = 8615
order by SURVEY_ID, item

drop table #sel_qstns


select top 100 *
from [dbo].[SEL_SCLS] ss
where [label] = 'Russian'
order by ss.qpc_id desc

select sq.*
FROM [dbo].[SEL_QSTNS] sq
--inner join [dbo].[SEL_SCLS] ss on ss.QPC_id = sq.Scaleid
where sq.QSTNCORE = 54067
                          
