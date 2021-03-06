/*
S13.US11
S14.US5		CEM - Data Gathering process
			Build procedure to gather data for a queued up template

T11.1	Determine dynamic sql to join necessary tables
T11.2	Design algorithm to determine which respondents should be in the data (survey/sample units, date range, ReturnsOnly)
T11.3	Build table(s) to hold the data
T5.1	Gather & recode data
T5.2	Disposition recode process
T5.3	Logging/Errors/Warnings

Dave Gilsdorf

CREATE PROCEDURE [CEM].[PullExportData]
CREATE PROCEDURE [CEM].[ExportPostProcess00000001]
*/
use NRC_Datamart
go
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.procedures sp on ss.schema_id=sp.schema_id
            WHERE   ss.name = N'CEM' and sp.name=N'PullExportData') 
    DROP PROCEDURE [CEM].[PullExportData] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.procedures sp on ss.schema_id=sp.schema_id
            WHERE   ss.name = N'CEM' and sp.name=N'AssembleExportData') 
    DROP PROCEDURE [CEM].[AssembleExportData] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.procedures sp on ss.schema_id=sp.schema_id
            WHERE   ss.name = N'CEM' and sp.name=N'ExportPostProcess00000001') 
    DROP PROCEDURE [CEM].[ExportPostProcess00000001] 
GO
CREATE PROCEDURE [CEM].[PullExportData]
@ExportQueueID int, @doRecode bit=1, @doDispositionProc bit=1, @doPostProcess bit=1
as
begin 

--declare @ExportQueueID int = 1

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
	RETURN --1
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
where et.ExportTemplateID=1--@ExportTemplateID
order by etc.ColumnOrder

if exists (	select ExportTemplateColumnID
			from #allcolumns
			where ExportColumnNameMR is not null
			and RawValue <> -9
			group by ExportTemplateColumnID
			having min(FixedWidthLength) <> sum(len(RecodeValue)))
begin
	print 'ERROR! One or more of the multiple response questions doesn''t have a wide enough FixedWidthLength. Aborting.'
	set @sql=''
	select @SQL = @SQL + msg + ', '
	from (	select min(ExportTemplateColumnDescription)+ ' needs ' + convert(varchar,sum(len(RecodeValue))) + ' but is using '+convert(varchar, min(FixedWidthLength)) as msg
			from #allcolumns
			where ExportColumnNameMR is not null
			and RawValue <> -9
			group by ExportTemplateColumnID
			having min(FixedWidthLength) <> sum(len(RecodeValue))) x

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
	RETURN --1
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
 , (select max(len(RawValue)) as defaultwidth from CEM.ExportTemplateDefaultResponse where ExportTemplateID=@ExportTemplateID) d
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
	set @SQL = 'insert into #results (samplepopulationid) 
		select distinct samplepopulationid 
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
		return 
	end
end

declare @sqlInsert varchar(max), @sqlSelect varchar(max), @sqlFrom varchar(max), @sqlWhere varchar(max)
set @sqlInsert='insert into #results (SamplepopulationID, QuestionFormID, ExportQueueID, ExportTemplateID' + char(10)
set @sqlSelect='select distinct sp.SamplepopulationID, qf.QuestionFormID, '+convert(varchar,@ExportQueueID)+' as ExportQueueID, '+convert(varchar,@ExportTemplateID)+' as ExportTemplateID' + char(10)
set @sqlFrom='from samplepopulation sp 
inner join sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join selectedsample sel on sp.samplepopulationid=sel.samplepopulationid
inner join sampleunit su on sel.sampleunitid=su.sampleunitid
left join questionform qf on sp.samplepopulationid=qf.samplepopulationid' + char(10)

set @sqlWhere = 'where su.surveyid in ('+@surveylist+')' + char(10)

if @CahpsUnitOnly=1
	set @sqlWhere=@sqlWhere+'and su.isCahps = 1' + char(10)

if @ReturnsOnly=1
	set @sqlWhere = @sqlWhere + 'and qf.ReturnDate is not null' + char(10)


select @sqlSelect = @sqlSelect + ', isnull(' +
		case when SourceColumnType in (40,61) then 'convert(varchar,' else '' end + 
	TableAlias + '.[' + SourceColumnName + ']'+
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
	select @sqlFrom = @sqlFrom + 'inner join (select samplepopulationid, convert(datetime,ColumnValue) as ['+ExportColumnName+'] '
		+ 'from Samplepopulationbackgroundfield '
		+ 'where '+SourceColumnName+') datesub '
		+ 'on sp.samplepopulationid=datesub.samplepopulationid' + char(10)
	 , @sqlWhere = @sqlWhere + 'and datesub.['+ExportColumnName+'] between '''+convert(varchar,@exportStart)+''' and '''+convert(varchar,@exportEnd)+'''' + char(10)
	 , @sqlSelect = @sqlSelect + ', convert(varchar,['+ExportColumnName+'],112)' + char(10)
	 , @sqlinsert = @sqlinsert + ', ['+ExportTemplateSectionName+'.'+ExportColumnName+']' + char(10)
	from (select distinct ExportColumnName, SourceColumnName, ExportTemplateSectionName, ExportTemplateColumnID from #allcolumns) ac
	where ExportTemplateColumnID=@ExportDateColumnID
	update #allcolumns set flag=1 where ExportTemplateColumnID=@ExportDateColumnID	
end

set @SQL = @sqlinsert + ') '+@sqlSelect + @sqlFrom + @sqlWhere
print @sql
exec (@SQL)


set @SQL = ''
select @SQL = @SQL + cmd + char(10)
from (	select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnName+']=bg.columnValue
		from #results r
		inner join samplepopulationbackgroundfield bg on r.samplepopulationid=bg.samplepopulationid
		where bg.'+SourceColumnName as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=4) x
print @sql
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=4

set @SQL = ''
select @SQL = @SQL + cmd + char(10)
from (	select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnName+']=rb.ResponseValue
		from #results r
		inner join ResponseBubble rb on r.QuestionFormID=rb.QuestionFormID
		where rb.'+SourceColumnName as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=2
		and ExportColumnName is not null) x
print @sql
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=2 and ExportColumnName is not null


set @SQL = ''
select @SQL = @SQL + cmd + char(10)
from (	select distinct 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnNameMR+']='+convert(varchar,RecodeValue)+'
		from #results r
		inner join ResponseBubble rb on r.QuestionFormID=rb.QuestionFormID
		where rb.'+SourceColumnName+'
		and rb.ResponseValue='+convert(varchar,RawValue) as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=2
		and ExportColumnNameMR is not null
		and RawValue <> -9) x
print @sql
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=2 and ExportColumnNameMR is not null

-- declare @sql varchar(max), @sqlfrom varchar(max)
declare @sectname varchar(200), @colname varchar(200)
select @sql = DefaultNamingConvention, @sqlfrom=''''+DefaultNamingConvention+''''
from cem.ExportTemplate 
where ExportTemplateID=@ExportTemplateID

while charindex('{',@SQL) > 1
begin
	--declare @SQL varchar(max) = 'ICH_{header.facility-id}_{header.survey-yr}_{header.sem-survey}', @sqlfrom varchar(max), @colname varchar(200)
	set @colname = substring(@SQL, 1 + charindex('{', @SQL),  charindex('}', @SQL) - charindex('{', @SQL) - 1)
	set @sqlfrom = replace(@sqlfrom,@sqlfrom,'replace('+@sqlfrom+',''{'+@colname+'}'',['+@colname+'])')
	set @sql = replace(@sql,'{'+@colname+'}','')
end
set @sql = 'update #results set FileMakerName='+@sqlfrom
print @sql
exec (@sql)

set @sql = ''
select @sql = @sql + 'update r set ['+ExportTemplateSectionName+'.'+ExportColumnName+']=sub.Agg
	from #results r
	inner join (select FileMakerName, '+rtrim(AggregateFunction)+'('+
		case when SourceColumnType in (40,61) then 'convert(varchar,' else '' end+
		TableAlias+'.'+SourceColumnName+case when SourceColumnType in (40,61) then ',112)' else '' end+') as Agg
		from #results r 
		inner join '+TableName+' '+TableAlias+' on r.'+TableName+'id='+TableAlias+'.'+TableName+'id
		group by FileMakerName) sub
		on r.FileMakerName=sub.FileMakerName' + char(10)
from #allcolumns
where flag=0
and ExportColumnName is not null
and AggregateFunction is not null

set @sql = replace(@sql,'count distinct(','count(distinct ')

print @SQL
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
	RETURN --1
end

if @doRecode=1
begin
	if object_id('tempdb..#recodes') is not null
		drop table #recodes

	-- use a cartesian join to populate all the default recoding that should happen across all columns
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnName, isnull(convert(varchar,d.RawValue),'') as RawValue, d.RecodeValue
	into #recodes
	from #allcolumns ac, [CEM].[ExportTemplateDefaultResponse] d
	where ExportColumnName is not null and ac.RecodeValue is not null

	-- update #recodes with any column-specific recodes that override the default behavior
	update #allColumns set flag=0
	update r set RecodeValue=ac.RecodeValue
	from #recodes r
	inner join #allcolumns ac on r.ExportTemplateSectionName=ac.ExportTemplateSectionName and r.ExportColumnName = ac.ExportColumnName and r.RawValue=ac.RawValue

	update #allColumns set flag=1
	from #recodes r
	inner join #allcolumns ac on r.ExportTemplateSectionName=ac.ExportTemplateSectionName and r.ExportColumnName = ac.ExportColumnName and r.RawValue=ac.RawValue

	-- add column specific recodes to #recodes
	insert into #recodes
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnName, isnull(ac.RawValue,''), ac.RecodeValue
	from #allcolumns ac
	where ExportColumnName is not null and ac.RecodeValue is not null and flag=0 

	-- execute the recodes
	-- declare @sql varchar(max), @sectname varchar(200), @colname varchar(200)
	select top 1 @sectname=ExportTemplateSectionName, @colname=ExportColumnName from #recodes 
	while @@rowcount>0
	begin
		-- char(7) is used as a flag for "out-of-range"
		set @SQL = 'update R
				set ['+@sectname+'.'+@colname+']=isnull(RecodeValue,char(7))
				from #results R
				left join (select RawValue, RecodeValue from #recodes where ExportTemplateSectionName='''+@sectname+''' and ExportColumnName='''+@colname+''') rc
					on r.['+@sectname+'.'+@colname+']=rc.RawValue'
		print @SQL
		exec (@SQL)

		delete from #recodes where ExportTemplateSectionName=@sectname and ExportColumnName=@colname
		select top 1 @sectname=ExportTemplateSectionName, @colname=ExportColumnName from #recodes 
	end


	-- declare @sql varchar(max), @sqlwhere varchar(max)
	insert into #recodes
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnNameMR, isnull(ac.RawValue,''), ac.RecodeValue
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

	select distinct dp.DispositionProcessID, dp.RecodeValue, dc.DispositionClauseID, '['+ac.ExportTemplateSectionName+'.'+isnull(ExportColumnName,ExportColumnNameMR)+'] '+o.strOperator+' '
		+replace(replace(o.strLogic,'%strLowValue%',isnull(LowValue,'')),'%strHighValue%',isnull(HighValue,'')) as strWhere
	into #disproc
	from CEM.DispositionProcess dp
	inner join CEM.DispositionClause dc on dp.DispositionProcessID=dc.DispositionProcessID
	inner join #allcolumns ac on dc.[ExportTemplateColumnID]=ac.[ExportTemplateColumnID]
	inner join CEM.Operator o on dc.OperatorID=o.OperatorID

	-- declare @sql varchar(max)
	declare @dpid int, @dcid int 

	select top 1 @dcid = DispositionClauseID from #disproc where strWhere like '%[%]inlist[%]%'
	while @@rowcount>0 
	begin
		set @sql = '('
		select @sql = @sql + '''' + ListValue + ''','	
		from #disproc dc
		inner join CEM.dispositioninlist dil on dc.DispositionClauseID=dil.DispositionClauseID
		where dc.DispositionClauseID=@dcid
		
		set @sql = left(@sql,len(@sql)-1)+')'
		
		update #disproc set strwhere = replace(strWhere, '%inlist%', @sql)
		select top 1 @dcid = DispositionClauseID from #disproc where strWhere like '%[%]inlist[%]%'
	end

	while exists (select DispositionProcessID from #disproc group by DispositionProcessID having count(*)>1)
	begin
		select top 1 @dpid = DispositionProcessID, @dcid=min(DispositionClauseID) from #disproc group by DispositionProcessID having count(*)>1
		
		set @SQL = ''
		select @sql=@sql+strWhere + ' and '
		from #disproc
		where DispositionProcessID = @dpid 
		
		set @sql = left(@sql,len(@sql)-4)
		
		delete from #disproc where DispositionProcessID = @dpid and DispositionClauseID <> @dcid
		update #disproc set strWhere = @sql where DispositionProcessID = @dpid 
	end

	select top 1 @dpid=DispositionProcessID from #disproc
	while @@rowcount>0
	begin
		set @sql = 'update #results set '
		select @sql = @sql + char(10) + '[' + ac.ExportTemplateSectionName + '.' + ac.ExportColumnName+'] = ''' + replicate(dc.RecodeValue,ac.FixedWidthLength) + ''',' 
		from (	select distinct DispositionProcessID,ExportTemplateSectionName,isnull(ExportColumnNameMR,ExportColumnName) as ExportColumnName,FixedWidthLength 
				from #allcolumns
				where isnull(ExportColumnNameMR,'') <> 'unmarked') ac
		inner join #disproc dc on ac.DispositionProcessID=dc.DispositionProcessID
		where ac.DispositionProcessID=@dpid
		
		select @sql = left(@sql,len(@sql)-1) + ' where ' + strWhere
		from #disproc
		where DispositionProcessID=@dpid
		
		print @SQL
		exec (@SQL)

		delete from #disproc where DispositionProcessID=@dpid
		select top 1 @dpid=DispositionProcessID from #disproc
	end
end /* @doDispositionProc=1 */

if @doRecode=1 and @doDispositionProc=1
begin
	-- move recoded results into permanent table
	-- declare @sql varchar(max), @ExportTemplateID int=1
	set @sql = ''
	select @sql = @sql + ',['+ExportTemplateSectionName+'.'+ExportColumnName+']'
	from (select distinct ExportTemplateSectionName,isnull(ExportColumnName,ExportColumnNameMR) as ExportColumnName from #allcolumns where isnull(ExportColumnNameMR,'') <> 'unmarked') x

	print 'insert into CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' (ExportqueueID, ExportTemplateID, SamplepopulationID, QuestionformID, FileMakerName' + @sql + ')'
	print 'select ExportqueueID, ExportTemplateID, SamplepopulationID, QuestionformID, FileMakerName'+@sql
	print 'from #results'
	
	set @sql = 'insert into CEM.ExportDataset'+right(convert(varchar,100000000+@ExportTemplateID),8)+' (ExportqueueID, ExportTemplateID, SamplepopulationID, QuestionformID, FileMakerName' + @sql + ')
	select ExportqueueID, ExportTemplateID, SamplepopulationID, QuestionformID, FileMakerName'+@sql+'
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
			RETURN --1
		end catch
		
	end

	update CEM.ExportQueue 
	set PullDate=getdate()
	where ExportQueueID=@ExportQueueID
end

drop table #allcolumns
if object_id('tempdb..#recodes') is not null 
	drop table #recodes
if object_id('tempdb..#disproc') is not null 
	drop table #disproc

end
go
CREATE PROCEDURE [CEM].[ExportPostProcess00000001]
@ExportQueueID int
as
update CEM.ExportDataset00000001
set [patientresponse.race-white-phone]='M', [patientresponse.race-african-amer-phone]='M', [patientresponse.race-amer-indian-phone]='M', [patientresponse.race-asian-phone]='M', [patientresponse.race-nativehawaiian-pacific-phone]='M', [patientresponse.race-noneofabove-phone]='M' 
where len([patientresponse.race-white-phone]+[patientresponse.race-african-amer-phone]+[patientresponse.race-amer-indian-phone]+[patientresponse.race-asian-phone]+[patientresponse.race-nativehawaiian-pacific-phone]+[patientresponse.race-noneofabove-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.race-asian-indian-phone]='M', [patientresponse.race-chinese-phone]='M', [patientresponse.race-filipino-phone]='M', [patientresponse.race-japanese-phone]='M', [patientresponse.race-korean-phone]='M', [patientresponse.race-vietnamese-phone]='M', [patientresponse.race-otherasian-phone]='M', [patientresponse.race-noneofabove-asian-phone]='M'
where len([patientresponse.race-asian-indian-phone]+[patientresponse.race-chinese-phone]+[patientresponse.race-filipino-phone]+[patientresponse.race-japanese-phone]+[patientresponse.race-korean-phone]+[patientresponse.race-vietnamese-phone]+[patientresponse.race-otherasian-phone]+[patientresponse.race-noneofabove-asian-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.race-nativehawaiian-phone]='M', [patientresponse.race-guam-chamarro-phone]='M', [patientresponse.race-samoan-phone]='M', [patientresponse.race-otherpacificislander-phone]='M', [patientresponse.race-noneofabove-pacific-phone]='M'
where len([patientresponse.race-nativehawaiian-phone]+[patientresponse.race-guam-chamarro-phone]+[patientresponse.race-samoan-phone]+[patientresponse.race-otherpacificislander-phone]+[patientresponse.race-noneofabove-pacific-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.race-white-mail]='M', [patientresponse.race-african-amer-mail]='M', [patientresponse.race-amer-indian-mail]='M', [patientresponse.race-asian-indian-mail]='M', [patientresponse.race-chinese-mail]='M', [patientresponse.race-filipino-mail]='M', [patientresponse.race-japanese-mail]='M', [patientresponse.race-korean-mail]='M', [patientresponse.race-vietnamese-mail]='M', [patientresponse.race-otherasian-mail]='M', [patientresponse.race-nativehawaiian-mail]='M', [patientresponse.race-guamanian-chamorro-mail]='M', [patientresponse.race-samoan-mail]='M', [patientresponse.race-other-pacificislander-mail]='M'
where len([patientresponse.race-white-mail]+[patientresponse.race-african-amer-mail]+[patientresponse.race-amer-indian-mail]+[patientresponse.race-asian-indian-mail]+[patientresponse.race-chinese-mail]+[patientresponse.race-filipino-mail]+[patientresponse.race-japanese-mail]+[patientresponse.race-korean-mail]+[patientresponse.race-vietnamese-mail]+[patientresponse.race-otherasian-mail]+[patientresponse.race-nativehawaiian-mail]+[patientresponse.race-guamanian-chamorro-mail]+[patientresponse.race-samoan-mail]+[patientresponse.race-other-pacificislander-mail])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.help-answer]='M', [patientresponse.help-other]='M', [patientresponse.help-read]='M', [patientresponse.help-translate]='M', [patientresponse.help-wrote]='M'
where len([patientresponse.help-answer]+[patientresponse.help-other]+[patientresponse.help-read]+[patientresponse.help-translate]+[patientresponse.help-wrote])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and ExportQueueID=@ExportQueueID
GO