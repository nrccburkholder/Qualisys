/*
	RTP-3594 Rename SurveyType from PQRS to MIPS - Rollback.sql

	Lanny Boswell

	8/17/2017

*/

USE [QP_PROD]
GO

UPDATE SurveyType SET SurveyType_dsc = 'PQRS CAHPS' WHERE SurveyType_ID = 13 AND SurveyType_dsc = 'MIPS CAHPS'


GO