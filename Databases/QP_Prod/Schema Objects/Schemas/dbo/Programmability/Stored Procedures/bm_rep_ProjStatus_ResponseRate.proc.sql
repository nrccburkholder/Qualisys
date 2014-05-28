CREATE procedure [dbo].[bm_rep_ProjStatus_ResponseRate]
        @Associate varchar(50),
        @Client varchar(50),
        @Study varchar(50),
        @RespRateDetail varchar(30),
        @Period varchar(15)
AS
--select @Associate = 'dgilsdorf', @Client = 'St. Elizabeth Medical Center', @Study = '_ALL', @RespRateDetail = 'Root levels + 10', @Period='Current'
--select @Associate = 'dgilsdorf', @Client = 'Holy Family Memorial', @Study = '_ALL', @RespRateDetail = 'Root levels + 10', @Period='Current'
--select @associate= 'dgilsdorf', @client= 'Ontario Hospital Association', @study= '_ALL', @respratedetail= 'Root levels + 22', @period= 'Current'
--select @Associate='Dgilsdorf', @Client='St. Luke''s Episcopal Hospital', @Study='StLEH Empl ', @RespRateDetail='Root levels + 5', @Period='Current'

-- Set depth of sample unit for the report
declare @PlanDepth int
if rtrim( @RespRateDetail) = 'Root level only'
     set @planDepth=1
else
     set @planDepth= 1+convert(int,right(rtrim( @RespRateDetail),2))

-- Survey period info
create table #CSS (
        client_id int, 
        Study_id int, 
        Survey_id int,
        SamplePlan_id int,
        PrevBeginDate datetime,
        CurrentBeginDate datetime,
        intDone int
)
 
insert into #css (
        client_id, 
        Study_id, 
        survey_id, 
        SamplePlan_id, 
        PrevBeginDate, 
        CurrentBeginDate, 
        intDone
       )
select css.client_id, 
       css.study_id, 
       css.survey_id, 
       max(SamplePlan_id), 
       '1/1/1900', 
       '1/1/1900', 
       0
  from clientstudysurvey_view css 
 where css.strclient_nm = @Client
   and css.strstudy_nm=case when @study='_ALL' then css.strStudy_nm else @Study end
 group by 
       css.client_id, 
       css.study_id, 
       css.survey_id
 
-- create a list of all samplesets and NewPeriodDate records for each survey
create table #cleanperiod (
        cleanperiod_id int identity(1,1), 
        survey_id int, 
        datDateTime datetime, 
        intID int, 
        strWhat varchar(20)
)
 
insert into #cleanperiod (
        survey_id, 
        datDateTime, 
        intID, 
        strWhat
       )
select ss.survey_id, 
       ss.datSampleCreate_dt, 
       ss.sampleset_id, 
       'Sample' 
  from sampleset ss, 
       #css 
 where ss.survey_id=#css.survey_id
union 
select p.survey_id, 
       p.datPeriodDate, 
       p.period_id, 
       'New Period' 
  from period p, 
       #css 
 where p.survey_id=#css.survey_id
 order by 1, 2
 
-- remove the sampleset records
delete from #cleanperiod where strWhat='Sample'
 
-- we're left with NewPeriodDates.  any two or more NewPeriodDates that have
-- consecutive cleanperiod_id's must not have any samplesets between them, 
--so delete all of them except the first one
delete from #cleanperiod 
 where intID in (
             select cp2.intID
               from #cleanperiod cp, 
                    #cleanperiod cp2
              where cp.survey_id = cp2.survey_id
                and cp.strWhat = 'New Period'
                and cp2.strWhat = 'New Period'
                and (cp2.cleanperiod_id - cp.cleanperiod_id) = 1
            )
 
-- now we're left with NewPeriodDates that we KNOW have samplesets between them.  
-- update #css with the latest NewPeriodDate. This is the current period begin date.
update #css
   set currentBeginDate = sub.datDateTime
  from (
        select survey_id,
               max(datDateTime) as datDateTime 
          from #cleanperiod 
         group by survey_id
       ) sub
 where #css.survey_id = sub.survey_id
 
-- remove the latest NewPeriodDate
delete cp
  from #cleanPeriod cp,
       (
        select survey_id,
               max(datDateTime) as datDateTime 
          from #cleanperiod 
         group by survey_id
       ) sub
 where cp.survey_id = sub.survey_id
   and cp.datDateTime = sub.datDateTime
 
-- update #css with the latest NewPeriodDate.
-- This is the previous period begin date.
update #css
   set prevBeginDate = sub.datDateTime
  from (
        select survey_id,
               max(datDateTime) as datDateTime 
          from #cleanperiod 
         group by survey_id
       ) sub
 where #css.survey_id = sub.survey_id
 

-- Create SampleSet for each survey based on the selected period (current or previous)
create table #sampleset (
       survey_id int, 
       sampleset_id int
)
 
if @Period='Previous'
     insert into #sampleset
     select c.survey_id, 
            ss.sampleset_id
       from #css c, 
            sampleset ss
      where c.survey_id=ss.survey_id
        and ss.datSampleCreate_dt between c.PrevBeginDate 
                                      and c.CurrentBeginDate
else
     insert into #sampleset
     select c.survey_id, 
            ss.sampleset_id
       from #css c, 
            sampleset ss
      where c.survey_id = ss.survey_id
        and ss.datSampleCreate_dt >= c.CurrentBeginDate
 
-- Create list of sample units and their tier number
create table #SampleUnits (
       Survey_id int,
       SampleUnit_id int,
       ParentSampleUnit_id int,
       strSampleUnit_nm varchar(255),
       intTier int,
       intTreeOrder int,
       intTarget int,
       intKidTargets int,
       intSampled int,
       intUndel int,
       intReturned int,
       datLastToDate smalldatetime
)
 

declare @SQL varchar(8000)
 
set rowcount 85

update #css 
   set intDone=1 
 where intDone=0
 
while @@rowcount>0
begin
     set @SQL=''
 
     select @SQL = @SQL + '
             exec sp_SampleUnits ' + convert(varchar,SamplePlan_id) + '
             update #SampleUnits
                set survey_id = ' + convert(varchar,survey_id)+'
              where survey_id is null
            '
       from #css
      where intDone=1
 
     set rowcount 0
     exec ( @SQL)
 
     update #css set intdone=2 where intdone=1
     set rowcount 85
     update #css set intDone=1 where intDone=0
end
set rowcount 0

select *
  from #SampleUnits
 
 
-- Set the parent unit and target number for each sample unit
update #sampleunits 
   set intTarget = intTargetReturn, 
       parentsampleunit_id = su.parentsampleunit_id, 
       intKidTargets = 0
  from SampleUnit su
 where #sampleunits.sampleunit_id = su.sampleunit_id

-- Delete those sample units that need to be suppressed
delete 
from #sampleunits 
where sampleunit_id in (select sampleunit_id from datamart.qp_comments.dbo.sampleunit where bitSuppress=1)


-- Begin to calculate response rate
create table #RR (
       sampleunit_id int, 
       intSampled int, 
       intUndel int, 
       intReturned int
)
 
insert into #rr 
select sampleunit_id,
       sum(intSampled) as intSampled, 
       sum(intUD) as intUD, 
       sum(intReturned) as intReturned
  from datamart.qp_comments.dbo.respratecount rrc, 
       #sampleset ss
 where rrc.survey_id = ss.survey_id
   and rrc.sampleset_id=ss.SampleSet_id 
 group by sampleunit_id
 
 
update su
   set su.intSampled=r.intSampled, 
       su.intUndel=r.intUndel, 
       su.intReturned=r.intReturned
  from #sampleunits su, 
       #rr r
 where su.sampleunit_id=r.sampleunit_id

-- Sum up the target of all child sample units for each unit
set @SQL=''
select distinct @sql = @sql + '
                 update su
                    set intKidTargets = su.intTarget + sub.target
                   from #sampleunits su, 
                        (
                         select parentSampleunit_id, 
                                sum(case when intKidTargets=0 then intTarget 
                                         else intKidTargets 
                                     end
                                   ) as target 
                           from #sampleunits 
                          where intTier = ' + convert(varchar, intTier) + '
                          group by parentsampleunit_id
                        ) sub
                  where su.sampleunit_id=sub.parentsampleunit_id
                '
  from #sampleunits
 order by 1 desc
 
exec ( @SQL)

-- Delete surveys that have never sampled
delete 
  from #sampleset
 where survey_id in (
                  select survey_id 
                    from #sampleunits 
                   group by survey_id 
                  having isnull(sum(intSampled),0)=0
                 )
 
delete 
  from #sampleunits 
 where survey_id in  (
                  select survey_id 
                    from #sampleunits 
                   group by survey_id 
                  having isnull(sum(intSampled),0)=0
                 )
 
-- Delete sample units that not sampled and has the target of all child sample units of 0
delete
  from #sampleunits 
 where intKidTargets = 0
   and intSampled is null
 
if @PlanDepth>1
begin
     insert into #sampleunits (survey_id, intTreeOrder,intTier) 
     select distinct survey_id,99999999,0 from #sampleunits
 
     insert into #sampleunits (survey_id, strSampleUnit_nm, intTreeOrder,intTier) 
     select distinct css.survey_id,rtrim(strStudy_nm) + ' - ' + rtrim(strSurvey_nm)+' ('+convert(varchar,survey_id)+')', -1, 0 
     from clientstudysurvey_view css
     where css.survey_id in (select survey_id from #sampleunits)
 
     insert into #sampleunits (survey_id, strSampleUnit_nm, intTreeOrder,intTier) 
     select survey_id, isnull('Date Range: '+convert(varchar,datDateRange_FromDate,101)+' - '+convert(varchar,datDateRange_ToDate,101),''), 0, 0 
     from (select p.survey_id, min(datDateRange_FromDate) as datDateRange_FromDate, max(datDateRange_ToDate) as datDateRange_ToDate
     from #sampleset t, sampleset p
     where t.sampleset_id=p.sampleset_id
     and datDateRange_FromDate is not null
     group by p.survey_id) sub
 
     update #sampleunits
     set datLastToDate=datDateRange_ToDate
     from      (select p.survey_id, min(datDateRange_FromDate) as datDateRange_FromDate, max(datDateRange_ToDate) as datDateRange_ToDate
          from #sampleset t, sampleset p
          where t.sampleset_id=p.sampleset_id
          group by p.survey_id) sub
     where #sampleunits.survey_id=sub.survey_id
 
     select strSampleUnit_nm as [Unit Name], /*SampleUnit_id as [Unit ID],*/ null as [ ], intTarget as [Target], intSampled as [# Sampled], 
     intUndel as [# Undeliverable], intReturned as [# Returned], 
     '=TEXT('+convert(varchar,1.0*intReturned/(intSampled-intUndel))+',"0.0%")' as [Response Rate]
     from #SampleUnits
     where intTier <= @PlanDepth
     order by isnull(datLastToDate,dateadd(year,1,getdate())) desc,survey_id,intTreeorder
end

else
begin
     update #sampleunits 
     set strsampleunit_nm=rtrim(strStudy_nm) + ' - ' + strSurvey_nm
     from clientstudysurvey_view css 
     where #sampleunits.survey_id=css.survey_id
 
     select rtrim(su.strSampleUnit_nm)+' ('+convert(varchar,su.survey_id)+')' as [Survey], /*SampleUnit_id as [Unit ID],*/ 
     null as [ ], isnull(convert(varchar,sub.datDateRange_FromDate,101)+' - '+convert(varchar,sub.datDateRange_ToDate,101),'') as [Date Range], su.intSampled as [# Sampled], 
     su.intUndel as [# Undeliverable], su.intReturned as [# Returned], 
     '=TEXT('+convert(varchar,1.0*su.intReturned/(su.intSampled-su.intUndel))+',"0.0%")' as [Response Rate]
     from #SampleUnits su, 
          (select p.survey_id, min(datDateRange_FromDate) as datDateRange_FromDate, max(datDateRange_ToDate) as datDateRange_ToDate
          from #sampleset t, sampleset p
          where t.sampleset_id=p.sampleset_id
          group by p.survey_id) sub
     where su.intTier <= @PlanDepth
     and su.survey_id=sub.survey_id
     order by isnull(datLastToDate,dateadd(year,1,getdate())) desc, su.survey_id,su.intTreeorder
end
 
drop table #css
drop table #cleanperiod
drop table #sampleunits
drop table #rr
drop table #sampleset


