
use qp_prod

select *
from s4765.ENCOUNTER
where ccn = 000111

use qp_prod

select *
from s4765.ENCOUNTER
where ServiceDate is null
and ccn = 000222


SELECT pop.fname, pop.lname, sp.SAMPLEPOP_ID, enc.*, dm.*
	FROM [QP_Prod].[S4765].[ENCOUNTER] enc
	inner join [QP_Prod].[S4765].[POPULATION] pop on pop.pop_id= enc.pop_id 
	left join [QP_Prod].[dbo].SAMPLEPOP sp on sp.POP_ID = pop.pop_id 
	left join [QP_Prod].[dbo].[DATASETMEMBER] dm on dm.ENC_ID = enc.enc_id and dm.POP_ID = enc.pop_id
	where 1 = 1
	--and enc.CCN = '000111' 
	--and dm.DATASET_ID = 290998 --and enc.ServiceDate is not null
	and sp.SAMPLESET_ID = 1218647
	order by sp.SAMPLEPOP_ID


--	100515974,
--100515975,
--100515976,
--100515977,
--100515978,
--100515980,
--100515981,
--100515982,
--100515983,
--100515984,
--100515985,
--100515986,
--100515987,
--100515990,

	use qp_prod
Select distinct sp.SAMPLEPOP_ID,sm.datexpire, sp.study_id, p.FName, p.LName, sm.strlithocode, schm.samplepop_ID, schm.sentmail_ID, schm.mailingstep_ID, fgl.intsequence, sm.datGenerated, sm.datPrinted, sm.datMailed, qf.questionform_id, qf.datreturned, qfeh.datExtracted_dt, qfe.datExtracted_dt, qr.QuestionResult, qf.bitcomplete 
From ScheduledMailing schm
      inner join Samplepop sp   on schm.samplepop_ID = sp.samplepop_ID
      inner join S4765.Population p on sp.pop_ID = p.pop_ID
      inner join SentMailing sm on schm.sentMail_ID = sm.sentmail_id
      inner join formgenlog fgl on schm.mailingstep_ID = fgl.mailingstep_ID
      inner join questionform qf on sm.sentmail_id=qf.sentmail_id
      left join questionform_extract_history qfeh on qf.questionform_id=qfeh.questionform_id
      left join questionform_extract qfe on qf.questionform_id=qfe.questionform_id
      left join (select distinct questionform_id as QuestionResult from questionresult) qr on qf.questionform_id=qr.questionresult
Where sp.sampleset_ID =  1218647
and fgl.intsequence = 1
order by sp.SAMPLEPOP_ID
