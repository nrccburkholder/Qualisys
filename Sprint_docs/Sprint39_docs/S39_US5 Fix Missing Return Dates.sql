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
exec dbo.temp_InvestigateMissingReturns
/*  /end of job code */
go
use QP_Prod
go
if exists (select * from sys.procedures where name = 'temp_InvestigateMissingReturns')
	drop procedure [dbo].[temp_InvestigateMissingReturns] 
go
CREATE procedure dbo.temp_InvestigateMissingReturns
as
begin

	update Questionform_Missing_datReturned set notes='' where notes is null

	update qfmr 
	set notes = notes + 'in dbo.ScanningResets - '
	from Questionform_Missing_datReturned qfmr
	inner join sentmailing sm on qfmr.sentmail_id=sm.sentmail_id
	inner join ScanningResets sr on sm.strlithocode=sr.strlithocode
	where notes not like '%in dbo.ScanningResets -%'

	update qfmr 
	set notes = notes + 'in dbo.QSIDataForm - '
	from Questionform_Missing_datReturned qfmr
	inner join QSIDataForm qdf on qfmr.questionform_id=qdf.questionform_id
	where notes not like '%in dbo.QSIDataForm -%'

	update qfmr 
	set notes = notes + 'form verified on '+left(convert(varchar,qdf.dateverified,1),5)+' - '
	from Questionform_Missing_datReturned qfmr
	inner join QSIDataForm qdf on qfmr.questionform_id=qdf.questionform_id
	where qdf.dateverified is not null
	and notes not like '%form verified on%'

	update qfmr 
	set notes = notes + 'batch finalized on '+left(convert(varchar,qdb.datefinalized,1),5)+' - '
	from Questionform_Missing_datReturned qfmr
	inner join QSIDataForm qdf on qfmr.questionform_id=qdf.questionform_id
	inner join QSIDataBatch qdb on qdf.batch_id=qdb.batch_id
	where qdb.datefinalized is not null
	and notes not like '%batch finalized on%'

	update qfmr 
	set notes = notes + 'datReturned set to '+left(convert(varchar,qf.datReturned,1),5)+' - Resolved. '
	from Questionform_Missing_datReturned qfmr
	inner join questionform qf on qfmr.questionform_id=qf.questionform_id
	where qf.datReturned is not null
	and notes not like '%datReturned set to %'

	update qfmr 
	set notes = notes + 'datUnusedReturned set to '+left(convert(varchar,qf.datUnusedReturn,1),5)+' - Resolved. '
	from Questionform_Missing_datReturned qfmr
	inner join questionform qf on qfmr.questionform_id=qf.questionform_id
	where qf.datUnusedReturn is not null
	and notes not like '%datUnusedReturned set to %'

	declare @QfMissingDatreturned_id int
	declare @MailTo varchar(100) = 'dgilsdorf@nationalresearch.com,tbutler@nationalresearch.com'
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
		if exists (select * from Questionform_Missing_datReturned where QfMissingDatreturned_id>@QfMissingDatreturned_id and Notes='')
		begin
			declare @sql varchar(200) = 'select * from Questionform_Missing_datReturned where isResetLitho=0 AND QfMissingDatreturned_id>='+convert(varchar,@QfMissingDatreturned_id)
			declare @sql2 varchar(max) = 'select count(*) as [count], count(distinct questionform_id) as [count questionform_id], convert(varchar,min(logDate),1) as oldest, convert(varchar,max(logDate),1) as newest, notes
											from Questionform_Missing_datReturned qfmr
											group by notes'
			EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',
				@recipients=@mailto,
				@subject='New records in Questionform_Missing_datReturned',
				@body=@sql,
				@query=@sql2,
				@execute_query_database='qp_prod',
				@attach_query_result_as_file=01,
				@body_format='Text',
				@importance='High'
		end
	end
end
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
if not exists (select * from sys.columns where object_name(object_id)='Questionform_Missing_datReturned' and name='newDATRETURNED')
	ALTER TABLE dbo.Questionform_Missing_datReturned ADD
		  [newDATRETURNED] datetime
		, [newUnusedReturn_id] int
		, [newdatUnusedReturn] datetime
		, [newdatResultsImported] datetime
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

	insert into Questionform_Missing_datReturned ([logDate], [host_name], [program_name], [login_name], [QUESTIONFORM_ID], [SENTMAIL_ID], [SAMPLEPOP_ID], [DATRETURNED], [SURVEY_ID], [UnusedReturn_id], [datUnusedReturn], [datResultsImported], [strSTRBatchNumber], [intSTRLineNumber], [ReceiptType_id], [strScanBatch]
	, [newDATRETURNED], [newUnusedReturn_id], [newdatUnusedReturn], [newdatResultsImported])
	select @now, @host_name, @program_name, @login_name, d.QUESTIONFORM_ID, d.SENTMAIL_ID, d.SAMPLEPOP_ID, d.DATRETURNED, d.SURVEY_ID, d.UnusedReturn_id, d.datUnusedReturn, d.datResultsImported, d.strSTRBatchNumber, d.intSTRLineNumber, d.ReceiptType_id, d.strScanBatch
		, qf.DATRETURNED, qf.UnusedReturn_id, qf.datUnusedReturn, qf.datResultsImported
	from deleted d
	inner join questionform qf on d.questionform_id=qf.questionform_id
	where qf.datreturned is null 
	and qf.datUnusedReturn is null
	and qf.strScanBatch is not null 
	and qf.strScanBatch<>''

END
go