/*
S39_US5 Fix Missing Return Dates.sql

user story 5 Fix Missing Return Dates
As the Director of Research, I want the issue with missing return dates identified and resolved, so that we capture results from all returns.

Dave Gilsdorf

QP_Prod:
CREATE TABLE dbo.Questionform_Missing_datReturned 
CREATE TRIGGER [dbo].[trg_QuestionForm_temp_MissingReturnDates] 

*/
use QP_Prod
go
if not exists (select * from sys.tables where name = 'Questionform_Missing_datReturned')
	CREATE TABLE dbo.Questionform_Missing_datReturned 
	([QfMissingDatreturned_id] int identity(1,1)
	, [logDate] datetime
	, [host_name] nvarchar(256)
	, [program_name] nvarchar(256)
	, [login_name] nvarchar(256)
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