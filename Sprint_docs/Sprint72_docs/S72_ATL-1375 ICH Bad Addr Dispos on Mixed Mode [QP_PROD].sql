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
		values(55,35,11,'Bad address and bad phone',0,NULL,8)
GO