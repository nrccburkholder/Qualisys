CREATE PROCEDURE SP_QDE_LithoStatus
@strLithoCode VARCHAR(20)
AS

SELECT c.Cmnt_id, c.QstnCore, c.datKeyed, c.strKeyedBy, c.datKeyVerified, c.strKeyVerifiedBy, c.datCoded, c.strCodedBy, c.datCodeVerified, c.strCodeVerifiedBy, datFinalized
FROM QDEForm q, QDEComments c, QDEBatch b
WHERE q.strLithoCode=@strLithoCode
AND q.Form_id=c.Form_id
AND q.Batch_id=b.Batch_id


