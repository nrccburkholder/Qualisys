/*
S35_US20 CAHPS Hospice template changes.sql

As a Hospice CAHPS Vendor, we need to correctly report the sample type, so we submit accurate data & comply w/ an on-site visit item 
See HSP_Visit_2015_FUp_CCN_051508_SampleType.docx 
Notes: 3 possible sample methods (target/out-go/census). We pulled in the NRC value of 2 and reported census it appears. At 700 decedents/year 
then the method changes from census to random At CCN level, we need to check if numbered sampled is =< for specified outgo for all 3 months, 
if so we census sampled. OR Should implementation use the correct code when they set it up?

Task 3 - Change post-processing to use the new element

Dave Gilsdorf

NRC_DataMart_Extracts:
insert into CEM.Datasource
update CEM.exporttemplatecolumn 
update CEM.ExportTemplateColumnResponse 

*/
use NRC_DataMart_Extracts
go

if exists (select * from CEM.datasource where TableName='NRC_Datamart.dbo.SampleUnitBySampleSet')
	delete from CEM.datasource where TableName='NRC_Datamart.dbo.SampleUnitBySampleSet'

declare @newTemplateID int, @SQL varchar(max)
select @newTemplateID=exporttemplateid from CEM.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2
if @newTemplateID is not null
begin
	select object_name(object_id), * from sys.columns where name = 'exporttemplateid' order by 1
	delete from CEM.DispositionInList where DispositionClauseID in (select DispositionClauseID from CEM.DispositionClause where DispositionProcessID in (select DispositionProcessID from CEM.ExportTemplateColumn where DispositionProcessID is not null and ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID)))
	delete from CEM.DispositionClause where DispositionProcessID in (select DispositionProcessID from CEM.ExportTemplateColumn where DispositionProcessID is not null and ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID))
	delete from CEM.DispositionProcess where DispositionProcessID in (select DispositionProcessID from CEM.ExportTemplateColumn where DispositionProcessID is not null and ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID))
	delete from CEM.ExportTemplateDefaultResponse where exporttemplateid=@newTemplateID
	delete from CEM.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID)
	delete from CEM.ExportTemplateColumn where ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID)
	delete from CEM.ExportTemplateSection where exporttemplateid=@newTemplateID
	delete from CEM.ExportTemplate where exporttemplateid=@newTemplateID
	if exists (select * from sys.tables where name = 'ExportDataset' + right(convert(varchar,100000000+@newTemplateID),8))
	begin
		set @SQL = 'delete from CEM.ExportQueueFile where exportqueueid in (select exportqueueID from CEM.ExportDataset' + right(convert(varchar,100000000+@newTemplateID),8) + ')'
		exec (@SQL)
		set @sql=replace(@sql,'ExportQueueFile','ExportQueueSurvey')
		exec (@SQL)
		set @sql=replace(@sql,'ExportQueueSurvey','ExportQueue')
		exec (@SQL)
		set @sql = 'drop table CEM.ExportDataset' + right(convert(varchar,100000000+@newTemplateID),8) 
		exec (@SQL)
	end
	set @sql='ExportPostProcess' + right(convert(varchar,100000000+@newTemplateID),8) 
	if exists (select * from sys.procedures where name = @SQL)
	begin
		set @SQL = 'drop procedure CEM.'+@SQL
		exec (@SQL)
	end

end


select max(exporttemplateid) from CEM.ExportTemplate -- 6
select max(exporttemplatesectionid) from CEM.ExportTemplateSection -- 16
select max(exporttemplatecolumnid) from CEM.ExportTemplateColumn -- 604
select max(ExportTemplateColumnResponseid) from CEM.ExportTemplateColumnResponse -- 2017
select max(ExportTemplateDefaultResponseid) from CEM.ExportTemplateDefaultResponse -- 119
select max(dispositionprocessid) from CEM.DispositionProcess -- 12
select max(dispositionclauseid) from  CEM.DispositionClause -- 20
select max(dispositioninlistid) from  CEM.Dispositioninlist -- 344
select max(datasourceid) from CEM.Datasource -- 9

DBCC CHECKIDENT ('CEM.ExportTemplate', RESEED, 6 )
DBCC CHECKIDENT ('CEM.ExportTemplateSection', RESEED, 16) 
DBCC CHECKIDENT ('CEM.ExportTemplateColumn', RESEED, 604) 
DBCC CHECKIDENT ('CEM.ExportTemplateColumnResponse', RESEED, 2017) 
DBCC CHECKIDENT ('CEM.ExportTemplateDefaultResponse', RESEED, 119) 

DBCC CHECKIDENT ('CEM.DispositionProcess', RESEED, 12) 
DBCC CHECKIDENT ('CEM.DispositionClause', RESEED, 20) 
DBCC CHECKIDENT ('CEM.Dispositioninlist', RESEED, 344) 

DBCC CHECKIDENT ('CEM.Datasource', RESEED, 9) 
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
declare @ExportColumnName varchar(255), @AggFunction varchar(255), @SourceColumnType int, @TableName varchar(255), @TableAlias varchar(20), @SourceColumnName varchar(255), @GroupBy varchar(255)
while exists (select * from #allcolumns where flag=0 and ExportColumnName is not null and AggregateFunction is not null)
begin
	select top 1 @ExportcolumnName=ExportTemplateSectionName+'.'+ExportColumnName
	, @AggFunction = rtrim(AggregateFunction)
	, @SourceColumnType=SourceColumnType
	, @TableName=TableName
	, @TableAlias=TableAlias
	, @SourceColumnName=SourceColumnName
	from #allcolumns where flag=0 
	and ExportColumnName is not null 
	and AggregateFunction is not null

	if charindex('[',@AggFunction)>0
	begin
		set @GroupBy = substring(@AggFunction,charindex('[',@AggFunction),len(@AggFunction))
		set @AggFunction = replace(@AggFunction,@GroupBy,'')
	end
	else
		set @GroupBy = '[FileMakerName]'

	set @sql = @sql + 'update r set ['+@ExportColumnName+']=sub.Agg
	from #results r
	inner join (select '+@groupby+', '+@AggFunction+'('+
		case when @SourceColumnType in (40,61) then 'convert(varchar,' else '' end+
		@TableAlias+'.'+@SourceColumnName+case when @SourceColumnType in (40,61) then ',112)' else '' end+') as Agg
		from #results r 
		inner join '+@TableName+' '+@TableAlias+' on r.'+replace(@TableName,'NRC_Datamart.dbo.','')+'id='+@TableAlias+'.'+replace(@TableName,'NRC_Datamart.dbo.','')+'id
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