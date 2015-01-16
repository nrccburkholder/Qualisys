/*

S14.US16	As an Implementation Associate, I want a new survey type w/ appropriate defaults forCIHIS, so I can set up the survey correctly.

16.2	Create new Suvey type and properties' defaults 
16.3	Create new Metafields
16.4	Create standard default DQ rules
16.5	Create sample period defaults
16.6	Create standard methodologies
16.7	Create survey validation rules


*/

use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @IsCAHPS bit

SET @IsCAHPS = 0

SET @SurveyType_desc = 'CIHI CPES-IC'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL

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
			   ,@SeededMailings
			   ,@SeedSurveyPercent
			   ,@SeedUnitField)

	SELECT @SurveyType_ID = SCOPE_IDENTITY()

	IF @IsCAHPS = 1
		UPDATE SurveyType
		SET CAHPSType_id = @SurveyType_ID
		WHERE SurveyType_ID = @SurveyType_ID

END


--select * from surveytype
--select * from qualpro_params where strparam_nm like '%HCAHPS IP%' select * from qualpro_params where strparam_nm like '%CIHI%'
--delete from qualpro_params where strparam_nm = 'SurveyRule: IsSamplingMethodDisabled - CIHI CPES-IC'

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SkipEnforcementRequired - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyMethodDefault - CIHI CPES-IC','S','SurveyRules','CalendarMonths',2,NULL,'CIHI Resurvey method default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - CIHI CPES-IC','N','SurveyRules',NULL,12,NULL,'CIHI Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - CIHI CPES-IC','S','SurveyRules',1,NULL,NULL,'CIHI Resurvey Exclusion Days disabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsMonthlyOnly - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Rule to determine if survey type is Monthly only for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsCAHPS - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Rule to determine if this is a CAHPS survey type for Config Man')

--select * from standardmailingstep select * from standardmethodologybysurveytype select * from standardmethodology select * from methodologysteptype select * from mailingmethodology

insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('CPES-IC Mail Only, 2 Wave', 0, 'Mail Only')


declare @CIHIMethodologyId int, @CIHIId int
select @CIHIId = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc

select @CIHIMethodologyId = StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = 'CPES-IC Mail Only, 2 Wave'
insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@CIHIMethodologyId, @CIHIId, 0)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@CIHIMethodologyId, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@CIHIMethodologyId, 2, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, 1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

update sms 
set ExpireFromStep = StandardMailingStepID from
--select * from
StandardMailingStep sms 
inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'CPES-IC Mail Only, 2 Wave'
and intSequence = 1

update sms 
set ExpireFromStep = StandardMailingStepID - 1 from
--select * from
StandardMailingStep sms 
inner join StandardMethodology sm on sms.StandardMethodologyID = sm.StandardMethodologyID 
where strStandardMethodology_nm = 'CPES-IC Mail Only, 2 Wave'
and intSequence = 2

--select * from metafieldgroupdef select * from metafield
insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('CIHI Pop', NULL, 0)

insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('CIHI Enc', NULL, 0)

insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('Case Manager Name', 'N', 0)

declare @PopId int, @EncId int, @CaseId int

select @PopId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'CIHI Pop'
select @EncId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'CIHI Enc'
select @CaseId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Case Manager Name'

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_CIHIName','Name of CIHI',@EncId,'S',	NULL, NULL,'HspNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_NumLiveDisch','Number of live discharges this month for the CIHI',@EncId,'I',NULL,NULL,'LiveDsch',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_NumDecd','Total number of decedents this month for the CIHI',@EncId,'I',NULL,NULL,'NumDecd',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_NumNoPub','Number of no publicity records excluded from the file by the CIHI this month',@EncId,'I',NULL,NULL,'NumNoPub',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecedentID','Unique identifier for CIHI decedent',@PopId,'S',NULL,NULL,'DecdID',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdFName','First Name of CIHI decedent',@PopId,'S',NULL,NULL,'DecdFNm',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdLName','Last Name of CIHI decedent',@PopId,'S',NULL,NULL,'DecdLNm',0,0,NULL,NULL,1)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdMiddle','Middle Initial of CIHI decedent',@PopId,'S',NULL,NULL,'DecdMid',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdTitle','Title of CIHI decedent',@PopId,'S',NULL,NULL,'DecdTitl',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdSuffix','Name suffix of CIHI decedent',@PopId,'S',NULL,NULL,'DecdSufx',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdSex','Sex of CIHI decedent',@PopId,'S',NULL,NULL,'DecdSex',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdHisp','Is CIHI decedent Hispanic or Latino?',@PopId,'S',NULL,NULL,'DecdHisp',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdRace','CIHI decedent''s race',@PopId,'S',NULL,NULL,'DecdRace',0,0,NULL,NULL,0)
--begin block delete clean-up for 'CIHI_DateOfDeath'
delete from metastructure where field_id in (select field_id from metafield where STRFIELD_NM = 'CIHI_DateOfDeath')
update sd set sd.SampleEncounterField_id = 117
--select * 
from survey_def sd where sd.SampleEncounterField_id in (select field_id from metafield where STRFIELD_NM = 'CIHI_DateOfDeath')
delete 
--select *
from Metafield where STRFIELD_NM = 'CIHI_DateOfDeath' --removed per Dana 12/16/2014
/* select * from metafield where STRFIELD_NM in ('CIHI_DateOfDeath', 'ServiceDate') select * from metastructure select * from survey_def where SampleEncounterField_id = 1675
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DateOfDeath','CIHI decedent''s date of death',@PopId,'D',NULL,NULL,'DecdDOD',0,0,NULL,NULL,1)*/
--end block delete clean-up for 'CIHI_DateOfDeath'
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_LastLoc','Last location of CIHI care',@EncId,'S',NULL,NULL,'LastLoc',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_Payer1','CIHI primary payer',@EncId,'S',NULL,NULL,'HspPayr1',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_Payer2','CIHI Secondary Payer',@EncId,'S',NULL,NULL,'HspPayr2',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_Payer3','CIHI Other Payer',@EncId,'S',NULL,NULL,'HspPayr3',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CaseMgrFName','Case Manager First Name',@CaseId,'S',NULL,NULL,'CsMgrFNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CaseMgrLName','Case Manager Last Name',@CaseId,'S',NULL,NULL,'CsMgrLNm',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ReferralSource','Source that referred patient to facility',NULL,'S',NULL,NULL,'RefrSrc',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_CaregiverRelatn','Relationship of caregiver to CIHI decedent',@PopId,'S',NULL,NULL,'HspReltn',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_GuardFlg','Flag indicating if CIHI caregiver is a non-familial legal guardian',@PopId,'S',NULL,NULL,'HspGuard',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_DecdAge','Age at death of CIHI decedent',@PopId,'I',NULL,NULL,'HspAge',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('CIHI_HE_Lang','Hand-entry field for the CIHI Language question',@PopId,'S',NULL,NULL,'HSPLang',0,0,NULL,NULL,0)

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

--declare @CIHIMethodologyId int, @CIHIId int
select @CIHIId = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc

insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (147, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (148, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (149, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (150, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (151, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (153, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (155, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (156, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (158, @CIHIId, null)
insert into SurveyValidationProcsBySurveyType (svpbst.[SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
values (162, @CIHIId, null)

--declare @CIHIMethodologyId int, @CIHIId int
select @CIHIId = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc
declare @DCStmtId int, @FieldId int

--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_L Nm', '(POPULATIONLName IS NULL)', 'Q')
SELECT @DCStmtId = SCOPE_IDENTITY()
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, @DCStmtId)

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_F Nm', '(POPULATIONFName IS NULL)', 'Q')
SELECT @DCStmtId = SCOPE_IDENTITY()
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, @DCStmtId)

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Age', '(POPULATIONHSP_DecdAge < 18)', 'Q')

select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Age' and strCriteriaString = '(POPULATIONHSP_DecdAge < 18)'

insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_DecdAge'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 5, '18', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_LOS', '(ENCOUNTERLengthOfStay < 2)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_LOS' and strCriteriaString = '(ENCOUNTERLengthOfStay < 2)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, @DCStmtId)
select @Fieldid = 75
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'ENCOUNTER', @Fieldid, 5, '2', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Rel', '(POPULATIONHSP_CaregiverRelatn = 6)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Rel' and strCriteriaString = '(POPULATIONHSP_CaregiverRelatn = 6)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_CaregiverRelatn'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 1, '6', '')

insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
values ('DQ_Guar', '(POPULATIONHSP_GuardFlg = 1)', 'Q')
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_Guar' and strCriteriaString = '(POPULATIONHSP_GuardFlg = 1)'
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, @DCStmtId)
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'HSP_GuardFlg'
insert into DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@DCStmtId, 1, 'POPULATION', @Fieldid, 1, '1', '')


insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, 1)
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, 2)
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@CIHIId, 1, 19)

go


commit tran

