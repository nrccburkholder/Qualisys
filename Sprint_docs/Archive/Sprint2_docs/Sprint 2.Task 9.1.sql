/*
story 9: As an Implementation Associate, I want standard methodologies available for selection for ICH-CAHPS survey types, so that I 
can more easily set up the survey according to protocols
task 9.1: Modify Script to insert records
*/
use qp_prod
go
declare @SMid int, @SMSid int, @SurveyTypeid int																													
select @SurveyTypeid = surveytype_id from surveytype where SurveyType_dsc='ICHCAHPS'																													

if @SurveyTypeid is null
begin
	print 'ICHCAHPS survey type isn''t defined yet. aborting'
end
else
begin
	begin tran
	insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values ('ICH Mixed Mail-Phone',0,'Mixed Mail-Phone')																													
	set @SMid=scope_identity()	
	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyTypeid)																												
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'1'	,'Prenote'	,'0'	,'84'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	set @SMSid=scope_identity()																													
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'2'	,'1st Survey'	,'4'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast	,Quota_id	)
	values (@SMid	,'3'	,'Phone'	,'25'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'1'	,'46'	,'10'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL	,1	)
	update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
																														
	insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values ('ICH Mail Only',0,'Mail Only')																													
	set @SMid=scope_identity()	
	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyTypeid)																												
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'1'	,'Prenote'	,'0'	,'84'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	set @SMSid=scope_identity()																													
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'2'	,'1st Survey'	,'4'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'3'	,'2nd Survey'	,'25'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
																														
																														
	insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values ('ICH Phone Only',0,'Phone Only')																													
	set @SMid=scope_identity()	
	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyTypeid)																												
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
	values (@SMid	,'1'	,'Prenote'	,'0'	,'84'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
	set @SMSid=scope_identity()																													
	insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep		,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast,	quota_id	)
	values (						 @SMid					,'2'			,'Phone'			,'5'				,'84'			,'-1' /*prenote*/	,'0'				,'1'			,'0'				,'0'			,'1'					,'75'			,'10'				,'1'				,'1'				,'1'			,'1'			,'1'			,'1'					,'1'				,'0'					,NULL					,NULL				,1	)
	update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													

	commit tran
end
