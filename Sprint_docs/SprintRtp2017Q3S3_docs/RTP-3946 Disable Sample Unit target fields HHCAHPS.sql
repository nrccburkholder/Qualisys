/*
	RTP-3946 Disable Sample Unit target fields HHCAHPS.sql

	Chris Burkholder

	9/8/2017

	INSERT INTO QUALPRO_PARAMS

select * from qualpro_params where strparam_nm like '%surveyrule%HCAHPS%' order by strparam_nm
select * from qualpro_params where strparam_nm like '%surveyrule%OAS%' order by strparam_nm
select * from qualpro_params where strparam_nm like '%surveyrule%Home%' order by strparam_nm
*/

USE [QP_Prod]
GO

if not exists (select * from qualpro_params where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - Home Health CAHPS')
INSERT INTO [dbo].[QUALPRO_PARAMS]
           ([STRPARAM_NM]
           ,[STRPARAM_TYPE]
           ,[STRPARAM_GRP]
           ,[STRPARAM_VALUE]
           ,[NUMPARAM_VALUE]
           ,[DATPARAM_VALUE]
           ,[COMMENTS])
SELECT replace([STRPARAM_NM], 'HCAHPS IP', 'Home Health CAHPS')
      ,[STRPARAM_TYPE]
      ,[STRPARAM_GRP]
      ,[STRPARAM_VALUE]
      ,[NUMPARAM_VALUE]
      ,[DATPARAM_VALUE]
      ,replace([COMMENTS], 'HCAHPS IP', 'Home Health CAHPS')
  FROM [dbo].[QUALPRO_PARAMS]
where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - HCAHPS IP'

if not exists (select * from qualpro_params where strparam_nm = 'SurveyRule: BypassInitRespRateNumericEnforcement - Home Health CAHPS')
INSERT INTO [dbo].[QUALPRO_PARAMS]
           ([STRPARAM_NM]
           ,[STRPARAM_TYPE]
           ,[STRPARAM_GRP]
           ,[STRPARAM_VALUE]
           ,[NUMPARAM_VALUE]
           ,[DATPARAM_VALUE]
           ,[COMMENTS])
SELECT replace([STRPARAM_NM], 'HCAHPS IP', 'Home Health CAHPS')
      ,[STRPARAM_TYPE]
      ,[STRPARAM_GRP]
      ,[STRPARAM_VALUE]
      ,[NUMPARAM_VALUE]
      ,[DATPARAM_VALUE]
      ,replace([COMMENTS], 'HCAHPS IP', 'Home Health CAHPS')
  FROM [dbo].[QUALPRO_PARAMS]
where strparam_nm = 'SurveyRule: BypassInitRespRateNumericEnforcement - HCAHPS IP'

GO