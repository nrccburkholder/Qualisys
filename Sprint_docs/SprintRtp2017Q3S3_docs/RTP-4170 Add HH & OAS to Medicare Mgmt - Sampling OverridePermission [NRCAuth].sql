/*
	RTP-4170 Add HH & OAS to Medicare Mgmt - Sampling OverridePermission.sql
	Jing Fu, 8/31/2017
	Table:
		- Modify table Privilege
		- Modify table OrgUnitPrivilege
*/

USE [NRCAuth]
GO

PRINT 'Start table changes'
GO

PRINT 'Insert record to table Privilege'
GO
DECLARE @Application_id AS INT, @Author AS INT, @PrivilegeLevel_id AS INT, @privilegeID AS INT
SELECT @Application_id=Application_id FROM [Application] WHERE Lower(strApplication_nm)='configuration manager'
SELECT @PrivilegeLevel_id=PrivilegeLevel_id FROM PrivilegeLevel WHERE Lower(strPrivilegeLevel_dsc)='member level privilege'
SELECT Top 1 @Author=Member_id FROM member WHERE strFName LIKE '%chris%' AND strLName LIKE '%Burkholder%' ORDER BY datCreated

DECLARE @maxSeed INT
SELECT @maxSeed=MAX(Privilege_id) FROM Privilege
DBCC CHECKIDENT ('dbo.Privilege', RESEED, @maxSeed)

INSERT INTO Privilege
           (Application_id, strPrivilege_nm, strPrivilege_dsc, Author, datOccurred, PrivilegeLevel_id)
VALUES (@Application_id, 'Override Sampling Rate', 'Allows access to the sampling rate override.' , @Author, GETDATE(), @PrivilegeLevel_id)

SELECT @privilegeID = SCOPE_IDENTITY()

SELECT @maxSeed=MAX(OrgUnitPrivilege_id) FROM OrgUnitPrivilege
DBCC CHECKIDENT ('dbo.OrgUnitPrivilege', RESEED, @maxSeed);  

INSERT INTO OrgUnitPrivilege (OrgUnit_id, Privilege_id, datGranted, datRevoked, Author, datOccurred) 
SELECT OrgUnit_ID, @privilegeID, GETDATE(), NULL, @Author, GETDATE() FROM OrgUnit WHERE strOrgUnit_nm IN ('NRCIS', 'NRC General')

GO

PRINT 'End table changes'
GO

