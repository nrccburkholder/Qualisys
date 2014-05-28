CREATE procedure sp_Export_NewMRD_Sub
@cutoff_id integer, @ReturnsOnly bit = 0 
as

exec master.dbo.xp_sendmail @recipients='bdohmen', @subject='sp_Export_NewMRD_Sub', @message=@cutoff_id

declare @start_dt datetime, @stop_dt datetime, @survey_id integer, @study_id integer, @cutoffType char(1)
declare @fld varchar(100), @shrt varchar(100), @SQL varchar(8000), @Sel varchar(8000)
declare @tbl integer

select @survey_id=survey_id, @start_dt=isnull(datCutoffStart_dt,0), @stop_dt=isnull(datCutoffStop_dt,0)
from cutoff where cutoff_id=@cutoff_id

select @study_id=study_id, @cutoffType=strCutoffResponse_Cd
from survey_def 
where survey_id=@survey_id

if @start_dt=0
begin
  if @cutofftype='0'
    select @start_dt=min(datSampleCreate_dt), @stop_dt=max(datSampleCreate_dt)
    from questionform qf, samplepop sp, sampleset ss
    where qf.cutoff_id=@cutoff_id
      and qf.samplepop_id=sp.samplepop_id
      and sp.sampleset_id=ss.sampleset_id    
  else if @cutofftype='1'
    begin
      select @start_dt=min(datReturned), @stop_dt=max(datReturned)
      from questionform
      where cutoff_id=@cutoff_id
      set @ReturnsOnly=1
    end
  else 
    begin
      select @Sel = strtable_nm + strField_nm
      from survey_def sd, metatable mt, metafield mf
      where cutofftable_id=mt.table_id
        and cutofffield_id=mf.field_id
        and survey_id=@survey_id

      create table #daterange (mn datetime, mx datetime)
      select @SQL = 
      'insert into #daterange (mn, mx) ' +
      'select min('+@sel+'), max('+@sel+') '+
      'from questionform qf, samplepop sp, selectedsample ss, s'+convert(varchar,@study_id)+'.unikeys uk, s'+convert(varchar,@study_id)+'.big_view bv '+
      'where qf.cutoff_id='+convert(varchar,@cutoff_id)+
      '  and qf.samplepop_id=sp.samplepop_id'+
      '  and sp.sampleset_id=ss.sampleset_id'+
      '  and sp.pop_id=ss.pop_id'+
      '  and ss.sampleset_id=uk.sampleset_id'+
      '  and ss.pop_id=uk.pop_id'+
      '  and ss.sampleunit_id=uk.sampleunit_id'+
      '  and ss.strUnitSelectType=''D'''+
      '  and uk.pop_id=bv.populationpop_id'

      select @tbl=table_id from metatable where study_id=@study_id and strTable_nm='ENCOUNTER'
      if @@rowcount=0 
        begin
          select @tbl=table_id from metatable where study_id=@study_id and strTable_nm='POPULATION'
          select @SQL = @SQL + ' and UK.table_id='+convert(varchar,@tbl)
        end
      else
        select @SQL = @SQL + ' and UK.table_id='+convert(varchar,@tbl) + ' and UK.KeyValue=bv.encounterenc_id'

      exec (@SQL)
      select @start_dt=mn, @stop_dt=mx from #daterange

      drop table #daterange

    end
end

select distinct isnull(strfieldshort_nm,mf.strfield_nm) as shrt, convert(varchar(60),'') as fldnm
into #SelClause
from metatable mt, metastructure ms, metafield mf
where mt.table_id=ms.table_id
  and ms.field_id=mf.field_id
  and mt.study_id=@study_id

update #SelClause
  set fldnm=mt.strtable_nm+'.'+mf.strfield_nm
from metatable mt, metastructure ms, metafield mf
where mt.table_id=ms.table_id
  and ms.field_id=mf.field_id
  and mt.study_id=@study_id
  and #SelClause.shrt=isnull(strfieldshort_nm,mf.strfield_nm)

select distinct isnull(strfieldshort_nm,mf.strfield_nm) +' '+
case strFieldDataType
  when 'S' then 'varchar('+convert(varchar,intfieldlength)+')'
  when 'D' then 'datetime'
  when 'I' then 'integer'
end as strdef, mf.field_id 
into #FldDef
from metatable mt, metastructure ms, metafield mf
where mt.table_id=ms.table_id
  and ms.field_id=mf.field_id
  and mt.study_id=@study_id

insert into #FldDef (strDef,field_id)
  select 'q'+right('00000'+convert(varchar,qstncore),6) + ' integer', selqstns_id+100000
  from sel_qstns where survey_id=@survey_id and subtype=1  

declare curDef cursor for
  select strDef from #flddef order by field_id

select @SQL = 'ALTER TABLE #MRD ADD '
open curDef
fetch next from curDef into @fld
while @@Fetch_status=0
begin
  select @SQL = @SQL + @fld + ' ,'
  fetch next from curDef into @fld
end

close curDef
deallocate curDef
drop table #FldDef
select @SQL = left(@SQL,len(@SQL)-1) 
exec (@SQL)

declare curIns cursor for
  select shrt,fldnm from #SelClause order by shrt

select @SQL = 'INSERT INTO #MRD (sampset, samp_dt, sampunit, unit_nm, samptype, samppop'
select @Sel = 'select uk.sampleset_id, s.datSampleCreate_dt, uk.sampleunit_id, su.strsampleunit_nm, ss.strUnitSelectType, sp.samplepop_id'
open curIns
fetch next from curIns into @shrt,@fld
while @@Fetch_status=0
begin
  select @SQL = @SQL + ','+@shrt
  select @sel = @sel + ','+@fld 
  fetch next from curIns into @shrt,@fld
end
close curIns
deallocate curIns
drop table #SelClause

select @SQL = @SQL + ') ' + @Sel + ' FROM s'+convert(varchar,@study_id)+'.Unikeys UK, SampleSet s, SelectedSample SS, SamplePop SP, SampleUnit SU'
if @ReturnsOnly=1
  select @SQL = @SQL + ', QuestionForm QF'

declare curFrom cursor for
  select 's'+convert(varchar,@study_id)+'.'+strtable_nm+' '+strtable_nm as FRM from metatable where study_id=@study_id
open curFrom
fetch next from curFrom into @shrt
while @@Fetch_status=0
begin
  select @SQL = @SQL + ',' + @shrt
  fetch next from curFrom into @shrt
end
close curFrom
deallocate curFrom

select @SQL = @SQL + ' where UK.sampleset_id=ss.sampleset_id and ss.sampleset_id=s.sampleset_id and uk.pop_id=ss.pop_id and uk.sampleunit_id=ss.sampleunit_id and ss.sampleunit_id=su.sampleunit_id and ss.strUnitSelectType=''D'' and UK.sampleset_id=sp.sampl
eset_id and uk.pop_id=sp.pop_id and UK.pop_id=population.pop_id'
if @ReturnsOnly=1
  select @SQL = @SQL + ' and sp.samplepop_id=qf.samplepop_id and qf.cutoff_id='+convert(varchar,@cutoff_id)

declare curWhere cursor for
  select strtable_nm+'.'+strfield_nm+' = '+lookuptablename+'.'+lookupfieldname as condtn
  from metalookup_view 
  where study_id=@study_id
open curWhere
fetch next from curWhere into @shrt
while @@fetch_status=0
begin
  select @SQL = @SQL + ' and ' + @shrt
  fetch next from curWhere into @shrt
end
close curWhere
deallocate curWhere

select @tbl=table_id from metatable where study_id=@study_id and strTable_nm='ENCOUNTER'

if @@rowcount=0 
  begin
    select @tbl=table_id from metatable where study_id=@study_id and strTable_nm='POPULATION'
    select @SQL = @SQL + ' and UK.table_id='+convert(varchar,@tbl)
  end
else
  select @SQL = @SQL + ' and UK.table_id='+convert(varchar,@tbl) + ' and UK.KeyValue=encounter.enc_id'

if @cutofftype = '0'
  select @SQL = @SQL + ' and S.datSampleCreate_dt >= '''+convert(varchar,@start_dt,100)+''' and S.datSampleCreate_dt < dateadd(day,1,'''+convert(varchar,@stop_dt,100)+''')'
else
  if @cutofftype = '2' 
    begin
      select @Sel = strtable_nm+ '.' + strField_nm
      from survey_def sd, metatable mt, metafield mf
      where cutofftable_id=mt.table_id
        and cutofffield_id=mf.field_id
        and survey_id=@survey_id
      select @SQL = @SQL + ' and ' + @sel + ' between '''+convert(varchar,@start_dt,100)+''' and '''+convert(varchar,@stop_dt,100)+''''
    end
exec (@SQL)
/* added datundeliverable to #MRD table */
update #mrd 
set qstnform=questionform_id, rtrn_dt=datReturned, lithocd=sm.strlithocode, undel_dt = datundeliverable
from QuestionForm qf, sentmailing sm
where #mrd.samppop=qf.samplepop_id
  and qf.cutoff_id=@cutoff_id
  and qf.sentmail_id=sm.sentmail_id

if @cutofftype = '1'
  delete #MRD where qstnform is null or rtrn_dt is null
else
  update #mrd
  set qstnform=questionform_id
  from QuestionForm qf
  where #mrd.samppop=qf.samplepop_id
    and #mrd.qstnform is null
    and isnull(qf.cutoff_id,-1) <> @cutoff_id

declare @core integer

declare curQstn cursor for
  select 'q'+right('00000'+convert(varchar,qstncore),6),qstncore from sel_qstns where survey_id=@survey_id and subtype=1
open curQstn
fetch next from curQstn into @fld, @core
while @@Fetch_status=0
begin
  select @SQL = 
      'update #MRD'+
      '  set '+@fld+' = intresponseval '+
      'from questionresult qr '+
      'where #mrd.rtrn_dt is not null'+
      '  and #mrd.qstnform=qr.questionform_id'+
      '  and #mrd.sampunit=qr.sampleunit_id'+
      '  and qr.qstncore='+convert(varchar,@core)
  exec (@SQL)
  select @SQL = 
      'update #MRD'+
      '  set '+@fld+' = intresponseval '+
      'from questionresult qr '+
      'where #mrd.rtrn_dt is not null'+
      '  and #mrd.qstnform=qr.questionform_id'+
      '  and #mrd.'+@fld+' is null'+
      '  and qr.qstncore='+convert(varchar,@core)
  exec (@SQL)
  fetch next from curQstn into @fld, @core
end
close curQstn
deallocate curQstn


