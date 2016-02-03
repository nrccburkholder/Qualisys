/*

S40_US10_OAS_Methodologies_update.sql

10 OAS: New Survey Type
As an Implementation Associate, I want a new survey type w/ appropriate settings for OAS CAHPS, so that I can set up surveys compliantly.
Survey type, no subtypes, DQ rules, monthly sample periods, 3 std methodologies, add survey type to catalyst database 



Chris Burkholder

Task 2 - Update old scripts where we've done this before; make sure goes into Catalyst

ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
ALTER PROCEDURE [dbo].[SV_CAHPS_SkipPatterns]
ALTER PROCEDURE [dbo].[SV_CAHPS_Householding]
ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
ALTER PROCEDURE [dbo].[SV_CAHPS_SamplingAlgorithm]
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
ALTER PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
ALTER PROCEDURE [dbo].[SV_CAHPS_HasDQRule]
CREATE PROCEDURE [dbo].[SV_CAHPS_SupplementalQuestionCount]
*/




use qp_prod
go

DECLARE @SurveyType_ID int

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'

begin tran



declare @SMid int, @SMSid int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'OAS Mixed Mail-Phone'
SET @MethodologyType = 'Mixed Mail-Phone'

/*
	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID in (
		select StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
	)	
*/

if not exists(select * from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType)
begin
	insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)

	set @SMid=scope_identity()	
	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_id)																												
																																																							
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,
	bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'1'	,'1st Survey'	,'0'	,'42'	,'-1' /*1st survey*/	,
	'0'	,'1'	,'0'	,'1'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	set @SMSid=scope_identity()																													
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,
	bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast,	quota_id)
	values (@SMid	,'2'	,'Phone'	,'19'	,'42'	,'-1' /*1st survey*/	,
	'0'	,'1'	,'0'	,'0'	,'1'	,'20'	,'5'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL	,1	)
	update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
end	


SET @StandardMethodology_nm = 'OAS Mail Only'
SET @MethodologyType = 'Mail Only'

/*
	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID in (
		select StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
	)	
*/

if not exists(select * from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType)
begin
	insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																													
																												
	set @SMid=scope_identity()	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_ID)																												
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,
	bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'1'	,'1st Survey'	,'0'	,'42'	,'-1' /*1st survey*/	,
	'0'	,'1'	,'0'	,'1'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	set @SMSid=scope_identity()																													
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,
	bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'2'	,'2nd Survey'	,'18'	,'42'	,'-1' /*1st survey*/	,
	'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
end																											


SET @StandardMethodology_nm = 'OAS Phone Only'
SET @MethodologyType = 'Phone Only'
/*
	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID in (
		select StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
	)	
*/

if not exists(select * from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType)
begin
	insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																												
																													
	set @SMid=scope_identity()	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_ID)																												
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,
	bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast	, Quota_ID		)
	values (@SMid	,'1'	,'Phone'	,'0'	,'42'	,'-1' /*phone*/	,
	'0'	,'1'	,'0'	,'1'	,'1'	,'41'	,'5'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL	,1	)
	set @SMSid=scope_identity()																													
	update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
end

--rollback tran	
--update standardmailingstep set ExpireInDays = 42, intIntervalDays = 0 where standardmailingstepid = 138


go



select *
from StandardMethodology where strStandardMethodology_nm like 'OAS%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'OAS%'
)


select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'OAS%'
)

go


--select * from metafieldgroupdef select * from metafield
if not exists(select * from metafieldgroupdef where strfieldgroup_nm = 'OAS CAHPS')
insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('OAS CAHPS', 'N', 0)

declare @OASId int

select @OASId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'OAS CAHPS'

if not exists (select * from Metafield where strfield_NM = 'OAS_LocationID')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_LocationID','ID for location or other division under HOPD or ASC',@OASId,'S',42,NULL,NULL,'OASLocID',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'OAS_LocationName')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_LocationName','Name for location or other division under HOPD or ASC',@OASId,'S',100,NULL,NULL,'OASLocNm',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'OAS_PatServed')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_PatServed','OAS CAHPS count of patients served',@OASId,'I',NULL,NULL,NULL,'OASPtSrv',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'OAS_VisitAge')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_VisitAge','OAS CAHPS age on date of procedure',@OASId,'I',NULL,NULL,NULL,'OASAge',0,0,NULL,NULL,1)
if not exists (select * from Metafield where strfield_NM = 'HCPCSLvl2Cd')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HCPCSLvl2Cd','Primary HCPCS Level II code',NULL,'S',5,NULL,NULL,'Lvl2Cd',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'HCPCSLvl2Cd_2')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HCPCSLvl2Cd_2','Primary HCPCS Level II code 2',NULL,'S',5,NULL,NULL,'Lvl2Cd2',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'HCPCSLvl2Cd_3')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HCPCSLvl2Cd_3','Primary HCPCS Level II code',NULL,'S',5,NULL,NULL,'Lvl2Cd3',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'OAS_HE_Lang')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_HE_Lang','OAS CAHPS language question hand-entry field',NULL,'S',50,NULL,NULL,'OASLang',0,0,NULL,NULL,1)
if not exists (select * from Metafield where strfield_NM = 'OAS_HE_HowHelp')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_HE_HowHelp','OAS CAHPS how helped question hand-entry field',NULL,'S',99,NULL,NULL,'OASHelp',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'OAS_FacilityType')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('OAS_FacilityType','OAS CAHPS facility type (HOPD or ASC)',@OASId,'S',10,NULL,NULL,'OASFTyp',0,0,NULL,NULL,0)
if not exists (select * from Metafield where strfield_NM = 'CPT_Srg_Cd_Valid')
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CPT_Srg_Cd_Valid','OAS CAHPS CPT Codes Valid',@OASId,'S',10,NULL,NULL,'CPTSrgCV',0,0,NULL,NULL,0)


GO

declare @OAScahpsId int

select @OAScahpsId = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'

--select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = 16
--select * from SurveyValidationProcs
/*
select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on  svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id 
where cahpstype_id = 16 and ProcedureName = 'SV_CAHPS_HasDQRule'
*/
--delete from SurveyValidationProcsBySurveyType where SurveyValidationProcsToSurveyType_id = 143

if not exists (select * from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SupplementalQuestionCount')
insert SurveyValidationProcs (ProcedureName, ValidMessage, intOrder)
select 'SV_CAHPS_SupplementalQuestionCount', 'PASSED! Survey has allowable number of supplementable questions', max(intorder) + 1 from SurveyValidationProcs

if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SampleUnit')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SampleUnit'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_ActiveMethodology')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_ActiveMethodology'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_RequiredPopulationFields')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_RequiredPopulationFields'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_RequiredEncounterFields')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SkipPatterns')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SkipPatterns'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_Householding')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_Householding'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_ReportingDate')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_ReportingDate'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SamplingAlgorithm')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_FormQuestions')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_FormQuestions'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_EnglishOrSpanish')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_EnglishOrSpanish'
if not exists(select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SupplementalQuestionCount')
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@OAScahpsId from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SupplementalQuestionCount'

--declare @OAScahpsId int
select @OAScahpsId = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'
declare @DCStmtId int, @FieldId int

--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause select * from DefaultCriteriaInList
/*
select * 
from defaultcriteriainlist dcil inner join defaultcriteriaclause dcc on dcil.DefaultCriteriaClause_id = dcc.DefaultCriteriaClause_id
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = 16

select * 
from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = 16 
order by dcc.DefaultCriteriaStmt_id, CriteriaPhrase_id, DefaultCriteriaClause_id

select * 
from defaultcriteriastmt dcis 
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcis.DefaultCriteriaStmt_id
where surveytype_id = 16 

select * 
from surveytypedefaultcriteria stdc 
where surveytype_id = 16 
*/
----------------------
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_MDFA' and strCriteriaString = '(POPULATIONAddrErr=''FO'')'
if not exists(select * from SurveyTypeDefaultCriteria 
				where SurveyType_id = @OAScahpsId and Country_id = 1 and DefaultCriteriaStmt_id = @DCStmtId)
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@OAScahpsId, 1, @DCStmtId)
----------------------
if not exists(select * from DefaultCriteriaStmt 
				where (strCriteriaStmt_nm = 'DQ_Age' and strCriteriaString = '(ENCOUNTEROAS_VisitAge < 18)' and BusRule_cd = 'Q'))
insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Age', '(ENCOUNTEROAS_VisitAge < 18)', 'Q')

select @DCStmtId = DefaultCriteriaStmt_Id from DefaultCriteriaStmt 
				where strCriteriaStmt_nm = 'DQ_Age' and strCriteriaString = '(ENCOUNTEROAS_VisitAge < 18)' and BusRule_cd = 'Q'

if not exists(select * from SurveyTypeDefaultCriteria 
				where SurveyType_id = @OAScahpsId and Country_id = 1 and DefaultCriteriaStmt_id = @DCStmtId)
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@OAScahpsId, 1, @DCStmtId)

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'OAS_VisitAge'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and CriteriaPhrase_id = 1)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 5, '18', '')
----------------------
if not exists(select * from DefaultCriteriaStmt 
				where strCriteriaStmt_nm = 'DQ_SrgCd' and strCriteriaString = 'CPT4 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_2 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_3 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'')' and BusRule_cd = 'Q')
insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_SrgCd', 'CPT4 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_2 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_3 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'')', 'Q')

select @DCStmtId = DefaultCriteriaStmt_Id from DefaultCriteriaStmt 
				where strCriteriaStmt_nm = 'DQ_SrgCd' and strCriteriaString = 'CPT4 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_2 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_3 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'')' and BusRule_cd = 'Q'
if not exists(select * from SurveyTypeDefaultCriteria 
				where (SurveyType_id = @OAScahpsId and Country_id = 1 and DefaultCriteriaStmt_id = @DCStmtId))
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@OAScahpsId, 1, @DCStmtId)

declare @cpt2 int, @cpt3 int, @cpt4 int

---------------SET 1: 0, NOT IN, NOT IN, NOT IN

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 1)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 1)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and intoperator = 11 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 1)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and intoperator = 11 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 1)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and intoperator = 11 and Field_id = @Fieldid
----------------------

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')

---------------SET 2: 0, IS NULL, NOT IN, NOT IN

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 2)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 2, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 2)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 2, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 2 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 2)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 2, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 2 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 2)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 2, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 2 and Field_id = @Fieldid
----------------------
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')
*/
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')

---------------SET 3: 0, NOT IN, IS NULL, NOT IN

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 3)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 3, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 3)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 3, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 3 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 3)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 3, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 3 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 3)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 3, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 3 and Field_id = @Fieldid
----------------------

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')
*/
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')

---------------SET 4: 0, NOT IN, NOT IN, IS NULL

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 4)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 4, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 4)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 4, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 4 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 4)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 4, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 4 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 4)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 4, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 4 and Field_id = @Fieldid
----------------------

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')
*/

---------------SET 5: 0, IS NULL, IS NULL, NOT IN

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 5)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 5, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 5)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 5, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 5 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 5)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 5, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 5 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 5)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 5, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 5 and Field_id = @Fieldid
----------------------
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')
*/
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')

---------------SET 6: 0, NOT IN, IS NULL, IS NULL

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 6)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 6, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 6)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 6, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 6 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 6)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 6, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 6 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 6)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 6, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 6 and Field_id = @Fieldid
----------------------

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')
*/

---------------SET 7: 0, IS NULL, NOT IN, IS NULL

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 7)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 7, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 7)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 7, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 7 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 7)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 7, 'ENCOUNTER', @Fieldid, 11, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 7 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 7)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 7, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 7 and Field_id = @Fieldid
----------------------
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')
*/
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')
*/

---------------SET 8: 0, IS NULL, IS NULL, IS NULL

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT_Srg_Cd_Valid'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 8)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 8, 'ENCOUNTER', @Fieldid, 1, '0', '')

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 8)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 8, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 8 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_2'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 8)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 8, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 8 and Field_id = @Fieldid

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HCPCSLvl2Cd_3'
if not exists (select * from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and Field_id = @FieldId and CriteriaPhrase_id = 8)
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 8, 'ENCOUNTER', @Fieldid, 9, '', '')

select @cpt4 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and CriteriaPhrase_id = 8 and Field_id = @Fieldid
----------------------
/*
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt2, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt3, 'G0260')

if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0104')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0104')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0105')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0105')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0121')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0121')
if not exists (select * from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt4 and strListValue = 'G0260')
insert into DefaultCriteriaInList (DefaultCriteriaClause_id,strListValue) values (@cpt4, 'G0260')
*/
go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1



IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

IF @subtype_id is null
	SET @subtype_id = 0

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Check the active methodology  (ALL CAHPS)
CREATE TABLE #ActiveMethodology (standardmethodologyid INT, bitExpired bit)

INSERT INTO #ActiveMethodology
SELECT mm.StandardMethodologyId, smst.bitExpired
FROM MailingMethodology mm (NOLOCK)
INNER JOIN StandardMethodology sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
WHERE mm.Survey_id=@Survey_id
AND mm.bitActiveMethodology=1
and smst.SurveyType_id = @surveyType_id

IF @@ROWCOUNT<>1
 INSERT INTO #M (Error, strMessage)
 SELECT 1,'Survey must have exactly one active methodology.'
ELSE
BEGIN

	 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid = 5 and bitExpired = 0) -- 5 is custom methodology
	  INSERT INTO #M (Error, strMessage)
	  SELECT 2,'Survey uses a custom methodology.'         -- a warning

	 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology WHERE bitExpired = 1) -- 
	  INSERT INTO #M (Error, strMessage)
	  SELECT 1,'Survey uses an expired methodology.'         -- an error

	 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology
	   WHERE standardmethodologyid in (select StandardMethodologyID
		 from StandardMethodologyBySurveyType where SurveyType_id = @surveyType_id and SubType_ID = @subtype_id
		)
	   )
	  INSERT INTO #M (Error, strMessage)
	  SELECT 0,'Survey uses a standard ' + @SurveyTypeDescription + ' methodology.'

	 ELSE
	  INSERT INTO #M (Error, strMessage)
	  SELECT 1,'Survey does not use a standard ' + @SurveyTypeDescription + ' methodology.'   -- a warning     

END

DROP TABLE #ActiveMethodology

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the required fields are a part of the study (Population Fields)
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a Population field in the data structure.'
FROM (SELECT Field_id, strField_nm
		FROM MetaField
		WHERE strField_nm IN (SELECT [ColumnName] 
							FROM SurveyValidationFields
							WHERE SurveyType_Id = @surveyType_id
							AND TableName = 'POPULATION'
							AND bitActive = 1)) a
LEFT JOIN ( SELECT strField_nm 
			FROM MetaData_View m, Survey_def sd
			WHERE sd.Survey_id=@Survey_id
			AND sd.Study_id=m.Study_id
			AND m.strTable_nm = 'POPULATION') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL

IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All Population ' + @SurveyTypeDescription + ' fields are in the data structure'


SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))


--Make sure required fields are a part of the study (Encounter Fields)
	INSERT INTO #M (Error, strMessage)
	SELECT 1,a.strField_nm+' is not an Encounter field in the data structure.'
	FROM (SELECT Field_id, strField_nm
		  FROM MetaField
		  WHERE strField_nm IN (SELECT [ColumnName] 
								FROM SurveyValidationFields
								WHERE SurveyType_Id = @surveyType_id
								AND TableName = 'ENCOUNTER'
								AND bitActive = 1)) a
		  LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
					 WHERE sd.Survey_id=@Survey_id
					 AND sd.Study_id=m.Study_id
	   AND m.strTable_nm = 'ENCOUNTER') b
	ON a.strField_nm=b.strField_nm
	WHERE b.strField_nm IS NULL
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'All Encounter ' + @SurveyTypeDescription + ' fields are in the data structure'

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_SkipPatterns]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

	--Make sure skip patterns are enforced.
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'Skip Patterns are not enforced.'
	FROM Survey_def
	WHERE Survey_id=@Survey_id
	AND bitEnforceSkip=0
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'Skip Patterns are enforced'

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_Householding]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @hospiceCAHPS int
select @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @pqrsCAHPS int
select @pqrsCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

declare @oasCAHPS int
select @oasCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'


declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@HCAHPS) or (@surveyType_id in (@CGCAHPS) and @subtype_id = @PCMHSubType)
	BEGIN
		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is not defined.'
		FROM Survey_def sd LEFT JOIN HouseHoldRule hhr
		ON sd.Survey_id=hhr.Survey_id
		WHERE sd.Survey_id=@Survey_id
		AND hhr.Survey_id IS NULL

		--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns
		INSERT INTO #M (Error, strMessage)
		SELECT 1,strField_nm+' is not a householding column.'
		FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a
		  LEFT JOIN HouseHoldRule hhr
		ON a.Field_id=hhr.Field_id
		AND hhr.Survey_id=@Survey_id
		WHERE hhr.Field_id IS NULL

END

IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS, @hospiceCAHPS, @CIHI, @pqrsCAHPS, @oasCAHPS)
	BEGIN

		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is defined and should not be.'
		FROM HouseHoldRule hhr
		WHERE hhr.Survey_id=@Survey_id
END

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @hospiceCAHPS int
select @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @pqrsCAHPS int
select @pqrsCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

declare @oasCAHPS int
select @oasCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@ACOCAHPS)
	BEGIN
		--Make sure the reporting date is ACO_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
			FROM Survey_def sd, MetaTable mt
		 WHERE sd.sampleEncounterTable_id=mt.Table_id
			  AND  sd.Survey_id=@Survey_id
			  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ACO_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ACO_FieldDate.'
	END

	IF @surveyType_id in (@ICHCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ICH_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ICH_FieldDate.'
	END

	IF @surveyType_id in (@hospiceCAHPS, @pqrsCAHPS, @oasCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ServiceDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ServiceDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ServiceDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ServiceDate.'
	END

	IF @surveyType_id in (@CIHI)
	BEGIN
		--Make sure the reporting date is DischargeDate                                     
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be DischargeDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be DischargeDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'DischargeDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to DischargeDate.'
	END

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_SamplingAlgorithm]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--What is the sampling algorithm
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your sampling algorithm is not StaticPlus.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND SamplingAlgorithmID<>3

SELECT * FROM #M

DROP TABLE #M

GO
-------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
	02/25/2015 -- TSB:  modified the select into #CAHPS_SurveyTypeQuestionMappings to only include Questions whose datEncounterEnd_dt is 
				greater than today's date. This is related to S19 US19 which deactivated five question cores and added a new one.

	04/30/2015 -- TSB: modified CAHPS Type variables to come from SELECT from SurveyType to ensure Id consistency.  Changed @PCHMSubType to read from
				SubType table with name "PCMH Distinction".  S24 US13.1
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

declare @CGCAHPS int
SELECT  @CGCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

declare @HCAHPS int
SELECT  @HCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'HCAHPS IP'

declare @HHCAHPS int
SELECT  @HHCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'Home Health CAHPS'

declare @ACOCAHPS int
SELECT  @ACOCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'

declare @ICHCAHPS int
SELECT  @ICHCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ICHCAHPS'

declare @hospiceCAHPS int
SELECT @hospiceCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'Hospice CAHPS'

declare @oasCAHPS int
SELECT @oasCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'OAS CAHPS'

declare @PCMHSubType int
SELECT @PCMHSubType = [Subtype_id]
FROM [dbo].[Subtype]
where [Subtype_nm] = 'PCMH Distinction'


declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

DECLARE @questionnaireType_id int

-- get any associated subtype_id that is has questionnaire category type
select  @questionnaireType_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 2

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure all of the CAHPS questions are on the form and in the correct location.
	CREATE TABLE #CurrentForm (
		Order_id INT IDENTITY(1,1),
		QstnCore INT,
		Section_id INT,
		Subsection INT,
		Item INT
	)

	--Get the questions currently on the form
	INSERT INTO #CurrentForm (QstnCore, Section_id, Subsection, Item)
	SELECT QstnCore, Section_id, Subsection, Item
	FROM Sel_Qstns
	WHERE Survey_id=@Survey_id
	  AND SubType in (1,4)
	  AND Language=1
	  AND (Height>0 OR Height IS NULL)
	ORDER BY Section_id, Subsection, Item

	--Check for expanded questions
	--If they exist on survey, then pull question list that includes expanded questions (bitExpanded = 1)
	declare @bitExpanded int

	CREATE TABLE #CAHPS_SurveyTypeQuestionMappings(
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL,
	[SubType_id] [INT] NOT NULL)

	IF @surveyType_id in (@HCAHPS)
	BEGIN

		select @bitExpanded = isnull((select top 1 1 from #currentform where qstncore in (46863,46864,46865,46866,46867)),0) 

	--If active sample period is after 1/1/2013, then the survey should be using expanded questions (bitExpanded = 1)
	--**************************************************
	--** Code from QCL_SelectActivePeriodbySurveyId
	--**************************************************
		create table #periods (perioddef_id int, activeperiod bit)

		--Get a list of all periods for this survey
		INSERT INTO #periods (periodDef_id)
		SELECT periodDef_id
		FROM perioddef
		WHERE survey_id=@survey_id

		--Get a list of all periods that have not completed sampling
		SELECT distinct pd.PeriodDef_id
		INTO #temp
		FROM perioddef p, perioddates pd
		WHERE p.perioddef_id=pd.perioddef_id AND
				survey_id=@survey_id AND
	  			datsampleCREATE_dt is null

		--Find the active Period.  It is either a period that hasn't completed sampling
		--or a period that hasn't started but has the most recent first scheduled date
		--If no unfinished periods exist, set active period to the period with the most
		--recently completed sample

		IF EXISTS (SELECT top 1 *
					FROM #temp)
		BEGIN

			DECLARE @UnfinishedPeriod int

			SELECT @UnfinishedPeriod=pd.perioddef_id
			FROM perioddates pd, #temp t
			WHERE pd.perioddef_id=t.perioddef_id AND
		  			pd.samplenumber=1 AND
					pd.datsampleCREATE_dt is not null

			IF @UnfinishedPeriod is not null
			BEGIN
				--There is a period that is partially finished, so set it to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id = @UnfinishedPeriod
			END
			ELSE
			BEGIN
				--There is no period that is partially finished, so set the unstarted period
				--with the earliest scheduled sample date to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id =
					(SELECT top 1 pd.perioddef_id
					 FROM perioddates pd, #temp t
					 WHERE pd.perioddef_id=t.perioddef_id AND
				  			pd.samplenumber=1
					 ORDER BY datscheduledsample_dt)
			END
		END
		ELSE
		BEGIN
			--No unfinished periods exist, so we will set the active to be the most recently
			--finished
			UPDATE #periods
			SET ActivePeriod=1
			WHERE perioddef_id =
				(SELECT top 1 p.perioddef_id
				 FROM perioddates pd, perioddef p
				 WHERE p.survey_id=@survey_id AND
						pd.perioddef_id=p.perioddef_id
				 GROUP BY p.perioddef_id
				 ORDER BY Max(datsampleCREATE_dt) desc)
		END

		IF @surveyType_id in (@HCAHPS)
		BEGIN
			if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
				select @bitExpanded = 1 ---(HCAHPS specific)
		END

		drop table #periods
		drop table #temp

		--Create subset SurveyTypeQuestionMappings looking at only surveyType
		INSERT INTO #CAHPS_SurveyTypeQuestionMappings
		Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id 
		and bitExpanded = @bitExpanded
		and [datEncounterEnd_dt] >= GETDATE()

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and [datEncounterEnd_dt] >= GETDATE()

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id
			and [datEncounterEnd_dt] >= GETDATE()

		END

	END

	--Look for questions missing from the form.
/*	IF @surveyType_id IN (@ACOCAHPS)
	BEGIN

		DECLARE @cnt50715 INT
		DECLARE @cnt50255 INT

		SELECT
		 @cnt50715 = SUM( CASE s.QstnCore WHEN 50715 THEN 1 ELSE 0 END),
		 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL and s.QstnCore NOT IN (50715,50255)

	END
*/
	IF @surveyType_id IN (@HCAHPS)
	BEGIN

		DECLARE @cnt43350 INT
		DECLARE @cnt50860 INT
		SELECT
		 @cnt43350 = SUM( CASE s.QstnCore WHEN 43350 THEN 1 ELSE 0 END),
		 @cnt50860 = SUM( CASE s.QstnCore WHEN 50860 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		IF @cnt43350 = 0 AND @cnt50860 = 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both missing.  You must have either 43350 or 50860, but not both.')
		END
		IF @cnt43350 > 0 AND @cnt50860 > 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both assigned.  You must have either 43350 or 50860, but not both.')
		END

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		AND t.QstnCore IS NULL and s.QstnCore NOT IN (43350,50860)

	END

	IF (@surveyType_id = @HHCAHPS) OR (@SurveyType_id = @hospiceCAHPS) OR (@SurveyType_id = @CIHI) OR (@SurveyType_id = @oasCAHPS)
	BEGIN
		IF (@SurveyType_id = @oasCAHPS)
			IF EXISTS (select 1 from #CurrentForm  where QstnCore = 54117)
				delete from #CAHPS_SurveyTypeQuestionMappings where QstnCore in (54181,54182,54183)
			ELSE
				IF EXISTS (select 1 from #CurrentForm where QstnCore in (54181,54182,54183))
					delete from #CAHPS_SurveyTypeQuestionMappings  where QstnCore = 54117
		
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END

	--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		and s.SubType_id = @questionnaireType_id
		AND t.QstnCore IS NULL

		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		and s.SubType_id = @questionnaireType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck 
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
		from #CAHPS_SurveyTypeQuestionMappings qm 
		INNER JOIN #CurrentForm t ON qm.SurveyType_id = @surveyType_id
		WHERE qm.SubType_id = @questionnaireType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END
	ELSE -- NOT (IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS))
	BEGIN
		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff

		from #CAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
		WHERE qm.SurveyType_id = @surveyType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END


	DECLARE @OrderDifference INT

	SELECT @OrderDifference=OrderDiff
	FROM #OrderCheck
	WHERE OverAllOrder=1

	IF (@SurveyType_id = @oasCAHPS)
		IF NOT EXISTS (select 1 from #CurrentForm where QstnCore in (54181,54182,54183))
			delete from #OrderCheck where QstnCore in (54118,54119,54120,54121,54122)
		ELSE
			IF NOT EXISTS (select 1 from #CurrentForm where QstnCore = 54117)
				delete from #OrderCheck where QstnCore in (54181,54182,54183,54118,54119,54120,54121,54122)

	INSERT INTO #M (Error, strMessage)
	SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'
	FROM #OrderCheck
	WHERE OrderDiff<>@OrderDifference

	DROP TABLE #OrderCheck
	
	DROP TABLE #CurrentForm

	IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
	BEGIN
	 INSERT INTO #M (Error, strMessage)
	 SELECT 0,'All ' + @SurveyTypeDescription + ' Questions are on the form in the correct order.'

	 --IF all cores or on the survey, then check that the questions are mapped
	 --in a manner that ensures someone sampled at the units will get all of them
	 SELECT sampleunit_id
	 into #CAHPSUnits
	 FROM SampleUnit su, SamplePlan sp
	 WHERE sp.Survey_id=@Survey_id
	 AND sp.SamplePlan_id=su.SamplePlan_id
	 AND CAHPSType_id = @surveyType_id

	 DECLARE @sampleunit_id int

	 SELECT TOP 1 @sampleunit_id=sampleunit_id
	 FROM #CAHPSUnits

	 WHILE @@rowcount>0
	 BEGIN

		INSERT INTO #M (Error, strMessage)
		 SELECT 1,'QstnCore '+LTRIM(STR(a.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'
		 from
		 (
		  SELECT stqm.QstnCore, intOrder
		  FROM
		  (
		   SELECT sq.Qstncore
		   FROM SAMPLEUNITTREEINDEX si JOIN sampleunitsection su
			ON si.sampleunit_id=@sampleunit_id
			 AND si.ancestorunit_id=su.sampleunit_id
			JOIN sel_qstns sq
			ON sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		   union
		   SELECT sq.Qstncore
		   FROM sampleunitsection su JOIN sel_qstns sq
			ON su.sampleunit_id=@sampleunit_id
			 AND sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		  ) as Q  RIGHT JOIN #CAHPS_SurveyTypeQuestionMappings stqm
		  ON Q.QstnCore=stqm.QstnCore
		  WHERE stqm.SurveyType_id=@surveyType_id AND Q.QstnCore IS NULL
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%phone%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Phone'))
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%mail%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Mail'))
		  AND not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%dummy%') 
		 ) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

		  IF @@ROWCOUNT=0
		   INSERT INTO #M (Error, strMessage)
		   SELECT 0,'All Questions are mapped properly for Sampleunit ' + convert(varchar,@sampleunit_id)

		  DELETE
		  FROM #CAHPSUnits
		  WHERE sampleunit_Id=@sampleunit_id

		  SELECT TOP 1 @sampleunit_id=sampleunit_id
		  FROM #CAHPSUnits

	 END

	 DROP TABLE #CAHPSUnits
	 

	END
	--End of Question checking

	DROP TABLE #CAHPS_SurveyTypeQuestionMappings

ENDOFPROC:

SELECT * FROM #M

DROP TABLE #M

GO
-------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--check to make sure only english or hcahps spanish is used on HHACAHPS survey
		INSERT INTO #M (Error, strMessage)
		SELECT 1, l.Language + ' is not a valid Language for this CAHPS survey'
		FROM Languages l, SEL_QSTNS sq
		WHERE l.LangID = sq.LANGUAGE and
		  sq.SURVEY_ID = @Survey_id and
		  l.LangID not in (1,19)

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SV_CAHPS_HasDQRule]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

	IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br
					 WHERE br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has a DQ or other Business Rule and should not.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule.'

SELECT * FROM #M

DROP TABLE #M

GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SupplementalQuestionCount]    Script Date: 1/13/2016 4:23:52 PM ******/
IF OBJECT_ID('SV_CAHPS_SupplementalQuestionCount', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[SV_CAHPS_SupplementalQuestionCount]
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_SupplementalQuestionCount]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

Declare @SupplementalQuestions int

select @SupplementalQuestions = count(distinct qstncore)
				   FROM sel_qstns sq inner join survey_def sd on sq.SURVEY_ID = sd.SURVEY_ID
					 WHERE sq.Survey_id = @Survey_id
					 and subtype in (1,4) --questions/comment boxes
					 and qstncore > 0
					 and qstncore not in (select qstncore from SurveyTypeQuestionMappings where surveytype_id = sd.SurveyType_id)
	IF (@SupplementalQuestions > 15)
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has more than 15 supplemental questions.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has 15 or fewer supplemental questions.'

SELECT * FROM #M

DROP TABLE #M

GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'OAS CAHPS'

--select * from surveyvalidationfields where surveytype_id = 16

if not exists (select 1 from SurveyValidationFields where ColumnName = 'OAS_HE_HowHelp' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Population', 'OAS_HE_HowHelp', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'OAS_HE_Lang' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Population','OAS_HE_Lang', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'OAS_LocationID' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','OAS_LocationID', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'OAS_LocationName' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','OAS_LocationName', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'OAS_PatServed' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','OAS_PatServed', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'OAS_FacilityType' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','OAS_FacilityType', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'HCPCSLvl2Cd' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','HCPCSLvl2Cd', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'HCPCSLvl2Cd_2' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','HCPCSLvl2Cd_2', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'HCPCSLvl2Cd_3' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','HCPCSLvl2Cd_3', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'CPT4' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','CPT4', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'CPT4_2' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','CPT4_2', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'CPT4_3' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','CPT4_3', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'CPT_Srg_Cd_Valid' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','CPT_Srg_Cd_Valid', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'FacilityName' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','FacilityName', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'CCN' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','CCN', @SurveyType_ID, 1)
if not exists (select 1 from SurveyValidationFields where ColumnName = 'ServiceDate' and SurveyType_id = @SurveyType_ID)
	insert into SurveyValidationFields(TableName, ColumnName, SurveyType_Id, bitActive)
	values('Encounter','ServiceDate', @SurveyType_ID, 1)

GO

--select * from SurveyTypeQuestionMappings where surveytype_id in (13,16) order by surveytype_id,intorder

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'OAS CAHPS'

if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54086)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54086,1,1,0,'2016-01-01' , '2999-12-31', 0 )
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54087)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54087,2,1,0,'2016-01-01','2999-12-31', 0 )
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54088)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54088,3,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54089)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54089,4,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54090)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54090,5,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54091)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54091,6,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54092)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54092,7,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54093)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54093,8,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54094)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54094,9,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54095)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54095,10,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54096)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54096,11,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54097)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54097,12,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54098)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54098,13,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54099)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54099,14,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54100)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54100,15,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54101)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54101,16,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54102)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54102,17,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54103)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54103,18,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54104)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54104,19,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54105)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54105,20,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54106)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54106,21,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54107)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54107,22,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54108)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54108,23,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54109)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54109,24,1,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54110)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54110,25,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54111)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54111,26,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54112)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54112,27,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54113)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54113,28,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54114)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54114,29,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54115)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54115,30,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54116)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54116,31,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54117)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54117,32,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54181)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54181,33,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54182)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54182,340,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54183)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54183,35,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54118)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54118,36,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54119)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54119,37,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54120)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54120,38,0,0,'2016-01-01','2999-12-31',0)
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54121)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54121,39,0,0,'2016-01-01','2999-12-31',0) 
if not exists(select * from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54122)
insert into SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID)
values(@SurveyType_ID,54122,40,0,0,'2016-01-01','2999-12-31',0) 

update o1 set o1.strOperator = o2.strOperator, o1.strLogic = o2.strLogic 
--select o1.*, o2.* 
from operator o1 inner join operator o2 on o1.operator_num = 11 and o2.operator_num = 12

delete
--select *
from operator where operator_num = 12

--rollback tran	
commit tran


GO
