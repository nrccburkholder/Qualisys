/*
S8.US13	Create New Standard Methodology for ACO CAHPS
	As an Operations or Survey Management associate, I want the mail and phone steps to generate at the appropriate time, so that we can field according to the new schedule

T13.1	Add triggers to record the changes in the ChangeLog
T13.2	Update the existing methodology

Dave Gilsdorf

CREATE TRIGGER [dbo].[trg_Upd_dbo_StandardMailingStep] 
UPDATE StandardMailingStep
INSERT INTO ChangeLog
UPDATE MailingStep
*/
use qp_prod
go
begin tran
go
if exists (select * from sys.objects where type='tr' and name = 'trg_Upd_dbo_StandardMailingStep')
	drop trigger [dbo].[trg_Upd_dbo_StandardMailingStep] 
go
begin tran

-- updating the standard methodology
update sms 
set INTINTERVALDAYS=case intSequence 
						when 1 then 0 
						when 2 then 4 
						when 3 then 15
						when 4 then 15
					end
	,ExpireInDays=case intSequence
						when 1 then 64 
						when 2 then 64
						when 3 then 64
						when 4 then 25
					end
	,DaysInField = case when intSequence=4 then 21 else sms.daysinField end
--select sms.* 
from standardmailingstep sms
inner join standardmethodology sm on sms.StandardMethodologyID=sm.StandardMethodologyID
where strStandardMethodology_nm='ACO Mixed Mail-Phone'

-- updating existing surveys that use the standardmethodology (and explicitly inserting records into ChangeLog)
-- intIntervalDays:
insert into dbo.changelog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
select ms.MailingStep_id, 'MethodologyStep', 'DaysSincePreviousStep', ms.INTINTERVALDAYS as oldValue
	, case intSequence	when 1 then 0 
						when 2 then 4 
						when 3 then 15
						when 4 then 15
					end as NewValue
	, getdate(), 'manual:'+system_user, 'U'
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

update ms 
set INTINTERVALDAYS=case intSequence 
						when 1 then 0 
						when 2 then 4 
						when 3 then 15
						when 4 then 15
					end
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

-- ExpireInDays:
insert into dbo.changelog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
select ms.MailingStep_id, 'MethodologyStep', 'ExpirationDays', ms.ExpireInDays as oldValue
	, case intSequence	when 1 then 82 
						when 2 then 82
						when 3 then 82
						when 4 then 25
					end as NewValue
	, getdate(), 'manual:'+system_user, 'U'
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

update ms 
set ExpireInDays=case intSequence
						when 1 then 82 
						when 2 then 82
						when 3 then 82
						when 4 then 25
					end
-- select ms.*
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19

-- DaysInField:
insert into dbo.changelog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
select ms.MailingStep_id, 'MethodologyStep', 'DaysInField', ms.DaysInField as oldValue, 21 as NewValue
	, getdate(), 'manual:'+system_user, 'U'
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19
and intSequence=4

update ms 
set DaysInField=21
-- select ms.*
from mailingmethodology mm
inner join mailingstep ms on mm.methodology_id=ms.methodology_id
where mm.StandardMethodologyID=19
and intSequence=4

rollback tran
commit tran

/*
MAILINGSTEP_ID	BITSURVEYINLINE		OverRide_Langid	
	
      select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='CoverLetterId'			-- SELCOVER_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='DaysInField'			-- DaysInField	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='DaysSincePreviousStep'	-- INTINTERVALDAYS	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='ExpirationDays'			-- ExpireInDays	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='ExpireFromStepId'		-- ExpireFromStep	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsAcceptPartial'		-- AcceptPartial	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsCallBackOtherLang'	-- CallBackOtherLang	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsCallBackUsingTTY'		-- CallbackUsingTTY	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsEmailBlast'			-- SendEmailBlast	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsFirstSurvey'			-- BITFIRSTSURVEY	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSaturdayDayCall'		-- Sat_Day_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSaturdayEveCall'		-- Sat_Eve_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSundayDayCall'		-- Sun_Day_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSundayEveCall'		-- Sun_Eve_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsSurvey'				-- BITSENDSURVEY
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsThankYouLetter'		-- BITTHANKYOUITEM	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsWeekDayDayCall'		-- WeekDay_Day_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='IsWeekDayEveCall'		-- WeekDay_Eve_Call	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='LinkedStepId'			-- MMMailingStep_id (?)
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='MethodologyId'			-- METHODOLOGY_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='Name'					-- STRMAILINGSTEP_NM	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='NumberOfAttempts'		-- NumberOfAttempts	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='QuotaID'				-- Quota_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='QuotaStopCollectionAt'	-- QuotaStopCollectionAt	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='SequenceNumber'			-- INTSEQUENCE	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='StepMethodId'			-- MailingStepMethod_id	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='SurveyId'				-- SURVEY_ID	
union select top 1 * from changelog where idname='methodologystep' and actiontype='A' and property='VendorSurveyID'			-- Vendor_ID
*/
