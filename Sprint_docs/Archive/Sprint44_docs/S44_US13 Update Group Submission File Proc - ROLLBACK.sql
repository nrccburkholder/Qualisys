/*

Sprint 44 User Story 13: Update Group Submission File Proc.

Brendan Goble

ROLLBACK

*/

use QP_Comments
go

if exists (select * from sys.procedures where name = 'GetCGCahpsGroupInfo' and schema_id = SCHEMA_ID('dbo'))
	drop procedure dbo.GetCGCahpsGroupInfo;
go
/*
Procedure to return group information for cgcahps submissions.  Is used in conjunction with proc GetCGCahpsPracticeSiteInfo.

01/13/2012	DRM		Initial creation.
*/
CREATE proc [dbo].[GetCGCahpsGroupInfo]   
@groupid int  
as  
select  
 right(space(10) + cast(isnull(cggroupid,0) as varchar), 10)+   --GroupID  
 right(space(50) + rtrim(ltrim(isnull(groupname,''))), 50)+    --GroupName  
 right(space(30) + rtrim(ltrim(isnull(addr1,''))), 30)+     --Street Address 1  
 right(space(30) + rtrim(ltrim(isnull(addr2,''))), 30)+     --Street Address 2  
 right(space(30) + rtrim(ltrim(isnull(city,''))), 30)+     --City  
 right(space(2) + rtrim(ltrim(isnull(st,''))), 2)+      --State  
 right(space(5) + rtrim(ltrim(isnull(Zip5,''))), 5)+      --Zip Code  
 right(space(10) + rtrim(ltrim(isnull(phone,''))), 10)+     --Phone Number  
 right('00' + isnull(groupownership,'  '), 2)+   --Group Ownership and Affiliation  
 --case when len(groupownership) = 0 then ' '  
 --else right(('0' + groupownership),2)  
 --end +  
 right(space(30) + rtrim(ltrim(isnull(groupcontactname,''))), 30)+  --Group Contact Name  
 right(space(10) + rtrim(ltrim(isnull(groupcontactphone,''))), 10)+  --Group Contact Phone  
 right(space(30) + rtrim(ltrim(isnull(groupcontactemail,''))), 30)  --Group Contact Email  
from CGCAHPSGroup  
where cggroupid = @groupid
go