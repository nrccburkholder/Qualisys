/*
S35_US20 CAHPS Hospice template changes.sql

user story 20:
As a Hospice CAHPS Vendor, we need to correctly report the sample type, so we submit accurate data & comply w/ an on-site visit item 
See HSP_Visit_2015_FUp_CCN_051508_SampleType.docx 
Notes: 3 possible sample methods (target/out-go/census). We pulled in the NRC value of 2 and reported census it appears. At 700 decedents/year 
then the method changes from census to random At CCN level, we need to check if numbered sampled is =< for specified outgo for all 3 months, 
if so we census sampled. OR Should implementation use the correct code when they set it up?

Task 3 - Change post-processing to use the new element


User story 18: 
18 Hospice CAHPS: As a Hospice CAHPS Vendor, we need to report ineligible presample at the CCN level, so we submit accurate data & comply w/ an on-site 
visit item Currently reporting from root sampleunit for survey. 

Task 2: Update CEM to calculate the correct numbers - sample unit facility attributes is where it's at in catalyst


user story 17:
Hospice CAHPS: As a Hospice CAHPS Vendor, we need to fix/refactor lag time calculations, so we submit accurate data & comply w/ an on-site visit item 
Notes: datExpire is one day later than it should be. Also lag times > 400 due to expiration date manual changes. NonDel Lag times need to use 
datLogged from dispo log. 

Task 2: Alter the CEM process that calculates lag time to use datFirst; the 42 days can be coded in, this value seems stable.
Task 3: Non-deliverables had high lag times; looking at wrong date in disposition logs. Needs to look at datLogged.



Dave Gilsdorf

NRC_DataMart_Extracts:
insert into cem.Datasource
update cem.exporttemplatecolumn 
update cem.ExportTemplateColumnResponse 

*/
use NRC_DataMart_Extracts
go

--select * from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportColumnName='sample-type'
--select * from cem.exporttemplatecolumn where AggregateFunction is not null
--select * from cem.exporttemplatecolumn where ExportTemplateColumnID=(select top 1 exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='sample-type')
--select * from cem.ExportTemplateColumnResponse where ExportTemplateColumnID=(select top 1 exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='sample-type')

--select * from cem.Datasource
--select * from nrc_datamart.dbo.SampleUnitFacilityAttributes
--select * from nrc_datamart.dbo.SampleUnitBySampleSet

if not exists (select * from cem.datasource where TableName='NRC_Datamart.dbo.SampleUnitBySampleSet')
	insert into cem.Datasource (HorizontalVertical, TableName, TableAlias, ForeignKeyField) 
	values ('H', 'NRC_Datamart.dbo.SampleUnitBySampleSet', 'suss', 'SampleUnitID,SampleSetID')

if not exists (select * from sys.columns where object_name(object_id)='Datasource' and name = 'Uniqueness')
begin
	alter table cem.Datasource add Uniqueness varchar(50)
	update cem.Datasource set Uniqueness = 'QuestionFormID' where tableAlias='qf'
	update cem.Datasource set Uniqueness = 'QuestionFormID,OriginalQuestionCore,ResponseValue' where tableAlias='rb'
	update cem.Datasource set Uniqueness = 'SamplepopulationID' where tableAlias='sp'
	update cem.Datasource set Uniqueness = 'SamplePopulationID,ColumnName' where tableAlias='bg'
	update cem.Datasource set Uniqueness = 'SamplesetID' where tableAlias='ss'
	update cem.Datasource set Uniqueness = 'SamplePopulationID,SampleUnitID' where tableAlias='sel'
	update cem.Datasource set Uniqueness = 'SampleUnitID' where tableAlias='su'
	update cem.Datasource set Uniqueness = 'SurveyID' where tableAlias='sv'
	update cem.Datasource set Uniqueness = 'SampleUnitID' where tableAlias='sufa'
	update cem.Datasource set Uniqueness = 'SampleUnitID,SampleSetID' where tableAlias='suss'
end

declare @dataSourceID int, @oldTemplateID int, @newTemplateID int
select @dataSourceID=datasourceID from cem.datasource where TableName='NRC_Datamart.dbo.SampleUnitBySampleSet'

select @oldTemplateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=1

if not exists (select * from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)
begin
	exec [CEM].[CopyExportTemplate] @oldTemplateID
	select @newTemplateID = max(exporttemplateid) from cem.exporttemplate 
	update cem.ExportTemplate set ExportTemplateVersionMinor=2 where ExportTemplateID=@newTemplateID
/* 
y'know .... i don't think we need to do this in post-processing. I think we can take care of it via ExportTemplateColumn.AggregateFunction

	declare @sql nvarchar(max)
	select @sql=definition
	from sys.sql_modules
	where object_name(object_id)='ExportPostProcess'+right(convert(varchar,@newtemplateID+100000000),8)
	print @sql
	set @sql = replace(@sql,'-- recode various blank columns to ''M'' or ''N/A''','-- ineligible-presample & sample-type:
-- sample-type: 1=Simple Random Sample, 2=Census Sample
update eds
set [hospicedata.ineligible-presample]=sub.IneligibleCount, [hospicedata.sample-type]= case sub.isCensus when 0 then 1 when 1 then 2 end
from cem.ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+' eds
inner join (select r.[hospicedata.reference-month],r.[hospicedata.provider-id], sum(suss.IneligibleCount) as IneligibleCount, min(suss.isCensus) as isCensus
		from cem.ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+' r
		inner join nrc_datamart.dbo.SampleUnitFacilityAttributes sufa on r.[hospicedata.provider-id]=sufa.MedicareNumber
		inner join NRC_Datamart.dbo.SamplePopulation sp on r.SamplepopulationID=sp.SamplepopulationID
		inner join NRC_Datamart.dbo.SampleSet ss on sp.SampleSetID=ss.SampleSetID
		inner join NRC_Datamart.dbo.SelectedSample sel on sp.SamplePopulationID=sel.SamplePopulationID and sel.sampleunitid=sufa.sampleunitid
		inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
		inner join NRC_Datamart.dbo.SampleUnitBySampleSet suss on sel.sampleunitid=suss.sampleunitid and ss.SampleSetID=suss.SampleSetID
		where su.isCahps=1
		group by r.[hospicedata.reference-month],r.[hospicedata.provider-id] ) sub
	on eds.[hospicedata.reference-month]=sub.[hospicedata.reference-month] and eds.[hospicedata.provider-id]=sub.[hospicedata.provider-id]
where eds.ExportQueueID = @ExportQueueID 

-- recode various blank columns to ''M'' or ''N/A''')
	
	if exists(select * from sys.procedures where name = 'ExportPostProcess'+right(convert(varchar,@newTemplateID+100000000),8))
		set @SQL = replace(@SQL,'CREATE PROCEDURE [CEM].[','ALTER PROCEDURE [CEM].[')

	EXECUTE dbo.sp_executesql @SQL
*/
	-- user story 17: change lag-time calculation in the post-processing procedure.
	declare @sql nvarchar(max), @oldcode nvarchar(max), @newcode nvarchar(max)
	select @sql=definition
	from sys.sql_modules
	where object_name(object_id)='ExportPostProcess'+right(convert(varchar,@newtemplateID+100000000),8)
	
	set @oldcode='select distinct ss.samplesetid, eds.samplepopulationid, qf.DatExpire
into #SampleSetExpiration
from CEM.ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+' eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where eds.ExportQueueID = @ExportQueueID 
order by 2'

	set @newcode='select distinct ss.samplesetid, eds.samplepopulationid, dateadd(day,42,ss.datFirstMailed) as DatExpire
into #SampleSetExpiration
from CEM.ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+' eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
where eds.ExportQueueID = @ExportQueueID 
order by 2'

	if charindex(@oldcode,@sql)=0
		select 1 from [Can't find @oldcode (1)]
	else
		set @sql = replace(@sql,@oldcode,@newcode)

	set @oldcode='update sse
set datExpire=sub.datExpire
from #SampleSetExpiration sse
inner join (select samplesetid,max(datexpire) as datExpire
			from #SampleSetExpiration
			where datExpire is not null
			group by samplesetid) sub
	on sse.samplesetid=sub.samplesetid
where sse.datExpire is null'

	set @newcode='if exists (select * from #SampleSetExpiration where datExpire is null)
	update sse
	set datExpire=dateadd(day,42,sub.datFirstMailed) 
	from #SampleSetExpiration sse
	inner join (select sse.samplesetid, min(sm.datMailed) as datFirstMailed
				from #SampleSetExpiration sse
				inner join nrc_datamart.etl.datasourcekey dsk on sse.SampleSetID=dsk.DataSourceKeyID
				inner join qualisys.qp_prod.dbo.samplepop sp on dsk.DataSourceKey=sp.sampleset_id
				inner join qualisys.qp_prod.dbo.scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
				inner join qualisys.qp_prod.dbo.sentmailing sm on scm.sentmail_id=sm.sentmail_id
				group by sse.samplesetid) sub
		on sse.samplesetid=sub.samplesetid
	where sse.datExpire is null'

	if charindex(@oldcode,@sql)=0
		select 1 from [Can't find @oldcode (2)]
	else
		set @sql = replace(@sql,@oldcode,@newcode)

	set @oldcode='spdl.CreateDate'
	set @newcode='spdl.LoggedDate'

	if charindex(@oldcode,@sql)=0
		select 1 from [Can't find @oldcode (3)]
	else
		set @sql = replace(@sql,@oldcode,@newcode)

	set @oldcode='-- recode blank NPI''s to ''M'''
	set @newcode='-- add zero-sample CCN''s to the dataset. 
-- for now, any CCN that''s in (select from SampleUnitFacilityAttributes where AHAIdent=1) is one we should be submitting for.
-- AHAIdent is manually populated.

if object_id(''tempdb..#months'') is not null
	drop table #months
if object_id(''tempdb..#CCN'') is not null
	drop table #CCN
if object_id(''tempdb..#everything'') is not null
	drop table #everything

select distinct eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]
into #months
from [CEM].[ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+'] eds
where eds.exportqueueid=@ExportQueueID

select distinct MedicareNumber, FacilityName, convert(char(10), NULL) as NPI
into #CCN
from nrc_datamart.dbo.SampleUnitFacilityAttributes 
where AHAIdent=1

update #ccn set NPI=''M''

update ccn
set npi=[hospicedata.npi]
from #ccn ccn
inner join [CEM].[ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+'] eds on ccn.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueid=@ExportQueueID

select *
into #everything
from #months m, #ccn c

delete e
from #everything e
inner join [CEM].[ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+'] eds 
	on e.[hospicedata.reference-yr]=eds.[hospicedata.reference-yr]
		and e.[hospicedata.reference-month]=eds.[hospicedata.reference-month]
		and e.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueID=@ExportQueueID

insert into [CEM].[ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+'] ([ExportQueueID], [ExportTemplateID], [FileMakerName], [vendordata.vendor-name], [vendordata.file-submission-yr], [vendordata.file-submission-month], [vendordata.file-submission-day]
	, [vendordata.file-submission-number], [hospicedata.reference-yr], [hospicedata.reference-month], [hospicedata.provider-name], [hospicedata.provider-id], [hospicedata.npi], [hospicedata.survey-mode], [hospicedata.total-decedents]
	, [hospicedata.live-discharges], [hospicedata.no-publicity], [hospicedata.ineligible-presample], [hospicedata.sample-size], [hospicedata.ineligible-postsample], [hospicedata.sample-type])
select distinct eds.[ExportQueueID], eds.[ExportTemplateID], eds.[FileMakerName], eds.[vendordata.vendor-name], eds.[vendordata.file-submission-yr], eds.[vendordata.file-submission-month], eds.[vendordata.file-submission-day]
	, eds.[vendordata.file-submission-number], e.[hospicedata.reference-yr], e.[hospicedata.reference-month], left(e.FacilityName,100), e.MedicareNumber, e.NPI, ''8'' as [hospicedata.survey-mode], char(7) as [hospicedata.total-decedents]
	, char(7) as [hospicedata.live-discharges], char(7) as [hospicedata.no-publicity], char(7) as [hospicedata.ineligible-presample], ''0'' as [hospicedata.sample-size], ''0'' as [hospicedata.ineligible-postsample], ''8'' as [hospicedata.sample-type]
from [CEM].[ExportDataset'+right(convert(varchar,@newtemplateID+100000000),8)+'] eds, #everything e
where eds.ExportQueueID=@ExportQueueID

-- recode blank NPI''s to ''M'''

	if charindex(@oldcode,@sql)=0
		select 1 from [Can't find @oldcode (4)]
	else
		set @sql = replace(@sql,@oldcode,@newcode)

	-- phone-only methodologies that didn't have any response should use the date of the last phone call for lag-time calculation. 
	-- we were using sampleset.datLastMailed for some reason.
	set @oldcode='update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+''/''+[decedentleveldata.death-day]+''/''+[decedentleveldata.death-yr]),qss.datLastMailed)
--select eds.samplepopulationid, [hospicedata.provider-id] ccn, [hospicedata.survey-mode], convert(datetime,[decedentleveldata.death-month]+''/''+[decedentleveldata.death-day]+''/''+[decedentleveldata.death-yr]) DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then ''Expiration Date (Mail & Mixed) OR Date of last phone attempt (Phone)''
--	   end
--, ss.samplesetID, dsk.DataSourceKey as sampleset_id, qss.datLastMailed
from CEM.ExportDataset00000003 eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID and dsk.EntityTypeID=8
inner join Qualisys.qp_prod.dbo.sampleset qss on dsk.DataSourceKey = qss.sampleset_id
where ltrim([decedentleveldata.survey-status]) in (''9'')
and isnull([decedentleveldata.lag-time],'''') =''''
and qss.datLastMailed is not null
and eds.ExportQueueID = @ExportQueueID'

	set @newcode='update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+''/''+[decedentleveldata.death-day]+''/''+[decedentleveldata.death-yr]),phones.lastPhoneCall)
--select eds.samplepopulationid, [hospicedata.provider-id] ccn, [hospicedata.survey-mode], convert(datetime,[decedentleveldata.death-month]+''/''+[decedentleveldata.death-day]+''/''+[decedentleveldata.death-yr]) DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then ''Expiration Date (Mail & Mixed) OR Date of last phone attempt (Phone)''
--	   end
--, phones.lastPhoneCall
from CEM.ExportDataset00000007 eds
inner join (select eds.samplepopulationid, max(d.DispositionDate) as lastPhoneCall
			from CEM.ExportDataset00000007 eds
			inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
			inner join NRC_DataMart.etl.DataSourceKey dsk on sp.SamplePopulationID=dsk.DataSourceKeyID
			inner join Qualisys.qp_prod.dbo.scheduledmailing scm on dsk.DataSourceKey = scm.samplepop_id
			inner join Qualisys.qp_prod.dbo.sentmailing sm on scm.sentmail_id=sm.sentmail_id
			inner join Qualisys.qp_prod.dbo.dl_lithocodes lc on sm.strlithocode=lc.strlithocode
			inner join Qualisys.qp_prod.dbo.dl_dispositions d on lc.DL_LithoCode_ID=d.DL_LithoCode_ID
			where ltrim([decedentleveldata.survey-status]) in (''9'')
			and isnull([decedentleveldata.lag-time],'''') =''''
			and eds.ExportQueueID = @ExportQueueID
			and d.isFinal=1
			group by eds.samplepopulationid) phones
		on eds.SamplePopulationID=phones.SamplePopulationID
where eds.ExportQueueID = @ExportQueueID'

	if charindex(@oldcode,@sql)=0
		select 1 from [Can't find @oldcode (5)]
	else
		set @sql = replace(@sql,@oldcode,@newcode)

	if exists(select * from sys.procedures where name = 'ExportPostProcess'+right(convert(varchar,@newTemplateID+100000000),8))
		set @SQL = replace(@SQL,'CREATE PROCEDURE','ALTER PROCEDURE')

	EXECUTE dbo.sp_executesql @SQL
	
end

-- email from James (10/14/2015):
--There were two CCNs in Q2 2015 that had “zero sampled” months:
--	•	GentlePro Hospice Services, CCN 141613
--		o	Zero sampled all 3 months of data in Q2 2015
--	•	Catholic Community Hospice, CCN 261644
--		o	Zero sampled in April and May
update sufa
set AHAIdent=1
from nrc_datamart.dbo.SampleUnitFacilityAttributes sufa
where MedicareNumber in ('141613','261644')


-- user story 20: use SampleUnitBySampleSet.isCensus for calculation of [sample-type]
update etc
set DatasourceID=@datasourceid, SourceColumnName='isCensus', AggregateFunction='min [hospicedata.reference-month],[hospicedata.provider-id]'  --> min=0 => isCensus=false, min=1 => isCensus=true
from cem.exporttemplatecolumn etc
where etc.ExportTemplateColumnID=(select top 1 exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateID=@newTemplateID and ExportColumnName='sample-type')
and DatasourceID<>@datasourceid

update etcr
set rawValue=0
from cem.ExportTemplateColumnResponse etcr
where ExportTemplateColumnID=(select top 1 exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateID=@newTemplateID and ExportColumnName='sample-type')
and ResponseLabel='Simple Random Sample'
and RawValue <> 0

update etcr
set rawValue=1
from cem.ExportTemplateColumnResponse etcr
where ExportTemplateColumnID=(select top 1 exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateID=@newTemplateID and ExportColumnName='sample-type')
and ResponseLabel='Census Sample'
and RawValue <> 1

-- User story 18: use SampleUnitBySampleSet.IneligibleCount for calculation of [ineligible-presample]
update etc
set datasourceid=@datasourceid, SourceColumnName='IneligibleCount', AggregateFunction='sum [hospicedata.reference-month],[hospicedata.provider-id]'
from cem.exporttemplatecolumn etc
where ExportTemplateColumnID=(select top 1 exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateID=@newTemplateID and ExportColumnName='ineligible-presample')
--select * from sys.procedures where schema_id=8
--sp_Helptext [cem.PullExportData]
--sp_Helptext [CEM.CopyExportTemplate]

go
ALTER PROCEDURE [CEM].[PullExportData]
@ExportQueueID int, @doRecode bit=1, @doDispositionProc bit=1, @doPostProcess bit=1
as
begin 

-- */ declare @ExportQueueID int = 55,  @doRecode bit=1, @doDispositionProc bit=1, @doPostProcess bit=1

declare @ExportTemplateName varchar(200), @ExportTemplateVersionMajor varchar(200), @ExportTemplateVersionMinor int
declare @ExportTemplateID int, @ExportDateColumnID int, @ExportStart datetime, @exportEnd datetime, @returnsonly bit, @CahpsUnitOnly bit
declare @DateDataSourceID int, @DateFieldName varchar(200), @DateColumnName varchar(200), @surveylist varchar(max)

select @ExportTemplateName=ExportTemplateName, @ExportTemplateVersionMajor=ExportTemplateVersionMajor, @ExportTemplateVersionMinor=ExportTemplateVersionMinor, 
	@exportStart=exportdatestart, @exportEnd=exportdateend, @returnsonly=returnsonly
from CEM.exportqueue eq
where eq.exportqueueid=@ExportQueueID

set @surveylist=''
select @surveylist=@surveylist+convert(varchar,eqs.SurveyID)+','
from CEM.exportqueue eq
inner join CEM.exportqueuesurvey eqs on eq.exportqueueid=eqs.exportqueueid
where eq.exportqueueid=@ExportQueueID

set @surveylist=left(@surveylist,len(@surveylist)-1)

if @ExportTemplateVersionMinor is null
	select @ExportTemplateVersionMinor = max(ExportTemplateVersionMinor)
	from cem.ExportTemplate et
	where ExportTemplateName=@ExportTemplateName 
	and ExportTemplateVersionMajor=@ExportTemplateVersionMajor 

select @ExportTemplateID=ExportTemplateID, @ExportDateColumnID=ValidDateColumnID
from cem.ExportTemplate et
where ExportTemplateName=@ExportTemplateName 
and ExportTemplateVersionMajor=@ExportTemplateVersionMajor 
and ExportTemplateVersionMinor=@ExportTemplateVersionMinor

if @ExportTemplateID is null 
begin
	print 'ERROR! Cannot identify the proper template'
	insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
	select getdate() as EventDateTime
		, 'Error' as EventLevel
		, system_user as UserName
		, host_name() as MachineName
		, '' as EventType
		, 'Cannot identify the proper template.' as EventMessage
		, '[CEM].[PullExportData] @ExportQueueID=' + convert(varchar,@ExportQueueID) as EventSource
		, 'Stored Procedure' as EventClass
		, '' as EventMethod
		, 'ExportTemplateName: '+@ExportTemplateName
			+', ExportTemplateVersionMajor: '+@ExportTemplateVersionMajor
			+', ExportTemplateVersionMinor: '+isnull(@ExportTemplateVersionMajor,'NULL') as ErrorMessage
	return --1
end

select distinct @CahpsUnitOnly=case when isnull(et.sampleunitcahpstypeid,0)=0 then 0 else 1 end
	, @DateDataSourceID=etc.DataSourceID
	, @DateFieldName=etc.ExportColumnName
	, @DateColumnName=etc.SourceColumnName
from CEM.exporttemplate et
inner join CEM.exporttemplatesection ets on et.exporttemplateid=ets.exporttemplateid
inner join CEM.exporttemplatecolumn etc on ets.exporttemplatesectionid=etc.exporttemplatesectionid
where etc.ExportTemplateColumnID=@ExportDateColumnID


declare @sql varchar(max)

if object_id('tempdb..#allcolumns') is not null
	drop table #allcolumns

select distinct ets.ExportTemplateSectionID, ets.ExportTemplateSectionName, etc.ExportTemplateColumnID, etc.DispositionProcessID, 
	ds.DataSourceID, ds.TableName, ds.horizontalvertical, ds.TableAlias, etc.ExportTemplateColumnDescription,
	etc.ColumnOrder,etc.ExportColumnName, etc.FixedWidthLength, etc.AggregateFunction, etc.SourceColumnName, etc.SourceColumnType, 
	etcr.RawValue, etcr.ExportColumnName as ExportColumnNameMR, etcr.RecodeValue, 0 as flag
into #allColumns
from CEM.exporttemplate et
inner join CEM.exporttemplatesection ets on et.exporttemplateid=ets.exporttemplateid
inner join CEM.exporttemplatecolumn etc on ets.exporttemplatesectionid=etc.exporttemplatesectionid
inner join CEM.datasource ds on etc.DataSourceID=ds.DataSourceID
left join CEM.exporttemplatecolumnresponse etcr on etc.ExportTemplateColumnID=etcr.ExportTemplateColumnID
where et.ExportTemplateID=@ExportTemplateID
order by ets.ExportTemplateSectionID,etc.ColumnOrder

if exists (	select ExportTemplateColumnID, 1.0*min(FixedWidthLength)/count(*) , round(1.0*min(FixedWidthLength)/count(*),0)
			from #allcolumns
			where ExportColumnNameMR is not null
			and RawValue <> -9
			group by ExportTemplateColumnID
			having 1.0*min(FixedWidthLength)/count(*) <> round(1.0*min(FixedWidthLength)/count(*),0)
			or 1.0*min(FixedWidthLength)/count(*) < max(len(recodevalue)))
begin
	print 'ERROR! The width of one or more of the multiple response questions is too short or isn''t evenly divisible by the number of responses. Aborting.'
	set @sql=''
	select @SQL = @SQL + msg + ', '
	from (	select min(ExportTemplateColumnDescription)+ ' has ' + convert(varchar,count(*)) + ' responses but has a width of '+convert(varchar, min(FixedWidthLength)) as msg
			from #allcolumns
			where ExportColumnNameMR is not null
			and RawValue <> -9
			group by ExportTemplateColumnID
			having 1.0*min(FixedWidthLength)/count(*) <> round(1.0*min(FixedWidthLength)/count(*),0)
			or 1.0*min(FixedWidthLength)/count(*) < max(len(recodevalue))) x

	insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
	select getdate() as EventDateTime
		, 'Error' as EventLevel
		, system_user as UserName
		, host_name() as MachineName
		, '' as EventType
		, 'Multiple-response question(s) aren''t using the proper FixedWidthLength.' as EventMessage
		, '[CEM].[PullExportData] @ExportQueueID=' + convert(varchar,@ExportQueueID) as EventSource
		, 'Stored Procedure' as EventClass
		, '' as EventMethod
		, @sql as ErrorMessage			
	return --1
end

update #allcolumns set FixedWidthLength=len(RecodeValue)
where ExportColumnNameMR is not null


if object_id('tempdb..#results') is null
	create table #results (ResultsID int identity(1,1), ExportQueueID int, ExportTemplateID int, SamplePopulationID int, QuestionFormID int, FileMakerName varchar(200))
else
begin
	-- if #results pre-exists (possible outside the scope of this proc) reset it to just be an empty table with the original 5 columns
	if exists (select * from #results)
		truncate table #results
end

declare @objid int
set @objid=object_id('tempdb..#results') 
set @sql = 'alter table #results add '

select @sql=@sql + '[' + ExportTemplateSectionName + '.' + isnull(ExportColumnName,ExportColumnNameMR) + '] varchar('+convert(varchar,
				case 
				when rawwidth >= recodewidth and rawwidth >= defaultwidth then rawwidth 
				when recodewidth >= rawwidth and recodewidth >= defaultwidth then recodewidth
				when defaultwidth >= rawwidth and defaultwidth >= recodewidth then defaultwidth
				else 255 
				end)+') default '''','
from (	select columnorder, ExportTemplateSectionID, ExportTemplateSectionName, ExportColumnName,ExportColumnNameMR, max(FixedWidthLength) as recodewidth, max(len(isnull(RawValue,0))) as rawwidth
		from #allcolumns
		where isnull(ExportColumnNameMR,'') <> 'unmarked'
		and ExportTemplateSectionName + '.' + isnull(ExportColumnName,ExportColumnNameMR) not in (select name from tempdb.sys.columns where object_id=@objid)
		group by columnorder, ExportTemplateSectionID, ExportTemplateSectionName, ExportColumnName,ExportColumnNameMR) c 
 , (select isnull(max(len(RawValue)),1) as defaultwidth from CEM.ExportTemplateDefaultResponse where ExportTemplateID=@ExportTemplateID) d
order by ExportTemplateSectionid, columnorder

if @@rowcount>0
begin
	set @SQL = left(@sql,len(@sql)-1)
	exec (@SQL)
end


if object_id('CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)) is null
begin
	set @SQL = 'create table CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' (ResultsID int identity(1,1), ExportQueueID int, ExportTemplateID int, SamplePopulationID int, QuestionFormID int)'
	exec (@SQL)

	set @sql = 'alter table CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' add FileMakerName varchar(200)'

	select @sql=@sql + ',
	[' + ExportTemplateSectionName + '.' + isnull(ExportColumnName,ExportColumnNameMR) + '] varchar('+convert(varchar,FixedWidthLength)+')'
	from (	select distinct columnorder, ExportTemplateSectionid, ExportTemplateSectionName, ExportColumnName,ExportColumnNameMR, FixedWidthLength
			from #allcolumns
			where isnull(ExportColumnNameMR,'') <> 'unmarked') c 
	order by ExportTemplateSectionid, columnorder

	exec (@SQL)
end
else
begin
	set @SQL = 'insert into #results (SamplePopulationID) 
		select distinct SamplePopulationID 
		from CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+'
		where ExportQueueID='+convert(varchar,@ExportQueueID)
	exec (@SQL)
	if exists (select * from #results)
	begin
		print 'It appears this ExportQueueID''s data has already been pulled. Aborting.'
		insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
		select getdate() as EventDateTime
			, 'Info' as EventLevel
			, system_user as UserName
			, host_name() as MachineName
			, '' as EventType
			, 'Data for ExportQueueID has already been pulled.' as EventMessage
			, '[CEM].[PullExportData] @ExportQueueID=' + convert(varchar,@ExportQueueID) as EventSource
			, 'Stored Procedure' as EventClass
			, '' as EventMethod
			, 'To re-pull, first: DELETE FROM CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' WHERE ExportQueueID=' + convert(varchar,@ExportQueueID) as ErrorMessage
		return --
	end
end

declare @sqlInsert varchar(max), @sqlSelect varchar(max), @sqlFrom varchar(max), @sqlWhere varchar(max)
set @sqlInsert='insert into #results (SamplePopulationID, QuestionFormID, ExportQueueID, ExportTemplateID' + char(10)
set @sqlSelect='select distinct sp.SamplePopulationID, qf.QuestionFormID, '+convert(varchar,@ExportQueueID)+' as ExportQueueID, '+convert(varchar,@ExportTemplateID)+' as ExportTemplateID' + char(10)
set @sqlFrom='from NRC_Datamart.dbo.samplepopulation sp 
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
inner join NRC_Datamart.dbo.SampleUnitBySampleset suss on su.sampleunitid=suss.sampleunitid and ss.samplesetid=suss.samplesetid
left join NRC_Datamart.dbo.SampleUnitFacilityAttributes sufa on sel.sampleunitid=sufa.sampleunitid
left join NRC_Datamart.dbo.questionform qf on sp.SamplePopulationID=qf.SamplePopulationID and qf.isActive=1' + char(10)

set @sqlWhere = 'where su.surveyid in ('+@surveylist+')' + char(10)

if @CahpsUnitOnly=1
	set @sqlWhere=@sqlWhere+'and su.isCahps = 1' + char(10)

if @ReturnsOnly=1
	set @sqlWhere = @sqlWhere + 'and qf.ReturnDate is not null' + char(10)


select @sqlSelect = @sqlSelect + ', isnull(' +
		case when SourceColumnType in (40,61) then 'convert(varchar,' else '' end + 
	case when charindex('[',SourceColumnName)>0 then replace(SourceColumnName,'[',TableAlias +'.[') else TableAlias + '.[' + SourceColumnName + ']' end +
		case when SourceColumnType in (40,61) then ',112)' else '' end + 
	','''') as ['+ExportTemplateSectionName+'.'+ExportColumnName+']' + char(10)
, @sqlInsert = @sqlInsert + ', ['+ExportTemplateSectionName+'.'+ExportColumnName+']' + char(10)
from (select distinct horizontalvertical,TableAlias,SourceColumnName,ExportTemplateSectionName,ExportColumnName,SourceColumnType,AggregateFunction from #allcolumns) ac
where horizontalvertical='H'
and AggregateFunction is null

update #allcolumns set flag=1
where horizontalvertical='H'
and AggregateFunction is null

if exists (select * from #allcolumns where flag=1 and ExportTemplateColumnID=@ExportDateColumnID)
	select @sqlWhere = @sqlWhere + 'and ' + ds.TableAlias+'.'+@DateColumnName + ' between '''+convert(varchar,@exportStart)+''' and '''+convert(varchar,@exportEnd)+'''' + char(10)
	from CEM.datasource ds
	where ds.DataSourceID=@DateDataSourceID
else
begin
	select @sqlFrom = @sqlFrom + 'inner join (select SamplePopulationID, convert(datetime,ColumnValue) as ['+ExportColumnName+'] '
		+ 'from NRC_Datamart.dbo.Samplepopulationbackgroundfield '
		+ 'where '+SourceColumnName+') datesub '
		+ 'on sp.SamplePopulationID=datesub.SamplePopulationID' + char(10)
	 , @sqlWhere = @sqlWhere + 'and datesub.['+ExportColumnName+'] between '''+convert(varchar,@exportStart)+''' and '''+convert(varchar,@exportEnd)+'''' + char(10)
	 , @sqlSelect = @sqlSelect + ', convert(varchar,['+ExportColumnName+'],112)' + char(10)
	 , @sqlinsert = @sqlinsert + ', ['+ExportTemplateSectionName+'.'+ExportColumnName+']' + char(10)
	from (select distinct ExportColumnName, SourceColumnName, ExportTemplateSectionName, ExportTemplateColumnID from #allcolumns) ac
	where ExportTemplateColumnID=@ExportDateColumnID
	update #allcolumns set flag=1 where ExportTemplateColumnID=@ExportDateColumnID	
end

set @SQL = @sqlinsert + ') '+@sqlSelect + @sqlFrom + @sqlWhere
print substring(@sql,1,8000)
if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
exec (@SQL)


set @SQL = ''
select @SQL = @SQL + cmd + char(10)
from (	select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnName+']=bg.columnValue
		from #results r
		inner join NRC_Datamart.dbo.samplepopulationbackgroundfield bg on r.SamplePopulationID=bg.SamplePopulationID
		where bg.'+SourceColumnName as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and SourceColumnName not like '%(%'
		and DataSourceID=4
		union
		select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnName+']='+left(SourceColumnName,charindex('(',SourceColumnName))+'bg.columnValue)
		from #results r
		inner join NRC_Datamart.dbo.samplepopulationbackgroundfield bg on r.SamplePopulationID=bg.SamplePopulationID
		where bg.'+substring(replace(SourceColumnName,')',''),1+charindex('(',sourcecolumnname),99) as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and SourceColumnName like '%(%'
		and DataSourceID=4) x
print substring(@sql,1,8000)
if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=4

set @SQL = ''
select @SQL = @SQL + cmd + char(10)
from (	select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnName+']=rb.ResponseValue
		from #results r
		inner join nrc_datamart.dbo.ResponseBubble rb on r.QuestionFormID=rb.QuestionFormID
		where rb.'+SourceColumnName as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=2
		and ExportColumnName is not null) x
print substring(@sql,1,8000)
if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=2 and ExportColumnName is not null


set @SQL = ''
select @SQL = @SQL + cmd + char(10)
from (	select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnNameMR+']='+convert(varchar,RecodeValue)+'
		from #results r
		inner join nrc_datamart.dbo.ResponseBubble rb on r.QuestionFormID=rb.QuestionFormID
		where rb.'+SourceColumnName+'
		and rb.ResponseValue='+convert(varchar,RawValue) as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=2
		and ExportColumnNameMR is not null
		and RawValue <> -9) x
print substring(@sql,1,8000)
if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=2 and ExportColumnNameMR is not null

-- update any columns that contain literal values 
-- declare @sql varchar(max), @sqlfrom varchar(max)
set @sql = 'update #results set '
select @sql = @sql + x
from (select distinct '['+exporttemplatesectionname+'.'+exportcolumnname+']='''+replace(sourcecolumnname,'''','''''')+''',' as x
		from #allColumns
		where DataSourceID=0) sub
if @@rowcount>0
begin
	set @sql = left(@sql,len(@sql)-1)

	print substring(@sql,1,8000)
	if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
	if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
	exec (@SQL)

	update #allcolumns set flag=1 where flag=0 and datasourceid=0
end

-- declare @sql varchar(max), @sqlfrom varchar(max)
declare @sectname varchar(200), @colname varchar(200)
select @sql = DefaultNamingConvention, @sqlfrom=''''+DefaultNamingConvention+''''
from cem.ExportTemplate 
where ExportTemplateID=@ExportTemplateID

while charindex('{',@SQL) > 0
begin
	--declare @SQL varchar(max)='{vendordata.vendor-name}.{vendordata.file-submission-day}{vendordata.file-submission-month}{vendordata.file-submission-yr}.{vendordata.file-submission-number}', @sqlfrom varchar(max), @colname varchar(200) set @sqlfrom=''''+@sql+''''
	set @colname = substring(@SQL, 1 + charindex('{', @SQL),  charindex('}', @SQL) - charindex('{', @SQL) - 1)
	set @sqlfrom = replace(@sqlfrom,@sqlfrom,'replace('+@sqlfrom+',''{'+@colname+'}'',['+@colname+'])')
	set @sql = replace(@sql,'{'+@colname+'}','')
end
set @sql = 'update #results set FileMakerName='+@sqlfrom
print substring(@sql,1,8000)
if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
exec (@sql)

set @sql = ''
declare @ExportColumnName varchar(255), @AggFunction varchar(255), @SourceColumnType int, @TableName varchar(255), @TableAlias varchar(20), @SourceColumnName varchar(255), @GroupBy varchar(255), @JoinOn varchar(max), @Uniqueness varchar(50)
while exists (select * from #allcolumns where flag=0 and ExportColumnName is not null and AggregateFunction is not null)
begin
	select top 1 @ExportcolumnName=ac.ExportTemplateSectionName+'.'+ac.ExportColumnName
	, @AggFunction = rtrim(ac.AggregateFunction)
	, @SourceColumnType=ac.SourceColumnType
	, @TableName=ac.TableName
	, @TableAlias=ac.TableAlias
	, @SourceColumnName=ac.SourceColumnName
	, @Uniqueness=ds.Uniqueness
	from #allcolumns ac
	inner join cem.Datasource ds on ac.DatasourceID=ds.DatasourceID
	where ac.flag=0 
	and ac.ExportColumnName is not null 
	and ac.AggregateFunction is not null

	set @JoinOn = replace(@TableName,'NRC_Datamart.dbo.','')+'id'

	if exists (select * from tempdb.sys.columns where object_id=object_id('tempdb..#results') and name = @JoinOn)
	begin
		set @JoinOn = 'inner join '+@TableName+' '+@TableAlias+' on r.'+@JoinOn+'='+@TableAlias+'.'+@JoinOn
	end
	else
	begin
		set @JoinOn='inner join NRC_Datamart.dbo.SamplePopulation sp on r.SamplepopulationID=sp.SamplepopulationID
		inner join NRC_Datamart.dbo.SampleSet ss on sp.SampleSetID=ss.SampleSetID
		inner join NRC_Datamart.dbo.SelectedSample sel on sp.SamplePopulationID=sel.SamplePopulationID
		inner join NRC_Datamart.dbo.SampleUnit su on sel.sampleunitid=su.sampleunitid ' + case when @CahpsUnitOnly=1 then 'and su.isCahps = 1' else '' end + '
		inner join NRC_Datamart.dbo.SampleUnitBySampleset suss on su.sampleunitid=suss.sampleunitid and ss.samplesetid=suss.samplesetid
		left join NRC_Datamart.dbo.SampleUnitFacilityAttributes sufa on sel.sampleunitid=sufa.sampleunitid
		left join NRC_Datamart.dbo.QuestionForm qf on sp.SamplePopulationID=qf.SamplePopulationID and qf.isActive=1' + char(10)
	end

	if charindex('[',@AggFunction)>0
	begin
		set @GroupBy = substring(@AggFunction,charindex('[',@AggFunction),len(@AggFunction))
		set @AggFunction = replace(@AggFunction,@GroupBy,'')
	end
	else
		set @GroupBy = '[FileMakerName]'

	set @Uniqueness = replace(@Uniqueness, @SourceColumnName, '')
	if rtrim(@uniqueness)<>'' set @uniqueness=','+@uniqueness

	set @sql = @sql + 'update r set ['+@ExportColumnName+']=sub.Agg
	from #results r
	inner join (select '+@groupby+', '+@AggFunction+'('+
		case when @SourceColumnType in (40,61) then 'convert(varchar,' else '' end+
		'sub2.'+@SourceColumnName+case when @SourceColumnType in (40,61) then ',112)' else '' end+') as Agg
		from (select distinct '+@GroupBy+replace(@Uniqueness+','+@SourceColumnName, ',', ','+@TableAlias+'.')+'
			from #results r 
			'+@JoinOn+'		) sub2
		group by '+@groupby+') sub
		on '+replace(replace(@groupby,',','+''|''+'),'[','r.[')     --> takes a @GroupBy                (e.g. [ColX],[ColY])
		+'='+replace(replace(@groupby,',','+''|''+'),'[','sub.[')	--> and makes it into a join clause (e.g. r.[ColX]+'|'+r.[ColY] = sub.[ColX]+'|'+sub.[ColY])
		+ char(10)

	update #allcolumns
	set Flag=1
	where flag=0
	and ExportTemplateSectionName+'.'+ExportColumnName = @ExportcolumnName
end

set @sql = replace(@sql,'count distinct (','count(distinct ')
set @sql = replace(@sql,'count distinct(','count(distinct ')

print substring(@sql,1,8000)
if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
exec (@SQL)

update #allcolumns set flag=1
where flag=0
and ExportColumnName is not null
and AggregateFunction is not null

if exists (select * from #allcolumns where flag=0)
begin
	print 'One or more columns were not processed. Aborting.'
	set @sql=''
	select @SQL = @SQL + msg + ', '
	from (	select isnull(ExportColumnName,ExportColumnNameMR) as msg
			from #allcolumns
			where flag=0) x

	insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
	select getdate() as EventDateTime
		, 'Error' as EventLevel
		, system_user as UserName
		, host_name() as MachineName
		, '' as EventType
		, 'One or more columns were not processed.' as EventMessage
		, '[CEM].[PullExportData] @ExportQueueID=' + convert(varchar,@ExportQueueID) as EventSource
		, 'Stored Procedure' as EventClass
		, '' as EventMethod
		, 'The procedure doesn''t know how to handle the following columns: '+@sql as ErrorMessage
	return --1
end

if @doRecode=1
begin
	if object_id('tempdb..#recodes') is not null
		drop table #recodes

	-- use a cartesian join to populate all the default recoding that should happen across all columns
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnName, isnull(convert(varchar,d.RawValue),'') as RawValue, d.RecodeValue, ac.FixedWidthLength
	into #recodes
	from #allcolumns ac, [CEM].[ExportTemplateDefaultResponse] d
	where ExportColumnName is not null and ac.RecodeValue is not null and d.ExportTemplateID=@ExportTemplateID

	-- update #recodes with any column-specific recodes that override the default behavior
	update #allColumns set flag=0
	update r set RecodeValue=ac.RecodeValue
	from #recodes r
	inner join #allcolumns ac on r.ExportTemplateSectionName=ac.ExportTemplateSectionName and r.ExportColumnName = ac.ExportColumnName and r.RawValue=convert(varchar,ac.RawValue)

	update #allColumns set flag=1
	from #recodes r
	inner join #allcolumns ac on r.ExportTemplateSectionName=ac.ExportTemplateSectionName and r.ExportColumnName = ac.ExportColumnName and r.RawValue=convert(varchar,ac.RawValue)

	-- add column specific recodes to #recodes
	insert into #recodes
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnName, isnull(ac.RawValue,''), ac.RecodeValue, ac.FixedWidthLength
	from #allcolumns ac
	where ExportColumnName is not null and ac.RecodeValue is not null and flag=0

	-- execute the recodes
	-- declare @sql varchar(max), @sectname varchar(200), @colname varchar(200) 
	select top 1 @sectname=ExportTemplateSectionName, @colname=ExportColumnName from #recodes 
	while @@rowcount>0
	begin
		-- char(7) is used as a flag for "out-of-range"
		set @SQL = 'update R
				set ['+@sectname+'.'+@colname+']=isnull(right(replicate(RecodeValue,FixedWidthLength),FixedWidthLength),char(7))
				from #results R
				left join (select RawValue, RecodeValue, FixedWidthLength from #recodes where ExportTemplateSectionName='''+@sectname+''' and ExportColumnName='''+@colname+''') rc
					on r.['+@sectname+'.'+@colname+']=rc.RawValue'
		print substring(@sql,1,8000)
		if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
		if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
		exec (@SQL)

		delete from #recodes where ExportTemplateSectionName=@sectname and ExportColumnName=@colname
		select top 1 @sectname=ExportTemplateSectionName, @colname=ExportColumnName from #recodes 
	end

	-- declare @sql varchar(max), @sqlwhere varchar(max)
	insert into #recodes
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnNameMR, isnull(ac.RawValue,''), ac.RecodeValue, FixedWidthLength
	from #allcolumns ac
	where ExportColumnNameMR is not null 

	declare @etcID int, @notAnsweredCode varchar(200)
	select top 1 @etcID=ExportTemplateColumnID, @notAnsweredCode=RecodeValue from #recodes where RawValue=-9
	while @@rowcount>0
	begin
		select @SQLwhere = '', @sql=''
		select @sqlwhere=@sqlwhere + '['+ExportTemplateSectionName+'.'+ExportColumnName+']+'
		from #recodes
		where ExportTemplateColumnID = @etcID
		and ExportColumnName <> 'unmarked'
		set @sqlwhere = left(@sqlwhere,len(@sqlwhere)-1)
		
		select @sql=@sql + 'update #results set ['+ExportTemplateSectionName+'.'+ExportColumnName+']='''+@notAnsweredCode+''' where len('+@sqlwhere+')>0 and ['+ExportTemplateSectionName+'.'+ExportColumnName+']<>'''+RecodeValue+'''' + char(10) 
		from #recodes
		where ExportTemplateColumnID = @etcID
		and ExportColumnName <> 'unmarked'
		
		exec (@SQL)
		
		delete from #recodes where ExportTemplateColumnID = @etcID
		select top 1 @etcID=ExportTemplateColumnID, @notAnsweredCode=RecodeValue from #recodes where RawValue=-9
	end
end /* @doRecode=1 */

if @doDispositionProc=1
begin
	if object_id('tempdb..#disproc') is not null
		drop table #disproc

	select distinct dp.DispositionProcessID, dp.RecodeValue, dp.DispositionActionID, dc.DispositionClauseID, dc.DispositionPhraseKey, '['+ac.ExportTemplateSectionName+'.'+isnull(ExportColumnName,ExportColumnNameMR)+'] '+o.strOperator+' '
		+replace(replace(o.strLogic,'%strLowValue%',isnull(LowValue,'')),'%strHighValue%',isnull(HighValue,'')) as strWhere
	into #disproc
	from CEM.DispositionProcess dp
	inner join CEM.DispositionClause dc on dp.DispositionProcessID=dc.DispositionProcessID
	inner join #allcolumns ac on dc.[ExportTemplateColumnID]=ac.[ExportTemplateColumnID]
	inner join CEM.Operator o on dc.OperatorID=o.OperatorID

	-- declare @sql varchar(max)
	declare @dpid int, @dcid int, @dpk int, @daid int 

	select top 1 @dcid = DispositionClauseID from #disproc where strWhere like '%[%]inlist[%]%'
	while @@rowcount>0 
	begin
		set @sql = '('
		select @sql = @sql + '''' + ListValue + ''','	
		from #disproc dc
		inner join CEM.dispositioninlist dil on dc.DispositionClauseID=dil.DispositionClauseID
		where dc.DispositionClauseID=@dcid
		
		set @sql = left(@sql,len(@sql)-1)+')'
		
		update #disproc set strwhere = replace(strWhere, '%inlist%', @sql) where DispositionClauseID=@dcid
		select top 1 @dcid = DispositionClauseID from #disproc where strWhere like '%[%]inlist[%]%'
	end

	-- declare @sql varchar(max), @dpid int, @dpk int, @dcid int
	while exists (select 1 from #disproc group by DispositionProcessID, DispositionPhraseKey having count(*)>1)
	begin
		select top 1 @dpid=DispositionProcessID, @dcid=min(DispositionClauseID), @dpk=DispositionPhraseKey 
		from #disproc 
		group by DispositionProcessID, DispositionPhraseKey  
		having count(*)>1
		
		set @SQL = ''
		select @sql=@sql+strWhere + ' and '
		from #disproc
		where DispositionProcessID = @dpid 
		and DispositionPhraseKey = @dpk
		
		set @sql = left(@sql,len(@sql)-4)
		
		delete from #disproc where DispositionProcessID = @dpid and DispositionPhraseKey=@dpk and DispositionClauseID <> @dcid
		update #disproc set strWhere = @sql where DispositionProcessID = @dpid and DispositionPhraseKey=@dpk 
	end

	-- declare @sql varchar(max), @dpid int, @dpk int, @dcid int 
	while exists (select DispositionProcessID from #disproc group by DispositionProcessID having count(*)>1)
	begin
		select top 1 @dpid = DispositionProcessID, @dcid=min(DispositionClauseID) from #disproc group by DispositionProcessID having count(*)>1
		
		set @SQL = ''
		select @sql=@sql+'('+strWhere + ') or '
		from #disproc
		where DispositionProcessID = @dpid 
		
		set @sql = left(@sql,len(@sql)-3)
		
		delete from #disproc where DispositionProcessID = @dpid and DispositionClauseID <> @dcid
		update #disproc set strWhere = @sql where DispositionProcessID = @dpid 
	end

	select top 1 @dpid=DispositionProcessID, @daid=DispositionActionID from #disproc
	while @@rowcount>0
	begin
		print '--DispositionProcessId=' + convert(varchar,@dpid)
		if @daid=1 -- recode
		begin
			set @sql = 'update #results set '
			select @sql = @sql + char(10) + '[' + ac.ExportTemplateSectionName + '.' + ac.ExportColumnName+'] = ''' + replicate(dc.RecodeValue,ac.FixedWidthLength) + ''',' 
			from (	select distinct DispositionProcessID,ExportTemplateSectionName,isnull(ExportColumnNameMR,ExportColumnName) as ExportColumnName,FixedWidthLength 
					from #allcolumns
					where isnull(ExportColumnNameMR,'') <> 'unmarked') ac
			inner join #disproc dc on ac.DispositionProcessID=dc.DispositionProcessID
			where ac.DispositionProcessID=@dpid
		end
		else if @daid=2 -- delete 
			set @sql = 'delete #results~' -- the "~" will get removed by the left() function in the next select
		
		select @sql = left(@sql,len(@sql)-1) + ' where ' + strWhere
		from #disproc
		where DispositionProcessID=@dpid
		
		print substring(@sql,1,8000)
		if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
		if len(@Sql)>15000 print '~'+substring(@sql,16001,7000)
		exec (@SQL)

		delete from #disproc where DispositionProcessID=@dpid
		select top 1 @dpid=DispositionProcessID, @daid=DispositionActionID from #disproc
	end
end /* @doDispositionProc=1 */

if @doRecode=1 and @doDispositionProc=1
begin
	-- move recoded results into permanent table
	-- declare @sql varchar(max), @ExportTemplateID int=1
	set @sql = ''
	select @sql = @sql + ',['+ExportTemplateSectionName+'.'+ExportColumnName+']'
	from (select distinct ExportTemplateSectionName,isnull(ExportColumnName,ExportColumnNameMR) as ExportColumnName from #allcolumns where isnull(ExportColumnNameMR,'') <> 'unmarked') x

	print 'insert into CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' (ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName' + @sql + ')'
	print 'select ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName'+@sql
	print 'from #results'
	
	set @sql = 'insert into CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' (ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName' + @sql + ')
	select ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName'+@sql+'
	from #results'

	exec (@SQL)

	if @doPostProcess=1
		AND exists (SELECT * 
					FROM  sys.schemas ss 
						  INNER JOIN sys.procedures sp ON ss.schema_id = sp.schema_id 
					WHERE ss.NAME = 'CEM' 
						  AND sp.NAME = 'ExportPostProcess' + RIGHT(CONVERT(VARCHAR, 100000000+@ExportTemplateID), 8) )
	begin
		set @SQL = 'exec CEM.ExportPostProcess'+right(convert(varchar,100000000+@ExportTemplateID),8) + ' ' + convert(varchar,@ExportQueueID)
		begin try
			exec (@SQL)
		end try
		begin catch
			print 'error running ExportPostProcess'
			insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
			select getdate() as EventDateTime
				, 'Error' as EventLevel
				, system_user as UserName
				, host_name() as MachineName
				, '' as EventType
				, 'Export post process failed' as EventMessage
				, '[CEM].[PullExportData] @ExportQueueID=' + convert(varchar,@ExportQueueID) as EventSource
				, 'Stored Procedure' as EventClass
				, '' as EventMethod
				, @sql as ErrorMessage			
			return --1
		end catch
		
	end

	update CEM.ExportQueue 
	set PullDate=getdate()
	where ExportQueueID=@ExportQueueID
end

-- drop table #results
drop table #allcolumns
if object_id('tempdb..#recodes') is not null 
	drop table #recodes
if object_id('tempdb..#disproc') is not null 
	drop table #disproc

end
GO
