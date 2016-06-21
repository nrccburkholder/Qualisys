/*
S16.US11 Extract Data for ICH
	Extract Data for ICH for submission

T11.1	Extract Data for ICH for submission with likely multiple runs and adjustments

this script will manually update the datamart's Sampleset.StandardMethodologyID column 

Dave Gilsdorf

*/
use qp_Prod
go
if object_id('tempdb..#ssmm') is not null
	drop table #ssmm
go
select sd.survey_id, ss.sampleset_id, min(mm.methodology_id) as methodology_id, count(distinct mm.methodology_id) as numMethods
into #ssmm
from survey_def sd
inner join sampleset ss on sd.survey_id=ss.survey_id
inner join samplepop sp on ss.sampleset_id=sp.sampleset_id
inner join scheduledmailing schm on sp.samplepop_id=schm.samplepop_id
inner join mailingmethodology mm on schm.methodology_id=mm.methodology_id
where sd.surveytype_id = 8
group by sd.survey_id, ss.sampleset_id

if exists (select * from #ssmm where numMethods <> 1) 
	select * 
	from [this shouldn't happen - there's more than one methodology_id for a single sampleset]

declare @sql varchar(max)
set @sql='select DataSourceKeyID, DataSourceKey from etl.datasourcekey where datasourcekey in ('	
select @sql = @sql  + '''' + convert(varchar,sampleset_id) + ''','
from #ssmm 
set @sql = left(@sql,len(@sql)-1) + ')'
print @SQL


-- execute the above select in the datamart. It should look something like this:
-- select DataSourceKeyID, DataSourceKey from etl.datasourcekey where datasourcekey in ('1306973','1306970','1306971')
-- script the grid results and paste it in here, 

---------------   #tmp_GridResults_1   ---------------
note: this is just an example. Script the actual results from NRC_Datamart and paste in the script here. And remove or comment out this line.
SELECT * INTO #tmp_GridResults_1
FROM (
SELECT N'167045822' AS [DataSourceKeyID], N'1306929' AS [DataSourceKey] UNION ALL
SELECT N'167045826' AS [DataSourceKeyID], N'1306933' AS [DataSourceKey] UNION ALL
SELECT N'167045844' AS [DataSourceKeyID], N'1306951' AS [DataSourceKey] UNION ALL
SELECT N'167046822' AS [DataSourceKeyID], N'1306967' AS [DataSourceKey] UNION ALL
SELECT N'167046823' AS [DataSourceKeyID], N'1306968' AS [DataSourceKey] UNION ALL
SELECT N'167046824' AS [DataSourceKeyID], N'1306969' AS [DataSourceKey] UNION ALL
SELECT N'167046825' AS [DataSourceKeyID], N'1306970' AS [DataSourceKey] UNION ALL
SELECT N'167046826' AS [DataSourceKeyID], N'1306971' AS [DataSourceKey] UNION ALL
SELECT N'167046827' AS [DataSourceKeyID], N'1306972' AS [DataSourceKey] UNION ALL
SELECT N'167046828' AS [DataSourceKeyID], N'1306973' AS [DataSourceKey] UNION ALL
SELECT N'167046829' AS [DataSourceKeyID], N'1306974' AS [DataSourceKey] UNION ALL
SELECT N'167045883' AS [DataSourceKeyID], N'1307020' AS [DataSourceKey] UNION ALL
SELECT N'167045884' AS [DataSourceKeyID], N'1307021' AS [DataSourceKey] UNION ALL
SELECT N'167045791' AS [DataSourceKeyID], N'1307023' AS [DataSourceKey] UNION ALL
SELECT N'167045792' AS [DataSourceKeyID], N'1307024' AS [DataSourceKey] UNION ALL
SELECT N'167045793' AS [DataSourceKeyID], N'1307026' AS [DataSourceKey] UNION ALL
SELECT N'167045794' AS [DataSourceKeyID], N'1307027' AS [DataSourceKey] UNION ALL
SELECT N'167118990' AS [DataSourceKeyID], N'1307028' AS [DataSourceKey] UNION ALL
SELECT N'167118991' AS [DataSourceKeyID], N'1307029' AS [DataSourceKey] UNION ALL
SELECT N'167118992' AS [DataSourceKeyID], N'1307030' AS [DataSourceKey] UNION ALL
SELECT N'167118993' AS [DataSourceKeyID], N'1307031' AS [DataSourceKey] UNION ALL
SELECT N'167118994' AS [DataSourceKeyID], N'1307032' AS [DataSourceKey] UNION ALL
SELECT N'167118995' AS [DataSourceKeyID], N'1307033' AS [DataSourceKey] UNION ALL
SELECT N'167118996' AS [DataSourceKeyID], N'1307034' AS [DataSourceKey] UNION ALL
SELECT N'167118997' AS [DataSourceKeyID], N'1307035' AS [DataSourceKey] UNION ALL
SELECT N'167118998' AS [DataSourceKeyID], N'1307036' AS [DataSourceKey] ) t;

select ssmm.*, sm.*, gr.DataSourceKey as SamplesetID,
'update sampleset set StandardMethodologyID='+convert(varchar,mm.StandardMethodologyID)+' where samplesetid='+convert(varchar,gr.DataSourceKeyID ) as UpdateCmnd
from #ssmm ssmm
inner join mailingmethodology mm on ssmm.methodology_id=mm.methodology_id
inner join standardmethodology sm on mm.StandardMethodologyID=sm.StandardMethodologyID
inner join #tmp_GridResults_1 gr on ssmm.sampleset_id=gr.datasourcekey

-- execute the contents of the UpdateCmnd column from the above resultset in the datamart.

