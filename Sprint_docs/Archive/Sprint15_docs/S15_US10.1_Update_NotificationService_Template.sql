/*
	S15 US10.1 Update notification email for download and extract job to provide more information

	Tim Butler

	Update the Template definition for USPS_ACS_StatusNotification

*/
USE NotificationService

DECLARE @TemplateID int

SELECT @TemplateID = [Template_id]
FROM [dbo].[Template]
WHERE TemplateName = 'USPS_ACS_StatusNotification'



update [dbo].[Template]
SET TemplateString = 
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
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Message:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Message$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
</Message>'
WHERE Template_id = @TemplateID


DECLARE @TemplateDefinitions_id int

SELECT @TemplateDefinitions_id = [TemplateDefinitions_id]
FROM [dbo].[TemplateDefinitions]
WHERE Template_id = @TemplateID
AND [TemplateDefinitionsName] = 'FileName'



update [dbo].[TemplateDefinitions]
set TemplateDefinitionsName = 'Message'
where TemplateDefinitions_ID = @TemplateDefinitions_id

