CREATE PROCEDURE DBO.SP_QDE_UpdateComment
@Cmnt_id INT,
@strCmntText TEXT,
@CmntType_id INT,
@CmntValence_id INT,
@datKeyed DATETIME,
@strKeyedBy VARCHAR(50),
@datKeyVerified DATETIME,
@strKeyVerifiedBy VARCHAR(50),
@datCoded DATETIME,
@strCodedBy VARCHAR(50),
@datCodeVerified DATETIME,
@strCodeVerifiedBy VARCHAR(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

UPDATE QDEComments
SET 	strCmntText = @strCmntText,
	CmntType_id = @CmntType_id,
	CmntValence_id = @CmntValence_id,
	datKeyed = @datKeyed,
	strKeyedBy = @strKeyedBy,
	datKeyVerified = @datKeyVerified,
	strKeyVerifiedBy = @strKeyVerifiedBy,
	datCoded = @datCoded,
	strCodedBy = @strCodedBy,
	datCodeVerified = @datCodeVerified,
	strCodeVerifiedBy = @strCodeVerifiedBy
WHERE Cmnt_id = @Cmnt_id


