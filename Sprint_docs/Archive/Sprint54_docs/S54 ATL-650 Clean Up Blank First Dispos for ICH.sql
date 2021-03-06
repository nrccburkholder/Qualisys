/*
	S54 ATL-650	Clean Up Blank First Dispos for ICH

	As Corporate Compliance, we want the incorrect blank first survey dispositions changed to no response dispositions for ICH, so that we have the correct NRC dispositions for audit purposes.

	This will only update those where there was no return, hence no record in disposition log. 

	Tim Butler

*/
use [NRC_DataMart]

SELECT distinct sp.SamplePopulationID
into #samplepops
  FROM [dbo].[SamplePopulation] sp
  inner join dbo.SampleSet ss on ss.SampleSetID = sp.SampleSetID
  inner join dbo.SampleUnitBySampleSet suss on suss.SAMPLESETID = ss.SampleSetID
  inner join dbo.SampleUnit su on su.SampleUnitID = suss.SAMPLEUNITID
  inner join dbo.Survey svy on svy.SurveyID = su.SurveyID
  left join (
	select distinct samplepopulationid 
	  from dbo.SamplePopulationDispositionLog s
	  inner join dbo.CahpsDispositionMapping cdm on cdm.dispositionid = s.dispositionid
	  where cdm.CahpsTypeID = 5
	)spdl on spdl.SamplePopulationID = sp.SamplePopulationID
  where svy.CahpsTypeID = 5
  and sp.DispositionID = 25 --blank first survey
  and spdl.SamplePopulationID is null

begin tran

  Update sp
	SET sp.DispositionID = 12 -- no response after max attempts
  FROM [dbo].[SamplePopulation] sp
  inner join #samplepops spt on spt.SamplePopulationID = sp.SamplePopulationID

commit tran


  
SELECT distinct sp.*
  FROM [dbo].[SamplePopulation] sp
  inner join #samplepops spt on spt.SamplePopulationID = sp.SamplePopulationID


drop table #samplepops

GO