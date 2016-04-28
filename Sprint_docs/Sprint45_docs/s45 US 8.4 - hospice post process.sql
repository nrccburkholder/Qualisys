/*
	S45 US 8 Hospice Post-Process Error Logging 
	As a developer, I want to check the nightly Hospice extract for errors and log them to a file so that we can track down what conditions are causing problems before it's time for the submission
	
	8.4 - Select items from doc to implement & implement them
	
*/
use NRC_Datamart_Extracts
go
alter PROCEDURE [CEM].[ExportPostProcess00000011]
@ExportQueueID int
as
/* includes changes for xml version 2.1 as per S40 US22  TSB 01/13/2016 */
update eds
set [decedentleveldata.sex] = case [decedentleveldata.sex] when 'M' then '1' when 'F' then '2' else 'M' end
from CEM.ExportDataset00000011 eds
where [decedentleveldata.sex] not in ('1','2')
and eds.ExportQueueID = @ExportQueueID 

/*
Number of days between date of death and the date that data collection activities ended

Disposition Description                      Disposition  Lag Time Field                                Notes
Completed Survey                             1            QuestionForm.ReturnDate    
Ineligible: Deceased                         2            SamplePopulationDispositionLog.LoggedDate    
Ineligible: Not in Eligible Population       3            SamplePopulationDispositionLog.LoggedDate    
Ineligible: Language Barrier                 4            SamplePopulationDispositionLog.LoggedDate    
Ineligible: Mental/Physical Incapacity       5            SamplePopulationDispositionLog.LoggedDate    
Ineligible: Never involved in decedent care  6            "QuestionForm.ReturnDate
                                                          OR
                                                          SamplePopulationDispositionLog.LoggedDate"    Dispo comes from the answer to Q3, or can be dispositioned in the intro during a phone interview (before any questions asked)
Non-response: Breakoff                       7            QuestionForm.ReturnDate    Partial survey
Non-response: Refusal                        8            SamplePopulationDispositionLog.LoggedDate    
Non-response: Maximum attempts               9            "Expiration Date (Mail & Mixed)
                                                          OR
                                                          Date of last phone attempt (Phone)"           Expiration date is in Catalyst questionform table, but questionform records only brought over to Catalyst for returns
Non-response: Bad Address                    10           QuestionForm.datUndeliverable    
Non-response: Bad/no phone number            11           QuestionForm.datUndeliverable    
Non-response: Incomplete Caregiver Name      12           SamplePopulationDispositionLog.LoggedDate     May change depending on solution for identifying these
Non-response: Incomplete Decedent Name       13           SamplePopulationDispositionLog.LoggedDate     May change depending on solution for identifying these
Ineligible: Institutionalized                14           SamplePopulationDispositionLog.LoggedDate    
Non-Response: Hospice Disavowal              15           SamplePopulationDispositionLog.LoggedDate    
*/

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),spdl.LoggedDate)
--select distinct eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) in (2,3,4,5,8,12,13,14,15) then 'SamplePopulationDispositionLog.LoggedDate' 
--	   end
--,spdl.DispositionID,spdl.ReceiptTypeID,spdl.CahpsTypeID,spdl.LoggedBy,spdl.LoggedDate
from CEM.ExportDataset00000011 eds
inner join nrc_datamart.dbo.samplepopulationdispositionlog spdl on spdl.SamplePopulationID=eds.SamplePopulationID
inner join nrc_datamart.dbo.CahpsDispositionMapping cdm on cdm.dispositionid=spdl.DispositionID and [decedentleveldata.survey-status]=(cdm.CahpsDispositionID-600)
where ltrim([decedentleveldata.survey-status]) in ('2','3','4','5','8','12','13','14','15')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) in (1,7) then 'QuestionForm.ReturnDate'
--	   end
--, qf.returndate
from CEM.ExportDataset00000011 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) in ('1','7') 
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 6 then 'QuestionForm.ReturnDate OR SamplePopulationDispositionLog.LoggedDate'
--	   end
--, qf.returndate
--, [caregiverresponse.oversee], [decedentleveldata.survey-completion-mode]
from CEM.ExportDataset00000011 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) = '6' 
and eds.ExportQueueID = @ExportQueueID 

if object_id('tempdb..#SampleSetExpiration') is not null
	drop table #SampleSetExpiration
select distinct ss.samplesetid, eds.samplepopulationid, dateadd(day,42,ss.datFirstMailed) as DatExpire
into #SampleSetExpiration
from CEM.ExportDataset00000011 eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
where eds.ExportQueueID = @ExportQueueID 
order by 2

if exists (select * from #SampleSetExpiration where datExpire is null)
	update sse
	set datExpire=dateadd(day,42,sub.datFirstMailed) 
	from #SampleSetExpiration sse
	inner join (select sse.samplesetid, min(sm.datMailed) as datFirstMailed
				from #SampleSetExpiration sse
				inner join nrc_datamart.etl.datasourcekey dsk on sse.SampleSetID=dsk.DataSourceKeyID
				inner join qualisys.qp_prod.dbo.samplepop sp on dsk.DataSourceKey=sp.sampleset_id
				inner join qualisys.qp_prod.dbo.scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
				inner join qualisys.qp_prod.dbo.sentmailing sm on scm.sentmail_id=sm.sentmail_id
				group by sse.samplesetid) sub
		on sse.samplesetid=sub.samplesetid
	where sse.datExpire is null

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),sse.datExpire)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then 'Expiration Date (Mail & Mixed)'
--	   end
--, sse.DatExpire
from CEM.ExportDataset00000011 eds
inner join #SampleSetExpiration sse on eds.SamplePopulationID=sse.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) ='9'
and [hospicedata.survey-mode] in ('1','3')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),spdl.loggeddate)
--select eds.samplepopulationid, [hospicedata.provider-id] ccn, [hospicedata.survey-mode], convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) DayOfDeath
--, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then 'Date of last phone attempt (Phone)'
--	   end
--, spdl.loggeddate
from CEM.ExportDataset00000011 eds
inner join NRC_Datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) in ('9')
and isnull([decedentleveldata.lag-time],'') =''
and [hospicedata.survey-mode] not in ('1','3')
and spdl.dispositionid in (12) --- Maximum Attempts on Phone or Mail
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.LoggedDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate)) as lagtime
from CEM.ExportDataset00000011 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID=5--Non Response Bad Address / 16--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '10' -- bad address     / 11 -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.LoggedDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate)) as lagtime
from CEM.ExportDataset00000011 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID in (14,16)--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '11' -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 

-- There’s one hospice that we messed up sampling for January & February data.
-- Delete all January and February data out of the file for CCN 031592.
delete 
from CEM.ExportDataset00000011 
where [hospicedata.provider-id]='031592'
and [hospicedata.reference-yr]='2015'
and [hospicedata.reference-month] in ('01','02')
and ExportQueueID = @ExportQueueID 

-- Saint Mary’s Hospice and Palliative Care (ccn 291501) has six people we sampled in January but shouldn't have, so we're not submiting any of their january data.
delete eds
from cem.ExportDataset00000011 eds
where ExportQueueID = @ExportQueueID 
and [hospicedata.provider-id]='291501'
and [hospicedata.reference-yr]='2015'
and [hospicedata.reference-month] in ('01')

--update blank [no-publicity] to 0 for the following CCNs:
	--provider-name								provider-id	reference-month
	--Gentlepro Home Health Care				141613		03
	--Knapp Medical Center (Prime Healthcare)	451662		01
	--Knapp Medical Center (Prime Healthcare)	451662		02
	--Knapp Medical Center (Prime Healthcare)	451662		03
	--Vernon Memorial Hospital					521544		03
update eds
set [hospicedata.no-publicity]='0'
--- select distinct exportqueueid,[hospicedata.provider-id],[hospicedata.reference-month],[hospicedata.no-publicity]
from cem.ExportDataset00000011 eds
where [hospicedata.no-publicity]=''
and [hospicedata.provider-id]+'.'+[hospicedata.reference-month] in ('141613.03','451662.01','451662.02','451662.03','521544.03')
and [hospicedata.reference-yr]='2015'
and ExportQueueID = @ExportQueueID

-- delete the following months for the following CCNs - we have good March data for them and aren't submitting January or February
	--provider-name									provider-id	reference-yr	reference-month
	--Saint Mary’s Hospice and Palliative Care 		291501		2015			2
	--St. Joseph Hospice-Baton Rouge/TCH			191568		2015			1
	--St. Joseph Hospice-Baton Rouge/TCH			191568		2015			2
	--St. Joseph Hospice-Biloxi/Hattiesburg/Picayun	251670		2015			1
	--St. Joseph Hospice-Biloxi/Hattiesburg/Picayun	251670		2015			2
	--St. Joseph Hospice-Richland/Vicksburg			251575		2015			1
	--St. Joseph Hospice-Richland/Vicksburg			251575		2015			2
delete eds
from cem.ExportDataset00000011 eds
where ExportQueueID = @ExportQueueID 
and [hospicedata.reference-yr]='2015'
and [hospicedata.provider-id] in ('291501','191568','251670','251575')
and [hospicedata.reference-month] in ('01','02')

-- Number of decedents/caregivers in the sample for the month with a “Final Survey Status” code of:  
-- “3 – Ineligible: Not in Eligible Population,” 
-- “6 – Ineligible: Never Involved in Decedent Care,” and 
-- “14 – Ineligible: Institutionalized.”
update cem.ExportDataset00000011 
set [hospicedata.ineligible-postsample]='0'
where ExportQueueID=@ExportQueueID 

update eds
set [hospicedata.ineligible-postsample]=sub.cnt
from cem.ExportDataset00000011 eds
inner join (select [hospicedata.provider-id],[hospicedata.reference-month], count(*) cnt
			from cem.ExportDataset00000011
			where ExportQueueID=@ExportQueueID 
			and ltrim([decedentleveldata.survey-status]) in ('2','3','4','5','6','14') --(v2.1)
			group by [hospicedata.provider-id], [hospicedata.reference-month]) sub
	on eds.[hospicedata.provider-id]=sub.[hospicedata.provider-id] and eds.[hospicedata.reference-month]=sub.[hospicedata.reference-month]
where eds.ExportQueueID=@ExportQueueID 

-- recode various blank columns to 'M' or 'N/A'
update cem.ExportDataset00000011 set [decedentleveldata.decedent-primary-diagnosis]='MMMMMMMM' where [decedentleveldata.decedent-primary-diagnosis]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [decedentleveldata.decedent-payer-primary]='M' where [decedentleveldata.decedent-payer-primary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [decedentleveldata.decedent-payer-secondary]='M' where [decedentleveldata.decedent-payer-secondary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [decedentleveldata.decedent-payer-other]='M' where [decedentleveldata.decedent-payer-other]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [decedentleveldata.last-location]='M' where [decedentleveldata.last-location]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [decedentleveldata.decedent-race]='M' where [decedentleveldata.decedent-race]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [decedentleveldata.facility-name]='N/A' where [decedentleveldata.facility-name]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000011 set [hospicedata.no-publicity]='M' where [hospicedata.no-publicity]='' and ExportQueueid=@ExportQueueID

-- add zero-sample CCN's to the dataset. 
-- for now, we're hardcoding which CCNs need to be included

if object_id('tempdb..#months') is not null
	drop table #months
if object_id('tempdb..#CCN') is not null
	drop table #CCN
if object_id('tempdb..#everything') is not null
	drop table #everything

select distinct eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]
into #months
from [CEM].[ExportDataset00000011] eds
where eds.exportqueueid=@ExportQueueID

select distinct MedicareNumber, FacilityName, convert(char(10), NULL) as NPI
into #CCN
from nrc_datamart.dbo.SampleUnitFacilityAttributes 
where medicarenumber in ('141613','191572','671765')  --> this is the hardcoding

update #ccn set NPI='M'

update ccn
set npi=[hospicedata.NPI]
from #ccn ccn
inner join [CEM].[ExportDataset00000011] eds on ccn.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueid=@ExportQueueID

select *
	, char(7) as [no-publicity]
	, char(7) as [total-decedents]
	, char(7) as [ineligible-presample]
	, char(7) as [live-discharges]
	, char(7) as [missing-dod]
	, char(7) as [number-offices]
into #everything
from #months m, #ccn c

delete e
from #everything e
inner join [CEM].[ExportDataset00000011] eds 
	on e.[hospicedata.reference-yr]=eds.[hospicedata.reference-yr]
		and e.[hospicedata.reference-month]=eds.[hospicedata.reference-month]
		and e.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueID=@ExportQueueID

-- more 2015 Q4 hardcoding
--From: James Tobey 
--Sent: Thursday, April 14, 2016 11:58 AM
--To: Dave Gilsdorf <dgilsdorf@nationalresearch.com>
--Cc: ATLAS SCRUM Team <ATLASSCRUMTeam@nationalresearch.com>
--Subject: RE: Hospice Q4 submission data issues

--Hi Dave,

--Here are the numbers you need for GentlePro, and two additional hospices with zero outgo I found:

--reference-yr	reference-month	provider-name					provider-id	no-publicity	total-decedents	ineligible-presample	live-discharges	missing-dod	number-offices
--2015			10				Gentlepro Home Health Care		141613		0				0				0						3				0			1
--2015			11				Gentlepro Home Health Care		141613		0				0				0						2				0			1
--2015			12				St. Joseph Hospice-New Orleans	191572		0				0				0						1				0			1
--2015			11				St. Joseph Hospice-Texas		671765		0				0				0						2				0			1

--You mentioned that your “zero outgo” would have caught any CCN with at least one row in the extract but did not have all three months. Both CCN 191572 and 671765 had two sample months in the extract and were missing one month.

--I reconciled the extract CCNs against our authorization list and found no gap. All CCNs are accounted for.

--Thanks,
--James

update #everything set [no-publicity]='0',[total-decedents]='0',[ineligible-presample]='0',[live-discharges]='3',[missing-dod]='0',[number-offices]='1' where [hospicedata.reference-yr]='2015' and [hospicedata.reference-month]='10' and MedicareNumber='141613'
update #everything set [no-publicity]='0',[total-decedents]='0',[ineligible-presample]='0',[live-discharges]='2',[missing-dod]='0',[number-offices]='1' where [hospicedata.reference-yr]='2015' and [hospicedata.reference-month]='11' and MedicareNumber='141613'
update #everything set [no-publicity]='0',[total-decedents]='0',[ineligible-presample]='0',[live-discharges]='1',[missing-dod]='0',[number-offices]='1' where [hospicedata.reference-yr]='2015' and [hospicedata.reference-month]='12' and MedicareNumber='191572'
update #everything set [no-publicity]='0',[total-decedents]='0',[ineligible-presample]='0',[live-discharges]='2',[missing-dod]='0',[number-offices]='1' where [hospicedata.reference-yr]='2015' and [hospicedata.reference-month]='11' and MedicareNumber='671765'
-- /more 2015 Q4 hardcoding

INSERT INTO [CEM].[exportdataset00000011] 
            ([exportqueueid], 
             [exporttemplateid], 
             [filemakername], 
             [vendordata.vendor-name], 
             [vendordata.file-submission-yr], 
             [vendordata.file-submission-month], 
             [vendordata.file-submission-day], 
             [vendordata.file-submission-number], 
             [hospicedata.reference-yr], 
             [hospicedata.reference-month], 
             [hospicedata.provider-name], 
             [hospicedata.provider-id], 
             [hospicedata.npi], 
             [hospicedata.survey-mode], 
             [hospicedata.total-decedents], 
             [hospicedata.live-discharges], 
             [hospicedata.no-publicity], 
             [hospicedata.ineligible-presample], 
			 [hospicedata.missing-dod],
             [hospicedata.sample-size], 
             [hospicedata.ineligible-postsample], 
			 [hospicedata.number-offices],
             [hospicedata.sample-type]) 
SELECT DISTINCT eds.[exportqueueid], 
                eds.[exporttemplateid], 
                eds.[filemakername], 
                eds.[vendordata.vendor-name], 
                eds.[vendordata.file-submission-yr], 
                eds.[vendordata.file-submission-month], 
                eds.[vendordata.file-submission-day], 
                eds.[vendordata.file-submission-number], 
                e.[hospicedata.reference-yr], 
                e.[hospicedata.reference-month], 
                LEFT(e.facilityname, 100), 
                e.medicarenumber, 
                e.npi, 
                '8' AS [survey-mode], 
				     e.[total-decedents], 
				     e.[live-discharges], 
				     e.[no-publicity], 
				     e.[ineligible-presample], 
				     e.[missing-dod],
                '0' AS [sample-size], 
                '0' AS [ineligible-postsample], 
				     e.[number-offices],
                '8' AS [sample-type] 
FROM   [CEM].[exportdataset00000011] eds, #everything e 
WHERE  eds.exportqueueid = @ExportQueueID 

-- hardcoding zero eligible cases 2015 Q3
update [CEM].[ExportDataset00000011] 
set [hospicedata.total-decedents] = 0,
	[hospicedata.live-discharges] = case [hospicedata.reference-month] when 7 then 0 when 9 then 3 end,
	[hospicedata.no-publicity] = 0, 
	[hospicedata.ineligible-presample] = 0,
    [hospicedata.number-offices] = '1'
where ExportQueueID=@ExportQueueID
and [hospicedata.provider-id]='141613'
and [hospicedata.reference-yr]='2015'
and [hospicedata.reference-month] in (7,9)

-- /hardcoding zero eligible cases 2015 Q3

-- recode blank NPI's to 'M'
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000011 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.npi]=''

-- recode NPI to 'M' for any CCN that has multiple NPI values
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000011 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.provider-id] in (select [hospicedata.provider-id]
									from CEM.ExportDataset00000011 eds
									where eds.ExportQueueID = @ExportQueueID 
									group by [hospicedata.provider-id]
									having count(distinct [hospicedata.npi])>1)

update cem.ExportDataset00000011 
set [caregiverresponse.location-assisted]='M'
	,[caregiverresponse.location-home]='M'
	,[caregiverresponse.location-hospice-facility]='M'
	,[caregiverresponse.location-hospital]='M'
	,[caregiverresponse.location-nursinghome]='M'
	,[caregiverresponse.location-other]='M'
where [caregiverresponse.location-assisted] = ''
	and [caregiverresponse.location-home] = ''
	and [caregiverresponse.location-hospice-facility] = ''
	and [caregiverresponse.location-hospital] = ''
	and [caregiverresponse.location-nursinghome] = ''
	and [caregiverresponse.location-other] = ''
	and ltrim([decedentleveldata.survey-status]) in ('1','6','7')  
	and ExportQueueID = @ExportQueueID 

update cem.ExportDataset00000011 
set [caregiverresponse.race-african-amer]='M'
	,[caregiverresponse.race-amer-indian-ak]='M'
	,[caregiverresponse.race-asian]='M'
	,[caregiverresponse.race-hi-pacific-islander]='M'
	,[caregiverresponse.race-white]='M'
where [caregiverresponse.race-african-amer]='' 
	and [caregiverresponse.race-amer-indian-ak]='' 
	and [caregiverresponse.race-asian]='' 
	and [caregiverresponse.race-hi-pacific-islander]='' 
	and [caregiverresponse.race-white]=''
	and ltrim([decedentleveldata.survey-status]) in ('1','6','7')  
	and ExportQueueID = @ExportQueueID 

-- the default CEM behavior is to repeat the missing characters (e.g. 'M') for the entire width of the field. CAHPSHospice wants it to be just 'M' in the CareGiverResponse section, regardless of the width of the field.
-- in other sections they want it repeated (e.g. [decedentleveldata.decedent-primary-diagnosis] should be 'MMMMMMM' and not 'M')
declare @sql varchar(max)=''
select @sql=@sql+'update cem.ExportDataset00000011 set [caregiverresponse.'+etc.exportcolumnname+']=''M'' '+
	'where [caregiverresponse.'+etc.exportcolumnname+']='''+replicate('M',etc.fixedwidthlength)+''' and ExportQueueid='+convert(varchar,eq.exportqueueid)+char(10)
from cem.exportqueue eq
inner join cem.ExportTemplate et on eq.exporttemplatename=et.exporttemplatename and eq.exporttemplateversionmajor=et.exporttemplateversionmajor and isnull(eq.ExportTemplateVersionMinor,-1)=isnull(et.ExportTemplateVersionMinor,-1)
inner join cem.ExportTemplateSection ets on et.ExportTemplateID=ets.ExportTemplateID
inner join cem.ExportTemplateColumn etc on ets.ExportTemplateSectionID=etc.ExportTemplateSectionID
where eq.exportqueueid=@ExportQueueID
and ets.exporttemplatesectionname='caregiverresponse'
and etc.FixedWidthLength>1
and etc.exportcolumnname is not null
print @SQL
exec(@SQL)

select [decedentleveldata.survey-status], min([decedentleveldata.lag-time]) as minLagTime, max([decedentleveldata.lag-time]) as maxLagTime, count(*) as [count]
from CEM.ExportDataset00000011 eds
where isnull([decedentleveldata.lag-time],'') =''
and ExportQueueID = @ExportQueueID 
group by [decedentleveldata.survey-status]

/* 
Determine if the ICD code returned is ICD9 or ICD10, then write value into decedent-primary-diagnosis, and type of ICD into diagnosis-code-format 
S37 US 8.2 Modify stored procedure to accommodate ICD type determination  11/03/2015  TSB
*/

update eds 
	set [decedentleveldata.diagnosis-code-format] ='1',
	[decedentleveldata.decedent-primary-diagnosis] =  ltrim(rtrim([decedentleveldata.icd9]))
from cem.ExportDataset00000011 eds 
where LEN(ltrim(rtrim([decedentleveldata.icd9]))) > 0
and eds.ExportQueueID = @ExportQueueID

update eds 
	set [decedentleveldata.diagnosis-code-format] ='2',
	[decedentleveldata.decedent-primary-diagnosis] =  ltrim(rtrim([decedentleveldata.icd10]))
from cem.ExportDataset00000011 eds 
where LEN(ltrim(rtrim([decedentleveldata.icd10]))) > 0 
and eds.ExportQueueID = @ExportQueueID

-- if icd10 code is a z code, then mark as missing
update eds 
	set [decedentleveldata.decedent-primary-diagnosis] =  'MMMMMMMM'
from cem.ExportDataset00000011 eds 
where [decedentleveldata.diagnosis-code-format] ='2'
and substring((ltrim(rtrim([decedentleveldata.icd10]))),1,1) = 'Z'
and eds.ExportQueueID = @ExportQueueID

/* 
Hospice Missing DOD Count -----As an authorized Hospice CAHPS vendor, we must keep a count of records w/ missing dates of death, so that we can submit data according to specifications 
S37 US 1.1 Alter the Hospice CAHPS CEM template post processing proc to grab this data from Qualisys  11/03/2015  TSB
*/

CREATE TABLE #MissingDODCounts (                                  
   [provider-id] VARCHAR(10),
   [Study_id] int,
   [DataSet_id] int,  
   [yr] varchar(4),
   [mo] varchar(2),                                   
   [MissingCount] int                            
)   


select eds.[hospicedata.provider-id] as provider_id, qpss.SampleSet_ID, sds.DataSet_ID, ds.Study_id 
       , min(qpss.intDateRange_Field_id) as SampledOnField_id, min(mf.strField_nm) as SampledOnField_nm, qpss.[datDateRange_FromDate] as SampleSet_FromDate, qpss.[datDateRange_ToDate] as Sampleset_ToDate
       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
	   , convert(bit,null) as isInDateRange, convert(datetime,null) as minDatasetServicedate, convert(datetime,null) as maxDatasetServicedate
	   INTO #SampleSets
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000011] eds
inner join NRC_DataMart_Extracts.CEM.ExportQueue  eq on eq.ExportQueueId = eds.ExportQueueId
inner join Qualisys.qp_prod.dbo.SuFacility suf on suf.medicarenumber = eds.[hospicedata.provider-id]
inner join Qualisys.qp_prod.dbo.SampleUnit qpsu on qpsu.SUFacility_id = suf.SUFacility_id
inner join Qualisys.qp_prod.dbo.SamplePlan qpsp on qpsp.SamplePlan_id = qpsu.SamplePlan_id
inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.Survey_id = qpsp.Survey_id
inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
inner join Qualisys.qp_prod.dbo.MetaField mf on qpss.intDateRange_Field_id=mf.field_id
inner join Qualisys.qp_prod.dbo.survey_def sd on qpsp.survey_id=sd.survey_id
WHERE eq.ExportQueueID = @ExportQueueID
and sd.surveytype_id=11
and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate]
GROUP BY eds.[hospicedata.provider-id], qpss.SampleSet_Id, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]

-- remove datasets that don't have data within the sampleset's date range.
	update ss
	set minDatasetServicedate=dsdr.minDate
	, maxDatasetServicedate=dsdr.maxDate
	from #samplesets ss
	inner join Qualisys.qp_prod.dbo.DatasetDateRange dsdr on ss.dataset_id=dsdr.dataset_id and ss.SampledOnField_id=dsdr.field_id

	-- these are datasets that don't have any data in dbo.DatasetDateRange (or datasetDateRange.minDate was NULL), so we'll go look at the various encounter tables for the encounter date ranges.
	declare @study_id int, @SampledOnField_nm varchar(50), @dataset_id int
	select top 1 @study_id = study_id, @SampledOnField_nm = SampledOnField_nm, @dataset_id=dataset_id
	from #SampleSets
	where minDatasetServicedate is null
	while @@rowcount>0
	begin
		SET @sql = 'update ss
		set minDatasetServicedate = minEncDate, maxDatasetServicedate = maxEncDate
		from #samplesets ss
		inner join (SELECT dm.dataset_id, isnull(min(enc.'+@SampledOnField_nm+'),''1/1/1901'') as minEncDate, isnull(max(enc.'+@SampledOnField_nm+'),''1/31/1901'') as maxEncDate
					FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
					inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.pop_ID = enc.pop_id and dm.ENC_ID = enc.enc_id		   
					where dm.dataset_id=' + CAST(@dataset_id as varchar) + '
					group by dm.dataset_id) sub
			on ss.dataset_id=sub.dataset_id'
		print @SQL
		exec (@SQL)

		-- if minDataSetServiceDate is 1/1/1901, that means there were records in the dataset but ALL the ServiceDates were null.
		-- we assume that all the records rightfully belong to the sampleset, so we're going to explicitly set isInDateRange = 1 
		update #samplesets set isInDateRange = 1, minDataSetServiceDate=SampleSet_FromDate, maxDataSetServiceDate=Sampleset_ToDate where dataset_id=@dataset_id and minDataSetServiceDate = '1/1/1901'
		
		-- if minDataSetServiceDate is still NULL, that means there weren't any records in the dataset
		-- the missing DoD count should be zero, so we're going to exclude these records from #samplesets
		delete from #samplesets where dataset_id=@dataset_id and minDataSetServiceDate is null

		select top 1 @study_id = study_id, @SampledOnField_nm = SampledOnField_nm, @dataset_id=dataset_id
		from #SampleSets
		where minDatasetServicedate is null
	end

	update #samplesets set isInDateRange = 1 
	where minDatasetServicedate between [Sampleset_FromDate] and [Sampleset_ToDate] 
	and maxDatasetServicedate between [Sampleset_FromDate] and [Sampleset_ToDate] 

	update #samplesets set isInDateRange = 0 where isInDateRange is NULL

	-- these are samplesets in which SOME of the data in the datasets is within the sampleset's date range.
	if exists (select * from #samplesets where isindaterange=0 
				and (minDatasetServicedate between [Sampleset_FromDate] and [Sampleset_ToDate] 
					or maxDatasetServicedate between [Sampleset_FromDate] and [Sampleset_ToDate]))
	begin
		select 'these datasets have encounter dates that spill over the sampleset''s date range, so it might be impossible to tell if any missing DoD values are within the specific month' as [ERROR!]
		select * 
		from #samplesets 
		where isindaterange=0 
		and (minDatasetServicedate between [Sampleset_FromDate] and [Sampleset_ToDate] 
			or maxDatasetServicedate between [Sampleset_FromDate] and [Sampleset_ToDate])
		order by [Sampleset_FromDate]
	end

	delete from #samplesets where isInDateRange = 0
-- /remove datasets


select top 1 @study_id = study_id, @SampledOnField_nm = SampledOnField_nm
from #SampleSets
while @@rowcount>0
begin
      
       SET @sql = 'INSERT INTO #MissingDODCounts
       SELECT enc.ccn,' + CAST(@study_id as varchar) + ',dm.dataset_id,ss.yr,ss.mo, count(distinct dm.pop_id)
       FROM Qualisys.[QP_Prod].[S' + CAST(@study_id as varchar) + '].[ENCOUNTER] enc
       inner join Qualisys.[QP_Prod].[dbo].[DATASETMEMBER] dm on dm.pop_ID = enc.pop_id and dm.ENC_ID = enc.enc_id
       inner join #samplesets ss on dm.dataset_id=ss.dataset_id and enc.ccn=ss.provider_id
       where ss.study_id=' + CAST(@study_id as varchar) + ' and enc.'+@SampledOnField_nm+' is null
       group by enc.ccn,dm.dataset_id,ss.yr,ss.mo'

       print @sql
       exec (@Sql)

       delete from #SampleSets where study_id = @study_id and SampledOnField_nm = @SampledOnField_nm
       select top 1 @study_id = study_id, @SampledOnField_nm = SampledOnField_nm
       from #SampleSets
end


update eds
SET [hospicedata.missing-dod] = mdc.MissingCount
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000011] eds
inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
			from #MissingDODCounts
			group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]
where eds.ExportQueueID = @ExportQueueID

update eds
SET [hospicedata.missing-dod] = 0
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000011] eds
where eds.ExportQueueID = @ExportQueueID
and isnull([hospicedata.missing-dod],'')=''

drop table #SampleSets
drop table #MissingDODCounts
