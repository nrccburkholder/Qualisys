/*
	RTP-3655 MIPS: Updates for New Question - Rollback.sql
	Jing Fu, 9/15/2017
	Table:
		- Remove one record for MIPS new question from table SurveyTypeQuestionMappings
*/

USE QP_Prod
GO

PRINT 'Start table changes'
GO

IF EXISTS (SELECT QstnCore FROM dbo.SurveyTypeQuestionMappings WHERE surveyType_ID=13 AND QstnCore=57684)
BEGIN
	DELETE dbo.SurveyTypeQuestionMappings WHERE surveyType_ID=13 AND QstnCore=57684
	UPDATE  dbo.SurveyTypeQuestionMappings SET intOrder=intOrder-1  WHERE surveyType_ID=13 AND intOrder>=77
END
GO

PRINT 'End table changes'
GO

