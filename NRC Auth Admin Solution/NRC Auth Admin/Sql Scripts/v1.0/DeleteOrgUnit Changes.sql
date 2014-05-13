----DELETE OrgUnit Functionality
ALTER PROCEDURE dbo.Auth_GetGroups
AS

SELECT Group_id, strGroup_nm, g.OrgUnit_id
FROM Groups g, OrgUnit ou
WHERE g.OrgUnit_id=ou.OrgUnit_id
AND ou.bitActive=1
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_GroupEmailList
AS

SELECT Group_id,strEmail,intEmailFormat
FROM Groups g, OrgUnit ou
WHERE g.OrgUnit_id=ou.OrgUnit_id
AND ou.bitActive=1
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_OrgUnitTree
	@OrgUnit_id			INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @OrgUnits TABLE (
	OrgUnit_id			INT,
	ParentOrgUnit_id	INT
)

INSERT INTO @OrgUnits
SELECT @OrgUnit_id,NULL

WHILE @@ROWCOUNT>0
BEGIN

INSERT INTO @OrgUnits
SELECT ou.OrgUnit_id, ou.ParentOrgUnit_id
FROM OrgUnit ou JOIN @OrgUnits t
ON t.OrgUnit_id=ou.ParentOrgUnit_id LEFT OUTER JOIN @OrgUnits tt
ON ou.OrgUnit_id=tt.OrgUnit_id
WHERE tt.OrgUnit_id IS NULL
AND ou.bitActive=1

END

SELECT * FROM @OrgUnits

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE dbo.Auth_PU_GetGroups @QPClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @PrivID INT
SELECT @PrivID=Privilege_id
FROM Application a, Privilege p
WHERE a.strApplication_nm='Project Updates'
AND a.Application_id=p.Application_id
AND p.strPrivilege_nm='Access Project Updates'


SELECT 0 Group_id, '' strGroup_nm
UNION ALL
SELECT g.Group_id, g.strGroup_nm
FROM OrgUnit ou, Groups g, OrgUnitPrivilege oup, GroupPrivilege gp
WHERE ou.QPClient_id=@QPClientID
AND ou.OrgUnit_id=g.OrgUnit_id
AND g.Group_id=gp.Group_id
AND ou.OrgUnit_id=oup.OrgUnit_id
AND oup.Privilege_id=@PrivID
AND oup.OrgUnitPrivilege_id=gp.OrgUnitPrivilege_id
AND oup.datGranted<GETDATE()
AND ISNULL(oup.datRevoked,'1/1/4000')>GETDATE()
AND ou.bitActive=1
ORDER BY g.strGroup_nm

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_SelectMember
	@UserName		VARCHAR(100)
AS

SELECT 	m.Member_id,
		m.OrgUnit_id,
		m.CreatorMember_id,
		m.datCreated,
		m.datLastLogin,
		m.datLocked,
		m.datRetired,
		m.datPasswordChanged,
		m.DaysTilPasswordExpires,
		m.MemberType_id,
		h.strHint,
		m.strHintAnswer,
		m.strMember_nm,
		m.strPassword,
		m.SaltValue,
		m.strFName,
		m.strLName,
		m.strTitle,
		m.strPhone,
		m.strCity,
		m.strState,
		m.strFacility_nm,
		m.strEmail,
		m.Author,
		m.datOccurred,
		n.NTLogin_nm		
FROM OrgUnit ou, Member m LEFT OUTER JOIN Hint h
ON m.Hint_id=h.Hint_id
LEFT OUTER JOIN NRCMembers n
ON m.Member_id=n.Member_id
WHERE strMember_nm=@UserName
AND ISNULL(datRetired,'1/1/4000')>GETDATE()
AND m.OrgUnit_id=ou.OrgUnit_id
AND ou.bitActive=1
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_SelectNRCMember
	@NTLogin		VARCHAR(100)
AS

SELECT 	m.Member_id,
		m.OrgUnit_id,
		m.CreatorMember_id,
		m.datCreated,
		m.datLastLogin,
		m.datLocked,
		m.datRetired,
		m.datPasswordChanged,
		m.DaysTilPasswordExpires,
		m.MemberType_id,
		h.strHint,
		m.strHintAnswer,
		m.strMember_nm,
		m.strPassword,
		m.SaltValue,
		m.strFName,
		m.strLName,
		m.strTitle,
		m.strPhone,
		m.strCity,
		m.strState,
		m.strFacility_nm,
		m.strEmail,
		m.Author,
		m.datOccurred,
		n.NTLogin_nm		
FROM OrgUnit ou, Member m LEFT OUTER JOIN Hint h
ON m.Hint_id=h.Hint_id
LEFT OUTER JOIN NRCMembers n
ON m.Member_id=n.Member_id
WHERE NTLogin_nm=@NTLogin
AND ISNULL(datRetired,'1/1/4000')>GETDATE()
AND m.OrgUnit_id=ou.OrgUnit_id
AND ou.bitActive=1
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_SelectOrgUnit
	@OrgUnitID		INT,
	@ShowTree		BIT=0
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

IF @ShowTree=0
	SELECT 	o.OrgUnit_id,
			o.QPClient_id,
			o.strOrgUnit_nm,
			o.strOrgUnit_dsc,
			o.ParentOrgUnit_id,
			o.datCreated,
			o.strOrgUnit_dsc,
			CASE WHEN cnt IS NULL THEN 0 ELSE 1 END HasChildren,
			StripIPAddressFilter IPAddressFilter,
			OrgUnitType_id,
			bitActive,
			TermsOfUse
	FROM OrgUnit o LEFT OUTER JOIN (
		SELECT ParentOrgUnit_id, COUNT(*) cnt 
		FROM OrgUnit
		WHERE ParentOrgUnit_id=@OrgUnitID
		AND bitActive=1
		GROUP BY ParentOrgUnit_id) a
	ON o.OrgUnit_id=a.ParentOrgUnit_id LEFT OUTER JOIN ClientIPAddressFilter f
	ON o.QPClient_id=f.QPClient_id LEFT OUTER JOIN ClientTermsOfUse tou
	ON o.QPClient_id=tou.QPClient_id
	WHERE o.OrgUnit_id=@OrgUnitID
ELSE
BEGIN

	--Temp table to hold the tree
	CREATE TABLE #OUs (OrgUnit_id INT, ParentOrgUnit_id INT)

	--Insert the parent orgunit_id
	INSERT INTO #OUs
	SELECT OrgUnit_id, ParentOrgUnit_id
	FROM OrgUnit
	WHERE OrgUnit_id=@OrgUnitID
	
	--loop to add all children orgunits that are not already in the #OUs table
	WHILE @@ROWCOUNT>0
	BEGIN

		INSERT INTO #OUs
		SELECT a.OrgUnit_id, a.ParentOrgUnit_id
		FROM (SELECT ou.OrgUnit_id, ou.ParentOrgUnit_id FROM #OUs t, OrgUnit ou
		WHERE t.OrgUnit_id=ou.ParentOrgUnit_id AND ou.bitActive=1) a LEFT OUTER JOIN #OUs o
		ON a.OrgUnit_id=o.OrgUnit_id
		WHERE o.OrgUnit_id IS NULL
		
	END

	UPDATE t
	SET t.ParentOrgUnit_id=NULL
	FROM #OUs t LEFT OUTER JOIN #OUs ou
	ON t.ParentOrgUnit_id=ou.OrgUnit_id
	WHERE ou.OrgUnit_id IS NULL

	SELECT 	o.OrgUnit_id,
			o.QPClient_id,
			o.strOrgUnit_nm,
			o.strOrgUnit_dsc,
			o.ParentOrgUnit_id,
			o.datCreated,
-- 			o.strOrgUnit_dsc,
			CASE WHEN cnt IS NULL THEN 0 ELSE 1 END HasChildren,
			StripIPAddressFilter IPAddressFilter,
			OrgUnitType_id,
			bitActive,
			TermsOfUse
	INTO #TempOU
	FROM OrgUnit o LEFT OUTER JOIN (
		SELECT ou.ParentOrgUnit_id, COUNT(*) cnt 
		FROM OrgUnit ou, #OUs t
		WHERE t.OrgUnit_id=ou.OrgUnit_id
		AND ou.bitActive=1
		GROUP BY ou.ParentOrgUnit_id) a
	ON o.OrgUnit_id=a.ParentOrgUnit_id LEFT OUTER JOIN ClientIPAddressFilter f
	ON o.QPClient_id=f.QPClient_id LEFT OUTER JOIN ClientTermsOfUse tou
	ON o.QPClient_id=tou.QPClient_id JOIN #OUs tt
	ON o.OrgUnit_id=tt.OrgUnit_id
	ORDER BY strOrgUnit_nm

	UPDATE tou
	SET ParentOrgUnit_id=t.ParentOrgUnit_id
	FROM #OUs t, #TempOU tou
	WHERE t.OrgUnit_id=tou.OrgUnit_id

	SELECT *
	FROM #TempOU
	ORDER BY strOrgUnit_nm

END

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO
--------------------------------------------------------------------------------------------------
GO
ALTER     PROCEDURE Auth_SelectOrgUnitChildren
	@OrgUnitID		INT
AS

SELECT 	OrgUnit_id,
		strOrgUnit_nm,
		strOrgUnit_dsc,
		o.ParentOrgUnit_id,
		datCreated,
		strOrgUnit_dsc,
		CASE WHEN cnt IS NULL THEN 0 ELSE 1 END HasChildren,
		StripIPAddressFilter IPAddressFilter,
		OrgUnitType_id,
		bitActive,
		TermsOfUse
FROM OrgUnit o LEFT OUTER JOIN (
	SELECT ParentOrgUnit_id, COUNT(*) cnt 
	FROM OrgUnit
	WHERE bitActive=1
	GROUP BY ParentOrgUnit_id) a
ON o.OrgUnit_id=a.ParentOrgUnit_id LEFT OUTER JOIN ClientIPAddressFilter f
ON o.QPClient_id=f.QPClient_id LEFT OUTER JOIN ClientTermsOfUse tou
ON o.QPClient_id=tou.QPClient_id
WHERE o.ParentOrgUnit_id=@OrgUnitID
AND o.bitActive=1
ORDER BY strOrgUnit_nm
GO
--------------------------------------------------------------------------------------------------
GO
--Rename of 'Access eToolKit' privilege------------------------------------------------------------------------------------------------
GO
UPDATE Privilege SET strPrivilege_nm = 'IP eToolKit' WHERE strPrivilege_nm = 'Access eToolKit'
GO
--Change DeleteGroup proc------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_RetireGroup
	@GroupID			INT,
	@MemberID			INT
AS

UPDATE Groups
SET strGroup_nm=CONVERT(VARCHAR,@GroupID)+'_'+SUBSTRING(strGroup_nm,1,100-LEN(@GroupID)-1),
	datRetired=GETDATE(),
	Author=@MemberID,
	datOccurred=GETDATE()
WHERE Group_id=@GroupID

--Now Cleanup in the Datamart
DECLARE @Server VARCHAR(2000), @sql VARCHAR(8000)
SELECT @Server=strParam_Value FROM NRCAuth_Params WHERE strParam_nm='Datamart'
SELECT @sql='EXECUTE '+@Server+'dbo.Auth_DeleteGroup '+LTRIM(STR(@GroupID))
EXEC (@sql)
GO
--------------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE Auth_UpdateOrgUnit
	@OrgUnitID		INT,
	@Name			VARCHAR(50),
	@Description	VARCHAR(200),
	@OrgUnitType	INT,
	@ParentOrgUnit	INT,
	@Active			BIT,
	@Author			INT
AS

IF @Active = 0
BEGIN
	SET @Name = CONVERT(VARCHAR, @OrgUnitID) + @Name
END

UPDATE OrgUnit
SET 	strOrgUnit_nm=@Name,
		strOrgUnit_dsc=@Description,
		ParentOrgUnit_id=CASE WHEN @ParentOrgUnit=-1 THEN NULL ELSE @ParentOrgUnit END,
		OrgUnitType_id=@OrgUnitType,
		bitActive=@Active,
		Author=@Author,
		datOccurred=GETDATE()
WHERE OrgUnit_id=@OrgUnitID
GO
--------------------------------------------------------------------------------------------------
GO
