/*
-- Begin work area

SELECT * FROM Template

SELECT * FROM TemplateDefinitions

SELECT * FROM TemplateTableDefinitions

-- End work area
*/

-------------------------------------------------------------------------
-- Copyright © National Research Corporation
--
-- Project Name:	HCAHPS Sampling
--
-- Created By:		Jeffrey J. Fleming
--		   Date:	09-12-2008
--
-- Description:
-- This script will insert or update the specified template into the 
-- notification database.
--
-- Revisions:
--		Date		By		Description
-------------------------------------------------------------------------

-- Declare variables
DECLARE @TemplateID int
DECLARE @TemplateDefinitionID int

DECLARE @TemplateName varchar(42)
DECLARE @EmailSubject varchar(100)
DECLARE @EmailFrom varchar(100)
DECLARE @EmailTo varchar(255)
DECLARE @EmailCC varchar(255)
DECLARE @EmailBCC varchar(255)
DECLARE @SMTPServer varchar(100)
DECLARE @TemplateString varchar(8000)

-- Setup variables
-- NOTE: Set the following variables to whatever you need for this email
SET @TemplateName = 'MethodologyChangeNotice'
SET @EmailSubject = 'Non-Mail Methodolgy Change - $Survey$ ($SurveyID$) $Environment$'
SET @EmailFrom = 'ClientSupport@NationalResearch.com'
SET @EmailTo = NULL
SET @EmailCC = NULL
SET @EmailBCC = NULL

-- Determine the SMTP Server to use
SET @SMTPServer = 
    CASE @@ServerName
        WHEN 'Batman' THEN 'Superman'
        WHEN 'Jayhawk' THEN 'Huskers'
        ELSE 'smtp2.nationalresearch.com'
    END

-- Setup the TemplateString
SET @TemplateString = 
'<?xml version="1.0"?>
<Message>
<BodyText>
Phone/Web/IVR Methodology Change Notification

Client:              $Client$ ($ClientID$)
Study:               $Study$ ($StudyID$)
Survey:              $Survey$ ($SurveyID$)
Name of Methodology: $Methodology$ ($MethStatus$)
Report Link:         $ReportLink$
</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;Phone/Web/IVR Methodology Change Notification&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Client$ ($ClientID$)&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Study$ ($StudyID$)&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Survey$ ($SurveyID$)&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Name of Methodology:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Methodology$ ($MethStatus$)&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Report Link:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$ReportLink$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
</Message>'

-- Determine if we are inserting or updating
IF EXISTS(SELECT * FROM Template WHERE TemplateName = @TemplateName)
BEGIN
    -- This template already exists so update it
    UPDATE Template
    SET SMTPServer = @SMTPServer, 
        EmailSubject = @EmailSubject, 
        EmailFrom = @EmailFrom, 
        EmailTo = @EmailTo, 
        EmailCC = @EmailCC, 
        EmailBCC = @EmailBCC, 
        TemplateString = @TemplateString
    WHERE TemplateName = @TemplateName

    -- Get the TemplateID
    SELECT @TemplateID = Template_id FROM Template WHERE TemplateName = @TemplateName

    -- Delete this template's entries from the TemplateTableDefinitions tables
    DELETE FROM TemplateTableDefinitions 
    WHERE TemplateDefinitions_id IN (
        SELECT TemplateDefinitions_id 
        FROM TemplateDefinitions 
        WHERE Template_id = @TemplateID)

    -- Delete this template's entries from the TemplateDefinitions table
    DELETE FROM TemplateDefinitions WHERE Template_id = @TemplateID
END
ELSE
BEGIN
    -- This template does not exist so insert it
    INSERT INTO Template (TemplateName, SMTPServer, EmailSubject, EmailFrom, 
                          EmailTo, EmailCC, EmailBCC, TemplateString)
    VALUES (@TemplateName, @SMTPServer, @EmailSubject, @EmailFrom, 
            @EmailTo, @EmailCC, @EmailBCC, @TemplateString) 

    -- Get the TemplateID
    SET @TemplateID = Scope_Identity()
END

-- Insert the TemplateDefinitions
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Environment', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Client', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ClientID', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Study', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'StudyID', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Survey', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SurveyID', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Methodology', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'MethStatus', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ReportLink', 0)

/*
-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'TblDefName', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ColName1')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ColName2')
*/
