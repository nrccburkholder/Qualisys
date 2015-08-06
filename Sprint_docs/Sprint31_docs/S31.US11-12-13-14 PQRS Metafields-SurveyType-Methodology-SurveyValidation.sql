/*

S31.US11-12-13-14 PQRS Metafields-SurveyType-Methodology-SurveyValidation

11 As Corporate Compliance, we want specific metafields for PQRS, so that data is stored consistently
12 As Corporate Compliance, we want a new survey type with appropriate defaults for PQRS, so that surveys are set up and processed correctly
13 As Corporate Compliance, we want a new standard methodology created for PQRS, so that we field according to specifications
14 As Corporate Compliance, we want survey validation to enforce specific PQRS rules, so that we field compliantly

11.1 insert metafields and group into tables
12.1 insert survey type and qualproparams defaults for PQRS 
13.1 insert standard methodologies and mailing steps
14.1 create new survey validation stored procedure and add to mapping table

Chris Burkholder 11.1 12.1 13.1 
??? 14.1 

*/

-- 12.1 -------------------------------------------------------------

use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'PQRS CAHPS'

begin tran

if not exists (	SELECT 1 FROM SurveyType WHERE SurveyType_dsc = @SurveyType_desc)
BEGIN

	INSERT INTO [dbo].[SurveyType]
			   ([SurveyType_dsc]
			   ,[CAHPSType_id]
			   ,[SeedMailings]
			   ,[SeedSurveyPercent]
			   ,[SeedUnitField]
			   ,[SkipRepeatsScaleText])
		 VALUES
			   (@SurveyType_desc
			   ,NULL
			   ,1
			   ,2
			   ,'CAHPSType_id',
			   1)

	SELECT @SurveyType_ID = SCOPE_IDENTITY()

	UPDATE SurveyType
	SET CAHPSType_id = @SurveyType_ID
	WHERE SurveyType_ID = @SurveyType_ID

END

--select * from surveytype
--select * from qualpro_params where strparam_nm like '%ACOCAHPS%' select * from qualpro_params where strparam_nm like '%PQRS CAHPS%'
--delete from qualpro_params where strparam_nm = 'SurveyRule: IsSamplingMethodDisabled - Hospice CAHPS'

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SkipEnforcementRequired - PQRS CAHPS','S','SurveyRules','1',NULL,NULL,'Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsCAHPS - PQRS CAHPS','S','SurveyRules','1',NULL,NULL,'Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SamplingMethodDefault - PQRS CAHPS','S','SurveyRules','Census',3,NULL,'Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsSamplingMethodDisabled - PQRS CAHPS','S','SurveyRules','1',NULL,NULL,'Rule to determine if sampling method is enabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - PQRS CAHPS','N','SurveyRules',NULL,0,NULL,'PQRS CAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - PQRS CAHPS','S','SurveyRules','1',NULL,NULL,'PQRS CAHPS Resurvey Exclusion Days disabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: MedicareIdTextMayBeBlank - PQRS CAHPS','S','SurveyRules','1',NULL,NULL,'Medicare Id Text May Be Blank for PQRS CAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: UseUSPSAddrChangeServiceDefault - PQRS CAHPS','S','SurveyRules','1',NULL,NULL,'Rule to set the default state of UseUSPSAddrChangeServiceCheckBox')

-- 13.1 -------------------------------------------------------------

--select * from standardmailingstep select * from standardmethodologybysurveytype select * from standardmethodology select * from methodologysteptype select * from mailingmethodology

insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('PQRS Mixed Mail-Phone', 0, 'Mixed Mail-Phone')

declare @pqrsMethodologyId int, @pqrsId int
select @pqrsId = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'
select @pqrsMethodologyId = StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = 'PQRS Mixed Mail-Phone'

insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@pqrsMethodologyId, @pqrsId, 0)

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@pqrsMethodologyId, 1, 0, 1, 0, 0, 'Prenote', 1, 10, 82, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@pqrsMethodologyId, 2, 0, 1, 4, 0, '1st Survey', 0, 0, 82, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@pqrsMethodologyId, 3, 0, 1, 20, 0, '2nd Survey', 0, 0, 82, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@pqrsMethodologyId, 4, 0, 1, 20, 0, 'Phone', 0, 1, 32, 1, 1, null, 29, 6, 1, 1, 1, 1, 1, 1, 1, 0, null, null)

update sms set ExpireFromStep = StandardMailingStepID - intSequence + 1 from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'PQRS Mixed Mail-Phone'
and intSequence in (1,2,3)

update sms set ExpireFromStep = StandardMailingStepID from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'PQRS Mixed Mail-Phone'
and intSequence = 4


-- 11.1 -------------------------------------------------------------

--select * from metafieldgroupdef select * from metafield where strfield_nm like '%findernum' or strfield_nm like '%HandE' 
insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('PQRS CAHPS', 'N', 0)

declare @pqrsGroupId int
select @pqrsGroupId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'PQRS CAHPS'

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PQRS_FinderNum','Finder number to identify PQRS CAHPS beneficiary',null,'S',10,NULL,NULL,'PQFinder',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PQRS_GroupID','PQRS Group Practice ID from CMS',@pqrsGroupId,'S',10,NULL,NULL,'PQGrpID',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values('PQRS_GroupName','PQRS Group Practice name from CMS',@pqrsGroupId,'S',100,NULL,NULL,'PQGrpNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values('PQRS_FocalType','PQRS provider focus',@pqrsGroupId,'S',1,NULL,NULL,'PQFocTyp',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values('PQRS_LangHandE','PQRS Language question hand-entry field',null,'S',50,NULL,NULL,'PQLangHE',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values('PQRS_HelpedHandE','PQRS How Helped question hand-entry field',null,'S',100,NULL,NULL,'PQHelpHE',0,0,NULL,NULL,1)

/*
-- 14.1 -------------------------------------------------------------
--declare @hospiceMethodologyId int, @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (147, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (148, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (149, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (150, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (151, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (153, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (155, @hospiceId, null)
--insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
--values (156, @hospiceId, null)  -- SamplingMethod validation not needed because all methods are valid
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (158, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (162, @hospiceId, null)

go
*/

commit tran

