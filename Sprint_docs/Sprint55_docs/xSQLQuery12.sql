
use qp_prod

select top 1000  *
from dbo.DRGDebugLogging
--group by Study_ID, DataFile_ID
--where study_id = 4878 and DataFile_ID = 2930
order by DateStamp desc




select Study_id
, DataFile_ID
, SUBSTRING([Message],1,CHARINDEX('DRG:',[Message]) + 2)
,CAST(SUBSTRING([Message],CHARINDEX('Records With Updates:',[Message]) + 21,4) as int)
from dbo.DRGDebugLogging
where CHARINDEX('DRG:',[Message]) > 0
and CHARINDEX('Records With Updates:',[Message]) > 0
and CAST(SUBSTRING([Message],CHARINDEX('Records With Updates:',[Message]) + 21,4) as int) > 0
and DateStamp > '2016-07-01'
group by Study_ID
, DataFile_ID
, SUBSTRING([Message],1,CHARINDEX('DRG:',[Message]) + 2),
CAST(SUBSTRING([Message],CHARINDEX('Records With Updates:',[Message]) + 21,4) as int)
order by DataFile_ID