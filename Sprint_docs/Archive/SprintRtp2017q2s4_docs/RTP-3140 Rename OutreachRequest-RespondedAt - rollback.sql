/*

	RTP-3140 Rename OutreachRequest-RespondedAt - rollback.sql

	Lanny Boswell

	6/9/2017
*/

use qp_prod
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS c 
		WHERE c.COLUMN_NAME = 'VendorRespondedAt' 
		AND c.TABLE_NAME = 'OutreachRequest'
		AND c.TABLE_SCHEMA = 'RTPhoenix')
	EXEC sys.sp_rename 'RTPhoenix.OutreachRequest.VendorRespondedAt', 'RespondedAt', 'COLUMN'

