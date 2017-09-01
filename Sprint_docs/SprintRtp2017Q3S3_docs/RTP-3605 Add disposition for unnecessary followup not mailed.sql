/*
	RTP-3605 Add disposition for unnecessary followup not mailed.sql

	Lanny Boswell

	Insert Disposition

*/

use [QP_Prod]
go

if not exists (select * from Disposition where Disposition_id = 57)
begin
	set identity_insert dbo.Disposition on
	insert Disposition(Disposition_id, strDispositionLabel, Action_id, strReportLabel, MustHaveResults)
		values (57, 'Unnecessary followup not mailed', 0, 'Unnecessary followup not mailed', 0)
	set identity_insert dbo.Disposition off
end
go
