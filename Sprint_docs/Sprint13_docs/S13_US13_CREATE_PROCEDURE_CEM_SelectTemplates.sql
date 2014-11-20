use NRC_Datamart

IF EXISTS (SELECT * 
		   FROM sys.procedures p
		   INNER JOIN sys.schemas s on s.schema_id = p.schema_id
		   where s.name = 'CEM' 
		   and p.name = 'SelectTemplates')
	DROP PROCEDURE CEM.SelectTemplates

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Butler
-- Create date: 11/14/2014
-- Description:	Returns a template
-- =============================================
CREATE PROCEDURE CEM.SelectTemplates
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--Template
	SELECT [ExportTemplateID]
		  ,[ExportTemplateName]
		  ,[SurveyTypeID]
		  ,[SurveySubTypeID]
		  ,[ValidDateType]
		  ,[ValidStartDate]
		  ,[ValidEndDate]
		  ,[ExportTemplateVersionMajor]
		  ,[ExportTemplateVersionMinor]
		  ,[CreatedBy]
		  ,[CreatedOn]
		  ,[ClientID]
		  ,[DefaultNotificationID]
		  ,[DefaultNamingConvention]
		  ,[State]
		  ,[ReturnsOnly]
		  ,[SampleUnitCahpsTypeID]
		  ,[XMLSchemaDefinition]
		  ,[isOfficial]
		  ,[DefaultFileMakerType]
	  FROM [CEM].[ExportTemplate] 


    -- Sections
	select ets.ExportTemplateSectionID
		,ets.ExportTemplateSectionName
		,ets.ExportTemplateID
		,ets.DefaultNamingConvention  
	from [CEM].[ExportTemplateSection] ets


	-- Columns
	select ets.ExportTemplateID
		,ets.ExportTemplateSectionID
		,etc.ExportTemplateColumnID
		,etc.ExportTemplateColumnDescription
		,etc.ColumnOrder
		,etc.DatasourceID
		,etc.ExportColumnName
		,etc.DispositionProcessID
		,etc.FixedWidthLength
		,etc.ColumnSetKey
		,etc.FormatID
		,etc.MissingThresholdPercentage
		,etc.CheckFrequencies
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID

	-- Column Responses
	select distinct
		ets.ExportTemplateID
		,ets.ExportTemplateSectionID
		,etcr.ExportTemplateColumnResponseID
		,etcr.ExportTemplateColumnID
		,etcr.ExportColumnName
		,etcr.RawValue
		,etcr.RecodeValue
		,etcr.ResponseLabel
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	left join [CEM].[ExportTemplateColumnResponse] etcr on etcr.ExportTemplateColumnID = etcr.ExportTemplateColumnID


END
GO
