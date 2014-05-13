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
SET @TemplateName = 'MedicareProportionChangeThresholdExceeded'
SET @EmailSubject = 'Medicare Number $MedicareNumber$ - Sampling Locked $Environment$'
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
Medicare Number $MedicareNumber$ ($MedicareName$) - Sampling Locked

Please be aware the system has locked the Medicare Number listed 
above for sampling.  You will not be able to sample any of the 
surveys with sample units associated with this Medicare Number 
shown below because the HCAHPS Proportion % has changed between 
the last calculation date and the current calculation date by 
more than the allowable amount.

Someone from the HCAHPS Sampling Threshold group will contact you 
when this has been reviewed and resolved.  If you do not receive 
notification within 2 business days, please contact: 
HCAHPSThresholdExceeded@NationalResearch.com. $RecipientNoteText$

Previous Calculation:
Date:        $PrevCalcDate$
Proportion:  $PrevCalcProp$

Current Calculation:
Date:        $CurrCalcDate$
Proportion:  $CurrCalcProp$

The following sample units are affected:
$LockedUnits_Text$
-----------  ---------------------------------

Click the following link to view the Recalc History Report:
  $RecalcHistoryLink$
</BodyText>
<ListTemplate NAME="LockedUnits_Text">
-----------  ---------------------------------
Client:      $ClientName$ ($ClientID$)
Study:       $StudyName$ ($StudyID$)
Survey:      $SurveyName$ ($SurveyID$)
SampleUnit:  $SampleUnitName$ ($SampleUnitID$)
</ListTemplate>
<BodyHtml>
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled=''true'', startColorstr=#cc66ff, endColorstr=#663399);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)" Colspan="4"&gt;Medicare Number $MedicareNumber$ ($MedicareName$) - Sampling Locked&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF; padding: 5px" Colspan="4"&gt;
&lt;P&gt;
Please be aware the system has locked the Medicare Number listed above for sampling.  You will not be able to sample any of the surveys with sample units associated with this Medicare Number shown below because the HCAHPS Proportion % has changed between the last calculation date and the current calculation date by more than the allowable amount.
&lt;/P&gt;
&lt;P&gt;
Someone from the HCAHPS Sampling Threshold group will contact you when this has been reviewed and resolved.  If you do not receive notification within 2 business days, please contact &lt;a href="mailto:HCAHPSThresholdExceeded@NationalResearch.com"&gt;HCAHPS Threshold Exceeded Group&lt;/a&gt;  $RecipientNoteHtml$
&lt;/P&gt;
&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px; font-weight: bold" Colspan="2"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold" Colspan="2"&gt;Previous Calculation&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;Date:&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;$PrevCalcDate$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;Proportion:&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;$PrevCalcProp$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;
&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px; font-weight: bold" Colspan="2"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold" Colspan="2"&gt;Current Calculation&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;Date:&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;$CurrCalcDate$&lt;/TD&gt;&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;Proportion:&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 50%; padding: 5px; White-space: nowrap"&gt;$CurrCalcProp$&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;
&lt;TD style="background-color: #FFFFFF;White-space: nowrap; padding: 5px; font-weight: bold" Colspan="4"&gt;
&lt;TABLE style="background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small" Width="100%" cellpadding="0" cellspacing="1"&gt;
&lt;TR&gt;&lt;TD style="background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Client&lt;/TD&gt;&lt;TD style="background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Study&lt;/TD&gt;&lt;TD style="background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Survey&lt;/TD&gt;&lt;TD style="background-color: #CC99FF;White-space: nowrap; padding: 5px; font-weight: bold"&gt;Sample Unit&lt;/TD&gt;&lt;/TR&gt;
$LockedUnits_Html$
&lt;/TABLE&gt;
&lt;/TD&gt;
&lt;/TR&gt;
&lt;TR&gt;&lt;TD style="background-color: #FFFFFF; padding: 5px" Colspan="4"&gt;
&lt;P&gt;
Click here to view the &lt;a href="$RecalcHistoryLink$"&gt;Recalc History Report&lt;/a&gt;
&lt;/P&gt;
&lt;/TD&gt;&lt;/TR&gt;
&lt;/TABLE&gt;
</BodyHtml>
<ListTemplate NAME="LockedUnits_Html">
&lt;TR&gt;&lt;TD style="background-color: #ccccff;Width: 25%; padding: 5px; White-space: wrap"&gt;$ClientName$ ($ClientID$)&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 25%; padding: 5px; White-space: wrap"&gt;$StudyName$ ($StudyID$)&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 25%; padding: 5px; White-space: wrap"&gt;$SurveyName$ ($SurveyID$)&lt;/TD&gt;&lt;TD style="background-color: #ccccff;Width: 25%; padding: 5px; White-space: wrap"&gt;$SampleUnitName$ ($SampleUnitID$)&lt;/TD&gt;&lt;/TR&gt;
</ListTemplate>
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
VALUES (@TemplateID, 'MedicareNumber', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'MedicareName', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'PrevCalcDate', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'PrevCalcProp', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'CurrCalcDate', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'CurrCalcProp', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'Environment', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecipientNoteText', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecipientNoteHtml', 0)

INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'RecalcHistoryLink', 0)

-- Insert the LockedUnits_Text table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'LockedUnits_Text', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleUnitID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleUnitName')

-- Insert the LockedUnits_Html table definition
INSERT INTO TemplateDefinitions (Template_id, TemplateDefinitionsName, IsTable)
VALUES (@TemplateID, 'LockedUnits_Html', 1)

SET @TemplateDefinitionID = Scope_Identity()

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'ClientName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'StudyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SurveyName')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleUnitID')

INSERT INTO TemplateTableDefinitions (TemplateDefinitions_id, ColumnName)
VALUES (@TemplateDefinitionID, 'SampleUnitName')
