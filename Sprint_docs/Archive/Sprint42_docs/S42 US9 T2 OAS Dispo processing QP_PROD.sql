/*
S42 US9 T2 OAS Dispo processing QP_PROD.sql

 9 OAS: Dispo Processing
As an OAS-CAHPS vendor, we need to assign the correct final disposition to each record, so that we submit accurate data
See x-walk document in BA folder on SP. Acceptance: Records get default ""no response"" dispo when samplepops ETL'd. 
All dispositions are evaluated against the hierarchy and assigned correctly. Completeness is accurately evaluated per 
OAS guidelines. The disposition tables in Catalyst and QP_Prod are updated. (see script from story 32.22 for PQRS) 
Need before returns come back (firsts mailing BY 2/21) (date is off-cycle) 

Task 2 - Insert records into survey type dispositions in qp_prod 

Chris Burkholder

2/5/2016

*/

use [QP_Prod]

GO


/*
select * from SurveyTypeDispositions
where SurveyType_id = 16
*/

begin tran

if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 8)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(8,220,1,'Ineligible: Does not meet eligible Population criteria',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 3)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(3,210,2,'Ineligible: Deceased',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 4)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(4,240,3,'Ineligible: Mentally or Physically Incapacitated/No Proxy Available',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 10)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(10,230,4,'Ineligible: Language Barrier',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 26)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(26,320,5,'Blank second mail survey',0,17,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 2)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(2,320,5,'Refusal',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 19)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(19,110,6,'Completed Mail Survey',1,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 20)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(20,120,6,'Completed Phone Interview',1,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 49)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(49,350,7,'Breakoff is actually blank',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 11)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(11,310,8,'Breakoff',1,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 14)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(14,340,9,'Wrong, Disconnected or No Telephone Number',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 16)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(16,340,9,'Wrong, Disconnected or No Telephone Number',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 5)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(5,330,10,'Bad Address/Undeliverable Mail',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 12)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(12,350,11,'No Response After Maximum Attempts',0,NULL,16)
if not exists (select * from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 25)
insert into SurveyTypeDispositions (Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values(25,350,11,'Blank first mail survey',0,17,16)

--rollback tran
commit tran
