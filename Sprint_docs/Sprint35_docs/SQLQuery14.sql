

select *
from LOAD_TABLES.SampleUnitBySampleSet ss
--where isCensus is not null --samplesetid = 188392933
where ss.sampleset_ID in (
		1462528,
		1462708,
		1466184,
		1466347,
		1474064,
		1474358,
		1479052,
		1480143,
		1483251,
		1490333,
		1492477,
		1492569,
		1501620,
		1504222,
		1504283,
		1505909,
		1508022,
		1515947 
		)


select cast(SAMPLESETID as varchar) + ','
from LOAD_TABLES.SampleUnitBySampleSet ss
--where isCensus is not null --samplesetid = 188392933
where ss.sampleset_ID in (
		1462528,
		1462708,
		1466184,
		1466347,
		1474064,
		1474358,
		1479052,
		1480143,
		1483251,
		1490333,
		1492477,
		1492569,
		1501620,
		1504222,
		1504283,
		1505909,
		1508022,
		1515947 
		)
group by SAMPLESETID


select *
from SampleUnitBySampleSet
--where isCensus is not null
where SAMPLESETID in (

182024311,
182024465,
182438021,
182438178,
183145662,
183145784,
183606047,
183731199,
183997510,
184693057,
184867575,
184950849,
185698319,
186008002,
186008061,
186184436,
186468633,
187159071

)