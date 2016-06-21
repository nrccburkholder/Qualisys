/*

Sprint 44 User Story 14: Update Practice Site Submission File Proc.

Brendan Goble

ROLLBACK

*/

use QP_Prod
go

if exists (
	select *
	from sys.columns c inner join sys.tables t on t.object_id = c.object_id
	where t.schema_id = schema_id('dbo') and t.name = 'PracticeSite' and c.name = 'Sampling'
)
begin
	alter table dbo.PracticeSite drop constraint DF_PracticeSite_Sampling;
	alter table dbo.PracticeSite drop column Sampling;
end
go