
select *
from NRC_DataMart_ETL.dbo.SampleSetTemp

select *
from NRC_DataMart_ETL.dbo.SamplePopTemp

select *
from NRC_DataMart_ETL.dbo.SampleUnitTemp
order by ExtractFileID desc

select *
from NRC_DataMart_ETL.dbo.SelectedSampleTemp

select *
from NRC_DataMart_ETL.dbo.QuestionFormTemp


select *
from NRC_DataMart_ETL.dbo.ExtractQueue
where Created > '2015-10-03 22:54:36.000'
and EntityTypeID = 8
order by Pkey1