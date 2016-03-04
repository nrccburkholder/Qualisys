/*

Sprint 44 User Story 14: Update Practice Site Submission File Proc.

Brendan Goble

*/

use QP_Prod
go

if not exists (
	select *
	from sys.columns c inner join sys.tables t on t.object_id = c.object_id
	where t.schema_id = schema_id('dbo') and t.name = 'PracticeSite' and c.name = 'Sampling'
)
begin
	alter table dbo.PracticeSite add Sampling tinyint not null constraint DF_PracticeSite_Sampling default ((1));
end
go