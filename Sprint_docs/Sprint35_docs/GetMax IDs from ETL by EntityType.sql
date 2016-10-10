

use NRC_Datamart

select 'Client',
(select max( cast(dsk.DataSourceKey as int)) 
from NRC_Datamart.[ETL].[DataSourceKey] dsk
where dsk.EntityTypeID = 1 -- client
and dsk.DataSourceID = 1
and CHARINDEX(',',dsk.DataSourceKey) = 0) max_id,
(
select max(client_id)
from Gator.[QP_PROD].[dbo].Client)  max_id_QP_Prod

select 'Study',
(select max( cast(dsk.DataSourceKey as int)) 
from NRC_Datamart.[ETL].[DataSourceKey] dsk
where dsk.EntityTypeID = 15 -- study
and dsk.DataSourceID = 1
and CHARINDEX(',',dsk.DataSourceKey) = 0) max_id,
(
select max(study_id)
from Gator.[QP_PROD].[dbo].study)  max_id_QP_Prod

select 'Survey',
(select max( cast(dsk.DataSourceKey as int)) 
from NRC_Datamart.[ETL].[DataSourceKey] dsk
where dsk.EntityTypeID = 3 -- survey
and dsk.DataSourceID = 1
and CHARINDEX(',',dsk.DataSourceKey) = 0) max_id,
(
select max(survey_id)
from Gator.[QP_PROD].[dbo].survey_def)  max_id_QP_Prod




select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey = 169679485
and dsk.EntityTypeID = 11 -- questionform

select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey = 115890818
and dsk.EntityTypeID = 15  -- study

select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey = 123061524
and dsk.EntityTypeID = 7  -- samplepop

-- sample set
select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKeyID in ( 188393766)
and dsk.EntityTypeID = 8 -- sampleset


select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKeyID in ( 
188393723,
188393724,
188393725,
188393726)
and dsk.EntityTypeID = 6  -- sampleunit

select cast(DataSourceKeyID as varchar) + ',',*
from [ETL].[DataSourceKey] dsk
where dsk.EntityTypeID =8 -- sampleset
and dsk.datasourcekey in (
1534680

)


select *
from LOAD_TABLES.SampleSet
order by DataFileID desc
where ID in (
1534680
)

select *
from dbo.SampleSet with (nolock)
where SampleSetID = 189270852


select *
from LOAD_TABLES.SampleUnitBySampleSet
where SAMPLESET_ID in (
1534680
)

select *
from SampleUnitBySampleSet
where samplesetid in (
188393766
)


USE [NRC_DataMart]
GO

SELECT [SAMPLESETID]
      ,[SAMPLEUNITID]
      ,[NumPatInFile]
      ,[IneligibleCount]
      ,[IsCensus]
  FROM [dbo].[SampleUnitBySampleSet]
GO

