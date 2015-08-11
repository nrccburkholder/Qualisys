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

Chris Burkholder 11.1 12.1 13.1 14.1 

ALTER PROCEDURE [dbo].[SV_CAHPS_Householding]
ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]

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

GO

-- 14.1 -------------------------------------------------------------

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

--select * from SurveyValidationProcsBySurveyType svpbst inner join SurveyValidationProcs svp on svp.SurveyValidationProcs_id = svpbst.SurveyValidationProcs_id where cahpstype_id = 14

insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SampleUnit'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_ActiveMethdology'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SkipPatterns'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_Resurvey'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_Householding'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_ReportingDate'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SamplingMethod'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_FormQuestions'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SamplePeriods'
insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID) SELECT SurveyValidationProcs_id,@SurveyType_ID from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_HasDQRule'

--select * from SurveyTypeQuestionMappings where surveytype_id = 14 order by intorder

--START FROM ACOCAHPS QUESTIONS
insert into SurveyTypeQuestionMappings
select @SurveyType_ID, QstnCore, intOrder, bitFirstOnForm, bitExpanded, '11/1/2015', datEncounterEnd_dt, 0 from SurveyTypeQuestionMappings where surveytype_id = 10 and subtype_id = 11

--SUBSTITUTE NEW PQRS CAHPS QSTNCORE NUMBERS
update SurveyTypeQuestionMappings set QstnCore = 53421 where intorder = 5 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53422 where intorder = 6 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53423 where intorder = 9 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53424 where intorder = 10 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53427 where intorder = 12 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53428 where intorder = 15 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53429 where intorder = 19 and surveytype_id = @SurveyType_ID
update SurveyTypeQuestionMappings set QstnCore = 53425 where intorder = 20 and surveytype_id = @SurveyType_ID

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

declare @pqrsCAHPS int
select @pqrsCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

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

IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS, @hospiceCAHPS, @CIHI, @pqrsCAHPS)
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

declare @pqrsCAHPS int
select @pqrsCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

	IF @surveyType_id in (@hospiceCAHPS, @pqrsCAHPS)
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


commit tran

