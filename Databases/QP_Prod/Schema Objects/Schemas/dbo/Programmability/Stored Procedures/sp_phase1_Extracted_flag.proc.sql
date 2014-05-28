CREATE PROCEDURE sp_phase1_Extracted_flag AS
/*
update selectedsample set intextracted_flg = 1 
where strunitselecttype = 'D'
*/
declare @LastSampleSet int
select @LastSampleSet=max(SampleSet_ID) from SampleSet

insert into ReportingHierarchy (Survey_ID, Study_ID, intTier, Reporting_Level_nm)
  select sd.Survey_ID, sd.Study_ID, 1, 'Level 1'
  from SampleUnit su, SamplePlan sp, Survey_Def sd
  where su.ParentSampleUnit_ID is null
    and su.Reporting_Hierarchy_ID is null
    and su.SamplePlan_ID=sp.SamplePlan_ID
    and sp.Survey_ID=sd.Survey_ID

if @@rowcount > 0 
begin
  update su
  set Reporting_Hierarchy_ID=rh.Reporting_Hierarchy_ID
  from ReportingHierarchy rh, SampleUnit su, SamplePlan sp, Survey_Def sd
  where su.ParentSampleUnit_ID is null
    and su.Reporting_Hierarchy_ID is null
    and su.SamplePlan_ID=sp.SamplePlan_ID
    and sp.Survey_ID=sd.Survey_ID
    and sd.Survey_ID=rh.Survey_ID
end

select top 1 * from SampleUnit where Reporting_Hierarchy_ID is null
while @@rowcount > 0 
begin
  update suc
  set Reporting_Hierarchy_ID=rhc.Reporting_Hierarchy_ID
  from SampleUnit suc, SampleUnit sup, ReportingHierarchy rhp, ReportingHierarchy rhc
  where suc.Reporting_Hierarchy_ID is null
    and suc.ParentSampleUnit_ID=sup.SampleUnit_ID
    and sup.Reporting_Hierarchy_ID=rhp.Reporting_Hierarchy_ID
    and rhp.Reporting_Hierarchy_ID=rhc.Prnt_Reporting_Hierarchy_ID

  insert into ReportingHierarchy (Survey_ID,Study_ID,intTier,Reporting_Level_nm,Prnt_Reporting_Hierarchy_ID)
  select distinct rhp.Survey_ID,rhp.Study_ID,rhp.intTier+1 as intTier,'Level '+convert(varchar,rhp.intTier+1) as Reporting_Level_nm,rhp.Reporting_Hierarchy_ID as Prnt_Reporting_Hierarchy_ID
  from SampleUnit suc, SampleUnit sup, ReportingHierarchy rhp
  where suc.Reporting_Hierarchy_ID is null
    and suc.ParentSampleUnit_ID=sup.SampleUnit_ID
    and sup.Reporting_Hierarchy_ID=rhp.Reporting_Hierarchy_ID
end

create table #SampleUnitTier (SamplePlan_ID int, SampleUnit_ID int, intTier int)

insert into #SampleUnitTier (SamplePlan_ID, SampleUnit_ID, intTier)
  select su.SamplePlan_ID, su.SampleUnit_ID, rh.intTier
  from SampleUnit su, ReportingHierarchy rh
  where su.Reporting_Hierarchy_ID=rh.Reporting_Hierarchy_ID

select ss.Pop_ID, ss.Study_ID, ss.SampleSet_ID, ss.SampleUnit_ID, SUT.intTier
into #PopTier
from SelectedSample ss, #SampleUnitTier SUT
where ss.SampleUnit_ID=SUT.SampleUnit_ID 
  and ss.strUnitSelectType='D'
  and ss.intExtracted_flg is null
drop table #SampleUnitTier

select PT.Pop_ID, PT.Study_ID, pt.SampleSet_ID, PT.SampleUnit_ID, PT.intTier, convert(float,-1) as RandNum
into #PopMaxTier
from #PopTier PT,
  (select Pop_ID, Study_ID, SampleSet_ID, max(intTier) as maxTier
  from #PopTier
  group by Pop_ID, Study_ID, SampleSet_ID) Sub
where PT.Pop_ID=Sub.Pop_ID
  and PT.Study_ID=Sub.Study_ID
  and PT.SampleSet_ID=Sub.SampleSet_ID
  and PT.intTier=Sub.maxTier
drop table #PopTier

select Pop_ID, pmt.Study_ID, pmt.SampleSet_ID into #Dup from #PopMaxTier pmt, sampleset ss, survey_def sd
where pmt.sampleset_id = ss.sampleset_id
and ss.survey_id = sd.survey_id
--BD 12/14/1 Duplicates are not isolated to dynamic surveys
--and sd.bitdynamic = 0 
group by Pop_ID, pmt.Study_ID, pmt.SampleSet_ID having count(*)>1
create index #Dupindex on #Dup (Pop_ID, Study_ID, SampleSet_ID)
create index #PMTindex on #PopMaxTier (Pop_ID, Study_ID, SampleSet_ID)

DECLARE @Pop_ID int, @Study_ID int, @SampleSet_ID int, @SampleUnit_ID int

SET NOCOUNT ON
DECLARE curPMT CURSOR FOR 
  SELECT PMT.Pop_ID, PMT.Study_ID, PMT.SampleSet_ID, SampleUnit_ID
  FROM #PopMaxTier PMT, #Dup
  WHERE PMT.Pop_ID = #Dup.Pop_ID
    and PMT.Study_ID = #Dup.Study_ID
    and PMT.SampleSet_ID = #Dup.SampleSet_ID
OPEN curPMT
FETCH NEXT FROM curPMT INTO @Pop_ID, @Study_ID, @SampleSet_ID, @SampleUnit_ID
WHILE @@FETCH_STATUS = 0
BEGIN
  update #PopMaxTier set RandNum=rand() where Pop_ID=@Pop_ID and Study_ID=@Study_ID and SampleSet_ID=@SampleSet_ID and SampleUnit_ID=@SampleUnit_ID
  FETCH NEXT FROM curPMT INTO @Pop_ID, @Study_ID, @SampleSet_ID, @SampleUnit_ID

END
CLOSE curPMT
DEALLOCATE curPMT
SET NOCOUNT OFF
drop table #Dup
update PMT
set RandNum=-1
from #PopMaxTier PMT, 
  (select Pop_ID,Study_ID,SampleSet_ID,min(RandNum) as RandNum
  from #PopMaxTier 
  group by Pop_ID,Study_ID,SampleSet_ID) Sub
where PMT.Pop_ID=Sub.Pop_ID
  and PMT.Study_ID=Sub.Study_ID
  and PMT.SampleSet_ID=Sub.SampleSet_ID
  and PMT.RandNum=Sub.RandNum

update ss
set intExtracted_flg=1
from SelectedSample ss, #PopMaxTier PMT
where ss.Pop_ID=pmt.Pop_ID
  and ss.Study_ID=pmt.Study_ID
  and ss.SampleSet_ID=pmt.SampleSet_ID
  and ss.SampleUnit_ID=pmt.SampleUnit_ID
  and pmt.RandNum=-1
drop table #PopMaxTier

update SelectedSample 
set intExtracted_flg=0 
where intExtracted_flg is null
  and SampleSet_ID <= @LastSampleSet


