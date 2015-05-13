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
Template	Old Core	New Core
PCMH-A		44228		52948
PCMH –P		46327		52949
PCMH – P	48856		52955

*/

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44121 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44121,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44122 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44122,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44123 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44123,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44124 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44124,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44125 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44125,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44126 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44126,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44127 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44127,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44129 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44129,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44130 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44130,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44134 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44134,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44135 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44135,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44136 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44136,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44139 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44139,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44140 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44140,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44141 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44141,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44142 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44142,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44147 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44147,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44148 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44148,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44150 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44150,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44152 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44152,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44155 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44155,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44157 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44157,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44158 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44158,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44161 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44161,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44162 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44162,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44168 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44168,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44169 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44169,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44171 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44171,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44172 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44172,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44173 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44173,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44174 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44174,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44181 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44181,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44164 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44164,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44165 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44165,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44190 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44190,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44191 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44191,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44175 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44175,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44176 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44176,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44188 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44188,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44187 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44187,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44166 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44166,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44201 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44201,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44202 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44202,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44203 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44203,44,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44204 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44204,45,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44226 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44226,46,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44227 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44227,47,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 52948 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,52948,48,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44229 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44229,49,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 44230 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,44230,50,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 48664 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,48664,51,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 48665 AND SubType_id = @Subtype_id_Adult)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,48665,52,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46265 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46265,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46266 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46266,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46267 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46267,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46268 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46268,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46269 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46269,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46270 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46270,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46271 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46271,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46272 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46272,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46273 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46273,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46274 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46274,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46275 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46275,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46276 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46276,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46277 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46277,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46278 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46278,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46279 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46279,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46280 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46280,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46281 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46281,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46282 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46282,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46283 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46283,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46284 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46284,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46285 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46285,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46286 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46286,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46287 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46287,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46288 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46288,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46289 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46289,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46290 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46290,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46291 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46291,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46292 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46292,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46293 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46293,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46294 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46294,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46295 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46295,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46296 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46296,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46297 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46297,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46298 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46298,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46299 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46299,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46300 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46300,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46301 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46301,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46302 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46302,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46303 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46303,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46304 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46304,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46305 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46305,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46306 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46306,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46307 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46307,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46308 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46308,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46309 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46309,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46310 AND SubType_id = @Subtype_id_Child)

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46310,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46311 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46311,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46312 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46312,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46313 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46313,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46314 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46314,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46315 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46315,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46316 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46316,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46317 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46317,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46318 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46318,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46319 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46319,61,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46320 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46320,62,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46321 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46321,63,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46322 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46322,64,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46323 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46323,65,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46324 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46324,66,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 52955 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,52955,67,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 46326 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,46326,68,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 52949 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,52949,69,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 48666 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,48666,70,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 48667 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,48667,71,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)

IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE  SurveyType_id = @SurveyType_ID AND QstnCore = 48668 AND SubType_id = @Subtype_id_Child)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyType_ID,48668,72,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)


--IF NOT EXISTS(SELECT 1 FROM [dbo].[SurveyTypeQuestionMappings] WHERE SurveyType_id = @SurveyType_id and QstnCore = 44121 and SubType_id = @Subtype_id_Adult)
--	INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44121,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44122,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44123,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44124,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44125,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44126,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44127,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44129,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44130,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44134,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44135,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44136,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44139,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44140,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44141,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44142,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44147,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44148,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44150,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44152,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44155,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44157,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44158,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44161,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44162,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44168,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44169,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44171,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44172,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44173,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44174,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44181,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44164,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44165,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44190,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44191,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44175,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44176,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44188,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44187,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44166,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44201,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44202,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44203,44,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44204,45,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44226,46,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44227,47,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,52948,48,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44229,49,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,44230,50,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48664,51,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48665,52,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Adult)

--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46265,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46266,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46267,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46268,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46269,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46270,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46271,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46272,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46273,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46274,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46275,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46276,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46277,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46278,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46279,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46280,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46281,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46282,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46283,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46284,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46285,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46286,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46287,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46288,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46289,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46290,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46291,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46292,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46293,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46294,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46295,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46296,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46297,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46298,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46299,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46300,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46301,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46302,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46303,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46304,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46305,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46306,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46307,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46308,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46309,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46310,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46311,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46312,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46313,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46314,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46315,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46316,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46317,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46318,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46319,61,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46320,62,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46321,63,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46322,64,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46323,65,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46324,66,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,52955,67,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,46326,68,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,52949,69,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48666,70,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48667,71,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)
--INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@Surveytype_id,48668,72,0,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id_Child)


/*

commit tran

rollback tran

*/