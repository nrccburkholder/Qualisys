--/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [NRC_Datamart].[LOAD_TABLES].[PracticeSite]

--  truncate table [NRC_Datamart].[LOAD_TABLES].[PracticeSite]


SELECT ps.*, dsk.DataSourceKey as 'SampleUnit_id'
FROM [NRC_Datamart].[DBO].[PracticeSite] ps
inner join [NRC_Datamart].[ETL].DataSourceKey dsk on dsk.DataSourceKeyID = ps.SampleUnitid and dsk.EntityTypeID = 6

USE [NRC_Datamart]
GO

--SELECT [DataFileID]
--      ,[SiteGroup_ID]
--      ,[AssignedID]
--      ,[GroupName]
--      ,[Addr1]
--      ,[Addr2]
--      ,[City]
--      ,[ST]
--      ,[Zip5]
--      ,[Phone]
--      ,[GroupOwnership]
--      ,[GroupContactName]
--      ,[GroupContactPhone]
--      ,[GroupContactEmail]
--      ,[MasterGroupID]
--      ,[MasterGroupName]
--      ,[bitActive]
--  FROM [LOAD_TABLES].[SiteGroup]
--GO

SELECT *
FROM [NRC_Datamart].[DBO].[SiteGroup]

/*

use NRC_Datamart

select *
from ETL.DataSourceKey dsk
where dsk.DataSourceKey = '190191'

select *
from ETL.DataSourceKey dsk
where dsk.DataSourceKey = '15970'

select *
from ETL.DataSourceKey dsk
where dsk.DataSourceKey = '4781'



*/

--select *
--from ETL.DataSourceKey dsk
--where dsk.DataSourceKeyId = 367203

--exec QCL_SelectFacilityByClientId 2521 -- Facilities and Groups
--exec QCL_SelectFacilityByClientId 2521, 0 --Facilities only
--exec QCL_SelectFacilityByClientId 2521, 1 --Practice Sites Only 

/*
select top 100 *
from ETL.DataFileCounts
order by DataFileId desc

*/
--select *
--FROM LOAD_TABLES.SampleUnitFacilityAttributes 
--where Facility_ID = 8113

--select *
--FROM dbo.SampleUnitFacilityAttributes 
--where FacilityName = 'ICHCAHPS_JW'
----where Facility_ID = 8113