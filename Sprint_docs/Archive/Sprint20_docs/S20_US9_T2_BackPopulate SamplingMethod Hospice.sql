/*
S20 US9 T2 Back populate SamplingMethod_ID's for Hospice (just queueing them up in Catalyst ETL)

As an authorized Hospice CAHPS vendor, we must be able to report the sampling type (census or simple random)	Do this for every survey type	3	9.1	Modify Catalyst ETL to put sampling type into Catalyst
			9.2	Write code to Back populate for Hospice

SELECT TOP 10000 *
  FROM [NRC_DataMart_ETL].[dbo].[ExtractQueue]
  where
  EntityTypeID = 8
*/

use [QP_Prod]

insert into [NRC_DataMart_ETL].[dbo].[ExtractQueue]
(EntityTypeID, PKey1, PKey2, IsMetaData, ExtractFileID, isDeleted, Created, Source)
select 8, SampleSet_id, null, 1, -1, 0, GetDate(), 'SamplingMethodId back-populate Hospice CAHPS'
from Sampleset where surveytype_id = 11