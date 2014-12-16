/*

S14.US17.1	As an Implementation Associate, I want a new survey type w/ appropriate defaults for Hospice CAHPS, so I can set up the survey correctly.

17.1	Insert new survey type into SurveyType table
17.2	Insert default into QualProParams
17.3	Insert DQ rules into Default Criteria table
17.4	Add calendar month sample periods to qualproparams
17.5	Check to see if identification of a specific sample unit already works because of additions to tables in previous tasks
17.6	Insert records into standard methodolgy table and hook them up to the valid survey types
	17.7	Document validation rules
17.8	For Hospice CAHPS survey validation insert records into the appropriate tables and possibly add code 

Tim Butler 17.1
Chris Burkholder 17.2, 17.3, 17.4, 17.5, 17.6, 17.8

*/

use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

begin tran

if not exists (	SELECT 1 FROM SurveyType WHERE SurveyType_dsc = @SurveyType_desc)
BEGIN

	INSERT INTO [dbo].[SurveyType]
			   ([SurveyType_dsc]
			   ,[CAHPSType_id]
			   ,[SeedMailings]
			   ,[SeedSurveyPercent]
			   ,[SeedUnitField])
		 VALUES
			   (@SurveyType_desc
			   ,NULL
			   ,1
			   ,2
			   ,'CAHPSType_id')

	SELECT @SurveyType_ID = SCOPE_IDENTITY()

	UPDATE SurveyType
	SET CAHPSType_id = @SurveyType_ID
	WHERE SurveyType_ID = @SurveyType_ID

END

--select * from surveytype
--select * from qualpro_params where strparam_nm like '%HCAHPS IP%' select * from qualpro_params where strparam_nm like '%Hospice%'
--delete from qualpro_params where strparam_nm = 'SurveyRule: IsSamplingMethodDisabled - Hospice CAHPS'

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SkipEnforcementRequired - Hospice CAHPS','S','SurveyRules','1',NULL,NULL,'Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyMethodDefault - Hospice CAHPS','S','SurveyRules','CalendarMonths',2,NULL,'Hospice CAHPS Resurvey method default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Hospice CAHPS','N','SurveyRules',NULL,1,NULL,'Hospice CAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - Hospice CAHPS','S','SurveyRules',1,NULL,NULL,'Hospice CAHPS Resurvey Exclusion Days disabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsMonthlyOnly - Hospice CAHPS','S','SurveyRules','1',NULL,NULL,'Rule to determine if survey type is Monthly only for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SamplingMethodDefault - Hospice CAHPS','S','SurveyRules','Specify Outgo',2,NULL,'Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsCAHPS - Hospice CAHPS','S','SurveyRules','1',NULL,NULL,'Rule to determine if this is a CAHPS survey type for Config Man')

--select * from standardmailingstep select * from standardmethodologybysurveytype select * from standardmethodology select * from methodologysteptype select * from mailingmethodology

insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('Hospice Mixed Mail-Phone', 0, 'Mixed Mail-Phone')
insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('Hospice Mail Only', 0, 'Mail Only')
insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('Hospice Phone Only', 0, 'Phone Only')

declare @hospiceMethodologyId int, @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

select @hospiceMethodologyId = StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = 'Hospice Mixed Mail-Phone'
insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@hospiceMethodologyId, @hospiceId, 0)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@hospiceMethodologyId, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 42, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@hospiceMethodologyId, 2, 0, 1, 18, 0, 'Phone', 0, 1, 42, 1, 1, null, 41, 5, 1, 1, 1, 1, 1, 1, 1, 1, null, null)

select @hospiceMethodologyId = StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = 'Hospice Mail Only'
insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@hospiceMethodologyId, @hospiceId, 0)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@hospiceMethodologyId, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 42, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@hospiceMethodologyId, 2, 0, 1, 18, 0, '2nd Survey', 0, 0, 42, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

select @hospiceMethodologyId = StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = 'Hospice Phone Only'
insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@hospiceMethodologyId, @hospiceId, 0)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@hospiceMethodologyId, 1, 0, 1, 0, 0, 'Phone', 1, 1, 42, 1, 1, null, 41, 5, 1, 1, 1, 1, 1, 1, 1, 1, null, null)

update sms set ExpireFromStep = StandardMailingStepID from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'Hospice Mixed Mail-Phone'
and intSequence = 1

update sms set ExpireFromStep = StandardMailingStepID - 1 from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'Hospice Mixed Mail-Phone'
and intSequence = 2

update sms set ExpireFromStep = StandardMailingStepID from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'Hospice Mail Only'
and intSequence = 1

update sms set ExpireFromStep = StandardMailingStepID - 1 from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'Hospice Mail Only'
and intSequence = 2

update sms set ExpireFromStep = StandardMailingStepID from
--select * from
StandardMailingStep sms inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'Hospice Phone Only'
and intSequence = 1

--select * from metafieldgroupdef select * from metafield
insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('Hospice CAHPS Pop', NULL, 0)

insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('Hospice CAHPS Enc', NULL, 0)

insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('Case Manager Name', 'N', 0)

declare @PopId int, @EncId int, @CaseId int

select @PopId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Hospice CAHPS Pop'
select @EncId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Hospice CAHPS Enc'
select @CaseId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Case Manager Name'

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_HospiceName','Name of hospice',@EncId,'S',	NULL, NULL,'HspNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_NumLiveDisch','Number of live discharges this month for the hospice',@EncId,'I',NULL,NULL,'LiveDsch',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_NumDecd','Total number of decedents this month for the hospice',@EncId,'I',NULL,NULL,'NumDecd',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_NumNoPub','Number of no publicity records excluded from the file by the hospice this month',@EncId,'I',NULL,NULL,'NumNoPub',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecedentID','Unique identifier for hospice decedent',@PopId,'S',NULL,NULL,'DecdID',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdFName','First Name of hospice decedent',@PopId,'S',NULL,NULL,'DecdFNm',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdLName','Last Name of hospice decedent',@PopId,'S',NULL,NULL,'DecdLNm',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdMiddle','Middle Initial of hospice decedent',@PopId,'S',NULL,NULL,'DecdMid',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdTitle','Title of hospice decedent',@PopId,'S',NULL,NULL,'DecdTitl',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdSuffix','Name suffix of hospice decedent',@PopId,'S',NULL,NULL,'DecdSufx',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdSex','Sex of hospice decedent',@PopId,'S',NULL,NULL,'DecdSex',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdHisp','Is hospice decedent Hispanic or Latino?',@PopId,'S',NULL,NULL,'DecdHisp',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdRace','Hospice decedent''s race',@PopId,'S',NULL,NULL,'DecdRace',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DateOfDeath','Hospice decedent''s date of death',@PopId,'D',NULL,NULL,'DecdDOD',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_LastLoc','Last location of hospice care',@EncId,'S',NULL,NULL,'LastLoc',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_Payer1','Hospice CAHPS primary payer',@EncId,'S',NULL,NULL,'HspPayr1',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_Payer2','Hospice CAHPS Secondary Payer',@EncId,'S',NULL,NULL,'HspPayr2',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_Payer3','Hospice CAHPS Other Payer',@EncId,'S',NULL,NULL,'HspPayr3',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CaseMgrFName','Case Manager First Name',@CaseId,'S',NULL,NULL,'CsMgrFNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CaseMgrLName','Case Manager Last Name',@CaseId,'S',NULL,NULL,'CsMgrLNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ReferralSource','Source that referred patient to facility',NULL,'S',NULL,NULL,'RefrSrc',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_CaregiverRelatn','Relationship of caregiver to hospice decedent',@PopId,'S',NULL,NULL,'HspReltn',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_GuardFlg','Flag indicating if hospice caregiver is a non-familial legal guardian',@PopId,'S',NULL,NULL,'HspGuard',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DecdAge','Age at death of hospice decedent',@PopId,'I',NULL,NULL,'HspAge',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_HE_Lang','Hand-entry field for the Hospice CAHPS Language question',@PopId,'S',NULL,NULL,'HSPLang',0,0,NULL,NULL,0)

update metafield set intFieldLength = 50 where STRFIELDSHORT_NM = 'HspNm'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'DecdID'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'DecdFNm'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'DecdLNm'
update metafield set intFieldLength = 1	where STRFIELDSHORT_NM = 'DecdMid'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'DecdTitl'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'DecdSufx'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'DecdSex'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'DecdHisp'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'DecdRace'
update metafield set intFieldLength = 2 where STRFIELDSHORT_NM = 'LastLoc'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'HspPayr1'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'HspPayr2'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'HspPayr3'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'CsMgrFNm'
update metafield set intFieldLength = 42 where STRFIELDSHORT_NM = 'CsMgrLNm'
update metafield set intFieldLength = 50 where STRFIELDSHORT_NM = 'RefrSrc'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'HspReltn'
update metafield set intFieldLength = 1 where STRFIELDSHORT_NM = 'HspGuard'
update metafield set intFieldLength = 50 where STRFIELDSHORT_NM = 'HSPLang'

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
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (156, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (158, @hospiceId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (162, @hospiceId, null)

--declare @hospiceMethodologyId int, @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'
declare @DCStmtId int, @FieldId int

--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Age', '(POPULATIONHSP_DecdAge < 18)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Age'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_DecdAge'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 5, '18', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_LOS', '(ENCOUNTERLengthOfStay < 2)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_LOS'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = 75
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 5, '2', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Rel', '(POPULATIONHSP_CaregiverRelatn = 6)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Rel'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_CaregiverRelatn'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 1, '6', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Guar', '(POPULATIONHSP_GuardFlg = 1)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Guar'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_GuardFlg'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 1, '1', '')


insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, 1)
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, 2)
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, 19)

go


commit tran

