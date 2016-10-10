
use NRC_DataMart_Extracts

DECLARE @ExportQueueID int = 67

CREATE TABLE #MissingDODCounts (                                  
   [provider-id] VARCHAR(10),
   [Study_id] int,
   [DataSet_id] int,  
   [yr] varchar(4),
   [mo] varchar(2),                                   
   [MissingCount] int                            
)   

declare @study_id int
declare @sql varchar(8000)

--select eds.[hospicedata.provider-id] as provider_id, dsk.DataSourceKey as SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
--       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
--INTO #SampleSets1
--from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
--inner join NRC_DataMart_Extracts.CEM.ExportQueue  eq on eq.ExportQueueId = eds.ExportQueueId
--inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
--inner join NRC_DataMart.dbo.SampleSet ss on sp.SampleSetID = ss.SampleSetID
--inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID 
--inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.SampleSet_ID = dsk.DataSourceKey
--inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
--inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
--WHERE dsk.EntityTypeID = 8
--and eq.ExportQueueID = @ExportQueueID
--and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate] -- not sure we need this
----GROUP BY eds.[hospicedata.provider-id], dsk.DataSourceKey, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
----, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]
--UNION
--select eds.[hospicedata.provider-id] as provider_id, qpss.SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
--       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
--from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
--inner join NRC_DataMart_Extracts.CEM.ExportQueue  eq on eq.ExportQueueId = eds.ExportQueueId
--inner join Qualisys.qp_prod.dbo.SuFacility suf on suf.medicarenumber = eds.[hospicedata.provider-id]
--inner join Qualisys.qp_prod.dbo.SampleUnit qpsu on qpsu.SUFacility_id = suf.SUFacility_id
--inner join Qualisys.qp_prod.dbo.SamplePlan qpsp on qpsp.SamplePlan_id = qpsu.SamplePlan_id
--inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.Survey_id = qpsp.Survey_id
--inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
--inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
--WHERE eq.ExportQueueID = @ExportQueueID
----and qpss.[datDateRange_FromDate] between eq.[ExportDateStart] and eq.[ExportDateEnd]
----AND qpss.[datDateRange_ToDate] between eq.[ExportDateStart] and eq.[ExportDateEnd]
--and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate]
--GROUP BY eds.[hospicedata.provider-id], qpss.SampleSet_Id, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
--, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]

--SELECT * from #SampleSets1
--order by [provider_id],yr,mo, study_id, SampleSet_ID, dataset_id

--drop table #SampleSets1


select eds.[hospicedata.provider-id] as provider_id, qpss.SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
	   INTO #SampleSets
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000007] eds
left join NRC_DataMart_Extracts.CEM.ExportQueue  eq on eq.ExportQueueId = eds.ExportQueueId
left join Qualisys.qp_prod.dbo.SuFacility suf on suf.medicarenumber = eds.[hospicedata.provider-id]
left join Qualisys.qp_prod.dbo.SampleUnit qpsu on qpsu.SUFacility_id = suf.SUFacility_id
left join Qualisys.qp_prod.dbo.SamplePlan qpsp on qpsp.SamplePlan_id = qpsu.SamplePlan_id
left join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.Survey_id = qpsp.Survey_id
left join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
left join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
WHERE eq.ExportQueueID = @ExportQueueID
and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate]
GROUP BY eds.[hospicedata.provider-id], qpss.SampleSet_Id, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]

SELECT * from #SampleSets
order by [provider_id],yr,mo, study_id, SampleSet_ID, dataset_id

--select top 1 @study_id = study_id 
--from #SampleSets

--while @@rowcount>0
--begin
      
--       SET @sql = 'INSERT INTO #MissingDODCounts
--       SELECT enc.ccn,' + CAST(@study_id as varchar) + ',dm.dataset_id,ss.yr,ss.mo, count(*)
--       FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
--       inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.pop_ID = enc.pop_id and dm.ENC_ID = enc.enc_id
--       inner join #samplesets ss on dm.dataset_id=ss.dataset_id and enc.ccn=ss.provider_id
--       where ss.study_id=' + CAST(@study_id as varchar) + ' and enc.ServiceDate is null
--       group by enc.ccn,dm.dataset_id,ss.yr,ss.mo'

--       print @sql
--       exec (@Sql)

--       delete from #SampleSets where study_id = @study_id
--      select top 1 @study_id = study_id 
--		from #SampleSets
--end

--select * from #MissingDODCounts 
--order by [provider-id],yr,mo

----update eds
----       SET [hospicedata.missing-dod] = mdc.MissingCount
----       FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
----       inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
----					from #MissingDODCounts
----					group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]


--SELECT 
--      [hospicedata.provider-id]
--	  ,[hospicedata.reference-yr]
--      ,[hospicedata.reference-month]
--      --,[hospicedata.missing-dod]
--	  ,missingcount
--FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000007] eds
--inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
--			from #MissingDODCounts
--			group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]
--group by [hospicedata.provider-id]
--	  ,[hospicedata.reference-yr]
--      ,[hospicedata.reference-month]
--      --,[hospicedata.missing-dod]
--	  ,missingcount


drop table #SampleSets
drop table #MissingDODCounts

/*
select *
from Qualisys.Qp_prod.S5019.Encounter
where ccn = '451711'
where servicedate is null

select *
from Qualisys.Qp_prod.S5019.Population
where pop_id = 25


select *
from Qualisys.[QP_Prod].[dbo].[DATASETMEMBER]
where pop_id = 25 and enc_id = 25

select *
from Qualisys.[QP_Prod].[dbo].[DATA_SET]
where study_id = 5016
and dataset_id in (
	select dataset_id
	from Qualisys.[QP_Prod].[dbo].[DATASETMEMBER]
	where pop_id = 25 and enc_id = 25
)

--CCN: 451711

*/