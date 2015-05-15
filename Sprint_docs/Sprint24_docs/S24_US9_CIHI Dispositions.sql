/*
S24_US9	dispositions (fielding)	
	as a CIHI vendor we need to store dispositions for proper data submission

Dave Gilsdorf

9.2	Analysis and fixing defect

*/

use nrc_datamart
go
if not exists (select * from dbo.cahpstype where label='Hospice CAHPS')
	and not exists (select * from dbo.cahpstype where CahpsTypeID=6)
	insert into dbo.cahpstype (CahpsTypeID,Label,NumberCutoffDays) values (6,'Hospice CAHPS',84)

if not exists (select * from dbo.cahpstype where label='CIHI CPES-IC')
	and not exists (select * from dbo.cahpstype where CahpsTypeID=7)
	insert into dbo.cahpstype (CahpsTypeID,Label,NumberCutoffDays) values (7,'CIHI CPES-IC',84)

if not exists (select * from dbo.cahpstype where label='Hospice CAHPS')
	or not exists (select * from dbo.cahpstype where label='CIHI CPES-IC')
		RAISERROR ('something went wrong....', 
					   16, -- Severity.
					   1 -- State.
					   );	

if not exists (select * from cahpsdisposition where cahpstypeid=6)
	insert into cahpsdisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
	values (601, 6, 'Completed Survey', 1, 0)
		 , (602, 6, 'Ineligible: Deceased', 0, 0)
		 , (603, 6, 'Ineligible: Not in Eligible Population', 0, 0)
		 , (604, 6, 'Ineligible: Language Barrier', 0, 0)
		 , (605, 6, 'Ineligible: Mental or Physical Incapacity', 0, 0)
		 , (606, 6, 'Ineligible: Never Involved in Decedent Care', 0, 0)
		 , (607, 6, 'Non-response: Break-off', 0, 1)
		 , (608, 6, 'Non-response: Refusal', 0, 0)
		 , (609, 6, 'Non-response: Non-response after max attempts', 0, 0)
		 , (610, 6, 'Non-response: Non-response: Bad Address', 0, 0)
		 , (611, 6, 'Non-response: Non-response: Bad/No Telephone Number', 0, 0)


if not exists (select * from cahpsdisposition where cahpstypeid=7)
	insert into cahpsdisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
	values (703, 7, 'Not in Eligible Population', 0, 0)
		 , (702, 7, 'Ineligible - Deceased', 0, 0)
		 , (706, 7, 'Mail/Phone or IVR is not complete', 0, 0)
		 , (701, 7, 'Complete and Valid Survey', 1, 0)
		 , (704, 7, 'Language Barrier', 0, 0)
		 , (705, 7, 'Mental/Physical Incapacitation', 0, 0)
		 , (710, 7, 'Non Response Bad Phone', 0, 0)
		 , (709, 7, 'Non Response Bad Address', 0, 0)
		 , (707, 7, 'Patient Refused', 0, 0)
		 , (708, 7, 'Maximum Attempts on Phone or Mail', 0, 0)

if not exists (select * from dbo.cahpsdispositionmapping where cahpstypeid=6)
	insert into dbo.cahpsdispositionmapping (CahpsTypeID,DispositionID,ReceiptTypeID,Label,CahpsDispositionID,CahpsHierarchy,IsDefaultDisposition)
	values (6,  2, -1, 'Non-response: Refusal', 608, 3, 0)
		 , (6,  3, -1, 'Ineligible: Deceased', 602, 2, 0)
		 , (6,  4, -1, 'Ineligible: Mental or Physical Incapacity', 605, 8, 0)
		 , (6,  5, -1, 'Non-response: Non-response: Bad Address', 610, 10, 0)
		 , (6,  8, -1, 'Ineligible: Not in Eligible Population', 603, 1, 0)
		 , (6, 10, -1, 'Ineligible: Language Barrier', 604, 7, 0)
		 , (6, 11, -1, 'Non-response: Break-off', 607, 6, 0)
		 , (6, 12, -1, 'Non-response: Non-response after max attempts', 609, 11, 1)
		 , (6, 13, -1, 'Completed Survey', 601, 5, 0)
		 , (6, 14, -1, 'Non-response: Non-response: Bad/No Telephone Number', 611, 9, 0)
		 , (6, 16, -1, 'Non-response: Non-response: Bad/No Telephone Number', 611, 9, 0)
		 , (6, 25, -1, 'Non-response: Non-response after max attempts', 609, 11, 0)
		 , (6, 45, -1, 'Ineligible: Never Involved in Decedent Care', 606, 4, 0)
		 , (6, 46, -1, 'Non-response: Unused Bad Address', 609, 12, 0)
		 , (6, 47, -1, 'Non-response: Unused Bad/No Telephone Number', 609, 12, 0)


if not exists (select * from dbo.cahpsdispositionmapping where cahpstypeid=7)
	insert into dbo.cahpsdispositionmapping (CahpsTypeID,DispositionID,ReceiptTypeID,Label,CahpsDispositionID,CahpsHierarchy,IsDefaultDisposition)
	values (7,  8, -1, 'Not in Eligible Population', 703, 1, 0)
		 , (7,  3, -1, 'Ineligible - Deceased', 702, 2, 0)
		 , (7, 11, -1, 'Mail/Phone or IVR is not complete', 706, 3, 0)
		 , (7, 13, -1, 'Complete and Valid Survey', 701, 4, 0)
		 , (7, 10, -1, 'Language Barrier', 704, 5, 0)
		 , (7,  4, -1, 'Mental/Physical Incapacitation', 705, 6, 0)
		 , (7, 14, -1, 'Non Response Bad Phone', 710, 7, 0)
		 , (7, 16, -1, 'Non Response Bad Phone', 710, 8, 0)
		 , (7,  5, -1, 'Non Response Bad Address', 709, 9, 0)
		 , (7,  2, -1, 'Patient Refused', 707, 10, 0)
		 , (7, 15, -1, 'CAHPS Mailed Late', 708, 11, 0)
		 , (7, 12, -1, 'Maximum Attempts on Phone or Mail', 708, 12, 1)



use nrc_datamart_CA
go
if not exists (select * from dbo.cahpstype where label='Hospice CAHPS')
	and not exists (select * from dbo.cahpstype where CahpsTypeID=6)
	insert into dbo.cahpstype (CahpsTypeID,Label,NumberCutoffDays) values (6,'Hospice CAHPS',84)

if not exists (select * from dbo.cahpstype where label='CIHI CPES-IC')
	and not exists (select * from dbo.cahpstype where CahpsTypeID=7)
	insert into dbo.cahpstype (CahpsTypeID,Label,NumberCutoffDays) values (7,'CIHI CPES-IC',84)

if not exists (select * from dbo.cahpstype where label='Hospice CAHPS')
	or not exists (select * from dbo.cahpstype where label='CIHI CPES-IC')
		RAISERROR ('something went wrong....', 
					   16, -- Severity.
					   1 -- State.
					   );	

if not exists (select * from cahpsdisposition where cahpstypeid=6)
	insert into cahpsdisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
	values (601, 6, 'Completed Survey', 1, 0)
		 , (602, 6, 'Ineligible: Deceased', 0, 0)
		 , (603, 6, 'Ineligible: Not in Eligible Population', 0, 0)
		 , (604, 6, 'Ineligible: Language Barrier', 0, 0)
		 , (605, 6, 'Ineligible: Mental or Physical Incapacity', 0, 0)
		 , (606, 6, 'Ineligible: Never Involved in Decedent Care', 0, 0)
		 , (607, 6, 'Non-response: Break-off', 0, 1)
		 , (608, 6, 'Non-response: Refusal', 0, 0)
		 , (609, 6, 'Non-response: Non-response after max attempts', 0, 0)
		 , (610, 6, 'Non-response: Non-response: Bad Address', 0, 0)
		 , (611, 6, 'Non-response: Non-response: Bad/No Telephone Number', 0, 0)


if not exists (select * from cahpsdisposition where cahpstypeid=7)
	insert into cahpsdisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
	values (703, 7, 'Not in Eligible Population', 0, 0)
		 , (702, 7, 'Ineligible - Deceased', 0, 0)
		 , (706, 7, 'Mail/Phone or IVR is not complete', 0, 0)
		 , (701, 7, 'Complete and Valid Survey', 1, 0)
		 , (704, 7, 'Language Barrier', 0, 0)
		 , (705, 7, 'Mental/Physical Incapacitation', 0, 0)
		 , (710, 7, 'Non Response Bad Phone', 0, 0)
		 , (709, 7, 'Non Response Bad Address', 0, 0)
		 , (707, 7, 'Patient Refused', 0, 0)
		 , (708, 7, 'Maximum Attempts on Phone or Mail', 0, 0)


if not exists (select * from dbo.disposition where DispositionID in (45,46,47))
	insert into disposition (DispositionID, Label)
	values (45, 'Ineligible: Never Involved in Decedent Care')
		 , (46, 'Non-response: Unused Bad Address')
		 , (47, 'Non-response: Unused Bad/No Telephone Number')

if not exists (select * from dbo.cahpsdispositionmapping where cahpstypeid=6)
	insert into dbo.cahpsdispositionmapping (CahpsTypeID,DispositionID,ReceiptTypeID,Label,CahpsDispositionID,CahpsHierarchy,IsDefaultDisposition)
	values (6,  2, -1, 'Non-response: Refusal', 608, 3, 0)
		 , (6,  3, -1, 'Ineligible: Deceased', 602, 2, 0)
		 , (6,  4, -1, 'Ineligible: Mental or Physical Incapacity', 605, 8, 0)
		 , (6,  5, -1, 'Non-response: Non-response: Bad Address', 610, 10, 0)
		 , (6,  8, -1, 'Ineligible: Not in Eligible Population', 603, 1, 0)
		 , (6, 10, -1, 'Ineligible: Language Barrier', 604, 7, 0)
		 , (6, 11, -1, 'Non-response: Break-off', 607, 6, 0)
		 , (6, 12, -1, 'Non-response: Non-response after max attempts', 609, 11, 1)
		 , (6, 13, -1, 'Completed Survey', 601, 5, 0)
		 , (6, 14, -1, 'Non-response: Non-response: Bad/No Telephone Number', 611, 9, 0)
		 , (6, 16, -1, 'Non-response: Non-response: Bad/No Telephone Number', 611, 9, 0)
		 , (6, 25, -1, 'Non-response: Non-response after max attempts', 609, 11, 0)
		 , (6, 45, -1, 'Ineligible: Never Involved in Decedent Care', 606, 4, 0)
		 , (6, 46, -1, 'Non-response: Unused Bad Address', 609, 12, 0)
		 , (6, 47, -1, 'Non-response: Unused Bad/No Telephone Number', 609, 12, 0)

if not exists (select * from dbo.cahpsdispositionmapping where cahpstypeid=7)
	insert into dbo.cahpsdispositionmapping (CahpsTypeID,DispositionID,ReceiptTypeID,Label,CahpsDispositionID,CahpsHierarchy,IsDefaultDisposition)
	values (7,  8, -1, 'Not in Eligible Population', 703, 1, 0)
		 , (7,  3, -1, 'Ineligible - Deceased', 702, 2, 0)
		 , (7, 11, -1, 'Mail/Phone or IVR is not complete', 706, 3, 0)
		 , (7, 13, -1, 'Complete and Valid Survey', 701, 4, 0)
		 , (7, 10, -1, 'Language Barrier', 704, 5, 0)
		 , (7,  4, -1, 'Mental/Physical Incapacitation', 705, 6, 0)
		 , (7, 14, -1, 'Non Response Bad Phone', 710, 7, 0)
		 , (7, 16, -1, 'Non Response Bad Phone', 710, 8, 0)
		 , (7,  5, -1, 'Non Response Bad Address', 709, 9, 0)
		 , (7,  2, -1, 'Patient Refused', 707, 10, 0)
		 , (7, 15, -1, 'CAHPS Mailed Late', 708, 11, 0)
		 , (7, 12, -1, 'Maximum Attempts on Phone or Mail', 708, 12, 1)


