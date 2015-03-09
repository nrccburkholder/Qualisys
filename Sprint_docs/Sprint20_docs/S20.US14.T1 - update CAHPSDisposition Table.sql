/*
	S20.US14 Hospice CAHPS Dispositions
		As a Hospice CAHPS vendor, we need to be able to assign the appropriate final disposition so it can be reported to CMS.

	T14.1	Update CAHPSDiposition Table

Dave Gilsdorf

NRC_Datamart:
insert into CahpsDispositionMapping 

note: query ran in qp_prod to get the values below:
	select 6 as CahpsTypeID
		, Disposition_id as DispositionID
		, case when ReceiptType_ID in (19,21) then 17 when ReceiptType_ID in (20,22) then 12 else -1 end as ReceiptTypeID
					-- note: none of Hospice CAHPS dipsositions are methodology dependent, so all ReceiptTypeID values are -1
		, [desc] as Label
		, [value] as CahpsDispositionID
		, Hierarchy as CahpsHierarchy
		, case when disposition_id=12 then 1 else 0 end as IsDefaultDisposition 
	from SurveyTypeDispositions 
	where surveytype_id=11
	and [value] is not null
*/
use NRC_Datamart
go
begin tran
if not exists (select * from disposition where dispositionid in (45,46,47))
	insert into dbo.Disposition (DispositionID, Label) 
	values (45, N'Ineligible: Never Involved in Decedent Care')
	, (46, N'Non-response: Unused Bad Address')
	, (47, N'Non-response: Unused Bad/No Telephone Number')

if not exists (select * from CahpsDispositionMapping where CahpsTypeID=6)
	insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	select CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition
	FROM (
	SELECT N'6' AS [CahpsTypeID], N'8' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Ineligible: Not in Eligible Population' AS [Label], N'3' AS [CahpsDispositionID], N'1' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'3' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Ineligible: Deceased' AS [Label], N'2' AS [CahpsDispositionID], N'2' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'2' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Refusal' AS [Label], N'8' AS [CahpsDispositionID], N'3' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'13' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Completed Survey' AS [Label], N'1' AS [CahpsDispositionID], N'5' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'11' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Break-off' AS [Label], N'7' AS [CahpsDispositionID], N'6' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'10' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Ineligible: Language Barrier' AS [Label], N'4' AS [CahpsDispositionID], N'7' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'4' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Ineligible: Mental or Physical Incapacity' AS [Label], N'5' AS [CahpsDispositionID], N'8' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'5' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Non-response: Bad Address' AS [Label], N'10' AS [CahpsDispositionID], N'10' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'14' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Non-response: Bad/No Telephone Number' AS [Label], N'11' AS [CahpsDispositionID], N'9' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'16' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Non-response: Bad/No Telephone Number' AS [Label], N'11' AS [CahpsDispositionID], N'9' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'12' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Non-response after max attempts' AS [Label], N'9' AS [CahpsDispositionID], N'11' AS [CahpsHierarchy], N'1' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'25' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Non-response after max attempts' AS [Label], N'9' AS [CahpsDispositionID], N'11' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'45' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Ineligible: Never Involved in Decedent Care' AS [Label], N'6' AS [CahpsDispositionID], N'4' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'46' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Unused Bad Address' AS [Label], N'9' AS [CahpsDispositionID], N'12' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] UNION ALL
	SELECT N'6' AS [CahpsTypeID], N'47' AS [DispositionID], N'-1' AS [ReceiptTypeID], N'Non-response: Unused Bad/No Telephone Number' AS [Label], N'9' AS [CahpsDispositionID], N'12' AS [CahpsHierarchy], N'0' AS [IsDefaultDisposition] ) t;

if not exists (select * from CAHPSDisposition where CahpsTypeID=6)
	insert into dbo.CAHPSDisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
	select 600+cahpsdispositionID, cahpstypeid, min(label) as label
	, case when cahpsdispositionid in (1) then 1 else 0 end as IsCahpsDispositionComplete
	, case when cahpsdispositionid in (7) then 1 else 0 end as IsCahpsDispositionInComplete 
	from CahpsDispositionMapping 
	where cahpstypeid=6 
	group by cahpsdispositionID, cahpstypeid
	order by 1

commit tran

