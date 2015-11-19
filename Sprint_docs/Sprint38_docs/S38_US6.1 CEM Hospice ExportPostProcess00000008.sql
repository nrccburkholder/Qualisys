/*
S37 US8 CAHPS - Hospice XML 2.0
As an authorized Hospice CAHPS vendor, we must update our submission file to conform to XML File Specs 2.0 starting w/ Q3 2015 decedents, so that we can submit data for our clients

Task 8.2 Modify the CEM.pullexportdata stored procedure to accommodate ICD type determination*
*  So we're not really modifing CEM.PullExportData to do this.  Using the PostProcess proc to update the ICDType

S37 US9 CAHPS - Hospice Missing DOD Count 
As an authorized Hospice CAHPS vendor, we must keep a count of records w/ missing dates of death, so that we can submit data according to specifications.

Task 9.1 alter the Hospice CAHPS CEM template post processing proc to grab this data from Qualisys
	

Tim Butler

*/


USE [NRC_Datamart_Extracts]


GO
/****** Object:  StoredProcedure [CEM].[ExportPostProcess00000008]    Script Date: 11/2/2015 4:36:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [CEM].[ExportPostProcess00000008]
@ExportQueueID int
as
update eds
set [decedentleveldata.sex] = case [decedentleveldata.sex] when 'M' then '1' when 'F' then '2' else 'M' end
from CEM.ExportDataset00000008 eds
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
*/

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),spdl.LoggedDate)
--select distinct eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) in (2,3,4,5,8,12,13,14) then 'SamplePopulationDispositionLog.LoggedDate' 
--	   end
--,spdl.DispositionID,spdl.ReceiptTypeID,spdl.CahpsTypeID,spdl.LoggedBy,spdl.LoggedDate
from CEM.ExportDataset00000008 eds
inner join nrc_datamart.dbo.samplepopulationdispositionlog spdl on spdl.SamplePopulationID=eds.SamplePopulationID
inner join nrc_datamart.dbo.CahpsDispositionMapping cdm on cdm.dispositionid=spdl.DispositionID and [decedentleveldata.survey-status]=(cdm.CahpsDispositionID-600)
where ltrim([decedentleveldata.survey-status]) in ('2','3','4','5','8','12','13','14')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) in (1,7) then 'QuestionForm.ReturnDate'
--	   end
--, qf.returndate
from CEM.ExportDataset00000008 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) in ('1','7') 
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 6 then 'QuestionForm.ReturnDate OR SamplePopulationDispositionLog.LoggedDate'
--	   end
--, qf.returndate
--, [caregiverresponse.oversee], [decedentleveldata.survey-completion-mode]
from CEM.ExportDataset00000008 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) = '6' 
and eds.ExportQueueID = @ExportQueueID 

if object_id('tempdb..#SampleSetExpiration') is not null
	drop table #SampleSetExpiration
select distinct ss.samplesetid, eds.samplepopulationid, dateadd(day,42,ss.datFirstMailed) as DatExpire
into #SampleSetExpiration
from CEM.ExportDataset00000008 eds
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
--, case when ltrim([decedentleveldata.survey-status]) = 9 then 'Expiration Date (Mail & Mixed) OR Date of last phone attempt (Phone)'
--	   end
--, sse.DatExpire
from CEM.ExportDataset00000008 eds
inner join #SampleSetExpiration sse on eds.SamplePopulationID=sse.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) ='9'
and [hospicedata.survey-mode] in ('1','3')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qss.datLastMailed)
--select eds.samplepopulationid, [hospicedata.provider-id] ccn, [hospicedata.survey-mode], convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) DayOfDeath
--, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then 'Expiration Date (Mail & Mixed) OR Date of last phone attempt (Phone)'
--	   end
--, ss.samplesetID, dsk.DataSourceKey as sampleset_id, qss.datLastMailed
from CEM.ExportDataset00000008 eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID and dsk.EntityTypeID=8
inner join Qualisys.qp_prod.dbo.sampleset qss on dsk.DataSourceKey = qss.sampleset_id
where ltrim([decedentleveldata.survey-status]) in ('9')
and isnull([decedentleveldata.lag-time],'') =''
and qss.datLastMailed is not null
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.LoggedDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate)) as lagtime
from CEM.ExportDataset00000008 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID=5--Non Response Bad Address / 16--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '10' -- bad address     / 11 -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.LoggedDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate)) as lagtime
from CEM.ExportDataset00000008 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID in (14,16)--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '11' -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 

-- There’s one hospice that we messed up sampling for January & February data.
-- Delete all January and February data out of the file for CCN 031592.
delete 
from CEM.ExportDataset00000008 
where [hospicedata.provider-id]='031592'
and [hospicedata.reference-yr]='2015'
and [hospicedata.reference-month] in ('01','02')
and ExportQueueID = @ExportQueueID 

-- Saint Mary’s Hospice and Palliative Care (ccn 291501) has six people we sampled in January but shouldn't have, so we're not submiting any of their january data.
delete eds
from cem.ExportDataset00000008 eds
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
from cem.ExportDataset00000008 eds
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
from cem.ExportDataset00000008 eds
where ExportQueueID = @ExportQueueID 
and [hospicedata.reference-yr]='2015'
and [hospicedata.provider-id] in ('291501','191568','251670','251575')
and [hospicedata.reference-month] in ('01','02')

-- Number of decedents/caregivers in the sample for the month with a “Final Survey Status” code of:  
-- “3 – Ineligible: Not in Eligible Population,” 
-- “6 – Ineligible: Never Involved in Decedent Care,” and 
-- “14 – Ineligible: Institutionalized.”
update cem.ExportDataset00000008 
set [hospicedata.ineligible-postsample]='0'
where ExportQueueID=@ExportQueueID 

update eds
set [hospicedata.ineligible-postsample]=sub.cnt
from cem.ExportDataset00000008 eds
inner join (select [hospicedata.provider-id],[hospicedata.reference-month], count(*) cnt
			from cem.ExportDataset00000008
			where ExportQueueID=@ExportQueueID 
			and ltrim([decedentleveldata.survey-status]) in ('3','6','14')
			group by [hospicedata.provider-id], [hospicedata.reference-month]) sub
	on eds.[hospicedata.provider-id]=sub.[hospicedata.provider-id] and eds.[hospicedata.reference-month]=sub.[hospicedata.reference-month]
where eds.ExportQueueID=@ExportQueueID 

-- recode various blank columns to 'M' or 'N/A'
update cem.ExportDataset00000008 set [decedentleveldata.decedent-primary-diagnosis]='MMMMMMM' where [decedentleveldata.decedent-primary-diagnosis]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [decedentleveldata.decedent-payer-primary]='M' where [decedentleveldata.decedent-payer-primary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [decedentleveldata.decedent-payer-secondary]='M' where [decedentleveldata.decedent-payer-secondary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [decedentleveldata.decedent-payer-other]='M' where [decedentleveldata.decedent-payer-other]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [decedentleveldata.last-location]='M' where [decedentleveldata.last-location]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [decedentleveldata.decedent-race]='M' where [decedentleveldata.decedent-race]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [decedentleveldata.facility-name]='N/A' where [decedentleveldata.facility-name]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000008 set [hospicedata.no-publicity]='M' where [hospicedata.no-publicity]='' and ExportQueueid=@ExportQueueID

-- add zero-sample CCN's to the dataset. 
-- for now, any CCN that's in (select from SampleUnitFacilityAttributes where AHAIdent=1) is one we should be submitting for.
-- AHAIdent is manually populated.

if object_id('tempdb..#months') is not null
	drop table #months
if object_id('tempdb..#CCN') is not null
	drop table #CCN
if object_id('tempdb..#everything') is not null
	drop table #everything

select distinct eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]
into #months
from [CEM].[ExportDataset00000008] eds
where eds.exportqueueid=@ExportQueueID

select distinct MedicareNumber, FacilityName, convert(char(10), NULL) as NPI
into #CCN
from nrc_datamart.dbo.SampleUnitFacilityAttributes 
where AHAIdent=1

update #ccn set NPI='M'

update ccn
set npi=[hospicedata.NPI]
from #ccn ccn
inner join [CEM].[ExportDataset00000008] eds on ccn.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueid=@ExportQueueID

select *
into #everything
from #months m, #ccn c

delete e
from #everything e
inner join [CEM].[ExportDataset00000008] eds 
	on e.[hospicedata.reference-yr]=eds.[hospicedata.reference-yr]
		and e.[hospicedata.reference-month]=eds.[hospicedata.reference-month]
		and e.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueID=@ExportQueueID

insert into [CEM].[ExportDataset00000008] ([ExportQueueID], [ExportTemplateID], [FileMakerName], [vendordata.vendor-name], [vendordata.file-submission-yr], [vendordata.file-submission-month], [vendordata.file-submission-day]
	, [vendordata.file-submission-number], [hospicedata.reference-yr], [hospicedata.reference-month], [hospicedata.provider-name], [hospicedata.provider-id], [hospicedata.npi], [hospicedata.survey-mode], [hospicedata.total-decedents]
	, [hospicedata.live-discharges], [hospicedata.no-publicity], [hospicedata.ineligible-presample], [hospicedata.sample-size], [hospicedata.ineligible-postsample], [hospicedata.sample-type])
select distinct eds.[ExportQueueID], eds.[ExportTemplateID], eds.[FileMakerName], eds.[vendordata.vendor-name], eds.[vendordata.file-submission-yr], eds.[vendordata.file-submission-month], eds.[vendordata.file-submission-day]
	, eds.[vendordata.file-submission-number], e.[hospicedata.reference-yr], e.[hospicedata.reference-month], left(e.FacilityName,100), e.MedicareNumber, e.NPI, '8' as [hospicedata.survey-mode], char(7) as [hospicedata.total-decedents]
	, char(7) as [hospicedata.live-discharges], char(7) as [hospicedata.no-publicity], char(7) as [hospicedata.ineligible-presample], '0' as [hospicedata.sample-size], '0' as [hospicedata.ineligible-postsample], '8' as [hospicedata.sample-type]
from [CEM].[ExportDataset00000008] eds, #everything e
where eds.ExportQueueID=@ExportQueueID

-- recode blank NPI's to 'M'
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000008 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.npi]=''

-- recode NPI to 'M' for any CCN that has multiple NPI values
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000008 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.provider-id] in (select [hospicedata.provider-id]
									from CEM.ExportDataset00000008 eds
									where eds.ExportQueueID = @ExportQueueID 
									group by [hospicedata.provider-id]
									having count(distinct [hospicedata.npi])>1)

update cem.ExportDataset00000008 
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

update cem.ExportDataset00000008 
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
select @sql=@sql+'update cem.ExportDataset00000008 set [caregiverresponse.'+etc.exportcolumnname+']=''M'' '+
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
from CEM.ExportDataset00000008 eds
where isnull([decedentleveldata.lag-time],'') =''
and ExportQueueID = @ExportQueueID 
group by [decedentleveldata.survey-status]

/* 
Determine if the ICD code returned is ICD9 or ICD10, then write value into decedent-primary-diagnosis, and type of ICD into diagnosis-code-format 
S37 US 8.2 Modify stored procedure to accommodate ICD type determination  11/03/2015  TSB
*/


update eds 
	set [decedentleveldata.diagnosis-code-format] ='1', 
	[decedentleveldata.decedent-primary-diagnosis] = replace([decedentleveldata.icd9],'.','') -- remove dot
from cem.ExportDataset00000008 eds 
where LEN(ltrim(rtrim([decedentleveldata.icd9]))) > 0
and eds.ExportQueueID = @ExportQueueID

update eds 
	set [decedentleveldata.diagnosis-code-format] ='2', 
	[decedentleveldata.decedent-primary-diagnosis] = replace([decedentleveldata.icd10],'.','') -- remove dot
from cem.ExportDataset00000008 eds 
where LEN(ltrim(rtrim([decedentleveldata.icd10]))) > 0 
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

declare @study_id int


select eds.[hospicedata.provider-id] as provider_id, qpss.SampleSet_ID, sds.DataSet_ID, ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
       , eds.[hospicedata.reference-yr] as yr, eds.[hospicedata.reference-month] as mo
	   INTO #SampleSets
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
inner join NRC_DataMart_Extracts.CEM.ExportQueue  eq on eq.ExportQueueId = eds.ExportQueueId
inner join Qualisys.qp_prod.dbo.SuFacility suf on suf.medicarenumber = eds.[hospicedata.provider-id]
inner join Qualisys.qp_prod.dbo.SampleUnit qpsu on qpsu.SUFacility_id = suf.SUFacility_id
inner join Qualisys.qp_prod.dbo.SamplePlan qpsp on qpsp.SamplePlan_id = qpsu.SamplePlan_id
inner join Qualisys.qp_prod.dbo.SampleSet qpss on qpss.Survey_id = qpsp.Survey_id
inner join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.SampleSet_ID = qpss.SampleSet_ID
inner join Qualisys.qp_prod.dbo.Data_Set ds on ds.DataSet_ID = sds.DataSet_ID
WHERE eq.ExportQueueID = @ExportQueueID
and CAST(eds.[hospicedata.reference-yr] + '-' + eds.[hospicedata.reference-month] + '- 01' AS DATETIME) between qpss.[datDateRange_FromDate] AND qpss.[datDateRange_ToDate]
GROUP BY eds.[hospicedata.provider-id], qpss.SampleSet_Id, sds.DataSet_ID,  ds.Study_id , qpss.[datDateRange_FromDate], qpss.[datDateRange_ToDate]
, eds.[hospicedata.reference-yr], eds.[hospicedata.reference-month]


select top 1 @study_id = study_id
from #SampleSets
while @@rowcount>0
begin
      
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


update eds
SET [hospicedata.missing-dod] = mdc.MissingCount
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
			from #MissingDODCounts
			group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]
where eds.ExportQueueID = @ExportQueueID

update eds
SET [hospicedata.missing-dod] = 0
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000008] eds
where eds.ExportQueueID = @ExportQueueID
and [hospicedata.missing-dod] is NULL

drop table #SampleSets
drop table #MissingDODCounts
