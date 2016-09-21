/*
	S58 ATL-836 ATL-859 ACO & PQRS Standard Methodologies 2016 New Metafields - Rollback

	Chris Burkholder

	9/16/2016

	select * from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone')
	select * from standardmailingstep where standardMethodologyid in (select standardmethodologyid from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone'))
	select * from StandardMethodologyBySurveyType where StandardMethodologyID in (select StandardMethodologyID from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone'))

	select * from MetafieldGroupDef
	select * from Metafield where fieldGroup_id in (select fieldgroup_id from MetafieldGroupDef where strFieldGroup_nm in ('ACOCAHPS','PQRS CAHPS'))
	--update MetafieldGroupDef set STRFIELDGROUP_NM = 'CGCAHPS' where FIELDGROUP_ID = 28
*/

begin tran

----------------------- ATL-836 Standard Methodologies ----------------------

declare @ACO int, @PQRS int, @newACOPQRS int

select @ACO = StandardMethodologyID from StandardMethodology where strStandardMethodology_nm = 'ACO Mixed Mail-Phone'
select @PQRS = StandardMethodologyID from StandardMethodology where strStandardMethodology_nm = 'PQRS Mixed Mail-Phone'
/*
insert into StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
select 'ACO-PQRS Mixed Mail-Phone', bitCustom, MethodologyType from StandardMethodology where StandardMethodologyID in (@ACO)
*/
	select * from StandardMethodology where strStandardMethodology_nm = 'ACO-PQRS Mixed Mail-Phone'

select @newACOPQRS = max(StandardMethodologyID) from StandardMethodology where strStandardMethodology_nm = 'ACO-PQRS Mixed Mail-Phone'

delete from StandardMethodology where StandardMethodologyID = @newACOPQRS

/*
insert into StandardMethodologyBySurveyType (StandardMethodologyID, SurveyType_id, SubType_ID, bitExpired)
select @newACOPQRS, SurveyType_id, SubType_id, bitExpired from StandardMethodologyBySurveyType where StandardMethodologyID in (@ACO,@PQRS)
*/
delete from StandardMethodologyBySurveyType where StandardMethodologyID = @newACOPQRS

update StandardMethodologyBySurveyType set bitExpired = 0 where StandardMethodologyID in (@ACO, @PQRS)

	select * from StandardMethodologyBySurveyType where StandardMethodologyID in (@ACO, @PQRS, @newACOPQRS)

/*
insert into StandardMailingStep (StandardMethodologyID, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast)
select @newACOPQRS, intSequence, bitSurveyInLine, bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm, bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep, Quota_ID, QuotaStopCollectionAt, DaysInField, NumberOfAttempts, WeekDay_Day_Call, WeekDay_Eve_Call, Sat_Day_Call, Sat_Eve_Call, Sun_Day_Call, Sun_Eve_Call, CallBackOtherLang, CallbackUsingTTY, AcceptPartial, SendEmailBlast
from StandardMailingStep where StandardMethodologyID = @PQRS
*/
delete from StandardMailingStep where StandardMethodologyID = @newACOPQRS

/*
declare @s1 int, @s2 int, @s3 int, @s4 int
select @s1 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOPQRS and intSequence = 1
select @s2 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOPQRS and intSequence = 2
select @s3 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOPQRS and intSequence = 3
select @s4 = StandardMailingStepID from StandardMailingStep where StandardMethodologyID = @newACOPQRS and intSequence = 4

update StandardMailingStep set ExpireFromStep = @s1, intIntervalDays = 0, ExpireInDays = 83 
where StandardMailingStepID = @s1

update StandardMailingStep set ExpireFromStep = @s1, intIntervalDays = 4, ExpireInDays = 83 
where StandardMailingStepID = @s2

update StandardMailingStep set ExpireFromStep = @s1, intIntervalDays = 21, ExpireInDays = 83  
where StandardMailingStepID = @s3

update StandardMailingStep set ExpireFromStep = @s4, intIntervalDays = 20, ExpireInDays = 36, DaysInField = 28, NumberOfAttempts = 6
where StandardMailingStepID = @s4
*/
	select * from StandardMailingStep where StandardMethodologyID = @newACOPQRS

--------------------ATL - 859 Metafields --------------------

select @ACO = fieldgroup_id from MetaFieldGroupDef where STRFIELDGROUP_NM = 'ACOCAHPS'
select @PQRS = fieldgroup_id from MetaFieldGroupDef where STRFIELDGROUP_NM = 'PQRS CAHPS'

/*
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ACO_LangProt','ACO CAHPS Language protocol for survey',@ACO,'S',5,NULL,NULL,'ACOLngP',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PQRS_LangProt','PQRS CAHPS Language protocol for survey',@PQRS,'S',5,NULL,NULL,'PQRSLngP',0,0,NULL,NULL,0)
*/
delete from MetaField where StrField_NM in ('ACO_LangProt','PQRS_LangProt')

--rollback tran
commit tran

	select * from Metafield where fieldGroup_id in (select fieldgroup_id from MetafieldGroupDef where strFieldGroup_nm in ('ACOCAHPS','PQRS CAHPS'))