/*
	RTP-4105 Add comment code for non English comment - rollback.sql

	Lanny Boswell

	Delete CommentCodes

*/

use [QP_Prod]
go

IF EXISTS (SELECT * FROM CommentCodes WHERE CmntCode_id=1016 AND strCmntCode_Nm='Non-English Original Comment')
BEGIN
	DELETE CommentCodes WHERE CmntCode_id=1016 AND strCmntCode_Nm='Non-English Original Comment'

	UPDATE dbo.CommentCodes 
	SET intOrder=intOrder-1
	WHERE CmntSubHeader_id=1
	AND intOrder>19
END
GO