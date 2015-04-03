

declare @SMid int, @SMSid int, @SurveyTypeid int, @Subtype_Id int

if not exists (select 1 from subtype where Subtype_nm = 'PCMH') 
	INSERT INTO dbo.subtype VALUES ('PCMH',1,0)
update dbo.subtype set subtype_nm = 'PCMH Distinction', bitRuleOverride = 1
where subtype_nm = 'PCMH'
																												
select @SurveyTypeid = surveytype_id from surveytype where SurveyType_dsc='CGCAHPS'	

select @subtype_id = st.subtype_id 
from surveytypesubtype stst
inner join subtype st on st.subtype_id = stst.subtype_id
where st.Subtype_nm = 'PCMH'
	
if not exists (select 1 from surveytypesubtype where surveytype_id = @surveytypeid and subtype_id = @subtype_id)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (@SurveyTypeid,@subtype_id)


begin tran
																									
insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values ('PCMH Mixed Mail-Phone',0,' Mixed Mail-Phone')																													
set @SMid=scope_identity()	

insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id,SubType_ID) values (@SMid, @SurveyTypeid,@subtype_id)	
																										
	
																												
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast, Quota_ID		)
values (@SMid	,'1'	,'1st Survey'	,'0'	,'42'	,'-1'	,'0'	,'1'	,'0'	,'1'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL, 1		)
set @SMSid=scope_identity()
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast, Quota_ID		)
values (@SMid	,'2'	,'Phone'	,'18'	,'42'	,'-1'	,'0'	,'1'	,'0'	,'0'	,'1'	,'21'	,'5'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL, 1		)

insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values ('PCMH Mail Only',0,' Mail Only')																													
set @SMid=scope_identity()	

update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1

insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id,SubType_ID) values (@SMid, @SurveyTypeid,@subtype_id)																												
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast, Quota_ID		)
values (@SMid	,'1'	,'1st Survey'	,'0'	,'42'	,'-1'	,'0'	,'1'	,'0'	,'1'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL, 0		)
set @SMSid=scope_identity()	
																												
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast, Quota_ID		)
values (@SMid	,'2'	,'2nd Survey'	,'18'	,'42'	,'-1'	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL, 0		)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1	

																												
insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values ('PCMH Phone Only',0,' Phone Only')																													
set @SMid=scope_identity()	

insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id, SubType_ID) values (@SMid, @SurveyTypeid, @subtype_id)																												
set @SMSid=scope_identity()	
																												
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast, Quota_ID		)
values (@SMid	,'1'	,'Phone'	,'0'	,'42'	,'-1'	,'0'	,'1'	,'0'	,'0'	,'1'	,'41'	,'5'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL, 1		)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													


  commit tran




select *
from StandardMethodology where strStandardMethodology_nm like 'PCMH%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'PCMH%'
)

select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'PCMH%'
)

-- Will need to double-check the ExpireFromStep in StandardMailingStep to make sure the values match the appropriate StandardMailingStepID

