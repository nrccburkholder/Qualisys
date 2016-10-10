USE NRC_Datamart_Extracts

select * 
from CEM.ExportTemplate


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ExportTemplateColumnID]
      ,[ExportTemplateSectionID]
      ,[ExportTemplateColumnDescription]
      ,[ColumnOrder]
      ,[DatasourceID]
      ,[ExportColumnName]
      ,[SourceColumnName]
      ,[SourceColumnType]
      ,[DispositionProcessID]
      ,[FixedWidthLength]
      ,[ColumnSetKey]
      ,[FormatID]
      ,[MissingThresholdPercentage]
      ,[CheckFrequencies]
      ,[AggregateFunction]
  FROM [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn]
  where ExportTemplateSectionID = 23


  select *
  from [CEM].[ExportTemplateColumnResponse]
  where ExportTemplateColumnId in (
	  SELECT [ExportTemplateColumnID]
	  FROM [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn]
	  where ExportTemplateSectionID =23
	  )
  and exportTemplatecolumnId = 747


