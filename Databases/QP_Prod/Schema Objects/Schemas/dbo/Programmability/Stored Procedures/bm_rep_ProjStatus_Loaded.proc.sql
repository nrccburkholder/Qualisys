create procedure dbo.bm_rep_ProjStatus_Loaded
        @Associate varchar(50),
        @Client varchar(50),
        @Study varchar(50),
        @ActivitySince datetime
as

create table #CS (
       client_id int, 
       Study_id int, 
       strCutoffResponse_CD int, 
       cutofftable_id int, 
       cutofffield_id int, 
       strCutoffTable_nm varchar(42), 
       strCutoffField_nm varchar(42),
       intFlag int default 0,
       bitEncounterTable bit
)

insert into #cs (
        client_id, 
        Study_id, 
        strCutoffResponse_CD, 
        cutofftable_id, 
        cutofffield_id, 
        strcutofftable_nm, 
        strCutofffield_nm, 
        bitEncounterTable
       )
select css.client_id, 
       css.study_id, 
       sd.strCutoffResponse_CD, 
       sd.cutofftable_id, 
       sd.cutofffield_id, 
       NULL, 
       NULL, 
       0
  from clientstudysurvey_view css, 
       survey_def sd, 
       data_set ds
 where css.strclient_nm = @Client
   and css.strstudy_nm = case when @study='_ALL' then css.strStudy_nm else @Study end
   and css.study_id=ds.study_id
   and ds.datload_dt >= @ActivitySince
   and css.survey_id = sd.survey_id
 group by 
       css.client_id, 
       css.study_id, 
       sd.strCutoffResponse_CD, 
       sd.cutofftable_id, 
       sd.cutofffield_id

update #cs
   set strCutoffTable_nm = strTable_nm, 
       strCutoffField_nm = strField_nm
  from metatable mt, 
       metafield mf
 where #cs.cutofftable_id = mt.table_id
   and #cs.cutofffield_id = mf.field_id
   and #cs.strCutoffResponse_cd = 2 

update #cs
   set bitEncounterTable=1
  from metatable mt
 where #cs.study_id = mt.study_id
   and mt.strTable_nm = 'ENCOUNTER'

create table #counts (
       dataset_id int, 
       rec_cnt int, 
       indiv_cnt int, 
       FirstDt datetime, 
       LastDt datetime
)

declare @SQL varchar(8000)

set rowcount 20

update #cs 
   set intFlag=1
   
while @@rowcount>0 
begin

    ---------------------------------------------------------
    -- Sampe insert script
    ---------------------------------------------------------
    --
    -- insert into #counts 
    -- select ds.dataset_id,
    --        count(*),
    --        count(distinct dsm.pop_id),
    --        min(bv.ENCOUNTERDischargeDate) as FirstDt,
    --        max(bv.ENCOUNTERDischargeDate) as LastDt
    --   from data_set ds, 
    --        datasetmember dsm, 
    --        s8.big_view bv
    --  where ds.study_id = 8
    --    and ds.datload_dt >= '09/28/2003'
    --    and dsm.dataset_id = ds.dataset_id
    --    and bv.populationpop_id = dsm.pop_id
    --    and bv.encounterenc_id = dsm.enc_id
    --  group by ds.dataset_id
    --
    -- insert into #counts 
    -- select ds.dataset_id,
    --        count(*),
    --        count(distinct dsm.pop_id),
    --        min(bv.ENCOUNTERServiceDate) as FirstDt,
    --        max(bv.ENCOUNTERServiceDate) as LastDt
    --   from data_set ds, 
    --        datasetmember dsm, 
    --        s684.big_view bv
    --  where ds.study_id = 684
    --    and ds.datload_dt >= '09/28/2003'
    --    and dsm.dataset_id = ds.dataset_id
    --    and bv.populationpop_id = dsm.pop_id
    --    and bv.encounterenc_id = dsm.enc_id
    --  group by ds.dataset_id
    --
    ---------------------------------------------------------
    
    set @SQL=''

    select @SQL = @SQL + '
                   insert into #counts 
                   select ds.dataset_id,
                          count(*),
                          count(distinct dsm.pop_id),
                          ' + isnull('min(bv.'+strcutofftable_nm+strCutofffield_nm+')','null')+' as FirstDt,
                          ' + isnull('max(bv.'+strcutofftable_nm+strCutofffield_nm+')','null')+' as LastDt
                     from data_set ds, 
                          datasetmember dsm, 
                          s' + convert(varchar, study_id) + '.big_view bv
                    where ds.study_id = ' + convert(varchar, study_id) + '
                      and ds.datload_dt >= ''' + convert(varchar, @ActivitySince, 101) + '''
                      and dsm.dataset_id = ds.dataset_id
                      and bv.populationpop_id = dsm.pop_id
                      ' + case when bitEncounterTable=1 
                            then 'and bv.encounterenc_id = dsm.enc_id' 
                            else '' 
                            end + '
                    group by ds.dataset_id
                  '
    from #CS
    where intFlag=1

    PRINT(@SQL)

    exec (@SQL)

    delete from #CS 
     where intflag=1

    update #cs 
       set intFlag=1
end

set rowcount 0

set @SQL = '
     select s.strStudy_nm as [Study files loaded since '+convert(varchar, @ActivitySince, 7)+'], 
            convert(varchar, ds.DATLOAD_DT, 101) as [Loaded On], 
            convert(varchar, sub.firstdt, 101) + '' - '' + convert(varchar, sub.lastdt, 101) as [Date Range], 
            sub.Rec_Cnt as [# records], 
            sub.indiv_cnt as [# individuals]
       from data_set ds, 
            study s, 
            #counts sub
      where ds.study_id = s.study_id
        and ds.dataset_id = sub.dataset_id
      order by 
            s.strStudy_nm, 
            ds.datLoad_dt
    '

exec (@SQL)

drop table #cs
drop table #counts


