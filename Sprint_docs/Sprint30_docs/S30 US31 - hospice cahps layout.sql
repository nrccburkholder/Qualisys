/*
	S29 US31	Hospice CAHPS submission file prep
				As a hospice CAHPS vendor we need to submit data to specifications for Hospice CAHPS  

	31.3	create a CEM template

Dave Gilsdorf

NRC_Datamart_Extacts:
insert into cem.Datasource 
insert into cem.ExportTemplate
insert into cem.ExportTemplateSection
insert into cem.ExportTemplateColumn
insert into cem.ExportTemplateResponse
*/
go
use NRC_Datamart_Extracts
go
if not exists (select * from cem.Datasource where tablealias='n/a')
begin
	set identity_insert cem.datasource on
	insert into cem.Datasource (DatasourceID, HorizontalVertical,TableName,TableAlias,ForeignKeyField)
	values (0, '', '<literal>', 'n/a', '')
	set identity_insert cem.datasource off
end
if not exists (select * from cem.Datasource where tablealias='sufa')
	insert into cem.Datasource (HorizontalVertical,TableName,TableAlias,ForeignKeyField)
	values ('H', 'NRC_Datamart.dbo.SampleUnitFacilityAttributes', 'sufa', 'SampleUnitID')
go
if exists (	select object_name(object_id), * 
			from sys.columns sc
			where name = 'rawvalue'
			and object_name(object_id)='ExportTemplateColumnResponse'
			and system_type_id<>56)
	alter table cem.ExportTemplateColumnResponse ALTER COLUMN RawValue int --varchar(200)
go
if object_id('tempdb..#layout') is not null drop table #layout
if object_id('tempdb..#response') is not null drop table #response
if object_id('tempdb..#cols') is not null drop table #cols
go
create table #layout (row_id int identity(1,1),
XMLElement varchar(510),	Attributes varchar(10),	Description varchar(470),	ValidValues varchar(670),	DataType varchar(30),	MaxFieldSize varchar(10),	DataElementRequired varchar(190),	Catalystfield varchar(100),	Notes varchar(300))
insert into #layout values ('<vendordata>|Opening Tag, defines a submission by the survey vendor','None','N/A','N/A','NA','N/A','Yes','','Ask CMS: What attributes? xmlns?')
insert into #layout values ('<vendor-name>|Sub-element of vendordata','None','The name of the survey vendor.','Must be vendor''s business name up to 100 alphanumeric characters.','Alphanumeric Character','100','Yes','','Hard code, or store somewhere?')
insert into #layout values ('<file-submission-yr>|Sub-element of vendordata','None','The year in which the file is submitted.','YYYY|YYYY = (2015 or greater)|(cannot be 9999)','Numeric','4','Yes','year(now())','Make sure file will be created & submitted on same day')
insert into #layout values ('<file-submission-month>|Sub-element of vendordata','None','The month in which the file is submitted.','MM|MM = (1-12)|(cannot be 00, 13 - 99)','Numeric','2','Yes','month(now())','Make sure file will be created & submitted on same day')
insert into #layout values ('<file-submission-day>|Sub-element of vendordata','None','The day in which the file is submitted.','DD|DD = (1-31)|(cannot be 00, 32 - 99)','Numeric','2','Yes','day(now())','Make sure file will be created & submitted on same day')
insert into #layout values ('<file-submission-number>|Sub-element of vendordata','None','Ordinal number of the submission for the day.  The submission count re-starts with every new day of the file submission.','1 - 99','Numeric','2','Yes','','Need to think about how to do this. What about files w/ errors/warnings?')
insert into #layout values ('</vendordata>    |Closing tag for vendordata ','0','0','0','0','0','0','','Ask CMS: This element should actually be at the end of the file, so ignore this one?')
--insert into #layout values ('The following section defines the format of the Hospice Record. There should be one hospicedata record for each month of the survey.','','','','','','','','')
insert into #layout values ('<hospicedata>|Opening Tag, defines the hospice record of monthly sample data. There must be a separate hospicedata group for each month from which decedents/caregivers were sampled.  ','None','N/A','N/A','NA','N/A','Yes','','Ask CMS: confirm there can be >1 hospicedata section')
insert into #layout values ('<reference-yr>|Sub-element of hospicedata','None','The year for which decedent counts were collected.','YYYY|YYYY = (2015 or greater)|(cannot be 9999)','Numeric','4','Yes','year(ServiceDate) from samplepopulation','encounter year - could be from date param sent to pull data')
insert into #layout values ('<reference-month>|Sub-element of hospicedata','None','The month for which decedents counts were collected.','MM|MM = (1-12)|(cannot be 00, 13 - 99)','Numeric','2','Yes','month(ServiceDate) from samplepopulation','encounter month - could be from date param sent to pull data')
insert into #layout values ('<provider-name>|Sub-element of hospicedata','None','The name of the hospice represented by the survey.','N/A','Alphanumeric Character','100','Yes','SampleUnitFacilityAttributes.FacilityName','Look up by SampleUnitID')
insert into #layout values ('<provider-id>|Sub-element of hospicedata','None','The ID number/CCN of the hospice represented by the survey.','Valid 6-digit CMS Certification Number (formerly known as Medicare Provider Number)','Alphanumeric Character','10','Yes','SampleUnitFacilityAttributes.MedicareNumber','Look up by SampleUnitID')
insert into #layout values ('<npi>|Sub-element of hospicedata','None','The National Provider Identifier (NPI) of the hospice represented by the survey.','Valid 10 digit National Provider Identifier.|M - Missing','Numeric','10','No','samplepopulationbackgroundfield.ColumnValue |where columnname = ''NPI''','Ask CMS: What about >1 NPI for 1 CCN?')
insert into #layout values ('<survey-mode>|Sub-element of hospicedata','None','The mode of survey administration.|The survey mode must be the same for all three months within a quarter. ','1 - Mail Only|2 - Telephone Only|3 - Mixed Mode','Alphanumeric Character','1','Yes','sampleset.StandardMethodologyID','Are these the Qualisys IDs? Can''t find a lookup table in Catalyst.|Assume will need to be recoded.')
insert into #layout values ('<total-decedents>|Sub-element of hospicedata','None','The total number of decedents in the hospice in the month, including “no-publicity” decedents/caregivers.','N/A','Numeric','10','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_NumDecd''','Should be the same for all samplepops|What if it''s not?')
insert into #layout values ('<live-discharges>|Sub-element of hospicedata','None','The number of patients who were discharged alive during the month.','N/A','Numeric','10','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_NumLiveDisch''','Should be the same for all samplepops|What if it''s not?')
insert into #layout values ('<no-publicity>|Sub-element of hospicedata','None','The number of “no publicity” decedents/caregivers during the month who were excluded from the file.','N/A','Numeric','10','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_NumNoPub''','Should be the same for all samplepops|What if it''s not?')
insert into #layout values ('<ineligible-presample>|Sub-element of hospicedata','None','The number of decedents/caregivers determined to be ineligible for the month, prior to sampling, for any of the following reasons:|1. Decedent was under the age of 18|2. Decedent’s death was less than 48 hours following last admission to hospice care |3. Decedent has no caregiver of record|4. Decedent’s caregiver is a non-familial legal guardian|5. Decedent’s caregiver has an address outside the U.S. or U.S. Territories','N/A','Numeric','10','Yes','sampleset.ineligiblecount','How does IneligibleCount in sampleset get populated?')
insert into #layout values ('<sample-size>|Sub-element of hospicedata','None','The number of eligible decedents/caregivers drawn into the sample for survey administration. ','N/A','Numeric','10','Yes','SamplePopulation.count(distinct samplepopulationid)','count of records in selectedsample?|select count(*) |from sampleset sst, SamplePopulation sp, SelectedSample ss|where sst.samplesetid = sp.samplesetid|and sp.samplepopulationid = ss.samplepopulationid|AND sst.SampleSetID = 182206217|and ss.SampleUnitID = 177126720')
insert into #layout values ('<ineligible-postsample>|Sub-element of hospicedata','None','Number of decedents/caregivers in the sample for the month with a “Final Survey Status” code of: “3 – Ineligible: Not in Eligible Population,” “6 – Ineligible: Never Involved in Decedent Care,” and  “14 – Ineligible: Institutionalized.”','N/A','Numeric','10','Yes','','count of records w/ samplepopulation.CAHPSDispositionID in (603, 606, 614)')
insert into #layout values ('<sample-type>|Sub-element of hospicedata','None','The sample type must be the same for all three months within a quarter.','1 - Simple Random Sample|2 - Census Sample','Numeric','1','Yes','sampleset.SamplingMethodID','How does sampleset.SamplingMethodID get populated? Is that the right field? It''s qp_prod..PeriodDef.SamplingMethod_id')
insert into #layout values ('</hospicedata>       |Closing tag for hospicedata ','0','0','0','0','0','0','','')
--insert into #layout values ('The following section defines the format of the Decedent/Caregiver Administrative Record. ','','','','','','','','')
insert into #layout values ('<decedentleveldata>|Opening Tag, defines the decedent level data record of monthly survey data','None','N/A','N/A','NA','N/A','Yes','','')
insert into #layout values ('<provider-id>|Sub-element of decedentleveldata','None','The ID number (CCN) of the hospice represented by the survey.','Valid 6-digit CMS Certification Number (formerly known as Medicare Provider Number)','Alphanumeric Character','10','Yes','SampleUnitFacilityAttributes.MedicareNumber','Look up by SampleUnitID')
insert into #layout values ('<decedent-id>|Sub-element of decedentleveldata','None','The unique de-identified decedent/caregiver ID assigned by the survey vendor to uniquely identify the survey.','N/A','Alphanumeric Character','16','Yes','samplepopulation.SamplePopulationID','consider impact of eventual move to EFS Reporting DB; these need to be unique across time')
insert into #layout values ('<birth-yr>|Sub-element of decedentleveldata','None','The year the decedent was born as provided by the hospice.','YYYY|(cannot be 9999)|Use 8888 only if unable to obtain information by the data submission due date.','Numeric','4','Yes','year(columnvalue) from samplepopulationbackgroundfield where columnname = ''dob''','')
insert into #layout values ('<birth-month>|Sub-element of decedentleveldata','None','The month the decedent was born as provided by the hospice.','MM|MM = (1-12)|(cannot be 00, 13 - 99)|Use 88 only if unable to obtain information by the data submission due date.','Numeric','2','Yes','month(columnvalue) from samplepopulationbackgroundfield where columnname = ''dob''','')
insert into #layout values ('<birth-day>|Sub-element of decedentleveldata','None','The day the decedent was born as provided by the hospice.','DD|DD = (1-31)|(cannot be 00, 32 - 99)|Use 88 only if unable to obtain information by the data submission due date.','Numeric','2','Yes','day(columnvalue) from samplepopulationbackgroundfield where columnname = ''dob''','')
insert into #layout values ('<death-yr>|Sub-element of decedentleveldata','None','The year the decedent died as provided by the hospice.','YYYY|YYYY = (2015 or greater)|(cannot be 9999)','Numeric','4','Yes','year(servicedate) from samplepopulation','')
insert into #layout values ('<death-month>|Sub-element of decedentleveldata','None','The month the decedent died as provided by the hospice.','MM|MM = (1-12)|(cannot be 00, 13 - 99)','Numeric','2','Yes','month(servicedate) from samplepopulation','')
insert into #layout values ('<death-day>|Sub-element of decedentleveldata','None','The day the decedent died as provided by the hospice.','DD|DD = (1-31)|(cannot be 00, 32 - 99)','Numeric','2','Yes','day(servicedate) from samplepopulation','')
insert into #layout values ('<admission-yr>|Sub-element of decedentleveldata','None','The year the decedent was admitted for final episode of hospice care as provided by the hospice.','YYYY|YYYY = (2014 or later)|(cannot be 9999)','Numeric','4','Yes','year(admitdate) from samplepopulation','')
insert into #layout values ('<admission-month>|Sub-element of decedentleveldata','None','The month the decedent was admitted for final episode of hospice care as  provided by the hospice.','MM|MM = (1-12)|(cannot be 00, 13 - 99)','Numeric','2','Yes','month(admitdate) from samplepopulation','')
insert into #layout values ('<admission-day>|Sub-element of decedentleveldata','None','The day the decedent was admitted for final episode of hospice care as provided by the hospice.','DD|DD = (1-31)|(cannot be 00, 32 - 99)','Numeric','2','Yes','day(admitdate) from samplepopulation','')
insert into #layout values ('<sex>|Sub-element of decedentleveldata','None','The decedent''s sex as provided by the hospice.','1 - Male|2 - Female|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_DECDSEX''','')
insert into #layout values ('<decedent-hispanic>|Sub-element of decedentleveldata','None','The indication whether on not decedent was Hispanic as provided by the hospice.','1 - Hispanic|2 - Non-Hispanic|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_DECDHISP''','')
insert into #layout values ('<decedent-race>|Sub-element of decedentleveldata','None','The decedent''s race as provided by the hospice.','1 - White|2 - Black or African American|3 - Asian|4 - Native Hawaiian or Pacific Islander|5 - American Indian or Alaska Native|6 - More than one race|7 - Other|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_DECDRACE''','')
insert into #layout values ('<caregiver-relationship>|Sub-element of decedentleveldata','None','The caregiver relationship to the decedent as provided by the hospice.','1 - Spouse/partner|2 - Parent|3 - Child|4 - Other family member|5 - Friend|6 - Legal guardian|7 - Other|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_CAREGIVERREL''','')
insert into #layout values ('<decedent-payer-primary>|Sub-element of decedentleveldata','None','The decedent''s primary payer for healthcare services as provided by the hospice. ','1 - Medicare|2 - Medicaid|3 - Private|4 - Uninsured/no payer|5 - Program for All Inclusive Care for the Elderly (PACE)|6 - Other|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_PAYER1''','')
insert into #layout values ('<decedent-payer-secondary>|Sub-element of decedentleveldata','None','The decedent''s secondary payer for healthcare services as provided by the hospice.','1 - Medicare|2 - Medicaid|3 - Private|4 - Uninsured/no payer|5 - Program for All Inclusive Care for the Elderly (PACE)|6 - Other|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_PAYER2''','')
insert into #layout values ('<decedent-payer-other>|Sub-element of decedentleveldata','None','The decedent''s other payer for healthcare services as provided by the hospice.','1 - Medicare|2 - Medicaid|3 - Private|4 - Uninsured/no payer|5 - Program for All Inclusive Care for the Elderly (PACE)|6 - Other|M - Missing','Alphanumeric Character','1','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_PAYER3''','')
insert into #layout values ('<last-location>|Sub-element of decedentleveldata','None','The decedent''s last location/setting of hospice care as provided by the hospice.|','1 - Home|2 - Assisted living|3 - Long-term care facility or non-skilled nursing facility|4 - Skilled nursing facility|5 - Inpatient hospital|6 - Inpatient hospice facility|7 - Long-term care facility|8 - Inpatient psychiatric facility|9 - Location not otherwise specified|10 - Hospice facility|M - Missing','Alphanumeric Character','2','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''HSP_LASTLOC''','')
insert into #layout values ('<facility-name>|Sub-element of decedentleveldata','None','The name of the assisted living facility, nursing home, hospital, or hospice facility/hospice house, if applicable (optional).','Facility name up to 100 alphanumeric characters.|N/A = Missing/Not applicable','Alphanumeric Character','100','No','samplepopulationbackgroundfield.ColumnValue |where columnname = ''FACILITYNAME''','')
insert into #layout values ('<decedent-primary-diagnosis>|Sub-element of decedentleveldata','None','The decedent''s primary diagnosis provided by the hospice, including decimal points and leading zeros (when applicable)','ICD-9 code for the primary diagnosis of the decedent. (ICD-10 codes anticipated to be implemented October 1, 2015) ','Alphanumeric Character','7','Yes','samplepopulationbackgroundfield.ColumnValue |where columnname = ''ICD9''','Column Name will be ''ICD10_1'' starting w/ October 2015 service dates')
insert into #layout values ('<survey-status>|Sub-element of decedentleveldata','None','The disposition of the survey.','1 - Completed Survey|2 - Ineligible: Deceased|3 - Ineligible: Not in Eligible Population|4 - Ineligible: Language Barrier|5 - Ineligible: Mental/Physical Incapacity|6 - Ineligible: Never Involved in Decedent Care|7 - Non-response: Break-off|8 - Non-response: Refusal|9 - Non-response: Non-response after Maximum Attempts|10 - Non-response: Bad Address|11 - Non-response: Bad/No Telephone Number|12 - Non-response: Incomplete Caregiver Name|13 - Non-response: Incomplete Decedent Name |14 - Ineligible: Institutionalized|33 - No response collected (used only for interim data file submission)|M - Missing','Alphanumeric Character','2','Yes','samplepopulation.CAHPSDispositionID','Have to remove leading "6" from value in Catalyst')
insert into #layout values ('<survey-completion-mode>|Sub-element of decedentleveldata','None','The survey mode used to complete a survey administered via the Mixed Mode.','1 - Mixed Mode-mail|2 - Mixed Mode-phone|88 - Not Applicable','Numeric','2','No, required only if survey mode is Mixed  and Survey Status is “1 – Completed Survey,” “6 – Ineligible: Never Involved in Decedent Care” or “7 – Non-response: Break-off.”','QuestionForm.ReceiptTypeID','look up by SamplepopID')
insert into #layout values ('<number-survey-attempts-telephone>|Sub-element of decedentleveldata','None','The number of telephone contact attempts per survey with a survey mode of Telephone Only or Mixed Mode.','1 - First Telephone Attempt|2 - Second Telephone Attempt|3 - Third Telephone Attempt|4 - Fourth Telephone Attempt|5 - Fifth Telephone Attempt|88 - Not Applicable','Numeric','2','No, conditionally required only if the survey mode is Telephone Only Mode or Mixed Mode with survey completion mode: “2 –  Mixed Mode-phone.” ','SamplePopulation.NumberOfPhoneAttempts','Is this anywhere in Catalyst?')
insert into #layout values ('<number-survey-attempts-mail>|Sub-element of decedentleveldata','None','The mail wave for which “Final Survey Status” code is determined per survey with a survey mode of Mail Only.','1 - First Wave Mailing|2 - Second Wave Mailing|88 - Not Applicable','Numeric','2','No, conditionally required only if the survey mode is Mail Only.','SamplePopulation.NumberOfMailAttempts','Is this anywhere in Catalyst?')
insert into #layout values ('<language>|Sub-element of decedentleveldata','None','The survey language in which the survey was administered (English, Spanish, Chinese).','1 - English|2 - Spanish|3 - Chinese|88 - Not Applicable','Numeric','2','Yes','SamplePopulation.LanguageID','Need to recode')
insert into #layout values ('<lag-time>|Sub-element of decedentleveldata','None','The number of days between decedent date of death and the date that data collection activities ended for the decedent/caregiver.',' 0-365|888 - Not Applicable                      (use only for interim data file submission)','Numeric','3','Yes','See Lag Time Definitions tab','Calculated.')
insert into #layout values ('<supplemental-question-count>  |Sub-element of decedentleveldata','None','A count of supplemental questions added to the questionnaire.','0-15|M - Missing','Alphanumeric Character','2','No. Required only if “Final Survey Status” is “1 – Completed Survey,” “6 – Ineligible: Never Involved in Decedent Care” or “7 – Non-response: Break-off.”','Samplepopulation.SupplementalQuestionCount','')
insert into #layout values ('<service-date>|Sub-element of decedentleveldata','None','the date used to determin which records will be included in the file. Not actually part of the exported XML data.','date','date','10','Yes','ServiceDate from samplepopulation','')
--insert into #layout values ('The following section defines the format of the Survey Results Record (caregiver response).|Note: Survey Results Records (caregiver response) are not required for a valid data submission; however, if survey results are included then all fields must have an entry. Survey Results Record (caregiver response) is required if the final <survey-status> is "1 - Completed survey," "6 - Ineligible: Never Involved in Decedent Care," or "7 - Non-response: Break-off."|','','','','','','','','')
insert into #layout values ('<caregiverresponse>|Opening Tag, defines the decedent response data record within the caregiver level data record of monthly survey data','None','N/A','N/A','NA','N/A','Yes','','')
insert into #layout values ('<provider-id>|Sub-element of caregiverresponse','None','The ID number-CCN of the hospice represented by the survey.3','Valid 6-digit CMS Certification Number (formerly known as Medicare Provider Number).','Alphanumeric Character','10','Yes','SampleUnitFacilityAttributes.MedicareNumber','')
insert into #layout values ('<decedent-id>|Sub-element of caregiverresponse','None','The unique de-identified decedent/caregiver ID assigned by the hospice to uniquely identify the survey.','N/A','Alphanumeric Character','16','Yes','samplepopulation.SamplePopulationID','consider impact of eventual move to EFS Reporting DB; these need to be unique across time')
insert into #layout values ('<related>|Sub-element of caregiverresponse','None','Question 1: Related.','1 - My spouse or partner|2 - My parent|3 - My mother-in-law or father-in-law|4 - My grandparent|5 - My aunt or uncle |6 - My sister or brother|7 - My child|8 - My friend|9 - Other|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51574','Recode -9 = "M"')
insert into #layout values ('<location-home>|Sub-element of caregiverresponse','None','Question 2: Location: at home.','1 - Home|0 - Not home|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51575 AND ResponseBubble.ResponseValue = 1','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<location-assisted>|Sub-element of caregiverresponse','None','Question 2: Location: assisted living facility.','1 - Assisted living facility|0 - Not assisted living facility|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51575 AND ResponseBubble.ResponseValue = 2','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<location-nursinghome>|Sub-element of caregiverresponse','None','Question 2: Location: nursing home.','1 - Nursing home|0 - Not nursing home|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51575 AND ResponseBubble.ResponseValue = 3','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<location-hospital>|Sub-element of caregiverresponse','None','Question 2: Location: hospital.','1 - Hospital|0 - Not hospital|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51575 AND ResponseBubble.ResponseValue = 4','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<location-hospice-facility>|Sub-element of caregiverresponse','None','Question 2: Location: hospice facility/hospice house.','1 - Hospice facility/hospice house|0 - Not hospice facility/hospice house|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51575 AND ResponseBubble.ResponseValue = 5','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<location-other>|Sub-element of caregiverresponse','None','Question 2: Location: other.','1 - Other|0 - Not other|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51575 AND ResponseBubble.ResponseValue = 6','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<oversee>|Sub-element of caregiverresponse','None','Question 3: Oversee.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51576','Recode -9 = "M"')
insert into #layout values ('<needhelp>|Sub-element of caregiverresponse','None','Question 4: Need help.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51577','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<gethelp>|Sub-element of caregiverresponse','None','Question 5: Get help.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51578','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_informtime>|Sub-element of caregiverresponse','None','Question 6: Hospice inform.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51579','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<helpasan>|Sub-element of caregiverresponse','None','Question 7: Help as soon as need.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51580','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_explain>|Sub-element of caregiverresponse','None','Question 8: Hospice explain.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51581','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_inform>|Sub-element of caregiverresponse','None','Question 9: Hospice inform.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51582','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_confuse>|Sub-element of caregiverresponse','None','Question 10: Hospice confuse.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51583','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_dignity>|Sub-element of caregiverresponse','None','Question 11: Hospice dignity.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51584','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_cared>|Sub-element of caregiverresponse','None','Question 12: Hospice cared.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51585','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_talk>|Sub-element of caregiverresponse','None','Question 13: Hospice talk.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51586','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_talklisten>|Sub-element of caregiverresponse','None','Question 14: Hospice talk and listen.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51587','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<pain>|Sub-element of caregiverresponse','None','Question 15: Pain.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51588','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<painhlp>|Sub-element of caregiverresponse','None','Question 16: Pain help.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51589','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<painrx>|Sub-element of caregiverresponse','None','Question 17: Pain medicine.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51590','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<painrxside>|Sub-element of caregiverresponse','None','Question 18: Pain medication info.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51591','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<painrxwatch>|Sub-element of caregiverresponse','None','Question 19: Pain medicine watch.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51592','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<painrxtrain>|Sub-element of caregiverresponse','None','Question 20: Pain medicine train.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|4 - I did not need to give pain medicine to my family member|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51593','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<breath>|Sub-element of caregiverresponse','None','Question 21: Breath.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51594','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<breathhlp>|Sub-element of caregiverresponse','None','Question 22: Breath help.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51595','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<breathtrain>|Sub-element of caregiverresponse','None','Question 23: Breath train.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|4 - I did not need to help my family member with trouble breathing','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51596','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<constip>|Sub-element of caregiverresponse','None','Question 24: Constipation.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51597','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<constiphlp>|Sub-element of caregiverresponse','None','Question 25: Constipation help.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51598','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<sad>|Sub-element of caregiverresponse','None','Question 26: Sad.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51599','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<sadgethlp>|Sub-element of caregiverresponse','None','Question 27: Sad get help.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51600','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<restless>|Sub-element of caregiverresponse','None','Question 28: Restless.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51601','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<restlesstrain>|Sub-element of caregiverresponse','None','Question 29: Restless train.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51602','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<movetrain>|Sub-element of caregiverresponse','None','Question 30: Move train.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|4 - I did not need to move my family member|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51603','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<expectinfo>|Sub-element of caregiverresponse','None','Question 31: Expect info.','1 - Yes, definitely |2 - Yes, somewhat|3 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51604','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<receivednh>|Sub-element of caregiverresponse','None','Question 32: Received nursing home.','1 - Yes|2 - No|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51605','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<cooperatehnh>|Sub-element of caregiverresponse','None','Question 33: Cooperate hospice and nursing home.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51606','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<differhnh>|Sub-element of caregiverresponse','None','Question 34: Difference between hospice and nursing home.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51607','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_clisten>|Sub-element of caregiverresponse','None','Question 35: Hospice listening carefully to caregiver.','1 - Never|2 - Sometimes|3 - Usually|4 - Always|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51608','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<cbeliefrespect>|Sub-element of caregiverresponse','None','Question 36: Caregiver beliefs respected.','1 - Too little|2 - Right amount|3 - Too much|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51609','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<cemotion>|Sub-element of caregiverresponse','None','Question 37: Caregiver emotion.','1 - Too little|2 - Right amount|3 - Too much|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51610','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<cemotionafter>|Sub-element of caregiverresponse','None','Question 38: Caregiver emotion after.','1 - Too little|2 - Right amount|3 - Too much|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51611','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<ratehospice>|Sub-element of caregiverresponse','None','Question 39: Rate hospice.','0 - Worst hospice care possible|1|2|3|4|5|6|7|8|9|10 - Best hospice care possible|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51612','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<h_recommend>|Sub-element of caregiverresponse','None','Question 40: Hospice recommended.','1 - Definitely no|2 - Probably no |3 - Probably yes|4 - Definitely yes|88 - Not Applicable|M - Missing/Don''t Know','Alphanumeric Character','2','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51613','Recode -9 = "M"|Recode -4 = "88"')
insert into #layout values ('<pEdu>|Sub-element of caregiverresponse','None','Question 41: Decedent education.','1 - 8th grade or less|2 - Some high school, but did not graduate|3 - High school graduate or GED|4 - Some college or 2-year degree|5 - 4-year college graduate|6 - More than 4-year college degree|7 - Don''t Know|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51614','Recode -9 = "M"')
insert into #layout values ('<pLatino>|Sub-element of caregiverresponse','None','Question 42: Decedent Latino.','1 - No, not Spanish/Hispanic/Latino|2 - Yes, Puerto Rican|3 - Yes, Mexican, Mexican American, Chicano/a|4 - Yes, Cuban|5 - Yes, other Spanish/Hispanic/Latino|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51615','Recode -9 = "M"')
insert into #layout values ('<race-white>|Sub-element of caregiverresponse','None','Question 43: Race, White.','1 - White|0 - Not White|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51616 AND ResponseBubble.ResponseValue = 1','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<race-african-amer>|Sub-element of caregiverresponse','None','Question 43: Race, African-American.','1 - Black or African-American|0 - Not Black or African-American|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51616 AND ResponseBubble.ResponseValue = 2','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<race-asian>|Sub-element of caregiverresponse','None','Question 43: Race, Asian.','1 - Asian|0 - Not Asian|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51616 AND ResponseBubble.ResponseValue = 3','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<race-hi-pacific-islander>|Sub-element of caregiverresponse','None','Question 43: Race, Pacific Islander.','1 - Native Hawaiian or other Pacific Islander|0 - Not Native Hawaiian or other Pacific Islander|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51616 AND ResponseBubble.ResponseValue = 4','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<race-amer-indian-ak>|Sub-element of caregiverresponse','None','Question 43: Race, American Indian/Alaska Native.','1 - American Indian or Alaska native|0 - Not American Indian or Alaska native|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.OriginalQuestionCore = 51616 AND ResponseBubble.ResponseValue = 5','Multi-response; if all responses blank, code all "M"')
insert into #layout values ('<cAge>|Sub-element of caregiverresponse','None','Question 44: Caregiver, age.','1 - 18 to 24|2 - 25 to 34|3 - 35 to 44|4 - 45 to 54|5 - 55 to 64|6 - 65 to 74|7 - 75 to 84|8 - 85 or older|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51617','Recode -9 = "M"')
insert into #layout values ('<cSex>|Sub-element of caregiverresponse','None','Question 45: Caregiver, sex.','1 - Male|2 - Female|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51618','Recode -9 = "M"')
insert into #layout values ('<cEdu>|Sub-element of caregiverresponse','None','Question 46: Caregiver, education.','1 - 8th grade or less|2 - Some high school, but did not graduate|3 - High school graduate or GED|4 - Some college or 2-year degree|5 - 4-year college graduate|6 - More than 4-year college degree|M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51619','Recode -9 = "M"')
insert into #layout values ('<cHomeLang>|Sub-element of caregiverresponse','None','Question 47: Language spoken at home.','1 - English|2 - Spanish|3 - Chinese|4 - Some other language |M - Missing/Don''t Know','Alphanumeric Character','1','Yes','ResponseBubble.ResponseValue where OriginalQuestionCore = 51620','Recode -9 = "M"')
insert into #layout values ('</caregiverresponse>   |                     |Closing tag for caregiverresponse','None','Note: This tag is required in the XML file, however, it contains no data. This decedentleveldata element should only occur once per decedent/caregiver.','','','','','','')
insert into #layout values ('</decedentleveldata>   |Closing tag for decedentleveldata','None','Note: This tag is required in the XML file, however, it contains no data. This vendordata element should only occur once per file.','','','','','','')
insert into #layout values ('</vendordata>    |Closing tag for |vendordata','','','','','','','','')

-- samplepopulationbackgroundfield.ColumnValue |where columnname = 'HSP_NumLiveDisch'
update #layout 
set catalystfield = substring(catalystfield,charindex(' from ',catalystfield)+6,99)+'.'+left(catalystfield,charindex(' from ',catalystfield)-1)
from #layout 
where catalystfield  like '%from%'

update #layout 
set catalystfield = left(catalystfield,charindex(' where',catalystfield)-1)+'.'+substring(catalystfield,charindex('.',catalystfield)+1,999)+' |'+substring(catalystfield,charindex(' where',catalystfield)+1,charindex('.',catalystfield)-charindex('where ',catalystfield))
from #layout 
where catalystfield like '%where%.%'

update #layout 
set catalystfield=replace(catalystfield,' where',' |where') 
where catalystfield like '%.% where%'

alter table #layout add ExportTemplateSectionName varchar(40)
go
-- select * from #layout where xmlelement like '%opening tag%'
update #layout set ExportTemplateSectionName = 'vendordata'        where XMLElement like '%Sub-element of vendordata'
update #layout set ExportTemplateSectionName = 'hospicedata'       where XMLElement like '%Sub-element of hospicedata'
update #layout set ExportTemplateSectionName = 'decedentleveldata' where XMLElement like '%Sub-element of decedentleveldata'
update #layout set ExportTemplateSectionName = 'caregiverresponse' where XMLElement like '%Sub-element of caregiverresponse'

alter table #layout add ExportColumnName varchar(40), DataSourceTableName varchar(500), SourceColumnName varchar(500)
go
update l set ExportColumnName=
-- select *, 
	substring(xmlelement,2,charindex('>',xmlelement)-2) 
from #layout l
where xmlelement not like '%ing tag%'  -- opening tag / closing tag

update l set DataSourceTableName = 
-- select * ,
	left(catalystfield,charindex('.',catalystfield)-1), SourceColumnName = substring(catalystfield,charindex('.',catalystfield)+1,99)
from #layout l
where catalystfield like '%.%'

update l set sourcecolumnname=
-- select * , 
	replace(sourcecolumnname,'ColumnValue |where ','') 
from #layout l
where datasourcetablename='samplepopulationbackgroundfield'

update l set sourcecolumnname=
-- select *, 
	replace(sourcecolumnname,'ResponseValue |where ','') 
from #layout l
where datasourcetablename='ResponseBubble'

update #layout set validvalues='2015|2016'		where validvalues = 'YYYY|YYYY = (2015 or greater)|(cannot be 9999)'
update #layout set validvalues='2014|2015|2016' where validvalues = 'YYYY|YYYY = (2014 or later)|(cannot be 9999)'
update #layout set validvalues='|8888'			where validvalues = 'YYYY|(cannot be 9999)|Use 8888 only if unable to obtain information by the data submission due date.'

update #layout set validvalues='01|02|03|04|05|06|07|08|09|10|11|12' where validvalues = 'MM|MM = (1-12)|(cannot be 00, 13 - 99)'
update #layout set validvalues='01|02|03|04|05|06|07|08|09|10|11|12|88' where validvalues = 'MM|MM = (1-12)|(cannot be 00, 13 - 99)|Use 88 only if unable to obtain information by the data submission due date.'


update #layout set validvalues='01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31' where validvalues = 'DD|DD = (1-31)|(cannot be 00, 32 - 99)'
update #layout set validvalues='01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|88' where validvalues = 'DD|DD = (1-31)|(cannot be 00, 32 - 99)|Use 88 only if unable to obtain information by the data submission due date.'

update #layout set validvalues='1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|M - Missing' where validvalues = '0-15|M - Missing'

update #layout set validvalues='' where validvalues in ('Valid 10 digit National Provider Identifier.|M - Missing','Facility name up to 100 alphanumeric characters.|N/A = Missing/Not applicable',' 0-365|888 - Not Applicable                      (use only for interim data file submission)')
-- 

update #layout set  validvalues='' where exportcolumnname like 'file-submission%'

alter table #layout add flag int
go
-- drop table #response update #layout set flag=null
create table #response (response_id int identity(1,1), row_id int, string varchar(1000), responsevalue varchar(20), responselabel varchar(250), RawValue varchar(200), ExportColumnName varchar(50))

declare @r int, @v varchar(max)
select top 1 @r=row_id, @v=ltrim(rtrim(validvalues))
from #layout
where validvalues like '%|%'
and exportcolumnname is not null
and flag is null
while @@rowcount>0
begin
	insert into #response (row_id, string)
	select @r, ltrim(rtrim(item)) from nrc_datamart.dbo.split(@v,'|')

	update #layout set flag=1 where row_id=@r

	select top 1 @r=row_id, @v=ltrim(rtrim(validvalues))
	from #layout
	where validvalues like '%|%'
	and exportcolumnname is not null
	and flag is null
end

update #response 
set responsevalue = left(string,charindex(' ',string+' ')-1) 
where string like '[1234567890M]%'

update #response 
set responselabel = ltrim(substring(string,charindex(' - ',string)+3,999))
where string like '[1234567890M]% - %'

update #response set responselabel=responsevalue where responselabel is null and responsevalue is not null

/*
select l.Description, l.ExportTemplateSectionName, l.ExportColumnName, r.*
from #layout l 
inner join #response r on l.row_id=r.row_id
*/


update r set ExportColumnName=l.ExportColumnName, rawvalue = right(l.sourcecolumnname,2)
from #layout l
inner join #response r on l.row_id=r.row_id
where l.sourcecolumnname like '% and responsebubble.responsevalue%'
and r.responsevalue='1'

--select l.row_id, l.ExportColumnName, l.datasourcetablename, l.sourcecolumnname, r.*, replace(l.sourcecolumnname, ' AND ResponseBubble.ResponseValue = ' + ltrim(rtrim(r.rawvalue)),'')
update l set ExportColumnName='', sourcecolumnname = replace(l.sourcecolumnname, ' AND ResponseBubble.ResponseValue = ' + ltrim(rtrim(r.rawvalue)),'')
from #layout l
inner join #response r on l.row_id=r.row_id
where l.sourcecolumnname like '% and responsebubble.responsevalue%'
and r.responsevalue='1'

alter table #layout add AggregateFunction varchar(30)
go

update #layout 
set aggregatefunction='count distinct', sourcecolumnname='samplepopulationid'
where sourcecolumnname='count(distinct samplepopulationid)'

update L
set sourcecolumnname=replace(replace(sourcecolumnname,'(','(['),')','])')
--select sourcecolumnname, replace(replace(sourcecolumnname,'(','(['),')','])')
from #layout L
where sourcecolumnname like '%(%'

update L
set sourcecolumnname=replace(sourcecolumnname, '[columnvalue]) |where columnname', '[ColumnName]') +')'
--select sourcecolumnname, replace(sourcecolumnname, '[columnvalue]) |where columnname', '[ColumnName]') +')'--day([ColumnName] = 'dob')
from #layout L 
where sourcecolumnname like '%(%where%'

update l
set sourcecolumnname=replicate('0',maxfieldsize)
--select catalystfield, replicate('0',maxfieldsize)
from #layout l
where catalystfield like '%(now())%'


delete from #response where row_id in (select row_id from #response where exportcolumnname is not null) and exportcolumnname is null

update r set rawvalue=-9
from #layout l
inner join #response r on l.row_id=r.row_id
where notes like '%Recode -9 = "M"%'
and r.responsevalue = 'M'

update #response set rawvalue=-9 where responsevalue='M' and rtrim(responselabel) in ('Missing','Missing/Don''t Know')

update r set rawvalue=-4
from #layout l
inner join #response r on l.row_id=r.row_id
where notes like '%Recode -4 = "8%'
and r.string like '8%not%'

update #response set rawvalue=-9 where responselabel like '%88%'

update #response set rawvalue=responsevalue where rawvalue is null

update #response 
set row_id=(select min(row_id) from #layout where description like 'question 2:%')
where row_id in (select row_id from #layout where description like 'question 2:%')

update #response 
set row_id=(select min(row_id) from #layout where description like 'question 43:%')
where row_id in (select row_id from #layout where description like 'question 43:%')

update #response set rawvalue=rawvalue + 600 where row_id=45 and rawvalue>=0 -- CahpsDispositionID
delete from #response where row_id=45 and rawvalue=-9

update #layout set SourceColumnName='National Research Corporation' where exportcolumnname='vendor-name'
update #layout set SourceColumnName='1' where exportcolumnname='file-submission-number'
update #layout set SourceColumnName='' where exportcolumnname='ineligible-postsample'
update #layout set SourceColumnName='' where exportcolumnname='lag-time'


select min(row_id) as row_id
	, ExportTemplateSectionName
	, left(description,charindex(':',description+':')-1) as ExportTemplateColumnDescription
	, isnull(DataSourceTableName, catalystfield) as ["DatasourceID"]
	, case when  notes like '%multi%' then '' else exportcolumnname end as exportcolumnname
	, SourceColumnName
	, AggregateFunction
into #cols
from #layout l
where exportcolumnname is not null
group by ExportTemplateSectionName
	, left(description,charindex(':',description+':')-1) 
	, case when  notes like '%multi%' then '' else exportcolumnname end 
	, isnull(DataSourceTableName, catalystfield)
	, SourceColumnName
	, AggregateFunction
order by min(row_id)

update #cols
set exportcolumnname=null
where exportcolumnname=''

-- these are sourced from client supplied background fields where 'M' is missing, not '-9'
update r
set RawValue='M'
from #response r
inner join #layout l on r.row_id = l.row_id
and l.ExportTemplateSectionName='decedentleveldata'
and responsevalue='m'

-- sex raw value is 'm' and 'f' - not '1' and '2'. But the recoded value is 1/2/M.  So if the source value is M is that Male or Missing? Flip a coin?
update r
set rawvalue = left(responselabel,1) 
from #response r
inner join #layout l on r.row_id = l.row_id
and l.ExportColumnName='sex'

update #response set rawvalue=17 where responselabel='Mixed Mode-mail'
update #response set rawvalue=12 where responselabel='Mixed Mode-phone'

update #response set rawvalue='-89' where row_id in (select row_id from #layout where exportcolumnname in ('painrxtrain','breathtrain','movetrain')) and rawvalue='4'
insert into #response (row_id,string,responsevalue,responselabel,RawValue)
select row_id, string, 4, responselabel, 9911 from #response where row_id in (select row_id from #layout where exportcolumnname in ('painrxtrain','breathtrain','movetrain')) and rawvalue='-89'


update r set rawvalue = 
--select r.* , 
	case responselabel when 'Mixed Mode-mail' then 17 when 'Mixed Mode-phone' then 12 else 0 end
from #response r
inner join #layout l on r.row_id = l.row_id
and l.ExportColumnName='survey-completion-mode'


update r set rawvalue = 
--select r.* , 
	case responselabel when 'Mail Only' then 24 when 'Telephone Only' then 25 when 'Mixed Mode' then 23 end
from #response r
inner join #layout l on r.row_id = l.row_id
and l.ExportColumnName='survey-mode'


-- taken care of by cem.ExportTemplateDefaultResponse
delete 
from #response
where (rawvalue='-4' and responsevalue like '8%')
or (rawvalue='-9' and responsevalue like 'm%')


if object_id('tempdb..#ids') is not null drop table #ids


begin tran
create table #IDS (what varchar(50), val varchar(200), theID int)

insert into cem.ExportTemplate (ExportTemplateName, SurveyTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial)
values ('CAHPS Hospice',11, -1, '1/1/2015','12/31/2222', '1.1', 1, 'dgilsdorf', getdate(), '{vendordata.vendor-name}.{vendordata.file-submission-day}{vendordata.file-submission-month}{vendordata.file-submission-yr}.{vendordata.file-submission-number}', 1, 0, 11, '<?xml version="1.0" encoding="UTF-8"?><xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified"><xs:element name="vendordata"><xs:complexType><xs:sequence><xs:element name="vendor-name" type="xs:string"></xs:element><xs:element name="file-submission-yr" type="xs:string"></xs:element><xs:element name="file-submission-month" type="xs:string"></xs:element><xs:element name="file-submission-day" type="xs:string"></xs:element><xs:element name="file-submission-number" type="xs:string"></xs:element><xs:element name="hospicedata"><xs:complexType><xs:sequence><xs:element name="reference-yr" type="xs:string"></xs:element><xs:element name="reference-month" type="xs:string"></xs:element><xs:element name="provider-name" type="xs:string"></xs:element><xs:element name="provider-id" type="xs:string"></xs:element><xs:element name="npi" type="xs:string"></xs:element><xs:element name="survey-mode" type="xs:string"></xs:element><xs:element name="total-decedents" type="xs:string"></xs:element><xs:element name="live-discharges" type="xs:string"></xs:element><xs:element name="no-publicity" type="xs:string"></xs:element><xs:element name="ineligible-presample" type="xs:string"></xs:element><xs:element name="sample-size" type="xs:string"></xs:element><xs:element name="ineligible-postsample" type="xs:string"></xs:element><xs:element name="sample-type" type="xs:string"></xs:element></xs:sequence></xs:complexType></xs:element><xs:element name="decedentleveldata"><xs:complexType><xs:sequence><xs:element name="provider-id" type="xs:string"></xs:element><xs:element name="decedent-id" type="xs:string"></xs:element><xs:element name="birth-yr" type="xs:string"></xs:element><xs:element name="birth-month" type="xs:string"></xs:element><xs:element name="birth-day" type="xs:string"></xs:element><xs:element name="death-yr" type="xs:string"></xs:element><xs:element name="death-month" type="xs:string"></xs:element><xs:element name="death-day" type="xs:string"></xs:element><xs:element name="admission-yr" type="xs:string"></xs:element><xs:element name="admission-month" type="xs:string"></xs:element><xs:element name="admission-day" type="xs:string"></xs:element><xs:element name="sex" type="xs:string"></xs:element><xs:element name="decedent-hispanic" type="xs:string"></xs:element><xs:element name="decedent-race" type="xs:string"></xs:element><xs:element name="caregiver-relationship" type="xs:string"></xs:element><xs:element name="decedent-payer-primary" type="xs:string"></xs:element><xs:element name="decedent-payer-secondary" type="xs:string"></xs:element><xs:element name="decedent-payer-other" type="xs:string"></xs:element><xs:element name="last-location" type="xs:string"></xs:element><xs:element name="facility-name" type="xs:string"></xs:element><xs:element name="decedent-primary-diagnosis" type="xs:string"></xs:element><xs:element name="survey-status" type="xs:string"></xs:element><xs:element name="survey-completion-mode" type="xs:string"></xs:element><xs:element name="number-survey-attempts-telephone" type="xs:string"></xs:element><xs:element name="number-survey-attempts-mail" type="xs:string"></xs:element><xs:element name="language" type="xs:string"></xs:element><xs:element name="lag-time" type="xs:string"></xs:element><xs:element name="supplemental-question-count" type="xs:string"></xs:element><xs:element name="caregiverresponse"><xs:complexType><xs:sequence><xs:element name="provider-id" type="xs:string"></xs:element><xs:element name="decedent-id" type="xs:string"></xs:element><xs:element name="related" type="xs:string"></xs:element><xs:element name="location-home" type="xs:string"></xs:element><xs:element name="location-assisted" type="xs:string"></xs:element><xs:element name="location-nursinghome" type="xs:string"></xs:element><xs:element name="location-hospital" type="xs:string"></xs:element><xs:element name="location-hospice-facility" type="xs:string"></xs:element><xs:element name="location-other" type="xs:string"></xs:element><xs:element name="oversee" type="xs:string"></xs:element><xs:element name="needhelp" type="xs:string"></xs:element><xs:element name="gethelp" type="xs:string"></xs:element><xs:element name="h_informtime" type="xs:string"></xs:element><xs:element name="helpasan" type="xs:string"></xs:element><xs:element name="h_explain" type="xs:string"></xs:element><xs:element name="h_inform" type="xs:string"></xs:element><xs:element name="h_confuse" type="xs:string"></xs:element><xs:element name="h_dignity" type="xs:string"></xs:element><xs:element name="h_cared" type="xs:string"></xs:element><xs:element name="h_talk" type="xs:string"></xs:element><xs:element name="h_talklisten" type="xs:string"></xs:element><xs:element name="pain" type="xs:string"></xs:element><xs:element name="painhlp" type="xs:string"></xs:element><xs:element name="painrx" type="xs:string"></xs:element><xs:element name="painrxside" type="xs:string"></xs:element><xs:element name="painrxwatch" type="xs:string"></xs:element><xs:element name="painrxtrain" type="xs:string"></xs:element><xs:element name="breath" type="xs:string"></xs:element><xs:element name="breathhlp" type="xs:string"></xs:element><xs:element name="breathtrain" type="xs:string"></xs:element><xs:element name="constip" type="xs:string"></xs:element><xs:element name="constiphlp" type="xs:string"></xs:element><xs:element name="sad" type="xs:string"></xs:element><xs:element name="sadgethlp" type="xs:string"></xs:element><xs:element name="restless" type="xs:string"></xs:element><xs:element name="restlesstrain" type="xs:string"></xs:element><xs:element name="movetrain" type="xs:string"></xs:element><xs:element name="expectinfo" type="xs:string"></xs:element><xs:element name="receivednh" type="xs:string"></xs:element><xs:element name="cooperatehnh" type="xs:string"></xs:element><xs:element name="differhnh" type="xs:string"></xs:element><xs:element name="h_clisten" type="xs:string"></xs:element><xs:element name="cbeliefrespect" type="xs:string"></xs:element><xs:element name="cemotion" type="xs:string"></xs:element><xs:element name="cemotionafter" type="xs:string"></xs:element><xs:element name="ratehospice" type="xs:string"></xs:element><xs:element name="h_recommend" type="xs:string"></xs:element><xs:element name="pEdu" type="xs:string"></xs:element><xs:element name="pLatino" type="xs:string"></xs:element><xs:element name="race-white" type="xs:string"></xs:element><xs:element name="race-african-amer" type="xs:string"></xs:element><xs:element name="race-asian" type="xs:string"></xs:element><xs:element name="race-hi-pacific-islander" type="xs:string"></xs:element><xs:element name="race-amer-indian-ak" type="xs:string"></xs:element><xs:element name="cAge" type="xs:string"></xs:element><xs:element name="cSex" type="xs:string"></xs:element><xs:element name="cEdu" type="xs:string"></xs:element><xs:element name="cHomeLang" type="xs:string"></xs:element></xs:sequence></xs:complexType></xs:element></xs:sequence></xs:complexType></xs:element></xs:sequence></xs:complexType></xs:element></xs:schema>', 1)
insert into #ids values ('ExportTemplateID', 'CAHPS Hospice', scope_identity())

select * from #ids

insert into cem.ExportTemplatesection (ExportTemplateSectionName,ExportTemplateID)
select ExportTemplateSectionName,theID from #layout, #ids 
where ExportTemplateSectionName is not null 
and what='ExportTemplateID'
group by ExportTemplateSectionName,theid
order by min(row_id)

insert into #ids (what, val, theID)
select 'ExportTemplateSectionID', ExportTemplateSectionName, ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateID=(select theid from #ids where what='ExportTemplateID')


insert into cem.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, MissingThresholdPercentage, CheckFrequencies)
select i.theid
	, c.ExportTemplateColumnDescription
	, ROW_NUMBER() OVER(ORDER BY c.row_id)
	, isnull(ds.DatasourceID,0)
	, c.exportcolumnname
	, c.sourcecolumnname
	, case l.DataType when 'Numeric' then 56 when 'Alphanumeric Character' then 167 when 'Date' then 61 else 00 end as SourceColumnType
	, c.AggregateFunction
	, NULL as DispositionProcessID
	, l.maxfieldsize as FixedWidthLength
	, .95
	, 0
from #cols c
inner join #ids i on c.ExportTemplateSectionName=i.val and i.what='ExportTemplateSectionID'
left join cem.datasource ds on c.["DatasourceID"]=replace(ds.TableName,'NRC_Datamart.dbo.','')
inner join #layout l on c.row_id=l.row_id

update etc set FixedWidthLength=sub.maxlen
from #cols c
inner join (select row_id, sum(len(responsevalue)) maxlen from #response where row_id in (select row_id from #cols where exportcolumnname is null) group by row_id) sub on c.row_id=sub.row_id
inner join cem.exporttemplatecolumn etc on etc.ExportTemplateColumnDescription=c.ExportTemplateColumnDescription
where c.exportcolumnname is null
and FixedWidthLength<>sub.maxlen

insert into #ids (what, val, theID)
select 'ExportTemplateColumnID', ExportTemplateColumnDescription, ExportTemplateColumnID
from cem.ExportTemplateColumn
where ExportTemplateSectionID in (select theid from #ids where what='ExportTemplateSectionID')

-- reset column order so that it starts at 1 with each section
update etc set etc.columnorder = etc.columnOrder-minorder+1
--select etc.exporttemplatesectionid, etc.columnOrder, sub.*, etc.columnOrder-minorder+1
from cem.exporttemplatecolumn etc
inner join (select exporttemplatesectionid, min(columnOrder) as minOrder
			from cem.exporttemplatecolumn
			where ExportTemplateSectionID in (select theid from #ids where what='ExportTemplateSectionID')
			group by ExportTemplateSectionID) sub
	on etc.ExportTemplateSectionID=sub.ExportTemplateSectionID

-- update the template so that it uses Service-Date for cutoffs:
update cem.ExportTemplate 
set ValidDateColumnID = (select ExportTemplateColumnID from cem.ExportTemplateColumn where ExportColumnName='service-date' and ExportTemplateSectionID in (select theid from #ids where what='ExportTemplateSectionID') )
where exporttemplateid = (select theid from #ids where what='ExportTemplateID')

insert into cem.ExportTemplateDefaultResponse (ExportTemplateID,RawValue,RecodeValue,ResponseLabel)
select theid,RawValue,case when rawvalue=-4 then '8' else RecodeValue end,ResponseLabel
from cem.ExportTemplateDefaultResponse, (select theid from #ids where what='ExportTemplateID') i
where exporttemplateid=1 
and isnull(rawvalue,0) not in (10011,10012,10013,10014)

delete r
from #response r
inner join cem.ExportTemplateDefaultResponse etdr on r.rawvalue=convert(varchar,etdr.rawvalue) and r.responsevalue=etdr.recodevalue 
where etdr.ExportTemplateID=(select theid from #ids where what='ExportTemplateID') 

-- these decedent fields are client supplied and have 'M' as a raw value - raw values need to be integers. 
-- none of the fields actually need recoding, so we're not putting any records into cem.exporttemplatecolumnresponse
-- this means there won't be any range checking.
delete r
from #cols c 
inner join #response r on c.row_id =r.row_id 
where exporttemplatesectionname = 'decedentleveldata' 
and c.exportcolumnname in ('sex','caregiver-relationship','decedent-hispanic','decedent-payer-other','decedent-payer-primary','decedent-payer-secondary','decedent-race','last-location','supplemental-question-count')


insert into cem.exporttemplatecolumnresponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select i.theid
, r.rawvalue
, r.exportcolumnname
, r.responsevalue
, r.responselabel
from #response r
inner join #cols c on r.row_id=c.row_id
inner join #ids i on what='ExportTemplateColumnID' and i.val=c.ExportTemplateColumnDescription
where isnull(c.exportcolumnname,'') <>'birth-yr'
order by i.theid, r.rawvalue

select *
from #response r
inner join #cols c on r.row_id=c.row_id
inner join #ids i on what='ExportTemplateColumnID' and i.val=c.ExportTemplateColumnDescription
where isnull(c.exportcolumnname,'') = 'birth-yr'

-- dispositionprocesses
-- survey-completion-mode: 1/2 (if survey-mode=3 and survey-status in (1,6,7)) else 88
-- in other words: 88 if surveymode <> 3 OR survey-status NOT in (1,6,7)
declare @dp_id int, @dc_id int
insert into cem.DispositionProcess (DispositionActionID,RecodeValue) values (1,8)
set @dp_id=SCOPE_IDENTITY()

insert into cem.DispositionClause (DispositionProcessID, DispositionPhraseKey, ExportTemplateColumnID, OperatorID)
select @dp_id, 1, ExportTemplateColumnID, o.OperatorID
from cem.ExportTemplateColumn etc, cem.Operator o
where etc.ExportColumnName='survey-status'
and o.strOperator = 'NOT IN'
and etc.ExportTemplateColumnID>=172
set @dc_id=SCOPE_IDENTITY()

insert into cem.DispositionInList (DispositionClauseID,ListValue) values (@dc_id, 1), (@dc_id, 6), (@dc_id, 7)

insert into cem.DispositionClause (DispositionProcessID, DispositionPhraseKey, ExportTemplateColumnID, OperatorID, LowValue)
select @dp_id, 1, ExportTemplateColumnID, o.OperatorID, '''3'''
from cem.ExportTemplateColumn etc, cem.Operator o
where etc.ExportColumnName='survey-mode'
and o.strOperator = '<>'
and etc.ExportTemplateColumnID>=172

update etc
set DispositionProcessID=@dp_id
from cem.ExportTemplateColumn etc
where etc.ExportColumnName='survey-completion-mode'
and etc.ExportTemplateColumnID>=172

commit tran
-- rollback tran

go
use NRC_DataMart_Extracts
go
if exists (select * from sys.procedures where name='ExportPostProcess00000003')
	drop procedure cem.ExportPostProcess00000003
go
CREATE PROCEDURE [CEM].[ExportPostProcess00000003]
@ExportQueueID int
as
update eds
set [decedentleveldata.sex] = case [decedentleveldata.sex] when 'M' then '1' when 'F' then '2' else 'M' end
from CEM.ExportDataset00000003 eds
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
from CEM.ExportDataset00000003 eds
inner join nrc_datamart.dbo.samplepopulationdispositionlog spdl on spdl.SamplePopulationID=eds.SamplePopulationID
inner join nrc_datamart.dbo.CahpsDispositionMapping cdm on cdm.dispositionid=spdl.DispositionID and [decedentleveldata.survey-status]=(cdm.CahpsDispositionID-600)
where ltrim([decedentleveldata.survey-status]) in ('2','3','4','5','8','12','13','14')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) in (1,7) then 'QuestionForm.ReturnDate'
--	   end
--, qf.returndate
from CEM.ExportDataset00000003 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) in ('1','7') 
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qf.returndate)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 6 then 'QuestionForm.ReturnDate OR SamplePopulationDispositionLog.LoggedDate'
--	   end
--, qf.returndate
--, [caregiverresponse.oversee], [decedentleveldata.survey-completion-mode]
from CEM.ExportDataset00000003 eds
inner join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) = '6' 
and eds.ExportQueueID = @ExportQueueID 

if object_id('tempdb..#SampleSetExpiration') is not null
	drop table #SampleSetExpiration
select distinct ss.samplesetid, eds.samplepopulationid, qf.DatExpire
into #SampleSetExpiration
from CEM.ExportDataset00000003 eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
where eds.ExportQueueID = @ExportQueueID 
order by 2

update sse
set datExpire=sub.datExpire
from #SampleSetExpiration sse
inner join (select samplesetid,max(datexpire) as datExpire
			from #SampleSetExpiration
			where datExpire is not null
			group by samplesetid) sub
	on sse.samplesetid=sub.samplesetid
where sse.datExpire is null

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),sse.datExpire)
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then 'Expiration Date (Mail & Mixed) OR Date of last phone attempt (Phone)'
--	   end
--, sse.DatExpire
from CEM.ExportDataset00000003 eds
inner join #SampleSetExpiration sse on eds.SamplePopulationID=sse.SamplePopulationID
where ltrim([decedentleveldata.survey-status]) ='9'
and [hospicedata.survey-mode] in ('1','3')
and eds.ExportQueueID = @ExportQueueID 

update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),qss.datLastMailed)
--select eds.samplepopulationid, [hospicedata.provider-id] ccn, [hospicedata.survey-mode], convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) DayOfDeath, [decedentleveldata.survey-status]
--, case when ltrim([decedentleveldata.survey-status]) = 9 then 'Expiration Date (Mail & Mixed) OR Date of last phone attempt (Phone)'
--	   end
--, ss.samplesetID, dsk.DataSourceKey as sampleset_id, qss.datLastMailed
from CEM.ExportDataset00000003 eds
inner join NRC_Datamart.dbo.samplepopulation sp  on eds.SamplePopulationID=sp.SamplePopulationID
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_DataMart.etl.DataSourceKey dsk on ss.SampleSetID=dsk.DataSourceKeyID and dsk.EntityTypeID=8
inner join Qualisys.qp_prod.dbo.sampleset qss on dsk.DataSourceKey = qss.sampleset_id
where ltrim([decedentleveldata.survey-status]) in ('9')
and isnull([decedentleveldata.lag-time],'') =''
and qss.datLastMailed is not null
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.CreateDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.CreateDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.CreateDate)) as lagtime
from CEM.ExportDataset00000003 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID=5--Non Response Bad Address / 16--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '10' -- bad address     / 11 -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 


update eds set [decedentleveldata.lag-time]=datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.CreateDate))
--select eds.samplepopulationid, convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]) as DayOfDeath, [decedentleveldata.survey-status]
--, isnull(qf.datUndeliverable, spdl.CreateDate) as dispositiondate
--, datediff(day,convert(datetime,[decedentleveldata.death-month]+'/'+[decedentleveldata.death-day]+'/'+[decedentleveldata.death-yr]),isnull(qf.datUndeliverable, spdl.CreateDate)) as lagtime
from CEM.ExportDataset00000003 eds
left join nrc_datamart.dbo.questionform qf on qf.SamplePopulationID=eds.SamplePopulationID
left join nrc_datamart.dbo.SamplePopulationDispositionLog spdl on eds.SamplePopulationID=spdl.SamplePopulationID and spdl.DispositionID in (14,16)--Non Response Bad Phone
where ltrim([decedentleveldata.survey-status]) = '11' -- bad phone
and isnull([decedentleveldata.lag-time],'') =''
and eds.ExportQueueID = @ExportQueueID 

-- There’s one hospice that we messed up sampling for January & February data.
-- Delete all January and February data out of the file for CCN 031592.
delete 
from CEM.ExportDataset00000003 
where [hospicedata.provider-id]='031592'
and [hospicedata.reference-yr]='2015'
and [hospicedata.reference-month] in ('01','02')
and ExportQueueID = @ExportQueueID 

-- Saint Mary’s Hospice and Palliative Care (ccn 291501) has six people we sampled in January but shouldn't have, so we're not submiting any of their january data.
delete eds
from cem.ExportDataset00000003 eds
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
from cem.ExportDataset00000003 eds
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
from cem.ExportDataset00000003 eds
where ExportQueueID = @ExportQueueID 
and [hospicedata.reference-yr]='2015'
and [hospicedata.provider-id] in ('291501','191568','251670','251575')
and [hospicedata.reference-month] in ('01','02')

-- Number of decedents/caregivers in the sample for the month with a “Final Survey Status” code of:  
-- “3 – Ineligible: Not in Eligible Population,” 
-- “6 – Ineligible: Never Involved in Decedent Care,” and 
-- “14 – Ineligible: Institutionalized.”
update cem.ExportDataset00000003 
set [hospicedata.ineligible-postsample]='0'
where ExportQueueID=@ExportQueueID 

update eds
set [hospicedata.ineligible-postsample]=sub.cnt
from cem.ExportDataset00000003 eds
inner join (select [hospicedata.provider-id],[hospicedata.reference-month], count(*) cnt
			from cem.ExportDataset00000003
			where ExportQueueID=@ExportQueueID 
			and ltrim([decedentleveldata.survey-status]) in ('3','6','14')
			group by [hospicedata.provider-id], [hospicedata.reference-month]) sub
	on eds.[hospicedata.provider-id]=sub.[hospicedata.provider-id] and eds.[hospicedata.reference-month]=sub.[hospicedata.reference-month]
where eds.ExportQueueID=@ExportQueueID 

-- recode various blank columns to 'M' or 'N/A'
update cem.ExportDataset00000003 set [decedentleveldata.decedent-primary-diagnosis]='MMMMMMM' where [decedentleveldata.decedent-primary-diagnosis]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000003 set [decedentleveldata.decedent-payer-primary]='M' where [decedentleveldata.decedent-payer-primary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000003 set [decedentleveldata.decedent-payer-secondary]='M' where [decedentleveldata.decedent-payer-secondary]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000003 set [decedentleveldata.decedent-payer-other]='M' where [decedentleveldata.decedent-payer-other]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000003 set [decedentleveldata.last-location]='M' where [decedentleveldata.last-location]='' and ExportQueueid=@ExportQueueID
update cem.ExportDataset00000003 set [decedentleveldata.facility-name]='N/A' where [decedentleveldata.facility-name]='' and ExportQueueid=@ExportQueueID

-- recode blank NPI's to 'M'
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000003 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.npi]=''

-- recode NPI to 'M' for any CCN that has multiple NPI values
update eds
set [hospicedata.npi]='M'
from CEM.ExportDataset00000003 eds
where eds.ExportQueueID = @ExportQueueID 
and [hospicedata.provider-id] in (select [hospicedata.provider-id]
									from CEM.ExportDataset00000003 eds
									where eds.ExportQueueID = @ExportQueueID 
									group by [hospicedata.provider-id]
									having count(distinct [hospicedata.npi])>1)

update cem.ExportDataset00000003 
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

update cem.ExportDataset00000003 
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
select @sql=@sql+'update cem.ExportDataset00000003 set [caregiverresponse.'+etc.exportcolumnname+']=''M'' where [caregiverresponse.'+etc.exportcolumnname+']='''+replicate('M',etc.fixedwidthlength)+''' and ExportQueueid='+convert(varchar,eq.exportqueueid)+char(10)
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
from CEM.ExportDataset00000003 eds
where isnull([decedentleveldata.lag-time],'') =''
and ExportQueueID = @ExportQueueID 
group by [decedentleveldata.survey-status]
go
declare @Q_id int
insert into cem.exportqueue (ExportTemplateName, ExportTemplateVersionMajor, ExportTemplateVersionMinor, ExportDateStart, ExportDateEnd, ReturnsOnly, ExportNotificationID, RequestDate, PullDate, ValidatedDate, ValidatedBy, ValidationCode)
values ('CAHPS Hospice','1.1',NULL,'2015-01-01 00:00:00.000','2015-03-31 00:00:00.000','0',NULL,getdate(),NULL,NULL,NULL,NULL)
set @Q_id=scope_identity()

print 'ExportQueueID='+convert(varchar,@Q_id)

insert into cem.ExportQueueSurvey (ExportQueueID,SurveyID)
select @Q_id, s.SurveyID --, min(sp.ServiceDate), max(sp.ServiceDate), count(*)
from nrc_datamart.dbo.survey S
inner join nrc_datamart.dbo.sampleunit su on s.surveyid=su.SurveyID
inner join nrc_datamart.dbo.selectedsample ss on su.SampleUnitID=ss.SampleUnitID
inner join nrc_datamart.dbo.samplepopulation sp on ss.SamplePopulationID=sp.samplepopulationID
where s.SurveyTypeID=11
and s.SurveyID>0
and sp.ServiceDate between '1/1/15' and '3/31/15'
group by s.SurveyID
order by s.SurveyID

/*
select * from cem.ExportTemplate where ExportTemplateID>2
select * from cem.ExportTemplateSection where ExportTemplateID>2
select * from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID>2)
select * from cem.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID>2))
select * from cem.ExportTemplateDefaultResponse where ExportTemplateID>2


delete from cem.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID>2))
delete from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID>2)
delete from cem.ExportTemplateSection where ExportTemplateID>2
delete from cem.ExportTemplate where ExportTemplateID>2
delete from cem.ExportTemplateDefaultResponse where ExportTemplateID>2

select max(exporttemplateid) from cem.ExportTemplate
select max(exporttemplatesectionid) from cem.ExportTemplateSection
select max(exporttemplatecolumnid) from cem.ExportTemplateColumn
select max(ExportTemplateColumnResponseid) from cem.ExportTemplateColumnResponse
select max(ExportTemplateDefaultResponseid) from cem.ExportTemplateDefaultResponse

DBCC CHECKIDENT ('cem.ExportTemplate', RESEED, 2) 
DBCC CHECKIDENT ('cem.ExportTemplateSection', RESEED, 6) 
DBCC CHECKIDENT ('cem.ExportTemplateColumn', RESEED, 172) 
DBCC CHECKIDENT ('cem.ExportTemplateColumnResponse', RESEED, 606) 
DBCC CHECKIDENT ('cem.ExportTemplateDefaultResponse', RESEED, 42) 


delete from cem.Dispositioninlist where DispositionClauseID in (select DispositionClauseID from cem.DispositionClause where DispositionProcessID>7)
delete from cem.DispositionClause where DispositionProcessID>7
delete from cem.DispositionProcess where DispositionProcessID>7

select max(dispositionprocessid) from cem.DispositionProcess 
select max(dispositionclauseid) from  cem.DispositionClause 
select max(dispositioninlistid) from  cem.Dispositioninlist 

DBCC CHECKIDENT ('cem.DispositionProcess', RESEED, 7) 
DBCC CHECKIDENT ('cem.DispositionClause', RESEED, 13) 
DBCC CHECKIDENT ('cem.Dispositioninlist', RESEED, 72) 

*/


select * from cem.DispositionProcess
select * from cem.dispositionaction
select * from cem.DispositionClause
select * from cem.Dispositioninlist 

select distinct rawvalue,recodevalue,responselabel from cem.ExportTemplateDefaultResponse

select *
from (select rawvalue,responsevalue, count(*) as cnt from #response where responsevalue like '[0-9]%' group by rawvalue,responsevalue) x
where responsevalue<> rawvalue 
union
select rawvalue,responsevalue, count(*) as cnt from #response where responsevalue not like '[0-9]%' group by rawvalue,responsevalue
order by 1,2,3
