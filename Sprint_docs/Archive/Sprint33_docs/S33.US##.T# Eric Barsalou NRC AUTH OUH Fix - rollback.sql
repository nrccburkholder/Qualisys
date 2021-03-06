/*

S33.US##.T# Eric Barsalou NRC AUTH OUH Fix - rollback.sql

Eric Barsalou via Chris Burkholder 

ALTER PROCEDURE [Auth_SelectOrgUnitApplications]

*/
USE [NRCAuth]
GO
/****** Object:  StoredProcedure [dbo].[Auth_SelectOrgUnitApplications]    Script Date: 9/14/2015 12:38:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Auth_SelectOrgUnitApplications]  
 @OrgUnitID   INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET NOCOUNT ON  

SELECT a.Application_id
INTO #OUApps
FROM OrgUnitPrivilege oup, Privilege p, Application a 
WHERE oup.OrgUnit_id=@OrgUnitID 
AND oup.Privilege_id=p.Privilege_id 
AND ISNULL(oup.datRevoked,'1/1/4000')>GETDATE()
AND p.Application_id=a.Application_id
AND oup.datGranted<GETDATE()
GROUP BY a.Application_id  

SELECT a.Application_id, strApplication_nm, strApplication_dsc, DeploymentType_id, 
 strPath, strCategory_nm, IconImage, bitInternal 
FROM #OUApps oa, Application a 
WHERE oa.Application_id=a.Application_id 
ORDER BY a.strApplication_nm
  
SELECT OrgUnitPrivilege_id, p.Application_id, p.Privilege_id, strPrivilege_nm,   
 ISNULL(strPrivilege_dsc,strPrivilege_nm) strPrivilege_dsc, datRevoked,  PrivilegeLevel_id 
FROM OrgUnitPrivilege oup, Privilege p 
WHERE oup.OrgUnit_id=@OrgUnitID 
AND oup.Privilege_id=p.Privilege_id 
AND ISNULL(oup.datRevoked,'1/1/4000')>GETDATE()
AND oup.datGranted<GETDATE()
ORDER BY p.Application_id, p.strPrivilege_nm  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
SET NOCOUNT OFF  
  
