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

SET @TemplateName = 'WebSurveyProcessingSummary'

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



--USPS_ACS_PartialMatchReport--

IF NOT EXISTS(select 1 from Template where TemplateName = 'WebSurveyProcessingSummary')
BEGIN
	INSERT INTO [dbo].[Template] ([TemplateName],[SMTPServer],[TemplateString],[EmailFrom],[EmailTo],[EmailSubject],[EmailBCC],[EmailCC])
		 VALUES
			   ('WebSurveyProcessingSummary'
			   ,@SMTPServer
			   ,'<?xml version="1.0"?>
<Message>
    <BodyText>
        $ServiceName$ Processing Summary Report

        Date Occurred: $DateOccurred$

        Machine Name:  $MachineName$

    </BodyText>
    <BodyHtml>
        &lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
        &lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;$ServiceName$ Processing Summary Report&lt;/TD&gt;&lt;/TR&gt;
        &lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Message:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Message$&lt;/TD&gt;&lt;/TR&gt;
        &lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
        &lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
        &lt;/TABLE&gt;
    </BodyHtml>
</Message>'
			   ,@EmailFrom,@EmailTo,replace(@EmailSubject,'Exception','Processing Summary Report'),@EmailBCC,@EmailCC)

	SET @Template_id = SCOPE_IDENTITY() 

	INSERT INTO [dbo].[TemplateDefinitions]([Template_id],[TemplateDefinitionsName],[IsTable]) 
	SELECT @Template_id, TemplateDefinitionsName, IsTable
	FROM [dbo].[TemplateDefinitions]
	where Template_id = @TransferResultsTemplate_id and TemplateDefinitionsName in ('ServiceName','Environment','DateOccurred','MachineName','Message')
END

commit tran



select *
from [dbo].[Template]
where Template_id = (
	select Template_id from Template where TemplateName = 'WebSurveyProcessingSummary'
)


SELECT *
  FROM [dbo].[TemplateDefinitions]
where Template_id = (
	select Template_id from Template where TemplateName = 'WebSurveyProcessingSummary'
)

