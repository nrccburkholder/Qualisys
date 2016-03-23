/*
	S45 US 8 Hospice Post-Process Error Logging 
	As a developer, I want to check the nightly Hospice extract for errors and log them to a file so that we can track down what conditions are causing problems before it's time for the submission
	
	8.4 - Select items from doc to implement & implement them
	
*/
use NRC_Datamart_Extracts
go
if exists (select * from sys.tables where name = 'ErrorLog')
	drop table [CEM].[ErrorLog] 
go
create table [CEM].[ErrorLog] (ErrorLogId int identity(1,1), ErrorDateTime datetime, ExportQueueID int, ErrorType varchar(200), ErrorSource varchar(200), ErrorIdentity varchar(200), ErrorDescription varchar(200))
go
if exists (select * from sys.procedures where name = 'ExportErrorChecks00000011')
	drop procedure [CEM].[ExportErrorChecks00000011]
go
create procedure [CEM].[ExportErrorChecks00000011]
@ExportQueueID int=0
as
create table #ErrorLog (ErrorLogId int identity(1,1), ErrorDateTime datetime, ExportQueueID int, ErrorType varchar(200), ErrorSource varchar(200), ErrorIdentity varchar(200), ErrorDescription varchar(200))

declare @sql varchar(max)=''

-- if you don't specificy a @ExportQueueID, we'll process all un-processed QueueIDs. Otherwise, we'll just process the one specified -- unless it's already been processed.
-- to reprocess a specific ExportQueueID, you first need to delete its records out of CEM.ErrrorLog 
select distinct ExportQueueID, 0 as flag
into #Queues
from cem.ExportDataset00000011
where ExportQueueID not in (select ExportQueueID from [CEM].[ErrorLog])
and (ExportQueueID=@ExportQueueID or @ExportQueueID=0)

select top 1 @exportqueueid = exportqueueid from #queues where flag=0
while @@rowcount>0
begin

	--•	NULL or blank [hospicedata.no-publicity] fields
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.no-publicity is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'no-publicity='+isnull(convert(varchar,[hospicedata.no-publicity]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.no-publicity] = '' or [hospicedata.no-publicity] is null)


	--•	NULL or blank [decedentleveldata.decedent-race] fields
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.decedent-race is null'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')
		, 'decedent-race='+isnull(convert(varchar,[decedentleveldata.decedent-race]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([decedentleveldata.decedent-race] = '' or [decedentleveldata.decedent-race] is null)

	--•	NULL or blank [decedentleveldata.lag-time] fields
	--•	This has been related to surveys that have NULL datReturned and NULL datUnusedReturn but have something in strScanBatch
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.lag-time is null'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')
		, 'lag-time='+isnull(convert(varchar,[decedentleveldata.lag-time]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([decedentleveldata.lag-time] = '' or [decedentleveldata.lag-time] is null)

	--•	Respondents who answer “NEVER” to being involved in the decedent’s care, should have a disposition of 6
	--Find where this happens (completeness check?). Was this all cases or just some?
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice."never involved in care" should have survey-status=6'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')
		, 'survey-status='+isnull(convert(varchar,[decedentleveldata.survey-status]),'null')+';oversee='+isnull(convert(varchar,[caregiverresponse.oversee]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and [caregiverresponse.oversee]='1' 
	and ltrim(rtrim([decedentleveldata.survey-status]))<>'6'

	--•	All records with a Complete disposition should have 50%+ ATA questions answered
	--•	All records with a Partial (break-off) disposition should have 1-49.0% ATA questions answered
	/*
	select distinct qm.*, etv.ExportTemplateSectionName, isnull(etv.ExportColumnName,etv.[ExportColumnName.mr]) as ExportColumnName
		, 'union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], '+convert(varchar,qm.qstncore)+' as qstncore, ['+etv.ExportTemplateSectionName+'.'+isnull(etv.ExportColumnName,etv.[ExportColumnName.mr])+'] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID' as snippet
	from qualisys.qp_prod.dbo.surveytypequestionmappings qm
	inner join cem.ExportTemplate_view etv on exporttemplateid=11 and convert(varchar,qm.qstncore)=right(sourcecolumnname,5)
	where qm.surveytype_id=11
	and qm.qstncore in (51574,51575,51576,51577,51579,51580,51581,51582,51583,51584,51585,51586,51588,51590,51594,51597,51599,51601,51603,51604,51605,51608,51609,51610,51611,51612,51613,51614,51615,51616,51617,51618,51619,51620)
	and isnull(etv.[ExportColumnName.mr],'') <> 'unmarked'
	*/

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.completeness checks'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')
		, 'survey-status='+isnull(convert(varchar,[decedentleveldata.survey-status]),'null')+';'+convert(varchar, convert(int,PctAnswered*100))+'% complete'
	from (
	select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], PctAnswered
		, case [decedentleveldata.survey-status]
			when ' 1' then case when PctAnswered >= 0.50 then 'ok' else 'Complete disposition should have 50%+ ATA questions answered' end
			when ' 7' then case when PctAnswered <  0.50 then 'ok' else 'Partial (break-off) disposition should have 1-49.0% ATA questions answered' end
			else '?'
		  end as CompletionStatus
	from (select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 1.0*sum(case when response like '%m%' then 0 else 1 end)/count(distinct qstncore) as PctAnswered
		from (select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51574 as qstncore, [caregiverresponse.related]  as response from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51575 as qstncore, [caregiverresponse.location-assisted]+[caregiverresponse.location-home]+[caregiverresponse.location-hospice-facility]+[caregiverresponse.location-hospital]+[caregiverresponse.location-nursinghome]+[caregiverresponse.location-other] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51576 as qstncore, [caregiverresponse.oversee] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51577 as qstncore, [caregiverresponse.needhelp] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51579 as qstncore, [caregiverresponse.h_informtime] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51580 as qstncore, [caregiverresponse.helpasan] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51581 as qstncore, [caregiverresponse.h_explain] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51582 as qstncore, [caregiverresponse.h_inform] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51583 as qstncore, [caregiverresponse.h_confuse] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51584 as qstncore, [caregiverresponse.h_dignity] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51585 as qstncore, [caregiverresponse.h_cared] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51586 as qstncore, [caregiverresponse.h_talk] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51588 as qstncore, [caregiverresponse.pain] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51590 as qstncore, [caregiverresponse.painrx] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51594 as qstncore, [caregiverresponse.breath] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51597 as qstncore, [caregiverresponse.constip] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51599 as qstncore, [caregiverresponse.sad] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51601 as qstncore, [caregiverresponse.restless] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51603 as qstncore, [caregiverresponse.movetrain] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51604 as qstncore, [caregiverresponse.expectinfo] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51605 as qstncore, [caregiverresponse.receivednh] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51608 as qstncore, [caregiverresponse.h_clisten] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51609 as qstncore, [caregiverresponse.cbeliefrespect] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51610 as qstncore, [caregiverresponse.cemotion] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51611 as qstncore, [caregiverresponse.cemotionafter] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51612 as qstncore, [caregiverresponse.ratehospice] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51613 as qstncore, [caregiverresponse.h_recommend] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51614 as qstncore, [caregiverresponse.pEdu] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51615 as qstncore, [caregiverresponse.pLatino] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51616 as qstncore, [caregiverresponse.race-african-amer]+[caregiverresponse.race-amer-indian-ak]+[caregiverresponse.race-asian]+[caregiverresponse.race-hi-pacific-islander] +[caregiverresponse.race-white] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51617 as qstncore, [caregiverresponse.cAge] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51618 as qstncore, [caregiverresponse.cSex] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID
			union select SamplePopulationID, ExportQueueID, [decedentleveldata.survey-status], 51619 as qstncore, [caregiverresponse.cEdu] from cem.ExportDataset00000011 where ExportQueueID=@ExportQueueID) x
		group by SamplePopulationID,ExportQueueID,[decedentleveldata.survey-status]) y
	where [decedentleveldata.survey-status] in (' 1', ' 7')) z
	where z.CompletionStatus <> 'ok'


	--• Survey-mode is null or blank 
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.survey-mode is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'survey-mode='+isnull(convert(varchar,[hospicedata.survey-mode]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.survey-mode] = '' or [hospicedata.survey-mode] is null)

	--•	The number of attempts should be included for dispositions 1, 6 and 7 for appropriate mail modes (Dave/James)
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.MixedAttempts'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')+'survey-status='+isnull(convert(varchar,[decedentleveldata.survey-status]),'null')
		, 'survey-mode='+isnull(convert(varchar,[hospicedata.survey-mode]),'null')
			+ ';number-survey-attempts-mail='+isnull(convert(varchar,[decedentleveldata.number-survey-attempts-mail]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and [decedentleveldata.survey-status] in (1,6,7)
	and [hospicedata.survey-mode]='1' -- mail only

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.MixedAttempts'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')+'survey-status='+isnull(convert(varchar,[decedentleveldata.survey-status]),'null')
		, 'survey-mode='+isnull(convert(varchar,[hospicedata.survey-mode]),'null')
			+ ';number-survey-attempts-telephone='+isnull(convert(varchar,[decedentleveldata.number-survey-attempts-telephone]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and [decedentleveldata.survey-status] in (1,6,7)
	and [hospicedata.survey-mode]='2' -- telephone only

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.MixedAttempts'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')+'survey-status='+isnull(convert(varchar,[decedentleveldata.survey-status]),'null')
		, 'survey-mode='+isnull(convert(varchar,[hospicedata.survey-mode]),'null')
			+ ';survey-completion-mode='+isnull(convert(varchar,[decedentleveldata.survey-completion-mode]),'null')
			+ ';number-survey-attempts-mail='+isnull(convert(varchar,[decedentleveldata.number-survey-attempts-mail]),'null')
			+ ';number-survey-attempts-telephone='+isnull(convert(varchar,[decedentleveldata.number-survey-attempts-telephone]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and [decedentleveldata.survey-status] in (1,6,7)
	and [hospicedata.survey-mode]='3' -- mixed mode

	--•	NULL or blank ineligible-pre-sample fields
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.ineligible-presample is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'ineligible-presample='+isnull(convert(varchar,[hospicedata.ineligible-presample]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.ineligible-presample] = '' or [hospicedata.ineligible-presample] is null)



	--•	NULL or blank sample-type fields
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.sample-type is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'sample-type='+isnull(convert(varchar,[hospicedata.sample-type]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.sample-type] = '' or [hospicedata.sample-type] is null)


	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.ineligible-postsample is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'ineligible-postsample='+isnull(convert(varchar,[hospicedata.ineligible-postsample]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.ineligible-postsample] = '' or [hospicedata.ineligible-postsample] is null)

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.total-decedents is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'total-decedents='+isnull(convert(varchar,[hospicedata.total-decedents]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.total-decedents] = '' or [hospicedata.total-decedents] is null)

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.live-discharges is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'live-discharges='+isnull(convert(varchar,[hospicedata.live-discharges]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.live-discharges] = '' or [hospicedata.live-discharges] is null)

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.number-offices is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'number-offices='+isnull(convert(varchar,[hospicedata.number-offices]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.number-offices] = '' or [hospicedata.number-offices] is null)

	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, 'Hospice.missing-dod is null'
		, 'CEM.HospiceChecks'
		, 'reference-yr='+isnull(convert(varchar,[hospicedata.reference-yr]),'null')+';reference-month='+isnull(convert(varchar,[hospicedata.reference-month]),'null')+';provider-name='+isnull(convert(varchar,[hospicedata.provider-name]),'null')+';provider-id='+isnull(convert(varchar,[hospicedata.provider-id]),'null')
		, 'missing-dod='+isnull(convert(varchar,[hospicedata.missing-dod]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([hospicedata.missing-dod] = '' or [hospicedata.missing-dod] is null)


	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, 'Hospice.diagnosis-code-format is null'
		, 'CEM.HospiceChecks'
		, 'SamplePopulationID='+isnull(convert(varchar,SamplePopulationID),'null')+';decedent-id='+isnull(convert(varchar,[decedentleveldata.decedent-id]),'null')
		, 'diagnosis-code-format='+isnull(convert(varchar,[decedentleveldata.diagnosis-code-format]),'null')
	from cem.ExportDataset00000011 
	where ExportQueueID=@ExportQueueID
	and ([decedentleveldata.diagnosis-code-format] = '' or [decedentleveldata.diagnosis-code-format] is null)

	set @sql = ''
	select @sql=@sql + '
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, ''Hospice.'+ExportColumnName+' is OOR''
		, ''CEM.HospiceChecks''
		, ''reference-yr=''+isnull(convert(varchar,[hospicedata.reference-yr]),''null'')+'';reference-month=''+isnull(convert(varchar,[hospicedata.reference-month]),''null'')+'';provider-name=''+isnull(convert(varchar,[hospicedata.provider-name]),''null'')+'';provider-id=''+isnull(convert(varchar,[hospicedata.provider-id]),''null'')
		, '''+ExportColumnName+'=out-of-range''
	from cem.ExportDataset00000011 
	where ExportQueueID='+convert(varchar,@ExportQueueID)+'
	and [hospicedata.'+ExportColumnName+']=char(7)
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select distinct getdate()
		, ExportQueueID
		, ''Hospice.'+ExportColumnName+' is inconsistent''
		, ''CEM.HospiceChecks''
		, ''reference-yr=''+isnull(convert(varchar,[hospicedata.reference-yr]),''null'')+'';reference-month=''+isnull(convert(varchar,[hospicedata.reference-month]),''null'')+'';provider-id=''+isnull(convert(varchar,[hospicedata.provider-id]),''null'')
		, '''+ExportColumnName+' has ''+convert(varchar,freq)+'' values, such as "''+minVal+''" and "''+maxVal+''"''
	from (select ExportQueueID,[hospicedata.reference-yr],[hospicedata.reference-month],[hospicedata.provider-id], count(distinct [hospicedata.'+ExportColumnName+']) as freq, min([hospicedata.'+ExportColumnName+']) as minVal, max([hospicedata.'+ExportColumnName+']) as maxVal
		from cem.ExportDataset00000011 
		where ExportQueueID='+convert(varchar,@ExportQueueID)+'
		group by ExportQueueID,[hospicedata.reference-yr],[hospicedata.reference-month],[hospicedata.provider-id]
		having count(distinct [hospicedata.'+ExportColumnName+'])>1) x'
	from (select ExportColumnName,min(ColumnOrder) as ColumnOrder from cem.ExportTemplate_view where exporttemplateid=11 and ExportTemplateSectionName = 'hospicedata' group by ExportColumnName) x
	order by columnOrder

	print @sql
	print substring(@sql,8001,8000)
	print substring(@sql,16001,8000)
	exec (@SQL)

	set @sql=''
	select @sql=@sql + '
	insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
	select getdate()
		, ExportQueueID
		, ''Hospice.'+ExportColumnName+' is OOR''
		, ''CEM.HospiceChecks''
		, ''SamplePopulationID=''+convert(varchar,SamplePopulationID)+'';decedent-id=''+isnull(convert(varchar,['+ExportTemplateSectionName+'.decedent-id]),''null'')
		, '''+ExportColumnName+'=out-of-range''
	from cem.ExportDataset00000011 
	where ExportQueueID='+convert(varchar,@ExportQueueID)+'
	and ['+ExportTemplateSectionName+'.'+ExportColumnName+']=char(7)'
	from (select distinct ExportTemplateSectionID,ColumnOrder,ExportTemplateSectionName, isnull(ExportColumnName,[ExportColumnName.MR]) as ExportColumnName 
			from cem.ExportTemplate_view 
			where exporttemplateid=11 
			and ExportTemplateSectionName in ('decedentleveldata','caregiverresponse')
			and [ExportColumnName.MR]<>'unmarked') x
	order by ExportTemplateSectionID,ColumnOrder

	exec (@SQL)

	update #queues set flag=1 where exportqueueid = @exportqueueid 
	select top 1 @exportqueueid = exportqueueid from #queues where flag=0

end

insert into #ErrorLog (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
select getdate(), q.ExportQueueID, 'Hospice.everything looks good', 'CEM.HospiceChecks', '', ''
from #queues q
left join #errorlog el on q.ExportQueueID=el.ExportQueueID
where el.ExportQueueID is null

insert into [cem].[ErrorLog] (ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription)
select ErrorDateTime, ExportQueueID, ErrorType, ErrorSource, ErrorIdentity, ErrorDescription
from #errorlog
order by ErrorLogId 

-- declare @sql varchar(max)
set @sql = 'ExportQueueID in ('
select @sql = @sql + convert(varchar,ExportQueueID)+','
from (select distinct ExportQueueID
	from #errorlog 
	where errortype = 'Hospice.everything looks good') x
set @sql = left(@sql,len(@sql)-1) + ')'

if @SQL <> 'ExportQueueID in )'
	exec msdb.dbo.sp_send_dbmail @body=@sql, @subject='hospice cahps submission problems', @recipients='dgilsdorf@nationalresearch.com'

drop table #queues
drop table #errorlog

go