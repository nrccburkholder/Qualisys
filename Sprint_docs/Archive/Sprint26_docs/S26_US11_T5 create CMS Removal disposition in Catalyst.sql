/*
	S26.US11	ICHCAHPS submission file changes
		as an authorized ICHCAHPS vendor, we must remove records from the submission file that were sampled in error


	T11.5	create a 'CMS Removal' disposition and put it at the top of ICHCAHPS' hierarchy

Dave Gilsdorf

NRC_Datamart:
INSERT INTO dbo.cahpsdisposition
INSERT INTO dbo.disposition 
UPDATE/INSERT INTO cahpsdispositionmapping 
*/
use nrc_datamart
go

if not exists (select * from cahpsdisposition where cahpstypeid=5 and label = 'CMS Removal')
	insert into cahpsdisposition (CahpsDispositionID, CahpsTypeID, Label, IsCahpsDispositionComplete, IsCahpsDispositionInComplete)
	values (5999, 5, 'CMS Removal', 0, 0)

if not exists (select * from disposition where label = 'CMS Removal')
	insert into disposition (DispositionID, label) values (48, 'CMS Removal')
	
if not exists (select * from cahpsdispositionmapping where cahpstypeid=5 and label = 'CMS Removal')
begin
	update cahpsdispositionmapping set CahpsHierarchy=CahpsHierarchy+1 where cahpstypeid=5
	insert into cahpsdispositionmapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	values (5, 48, -1, 'CMS Removal', '5999', 0, 0)
end

