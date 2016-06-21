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
if exists (	SELECT 1 
			FROM   sys.tables st 
				   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
			WHERE  st.schema_id = 1 
				   AND st.NAME = 'vendordispositions' 
				   AND sc.NAME = 'isFinal' )
	alter table [dbo].[vendordispositions] drop column isFinal 
go
if exists (select * from disposition where strDispositionLabel='Non Response, Still Attempting')
begin
	declare @newDispCode int
	select @newDispCode=Disposition_id
	from disposition 
	where strDispositionLabel='Non Response, Still Attempting'
	
	delete 
	from VendorDispositions 
	where Disposition_ID=@newDispCode 

	delete 
	from Disposition
	where Disposition_ID=@newDispCode 
end
go
commit tran



