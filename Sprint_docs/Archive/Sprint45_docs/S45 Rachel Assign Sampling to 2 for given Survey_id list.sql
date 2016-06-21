/*
S45 Rachel Assign Sampling to 2 for given Survey_id list.sql

This was an ad hoc request needed for CGCahps submission files.
 
Chris Burkholder
*/

update ps set Sampling = 2
--select * 
from practicesite ps where practicesite_id in
(select distinct SUFacility_id from sampleunit where /*bitMNCM = 1 and */ SUFacility_id <> 0 and sampleplan_id in 
(select sampleplan_id from sampleplan where
survey_id in
(18213,
18214,
18001,
16683,
16684,
16686,
16687,
16688,
16690,
18006,
16692,
16693,
18282,
18283,
16694,
16729,
16730,
16731,
16732,
16769,
16771,
16772,
16773,
16775,
16776,
16777,
18215,
18225,
18226,
18227,
18228,
18229,
18230,
18231,
18233,
18235,
18236,
18237,
18238,
18239,
18240,
18241,
18242,
18243,
18244,
18245,
18254,
18255,
18256,
18257,
18258,
18259,
18261,
18262,
18191,
18192,
18572,
16778,
16779,
16781,
16782,
16783,
18264,
18265,
18296,
18297,
16784,
16796,
16040,
16041,
17054)
)
)