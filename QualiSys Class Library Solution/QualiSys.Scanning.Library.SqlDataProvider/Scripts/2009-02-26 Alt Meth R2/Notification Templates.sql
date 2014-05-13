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
SET @TemplateName = 'TransferResultsServiceException'
SET @EmailSubject = 'Transfer Results Service Exception $Environment$'
SET @EmailFrom = 'TransferResults@NRCPicker.com'
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
Transfer Results Service Exception

Message:       $Message$

Date Occurred: $DateOccurred$

Machine Name:  $MachineName$

File Name:     $FileName$

Exception:     $ExceptionText$

Source:        $Source$

SQL Command:   $SQLCommand$

Stack Trace:
$StackTraceText$

Inner Exception:
$InnerExceptionText$
</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;Transfer Results Service Exception&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Message:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Message$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Occurred:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Machine Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MachineName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Exception:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$ExceptionHtml$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Source:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Source$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SQL Command:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$SQLCommand$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Stack Trace:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$StackTraceHtml$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Inner Exception:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$InnerExceptionHtml$&lt;/TD&gt;&lt;/TR&gt;
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
VALUES (@TemplateID, 'Message', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'DateOccurred', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'MachineName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ExceptionText', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ExceptionHtml', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Source', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SQLCommand', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'StackTraceText', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'StackTraceHtml', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'InnerExceptionText', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'InnerExceptionHtml', 0)

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


-- Setup variables
-- NOTE: Set the following variables to whatever you need for this email
SET @TemplateName = 'QSIFileMoverServiceFileReceived'
SET @EmailSubject = 'File Received $Environment$'
SET @EmailFrom = 'TransferResults@NRCPicker.com'
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
File Upload Successful

Vendor Name: $VendorName$

Date:        $DateOccurred$

File Name:   $FileName$

File Size:   $FileSize$ bytes

File Date:   $FileDate$ $RecipientNoteText$
</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #7C7C7C; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD Colspan="2" style="background-color: white;White-space: nowrap; padding: 5px; font-weight: bold"&gt;&lt;img width=468 height=75 id="_x0000_i1025" src="http://nrcpicker.com/DataExchange/img/NRCPicker/HeaderLeftUS.gif"&gt;&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD Colspan="2" style="Text-Align: Center; background-color: #FFFFCC; Color: #990000; font-weight:Bold;font-size:medium;padding: 3px;"&gt;File Upload Successful&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Vendor Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;Width: 100%; padding: 5px; White-space: nowrap"&gt;$VendorName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateOccurred$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Size:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileSize$ bytes&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Date:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #FFFFCC;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileDate$ $RecipientNoteHtml$&lt;/TD&gt;&lt;/TR&gt;
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
VALUES (@TemplateID, 'VendorName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'DateOccurred', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileSize', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileDate', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecipientNoteText', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecipientNoteHtml', 0)
