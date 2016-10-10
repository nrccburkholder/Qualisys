
use NRC_DataMart_Extracts

select eds.[hospicedata.provider-id] as provider_id, qpss.SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
INTO #SampleSets
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000007] eds
inner join NRC_DataMart_Extracts.CEM.ExportQueue  eq on eq.ExportQueueId = eds.ExportQueueId
inner join Qualisys.qp_prod.dbo.SuFacility suf on suf.medicarenumber = eds.[hospicedata.provider-id]
inner join Qualisys.qp_prod.dbo.SampleUnit qpsu on qpsu.SUFacility_id = suf.SUFacility_id
inner join Qualisys.qp_prod.dbo.SamplePlan qpsp on qpsp.SamplePlan_id = qpsu.SamplePlan_id
inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.Survey_id = qpsp.Survey_id
inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
WHERE eds.SamplePopulationID is null
--and qpss.[datDateRange_FromDate] between eq.[ExportDateStart] and eq.[ExportDateEnd]
--AND qpss.[datDateRange_ToDate] between eq.[ExportDateStart] and eq.[ExportDateEnd]
and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate]
GROUP BY eds.[hospicedata.provider-id], qpss.SampleSet_Id, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]


select * 
from #SampleSets

declare @sql varchar(8000)


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



	SET @sql = 'INSERT INTO #MissingDODCounts
       SELECT enc.ccn,' + CAST(@study_id as varchar) + ',dm.dataset_id,ss.yr,ss.mo, count(*)
       FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
       inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.pop_ID = enc.pop_id and dm.ENC_ID = enc.enc_id
       inner join #samplesets ss on dm.dataset_id=ss.dataset_id and enc.ccn=ss.provider_id 
       where ss.study_id=' + CAST(@study_id as varchar) + ' and enc.ServiceDate is null ' +
       'group by enc.ccn,dm.dataset_id,ss.yr,ss.mo' +
	   ''

	   print @sql

	exec (@Sql)

	delete from #SampleSets where study_id = @study_id 
	select top 1 @study_id = study_id 
	from #SampleSets
end

select * from #MissingDODCounts

/*
update eds
       SET [hospicedata.missing-dod] = mdc.MissingCount
       FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
       inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
					from #MissingDODCounts
					group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]
*/

SELECT *
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000007] eds
       inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
					from #MissingDODCounts
					group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]


drop table #SampleSets
drop table #MissingDODCounts


/*
select *
from qualisys.qp_prod.S5091.Encounter
where servicedate is null

*/
--where servicedate between '04/01/2015' and '06/30/2015'
/*
select *
from qualisys.qp_prod.S5069.Encounter
where servicedate is null

*/
--where servicedate between '04/01/2015' and '06/30/2015'
------and enc_id in (181,182)