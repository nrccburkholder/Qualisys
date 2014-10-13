/*
S10.US6	Change to TestPrints
		As an Implementation Associate, I want to do test prints for dynamically created Cover Letters, so that I know the coverletters are created correctly.

T6.1	Modify the SP to pick the representive sample from the study that produces each of the cover letters. 

Dave Gilsdorf

CREATE PROCEDURE dbo.CoverVariationGetMap
CREATE PROCEDURE dbo.CoverVariationList

*/
use qp_prod
go
begin tran
go
if exists (select * from sys.procedures where schema_id=1 and name = 'CoverVariationGetMap')
	drop procedure dbo.CoverVariationGetMap
go
if exists (select * from sys.procedures where schema_id=1 and name = 'CoverVariationList')
	drop procedure dbo.CoverVariationList
go
commit tran