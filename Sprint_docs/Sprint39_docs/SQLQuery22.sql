DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc


DECLARE @OldQstnCore int
DECLARE @NewQstnCore int
DECLARE @NewScale_id int

SET @OldQstnCore = 51620 
SET @NewQstnCore = 54067

SET @NewScale_id = 8850

select sq.SURVEY_ID, ss.*
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language] 
	FROM [dbo].[SEL_QSTNS] sq
	INNER JOIN [dbo].[SURVEY_DEF] sd on sq.survey_id = sq.survey_id
	INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
	INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
	where sq.QSTNCORE = @NewQstnCore
	and sd.surveytype_id = @SurveyType_ID
) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)


select sq.SURVEY_ID, ss.*
from [dbo].[SEL_SCLS] ss
inner join (SELECT distinct sq.selqstns_id, sq.survey_id, sq.scaleid, sq.label, sq.[language] 
	FROM [dbo].[SEL_QSTNS] sq
	INNER JOIN [dbo].[SURVEY_DEF] sd on sq.survey_id = sq.survey_id
	INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
	INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
	where sq.QSTNCORE = @oldQstnCore
	and sd.surveytype_id = @SurveyType_ID
) sq on (ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID)