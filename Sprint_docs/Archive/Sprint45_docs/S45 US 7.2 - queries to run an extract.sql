/*
	S45 US 7 Nightly Hospice File Extract 
	As a developer, I need to create a sql agent job on CatDB2 that creates a Hospice CAHPS extract every night so that we have a mechanism for identifying incorrect data well before its time to submit it
	
	7.2 - Create a job that inserts Hospice CAHPS records into CEM.ExportQueue and CEM.ExportQueueSurvey and runs CEM.PullExportData. Don't enable in prod yet.
	
*/
use NRC_Datamart_Extracts
go
if exists (select * from sys.procedures where schema_name(schema_id)='CEM' and name='SetSubmissionDateFields')
	drop procedure CEM.SetSubmissionDateFields
go
create procedure CEM.SetSubmissionDateFields
@ExportQueueID int, @YrField varchar(100), @MoField varchar(100), @DayField varchar(100), @SubNumField varchar(100)
as
declare @SQL nvarchar(max), @ExportTemplateID char(8), @YearWidth tinyint

select @ExportTemplateID=right('00000000'+convert(varchar,et.ExportTemplateID),8)
from CEM.ExportQueue eq
inner join CEM.ExportTemplate et on eq.ExportTemplateName=et.ExportTemplateName
									and eq.ExportTemplateVersionMajor=et.ExportTemplateVersionMajor
									and eq.ExportTemplateVersionMinor=et.ExportTemplateVersionMinor
where eq.ExportQueueID=@ExportQueueID

select @YearWidth = FixedWidthLength
from CEM.exporttemplate_view
where ExportTemplateID=@ExportTemplateID
and ExportTemplateSectionName+'.'+ExportColumnName=@YrField

set @SQL = 'update eds
set ['+@YrField+']=right(year(getdate()), @YW)
	,['+@MoField+']=right(100+month(getdate()),2)
	,['+@DayField+']=right(100+day(getdate()),2)
from CEM.ExportDataset'+@ExportTemplateID+' eds
where ExportQueueID=@QueueID'
EXECUTE sp_executesql @SQL, N'@QueueID int, @YW tinyint', @QueueID = @ExportQueueID, @YW = @YearWidth;

set @SQL = 'declare @subno int
select @subno = max(['+@SubNumField+'])
from CEM.ExportDataset'+@ExportTemplateID+' eds
where ExportQueueID<@QueueID
and ['+@YrField+']=right(year(getdate()), @YW)
and ['+@MoField+']=month(getdate())
and ['+@DayField+']=day(getdate())

if @subno is not null
	update eds
	set ['+@SubNumField+']=@subno+1
	from CEM.ExportDataset'+@ExportTemplateID+' eds
	where ExportQueueID=@QueueID'
EXECUTE sp_executesql @SQL, N'@QueueID int, @YW tinyint', @QueueID = @ExportQueueID, @YW = @YearWidth;

declare @FileNamePattern varchar(max), @FileName varchar(max)
declare @colname varchar(200)
select @FileNamePattern = DefaultNamingConvention, @FileName=''''+DefaultNamingConvention+''''
from CEM.ExportTemplate 
where ExportTemplateID=@ExportTemplateID

while charindex('{',@FileNamePattern) > 0
begin
	set @colname = substring(@FileNamePattern, 1 + charindex('{', @FileNamePattern),  charindex('}', @FileNamePattern) - charindex('{', @FileNamePattern) - 1)
	set @FileName = replace(@FileName,@FileName,'replace('+@FileName+',''{'+@colname+'}'',['+@colname+'])')
	set @FileNamePattern = replace(@FileNamePattern,'{'+@colname+'}','')
end
set @SQL = 'update CEM.ExportDataset'+@ExportTemplateID+' set FileMakerName='+@FileName+' where exportqueueid=@QueueID'
EXECUTE sp_executesql @SQL, N'@QueueID int', @QueueID = @ExportQueueID
go
declare @ExportTemplateName varchar(200), @ExportTemplateVersionMajor varchar(100), @ExportTemplateID char(8)
select @ExportTemplateName='CAHPS Hospice', @ExportTemplateVersionMajor='2.1.2'

select et.ExportTemplateID, et.ExportTemplateName, et.ExportTemplateVersionMajor, et.ExportTemplateVersionMinor, s.SurveyID, s.SurveyTypeID, s.CahpsTypeID, min(sp.servicedate) as minServicedate, max(sp.servicedate) as maxServicedate, count(*) as cnt
into #s
from CEM.exporttemplate et 
inner join NRC_Datamart.dbo.survey s on s.SurveyTypeID=et.SurveyTypeID
inner join NRC_Datamart.dbo.sampleunit su on su.surveyid=s.surveyid
inner join NRC_Datamart.dbo.selectedsample sel on sel.sampleunitid=su.sampleunitid
inner join NRC_Datamart.dbo.samplepopulation sp on sp.SamplePopulationID=sel.SamplePopulationID and sp.servicedate between et.ValidStartDate and et.ValidEndDate
where et.ExportTemplateName=@ExportTemplateName
and et.ExportTemplateVersionMajor=@ExportTemplateVersionMajor
group by et.ExportTemplateID, et.ExportTemplateName, et.ExportTemplateVersionMajor, et.ExportTemplateVersionMinor, s.SurveyID, s.SurveyTypeID, s.CahpsTypeID

-- if there are different minor versions of the template, we want to use the most recent one
delete from #s where ExportTemplateVersionMinor < (select max(ExportTemplateVersionMinor) from #s)

select @ExportTemplateID = right('00000000' + convert(varchar,ExportTemplateID),8) from #s

declare @ExportQueueID int
insert into CEM.ExportQueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select s.ExportTemplateName,s.ExportTemplateVersionMajor,s.ExportTemplateVersionMinor,min(minServiceDate),max(maxServiceDate),ReturnsOnly,getdate()
from #s s
inner join CEM.ExportTemplate et on s.ExportTemplateID=et.ExportTemplateID
group by s.ExportTemplateName,s.ExportTemplateVersionMajor,s.ExportTemplateVersionMinor,ReturnsOnly
set @ExportQueueID = SCOPE_IDENTITY()

insert into CEM.ExportQueueSurvey (ExportQueueID, SurveyID)
select @ExportQueueID, surveyid
from #s

exec CEM.PullExportData @ExportQueueID

exec CEM.SetSubmissionDateFields @ExportQueueID, 'vendordata.file-submission-yr', 'vendordata.file-submission-month', 'vendordata.file-submission-day', 'vendordata.file-submission-number'

declare @sql nvarchar(max)

set @SQL = 'insert into CEM.ExportQueueFile (ExportQueueID,FileState,FileMakerType,FileMakerName)
select distinct exportqueueid, 0, 1, filemakername
from CEM.ExportDataset'+@ExportTemplateID+' eds
where ExportQueueID=@ExportQueueID'
EXECUTE sp_executesql @SQL, N'@ExportQueueID int', @ExportQueueID;
go
