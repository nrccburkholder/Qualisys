/*

S70 RTP-1672 Prioritize Qualisys-HCAHPS above RT-HCAHPS.sql

3/7/2017

Chris Burkholder

*/

USE [QP_Prod]
GO

insert into QualPro_Params
(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
VALUES('SurveyRule: SamplingToolPriority - RT','N','SurveyRules',NULL,3,NULL,'RT Sampling Tool Priority is 3')

select * from QUALPRO_PARAMS where strparam_nm like '%samplingToolPriority%'

GO