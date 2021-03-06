USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_SamplePlan_Has_Consistent_CCNs]    Script Date: 1/12/2016 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_SamplePlan_Has_Consistent_CCNs]
@survey_id int
as
select sp.Survey_id, sd.SurveyType_id, su.SampleUnit_id
	, su.ParentSampleUnit_id, convert(varchar(100),su.strSampleUnit_nm) as strSampleUnit_nm, su.SUFacility_id, suf.MedicareNumber, su.CAHPSType_id, 0 as Tier, -1 as CCNMatch
	, convert(varchar(50),null) as TierSort
into #su
from sampleunit su
inner join sampleplan sp on su.sampleplan_id=sp.sampleplan_id
inner join survey_def sd on sp.survey_id=sd.survey_id
left join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
where sd.survey_id = @survey_id
--and dbo.SurveyProperty ('FacilitiesArePracticeSites', null, @survey_id) <> '1' CHG0032324 CJB 1/12/2015
and sd.surveytype_id <> 4 --CGCAHPS was being excluded via the SurveyProperty above but will not be with CHG0032332 CJB 1/14/2016

update #su set Tier=1, TierSort=Sampleunit_id where parentsampleunit_id is null

while @@rowcount>0
	update child
	set Tier=parent.Tier+1
		, CCNMatch = case when parent.MedicareNumber is NULL or isnull(parent.MedicareNumber,-1) = isnull(child.MedicareNumber,-1) then 1 else 0 end
		, TierSort=parent.TierSort+'.'+convert(varchar,child.sampleunit_id)
		--, strSampleUnit_nm=replicate('  ',parent.Tier)+strSampleUnit_nm
	from #su child
	inner join (select sampleunit_id, SUFacility_id, MedicareNumber, Tier, TierSort from #su where tier>0) parent
		on child.parentsampleunit_id=parent.sampleunit_id
	where child.tier=0

if exists (select * from #su where CCNMatch=0)
	select 1 error, left('CCN consistentcy error: "'+strsampleunit_nm+'" is assigned to a different CCN than its parent.',200) strMessage from #su where ccnmatch=0 order by TierSort
else 
	select 0 error, 'Sample Plan has consistent CCN assignments' strMessage 

drop table #su
