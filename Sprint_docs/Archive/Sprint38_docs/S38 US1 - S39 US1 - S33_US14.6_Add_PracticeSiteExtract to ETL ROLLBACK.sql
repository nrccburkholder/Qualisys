/*

S38 US1 - S39 US1 - S33_US14.6_Add_PracticeSiteExtract to ETL ROLLBACK.sql

As a Research Associate, I want the SUFacility field populated for all CG-CAHPS units, so that the data is available for benchmarks. notes: Populate based on sampleunit in Medusa practice table where available. Depending on volume of remaining unmapped units, may want a mass update/bulk insert.

TASK 14.6	Cue the PracticeSite table to be sent in the Catalyst ETL for hook-up alongside SUFacility

Tim Butler

DROP TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_PracticeSite] 
DROP PROCEDURE [dbo].[csp_GetPracticeSiteExtractData] 
DROP TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SiteGroup] 
DROP PROCEDURE [dbo].[csp_GetSiteGroupExtractData] 

ROLLBACK

*/

/* PracticeSite */

USE [QP_Prod]
GO


IF EXISTS (SELECT *   
               FROM   sys.objects   
               WHERE  [type] = 'TR'  
               AND    [name] = 'trg_NRC_DataMart_ETL_dbo_PracticeSite')   
	DROP TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_PracticeSite]
GO






USE [NRC_DataMart_ETL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'csp_GetPracticeSiteExtractData')
DROP PROCEDURE [dbo].[csp_GetPracticeSiteExtractData] 

USE [NRC_DataMart_ETL]
GO


/*  SiteGroup */

USE [QP_Prod]
GO


IF EXISTS (SELECT *   
               FROM   sys.objects   
               WHERE  [type] = 'TR'  
               AND    [name] = 'trg_NRC_DataMart_ETL_dbo_SiteGroup')   
	DROP TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SiteGroup]
GO



USE [NRC_DataMart_ETL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'csp_GetSiteGroupExtractData')
DROP PROCEDURE [dbo].[csp_GetSiteGroupExtractData] 


GO