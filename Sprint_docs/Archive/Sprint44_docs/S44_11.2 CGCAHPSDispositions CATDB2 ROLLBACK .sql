/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S44 US11 CG-CAHPS Dispositions 
	As a CG-CAHPS vendor, we need to update the disposition hierarchy to match the new specs, so that we can submit accurate data.

	Task 2 - Update CAHPSTypeDispositions & CAHPSTypeDispositionMapping on Catalyst

	Tim Butler
*/


use NRC_Datamart


--remove current records for CGCAHPS
delete dbo.CahpsDispositionMapping
where CahpsTypeID = 10 


--remove current records for CGCAHPS
delete dbo.CahpsDisposition
where CahpsTypeID = 10 


delete [dbo].[Disposition]
where [Label] = 'Incomplete Survey (no measure question answered)'

delete
from dbo.CahpsType
where CahpsTypeID = 10 



select *
from dbo.Disposition
where [Label] = 'Incomplete Survey (no measure question answered)'


select *
from dbo.CahpsType
where CahpsTypeID = 10

select *
from [dbo].[CahpsDisposition]
where CahpsTypeID = 10

SELECT *
FROM [NRC_Datamart].[dbo].[CahpsDispositionMapping]
where CahpsTypeID = 10
