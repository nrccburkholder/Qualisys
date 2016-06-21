use qp_comments
go
if exists (select * from sys.procedures where name = 'tmp_FixSkippedMultiResponseAnswers')
	drop procedure tmp_FixSkippedMultiResponseAnswers
go
create procedure tmp_FixSkippedMultiResponseAnswers
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

/*
select distinct 'exec tmp_FixSkippedMultiResponseAnswers @survey_id=',sd.survey_id,', @begindate = ''7/1/14'', @enddate=''12/31/14'' --', sd.study_id,2
from qualisys.qp_prod.dbo.survey_def sd
inner join qualisys.qp_prod.dbo.sampleset ss on sd.survey_id=ss.survey_id
where sd.surveytype_id=3 --hhcahps
and ss.datDateRange_fromdate >= '7/1/14'
union
select distinct 'exec tmp_FixSkippedMultiResponseAnswers @survey_id=',sd.survey_id,', @begindate = ''1/1/14'', @enddate=''12/31/14'' --', sd.study_id,2
from qualisys.qp_prod.dbo.survey_def sd
inner join qualisys.qp_prod.dbo.sampleset ss on sd.survey_id=ss.survey_id
where sd.surveytype_id=4 --cg cahps
and ss.datDateRange_fromdate >= '1/1/14'
union 
select 'begin tran --',null,'',sd.study_id,1
from qualisys.qp_prod.dbo.survey_def sd
inner join qualisys.qp_prod.dbo.sampleset ss on sd.survey_id=ss.survey_id
where sd.surveytype_id=4 --cg cahps
and ss.datDateRange_fromdate >= '1/1/14'
union 
select 'commit tran --',null,'',sd.study_id,3
from qualisys.qp_prod.dbo.survey_def sd
inner join qualisys.qp_prod.dbo.sampleset ss on sd.survey_id=ss.survey_id
where sd.surveytype_id=4 --cg cahps
and ss.datDateRange_fromdate >= '1/1/14'
union 
select 'begin tran --',null,'',sd.study_id,1
from qualisys.qp_prod.dbo.survey_def sd
inner join qualisys.qp_prod.dbo.sampleset ss on sd.survey_id=ss.survey_id
where sd.surveytype_id=3 --hhcahps
and ss.datDateRange_fromdate >= '7/1/14'
union 
select 'commit tran --',null,'',sd.study_id,3
from qualisys.qp_prod.dbo.survey_def sd
inner join qualisys.qp_prod.dbo.sampleset ss on sd.survey_id=ss.survey_id
where sd.surveytype_id=3 --hhcahps
and ss.datDateRange_fromdate >= '7/1/14'
order by 4,5,3
*/

begin tran 																								--	22	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14259	, @begindate = '1/1/14', @enddate='12/31/14' --	22	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13668	, @begindate = '1/1/14', @enddate='12/31/14' --	22	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13670	, @begindate = '1/1/14', @enddate='12/31/14' --	22	2
commit tran 																							--	22	3
begin tran 																								--	469	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	5118	, @begindate = '1/1/14', @enddate='12/31/14' --	469	2
commit tran 																							--	469	3
begin tran 																								--	724	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16104	, @begindate = '1/1/14', @enddate='12/31/14' --	724	2
commit tran 																							--	724	3
begin tran 																								--	1563	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16239	, @begindate = '1/1/14', @enddate='12/31/14' --	1563	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16240	, @begindate = '1/1/14', @enddate='12/31/14' --	1563	2
commit tran 																							--	1563	3
begin tran 																								--	1712	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15089	, @begindate = '1/1/14', @enddate='12/31/14' --	1712	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15088	, @begindate = '1/1/14', @enddate='12/31/14' --	1712	2
commit tran 																							--	1712	3
begin tran 																								--	1764	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15098	, @begindate = '1/1/14', @enddate='12/31/14' --	1764	2
commit tran 																							--	1764	3
begin tran 																								--	1795	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15452	, @begindate = '1/1/14', @enddate='12/31/14' --	1795	2
commit tran 																							--	1795	3
begin tran 																								--	1799	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	7446	, @begindate = '1/1/14', @enddate='12/31/14' --	1799	2
commit tran 																							--	1799	3
begin tran 																								--	2185	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16389	, @begindate = '1/1/14', @enddate='12/31/14' --	2185	2
commit tran 																							--	2185	3
begin tran 																								--	2224	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15764	, @begindate = '1/1/14', @enddate='12/31/14' --	2224	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15750	, @begindate = '1/1/14', @enddate='12/31/14' --	2224	2
commit tran 																							--	2224	3
begin tran 																								--	2232	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16368	, @begindate = '1/1/14', @enddate='12/31/14' --	2232	2
commit tran 																							--	2232	3
begin tran 																								--	2285	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14435	, @begindate = '1/1/14', @enddate='12/31/14' --	2285	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16084	, @begindate = '1/1/14', @enddate='12/31/14' --	2285	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16098	, @begindate = '1/1/14', @enddate='12/31/14' --	2285	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16097	, @begindate = '1/1/14', @enddate='12/31/14' --	2285	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9586	, @begindate = '1/1/14', @enddate='12/31/14' --	2285	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16215	, @begindate = '1/1/14', @enddate='12/31/14' --	2285	2
commit tran 																							--	2285	3
begin tran 																								--	2289	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9605	, @begindate = '7/1/14', @enddate='12/31/14' --	2289	2
commit tran 																							--	2289	3
begin tran 																								--	2292	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16499	, @begindate = '1/1/14', @enddate='12/31/14' --	2292	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16500	, @begindate = '1/1/14', @enddate='12/31/14' --	2292	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9625	, @begindate = '1/1/14', @enddate='12/31/14' --	2292	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16552	, @begindate = '1/1/14', @enddate='12/31/14' --	2292	2
commit tran 																							--	2292	3
begin tran 																								--	2299	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9650	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16263	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16260	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9829	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16262	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16249	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16259	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16261	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16285	, @begindate = '1/1/14', @enddate='12/31/14' --	2299	2
commit tran 																							--	2299	3
begin tran 																								--	2318	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9686	, @begindate = '1/1/14', @enddate='12/31/14' --	2318	2
commit tran 																							--	2318	3
begin tran 																								--	2322	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16052	, @begindate = '7/1/14', @enddate='12/31/14' --	2322	2
commit tran 																							--	2322	3
begin tran 																								--	2342	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9747	, @begindate = '7/1/14', @enddate='12/31/14' --	2342	2
commit tran 																							--	2342	3
begin tran 																								--	2345	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9759	, @begindate = '1/1/14', @enddate='12/31/14' --	2345	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16673	, @begindate = '1/1/14', @enddate='12/31/14' --	2345	2
commit tran 																							--	2345	3
begin tran 																								--	2347	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9776	, @begindate = '7/1/14', @enddate='12/31/14' --	2347	2
commit tran 																							--	2347	3
begin tran 																								--	2348	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9777	, @begindate = '1/1/14', @enddate='12/31/14' --	2348	2
commit tran 																							--	2348	3
begin tran 																								--	2350	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16090	, @begindate = '1/1/14', @enddate='12/31/14' --	2350	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15690	, @begindate = '1/1/14', @enddate='12/31/14' --	2350	2
commit tran 																							--	2350	3
begin tran 																								--	2358	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9828	, @begindate = '7/1/14', @enddate='12/31/14' --	2358	2
commit tran 																							--	2358	3
begin tran 																								--	2359	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9824	, @begindate = '7/1/14', @enddate='12/31/14' --	2359	2
commit tran 																							--	2359	3
begin tran 																								--	2368	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9819	, @begindate = '1/1/14', @enddate='12/31/14' --	2368	2
commit tran 																							--	2368	3
begin tran 																								--	2380	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9836	, @begindate = '7/1/14', @enddate='12/31/14' --	2380	2
commit tran 																							--	2380	3
begin tran 																								--	2382	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9862	, @begindate = '7/1/14', @enddate='12/31/14' --	2382	2
commit tran 																							--	2382	3
begin tran 																								--	2383	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9863	, @begindate = '7/1/14', @enddate='12/31/14' --	2383	2
commit tran 																							--	2383	3
begin tran 																								--	2384	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9833	, @begindate = '7/1/14', @enddate='12/31/14' --	2384	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9832	, @begindate = '7/1/14', @enddate='12/31/14' --	2384	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9830	, @begindate = '7/1/14', @enddate='12/31/14' --	2384	2
commit tran 																							--	2384	3
begin tran 																								--	2385	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9839	, @begindate = '7/1/14', @enddate='12/31/14' --	2385	2
commit tran 																							--	2385	3
begin tran 																								--	2386	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9840	, @begindate = '7/1/14', @enddate='12/31/14' --	2386	2
commit tran 																							--	2386	3
begin tran 																								--	2389	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9841	, @begindate = '7/1/14', @enddate='12/31/14' --	2389	2
commit tran 																							--	2389	3
begin tran 																								--	2390	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9844	, @begindate = '7/1/14', @enddate='12/31/14' --	2390	2
commit tran 																							--	2390	3
begin tran 																								--	2392	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9848	, @begindate = '7/1/14', @enddate='12/31/14' --	2392	2
commit tran 																							--	2392	3
begin tran 																								--	2396	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9860	, @begindate = '7/1/14', @enddate='12/31/14' --	2396	2
commit tran 																							--	2396	3
begin tran 																								--	2397	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9864	, @begindate = '7/1/14', @enddate='12/31/14' --	2397	2
commit tran 																							--	2397	3
begin tran 																								--	2400	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9868	, @begindate = '7/1/14', @enddate='12/31/14' --	2400	2
commit tran 																							--	2400	3
begin tran 																								--	2401	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9876	, @begindate = '7/1/14', @enddate='12/31/14' --	2401	2
commit tran 																							--	2401	3
begin tran 																								--	2402	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12007	, @begindate = '7/1/14', @enddate='12/31/14' --	2402	2
commit tran 																							--	2402	3
begin tran 																								--	2403	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9859	, @begindate = '7/1/14', @enddate='12/31/14' --	2403	2
commit tran 																							--	2403	3
begin tran 																								--	2405	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9870	, @begindate = '7/1/14', @enddate='12/31/14' --	2405	2
commit tran 																							--	2405	3
begin tran 																								--	2406	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9874	, @begindate = '7/1/14', @enddate='12/31/14' --	2406	2
commit tran 																							--	2406	3
begin tran 																								--	2407	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9879	, @begindate = '7/1/14', @enddate='12/31/14' --	2407	2
commit tran 																							--	2407	3
begin tran 																								--	2408	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9877	, @begindate = '7/1/14', @enddate='12/31/14' --	2408	2
commit tran 																							--	2408	3
begin tran 																								--	2409	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9858	, @begindate = '7/1/14', @enddate='12/31/14' --	2409	2
commit tran 																							--	2409	3
begin tran 																								--	2411	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9873	, @begindate = '7/1/14', @enddate='12/31/14' --	2411	2
commit tran 																							--	2411	3
begin tran 																								--	2412	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9878	, @begindate = '7/1/14', @enddate='12/31/14' --	2412	2
commit tran 																							--	2412	3
begin tran 																								--	2418	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9881	, @begindate = '7/1/14', @enddate='12/31/14' --	2418	2
commit tran 																							--	2418	3
begin tran 																								--	2419	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9880	, @begindate = '7/1/14', @enddate='12/31/14' --	2419	2
commit tran 																							--	2419	3
begin tran 																								--	2420	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9884	, @begindate = '7/1/14', @enddate='12/31/14' --	2420	2
commit tran 																							--	2420	3
begin tran 																								--	2421	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9883	, @begindate = '7/1/14', @enddate='12/31/14' --	2421	2
commit tran 																							--	2421	3
begin tran 																								--	2429	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9899	, @begindate = '1/1/14', @enddate='12/31/14' --	2429	2
commit tran 																							--	2429	3
begin tran 																								--	2431	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10011	, @begindate = '7/1/14', @enddate='12/31/14' --	2431	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10008	, @begindate = '7/1/14', @enddate='12/31/14' --	2431	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10010	, @begindate = '7/1/14', @enddate='12/31/14' --	2431	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10012	, @begindate = '7/1/14', @enddate='12/31/14' --	2431	2
commit tran 																							--	2431	3
begin tran 																								--	2439	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9920	, @begindate = '7/1/14', @enddate='12/31/14' --	2439	2
commit tran 																							--	2439	3
begin tran 																								--	2442	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10508	, @begindate = '7/1/14', @enddate='12/31/14' --	2442	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10509	, @begindate = '7/1/14', @enddate='12/31/14' --	2442	2
commit tran 																							--	2442	3
begin tran 																								--	2455	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9996	, @begindate = '1/1/14', @enddate='12/31/14' --	2455	2
commit tran 																							--	2455	3
begin tran 																								--	2457	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9981	, @begindate = '1/1/14', @enddate='12/31/14' --	2457	2
commit tran 																							--	2457	3
begin tran 																								--	2458	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9936	, @begindate = '7/1/14', @enddate='12/31/14' --	2458	2
commit tran 																							--	2458	3
begin tran 																								--	2459	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9930	, @begindate = '7/1/14', @enddate='12/31/14' --	2459	2
commit tran 																							--	2459	3
begin tran 																								--	2460	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9934	, @begindate = '7/1/14', @enddate='12/31/14' --	2460	2
commit tran 																							--	2460	3
begin tran 																								--	2461	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9937	, @begindate = '7/1/14', @enddate='12/31/14' --	2461	2
commit tran 																							--	2461	3
begin tran 																								--	2463	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10159	, @begindate = '7/1/14', @enddate='12/31/14' --	2463	2
commit tran 																							--	2463	3
begin tran 																								--	2466	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9945	, @begindate = '7/1/14', @enddate='12/31/14' --	2466	2
commit tran 																							--	2466	3
begin tran 																								--	2467	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9947	, @begindate = '7/1/14', @enddate='12/31/14' --	2467	2
commit tran 																							--	2467	3
begin tran 																								--	2468	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9948	, @begindate = '7/1/14', @enddate='12/31/14' --	2468	2
commit tran 																							--	2468	3
begin tran 																								--	2470	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9950	, @begindate = '7/1/14', @enddate='12/31/14' --	2470	2
commit tran 																							--	2470	3
begin tran 																								--	2471	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10172	, @begindate = '7/1/14', @enddate='12/31/14' --	2471	2
commit tran 																							--	2471	3
begin tran 																								--	2473	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9951	, @begindate = '7/1/14', @enddate='12/31/14' --	2473	2
commit tran 																							--	2473	3
begin tran 																								--	2474	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9931	, @begindate = '7/1/14', @enddate='12/31/14' --	2474	2
commit tran 																							--	2474	3
begin tran 																								--	2475	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9932	, @begindate = '7/1/14', @enddate='12/31/14' --	2475	2
commit tran 																							--	2475	3
begin tran 																								--	2476	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9953	, @begindate = '7/1/14', @enddate='12/31/14' --	2476	2
commit tran 																							--	2476	3
begin tran 																								--	2477	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10192	, @begindate = '7/1/14', @enddate='12/31/14' --	2477	2
commit tran 																							--	2477	3
begin tran 																								--	2478	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9933	, @begindate = '7/1/14', @enddate='12/31/14' --	2478	2
commit tran 																							--	2478	3
begin tran 																								--	2479	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10195	, @begindate = '7/1/14', @enddate='12/31/14' --	2479	2
commit tran 																							--	2479	3
begin tran 																								--	2480	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10198	, @begindate = '7/1/14', @enddate='12/31/14' --	2480	2
commit tran 																							--	2480	3
begin tran 																								--	2481	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9928	, @begindate = '7/1/14', @enddate='12/31/14' --	2481	2
commit tran 																							--	2481	3
begin tran 																								--	2482	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9939	, @begindate = '7/1/14', @enddate='12/31/14' --	2482	2
commit tran 																							--	2482	3
begin tran 																								--	2483	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10206	, @begindate = '7/1/14', @enddate='12/31/14' --	2483	2
commit tran 																							--	2483	3
begin tran 																								--	2486	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9929	, @begindate = '7/1/14', @enddate='12/31/14' --	2486	2
commit tran 																							--	2486	3
begin tran 																								--	2487	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9952	, @begindate = '7/1/14', @enddate='12/31/14' --	2487	2
commit tran 																							--	2487	3
begin tran 																								--	2490	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9942	, @begindate = '7/1/14', @enddate='12/31/14' --	2490	2
commit tran 																							--	2490	3
begin tran 																								--	2491	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10183	, @begindate = '7/1/14', @enddate='12/31/14' --	2491	2
commit tran 																							--	2491	3
begin tran 																								--	2496	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9966	, @begindate = '7/1/14', @enddate='12/31/14' --	2496	2
commit tran 																							--	2496	3
begin tran 																								--	2497	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9965	, @begindate = '7/1/14', @enddate='12/31/14' --	2497	2
commit tran 																							--	2497	3
begin tran 																								--	2498	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9971	, @begindate = '7/1/14', @enddate='12/31/14' --	2498	2
commit tran 																							--	2498	3
begin tran 																								--	2499	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9970	, @begindate = '7/1/14', @enddate='12/31/14' --	2499	2
commit tran 																							--	2499	3
begin tran 																								--	2501	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9972	, @begindate = '7/1/14', @enddate='12/31/14' --	2501	2
commit tran 																							--	2501	3
begin tran 																								--	2502	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9968	, @begindate = '7/1/14', @enddate='12/31/14' --	2502	2
commit tran 																							--	2502	3
begin tran 																								--	2503	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9969	, @begindate = '7/1/14', @enddate='12/31/14' --	2503	2
commit tran 																							--	2503	3
begin tran 																								--	2504	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9973	, @begindate = '7/1/14', @enddate='12/31/14' --	2504	2
commit tran 																							--	2504	3
begin tran 																								--	2505	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9967	, @begindate = '7/1/14', @enddate='12/31/14' --	2505	2
commit tran 																							--	2505	3
begin tran 																								--	2507	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9960	, @begindate = '7/1/14', @enddate='12/31/14' --	2507	2
commit tran 																							--	2507	3
begin tran 																								--	2509	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9979	, @begindate = '7/1/14', @enddate='12/31/14' --	2509	2
commit tran 																							--	2509	3
begin tran 																								--	2512	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9987	, @begindate = '7/1/14', @enddate='12/31/14' --	2512	2
commit tran 																							--	2512	3
begin tran 																								--	2514	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10460	, @begindate = '7/1/14', @enddate='12/31/14' --	2514	2
commit tran 																							--	2514	3
begin tran 																								--	2519	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	9997	, @begindate = '1/1/14', @enddate='12/31/14' --	2519	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16507	, @begindate = '1/1/14', @enddate='12/31/14' --	2519	2
commit tran 																							--	2519	3
begin tran 																								--	2526	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10026	, @begindate = '7/1/14', @enddate='12/31/14' --	2526	2
commit tran 																							--	2526	3
begin tran 																								--	2527	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10027	, @begindate = '7/1/14', @enddate='12/31/14' --	2527	2
commit tran 																							--	2527	3
begin tran 																								--	2528	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10028	, @begindate = '7/1/14', @enddate='12/31/14' --	2528	2
commit tran 																							--	2528	3
begin tran 																								--	2529	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10029	, @begindate = '7/1/14', @enddate='12/31/14' --	2529	2
commit tran 																							--	2529	3
begin tran 																								--	2530	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10030	, @begindate = '7/1/14', @enddate='12/31/14' --	2530	2
commit tran 																							--	2530	3
begin tran 																								--	2531	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10031	, @begindate = '7/1/14', @enddate='12/31/14' --	2531	2
commit tran 																							--	2531	3
begin tran 																								--	2532	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10032	, @begindate = '7/1/14', @enddate='12/31/14' --	2532	2
commit tran 																							--	2532	3
begin tran 																								--	2533	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10033	, @begindate = '7/1/14', @enddate='12/31/14' --	2533	2
commit tran 																							--	2533	3
begin tran 																								--	2534	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10034	, @begindate = '7/1/14', @enddate='12/31/14' --	2534	2
commit tran 																							--	2534	3
begin tran 																								--	2535	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10035	, @begindate = '7/1/14', @enddate='12/31/14' --	2535	2
commit tran 																							--	2535	3
begin tran 																								--	2536	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10036	, @begindate = '7/1/14', @enddate='12/31/14' --	2536	2
commit tran 																							--	2536	3
begin tran 																								--	2537	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10037	, @begindate = '7/1/14', @enddate='12/31/14' --	2537	2
commit tran 																							--	2537	3
begin tran 																								--	2538	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10038	, @begindate = '7/1/14', @enddate='12/31/14' --	2538	2
commit tran 																							--	2538	3
begin tran 																								--	2539	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10039	, @begindate = '7/1/14', @enddate='12/31/14' --	2539	2
commit tran 																							--	2539	3
begin tran 																								--	2540	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10041	, @begindate = '7/1/14', @enddate='12/31/14' --	2540	2
commit tran 																							--	2540	3
begin tran 																								--	2541	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10043	, @begindate = '7/1/14', @enddate='12/31/14' --	2541	2
commit tran 																							--	2541	3
begin tran 																								--	2542	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10044	, @begindate = '7/1/14', @enddate='12/31/14' --	2542	2
commit tran 																							--	2542	3
begin tran 																								--	2543	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10045	, @begindate = '7/1/14', @enddate='12/31/14' --	2543	2
commit tran 																							--	2543	3
begin tran 																								--	2544	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10046	, @begindate = '7/1/14', @enddate='12/31/14' --	2544	2
commit tran 																							--	2544	3
begin tran 																								--	2545	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10047	, @begindate = '7/1/14', @enddate='12/31/14' --	2545	2
commit tran 																							--	2545	3
begin tran 																								--	2546	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10048	, @begindate = '7/1/14', @enddate='12/31/14' --	2546	2
commit tran 																							--	2546	3
begin tran 																								--	2547	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10049	, @begindate = '7/1/14', @enddate='12/31/14' --	2547	2
commit tran 																							--	2547	3
begin tran 																								--	2548	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10050	, @begindate = '7/1/14', @enddate='12/31/14' --	2548	2
commit tran 																							--	2548	3
begin tran 																								--	2549	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10051	, @begindate = '7/1/14', @enddate='12/31/14' --	2549	2
commit tran 																							--	2549	3
begin tran 																								--	2550	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10052	, @begindate = '7/1/14', @enddate='12/31/14' --	2550	2
commit tran 																							--	2550	3
begin tran 																								--	2554	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10056	, @begindate = '7/1/14', @enddate='12/31/14' --	2554	2
commit tran 																							--	2554	3
begin tran 																								--	2555	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10057	, @begindate = '7/1/14', @enddate='12/31/14' --	2555	2
commit tran 																							--	2555	3
begin tran 																								--	2556	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10058	, @begindate = '7/1/14', @enddate='12/31/14' --	2556	2
commit tran 																							--	2556	3
begin tran 																								--	2557	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10059	, @begindate = '7/1/14', @enddate='12/31/14' --	2557	2
commit tran 																							--	2557	3
begin tran 																								--	2558	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10060	, @begindate = '7/1/14', @enddate='12/31/14' --	2558	2
commit tran 																							--	2558	3
begin tran 																								--	2563	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10065	, @begindate = '7/1/14', @enddate='12/31/14' --	2563	2
commit tran 																							--	2563	3
begin tran 																								--	2566	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10068	, @begindate = '7/1/14', @enddate='12/31/14' --	2566	2
commit tran 																							--	2566	3
begin tran 																								--	2567	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10070	, @begindate = '7/1/14', @enddate='12/31/14' --	2567	2
commit tran 																							--	2567	3
begin tran 																								--	2568	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10071	, @begindate = '7/1/14', @enddate='12/31/14' --	2568	2
commit tran 																							--	2568	3
begin tran 																								--	2569	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10072	, @begindate = '7/1/14', @enddate='12/31/14' --	2569	2
commit tran 																							--	2569	3
begin tran 																								--	2570	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10073	, @begindate = '7/1/14', @enddate='12/31/14' --	2570	2
commit tran 																							--	2570	3
begin tran 																								--	2575	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10078	, @begindate = '7/1/14', @enddate='12/31/14' --	2575	2
commit tran 																							--	2575	3
begin tran 																								--	2576	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10079	, @begindate = '7/1/14', @enddate='12/31/14' --	2576	2
commit tran 																							--	2576	3
begin tran 																								--	2577	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10080	, @begindate = '7/1/14', @enddate='12/31/14' --	2577	2
commit tran 																							--	2577	3
begin tran 																								--	2585	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10089	, @begindate = '7/1/14', @enddate='12/31/14' --	2585	2
commit tran 																							--	2585	3
begin tran 																								--	2586	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10090	, @begindate = '7/1/14', @enddate='12/31/14' --	2586	2
commit tran 																							--	2586	3
begin tran 																								--	2588	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10092	, @begindate = '7/1/14', @enddate='12/31/14' --	2588	2
commit tran 																							--	2588	3
begin tran 																								--	2589	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10093	, @begindate = '7/1/14', @enddate='12/31/14' --	2589	2
commit tran 																							--	2589	3
begin tran 																								--	2593	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10097	, @begindate = '7/1/14', @enddate='12/31/14' --	2593	2
commit tran 																							--	2593	3
begin tran 																								--	2594	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10099	, @begindate = '7/1/14', @enddate='12/31/14' --	2594	2
commit tran 																							--	2594	3
begin tran 																								--	2595	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10100	, @begindate = '7/1/14', @enddate='12/31/14' --	2595	2
commit tran 																							--	2595	3
begin tran 																								--	2596	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10101	, @begindate = '7/1/14', @enddate='12/31/14' --	2596	2
commit tran 																							--	2596	3
begin tran 																								--	2597	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10102	, @begindate = '7/1/14', @enddate='12/31/14' --	2597	2
commit tran 																							--	2597	3
begin tran 																								--	2598	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10103	, @begindate = '7/1/14', @enddate='12/31/14' --	2598	2
commit tran 																							--	2598	3
begin tran 																								--	2599	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10104	, @begindate = '7/1/14', @enddate='12/31/14' --	2599	2
commit tran 																							--	2599	3
begin tran 																								--	2600	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10105	, @begindate = '7/1/14', @enddate='12/31/14' --	2600	2
commit tran 																							--	2600	3
begin tran 																								--	2601	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10106	, @begindate = '7/1/14', @enddate='12/31/14' --	2601	2
commit tran 																							--	2601	3
begin tran 																								--	2602	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10107	, @begindate = '7/1/14', @enddate='12/31/14' --	2602	2
commit tran 																							--	2602	3
begin tran 																								--	2603	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10108	, @begindate = '7/1/14', @enddate='12/31/14' --	2603	2
commit tran 																							--	2603	3
begin tran 																								--	2604	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10109	, @begindate = '7/1/14', @enddate='12/31/14' --	2604	2
commit tran 																							--	2604	3
begin tran 																								--	2605	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10110	, @begindate = '7/1/14', @enddate='12/31/14' --	2605	2
commit tran 																							--	2605	3
begin tran 																								--	2606	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10111	, @begindate = '7/1/14', @enddate='12/31/14' --	2606	2
commit tran 																							--	2606	3
begin tran 																								--	2607	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10112	, @begindate = '7/1/14', @enddate='12/31/14' --	2607	2
commit tran 																							--	2607	3
begin tran 																								--	2608	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10113	, @begindate = '7/1/14', @enddate='12/31/14' --	2608	2
commit tran 																							--	2608	3
begin tran 																								--	2609	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10114	, @begindate = '7/1/14', @enddate='12/31/14' --	2609	2
commit tran 																							--	2609	3
begin tran 																								--	2610	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10115	, @begindate = '7/1/14', @enddate='12/31/14' --	2610	2
commit tran 																							--	2610	3
begin tran 																								--	2611	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10116	, @begindate = '7/1/14', @enddate='12/31/14' --	2611	2
commit tran 																							--	2611	3
begin tran 																								--	2613	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10118	, @begindate = '7/1/14', @enddate='12/31/14' --	2613	2
commit tran 																							--	2613	3
begin tran 																								--	2618	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10123	, @begindate = '7/1/14', @enddate='12/31/14' --	2618	2
commit tran 																							--	2618	3
begin tran 																								--	2619	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10124	, @begindate = '7/1/14', @enddate='12/31/14' --	2619	2
commit tran 																							--	2619	3
begin tran 																								--	2620	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10125	, @begindate = '7/1/14', @enddate='12/31/14' --	2620	2
commit tran 																							--	2620	3
begin tran 																								--	2622	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10127	, @begindate = '7/1/14', @enddate='12/31/14' --	2622	2
commit tran 																							--	2622	3
begin tran 																								--	2624	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10129	, @begindate = '7/1/14', @enddate='12/31/14' --	2624	2
commit tran 																							--	2624	3
begin tran 																								--	2625	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10130	, @begindate = '7/1/14', @enddate='12/31/14' --	2625	2
commit tran 																							--	2625	3
begin tran 																								--	2626	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10131	, @begindate = '7/1/14', @enddate='12/31/14' --	2626	2
commit tran 																							--	2626	3
begin tran 																								--	2628	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10133	, @begindate = '7/1/14', @enddate='12/31/14' --	2628	2
commit tran 																							--	2628	3
begin tran 																								--	2630	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10135	, @begindate = '7/1/14', @enddate='12/31/14' --	2630	2
commit tran 																							--	2630	3
begin tran 																								--	2631	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10136	, @begindate = '7/1/14', @enddate='12/31/14' --	2631	2
commit tran 																							--	2631	3
begin tran 																								--	2632	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10137	, @begindate = '7/1/14', @enddate='12/31/14' --	2632	2
commit tran 																							--	2632	3
begin tran 																								--	2633	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10214	, @begindate = '7/1/14', @enddate='12/31/14' --	2633	2
commit tran 																							--	2633	3
begin tran 																								--	2634	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10215	, @begindate = '7/1/14', @enddate='12/31/14' --	2634	2
commit tran 																							--	2634	3
begin tran 																								--	2635	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10218	, @begindate = '7/1/14', @enddate='12/31/14' --	2635	2
commit tran 																							--	2635	3
begin tran 																								--	2636	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10219	, @begindate = '7/1/14', @enddate='12/31/14' --	2636	2
commit tran 																							--	2636	3
begin tran 																								--	2637	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10220	, @begindate = '7/1/14', @enddate='12/31/14' --	2637	2
commit tran 																							--	2637	3
begin tran 																								--	2638	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10221	, @begindate = '7/1/14', @enddate='12/31/14' --	2638	2
commit tran 																							--	2638	3
begin tran 																								--	2639	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10226	, @begindate = '7/1/14', @enddate='12/31/14' --	2639	2
commit tran 																							--	2639	3
begin tran 																								--	2640	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10228	, @begindate = '7/1/14', @enddate='12/31/14' --	2640	2
commit tran 																							--	2640	3
begin tran 																								--	2641	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10229	, @begindate = '7/1/14', @enddate='12/31/14' --	2641	2
commit tran 																							--	2641	3
begin tran 																								--	2642	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10231	, @begindate = '7/1/14', @enddate='12/31/14' --	2642	2
commit tran 																							--	2642	3
begin tran 																								--	2643	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10233	, @begindate = '7/1/14', @enddate='12/31/14' --	2643	2
commit tran 																							--	2643	3
begin tran 																								--	2644	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10235	, @begindate = '7/1/14', @enddate='12/31/14' --	2644	2
commit tran 																							--	2644	3
begin tran 																								--	2645	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10239	, @begindate = '7/1/14', @enddate='12/31/14' --	2645	2
commit tran 																							--	2645	3
begin tran 																								--	2646	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10240	, @begindate = '7/1/14', @enddate='12/31/14' --	2646	2
commit tran 																							--	2646	3
begin tran 																								--	2647	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10269	, @begindate = '7/1/14', @enddate='12/31/14' --	2647	2
commit tran 																							--	2647	3
begin tran 																								--	2648	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10267	, @begindate = '7/1/14', @enddate='12/31/14' --	2648	2
commit tran 																							--	2648	3
begin tran 																								--	2649	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10266	, @begindate = '7/1/14', @enddate='12/31/14' --	2649	2
commit tran 																							--	2649	3
begin tran 																								--	2650	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10264	, @begindate = '7/1/14', @enddate='12/31/14' --	2650	2
commit tran 																							--	2650	3
begin tran 																								--	2651	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10262	, @begindate = '7/1/14', @enddate='12/31/14' --	2651	2
commit tran 																							--	2651	3
begin tran 																								--	2652	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10261	, @begindate = '7/1/14', @enddate='12/31/14' --	2652	2
commit tran 																							--	2652	3
begin tran 																								--	2653	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10259	, @begindate = '7/1/14', @enddate='12/31/14' --	2653	2
commit tran 																							--	2653	3
begin tran 																								--	2654	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10258	, @begindate = '7/1/14', @enddate='12/31/14' --	2654	2
commit tran 																							--	2654	3
begin tran 																								--	2655	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10254	, @begindate = '7/1/14', @enddate='12/31/14' --	2655	2
commit tran 																							--	2655	3
begin tran 																								--	2656	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10252	, @begindate = '7/1/14', @enddate='12/31/14' --	2656	2
commit tran 																							--	2656	3
begin tran 																								--	2661	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10245	, @begindate = '7/1/14', @enddate='12/31/14' --	2661	2
commit tran 																							--	2661	3
begin tran 																								--	2662	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10242	, @begindate = '7/1/14', @enddate='12/31/14' --	2662	2
commit tran 																							--	2662	3
begin tran 																								--	2663	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10241	, @begindate = '7/1/14', @enddate='12/31/14' --	2663	2
commit tran 																							--	2663	3
begin tran 																								--	2664	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10238	, @begindate = '7/1/14', @enddate='12/31/14' --	2664	2
commit tran 																							--	2664	3
begin tran 																								--	2665	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10237	, @begindate = '7/1/14', @enddate='12/31/14' --	2665	2
commit tran 																							--	2665	3
begin tran 																								--	2666	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10236	, @begindate = '7/1/14', @enddate='12/31/14' --	2666	2
commit tran 																							--	2666	3
begin tran 																								--	2667	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10234	, @begindate = '7/1/14', @enddate='12/31/14' --	2667	2
commit tran 																							--	2667	3
begin tran 																								--	2668	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10232	, @begindate = '7/1/14', @enddate='12/31/14' --	2668	2
commit tran 																							--	2668	3
begin tran 																								--	2669	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10230	, @begindate = '7/1/14', @enddate='12/31/14' --	2669	2
commit tran 																							--	2669	3
begin tran 																								--	2670	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10224	, @begindate = '7/1/14', @enddate='12/31/14' --	2670	2
commit tran 																							--	2670	3
begin tran 																								--	2671	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10227	, @begindate = '7/1/14', @enddate='12/31/14' --	2671	2
commit tran 																							--	2671	3
begin tran 																								--	2672	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10217	, @begindate = '7/1/14', @enddate='12/31/14' --	2672	2
commit tran 																							--	2672	3
begin tran 																								--	2673	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10213	, @begindate = '7/1/14', @enddate='12/31/14' --	2673	2
commit tran 																							--	2673	3
begin tran 																								--	2674	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10244	, @begindate = '7/1/14', @enddate='12/31/14' --	2674	2
commit tran 																							--	2674	3
begin tran 																								--	2675	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10251	, @begindate = '7/1/14', @enddate='12/31/14' --	2675	2
commit tran 																							--	2675	3
begin tran 																								--	2676	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10253	, @begindate = '7/1/14', @enddate='12/31/14' --	2676	2
commit tran 																							--	2676	3
begin tran 																								--	2677	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10255	, @begindate = '7/1/14', @enddate='12/31/14' --	2677	2
commit tran 																							--	2677	3
begin tran 																								--	2678	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10256	, @begindate = '7/1/14', @enddate='12/31/14' --	2678	2
commit tran 																							--	2678	3
begin tran 																								--	2680	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10260	, @begindate = '7/1/14', @enddate='12/31/14' --	2680	2
commit tran 																							--	2680	3
begin tran 																								--	2681	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10263	, @begindate = '7/1/14', @enddate='12/31/14' --	2681	2
commit tran 																							--	2681	3
begin tran 																								--	2689	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10276	, @begindate = '7/1/14', @enddate='12/31/14' --	2689	2
commit tran 																							--	2689	3
begin tran 																								--	2690	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10277	, @begindate = '7/1/14', @enddate='12/31/14' --	2690	2
commit tran 																							--	2690	3
begin tran 																								--	2691	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10280	, @begindate = '7/1/14', @enddate='12/31/14' --	2691	2
commit tran 																							--	2691	3
begin tran 																								--	2692	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10282	, @begindate = '7/1/14', @enddate='12/31/14' --	2692	2
commit tran 																							--	2692	3
begin tran 																								--	2694	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10286	, @begindate = '7/1/14', @enddate='12/31/14' --	2694	2
commit tran 																							--	2694	3
begin tran 																								--	2695	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10288	, @begindate = '7/1/14', @enddate='12/31/14' --	2695	2
commit tran 																							--	2695	3
begin tran 																								--	2696	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10290	, @begindate = '7/1/14', @enddate='12/31/14' --	2696	2
commit tran 																							--	2696	3
begin tran 																								--	2697	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10320	, @begindate = '7/1/14', @enddate='12/31/14' --	2697	2
commit tran 																							--	2697	3
begin tran 																								--	2699	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10322	, @begindate = '7/1/14', @enddate='12/31/14' --	2699	2
commit tran 																							--	2699	3
begin tran 																								--	2703	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10243	, @begindate = '7/1/14', @enddate='12/31/14' --	2703	2
commit tran 																							--	2703	3
begin tran 																								--	2704	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10324	, @begindate = '7/1/14', @enddate='12/31/14' --	2704	2
commit tran 																							--	2704	3
begin tran 																								--	2705	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10325	, @begindate = '7/1/14', @enddate='12/31/14' --	2705	2
commit tran 																							--	2705	3
begin tran 																								--	2706	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10327	, @begindate = '7/1/14', @enddate='12/31/14' --	2706	2
commit tran 																							--	2706	3
begin tran 																								--	2707	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10328	, @begindate = '7/1/14', @enddate='12/31/14' --	2707	2
commit tran 																							--	2707	3
begin tran 																								--	2708	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10335	, @begindate = '7/1/14', @enddate='12/31/14' --	2708	2
commit tran 																							--	2708	3
begin tran 																								--	2709	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10336	, @begindate = '7/1/14', @enddate='12/31/14' --	2709	2
commit tran 																							--	2709	3
begin tran 																								--	2710	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10338	, @begindate = '7/1/14', @enddate='12/31/14' --	2710	2
commit tran 																							--	2710	3
begin tran 																								--	2711	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10339	, @begindate = '7/1/14', @enddate='12/31/14' --	2711	2
commit tran 																							--	2711	3
begin tran 																								--	2712	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10340	, @begindate = '7/1/14', @enddate='12/31/14' --	2712	2
commit tran 																							--	2712	3
begin tran 																								--	2713	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10341	, @begindate = '7/1/14', @enddate='12/31/14' --	2713	2
commit tran 																							--	2713	3
begin tran 																								--	2714	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10345	, @begindate = '7/1/14', @enddate='12/31/14' --	2714	2
commit tran 																							--	2714	3
begin tran 																								--	2715	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10347	, @begindate = '7/1/14', @enddate='12/31/14' --	2715	2
commit tran 																							--	2715	3
begin tran 																								--	2716	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10348	, @begindate = '7/1/14', @enddate='12/31/14' --	2716	2
commit tran 																							--	2716	3
begin tran 																								--	2718	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10376	, @begindate = '7/1/14', @enddate='12/31/14' --	2718	2
commit tran 																							--	2718	3
begin tran 																								--	2719	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10355	, @begindate = '7/1/14', @enddate='12/31/14' --	2719	2
commit tran 																							--	2719	3
begin tran 																								--	2720	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10360	, @begindate = '7/1/14', @enddate='12/31/14' --	2720	2
commit tran 																							--	2720	3
begin tran 																								--	2721	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10362	, @begindate = '7/1/14', @enddate='12/31/14' --	2721	2
commit tran 																							--	2721	3
begin tran 																								--	2722	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10363	, @begindate = '7/1/14', @enddate='12/31/14' --	2722	2
commit tran 																							--	2722	3
begin tran 																								--	2723	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10365	, @begindate = '7/1/14', @enddate='12/31/14' --	2723	2
commit tran 																							--	2723	3
begin tran 																								--	2724	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10367	, @begindate = '7/1/14', @enddate='12/31/14' --	2724	2
commit tran 																							--	2724	3
begin tran 																								--	2725	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10369	, @begindate = '7/1/14', @enddate='12/31/14' --	2725	2
commit tran 																							--	2725	3
begin tran 																								--	2726	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10370	, @begindate = '7/1/14', @enddate='12/31/14' --	2726	2
commit tran 																							--	2726	3
begin tran 																								--	2727	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10359	, @begindate = '7/1/14', @enddate='12/31/14' --	2727	2
commit tran 																							--	2727	3
begin tran 																								--	2728	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10364	, @begindate = '7/1/14', @enddate='12/31/14' --	2728	2
commit tran 																							--	2728	3
begin tran 																								--	2729	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10366	, @begindate = '7/1/14', @enddate='12/31/14' --	2729	2
commit tran 																							--	2729	3
begin tran 																								--	2730	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10368	, @begindate = '7/1/14', @enddate='12/31/14' --	2730	2
commit tran 																							--	2730	3
begin tran 																								--	2731	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10373	, @begindate = '7/1/14', @enddate='12/31/14' --	2731	2
commit tran 																							--	2731	3
begin tran 																								--	2732	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10361	, @begindate = '7/1/14', @enddate='12/31/14' --	2732	2
commit tran 																							--	2732	3
begin tran 																								--	2733	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10374	, @begindate = '7/1/14', @enddate='12/31/14' --	2733	2
commit tran 																							--	2733	3
begin tran 																								--	2734	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10353	, @begindate = '7/1/14', @enddate='12/31/14' --	2734	2
commit tran 																							--	2734	3
begin tran 																								--	2749	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10283	, @begindate = '7/1/14', @enddate='12/31/14' --	2749	2
commit tran 																							--	2749	3
begin tran 																								--	2750	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10285	, @begindate = '7/1/14', @enddate='12/31/14' --	2750	2
commit tran 																							--	2750	3
begin tran 																								--	2751	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10287	, @begindate = '7/1/14', @enddate='12/31/14' --	2751	2
commit tran 																							--	2751	3
begin tran 																								--	2752	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10289	, @begindate = '7/1/14', @enddate='12/31/14' --	2752	2
commit tran 																							--	2752	3
begin tran 																								--	2753	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10291	, @begindate = '7/1/14', @enddate='12/31/14' --	2753	2
commit tran 																							--	2753	3
begin tran 																								--	2754	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10292	, @begindate = '7/1/14', @enddate='12/31/14' --	2754	2
commit tran 																							--	2754	3
begin tran 																								--	2757	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10333	, @begindate = '7/1/14', @enddate='12/31/14' --	2757	2
commit tran 																							--	2757	3
begin tran 																								--	2759	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10331	, @begindate = '7/1/14', @enddate='12/31/14' --	2759	2
commit tran 																							--	2759	3
begin tran 																								--	2761	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10337	, @begindate = '7/1/14', @enddate='12/31/14' --	2761	2
commit tran 																							--	2761	3
begin tran 																								--	2762	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10342	, @begindate = '7/1/14', @enddate='12/31/14' --	2762	2
commit tran 																							--	2762	3
begin tran 																								--	2763	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10344	, @begindate = '7/1/14', @enddate='12/31/14' --	2763	2
commit tran 																							--	2763	3
begin tran 																								--	2764	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10346	, @begindate = '7/1/14', @enddate='12/31/14' --	2764	2
commit tran 																							--	2764	3
begin tran 																								--	2765	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10349	, @begindate = '7/1/14', @enddate='12/31/14' --	2765	2
commit tran 																							--	2765	3
begin tran 																								--	2766	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10351	, @begindate = '7/1/14', @enddate='12/31/14' --	2766	2
commit tran 																							--	2766	3
begin tran 																								--	2767	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10354	, @begindate = '7/1/14', @enddate='12/31/14' --	2767	2
commit tran 																							--	2767	3
begin tran 																								--	2768	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10356	, @begindate = '7/1/14', @enddate='12/31/14' --	2768	2
commit tran 																							--	2768	3
begin tran 																								--	2770	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10396	, @begindate = '1/1/14', @enddate='12/31/14' --	2770	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15246	, @begindate = '1/1/14', @enddate='12/31/14' --	2770	2
commit tran 																							--	2770	3
begin tran 																								--	2772	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10139	, @begindate = '7/1/14', @enddate='12/31/14' --	2772	2
commit tran 																							--	2772	3
begin tran 																								--	2773	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10140	, @begindate = '7/1/14', @enddate='12/31/14' --	2773	2
commit tran 																							--	2773	3
begin tran 																								--	2774	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10141	, @begindate = '7/1/14', @enddate='12/31/14' --	2774	2
commit tran 																							--	2774	3
begin tran 																								--	2778	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10153	, @begindate = '7/1/14', @enddate='12/31/14' --	2778	2
commit tran 																							--	2778	3
begin tran 																								--	2780	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10155	, @begindate = '7/1/14', @enddate='12/31/14' --	2780	2
commit tran 																							--	2780	3
begin tran 																								--	2781	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10156	, @begindate = '7/1/14', @enddate='12/31/14' --	2781	2
commit tran 																							--	2781	3
begin tran 																								--	2782	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10157	, @begindate = '7/1/14', @enddate='12/31/14' --	2782	2
commit tran 																							--	2782	3
begin tran 																								--	2783	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10163	, @begindate = '7/1/14', @enddate='12/31/14' --	2783	2
commit tran 																							--	2783	3
begin tran 																								--	2784	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10164	, @begindate = '7/1/14', @enddate='12/31/14' --	2784	2
commit tran 																							--	2784	3
begin tran 																								--	2785	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10165	, @begindate = '7/1/14', @enddate='12/31/14' --	2785	2
commit tran 																							--	2785	3
begin tran 																								--	2786	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10166	, @begindate = '7/1/14', @enddate='12/31/14' --	2786	2
commit tran 																							--	2786	3
begin tran 																								--	2787	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10167	, @begindate = '7/1/14', @enddate='12/31/14' --	2787	2
commit tran 																							--	2787	3
begin tran 																								--	2788	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10168	, @begindate = '7/1/14', @enddate='12/31/14' --	2788	2
commit tran 																							--	2788	3
begin tran 																								--	2789	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10169	, @begindate = '7/1/14', @enddate='12/31/14' --	2789	2
commit tran 																							--	2789	3
begin tran 																								--	2790	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10170	, @begindate = '7/1/14', @enddate='12/31/14' --	2790	2
commit tran 																							--	2790	3
begin tran 																								--	2792	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10176	, @begindate = '7/1/14', @enddate='12/31/14' --	2792	2
commit tran 																							--	2792	3
begin tran 																								--	2793	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10177	, @begindate = '7/1/14', @enddate='12/31/14' --	2793	2
commit tran 																							--	2793	3
begin tran 																								--	2794	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10178	, @begindate = '7/1/14', @enddate='12/31/14' --	2794	2
commit tran 																							--	2794	3
begin tran 																								--	2795	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10180	, @begindate = '7/1/14', @enddate='12/31/14' --	2795	2
commit tran 																							--	2795	3
begin tran 																								--	2796	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10181	, @begindate = '7/1/14', @enddate='12/31/14' --	2796	2
commit tran 																							--	2796	3
begin tran 																								--	2797	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10182	, @begindate = '7/1/14', @enddate='12/31/14' --	2797	2
commit tran 																							--	2797	3
begin tran 																								--	2799	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10184	, @begindate = '7/1/14', @enddate='12/31/14' --	2799	2
commit tran 																							--	2799	3
begin tran 																								--	2800	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10185	, @begindate = '7/1/14', @enddate='12/31/14' --	2800	2
commit tran 																							--	2800	3
begin tran 																								--	2802	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10187	, @begindate = '7/1/14', @enddate='12/31/14' --	2802	2
commit tran 																							--	2802	3
begin tran 																								--	2803	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10188	, @begindate = '7/1/14', @enddate='12/31/14' --	2803	2
commit tran 																							--	2803	3
begin tran 																								--	2804	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10189	, @begindate = '7/1/14', @enddate='12/31/14' --	2804	2
commit tran 																							--	2804	3
begin tran 																								--	2805	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10190	, @begindate = '7/1/14', @enddate='12/31/14' --	2805	2
commit tran 																							--	2805	3
begin tran 																								--	2806	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10191	, @begindate = '7/1/14', @enddate='12/31/14' --	2806	2
commit tran 																							--	2806	3
begin tran 																								--	2807	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10193	, @begindate = '7/1/14', @enddate='12/31/14' --	2807	2
commit tran 																							--	2807	3
begin tran 																								--	2810	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10199	, @begindate = '7/1/14', @enddate='12/31/14' --	2810	2
commit tran 																							--	2810	3
begin tran 																								--	2812	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10201	, @begindate = '7/1/14', @enddate='12/31/14' --	2812	2
commit tran 																							--	2812	3
begin tran 																								--	2813	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10202	, @begindate = '7/1/14', @enddate='12/31/14' --	2813	2
commit tran 																							--	2813	3
begin tran 																								--	2814	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10203	, @begindate = '7/1/14', @enddate='12/31/14' --	2814	2
commit tran 																							--	2814	3
begin tran 																								--	2815	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10204	, @begindate = '7/1/14', @enddate='12/31/14' --	2815	2
commit tran 																							--	2815	3
begin tran 																								--	2817	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10208	, @begindate = '7/1/14', @enddate='12/31/14' --	2817	2
commit tran 																							--	2817	3
begin tran 																								--	2818	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10209	, @begindate = '7/1/14', @enddate='12/31/14' --	2818	2
commit tran 																							--	2818	3
begin tran 																								--	2820	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10211	, @begindate = '7/1/14', @enddate='12/31/14' --	2820	2
commit tran 																							--	2820	3
begin tran 																								--	2821	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10144	, @begindate = '7/1/14', @enddate='12/31/14' --	2821	2
commit tran 																							--	2821	3
begin tran 																								--	2822	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10145	, @begindate = '7/1/14', @enddate='12/31/14' --	2822	2
commit tran 																							--	2822	3
begin tran 																								--	2823	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10146	, @begindate = '7/1/14', @enddate='12/31/14' --	2823	2
commit tran 																							--	2823	3
begin tran 																								--	2824	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10147	, @begindate = '7/1/14', @enddate='12/31/14' --	2824	2
commit tran 																							--	2824	3
begin tran 																								--	2825	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10148	, @begindate = '7/1/14', @enddate='12/31/14' --	2825	2
commit tran 																							--	2825	3
begin tran 																								--	2826	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10149	, @begindate = '7/1/14', @enddate='12/31/14' --	2826	2
commit tran 																							--	2826	3
begin tran 																								--	2827	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10150	, @begindate = '7/1/14', @enddate='12/31/14' --	2827	2
commit tran 																							--	2827	3
begin tran 																								--	2828	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10152	, @begindate = '7/1/14', @enddate='12/31/14' --	2828	2
commit tran 																							--	2828	3
begin tran 																								--	2829	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10158	, @begindate = '7/1/14', @enddate='12/31/14' --	2829	2
commit tran 																							--	2829	3
begin tran 																								--	2834	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10174	, @begindate = '7/1/14', @enddate='12/31/14' --	2834	2
commit tran 																							--	2834	3
begin tran 																								--	2838	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10207	, @begindate = '7/1/14', @enddate='12/31/14' --	2838	2
commit tran 																							--	2838	3
begin tran 																								--	2839	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10436	, @begindate = '7/1/14', @enddate='12/31/14' --	2839	2
commit tran 																							--	2839	3
begin tran 																								--	2843	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10387	, @begindate = '7/1/14', @enddate='12/31/14' --	2843	2
commit tran 																							--	2843	3
begin tran 																								--	2844	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10388	, @begindate = '7/1/14', @enddate='12/31/14' --	2844	2
commit tran 																							--	2844	3
begin tran 																								--	2845	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10389	, @begindate = '7/1/14', @enddate='12/31/14' --	2845	2
commit tran 																							--	2845	3
begin tran 																								--	2846	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10395	, @begindate = '7/1/14', @enddate='12/31/14' --	2846	2
commit tran 																							--	2846	3
begin tran 																								--	2849	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10405	, @begindate = '7/1/14', @enddate='12/31/14' --	2849	2
commit tran 																							--	2849	3
begin tran 																								--	2850	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10406	, @begindate = '7/1/14', @enddate='12/31/14' --	2850	2
commit tran 																							--	2850	3
begin tran 																								--	2851	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10407	, @begindate = '7/1/14', @enddate='12/31/14' --	2851	2
commit tran 																							--	2851	3
begin tran 																								--	2853	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10409	, @begindate = '7/1/14', @enddate='12/31/14' --	2853	2
commit tran 																							--	2853	3
begin tran 																								--	2855	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10411	, @begindate = '7/1/14', @enddate='12/31/14' --	2855	2
commit tran 																							--	2855	3
begin tran 																								--	2856	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10412	, @begindate = '7/1/14', @enddate='12/31/14' --	2856	2
commit tran 																							--	2856	3
begin tran 																								--	2858	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10414	, @begindate = '7/1/14', @enddate='12/31/14' --	2858	2
commit tran 																							--	2858	3
begin tran 																								--	2867	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10423	, @begindate = '7/1/14', @enddate='12/31/14' --	2867	2
commit tran 																							--	2867	3
begin tran 																								--	2869	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10425	, @begindate = '7/1/14', @enddate='12/31/14' --	2869	2
commit tran 																							--	2869	3
begin tran 																								--	2870	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10426	, @begindate = '7/1/14', @enddate='12/31/14' --	2870	2
commit tran 																							--	2870	3
begin tran 																								--	2874	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10430	, @begindate = '7/1/14', @enddate='12/31/14' --	2874	2
commit tran 																							--	2874	3
begin tran 																								--	2875	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10431	, @begindate = '7/1/14', @enddate='12/31/14' --	2875	2
commit tran 																							--	2875	3
begin tran 																								--	2877	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10433	, @begindate = '7/1/14', @enddate='12/31/14' --	2877	2
commit tran 																							--	2877	3
begin tran 																								--	2878	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10434	, @begindate = '7/1/14', @enddate='12/31/14' --	2878	2
commit tran 																							--	2878	3
begin tran 																								--	2881	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10442	, @begindate = '7/1/14', @enddate='12/31/14' --	2881	2
commit tran 																							--	2881	3
begin tran 																								--	2886	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10453	, @begindate = '7/1/14', @enddate='12/31/14' --	2886	2
commit tran 																							--	2886	3
begin tran 																								--	2887	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13918	, @begindate = '1/1/14', @enddate='12/31/14' --	2887	2
commit tran 																							--	2887	3
begin tran 																								--	2889	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10458	, @begindate = '7/1/14', @enddate='12/31/14' --	2889	2
commit tran 																							--	2889	3
begin tran 																								--	2890	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10455	, @begindate = '7/1/14', @enddate='12/31/14' --	2890	2
commit tran 																							--	2890	3
begin tran 																								--	2892	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10459	, @begindate = '7/1/14', @enddate='12/31/14' --	2892	2
commit tran 																							--	2892	3
begin tran 																								--	2893	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10507	, @begindate = '7/1/14', @enddate='12/31/14' --	2893	2
commit tran 																							--	2893	3
begin tran 																								--	2894	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10465	, @begindate = '7/1/14', @enddate='12/31/14' --	2894	2
commit tran 																							--	2894	3
begin tran 																								--	2895	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10466	, @begindate = '7/1/14', @enddate='12/31/14' --	2895	2
commit tran 																							--	2895	3
begin tran 																								--	2897	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10468	, @begindate = '7/1/14', @enddate='12/31/14' --	2897	2
commit tran 																							--	2897	3
begin tran 																								--	2898	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10469	, @begindate = '7/1/14', @enddate='12/31/14' --	2898	2
commit tran 																							--	2898	3
begin tran 																								--	2899	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10470	, @begindate = '7/1/14', @enddate='12/31/14' --	2899	2
commit tran 																							--	2899	3
begin tran 																								--	2902	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10484	, @begindate = '7/1/14', @enddate='12/31/14' --	2902	2
commit tran 																							--	2902	3
begin tran 																								--	2903	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10485	, @begindate = '7/1/14', @enddate='12/31/14' --	2903	2
commit tran 																							--	2903	3
begin tran 																								--	2905	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10487	, @begindate = '7/1/14', @enddate='12/31/14' --	2905	2
commit tran 																							--	2905	3
begin tran 																								--	2906	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10488	, @begindate = '7/1/14', @enddate='12/31/14' --	2906	2
commit tran 																							--	2906	3
begin tran 																								--	2907	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10489	, @begindate = '7/1/14', @enddate='12/31/14' --	2907	2
commit tran 																							--	2907	3
begin tran 																								--	2914	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10496	, @begindate = '7/1/14', @enddate='12/31/14' --	2914	2
commit tran 																							--	2914	3
begin tran 																								--	2916	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10498	, @begindate = '7/1/14', @enddate='12/31/14' --	2916	2
commit tran 																							--	2916	3
begin tran 																								--	2917	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10499	, @begindate = '7/1/14', @enddate='12/31/14' --	2917	2
commit tran 																							--	2917	3
begin tran 																								--	2918	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10500	, @begindate = '7/1/14', @enddate='12/31/14' --	2918	2
commit tran 																							--	2918	3
begin tran 																								--	2919	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10501	, @begindate = '7/1/14', @enddate='12/31/14' --	2919	2
commit tran 																							--	2919	3
begin tran 																								--	2923	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10505	, @begindate = '7/1/14', @enddate='12/31/14' --	2923	2
commit tran 																							--	2923	3
begin tran 																								--	2924	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10510	, @begindate = '7/1/14', @enddate='12/31/14' --	2924	2
commit tran 																							--	2924	3
begin tran 																								--	2925	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10511	, @begindate = '7/1/14', @enddate='12/31/14' --	2925	2
commit tran 																							--	2925	3
begin tran 																								--	2927	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10513	, @begindate = '7/1/14', @enddate='12/31/14' --	2927	2
commit tran 																							--	2927	3
begin tran 																								--	2928	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10514	, @begindate = '7/1/14', @enddate='12/31/14' --	2928	2
commit tran 																							--	2928	3
begin tran 																								--	2936	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10555	, @begindate = '7/1/14', @enddate='12/31/14' --	2936	2
commit tran 																							--	2936	3
begin tran 																								--	2938	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10528	, @begindate = '7/1/14', @enddate='12/31/14' --	2938	2
commit tran 																							--	2938	3
begin tran 																								--	2940	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10529	, @begindate = '7/1/14', @enddate='12/31/14' --	2940	2
commit tran 																							--	2940	3
begin tran 																								--	2943	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10559	, @begindate = '7/1/14', @enddate='12/31/14' --	2943	2
commit tran 																							--	2943	3
begin tran 																								--	2945	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10561	, @begindate = '7/1/14', @enddate='12/31/14' --	2945	2
commit tran 																							--	2945	3
begin tran 																								--	2946	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10530	, @begindate = '7/1/14', @enddate='12/31/14' --	2946	2
commit tran 																							--	2946	3
begin tran 																								--	2947	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10562	, @begindate = '7/1/14', @enddate='12/31/14' --	2947	2
commit tran 																							--	2947	3
begin tran 																								--	2948	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10531	, @begindate = '7/1/14', @enddate='12/31/14' --	2948	2
commit tran 																							--	2948	3
begin tran 																								--	2949	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10532	, @begindate = '7/1/14', @enddate='12/31/14' --	2949	2
commit tran 																							--	2949	3
begin tran 																								--	2950	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10563	, @begindate = '7/1/14', @enddate='12/31/14' --	2950	2
commit tran 																							--	2950	3
begin tran 																								--	2954	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10564	, @begindate = '7/1/14', @enddate='12/31/14' --	2954	2
commit tran 																							--	2954	3
begin tran 																								--	2956	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10542	, @begindate = '7/1/14', @enddate='12/31/14' --	2956	2
commit tran 																							--	2956	3
begin tran 																								--	2957	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10536	, @begindate = '7/1/14', @enddate='12/31/14' --	2957	2
commit tran 																							--	2957	3
begin tran 																								--	2960	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10544	, @begindate = '7/1/14', @enddate='12/31/14' --	2960	2
commit tran 																							--	2960	3
begin tran 																								--	2962	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10568	, @begindate = '7/1/14', @enddate='12/31/14' --	2962	2
commit tran 																							--	2962	3
begin tran 																								--	2964	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10570	, @begindate = '7/1/14', @enddate='12/31/14' --	2964	2
commit tran 																							--	2964	3
begin tran 																								--	2966	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10538	, @begindate = '7/1/14', @enddate='12/31/14' --	2966	2
commit tran 																							--	2966	3
begin tran 																								--	2971	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10540	, @begindate = '7/1/14', @enddate='12/31/14' --	2971	2
commit tran 																							--	2971	3
begin tran 																								--	2972	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10545	, @begindate = '7/1/14', @enddate='12/31/14' --	2972	2
commit tran 																							--	2972	3
begin tran 																								--	2978	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10547	, @begindate = '7/1/14', @enddate='12/31/14' --	2978	2
commit tran 																							--	2978	3
begin tran 																								--	2979	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10578	, @begindate = '7/1/14', @enddate='12/31/14' --	2979	2
commit tran 																							--	2979	3
begin tran 																								--	2980	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10548	, @begindate = '7/1/14', @enddate='12/31/14' --	2980	2
commit tran 																							--	2980	3
begin tran 																								--	2987	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10541	, @begindate = '7/1/14', @enddate='12/31/14' --	2987	2
commit tran 																							--	2987	3
begin tran 																								--	2988	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10549	, @begindate = '7/1/14', @enddate='12/31/14' --	2988	2
commit tran 																							--	2988	3
begin tran 																								--	2991	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10551	, @begindate = '7/1/14', @enddate='12/31/14' --	2991	2
commit tran 																							--	2991	3
begin tran 																								--	2992	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10586	, @begindate = '7/1/14', @enddate='12/31/14' --	2992	2
commit tran 																							--	2992	3
begin tran 																								--	2994	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10587	, @begindate = '7/1/14', @enddate='12/31/14' --	2994	2
commit tran 																							--	2994	3
begin tran 																								--	2995	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10588	, @begindate = '7/1/14', @enddate='12/31/14' --	2995	2
commit tran 																							--	2995	3
begin tran 																								--	2999	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10554	, @begindate = '7/1/14', @enddate='12/31/14' --	2999	2
commit tran 																							--	2999	3
begin tran 																								--	3000	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10591	, @begindate = '7/1/14', @enddate='12/31/14' --	3000	2
commit tran 																							--	3000	3
begin tran 																								--	3001	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10592	, @begindate = '7/1/14', @enddate='12/31/14' --	3001	2
commit tran 																							--	3001	3
begin tran 																								--	3003	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10682	, @begindate = '7/1/14', @enddate='12/31/14' --	3003	2
commit tran 																							--	3003	3
begin tran 																								--	3010	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10726	, @begindate = '7/1/14', @enddate='12/31/14' --	3010	2
commit tran 																							--	3010	3
begin tran 																								--	3011	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10884	, @begindate = '7/1/14', @enddate='12/31/14' --	3011	2
commit tran 																							--	3011	3
begin tran 																								--	3012	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10727	, @begindate = '7/1/14', @enddate='12/31/14' --	3012	2
commit tran 																							--	3012	3
begin tran 																								--	3015	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10725	, @begindate = '7/1/14', @enddate='12/31/14' --	3015	2
commit tran 																							--	3015	3
begin tran 																								--	3021	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10557	, @begindate = '7/1/14', @enddate='12/31/14' --	3021	2
commit tran 																							--	3021	3
begin tran 																								--	3022	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10558	, @begindate = '7/1/14', @enddate='12/31/14' --	3022	2
commit tran 																							--	3022	3
begin tran 																								--	3023	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10574	, @begindate = '7/1/14', @enddate='12/31/14' --	3023	2
commit tran 																							--	3023	3
begin tran 																								--	3024	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10575	, @begindate = '7/1/14', @enddate='12/31/14' --	3024	2
commit tran 																							--	3024	3
begin tran 																								--	3025	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10579	, @begindate = '7/1/14', @enddate='12/31/14' --	3025	2
commit tran 																							--	3025	3
begin tran 																								--	3026	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10580	, @begindate = '7/1/14', @enddate='12/31/14' --	3026	2
commit tran 																							--	3026	3
begin tran 																								--	3029	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10584	, @begindate = '7/1/14', @enddate='12/31/14' --	3029	2
commit tran 																							--	3029	3
begin tran 																								--	3031	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10597	, @begindate = '7/1/14', @enddate='12/31/14' --	3031	2
commit tran 																							--	3031	3
begin tran 																								--	3032	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10639	, @begindate = '7/1/14', @enddate='12/31/14' --	3032	2
commit tran 																							--	3032	3
begin tran 																								--	3033	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10618	, @begindate = '7/1/14', @enddate='12/31/14' --	3033	2
commit tran 																							--	3033	3
begin tran 																								--	3039	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10659	, @begindate = '7/1/14', @enddate='12/31/14' --	3039	2
commit tran 																							--	3039	3
begin tran 																								--	3040	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10660	, @begindate = '7/1/14', @enddate='12/31/14' --	3040	2
commit tran 																							--	3040	3
begin tran 																								--	3041	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10661	, @begindate = '7/1/14', @enddate='12/31/14' --	3041	2
commit tran 																							--	3041	3
begin tran 																								--	3042	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10662	, @begindate = '7/1/14', @enddate='12/31/14' --	3042	2
commit tran 																							--	3042	3
begin tran 																								--	3043	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10646	, @begindate = '7/1/14', @enddate='12/31/14' --	3043	2
commit tran 																							--	3043	3
begin tran 																								--	3045	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10663	, @begindate = '7/1/14', @enddate='12/31/14' --	3045	2
commit tran 																							--	3045	3
begin tran 																								--	3046	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10603	, @begindate = '7/1/14', @enddate='12/31/14' --	3046	2
commit tran 																							--	3046	3
begin tran 																								--	3047	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10604	, @begindate = '7/1/14', @enddate='12/31/14' --	3047	2
commit tran 																							--	3047	3
begin tran 																								--	3048	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10627	, @begindate = '7/1/14', @enddate='12/31/14' --	3048	2
commit tran 																							--	3048	3
begin tran 																								--	3052	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10656	, @begindate = '7/1/14', @enddate='12/31/14' --	3052	2
commit tran 																							--	3052	3
begin tran 																								--	3053	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10622	, @begindate = '7/1/14', @enddate='12/31/14' --	3053	2
commit tran 																							--	3053	3
begin tran 																								--	3055	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10623	, @begindate = '7/1/14', @enddate='12/31/14' --	3055	2
commit tran 																							--	3055	3
begin tran 																								--	3056	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10624	, @begindate = '7/1/14', @enddate='12/31/14' --	3056	2
commit tran 																							--	3056	3
begin tran 																								--	3057	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10605	, @begindate = '7/1/14', @enddate='12/31/14' --	3057	2
commit tran 																							--	3057	3
begin tran 																								--	3058	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10630	, @begindate = '7/1/14', @enddate='12/31/14' --	3058	2
commit tran 																							--	3058	3
begin tran 																								--	3060	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10657	, @begindate = '7/1/14', @enddate='12/31/14' --	3060	2
commit tran 																							--	3060	3
begin tran 																								--	3061	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10645	, @begindate = '7/1/14', @enddate='12/31/14' --	3061	2
commit tran 																							--	3061	3
begin tran 																								--	3067	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10634	, @begindate = '7/1/14', @enddate='12/31/14' --	3067	2
commit tran 																							--	3067	3
begin tran 																								--	3068	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10606	, @begindate = '7/1/14', @enddate='12/31/14' --	3068	2
commit tran 																							--	3068	3
begin tran 																								--	3069	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10616	, @begindate = '7/1/14', @enddate='12/31/14' --	3069	2
commit tran 																							--	3069	3
begin tran 																								--	3071	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10608	, @begindate = '7/1/14', @enddate='12/31/14' --	3071	2
commit tran 																							--	3071	3
begin tran 																								--	3072	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10626	, @begindate = '7/1/14', @enddate='12/31/14' --	3072	2
commit tran 																							--	3072	3
begin tran 																								--	3076	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10638	, @begindate = '7/1/14', @enddate='12/31/14' --	3076	2
commit tran 																							--	3076	3
begin tran 																								--	3079	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10617	, @begindate = '7/1/14', @enddate='12/31/14' --	3079	2
commit tran 																							--	3079	3
begin tran 																								--	3080	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10640	, @begindate = '7/1/14', @enddate='12/31/14' --	3080	2
commit tran 																							--	3080	3
begin tran 																								--	3081	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10658	, @begindate = '7/1/14', @enddate='12/31/14' --	3081	2
commit tran 																							--	3081	3
begin tran 																								--	3082	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10647	, @begindate = '7/1/14', @enddate='12/31/14' --	3082	2
commit tran 																							--	3082	3
begin tran 																								--	3083	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10619	, @begindate = '7/1/14', @enddate='12/31/14' --	3083	2
commit tran 																							--	3083	3
begin tran 																								--	3084	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10641	, @begindate = '7/1/14', @enddate='12/31/14' --	3084	2
commit tran 																							--	3084	3
begin tran 																								--	3085	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10642	, @begindate = '7/1/14', @enddate='12/31/14' --	3085	2
commit tran 																							--	3085	3
begin tran 																								--	3088	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10643	, @begindate = '7/1/14', @enddate='12/31/14' --	3088	2
commit tran 																							--	3088	3
begin tran 																								--	3092	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10612	, @begindate = '7/1/14', @enddate='12/31/14' --	3092	2
commit tran 																							--	3092	3
begin tran 																								--	3093	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10644	, @begindate = '7/1/14', @enddate='12/31/14' --	3093	2
commit tran 																							--	3093	3
begin tran 																								--	3094	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10655	, @begindate = '7/1/14', @enddate='12/31/14' --	3094	2
commit tran 																							--	3094	3
begin tran 																								--	3095	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10636	, @begindate = '7/1/14', @enddate='12/31/14' --	3095	2
commit tran 																							--	3095	3
begin tran 																								--	3096	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10664	, @begindate = '7/1/14', @enddate='12/31/14' --	3096	2
commit tran 																							--	3096	3
begin tran 																								--	3097	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10718	, @begindate = '7/1/14', @enddate='12/31/14' --	3097	2
commit tran 																							--	3097	3
begin tran 																								--	3099	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10717	, @begindate = '7/1/14', @enddate='12/31/14' --	3099	2
commit tran 																							--	3099	3
begin tran 																								--	3100	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10683	, @begindate = '7/1/14', @enddate='12/31/14' --	3100	2
commit tran 																							--	3100	3
begin tran 																								--	3101	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10684	, @begindate = '7/1/14', @enddate='12/31/14' --	3101	2
commit tran 																							--	3101	3
begin tran 																								--	3102	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10685	, @begindate = '7/1/14', @enddate='12/31/14' --	3102	2
commit tran 																							--	3102	3
begin tran 																								--	3104	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10687	, @begindate = '7/1/14', @enddate='12/31/14' --	3104	2
commit tran 																							--	3104	3
begin tran 																								--	3105	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10688	, @begindate = '7/1/14', @enddate='12/31/14' --	3105	2
commit tran 																							--	3105	3
begin tran 																								--	3106	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10689	, @begindate = '7/1/14', @enddate='12/31/14' --	3106	2
commit tran 																							--	3106	3
begin tran 																								--	3109	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10693	, @begindate = '7/1/14', @enddate='12/31/14' --	3109	2
commit tran 																							--	3109	3
begin tran 																								--	3114	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10713	, @begindate = '7/1/14', @enddate='12/31/14' --	3114	2
commit tran 																							--	3114	3
begin tran 																								--	3117	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10702	, @begindate = '7/1/14', @enddate='12/31/14' --	3117	2
commit tran 																							--	3117	3
begin tran 																								--	3120	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10705	, @begindate = '7/1/14', @enddate='12/31/14' --	3120	2
commit tran 																							--	3120	3
begin tran 																								--	3122	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10707	, @begindate = '7/1/14', @enddate='12/31/14' --	3122	2
commit tran 																							--	3122	3
begin tran 																								--	3126	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10715	, @begindate = '7/1/14', @enddate='12/31/14' --	3126	2
commit tran 																							--	3126	3
begin tran 																								--	3128	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10719	, @begindate = '7/1/14', @enddate='12/31/14' --	3128	2
commit tran 																							--	3128	3
begin tran 																								--	3129	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10720	, @begindate = '7/1/14', @enddate='12/31/14' --	3129	2
commit tran 																							--	3129	3
begin tran 																								--	3131	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10722	, @begindate = '7/1/14', @enddate='12/31/14' --	3131	2
commit tran 																							--	3131	3
begin tran 																								--	3132	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10723	, @begindate = '7/1/14', @enddate='12/31/14' --	3132	2
commit tran 																							--	3132	3
begin tran 																								--	3133	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10724	, @begindate = '7/1/14', @enddate='12/31/14' --	3133	2
commit tran 																							--	3133	3
begin tran 																								--	3135	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10729	, @begindate = '7/1/14', @enddate='12/31/14' --	3135	2
commit tran 																							--	3135	3
begin tran 																								--	3136	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10730	, @begindate = '7/1/14', @enddate='12/31/14' --	3136	2
commit tran 																							--	3136	3
begin tran 																								--	3141	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10994	, @begindate = '7/1/14', @enddate='12/31/14' --	3141	2
commit tran 																							--	3141	3
begin tran 																								--	3142	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10967	, @begindate = '7/1/14', @enddate='12/31/14' --	3142	2
commit tran 																							--	3142	3
begin tran 																								--	3143	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10763	, @begindate = '7/1/14', @enddate='12/31/14' --	3143	2
commit tran 																							--	3143	3
begin tran 																								--	3144	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10807	, @begindate = '7/1/14', @enddate='12/31/14' --	3144	2
commit tran 																							--	3144	3
begin tran 																								--	3145	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10757	, @begindate = '7/1/14', @enddate='12/31/14' --	3145	2
commit tran 																							--	3145	3
begin tran 																								--	3147	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10760	, @begindate = '7/1/14', @enddate='12/31/14' --	3147	2
commit tran 																							--	3147	3
begin tran 																								--	3150	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10764	, @begindate = '7/1/14', @enddate='12/31/14' --	3150	2
commit tran 																							--	3150	3
begin tran 																								--	3151	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10765	, @begindate = '7/1/14', @enddate='12/31/14' --	3151	2
commit tran 																							--	3151	3
begin tran 																								--	3153	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10767	, @begindate = '7/1/14', @enddate='12/31/14' --	3153	2
commit tran 																							--	3153	3
begin tran 																								--	3156	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10770	, @begindate = '7/1/14', @enddate='12/31/14' --	3156	2
commit tran 																							--	3156	3
begin tran 																								--	3158	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10771	, @begindate = '7/1/14', @enddate='12/31/14' --	3158	2
commit tran 																							--	3158	3
begin tran 																								--	3159	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10772	, @begindate = '7/1/14', @enddate='12/31/14' --	3159	2
commit tran 																							--	3159	3
begin tran 																								--	3163	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10776	, @begindate = '7/1/14', @enddate='12/31/14' --	3163	2
commit tran 																							--	3163	3
begin tran 																								--	3165	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10778	, @begindate = '7/1/14', @enddate='12/31/14' --	3165	2
commit tran 																							--	3165	3
begin tran 																								--	3166	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10779	, @begindate = '7/1/14', @enddate='12/31/14' --	3166	2
commit tran 																							--	3166	3
begin tran 																								--	3167	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10780	, @begindate = '7/1/14', @enddate='12/31/14' --	3167	2
commit tran 																							--	3167	3
begin tran 																								--	3168	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10781	, @begindate = '7/1/14', @enddate='12/31/14' --	3168	2
commit tran 																							--	3168	3
begin tran 																								--	3170	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10783	, @begindate = '7/1/14', @enddate='12/31/14' --	3170	2
commit tran 																							--	3170	3
begin tran 																								--	3171	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10784	, @begindate = '7/1/14', @enddate='12/31/14' --	3171	2
commit tran 																							--	3171	3
begin tran 																								--	3172	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10785	, @begindate = '7/1/14', @enddate='12/31/14' --	3172	2
commit tran 																							--	3172	3
begin tran 																								--	3174	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10787	, @begindate = '7/1/14', @enddate='12/31/14' --	3174	2
commit tran 																							--	3174	3
begin tran 																								--	3175	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10788	, @begindate = '7/1/14', @enddate='12/31/14' --	3175	2
commit tran 																							--	3175	3
begin tran 																								--	3176	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10789	, @begindate = '7/1/14', @enddate='12/31/14' --	3176	2
commit tran 																							--	3176	3
begin tran 																								--	3177	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10790	, @begindate = '7/1/14', @enddate='12/31/14' --	3177	2
commit tran 																							--	3177	3
begin tran 																								--	3180	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10793	, @begindate = '7/1/14', @enddate='12/31/14' --	3180	2
commit tran 																							--	3180	3
begin tran 																								--	3183	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10796	, @begindate = '7/1/14', @enddate='12/31/14' --	3183	2
commit tran 																							--	3183	3
begin tran 																								--	3189	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10802	, @begindate = '7/1/14', @enddate='12/31/14' --	3189	2
commit tran 																							--	3189	3
begin tran 																								--	3190	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10803	, @begindate = '7/1/14', @enddate='12/31/14' --	3190	2
commit tran 																							--	3190	3
begin tran 																								--	3194	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10811	, @begindate = '7/1/14', @enddate='12/31/14' --	3194	2
commit tran 																							--	3194	3
begin tran 																								--	3195	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10813	, @begindate = '7/1/14', @enddate='12/31/14' --	3195	2
commit tran 																							--	3195	3
begin tran 																								--	3197	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10818	, @begindate = '7/1/14', @enddate='12/31/14' --	3197	2
commit tran 																							--	3197	3
begin tran 																								--	3199	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10820	, @begindate = '7/1/14', @enddate='12/31/14' --	3199	2
commit tran 																							--	3199	3
begin tran 																								--	3201	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10822	, @begindate = '7/1/14', @enddate='12/31/14' --	3201	2
commit tran 																							--	3201	3
begin tran 																								--	3202	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10823	, @begindate = '7/1/14', @enddate='12/31/14' --	3202	2
commit tran 																							--	3202	3
begin tran 																								--	3203	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10824	, @begindate = '7/1/14', @enddate='12/31/14' --	3203	2
commit tran 																							--	3203	3
begin tran 																								--	3207	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10829	, @begindate = '7/1/14', @enddate='12/31/14' --	3207	2
commit tran 																							--	3207	3
begin tran 																								--	3211	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10833	, @begindate = '7/1/14', @enddate='12/31/14' --	3211	2
commit tran 																							--	3211	3
begin tran 																								--	3212	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10835	, @begindate = '7/1/14', @enddate='12/31/14' --	3212	2
commit tran 																							--	3212	3
begin tran 																								--	3213	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10836	, @begindate = '7/1/14', @enddate='12/31/14' --	3213	2
commit tran 																							--	3213	3
begin tran 																								--	3216	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10838	, @begindate = '7/1/14', @enddate='12/31/14' --	3216	2
commit tran 																							--	3216	3
begin tran 																								--	3217	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10839	, @begindate = '7/1/14', @enddate='12/31/14' --	3217	2
commit tran 																							--	3217	3
begin tran 																								--	3220	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10844	, @begindate = '7/1/14', @enddate='12/31/14' --	3220	2
commit tran 																							--	3220	3
begin tran 																								--	3222	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10846	, @begindate = '7/1/14', @enddate='12/31/14' --	3222	2
commit tran 																							--	3222	3
begin tran 																								--	3224	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10849	, @begindate = '7/1/14', @enddate='12/31/14' --	3224	2
commit tran 																							--	3224	3
begin tran 																								--	3225	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10850	, @begindate = '7/1/14', @enddate='12/31/14' --	3225	2
commit tran 																							--	3225	3
begin tran 																								--	3227	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10856	, @begindate = '7/1/14', @enddate='12/31/14' --	3227	2
commit tran 																							--	3227	3
begin tran 																								--	3230	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10860	, @begindate = '7/1/14', @enddate='12/31/14' --	3230	2
commit tran 																							--	3230	3
begin tran 																								--	3232	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10862	, @begindate = '7/1/14', @enddate='12/31/14' --	3232	2
commit tran 																							--	3232	3
begin tran 																								--	3242	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10869	, @begindate = '7/1/14', @enddate='12/31/14' --	3242	2
commit tran 																							--	3242	3
begin tran 																								--	3245	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10872	, @begindate = '7/1/14', @enddate='12/31/14' --	3245	2
commit tran 																							--	3245	3
begin tran 																								--	3246	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10873	, @begindate = '7/1/14', @enddate='12/31/14' --	3246	2
commit tran 																							--	3246	3
begin tran 																								--	3247	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10874	, @begindate = '7/1/14', @enddate='12/31/14' --	3247	2
commit tran 																							--	3247	3
begin tran 																								--	3248	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10875	, @begindate = '7/1/14', @enddate='12/31/14' --	3248	2
commit tran 																							--	3248	3
begin tran 																								--	3252	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10878	, @begindate = '7/1/14', @enddate='12/31/14' --	3252	2
commit tran 																							--	3252	3
begin tran 																								--	3253	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10897	, @begindate = '7/1/14', @enddate='12/31/14' --	3253	2
commit tran 																							--	3253	3
begin tran 																								--	3257	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10906	, @begindate = '7/1/14', @enddate='12/31/14' --	3257	2
commit tran 																							--	3257	3
begin tran 																								--	3261	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10912	, @begindate = '7/1/14', @enddate='12/31/14' --	3261	2
commit tran 																							--	3261	3
begin tran 																								--	3262	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10913	, @begindate = '7/1/14', @enddate='12/31/14' --	3262	2
commit tran 																							--	3262	3
begin tran 																								--	3263	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10914	, @begindate = '7/1/14', @enddate='12/31/14' --	3263	2
commit tran 																							--	3263	3
begin tran 																								--	3265	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10916	, @begindate = '7/1/14', @enddate='12/31/14' --	3265	2
commit tran 																							--	3265	3
begin tran 																								--	3266	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10917	, @begindate = '7/1/14', @enddate='12/31/14' --	3266	2
commit tran 																							--	3266	3
begin tran 																								--	3269	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10924	, @begindate = '7/1/14', @enddate='12/31/14' --	3269	2
commit tran 																							--	3269	3
begin tran 																								--	3272	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10929	, @begindate = '7/1/14', @enddate='12/31/14' --	3272	2
commit tran 																							--	3272	3
begin tran 																								--	3273	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10930	, @begindate = '7/1/14', @enddate='12/31/14' --	3273	2
commit tran 																							--	3273	3
begin tran 																								--	3274	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10928	, @begindate = '7/1/14', @enddate='12/31/14' --	3274	2
commit tran 																							--	3274	3
begin tran 																								--	3279	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10918	, @begindate = '7/1/14', @enddate='12/31/14' --	3279	2
commit tran 																							--	3279	3
begin tran 																								--	3280	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10911	, @begindate = '7/1/14', @enddate='12/31/14' --	3280	2
commit tran 																							--	3280	3
begin tran 																								--	3281	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10909	, @begindate = '7/1/14', @enddate='12/31/14' --	3281	2
commit tran 																							--	3281	3
begin tran 																								--	3282	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10904	, @begindate = '7/1/14', @enddate='12/31/14' --	3282	2
commit tran 																							--	3282	3
begin tran 																								--	3283	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10903	, @begindate = '7/1/14', @enddate='12/31/14' --	3283	2
commit tran 																							--	3283	3
begin tran 																								--	3288	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10894	, @begindate = '7/1/14', @enddate='12/31/14' --	3288	2
commit tran 																							--	3288	3
begin tran 																								--	3292	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10890	, @begindate = '7/1/14', @enddate='12/31/14' --	3292	2
commit tran 																							--	3292	3
begin tran 																								--	3299	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10855	, @begindate = '7/1/14', @enddate='12/31/14' --	3299	2
commit tran 																							--	3299	3
begin tran 																								--	3302	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10851	, @begindate = '7/1/14', @enddate='12/31/14' --	3302	2
commit tran 																							--	3302	3
begin tran 																								--	3305	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10840	, @begindate = '7/1/14', @enddate='12/31/14' --	3305	2
commit tran 																							--	3305	3
begin tran 																								--	3306	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10834	, @begindate = '7/1/14', @enddate='12/31/14' --	3306	2
commit tran 																							--	3306	3
begin tran 																								--	3307	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10830	, @begindate = '7/1/14', @enddate='12/31/14' --	3307	2
commit tran 																							--	3307	3
begin tran 																								--	3308	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10828	, @begindate = '7/1/14', @enddate='12/31/14' --	3308	2
commit tran 																							--	3308	3
begin tran 																								--	3309	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10816	, @begindate = '7/1/14', @enddate='12/31/14' --	3309	2
commit tran 																							--	3309	3
begin tran 																								--	3310	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10814	, @begindate = '7/1/14', @enddate='12/31/14' --	3310	2
commit tran 																							--	3310	3
begin tran 																								--	3311	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10812	, @begindate = '7/1/14', @enddate='12/31/14' --	3311	2
commit tran 																							--	3311	3
begin tran 																								--	3314	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10808	, @begindate = '7/1/14', @enddate='12/31/14' --	3314	2
commit tran 																							--	3314	3
begin tran 																								--	3317	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15749	, @begindate = '1/1/14', @enddate='12/31/14' --	3317	2
commit tran 																							--	3317	3
begin tran 																								--	3320	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10957	, @begindate = '7/1/14', @enddate='12/31/14' --	3320	2
commit tran 																							--	3320	3
begin tran 																								--	3321	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10934	, @begindate = '7/1/14', @enddate='12/31/14' --	3321	2
commit tran 																							--	3321	3
begin tran 																								--	3324	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10937	, @begindate = '7/1/14', @enddate='12/31/14' --	3324	2
commit tran 																							--	3324	3
begin tran 																								--	3325	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10942	, @begindate = '7/1/14', @enddate='12/31/14' --	3325	2
commit tran 																							--	3325	3
begin tran 																								--	3328	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10944	, @begindate = '7/1/14', @enddate='12/31/14' --	3328	2
commit tran 																							--	3328	3
begin tran 																								--	3329	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10961	, @begindate = '7/1/14', @enddate='12/31/14' --	3329	2
commit tran 																							--	3329	3
begin tran 																								--	3330	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10955	, @begindate = '7/1/14', @enddate='12/31/14' --	3330	2
commit tran 																							--	3330	3
begin tran 																								--	3333	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10953	, @begindate = '7/1/14', @enddate='12/31/14' --	3333	2
commit tran 																							--	3333	3
begin tran 																								--	3336	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10933	, @begindate = '7/1/14', @enddate='12/31/14' --	3336	2
commit tran 																							--	3336	3
begin tran 																								--	3337	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10935	, @begindate = '7/1/14', @enddate='12/31/14' --	3337	2
commit tran 																							--	3337	3
begin tran 																								--	3341	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10940	, @begindate = '7/1/14', @enddate='12/31/14' --	3341	2
commit tran 																							--	3341	3
begin tran 																								--	3342	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10965	, @begindate = '7/1/14', @enddate='12/31/14' --	3342	2
commit tran 																							--	3342	3
begin tran 																								--	3343	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10954	, @begindate = '7/1/14', @enddate='12/31/14' --	3343	2
commit tran 																							--	3343	3
begin tran 																								--	3345	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10945	, @begindate = '7/1/14', @enddate='12/31/14' --	3345	2
commit tran 																							--	3345	3
begin tran 																								--	3347	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10946	, @begindate = '7/1/14', @enddate='12/31/14' --	3347	2
commit tran 																							--	3347	3
begin tran 																								--	3349	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10948	, @begindate = '7/1/14', @enddate='12/31/14' --	3349	2
commit tran 																							--	3349	3
begin tran 																								--	3350	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10949	, @begindate = '7/1/14', @enddate='12/31/14' --	3350	2
commit tran 																							--	3350	3
begin tran 																								--	3351	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10969	, @begindate = '7/1/14', @enddate='12/31/14' --	3351	2
commit tran 																							--	3351	3
begin tran 																								--	3352	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10970	, @begindate = '7/1/14', @enddate='12/31/14' --	3352	2
commit tran 																							--	3352	3
begin tran 																								--	3353	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10950	, @begindate = '7/1/14', @enddate='12/31/14' --	3353	2
commit tran 																							--	3353	3
begin tran 																								--	3354	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10951	, @begindate = '7/1/14', @enddate='12/31/14' --	3354	2
commit tran 																							--	3354	3
begin tran 																								--	3356	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10941	, @begindate = '7/1/14', @enddate='12/31/14' --	3356	2
commit tran 																							--	3356	3
begin tran 																								--	3358	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11563	, @begindate = '7/1/14', @enddate='12/31/14' --	3358	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11561	, @begindate = '7/1/14', @enddate='12/31/14' --	3358	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11562	, @begindate = '7/1/14', @enddate='12/31/14' --	3358	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10972	, @begindate = '7/1/14', @enddate='12/31/14' --	3358	2
commit tran 																							--	3358	3
begin tran 																								--	3359	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10971	, @begindate = '7/1/14', @enddate='12/31/14' --	3359	2
commit tran 																							--	3359	3
begin tran 																								--	3367	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	10985	, @begindate = '7/1/14', @enddate='12/31/14' --	3367	2
commit tran 																							--	3367	3
begin tran 																								--	3371	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11007	, @begindate = '7/1/14', @enddate='12/31/14' --	3371	2
commit tran 																							--	3371	3
begin tran 																								--	3372	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11008	, @begindate = '7/1/14', @enddate='12/31/14' --	3372	2
commit tran 																							--	3372	3
begin tran 																								--	3381	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11021	, @begindate = '7/1/14', @enddate='12/31/14' --	3381	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11020	, @begindate = '7/1/14', @enddate='12/31/14' --	3381	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11019	, @begindate = '7/1/14', @enddate='12/31/14' --	3381	2
commit tran 																							--	3381	3
begin tran 																								--	3383	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11063	, @begindate = '7/1/14', @enddate='12/31/14' --	3383	2
commit tran 																							--	3383	3
begin tran 																								--	3385	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11069	, @begindate = '7/1/14', @enddate='12/31/14' --	3385	2
commit tran 																							--	3385	3
begin tran 																								--	3387	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11070	, @begindate = '7/1/14', @enddate='12/31/14' --	3387	2
commit tran 																							--	3387	3
begin tran 																								--	3388	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11071	, @begindate = '7/1/14', @enddate='12/31/14' --	3388	2
commit tran 																							--	3388	3
begin tran 																								--	3389	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11072	, @begindate = '7/1/14', @enddate='12/31/14' --	3389	2
commit tran 																							--	3389	3
begin tran 																								--	3390	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11073	, @begindate = '7/1/14', @enddate='12/31/14' --	3390	2
commit tran 																							--	3390	3
begin tran 																								--	3396	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11091	, @begindate = '7/1/14', @enddate='12/31/14' --	3396	2
commit tran 																							--	3396	3
begin tran 																								--	3397	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11092	, @begindate = '7/1/14', @enddate='12/31/14' --	3397	2
commit tran 																							--	3397	3
begin tran 																								--	3398	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11093	, @begindate = '7/1/14', @enddate='12/31/14' --	3398	2
commit tran 																							--	3398	3
begin tran 																								--	3399	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11094	, @begindate = '7/1/14', @enddate='12/31/14' --	3399	2
commit tran 																							--	3399	3
begin tran 																								--	3401	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11096	, @begindate = '7/1/14', @enddate='12/31/14' --	3401	2
commit tran 																							--	3401	3
begin tran 																								--	3422	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11117	, @begindate = '7/1/14', @enddate='12/31/14' --	3422	2
commit tran 																							--	3422	3
begin tran 																								--	3423	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11118	, @begindate = '7/1/14', @enddate='12/31/14' --	3423	2
commit tran 																							--	3423	3
begin tran 																								--	3424	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11119	, @begindate = '7/1/14', @enddate='12/31/14' --	3424	2
commit tran 																							--	3424	3
begin tran 																								--	3427	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11122	, @begindate = '7/1/14', @enddate='12/31/14' --	3427	2
commit tran 																							--	3427	3
begin tran 																								--	3428	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11123	, @begindate = '7/1/14', @enddate='12/31/14' --	3428	2
commit tran 																							--	3428	3
begin tran 																								--	3429	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11124	, @begindate = '7/1/14', @enddate='12/31/14' --	3429	2
commit tran 																							--	3429	3
begin tran 																								--	3430	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11125	, @begindate = '7/1/14', @enddate='12/31/14' --	3430	2
commit tran 																							--	3430	3
begin tran 																								--	3431	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11126	, @begindate = '7/1/14', @enddate='12/31/14' --	3431	2
commit tran 																							--	3431	3
begin tran 																								--	3432	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11127	, @begindate = '7/1/14', @enddate='12/31/14' --	3432	2
commit tran 																							--	3432	3
begin tran 																								--	3433	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11128	, @begindate = '7/1/14', @enddate='12/31/14' --	3433	2
commit tran 																							--	3433	3
begin tran 																								--	3437	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11132	, @begindate = '7/1/14', @enddate='12/31/14' --	3437	2
commit tran 																							--	3437	3
begin tran 																								--	3439	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11134	, @begindate = '7/1/14', @enddate='12/31/14' --	3439	2
commit tran 																							--	3439	3
begin tran 																								--	3440	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11135	, @begindate = '7/1/14', @enddate='12/31/14' --	3440	2
commit tran 																							--	3440	3
begin tran 																								--	3441	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11136	, @begindate = '7/1/14', @enddate='12/31/14' --	3441	2
commit tran 																							--	3441	3
begin tran 																								--	3442	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11137	, @begindate = '7/1/14', @enddate='12/31/14' --	3442	2
commit tran 																							--	3442	3
begin tran 																								--	3443	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11138	, @begindate = '7/1/14', @enddate='12/31/14' --	3443	2
commit tran 																							--	3443	3
begin tran 																								--	3444	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11139	, @begindate = '7/1/14', @enddate='12/31/14' --	3444	2
commit tran 																							--	3444	3
begin tran 																								--	3445	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11140	, @begindate = '7/1/14', @enddate='12/31/14' --	3445	2
commit tran 																							--	3445	3
begin tran 																								--	3447	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11142	, @begindate = '7/1/14', @enddate='12/31/14' --	3447	2
commit tran 																							--	3447	3
begin tran 																								--	3448	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11143	, @begindate = '7/1/14', @enddate='12/31/14' --	3448	2
commit tran 																							--	3448	3
begin tran 																								--	3449	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11144	, @begindate = '7/1/14', @enddate='12/31/14' --	3449	2
commit tran 																							--	3449	3
begin tran 																								--	3451	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11146	, @begindate = '7/1/14', @enddate='12/31/14' --	3451	2
commit tran 																							--	3451	3
begin tran 																								--	3453	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11148	, @begindate = '7/1/14', @enddate='12/31/14' --	3453	2
commit tran 																							--	3453	3
begin tran 																								--	3455	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11150	, @begindate = '7/1/14', @enddate='12/31/14' --	3455	2
commit tran 																							--	3455	3
begin tran 																								--	3456	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11151	, @begindate = '7/1/14', @enddate='12/31/14' --	3456	2
commit tran 																							--	3456	3
begin tran 																								--	3458	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11153	, @begindate = '7/1/14', @enddate='12/31/14' --	3458	2
commit tran 																							--	3458	3
begin tran 																								--	3468	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11163	, @begindate = '7/1/14', @enddate='12/31/14' --	3468	2
commit tran 																							--	3468	3
begin tran 																								--	3473	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11168	, @begindate = '7/1/14', @enddate='12/31/14' --	3473	2
commit tran 																							--	3473	3
begin tran 																								--	3475	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11170	, @begindate = '7/1/14', @enddate='12/31/14' --	3475	2
commit tran 																							--	3475	3
begin tran 																								--	3478	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11176	, @begindate = '7/1/14', @enddate='12/31/14' --	3478	2
commit tran 																							--	3478	3
begin tran 																								--	3479	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11177	, @begindate = '7/1/14', @enddate='12/31/14' --	3479	2
commit tran 																							--	3479	3
begin tran 																								--	3488	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11542	, @begindate = '7/1/14', @enddate='12/31/14' --	3488	2
commit tran 																							--	3488	3
begin tran 																								--	3505	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11331	, @begindate = '1/1/14', @enddate='12/31/14' --	3505	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11208	, @begindate = '1/1/14', @enddate='12/31/14' --	3505	2
commit tran 																							--	3505	3
begin tran 																								--	3508	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11205	, @begindate = '7/1/14', @enddate='12/31/14' --	3508	2
commit tran 																							--	3508	3
begin tran 																								--	3532	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11293	, @begindate = '1/1/14', @enddate='12/31/14' --	3532	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11498	, @begindate = '1/1/14', @enddate='12/31/14' --	3532	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11516	, @begindate = '1/1/14', @enddate='12/31/14' --	3532	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11530	, @begindate = '1/1/14', @enddate='12/31/14' --	3532	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11528	, @begindate = '1/1/14', @enddate='12/31/14' --	3532	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11499	, @begindate = '1/1/14', @enddate='12/31/14' --	3532	2
commit tran 																							--	3532	3
begin tran 																								--	3539	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13867	, @begindate = '1/1/14', @enddate='12/31/14' --	3539	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13855	, @begindate = '1/1/14', @enddate='12/31/14' --	3539	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13868	, @begindate = '1/1/14', @enddate='12/31/14' --	3539	2
commit tran 																							--	3539	3
begin tran 																								--	3555	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11372	, @begindate = '7/1/14', @enddate='12/31/14' --	3555	2
commit tran 																							--	3555	3
begin tran 																								--	3558	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16539	, @begindate = '1/1/14', @enddate='12/31/14' --	3558	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11806	, @begindate = '1/1/14', @enddate='12/31/14' --	3558	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12732	, @begindate = '1/1/14', @enddate='12/31/14' --	3558	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16540	, @begindate = '1/1/14', @enddate='12/31/14' --	3558	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16541	, @begindate = '1/1/14', @enddate='12/31/14' --	3558	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16542	, @begindate = '1/1/14', @enddate='12/31/14' --	3558	2
commit tran 																							--	3558	3
begin tran 																								--	3560	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16307	, @begindate = '1/1/14', @enddate='12/31/14' --	3560	2
commit tran 																							--	3560	3
begin tran 																								--	3571	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11714	, @begindate = '1/1/14', @enddate='12/31/14' --	3571	2
commit tran 																							--	3571	3
begin tran 																								--	3573	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11526	, @begindate = '7/1/14', @enddate='12/31/14' --	3573	2
commit tran 																							--	3573	3
begin tran 																								--	3578	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13115	, @begindate = '1/1/14', @enddate='12/31/14' --	3578	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14317	, @begindate = '1/1/14', @enddate='12/31/14' --	3578	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11577	, @begindate = '1/1/14', @enddate='12/31/14' --	3578	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14267	, @begindate = '1/1/14', @enddate='12/31/14' --	3578	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11578	, @begindate = '1/1/14', @enddate='12/31/14' --	3578	2
commit tran 																							--	3578	3
begin tran 																								--	3583	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11962	, @begindate = '7/1/14', @enddate='12/31/14' --	3583	2
commit tran 																							--	3583	3
begin tran 																								--	3587	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11799	, @begindate = '7/1/14', @enddate='12/31/14' --	3587	2
commit tran 																							--	3587	3
begin tran 																								--	3592	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16241	, @begindate = '1/1/14', @enddate='12/31/14' --	3592	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11618	, @begindate = '1/1/14', @enddate='12/31/14' --	3592	2
commit tran 																							--	3592	3
begin tran 																								--	3593	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11621	, @begindate = '1/1/14', @enddate='12/31/14' --	3593	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11622	, @begindate = '1/1/14', @enddate='12/31/14' --	3593	2
commit tran 																							--	3593	3
begin tran 																								--	3597	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11639	, @begindate = '1/1/14', @enddate='12/31/14' --	3597	2
commit tran 																							--	3597	3
begin tran 																								--	3599	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11716	, @begindate = '7/1/14', @enddate='12/31/14' --	3599	2
commit tran 																							--	3599	3
begin tran 																								--	3605	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16191	, @begindate = '1/1/14', @enddate='12/31/14' --	3605	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16192	, @begindate = '1/1/14', @enddate='12/31/14' --	3605	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16190	, @begindate = '1/1/14', @enddate='12/31/14' --	3605	2
commit tran 																							--	3605	3
begin tran 																								--	3609	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12310	, @begindate = '1/1/14', @enddate='12/31/14' --	3609	2
commit tran 																							--	3609	3
begin tran 																								--	3612	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11662	, @begindate = '7/1/14', @enddate='12/31/14' --	3612	2
commit tran 																							--	3612	3
begin tran 																								--	3614	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11670	, @begindate = '7/1/14', @enddate='12/31/14' --	3614	2
commit tran 																							--	3614	3
begin tran 																								--	3616	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11873	, @begindate = '1/1/14', @enddate='12/31/14' --	3616	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16007	, @begindate = '1/1/14', @enddate='12/31/14' --	3616	2
commit tran 																							--	3616	3
begin tran 																								--	3619	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11678	, @begindate = '1/1/14', @enddate='12/31/14' --	3619	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16221	, @begindate = '1/1/14', @enddate='12/31/14' --	3619	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16220	, @begindate = '1/1/14', @enddate='12/31/14' --	3619	2
commit tran 																							--	3619	3
begin tran 																								--	3631	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11792	, @begindate = '7/1/14', @enddate='12/31/14' --	3631	2
commit tran 																							--	3631	3
begin tran 																								--	3634	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11713	, @begindate = '7/1/14', @enddate='12/31/14' --	3634	2
commit tran 																							--	3634	3
begin tran 																								--	3649	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15948	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13578	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15949	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15876	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13487	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13499	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15874	, @begindate = '1/1/14', @enddate='12/31/14' --	3649	2
commit tran 																							--	3649	3
begin tran 																								--	3660	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11812	, @begindate = '7/1/14', @enddate='12/31/14' --	3660	2
commit tran 																							--	3660	3
begin tran 																								--	3665	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14895	, @begindate = '1/1/14', @enddate='12/31/14' --	3665	2
commit tran 																							--	3665	3
begin tran 																								--	3674	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11842	, @begindate = '1/1/14', @enddate='12/31/14' --	3674	2
commit tran 																							--	3674	3
begin tran 																								--	3680	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11871	, @begindate = '1/1/14', @enddate='12/31/14' --	3680	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11867	, @begindate = '1/1/14', @enddate='12/31/14' --	3680	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11858	, @begindate = '1/1/14', @enddate='12/31/14' --	3680	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11863	, @begindate = '1/1/14', @enddate='12/31/14' --	3680	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11861	, @begindate = '1/1/14', @enddate='12/31/14' --	3680	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11864	, @begindate = '1/1/14', @enddate='12/31/14' --	3680	2
commit tran 																							--	3680	3
begin tran 																								--	3683	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15940	, @begindate = '1/1/14', @enddate='12/31/14' --	3683	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11885	, @begindate = '1/1/14', @enddate='12/31/14' --	3683	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15941	, @begindate = '1/1/14', @enddate='12/31/14' --	3683	2
commit tran 																							--	3683	3
begin tran 																								--	3694	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12048	, @begindate = '1/1/14', @enddate='12/31/14' --	3694	2
commit tran 																							--	3694	3
begin tran 																								--	3696	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11965	, @begindate = '7/1/14', @enddate='12/31/14' --	3696	2
commit tran 																							--	3696	3
begin tran 																								--	3697	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16318	, @begindate = '1/1/14', @enddate='12/31/14' --	3697	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16319	, @begindate = '1/1/14', @enddate='12/31/14' --	3697	2
commit tran 																							--	3697	3
begin tran 																								--	3698	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15894	, @begindate = '1/1/14', @enddate='12/31/14' --	3698	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16377	, @begindate = '1/1/14', @enddate='12/31/14' --	3698	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11991	, @begindate = '1/1/14', @enddate='12/31/14' --	3698	2
commit tran 																							--	3698	3
begin tran 																								--	3701	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	11983	, @begindate = '1/1/14', @enddate='12/31/14' --	3701	2
commit tran 																							--	3701	3
begin tran 																								--	3706	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12069	, @begindate = '1/1/14', @enddate='12/31/14' --	3706	2
commit tran 																							--	3706	3
begin tran 																								--	3712	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13665	, @begindate = '1/1/14', @enddate='12/31/14' --	3712	2
commit tran 																							--	3712	3
begin tran 																								--	3716	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12587	, @begindate = '1/1/14', @enddate='12/31/14' --	3716	2
commit tran 																							--	3716	3
begin tran 																								--	3721	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12913	, @begindate = '1/1/14', @enddate='12/31/14' --	3721	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15950	, @begindate = '1/1/14', @enddate='12/31/14' --	3721	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12906	, @begindate = '1/1/14', @enddate='12/31/14' --	3721	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16310	, @begindate = '1/1/14', @enddate='12/31/14' --	3721	2
commit tran 																							--	3721	3
begin tran 																								--	3726	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12119	, @begindate = '1/1/14', @enddate='12/31/14' --	3726	2
commit tran 																							--	3726	3
begin tran 																								--	3728	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12115	, @begindate = '1/1/14', @enddate='12/31/14' --	3728	2
commit tran 																							--	3728	3
begin tran 																								--	3734	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12170	, @begindate = '7/1/14', @enddate='12/31/14' --	3734	2
commit tran 																							--	3734	3
begin tran 																								--	3736	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12186	, @begindate = '1/1/14', @enddate='12/31/14' --	3736	2
commit tran 																							--	3736	3
begin tran 																								--	3737	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12307	, @begindate = '7/1/14', @enddate='12/31/14' --	3737	2
commit tran 																							--	3737	3
begin tran 																								--	3740	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15868	, @begindate = '1/1/14', @enddate='12/31/14' --	3740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15867	, @begindate = '1/1/14', @enddate='12/31/14' --	3740	2
commit tran 																							--	3740	3
begin tran 																								--	3741	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12204	, @begindate = '7/1/14', @enddate='12/31/14' --	3741	2
commit tran 																							--	3741	3
begin tran 																								--	3749	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12220	, @begindate = '1/1/14', @enddate='12/31/14' --	3749	2
commit tran 																							--	3749	3
begin tran 																								--	3754	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12238	, @begindate = '7/1/14', @enddate='12/31/14' --	3754	2
commit tran 																							--	3754	3
begin tran 																								--	3755	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12424	, @begindate = '7/1/14', @enddate='12/31/14' --	3755	2
commit tran 																							--	3755	3
begin tran 																								--	3758	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12341	, @begindate = '7/1/14', @enddate='12/31/14' --	3758	2
commit tran 																							--	3758	3
begin tran 																								--	3759	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12597	, @begindate = '1/1/14', @enddate='12/31/14' --	3759	2
commit tran 																							--	3759	3
begin tran 																								--	3765	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14554	, @begindate = '1/1/14', @enddate='12/31/14' --	3765	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16133	, @begindate = '1/1/14', @enddate='12/31/14' --	3765	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14562	, @begindate = '1/1/14', @enddate='12/31/14' --	3765	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16134	, @begindate = '1/1/14', @enddate='12/31/14' --	3765	2
commit tran 																							--	3765	3
begin tran 																								--	3777	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12421	, @begindate = '7/1/14', @enddate='12/31/14' --	3777	2
commit tran 																							--	3777	3
begin tran 																								--	3780	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12334	, @begindate = '7/1/14', @enddate='12/31/14' --	3780	2
commit tran 																							--	3780	3
begin tran 																								--	3781	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12393	, @begindate = '1/1/14', @enddate='12/31/14' --	3781	2
commit tran 																							--	3781	3
begin tran 																								--	3788	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13032	, @begindate = '1/1/14', @enddate='12/31/14' --	3788	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14999	, @begindate = '1/1/14', @enddate='12/31/14' --	3788	2
commit tran 																							--	3788	3
begin tran 																								--	3790	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12404	, @begindate = '1/1/14', @enddate='12/31/14' --	3790	2
commit tran 																							--	3790	3
begin tran 																								--	3793	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12470	, @begindate = '7/1/14', @enddate='12/31/14' --	3793	2
commit tran 																							--	3793	3
begin tran 																								--	3796	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12455	, @begindate = '7/1/14', @enddate='12/31/14' --	3796	2
commit tran 																							--	3796	3
begin tran 																								--	3799	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12516	, @begindate = '1/1/14', @enddate='12/31/14' --	3799	2
commit tran 																							--	3799	3
begin tran 																								--	3802	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12427	, @begindate = '1/1/14', @enddate='12/31/14' --	3802	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16638	, @begindate = '1/1/14', @enddate='12/31/14' --	3802	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16634	, @begindate = '1/1/14', @enddate='12/31/14' --	3802	2
commit tran 																							--	3802	3
begin tran 																								--	3803	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12472	, @begindate = '7/1/14', @enddate='12/31/14' --	3803	2
commit tran 																							--	3803	3
begin tran 																								--	3806	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12462	, @begindate = '7/1/14', @enddate='12/31/14' --	3806	2
commit tran 																							--	3806	3
begin tran 																								--	3808	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12467	, @begindate = '1/1/14', @enddate='12/31/14' --	3808	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13357	, @begindate = '1/1/14', @enddate='12/31/14' --	3808	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13356	, @begindate = '1/1/14', @enddate='12/31/14' --	3808	2
commit tran 																							--	3808	3
begin tran 																								--	3810	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12852	, @begindate = '1/1/14', @enddate='12/31/14' --	3810	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12474	, @begindate = '1/1/14', @enddate='12/31/14' --	3810	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12475	, @begindate = '1/1/14', @enddate='12/31/14' --	3810	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12851	, @begindate = '1/1/14', @enddate='12/31/14' --	3810	2
commit tran 																							--	3810	3
begin tran 																								--	3811	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12473	, @begindate = '7/1/14', @enddate='12/31/14' --	3811	2
commit tran 																							--	3811	3
begin tran 																								--	3814	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12477	, @begindate = '7/1/14', @enddate='12/31/14' --	3814	2
commit tran 																							--	3814	3
begin tran 																								--	3815	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12478	, @begindate = '7/1/14', @enddate='12/31/14' --	3815	2
commit tran 																							--	3815	3
begin tran 																								--	3817	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12498	, @begindate = '7/1/14', @enddate='12/31/14' --	3817	2
commit tran 																							--	3817	3
begin tran 																								--	3819	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12505	, @begindate = '1/1/14', @enddate='12/31/14' --	3819	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12504	, @begindate = '1/1/14', @enddate='12/31/14' --	3819	2
commit tran 																							--	3819	3
begin tran 																								--	3821	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12528	, @begindate = '1/1/14', @enddate='12/31/14' --	3821	2
commit tran 																							--	3821	3
begin tran 																								--	3829	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15635	, @begindate = '1/1/14', @enddate='12/31/14' --	3829	2
commit tran 																							--	3829	3
begin tran 																								--	3832	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15694	, @begindate = '1/1/14', @enddate='12/31/14' --	3832	2
commit tran 																							--	3832	3
begin tran 																								--	3847	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15709	, @begindate = '1/1/14', @enddate='12/31/14' --	3847	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15599	, @begindate = '1/1/14', @enddate='12/31/14' --	3847	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15603	, @begindate = '1/1/14', @enddate='12/31/14' --	3847	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15604	, @begindate = '1/1/14', @enddate='12/31/14' --	3847	2
commit tran 																							--	3847	3
begin tran 																								--	3848	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12580	, @begindate = '1/1/14', @enddate='12/31/14' --	3848	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15877	, @begindate = '1/1/14', @enddate='12/31/14' --	3848	2
commit tran 																							--	3848	3
begin tran 																								--	3850	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12789	, @begindate = '7/1/14', @enddate='12/31/14' --	3850	2
commit tran 																							--	3850	3
begin tran 																								--	3856	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16401	, @begindate = '1/1/14', @enddate='12/31/14' --	3856	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12623	, @begindate = '1/1/14', @enddate='12/31/14' --	3856	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12626	, @begindate = '1/1/14', @enddate='12/31/14' --	3856	2
commit tran 																							--	3856	3
begin tran 																								--	3857	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12624	, @begindate = '7/1/14', @enddate='12/31/14' --	3857	2
commit tran 																							--	3857	3
begin tran 																								--	3860	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12802	, @begindate = '7/1/14', @enddate='12/31/14' --	3860	2
commit tran 																							--	3860	3
begin tran 																								--	3861	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12791	, @begindate = '7/1/14', @enddate='12/31/14' --	3861	2
commit tran 																							--	3861	3
begin tran 																								--	3872	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14471	, @begindate = '1/1/14', @enddate='12/31/14' --	3872	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12778	, @begindate = '1/1/14', @enddate='12/31/14' --	3872	2
commit tran 																							--	3872	3
begin tran 																								--	3873	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14622	, @begindate = '1/1/14', @enddate='12/31/14' --	3873	2
commit tran 																							--	3873	3
begin tran 																								--	3878	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12793	, @begindate = '7/1/14', @enddate='12/31/14' --	3878	2
commit tran 																							--	3878	3
begin tran 																								--	3879	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12815	, @begindate = '7/1/14', @enddate='12/31/14' --	3879	2
commit tran 																							--	3879	3
begin tran 																								--	3885	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12867	, @begindate = '7/1/14', @enddate='12/31/14' --	3885	2
commit tran 																							--	3885	3
begin tran 																								--	3888	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12836	, @begindate = '7/1/14', @enddate='12/31/14' --	3888	2
commit tran 																							--	3888	3
begin tran 																								--	3889	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12839	, @begindate = '7/1/14', @enddate='12/31/14' --	3889	2
commit tran 																							--	3889	3
begin tran 																								--	3890	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12841	, @begindate = '7/1/14', @enddate='12/31/14' --	3890	2
commit tran 																							--	3890	3
begin tran 																								--	3897	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12859	, @begindate = '7/1/14', @enddate='12/31/14' --	3897	2
commit tran 																							--	3897	3
begin tran 																								--	3912	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15993	, @begindate = '1/1/14', @enddate='12/31/14' --	3912	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12937	, @begindate = '1/1/14', @enddate='12/31/14' --	3912	2
commit tran 																							--	3912	3
begin tran 																								--	3914	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12912	, @begindate = '7/1/14', @enddate='12/31/14' --	3914	2
commit tran 																							--	3914	3
begin tran 																								--	3922	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15887	, @begindate = '1/1/14', @enddate='12/31/14' --	3922	2
commit tran 																							--	3922	3
begin tran 																								--	3923	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12960	, @begindate = '1/1/14', @enddate='12/31/14' --	3923	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13218	, @begindate = '1/1/14', @enddate='12/31/14' --	3923	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16132	, @begindate = '1/1/14', @enddate='12/31/14' --	3923	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13142	, @begindate = '1/1/14', @enddate='12/31/14' --	3923	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16131	, @begindate = '1/1/14', @enddate='12/31/14' --	3923	2
commit tran 																							--	3923	3
begin tran 																								--	3925	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12973	, @begindate = '7/1/14', @enddate='12/31/14' --	3925	2
commit tran 																							--	3925	3
begin tran 																								--	3926	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12964	, @begindate = '7/1/14', @enddate='12/31/14' --	3926	2
commit tran 																							--	3926	3
begin tran 																								--	3928	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12972	, @begindate = '7/1/14', @enddate='12/31/14' --	3928	2
commit tran 																							--	3928	3
begin tran 																								--	3931	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12974	, @begindate = '7/1/14', @enddate='12/31/14' --	3931	2
commit tran 																							--	3931	3
begin tran 																								--	3933	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	12985	, @begindate = '7/1/14', @enddate='12/31/14' --	3933	2
commit tran 																							--	3933	3
begin tran 																								--	3937	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16546	, @begindate = '1/1/14', @enddate='12/31/14' --	3937	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16549	, @begindate = '1/1/14', @enddate='12/31/14' --	3937	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16547	, @begindate = '1/1/14', @enddate='12/31/14' --	3937	2
commit tran 																							--	3937	3
begin tran 																								--	3946	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13035	, @begindate = '7/1/14', @enddate='12/31/14' --	3946	2
commit tran 																							--	3946	3
begin tran 																								--	3951	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16550	, @begindate = '1/1/14', @enddate='12/31/14' --	3951	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16551	, @begindate = '1/1/14', @enddate='12/31/14' --	3951	2
commit tran 																							--	3951	3
begin tran 																								--	3966	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13121	, @begindate = '7/1/14', @enddate='12/31/14' --	3966	2
commit tran 																							--	3966	3
begin tran 																								--	3973	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13159	, @begindate = '1/1/14', @enddate='12/31/14' --	3973	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13169	, @begindate = '1/1/14', @enddate='12/31/14' --	3973	2
commit tran 																							--	3973	3
begin tran 																								--	3974	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16270	, @begindate = '1/1/14', @enddate='12/31/14' --	3974	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16274	, @begindate = '1/1/14', @enddate='12/31/14' --	3974	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13214	, @begindate = '1/1/14', @enddate='12/31/14' --	3974	2
commit tran 																							--	3974	3
begin tran 																								--	3987	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13245	, @begindate = '7/1/14', @enddate='12/31/14' --	3987	2
commit tran 																							--	3987	3
begin tran 																								--	3988	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13247	, @begindate = '7/1/14', @enddate='12/31/14' --	3988	2
commit tran 																							--	3988	3
begin tran 																								--	3989	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13249	, @begindate = '7/1/14', @enddate='12/31/14' --	3989	2
commit tran 																							--	3989	3
begin tran 																								--	3990	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13259	, @begindate = '7/1/14', @enddate='12/31/14' --	3990	2
commit tran 																							--	3990	3
begin tran 																								--	3993	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15602	, @begindate = '1/1/14', @enddate='12/31/14' --	3993	2
commit tran 																							--	3993	3
begin tran 																								--	4000	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13315	, @begindate = '1/1/14', @enddate='12/31/14' --	4000	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16219	, @begindate = '1/1/14', @enddate='12/31/14' --	4000	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16212	, @begindate = '1/1/14', @enddate='12/31/14' --	4000	2
commit tran 																							--	4000	3
begin tran 																								--	4013	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16511	, @begindate = '1/1/14', @enddate='12/31/14' --	4013	2
commit tran 																							--	4013	3
begin tran 																								--	4016	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13363	, @begindate = '7/1/14', @enddate='12/31/14' --	4016	2
commit tran 																							--	4016	3
begin tran 																								--	4021	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15744	, @begindate = '1/1/14', @enddate='12/31/14' --	4021	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15745	, @begindate = '1/1/14', @enddate='12/31/14' --	4021	2
commit tran 																							--	4021	3
begin tran 																								--	4024	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13729	, @begindate = '1/1/14', @enddate='12/31/14' --	4024	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13759	, @begindate = '1/1/14', @enddate='12/31/14' --	4024	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13740	, @begindate = '1/1/14', @enddate='12/31/14' --	4024	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13598	, @begindate = '1/1/14', @enddate='12/31/14' --	4024	2
commit tran 																							--	4024	3
begin tran 																								--	4028	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13473	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16207	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16209	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16206	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13472	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13474	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16208	, @begindate = '1/1/14', @enddate='12/31/14' --	4028	2
commit tran 																							--	4028	3
begin tran 																								--	4045	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13512	, @begindate = '7/1/14', @enddate='12/31/14' --	4045	2
commit tran 																							--	4045	3
begin tran 																								--	4053	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16236	, @begindate = '1/1/14', @enddate='12/31/14' --	4053	2
commit tran 																							--	4053	3
begin tran 																								--	4058	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16375	, @begindate = '1/1/14', @enddate='12/31/14' --	4058	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14994	, @begindate = '1/1/14', @enddate='12/31/14' --	4058	2
commit tran 																							--	4058	3
begin tran 																								--	4061	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13777	, @begindate = '7/1/14', @enddate='12/31/14' --	4061	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14623	, @begindate = '7/1/14', @enddate='12/31/14' --	4061	2
commit tran 																							--	4061	3
begin tran 																								--	4062	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15961	, @begindate = '1/1/14', @enddate='12/31/14' --	4062	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15960	, @begindate = '1/1/14', @enddate='12/31/14' --	4062	2
commit tran 																							--	4062	3
begin tran 																								--	4063	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16509	, @begindate = '1/1/14', @enddate='12/31/14' --	4063	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16144	, @begindate = '1/1/14', @enddate='12/31/14' --	4063	2
commit tran 																							--	4063	3
begin tran 																								--	4072	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13625	, @begindate = '7/1/14', @enddate='12/31/14' --	4072	2
commit tran 																							--	4072	3
begin tran 																								--	4073	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13624	, @begindate = '7/1/14', @enddate='12/31/14' --	4073	2
commit tran 																							--	4073	3
begin tran 																								--	4074	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13620	, @begindate = '7/1/14', @enddate='12/31/14' --	4074	2
commit tran 																							--	4074	3
begin tran 																								--	4075	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13621	, @begindate = '7/1/14', @enddate='12/31/14' --	4075	2
commit tran 																							--	4075	3
begin tran 																								--	4080	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15957	, @begindate = '1/1/14', @enddate='12/31/14' --	4080	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16391	, @begindate = '1/1/14', @enddate='12/31/14' --	4080	2
commit tran 																							--	4080	3
begin tran 																								--	4095	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13672	, @begindate = '7/1/14', @enddate='12/31/14' --	4095	2
commit tran 																							--	4095	3
begin tran 																								--	4103	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15684	, @begindate = '1/1/14', @enddate='12/31/14' --	4103	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15685	, @begindate = '1/1/14', @enddate='12/31/14' --	4103	2
commit tran 																							--	4103	3
begin tran 																								--	4107	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16622	, @begindate = '1/1/14', @enddate='12/31/14' --	4107	2
commit tran 																							--	4107	3
begin tran 																								--	4108	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14599	, @begindate = '1/1/14', @enddate='12/31/14' --	4108	2
commit tran 																							--	4108	3
begin tran 																								--	4111	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13717	, @begindate = '7/1/14', @enddate='12/31/14' --	4111	2
commit tran 																							--	4111	3
begin tran 																								--	4114	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13721	, @begindate = '1/1/14', @enddate='12/31/14' --	4114	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13873	, @begindate = '1/1/14', @enddate='12/31/14' --	4114	2
commit tran 																							--	4114	3
begin tran 																								--	4118	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16058	, @begindate = '1/1/14', @enddate='12/31/14' --	4118	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16057	, @begindate = '1/1/14', @enddate='12/31/14' --	4118	2
commit tran 																							--	4118	3
begin tran 																								--	4120	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14010	, @begindate = '7/1/14', @enddate='12/31/14' --	4120	2
commit tran 																							--	4120	3
begin tran 																								--	4124	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13749	, @begindate = '7/1/14', @enddate='12/31/14' --	4124	2
commit tran 																							--	4124	3
begin tran 																								--	4131	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13790	, @begindate = '7/1/14', @enddate='12/31/14' --	4131	2
commit tran 																							--	4131	3
begin tran 																								--	4134	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16399	, @begindate = '1/1/14', @enddate='12/31/14' --	4134	2
commit tran 																							--	4134	3
begin tran 																								--	4145	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16515	, @begindate = '1/1/14', @enddate='12/31/14' --	4145	2
commit tran 																							--	4145	3
begin tran 																								--	4154	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16618	, @begindate = '1/1/14', @enddate='12/31/14' --	4154	2
commit tran 																							--	4154	3
begin tran 																								--	4163	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13884	, @begindate = '1/1/14', @enddate='12/31/14' --	4163	2
commit tran 																							--	4163	3
begin tran 																								--	4164	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13870	, @begindate = '7/1/14', @enddate='12/31/14' --	4164	2
commit tran 																							--	4164	3
begin tran 																								--	4165	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13876	, @begindate = '1/1/14', @enddate='12/31/14' --	4165	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15132	, @begindate = '1/1/14', @enddate='12/31/14' --	4165	2
commit tran 																							--	4165	3
begin tran 																								--	4196	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16161	, @begindate = '1/1/14', @enddate='12/31/14' --	4196	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16162	, @begindate = '1/1/14', @enddate='12/31/14' --	4196	2
commit tran 																							--	4196	3
begin tran 																								--	4224	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15838	, @begindate = '1/1/14', @enddate='12/31/14' --	4224	2
commit tran 																							--	4224	3
begin tran 																								--	4226	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14006	, @begindate = '7/1/14', @enddate='12/31/14' --	4226	2
commit tran 																							--	4226	3
begin tran 																								--	4229	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16169	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16171	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16173	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16176	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16170	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16174	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16175	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16165	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16166	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16168	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16167	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16172	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16177	, @begindate = '1/1/14', @enddate='12/31/14' --	4229	2
commit tran 																							--	4229	3
begin tran 																								--	4233	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14041	, @begindate = '1/1/14', @enddate='12/31/14' --	4233	2
commit tran 																							--	4233	3
begin tran 																								--	4256	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14170	, @begindate = '7/1/14', @enddate='12/31/14' --	4256	2
commit tran 																							--	4256	3
begin tran 																								--	4258	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14150	, @begindate = '7/1/14', @enddate='12/31/14' --	4258	2
commit tran 																							--	4258	3
begin tran 																								--	4259	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14151	, @begindate = '7/1/14', @enddate='12/31/14' --	4259	2
commit tran 																							--	4259	3
begin tran 																								--	4260	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14152	, @begindate = '7/1/14', @enddate='12/31/14' --	4260	2
commit tran 																							--	4260	3
begin tran 																								--	4270	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14168	, @begindate = '1/1/14', @enddate='12/31/14' --	4270	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15862	, @begindate = '1/1/14', @enddate='12/31/14' --	4270	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15091	, @begindate = '1/1/14', @enddate='12/31/14' --	4270	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15861	, @begindate = '1/1/14', @enddate='12/31/14' --	4270	2
commit tran 																							--	4270	3
begin tran 																								--	4272	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14185	, @begindate = '7/1/14', @enddate='12/31/14' --	4272	2
commit tran 																							--	4272	3
begin tran 																								--	4274	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14299	, @begindate = '1/1/14', @enddate='12/31/14' --	4274	2
commit tran 																							--	4274	3
begin tran 																								--	4279	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16374	, @begindate = '1/1/14', @enddate='12/31/14' --	4279	2
commit tran 																							--	4279	3
begin tran 																								--	4285	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16610	, @begindate = '1/1/14', @enddate='12/31/14' --	4285	2
commit tran 																							--	4285	3
begin tran 																								--	4286	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14257	, @begindate = '7/1/14', @enddate='12/31/14' --	4286	2
commit tran 																							--	4286	3
begin tran 																								--	4292	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14254	, @begindate = '7/1/14', @enddate='12/31/14' --	4292	2
commit tran 																							--	4292	3
begin tran 																								--	4293	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14414	, @begindate = '1/1/14', @enddate='12/31/14' --	4293	2
commit tran 																							--	4293	3
begin tran 																								--	4295	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14266	, @begindate = '7/1/14', @enddate='12/31/14' --	4295	2
commit tran 																							--	4295	3
begin tran 																								--	4297	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15954	, @begindate = '1/1/14', @enddate='12/31/14' --	4297	2
commit tran 																							--	4297	3
begin tran 																								--	4307	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14285	, @begindate = '1/1/14', @enddate='12/31/14' --	4307	2
commit tran 																							--	4307	3
begin tran 																								--	4314	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16821	, @begindate = '1/1/14', @enddate='12/31/14' --	4314	2
commit tran 																							--	4314	3
begin tran 																								--	4331	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14366	, @begindate = '1/1/14', @enddate='12/31/14' --	4331	2
commit tran 																							--	4331	3
begin tran 																								--	4333	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16308	, @begindate = '1/1/14', @enddate='12/31/14' --	4333	2
commit tran 																							--	4333	3
begin tran 																								--	4334	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14616	, @begindate = '7/1/14', @enddate='12/31/14' --	4334	2
commit tran 																							--	4334	3
begin tran 																								--	4345	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14370	, @begindate = '7/1/14', @enddate='12/31/14' --	4345	2
commit tran 																							--	4345	3
begin tran 																								--	4349	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14392	, @begindate = '7/1/14', @enddate='12/31/14' --	4349	2
commit tran 																							--	4349	3
begin tran 																								--	4356	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14427	, @begindate = '1/1/14', @enddate='12/31/14' --	4356	2
commit tran 																							--	4356	3
begin tran 																								--	4357	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15875	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15879	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16366	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15869	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15889	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15886	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15912	, @begindate = '1/1/14', @enddate='12/31/14' --	4357	2
commit tran 																							--	4357	3
begin tran 																								--	4358	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16000	, @begindate = '1/1/14', @enddate='12/31/14' --	4358	2
commit tran 																							--	4358	3
begin tran 																								--	4359	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14573	, @begindate = '1/1/14', @enddate='12/31/14' --	4359	2
commit tran 																							--	4359	3
begin tran 																								--	4361	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14589	, @begindate = '7/1/14', @enddate='12/31/14' --	4361	2
commit tran 																							--	4361	3
begin tran 																								--	4363	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15229	, @begindate = '7/1/14', @enddate='12/31/14' --	4363	2
commit tran 																							--	4363	3
begin tran 																								--	4366	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14598	, @begindate = '1/1/14', @enddate='12/31/14' --	4366	2
commit tran 																							--	4366	3
begin tran 																								--	4368	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14581	, @begindate = '7/1/14', @enddate='12/31/14' --	4368	2
commit tran 																							--	4368	3
begin tran 																								--	4369	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14579	, @begindate = '7/1/14', @enddate='12/31/14' --	4369	2
commit tran 																							--	4369	3
begin tran 																								--	4370	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14578	, @begindate = '7/1/14', @enddate='12/31/14' --	4370	2
commit tran 																							--	4370	3
begin tran 																								--	4371	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14577	, @begindate = '7/1/14', @enddate='12/31/14' --	4371	2
commit tran 																							--	4371	3
begin tran 																								--	4375	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14595	, @begindate = '7/1/14', @enddate='12/31/14' --	4375	2
commit tran 																							--	4375	3
begin tran 																								--	4376	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14601	, @begindate = '7/1/14', @enddate='12/31/14' --	4376	2
commit tran 																							--	4376	3
begin tran 																								--	4377	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14602	, @begindate = '7/1/14', @enddate='12/31/14' --	4377	2
commit tran 																							--	4377	3
begin tran 																								--	4383	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14786	, @begindate = '1/1/14', @enddate='12/31/14' --	4383	2
commit tran 																							--	4383	3
begin tran 																								--	4390	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14655	, @begindate = '7/1/14', @enddate='12/31/14' --	4390	2
commit tran 																							--	4390	3
begin tran 																								--	4391	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14656	, @begindate = '7/1/14', @enddate='12/31/14' --	4391	2
commit tran 																							--	4391	3
begin tran 																								--	4392	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14657	, @begindate = '7/1/14', @enddate='12/31/14' --	4392	2
commit tran 																							--	4392	3
begin tran 																								--	4395	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14664	, @begindate = '7/1/14', @enddate='12/31/14' --	4395	2
commit tran 																							--	4395	3
begin tran 																								--	4400	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14759	, @begindate = '7/1/14', @enddate='12/31/14' --	4400	2
commit tran 																							--	4400	3
begin tran 																								--	4417	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15865	, @begindate = '1/1/14', @enddate='12/31/14' --	4417	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14760	, @begindate = '1/1/14', @enddate='12/31/14' --	4417	2
commit tran 																							--	4417	3
begin tran 																								--	4421	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14716	, @begindate = '1/1/14', @enddate='12/31/14' --	4421	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15881	, @begindate = '1/1/14', @enddate='12/31/14' --	4421	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15883	, @begindate = '1/1/14', @enddate='12/31/14' --	4421	2
commit tran 																							--	4421	3
begin tran 																								--	4428	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14722	, @begindate = '7/1/14', @enddate='12/31/14' --	4428	2
commit tran 																							--	4428	3
begin tran 																								--	4429	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14721	, @begindate = '1/1/14', @enddate='12/31/14' --	4429	2
commit tran 																							--	4429	3
begin tran 																								--	4432	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14737	, @begindate = '7/1/14', @enddate='12/31/14' --	4432	2
commit tran 																							--	4432	3
begin tran 																								--	4433	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14749	, @begindate = '7/1/14', @enddate='12/31/14' --	4433	2
commit tran 																							--	4433	3
begin tran 																								--	4434	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14744	, @begindate = '1/1/14', @enddate='12/31/14' --	4434	2
commit tran 																							--	4434	3
begin tran 																								--	4447	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14969	, @begindate = '7/1/14', @enddate='12/31/14' --	4447	2
commit tran 																							--	4447	3
begin tran 																								--	4450	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14917	, @begindate = '7/1/14', @enddate='12/31/14' --	4450	2
commit tran 																							--	4450	3
begin tran 																								--	4452	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15227	, @begindate = '1/1/14', @enddate='12/31/14' --	4452	2
commit tran 																							--	4452	3
begin tran 																								--	4458	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14928	, @begindate = '7/1/14', @enddate='12/31/14' --	4458	2
commit tran 																							--	4458	3
begin tran 																								--	4459	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14929	, @begindate = '7/1/14', @enddate='12/31/14' --	4459	2
commit tran 																							--	4459	3
begin tran 																								--	4460	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14930	, @begindate = '7/1/14', @enddate='12/31/14' --	4460	2
commit tran 																							--	4460	3
begin tran 																								--	4461	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14931	, @begindate = '7/1/14', @enddate='12/31/14' --	4461	2
commit tran 																							--	4461	3
begin tran 																								--	4462	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14927	, @begindate = '7/1/14', @enddate='12/31/14' --	4462	2
commit tran 																							--	4462	3
begin tran 																								--	4463	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14932	, @begindate = '7/1/14', @enddate='12/31/14' --	4463	2
commit tran 																							--	4463	3
begin tran 																								--	4465	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14954	, @begindate = '1/1/14', @enddate='12/31/14' --	4465	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16143	, @begindate = '1/1/14', @enddate='12/31/14' --	4465	2
commit tran 																							--	4465	3
begin tran 																								--	4467	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15062	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16328	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15060	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15065	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15066	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15064	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15067	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15068	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15061	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15063	, @begindate = '7/1/14', @enddate='12/31/14' --	4467	2
commit tran 																							--	4467	3
begin tran 																								--	4473	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16081	, @begindate = '1/1/14', @enddate='12/31/14' --	4473	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15058	, @begindate = '1/1/14', @enddate='12/31/14' --	4473	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16031	, @begindate = '1/1/14', @enddate='12/31/14' --	4473	2
commit tran 																							--	4473	3
begin tran 																								--	4475	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15185	, @begindate = '7/1/14', @enddate='12/31/14' --	4475	2
commit tran 																							--	4475	3
begin tran 																								--	4476	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	14987	, @begindate = '7/1/14', @enddate='12/31/14' --	4476	2
commit tran 																							--	4476	3
begin tran 																								--	4480	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15104	, @begindate = '7/1/14', @enddate='12/31/14' --	4480	2
commit tran 																							--	4480	3
begin tran 																								--	4481	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15128	, @begindate = '1/1/14', @enddate='12/31/14' --	4481	2
commit tran 																							--	4481	3
begin tran 																								--	4482	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16164	, @begindate = '1/1/14', @enddate='12/31/14' --	4482	2
commit tran 																							--	4482	3
begin tran 																								--	4485	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15014	, @begindate = '7/1/14', @enddate='12/31/14' --	4485	2
commit tran 																							--	4485	3
begin tran 																								--	4488	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15210	, @begindate = '1/1/14', @enddate='12/31/14' --	4488	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15173	, @begindate = '1/1/14', @enddate='12/31/14' --	4488	2
commit tran 																							--	4488	3
begin tran 																								--	4491	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15048	, @begindate = '1/1/14', @enddate='12/31/14' --	4491	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15047	, @begindate = '1/1/14', @enddate='12/31/14' --	4491	2
commit tran 																							--	4491	3
begin tran 																								--	4495	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15147	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15978	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15142	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15146	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15658	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15139	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15969	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15144	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15143	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15975	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15982	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15976	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15981	, @begindate = '1/1/14', @enddate='12/31/14' --	4495	2
commit tran 																							--	4495	3
begin tran 																								--	4497	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15118	, @begindate = '1/1/14', @enddate='12/31/14' --	4497	2
commit tran 																							--	4497	3
begin tran 																								--	4504	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15207	, @begindate = '7/1/14', @enddate='12/31/14' --	4504	2
commit tran 																							--	4504	3
begin tran 																								--	4509	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15176	, @begindate = '1/1/14', @enddate='12/31/14' --	4509	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16140	, @begindate = '1/1/14', @enddate='12/31/14' --	4509	2
commit tran 																							--	4509	3
begin tran 																								--	4512	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15169	, @begindate = '1/1/14', @enddate='12/31/14' --	4512	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16296	, @begindate = '1/1/14', @enddate='12/31/14' --	4512	2
commit tran 																							--	4512	3
begin tran 																								--	4515	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15228	, @begindate = '1/1/14', @enddate='12/31/14' --	4515	2
commit tran 																							--	4515	3
begin tran 																								--	4516	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13770	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16145	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16146	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15863	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15182	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15190	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15631	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16135	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16150	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16184	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15866	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15958	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16055	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13842	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15188	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15308	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16498	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	13778	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15181	, @begindate = '1/1/14', @enddate='12/31/14' --	4516	2
commit tran 																							--	4516	3
begin tran 																								--	4523	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15200	, @begindate = '7/1/14', @enddate='12/31/14' --	4523	2
commit tran 																							--	4523	3
begin tran 																								--	4526	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15202	, @begindate = '7/1/14', @enddate='12/31/14' --	4526	2
commit tran 																							--	4526	3
begin tran 																								--	4527	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15201	, @begindate = '7/1/14', @enddate='12/31/14' --	4527	2
commit tran 																							--	4527	3
begin tran 																								--	4530	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15211	, @begindate = '7/1/14', @enddate='12/31/14' --	4530	2
commit tran 																							--	4530	3
begin tran 																								--	4531	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15213	, @begindate = '7/1/14', @enddate='12/31/14' --	4531	2
commit tran 																							--	4531	3
begin tran 																								--	4532	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15212	, @begindate = '7/1/14', @enddate='12/31/14' --	4532	2
commit tran 																							--	4532	3
begin tran 																								--	4539	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16127	, @begindate = '1/1/14', @enddate='12/31/14' --	4539	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16138	, @begindate = '1/1/14', @enddate='12/31/14' --	4539	2
commit tran 																							--	4539	3
begin tran 																								--	4541	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16535	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16556	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16554	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16555	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16513	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16521	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16557	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16376	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16520	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16553	, @begindate = '1/1/14', @enddate='12/31/14' --	4541	2
commit tran 																							--	4541	3
begin tran 																								--	4552	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15272	, @begindate = '7/1/14', @enddate='12/31/14' --	4552	2
commit tran 																							--	4552	3
begin tran 																								--	4554	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15256	, @begindate = '7/1/14', @enddate='12/31/14' --	4554	2
commit tran 																							--	4554	3
begin tran 																								--	4567	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15689	, @begindate = '1/1/14', @enddate='12/31/14' --	4567	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15688	, @begindate = '1/1/14', @enddate='12/31/14' --	4567	2
commit tran 																							--	4567	3
begin tran 																								--	4569	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15360	, @begindate = '1/1/14', @enddate='12/31/14' --	4569	2
commit tran 																							--	4569	3
begin tran 																								--	4572	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15426	, @begindate = '1/1/14', @enddate='12/31/14' --	4572	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15390	, @begindate = '1/1/14', @enddate='12/31/14' --	4572	2
commit tran 																							--	4572	3
begin tran 																								--	4577	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15701	, @begindate = '1/1/14', @enddate='12/31/14' --	4577	2
commit tran 																							--	4577	3
begin tran 																								--	4578	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15385	, @begindate = '1/1/14', @enddate='12/31/14' --	4578	2
commit tran 																							--	4578	3
begin tran 																								--	4579	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15382	, @begindate = '1/1/14', @enddate='12/31/14' --	4579	2
commit tran 																							--	4579	3
begin tran 																								--	4580	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15373	, @begindate = '7/1/14', @enddate='12/31/14' --	4580	2
commit tran 																							--	4580	3
begin tran 																								--	4581	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15374	, @begindate = '7/1/14', @enddate='12/31/14' --	4581	2
commit tran 																							--	4581	3
begin tran 																								--	4582	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15375	, @begindate = '7/1/14', @enddate='12/31/14' --	4582	2
commit tran 																							--	4582	3
begin tran 																								--	4583	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15376	, @begindate = '7/1/14', @enddate='12/31/14' --	4583	2
commit tran 																							--	4583	3
begin tran 																								--	4587	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15371	, @begindate = '7/1/14', @enddate='12/31/14' --	4587	2
commit tran 																							--	4587	3
begin tran 																								--	4594	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15389	, @begindate = '7/1/14', @enddate='12/31/14' --	4594	2
commit tran 																							--	4594	3
begin tran 																								--	4597	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15419	, @begindate = '7/1/14', @enddate='12/31/14' --	4597	2
commit tran 																							--	4597	3
begin tran 																								--	4598	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15427	, @begindate = '7/1/14', @enddate='12/31/14' --	4598	2
commit tran 																							--	4598	3
begin tran 																								--	4600	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15394	, @begindate = '1/1/14', @enddate='12/31/14' --	4600	2
commit tran 																							--	4600	3
begin tran 																								--	4613	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15607	, @begindate = '7/1/14', @enddate='12/31/14' --	4613	2
commit tran 																							--	4613	3
begin tran 																								--	4614	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15608	, @begindate = '7/1/14', @enddate='12/31/14' --	4614	2
commit tran 																							--	4614	3
begin tran 																								--	4615	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15609	, @begindate = '7/1/14', @enddate='12/31/14' --	4615	2
commit tran 																							--	4615	3
begin tran 																								--	4616	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15809	, @begindate = '1/1/14', @enddate='12/31/14' --	4616	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15860	, @begindate = '1/1/14', @enddate='12/31/14' --	4616	2
commit tran 																							--	4616	3
begin tran 																								--	4617	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15613	, @begindate = '7/1/14', @enddate='12/31/14' --	4617	2
commit tran 																							--	4617	3
begin tran 																								--	4623	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15644	, @begindate = '7/1/14', @enddate='12/31/14' --	4623	2
commit tran 																							--	4623	3
begin tran 																								--	4631	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15756	, @begindate = '7/1/14', @enddate='12/31/14' --	4631	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15712	, @begindate = '7/1/14', @enddate='12/31/14' --	4631	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15753	, @begindate = '7/1/14', @enddate='12/31/14' --	4631	2
commit tran 																							--	4631	3
begin tran 																								--	4637	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15888	, @begindate = '1/1/14', @enddate='12/31/14' --	4637	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15721	, @begindate = '1/1/14', @enddate='12/31/14' --	4637	2
commit tran 																							--	4637	3
begin tran 																								--	4638	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15852	, @begindate = '1/1/14', @enddate='12/31/14' --	4638	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15854	, @begindate = '1/1/14', @enddate='12/31/14' --	4638	2
commit tran 																							--	4638	3
begin tran 																								--	4639	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15748	, @begindate = '7/1/14', @enddate='12/31/14' --	4639	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15754	, @begindate = '7/1/14', @enddate='12/31/14' --	4639	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15755	, @begindate = '7/1/14', @enddate='12/31/14' --	4639	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15752	, @begindate = '7/1/14', @enddate='12/31/14' --	4639	2
commit tran 																							--	4639	3
begin tran 																								--	4641	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15720	, @begindate = '1/1/14', @enddate='12/31/14' --	4641	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15719	, @begindate = '1/1/14', @enddate='12/31/14' --	4641	2
commit tran 																							--	4641	3
begin tran 																								--	4642	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15851	, @begindate = '1/1/14', @enddate='12/31/14' --	4642	2
commit tran 																							--	4642	3
begin tran 																								--	4653	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15792	, @begindate = '7/1/14', @enddate='12/31/14' --	4653	2
commit tran 																							--	4653	3
begin tran 																								--	4658	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15810	, @begindate = '7/1/14', @enddate='12/31/14' --	4658	2
commit tran 																							--	4658	3
begin tran 																								--	4659	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15811	, @begindate = '7/1/14', @enddate='12/31/14' --	4659	2
commit tran 																							--	4659	3
begin tran 																								--	4660	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15839	, @begindate = '1/1/14', @enddate='12/31/14' --	4660	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15813	, @begindate = '1/1/14', @enddate='12/31/14' --	4660	2
commit tran 																							--	4660	3
begin tran 																								--	4661	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15814	, @begindate = '7/1/14', @enddate='12/31/14' --	4661	2
commit tran 																							--	4661	3
begin tran 																								--	4662	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15818	, @begindate = '7/1/14', @enddate='12/31/14' --	4662	2
commit tran 																							--	4662	3
begin tran 																								--	4664	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15829	, @begindate = '1/1/14', @enddate='12/31/14' --	4664	2
commit tran 																							--	4664	3
begin tran 																								--	4667	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15823	, @begindate = '7/1/14', @enddate='12/31/14' --	4667	2
commit tran 																							--	4667	3
begin tran 																								--	4669	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15840	, @begindate = '1/1/14', @enddate='12/31/14' --	4669	2
commit tran 																							--	4669	3
begin tran 																								--	4670	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16232	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15878	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16230	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16223	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16226	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15864	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16228	, @begindate = '1/1/14', @enddate='12/31/14' --	4670	2
commit tran 																							--	4670	3
begin tran 																								--	4671	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15882	, @begindate = '7/1/14', @enddate='12/31/14' --	4671	2
commit tran 																							--	4671	3
begin tran 																								--	4672	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15933	, @begindate = '1/1/14', @enddate='12/31/14' --	4672	2
commit tran 																							--	4672	3
begin tran 																								--	4673	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15996	, @begindate = '1/1/14', @enddate='12/31/14' --	4673	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15997	, @begindate = '1/1/14', @enddate='12/31/14' --	4673	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16021	, @begindate = '1/1/14', @enddate='12/31/14' --	4673	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15966	, @begindate = '1/1/14', @enddate='12/31/14' --	4673	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15965	, @begindate = '1/1/14', @enddate='12/31/14' --	4673	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15998	, @begindate = '1/1/14', @enddate='12/31/14' --	4673	2
commit tran 																							--	4673	3
begin tran 																								--	4674	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16392	, @begindate = '1/1/14', @enddate='12/31/14' --	4674	2
commit tran 																							--	4674	3
begin tran 																								--	4678	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15930	, @begindate = '1/1/14', @enddate='12/31/14' --	4678	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15931	, @begindate = '1/1/14', @enddate='12/31/14' --	4678	2
commit tran 																							--	4678	3
begin tran 																								--	4680	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15943	, @begindate = '1/1/14', @enddate='12/31/14' --	4680	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15939	, @begindate = '1/1/14', @enddate='12/31/14' --	4680	2
commit tran 																							--	4680	3
begin tran 																								--	4682	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15951	, @begindate = '1/1/14', @enddate='12/31/14' --	4682	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15952	, @begindate = '1/1/14', @enddate='12/31/14' --	4682	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16042	, @begindate = '1/1/14', @enddate='12/31/14' --	4682	2
commit tran 																							--	4682	3
begin tran 																								--	4685	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15970	, @begindate = '1/1/14', @enddate='12/31/14' --	4685	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15983	, @begindate = '1/1/14', @enddate='12/31/14' --	4685	2
commit tran 																							--	4685	3
begin tran 																								--	4686	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16033	, @begindate = '1/1/14', @enddate='12/31/14' --	4686	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15971	, @begindate = '1/1/14', @enddate='12/31/14' --	4686	2
commit tran 																							--	4686	3
begin tran 																								--	4688	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15972	, @begindate = '1/1/14', @enddate='12/31/14' --	4688	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15990	, @begindate = '1/1/14', @enddate='12/31/14' --	4688	2
commit tran 																							--	4688	3
begin tran 																								--	4691	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15985	, @begindate = '7/1/14', @enddate='12/31/14' --	4691	2
commit tran 																							--	4691	3
begin tran 																								--	4692	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15984	, @begindate = '7/1/14', @enddate='12/31/14' --	4692	2
commit tran 																							--	4692	3
begin tran 																								--	4693	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15989	, @begindate = '7/1/14', @enddate='12/31/14' --	4693	2
commit tran 																							--	4693	3
begin tran 																								--	4694	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15987	, @begindate = '7/1/14', @enddate='12/31/14' --	4694	2
commit tran 																							--	4694	3
begin tran 																								--	4695	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	15988	, @begindate = '7/1/14', @enddate='12/31/14' --	4695	2
commit tran 																							--	4695	3
begin tran 																								--	4700	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16009	, @begindate = '1/1/14', @enddate='12/31/14' --	4700	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16008	, @begindate = '1/1/14', @enddate='12/31/14' --	4700	2
commit tran 																							--	4700	3
begin tran 																								--	4702	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16012	, @begindate = '1/1/14', @enddate='12/31/14' --	4702	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16011	, @begindate = '1/1/14', @enddate='12/31/14' --	4702	2
commit tran 																							--	4702	3
begin tran 																								--	4703	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16029	, @begindate = '1/1/14', @enddate='12/31/14' --	4703	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16030	, @begindate = '1/1/14', @enddate='12/31/14' --	4703	2
commit tran 																							--	4703	3
begin tran 																								--	4704	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16015	, @begindate = '1/1/14', @enddate='12/31/14' --	4704	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16016	, @begindate = '1/1/14', @enddate='12/31/14' --	4704	2
commit tran 																							--	4704	3
begin tran 																								--	4705	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16019	, @begindate = '1/1/14', @enddate='12/31/14' --	4705	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16020	, @begindate = '1/1/14', @enddate='12/31/14' --	4705	2
commit tran 																							--	4705	3
begin tran 																								--	4706	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16018	, @begindate = '1/1/14', @enddate='12/31/14' --	4706	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16017	, @begindate = '1/1/14', @enddate='12/31/14' --	4706	2
commit tran 																							--	4706	3
begin tran 																								--	4707	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16014	, @begindate = '1/1/14', @enddate='12/31/14' --	4707	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16013	, @begindate = '1/1/14', @enddate='12/31/14' --	4707	2
commit tran 																							--	4707	3
begin tran 																								--	4708	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16028	, @begindate = '1/1/14', @enddate='12/31/14' --	4708	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16027	, @begindate = '1/1/14', @enddate='12/31/14' --	4708	2
commit tran 																							--	4708	3
begin tran 																								--	4711	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16040	, @begindate = '1/1/14', @enddate='12/31/14' --	4711	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16041	, @begindate = '1/1/14', @enddate='12/31/14' --	4711	2
commit tran 																							--	4711	3
begin tran 																								--	4716	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16153	, @begindate = '1/1/14', @enddate='12/31/14' --	4716	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16061	, @begindate = '1/1/14', @enddate='12/31/14' --	4716	2
commit tran 																							--	4716	3
begin tran 																								--	4717	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16063	, @begindate = '7/1/14', @enddate='12/31/14' --	4717	2
commit tran 																							--	4717	3
begin tran 																								--	4718	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16064	, @begindate = '7/1/14', @enddate='12/31/14' --	4718	2
commit tran 																							--	4718	3
begin tran 																								--	4719	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16065	, @begindate = '7/1/14', @enddate='12/31/14' --	4719	2
commit tran 																							--	4719	3
begin tran 																								--	4720	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16062	, @begindate = '7/1/14', @enddate='12/31/14' --	4720	2
commit tran 																							--	4720	3
begin tran 																								--	4721	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16068	, @begindate = '7/1/14', @enddate='12/31/14' --	4721	2
commit tran 																							--	4721	3
begin tran 																								--	4723	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16070	, @begindate = '7/1/14', @enddate='12/31/14' --	4723	2
commit tran 																							--	4723	3
begin tran 																								--	4724	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16072	, @begindate = '7/1/14', @enddate='12/31/14' --	4724	2
commit tran 																							--	4724	3
begin tran 																								--	4725	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16071	, @begindate = '7/1/14', @enddate='12/31/14' --	4725	2
commit tran 																							--	4725	3
begin tran 																								--	4726	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16077	, @begindate = '1/1/14', @enddate='12/31/14' --	4726	2
commit tran 																							--	4726	3
begin tran 																								--	4729	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16086	, @begindate = '1/1/14', @enddate='12/31/14' --	4729	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16087	, @begindate = '1/1/14', @enddate='12/31/14' --	4729	2
commit tran 																							--	4729	3
begin tran 																								--	4736	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16108	, @begindate = '7/1/14', @enddate='12/31/14' --	4736	2
commit tran 																							--	4736	3
begin tran 																								--	4739	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16123	, @begindate = '1/1/14', @enddate='12/31/14' --	4739	2
commit tran 																							--	4739	3
begin tran 																								--	4740	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16694	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16729	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16732	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16769	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16772	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16775	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16773	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16730	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16771	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16770	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16731	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16774	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16776	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16777	, @begindate = '1/1/14', @enddate='12/31/14' --	4740	2
commit tran 																							--	4740	3
begin tran 																								--	4743	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16712	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16716	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16717	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16748	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16756	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16757	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16758	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16720	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16722	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16744	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16746	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16751	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16753	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16721	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16752	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16754	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16761	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16718	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16759	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16762	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16723	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16743	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16747	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16745	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16749	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16764	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16719	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16750	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16760	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16763	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16790	, @begindate = '1/1/14', @enddate='12/31/14' --	4743	2
commit tran 																							--	4743	3
begin tran 																								--	4744	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16778	, @begindate = '1/1/14', @enddate='12/31/14' --	4744	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16779	, @begindate = '1/1/14', @enddate='12/31/14' --	4744	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16782	, @begindate = '1/1/14', @enddate='12/31/14' --	4744	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16783	, @begindate = '1/1/14', @enddate='12/31/14' --	4744	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16781	, @begindate = '1/1/14', @enddate='12/31/14' --	4744	2
commit tran 																							--	4744	3
begin tran 																								--	4746	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16125	, @begindate = '1/1/14', @enddate='12/31/14' --	4746	2
commit tran 																							--	4746	3
begin tran 																								--	4747	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16681	, @begindate = '1/1/14', @enddate='12/31/14' --	4747	2
commit tran 																							--	4747	3
begin tran 																								--	4748	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16687	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16682	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16683	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16688	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16690	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16684	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16686	, @begindate = '1/1/14', @enddate='12/31/14' --	4748	2
commit tran 																							--	4748	3
begin tran 																								--	4752	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16352	, @begindate = '1/1/14', @enddate='12/31/14' --	4752	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16351	, @begindate = '1/1/14', @enddate='12/31/14' --	4752	2
commit tran 																							--	4752	3
begin tran 																								--	4766	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16257	, @begindate = '1/1/14', @enddate='12/31/14' --	4766	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16258	, @begindate = '1/1/14', @enddate='12/31/14' --	4766	2
commit tran 																							--	4766	3
begin tran 																								--	4771	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16225	, @begindate = '7/1/14', @enddate='12/31/14' --	4771	2
commit tran 																							--	4771	3
begin tran 																								--	4773	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16395	, @begindate = '1/1/14', @enddate='12/31/14' --	4773	2
commit tran 																							--	4773	3
begin tran 																								--	4774	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16229	, @begindate = '1/1/14', @enddate='12/31/14' --	4774	2
commit tran 																							--	4774	3
begin tran 																								--	4775	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16237	, @begindate = '7/1/14', @enddate='12/31/14' --	4775	2
commit tran 																							--	4775	3
begin tran 																								--	4776	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16284	, @begindate = '1/1/14', @enddate='12/31/14' --	4776	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16283	, @begindate = '1/1/14', @enddate='12/31/14' --	4776	2
commit tran 																							--	4776	3
begin tran 																								--	4777	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16247	, @begindate = '1/1/14', @enddate='12/31/14' --	4777	2
commit tran 																							--	4777	3
begin tran 																								--	4778	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16256	, @begindate = '7/1/14', @enddate='12/31/14' --	4778	2
commit tran 																							--	4778	3
begin tran 																								--	4799	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16650	, @begindate = '1/1/14', @enddate='12/31/14' --	4799	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16651	, @begindate = '1/1/14', @enddate='12/31/14' --	4799	2
commit tran 																							--	4799	3
begin tran 																								--	4810	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16353	, @begindate = '7/1/14', @enddate='12/31/14' --	4810	2
commit tran 																							--	4810	3
begin tran 																								--	4812	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16394	, @begindate = '1/1/14', @enddate='12/31/14' --	4812	2
commit tran 																							--	4812	3
begin tran 																								--	4813	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16369	, @begindate = '1/1/14', @enddate='12/31/14' --	4813	2
commit tran 																							--	4813	3
begin tran 																								--	4814	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16384	, @begindate = '1/1/14', @enddate='12/31/14' --	4814	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16388	, @begindate = '1/1/14', @enddate='12/31/14' --	4814	2
commit tran 																							--	4814	3
begin tran 																								--	4838	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16482	, @begindate = '1/1/14', @enddate='12/31/14' --	4838	2
commit tran 																							--	4838	3
begin tran 																								--	4850	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16784	, @begindate = '1/1/14', @enddate='12/31/14' --	4850	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16796	, @begindate = '1/1/14', @enddate='12/31/14' --	4850	2
commit tran 																							--	4850	3
begin tran 																								--	4853	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16545	, @begindate = '1/1/14', @enddate='12/31/14' --	4853	2
commit tran 																							--	4853	3
begin tran 																								--	4857	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16633	, @begindate = '1/1/14', @enddate='12/31/14' --	4857	2
commit tran 																							--	4857	3
begin tran 																								--	4860	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16607	, @begindate = '1/1/14', @enddate='12/31/14' --	4860	2
commit tran 																							--	4860	3
begin tran 																								--	4866	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16677	, @begindate = '1/1/14', @enddate='12/31/14' --	4866	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16676	, @begindate = '1/1/14', @enddate='12/31/14' --	4866	2
commit tran 																							--	4866	3
begin tran 																								--	4871	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16713	, @begindate = '1/1/14', @enddate='12/31/14' --	4871	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16714	, @begindate = '1/1/14', @enddate='12/31/14' --	4871	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16715	, @begindate = '1/1/14', @enddate='12/31/14' --	4871	2
commit tran 																							--	4871	3
begin tran 																								--	4874	1
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16802	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16804	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16806	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16801	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16808	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16803	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16805	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
exec tmp_FixSkippedMultiResponseAnswers @survey_id=	16807	, @begindate = '1/1/14', @enddate='12/31/14' --	4874	2
commit tran 																							--	4874	3
go

drop procedure tmp_FixSkippedMultiResponseAnswers 
