-- =============================================
-- Author:  <Dana Petersen>
-- Create date: <11/23/2011>
-- Description: <Data source for HCAHPS Targets-Returns By Date Range report>
--
-- Modified:
-- 06/15/2012 DRM  Added StartDate, CensusSampling, AnnualVolume, CalcType, and ability to run by CCN or Facility.
-- 06/20/2012 TS   Added additional clause to where statement to get MedicareNumber by comma sep list of @CCN from SSRS
-- 06/21/2012 TS   Added ISNULL to NumReturns
-- 07/25/2012 DRM  Changed counts to reflect number of hcahps completes rather than total returns.
-- 08/02/2012 DRM  Changed completeness to pull from dipositionlog rather than calling completeness function.
-- 09/11/2012 DBG  Changed the determination of CensusSampling from MedicareRecalc_History.ProportionCalcPct to MedicareRecalc_History.censusForced
-- 09/12/2012 DBG  When populating #CompletedSamplepops, join in SelectedSample and SampleUnit so we can filter out non-HCAHPS returns
-- 01/29/2013 TS   Added join to SUFacility in #CompletedSamplepops.  Same SampleSet in a survey can contain multiple MPN.  
-- 07/16/2013 TS   Added 'and ss.strunitselecttype = 'D' ' to #CompletedSamplepops
-- =============================================
CREATE PROCEDURE [dbo].[SP_SSRS_HCAHPSTargetsReturnsByDateRange]
@minEncDt date,
@maxEncDt date,
@CCN varchar(8000) = null,
--@RemoveCensusCCNs bit = 0,
@indebug char(1) = 0

AS
BEGIN

SET NOCOUNT ON;

--DECLARE @minEncDt date, @maxEncDt date, @CCN varchar(15), @indebug char(1)
--SET @minEncDt = '4/1/2009'
--SET @maxEncDt ='09/30/2012'
--SET  @CCN = '100090'
--SET @indebug = 1

--get survey ids and sampleset info for all HCAHPS surveys that sampled within the period
create table #surveyssamplesets(survey_id int, sampleset_id int, datsamplecreate_dt datetime
      ,datdaterange_fromdate date, datdaterange_todate date)

insert into #surveyssamplesets
select sd.SURVEY_ID, sst.SAMPLESET_ID, sst.datsamplecreate_dt, datdaterange_fromdate, datdaterange_todate
from SAMPLESET sst, SURVEY_DEF sd
where sst.SURVEY_ID = sd.SURVEY_ID
and sd.SurveyType_id = 2
and sst.datDateRange_FromDate between @minEncDt and @maxEncDt


--get associated CCNs for all surveys
create table #surveyCCN (survey_id int, medicarenumber varchar(15), strfacilityname varchar(100), medicarename varchar(100))

insert into #surveyCCN
--select distinct tsss.survey_id, suf.MedicareNumber, suf.strFacility_nm, ml.MedicareName
select distinct tsss.survey_id, suf.MedicareNumber, ml.MedicareName, ml.MedicareName
from #surveyssamplesets tsss, SAMPLEPLAN spl, SAMPLEUNIT su, SUFacility suf, MedicareLookup ml
where tsss.survey_id = spl.SURVEY_ID
and spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
and su.SUFacility_id = suf.SUFacility_id
and suf.MedicareNumber = ml.MedicareNumber
AND ml.MedicareNumber IN (SELECT items FROM dbo.Split (@CCN,','))

--if @ccn is not null delete #surveyccn where medicarenumber <> @ccn
--if @facilityname is not null delete #surveyccn where strfacilityname <> @facilityname

--get target info for each CCN
create table #CCNTargets (medicarerecalclog_id int, /*dg*/ survey_id int, /*dg*/ medicarenumber varchar(15), AnnualReturnTarget int, DateCalculated datetime,
      PropSampleCalcDate date, QtrEndDate date, CensusSampling char(1), CalcType char(1), AnnualVolume int) --**  add censussampling, calctype, annualvolume

insert into #CCNTargets    
select mrh.medicarerecalclog_id, /*dg*/tsc.survey_id, /*dg*/ tsc.medicarenumber, mrh.AnnualReturnTarget, mrh.datecalculated, mrh.PropSampleCalcDate
      ,DATEADD(day,-1, DATEADD(month,3,mrh.PropSampleCalcDate))
      --,ProportionCalcPct
      ,case when censusForced = 1 then 'C' else '' end as CensusSampling  --**  add censussampling
      --,medicarepropcalctype_id
      ,case when medicarepropcalctype_id = 1 then 'E' when medicarepropcalctype_id = 2 then 'H' else '' end as CalcType  --**  add calctype
      ,EstAnnualVolume
from #surveyCCN tsc, MedicareRecalc_History mrh 
where tsc.medicarenumber = mrh.MedicareNumber
and mrh.PropSampleCalcDate between @minEncDt and @maxEncDt


--Put together the info for the samplesets by CCN
create table #CCNSamplesets (survey_id int, medicarenumber varchar(15), sampleset_id int, datdaterange_fromdate date
      , datdaterange_todate date, datsamplecreate_dt datetime, daterangequarter int, daterangeyear int, numTarget int
      , CensusSampling char(1), CalcType char(1), AnnualVolume int) --**  add censussampling, calctype, annualvolume

insert into #CCNSamplesets (survey_id, medicarenumber, sampleset_id, datdaterange_fromdate, datdaterange_todate
      , datsamplecreate_dt, daterangequarter, daterangeyear)
select distinct tsss.survey_id, tcn.medicarenumber, tsss.sampleset_id, tsss.datdaterange_fromdate, tsss.datdaterange_todate   --** add distinct
      , tsss.datsamplecreate_dt, DATEPART(quarter,tsss.datdaterange_fromdate), DATEPART(YYYY,tsss.datdaterange_fromdate)
from #surveyssamplesets tsss, #surveyCCN tcn
where tsss.survey_id = tcn.survey_id


--Get startdate
select survey_id, medicarenumber, max(datdaterange_fromdate) startdate
into #tmp_startdates from
      (select medicarenumber, survey_id, min(datdaterange_fromdate) datdaterange_fromdate
      from #ccnsamplesets
      group by medicarenumber, survey_id) a
group by survey_id, medicarenumber

--Update with target in effect at the time each sampleset was pulled
create table #targetsforloop (survey_id int, medicarenumber varchar(15), propsamplecalcdate date, qtrenddate date, datecalculated datetime
      , annualreturntarget int, medicarerecalclog_id int
      , CensusSampling char(1), CalcType char(1), AnnualVolume int) --**  add censussampling, calctype, annualvolume

insert into #targetsforloop
select survey_id, medicarenumber, propsamplecalcdate, qtrenddate, datecalculated, AnnualReturnTarget, medicarerecalclog_id
      ,CensusSampling, CalcType, AnnualVolume
from #CCNTargets
order by medicarenumber, propsamplecalcdate, datecalculated

declare @survey_id int, @recalcid int
select top 1 @survey_id=survey_id, @recalcid = medicarerecalclog_id from #targetsforloop
while @@ROWCOUNT > 0
begin
      update #CCNSamplesets
      set numTarget = ttl.annualreturntarget
            ,censussampling = ttl.censussampling, calctype = ttl.calctype, annualvolume = ttl.annualvolume
      from #targetsforloop ttl
      where ttl.survey_id = #CCNSamplesets.survey_id
      and ttl.medicarenumber = #CCNSamplesets.medicarenumber
      and #CCNSamplesets.datdaterange_fromdate between ttl.propsamplecalcdate and ttl.qtrenddate
      and dateadd(m,10,#CCNSamplesets.datsamplecreate_dt) >= ttl.datecalculated
      and ttl.medicarerecalclog_id = @recalcid
      and ttl.survey_id = @survey_id

      delete from #targetsforloop where medicarerecalclog_id = @recalcid and survey_id = @survey_id
      select top 1 @survey_id=survey_id, @recalcid = medicarerecalclog_id from #targetsforloop
      continue
end

--Get completed (hcahps complete) return counts
-- TS.  Added MedicareNumber.  Added join to SUFacility
create table #SamplesetReturns (sampleset_id int, medicarenumber varchar(10), numReturns int)
create table #CompletedSamplepops (sampleset_id int, samplepop_id int, medicarenumber varchar(10), sampleunit_id int)

insert into #CompletedSamplepops
select distinct sp.sampleset_id, dl.samplepop_id, suf.medicarenumber, su.sampleunit_id
from DispositionLog dl 
      inner join SAMPLEPOP sp on dl.SamplePop_id = sp.SAMPLEPOP_ID
      inner join selectedSample ss on ss.pop_id=sp.pop_id and ss.sampleset_id=sp.sampleset_id
      inner join sampleunit su on ss.sampleunit_id=su.sampleunit_id
      inner join #CCNSamplesets c on c.sampleset_id = sp.SAMPLESET_ID
      INNER JOIN SUFacility suf ON su.SUFacility_id = suf.SUFacility_id
where dl.Disposition_id = 13
and dl.DaysFromFirst<=42
and su.bitHCahps=1
and ss.strunitselecttype = 'D'
order by SAMPLEPOP_ID



/*
insert into #SamplesetReturns
select tsss.sampleset_id, sum(cast(dbo.hcahpscompleteness(qf.questionform_id)as int))
from #surveyssamplesets tsss, SAMPLEPOP sp, QUESTIONFORM qf
where tsss.sampleset_id = sp.SAMPLESET_ID
and sp.SAMPLEPOP_ID = qf.SAMPLEPOP_ID
and qf.DATRETURNED is not null
group by tsss.sampleset_id
*/


-- TS.  Added MedicareNumber
insert into #SamplesetReturns
select sampleset_id, medicarenumber, count(samplepop_id)
from #CompletedSamplepops
group by sampleset_id, medicarenumber


--Put it all together!
--TS.  Added Join to #SampleSetReturns by MedicareNumber
select tcss.medicarenumber, tsc.strfacilityname, tcss.daterangequarter, tcss.daterangeyear, tcss.numTarget
      ,ISNULL(SUM(tssr.numreturns),0) as "numReturns"
      ,MIN(tcss.datdaterange_fromdate) as "minEncDt", MAX(tcss.datdaterange_todate) as "maxEncDt"
      ,min(tsd.startdate) StartDate, min(censussampling) CensusSampling, min(calctype) CalcType, min(annualvolume) AnnualVolume
--into #tmp_results


--select tcss.medicarenumber, tsc.strfacilityname, tcss.daterangequarter, tcss.daterangeyear, tcss.sampleset_id, tcss.numTarget
--    ,tssr.numreturns as "numReturns"
--    ,tcss.datdaterange_fromdate, tcss.datdaterange_todate
--    ,tsd.startdate, censussampling, calctype, annualvolume      
      
from #surveyCCN tsc
      join #CCNSamplesets tcss on tsc.medicarenumber = tcss.medicarenumber /*dg*/and tsc.survey_id=tcss.survey_id/*dg*/
      left outer join #SamplesetReturns tssr on tcss.sampleset_id = tssr.sampleset_id
      											 AND tcss.medicarenumber = tssr.medicarenumber	
      left join #tmp_startdates tsd on tsd.medicarenumber = tcss.medicarenumber and tsd.survey_id=tcss.survey_id
                                          --order by 1,4,3,7
group by tcss.medicarenumber, tsc.strfacilityname, tcss.daterangequarter, tcss.daterangeyear, tcss.numTarget
order by tcss.medicarenumber, tcss.daterangeyear, tcss.daterangequarter, MIN(tcss.datdaterange_fromdate)

--if @RemoveCensusCCNs=1
--begin
--    --Get list of most recent samples by CCN.
--    select medicarenumber, max(maxencdt)
--    into #tmpCensusCCNs
--    from #tmp_results
--    group by medicarenumber

--    --If the most recent CCN was Census sampled, then remove the CCN from the final result list.
--    delete #tmp_results where medicarenumber in
--    (select t1.medicarenumber
--    from #tmp_results t1 inner join #tmpCensusCCNs t2
--    on t1.medicarenumber = t2.medicare
--    where t1.CensusSampling = 'C')
--end

--select * from #tmp_results

--Cleanup
if @indebug = 0  --leave the tables for troubleshooting if in debug mode
begin
      drop table #surveyssamplesets
      drop table #surveyCCN
      drop table #CCNTargets
      drop table #CCNSamplesets
      drop table #targetsforloop
      drop table #SamplesetReturns
      drop table #tmp_startdates
      drop table #CompletedSamplepops
      --drop table #tmp_results
end    
    
    
END


