/*
S9.US10	HCAHPS Phone Lag Time Fix
		As an Authorized Vendor, we want to correctly calculate the lag time for phone non-response dispositions, so that we can report correct data to CMS

T10.1	Add IsFinal column to database (vendor disposition table) and inserting records

Dave Gilsdorf

alter table [dbo].[vendordispositions]
update/insert [dbo].[vendordispositions]
insert into disposition 
*/
use qp_prod
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'vendordispositions' 
					   AND sc.NAME = 'isFinal' )
	alter table [dbo].[vendordispositions] add isFinal tinyint
go
if exists (select * from vendordispositions where isFinal is null)
begin
	update VendorDispositions set isFinal=9 where Disposition_id<>12
	update VendorDispositions set isFinal=1 where Disposition_id=12

	declare @newDispCode int
	insert into disposition (strDispositionLabel,Action_id,strReportLabel,MustHaveResults)
	values ('Non Response, Still Attempting',0,'Non Response, Still Attempting',0)
	set @newDispCode = scope_identity()

	insert into VendorDispositions (Vendor_ID, Disposition_ID, VendorDispositionCode, VendorDispositionLabel, VendorDispositionDesc, DateCreated, isFinal)
	select Vendor_ID, @newDispCode as Disposition_ID, VendorDispositionCode, VendorDispositionLabel, VendorDispositionDesc, getdate() as DateCreated, 0 as isFinal
	from VendorDispositions 
	where isFinal=1
end
go
commit tran

