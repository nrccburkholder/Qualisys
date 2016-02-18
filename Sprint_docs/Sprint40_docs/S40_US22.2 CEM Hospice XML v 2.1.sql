/*
S40_US22.2 CAHPS - Hospice XML 2.10

user story 22:
As CMS we'd like to change your submission format so that our data is improved.

Tim Butler

Task 22.2 Create new template for the new XSD

Create version 2.1.1 
	* decedent-primary-diagnosis - changes FixedWidthLength to 8, and changes SourceColumnName to 'MMMMMMMM'
	* language - adds Russian and Portuguese
	* cHomeLang - drops Russian and Portuguese but keeps "Some Other Language" recoded to 6, and changes questioncore to 51620

Create version 2.1.2 
	* cHomeLang - adds Russian and Portuguese changes "Some Other Language" Rawvalue to 4, and changes questioncore to 54067

*/
use NRC_DataMart_Extracts
go


-- add template for 2.1.1

declare @oldTemplateID int, @newTemplateID int

select @oldTemplateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.0' and ExportTemplateVersionMinor=2

if not exists (select * from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=1)
begin
	exec [CEM].[CopyExportTemplate] @oldTemplateID
	select @newTemplateID = max(exporttemplateid) from cem.exporttemplate 

	update cem.ExportTemplate 
		set ExportTemplateVersionMajor = '2.1'
		,ExportTemplateVersionMinor = 1
		,CreatedOn = GETDATE()
		,CreatedBy = 'tbutler'
	where ExportTemplateID=@newTemplateID

end

declare @hospicedatasectionid int
declare @caregiverresponsesectionid int
declare @decedentleveldatasectionid int

select @hospicedatasectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'hospicedata'
and ExportTemplateID = @newTemplateID

select @caregiverresponsesectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'caregiverresponse'
and ExportTemplateID = @newTemplateID

select @decedentleveldatasectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'decedentleveldata'
and ExportTemplateID = @newTemplateID


declare @exporttemplatecolumnid int
declare @columnOrder int
declare @RawValue int
declare @RecodeValue varchar(200)
declare @ResponseLabel varchar(200)


/*
	update decedent-primary-diagnosis
*/

Update etc
	SET FixedWidthLength = 8
	,SourceColumnName = 'MMMMMMMM'
from cem.ExportTemplateColumn etc
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'decedent-primary-diagnosis'

/*
	insert Russian and Portuguese to language
*/

select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'language'


if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = 4 and ResponseLabel = 'Russian')
begin
	-- insert Russian
	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @exporttemplatecolumnid, 4, NULL, 4, 'Russian'
end

if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = 5 and ResponseLabel = 'Portuguese')
begin
	-- insert Portuguese
	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @exporttemplatecolumnid, 5, NULL, 5, 'Portuguese'

end


/*
	remove Russian and Portuguese from cHomeLang.  Change Some Other Language rawvalue to 4, but leave recodevalue as 6
*/

select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @caregiverresponsesectionid
and ExportColumnName = 'cHomeLang'

delete
from [CEM].[ExportTemplateColumnResponse]
where ExportTemplateColumnID =@exporttemplatecolumnid
and RawValue = 4 and ResponseLabel = 'Russian'

delete
from [CEM].[ExportTemplateColumnResponse]
where ExportTemplateColumnID =@exporttemplatecolumnid
and RawValue = 5 and ResponseLabel = 'Portuguese'


update [CEM].[ExportTemplateColumnResponse]
	SET RawValue = 4
where ExportTemplateColumnID =@exporttemplatecolumnid
and RawValue = 6 and ResponseLabel = 'Some Other Language'

update [CEM].[ExportTemplateColumn] 
	SET SourceColumnName = 'OriginalQuestionCore = 51620'
where ExportTemplateSectionID = @caregiverresponsesectionid
and ExportTemplateColumnID = @exporttemplatecolumnid



/*
Update the XMLSchemaDefinition in ExportTemplate
*/

Update CEM.ExportTemplate
	SET XMLSchemaDefinition = '<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="vendordata">
    <xs:annotation>
      <xs:documentation>CAHPS Hospice Survey XML File Specification
     Version 01.22.2016

     All data fields are defined as character.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:choice maxOccurs="unbounded" minOccurs="0">
        <xs:element type="xs:string" name="vendor-name"/>
        <xs:element type="xs:string" name="file-submission-yr"/>
        <xs:element type="xs:string" name="file-submission-month"/>
        <xs:element type="xs:string" name="file-submission-day"/>
        <xs:element type="xs:string" name="file-submission-number"/>
        <xs:element name="hospicedata" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="reference-yr"/>
              <xs:element type="xs:string" name="reference-month"/>
              <xs:element type="xs:string" name="provider-name"/>
              <xs:element type="xs:string" name="provider-id"/>
              <xs:element type="xs:string" name="npi"/>
              <xs:element type="xs:string" name="survey-mode"/>
              <xs:element type="xs:string" name="total-decedents"/>
              <xs:element type="xs:string" name="live-discharges"/>
              <xs:element type="xs:string" name="no-publicity"/>
              <xs:element type="xs:string" name="missing-dod"/>
              <xs:element type="xs:string" name="ineligible-presample"/>
              <xs:element type="xs:string" name="sample-size"/>
              <xs:element type="xs:string" name="ineligible-postsample"/>
              <xs:element type="xs:string" name="sample-type"/>
              <xs:element type="xs:string" name="number-offices"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="decedentleveldata" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="reference-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="reference-month" minOccurs="0"/>
              <xs:element type="xs:string" name="provider-name" minOccurs="0"/>
              <xs:element type="xs:string" name="provider-id"/>
              <xs:element type="xs:string" name="decedent-id" minOccurs="0"/>
              <xs:element type="xs:string" name="birth-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="birth-month" minOccurs="0"/>
              <xs:element type="xs:string" name="birth-day" minOccurs="0"/>
              <xs:element type="xs:string" name="death-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="death-month" minOccurs="0"/>
              <xs:element type="xs:string" name="death-day" minOccurs="0"/>
              <xs:element type="xs:string" name="admission-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="admission-month" minOccurs="0"/>
              <xs:element type="xs:string" name="admission-day" minOccurs="0"/>
              <xs:element type="xs:string" name="sex" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-hispanic" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-race" minOccurs="0"/>
              <xs:element type="xs:string" name="caregiver-relationship" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-payer-primary" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-payer-secondary" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-payer-other" minOccurs="0"/>
              <xs:element type="xs:string" name="last-location" minOccurs="0"/>
              <xs:element type="xs:string" name="facility-name" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-primary-diagnosis" minOccurs="0"/>
              <xs:element type="xs:string" name="diagnosis-code-format" minOccurs="0"/>
              <xs:element type="xs:string" name="survey-status" minOccurs="0"/>
              <xs:element type="xs:string" name="survey-completion-mode" minOccurs="0"/>
              <xs:element type="xs:string" name="number-survey-attempts-telephone" minOccurs="0"/>
              <xs:element type="xs:string" name="number-survey-attempts-mail" minOccurs="0"/>
              <xs:element type="xs:string" name="language" minOccurs="0"/>
              <xs:element type="xs:string" name="lag-time" minOccurs="0"/>
              <xs:element type="xs:string" name="supplemental-question-count" minOccurs="0"/>
              <xs:element name="caregiverresponse" minOccurs="0">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element type="xs:string" name="provider-id"/>
                    <xs:element type="xs:string" name="decedent-id"/>
                    <xs:element type="xs:string" name="related"/>
                    <xs:element type="xs:string" name="location-home"/>
                    <xs:element type="xs:string" name="location-assisted"/>
                    <xs:element type="xs:string" name="location-nursinghome"/>
                    <xs:element type="xs:string" name="location-hospital"/>
                    <xs:element type="xs:string" name="location-hospice-facility"/>
                    <xs:element type="xs:string" name="location-other"/>
                    <xs:element type="xs:string" name="oversee"/>
                    <xs:element type="xs:string" name="needhelp"/>
                    <xs:element type="xs:string" name="gethelp"/>
                    <xs:element type="xs:string" name="h_informtime"/>
                    <xs:element type="xs:string" name="helpasan"/>
                    <xs:element type="xs:string" name="h_explain"/>
                    <xs:element type="xs:string" name="h_inform"/>
                    <xs:element type="xs:string" name="h_confuse"/>
                    <xs:element type="xs:string" name="h_dignity"/>
                    <xs:element type="xs:string" name="h_cared"/>
                    <xs:element type="xs:string" name="h_talk"/>
                    <xs:element type="xs:string" name="h_talklisten"/>
                    <xs:element type="xs:string" name="pain"/>
                    <xs:element type="xs:string" name="painhlp"/>
                    <xs:element type="xs:string" name="painrx"/>
                    <xs:element type="xs:string" name="painrxside"/>
                    <xs:element type="xs:string" name="painrxwatch"/>
                    <xs:element type="xs:string" name="painrxtrain"/>
                    <xs:element type="xs:string" name="breath"/>
                    <xs:element type="xs:string" name="breathhlp"/>
                    <xs:element type="xs:string" name="breathtrain"/>
                    <xs:element type="xs:string" name="constip"/>
                    <xs:element type="xs:string" name="constiphlp"/>
                    <xs:element type="xs:string" name="sad"/>
                    <xs:element type="xs:string" name="sadgethlp"/>
                    <xs:element type="xs:string" name="restless"/>
                    <xs:element type="xs:string" name="restlesstrain"/>
                    <xs:element type="xs:string" name="movetrain"/>
                    <xs:element type="xs:string" name="expectinfo"/>
                    <xs:element type="xs:string" name="receivednh"/>
                    <xs:element type="xs:string" name="cooperatehnh"/>
                    <xs:element type="xs:string" name="differhnh"/>
                    <xs:element type="xs:string" name="h_clisten"/>
                    <xs:element type="xs:string" name="cbeliefrespect"/>
                    <xs:element type="xs:string" name="cemotion"/>
                    <xs:element type="xs:string" name="cemotionafter"/>
                    <xs:element type="xs:string" name="ratehospice"/>
                    <xs:element type="xs:string" name="h_recommend"/>
                    <xs:element type="xs:string" name="pEdu"/>
                    <xs:element type="xs:string" name="pLatino"/>
                    <xs:element type="xs:string" name="race-white"/>
                    <xs:element type="xs:string" name="race-african-amer"/>
                    <xs:element type="xs:string" name="race-asian"/>
                    <xs:element type="xs:string" name="race-hi-pacific-islander"/>
                    <xs:element type="xs:string" name="race-amer-indian-ak"/>
                    <xs:element type="xs:string" name="cAge"/>
                    <xs:element type="xs:string" name="cSex"/>
                    <xs:element type="xs:string" name="cEdu"/>
                    <xs:element type="xs:string" name="cHomeLang"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element type="xs:string" name="npi" minOccurs="0"/>
              <xs:element type="xs:string" name="survey-mode" minOccurs="0"/>
              <xs:element type="xs:string" name="total-decedents" minOccurs="0"/>
              <xs:element type="xs:string" name="live-discharges" minOccurs="0"/>
              <xs:element type="xs:string" name="no-publicity" minOccurs="0"/>
              <xs:element type="xs:string" name="missing-dod" minOccurs="0"/>
              <xs:element type="xs:string" name="ineligible-presample" minOccurs="0"/>
              <xs:element type="xs:string" name="sample-size" minOccurs="0"/>
              <xs:element type="xs:string" name="ineligible-postsample" minOccurs="0"/>
              <xs:element type="xs:string" name="sample-type" minOccurs="0"/>
              <xs:element type="xs:string" name="number-offices" minOccurs="0"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:choice>
    </xs:complexType>
  </xs:element>
</xs:schema>'
WHERE ExportTemplateId = @newTemplateID

GO

-- Now add template for 2.1.2

USE NRC_Datamart_Extracts

declare @oldTemplateID int, @newTemplateID int

select @oldTemplateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=1

if not exists (select * from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=2)
begin
	exec [CEM].[CopyExportTemplate] @oldTemplateID
	select @newTemplateID = max(exporttemplateid) from cem.exporttemplate 

	update cem.ExportTemplate 
		set ExportTemplateVersionMajor = '2.1'
		,ExportTemplateVersionMinor = 2
		,CreatedOn = GETDATE()
		,CreatedBy = 'tbutler'
	where ExportTemplateID=@newTemplateID

end

declare @hospicedatasectionid int
declare @caregiverresponsesectionid int
declare @decedentleveldatasectionid int

select @hospicedatasectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'hospicedata'and ExportTemplateID = @newTemplateID

select @caregiverresponsesectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'caregiverresponse'
and ExportTemplateID = @newTemplateID

select @decedentleveldatasectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'decedentleveldata'
and ExportTemplateID = @newTemplateID


declare @exporttemplatecolumnid int
declare @columnOrder int
declare @RawValue int
declare @RecodeValue varchar(200)
declare @ResponseLabel varchar(200)



/*
	insert Russian and Portuguese to cHomeLang
*/

select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @caregiverresponsesectionid
and ExportColumnName = 'cHomeLang'

update [CEM].[ExportTemplateColumn] 
	SET SourceColumnName = 'OriginalQuestionCore = 54067'
where ExportTemplateSectionID = @caregiverresponsesectionid
and SourceColumnName = 'OriginalQuestionCore = 51620'

	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @exporttemplatecolumnid, 4, NULL, 4, 'Russian'

	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @exporttemplatecolumnid, 5, NULL, 5, 'Portuguese'

	update [CEM].[ExportTemplateColumnResponse]
	SET RawValue = 6
	where ExportTemplateColumnID =@exporttemplatecolumnid
	and RecodeValue = 6 and ResponseLabel = 'Some Other Language'



GO

USE [NRC_Datamart_Extracts]
GO

if exists (select * from sys.procedures where name = 'ExportPostProcess00000000')
	drop PROCEDURE [CEM].[ExportPostProcess00000000]

GO
CREATE PROCEDURE [CEM].[ExportPostProcess00000000]
@ExportQueueID int
as
/* includes changes for xml version 2.1 as per S40 US22  TSB 01/13/2016 */
update eds
set [decedentleveldata.sex] = case [decedentleveldata.sex] when 'M' then '1' when 'F' then '2' else 'M' end
from CEM.ExportDataset00000000 eds
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
from CEM.ExportDataset00000000 eds
inner join nrc_datamart.dbo.samplepopulationdispositionlog spdl on spdl.SamplePopulationID=eds.SamplePopulationID
inner join nrc_datamart.dbo.CahpsDispositionMapping cdm on cdm.dispositionid=spdl.DispositionID and [decedentleveldata.survey-status]=(cdm.CahpsDispositionID-600)
where ltrim([decedentleveldata.survey-status]) in ('2','3','4','5','8','12','13','14')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) in (1,7) then 'QuestionForm.ReturnDate'
--	   end
--, qf.returndate
from CEM.ExportDataset00000000 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) in ('1','7') 
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 6 then 'QuestionForm.ReturnDate OR SamplePopulationDispositionLog.LoggedDate'
--	   end
--, qf.returndate
--, [caregiverresponse.oversee], [decedentleveldata.survey-completion-mode]
from CEM.ExportDataset00000000 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) = '6' 
and eds.ExportQueueID = @ExportQueueID 

if object_id('tempdb..#SampleSetExpiration') is not null
	drop table #SampleSetExpiration
select distinct ss.samplesetid, eds.samplepopulationid, dateadd(day,42,ss.datFirstMailed) as DatExpire
into #SampleSetExpiration
from CEM.ExportDataset00000000 eds
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
from CEM.ExportDataset00000000 eds
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
from CEM.ExportDataset00000000 eds
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
from CEM.ExportDataset00000000 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID=5--Non Response Bad Address / 16--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '10' -- bad address     / 11 -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.LoggedDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.LoggedDate)) as lagtime
from CEM.ExportDataset00000000 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID in (14,16)--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '11' -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 

-- There�s one hospice that we messed up sampling for January & February data.
-- Delete all January and February data out of the file for CCN 031592.
delete 
from CEM.ExportDataset00000000 
where [hospicedata.provider-id]='031592'
and [hospicedata.reference-yr]='2015'
and [hospicedata.reference-month] in ('01','02')
and ExportQueueID = @ExportQueueID 

-- Saint Mary�s Hospice and Palliative Care (ccn 291501) has six people we sampled in January but shouldn't have, so we're not submiting any of their january data.
delete eds
from cem.ExportDataset00000000 eds
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
from cem.ExportDataset00000000 eds
where [hospicedata.no-publicity]=''
and [hospicedata.provider-id]+'.'+[hospicedata.reference-month] in ('141613.03','451662.01','451662.02','451662.03','521544.03')
and [hospicedata.reference-yr]='2015'
and ExportQueueID = @ExportQueueID

-- delete the following months for the following CCNs - we have good March data for them and aren't submitting January or February
	--provider-name									provider-id	reference-yr	reference-month
	--Saint Mary�s Hospice and Palliative Care 		291501		2015			2
	--St. Joseph Hospice-Baton Rouge/TCH			191568		2015			1
	--St. Joseph Hospice-Baton Rouge/TCH			191568		2015			2
	--St. Joseph Hospice-Biloxi/Hattiesburg/Picayun	251670		2015			1
	--St. Joseph Hospice-Biloxi/Hattiesburg/Picayun	251670		2015			2
	--St. Joseph Hospice-Richland/Vicksburg			251575		2015			1
	--St. Joseph Hospice-Richland/Vicksburg			251575		2015			2
delete eds
from cem.ExportDataset00000000 eds
where ExportQueueID = @ExportQueueID 
and [hospicedata.reference-yr]='2015'
and [hospicedata.provider-id] in ('291501','191568','251670','251575')
and [hospicedata.reference-month] in ('01','02')

-- Number of decedents/caregivers in the sample for the month with a �Final Survey Status� code of:  
-- �3 � Ineligible: Not in Eligible Population,� 
-- �6 � Ineligible: Never Involved in Decedent Care,� and 
-- �14 � Ineligible: Institutionalized.�
update cem.ExportDataset00000000 
set [hospicedata.ineligible-postsample]='0'
where ExportQueueID=@ExportQueueID 

update eds
set [hospicedata.ineligible-postsample]=sub.cnt
from cem.ExportDataset00000000 eds
inner join (select [hospicedata.provider-id],[hospicedata.reference-month], count(*) cnt
			from cem.ExportDataset00000000
			where ExportQueueID=@ExportQueueID 
			and ltrim([decedentleveldata.survey-status]) in ('2','3','4','5','6','14') --(v2.1)
			group by [hospicedata.provider-id], [hospicedata.reference-month]) sub
	on eds.[hospicedata.provider-id]=sub.[hospicedata.provider-id] and eds.[hospicedata.reference-month]=sub.[hospicedata.reference-month]
where eds.ExportQueueID=@ExportQueueID 

-- recode various blank columns to 'M' or 'N/A'
update cem.ExportDataset00000000 set [decedentleveldata.decedent-primary-diagnosis]='MMMMMMMM' where [decedentleveldata.decedent-primary-diagnosis]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [decedentleveldata.decedent-payer-primary]='M' where [decedentleveldata.decedent-payer-primary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [decedentleveldata.decedent-payer-secondary]='M' where [decedentleveldata.decedent-payer-secondary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [decedentleveldata.decedent-payer-other]='M' where [decedentleveldata.decedent-payer-other]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [decedentleveldata.last-location]='M' where [decedentleveldata.last-location]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [decedentleveldata.decedent-race]='M' where [decedentleveldata.decedent-race]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [decedentleveldata.facility-name]='N/A' where [decedentleveldata.facility-name]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000000 set [hospicedata.no-publicity]='M' where [hospicedata.no-publicity]='' and ExportQueueid=@ExportQueueID

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
from [CEM].[ExportDataset00000000] eds
where eds.exportqueueid=@ExportQueueID

select distinct MedicareNumber, FacilityName, convert(char(10), NULL) as NPI
into #CCN
from nrc_datamart.dbo.SampleUnitFacilityAttributes 
where AHAIdent=1

update #ccn set NPI='M'

update ccn
set npi=[hospicedata.NPI]
from #ccn ccn
inner join [CEM].[ExportDataset00000000] eds on ccn.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueid=@ExportQueueID

select *
into #everything
from #months m, #ccn c

delete e
from #everything e
inner join [CEM].[ExportDataset00000000] eds 
	on e.[hospicedata.reference-yr]=eds.[hospicedata.reference-yr]
		and e.[hospicedata.reference-month]=eds.[hospicedata.reference-month]
		and e.MedicareNumber=eds.[hospicedata.provider-id]
where eds.ExportQueueID=@ExportQueueID

insert into [CEM].[ExportDataset00000000] ([ExportQueueID], [ExportTemplateID], [FileMakerName], [vendordata.vendor-name], [vendordata.file-submission-yr], [vendordata.file-submission-month], [vendordata.file-submission-day]
	, [vendordata.file-submission-number], [hospicedata.reference-yr], [hospicedata.reference-month], [hospicedata.provider-name], [hospicedata.provider-id], [hospicedata.npi], [hospicedata.survey-mode], [hospicedata.total-decedents]
	, [hospicedata.live-discharges], [hospicedata.no-publicity], [hospicedata.ineligible-presample], [hospicedata.sample-size], [hospicedata.ineligible-postsample], [hospicedata.sample-type])
select distinct eds.[ExportQueueID], eds.[ExportTemplateID], eds.[FileMakerName], eds.[vendordata.vendor-name], eds.[vendordata.file-submission-yr], eds.[vendordata.file-submission-month], eds.[vendordata.file-submission-day]
	, eds.[vendordata.file-submission-number], e.[hospicedata.reference-yr], e.[hospicedata.reference-month], left(e.FacilityName,100), e.MedicareNumber, e.NPI, '8' as [hospicedata.survey-mode], char(7) as [hospicedata.total-decedents]
	, char(7) as [hospicedata.live-discharges], char(7) as [hospicedata.no-publicity], char(7) as [hospicedata.ineligible-presample], '0' as [hospicedata.sample-size], '0' as [hospicedata.ineligible-postsample], '8' as [hospicedata.sample-type]
from [CEM].[ExportDataset00000000] eds, #everything e
where eds.ExportQueueID=@ExportQueueID

-- recode blank NPI's to 'M'
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000000 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.npi]=''

-- recode NPI to 'M' for any CCN that has multiple NPI values
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000000 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.provider-id] in (select [hospicedata.provider-id]
									from CEM.ExportDataset00000000 eds
									where eds.ExportQueueID = @ExportQueueID 
									group by [hospicedata.provider-id]
									having count(distinct [hospicedata.npi])>1)

update cem.ExportDataset00000000 
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

update cem.ExportDataset00000000 
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
select @sql=@sql+'update cem.ExportDataset00000000 set [caregiverresponse.'+etc.exportcolumnname+']=''M'' '+
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
from CEM.ExportDataset00000000 eds
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
from cem.ExportDataset00000000 eds 
where LEN(ltrim(rtrim([decedentleveldata.icd9]))) > 0
and eds.ExportQueueID = @ExportQueueID

update eds 
	set [decedentleveldata.diagnosis-code-format] ='2',
	[decedentleveldata.decedent-primary-diagnosis] =  ltrim(rtrim([decedentleveldata.icd10]))
from cem.ExportDataset00000000 eds 
where LEN(ltrim(rtrim([decedentleveldata.icd10]))) > 0 
and eds.ExportQueueID = @ExportQueueID

-- if icd10 code is a z code, then mark as missing
update eds 
	set [decedentleveldata.decedent-primary-diagnosis] =  'MMMMMMMM'
from cem.ExportDataset00000000 eds 
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
from [NRC_Datamart_Extracts].[CEM].[ExportDataset00000000] eds
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
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000000] eds
inner join (select [provider-id], yr, mo, sum(missingcount) as missingcount
			from #MissingDODCounts
			group by [provider-id], yr, mo) mdc on mdc.[provider-id] = eds.[hospicedata.provider-id] and mdc.yr = eds.[hospicedata.reference-yr] and mdc.mo = eds.[hospicedata.reference-month]
where eds.ExportQueueID = @ExportQueueID

update eds
SET [hospicedata.missing-dod] = 0
FROM [NRC_Datamart_Extracts].[CEM].[ExportDataset00000000] eds
where eds.ExportQueueID = @ExportQueueID
and [hospicedata.missing-dod] is NULL

drop table #SampleSets
drop table #MissingDODCounts


GO

declare @templateID int

select @templateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=1

declare @sql nvarchar(max)
select @sql=definition
from sys.sql_modules
where object_name(object_id)='ExportPostProcess00000000'

set @sql = replace(@sql, right('00000000',8), right(convert(varchar,@templateID+100000000),8))

if exists(select * from sys.procedures where name = 'ExportPostProcess'+right(convert(varchar,@templateID+100000000),8))
	set @SQL = replace(@SQL,'CREATE PROCEDURE','ALTER PROCEDURE')

EXECUTE dbo.sp_executesql @SQL


GO

declare @templateID int

select @templateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=2

declare @sql nvarchar(max)
select @sql=definition
from sys.sql_modules
where object_name(object_id)='ExportPostProcess00000000'

set @sql = replace(@sql, right('00000000',8), right(convert(varchar,@templateID+100000000),8))

if exists(select * from sys.procedures where name = 'ExportPostProcess'+right(convert(varchar,@templateID+100000000),8))
	set @SQL = replace(@SQL,'CREATE PROCEDURE','ALTER PROCEDURE')

EXECUTE dbo.sp_executesql @SQL


GO

if exists (select * from sys.procedures where name = 'ExportPostProcess00000000')
	drop PROCEDURE [CEM].[ExportPostProcess00000000]

GO