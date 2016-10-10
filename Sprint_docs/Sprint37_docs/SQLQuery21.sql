
use QP_Prod

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [QP_Prod].[S5268].[ENCOUNTER]
  where ServiceDate is null

  SELECT *
  FROM [QP_Prod].[S5268].[ENCOUNTER]

  select ds.*, dm.*
  from Data_Set ds
  inner join [QP_Prod].[dbo].[DATASETMEMBER] dm on dm.DATASET_ID = ds.DATASET_ID
  where ds.STUDY_ID = 5268


  select dm.DATASET_ID, ss.datDateRange_FromDate, ss.datDateRange_ToDate
  INTO #temp
  FROM [QP_Prod].[S4765].[ENCOUNTER] enc
  inner join [QP_Prod].[dbo].[DATASETMEMBER] dm on dm.ENC_ID = enc.enc_id and dm.POP_ID = enc.pop_id
  inner join [QP_Prod].[dbo].[SampleDataSet] sds on sds.DATASET_ID = dm.DATASET_ID
  inner join [QP_Prod].[dbo].[SAMPLESET] ss on ss.SAMPLESET_ID = sds.SAMPLESET_ID
  where enc.ServiceDate between ss.datDateRange_FromDate and ss.datDateRange_ToDate
  group by dm.DATASET_ID, ss.datDateRange_FromDate, ss.datDateRange_ToDate


  select * from #temp

  select enc.*, dm.DATASET_ID
  FROM [QP_Prod].[S4765].[ENCOUNTER] enc
  inner join [QP_Prod].[dbo].[DATASETMEMBER] dm on dm.ENC_ID = enc.enc_id
  where dm.DATASET_ID in (
	 SELECT DATASET_ID from #temp
  )
  and enc.ServiceDate is null

    select enc.*, dm.DATASET_ID
  FROM [QP_Prod].[S5268].[ENCOUNTER] enc
  inner join [QP_Prod].[dbo].[DATASETMEMBER] dm on dm.ENC_ID = enc.enc_id
  where dm.DATASET_ID in (
	 371422
  )
  and enc.ServiceDate is null

  drop table #temp
