/*
	RTP-2402 ODSDB Select Resurvey Settings

	Chris Burkhodler

	5/15/2017

	INSERT into QUALPRO_PARAMS

	select * from qualpro_params where strparam_grp = 'SamplingTool'
*/
Use [QP_Prod]
GO

if not exists (select * from QualPro_Params where strparam_nm = 'MasterSurveyTypeForODSDB')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('MasterSurveyTypeForODSDB','S','SamplingTool','13',NULL,NULL,'Legacy Connect Survey Type needed to read CustomerSurveyConfig')
GO