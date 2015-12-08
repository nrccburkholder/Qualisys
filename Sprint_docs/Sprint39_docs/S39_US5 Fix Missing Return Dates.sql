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
if not exists (select * from sys.tables where name = 'Questionform_connection_info')
	create table dbo.Questionform_connection_info (
	 [Questionform_connection_info_id] int identity(1,1)
	,[logDate] datetime
	,[session_id] smallint
	,[login_time] datetime
	,[host_name] nvarchar(256)
	,[program_name] nvarchar(256)
	,[host_process_id] int
	,[client_version] int
	,[client_interface_name] nvarchar(64)
	,[security_id] varbinary(85)
	,[login_name] nvarchar(256)
	,[nt_domain] nvarchar(256)
	,[nt_user_name] nvarchar(256)
	,[status] nvarchar(60)
	,[context_info] varbinary(128)
	,[cpu_time] int
	,[memory_usage] int
	,[total_scheduled_time] int
	,[total_elapsed_time] int
	,[endpoint_id] int
	,[last_request_start_time] datetime
	,[last_request_end_time] datetime
	,[reads] bigint
	,[writes] bigint
	,[logical_reads] bigint
	,[is_user_process] bit
	,[text_size] int
	,[language] nvarchar(256)
	,[date_format] nvarchar(6)
	,[date_first] smallint
	,[quoted_identifier] bit
	,[arithabort] bit
	,[ansi_null_dflt_on] bit
	,[ansi_defaults] bit
	,[ansi_warnings] bit
	,[ansi_padding] bit
	,[ansi_nulls] bit
	,[concat_null_yields_null] bit
	,[transaction_isolation_level] smallint
	,[lock_timeout] int
	,[deadlock_priority] int
	,[row_count] bigint
	,[prev_error] int
	,[original_security_id] varbinary(85)
	,[original_login_name] nvarchar(256)
	,[last_successful_logon] datetime
	,[last_unsuccessful_logon] datetime
	,[unsuccessful_logons] bigint
	,[group_id] int
	)
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

	insert into Questionform_connection_info 
	select @now, *
	from sys.dm_exec_sessions 
	where session_id=@@spid

	insert into Questionform_Missing_datReturned ([logDate], [host_name], [program_name], [login_name], [QUESTIONFORM_ID], [SENTMAIL_ID], [SAMPLEPOP_ID], [DATRETURNED], [SURVEY_ID], [UnusedReturn_id], [datUnusedReturn], [datResultsImported], [strSTRBatchNumber], [intSTRLineNumber], [ReceiptType_id], [strScanBatch])
	select @now, @host_name, @program_name, @login_name, d.QUESTIONFORM_ID, d.SENTMAIL_ID, d.SAMPLEPOP_ID, d.DATRETURNED, d.SURVEY_ID, d.UnusedReturn_id, d.datUnusedReturn, d.datResultsImported, d.strSTRBatchNumber, d.intSTRLineNumber, d.ReceiptType_id, d.strScanBatch
	from deleted d
	inner join questionform qf on d.questionform_id=qf.questionform_id
	--leaving this commented out on PRIME so we can make sure the various apps' connections have access to sys.dm_exec_sessions
	--where qf.datreturned is null 
	--and qf.datUnusedReturn is null
	--and qf.strScanBatch is not null 
	--and qf.strScanBatch<>''
END
go