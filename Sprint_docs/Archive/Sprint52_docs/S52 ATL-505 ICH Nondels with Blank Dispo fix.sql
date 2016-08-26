/*

S52 ATL-505 ICH Nondels w/ Blank Dispo - Research

Tim Butler

Figure out how "blank first survey" disposition is being assigned to a non-del

The wrong disposition was flagged as IsDefaultDispoistion for ICH Cahps

Should have been dispostion 12 instead of 25


Also, during the ETL, the process disposition step joins with CahpsDispositionMapping on dispositionid and receipttypeid. 
The samplepop's in question had receipttypeid's of 0, 7, 8, and 19. These receipttypeid's are not included in the mapping table, 
so ultimately these dispositions will end up with the default dispositionid (25, soon to be 12). 
The fix is adding additional mapping records for disposition 5 with receipttypeid's 0,7,8, and 19.

Also, adding ReceiptType 19 (USPS Address Change) to ReceiptType table.

*/

USE NRC_Datamart

begin tran

update [dbo].[CahpsDispositionMapping]
	SET IsDefaultDisposition = 0
where CahpsTypeID = 5
and DispositionID = 25


update [dbo].[CahpsDispositionMapping]
	SET IsDefaultDisposition = 1
where CahpsTypeID = 5
and DispositionID = 12

commit tran

GO


USE NRC_Datamart

begin tran


if not exists (select 1 from dbo.ReceiptType where ReceiptTypeID = 19 and [label] = 'USPS Address Change')
	INSERT INTO [dbo].[ReceiptType]([ReceiptTypeID],[Label])VALUES(19,'USPS Address Change')

commit tran

GO


use NRC_Datamart

begin tran

	if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = 5 and DispositionID = 5 and ReceiptTypeID = 0)
		insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
		Select 5,5,0,'Bad Address/Undeliverable Mail',5230,14,0

	if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = 5 and DispositionID = 5 and ReceiptTypeID = 7)
		insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
		Select 5,5,7,'Bad Address/Undeliverable Mail',5230,14,0

	if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = 5 and DispositionID = 5 and ReceiptTypeID = 8)
		insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
		Select 5,5,8,'Bad Address/Undeliverable Mail',5230,14,0

	if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = 5 and DispositionID = 5 and ReceiptTypeID = 19)
		insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
		Select 5,5,19,'Bad Address/Undeliverable Mail',5230,14,0

commit tran
