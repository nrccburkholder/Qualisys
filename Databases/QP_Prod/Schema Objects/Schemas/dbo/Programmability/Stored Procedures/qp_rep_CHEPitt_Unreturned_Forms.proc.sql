CREATE procedure qp_rep_CHEPitt_Unreturned_Forms
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @FirstSampleSet datetime,
 @LastSampleSet datetime
as
set transaction isolation level read uncommitted
declare @Survey_id int, @Study_id int, @SQL Varchar(2500), @TableList varchar(100)

select @survey_id = survey_id from clientstudysurvey_view where strclient_nm = @client and strstudy_nm = @study and strsurvey_nm = @survey
select @study_id = study_id from survey_def where survey_id = @survey_id

create table #Returns (SamplePop_id int, Returned int, Undeliverable int)
insert into #Returns
select sp.samplepop_id, 0, null
from samplepop sp, sampleset ss
where sp.sampleset_id = ss.sampleset_id	
and ss.survey_id = @survey_id
and convert(varchar,ss.datsamplecreate_dt,120) between convert(varchar,@FirstSampleSet,120) and convert(varchar,@LastSampleSet,120)

update r
set r.returned = 1
from #returns r, questionform qf
where r.samplepop_id = qf.samplepop_id
and qf.datreturned is not null

update r
set r.undeliverable = 1
from #returns r, questionform qf, sentmailing sm
where r.samplepop_id = qf.samplepop_id
and qf.sentmail_id = sm.sentmail_id
and sm.datundeliverable is not null

select strtable_nm + strfield_nm as FieldName
into #FieldList
from metadata_view 
where study_id = @Study_id
and (strtable_nm = 'POPULATION' or strtable_nm = 'FACILITY')

select @SQL = (select top 1 fieldname from #fieldlist)
delete #fieldlist where FieldName = (select top 1 fieldname from #fieldlist)
while (select count(*) from #fieldlist) > 0
begin
 select @SQL = @SQL + ', '+(select top 1 fieldname from #fieldlist)
 delete #fieldlist where FieldName = (select top 1 fieldname from #fieldlist)
end
drop table #fieldlist

/*set @TableList = 's'+convert(varchar,@study_id)+'.population'
if exists (select strtable_nm from metatable where strtable_nm = 'FACILITY' and study_id = @study_id)
set @TableList = @TableList +', s'+convert(varchar,@study_id)+'.facility'
*/
set @SQL = 'Select '+@SQL+', r.Undeliverable'+char(10)+
'from s' + convert(varchar,@study_id) + '.big_view p, samplepop sp, #returns r'+char(10)+
'where p.populationpop_id = sp.pop_id'+char(10)+
'and sp.samplepop_id = r.samplepop_id'+char(10)+
'and r.returned = 0'

exec(@SQL)
--select @SQL

drop table #returns

set transaction isolation level read committed


