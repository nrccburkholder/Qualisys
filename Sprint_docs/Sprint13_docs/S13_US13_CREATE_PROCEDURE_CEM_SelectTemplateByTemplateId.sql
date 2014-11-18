use NRC_Datamart

IF EXISTS (SELECT * 
		   FROM sys.procedures p
		   INNER JOIN sys.schemas s on s.schema_id = p.schema_id
		   where s.name = 'CEM' 
		   and p.name = 'SelectTemplateByTemplateId')
	DROP PROCEDURE CEM.SelectTemplateByTemplateId

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Butler
-- Create date: 11/14/2014
-- Description:	Returns a template
-- =============================================
CREATE PROCEDURE CEM.SelectTemplateByTemplateId
	@exportTemplateId int
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
	  WHERE ExportTemplateID = @exportTemplateId

    -- Sections
	select ets.ExportTemplateSectionID,ets.ExportTemplateSectionName,ets.ExportTemplateID,ets.DefaultNamingConvention  
	from [CEM].[ExportTemplateSection] ets
	where ets.ExportTemplateID=@exportTemplateId


	-- Columns
	select ets.ExportTemplateSectionID
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
	where ets.ExportTemplateID=@exportTemplateId

END
GO
