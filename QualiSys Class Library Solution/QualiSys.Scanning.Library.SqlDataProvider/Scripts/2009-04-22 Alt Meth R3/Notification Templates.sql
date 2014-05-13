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
SET @EmailSubject = '$ServiceName$ Exception $Environment$'
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
$ServiceName$ Exception

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
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;$ServiceName$ Exception&lt;/TD&gt;&lt;/TR&gt;
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
VALUES (@TemplateID, 'ServiceName', 0)

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
SET @TemplateName = 'QSIVendorFilesSent'
SET @EmailSubject = 'Vendor Files Sent Summary $Environment$'
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
-- This one is special because of the length of the template we need to break it up into several variables
DECLARE @TemplateString1 varchar(8000)
DECLARE @TemplateString2 varchar(8000)
DECLARE @TemplateString3 varchar(8000)
DECLARE @TemplateString4 varchar(8000)
DECLARE @TemplateString5 varchar(8000)
DECLARE @TemplateString6 varchar(8000)
DECLARE @TemplateString7 varchar(8000)
DECLARE @TemplateString8 varchar(8000)

SET @TemplateString1 = 
'<?xml version="1.0"?>
<Message>
<BodyText>
Vendor Files Sent Summary
$ReportDate$ $RecipientNoteText$

---------------------------------------------------------
$QtySuccessVendorFiles$ Successful Vendor File(s):
$SuccessVendorFiles_Text$
---------------------------------------------------------

---------------------------------------------------------
$QtyFailedVendorFiles$ Failed Vendor File(s) (Not Created):
$FailedVendorFiles_Text$
---------------------------------------------------------

---------------------------------------------------------
$QtySuccessTelematchFiles$ Successful Telematch File(s):
$SuccessTelematchFiles_Text$
---------------------------------------------------------

---------------------------------------------------------
$QtyFailedTelematchFiles$ Failed Telematch File(s) (Not Created):
$FailedTelematchFiles_Text$
---------------------------------------------------------

---------------------------------------------------------
$QtySuccessTeleVendorFiles$ Successful Telematch/Vendor File(s):
$SuccessTeleVendorFiles_Text$
---------------------------------------------------------

---------------------------------------------------------
$QtyFailedTeleVendorFiles$ Failed Telematch/Vendor File(s) (Not Created):
$FailedTeleVendorFiles_Text$
---------------------------------------------------------
</BodyText>
<ListTemplate NAME="SuccessVendorFiles_Text">
-----------------  --------------------------------------
File Name:         $ArchiveFileName$ ($VendorFileID$)
Client:            $ClientName$ ($ClientID$)
Study:             $StudyName$ ($StudyID$)
Survey:            $SurveyName$ ($SurveyID$)
SampleSetID:       $SampleSetID$
Sample Date:       $SampleCreateDate$
Encounter Dates:   $DateRangeFrom$ - $DateRangeTo$
Methodology Step:  $MethStepName$
Date Data Created: $DateDataCreated$
Record Count:      $RecordsInFile$
NotPrinted Count:  $RecordsNoLitho$
</ListTemplate>
<ListTemplate NAME="FailedVendorFiles_Text">
-----------------  --------------------------------------
VendorFileID:      $VendorFileID$
Client:            $ClientName$ ($ClientID$)
Study:             $StudyName$ ($StudyID$)
Survey:            $SurveyName$ ($SurveyID$)
SampleSetID:       $SampleSetID$
Sample Date:       $SampleCreateDate$
Encounter Dates:   $DateRangeFrom$ - $DateRangeTo$
Methodology Step:  $MethStepName$
Date Data Created: $DateDataCreated$
Record Count:      $RecordsInFile$
NotPrinted Count:  $RecordsNoLitho$
Exception:         $Exception$
</ListTemplate>
<ListTemplate NAME="SuccessTelematchFiles_Text">
-----------------  --------------------------------------
File Name:         $ArchiveFileName$ ($VendorFileID$)
Client:            $ClientName$ ($ClientID$)
Study:             $StudyName$ ($StudyID$)
Survey:            $SurveyName$ ($SurveyID$)
SampleSetID:       $SampleSetID$
Sample Date:       $SampleCreateDate$
Encounter Dates:   $DateRangeFrom$ - $DateRangeTo$
Methodology Step:  $MethStepName$
Date Data Created: $DateDataCreated$
Record Count:      $RecordsInFile$
NotPrinted Count:  $RecordsNoLitho$
TelematchLogID:    $TelematchLogID$
Date Sent:         $DateSent$
</ListTemplate>
<ListTemplate NAME="FailedTelematchFiles_Text">
-----------------  --------------------------------------
VendorFileID:      $VendorFileID$
Client:            $ClientName$ ($ClientID$)
Study:             $StudyName$ ($StudyID$)
Survey:            $SurveyName$ ($SurveyID$)
SampleSetID:       $SampleSetID$
Sample Date:       $SampleCreateDate$
Encounter Dates:   $DateRangeFrom$ - $DateRangeTo$
Methodology Step:  $MethStepName$
Date Data Created: $DateDataCreated$
Record Count:      $RecordsInFile$
NotPrinted Count:  $RecordsNoLitho$
Exception:         $Exception$
</ListTemplate>
<ListTemplate NAME="SuccessTeleVendorFiles_Text">
-----------------  --------------------------------------
File Name:         $ArchiveFileName$ ($VendorFileID$)
Client:            $ClientName$ ($ClientID$)
Study:             $StudyName$ ($StudyID$)
Survey:            $SurveyName$ ($SurveyID$)
SampleSetID:       $SampleSetID$
Sample Date:       $SampleCreateDate$
Encounter Dates:   $DateRangeFrom$ - $DateRangeTo$
Methodology Step:  $MethStepName$
Date Data Created: $DateDataCreated$
Record Count:      $RecordsInFile$
NotPrinted Count:  $RecordsNoLitho$
TelematchLogID:    $TelematchLogID$
Telematch Sent:    $DateSent$
</ListTemplate>
<ListTemplate NAME="FailedTeleVendorFiles_Text">
-----------------  --------------------------------------
VendorFileID:      $ArchiveFileName$ ($VendorFileID$)
Client:            $ClientName$ ($ClientID$)
Study:             $StudyName$ ($StudyID$)
Survey:            $SurveyName$ ($SurveyID$)
SampleSetID:       $SampleSetID$
Sample Date:       $SampleCreateDate$
Encounter Dates:   $DateRangeFrom$ - $DateRangeTo$
Methodology Step:  $MethStepName$
Date Data Created: $DateDataCreated$
Record Count:      $RecordsInFile$
NotPrinted Count:  $RecordsNoLitho$
TelematchLogID:    $TelematchLogID$
Telematch Sent:    $DateSent$
Exception:         $Exception$
</ListTemplate>'

SET @TemplateString2 = 
'<BodyHtml>
&lt;div style="font-family: Tahoma, Verdana, Arial; font-size: x-large;"&gt;Vendor Files Sent Summary&lt;/div&gt;
&lt;div style="font-family: Tahoma, Verdana, Arial; font-size: x-small;"&gt;&lt;i&gt;$ReportDate$ $RecipientNoteHtml$&lt;/i&gt;&lt;/div&gt;
&lt;/BR&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Left; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="1"&gt;$QtySuccessVendorFiles$ Successful Vendor File(s)&lt;/TD&gt;&lt;/TR&gt;
$SuccessVendorFiles_Html$
&lt;/TABLE&gt;
&lt;/BR&gt;
&lt;/BR&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Left; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="1"&gt;$QtyFailedVendorFiles$ Failed Vendor File(s) (Not Created)&lt;/TD&gt;&lt;/TR&gt;
$FailedVendorFiles_Html$
&lt;/TABLE&gt;
&lt;/BR&gt;
&lt;/BR&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Left; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="1"&gt;$QtySuccessTelematchFiles$ Successful Telematch File(s)&lt;/TD&gt;&lt;/TR&gt;
$SuccessTelematchFiles_Html$
&lt;/TABLE&gt;
&lt;/BR&gt;
&lt;/BR&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Left; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="1"&gt;$QtyFailedTelematchFiles$ Failed Telematch File(s) (Not Created)&lt;/TD&gt;&lt;/TR&gt;
$FailedTelematchFiles_Html$
&lt;/TABLE&gt;
&lt;/BR&gt;
&lt;/BR&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Left; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="1"&gt;$QtySuccessTeleVendorFiles$ Successful Telematch To Vendor File(s)&lt;/TD&gt;&lt;/TR&gt;
$SuccessTeleVendorFiles_Html$
&lt;/TABLE&gt;
&lt;/BR&gt;
&lt;/BR&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Left; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="1"&gt;$QtyFailedTeleVendorFiles$ Failed Telematch To Vendor File(s) (Not Created)&lt;/TD&gt;&lt;/TR&gt;
$FailedTeleVendorFiles_Html$
&lt;/TABLE&gt;
</BodyHtml>'

SET @TemplateString3 = 
'<ListTemplate NAME="SuccessVendorFiles_Html">
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$ArchiveFileName$ ($VendorFileID$)&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SampleSetID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleSetID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleCreateDate$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateRangeFrom$ - $DateRangeTo$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$MethStepName$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateDataCreated$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Record Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$RecordsInFile$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;NotPrinted Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$RecordsNoLitho$&lt;/TD&gt;
&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>'

SET @TemplateString4 = 
'<ListTemplate NAME="FailedVendorFiles_Html">
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;VendorFileID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$VendorFileID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SampleSetID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleSetID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleCreateDate$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateRangeFrom$ - $DateRangeTo$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$MethStepName$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateDataCreated$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Record Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$RecordsInFile$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;NotPrinted Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$RecordsNoLitho$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Exception:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$Exception$&lt;/TD&gt;
&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>'

SET @TemplateString5 = 
'<ListTemplate NAME="SuccessTelematchFiles_Html">
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$ArchiveFileName$ ($VendorFileID$)&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SampleSetID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleSetID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleCreateDate$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateRangeFrom$ - $DateRangeTo$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$MethStepName$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateDataCreated$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Record Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$RecordsInFile$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;NotPrinted Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$RecordsNoLitho$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;TelematchLogID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$TelematchLogID$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Sent:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateSent$&lt;/TD&gt;
&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>'

SET @TemplateString6 = 
'<ListTemplate NAME="FailedTelematchFiles_Html">
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;VendorFileID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$VendorFileID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SampleSetID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleSetID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleCreateDate$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateRangeFrom$ - $DateRangeTo$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$MethStepName$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateDataCreated$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Record Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$RecordsInFile$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;NotPrinted Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$RecordsNoLitho$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Exception:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$Exception$&lt;/TD&gt;
&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>'

SET @TemplateString7 = 
'<ListTemplate NAME="SuccessTeleVendorFiles_Html">
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$ArchiveFileName$ ($VendorFileID$)&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SampleSetID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleSetID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleCreateDate$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateRangeFrom$ - $DateRangeTo$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$MethStepName$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateDataCreated$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Record Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$RecordsInFile$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;NotPrinted Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$RecordsNoLitho$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;TelematchLogID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$TelematchLogID$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Sent:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateSent$&lt;/TD&gt;
&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>'

SET @TemplateString8 = 
'<ListTemplate NAME="FailedTeleVendorFiles_Html">
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$ArchiveFileName$ ($VendorFileID$)&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;SampleSetID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleSetID$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SampleCreateDate$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateRangeFrom$ - $DateRangeTo$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$MethStepName$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateDataCreated$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Record Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$RecordsInFile$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;NotPrinted Count:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$RecordsNoLitho$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;TelematchLogID:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;White-space: nowrap; padding: 5px"&gt;$TelematchLogID$&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Sent:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%;White-space: nowrap; padding: 5px"&gt;$DateSent$&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Exception:&lt;/TD&gt;
&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap" Colspan="3"&gt;$Exception$&lt;/TD&gt;
&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>
</Message>'

-- Print the variable lengths
PRINT 'TemplateString Length'
PRINT LEN(@TemplateString1)
PRINT LEN(@TemplateString2)
PRINT LEN(@TemplateString3)
PRINT LEN(@TemplateString4)
PRINT LEN(@TemplateString5)
PRINT LEN(@TemplateString6)
PRINT LEN(@TemplateString7)
PRINT LEN(@TemplateString8)

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
        TemplateString = @TemplateString1
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
            @EmailTo, @EmailCC, @EmailBCC, @TemplateString1) 

    -- Get the TemplateID
    SET @TemplateID = Scope_Identity()
END

--Get the text pointer for the text column
DECLARE @TextPtr VARBINARY(16)
SELECT @TextPtr=TEXTPTR(TemplateString) 
FROM Template (UPDLOCK) 
WHERE Template_id = @TemplateID

--Append the remaining chuncks of the comment
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString2
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString3
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString4
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString5
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString6
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString7
UPDATETEXT Template.TemplateString @TextPtr NULL NULL WITH LOG @TemplateString8

-- Insert the TemplateDefinitions
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Environment', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ReportDate', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecipientNoteText', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecipientNoteHtml', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'QtySuccessVendorFiles', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'QtyFailedVendorFiles', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'QtySuccessTelematchFiles', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'QtyFailedTelematchFiles', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'QtySuccessTeleVendorFiles', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'QtyFailedTeleVendorFiles', 0)

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SuccessVendorFiles_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SuccessVendorFiles_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FailedVendorFiles_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'Exception')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FailedVendorFiles_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'Exception')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SuccessTelematchFiles_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'TelematchLogID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateSent')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SuccessTelematchFiles_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'TelematchLogID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateSent')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FailedTelematchFiles_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'Exception')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FailedTelematchFiles_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'Exception')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SuccessTeleVendorFiles_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'TelematchLogID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateSent')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SuccessTeleVendorFiles_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'TelematchLogID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateSent')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FailedTeleVendorFiles_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'TelematchLogID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateSent')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'Exception')

-- Insert a table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FailedTeleVendorFiles_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ArchiveFileName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'VendorFileID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleSetID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleCreateDate')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeFrom')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateRangeTo')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'MethStepName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateDataCreated')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsInFile')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'RecordsNoLitho')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'TelematchLogID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'DateSent')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'Exception')



-- Setup variables
-- NOTE: Set the following variables to whatever you need for this email
SET @TemplateName = 'NQLFileNotice'
SET @EmailSubject = 'NQL File Notice - $Environment$'
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
Non-Mail File with NQL Notification

Language:      $Language$ ($LanguageID$)
Date Recieved: $DateRecieved$
File Name:     $FileName$
File Link:     $FileLink$

</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="2"&gt;Non-Mail File with NQL Notification&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Language:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Language$ ($LanguageID$)&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Recieved:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateRecieved$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Name:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileName$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;File Link:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$FileLink$&lt;/TD&gt;&lt;/TR&gt;
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
VALUES (@TemplateID, 'Language', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'LanguageID', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'DateRecieved', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileLink', 0)


-- Setup variables
-- NOTE: Set the following variables to whatever you need for this email
SET @TemplateName = 'QSITelematchOverdueNotice'
SET @EmailSubject = 'Telematch File Overdue Notice - $Environment$'
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
Telematch File Overdue Notification

File Name:         $FileName$ ($FileId$)
Client:            $ClientName$ ($ClientId$)
Study:             $Study$ ($StudyId$)
Survey:            $Survey$ ($SurveyId$)
Sample Set ID:     $SampleSetId$
Sample Date:       $SampleDate$
Encounter Dates:   $EncounterDates$
Methodology Step:  $MethStep$
Telematch Log ID:  $TelematchLogId$
Date Data Created: $DateCreated$
Sent to Telematch: $TelematchSentDate$

</BodyText>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="4"&gt;Telematch File Overdue Notification&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;FileName:&lt;/TD&gt;&lt;TD Colspan="3" style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px"&gt;$FileName$ ($FileId$)&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Set ID:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$SampleSetId$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Study$ ($StudyId$)&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Date:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$SampleDate$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$Survey$ ($SurveyId$)&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Encounter Dates:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$EncounterDates$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Methodology Step:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$MethStep$&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Data Created:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$DateCreated$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Telematch Log ID:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$TelematchLogId$&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Date Sent to Telematch:&lt;/TD&gt;&lt;TD style="Vertical-Align: Top; background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap"&gt;$TelematchSentDate$&lt;/TD&gt;&lt;/TR&gt;
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
VALUES (@TemplateID, 'FileName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'FileId', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ClientName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'ClientId', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Study', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'StudyId', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Survey', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SurveyId', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'MethStep', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'TelematchLogId', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SampleSetId', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'SampleDate', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'EncounterDates', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'DateCreated', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'TelematchSentDate', 0)
