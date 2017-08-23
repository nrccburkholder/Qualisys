/*
	RTP-3594 Update QualPro_Params from PQRS to MIPS - Rollback.sql

	Lanny Boswell

	8/21/2017

	UPDATE QualPro_Params

*/

USE [QP_PROD]
GO

UPDATE QualPro_Params SET 
	STRPARAM_NM = REPLACE(STRPARAM_NM, 'MIPS', 'PQRS')
	WHERE STRPARAM_NM like '%MIPS%'
	AND STRPARAM_GRP = 'SurveyRules'

UPDATE QualPro_Params SET 
	COMMENTS = REPLACE(COMMENTS, 'MIPS', 'PQRS')
	WHERE COMMENTS like '%MIPS%'
	AND STRPARAM_GRP = 'SurveyRules'

GO