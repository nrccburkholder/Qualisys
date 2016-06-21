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

--USPS_ACS_ServiceException--

IF NOT EXISTS(select 1 from Template where TemplateName = 'USPS_ACS_ServiceException')
BEGIN
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
END

--USPS_ACS_StatusNotification--

IF NOT EXISTS(select 1 from Template where TemplateName = 'USPS_ACS_StatusNotification')
BEGIN
	INSERT INTO [dbo].[Template] ([TemplateName],[SMTPServer],[TemplateString],[EmailFrom],[EmailTo],[EmailSubject],[EmailBCC],[EmailCC])
		 VALUES
			   ('USPS_ACS_StatusNotification'
			   ,@SMTPServer
			   ,'<?xml version="1.0"?>
<Message>
<BodyText>
$ServiceName$ Status Notification

Date Occurred: $DateOccurred$

Machine Name:  $MachineName$

File Name:     $FileName$

</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;$ServiceName$ Status Notification&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileName$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
</Message>'
			   ,@EmailFrom,@EmailTo,replace(@EmailSubject,'Exception','Status Notification'),@EmailBCC,@EmailCC)

	SET @Template_id = SCOPE_IDENTITY() 

	INSERT INTO [dbo].[TemplateDefinitions]([Template_id],[TemplateDefinitionsName],[IsTable]) 
	SELECT @Template_id, TemplateDefinitionsName, IsTable
	FROM [dbo].[TemplateDefinitions]
	where Template_id = @TransferResultsTemplate_id and TemplateDefinitionsName in ('ServiceName','Environment','DateOccurred','MachineName','FileName')
END

--USPS_ACS_PartialMatchReport--

IF NOT EXISTS(select 1 from Template where TemplateName = 'USPS_ACS_PartialMatchReport')
BEGIN
	INSERT INTO [dbo].[Template] ([TemplateName],[SMTPServer],[TemplateString],[EmailFrom],[EmailTo],[EmailSubject],[EmailBCC],[EmailCC])
		 VALUES
			   ('USPS_ACS_PartialMatchReport'
			   ,@SMTPServer
			   ,'<?xml version="1.0"?>
<Message>
<BodyText>
$ServiceName$ Partial and Multiple Match Report

Date Occurred: $DateOccurred$

Machine Name:  $MachineName$

File Name:     $FileName$

</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;$ServiceName$ Partial and Multiple Match Report&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Message:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Message$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
</Message>'
			   ,@EmailFrom,@EmailTo,replace(@EmailSubject,'Exception','Partial and Multiple Match Summary'),@EmailBCC,@EmailCC)

	SET @Template_id = SCOPE_IDENTITY() 

	INSERT INTO [dbo].[TemplateDefinitions]([Template_id],[TemplateDefinitionsName],[IsTable]) 
	SELECT @Template_id, TemplateDefinitionsName, IsTable
	FROM [dbo].[TemplateDefinitions]
	where Template_id = @TransferResultsTemplate_id and TemplateDefinitionsName in ('ServiceName','Environment','DateOccurred','MachineName','Message')
END

commit tran



select *
from [dbo].[Template]
where Template_id = @Template_id


SELECT *
  FROM [dbo].[TemplateDefinitions]
where Template_id = @Template_id

/*
update template set templatestring = 
'<?xml version="1.0"?>
<Message>
<BodyText>
$ServiceName$ Status Notification

Date Occurred: $DateOccurred$

Machine Name:  $MachineName$

File Name:     $FileName$

</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;$ServiceName$ Status Notification&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileName$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
</Message>'
,EmailSubject = replace(EmailSubject,'Exception','Status Notification')
where template_id = 17

update template set templatestring = 
'<?xml version="1.0"?>
<Message>
<BodyText>
$ServiceName$ Partial and Multiple Match Report

Date Occurred: $DateOccurred$

Machine Name:  $MachineName$

File Name:     $FileName$

</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;$ServiceName$ Partial and Multiple Match Report&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Message:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Message$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
</Message>'
,EmailSubject = replace(EmailSubject,'Exception','Partial and Multiple Match Summary')
where template_id = 18

select [Template_id],[TemplateName],[SMTPServer],[EmailFrom],[EmailTo],[EmailSubject],[EmailBCC],[EmailCC] from template where template_id in (16,17,18)
*/