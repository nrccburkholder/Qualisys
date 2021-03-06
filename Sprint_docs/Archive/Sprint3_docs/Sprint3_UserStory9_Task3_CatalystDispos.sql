use [NRC_DataMart_CA]

--SELECT * FROM [Disposition]

if not exists (select 1 from disposition where dispositionID = 24)
insert into disposition values (24,'Remove this patient from call list')

if not exists (select 1 from disposition where dispositionID = 25)
insert into disposition values (25,'Patient deceased')

if not exists (select 1 from disposition where dispositionID = 26)
insert into disposition values (26,'Privacy concerns')

if not exists (select 1 from disposition where dispositionID = 27)
insert into disposition values (27,'Declined to participate')

if not exists (select 1 from disposition where dispositionID = 28)
insert into disposition values (28,'Unknown')

if not exists (select 1 from disposition where dispositionID = 29)
insert into disposition values (29,'Other')

if not exists (select 1 from disposition where dispositionID = 30)
insert into disposition values (30,'The intended respondent is institutionalized')

if not exists (select 1 from disposition where dispositionID = 31)
insert into disposition values (31,'Blank first mail survey')

if not exists (select 1 from disposition where dispositionID = 32)
insert into disposition values (32,'Blank second mail survey')

if not exists (select 1 from disposition where dispositionID = 33)
insert into disposition values (33,'Blank phone survey')

if not exists (select 1 from disposition where dispositionID = 34)
insert into disposition values (34,'Removed from phone due to response from another mode')

if not exists (select 1 from disposition where dispositionID = 36)
insert into disposition values (36, 'Returned Survey - Eligibility Unknown')

if not exists (select 1 from disposition where dispositionID = 37)
insert into disposition values (37, 'Ineligible - Not Receiving Care')

if not exists (select 1 from disposition where dispositionID = 38)
insert into disposition values (38, 'Ineligible - Not Receiving Care at Facility')

if not exists (select 1 from disposition where dispositionID = 35)
insert into disposition values (35, 'Proxy Return')

/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT * FROM [Disposition]

use [NRC_DataMart]

if not exists (select 1 from disposition where dispositionID = 23)
insert into disposition values (23,'Negative Screener Response')

if not exists (select 1 from disposition where dispositionID = 24)
insert into disposition values (24,'Institutionalized')

if not exists (select 1 from disposition where dispositionID = 25)
insert into disposition values (25,'Blank first mail survey')

if not exists (select 1 from disposition where dispositionID = 26)
insert into disposition values (26,'Blank second mail survey')

if not exists (select 1 from disposition where dispositionID = 27)
insert into disposition values (27,'Blank phone survey')

if not exists (select 1 from disposition where dispositionID = 28)
insert into disposition values (28, 'Mixed Mode Removed from Phone')

if not exists (select 1 from disposition where dispositionID = 29)
insert into disposition values (29, 'Complete and Valid Survey by Web')

if not exists (select 1 from disposition where dispositionID = 30)
insert into disposition values (30, 'Partial Survey by Web')

if not exists (select 1 from disposition where dispositionID = 32)
insert into disposition values (32, 'Returned Survey - Eligibility Unknown')

if not exists (select 1 from disposition where dispositionID = 33)
insert into disposition values (33, 'Ineligible - Not Receiving Care')

if not exists (select 1 from disposition where dispositionID = 34)
insert into disposition values (34, 'Ineligible - Not Receiving Care at Facility')

if not exists (select 1 from disposition where dispositionID = 35)
insert into disposition values (35, 'Proxy Return')

--select * from CAHPSDisposition

--ACO

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 410 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (410,4,'Complete and Valid Survey',1,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 411 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (411,4,'The intended respondent is institutionalized',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 420 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (420,4,'The intended respondent has passed on',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 422 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (422,4,'Language Barrier',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 424 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (424,4,'The intended respondent is incapacitated and cannot participate in this survey',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 431 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (431,4,'Breakoff',0,1)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 432 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (432,4,'I do not wish to participate in this survey',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 433 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (433,4,'Non Response after Max Attempts',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 434 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (434,4,'Blank Survey',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 435 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (435,4,'Respondent not at address/phone Bad/missing/wrong phone',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 440 and CahpsTypeID = 4)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (440,4,'The survey is not applicable to me',0,0)

--ICH

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5150 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5150,5,'Deceased',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5199 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5199,5,'Survey completed by Proxy',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5140 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5140,5,'Ineligible: Not ReceivingDialysis',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5190 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5190,5,'Ineligible: No Longer Receiving Care at Sampled Facility',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5160 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5160,5,'Ineligible: Does Not Meet Eligibility Criteria',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5130 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5130,5,'Completed Mail Questionnaire—Survey Eligibility Unknown',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5120 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5120,5,'Completed Phone Interview',1,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5110 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5110,5,'Completed Mail Questionnaire',1,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5210 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5210,5,'Breakoff',0,1)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5220 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5220,5,'Refusal',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5170 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5170,5,'Language Barrier',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5180 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5180,5,'Mentally or Physically Incapacitated',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5240 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5240,5,'Wrong, Disconnected, or No Telephone Number',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5230 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5230,5,'Bad Address/Undeliverable Mail',0,0)

if not exists(select 1 from CAHPSDisposition where CahpsDispositionID = 5250 and CahpsTypeID = 5)
insert into CAHPSDisposition 
(CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (5250,5,'No Response After Maximum Attempts',0,0)

--delete from CahpsDisposition where CahpsDispositionID in (150,199,140,190,160,130,170,180,250)

--select * from CahpsDispositionMapping

/*
select * from Disposition

select * from CAHPSDisposition

select * from CahpsDispositionMapping

select ct.label ctlabel, cd.CahpsDispositionID, d.dispositionId, cd.label cdlabel, cdm.label cdmlabel, d.label dlabel from CAHPSDisposition cd
inner join CAHPSDispositionMapping cdm on cd.CahpsDispositionID = cdm.CahpsDispositionID 
inner join Disposition d on d.dispositionid = cdm.dispositionid
inner join CAHPSType ct on ct.CahpsTypeID = cdm.CahpsTypeID 
order by cd.CahpsDispositionID
*/

declare @xx int
declare @xxxx int

set @xx = 19
set @xxxx = 5110

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Completed Mail Questionnaire', @xx, 5, 0)

set @xx = 20
set @xxxx = 5120

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Completed Phone Interview', @xx, 5, 0)

set @xx = 32
set @xxxx = 5130

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Completed Mail Questionnaire—Survey Eligibility Unknown', @xx, 4, 0)

set @xx = 33
set @xxxx = 5140

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Ineligible: Not Receiving Dialysis', @xx, 1, 0)

set @xx = 3
set @xxxx = 5150

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Deceased', @xx, 0, 0)

set @xx = 8
set @xxxx = 5160

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Ineligible: Does Not Meet Eligibility Criteria', @xx, 3, 0)

set @xx = 24
set @xxxx = 5160

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Ineligible: Does Not Meet Eligibility Criteria', @xx, 3, 0)

set @xx = 10
set @xxxx = 5170

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Language Barrier', @xx, 9, 0)

set @xx = 4
set @xxxx = 5180

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Mentally or Physically Incapacitated', @xx, 10, 0)

set @xx = 34
set @xxxx = 5190

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Ineligible: No Longer Receiving Care at Sampled Facility', @xx, 2, 0)

set @xx = 35
set @xxxx = 5199

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Survey completed by Proxy', @xx, 0, 0)


set @xx = 11
set @xxxx = 5210

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Breakoff', @xx, 7, 0)

set @xx = 2
set @xxxx = 5220

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Refusal', @xx, 8, 0)

set @xx = 26
set @xxxx = 5220

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Refusal', @xx, 8, 0)

set @xx = 5
set @xxxx = 5230

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Bad Address/Undeliverable Mail', @xx, 12, 0)

set @xx = 14
set @xxxx = 5240

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Bad Address/Undeliverable Mail', @xx, 11, 0)

set @xx = 16
set @xxxx = 5240

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'Bad Address/Undeliverable Mail', @xx, 11, 0)

set @xx = 12
set @xxxx = 5250

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'No Response After Maximum Attempts', @xx, 13, 0)

set @xx = 25
set @xxxx = 5250

if not exists(select * from CahpsDispositionMapping where CahpsDispositionId = @xxxx and DispositionId = @xx)
insert into CahpsDispositionMapping (CahpsTypeID, CahpsDispositionID, ReceiptTypeID, Label, DispositionID, CahpsHierarchy, IsDefaultDisposition)
values (5, @xxxx, -1, 'No Response After Maximum Attempts', @xx, 13, 0)
