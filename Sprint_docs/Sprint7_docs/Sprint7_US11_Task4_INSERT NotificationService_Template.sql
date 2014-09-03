USE [NotificationService]
GO

DECLARE @TransferResultsTemplate_id int
DECLARE @Template_id int
DECLARE @TemplateName varchar(42)
DECLARE @SMTPServer varchar(100)
DECLARE @TemplateString varchar(8000)
DECLARE @EmailFrom varchar(100)
DECLARE @EmailTo varchar(255)
DECLARE @EmailSubject varchar(100)
DECLARE @EmailBCC varchar(255)
DECLARE @EmailCC varchar(255)

SET @TemplateName = 'USPS_ACS_ServiceException'

SELECT @TransferResultsTemplate_id = Template_id
	  ,@SMTPServer = [SMTPServer]
      ,@TemplateString = [TemplateString]
      ,@EmailFrom = [EmailFrom]
      ,@EmailTo = [EmailTo]
      ,@EmailSubject = [EmailSubject]
      ,@EmailBCC = [EmailBCC]
      ,@EmailCC =[EmailCC]
  FROM [NotificationService].[dbo].[Template]
  WHERE TemplateName = 'TransferResultsServiceException'


begin tran
INSERT INTO [dbo].[Template]
           ([TemplateName]
           ,[SMTPServer]
           ,[TemplateString]
           ,[EmailFrom]
           ,[EmailTo]
           ,[EmailSubject]
           ,[EmailBCC]
           ,[EmailCC])
     VALUES
           (@TemplateName
           ,@SMTPServer
           ,@TemplateString
           ,@EmailFrom
           ,@EmailTo
           ,@EmailSubject
           ,@EmailBCC
           ,@EmailCC)


SET @Template_id = SCOPE_IDENTITY() 





INSERT INTO [dbo].[TemplateDefinitions]([Template_id],[TemplateDefinitionsName],[IsTable]) 
SELECT @Template_id, TemplateDefinitionsName, IsTable
FROM [dbo].[TemplateDefinitions]
where Template_id = @TransferResultsTemplate_id


commit tran



select *
from [dbo].[Template]
where Template_id = @Template_id


SELECT *
  FROM [dbo].[TemplateDefinitions]
where Template_id = @Template_id
