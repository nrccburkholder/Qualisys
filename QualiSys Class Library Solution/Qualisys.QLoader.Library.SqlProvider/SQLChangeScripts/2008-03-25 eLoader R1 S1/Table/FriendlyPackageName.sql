--*****************************************************************
--**  add Package Friendly Name field to Package table
--*****************************************************************
use qp_load

--identify tables related to "package"
/*
select * from information_schema.tables where table_name like '%package%'
select * from information_schema.columns where column_name = 'package_id'

select top 10 * from package
select top 10 * from package_history
select top 10 * from packagelock
select top 10 * from packagetable
select top 10 * from packagetable_history
select top 10 * from packagenotes
select top 10 * from loading_params

select top 10 * from package_view
select top 10 * from packagetable_view

sp_help package
sp_help package_history
--package_history has same makeup as package.  probably will need to add field there as well.


select top 10 * from metatable
select * from information_schema.tables where table_name like '%meta%'
--meta tables don't exist on qloader.  on qualisys, they're used to describe data elements on surveys.
*/

--add friendly package name to package and package_history tables.
alter table package 
add strPackageFriendly_nm varchar(100)
GO
alter table package_history
add strPackageFriendly_nm varchar(100)
GO
--add friendly package name to package view.
--sp_helptext package_view

ALTER VIEW dbo.Package_View    
AS    
SELECT     Package_id, intVersion, strPackage_nm, Client_id, Study_id, intTeamNumber, strLogin_nm, datLastModified, bitArchive, datArchive, FileType_id,     
                      FileTypeSettings, SignOffBy_id, datCreated, strPackageFriendly_nm
FROM         Package    
UNION    
SELECT     Package_id, intVersion, strPackage_nm, Client_id, Study_id, intTeamNumber, strLogin_nm, datLastModified, bitArchive, datArchive, FileType_id,     
                      FileTypeSettings, SignOffBy_id, datCreated, strPackageFriendly_nm
FROM         Package_History    
GO

--back populate newly created fields
update p set strPackageFriendly_nm = isnull(rtrim(s.strstudy_nm),'') + '_' + rtrim(p.strPackage_nm)
from package p left join qualisys.qp_prod.dbo.study s  
 on p.study_id = s.study_id
GO
update p set strPackageFriendly_nm = isnull(rtrim(s.strstudy_nm),'') + '_' + rtrim(p.strPackage_nm)
from package_history p left join qualisys.qp_prod.dbo.study s  
 on p.study_id = s.study_id
GO
--add unique constraint
alter table package
add constraint ClientID_FriendlyPackageName unique (Client_id, strPackageFriendly_nm)
GO


--look for crud procs and/or other procs that may need to be adjusted for new field.
/*
select * from information_schema.routines where routine_name like '%package%'
p.strPackageFriendly_nm [FriendlyName]

sp_helptext LD_DeletePackage	--* moves rows from package to package_history
sp_helptext LD_GetPackageNotes
sp_helptext LD_PackageDestinations
sp_helptext LD_PackageNotes
sp_helptext LD_PackageOpen
sp_helptext LD_PackageProperties	--* used to populate interface?
sp_helptext LD_PackageSources
sp_helptext LD_PackageStatus
sp_helptext LD_PackageTableCleanup
sp_helptext LD_PackageTables
sp_helptext LD_SaveAsPackage
sp_helptext LD_SaveAsPackage_AthenatoMars	--* calls LD_SavePackage
sp_helptext LD_SavePackage	--* saves data to package table
sp_helptext LD_SetPackageArchive
sp_helptext LD_ValidatePackage



select * from information_schema.routines where routine_definition like '%package%'
--50 procs

select * from information_schema.routines where routine_definition like '%package_nm%'
--already checked from above
LD_SaveAsPackage
LD_SavePackage
LD_SaveAsPackage_AthenatoMars
LD_DeletePackage
LD_PackageOpen
LD_PackageProperties
--new procs to check
sp_helptext LD_ShowFileQueue	--* does select, possible candidate for change
sp_helptext LD_GetDTS	--* does select, possible candidate for change
sp_helptext LD_GetDTS_wVersion	--* does select, possible candidate for change
sp_helptext LD_GetFileQueue	--* does select, possible candidate for change
sp_helptext LD_IncrementVersion		--* inserts row into package_history from package


LD_ShowFileQueue	
LD_GetDTS	
LD_GetDTS_wVersion	
LD_GetFileQueue	



sp_help uploadactions
sp_help uploadstates
sp_help uploadfile
sp_help uploadfilepackage
sp_help uploadfilestate
sp_help uploadfilestate_history

select * from uploadactions
select * from uploadstates
select * from uploadfile
select * from uploadfilepackage
select * from uploadfilestate
select * from uploadfilestate_history

select top 10 * from member
select top 10 * from information_schema.columns where column_name = 'member_id'

sp_helptext LD_GetPackageIDsByStudyID 

sp_helptext ld_packageopen
*/