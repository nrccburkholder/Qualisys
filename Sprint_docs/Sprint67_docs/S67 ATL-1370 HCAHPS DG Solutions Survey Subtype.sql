/*
ATL-1370 HCAHPS DG Solutions Survey Subtype.sql

Chris Burkholder

1/24/2017

INSERT INTO Subtype
INSERT INTO SurveyTypeSubtype

select * from surveysubtype
select * from subtype
select * from surveytypesubtype
select * from subtypecategory
*/
USE [QP_Prod]
GO

--update subtype set subtype_nm = 'RT' where subtype_nm = 'DG'

if not exists (select * from subtype where subtype_nm = 'RT')
insert into subtype (Subtype_nm,SubtypeCategory_id,bitRuleOverride,bitQuestionnaireRequired,bitActive)
values ('RT',1,0,0,1)

declare @RT int 
select @RT = Subtype_id from subtype where subtype_nm = 'RT'

if not exists (select * from surveytypesubtype where surveytype_id = 2)
insert into SurveyTypeSubType(SurveyType_id,Subtype_id)
values (2, @RT)

GO