/*
	RTP-4105 Add comment code for non English comment.sql

	Lanny Boswell

	Insert CommentCodes

*/

use [QP_Prod]
go

IF EXISTS (SELECT * FROM CommentCodes WHERE CmntCode_id=1016 AND strCmntCode_Nm<>'Non-English Original Comment')
BEGIN
       RAISERROR(N'Another code already uses CmntCode_id=1016',10,1)
END
ELSE IF NOT EXISTS (SELECT * FROM CommentCodes WHERE CmntCode_id=1016 AND strCmntCode_Nm='Non-English Original Comment')
BEGIN
       UPDATE dbo.CommentCodes 
       SET intOrder=intOrder+1
       WHERE CmntSubHeader_id=1
       AND intOrder>=19

       SET IDENTITY_INSERT dbo.CommentCodes ON
       INSERT INTO dbo.CommentCodes (CmntCode_id, CmntSubHeader_id, strCmntCode_Nm, bitRetired, strModifiedBy, datModified, intOrder, Disposition_id)
       VALUES (1016, 1, 'Non-English Original Comment', 0, 'dgilsdorf', getdate(), 19, NULL)
       SET IDENTITY_INSERT dbo.CommentCodes Off
END
GO