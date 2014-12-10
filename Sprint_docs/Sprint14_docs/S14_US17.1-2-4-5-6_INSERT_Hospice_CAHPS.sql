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
Chris Burkholder 17.2, 17.4, 17.5, 17.6

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

go

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


commit tran

