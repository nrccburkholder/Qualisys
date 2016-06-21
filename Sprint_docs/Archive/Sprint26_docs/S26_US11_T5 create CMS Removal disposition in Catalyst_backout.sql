/*
	S26.US11	ICHCAHPS submission file changes
		as an authorized ICHCAHPS vendor, we must remove records from the submission file that were sampled in error


	T11.5	create a 'CMS Removal' disposition and put it at the top of ICHCAHPS' hierarchy

Dave Gilsdorf

NRC_Datamart:
INSERT INTO dbo.cahpsdisposition
UPDATE/INSERT INTO cahpsdispositionmapping 
*/
use nrc_datamart
go

if exists (select * from cahpsdisposition where cahpstypeid=5 and label = 'CMS Removal')
	delete from cahpsdisposition where cahpstypeid=5 and label = 'CMS Removal'

if exists (select * from cahpsdispositionmapping where cahpstypeid=5 and label = 'CMS Removal')
begin
	delete from cahpsdispositionmapping where cahpstypeid=5 and label = 'CMS Removal'
	update cahpsdispositionmapping set CahpsHierarchy=CahpsHierarchy-1 where cahpstypeid=5
end

if exists (select * from disposition where label = 'CMS Removal')
	delete from disposition where label = 'CMS Removal'