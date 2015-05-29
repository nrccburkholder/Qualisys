/*
	S26.US11	ICHCAHPS submission file changes
		as an authorized ICHCAHPS vendor, we must remove records from the submission file that were sampled in error


	T11.3	create new template to match current specs

Dave Gilsdorf

NRC_DataMart_Extracts:
INSERT INTO CEM.ExportTemplate 
INSERT INTO CEM.ExportTemplateSection 
INSERT INTO CEM.ExportTemplateColumn 
INSERT INTO CEM.ExportTemplateColumnResponse 
INSERT INTO CEM.DispositionProcess 
INSERT INTO CEM.DispositionClause 
INSERT INTO CEM.DispositionInList 
CREATE PROCEDURE [CEM].[ExportPostProcess00000002]

*/

select *, 0 as [newID] 
into #ET 
from cem.ExportTemplate 
where ExportTemplateID=1

select *, 0 as [newID] 
into #ETS 
from cem.ExportTemplateSection 
where ExportTemplateID=1

select *, 0 as [newID] 
into #ETDR 
from cem.ExportTemplateDefaultResponse 
where ExportTemplateID=1

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

-- TODO: should the values in #ETC.ExportTemplateColumnDescription (Q1, Q2 ... Q65) be updated?
update #ETC set ExportTemplateColumnDescription='Q57' where SourceColumnName='MasterQuestionCore=51203' -- language-spoken
update #ETC set ExportTemplateColumnDescription='Q58-phone' where SourceColumnName='MasterQuestionCore=51261' -- not-hispanic-phone
update #ETC set ExportTemplateColumnDescription='Q58a-phone' where SourceColumnName='MasterQuestionCore=51262' -- hispanic-phone
update #ETC set ExportTemplateColumnDescription='Q58-mail' where SourceColumnName='MasterQuestionCore=51204' -- not-hispanic-mail
update #ETC set ExportTemplateColumnDescription='Q59-phone' where SourceColumnName='MasterQuestionCore=51263' -- race-*-phone
update #ETC set ExportTemplateColumnDescription='Q59a-phone' where SourceColumnName='MasterQuestionCore=51264' -- race-asian-*-phone
update #ETC set ExportTemplateColumnDescription='Q59b-phone' where SourceColumnName='MasterQuestionCore=51265' -- race-pacific-*-phone
update #ETC set ExportTemplateColumnDescription='Q59-mail' where SourceColumnName='MasterQuestionCore=51205' -- race-mail
update #ETC set ExportTemplateColumnDescription='Q60' where SourceColumnName='MasterQuestionCore=47212' -- help-you
update #ETC set ExportTemplateColumnDescription='Q61' where SourceColumnName='MasterQuestionCore=47213' -- who-helped
update #ETC set ExportTemplateColumnDescription='Q62' where SourceColumnName='MasterQuestionCore=47214' -- how-helped


---- DOCUMENTED SUBMISSION FILE CHANGES - SPRING 2015 ----

-- Removed <age> element (was Q56)
-- Removed <sex> element (was Q57)
-- Removed <speak-english> element (was Q59)
-- Removed <speak-other-language> element (was Q60)
delete from #etcr where ExportTemplateColumnID in (select ExportTemplateColumnID from #etc where exportcolumnname in ('age','sex','speak-english','speak-other-language'))
delete from #etc where exportcolumnname in ('age','sex','speak-english','speak-other-language')


-- <language>: removed “M” as a valid value.
delete from #etcr 
where ExportTemplateColumnID in (select ExportTemplateColumnID from #etc where exportcolumnname in ('language'))
and RecodeValue='M'


-- Changed <language-spoken> element (was Q60a, now Q57). Valid values have changed.
declare @etcid int
select @etcid=ExportTemplateColumnID 
from #ETC
where exportcolumnname = 'language-spoken'

delete
from #ETCR
where ExportTemplateColumnID = @etcid

insert into #ETCR (ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel)
values (@etcid, 1, NULL, '1', 'English')
	,  (@etcid, 2, NULL, '2', 'Spanish')
	,  (@etcid, 3, NULL, '3', 'Chinese')
	,  (@etcid, 4, NULL, '4', 'Samoan')
	,  (@etcid, 5, NULL, '5', 'Russian')
	,  (@etcid, 6, NULL, '6', 'Vietnamese')
	,  (@etcid, 7, NULL, '7', 'Portuguese')
	,  (@etcid, 8, NULL, '8', 'Some other language')
	,  (@etcid, -9, NULL, 'X', 'NOT APPLICABLE')
	--,(@etcid, 'M', NULL, 'M', 'MISSING/DK') --> taken care of in the post-process proc


-- Added “X” as a valid value for <race-noneofabove-phone>

-- TODO: when would race-noneofabove-phone be set to 'X' (not applicable)?
-- would this be done in the post-processing proc?

select *
from #etc 
where exporttemplatecolumnid=81

select *
from #ETCR
where exporttemplatecolumnid=81


---- INSERT THE MODIFIED TEMPLATE INTO THE TABLES ----

begin tran
declare @newID int

INSERT INTO CEM.ExportTemplate (ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType)
select ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType
from #ET

set @newID = SCOPE_IDENTITY()
update #ET set ExportTemplateID=@newID
update #ETS set ExportTemplateID=@newID
update #ETDR set ExportTemplateID=@newID

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

select top 1 @oldID=DispositionInListID from #DC where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionInList (DispositionClauseID,ListValue)
	select DispositionClauseID,ListValue
	from #DIL
	where DispositionInListID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DIL set [newid]=@newID where DispositionInListID=@oldID
	
	select top 1 @oldID=DispositionInListID from #DC where [newid]=0
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


---- MAKE A COPY OF THE POST-PROCESS PROC ----

USE [NRC_DataMart_Extracts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CEM].[ExportPostProcess00000002]
@ExportQueueID int
as
update CEM.ExportDataset00000002
set [patientresponse.race-white-phone]='M', [patientresponse.race-african-amer-phone]='M', [patientresponse.race-amer-indian-phone]='M', [patientresponse.race-asian-phone]='M', 
	[patientresponse.race-nativehawaiian-pacific-phone]='M', [patientresponse.race-noneofabove-phone]='M' 
where len([patientresponse.race-white-phone]+[patientresponse.race-african-amer-phone]+[patientresponse.race-amer-indian-phone]+[patientresponse.race-asian-phone]
	+[patientresponse.race-nativehawaiian-pacific-phone]+[patientresponse.race-noneofabove-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-asian-indian-phone]='M', [patientresponse.race-chinese-phone]='M', [patientresponse.race-filipino-phone]='M', [patientresponse.race-japanese-phone]='M', 
	[patientresponse.race-korean-phone]='M', [patientresponse.race-vietnamese-phone]='M', [patientresponse.race-otherasian-phone]='M', [patientresponse.race-noneofabove-asian-phone]='M'
where len([patientresponse.race-asian-indian-phone]+[patientresponse.race-chinese-phone]+[patientresponse.race-filipino-phone]+[patientresponse.race-japanese-phone]
	+[patientresponse.race-korean-phone]+[patientresponse.race-vietnamese-phone]+[patientresponse.race-otherasian-phone]+[patientresponse.race-noneofabove-asian-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-nativehawaiian-phone]='M', [patientresponse.race-guam-chamarro-phone]='M', [patientresponse.race-samoan-phone]='M', [patientresponse.race-otherpacificislander-phone]='M',
	[patientresponse.race-noneofabove-pacific-phone]='M'
where len([patientresponse.race-nativehawaiian-phone]+[patientresponse.race-guam-chamarro-phone]+[patientresponse.race-samoan-phone]+[patientresponse.race-otherpacificislander-phone]
	+[patientresponse.race-noneofabove-pacific-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-white-mail]='M', [patientresponse.race-african-amer-mail]='M', [patientresponse.race-amer-indian-mail]='M', [patientresponse.race-asian-indian-mail]='M', 
	[patientresponse.race-chinese-mail]='M', [patientresponse.race-filipino-mail]='M', [patientresponse.race-japanese-mail]='M', [patientresponse.race-korean-mail]='M', 
	[patientresponse.race-vietnamese-mail]='M', [patientresponse.race-otherasian-mail]='M', [patientresponse.race-nativehawaiian-mail]='M', [patientresponse.race-guamanian-chamorro-mail]='M', 
	[patientresponse.race-samoan-mail]='M', [patientresponse.race-other-pacificislander-mail]='M'
where len([patientresponse.race-white-mail]+[patientresponse.race-african-amer-mail]+[patientresponse.race-amer-indian-mail]+[patientresponse.race-asian-indian-mail]
	+[patientresponse.race-chinese-mail]+[patientresponse.race-filipino-mail]+[patientresponse.race-japanese-mail]+[patientresponse.race-korean-mail]+[patientresponse.race-vietnamese-mail]
	+[patientresponse.race-otherasian-mail]+[patientresponse.race-nativehawaiian-mail]+[patientresponse.race-guamanian-chamorro-mail]+[patientresponse.race-samoan-mail]
	+[patientresponse.race-other-pacificislander-mail])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.help-answer]='M', [patientresponse.help-other]='M', [patientresponse.help-read]='M', [patientresponse.help-translate]='M', [patientresponse.help-wrote]='M'
where len([patientresponse.help-answer]+[patientresponse.help-other]+[patientresponse.help-read]+[patientresponse.help-translate]+[patientresponse.help-wrote])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [header.dcstart-date]='20150324'
where [header.dcstart-date]=''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [header.dcend-date]='20150714'
where [header.dcend-date]=''
and ExportQueueID=@ExportQueueID
GO
