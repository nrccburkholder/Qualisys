
use NRC_DataMart_Extracts

GO

DECLARE @exportTemplateName varchar(200) 
DECLARE @exportTemplateVersionMajor varchar(100)

--SET @exportTemplateName = 'ACO CAHPS'
--SET @exportTemplateVersionMajor = 'ACO-12'

--SET @exportTemplateName = 'ACO CAHPS'
--SET @exportTemplateVersionMajor = 'ACO-9'

--SET @exportTemplateName = 'PQRS CAHPS'
--SET @exportTemplateVersionMajor = '1.0'

DECLARE @exportTemplateVersionMinor int = 2

DECLARE @templateID int

if exists (SELECT 1 FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor and ExportTemplateVersionMinor = @exportTemplateVersionMinor)
BEGIN


	SELECT @templateID = ExportTemplateID FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor and ExportTemplateVersionMinor = @exportTemplateVersionMinor

	select *
	into #ET 
	from cem.ExportTemplate 
	where ExportTemplateID=@templateID

	select *
	into #ETS 
	from cem.ExportTemplateSection 
	where ExportTemplateID=@templateID

	select *
	into #ETDR 
	from cem.ExportTemplateDefaultResponse 
	where ExportTemplateID=@templateID

	select etc.*
	into #ETC
	from cem.ExportTemplateColumn etc 
	where ExportTemplateSectionID in (select ExportTemplateSectionID from #ETS)

	select etcr.*
	into #ETCR
	from cem.ExportTemplateColumnResponse etcr
	where ExportTemplateColumnID in (select ExportTemplateColumnID from #ETC)

	select *
	into #DP
	from cem.dispositionprocess 
	where DispositionProcessID in (select DispositionProcessID from #ETC where DispositionProcessID is not null)

	select *
	into #DC
	from cem.dispositionclause 
	where DispositionProcessID in (select DispositionProcessID from #DP)

	select *
	into #DIL 
	from cem.dispositioninlist
	where dispositionclauseID in (select dispositionClauseID from #DC)

-- only delete if there isn't an exportqueue for this template
	if not exists (SELECT 1 
					FROM CEM.ExportQueue eq
					INNER JOIN #ET et on et.ExportTemplateName = eq.ExportTemplateName and et.ExportTemplateVersionMajor = eq.ExportTemplateVersionMajor and et.ExportTemplateVersionMinor = eq.ExportTemplateVersionMinor)
	BEGIN
						 
		delete 
		from cem.dispositioninlist
		where dispositionclauseID in (select dispositionInListID from #DIL)


		declare @maxdispositioninlistID int
			select @maxdispositioninlistID=max(dispositioninlistID) from cem.dispositioninlist
			DBCC CHECKIDENT ('cem.dispositioninlist', RESEED, @maxdispositioninlistID)

		delete
		from cem.dispositionclause 
		where DispositionProcessID in (select DispositionProcessID from #DP)

		declare @maxdispositionclauseID int
			select @maxdispositionclauseID=max(dispositionclauseID) from cem.dispositionclause
			DBCC CHECKIDENT ('cem.dispositionclause', RESEED, @maxdispositionclauseID)


		delete
		from cem.dispositionprocess 
		where DispositionProcessID in (select DispositionProcessID from #ETC where DispositionProcessID is not null)

		declare @maxdispositionprocessID int
			select @maxdispositionprocessID=max(dispositionprocessID) from cem.dispositionprocess
			DBCC CHECKIDENT ('cem.dispositionprocess', RESEED, @maxdispositionprocessID)

		delete
		from cem.ExportTemplateColumnResponse
		where ExportTemplateColumnID in (select ExportTemplateColumnID from #ETC)

		declare @maxExportTemplateColumnResponseID int
			select @maxExportTemplateColumnResponseID=max(ExportTemplateColumnResponseID) from cem.ExportTemplateColumnResponse
			DBCC CHECKIDENT ('cem.ExportTemplateColumnResponse', RESEED, @maxExportTemplateColumnResponseID)


		delete
		from cem.ExportTemplateColumn 
		where ExportTemplateSectionID in (select ExportTemplateSectionID from #ETS)

		declare @maxExportTemplateColumnID int
			select @maxExportTemplateColumnID=max(ExportTemplateColumnID) from cem.ExportTemplateColumn
			DBCC CHECKIDENT ('cem.ExportTemplateColumn', RESEED, @maxExportTemplateColumnID)

		delete
		from cem.ExportTemplateDefaultResponse 
		where ExportTemplateID=@templateID

		declare @maxExportTemplateDefaultResponseID int
			select @maxExportTemplateDefaultResponseID=max(ExportTemplateDefaultResponseID) from cem.ExportTemplateDefaultResponse 
			DBCC CHECKIDENT ('cem.ExportTemplateDefaultResponse', RESEED, @maxExportTemplateDefaultResponseID)

		delete
		from cem.ExportTemplateSection 
		where ExportTemplateID=@templateID

		declare @maxExportTemplateSectionID int
			select @maxExportTemplateSectionID=max(ExportTemplateSectionID) from CEM.ExportTemplateSection
			DBCC CHECKIDENT ('CEM.ExportTemplateSection', RESEED, @maxExportTemplateSectionID)

		delete
		from cem.ExportTemplate 
		where ExportTemplateID=@templateID

		declare @maxExportTemplateID int
			select @maxExportTemplateID=max(ExportTemplateID) from CEM.ExportTemplate
			DBCC CHECKIDENT ('CEM.ExportTemplate', RESEED, @maxExportTemplateID)

	END
END

DROP TABLE #ET
DROP TABLE #ETS
DROP TABLE #ETDR
DROP TABLE #ETC 
DROP TABLE #ETCR
DROP TABLE #DP
DROP TABLE #DC
DROP TABLE #DIL

GO