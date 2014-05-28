CREATE procedure QP_Rep_SampleUnitSection 
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @cutoff varchar(20)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intStudy_id int, @intSamplePlan_id int, @strMRD varchar(20), @sql varchar(3000)

select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSamplePlan_id=SamplePlan_id 
from SamplePlan 
where Survey_id=@intSurvey_id

select @strMRD = '[s'+convert(varchar,@intStudy_id)+'].[MRD_' + convert(varchar,cutoff_id)+']'
from cutoff
where survey_id = @intsurvey_id
  and datediff(ss,datcutoffdate,@cutoff) < 1

set @SQL = 'if exists (select * from sysobjects where id = object_id(N'''+@strMRD+''') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)
  print ''exec sp_export_newmrd3 '''
exec (@SQL)

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int,
  NSize int default 0)

exec sp_SampleUnits @intSamplePlan_id

set @SQL =
  'update SU
  set NSize=cnt
  from #SampleUnits SU, 
   (select sampunit,count(distinct lithocd) as cnt
    from '+@strMRD+'
    where Rtrn_dt is not null 
    group by sampunit) MRD
  where SU.sampleunit_id=MRD.sampunit'
exec (@SQL)

declare @intSection_id int, @qstn char(6), @SelCols varchar(1000)
set @SelCols = ''

declare curSect cursor for
  select distinct section_id
  from sel_qstns
  where survey_id=@intSurvey_id
    and subtype=1

open curSect
fetch next from curSect into @intSection_id
while @@fetch_status=0
begin
  set @SQL = 'alter table #sampleunits add Sec'+convert(varchar,@intSection_id)+' char(1), int'+convert(varchar,@intSection_id)+' int'
  exec (@SQL)
  select @selCols=@SelCols + ', Sec'+convert(varchar,@intSection_id)+', int'+convert(varchar,@intSection_id)+' as [' + rtrim(label) + ']'
    from sel_qstns
    where survey_id=@intSurvey_id
      and section_id=@intSection_id
      and subtype=3

  set @SQL = ''
  declare curQ cursor for
    select right('00000'+convert(varchar,qstncore),6)
    from sel_qstns
    where survey_id=@intSurvey_id
      and subtype=1
      and section_id=@intSection_id
  set @SQL = ''
  open curQ
  fetch next from curQ into @qstn
  while @@fetch_status=0
  begin
    set @SQL = @SQL +'q'+@qstn+','
    fetch next from curQ into @qstn
  end
  close curQ
  deallocate curQ
  set @SQL = left(@SQL,len(@SQL)-1)
  set @SQL = 
   'update su
      set int'+convert(varchar,@intSection_id)+'=cnt, Sec'+convert(varchar,@intSection_id)+'='' ''
      from #sampleunits su, 
           (select sampunit,count(*) as cnt
            from '+@strMRD+'
            where coalesce('+@SQL+') is not null
            group by sampunit) mrd
      where su.sampleunit_id=mrd.sampunit'
  exec (@SQL)

  set @SQL = 
    'update su
     set su.Sec'+convert(varchar,@intSection_id)+'=''X''
     from #SampleUnits su, sampleunitsection sus
     where su.sampleunit_id=sus.sampleunit_id
       and sus.selqstnssection='+convert(varchar,@intSection_id)+'
       and sus.selqstnssurvey_id='+convert(varchar,@intSurvey_id)

  exec (@SQL)


  fetch next from curSect into @intSection_id
end
close curSect
deallocate curSect

set @SQL = 'select SampleUnit_id, strSampleUnit_nm as [Unit Name], NSize as N' + @SelCols + '
 from #sampleunits order by intTreeOrder'
exec (@SQL)

drop table #sampleunits

set transaction isolation level read committed


