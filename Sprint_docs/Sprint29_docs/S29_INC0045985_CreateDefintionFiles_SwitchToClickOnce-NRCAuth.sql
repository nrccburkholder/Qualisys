/*
S29_INC0045985_CreateDefintionFiles_SwitchToClickOnce-NRCAuth.sql

Fix: non-deliverable problems with litho codes mistakenly tripping Canada logic

Chris Burkholder

Configuring CreateDefinitionFiles to be ClickOnce rather than a local application
*/

USE [NRCAuth]
GO

UPDATE [dbo].[Application]
   SET [DeploymentType_id] = 1
      ,[strPath] = 'http://QualiSysApps/Prod/CreateDefinitionFiles/CreateDefinitionFilesLauncher.application'
 WHERE [strApplication_nm] = 'Create Definition Files'
GO

select * from [dbo].[application]
where [strapplication_nm] = 'Create Definition Files'
