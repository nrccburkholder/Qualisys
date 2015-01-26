/*

S16.US16	As an Implementation Associate, I want a new survey type w/ appropriate defaults forCIHIS, so I can set up the survey correctly.

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
DECLARE @Country_id int


SET @SurveyType_desc = 'CIHI CPES-IC'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL
SET @Country_id = 2

begin tran


/*
	Survey Type
*/

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


		UPDATE SurveyType
		SET CAHPSType_id = @SurveyType_ID
		WHERE SurveyType_ID = @SurveyType_ID

END


/*
	Survey Properties
*/

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: SkipEnforcementRequired - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Skip Enforcement is required and controls are not enabled in Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyMethodDefault - CIHI CPES-IC','S','SurveyRules','CalendarMonths',2,NULL,'CIHI Resurvey method default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - CIHI CPES-IC','N','SurveyRules',NULL,12,NULL,'CIHI Resurvey Exclusion Days default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - CIHI CPES-IC','S','SurveyRules',1,NULL,NULL,'CIHI Resurvey Exclusion Days disabled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: IsCAHPS - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Rule to determine if this is a CAHPS survey type for Config Man')


insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
VALUES ('SurveyRule: MedicareIdTextMayBeBlank - CIHI CPES-IC','S','SurveyRules','1',NULL,NULL,'Medicare Id Text May Be Blank for CIHI')

/*
	Methodologies
*/

declare @StandardMethodologyID int
declare @StandardMailingStepID int

insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('CPES-IC Mail Only, 2 Wave', 0, 'Mail Only')

set @StandardMethodologyID=scope_identity()

insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@StandardMethodologyID, @SurveyType_ID, 0)

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

set @StandardMailingStepID = scope_identity()

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 2, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

update StandardMailingStep set ExpireFromStep=@StandardMailingStepID where ExpireFromStep=-1



insert into standardmethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
values ('CPES-IC Mail Only, 3 Wave w/ Letter', 0, 'Mail Only')

set @StandardMethodologyID=scope_identity()

insert into standardmethodologybysurveytype (StandardMethodologyID, SurveyType_id, SubType_ID) values (@StandardMethodologyID, @SurveyType_ID, 0)

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 1, 0, 1, 0, 0, '1st Survey', 1, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

set @StandardMailingStepID = scope_identity()

insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 2, 0, 1, 7, 0, 'Reminder', 0, 0, 84, @StandardMailingStepID, null, null, null, null, null, null, null, null, null, null, null, null, null, null)


insert into standardmailingstep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
values (@StandardMethodologyID, 3, 0, 1, 18, 0, '2nd Survey', 0, 0, 84, -1, null, null, null, null, null, null, null, null, null, null, null, null, null, null)

update StandardMailingStep set ExpireFromStep=@StandardMailingStepID where ExpireFromStep=-1

/*
	META fields
*/

declare @FIELDGROUP_ID int
declare @STRFIELD_NM varchar(20)
declare @STRFIELD_DSC varchar(80)
declare @STRFIELDDATATYPE char(1)
declare @INTFIELDLENGTH int
declare @STRFIELDEDITMASK varchar(20)
declare @INTSPECIALFIELD_CD int
declare @STRFIELDSHORT_NM char(8)
declare @BITSYSKEY bit
declare @bitPhase1Field bit
declare @intAddrCleanCode int
declare @intAddrCleanGroup int
declare @bitPII bit

insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault)
values ('CIHI', NULL, 0)

SELECT @FIELDGROUP_ID = SCOPE_IDENTITY()


SET @STRFIELD_NM = 'CIHI_AdmitSrc'
SET @STRFIELD_DSC = 'Admit Source (DIR or ED) for CPES-IC'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 20
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'CIHIASrc'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


SET @STRFIELD_NM = 'CIHI_ServiceLine'
SET @STRFIELD_DSC = 'Service Line (MED, SURG, OBS) for CPES-IC'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 20
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'CIHIServ'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


SET @STRFIELD_NM = 'CIHI_AdmitAge'
SET @STRFIELD_DSC = 'Age of patient on admission date'
SET @STRFIELDDATATYPE = 'I'
SET @INTFIELDLENGTH = NULL
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'ADmAge'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 1

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


SET @STRFIELD_NM = 'CIHI_AgeCat'
SET @STRFIELD_DSC = 'Patient age category for CPES-IC'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 10
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = 'CIHIAgeC'
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, @FIELDGROUP_ID, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)

SET @STRFIELD_NM = 'CIHI_PIDType'
SET @STRFIELD_DSC = 'Type of Patient identifier (MRN or Other) for CIHI'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 3
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = NULL
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, NULL, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)

SET @STRFIELD_NM = 'HCN'
SET @STRFIELD_DSC = 'Canadian Healthcare Number'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 12
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = NULL
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, NULL, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)

SET @STRFIELD_NM = 'HCN_Issuer'
SET @STRFIELD_DSC = 'Canadian Jurisdiction issuing Healthcare Number'
SET @STRFIELDDATATYPE = 'S'
SET @INTFIELDLENGTH = 3
SET @STRFIELDEDITMASK = NULL
SET @INTSPECIALFIELD_CD = NULL
SET @STRFIELDSHORT_NM = NULL
SET @BITSYSKEY = 0
SET @bitPhase1Field = 0
SET @intAddrCleanCode = NULL
SET @intAddrCleanGroup = NULL
SET @bitPII = 0

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values (@STRFIELD_NM, @STRFIELD_DSC, NULL, @STRFIELDDATATYPE, @INTFIELDLENGTH, @STRFIELDEDITMASK, @INTSPECIALFIELD_CD, @STRFIELDSHORT_NM, @BITSYSKEY, @bitPhase1Field, @intAddrCleanCode, @intAddrCleanGroup, @bitPII)


/*
	DQ Rules
*/

declare @DCStmtId int
declare @FieldId int
declare @strCriteriaStmt_nm varchar(8)
declare @strCriteriaString varchar(7000)
declare @busRule_cd char(1)
--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause

SET @strCriteriaStmt_nm = 'DQ_L Nm'
SET @strCriteriaString = '(POPULATIONLName IS NULL)'
SET @busRule_cd = 'Q'
IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_F Nm'
SET @strCriteriaString = '(POPULATIONFName IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId, )


SET @strCriteriaStmt_nm = 'DQ_Addr'
SET @strCriteriaString = '(POPULATIONADDR IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_City'
SET @strCriteriaString = '(POPULATIONCITY IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_PROV'
SET @strCriteriaString = '(POPULATIONProvince IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_PstCd'
SET @strCriteriaString = '(POPULATIONPostal_Code IS NULL)'
SET @busRule_cd = 'Q'
IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_Age'
SET @strCriteriaString = '(POPULATIONAge IS NULL) OR (POPULATIONAGE < 0)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_SEX'
SET @strCriteriaString = '(POPULATIONSEX IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_LangI'
SET @strCriteriaString = '(POPULATIONLangID IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


SET @strCriteriaStmt_nm = 'DQ_MRN'
SET @strCriteriaString = '(POPULATIONMRN IS NULL)'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)



SET @strCriteriaStmt_nm = 'DQ_MDAE'
SET @strCriteriaString = '(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))'
SET @busRule_cd = 'Q'

IF NOT EXISTS (select 1 from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString )
BEGIN
	insert into DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd)
	values (@strCriteriaStmt_nm, @strCriteriaString, @busRule_cd)
END
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @strCriteriaStmt_nm and strCriteriaString = @strCriteriaString 
insert into SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
values (@SurveyType_ID,@Country_id, @DCStmtId)


/*
	Survey Validation
*/

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SampleUnit'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_Householding'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SamplingEncounterDate'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_ReportingDate'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_FormQuestions'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_SamplePeriods'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CAHPS_EnglishOrFrench'
and svpbst.SurveyValidationProcsToSurveyType_id is null

insert into SurveyValidationProcsBySurveyType ([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_ID])
SELECT svp.SurveyValidationProcs_id,@SurveyType_ID, null
FROM SurveyValidationProcs svp
LEFT JOIN SurveyValidationProcsBySurveyType svpbst on (svpbst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id and svpbst.[CAHPSType_ID] = @SurveyType_ID)
WHERE svp.ProcedureName = 'SV_CIHI_DQRules'
and svpbst.SurveyValidationProcsToSurveyType_id is null

go


commit tran

go

USE QP_PROD
GO

declare @SurveyTypeID int

SELECT @SurveyTypeID = st.[SurveyType_ID]
from SurveyType st
WHERE st.SurveyType_dsc = 'CIHI CPES-IC'


begin tran

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51377,1,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51378,2,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51379,3,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51380,4,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51381,5,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51382,6,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51383,7,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51384,8,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51385,9,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51386,10,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51387,11,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51388,12,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51389,13,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51390,14,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51391,15,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51392,16,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51393,17,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51394,18,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51395,19,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51396,20,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51397,21,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51398,22,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51399,23,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51400,24,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51401,25,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51402,26,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51403,27,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51404,28,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51405,29,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51406,30,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51407,31,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51408,32,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51409,33,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51410,34,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51411,35,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51412,36,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51413,37,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51414,38,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51415,39,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51416,40,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51417,41,1,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51418,42,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51419,43,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51420,44,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id])VALUES(@SurveyTypeID,51424,45,0,0,'2015-01-01 00:00:00.000','2999-12-31 00:00:00.000',0)



commit tran

