CREATE procedure sp_Export_NewMRD3_VA_Sub_Second
@cutoff_id integer, @ReturnsOnly bit = 0, @DirectOnly bit = 0
as
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
      '  and uk.pop_id=bv.populationpop_id'

      if @DirectOnly=1
         Select @sql=@SQL+'  and ss.strUnitSelectType=''D'''

      select @tbl=table_id from metatable where study_id=@study_id and strTable_nm='ENCOUNTER'
      if @@rowcount=0 
        begin
          select @tbl=table_id from metatable where study_id=@study_id and strTable_nm='POPULATION'
          select @SQL = @SQL + ' and UK.table_id='+convert(varchar,@tbl)
        end
      else
        select @SQL = @SQL + ' and UK.table_id='+convert(varchar,@tbl) + ' and UK.KeyValue=bv.encounterenc_id'

      Exec (@SQL)
      select @start_dt=mn, @stop_dt=mx from #daterange

      drop table #daterange

    end
end

select distinct isnull(strfieldshort_nm,left(mf.strfield_nm,8)) as shrt, convert(varchar(60),'') as fldnm
into #SelClause
from metatable mt, metastructure ms, metafield mf
where mt.table_id=ms.table_id
  and ms.field_id=mf.field_id
  and mt.study_id=@study_id

update #SelClause
  set fldnm = 
    case 
      when strFieldDataType='D' and strField_nm<>'NewRecordDate' 
      then 'convert(varchar,'+mt.strtable_nm+'.'+mf.strfield_nm+',101)' 
      else mt.strtable_nm+'.'+mf.strfield_nm 
    end
from metatable mt, metastructure ms, metafield mf
where mt.table_id=ms.table_id
  and ms.field_id=mf.field_id
  and mt.study_id=@study_id
  and #SelClause.shrt=isnull(strfieldshort_nm,left(mf.strfield_nm,8))

select distinct isnull(strfieldshort_nm,left(mf.strfield_nm,8)) +' '+
case strFieldDataType
  when 'S' then 'varchar('+convert(varchar,intfieldlength)+')'
  when 'D' then case when strField_nm='NewRecordDate' then 'datetime' else 'varchar(10)' end
  when 'I' then 'integer'
end as strdef, mf.field_id 
into #FldDef
from metatable mt, metastructure ms, metafield mf
where mt.table_id=ms.table_id
  and ms.field_id=mf.field_id
  and mt.study_id=@study_id

insert into #FldDef (strDef,field_id)
  select 'q'+right('00000'+convert(varchar,qstncore),6) + ' integer', sq.section_id * 100000 + sq.subsection * 100 + sq.item
  from sel_qstns sq
  where survey_id=@survey_id
    and subtype=1  
    and numMarkCount=1
  union 
  select 'q'+right('00000'+convert(varchar,sq.qstncore),6) + case when ss.val between 1 and 26 then char(96+ss.val) else '' end +' integer', sq.section_id * 100000 + sq.subsection * 100 + sq.item
  from sel_qstns sq, Sel_Scls ss
  where sq.survey_id=ss.survey_id
    and sq.scaleid=ss.qpc_id
    and sq.survey_id=@survey_id
    and sq.subtype=1  
    and sq.numMarkCount=2

declare curDef cursor for
  select strDef from #flddef order by field_id

select @SQL = 'ALTER TABLE s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' ADD '
open curDef
fetch next from curDef into @fld
while @@Fetch_status=0
begin
  select @SQL = @SQL + @fld + ' ,'
  fetch next from curDef into @fld
end close curDef
deallocate curDef
drop table #FldDef
select @SQL = left(@SQL,len(@SQL)-1) 
Exec (@SQL)

declare curIns cursor for
  select shrt,fldnm from #SelClause order by shrt

select @SQL = 'INSERT INTO s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' (sampset, samp_dt, sampunit, unit_nm, samptype, samppop, mailstep'
select @Sel = 'select uk.sampleset_id, s.datSampleCreate_dt, uk.sampleunit_id, su.strsampleunit_nm, ss.strUnitSelectType, sp.samplepop_id, schm.mailingstep_id'
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

select @SQL = @SQL + ') ' + @Sel + ' FROM s'+convert(varchar,@study_id)+'.Unikeys UK, SampleSet s, SelectedSample SS, SamplePop SP, SampleUnit SU, scheduledmailing schm '
if @ReturnsOnly=1
  select @SQL = @SQL + ', QuestionForm QF '

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

select @SQL = @SQL + ' where UK.sampleset_id=ss.sampleset_id and ss.sampleset_id=s.sampleset_id and uk.pop_id=ss.pop_id and uk.sampleunit_id=ss.sampleunit_id and ss.sampleunit_id=su.sampleunit_id and UK.sampleset_id=sp.sampleset_id and uk.pop_id=sp.pop_id

 and UK.pop_id=population.pop_id and sp.samplepop_id = schm.samplepop_id '
if @DirectOnly=1
  select @SQL = @SQL + ' and ss.strUnitSelectType=''D'''
if @ReturnsOnly=1
  select @SQL = @SQL + ' and sp.samplepop_id=qf.samplepop_id and qf.cutoff_id='+convert(varchar,@cutoff_id)+' and qf.sentmail_id=schm.sentmail_id '

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
Exec (@SQL)

select @sql = 'update MRD '+
'set qstnform=questionform_id, rtrn_dt=datReturned, lithocd=sm.strlithocode '+
'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' MRD, QuestionForm qf, sentmailing sm, scheduledmailing schm '+
'where MRD.samppop=qf.samplepop_id '+
'  and qf.cutoff_id='+convert(varchar,@cutoff_id) +
'  and qf.sentmail_id=sm.sentmail_id '+
'  and qf.sentmail_id=schm.sentmail_id '+
'  and schm.mailingstep_id=mrd.mailstep '
Exec (@SQL)

set @sql='delete s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' where lithocd is null'
EXEC (@sql)

/* added datundeliverable to MRD table */
select @sql = 'update MRD '+
'set undel_dt=datundeliverable '+
'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' MRD, QuestionForm qf, sentmailing sm '+
'where MRD.samppop=qf.samplepop_id '+
'  and qf.sentmail_id=sm.sentmail_id '+
'  and qf.datReturned is null' 
Exec (@SQL)

if @cutofftype = '1'
  select @sql = 'delete s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' where qstnform is null or rtrn_dt is null'
else
  select @sql = 'update mrd '+
  'set qstnform=questionform_id '+
  'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' mrd, QuestionForm qf '+
  'where mrd.samppop=qf.samplepop_id '+
  '  and mrd.qstnform is null '+
  '  and isnull(qf.cutoff_id,-1) <> '+convert(varchar,@cutoff_id)
exec(@sql)

/*Added 4/24/1 Brian Dohmen
Creation of the temp results table used in the following updates*/
select QR.QuestionForm_id, QstnCore, intResponseVal, SampleUnit_ID
into #QuestionResult2 
from QuestionResult2 QR, QuestionForm QF
where Cutoff_ID = @Cutoff_ID
and QF.QuestionForm_ID = QR.QuestionForm_ID

create index tmpindex on #questionresult2 (questionform_id, sampleunit_id, qstncore)

set @sql='CREATE INDEX tempindex on s'+convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' (qstnform, sampunit)'
EXEC (@sql)

/* Single Response questions */
declare @core integer

declare curQstn cursor for
  select 'q'+right('00000'+convert(varchar,qstncore),6),qstncore 
  from sel_qstns 
  where survey_id=@survey_id and subtype=1 and numMarkcount=1

open curQstn
fetch next from curQstn into @fld, @core
while @@Fetch_status=0
begin
  select @SQL = 
      'update MRD'+
      '  set '+@fld+' = intresponseval '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' MRD, #QuestionResult2 qr '+
      'where mrd.rtrn_dt is not null'+
      '  and mrd.qstnform=qr.questionform_id'+
      '  and mrd.sampunit=qr.sampleunit_id'+
      '  and qr.qstncore='+convert(varchar,@core)
  Exec (@SQL)
  select @SQL = 
      'update MRD'+
      '  set '+@fld+' = intresponseval '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' MRD, #QuestionResult2 qr '+
      'where mrd.rtrn_dt is not null'+
      '  and mrd.qstnform=qr.questionform_id'+
      '  and mrd.'+@fld+' is null'+
      '  and qr.qstncore='+convert(varchar,@core)
  Exec (@SQL)
  fetch next from curQstn into @fld, @core
end
close curQstn
deallocate curQstn

/* Multiple Response questions */
declare curQstn cursor for
  select 'q'+right('00000'+convert(varchar,qstncore),6)+case when ss.val between 1 and 26 then char(96+ss.val) else '' end,qstncore,ss.val
  from sel_qstns sq, sel_scls ss
  where sq.survey_id=ss.survey_id and sq.scaleid=ss.qpc_id
    and sq.survey_id=@survey_id and subtype=1 and numMarkcount=2

declare @val integer

open curQstn
fetch next from curQstn into @fld, @core, @val
while @@Fetch_status=0
begin
  select @SQL = 
      'update MRD'+
      '  set '+@fld+' = '+convert(varchar,@val)+' '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' MRD, #QuestionResult2 qr '+
      'where mrd.rtrn_dt is not null'+
      '  and mrd.qstnform=qr.questionform_id'+
      '  and mrd.sampunit=qr.sampleunit_id'+
      '  and qr.qstncore='+convert(varchar,@core)+
      '  and qr.intResponseval='+convert(varchar,@val)
  Exec (@SQL)
  select @SQL = 
      'update MRD'+
      '  set '+@fld+' = '+convert(varchar,@val)+' '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+' MRD, #QuestionResult2 qr '+
      'where mrd.rtrn_dt is not null'+
      '  and mrd.qstnform=qr.questionform_id'+
      '  and mrd.'+@fld+' is null'+
      '  and qr.qstncore='+convert(varchar,@core)+
      '  and qr.intResponseval='+convert(varchar,@val)
  Exec (@SQL)
  fetch next from curQstn into @fld, @core, @val
end
close curQstn
deallocate curQstn

--select @sql = 'delete from s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+
--' where lithocd is null '
--Exec (@SQL)

drop table #QuestionResult2


