/*
S34 US23	As a compliance analyst I want the ACO submission file to be created in CEM using the newest version of submission file layout

Changing PROCEDURE [CEM].[SelectExportTemplateColumn] to include SourceColumnType

ALTER PROCEDURE [CEM].[SelectExportTemplateColumn]

*/

USE [NRC_Datamart_Extracts]
GO
/****** Object:  StoredProcedure [CEM].[SelectExportTemplateColumn]    Script Date: 9/17/2015 11:56:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- Columns
ALTER PROCEDURE [CEM].[SelectExportTemplateColumn]
@exportTemplateId as int = null,
@exportTemplateSectionId as int = null,
@exportTemplateColumnID as int = null,
@exportColumnName as varchar(100) = null,
@ColumnSetKey as int = null,
@DataSourceID as int = null
AS
BEGIN
	select ets.ExportTemplateID
	,ets.ExportTemplateSectionID
	,etc.ExportTemplateColumnID
	,etc.ExportTemplateColumnDescription
	,etc.ColumnOrder
	,etc.DatasourceID
	,etc.ExportColumnName
	,etc.SourceColumnType
	,etc.DispositionProcessID
	,etc.FixedWidthLength
	,etc.ColumnSetKey
	,etc.FormatID
	,etc.MissingThresholdPercentage
	,etc.CheckFrequencies
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
		((@exportTemplateSectionId is null) or (ets.ExportTemplateSectionID=@exportTemplateSectionId)) and
		((@exportTemplateColumnId is null) or (etc.ExportTemplateColumnId = @exportTemplateColumnId)) and
		((@exportColumnName is null) or (etc.ExportColumnName = @exportColumnName)) and
		((@ColumnSetKey is null) or (etc.ColumnSetKey=@ColumnSetKey)) and
		((@DataSourceId is null) or (etc.DataSourceId=@DataSourceId))
END
