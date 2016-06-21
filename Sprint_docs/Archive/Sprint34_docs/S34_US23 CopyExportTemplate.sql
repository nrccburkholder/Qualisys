/*
S34_US23 CopyExportTemplate.sql

As a compliance analyst I want the ACO submission file to be created in CEM using the newest version of submission file layout

23.1 - create a new template in CEM for ACO

Dave Gilsdorf

NRC_DataMart_Extracts:
CREATE PROCEDURE [CEM].[CopyExportTemplate]

*/
use NRC_DataMart_Extracts
go
if exists (select * from sys.procedures where name = 'CopyExportTemplate')
	drop PROCEDURE [CEM].[CopyExportTemplate]
go
CREATE PROCEDURE [CEM].[CopyExportTemplate]
@templateID int
as
select *, 0 as [newID] 
into #ET 
from cem.ExportTemplate 
where ExportTemplateID=@templateID

select *, 0 as [newID] 
into #ETS 
from cem.ExportTemplateSection 
where ExportTemplateID=@templateID

select *, 0 as [newID] 
into #ETDR 
from cem.ExportTemplateDefaultResponse 
where ExportTemplateID=@templateID

select etc.*, 0 as [newID] 
into #ETC
from cem.ExportTemplateColumn etc 
where ExportTemplateSectionID in (select ExportTemplateSectionID from #ETS)

select etcr.*, 0 as [newID] 
into #ETCR
from cem.ExportTemplateColumnResponse etcr
where ExportTemplateColumnID in (select ExportTemplateColumnID from #ETC)

select *, 0 as [newID]
into #DC
from cem.dispositionclause 
where ExportTemplateColumnID in (select ExportTemplateColumnID from #ETC)

select *, 0 as [newID]
into #DP
from cem.dispositionprocess 
where DispositionProcessID in (select DispositionProcessID from #DC)

select *, 0 as [newID]
into #DIL 
from cem.dispositioninlist
where dispositioninlistID in (select dispositioninlistID from #DP)


---- INSERT THE MODIFIED TEMPLATE INTO THE TABLES ----

declare @newID int, @newTemplateID int
begin tran

INSERT INTO CEM.ExportTemplate (ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType)
select ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType
from #ET

set @newID = SCOPE_IDENTITY()
set @newTemplateID=@newID

update #ET set [newID]=@newID
update #ETS set ExportTemplateID=@newID
update #ETDR set ExportTemplateID=@newID

insert into cem.ExportTemplateDefaultResponse (ExportTemplateID,RawValue,RecodeValue,ResponseLabel)
select ExportTemplateID,RawValue,RecodeValue,ResponseLabel
from #ETDR

declare @oldID int
select top 1 @oldID=ExportTemplateSectionID from #ETS where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
	select ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention
	from #ETS
	where ExportTemplateSectionID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #ETC set ExportTemplateSectionID=@newID where ExportTemplateSectionID=@oldID
	update #ETS set [newid]=@newID where ExportTemplateSectionID=@oldID
	
	select top 1 @oldID=ExportTemplateSectionID from #ETS where [newid]=0
end

select top 1 @oldID=ExportTemplateColumnID from #ETC where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, ColumnSetKey, FormatID, MissingThresholdPercentage, CheckFrequencies)
	select ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, ColumnSetKey, FormatID, MissingThresholdPercentage, CheckFrequencies
	from #ETC
	where ExportTemplateColumnID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #ET set ValidDateColumnID=@newID where ValidDateColumnID=@oldID
	if @@rowcount>0
		update cem.ExportTemplate set ValidDateColumnID=@newID where ValidDateColumnID=@oldID and ExportTemplateId=@newTemplateID
	update #DC set ExportTemplateColumnID=@newID where ExportTemplateColumnID=@oldID
	update #ETCR set ExportTemplateColumnID=@newID where ExportTemplateColumnID=@oldID
	update #ETC set [newid]=@newID where ExportTemplateColumnID=@oldID
	
	select top 1 @oldID=ExportTemplateColumnID from #ETC where [newid]=0
end

select top 1 @oldID=ExportTemplateColumnResponseID from #ETCR where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.ExportTemplateColumnResponse (ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel)
	select ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel
	from #ETCR
	where ExportTemplateColumnResponseID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #ETCR set [newid]=@newID where ExportTemplateColumnResponseID=@oldID
	
	select top 1 @oldID=ExportTemplateColumnResponseID from #ETCR where [newid]=0
end

select top 1 @oldID=DispositionProcessID from #DP where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionProcess (RecodeValue,ExportErrorID,DispositionActionID)
	select RecodeValue,ExportErrorID,DispositionActionID
	from #DP
	where DispositionProcessID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DC set DispositionProcessID=@newID where DispositionProcessID=@oldID
	update #ETC set DispositionProcessID=@newID where DispositionProcessID=@oldID
	update #DP set [newid]=@newID where DispositionProcessID=@oldID
	
	select top 1 @oldID=DispositionProcessID from #DP where [newid]=0
end

update p set DispositionProcessID=t.DispositionProcessID
from #ETC t
inner join CEM.ExportTemplateColumn p on t.[newID]=p.ExportTemplateColumnID
where t.DispositionProcessID<>p.DispositionProcessID

select top 1 @oldID=DispositionClauseID from #DC where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionClause (DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue)
	select DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue
	from #DC
	where DispositionClauseID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DIL set DispositionClauseID=@newID where DispositionClauseID=@oldID
	update #DC set [newid]=@newID where DispositionClauseID=@oldID
	
	select top 1 @oldID=DispositionClauseID from #DC where [newid]=0
end

select top 1 @oldID=DispositionInListID from #DIL where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionInList (DispositionClauseID,ListValue)
	select DispositionClauseID,ListValue
	from #DIL
	where DispositionInListID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DIL set [newid]=@newID where DispositionInListID=@oldID
	
	select top 1 @oldID=DispositionInListID from #DIL where [newid]=0
end

commit tran

DROP TABLE #ET
DROP TABLE #ETS
DROP TABLE #ETDR
DROP TABLE #ETC 
DROP TABLE #ETCR
DROP TABLE #DP
DROP TABLE #DC
DROP TABLE #DIL

declare @sql nvarchar(max)
select @sql=definition
from sys.sql_modules
where object_name(object_id)='ExportPostProcess'+right(convert(varchar,@templateID+100000000),8)

set @sql = replace(@sql, right(convert(varchar,@templateID+100000000),8), right(convert(varchar,@newTemplateID+100000000),8))

if exists(select * from sys.procedures where name = 'ExportPostProcess'+right(convert(varchar,@newTemplateID+100000000),8))
	set @SQL = replace(@SQL,'CREATE PROCEDURE','ALTER PROCEDURE')

EXECUTE dbo.sp_executesql @SQL

go