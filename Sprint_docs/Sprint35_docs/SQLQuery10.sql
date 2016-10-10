

use NRC_Datamart


select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey = '3305'
and dsk.EntityTypeID = 1

--study
select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey = '5268'
and dsk.EntityTypeID = 15

--survey
select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey = '18225'
and dsk.EntityTypeID = 3


-- sample set
select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey in (
1534675,
1534676,
1534677,
1534680
)
and dsk.EntityTypeID = 8

-- sample unit
select *
from [ETL].[DataSourceKey] dsk
where dsk.DataSourceKey in ( 
252059,
252060,
252061,
252062
)
and dsk.EntityTypeID = 6

select *
from [ETL].[DataSourceKey] dsk
where dsk.EntityTypeID = 7
and dsk.datasourcekey in (

123061482,
123061491,
123061494,
123061501,
123061483,
123061497,
123061500,
123061496,
123061492,
123061489,
123061493,
123061487,
123061495,
123061498,
123061488,
123061485,
123061486,
123061484,
123061499,
123061490,
123061505,
123061508,
123061506,
123061515,
123061523,
123061502,
123061509,
123061517,
123061503,
123061512,
123061514,
123061521,
123061510,
123061518,
123061519,
123061516,
123061522,
123061504,
123061520,
123061507,
123061511,
123061513,
123061531,
123061525,
123061533,
123061527,
123061530,
123061524,
123061529,
123061528,
123061526,
123061532
)


select *
from LOAD_TABLES.SampleUnitBySampleSet
where SAMPLESET_ID in (
1516623,
1516624,
1516622
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

