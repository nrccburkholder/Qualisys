
use NRC_DataMart_Extracts

	select distinct datasourcekey
	from NRC_DataMart.ETL.DataSourceKey dsk
	where dsk.datasourcekeyid in (
		--select samplepopulationid 
		--from cem.ExportDataset00000007
		--where [hospicedata.survey-mode] = 1 -- 1	Mail Only
		--and [decedentleveldata.number-survey-attempts-mail]=88
		--union
		select samplepopulationid
		from cem.ExportDataset00000007
		where [hospicedata.survey-mode] = 2 --2	Telephone Only
		and [decedentleveldata.number-survey-attempts-telephone] =88 
	)
	and dsk.EntityTypeID = 7



select samplepopulationid 
from cem.ExportDataset00000007
where [hospicedata.survey-mode] = 1 -- 1	Mail Only
and [decedentleveldata.number-survey-attempts-mail]=88

select samplepopulationid 
from cem.ExportDataset00000007
where [hospicedata.survey-mode] = 2 --2	Telephone Only
and [decedentleveldata.number-survey-attempts-telephone] =88 


