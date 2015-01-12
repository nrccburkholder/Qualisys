/*

S14B.US9.1	As an Implementation Associate, I want Hospice CAHPS specific survey validation, so ensure my survey setup is compliant.

8.1	For Hospice CAHPS survey validation insert records into the appropriate tables and possibly add code 

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
--begin block delete clean-up for 'HSP_DateOfDeath'
delete from metastructure where field_id in (select field_id from metafield where STRFIELD_NM = 'HSP_DateOfDeath')
update sd set sd.SampleEncounterField_id = 117
--select * 
from survey_def sd where sd.SampleEncounterField_id in (select field_id from metafield where STRFIELD_NM = 'HSP_DateOfDeath')
delete 
--select *
from Metafield where STRFIELD_NM = 'HSP_DateOfDeath' --removed per Dana 12/16/2014
/* select * from metafield where STRFIELD_NM in ('HSP_DateOfDeath', 'ServiceDate') select * from metastructure select * from survey_def where SampleEncounterField_id = 1675
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_DateOfDeath','Hospice decedent''s date of death',@PopId,'D',NULL,NULL,'DecdDOD',0,0,NULL,NULL,1)*/
--end block delete clean-up for 'HSP_DateOfDeath'
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

--@hospiceId int
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

--declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'
declare @DCStmtId int, @FieldId int

--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Age', '(POPULATIONHSP_DecdAge < 18)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Age' and strCriteriaString = '(POPULATIONHSP_DecdAge < 18)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_DecdAge'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 5, '18', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_LOS', '(ENCOUNTERLengthOfStay < 2)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_LOS' and strCriteriaString = '(ENCOUNTERLengthOfStay < 2)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = 75
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 5, '2', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Rel', '(POPULATIONHSP_CaregiverRelatn = 6)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Rel' and strCriteriaString = '(POPULATIONHSP_CaregiverRelatn = 6)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@hospiceId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_CaregiverRelatn'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 1, '6', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Guar', '(POPULATIONHSP_GuardFlg = 1)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Guar' and strCriteriaString = '(POPULATIONHSP_GuardFlg = 1)'
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

-----------------------START S14B US8 Survey Validation Adds/Changes

--declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

delete from SurveyValidationProcsBySurveyType where surveyvalidationprocs_id = 166 and CAHPSType_ID = @hospiceId

insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (163, @hospiceId, null)
/*insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (166, @hospiceId, null)
*/


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Householding]    Script Date: 12/19/2014 11:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS, @hospiceCAHPS)
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

	IF @surveyType_id in (@hospiceCAHPS)
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

SELECT * FROM #M

DROP TABLE #M

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Hospice_CAHPS_DQRules]    Script Date: 12/19/2014 4:00:10 PM ******/
IF object_id('SV_CAHPS_Hospice_CAHPS_DQRules') IS NULL
    EXEC ('create procedure dbo.SV_CAHPS_Hospice_CAHPS_DQRules as select 1')
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_Hospice_CAHPS_DQRules]
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

--get Encounter MetaTable_ID this is so we can check for field existance before we check for
		--DQ rules.  If the field is not in the data structure we do not want to check for the error.
		SELECT @EncTable_ID = mt.Table_id
		FROM dbo.MetaTable mt
		WHERE mt.strTable_nm = 'ENCOUNTER'
		  AND mt.Study_id = @Study_id


		--check for DQ_L NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_L NM'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LName IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LName IS NULL).'


		--check for DQ_F NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_F NM'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (FName IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (FName IS NULL).'

		--check for DQ_MDFA Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_MDFA'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr = ''FO'').'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (AddrErr = ''FO'').'


		--check for DQ_Age Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Age'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (HSP_DecdAge < 18).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (HSP_DecdAge < 18).'

		--check for DQ_LOS Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_LOS'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LengthOfStay < 2).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LengthOfStay < 2).'

		--check for DQ_Rel Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Rel'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (HSP_CaregiverRelatn=6).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (HSP_CaregiverRelatn=6).'

		--check for DQ_Guar Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Guar'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (HSP_GuardFlg = 1).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (HSP_GuardFlg = 1).'

SELECT * FROM #M

DROP TABLE #M

GO

declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51574, 1, 1, 0, '2015-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @hospiceId, 0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51575,	2,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51576,	3,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51577,	4,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51578,	5,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51579,	6,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51580,	7,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51581,	8,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51582,	9,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51583,	10,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51584,	11,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51585,	12,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51586,	13,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51587,	14,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51588,	15,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51589,	16,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51590,	17,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51591,	18,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51592,	19,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51593,	20,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51594,	21,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51595,	22,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51596,	23,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51597,	24,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51598,	25,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51599,	26,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51600,	27,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51601,	28,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51602,	29,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51603,	30,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51604,	31,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51605,	32,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51606,	33,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51607,	34,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51608,	35,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51609,	36,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51610,	37,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51611,	38,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51612,	39,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51613,	40,	1,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51614,	41,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51615,	42,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51616,	43,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
/*
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51621,	44,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51622,	45,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51623,	46,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51624,	47,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51625,	48,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51626,	49,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51627,	50,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
*/
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51617,	44,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51618,	45,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51619,	46,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (51620,	47,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)
insert into SurveyTypeQuestionMappings (QstnCore, intOrder,	bitFirstOnForm,	bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SurveyType_id, SubType_ID)
values (52366,	48,	0,	0,	'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000', @hospiceId,0)

insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecedentID',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecdFName',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecdLName',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecdMiddle',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecdSex',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecdHisp',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population	','HSP_DecdRace',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_CaregiverRelatn',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_GuardFlg',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_DecdAge',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','HSP_HE_Lang',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Population','DOB',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_HospiceName',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_NumLiveDisch',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_NumDecd',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_NumNoPub',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_LastLoc',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_Payer1',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_Payer2',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','HSP_Payer3',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','ICD9',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','CCN',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','AdmitDate',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','LengthOfStay',1)
insert into surveyvalidationfields(SurveyType_id, TableName, ColumnName, bitActive)
values (@hospiceId, 'Encounter','ServiceDate',1)

--declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

insert into SurveyValidationProcs (ProcedureName, ValidMessage, intOrder)
values ('SV_CAHPS_Hospice_CAHPS_DQRules', 'Check DQ rules',	40)

declare @SV_Hospice_Id int
select @SV_Hospice_Id = SurveyValidationProcs_id from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_Hospice_CAHPS_DQRules'

insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_id)
values (@SV_Hospice_Id, @HospiceId)
-----------------------END S14B US8 Survey Validation Adds/Changes
go

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_EnglishOrSpanish]    Script Date: 12/22/2014 9:42:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
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
/*
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
*/
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

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 12/22/2014 10:23:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
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
SET @hospiceCAHPS = 11

declare @PCMHSubType int
SET @PCMHSubType = 9

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

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id

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

	IF (@surveyType_id = @HHCAHPS) OR (@SurveyType_id = @hospiceCAHPS)
	BEGIN

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
	ELSE
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

/****** Object:  StoredProcedure [dbo].[SV_SurveyProperties]    Script Date: 12/22/2014 1:51:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************************************************
Proc: SV_SurveyProperties
Created: ???
Purpose: called during survey validation.  This proc checks for generic rules that apply to all surveys 
		 contained within Qualisys

Modified:
	MWB 12/21/2009
		Added Householding field checks if householding is turned on.  
	MWB 03/11/2010
		Modified qstncore count to look at both Qualisys and Datamart for total questions.
		Does not account for questions that may have been removed from the datamart questions table.
	CJB 08/29/2014
		Added check for those survey types requiring USPS Address Change service 
  
***********************************************************************************************************/  
ALTER PROCEDURE [dbo].[SV_SurveyProperties]    
@Survey_id INT    
AS    

declare @Study_ID int, @qstncoreCnt int
    
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))    
Create table #tot_Qstncores (qstncore int, Type Varchar(1))  

IF NOT EXISTS(SELECT * FROM survey_def WHERE Survey_id=@Survey_id AND cutofftable_id=SampleEncounterTable_id and cutofffield_id=SampleEncounterField_id)    
INSERT INTO #M (Error, strMessage)    
SELECT 2 Error,'Sample Encounter Date Field and Report Date Field are different.'    
ELSE    
INSERT INTO #M (Error, strMessage)    
SELECT 0 Error,'Sample Encounter Date Field and Report Date Field are the same.'    

--===================================================================================
--CHECK TOTAL NUMBER OF QUESTIONS TO MAKE SURE THEY ARE NOT OVER THE 1024 LIMIT

Select @Study_ID = Study_Id from SURVEY_DEF where SURVEY_ID = @Survey_id

  
insert into #tot_Qstncores    
select distinct sq.qstncore, 'Q'  
from sel_qstns sq  
where sq.SURVEY_ID in (SELECT SURVEY_ID from SURVEY_DEF where STUDY_ID = @study_Id)
and sq.qstncore > 0
  
insert into #tot_Qstncores    
select distinct q.qstncore, 'D'  
from datamart.qp_comments.dbo.questions q    
where q.SURVEY_ID in (SELECT SURVEY_ID from datamart.qp_comments.dbo.clientstudysurvey where STUDY_ID = @study_Id)    
and q.qstncore > 0


Select @qstncoreCnt = COUNT(DISTINCT qstncore) from #tot_Qstncores

if (@qstncoreCnt) > 1000  
 BEGIN  
  INSERT INTO #M (Error, strMessage)    
  SELECT 1 Error,'Qstncore count is greater than 1000.  Please do not exceed 1000'    
 END  
ELSE    
 BEGIN  
  if (@qstncoreCnt) > 700  
  INSERT INTO #M (Error, strMessage)    
  SELECT 2 Error,'Qstncore count is greater than 700.  Please do not exceed 1000'    
  ELSE    
  INSERT INTO #M (Error, strMessage)    
  SELECT 0 Error,'You currently have ' + cast(@qstncoreCnt as varchar(15)) + ' questions fielded for study_ID ' + cast(@study_Id as varchar(15))  
 END  

--END: CHECK TOTAL NUMBER OF QUESTIONS TO MAKE SURE THEY ARE NOT OVER THE 1024 LIMIT 
--===================================================================================
  

--Check for HouseHolding            
if exists 
	(
	SELECT	'x'
	FROM	Survey_def sd         
	WHERE	sd.Survey_id=@Survey_id and 
			strHouseholdingType <> 'N'                       
	)     
BEGIN       
	--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns                
	INSERT INTO #M (Error, strMessage)                
	SELECT 1,'When Householding is turned on ' + strField_nm+ ' must be an included householding column.'                
	FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a                
	  LEFT JOIN HouseHoldRule hhr                
	ON a.Field_id=hhr.Field_id                
	AND hhr.Survey_id=@Survey_id                
	WHERE hhr.Field_id IS NULL           
END

if dbo.SurveyProperty('UseUSPSAddrChangeServiceDefault', null, @Survey_id) = 1
BEGIN
	if exists(select 1 from survey_def where UseUSPSAddrChangeService = 0 and survey_id = @Survey_id)
	insert into #M (Error, strMessage)
		select 1,'This survey must have USPS Address Change Service turned on'
	else
	insert into #M (Error, strMessage)
		select 0,'This survey does have USPS Address Change Service turned on as it should'

	declare @FirstStepCover varchar(42)

	select @firstStepCover=rtrim(description)
	from (                  select distinct st.CoverID, st.Language, sc.description
							from sel_cover sc
							inner join sel_textbox st on sc.survey_id=st.survey_id and sc.selcover_id=st.coverid
							inner join mailingmethodology mm on st.survey_id=mm.survey_id
							inner join mailingstep ms on mm.methodology_id=ms.methodology_id and st.coverid=ms.selcover_id
							where st.survey_id=@survey_id
							and ms.intSequence=1) coverlang
	left outer join (select distinct st.CoverID, st.Language
							from sel_textbox st 
							inner join mailingmethodology mm on st.survey_id=mm.survey_id
							inner join mailingstep ms on mm.methodology_id=ms.methodology_id and st.coverid=ms.selcover_id
							where st.survey_id=@survey_id
							and ms.intSequence=1
							and st.richtext like '%ELECTRONIC SERVICE REQUESTED%') esr
		  on coverlang.coverid=esr.coverid and coverlang.language=esr.language
	where esr.coverid is null

	if @@rowcount>0
	  	insert into #M (Error, strMessage)
		select 1,'The phrase "ELECTRONIC SERVICE REQUESTED" isn''t on the "'+@firstStepCover+'" cover letter'
	else
	  	insert into #M (Error, strMessage)
		select 0,'The phrase "ELECTRONIC SERVICE REQUESTED" was found on the first letter'

END
    
SELECT * FROM #M    
    
DROP TABLE #M

GO

commit tran

