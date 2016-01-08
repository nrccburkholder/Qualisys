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
