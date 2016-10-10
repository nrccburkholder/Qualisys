
--use NRC_Datamart_Extracts


--select eds.[hospicedata.provider-id] as provider_id, dsk.DataSourceKey as SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate], eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
--INTO #SampleSets
--from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
--inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
--inner join NRC_DataMart.dbo.SampleSet ss on sp.SampleSetID = ss.SampleSetID
--inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID 
--inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.SampleSet_ID = dsk.DataSourceKey
--inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
--inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
--WHERE dsk.EntityTypeID = 8
--and CAST(CAST(eds.[hospicedata.reference-yr] AS varchar) + '-' + CAST(eds.[hospicedata.reference-month] AS varchar) + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate] -- not sure we need this
--GROUP BY eds.[hospicedata.provider-id], dsk.DataSourceKey, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate], eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]

--select * from #SampleSets

--CREATE TABLE #MissingDODCounts (                                  
--   [provider-id] VARCHAR(10),
--   [Study_id] int,
--   [DataSet_id] int,  
--   [yr] varchar(4),
--   [mo] varchar(2),                                   
--   [MissingCount] int
                              
--)   

--declare @study_id int, @dataset_id int, @provider_id varchar(10), @yr varchar(4), @mo varchar(2)

--select top 1 @study_id = study_id, @dataset_id = dataset_id, @provider_id = provider_id, @yr = yr, @mo = mo from #SampleSets
--while @@rowcount>0
--begin

--	declare @sql varchar(8000)

--	SET @sql = 'INSERT INTO #MissingDODCounts
--	SELECT ''' + @provider_id + ''',' + CAST(@study_id as varchar) + ',' + CAST(@dataset_id as varchar) + ',''' + @yr + ''',''' + @mo + ''', count(*)
--	FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
--	inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.ENC_ID = enc.enc_id and dm.pop_id = enc.pop_id
--	 where dm.DATASET_ID = ' + CAST(@dataset_id as varchar) +
--	' and enc.CCN = ''' + @provider_id + 
--	''' and enc.ServiceDate is null'

--	print @sql

--	exec (@Sql)

--	delete from #SampleSets where study_id = @study_id and dataset_id = @dataset_id and provider_id = @provider_id and yr = @yr and mo = @mo
--	select top 1 @study_id = study_id, @dataset_id = dataset_id, @provider_id = provider_id, @yr = yr, @mo = mo from #SampleSets
--end

--select *
--from #MissingDODCounts


--update eds
--	SET [hospicedata.missing-dod] = mdc.MissingCount
--	FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
--	inner join #MissingDODCounts mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]


--select [provider-id],[yr],[mo],sum(missingCount) as MissingDOD
--from #MissingDODCounts
--Group By [provider-id],[yr],[mo]

--drop table #SampleSets
--drop table #MissingDODCounts


go

-- S37_US9 CEM Hospice Missing DOD stuff.sql
use NRC_Datamart_Extracts


select eds.[hospicedata.provider-id] as provider_id, dsk.DataSourceKey as SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
INTO #SampleSets
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_DataMart.dbo.SampleSet ss on sp.SampleSetID = ss.SampleSetID
inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID 
inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.SampleSet_ID = dsk.DataSourceKey
inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
WHERE dsk.EntityTypeID = 8
and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate] -- not sure we need this
GROUP BY eds.[hospicedata.provider-id], dsk.DataSourceKey, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]


CREATE TABLE #MissingDODCounts (                                  
   [provider-id] VARCHAR(10),
   [Study_id] int,
   [DataSet_id] int,  
   [yr] varchar(4),
   [mo] varchar(2),                                   
   [MissingCount] int
                             
)   

declare @study_id int

select top 1 @study_id = study_id
from #SampleSets
while @@rowcount>0
begin

       declare @sql varchar(8000)

       SET @sql = 'INSERT INTO #MissingDODCounts
       SELECT enc.ccn,' + CAST(@study_id as varchar) + ',dm.dataset_id,ss.yr,ss.mo, count(*)
       FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
       inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.pop_ID = enc.pop_id and dm.ENC_ID = enc.enc_id
       inner join #samplesets ss on dm.dataset_id=ss.dataset_id and enc.ccn=ss.provider_id
       where ss.study_id=' + CAST(@study_id as varchar) + ' and enc.ServiceDate is null
       group by enc.ccn,dm.dataset_id,ss.yr,ss.mo'

       print @sql
       exec (@Sql)

       delete from #SampleSets where study_id = @study_id
       select top 1 @study_id = study_id
       from #SampleSets
end



select [provider-id], yr, mo, sum(missingcount) as missingcount
from #MissingDODCounts
group by [provider-id], yr, mo



update eds
       SET [hospicedata.missing-dod] = mdc.MissingCount
       FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
       inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
					from #MissingDODCounts
					group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]

SELECT *
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
       inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
					from #MissingDODCounts
					group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]

drop table #SampleSets
drop table #MissingDODCounts

