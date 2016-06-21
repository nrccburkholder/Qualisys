/*

S43 US13 ICH: New Methodologies 
As an authorized ICH-CAHPS vendor, we need to set up new methodologies for Spring 2016, so that we can field compliantly

Tim Butler

Task 2 - Create script using prior examples, plus Catalyst table & run same


*/

use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @Country_id int


SET @SurveyType_desc = 'ICHCAHPS'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'

begin tran



declare @SMid int, @SMSid int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'ICH Mixed Mail-Phone'
SET @MethodologyType = 'Mixed Mail-Phone'


	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID in (
		select StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
	)	


																													
insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																													

set @SMid=scope_identity()	
insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_id)																												
																																																																																		
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'1'	,'Prenote'	,'0'	,'84'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
set @SMSid=scope_identity()																													
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'2'	,'1st Survey'	,'11'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast,	quota_id		)
values (@SMid	,'3'	,'Phone'	,'26'	,'88'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'1'	,'42'	,'10'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL    , 1 )
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
																									
	


SET @StandardMethodology_nm = 'ICH Mail Only'
SET @MethodologyType = 'Mail Only'


	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID in (
		select StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
	)	


insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																													
																												
set @SMid=scope_identity()	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_ID)	
																											
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'1'	,'Prenote'	,'0'	,'84'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
set @SMSid=scope_identity()																													
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'2'	,'1st Survey'	,'11'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'3'	,'2nd Survey'	,'25'	,'84'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1																													
																													
																											

SET @StandardMethodology_nm = 'ICH Phone Only'
SET @MethodologyType = 'Phone Only'

	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID in (
		select StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
	)	


insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																												
																													
set @SMid=scope_identity()	insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_ID)																												


insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'1'	,'Prenote'	,'0'	,'84'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
set @SMSid=scope_identity()																													
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast, Quota_ID				)
values (@SMid	,'2'	,'Phone'	,'12'	,'88'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'1'	,'70'	,'10'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL, 1		)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1		


go

select *
from StandardMethodology where strStandardMethodology_nm like 'ICH%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'
)


select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'
)

go																											


commit tran
go



select *
from StandardMethodology where strStandardMethodology_nm like 'ICH%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'
)


select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'
)

go

