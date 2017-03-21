/*

S71_ATL-1419 Resurvey Exclusion for Returns Only - Rollback.sql

Chris Burkholder

3/20/2017

INSERT INTO SubTypeCategory
INSERT INTO SubType

select * from surveytype
select * from subtypecategory
select * from subtype
select * from surveytypesubtype

*/

USE [QP_Prod]
GO

delete from SurveyTypeSubtype where SurveyType_id = 7

declare @maxseed int

select @maxseed=max(SurveyTypeSubtype_id) from SurveyTypeSubtype
DBCC CHECKIDENT ('dbo.SurveyTypeSubtype', RESEED, @maxseed);  

delete from Subtype where Subtype_nm = 'Returns Only'

select @maxseed=max(Subtype_id) from Subtype
DBCC CHECKIDENT ('dbo.Subtype', RESEED, @maxseed);  

delete from SubTypeCategory where SubtypeCategory_nm = 'Resurvey Exclusion Type'

select @maxseed=max(SubtypeCategory_id) from SubtypeCategory
DBCC CHECKIDENT ('dbo.SubtypeCategory', RESEED, @maxseed);  

GO
