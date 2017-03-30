/*
    S72_ATL-1375 ICH Bad Addr Dispos on Mixed Mode [QP_PROD] - Rollback.sql

	    ATL-1427 add bad addr & bad phone to ICH in SurveyTypeDispositions


	Chris Burkholder

	3/30/2017

	INSERT INTO SurveyTypeDispositions

	select * from SurveyTypeDispositions where surveytype_id = 8

	select * from surveytypedispositions std where [desc] like '%bad address and bad phone%'
	
*/

USE [QP_Prod]
GO

delete from SurveyTypeDispositions where surveytype_id = 8 and disposition_id = 55
GO

declare @maxseed int
select @maxseed=max(SurveyTypeDispositionID) from SurveyTypeDispositions
DBCC CHECKIDENT ('dbo.SurveyTypeDispositions', RESEED, @maxseed);
GO