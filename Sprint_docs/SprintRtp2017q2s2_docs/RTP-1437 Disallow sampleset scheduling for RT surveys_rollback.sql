/*
RTP-1437 Disallow sampleset scheduling for RT surveys rollback

Hector Mata
*/

USE [QP_Prod]
GO

DELETE FROM QUALPRO_PARAMS WHERE STRPARAM_NM = 'SurveyRule: IsSamplesetSchedulingDisabled - Connect'
