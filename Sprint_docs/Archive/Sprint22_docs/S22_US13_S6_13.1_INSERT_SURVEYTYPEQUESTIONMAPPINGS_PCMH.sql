/*
	S24 US13:  Setup PCHM survey validation

	T. Butler	
*/

USE QP_PROD
GO

DECLARE @Surveytype_id int
DECLARE @Subtype_id_Adult int
DECLARE @Subtype_id_Child int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

select @Subtype_id_Adult = Subtype_Id
from Subtype
where Subtype_nm = '12-month Adult 2.0 w/ PCMH'

select @Subtype_id_Child = Subtype_Id
from Subtype
where Subtype_nm = '12-month Child 2.0 w/ PCMH'

begin tran

/*

Contains these changes from the original:

Template	Old Core	New Core
PCMH -A		44228		52948
PCMH –P		46327		52949
PCMH –P		48856		52955

*/

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] in (@Subtype_id_Adult, @Subtype_id_Child) 


INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44121,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44122,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44123,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44124,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44125,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44126,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44127,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44129,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44130,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44134,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44135,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44136,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44139,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44140,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44141,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44142,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44147,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44148,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44150,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44152,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44155,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44157,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44158,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44161,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44162,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44168,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44169,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44171,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44172,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44173,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44174,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44181,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44164,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44165,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44190,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44191,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44175,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44176,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44188,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44187,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44166,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44201,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44202,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44203,44,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44204,45,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44226,46,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44227,47,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,52948,48,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44229,49,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44230,50,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48664,51,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48665,52,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46265,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46266,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46267,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46268,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46269,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46270,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46271,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46272,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46273,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46274,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46275,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46276,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46277,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46278,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46279,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46280,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46281,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46282,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46283,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46284,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46285,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46286,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46287,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46288,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46289,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46290,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46291,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46292,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46293,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46294,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46295,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46296,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46297,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46298,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46299,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46300,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46301,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46302,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46303,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46304,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46305,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46306,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46307,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46308,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46309,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46310,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46311,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46312,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46313,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46314,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46315,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46316,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46317,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46318,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46319,61,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46320,62,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46321,63,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46322,64,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46323,65,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46324,66,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,52955,67,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46326,68,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,52949,69,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48666,70,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48667,71,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48668,72,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)


commit tran

/*



rollback tran

*/