/*
S39_US5 Fix Missing Return Dates.sql

user story 5 Fix Missing Return Dates
As the Director of Research, I want the issue with missing return dates identified and resolved, so that we capture results from all returns.

Dave Gilsdorf

QP_Prod:
CREATE JOB (see below)
CREATE TABLE dbo.Questionform_Missing_datReturned 
CREATE TRIGGER [dbo].[trg_QuestionForm_temp_MissingReturnDates] 
CREATE INDEX on dbo.ScanningResets

*/
/* Create a single-step job on NRC10 that executes on QP_Prod and executes the following code every 10 minutes between 8:00 AM and 5:00 PM, Monday through Friday.
*/
declare @QfMissingDatreturned_id int
select @QfMissingDatreturned_id=min(QfMissingDatreturned_id) from Questionform_Missing_datReturned where isResetLitho is NULL

if @QfMissingDatreturned_id is NULL -- No new records
	RETURN

UPDATE QFMR 
set isResetLitho = case when SR.strLithocode is NULL then 0 else 1 end
FROM Questionform_Missing_datReturned QFMR
INNER JOIN SentMailing SM on QFMR.SentMail_id=SM.SentMail_id
LEFT JOIN ScanningResets SR on sm.strLithocode=SR.strLithocode
where QFMR.isResetLitho is NULL

if @@rowcount>0
begin
	if exists (select * from Questionform_Missing_datReturned where QfMissingDatreturned_id>@QfMissingDatreturned_id AND isResetLitho=0)
	begin
		declare @sql varchar(200) = 'select * from Questionform_Missing_datReturned where isResetLitho=0 AND QfMissingDatreturned_id>'+convert(varchar,@QfMissingDatreturned_id)
		EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',
			@recipients='dgilsdorf@nationalresearch.com',
			@subject='New records in Questionform_Missing_datReturned',
			@body=@sql,
			@body_format='Text',
			@importance='High'
	end
end
/*  /end of job code */

use QP_Prod
go
if not exists (select * from sys.indexes where object_id=object_id('ScanningResets') and name = 'IDX_ScanningResets_strLithocode')
	CREATE INDEX IDX_ScanningResets_strLithocode on dbo.ScanningResets (strLithocode) INCLUDE (datReturned)
go
if not exists (select * from sys.tables where name = 'Questionform_Missing_datReturned')
	CREATE TABLE dbo.Questionform_Missing_datReturned 
	([QfMissingDatreturned_id] int identity(1,1)
	, [logDate] datetime
	, [host_name] nvarchar(256)
	, [program_name] nvarchar(256)
	, [login_name] nvarchar(256)
	, [isResetLitho] tinyint
	, [Notes] varchar(500)
	, [QUESTIONFORM_ID] int
	, [SENTMAIL_ID] int
	, [SAMPLEPOP_ID] int
	, [DATRETURNED] datetime
	, [SURVEY_ID] int
	, [UnusedReturn_id] int
	, [datUnusedReturn] datetime
	, [datResultsImported] datetime
	, [strSTRBatchNumber] varchar(8)
	, [intSTRLineNumber] int
	, [ReceiptType_id] int
	, [strScanBatch] varchar(100))
go
if exists (select * from sys.objects where name = 'trg_QuestionForm_temp_MissingReturnDates' and type='tr')
	drop trigger [dbo].[trg_QuestionForm_temp_MissingReturnDates] 
go
CREATE TRIGGER [dbo].[trg_QuestionForm_temp_MissingReturnDates] 
   ON  [dbo].[QUESTIONFORM] 
   AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON

	declare @host_name nvarchar(256), @program_name nvarchar(256), @login_name nvarchar(256), @now datetime
	set @now=getdate()

	begin try
		select @host_name=host_name, @program_name=program_name, @login_name=login_name
		from sys.dm_exec_sessions 
		where session_id=@@spid
	end try
	begin catch
		select @host_name=ERROR_NUMBER(), @program_name=left(ERROR_MESSAGE(),256), @login_name=system_user
	end catch

	insert into Questionform_Missing_datReturned ([logDate], [host_name], [program_name], [login_name], [QUESTIONFORM_ID], [SENTMAIL_ID], [SAMPLEPOP_ID], [DATRETURNED], [SURVEY_ID], [UnusedReturn_id], [datUnusedReturn], [datResultsImported], [strSTRBatchNumber], [intSTRLineNumber], [ReceiptType_id], [strScanBatch])
	select @now, @host_name, @program_name, @login_name, d.QUESTIONFORM_ID, d.SENTMAIL_ID, d.SAMPLEPOP_ID, d.DATRETURNED, d.SURVEY_ID, d.UnusedReturn_id, d.datUnusedReturn, d.datResultsImported, d.strSTRBatchNumber, d.intSTRLineNumber, d.ReceiptType_id, d.strScanBatch
	from deleted d
	inner join questionform qf on d.questionform_id=qf.questionform_id
	where qf.datreturned is null 
	and qf.datUnusedReturn is null
	and qf.strScanBatch is not null 
	and qf.strScanBatch<>''

END
go