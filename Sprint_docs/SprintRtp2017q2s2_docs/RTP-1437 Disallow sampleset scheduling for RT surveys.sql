/*
RTP-1437 Disallow sampleset scheduling for RT surveys

Hector Mata
*/

USE [QP_Prod]
GO

IF NOT EXISTS (SELECT * FROM QUALPRO_PARAMS WHERE STRPARAM_NM = 'SurveyRule: IsSamplesetSchedulingDisabled - Connect')
INSERT INTO [QP_Prod].[dbo].[QUALPRO_PARAMS] 
  	(STRPARAM_NM, 
	STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
  VALUES
  ('SurveyRule: IsSamplesetSchedulingDisabled - Connect', 'S', 'SurveyRules', 1, 'Disable sampleset scheduling if survey type is connect')

GO