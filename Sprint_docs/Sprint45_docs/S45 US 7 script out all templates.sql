/*
	S45 US 7 Nightly Hospice File Extract 
	As a developer, I need to create a sql agent job on CatDB2 that creates a Hospice CAHPS extract every night so that we have a mechanism for identifying incorrect data well before its time to submit it
	
	7.1 - Write query to return all survey_ids that relate to the current template (all active hospice)

	The templates defined in production were slightly different from the templates in test and stage, so I wrote this to sync all three up.  I ran this in production and then ran the produced script in both test and prod.

	Run these queries with text (not grid) results and you'll get a script that populates all the CEM template tabldes for porting to another environment.  There will be some syntax you'll need to clean up, and you 
	should replace all "`" with "''" but otherwise it should be pretty straight-forward.

	The one exception is the query that returns the update to cem.exporttemplate.XMLSchemaDefinition. Run that in grid results, otherwise the XML will get truncated.
	
*/
use NRC_Datamart_Extracts

set nocount on

print 'truncate table cem.exporttemplate
truncate table cem.exporttemplatesection
truncate table cem.exporttemplatecolumn
truncate table cem.exporttemplatecolumnresponse
truncate table cem.exporttemplatedefaultresponse
truncate table cem.DispositionProcess 
truncate table cem.DispositionInList 
truncate table cem.DispositionClause'

print 'set identity_insert cem.ExportTemplate on'
print 'insert into cem.ExportTemplate (ExportTemplateID,ExportTemplateName,SurveyTypeID,ValidDateColumnID,ValidStartDate,ValidEndDate,ExportTemplateVersionMajor,ExportTemplateVersionMinor,CreatedBy,CreatedOn,DefaultNamingConvention,State,ReturnsOnly,SampleUnitCahpsTypeID,isOfficial,DefaultFileMakerType) values'
select ',('''+convert(varchar,[ExportTemplateID])+''','''+convert(varchar,[ExportTemplateName])+''','''+convert(varchar,[SurveyTypeID])+''','''+convert(varchar,[ValidDateColumnID])+''','''+convert(varchar,[ValidStartDate])+''','''+convert(varchar,[ValidEndDate])+''','''+convert(varchar,[ExportTemplateVersionMajor])+''','''+convert(varchar,[ExportTemplateVersionMinor])+''','''+convert(varchar,[CreatedBy])+''','''+convert(varchar,[CreatedOn])+''','''+convert(varchar,[DefaultNamingConvention])+''','''+convert(varchar,[State])+''','''+convert(varchar,[ReturnsOnly])+''','''+convert(varchar,[SampleUnitCahpsTypeID])+''','''+convert(varchar,[isOfficial])+''','+isnull(''''+convert(varchar,[DefaultFileMakerType])+'''','NULL')+')'
from cem.exporttemplate
print 'set identity_insert cem.ExportTemplate off'

select 'update cem.exporttemplate set XMLSchemaDefinition=''',XMLSchemaDefinition, ''' where ExportTemplateID=',ExportTemplateID
from cem.exporttemplate
where XMLSchemaDefinition is not null


print 'set identity_insert cem.ExportTemplateSection on
insert into cem.ExportTemplateSection ([ExportTemplateSectionID],[ExportTemplateSectionName],[ExportTemplateID])
values '
select ',('''+convert(varchar,[ExportTemplateSectionID])+''','''+convert(varchar,[ExportTemplateSectionName])+''','''+convert(varchar,[ExportTemplateID])+''')'
from cem.exporttemplatesection 
print 'set identity_insert cem.ExportTemplateSection off'

print 'set identity_insert cem.exporttemplatecolumn on
insert into cem.exporttemplatecolumn (ExportTemplateColumnID,ExportTemplateSectionID,ExportTemplateColumnDescription,ColumnOrder,DatasourceID,ExportColumnName,SourceColumnName,SourceColumnType,AggregateFunction,DispositionProcessID,FixedWidthLength,ColumnSetKey,FormatID,MissingThresholdPercentage,CheckFrequencies)
values '
select ',('+
isnull(''''+convert(varchar(max),ExportTemplateColumnID)+'''','null')+',',
isnull(''''+convert(varchar(max),ExportTemplateSectionID)+'''','null')+',',
isnull(''''+convert(varchar(max),replace(ExportTemplateColumnDescription,'''','`'))+'''','null')+',',
isnull(''''+convert(varchar(max),ColumnOrder)+'''','null')+',',
isnull(''''+convert(varchar(max),DatasourceID)+'''','null')+',',
isnull(''''+convert(varchar(max),ExportColumnName)+'''','null')+',',
isnull(''''+convert(varchar(max),replace(SourceColumnName,'''','`'))+'''','null')+',',
isnull(''''+convert(varchar(max),SourceColumnType)+'''','null')+',',
isnull(''''+convert(varchar(max),AggregateFunction)+'''','null')+',',
isnull(''''+convert(varchar(max),DispositionProcessID)+'''','null')+',',
isnull(''''+convert(varchar(max),FixedWidthLength)+'''','null')+',',
isnull(''''+convert(varchar(max),ColumnSetKey)+'''','null')+',',
isnull(''''+convert(varchar(max),FormatID)+'''','null')+',',
isnull(''''+convert(varchar(max),MissingThresholdPercentage)+'''','null')+',',
isnull(''''+convert(varchar(max),CheckFrequencies)+'''','null')+')'
from cem.exporttemplatecolumn

print 'set identity_insert cem.exporttemplatecolumn off

set identity_insert cem.exporttemplatecolumnresponse  on
insert into cem.exporttemplatecolumnresponse (ExportTemplateColumnResponseID,ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel)
values '
select ',('+
isnull(''''+convert(varchar(max),[ExportTemplateColumnResponseID])+'''','null')+','
, isnull(''''+convert(varchar(max),[ExportTemplateColumnID])+'''','null')+','
, isnull(''''+convert(varchar(max),[RawValue])+'''','null')+','
, isnull(''''+convert(varchar(max),[ExportColumnName])+'''','null')+','
, isnull(''''+convert(varchar(max),[RecodeValue])+'''','null')+','
, isnull(''''+convert(varchar(max),replace([ResponseLabel],'''','`'))+'''','null')+')'
from cem.exporttemplatecolumnresponse

print 'set identity_insert cem.exporttemplatecolumnresponse  off

set identity_insert cem.ExportTemplateDefaultResponse on
insert into cem.ExportTemplateDefaultResponse (ExportTemplateDefaultResponseID,ExportTemplateID,RawValue,RecodeValue,ResponseLabel)
values '
-- ExportTemplateDefaultResponseID	ExportTemplateID	RawValue	RecodeValue	ResponseLabel
select ',('+
isnull(''''+convert(varchar(max),[ExportTemplateDefaultResponseID])+'''','null')+','
, isnull(''''+convert(varchar(max),[ExportTemplateID])+'''','null')+','
, isnull(''''+convert(varchar(max),[RawValue])+'''','null')+','
, isnull(''''+convert(varchar(max),[RecodeValue])+'''','null')+','
, isnull(''''+convert(varchar(max),replace([ResponseLabel],'''','`'))+'''','null')+')'
from cem.exporttemplatedefaultresponse

print 'set identity_insert cem.ExportTemplateDefaultResponse off

set identity_insert cem.DispositionProcess on
insert into cem.DispositionProcess (DispositionProcessID,RecodeValue,DispositionActionID)
values'

-- DispositionProcessID	RecodeValue	DispositionActionID
select ',('+
isnull(''''+convert(varchar(max),[DispositionProcessID])+'''','null')+',',
isnull(''''+convert(varchar(max),[RecodeValue])+'''','null')+',',
isnull(''''+convert(varchar(max),[DispositionActionID])+'''','null')+')'
from cem.DispositionProcess

print 'set identity_insert cem.DispositionProcess off

set identity_insert cem.DispositionClause on
insert into cem.DispositionClause (DispositionClauseID,DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue)
values'

-- DispositionClauseID,DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue
select ',('+
isnull(''''+convert(varchar(max),[DispositionClauseID])+'''','null')+',',
isnull(''''+convert(varchar(max),[DispositionProcessID])+'''','null')+',',
isnull(''''+convert(varchar(max),[DispositionPhraseKey])+'''','null')+',',
isnull(''''+convert(varchar(max),[ExportTemplateColumnID])+'''','null')+',',
isnull(''''+convert(varchar(max),[OperatorID])+'''','null')+',',
isnull(''''+convert(varchar(max),replace([LowValue],'''','`'))+'''','null')+',',
isnull(''''+convert(varchar(max),replace([HighValue],'''','`'))+'''','null')+')'
from cem.DispositionClause

print 'set identity_insert cem.DispositionClause off

set identity_insert cem.DispositionInList on
insert into cem.DispositionInList (DispositionInListID,DispositionClauseID,ListValue)
values'

-- DispositionInListID,DispositionClauseID,ListValue
select ',('+
isnull(''''+convert(varchar(max),[DispositionInListID])+'''','null')+',',
isnull(''''+convert(varchar(max),[DispositionClauseID])+'''','null')+',',
isnull(''''+convert(varchar(max),replace([ListValue],char(7),'char(7)'))+'''','null')+')'
from cem.DispositionInList

print 'set identity_insert cem.DispositionInList off'

declare @sql varchar(max)=''
select @sql = @sql + 'exec sp_helptext [cem.'+name+']
'
from sys.procedures 
where name like 'ExportPostProcess000%' 
order by name

exec (@SQL)

