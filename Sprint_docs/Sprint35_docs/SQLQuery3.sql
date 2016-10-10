use NRC_DataMart_ETL

select top 1000 *
from ExtractQueue
where extractfileid is null
--and pkey1 = 1534675
order by created desc




select *
from NRC_DataMart_ETL.dbo.SamplesetTemp
where sampleset_id in (
1534680

)


select *, ',' + cast(samplepop_id as varchar)
from NRC_DataMart_ETL.dbo.SamplepopTemp
where sampleset_id in (
1534680
)


select *
from NRC_DataMart_ETL.dbo.samplepoptemp
where samplepop_id = 123061524

select *
from NRC_DataMart_ETL.[dbo].[QuestionFormTemp]
where samplepop_id in (

	select samplepop_id
	from NRC_DataMart_ETL.dbo.SamplepopTemp
	where sampleset_id in (
	1534680
	)
)