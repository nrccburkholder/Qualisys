/*
	RTP-3605 Add disposition for unnecessary followup not mailed - rollback.sql

	Lanny Boswell

	Delete Disposition

*/

use [QP_Prod]
go

delete dbo.Disposition where Disposition_id = 57 and strDispositionLabel = 'Unnecessary followup not mailed'
go
