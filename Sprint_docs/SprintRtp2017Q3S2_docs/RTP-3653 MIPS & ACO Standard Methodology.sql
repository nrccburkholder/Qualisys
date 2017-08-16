/*
	RTP-3653 MIPS & ACO Standard Methodology.sql

	Chris Burkholder

	8/16/2017

	select * from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone','ACO-PQRS Mixed Mail-Phone','ACO-MIPS Mixed Mail-Phone')
	select * from standardmailingstep where standardMethodologyid in (select standardmethodologyid from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone','ACO-PQRS Mixed Mail-Phone','ACO-MIPS Mixed Mail-Phone'))
	select * from StandardMethodologyBySurveyType where StandardMethodologyID in (select StandardMethodologyID from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone','ACO-PQRS Mixed Mail-Phone','ACO-MIPS Mixed Mail-Phone'))
*/

USE [QP_PROD]
GO

begin tran

----------------------- RTP-3653 MIPS & ACO Standard Methodology ----------------------

declare @ACOPQRS int, @newACOMIPS int

select @ACOPQRS = StandardMethodologyID from StandardMethodology where strStandardMethodology_nm = 'ACO-PQRS Mixed Mail-Phone'

insert into StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
select 'ACO-MIPS Mixed Mail-Phone', bitCustom, MethodologyType from StandardMethodology where StandardMethodologyID in (@ACOPQRS)

	select * from StandardMethodology where strStandardMethodology_nm = 'ACO-MIPS Mixed Mail-Phone'

select @newACOMIPS = max(StandardMethodologyID) from StandardMethodology group by strStandardMethodology_nm having strStandardMethodology_nm = 'ACO-MIPS Mixed Mail-Phone'

insert into StandardMethodologyBySurveyType (StandardMethodologyID, SurveyType_id, SubType_ID, bitExpired)
select @newACOMIPS, SurveyType_id, SubType_id, bitExpired from StandardMethodologyBySurveyType where StandardMethodologyID in (@ACOPQRS)

update StandardMethodologyBySurveyType set bitExpired = 1 where StandardMethodologyID in (@ACOPQRS)

	select * from StandardMethodologyBySurveyType where StandardMethodologyID in (@ACOPQRS, @newACOMIPS)

insert into StandardMailingStep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
select @newACOMIPS, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast
from StandardMailingStep where StandardMethodologyID = @ACOPQRS

declare @s1 int, @s2 int, @s3 int, @s4 int
select @s1 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOMIPS and intSequence = 1
select @s2 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOMIPS and intSequence = 2
select @s3 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOMIPS and intSequence = 3
select @s4 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOMIPS and intSequence = 4

update StandardMailingStep set ExpireFromStep = @s1, intIntervalDays = 0, ExpireInDays = 84 
where StandardMailingStepID = @s1

update StandardMailingStep set ExpireFromStep = @s1, intIntervalDays = 1, ExpireInDays = 84 
where StandardMailingStepID = @s2

update StandardMailingStep set ExpireFromStep = @s1, intIntervalDays = 22, ExpireInDays = 84  
where StandardMailingStepID = @s3

update StandardMailingStep set ExpireFromStep = @s4, intIntervalDays = 20, ExpireInDays = 36, DaysInField = 29, NumberOfAttempts = 6
where StandardMailingStepID = @s4

	select * from StandardMailingStep where StandardMethodologyID = @newACOMIPS
--rollback tran
commit tran

GO