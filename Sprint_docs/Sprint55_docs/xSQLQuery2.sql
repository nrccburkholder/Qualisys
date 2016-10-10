

select *
--delete
from dbo.ToBeSeeded
where YearQtr = '2016Q3'

/*
update dbo.ToBeSeeded
SET isSeeded = 0,
	datSeeded = NULL
where survey_id = 15910
and YearQtr = '2016Q3'
*/


--select *
--from survey_def where SURVEY_ID = 15910


select top 10 *
from sampleset
order by SAMPLESET_ID desc

Select sm.*,sp.*, ms.MailingStepMethod_id
From SCHEDULEDMAILING sm
inner join Samplepop sp on sm.samplepop_ID = sp.samplepop_ID
left join Mailingstep ms on sm.MailingStep_id = ms.MailingStep_id
Where sp.sampleset_id = 1219438
--and POP_ID < 0
order by POP_ID


select *
from dbo.MAILINGSTEP 
where MAILINGSTEP_ID in 
(
	Select sm.MAILINGSTEP_ID
	From SCHEDULEDMAILING sm
	join Samplepop sp on sm.samplepop_ID = sp.samplepop_ID
	left join Mailingstep ms on sm.MailingStep_id = ms.MailingStep_id
	Where sp.sampleset_id = 1219438
)


