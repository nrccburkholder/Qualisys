Use [NRCAuth]

/****** Script for SelectTopNRows command from SSMS  ******
SELECT TOP 1000 [Application_id]
      ,[strApplication_nm]
      ,[strApplication_dsc]
      ,[bitInternal]
      ,[Author]
      ,[datOccurred]
      ,[DeploymentType_id]
      ,[strPath]
      ,[IconImage]
      ,[strCategory_nm]
  FROM [NRCAuth].[dbo].[Application]
*/
declare @QMid int

select @QMid = Application_id from Application where strApplication_nm = 'Queue Manager' 

update Application set DeploymentType_id=1, strPath	='http://QualiSysApps/Prod/QueueManager/QueueManagerLauncher.application'
  where Application_id=@QMid and (DeploymentType_id <> 1 or strpath <> 'http://QualiSysApps/Prod/QueueManager/QueueManagerLauncher.application')

