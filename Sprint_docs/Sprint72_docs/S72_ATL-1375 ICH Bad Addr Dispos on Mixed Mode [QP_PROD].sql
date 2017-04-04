/*
    S72_ATL-1375 ICH Bad Addr Dispos on Mixed Mode [QP_PROD].sql

	    ATL-1427 add bad addr & bad phone to ICH in SurveyTypeDispositions


	Chris Burkholder

	3/30/2017

	INSERT INTO SurveyTypeDispositions

	select * from SurveyTypeDispositions where surveytype_id = 8

	select * from surveytypedispositions std where [desc] like '%bad address and bad phone%'
	
*/

USE [QP_Prod]
GO

if not exists(select * from SurveyTypeDispositions where surveytype_id = 8 and disposition_id = 55)
	insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
		values(55,35,13,'Bad address and bad phone',0,NULL,8)
GO

update SurveyTypeDispositions set Hierarchy = 14 where surveytype_id = 8 and Disposition_id in (14,16)
update SurveyTypeDispositions set Hierarchy = 15 where surveytype_id = 8 and Disposition_id = 5
update SurveyTypeDispositions set Hierarchy = 16 where surveytype_id = 8 and Disposition_id in (12,25)

GO