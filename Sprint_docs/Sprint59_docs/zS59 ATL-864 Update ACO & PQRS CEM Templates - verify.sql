
use NRC_Datamart_Extracts

GO

DECLARE @exportTemplateName varchar(200) = 'ACO CAHPS'
DECLARE @exportTemplateVersionMajor varchar(100) = 'ACO-12'
DECLARE @exportTemplateVersionMinor int = 2
DECLARE @templateID int

SELECT @templateID = ExportTemplateID FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor and ExportTemplateVersionMinor = @exportTemplateVersionMinor

SELECT *
FROM CEM.ExportTemplate
WHERE ExportTemplateID = @templateID


SELECT [ExportTemplateColumnID]
      ,ets.[ExportTemplateSectionID]
	  ,ets.ExportTemplateSectionName
      ,[ExportTemplateColumnDescription]
      ,[ColumnOrder]
      ,[DatasourceID]
      ,[ExportColumnName]
      ,[SourceColumnName]
      ,[SourceColumnType]
      ,[AggregateFunction]
      ,[DispositionProcessID]
      ,[FixedWidthLength]
      ,[ColumnSetKey]
      ,[FormatID]
      ,[MissingThresholdPercentage]
      ,[CheckFrequencies]
  FROM [CEM].[ExportTemplateColumn] etc
  INNER JOIN [CEM].[ExportTemplateSection] ets on ets.ExportTemplateSectionID = etc.ExportTemplateSectionID
  where ets.ExportTemplateID = @templateID
  order by ExportTemplateSectionID, ColumnOrder


SELECT etcr.*
  FROM [CEM].[ExportTemplateColumnResponse] etcr
  INNER JOIN [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateColumnID = etcr.ExportTemplateColumnID
  INNER JOIN [CEM].[ExportTemplateSection] ets on ets.ExportTemplateSectionID = etc.ExportTemplateSectionID
  where ets.ExportTemplateID = @templateID
  and etc.ExportColumnName = 'LANG_PROT'
