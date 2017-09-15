/*
	RTP-3655 MIPS: Updates for New Question.sql
	Jing Fu, 9/15/2017
	Table:
		- Add one record to table SurveyTypeQuestionMappings
*/

USE QP_Prod
GO

PRINT 'Start table changes'
GO

IF NOT EXISTS (SELECT QstnCore FROM dbo.SurveyTypeQuestionMappings WHERE surveyType_ID=13 AND QstnCore=57684)
BEGIN
	UPDATE  dbo.SurveyTypeQuestionMappings SET intOrder=intOrder+1  WHERE surveyType_ID=13 AND intOrder>=76

	INSERT INTO dbo.SurveyTypeQuestionMappings
           (SurveyType_id
           ,QstnCore
           ,intOrder
           ,bitFirstOnForm
           ,bitExpanded
           ,datEncounterStart_dt
           ,datEncounterEnd_dt
           ,SubType_ID
           ,isATA
           ,isMeasure
           ,isIgnoredIfCloserNestingExists)
     VALUES
           (13, 57684, 76, 1, 0, '11/1/2017', '12/31/2999',	0,	1,	0,	0)
END
GO

PRINT 'End table changes'
GO

