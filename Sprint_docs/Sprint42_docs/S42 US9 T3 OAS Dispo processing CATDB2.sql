/*
S42 US9 T3 OAS Dispo processing CATDB2.sql

 9 OAS: Dispo Processing
As an OAS-CAHPS vendor, we need to assign the correct final disposition to each record, so that we submit accurate data
See x-walk document in BA folder on SP. Acceptance: Records get default ""no response"" dispo when samplepops ETL'd. 
All dispositions are evaluated against the hierarchy and assigned correctly. Completeness is accurately evaluated per 
OAS guidelines. The disposition tables in Catalyst and QP_Prod are updated. (see script from story 32.22 for PQRS) 
Need before returns come back (firsts mailing BY 2/21) (date is off-cycle) 

Task 3 - Insert records into catalyst disposition mapping tables

Chris Burkholder

2/5/2016

NRC_Datamart:
insert into CahpsDispositionMapping 
insert into CahpsDisposition

note: queries to get the values below:
	--select * from CAHPSType

	select distinct
		[value] as CahpsDispositionID
		, 9 as CahpsTypeID
--		, Disposition_id as DispositionID
--		, case when ReceiptType_ID in (19,21) then 17 when ReceiptType_ID in (20,22) then 12 else -1 end as ReceiptTypeID
					-- note: none of Hospice CAHPS dipsositions are methodology dependent, so all ReceiptTypeID values are -1
		, [desc] as Label
--		, Hierarchy as CahpsHierarchy
--		, case when disposition_id=12 then 1 else 0 end as IsDefaultDisposition 
        , case when [desc] in ('Completed Mail Survey','Completed Phone Interview') then 1 else 0 end as IsCahpsDispositionComplete
		, case when [desc] = 'Breakoff' then 1 else 0 end as IsCahpsDispositionInComplete
	from [QUALISYS].[QP_Prod].[dbo].[SurveyTypeDispositions]
	where surveytype_id=16
	and [value] is not null

	select 9 as CahpsTypeID
		, Disposition_id as DispositionID
		, case when ReceiptType_ID in (19,21) then 17 when ReceiptType_ID in (20,22) then 12 else -1 end as ReceiptTypeID
					-- note: none of Hospice CAHPS dipsositions are methodology dependent, so all ReceiptTypeID values are -1
		, [desc] as Label
		, [value] as CahpsDispositionID
		, Hierarchy as CahpsHierarchy
		, case when disposition_id=12 then 1 else 0 end as IsDefaultDisposition 
--        , case when [desc] in ('Completed Mail Survey','Completed Phone Interview') then 1 else 0 end as IsCahpsDispositionComplete
--		, case when [desc] = 'Breakoff' then 1 else 0 end as IsCahpsDispositionInComplete
	from [QUALISYS].[QP_Prod].[dbo].[SurveyTypeDispositions]
	where surveytype_id=16
	and [value] is not null
*/

use [NRC_Datamart]

GO

begin tran

if not exists (select * from CAHPSDisposition where CahpsTypeID=9)
	insert into dbo.CAHPSDisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
	SELECT N'901', /*110,*/	9,'Completed Mail Survey',1,0 UNION ALL
	SELECT N'902', /*120,*/	9,'Completed Phone Interview',1,0 UNION ALL
	SELECT N'903', /*210,*/	9,'Ineligible: Deceased',0,0 UNION ALL
	SELECT N'904', /*220,*/	9,'Ineligible: Does not meet eligible Population criteria',0,0 UNION ALL
	SELECT N'905', /*230,*/	9,'Ineligible: Language Barrier',0,0 UNION ALL
	SELECT N'906', /*240,*/	9,'Ineligible: Mentally or Physically Incapacitated/No Proxy Available',0,0 UNION ALL
	SELECT N'907', /*310,*/	9,'Breakoff',0,1 UNION ALL
	SELECT N'908', /*320,*/	9,'Blank second mail survey',0,0 UNION ALL
	SELECT N'909', /*320,*/	9,'Refusal',0,0 UNION ALL
	SELECT N'910', /*330,*/	9,'Bad Address/Undeliverable Mail',0,0 UNION ALL
	SELECT N'911', /*340,*/	9,'Wrong, Disconnected or No Telephone Number',0,0 UNION ALL
	SELECT N'912', /*350,*/	9,'Blank first mail survey',0,0 UNION ALL
	SELECT N'913', /*350,*/	9,'Breakoff is actually blank',0,0 UNION ALL
	SELECT N'914', /*350,*/	9,'No Response After Maximum Attempts',0,0 
	order by 1

if not exists (select * from CahpsDispositionMapping where CahpsTypeID=9)
	insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	Select 9,8,-1,'Ineligible: Does not meet eligible Population criteria',904,/*220,*/1,0 union all
	Select 9,3,-1,'Ineligible: Deceased',903,/*210,*/2,0 union all
	Select 9,4,-1,'Ineligible: Mentally or Physically Incapacitated/No Proxy Available',906,/*240,*/3,0 union all
	Select 9,10,-1,'Ineligible: Language Barrier',905,/*230,*/4,0 union all
	Select 9,26,-1,'Blank second mail survey',908,/*320,*/5,0 union all
	Select 9,2,-1,'Refusal',909,/*320,*/5,0 union all
	Select 9,19,17,'Completed Mail Survey',901,/*110,*/6,0 union all
	Select 9,20,12,'Completed Phone Interview',902,/*120,*/6,0 union all
	Select 9,49,-1,'Breakoff is actually blank',913,/*350,*/7,0 union all
	Select 9,11,-1,'Breakoff',907,/*310,*/8,0 union all
	Select 9,14,-1,'Wrong, Disconnected or No Telephone Number',911,/*340,*/9,0 union all
	Select 9,16,-1,'Wrong, Disconnected or No Telephone Number',911,/*340,*/9,0 union all
	Select 9,5,-1,'Bad Address/Undeliverable Mail',910,/*330,*/10,0 union all
	Select 9,12,-1,'No Response After Maximum Attempts',914,/*350,*/11,1 union all
	Select 9,25,-1,'Blank first mail survey',912,/*350,*/11,0

select * from CAHPSDisposition where CahpsTypeID=9

select * from CahpsDispositionMapping where CahpsTypeID=9

--rollback tran
commit tran

