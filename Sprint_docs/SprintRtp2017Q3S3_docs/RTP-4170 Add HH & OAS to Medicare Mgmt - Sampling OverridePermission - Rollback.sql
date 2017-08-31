/*
	RTP-4170 Add HH & OAS to Medicare Mgmt - Sampling OverridePermission - Rollback.sql
	Jing Fu, 8/31/2017

	Table:
		- Modify table Privilege
		- Modify table OrgUnitPrivilege
*/

USE [NRCAuth]
GO

PRINT 'Start rollback table changes'
GO

PRINT 'Rollback table Privilege'
GO
DECLARE @privilegeID AS INT
SELECT @privilegeID = Privilege_id FROM Privilege WHERE LOWER(strPrivilege_nm)= 'override sampling rate'

DELETE MemberPrivilege 
FROM MemberPrivilege 
INNER JOIN OrgUnitPrivilege ON MemberPrivilege.OrgUnitPrivilege_id=OrgUnitPrivilege.OrgUnitPrivilege_id
WHERE OrgUnitPrivilege.Privilege_id=@privilegeID

DELETE OrgUnitPrivilege WHERE Privilege_id=@privilegeID

DELETE Privilege WHERE  Privilege_id=@privilegeID
GO

PRINT 'End rollback table changes'
GO
