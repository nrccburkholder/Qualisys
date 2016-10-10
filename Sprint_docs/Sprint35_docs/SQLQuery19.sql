

use QP_Prod

SELECT top 100 ss.SAMPLESET_ID, max(sm.datMailed)
from QP_Prod.dbo.SAMPLESET ss with (NOLOCK) 
	INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.SAMPLESET_ID = ss.SAMPLESET_ID
	inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
	inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
	where sm.DATMAILED is not null
	group by ss.SAMPLESET_ID
	order by max(sm.datMailed) desc
