
use NRC_Datamart_Extracts


select eds.[hospicedata.provider-id] as provider_id, dsk.DataSourceKey as SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate], eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]
INTO #SampleSets
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000007] eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_DataMart.dbo.SampleSet ss on sp.SampleSetID = ss.SampleSetID
inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID 
inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.SampleSet_ID = dsk.DataSourceKey
inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
WHERE dsk.EntityTypeID = 8
and CAST(CAST(eds.[hospicedata.reference-yr] AS varchar) + '-' + CAST(eds.[hospicedata.reference-month] AS varchar) + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate]
GROUP BY eds.[hospicedata.provider-id], dsk.DataSourceKey, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate], eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]

select * from #SampleSets

CREATE TABLE #MissingDODCounts (                                  
   [provider-id] VARCHAR(10),
   [Study_id] int,
   [DataSet_id] int,                                  
   [MissingCount] int                                 
)   

declare @study_id int, @dataset_id int, @provider_id varchar(10)

select top 1 @study_id = study_id, @dataset_id = dataset_id, @provider_id = provider_id from #SampleSets
while @@rowcount>0
begin

	declare @sql varchar(8000)

	SET @sql = 'INSERT INTO #MissingDODCounts
	SELECT ''' + @provider_id + ''',' + CAST(@study_id as varchar) + ',' + CAST(@dataset_id as varchar) + ', count(*)
	FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
	inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.ENC_ID = enc.enc_id
	 where dm.DATASET_ID = ' + CAST(@dataset_id as varchar) +
	' and enc.CCN = ''' + @provider_id + ''' and enc.ServiceDate is null'

	print @sql

	exec (@Sql)

	delete from #SampleSets where study_id = @study_id and dataset_id = @dataset_id and provider_id = @provider_id
	select top 1 @study_id = study_id, @dataset_id = dataset_id, @provider_id = provider_id from #SampleSets
end

select *
from #MissingDODCounts
order by Study_id, DataSet_id

drop table #SampleSets
drop table #MissingDODCounts



