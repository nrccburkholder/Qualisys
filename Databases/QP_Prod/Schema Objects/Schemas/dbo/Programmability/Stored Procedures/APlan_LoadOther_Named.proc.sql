CREATE procedure APlan_LoadOther_Named
  @Table_nm varchar(50), @OtherTable_nm varchar(50), @WhereClause varchar(255) = 'samptype=''D'''
as
-- Felix & I had each written procedures that did the same thing.  Felix's was much better, so use
-- APlan_LoadOther2 instead of APlan_LoadOther_Named.
-- DG 8/9/01

exec APlan_LoadOther2 @otherTable_nm, @WhereClause

/*
declare @survey_id int, @OtherSurvey_id int, @study_id int, @OtherStudy_id int, @SQL varchar(8000)

create table #SU (sampleunit_id int)
set @sql = 'insert into #SU select min(sampunit) from '+@Table_nm
exec (@SQL)
select @survey_id=survey_id from sampleplan sp, sampleunit su, #SU where #SU.sampleunit_id=su.sampleunit_id and su.sampleplan_id=sp.sampleplan_id
select @study_id=study_id from survey_def where survey_id=@survey_id

truncate table #SU
set @sql = 'insert into #SU select min(sampunit) from '+@OtherTable_nm
exec (@SQL)
select @othersurvey_id=survey_id from sampleplan sp, sampleunit su, #SU where #SU.sampleunit_id=su.sampleunit_id and su.sampleplan_id=sp.sampleplan_id
select @otherstudy_id=study_id from survey_def where survey_id=@othersurvey_id

declare curQstn cursor for
    select name
    from 	(select sc.name
	from syscolumns sc, sysobjects so, sysusers su
	where su.name = 's' + convert(varchar,@study_id)
	  and su.uid=so.uid
	  and so.name = substring(@Table_nm,1+charindex('.',@Table_nm),len(@Table_nm))
	  and so.id=sc.id
	  and (sc.name like 'Q0%' or sc.name in ('AGE','SEX'))
	union all
	select sc.name
	from syscolumns sc, sysobjects so, sysusers su
	where su.name = 's' + convert(varchar,@otherstudy_id)
	  and su.uid=so.uid
	  and so.name = substring(@OtherTable_nm,1+charindex('.',@OtherTable_nm),len(@OtherTable_nm))
	  and so.id=sc.id
	  and (sc.name like 'Q0%' or sc.name in ('AGE','SEX'))) x
    group by name
    having count(*)=2

declare @strCore varchar(20)
Open curQstn
Fetch next from curQstn
  into @strCore  
set @SQL='SampUnit, SampType, lithocd'
while @@fetch_status=0
begin
  set @SQL = @SQL + ', ' + @strCore
  Fetch next from curQstn
    into @strCore  
end
close curQstn
deallocate curQstn
declare @SampSet int
-- #aggregate uses the SampSet column to find the survey_id
select top 1 @SampSet = sampleset_id from sampleset where survey_id=@survey_id
set @SQL = 'INSERT INTO #MRD (SampSet, ' + @SQL + ') SELECT '+convert(varchar,@sampset)+','+@SQL+' FROM ' + @OtherTable_nm + ' where ' + @WhereClause
exec (@SQL)
*/


