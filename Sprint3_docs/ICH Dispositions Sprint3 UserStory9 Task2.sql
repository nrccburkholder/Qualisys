use [QP_Prod] 

--select * from Disposition

if not exists (select 1 from disposition where strDispositionLabel = 'Returned Survey - Eligibility Unknown')
insert into disposition (strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values ('Returned Survey - Eligibility Unknown','Unable to determine eligibility from screener questions on returned survey',0,1)

if not exists (select 1 from disposition where strDispositionLabel = 'Ineligible - Not Receiving Care')
insert into disposition (strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values ('Ineligible - Not Receiving Care','The patient is no longer receiving care',0,0)

if not exists (select 1 from disposition where strDispositionLabel = 'Ineligible - Not Receiving Care at Facility')
insert into disposition (strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values ('Ineligible - Not Receiving Care at Facility','The patient is not receiving care at the sampled facility',0,0)

if not exists (select 1 from disposition where strDispositionLabel = 'Proxy Return')
insert into disposition (strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values ('Proxy Return','The survey was completed by someone other than the intended recipient',0,1)

--select Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID from surveytypedispositions order by surveytype_id, hierarchy, disposition_id

declare @proxyId int
select @proxyId = disposition_id from disposition where strdispositionlabel = 'Proxy Return'

declare @eligibilityUnknownId int
select @eligibilityUnknownId = disposition_id from disposition where strdispositionlabel = 'Returned Survey - Eligibility Unknown'

declare @ineligibleNotCareId int
select @ineligibleNotCareId = disposition_id from disposition where strdispositionlabel = 'Ineligible - Not Receiving Care'

declare @ineligibleNotFacilityId int
select @ineligibleNotFacilityId = disposition_id from disposition where strdispositionlabel = 'Ineligible - Not Receiving Care at Facility'

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 3)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('150','Deceased',0,3,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @proxyId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('199','Survey completed by Proxy',0,@proxyId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @ineligibleNotCareId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('140','Ineligible: Not Receiving Dialysis',1,@ineligibleNotCareId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @ineligibleNotFacilityId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('190','Ineligible: No Longer Receiving Care at Sampled Facility',2,@ineligibleNotFacilityId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 8)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('160','Ineligible: Does Not Meet Eligibility Criteria',3,8,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 24)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('160','Ineligible: Does Not Meet Eligibility Criteria',3,24,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @eligibilityUnknownId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('130','Completed Mail Questionnaire—Survey Eligibility Unknown',4,@eligibilityUnknownId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 20)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('120','Completed Phone Interview',5,20,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 19)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('110','Completed Mail Questionnaire',5,19,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 11)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('210','Breakoff',7,11,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 2)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('220','Refusal',8,2,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 26)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('220','Refusal',8,26,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 10)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('170','Language Barrier',9,10,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 4)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('180','Mentally or Physically Incapacitated',10,4,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 14)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('240','Wrong, Disconnected, or No Telephone Number',11,14,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 16)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('240','Wrong, Disconnected, or No Telephone Number',11,16,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 5)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('230','Bad Address/Undeliverable Mail',12,5,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 12)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('250','No Response After Maximum Attempts',13,12,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 25)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('250','No Response After Maximum Attempts',13,25,0,8)
