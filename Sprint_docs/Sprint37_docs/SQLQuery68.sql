
use qp_prod

SELECT *
from dbo.SuFacility sf
where sf.medicareNumber in (
'261644',
'141613'
)

select *
from [dbo].[SAMPLEUNIT] su
where SUFacility_id in (8856,8915)

select *
from [dbo].[SAMPLEPLAN] sp
where sampleplan_id in ( 14963,14887 )

select *
from [dbo].[SAMPLESET] ss
where survey_id in (17518, 17586)

select *
from [dbo].[SAMPLEDATASET] sds
where sds.SAMPLESET_ID in (
1429788,
1457189,
1463562,
1466377,
1485356,
1504230,
1519880,
1538858,
1443236,
1533105
)


select *
from [dbo].[DATA_SET] ds
left join [dbo].[DATASETMEMBER] dsm on dsm.dataset_id = ds.dataset_id
where ds.dataset_id in (
344646,
344648,
347847,
351162,
351321,
351162,
352824,
353650,
358613,
358614,
363521,
363522,
367537,
367538,
371014,
372418,
372419
)



select *
from [dbo].[DATASETMEMBER] dsm
where dsm.DATASET_ID = 358613