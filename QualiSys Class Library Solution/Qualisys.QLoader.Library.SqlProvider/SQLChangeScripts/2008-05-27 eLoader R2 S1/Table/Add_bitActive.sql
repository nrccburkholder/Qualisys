--*****************************************************************
--**  add Active Flag field to Package table
--*****************************************************************
use qp_load

begin tran
--add Active flag to package and package_history tables.
alter table package 
add bitActive bit
GO
alter table package_history
add bitActive bit
GO
--add Active flage to package view.

ALTER VIEW dbo.Package_View    
AS    
SELECT     Package_id, intVersion, strPackage_nm, Client_id, Study_id, intTeamNumber, strLogin_nm, datLastModified, bitArchive, datArchive, FileType_id,     
                      FileTypeSettings, SignOffBy_id, datCreated, strPackageFriendly_nm, bitActive
FROM         Package    
UNION    
SELECT     Package_id, intVersion, strPackage_nm, Client_id, Study_id, intTeamNumber, strLogin_nm, datLastModified, bitArchive, datArchive, FileType_id,     
                      FileTypeSettings, SignOffBy_id, datCreated, strPackageFriendly_nm, bitActive
FROM         Package_History    
GO

--back populate newly created fields
update package set bitActive = 1
GO
update package_history set bitActive = 1
GO


commit tran