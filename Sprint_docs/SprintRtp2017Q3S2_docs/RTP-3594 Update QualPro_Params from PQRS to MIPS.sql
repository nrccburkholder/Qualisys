/*
	RTP-3594 Update QualPro_Params from PQRS to MIPS.sql

	Lanny Boswell

	8/21/2017

	UPDATE QualPro_Params

*/

USE [QP_PROD]
GO

UPDATE QualPro_Params SET 
	STRPARAM_NM = REPLACE(STRPARAM_NM, 'PQRS', 'MIPS')
	WHERE STRPARAM_NM like '%PQRS%'
	AND STRPARAM_GRP = 'SurveyRules'

UPDATE QualPro_Params SET 
	COMMENTS = REPLACE(COMMENTS, 'PQRS', 'MIPS')
	WHERE COMMENTS like '%PQRS%'
	AND STRPARAM_GRP = 'SurveyRules'

GO