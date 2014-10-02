use qp_comments
go
if exists (select * from sys.procedures where name = 'tmp_FixSkippedMultiResponseAnswers')
	drop procedure tmp_FixSkippedMultiResponseAnswers
go
create procedure #FixSkippedMultiResponseAnswers
@survey_id int, @begindate datetime, @enddate datetime
as

--select @survey_id=9830, @begindate = '1/1/13', @enddate='12/31/14'

set nocount on

declare @study varchar(10)
select @study='s'+convert(varchar,study_id) 
from clientstudysurvey css
where survey_id=@survey_id

if object_id('tempdb..#tbl') is not null
	drop table #tbl

select ss.name+'.'+st.name as tblname
into #tbl
from sys.schemas ss 
inner join sys.tables st on ss.schema_id=st.schema_id
where ss.name=@study
and st.name like 'study_results_vertical_20___[1-4]'

if object_id('tempdb..#updt') is null
	create table #updt (tblname varchar(50), fldname varchar(15), samplepop_id int, sampleunit_id int,ResponseVal int, errorflg tinyint)

declare @tn varchar(50), @fn varchar(15), @sql varchar(max)

select top 1 @tn=tblname from #tbl
while @@rowcount>0
begin
	set @sql='insert into #updt
			select '''+@tn+''' as tblname
				, ''Q'' + RIGHT(''00000''+CONVERT(VARCHAR, srv.qstncore), 6) + CASE WHEN srv.intResponseVal%10000 BETWEEN 1 AND 26 THEN Char(96+(srv.intResponseVal%10000)) ELSE '''' END as fldname
				, srv.samplepop_id, srv.sampleunit_id, srv.intResponseVal, 0
			FROM   '+@tn+' srv 
				   INNER JOIN '+replace(@tn,'study_results_vertical','big_table')+' bt ON srv.sampleunit_id=bt.sampleunit_id and srv.samplepop_id=bt.samplepop_id
				   INNER JOIN sampleunit su ON srv.sampleunit_id = su.sampleunit_id 
				   INNER JOIN questions q ON su.survey_id = q.survey_id AND srv.qstncore = q.qstncore 
			WHERE  su.survey_id = '+convert(varchar,@survey_id)+' 
				   AND q.nummarkcount > 1 
				   AND srv.intresponseval >= 10000 
				   AND bt.datSampleEncounterDate between '''+convert(varchar,@begindate)+''' and '''+convert(varchar,@enddate)+''''
	print @SQL
	exec (@SQL)
	delete from #tbl where tblname=@tn
	select top 1 @tn=tblname from #tbl
end

-- declare @tn varchar(50), @fn varchar(15), @sql varchar(max)
begin tran

select top 1 @tn=tblname,@fn=fldname from #updt where errorflg=0
while @@rowcount>0
begin
	set @SQL = 'update sr
				set '+@fn+'=u.ResponseVal
				from '+replace(@tn,'vertical_','')+' sr
				inner join #updt u on sr.samplepop_id=u.samplepop_id and sr.sampleunit_id=u.sampleunit_id
				where u.tblname='''+@tn+''' and u.fldname='''+@fn+''' and isnull('+@fn+',-123)<>isnull(u.ResponseVal,-123)
				delete u
				from '+replace(@tn,'vertical_','')+' sr
				inner join #updt u on sr.samplepop_id=u.samplepop_id and sr.sampleunit_id=u.sampleunit_id
				where u.tblname='''+@tn+''' and u.fldname='''+@fn+''''
	print @SQL
	exec (@SQL)
	
	update #updt set errorflg=1 where tblname=@tn and fldname=@fn
	select top 1 @tn=tblname,@fn=fldname from #updt where errorflg=0
end

if exists (select * from #updt where errorflg=1)
begin
	select 'There are records from study_results_vertical that don''t exist in study_results! Rolling back all updates.' as ErrorMessage
	select * from #updt where errorflg=1
	rollback tran
end 
else
	commit tran
set nocount off
go

begin tran
exec tmp_FixSkippedMultiResponseAnswers @survey_id=9830, @begindate = '1/1/13', @enddate='12/31/14'
rollback tran
