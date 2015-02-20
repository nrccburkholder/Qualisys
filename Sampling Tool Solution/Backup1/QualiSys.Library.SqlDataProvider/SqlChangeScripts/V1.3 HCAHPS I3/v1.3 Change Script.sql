/***********************************************************************************
						Table Creations/Alterations/Populations
***********************************************************************************/
CREATE TABLE MethodologyStepType (
MethodologyStepTypeId INT IDENTITY(1,1),
bitSurveyInLine BIT,
bitSendSurvey  BIT,
bitThankYouItem BIT,
strMailingStep_nm VARCHAR(42),
MailingStepMethod_id INT,
CoverLetterRequired BIT)

-----------------------------------------------------------------------------------------------
GO

INSERT INTO MethodologyStepType
SELECT 0,bitSendSurvey,0,strMailingStepName,0,0
FROM MailingStepName

INSERT INTO MethodologyStepType
SELECT 0,0,0,'Web Survey',1,0
INSERT INTO MethodologyStepType
SELECT 0,0,0,'IVR Survey',1,0

UPDATE MethodologyStepType SET CoverLetterRequired=CASE WHEN strMailingStep_nm IN ('Phone','Web Survey','Thank You(Web)') THEN 0 ELSE 1 END

-----------------------------------------------------------------------------------------------
GO

UPDATE MethodologyStepType SET MailingStepMethod_id=1 WHERE strMailingStep_nm='Phone'

-----------------------------------------------------------------------------------------------
GO

CREATE TABLE StandardMethodology (
	StandardMethodologyID INT IDENTITY (1, 1) NOT NULL ,
	strStandardMethodology_nm VARCHAR (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	bitCustom BIT,
	MethodologyType VARCHAR(30),
	CONSTRAINT PK_StandardMethodology PRIMARY KEY  CLUSTERED 
	(
		StandardMethodologyID
	) WITH  FILLFACTOR = 90  
) 
-----------------------------------------------------------------------------------------------
GO

CREATE TABLE StandardMailingStep (
	StandardMailingStepID INT IDENTITY (1, 1) NOT NULL ,
	StandardMethodologyID INT NOT NULL ,
	intSequence INT NOT NULL ,
	bitSurveyInLine BIT NOT NULL ,
	bitSendSurvey BIT NOT NULL ,
	intIntervalDays INT NOT NULL ,
	bitThankYouItem BIT NOT NULL ,
	strMailingStep_nm VARCHAR (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	bitFirstSurvey BIT NOT NULL ,
	OverRide_Langid INT NULL ,
	MMMailingStep_id INT NULL ,
	MailingStepMethod_id tinyint NULL CONSTRAINT DF__MAILINGST__Mail__16EEEF56 DEFAULT (0),
	ExpireInDays INT NULL CONSTRAINT DF__MailingSt__Expi__23D4B47F DEFAULT (84),
	ExpireFromStep INT NULL ,
	CONSTRAINT PK_StandardMailingStep PRIMARY KEY  CLUSTERED 
	(
		StandardMailingStepID
	) WITH  FILLFACTOR = 90  ,
	CONSTRAINT FK_StandardMAILINGS_REF_6482_MAILING FOREIGN KEY 
	(
		StandardMethodologyID
	) REFERENCES StandardMethodology (
		StandardMethodologyID
))
-----------------------------------------------------------------------------------------------
GO

CREATE TABLE StandardMethodologyBySurveyType (
StandardMethodologyID INT,
SurveyType_id INT,
CONSTRAINT FK_SMST_SurveyType FOREIGN KEY (
  SurveyType_id )
  REFERENCES SurveyType (
  SurveyType_id ),
CONSTRAINT FK_SMST_StandardMethodology FOREIGN KEY (
  StandardMethodologyID )
  REFERENCES StandardMethodology (
  StandardMethodologyID )
)
-----------------------------------------------------------------------------------------------
GO

CREATE TABLE MedicareLookup (
MedicareNumber VARCHAR(20) NOT NULL,
MedicareName VARCHAR(200) NOT NULL,
CONSTRAINT PK_ML_MedicareNumber PRIMARY KEY (MedicareNumber)
)
-----------------------------------------------------------------------------------------------
GO

ALTER TABLE SUFacility ADD CONSTRAINT PK_SUF_SUFacilityID PRIMARY KEY (SUFacility_id)

-----------------------------------------------------------------------------------------------
GO

CREATE TABLE ClientSUFacilityLookup (
Client_id INT NOT NULL,
SUFacility_id INT NOT NULL,
CONSTRAINT PK_CFL_ClientFacility PRIMARY KEY (Client_id, SUFacility_id),
CONSTRAINT FK_CFL_SUFacility FOREIGN KEY (SUFacility_id) REFERENCES SUFacility (SUFacility_id),
CONSTRAINT FK_CFL_Client FOREIGN KEY (Client_id) REFERENCES Client (Client_id),
)
-----------------------------------------------------------------------------------------------
GO

INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Mail Only, 2 Step, 18 Days',0,'Mail Only'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Phone Only, 1 Step',0,'Telephone Only'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Mixed Mode, 1 Mail, 1 Phone, 18 Days',0,'Mixed Mode'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'IVR, 1 Step',0,'IVR'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Custom',1,'Exception'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Mail only, 1 step', 0, 'NRC+Picker Mail Only'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Mail only, 2 step, 18 days', 0, 'NRC+Picker Mail Only'
INSERT INTO StandardMethodology (strStandardMethodology_nm, bitCustom, MethodologyType)
SELECT 'Mail only with reminder, 3 step, 18 days', 0, 'NRC+Picker Mail Only'

-----------------------------------------------------------------------------------------------
GO

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 1,1,0,1,0,0,'1st Survey',1,NULL,NULL,0,84,1

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 1,2,0,1,18,0,'2nd Survey',0,NULL,NULL,0,84,2

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 2,1,0,1,0,0,'Phone',1,NULL,NULL,1,84,3

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 3,1,0,1,0,0,'1st Survey',1,NULL,NULL,0,84,4

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 3,2,0,1,18,0,'Phone',0,NULL,NULL,1,84,5

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 4,1,0,1,0,0,'IVR Survey',1,NULL,NULL,1,84,6

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 6,1,0,1,0,0,'1st Survey',1,NULL,NULL,0,84,7

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 7,1,0,1,0,0,'1st Survey',1,NULL,NULL,0,84,8

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 7,2,0,1,18,0,'2nd Survey',0,NULL,NULL,0,84,9

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 8,1,0,1,0,0,'1st Survey',1,NULL,NULL,0,84,10

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 8,2,0,0,18,0,'Reminder',0,NULL,NULL,0,84,11

INSERT INTO StandardMailingStep (StandardMethodologyID,intSequence,bitSurveyInLine,
     bitSendSurvey,intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
     OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT 8,3,0,1,18,0,'2nd Survey',0,NULL,NULL,0,84,12
-----------------------------------------------------------------------------------------------
GO

INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 1,2
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 2,2
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 3,2
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 4,2
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 5,2
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 5,1
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 6,1
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 7,1
INSERT INTO StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id)
SELECT 8,1


-----------------------------------------------------------------------------------------------
GO

ALTER TABLE MailingMethodology ADD StandardMethodologyID INT NOT NULL DEFAULT(5)
ALTER TABLE MailingMethodology ALTER COLUMN strMethodology_nm VARCHAR(42) NOT NULL

-----------------------------------------------------------------------------------------------
GO

ALTER TABLE MailingMethodology ADD CONSTRAINT MM_StandardMethodology 
   FOREIGN KEY (StandardMethodologyID) REFERENCES StandardMethodology (StandardMethodologyID)

-----------------------------------------------------------------------------------------------
GO

INSERT INTO ClientSUFacilityLookup (Client_id, SUFacility_id)
SELECT su.Client_id, su.SUFacility_id
FROM SUFacility su, Client c
WHERE su.Client_id=c.Client_id
-----------------------------------------------------------------------------------------------
GO

ALTER TABLE SUFacility DROP COLUMN Client_id
ALTER TABLE suFacility ADD MedicareNumber VARCHAR(20)
ALTER TABLE SUFacility ADD CONSTRAINT FK_SUF_Medicare FOREIGN KEY (MedicareNumber) REFERENCES MedicareLookup (MedicareNumber)

-----------------------------------------------------------------------------------------------
GO

--Update to Standard Methodology=1 where I can and report any differences.
SELECT Methodology_id, MIN(intIntervalDays) minint, MAX(intIntervalDays) maxint
INTO #Methodology
FROM MailingStep
GROUP BY Methodology_id
HAVING COUNT(*)=2

DELETE t
FROM #Methodology t, Mailingstep ms
WHERE t.Methodology_id=ms.Methodology_id
AND bitSendSurvey=0

DELETE #Methodology WHERE maxint<>18
DELETE #Methodology WHERE minint<>0

SELECT SurveyType_id, COUNT(*)
FROM Survey_def sd, MailingMethodology mm, #Methodology t
WHERE t.Methodology_id=mm.Methodology_id
AND mm.Survey_id=sd.Survey_id
GROUP BY SurveyType_id

UPDATE mm
SET StandardMethodologyID=1
FROM MailingMethodology mm, #Methodology t, Survey_def sd
WHERE t.Methodology_id=mm.Methodology_id
AND mm.Survey_id=sd.Survey_id
AND sd.SurveyType_id=2

DROP TABLE #Methodology

SELECT strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id
FROM Client c, Study s, Survey_def sd, MailingMethodology mm
WHERE sd.SurveyType_id=2
AND sd.Survey_id=mm.Survey_id
AND mm.bitActiveMethodology=1
AND StandardMethodologyID<>1
AND sd.Study_id=s.Study_id
AND s.Client_id=c.Client_id
ORDER BY 1,3,5

-----------------------------------------------------------------------------------------------
GO

ALTER TABLE Extract_Web_QuestionForm ADD LangID INT

-----------------------------------------------------------------------------------------------
GO

ALTER TABLE DispositionLog ADD DaysFromCurrent INT, DaysFromFirst INT
-----------------------------------------------------------------------------------------------
GO

ALTER VIEW Phase4_NonQuestion_View AS  

SELECT Study_id, QuestionForm_id, SamplePop_id, SampleUnit_id, strLithoCode, SampleSet_id, datReturned, -- AS datResultsImported, 
  NULL datReportDate, strUnitSelectType, bitComplete, DaysFromFirstMailing, DaysFromCurrentMailing, LangID
FROM Extract_Web_QuestionForm

-- SELECT sp.Study_id, qf.QuestionForm_id, sp.SamplePop_id, ss.SampleUnit_id, sm.strLithoCode, sp.SampleSet_id,   
--    qf.datResultsImported, NULL datReportDate, ss.strUnitSelectType, qf.bitComplete  
-- FROM (SELECT DISTINCT QuestionForm_ID FROM QuestionForm_Extract (NOLOCK) WHERE datExtracted_dt IS NULL AND Study_id IS NOT NULL AND tiExtracted = 0) qfe,   
--  QuestionForm qf(NOLOCK), SentMailing sm(NOLOCK), SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK)  
-- WHERE qfe.QuestionForm_ID=qf.QuestionForm_ID  
-- AND qf.SentMail_id=sm.SentMail_id  
-- AND qf.SamplePop_id=sp.SamplePop_id  
-- AND sp.SampleSet_id=ss.SampleSet_id  
-- AND sp.Pop_id=ss.Pop_id  

-----------------------------------------------------------------------------------------------
GO

INSERT INTO SurveyValidationProcs
SELECT 'SV_ActiveMethodology','PASSED!  Survey has one active methodology.',12

-----------------------------------------------------------------------------------------------
GO

ALTER VIEW Web_SampleUnits_View AS

SELECT SampleUnit_id, ParentSampleUnit_id, strSampleUnit_nm, sd.Survey_id, sd.Study_id, 
case when inttargetreturn > 0 then 'D' else 'I' end strUnitSelectType, intTier intLevel, 
Reporting_Level_nm strLevel_nm, bitSuppress,bitHCAHPS,a.MedicareNumber, 
  MedicareName,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,
  bitTeaching,bitTrauma,bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
  bitPicker,bitFreeStanding,AHA_id
FROM SampleUnit su(NOLOCK) LEFT JOIN (
 SELECT suf.*, strRegion_nm, MedicareName 
 FROM SUFacility suf 
 LEFT JOIN MedicareLookup ml ON suf.MedicareNumber=ml.MedicareNumber
 LEFT JOIN Region r ON suf.Region_id=r.Region_id) a
ON su.SUFacility_id=a.SUFacility_id, 
SamplePlan sp(NOLOCK), Survey_def sd(NOLOCK), ReportingHierarchy rh(NOLOCK)
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = sd.Survey_id
AND su.Reporting_Hierarchy_id = rh.Reporting_Hierarchy_id

-----------------------------------------------------------------------------------------------
GO

ALTER TABLE Disposition ADD HCAHPSHierarchy INT

--Original Values before update on 7/27/2006
--UPDATE Disposition SET HCAHPSHierarchy=7 WHERE strReportLabel='Patient Refused'
--UPDATE Disposition SET HCAHPSHierarchy=2 WHERE strReportLabel='Ineligible - Deceased'
--UPDATE Disposition SET HCAHPSHierarchy=5 WHERE strReportLabel='Mental/Physical Incapacitation'
--UPDATE Disposition SET HCAHPSHierarchy=9 WHERE strReportLabel='Non Response Bad Address'
--UPDATE Disposition SET HCAHPSHierarchy=8 WHERE strReportLabel='Non Response Bad Phone'
--UPDATE Disposition SET HCAHPSHierarchy=3 WHERE strReportLabel='Not in Eligible Population'
--UPDATE Disposition SET HCAHPSHierarchy=4 WHERE strReportLabel='Language Barrier'
--UPDATE Disposition SET HCAHPSHierarchy=6 WHERE strReportLabel='Mail/Phone or IVR is not complete'
--UPDATE Disposition SET HCAHPSHierarchy=10 WHERE strReportLabel='Maximum Attempts on Phone or Mail'
--UPDATE Disposition SET HCAHPSHierarchy=1 WHERE strReportLabel='Complete and Valid Survey'


UPDATE Disposition SET HCAHPSHierarchy=9 WHERE strReportLabel='Patient Refused'
UPDATE Disposition SET HCAHPSHierarchy=2 WHERE strReportLabel='Ineligible - Deceased'
UPDATE Disposition SET HCAHPSHierarchy=8 WHERE strReportLabel='Mental/Physical Incapacitation'
UPDATE Disposition SET HCAHPSHierarchy=7 WHERE strReportLabel='Non Response Bad Address'
UPDATE Disposition SET HCAHPSHierarchy=6 WHERE strReportLabel='Non Response Bad Phone'
UPDATE Disposition SET HCAHPSHierarchy=1 WHERE strReportLabel='Not in Eligible Population'
UPDATE Disposition SET HCAHPSHierarchy=5 WHERE strReportLabel='Language Barrier'
UPDATE Disposition SET HCAHPSHierarchy=4 WHERE strReportLabel='Mail/Phone or IVR is not complete'
UPDATE Disposition SET HCAHPSHierarchy=10 WHERE strReportLabel='Maximum Attempts on Phone or Mail'
UPDATE Disposition SET HCAHPSHierarchy=3 WHERE strReportLabel='Complete and Valid Survey'

UPDATE Disposition SET action_id=5 WHERE strReportLabel='Language Barrier'

insert into DispositionListDef(DispositionList_id,Disposition_id,Author,datOccurred)
		values (1,10,263,getdate())
-----------------------------------------------------------------------------------------------
GO

CREATE FUNCTION dbo.fn_DispDaysFromCurrent (@SentMail_id INT, @datLogged DATETIME, @Disposition_id INT)
RETURNS INT
AS
BEGIN

RETURN (SELECT DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)),datLogged)
FROM DispositionLog dl(NOLOCK), SentMailing sm(NOLOCK)
WHERE dl.SentMail_id=@SentMail_id
AND dl.datLogged=@datLogged
AND dl.SentMail_id=sm.SentMail_id
AND dl.Disposition_id=@Disposition_id)

END

GO
-----------------------------------------------------------------------------------------------
GO

CREATE FUNCTION dbo.fn_DispDaysFromFirst (@SentMail_id INT, @datLogged DATETIME, @Disposition_id INT)
RETURNS INT
AS
BEGIN

RETURN (SELECT DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),MIN(datMailed),120)),dl.datLogged)
FROM DispositionLog dl(NOLOCK), ScheduledMailing schm(NOLOCK), ScheduledMailing schm2(NOLOCK), SentMailing sm(NOLOCK)
WHERE dl.SentMail_id=@SentMail_id
AND dl.datLogged=@datLogged
AND dl.SentMail_id=schm.SentMail_id
AND schm.SamplePop_id=schm2.SamplePop_id
AND schm2.SentMail_id=sm.SentMail_id
AND dl.Disposition_id=@Disposition_id
GROUP BY dl.datLogged)

END

GO
-----------------------------------------------------------------------------------------------
GO

CREATE VIEW ETL_DispositionLog_View
AS
SELECT Study_id,sp.SamplePop_id,Disposition_id,dl.ReceiptType_id,datLogged,LoggedBy, DaysFromCurrent, DaysFromFirst
FROM DispositionLog dl, SamplePop sp, QuestionForm qf
WHERE dl.datLogged>DATEADD(DAY,-7,GETDATE())
AND dl.SamplePop_id=sp.SamplePop_id
AND dl.SentMail_id=qf.SentMail_id

GO
-----------------------------------------------------------------------------------------------
GO

CREATE VIEW ETL_DispositionLog_View_backfill
AS

SELECT Study_id,sp.SamplePop_id,Disposition_id,dl.ReceiptType_id,datLogged,LoggedBy, DaysFromCurrent, DaysFromFirst FROM
(SELECT Sentmail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy, DaysFromCurrent, DaysFromFirst FROM DispositionLog dl 
UNION ALL 
SELECT Sentmail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy, DaysFromCurrent, DaysFromFirst FROM tmpI3_DispositionLog_bitcomplete) 
dl, SamplePop sp, QuestionForm qf
WHERE dl.SamplePop_id=sp.SamplePop_id
AND dl.SentMail_id=qf.SentMail_id

GO
-----------------------------------------------------------------------------------------------
GO

ALTER VIEW WEB_ClientStudySurvey_View     
AS    

-- 7/31/06 SJS: Added datHCAHPSReportable column  
SELECT DISTINCT strClient_nm, s.strStudy_nm, sd.strSurvey_nm strQSurvey_nm, ISNULL(strClientFacingName,sd.strSurvey_nm) strSurvey_nm, c.Client_id, s.Study_id, sd.Survey_id,     
 strNTLogin_nm, strField_nm strReportDateField, CASE WHEN datArchived IS NULL THEN 0 ELSE 1 END bitArchived, sd.datHCAHPSReportable, sd.SurveyType_id
FROM ClientStudySurvey_View c (NOLOCK), Study s (NOLOCK), Employee e (NOLOCK), Survey_Def sd (NOLOCK),    
 MetaField mf(NOLOCK)    
WHERE c.Study_id=s.Study_id    
AND s.ADEmployee_id=e.Employee_id    
AND c.Survey_id=sd.Survey_id    
AND sd.cutofffield_id=mf.field_id    
AND sd.strCutOffResponse_CD=2    
UNION    
SELECT DISTINCT strClient_nm, s.strStudy_nm, sd.strSurvey_nm strQSurvey_nm, ISNULL(strClientFacingName,sd.strSurvey_nm) strSurvey_nm, c.Client_id, s.Study_id, sd.Survey_id,     
 strNTLogin_nm, CASE WHEN strCutOffResponse_cd=0 THEN 'SampleCreate'     
 WHEN strCutOffResponse_cd=1 THEN 'ReturnDate' END strReportDateField,    
 CASE WHEN datArchived IS NULL THEN 0 ELSE 1 END bitArchived, sd.datHCAHPSReportable, sd.SurveyType_id
FROM ClientStudySurvey_View c (NOLOCK), Study s (NOLOCK), Employee e (NOLOCK), Survey_Def sd (NOLOCK)    
WHERE c.Study_id=s.Study_id    
AND s.ADEmployee_id=e.Employee_id    
AND c.Survey_id=sd.Survey_id    
AND sd.strCutOffResponse_CD IN (0,1)    

GO
-----------------------------------------------------------------------------------------------
GO

SET IDENTITY_INSERT dbo.ReceiptType ON
INSERT INTO dbo.ReceiptType (ReceiptType_id, ReceiptType_nm, ReceiptType_dsc, bitUIDisplay)
SELECT 0, 'System', 'System Calcuated - ETL', 0
SET IDENTITY_INSERT dbo.ReceiptType OFF
  
GO
-----------------------------------------------------------------------------------------------
GO

UPDATE METHODOLOGYSTEPTYPE SET bitSendSurvey = 1 WHERE MethodologyStepTypeId IN (13,14,15) 
UPDATE METHODOLOGYSTEPTYPE SET CoverLetterRequired = 0 WHERE MethodologyStepTypeId IN (15) 
  
GO
-----------------------------------------------------------------------------------------------
GO

-- Backfill dispositionlog with nondel disposition for datundeliverable 4/1/06 and greater 
INSERT INTO DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy)    
SELECT  sm.sentmail_id, sp.samplepop_id, 5 as disposition_id, 0 as ReceiptType_id, sm.datUndeliverable AS datLogged, '#nrcsql' AS LoggedBy
FROM samplepop sp, scheduledmailing sc, sentmailing sm, 
(select sampleset_id from sampleset where datsamplecreate_dt >= '1/1/06' and datdaterange_fromdate > '3/31/06') ss
WHERE sp.sampleset_id = ss.sampleset_id and sp.samplepop_id = sc.samplepop_id and sc.scheduledmailing_id = sm.scheduledmailing_Id 
AND sm.datundeliverable > '3/31/06'

-----------------------------------------------------------------------------------------------

/***********************************************************************************
								Stored Procedures							
***********************************************************************************/
CREATE PROCEDURE dbo.QCL_SelectMethodology
@MethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF EXISTS (SELECT * FROM ScheduledMailing WHERE Methodology_id=@MethodologyID)
BEGIN
  SELECT Methodology_id, Survey_id, strMethodology_nm, bitActiveMethodology, 
         sm.StandardMethodologyId, datCreate_dt, 0 bitAllowEdit, bitCustom
  FROM MailingMethodology mm, StandardMethodology sm
  WHERE Methodology_id=@MethodologyId
  AND mm.StandardMethodologyID=sm.StandardMethodologyID
END
ELSE
BEGIN
  SELECT Methodology_id, Survey_id, strMethodology_nm, bitActiveMethodology, 
         sm.StandardMethodologyId, datCreate_dt, 1 bitAllowEdit, bitCustom
  FROM MailingMethodology mm, StandardMethodology sm
  WHERE Methodology_id=@MethodologyId
  AND mm.StandardMethodologyID=sm.StandardMethodologyID
END

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE dbo.QCL_SelectMethodologiesBySurveyId
@SurveyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT mm.Methodology_id, Survey_id, strMethodology_nm, bitActiveMethodology, 
       sm.StandardMethodologyId, datCreate_dt, CASE WHEN a.Methodology_id IS NULL THEN 1 ELSE 0 END bitAllowEdit,
       bitCustom
FROM MailingMethodology mm LEFT JOIN (SELECT Methodology_id FROM ScheduledMailing
 GROUP BY Methodology_id) a
ON mm.Methodology_id=a.Methodology_id, StandardMethodology sm
WHERE Survey_id=@SurveyId
AND mm.StandardMethodologyID=sm.StandardMethodologyID
ORDER BY mm.Methodology_id

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE dbo.QCL_SelectMethodologyStepsByMethodologyId
@MethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MailingStep_id, strMailingStep_nm, Methodology_id, Survey_id, intSequence, 
		SelCover_id, intIntervalDays, bitSendSurvey, bitThankYouItem, bitFirstSurvey, 
		Override_Langid, MMMailingStep_id, MailingStepMethod_id, ExpireInDays, ExpireFromStep
FROM MailingStep
WHERE Methodology_id=@MethodologyId
ORDER BY intSequence
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
IF (EXISTS (SELECT name FROM sysobjects WHERE (name = N'QCL_SelectMailingStep') AND (type = 'P')))
DROP PROCEDURE dbo.QCL_SelectMailingStep
GO
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_InsertMethodology
@SurveyId INT,
@Name VARCHAR(42),
@StandardMethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

INSERT INTO MailingMethodology (Survey_id, bitActiveMethodology, strMethodology_nm, datCreate_dt, StandardMethodologyID)
SELECT @SurveyId, 0, @Name, GETDATE(), @StandardMethodologyId

SELECT SCOPE_IDENTITY()
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_InsertMethodologyStep
@MethodologyId INT,
@SurveyId INT,
@SequenceNumber INT,
@CoverLetterId INT,
@IsSurvey BIT,
@DaysSincePreviousStep INT,
@IsThankYouLetter BIT,
@Name VARCHAR(20),
@IsFirstSurvey BIT,
@OverrideLanguageId INT,
@LinkedStepId INT,
@StepMethodId INT,
@ExpirationDays INT,
@ExpireFromStepId INT
AS

DECLARE @NewId INT

INSERT INTO MailingStep (Methodology_id,Survey_id,intSequence,SelCover_id,
          bitSurveyInLine,bitSendSurvey,intIntervalDays,bitThankYouItem,
          strMailingStep_nm,bitFirstSurvey,Override_LangId,MMMailingStep_id,
          MailingStepMethod_id,ExpireInDays,ExpireFromStep)
SELECT @MethodologyId,@SurveyId,@SequenceNumber,@CoverLetterId,
          0,@IsSurvey,@DaysSincePreviousStep,@IsThankYouLetter,
          @Name,@IsFirstSurvey,@OverrideLanguageId,@LinkedStepId,
          @StepMethodId,@ExpirationDays,@ExpireFromStepId

SELECT @NewId=SCOPE_IDENTITY()  

UPDATE MailingStep 
SET MMMailingStep_id=CASE @LinkedStepId WHEN 0 THEN NULL ELSE @LinkedStepId END,
    ExpireFromStep=CASE @ExpireFromStepId WHEN 0 THEN @NewID ELSE @ExpireFromStepId END
WHERE MailingStep_id=@NewId

SELECT @NewId

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

ALTER PROCEDURE QCL_SelectMailingByLitho
@Litho VARCHAR(10)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT sm.SentMail_id, sm.strLithoCode, ms.MailingStep_id, ms.strMailingStep_nm, sp.Study_id, ms.Survey_id,   
  sp.Pop_id, sm.LangId, sm.datGenerated, sm.datPrinted, sm.datMailed,   
  schm.datGenerate 'datGenerationScheduled', sm.datUndeliverable, qf.datReturned  
FROM SentMailing sm LEFT OUTER JOIN QuestionForm qf ON (qf.SentMail_id=sm.SentMail_id),   
  ScheduledMailing schm, SamplePop sp, MailingStep ms  
WHERE sm.strLithoCode=@Litho  
AND sm.ScheduledMailing_id=schm.ScheduledMailing_id  
AND schm.SamplePop_id=sp.SamplePop_id  
AND schm.MailingStep_id=ms.MailingStep_id  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE QCL_SelectMailingByBarcode
@Barcode VARCHAR(8)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT sm.SentMail_id, sm.strLithoCode, ms.MailingStep_id, ms.strMailingStep_nm, sp.Study_id, 
  ms.Survey_id, sp.Pop_id, sm.LangId, sm.datGenerated, sm.datPrinted, 
  sm.datMailed, schm.datGenerate 'datGenerationScheduled', 
  sm.datUndeliverable, qf.datReturned
FROM SentMailing sm LEFT OUTER JOIN QuestionForm qf ON (qf.SentMail_id=sm.SentMail_id), 
 ScheduledMailing schm, SamplePop sp, MailingStep ms
WHERE sm.strLithoCode=DBO.BarcodeToLitho(@Barcode,1)
AND sm.ScheduledMailing_id=schm.ScheduledMailing_id
AND schm.SamplePop_id=sp.SamplePop_id
AND schm.MailingStep_id=ms.MailingStep_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE QCL_SelectMailingByWAC
@WAC VARCHAR(12)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT sm.SentMail_id, sm.strLithoCode, ms.MailingStep_id, ms.strMailingStep_nm, sp.Study_id, ms.Survey_id, 
  sp.Pop_id, sm.LangId, sm.datGenerated, sm.datPrinted, sm.datMailed, 
  schm.datGenerate 'datGenerationScheduled', sm.datUndeliverable, qf.datReturned
FROM SentMailing sm LEFT OUTER JOIN QuestionForm qf ON (qf.SentMail_id=sm.SentMail_id), 
  ScheduledMailing schm, SamplePop sp, MailingStep ms
WHERE sm.strLithoCode=DBO.WACToLitho(@WAC)
AND sm.ScheduledMailing_id=schm.ScheduledMailing_id
AND schm.SamplePop_id=sp.SamplePop_id
AND schm.MailingStep_id=ms.MailingStep_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
ALTER PROCEDURE QCL_SelectMailingsByPopId
@PopId INT,
@StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT sm.SentMail_id, sm.strLithoCode, ms.MailingStep_id, ms.strMailingStep_nm, sp.Study_id, ms.Survey_id, 
  sp.Pop_id, sm.LangId, sm.datGenerated, sm.datPrinted, sm.datMailed, 
  schm.datGenerate 'datGenerationScheduled', sm.datUndeliverable, qf.datReturned
FROM SamplePop sp, MailingStep ms, 
  ScheduledMailing schm LEFT OUTER JOIN SentMailing sm ON (sm.ScheduledMailing_id=schm.ScheduledMailing_id) 
  LEFT OUTER JOIN QuestionForm qf ON (qf.SentMail_id=sm.SentMail_id)
WHERE schm.SamplePop_id=sp.SamplePop_id
AND schm.MailingStep_id=ms.MailingStep_id
AND sp.Study_id=@StudyId
AND sp.Pop_id=@PopId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE dbo.QCL_SelectAllMethodologyStepTypes
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MethodologyStepTypeId, bitSendSurvey, bitThankYouItem, strMailingStep_nm, 
 MailingStepMethod_id, CoverLetterRequired
FROM MethodologyStepType
ORDER BY strMailingStep_nm

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_SelectStandardMethodologySteps
 @StandardMethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT StandardMailingStepId, StandardMethodologyID,intSequence,bitSurveyInLine,bitSendSurvey,
       intIntervalDays,bitThankYouItem,strMailingStep_nm,bitFirstSurvey,
       OverRide_Langid,MMMailingStep_id,MailingStepMethod_id,ExpireInDays,
       ExpireFromStep
FROM StandardMailingStep
WHERE StandardMethodologyID=@StandardMethodologyID 
ORDER BY intSequence

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_SelectStandardMethodologiesBySurveyTypeId
 @SurveyTypeID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
FROM StandardMethodology sm, StandardMethodologyBySurveyType smst
WHERE smst.SurveyType_id=@SurveyTypeID
AND smst.StandardMethodologyID=sm.StandardMethodologyID
ORDER BY sm.strStandardMethodology_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO 
-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE dbo.QCL_DeleteMethodology
@MethodologyId INT
AS
 
IF EXISTS (SELECT ScheduledMailing_id FROM ScheduledMailing WHERE Methodology_id = @MethodologyId)
BEGIN
            RAISERROR ('The methodology cannot be deleted because it has already been used to schedule survey generation.', 18, 1)
END
ELSE
BEGIN
	DELETE MailingStep
	WHERE Methodology_id=@MethodologyId

	DELETE MailingMethodology
	WHERE Methodology_id=@MethodologyId
END
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE dbo.QCL_DeleteMethodologyStepsByMethodologyId
@MethodologyId INT
AS

IF EXISTS (SELECT ScheduledMailing_id FROM ScheduledMailing WHERE Methodology_id=@MethodologyId)
BEGIN
   RAISERROR ('The methodology cannot be deleted because it has already been used to schedule survey generation.', 18, 1)
END

ELSE

DELETE MailingStep
WHERE Methodology_id=@MethodologyId

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_UpdateMethodology
@MethodologyId INT,
@SurveyId INT,
@Name VARCHAR(42),
@StandardMethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE MailingMethodology 
SET Survey_id=@SurveyId,
	strMethodology_nm=@Name,
	StandardMethodologyId=@StandardMethodologyId
WHERE Methodology_id=@MethodologyId
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_UpdateMethodologyActiveState 
@MethodologyId INT,
@IsActive BIT -- 0 => inActive 1=> Active
AS

UPDATE MailingMethodology 
SET bitActiveMethodology=@IsActive 
WHERE Methodology_id=@MethodologyID

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_SelectStandardMethodology
 @StandardMethodologyId INT  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom  
FROM StandardMethodology sm
WHERE sm.StandardMethodologyId=@StandardMethodologyId
  
SET NOCOUNT OFF  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_SelectCoverLettersBySurveyID
@SurveyID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SelCover_id, [Description] 
FROM Sel_Cover 
WHERE Survey_id=@SurveyID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE dbo.QCL_SelectAllFacilities
AS  

CREATE TABLE #t (
SUFacility_id INT,
strFacility_nm VARCHAR(100),
City VARCHAR(42),
State VARCHAR(2),
Country VARCHAR(42),
Region_id INT,
AdmitNumber INT,
BedSize INT,
bitPeds BIT,
bitTeaching BIT,
bitTrauma BIT,
bitReligious BIT,
bitGovernment BIT,
bitRural BIT,
bitForProfit BIT,
bitRehab BIT,
bitCancerCenter BIT,
bitPicker BIT,
bitFreeStanding BIT,
AHA_id INT,
MedicareNumber VARCHAR(20),
MedicareName varchar(45),
IsHCAHPSAssigned BIT DEFAULT(0)
)

INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,MedicareName
FROM SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
ORDER BY strFacility_nm, City

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*          
Business Purpose:           
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.      
          
Created: 3/14/2006 by DC      
          
Modified:          
        
      
*/
ALTER PROCEDURE QCL_SelectFacilityByClientId
@Client_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #t (
SUFacility_id INT,
strFacility_nm VARCHAR(100),
City VARCHAR(42),
State VARCHAR(2),
Country VARCHAR(42),
Region_id INT,
AdmitNumber INT,
BedSize INT,
bitPeds BIT,
bitTeaching BIT,
bitTrauma BIT,
bitReligious BIT,
bitGovernment BIT,
bitRural BIT,
bitForProfit BIT,
bitRehab BIT,
bitCancerCenter BIT,
bitPicker BIT,
bitFreeStanding BIT,
AHA_id INT,
MedicareNumber VARCHAR(20),
MedicareName varchar(45),
IsHCAHPSAssigned BIT DEFAULT(0)
)

INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT suf.SUFacility_id,strFacility_nm,City,State,Country,
  Region_id,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,
  bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,
  bitCancerCenter,bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,
  MedicareName
FROM ClientSUFacilityLookup cf, SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
WHERE cf.Client_id=@Client_Id
AND cf.SUFacility_id=suf.SUFacility_id

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*      
Business Purpose:       
This procedure is used to support the Qualisys Class Library.  It will return all facilities for an AHAId.  
      
Created: 3/14/2006 by DC  
      
Modified:      
    
  
*/          
ALTER PROCEDURE QCL_SelectFacilityByAHAId  
@AHA_ID INT  
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #t (
SUFacility_id INT,
strFacility_nm VARCHAR(100),
City VARCHAR(42),
State VARCHAR(2),
Country VARCHAR(42),
Region_id INT,
AdmitNumber INT,
BedSize INT,
bitPeds BIT,
bitTeaching BIT,
bitTrauma BIT,
bitReligious BIT,
bitGovernment BIT,
bitRural BIT,
bitForProfit BIT,
bitRehab BIT,
bitCancerCenter BIT,
bitPicker BIT,
bitFreeStanding BIT,
AHA_id INT,
MedicareNumber VARCHAR(20),
MedicareName varchar(45),
IsHCAHPSAssigned BIT DEFAULT(0)
)

INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,MedicareName
FROM SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
WHERE AHA_id=@AHA_id  

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.

Created: 3/14/2006 by DC

Modified:


*/
ALTER  PROCEDURE QCL_SelectFacility
@SUFacility_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #t (
SUFacility_id INT,
strFacility_nm VARCHAR(100),
City VARCHAR(42),
State VARCHAR(2),
Country VARCHAR(42),
Region_id INT,
AdmitNumber INT,
BedSize INT,
bitPeds BIT,
bitTeaching BIT,
bitTrauma BIT,
bitReligious BIT,
bitGovernment BIT,
bitRural BIT,
bitForProfit BIT,
bitRehab BIT,
bitCancerCenter BIT,
bitPicker BIT,
bitFreeStanding BIT,
AHA_id INT,
MedicareNumber VARCHAR(20),
MedicareName varchar(45),
IsHCAHPSAssigned BIT DEFAULT(0)
)

INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,MedicareName
FROM SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
WHERE SUFacility_id=@SUFacility_id

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_SelectAllMedicareNumbers
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT MedicareNumber, MedicareName
FROM MedicareLookup

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
 
CREATE PROCEDURE QCL_UnassignFacilityFromClient
@SUFacilityID INT,
@ClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DELETE ClientSUFacilityLookup
WHERE Client_id=@ClientID
AND SUFacility_id=@SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO 

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_AssignFacilityToClient
@SUFacilityID INT,
@ClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

EXEC QCL_UnassignFacilityFromClient @SUFacilityID, @ClientID

INSERT INTO ClientSUFacilityLookup (Client_id, SUFacility_id)
SELECT @ClientID, @SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_HCAHPS]        
@Survey_id INT    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
--If this is not an HCAHPS Survey, end the procedure    
IF (SELECT SurveyType_id FROM Survey_def WHERE Survey_id=@Survey_id)<>2    
BEGIN    
   RETURN    
END    
    
--Need a temp table to store the messages.  We will select them at the end.         
--0=Passed,1=Error,2=Warning         
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))      
    
--Make sure the 6 "H" fields are a part of the study  
INSERT INTO #M (Error, strMessage)  
SELECT 1,a.strField_nm+' is not a in the data structure.'  
FROM (SELECT Field_id, strField_nm   
      FROM MetaField  
      WHERE strField_nm IN ('HServiceType','HVisitType','HAdmissionSource',  
                            'HDischargeStatus','HAdmitAge','HCatAge')) a  
      LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd   
                 WHERE sd.Survey_id=@Survey_id   
                 AND sd.Study_id=m.Study_id
                 AND m.strTable_nm = 'ENCOUNTER') b    
ON a.strField_nm=b.strField_nm  
WHERE b.strField_nm IS NULL  
IF @@ROWCOUNT=0  
INSERT INTO #M (Error, strMessage)  
SELECT 0,'All HCHAPS fields are in the data structure'  
  
  
--Make sure skip patterns are enforced.    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'Skip Patterns are not enforced.'    
FROM Survey_def     
WHERE Survey_id=@Survey_id    
AND bitEnforceSkip=0        
IF @@ROWCOUNT=0        
INSERT INTO #M (Error, strMessage)        
SELECT 0,'Skip Patterns are enforced'      
    
--Check the ReSurvey Method    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'Resurvey Method is not set to Calendar Month.'    
FROM Survey_def    
WHERE Survey_id=@Survey_id    
AND ReSurveyMethod_id<>2    
    
--Make sure datHCAHPSReportable is populated    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'No HCAHPS Compliance date defined'    
FROM Survey_def    
WHERE Survey_id=@Survey_id    
AND datHCAHPSReportable IS NULL    
    
--Check for HouseHolding    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'Householding is not defined.'    
FROM Survey_def sd LEFT JOIN HouseHoldRule hhr    
ON sd.Survey_id=hhr.Survey_id    
WHERE sd.Survey_id=@Survey_id    
AND hhr.Survey_id IS NULL    
    
--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns        
INSERT INTO #M (Error, strMessage)        
SELECT 1,strField_nm+' is not a householding column.'        
FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a        
  LEFT JOIN HouseHoldRule hhr        
ON a.Field_id=hhr.Field_id        
AND hhr.Survey_id=@Survey_id        
WHERE hhr.Field_id IS NULL        
        
--Make sure the Medicare number is populated.    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'Medicare number is not populated.'    
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf  
ON su.SUFacility_id=suf.SUFacility_id  
WHERE sp.Survey_id=@Survey_id  
AND sp.SamplePlan_id=su.SamplePlan_id  
AND su.bitHCAHPS=1  
AND (suf.MedicareNumber IS NULL    
OR LTRIM(RTRIM(suf.MedicareNumber))='')    
IF @@ROWCOUNT=0        
INSERT INTO #M (Error, strMessage)        
SELECT 0,'Medicare number is populated'         
    
--Make sure we have at least one HCAHPS sampleunit    
IF (SELECT COUNT(*)     
    FROM SampleUnit su, SamplePlan sp     
    WHERE sp.Survey_id=@Survey_id     
    AND sp.SamplePlan_id=su.SamplePlan_id    
    AND bitHCAHPS=1)<1    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'Survey must have at least one HCAHPS Sampleunit.'    
ELSE    
INSERT INTO #M (Error, strMessage)    
SELECT 0,'Survey has one HCAHPS Sampleunit.'    
    
--Check that FacilityState is populated for the HCAHPS units.        
INSERT INTO #M (Error, strMessage)        
SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a state designated.'  
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf  
ON su.SUFacility_id=suf.SUFacility_id  
WHERE sp.Survey_id=@Survey_id  
AND sp.SamplePlan_id=su.SamplePlan_id  
AND su.bitHCAHPS=1  
AND suf.State IS NULL  
  
--Is AHA_id populated?    
IF EXISTS (SELECT *     
     FROM (SELECT SampleUnit_id, SUFacility_id     
     FROM SamplePlan sp, SampleUnit su     
     WHERE sp.Survey_id=@Survey_id     
     AND sp.SamplePlan_id=su.SamplePlan_id     
     AND bitHCAHPS=1) a     
     LEFT JOIN SUFacility f     
     ON a.SUFacility_id=f.SUFacility_id     
     WHERE f.AHA_id IS NULL)    
INSERT INTO #M (Error, strMessage)    
SELECT 2,'At least one HCAHPS Sampleunit does not have an AHA value.'    
    
--What is the sampling algorithm    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'Your sampling algorithm is not StaticPlus.'    
FROM Survey_def    
WHERE Survey_id=@Survey_id    
AND SamplingAlgorithmID<>3    
        
--Make sure the reporting date is either ServiceDate or DischargeDate    
IF (SELECT cutofffield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
	INSERT INTO #M (Error, strMessage)    
	SELECT 1,'Report date has to be either Service or Discharge Date from the Encounter table.'    
ELSE

	INSERT INTO #M (Error, strMessage)    
	SELECT 1,'Report date has to be either Service or Discharge Date from the Encounter table.'    
	FROM Survey_def sd, MetaTable mt    
	WHERE sd.CutOffTable_id=mt.Table_id    
	AND  sd.Survey_id=@Survey_id    
	AND sd.CutOffField_id NOT IN (54,117)    

IF @@ROWCOUNT=0    
INSERT INTO #M (Error, strMessage)    
SELECT 0,'Report date is set to either Service or Discharge Date.'  
    
--Make sure all of the HCAHPS questions are on the form and in the correct location.    
CREATE TABLE #CurrentForm (    
    Order_id INT IDENTITY(1,1),    
    QstnCore INT,    
    Section_id INT,     
    Subsection INT,    
    Item INT    
)    
    
--Get the questions currently on the form    
INSERT INTO #CurrentForm (QstnCore, Section_id, Subsection, Item)    
SELECT QstnCore, Section_id, Subsection, Item    
FROM Sel_Qstns    
WHERE Survey_id=@Survey_id    
AND SubType in (1,4)        
AND Language=1    
AND (Height>0 OR Height IS NULL)      
ORDER BY Section_id, Subsection, Item      
    
--Look for questions missing from the form.    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'    
FROM SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t    
ON s.QstnCore=t.QstnCore    
WHERE s.SurveyType_id=2    
AND t.QstnCore IS NULL    
    
--Look for questions that are out of order.    
--First the questions that have to be at the beginning of the form.    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'    
FROM SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t    
ON s.QstnCore=t.QstnCore    
AND s.intOrder=t.Order_id    
AND s.SurveyType_id=2    
WHERE bitFirstOnForm=1    
AND t.QstnCore IS NULL    
    
--Now the questions that are at the end of the form.    
SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff    
INTO #OrderCheck    
from SurveyTypeQuestionMappings qm, #CurrentForm t    
WHERE qm.SurveyType_id=2    
AND bitFirstOnForm=0    
AND qm.QstnCore=t.QstnCore    
    
DECLARE @OrderDifference INT    
    
SELECT @OrderDifference=OrderDiff    
FROM #OrderCheck    
WHERE OverAllOrder=1    
    
INSERT INTO #M (Error, strMessage)    
SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'    
FROM #OrderCheck    
WHERE OrderDiff<>@OrderDifference    
    
DROP TABLE #OrderCheck   

     
IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0       
BEGIN 
	INSERT INTO #M (Error, strMessage)        
	SELECT 0,'All HCAHPS Questions are on the form in the correct order.'   

	--IF all 27 cores or on the survey, then check that the 27 questions are mapped 
	--in a manner that ensures someone sampled at the HCAHP units will get all of them
	SELECT sampleunit_id
	into #HCAHPSUnits     
	FROM SampleUnit su, SamplePlan sp     
	WHERE sp.Survey_id=@Survey_id     
	AND sp.SamplePlan_id=su.SamplePlan_id    
	AND bitHCAHPS=1

	DECLARE @sampleunit_id int

	SELECT TOP 1 @sampleunit_id=sampleunit_id
	FROM #HCAHPSUnits

	WHILE @@rowcount>0
	BEGIN

		INSERT INTO #M (Error, strMessage)    
		SELECT 1,'QstnCore '+LTRIM(STR(stqm.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'    
		FROM (	SELECT sq.Qstncore
				FROM SAMPLEUNITTREEINDEX si JOIN sampleunitsection su
					ON si.sampleunit_id=@sampleunit_id
						AND si.ancestorunit_id=su.sampleunit_id
					JOIN sel_qstns sq
					ON sq.Survey_id=@Survey_id    
						AND SubType in (1,4)        
						AND Language=1    
						AND (Height>0 OR Height IS NULL) 
						AND su.selqstnssection=sq.section_id
						AND sq.survey_id=su.selqstnssurvey_id
			union
				SELECT sq.Qstncore
				FROM sampleunitsection su JOIN sel_qstns sq
					ON su.sampleunit_id=@sampleunit_id
						AND sq.Survey_id=@Survey_id    
						AND SubType in (1,4)        
						AND Language=1    
						AND (Height>0 OR Height IS NULL) 
						AND su.selqstnssection=sq.section_id
						AND sq.survey_id=su.selqstnssurvey_id) Q
			RIGHT JOIN SurveyTypeQuestionMappings stqm
			ON Q.QstnCore=stqm.QstnCore 
		WHERE stqm.SurveyType_id=2    
					AND Q.QstnCore IS NULL 

		IF @@ROWCOUNT=0       
			INSERT INTO #M (Error, strMessage)        
			SELECT 0,'All HCAHPS Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)  	

		DELETE
		FROM #HCAHPSUnits
		WHERE sampleunit_Id=@sampleunit_id

		SELECT TOP 1 @sampleunit_id=sampleunit_id
		FROM #HCAHPSUnits
	END
END
     
--End of Question checking    
   
--Now to check the active methodology    
CREATE TABLE #ActiveMethodology (standardmethodologyid INT)  
  
INSERT INTO #ActiveMethodology  
SELECT standardmethodologyid  
FROM MailingMethodology (NOLOCK)        
WHERE Survey_id=@Survey_id        
AND bitActiveMethodology=1     
  
IF @@ROWCOUNT<>1    
 INSERT INTO #M (Error, strMessage)    
 SELECT 1,'There must be exactly 1 active methodology.'  
ELSE  
BEGIN  
 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid in (1,2,3,4))  
  INSERT INTO #M (Error, strMessage)    
  SELECT 0,'Survey uses a standard HCAHPS methodology.'  
 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid =5)  
  INSERT INTO #M (Error, strMessage)    
  SELECT 2,'Survey uses a custom methodology.'  
 ELSE  
  INSERT INTO #M (Error, strMessage)    
  SELECT 1,'Survey does not use a standard HCAHPS methodology.'  
END   
  
DROP TABLE #ActiveMethodology        
    
SELECT * FROM #M    
    
DROP TABLE #M    
    
SET NOCOUNT OFF    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
 
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

ALTER  PROCEDURE QCL_InsertFacility
@AHA_id INT,
@strFacility_nm VARCHAR(100),
@City VARCHAR(42),
@State VARCHAR(2),
@Country VARCHAR(42),
@Region_id INT,
@AdmitNumber INT,
@BedSize INT,
@bitPeds BIT,
@bitTeaching BIT,
@bitTrauma BIT,
@bitReligious BIT,
@bitGovernment BIT,
@bitRural BIT,
@bitForProfit BIT,
@bitRehab BIT,
@bitCancerCenter BIT,
@bitPicker BIT,
@bitFreeStanding BIT,
@MedicareNumber VARCHAR(20)
AS

INSERT INTO SUFacility (AHA_id, strFacility_nm, City, State, Country,   
  Region_id, AdmitNumber, BedSize, bitPeds, bitTeaching, bitTrauma,   
  bitReligious, bitGovernment, bitRural, bitForProfit, bitRehab,   
  bitCancerCenter, bitPicker, bitFreeStanding, MedicareNumber)
VALUES (@AHA_id, @strFacility_nm, @City, @State, @Country,   
  @Region_id, @AdmitNumber, @BedSize, @bitPeds, @bitTeaching, @bitTrauma,   
  @bitReligious, @bitGovernment, @bitRural, @bitForProfit, @bitRehab,   
  @bitCancerCenter, @bitPicker, @bitFreeStanding, @MedicareNumber)

SELECT SCOPE_IDENTITY()

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

--  Created 1/27/3 BD Creates a view based on sampleset_id passed from NRC47.QP_COMMENTS.dbo.sp_extract_big_table stored procedure.      
--  Used during the extract to the datamart.      
--  Modified 7/20/2005 BD Added @Cleansed to handle PII information from Canada.      
--  Modified 5/19/2006 BD Added MethodologyType for HCAHPS reporting.      
ALTER PROCEDURE SP_Phase4_Big_View_Web @sampleset INT, @Cleansed BIT=0    
AS      
DECLARE @sql VARCHAR(1000), @ReportDate VARCHAR(50), @strsql VARCHAR(8000), @survey INT, @study INT, @fld VARCHAR(70), @short VARCHAR(70),      
@sel VARCHAR(8000), @cutofftype CHAR(1), @MethodologyType VARCHAR(50)  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
IF (SELECT numParam_Value FROM QualPro_Params WHERE strParam_nm='Country')=2  
SELECT @Cleansed=1  
ELSE  
SELECT @Cleansed=0  
      
--Get the survey and study ids and MethodologyType      
SELECT @survey=survey_id FROM sampleset WHERE sampleset_id=@sampleset      
SELECT @study=study_id FROM survey_def WHERE survey_id=@survey      
SELECT TOP 1 @MethodologyType=MethodologyType   
 FROM SamplePop sp, ScheduledMailing schm, MailingMethodology mm, StandardMethodology sm  
 WHERE sp.SampleSet_id=@SampleSet  
 AND sp.SamplePop_id=schm.SamplePop_id  
 AND schm.Methodology_id=mm.Methodology_id  
 AND mm.StandardMethodologyID=sm.StandardMethodologyID  
  
--if the view already exists, drop it      
SET @strsql = 'IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N''[S' + CONVERT(VARCHAR,@study)+'].[BIG_VIEW_WEB]'') ' +      
 ' AND OBJECTPROPERTY(id, N''IsView'') = 1) DROP VIEW [S' + CONVERT(VARCHAR,@study) + '].[BIG_VIEW_WEB]'      
EXEC(@strsql)      
      
--determine if the study has an encounter table.  This determines part of the join criteria      
SELECT table_id FROM metatable WHERE study_id = @study AND strtable_nm = 'ENCOUNTER'      
IF @@ROWCOUNT = 0      
  BEGIN      
 SELECT @sql = 'AND ss.pop_id = bv.populationpop_id '      
  END      
ELSE      
 SELECT @sql = 'AND ss.enc_id = bv.encounterenc_id '      
      
--Find the reporting date field      
SELECT @cutofftype = strCutoffResponse_Cd      
FROM survey_def       
WHERE survey_id = @survey      
      
IF @CutOffType = 0      
SET @ReportDate = 'datSampleCreate_dt'       
      
IF @CutOffType = 1      
SET @ReportDate = 'CONVERT(DATETIME,NULL)'      
      
IF @CutOffType = 2      
BEGIN    
 IF @Cleansed=1     
  SET @ReportDate = (SELECT 'dbo.FirstDayOfMonth('+strTable_nm + strField_nm+')' FROM survey_def sd, metadata_view md WHERE sd.survey_id = @survey       
     AND cutofftable_id = md.Table_id AND cutofffield_id = md.Field_id)      
 ELSE      
  SET @ReportDate = (SELECT strTable_nm + strField_nm FROM survey_def sd, metadata_view md WHERE sd.survey_id = @survey       
     AND cutofftable_id = md.Table_id AND cutofffield_id = md.Field_id)      
END    
    
--Get a list of distinct fields for the select statement      
SELECT DISTINCT strfield_nm AS short, CONVERT(VARCHAR(70),'') AS fldnm       
INTO #selclause      
FROM metatable mt, metastructure ms, metafield mf      
WHERE mt.table_id = ms.table_id      
AND ms.field_id = mf.field_id      
AND mt.study_id = @study      
AND ms.bitpostedfield_flg = 1      
      
IF @Cleansed=0    
 UPDATE #selclause      
 SET fldnm = mt.strtable_nm + mf.strfield_nm     
 FROM metatable mt, metastructure ms, metafield mf      
 WHERE mt.table_id = ms.table_id      
 AND ms.field_id = mf.field_id      
 AND mt.study_id = @study      
 AND #selclause.short = mf.strfield_nm      
 AND ms.bitpostedfield_flg = 1      
ELSE    
  
  BEGIN  
  
     UPDATE #selclause      
     SET fldnm=CASE WHEN mf.strField_nm='AGE' THEN 'CASE WHEN POPULATIONAge>90 THEN 90 ELSE POPULATIONAge END'  
      WHEN mf.strField_nm='Postal_Code' THEN 'LEFT(POPULATIONPostal_Code,3)'  
      WHEN mf.strFieldDataType='D' THEN 'dbo.FirstDayOfMonth('+mt.strtable_nm + mf.strfield_nm+')'     
         ELSE mt.strTable_nm+mf.strField_nm  
          END      
     FROM metatable mt, metastructure ms, metafield mf      
     WHERE mt.table_id = ms.table_id      
     AND ms.field_id = mf.field_id      
     AND mt.study_id = @study      
     AND #selclause.short = mf.strfield_nm      
     AND ms.bitpostedfield_flg = 1      
     AND ms.bitAllowUS=1  
  
     UPDATE #selclause      
     SET fldnm='0'     
     FROM metatable mt, metastructure ms, metafield mf      
     WHERE mt.table_id = ms.table_id      
     AND ms.field_id = mf.field_id     
     AND mt.study_id = @study      
     AND #selclause.short = mf.strfield_nm      
     AND ms.bitpostedfield_flg = 1      
     AND ms.bitAllowUS=0  
  
  END  
    
SET @sel = ''      
      
--build the select statement field list      
DECLARE curins CURSOR FOR       
 SELECT short, fldnm FROM #selclause ORDER BY short      
OPEN curins      
FETCH NEXT FROM curins INTO @short,@fld      
WHILE @@FETCH_STATUS = 0      
BEGIN      
 SELECT @sel = @sel + ' ,' + @fld + ' ' + @short       
 FETCH NEXT FROM curins INTO @short,@fld      
END      
CLOSE curins      
DEALLOCATE curins      
      
--put the statement together and then create the new view      
SET @strsql = 'CREATE VIEW S' + CONVERT(VARCHAR,@study) + '.BIG_VIEW_WEB AS ' +      
  ' SELECT null AS questionform_id, CONVERT(DATETIME,NULL) AS datUndeliverable, sp.samplepop_id, sp.sampleset_id, ss.sampleunit_id, ' +      
  @ReportDate + ' datReportDate, strUnitSelectType, 1.0 numWeight, ss.study_id, survey_id, datSampleCreate_dt, '+  
  'CONVERT(VARCHAR(30),'''+@MethodologyType+''') MethodologyType'+ @sel +    
  ' FROM selectedsample ss(NOLOCK), s' + CONVERT(VARCHAR,@study) + '.big_view bv(NOLOCK), samplepop sp(NOLOCK), sampleset s(NOLOCK) ' +       
  ' WHERE ss.sampleset_id in ( ' +CONVERT(VARCHAR,@sampleset)+') '+      
  ' AND ss.sampleset_id = s.sampleset_id ' +      
  ' AND ss.sampleset_id = sp.sampleset_id ' +      
  ' AND ss.pop_id = sp.pop_id ' + @sql       
      
EXEC(@STRSQL)      
      
DROP TABLE #selclause    


GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

-- Modified 7/28/04 SJS (skip pattern recode)
-- Modified 11/2/05 BGD Removed skip pattern enforcement.  Now in the SP_Extract_BubbleData procedure
-- Modified 11/16/05 BGD Calculate completeness for HCAHPS surveys
-- Modified 2/22/06 BGD Also enforce skip if question is left blank or has an invalid response.
-- Modified 3/7/06 BGD Calculate the number of days since first and current mailing.
-- Modified 3/16/06 BGD Add 10000 to answers that should have been skipped instead of recoding to -7
-- Modified 5/2/06 BGD Populating the strUnitSelectType column in the Extract_Web_QuestionForm table
-- Modified 5/22/06 BGD Bring over the langid from SentMailing to populate Big_Table_XXXX_X.LangID
ALTER PROCEDURE SP_Phase3_QuestionResult_For_Extract  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
--The Cmnt_QuestionResult_work table should be able to be removed.  
TRUNCATE TABLE Cmnt_QuestionResult_work  
TRUNCATE TABLE Extract_Web_QuestionForm  

--Get the records that are HCAHPS so we can compute completeness
SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete
INTO #a
FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd
WHERE e.Study_id IS NOT NULL
AND e.tiExtracted=0
AND datExtracted_dt IS NULL
AND e.QuestionForm_id=qf.Questionform_id
AND qf.Survey_id=sd.Survey_id
AND SurveyType_id=2
GROUP BY e.QuestionForm_id

CREATE INDEX tmpIndex ON #a (QuestionForm_id)

UPDATE #a SET Complete=dbo.HCAHPSCompleteness(QuestionForm_id)

UPDATE qf
SET bitComplete=Complete
FROM QuestionForm qf, #a t
WHERE t.QuestionForm_id=qf.QuestionForm_id

DROP TABLE #a
  
INSERT INTO Cmnt_QuestionResult_Work (QuestionForm_id, strLithoCode, SamplePop_id, Val,   
 SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, Survey_id)   
SELECT qf.QuestionForm_id, strLithoCode, qf.SamplePop_id, intResponseVal, SampleUnit_id,   
 QstnCore, datMailed, datResultsImported, Study_id, datGenerated, qf.Survey_id
FROM (SELECT DISTINCT QuestionForm_id, Study_id   
  FROM QuestionForm_Extract   
   WHERE Study_id IS NOT NULL   
   AND tiExtracted=0   
   AND datExtracted_dt IS NULL) qfe,   
 QuestionForm qf, SentMailing sm, QuestionResult qr   
WHERE qfe.QuestionForm_id=qf.QuestionForm_id   
AND qf.QuestionForm_id=qr.QuestionForm_id   
AND qf.SentMail_id=sm.SentMail_id   

INSERT INTO Extract_Web_QuestionForm (Study_id, QuestionForm_id, SamplePop_id, SampleUnit_id,   
 strLithoCode, Sampleset_id, datreturned, bitComplete, strUnitSelectType, LangID)  
SELECT sp.Study_id, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode,   
 sp.SampleSet_id, datResultsImported, qf.bitComplete, ss.strUnitSelectType, LangID
FROM (SELECT DISTINCT QuestionForm_id, Study_id
  FROM Cmnt_QuestionResult_work) qfe,
 QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss  
WHERE qfe.QuestionForm_id=qf.QuestionForm_id   
AND qf.SentMail_id=sm.SentMail_id   
AND qf.SamplePop_id=sp.SamplePop_id  
AND sp.Sampleset_id=ss.Sampleset_id  
AND sp.Pop_id=ss.Pop_id

-- Add code to determine days from first mailing as well as days from current mailing until the return
-- Get all of the maildates for the samplepops were are extracting
SELECT e.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed
INTO #Mail
FROM (SELECT SamplePop_id FROM Extract_Web_QuestionForm GROUP BY SamplePop_id) e, ScheduledMailing schm, SentMailing sm
WHERE e.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id=sm.SentMail_id

CREATE INDEX TempIndex ON #Mail (SamplePop_id, strLithoCode)

-- Update the work table with the actual number of days
UPDATE ewq
SET DaysFromFirstMailing=DATEDIFF(DAY,FirstMail,datReturned), DaysFromCurrentMailing=DATEDIFF(DAY,c.datMailed,datReturned)
FROM Extract_Web_QuestionForm ewq, 
 (SELECT SamplePop_id, MIN(datMailed) FirstMail FROM #Mail GROUP BY SamplePop_id) t, #Mail c
WHERE ewq.SamplePop_id=t.SamplePop_id
AND ewq.SamplePop_id=c.SamplePop_id
AND ewq.strLithoCode=c.strLithoCode

-- Make sure there are no negative days.
UPDATE Extract_Web_QuestionForm SET DaysFromFirstMailing=0 WHERE DaysFromFirstMailing<0
UPDATE Extract_Web_QuestionForm SET DaysFromCurrentMailing=0 WHERE DaysFromCurrentMailing<0

DROP TABLE #Mail

-- Modification 7/28/04 SJS -- Replaced code for skip pattern recode so that nested skip patterns are handled correctly  
SET NOCOUNT ON
DECLARE @work TABLE (QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)
DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT
SET @bitUpdate = 1
--Now to recode Skip pattern results
--If we have a valid answer, we will add 10000 to the responsevalue

-- Identify the first skip pattern that needs to be enforced for a questionform_id
INSERT INTO @work (QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id)
SELECT QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id  
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated  AND qr.QstnCore=si.QstnCore  AND qr.Val=si.intResponseVal
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id
WHERE sd.bitEnforceSkip <> 0
UNION
SELECT QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id  
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si 
ON qr.datGenerated=si.datGenerated  AND qr.QstnCore=si.QstnCore  AND qr.Val IN (-8,-9)
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id
WHERE sd.bitEnforceSkip <> 0

SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY questionform_id, sampleunit_id, skip_id  

-- Update skipped qstncores while we have work to process
WHILE (SELECT COUNT(*) FROM @work) > 0
	BEGIN

	--SkipPatternWork:
	IF @bitUpdate = 1
		UPDATE qr  
-- 		SET Val=-7  
		SET Val=VAL+10000
		FROM Cmnt_QuestionResult_Work qr, Skipqstns sq
		WHERE @qf = qr.QuestionForm_id
		AND @su = qr.SampleUnit_id
		AND @sk = Skip_id
		AND sq.QstnCore = qr.QstnCore  
		AND Val NOT IN (-9,-8)
                AND Val<9000  

		-- Identify the NEXT skip pattern that needs to be enforced for a questionform_id
		DELETE FROM @work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id
		SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY questionform_id, sampleunit_id, skip_id  

		-- Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop
		IF (SELECT COUNT(*) FROM  Cmnt_QuestionResult_Work qr
						INNER JOIN SkipIdentifier si
						ON qr.Questionform_id = @qf 
						AND qr.sampleunit_id = @su 
						AND qr.datGenerated=si.datGenerated  
						AND qr.QstnCore=si.QstnCore  
						AND (qr.Val = si.intResponseVal 
						OR qr.Val IN (-8,-9))
						AND si.skip_id = @sk 
			) > 0
			SET @bitUpdate = 1
		  ELSE 
			SET @bitUpdate = 0

	END

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_InsertMedicareNumber
 @MedicareNumber VARCHAR(20),
 @MedicareName varchar(45)
AS

IF EXISTS (SELECT * FROM MedicareLookup WHERE MedicareNumber=@MedicareNumber)
BEGIN
 RAISERROR ('MedicareNumber already exists.',18,1)
 RETURN
END

INSERT INTO MedicareLookup (MedicareNumber, MedicareName)
SELECT @MedicareNumber, @MedicareName

SELECT @MedicareNumber

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_DeleteMedicareNumber
 @MedicareNumber VARCHAR(20)
AS

IF EXISTS (SELECT * FROM SUFacility WHERE MedicareNumber=@MedicareNumber)
BEGIN
 RAISERROR ('MedicareNumber is associated with a facility.',18,1)
 RETURN
END

DELETE MedicareLookup WHERE MedicareNumber=@MedicareNumber

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_AllowDeleteMedicareNumber
 @MedicareNumber VARCHAR(20)
AS

IF EXISTS (SELECT * FROM SUFacility WHERE MedicareNumber=@MedicareNumber)
SELECT 0
ELSE
SELECT 1

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_UpdateMedicareName
 @MedicareNumber VARCHAR(20),
 @MedicareName VARCHAR(45)
AS

UPDATE MedicareLookup
SET MedicareName = @MedicareName
WHERE MedicareNumber = @MedicareNumber

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_ValidateSurvey
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
CREATE Table #Messages (  
     Message_id INT IDENTITY(1,1),   
     Error INT,   
     strMessage VARCHAR(200)  
)  
CREATE Table #Procs (  
     intOrder INT,   
     ProcedureName VARCHAR(100)  
)  
  
INSERT INTO #Procs   
SELECT SurveyValidationProcs_id, ProcedureName  
FROM SurveyValidationProcs  
  
DECLARE @Proc VARCHAR(100), @sql VARCHAR(8000)  
  
SELECT TOP 1 @Proc=ProcedureName  
FROM #Procs  
ORDER BY intOrder  
  
WHILE @@ROWCOUNT>0  
BEGIN  
  
SELECT @sql=' INSERT INTO #Messages EXEC dbo.'+@Proc+' '+LTRIM(STR(@SurveyId))
EXEC (@sql)  
  
DELETE #Procs   
WHERE ProcedureName=@Proc  
  
SELECT TOP 1 @Proc=ProcedureName  
FROM #Procs  
ORDER BY intOrder  
  
END  
  
--Now to log the messages  
INSERT INTO SurveyValidationResults (Survey_id, datRan, Error, strMessage)  
SELECT @SurveyId, GETDATE(), Error, strMessage  
FROM #Messages  
  
--Now to return the messages to the app.  
SELECT Error, strMessage  
FROM #Messages  
ORDER BY Error, Message_id  
  
DROP TABLE #Messages  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

DROP PROCEDURE SV_RunValidation

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It updates the   
contents of the survey_def table for the given survey_id  
  
Created:  02/27/2006 by Brian Dohmen  
Modified:    
	03/27/2006 by DC
		Added code to populate bitDynamic and householding type    
Modified:  
*/      
ALTER PROCEDURE [dbo].[QCL_UpdateSurvey]  
@Survey_id INT,  
@strSurvey_nm VARCHAR(10),  
@strSurvey_dsc VARCHAR(40),  
@intResponse_Recalc_Period INT,  
@intResurvey_Period INT,  
@ReSurveyMethod_id INT,  
@datSurvey_Start_dt DATETIME,  
@datSurvey_End_dt DATETIME,  
@SamplingAlgorithm INT,  
@bitEnforceSkip BIT,  
@strCutoffResponse_cd CHAR(1),  
@CutoffTable_id INT,  
@CutoffField_id INT,  
@strClientFacingName VARCHAR(42),  
@SurveyType_id INT,  
@SurveyTypeDef_id INT,
@datHCAHPSReportable DATETIME,  
@HouseHoldingType CHAR(1),
@IsValidated BIT,
@datValidated DATETIME,
@IsFormGenReleased BIT 
AS  
  
UPDATE Survey_def  
SET strSurvey_nm=@strSurvey_nm, strSurvey_dsc=@strSurvey_dsc,   
  intResponse_Recalc_Period=@intResponse_Recalc_Period, intResurvey_Period=@intResurvey_Period,   
  datSurvey_Start_dt=@datSurvey_Start_dt, datSurvey_End_dt=@datSurvey_End_dt,   
  SamplingAlgorithmID=@SamplingAlgorithm, bitEnforceSkip=@bitEnforceSkip,   
  strCutoffResponse_cd=@strCutoffResponse_cd, CutoffTable_id=@CutoffTable_id,   
  CutoffField_id=@CutoffField_id, strClientFacingName=@strClientFacingName,   
  SurveyType_id=@SurveyType_id, SurveyTypeDef_id=@SurveyTypeDef_id,  
  datHCAHPSReportable=@datHCAHPSReportable, ReSurveyMethod_id=@ReSurveyMethod_id,
  bitDynamic= case 
				When @SamplingAlgorithm=2 then 1 
				else 0 
			  end,
  strHouseholdingType=@HouseHoldingType,bitValidated_flg=@IsValidated,
  datValidated=@datValidated,bitFormGenRelease=@IsFormGenReleased 
WHERE Survey_id=@Survey_id  

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It returns a single    
record representing survey data for the ID specified    
    
Created:  10/17/2005 by Joe Camp    
    
Modified:    
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection    
02/16/2006 by DC - Added bitValidated_flg to survey selection    
02/23/2006 by DC - Added samplePlanId to survey selection    
02/24/2006 by DC - Added INTRESPONSE_RECALC_PERIOD to survey selection    
02/27/2006 by Brian Dohmen - Added additional columns to survey selection    
03/27/2006 by DC - Added strHouseholdingType to survey selection    
    
*/        
ALTER PROCEDURE [dbo].[QCL_SelectSurvey]      
@SurveyId INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      
DECLARE @intSamplePlan_id int    
SELECT @intSamplePlan_id = SamplePlan_id     
FROM dbo.SamplePlan    
WHERE Survey_id = @Surveyid    
    
SELECT Survey_id, strSurvey_nm, strSurvey_dsc, Study_id, 
 strCutoffResponse_cd, CutoffTable_id, CutoffField_id,    
 bitValidated_flg, datValidated, bitFormGenRelease, 
 @intSamplePlan_id as SamplePlan_id, INTRESPONSE_RECALC_PERIOD,  
/*Beginning of addition 2/27/2006*/  
 intResurvey_Period, datSurvey_Start_dt, datSurvey_End_dt, SamplingAlgorithmID,   
 bitEnforceSkip, strClientFacingName, SurveyType_id, SurveyTypeDef_id, datHCAHPSReportable,
 ReSurveyMethod_id, strHouseholdingType  
/*End of addition 2/27/2006*/  
FROM Survey_Def       
WHERE Survey_id=@SurveyId      
          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF     

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose:

This procedure is used to support the Qualisys Class Library.  It returns three
datasets.  The first is a list of all client names an employee has rights to.  The second
selects all of the study names and client_ids the employee has rights to.  The third selects
all of the survey names and study_ids the employee has rights to.


Created:  11/03/2005 by Joe Camp

Modified:
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection
02/16/2006 by DC - Added bitValidated_flg to survey selection. Added ADEmployee_id to Study.
02/23/2006 by DC - Added samplePlanId to survey selection
02/24/2006 by DC - Added INTRESPONSE_RECALC_PERIOD to survey selection
02/28/2006 by Brian Dohmen - Added Additional columns to survey selection
03/01/2006 by Brian Dohmen - Changed to left join to sampleplan table
03/17/2006 by Joe Camp - Changed to add ShowAllClients option
03/27/2006 by DC - Added strHouseholdingType to survey selection

*/
ALTER PROCEDURE [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]
    @UserName VARCHAR(42),
	@ShowAllClients BIT = 0
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

--Need a temp table to hold the ids the user has rights to
CREATE TABLE #EmpStudy (
     Client_id INT,
     Study_id INT,
     strStudy_nm VARCHAR(10),
     strStudy_dsc VARCHAR(255),
  ADEmployee_id int
)

--Populate the temp table with the studies they have rights to.
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id)
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc,s.ADEmployee_id
FROM Employee e, Study_Employee se, Study s
WHERE e.strNTLogin_nm=@UserName
AND e.Employee_id=se.Employee_id
AND se.Study_id=s.Study_id
AND s.datArchived IS NULL

CREATE INDEX tmpIndex ON #EmpStudy (Client_id)

--First recordset.  List of clients they have rights to.
IF @ShowAllClients = 1
BEGIN
	SELECT c.Client_id, c.strClient_nm
	FROM Client c
	ORDER BY c.strClient_nm
END
ELSE
BEGIN
	SELECT c.Client_id, c.strClient_nm
	FROM #EmpStudy t, Client c
	WHERE t.Client_id=c.Client_id
	GROUP BY c.Client_id, c.strClient_nm
	ORDER BY c.strClient_nm
END

--Second recordset.  List of studies they have rights to
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id
FROM #EmpStudy
ORDER BY strStudy_nm

--Third recordset.  List of surveys they have rights to
SELECT s.Survey_id, s.strSurvey_nm, s.strSurvey_dsc, s.Study_id, 
 s.strCutoffResponse_cd, s.CutoffTable_id, s.CutoffField_id,    
 s.bitValidated_flg, s.datValidated, s.bitFormGenRelease, 
 ISNULL(sp.SamplePlan_id,0) SamplePlan_id, s.INTRESPONSE_RECALC_PERIOD,  
/*Beginning of addition 2/27/2006*/  
 intResurvey_Period, datSurvey_Start_dt, datSurvey_End_dt, SamplingAlgorithmID,   
 bitEnforceSkip, strClientFacingName, SurveyType_id, SurveyTypeDef_id, datHCAHPSReportable,
 ReSurveyMethod_id, strHouseholdingType  
/*End of addition 2/27/2006*/  
FROM #EmpStudy t, Survey_def s LEFT JOIN SamplePlan sp
ON s.Survey_id=sp.Survey_id
WHERE t.Study_id=s.Study_id
ORDER BY s.strSurvey_nm

--Cleanup temp table
DROP TABLE #EmpStudy

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It returns a set of
records representing survey data for the ID specified

Created:  2/20/2006 by Dan Christensen

Modified:
03/27/2006 by DC - Added strHouseholdingType to survey selection

*/
ALTER  PROCEDURE QCL_SelectSurveysByStudyId
@StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT sd.Survey_id, strSurvey_nm, strSurvey_dsc, Study_id,
 strCutoffResponse_cd, CutoffTable_id, CutoffField_id,
 bitValidated_flg, datValidated, bitFormGenRelease,
 SamplePlan_id, INTRESPONSE_RECALC_PERIOD,
 intResurvey_Period, datSurvey_Start_dt, datSurvey_End_dt, SamplingAlgorithmID,
 bitEnforceSkip, strClientFacingName, SurveyType_id, SurveyTypeDef_id, datHCAHPSReportable,
 ReSurveyMethod_id, strHouseholdingType
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id=@StudyId  and
		sd.survey_id=sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE SV_ActiveMethodology
@Survey_id INT
AS

CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))

IF (SELECT COUNT(*) FROM MailingMethodology WHERE Survey_id=@Survey_id AND bitActiveMethodology=1)<>1
INSERT INTO #M (Error, strMessage)
SELECT 1 Error,'There is not an active methodology.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0 Error,'There is ONE active methodology.'

SELECT * FROM #M

DROP TABLE #M

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

ALTER PROCEDURE QCL_DeleteClient
@ClientId INT
AS

IF EXISTS (SELECT * FROM Study WHERE Client_id=@ClientId)
BEGIN
	RAISERROR ('The client cannot be deleted because it contains studies.', 18, 1)
END
ELSE
BEGIN
	DELETE ClientSUFacilityLookup
	WHERE Client_id=@ClientId

	DELETE Client
	WHERE Client_id=@ClientId
END

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It will add new 
SampleUnits to the sampleplan.  It will return the sampleunit_id
    
Created:  2/28/2006 by Brian Dohmen
    
Modified:    
		3/14/2006 by DC Removed unneeded columns
*/        
ALTER PROCEDURE [dbo].[QCL_InsertSampleUnit]
@CriteriaStmt_id INT,
@SamplePlan_id INT,
@ParentSampleUnit_id INT,
@strSampleUnit_nm VARCHAR(42),
@intTargetReturn INT,
--@intMinConfidence INT,
--@intMaxMargin INT,
@numInitResponseRate INT,
--@numResponseRate INT,
--@Reporting_Hierarchy_id INT,
@SUFacility_id INT,
--@SUServices VARCHAR(300),
@bitSuppress BIT,
@bitHCAHPS BIT,
--@MedicareNumber VARCHAR(20),
--@AHANumber INT,
--@FacilityState VARCHAR(42),
@Priority INT,
@SampleSelectionType_id INT
AS

DECLARE @su INT

INSERT INTO SampleUnit (CriteriaStmt_id, SamplePlan_id, ParentSampleUnit_id, strSampleUnit_nm,
  intTargetReturn, /*intMinConfidence, intMaxMargin,*/ numInitResponseRate, /*numResponseRate, 
  Reporting_Hierarchy_id,*/ SUFacility_id, /*SUServices,*/ bitSuppress, bitHCAHPS, /*MedicareNumber,
  AHANumber, FacilityState,*/ Priority, SampleSelectionType_id)
SELECT @CriteriaStmt_id, @SamplePlan_id, @ParentSampleUnit_id, @strSampleUnit_nm,
  @intTargetReturn, /*@intMinConfidence, @intMaxMargin, */@numInitResponseRate, /*@numResponseRate, 
  @Reporting_Hierarchy_id,*/ @SUFacility_id, /*@SUServices, */@bitSuppress, @bitHCAHPS, /*@MedicareNumber,
  @AHANumber, @FacilityState,*/ @Priority, @SampleSelectionType_id

SELECT @su=SCOPE_IDENTITY()

WHILE @ParentSampleUnit_id IS NOT NULL
BEGIN

INSERT INTO SampleUnitTreeIndex (SampleUnit_id, AncestorUnit_id)
SELECT @su, @ParentSampleUnit_id

SELECT @ParentSampleUnit_id=ParentSampleUnit_id
FROM SampleUnit
WHERE SampleUnit_id=@ParentSampleUnit_id

END

SELECT @su SampleUnit_id

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It will update 
SampleUnits.
    
Created:  2/28/2006 by Brian Dohmen
    
Modified:    
		3/14/2006 by DC Removed unneeded columns

*/        
ALTER PROCEDURE [dbo].[QCL_UpdateSampleUnit]
@SampleUnit_id INT,
@CriteriaStmt_id INT,
@SamplePlan_id INT,
@ParentSampleUnit_id INT,
@strSampleUnit_nm VARCHAR(42),
@intTargetReturn INT,
@numInitResponseRate INT,
@SUFacility_id INT,
@bitSuppress BIT,
@bitHCAHPS BIT,
@Priority INT,
@SampleSelectionType_id INT
AS

UPDATE SampleUnit 
SET CriteriaStmt_id=@CriteriaStmt_id, SamplePlan_id=@SamplePlan_id, 
  ParentSampleUnit_id=@ParentSampleUnit_id, strSampleUnit_nm=@strSampleUnit_nm,
  intTargetReturn=@intTargetReturn, numInitResponseRate=@numInitResponseRate, 
  SUFacility_id=@SUFacility_id, bitSuppress=@bitSuppress, 
  bitHCAHPS=@bitHCAHPS, Priority=@Priority, SampleSelectionType_id=@SampleSelectionType_id
WHERE SampleUnit_id=@SampleUnit_id

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It returns a single
record representing sampleUnit data for the ID specified

Created:  2/23/2006 by DC

Modified:
03/01/2006 BY Brian Dohmen  Added in the rest of the sampleunit columns
*/ 

ALTER PROCEDURE QCL_SelectSampleUnit
@SampleUnitId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority,   
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,  
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id,   
 su.SUServices, su.bitSuppress, su.bitHCAHPS, 
 su.SampleSelectionType_id, su.samplePlan_id  
FROM SampleUnit su, SamplePlan sp 
WHERE su.SamplePlan_id = sp.SamplePlan_id  
AND su.SampleUnit_id=@SampleUnitId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE QCL_SelectSampleUnitsByParentId
@SampleUnitId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, su.bitHCAHPS, 
 su.SampleSelectionType_id, su.samplePlan_id
FROM SampleUnit su, SamplePlan sp 
WHERE su.SamplePlan_id = sp.SamplePlan_id
 AND su.ParentSampleUnit_id=@SampleUnitId 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.It returns a single
record for each SampleUnit for the survey_id specified

Created:  2/23/2006 by DC

Modified:
03/01/2006 BY Brian DohmenAdded in the rest of the sampleunit columns

*/ 
ALTER PROCEDURE QCL_SelectSampleUnitsBySurveyId
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, su.bitHCAHPS,
 su.SampleSelectionType_id, su.samplePlan_id
FROM SampleUnit su, SamplePlan sp
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = @SurveyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

ALTER PROCEDURE QCL_UpdateFacility
@Facility_id INT,
@AHA_id INT,
@strFacility_nm VARCHAR(100),
@City VARCHAR(42),
@State VARCHAR(2),
@Country VARCHAR(42),
@Region_id INT,
@AdmitNumber INT,
@BedSize INT,
@bitPeds BIT,
@bitTeaching BIT,
@bitTrauma BIT,
@bitReligious BIT,
@bitGovernment BIT,
@bitRural BIT,
@bitForProfit BIT,
@bitRehab BIT,
@bitCancerCenter BIT,
@bitPicker BIT,
@bitFreeStanding BIT,
@MedicareNumber VARCHAR(20)
AS

UPDATE SUFacility
 SET AHA_id=@AHA_id,
 strFacility_nm=@strFacility_nm,
 City=@City,
 State=@State,
 Country=@Country,
 Region_id=@Region_id,
 AdmitNumber=@AdmitNumber,
 BedSize=@BedSize,
 bitPeds=@bitPeds,
 bitTeaching=@bitTeaching,
 bitTrauma=@bitTrauma,
 bitReligious=@bitReligious,
 bitGovernment=@bitGovernment,
 bitRural=@bitRural,
 bitForProfit=@bitForProfit,
 bitRehab=@bitRehab,
 bitCancerCenter=@bitCancerCenter,
 bitPicker=@bitPicker,
 bitFreeStanding=@bitFreeStanding,
 MedicareNumber=@MedicareNumber
WHERE SUFacility_id=@Facility_id

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

ALTER PROCEDURE [dbo].[QCL_DeleteFacility]
@FacilityId INT
AS


IF EXISTS (SELECT * FROM SampleUnit WHERE SUFacility_id = @FacilityId)
BEGIN
    RAISERROR ('The facility cannot be deleted because there are still sample units associated with it.', 18, 1)
END
ELSE
BEGIN
    --Delete any client mappings
    DELETE ClientSUFacilityLookup
    WHERE SUFacility_id = @FacilityId

    --Delete the facility
    DELETE SUFacility
    WHERE SUFacility_id = @FacilityId
END

GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
Business Purpose: 
This procedure is used to calculate the number of eligible discharges.  It
is used IN the header record of the CMS export

Created:  06/22/2006 by DC

Modified:

*/  
CREATE PROCEDURE [dbo].[Export_SampleunitAvailableCount]
	@Sampleunit_id INT, 
    @startDate DATETIME, 
    @EndDate DATETIME,
	@EncounterDateField varchar(100) = Null
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Study_id INT, @Survey_id INT,
		@Sel VARCHAR(8000), @SampleUnit INT, @strDateWHERE VARCHAR(150),
		@Where1 VARCHAR(8000), @Where2 VARCHAR(8000), @Where3 VARCHAR(8000),
		@Where4 VARCHAR(8000), @Where5 VARCHAR(8000), @Where6 VARCHAR(8000),
		@Where7 VARCHAR(8000), @Where8 VARCHAR(8000), @Where9 VARCHAR(8000),
		@Where10 VARCHAR(8000),@fields varchar(5000), @DQCriter varchar(8000)

SELECT  @Where1='', @Where2='', @Where3='',
		@Where4='', @Where5='', @Where6='',
		@Where7='', @Where8='', @Where9='',
		@Where10=''

SELECT @study_id=sd.study_id,
	@survey_id=sd.survey_id
FROM sampleunit su, sampleplan sp, survey_def sd
WHERE su.sampleunit_id=@sampleunit_id 
	and su.sampleplan_id=sp.sampleplan_id
	and sp.survey_id=sd.survey_id
	
--get Datefield
CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))
IF @EncounterDateField IS NULL
BEGIN
	SET @Sel = 'INSERT INTO #DATEFIELD' +
	   ' SELECT mt.strTABLE_nm + mf.strField_nm' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTABLE  mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.TABLE_id = mt.TABLE_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND ms.TABLE_id=sd.cutoffTABLE_id' +
	   ' AND ms.field_id=sd.cutofffield_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey_id)
END
ELSE 
BEGIN
	SET @Sel = 'INSERT INTO #DATEFIELD' +
	   ' SELECT mt.strTABLE_nm + mf.strField_nm' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTABLE  mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.TABLE_id = mt.TABLE_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND ms.TABLE_id=sd.cutoffTABLE_id' +
	   ' AND ms.field_id=sd.cutofffield_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey_id) +
	   ' AND mf.strField_nm = ''' + @EncounterDateField + ''''
END
Execute (@Sel)

SELECT @EncounterDateField=DATEFIELD
FROM #DATEFIELD


DECLARE @FROMDate VARCHAR(10), @ToDate VARCHAR(10)

SET @FROMDate=CONVERT(VARCHAR,@startdate,101)
SET @toDate=CONVERT(VARCHAR,@EndDate,101)

SET @strDateWhere=''

--Identify the encounter date field AND daterange
IF @EncounterDateField IS NULL 
BEGIN
	RAISERROR ('The cutoff date is not an encounter data field.  The eligible count cannot be calculated.', 16, 1)                  
	RETURN
END

IF (@FROMDate is null or @FROMDate='')
BEGIN
	RAISERROR ('Null dates are not allowed.', 16, 1)                  
	RETURN
END

--get the list of Fields needed for evaluating DQ rules
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

INSERT INTO @tbl 
SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
FROM CriteriaStmt cs, CriteriaClause cc, MetaData_View m, BusinessRule b
WHERE cs.Study_id=@Study_id
AND cs.CriteriaStmt_id=cc.CriteriaStmt_id
AND cc.Table_id=m.Table_id
AND cc.Field_id=m.Field_id
AND cs.CriteriaStmt_id=b.CriteriaStmt_id
AND b.survey_id=@survey_id
AND BusRule_cd='Q'

IF @@rowcount=0 
	INSERT INTO @tbl Values ('PopulationPop_id', 'I',4,1)

CREATE TABLE #BVUK (DummyField INT)

SET @sel='ALTER TABLE #BVUK ADD ,'

SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY Field_id
Set @sel=replace(@sel,',,','')

EXEC (@Sel)

ALTER TABLE #BVUK 
	DROP COLUMN DummyField

SELECT @strDateWhere=' AND ('+@EncounterDateField+' BETWEEN '''+@FROMDate+''' AND '''+CONVERT(VARCHAR,@ToDate)+' 23:59:59'')'

CREATE TABLE  #Criters (Survey_id INT, Sampleunit_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20), bitKeep bit default 0)        

INSERT INTO #Criters (Survey_id, Sampleunit_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, su.Sampleunit_id, c.CriteriaStmt_id, strCriteriaString, 'C'
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id
AND c.Study_id=@Study_id
AND su.Sampleplan_id=sp.Sampleplan_id
AND Survey_id=@Survey_id

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd='Q'
AND Survey_id=@Survey_id

DECLARE @Tables TABLE (Tablename VARCHAR(40))

INSERT INTO @Tables
SELECT DISTINCT strtable_nm
FROM MetaTABLE 
WHERE Study_id=@Study_id

SELECT TOP 1 @sel=Tablename FROM @Tables
WHILE @@ROWCOUNT>0
BEGIN
	
	DELETE @Tables WHERE Tablename=@sel
	
	SET @sel='UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'''+@sel+'.'','''+@sel+''')'
	EXEC (@Sel)
	
	SELECT TOP 1 @sel=Tablename FROM @Tables

END

UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'"','''')

DECLARE @Criteria VARCHAR(7900)

SET @Criteria=''

--loop the actual Criteria Stmts
SELECT @SampleUnit=@SampleUnit_id

WHILE @@ROWCOUNT>0
BEGIN

	UPDATE #Criters
	SET bitKeep=1
	WHERE SampleUnit_id=@SampleUnit
	
	SELECT @SampleUnit=parentsampleunit_id
	FROM SampleUnit
	WHERE sampleunit_id=@SampleUnit
END

SELECT *
INTO #UnitCriters
FROM #CRITERS
WHERE bitKeep=1
	AND BusRule_cd='C'

SELECT *
INTO #DQCriters
FROM #CRITERS
WHERE BusRule_cd='Q'

--Concatenating criterias could produce a string over 8000 chars, so we must place each IN 
--its own variable.  We assume that 10 variables will be enough

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where1=strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE strCriteriaStmt=@Where1
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where2=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where2
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where3=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where3
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where4=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where4
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where5=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where5
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where6=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where6
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where7=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where7
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where8=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where8
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where9=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where9
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where10=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where10
END

SET @fields=''

--build the SELECT list
SELECT @fields=@fields+','+Fieldname
FROM @tbl
ORDER BY Field_id

SET @fields=substring(@fields,2,len(@fields)-1)

SET @sel='INSERT INTO #BVUK('+@fields+')
	SELECT '+@fields+'
	FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View (NOLOCK)
	WHERE'

--QUERY BIG VIEW
--PRINT (@sel +' ('+@Where1+@Where2+@Where3+@Where4+@Where5+@Where6+@Where7+@Where8+@Where9+@Where10+')' + @strDateWhere)
EXEC (@sel +' ('+@Where1+@Where2+@Where3+@Where4+@Where5+@Where6+@Where7+@Where8+@Where9+@Where10+')' + @strDateWhere)

--Loop through DQ Rules

SELECT TOP 1 @DQCriter=strCriteriaStmt
FROM #DQCriters

WHILE @@rowcount>0
BEGIN
	SET @SEL='DELETE FROM #BVUK
			  WHERE ' + @DQCriter 

	--PRINT @SEL
	EXEC (@SEL)

	DELETE
	FROM #DQCriters
	WHERE strCriteriaStmt=@DQCriter

	SELECT TOP 1 @DQCriter=strCriteriaStmt
	FROM #DQCriters
END

SELECT COUNT(*)
FROM #BVUK

DROP TABLE #CRITERS
DROP TABLE #UnitCriters
DROP TABLE #DATEFIELD
DROP TABLE #DQCriters



GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/****** Object:  Stored Procedure dbo.QCL_LogDisposition Script Date: 8/22/06 ******/
/************************************************************************************************/
/*            											*/
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It inserts  */
/*            into the DispositionLog, and is the central procedure for that function, but is	*/
/* 		is called from many other diposition procedures.				*/
/* Date Created:  08/22/2006           								*/
/*            											*/
/* Created by:  Steve Spicka									*/
/*            											*/
/************************************************************************************************/


ALTER PROCEDURE QCL_LogDisposition 
     @SentMailID INT, 
     @SamplePopID INT, 
     @DispositionID INT, 
     @ReceiptTypeID INT, 
     @UserName VARCHAR(42),
     @datLogged DATETIME = NULL
AS

IF @datLogged IS NULL
SET @datLogged = GETDATE()

INSERT INTO DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy)    
SELECT @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @datLogged, @UserName    

UPDATE DispositionLog 
	SET DaysFromFirst   = dbo.fn_DispDaysFromFirst(@SentMailID,@datLogged,@DispositionID),
	    DaysFromCurrent = dbo.fn_DispDaysFromCurrent(@SentMailID,@datLogged,@DispositionID)
	WHERE SentMail_id= @SentMailID AND Disposition_id = @DispositionID AND datLogged = @datLogged
GO
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Stored Procedure dbo.QCL_DeleteFutureMailings       Script Date: 10/11/05 ******/
/************************************************************************************************/
/*            											*/
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It deletes  */
/*            future mailings for the given litho.  						*/
/* Date Created:  10/11/2005           								*/
/*            											*/
/* Created by:  Brian Dohmen           								*/
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*            											*/
/************************************************************************************************/
ALTER PROCEDURE QCL_DeleteFutureMailings   
 @Litho VARCHAR(20),   
 @DispositionID INT,  
 @ReceiptTypeID INT,  
 @UserName VARCHAR(42)    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
DECLARE @SentMailID INT, @SamplePopID INT 
    
--Need to get the samplepop_id from the litho.  This is used to find ungenerated steps.
SELECT @SamplePopID=SamplePop_id    
FROM SentMailing sm, ScheduledMailing schm    
WHERE sm.strLithoCode=@Litho    
AND sm.SentMail_id=schm.SentMail_id    
    
BEGIN TRANSACTION    

--delete any ungenerated steps for the samplepop_id    
DELETE ScheduledMailing    
WHERE SamplePop_id=@SamplePopID    
AND SentMail_id IS NULL    
    
IF @@ERROR<>0    
BEGIN    
 ROLLBACK TRANSACTION    
 SELECT -1    
 RETURN    
END    
    
--Log it    
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)    
SELECT @Litho,@DispositionID,GETDATE(),'Deleted Future Mailings'    
    
IF @@ERROR<>0    
BEGIN    
 ROLLBACK TRANSACTION    
 SELECT -1    
 RETURN    
END    
  
--Need to log the disposition for reporting purposes  
SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName
  
IF @@ERROR<>0        
BEGIN        
 ROLLBACK TRAN        
 SELECT -1        
RETURN        
END        
    
COMMIT TRANSACTION    
SELECT 1    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF    

GO
--------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/********************************************************************************************************/  
/*                       										*/  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It adds the         */ 
/*   		     recipient to the TOCL table.							*/
/*                       										*/  
/* Date Created:  10/17/2005                  								*/  
/*                       										*/  
/* Created by:  Joe Camp                   								*/  
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table  		*/
/*                       										*/  
/********************************************************************************************************/  
ALTER PROCEDURE QCL_TakeOffCallList 
 @Litho VARCHAR(20), 
 @DispositionID INT,  
 @ReceiptTypeID INT,
 @UserName VARCHAR(42)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRANSACTION  
  
--Add to TOCL
INSERT INTO TOCL (Study_id, Pop_id, datTOCL_dat)  
SELECT Study_id, Pop_id, GETDATE()  
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp  
WHERE sm.strLithoCode=@Litho  
AND sm.SentMail_id=schm.SentMail_id  
AND schm.SamplePop_id=sp.SamplePop_id  
  
IF @@ERROR<>0  
BEGIN  
 ROLLBACK TRANSACTION  
 SELECT -1  
 RETURN  
END  
  
--Log it  
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)  
SELECT @Litho,@DispositionID,GETDATE(),'Added to TOCL'  
  
IF @@ERROR<>0  
BEGIN  
 ROLLBACK TRANSACTION  
 SELECT -1  
 RETURN  
END  

--Log it to dispositionlog for reporting purposes

SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName

IF @@ERROR<>0      
BEGIN      
 ROLLBACK TRAN      
 SELECT -1      
RETURN      
END      
  
COMMIT TRANSACTION  
SELECT 1  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  

GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/****** Object:  Stored Procedure dbo.QCL_ChangeRespondentAddress    Script Date: 10/11/05 ******/  
/************************************************************************************************/  
/*                       */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It updates  */  
/*            the address for the given litho.        */  
/* Date Created:  10/11/2005                   */  
/*                       */  
/* Created by:  Brian Dohmen                   */  
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*                       */  
/************************************************************************************************/  
ALTER PROCEDURE dbo.QCL_ChangeRespondentAddress         
 @Litho VARCHAR(20),         
 @DispositionID INT,         
 @Addr VARCHAR(42),         
 @Addr2 VARCHAR(42),         
 @City VARCHAR(42),          
 @Del_Pt CHAR(3),         
 @ST CHAR(2),         
 @Zip4 CHAR(4),         
 @ZIP5 CHAR(5),         
 @AddrStat VARCHAR(42),         
 @AddrErr VARCHAR(42),        
 @CountryID INT,        
 @Province VARCHAR(42),        
 @PostalCode VARCHAR(42),    
 @ReceiptTypeID INT,    
 @UserName VARCHAR(42)    
AS          
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
SET NOCOUNT ON          

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRAN  
  
INSERT INTO tbl_QCL_AddressChange (Litho,Disposition_id,Addr,Addr2,City,Del_Pt,ST,Zip4,ZIP5,  
AddrStat,AddrErr,CountryID,Province,PostalCode,ReceiptTypeID,UserName)  
SELECT @Litho, @DispositionID, @Addr, @Addr2, @City, @Del_Pt, @ST, @Zip4, @Zip5,   
@AddrStat, @AddrErr, @CountryID, @Province, @PostalCode, @ReceiptTypeID, @UserName  
  
/*          
DECLARE @sql VARCHAR(8000), @Study VARCHAR(10), @Pop VARCHAR(20)          
          
--Need to get the study_id and the pop_id for the given litho  
SELECT @Study=LTRIM(STR(Study_id)), @Pop=LTRIM(STR(Pop_id))          
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp          
WHERE sm.strLithoCode=@Litho          
AND sm.SentMail_id=schm.SentMail_id          
AND schm.SamplePop_id=sp.SamplePop_id          
          
BEGIN TRAN          
  
--Now to update the address fields in the population table  
IF @CountryID=1        
BEGIN        
 --Check to see if the Addr2 field is valid for the study.  If so, it becomes part of the update statement.  
 IF EXISTS(SELECT * FROM MetaData_View WHERE Study_id=@Study AND strTable_nm='Population' AND strField_nm='Addr2')        
  SELECT @sql='UPDATE S'+@Study+'.Population           
   SET Addr='''+@Addr+''',           
    Addr2='''+@Addr2+''',          
    City='''+@City+''',          
    Del_Pt='''+@Del_Pt+''',          
    ST='''+@ST+''',          
    Zip4='''+@Zip4+''',          
    Zip5='''+@Zip5+''',          
    AddrStat='''+@AddrStat+''',          
    AddrErr='''+@AddrErr+'''          
   WHERE Pop_id='+@Pop          
 ELSE        
  --No Addr2 field  
  SELECT @sql='UPDATE S'+@Study+'.Population           
   SET Addr='''+LEFT(@Addr+' '+@Addr2,42)+''',           
    City='''+@City+''',          
    Del_Pt='''+@Del_Pt+''',          
    ST='''+@ST+''',          
    Zip4='''+@Zip4+''',          
    Zip5='''+@Zip5+''',          
    AddrStat='''+@AddrStat+''',          
    AddrErr='''+@AddrErr+'''          
   WHERE Pop_id='+@Pop          
         
 EXEC (@sql)          
        
 IF @@ERROR<>0          
 BEGIN          
  ROLLBACK TRAN          
  SELECT -1          
  RETURN          
 END         
        
 --Log it          
 INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)          
 SELECT @Litho,@Disposition_id,GETDATE(),'Updated Address: '+          
  ISNULL(@Addr,'')+' '+ISNULL(@Addr2,'')+' '+ISNULL(@City,'')+' '+          
  ISNULL(@ST,'')+' '+ISNULL(@Zip5,'')+' '+ISNULL(@Zip4,'')+' '+          
  ISNULL(@Del_pt,'')          
           
 IF @@ERROR<>0          
 BEGIN          
  ROLLBACK TRAN          
  SELECT -1          
  RETURN          
 END          
        
END        
ELSE        
--If Canadian, then this section will run.  It updates Province and Postal_Code instead of State and Zip.  
BEGIN   
 --Check to see if the Addr2 field is valid for the study.  If so, it becomes part of the update statement.  
 IF EXISTS(SELECT * FROM MetaData_View WHERE Study_id=@Study AND strTable_nm='Population' AND strField_nm='Addr2')        
  SELECT @sql='UPDATE S'+@Study+'.Population           
   SET Addr='''+@Addr+''',           
    Addr2='''+@Addr2+''',          
City='''+@City+''',          
    Province='''+@Province+''',          
    Postal_Code='''+@PostalCode+''',        
    AddrStat='''+@AddrStat+''',          
    AddrErr='''+@AddrErr+'''          
   WHERE Pop_id='+@Pop          
 ELSE        
  --No Addr2 field  
  SELECT @sql='UPDATE S'+@Study+'.Population           
   SET Addr='''+LEFT(@Addr+' '+@Addr2,42)+''',           
    City='''+@City+''',          
    Province='''+@Province+''',          
    Postal_Code='''+@PostalCode+''',        
    AddrStat='''+@AddrStat+''',          
    AddrErr='''+@AddrErr+'''          
   WHERE Pop_id='+@Pop          
         
 EXEC (@sql)          
        
 IF @@ERROR<>0          
 BEGIN          
  ROLLBACK TRAN          
  SELECT -1          
  RETURN          
 END         
 --Log it          
 INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)          
 SELECT @Litho,@Disposition_id,GETDATE(),'Updated Address: '+          
  ISNULL(@Addr,'')+' '+ISNULL(@Addr2,'')+' '+ISNULL(@City,'')+' '+          
  ISNULL(@Province,'')+' '+ISNULL(@PostalCode,'')          
           
 IF @@ERROR<>0          
 BEGIN          
  ROLLBACK TRAN          
  SELECT -1          
  RETURN          
 END          
        
END        
*/  
IF @@ERROR<>0          
BEGIN          
 ROLLBACK TRAN          
 SELECT -1          
RETURN          
END          
  
--Need to log the disposition for reporting purposes    
SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName

IF @@ERROR<>0          
BEGIN          
 ROLLBACK TRAN          
 SELECT -1          
RETURN          
END          
          
COMMIT TRAN          
SELECT 1          
          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF  
  

GO                                                                                                                                                                                                                                                  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Stored Procedure dbo.QCL_ReGenerateMailing       Script Date: 10/11/05 ******/  
/************************************************************************************************/  
/*                       */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It logs     */  
/*            the contact request to the dispositionlog table.  The actual email is sent by */  
/*            the application.         */  
/* Date Created:  10/11/2005                   */  
/*                       */  
/* Created by:  Brian Dohmen                   */  
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*                       */  
/************************************************************************************************/  
ALTER PROCEDURE QCL_ReGenerateMailing  
 @Litho VARCHAR(20),   
 @DispositionID INT,   
 @LangID INT,    
 @ReceiptTypeID INT,  
 @UserName VARCHAR(42)    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
DECLARE @sql VARCHAR(8000), @SentMailID INT, @SamplePopID INT, @PopID INT, @StudyID INT
 
--Get the samplepop_id, pop_id, and study_id for the given litho.  
SELECT @SamplePopID=sp.SamplePop_id, @PopID=Pop_id, @StudyID=Study_id    
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp    
WHERE sm.strLithoCode=@Litho    
AND sm.SentMail_id=schm.SentMail_id    
AND schm.SamplePop_id=sp.SamplePop_id    
    
--Change the langid as necessary    
IF @LangID IS NOT NULL    
BEGIN    
    
INSERT INTO tbl_QCL_LangIDChange (Study_id, Pop_id, LangID)
SELECT @StudyID, @PopID, @LangID
--  SELECT @sql='UPDATE S'+@Study_id+'.Population SET LangID='+LTRIM(STR(@LangID))+' WHERE Pop_id='+@Pop_id    
--  EXEC (@sql)    
    
END    
    
--Check to see if they have a regenerate scheduled to generate.  If they do, exit the proc.    
IF EXISTS (SELECT * FROM ScheduledMailing WHERE SamplePop_id=@SamplePopID AND SentMail_id IS NULL AND OverRideItem_id IS NOT NULL)    
BEGIN    
 SELECT 1    
 RETURN    
END    
    
BEGIN TRANSACTION     
    
--Now to schedule another generation.    
DECLARE @ORI INT    
    
--Add to OverRideItem  
INSERT INTO OverRideItem (intIntervalDays)    
SELECT 0    
  
--Capture the OverRideItem_id so we can insert it into ScheduledMailing    
SELECT @ORI=SCOPE_IDENTITY()    
    
IF @@ERROR<>0     
BEGIN    
 ROLLBACK TRANSACTION    
 SELECT -1    
END    
    
--Schedule the regeneration  
INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, Methodology_id, datGenerate)    
SELECT MIN(ms.MailingStep_id), @SamplePopID, @ORI, schm.Methodology_id, GETDATE()    
FROM ScheduledMailing schm, MailingStep ms    
WHERE schm.SamplePop_id=@SamplePopID    
AND schm.Methodology_id=ms.Methodology_id    
AND ms.bitFirstSurvey=1    
GROUP BY schm.Methodology_id    
    
IF @@ERROR<>0     
BEGIN    
 ROLLBACK TRANSACTION    
 SELECT -1    
END    
    
--Log it    
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)    
SELECT @Litho,@DispositionID,GETDATE(),'Regenerate Form'    
    
IF @@ERROR<>0        
BEGIN        
 ROLLBACK TRAN        
 SELECT -1        
RETURN        
END        
  
--Need to log the disposition for reporting purposes    
SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName 
  
IF @@ERROR<>0        
BEGIN        
 ROLLBACK TRAN        
 SELECT -1        
RETURN        
END        
  
COMMIT TRANSACTION    
SELECT 1    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF    

GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Stored Procedure dbo.QCL_LogContactRequest       Script Date: 10/11/05 ******/
/************************************************************************************************/
/*            											*/
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It logs     */
/*            the contact request to the dispositionlog table.  The actual email is sent by	*/
/*            the application.									*/
/* Date Created:  10/11/2005           								*/
/*            											*/
/* Created by:  Brian Dohmen           								*/
/* Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table   */
/*            											*/
/************************************************************************************************/
ALTER PROCEDURE QCL_LogContactRequest 
 @Litho VARCHAR(20), 
 @DispositionID INT, 
 @Comment VARCHAR(256),
 @ReceiptTypeID INT,
 @UserName VARCHAR(42)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

DECLARE @SentMailID INT, @SamplePopID INT
  
BEGIN TRAN

--Log it  
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)  
SELECT @Litho,@DispositionID,GETDATE(),'Contact: '+@Comment  

IF @@ERROR<>0      
BEGIN      
 ROLLBACK TRAN      
 SELECT -1      
RETURN      
END      

--Need to log the disposition for reporting purposes  
SELECT @SentMailID=Sentmail_id, @SamplepopID=samplepop_id 
FROM (	SELECT sm.SentMail_id, schm.SamplePop_id
	FROM SentMailing sm, ScheduledMailing schm
	WHERE strLithoCode=@Litho 
	AND sm.SentMail_id=schm.SentMail_id
	) t

EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName

IF @@ERROR<>0      
BEGIN      
 ROLLBACK TRAN      
 SELECT -1      
RETURN      
END      
  
COMMIT TRAN
SELECT 1  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  

GO


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It returns a single
record for each encounter that is eligible to be sampled.  It also does checks of 
DQ rules and other business rules.

Created:  02/20/2006 by DC

Modified:
		07/28/2006 by DC
		Fixed bug when encounter table did not exist and added code to skip TOCL check if HCAHPS

*/  
ALTER PROCEDURE [dbo].[QCL_SelectEncounterUnitEligibility]
	@Survey_id INT, 
	@Study_id INT,
	@DataSet VARCHAR(2000),
    @startDate DATETIME=NULL, 
    @EndDate DATETIME=NULL,
	@seed INT,
	@ReSurvey_Period INT,
	@EncounterDateField VARCHAR(42),
	@encTableExists BIT,
	@sampleSet_id INT,
	@samplingMethod INT,
	@resurveyMethod_id INT=1,
	@samplingAlgorithmId as INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @FromDate varchar(10), @ToDate varchar(10)

SET @fromDate=CONVERT(VARCHAR,@startdate,101)
SET @toDate=CONVERT(VARCHAR,@EndDate,101)

DECLARE @Sel VARCHAR(8000), @sql VARCHAR(8000), @DQ_id INT, @newbornRule varchar(7900)
DECLARE @SampleUnit INT, @ParentSampleUnit INT, @strDateWhere VARCHAR(150)
DECLARE @bitDoTOCL bit

SET @strDateWhere=''

CREATE TABLE #DataSets (DataSet_id INT)
SET @Sel='INSERT INTO #DataSets
	SELECT DataSet_id FROM Data_Set WHERE DataSet_id IN ('+@DataSet+')'
EXEC (@Sel)

--get the list of Fields needed
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

--Get HouseHolding Variables if needed
DECLARE @HouseHoldFieldSelectSyntax VARCHAR(1000), @HouseHoldFieldSelectBigViewSyntax VARCHAR(1000),
	@HouseHoldFieldCreateTableSyntax VARCHAR(1000), @HouseHoldJoinSyntax VARCHAR(1000),
	@HouseHoldingType CHAR(1)

SELECT @HouseHoldFieldSelectSyntax='', @HouseHoldFieldSelectBigViewSyntax='',
	@HouseHoldFieldCreateTableSyntax='', @HouseHoldJoinSyntax='' 

DECLARE @HHFields TABLE  (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

SELECT @HouseHoldingType=strHouseHoldingType, 
	@bitDoTOCL=	CASE
					when surveytype_id=2 then 0 --HCAHPS IP
					else 1
				END
FROM Survey_def 
WHERE Survey_id=@Survey_id

CREATE TABLE #HH_Dup_People (id_num INT IDENTITY, Pop_id INT, bitKeep BIT)
CREATE TABLE #Minor_Universe (id_num INT IDENTITY, Pop_id INT, intShouldBeRand TINYINT, intRemove INT, intMinorException INT)
CREATE TABLE #Minor_Exclude (Pop_id INT, intMinorException INT)	
CREATE TABLE #HouseHold_Dups (dummyColumn BIT)

IF @HouseHoldingType <> 'N'
BEGIN

	INSERT INTO @HHFields
	SELECT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
	FROM dbo.HouseHoldRule HR, MetaData_View m
	WHERE HR.Table_id=M.Table_id
	AND HR.Field_id=M.Field_id
	AND HR.Survey_id=@Survey_id

	SELECT @HouseHoldFieldSelectSyntax=@HouseHoldFieldSelectSyntax+', X.'+Fieldname
	FROM @HHFields
	ORDER BY Field_id
	SET @HouseHoldFieldSelectSyntax=substring(@HouseHoldFieldSelectSyntax,2,len(@HouseHoldFieldSelectSyntax)-1)

	SELECT @HouseHoldJoinSyntax=CASE WHEN @HouseHoldJoinSyntax='' THEN '' 
               ELSE @HouseHoldJoinSyntax+' AND ' END+' X.'+Fieldname+'=Y.'+FieldName
	FROM @HHFields
	ORDER BY Field_id

	SELECT @HouseHoldFieldCreateTableSyntax=@HouseHoldFieldCreateTableSyntax+
		','+
		FieldName+' '+
		CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
	FROM @HHFields
	ORDER BY Field_id
	SELECT @sel=REPLACE(@sel,',,','')
	SELECT @HouseHoldFieldCreateTableSyntax=SUBSTRING(@HouseHoldFieldCreateTableSyntax,2,LEN(@HouseHoldFieldCreateTableSyntax)-1)


	IF @encTableExists=1
	SELECT @sel='ALTER TABLE #HH_Dup_People ADD EncounterEnc_id INT'
	ELSE
	SELECT @sel='ALTER TABLE #HH_Dup_People ADD ,'

	SELECT @sel=@sel+
		','+
		FieldName+' '+
		CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
	FROM @HHFields
	ORDER BY Field_id
	SELECT @sel=REPLACE(@sel,',,','')

	EXEC (@Sel)
	SELECT @sel=REPLACE(@sel,'#HH_Dup_People','#Minor_Universe')
	EXEC (@Sel)
	SELECT @sel=REPLACE(@sel,'#Minor_Universe','#Minor_Exclude')
	EXEC (@Sel)
	SELECT @sel=REPLACE(@sel,'#Minor_Exclude','#HouseHold_Dups')
	EXEC (@Sel) 
 
END

--Create temp Tables
CREATE TABLE #SampleUnit_Universe (id_num INT IDENTITY, SampleUnit_id INT, Pop_id INT, Enc_id INT, Age INT, 
		DQ_Bus_Rule INT, Removed_Rule INT DEFAULT 0, strUnitSelectType VARCHAR(1), EncDate DATETIME,
		ReSurveyDate DATETIME, HouseHold_id int, bitBadAddress bit default 0, bitBadPhone bit default 0)

CREATE TABLE #PreSample (Pop_id INT, Enc_id INT, SampleUnit_id INT NOT NULL, DQ_id INT, bitBadAddress bit default 0, bitBadPhone bit default 0)
IF @encTableExists=0 
	ALTER TABLE #PreSample
		DROP COLUMN Enc_id

--Set Join Variables
DECLARE @BVJOIN VARCHAR(100), @PopID_EncID_Join VARCHAR(100), @POPENCSelect VARCHAR(100),
	 @PopID_EncID_CreateTable VARCHAR(100), @PopID_EncID_Select_Aliased  VARCHAR(100)

IF @encTableExists=1
BEGIN
	SELECT @BVJOIN= 'X.Pop_id=BV.POPULATIONPop_id AND X.Enc_id=BV.ENCOUNTEREnc_id'
	SELECT @PopID_EncID_Join='X.Pop_id=Y.Pop_id AND X.Enc_id=Y.Enc_id'
	SELECT @POPENCSelect='Pop_id, Enc_id'
	SELECT @PopID_EncID_CreateTable ='Pop_id int, Enc_id int'
	SELECT @PopID_EncID_Select_Aliased='x.Pop_id, x.Enc_id'
END
ELSE 
BEGIN
	SELECT @BVJOIN= 'X.Pop_id=BV.POPULATIONPop_id'
	SELECT @PopID_EncID_Join='X.Pop_id=Y.Pop_id'
	SELECT @POPENCSelect='Pop_id'
	SELECT @PopID_EncID_CreateTable ='Pop_id int'
	SELECT @PopID_EncID_Select_Aliased='x.Pop_id'
END

--Identify the encounter date field and daterange
IF @EncounterDateField IS NULL AND @encTableExists=0 SET @EncounterDateField='populationNewRecordDate'
	ELSE IF @EncounterDateField IS NULL AND @encTableExists=1 SET @EncounterDateField='encounterNewRecordDate'

IF NOT (@FromDate is null or @FromDate='')
BEGIN
	SELECT @strDateWhere=' AND '+@EncounterDateField+' BETWEEN '''+@FromDate+''' AND '''+CONVERT(VARCHAR,@ToDate)+' 23:59:59'''
END
ELSE
BEGIN
	SET @strDateWhere=' AND '+@EncounterDateField+' BETWEEN ''01jan1900'' AND ''01jan2500'''
END

--Add fields to bigview
IF @encTableExists=1
Insert into @tbl values ('ENCOUNTEREnc_id', 'I',4,0)

INSERT INTO @tbl 
	SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
	FROM CriteriaStmt cs, CriteriaClause cc, MetaData_View m
	WHERE cs.Study_id=@Study_id
	AND cs.CriteriaStmt_id=cc.CriteriaStmt_id
	AND cc.Table_id=m.Table_id
	AND cc.Field_id=m.Field_id
	AND strTable_nm+strField_nm not in ('EncounterEnc_id','POPULATIONPop_id')
UNION
	SELECT *
	FROM @HHFields
	WHERE FieldName not in ('EncounterEnc_id','POPULATIONPop_id')

IF NOT EXISTS (SELECT 1 FROM @tbl WHERE FieldName= 'POPULATIONAge')
	INSERT INTO @tbl SELECT 'POPULATIONAge', 'I',4,'9999'
IF NOT EXISTS (SELECT 1 FROM @tbl WHERE FieldName= @EncounterDateField)
	INSERT INTO @tbl SELECT @EncounterDateField, 'D',4,'9999'
CREATE TABLE #BVUK (POPULATIONPop_id INT)


--Add fields to bigview
SET @sel='ALTER TABLE #BVUK ADD ,'

SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY Field_id
SET @sel=REPLACE(@sel,',,','')

EXEC (@Sel)

--Add HH fields to #sampleunitUniverse
IF exists(select top 1 * from @HHFields)
BEGIN
	SET @sel='ALTER TABLE #SampleUnit_Universe ADD ,'

	SELECT @sel=@sel+
		','+
		FieldName+' '+
		CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
	FROM @HHFields
	ORDER BY Field_id
	SET @sel=REPLACE(@sel,',,','')

	EXEC (@Sel)
END


IF @encTableExists=1 CREATE INDEX popenc ON #BVUK (Populationpop_id, EncounterEnc_id)
	ELSE CREATE INDEX Populationpop_id ON #BVUK (Populationpop_id)

CREATE TABLE #Criters (Survey_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20))        

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd='Q'
AND Survey_id=@Survey_id

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, 'C'
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id
AND c.Study_id=@Study_id
AND su.Sampleplan_id=sp.Sampleplan_id
AND Survey_id=@Survey_id

--Add the bad address and bad phone criterias
INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd in ('F','A')
AND Survey_id=@Survey_id

DECLARE @Tables TABLE (tablename VARCHAR(40))
INSERT INTO @Tables
SELECT DISTINCT strTable_nm
FROM MetaTable
WHERE Study_id=@Study_id

SELECT top 1 @sel=tablename FROM @tables
WHILE @@ROWCOUNT>0
BEGIN
	
	DELETE @tables WHERE tablename=@sel
	
	SET @sel='UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'''+@sel+'.'','''+@sel+''')'
	EXEC (@Sel)
	
	SELECT TOP 1 @sel=tablename FROM @tables

END

UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'"','''')

DECLARE @Criteria VARCHAR(7900)

--Loop thru one Survey at a time
--Get the SampleUnit order
CREATE TABLE #SampleUnits
  (SampleUnit_id INT,
   ParentSampleUnit_id INT,
   CriteriaStmt_id INT,
   intTier INT,
   strNode VARCHAR(255),
   intTreeOrder INT,
   Survey_id INT)

--	SP_Samp_ReOrgSampleUnits 388
INSERT INTO #SampleUnits
EXEC QCL_SampleSetReOrgSampleUnits @Survey_id

--need two loops 
--loop the actual Criteria Stmts to assign people to Units
SELECT TOP 1 @SampleUnit=SampleUnit_id FROM #SampleUnits ORDER BY intTreeOrder
WHILE @@ROWCOUNT>0
BEGIN

	SELECT @ParentSampleUnit=ParentSampleUnit_id 
	  FROM #SampleUnits 
	    WHERE SampleUnit_id=@SampleUnit
	SELECT @Criteria=strCriteriaStmt 
	  FROM #SampleUnits su, #Criters c 
	    WHERE SampleUnit_id=@SampleUnit
	     AND su.CriteriaStmt_id=c.CriteriaStmt_id


	IF @ParentSampleUnit IS NULL
	BEGIN
		IF @encTableExists=1
		BEGIN
			SELECT @Sel='b.Populationpop_id, b.EncounterEnc_id'
			SELECT @Sql='Populationpop_id, EncounterEnc_id'
		END
		ELSE 
		BEGIN
			SELECT @Sel='b.Populationpop_id'
			SELECT @Sql='Populationpop_id'
		END
		
		--build the SELECT list
		SELECT @sel=@sel+','+Fieldname
		FROM @tbl
		WHERE Fieldname NOT IN ('Populationpop_id', 'EncounterEnc_id')
		ORDER BY Field_id

		--build the INSERT list
		SELECT @sql=@sql+','+Fieldname
		FROM @tbl
		WHERE Fieldname NOT IN ('Populationpop_id', 'EncounterEnc_id')
		ORDER BY Field_id
	
		IF @encTableExists=1
			--build the temp table.
			SET @Sel='INSERT INTO #BVUK('+@Sql+')
				SELECT '+@Sel+'
				FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
				WHERE dsm.DataSet_id=t.DataSet_id
				AND dsm.Enc_id=b.EncounterEnc_id
				AND ('+@Criteria+')'+@strDateWhere
		ELSE
			SET @Sel='INSERT INTO #BVUK('+@Sql+')
				SELECT '+@Sel+'
				FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
				WHERE dsm.DataSet_id=t.DataSet_id
				AND dsm.Pop_id=b.PopulationPop_id
				AND ('+@Criteria+')'+@strDateWhere
		EXEC (@Sel)

		IF @encTableExists=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)
				SELECT Populationpop_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b
				WHERE ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)
				SELECT Populationpop_id,EncounterEnc_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b
				WHERE ('+@Criteria+')'
	END
	ELSE
	BEGIN
		IF @encTableExists=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)
				SELECT b.Populationpop_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.Pop_id=b.Populationpop_id
				AND ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)
				SELECT b.Populationpop_id,b.EncounterEnc_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.Enc_id=b.EncounterEnc_id
				AND ('+@Criteria+')'
	END
	EXEC (@Sel)
	
	DELETE c 
	  FROM #SampleUnits su, #Criters c 
	    WHERE SampleUnit_id=@SampleUnit 
	     AND su.CriteriaStmt_id=c.CriteriaStmt_id
	DELETE #SampleUnits WHERE SampleUnit_id=@SampleUnit
	SELECT TOP 1 @SampleUnit=SampleUnit_id FROM #SampleUnits ORDER BY intTreeOrder
	
END

DROP TABLE #SampleUnits

--Remove Records that can't be sampled and update the counts in SPW if
--it is not a census sample
IF @SamplingMethod <>3
BEGIN
	CREATE INDEX Pop_id ON #PRESAMPLE (Pop_id)

	SELECT Pop_id
	INTO #SampleAble
	FROM #PreSample p, sampleunit s
	WHERE p.sampleunit_id=s.sampleunit_id and
			s.inttargetReturn>0
	 GROUP BY Pop_id
	 HAVING COUNT(*)>0

	--Remove pops not eligible for any targeted units
	SELECT p.Sampleunit_id, p.Pop_id
	INTO #UnSampleAble
	FROM #PreSample p LEFT JOIN #SampleAble s
		ON p.Pop_id=s.Pop_id
	WHERE s.Pop_id IS NULL

	DELETE p
	FROM #PreSample p, #UnSampleAble u
	WHERE p.Pop_id=u.Pop_id

	--Update the Universe count in SPW 
	UPDATE spw
	SET IntUniverseCount=ISNULL(IntUniverseCount,0)+freq
	FROM SamplePlanWorkSheet spw, 
		(SELECT sampleunit_id, COUNT(*) AS freq
		 FROM #UnSampleAble 
		 GROUP BY sampleunit_id) u
	WHERE spw.sampleunit_id=u.sampleunit_id AND
			spw.sampleset_id=@sampleSet_id

END

--Evaluate the DQ rules
SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd='Q' ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @encTableExists=0
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id 
					AND p.Enc_id=b.EncounterEnc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE CriteriaStmt_id=@DQ_id

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd='Q' ORDER BY CriteriaStmt_id

END

--Evaluate the Bad Address 
SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='A' ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @encTableExists=0
		SELECT @Sel='UPDATE p
					SET bitBadAddress=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET bitBadAddress=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id 
					AND p.Enc_id=b.EncounterEnc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE CriteriaStmt_id=@DQ_id

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='A' ORDER BY CriteriaStmt_id

END


--Evaluate the Bad Phone rules
SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='F' ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @encTableExists=0
		SELECT @Sel='UPDATE p
					SET bitBadPhone=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET bitBadPhone=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id 
					AND p.Enc_id=b.EncounterEnc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE CriteriaStmt_id=@DQ_id

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='F' ORDER BY CriteriaStmt_id

END



IF @encTableExists=0
	SET @Sel='INSERT INTO #SampleUnit_Universe 
	SELECT DISTINCT SampleUnit_id, ' +
	'x.pop_id, null as enc_ID, POPULATIONAge, DQ_ID, '+
	'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '+@EncounterDateField+', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone' 
ELSE
	SET @Sel='INSERT INTO #SampleUnit_Universe 
	SELECT DISTINCT SampleUnit_id, ' +
	'x.pop_id, x.enc_id, POPULATIONAge, DQ_ID, '+
	'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '+@EncounterDateField+', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone' 

IF @HouseHoldingType<>'N' SET @Sel=@Sel++', '+REPLACE(@HouseHoldFieldSelectSyntax,'X.','BV.')
SET @Sel=@Sel+' FROM #PreSample X, #BVUK BV ' +
'WHERE '+@BVJOIN 

SET @Sel=@Sel+' ORDER BY SampleUnit_id, '+@PopID_EncID_Select_Aliased 
EXEC (@Sel)

EXEC QCL_SampleSetIndexUniverse @encTableExists

SELECT @newbornRule=REPLACE(CONVERT(VARCHAR(7900),strCriteriaString),'"','''')
FROM criteriastmt c, businessrule br
WHERE c.criteriastmt_id=br.criteriastmt_id AND
	c.study_id=@study_id AND
	br.survey_id=@Survey_id AND
	BusRule_cd='B'

IF @newbornRule IS NOT NULL EXEC QCL_SampleSetNewbornRule @study_id, @BVJOIN, @newbornRule

IF @bitDoTOCL=1 EXEC QCL_SampleSetTOCLRule @study_id

EXEC QCL_SampleSetAssignHouseHold @HouseHoldFieldCreateTableSyntax, 
                                 @HouseHoldFieldSelectSyntax, 
                                 @HouseHoldJoinSyntax, 
                                 @HouseHoldingType

-- Apply the resurvey exclusion rule
EXEC QCL_SampleSetResurveyExclusion_StaticPlus @study_id, @resurveyMethod_id, @ReSurvey_Period, 
 @samplingAlgorithmId, @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax, 
 @HouseHoldJoinSyntax, @HouseHoldingType 

--Remove People that have a removed rule other than 0 or 4(DQ)
DECLARE @RemovedRule INT, @unit INT, @freq INT, @RuleName VARCHAR(8)

SELECT sampleunit_Id, Removed_Rule, COUNT(*) AS freq
INTO #UnSampleAbleRR
FROM #SampleUnit_Universe 
WHERE Removed_Rule NOT IN (0,4)
GROUP by sampleunit_Id, Removed_Rule

DELETE 
FROM #SampleUnit_Universe
WHERE Removed_Rule NOT IN (0,4)

--Update the Universe count in SPW 
SELECT top 1 @RemovedRule=Removed_Rule, @unit=sampleunit_Id, @freq=freq
FROM #UnSampleAbleRR

WHILE @@ROWCOUNT>0
BEGIN
	
	IF @RemovedRule=1 SET @RuleName='Resurvey'
	IF @RemovedRule=2 SET @RuleName='NewBorn'
	IF @RemovedRule=3 SET @RuleName='TOCL'
	IF @RemovedRule=4 SET @RuleName='DQRule'
	IF @RemovedRule=5 SET @RuleName='ExcEnc'
	IF @RemovedRule=6 SET @RuleName='HHMinor'
	IF @RemovedRule=7 SET @RuleName='HHAdult'
	IF @RemovedRule=8 SET @RuleName='SSRemove'
	EXEC QCL_InsertRemovedRulesIntoSPWDQCOUNTS @sampleset_Id, @unit, @RuleName, @freq

	DELETE 
	FROM #UnSampleAbleRR
	WHERE Removed_Rule=@removedRule 
		AND sampleunit_Id=@unit

	SELECT TOP 1 @RemovedRule=Removed_Rule, @unit=sampleunit_Id, @freq=freq
	FROM #UnSampleAbleRR
END

--Randomize file by Pop_id 
CREATE TABLE #randomPops (Pop_id INT, numrandom INT)

INSERT INTO #randomPops
SELECT Pop_id, numrandom
FROM (Select MAX(id_num) AS id_num, Pop_id
	FROM #SampleUnit_Universe
	GROUP BY Pop_id) dsp, random_numbers rn
WHERE ((dsp.id_num+@Seed)%1000000)=rn.random_id

--Return data sorted by randomPop_id
SELECT su.SampleUnit_id, su.Pop_id, su.Enc_id, su.DQ_Bus_Rule, su.Removed_Rule, su.EncDate, su.HouseHold_id, su.bitBadAddress, su.bitBadPhone
FROM #SampleUnit_Universe su, #randomPops rp
WHERE su.Pop_id=rp.Pop_id
ORDER BY rp.numrandom,Enc_id
	

DROP TABLE #Criters
DROP TABLE #Presample
DROP TABLE #DataSets
DROP TABLE #BVUK
DROP TABLE #randomPops
DROP TABLE #HH_Dup_People
DROP TABLE #Minor_Universe
DROP TABLE #Minor_Exclude
DROP TABLE #HouseHold_Dups
DROP TABLE #SAMPLEUNIT_UNIVERSE
DROP TABLE #SampleAble
DROP TABLE #UnSampleAble
DROP TABLE #UnSampleAblerr
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF





GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/***********************************************************************************************************************************
SP Name: sp_Samp_CalcResponseRates
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
Modified 7/7/3 BD Calculate the ResponseRate from the RespRateCount table.  This is a summary table of 
   current response rates as of current day.  
Modified 7/7/3 BD Only use SampleSets from the last 18 months.
Modified 8/24/2006 DC  Call SP in datamart to get back temp table of resprate information
   
***********************************************************************************************************************************/
ALTER PROCEDURE [dbo].[sp_Samp_CalcResponseRates]
 @intSurvey_id INT
AS
 DECLARE @ResponseRate_Recalc_Period INT
 
 --insert into dc_temp_timer (sp, starttime)
 --values ('sp_Samp_CalcResponseRates', getdate())
 
 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period = intResponse_Recalc_Period
  FROM Survey_def
  WHERE Survey_id = @intSurvey_id
 
CREATE TABLE #SampleSets (SampleSet_id INT)
 /* Mark the Sample Sets that have completed the collection methodology */
 INSERT INTO #SampleSets
 SELECT SampleSet_id
  FROM SampleSet
  WHERE datLastMailed IS NOT NULL
   AND DATEDIFF(DAY, datLastMailed, GETDATE()) > @ResponseRate_Recalc_Period
   AND Survey_id = @intSurvey_id
--Added 7/3/3 BD Only keep samplesets from the last 18 months.
   --AND datSampleCreate_dt > DATEADD(MONTH,-12,GETDATE())
 
DECLARE @sql VARCHAR(2000), @Server VARCHAR(50)
 
SELECT @Server=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'
 
CREATE TABLE #r (SampleUnit_id INT, RespRate FLOAT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)
 
--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
SELECT @sql='insert into #rr
			Exec '+@Server+'.qp_comments.dbo.QCL_SelectRespRateInfoBySurveyId ' + convert(varchar,@intSurvey_id) 
EXEC (@sql)

INSERT INTO #r 
SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled))*100) AS RespRate
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id = ss.SampleSet_id
GROUP BY SampleUnit_id
 
UPDATE SampleUnit
SET numResponseRate = RespRate
FROM #r
WHERE SampleUnit.SampleUnit_id = #r.SampleUnit_id
 
DROP TABLE #r



GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It will update the response
rate information in the sampleunit table.

Created:  02/24/2006 by DC

Modified:
03/15/2006 Brian Dohmen	  Made the datamart location a variable so it will work in Canada.
			  I also incorporated the HCAHPS 6 week cutoff
*/  
alter PROCEDURE [dbo].[QCL_CalcResponseRates]
 @Survey_id INT,
 @ResponseRate_Recalc_Period INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @sql VARCHAR(8000), @DataMart VARCHAR(50)

SELECT @DataMart=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'

 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period=intResponse_Recalc_Period
  FROM Survey_def
  WHERE Survey_id=@Survey_id

CREATE TABLE #SampleSets (SampleSet_id INT, datsamplecreate_dt datetime)
 /* Mark the Sample Sets that have completed the collection methodology */
 INSERT INTO #SampleSets
 SELECT SampleSet_id, datsamplecreate_dt
  FROM SampleSet
  WHERE datLastMailed IS NOT NULL
   AND DATEDIFF(DAY, datLastMailed, GETDATE())>@ResponseRate_Recalc_Period
   AND Survey_id=@Survey_id

CREATE TABLE #r (SampleUnit_id INT, intSampled INT, intReturned INT, bitHCAHPS BIT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)

SELECT @sql='insert into #rr 
			Exec '+@DataMart+'.qp_comments.dbo.QCL_SelectRespRateInfoBySurveyId ' + convert(varchar,@Survey_id) 
EXEC (@sql)

--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
SELECT @sql='INSERT INTO #r (SampleUnit_id, intSampled, intReturned, bitHCAHPS)
SELECT SampleUnit_id, SUM(intSampled), SUM(intReturned), 0
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id=ss.SampleSet_id
GROUP BY SampleUnit_id'
EXEC (@sql)

--Identify HCAHPS units
UPDATE t
SET bitHCAHPS=1
FROM #r t, SampleUnit su
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.bitHCAHPS=1

IF @@ROWCOUNT>0
BEGIN

CREATE TABLE #Update (SampleUnit_id INT, intReturned INT)
CREATE TABLE #rrDays (sampleset_id INT, sampleunit_id INT, intreturned INT)

SELECT @sql='insert into #rrDays 
			Exec '+@DataMart+'.qp_comments.dbo.QCL_SelectHCAHPSRespRateByDaysInfoBySurveyId ' + convert(varchar,@Survey_id) 
EXEC (@sql)

 --Update the response rate for the HCAHPS unit(s)
 SELECT @sql='INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(r2.intReturned) intReturned
       FROM #rr rrc, 
       #rrDays r2, 
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND r2.sampleset_id=ss.sampleset_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND tt.SampleUnit_id=r2.SampleUnit_id
  AND ss.datSampleCreate_dt>''4/10/6''
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id

 INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(rrc.intReturned) intReturned
       FROM #rr rrc, 
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND ss.datSampleCreate_dt<''4/10/6''
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id'

 EXEC (@sql)

 UPDATE t
 SET intReturned=u.intReturned
 FROM #r t, (SELECT SampleUnit_id, SUM(intReturned) intReturned
 FROM #Update
 GROUP BY SampleUnit_id) u
 WHERE t.SampleUnit_id=u.SampleUnit_id

 DROP TABLE #Update

END

UPDATE su
SET numResponseRate=RespRate
FROM SampleUnit su, (SELECT SampleUnit_id, ((intReturned*1.0)/(intSampled)*100) RespRate
FROM #r) a
WHERE su.SampleUnit_id=a.SampleUnit_id

UPDATE su
SET numResponseRate=numInitResponseRate
FROM SampleUnit su, (
         SELECT SampleUnit_id 
         FROM SampleUnit s, SamplePlan sp 
         WHERE sp.Survey_id=@Survey_id
         AND sp.SamplePlan_id=s.SamplePlan_id) a LEFT JOIN #r t
ON a.SampleUnit_id=t.SampleUnit_id
WHERE t.SampleUnit_id IS NULL
AND a.SampleUnit_id=su.SampleUnit_id

DROP TABLE #r

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


GO 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
GO

/***********************************************************************************
								Triggers
/***********************************************************************************/
GO

ALTER TRIGGER tr_SentMailingUndeliverable ON SentMailing    
FOR UPDATE    
AS    
    
IF UPDATE(datUndeliverable)    
BEGIN    
    
 DECLARE @datNonDel DATETIME, @LoggedBy VARCHAR(50), @ReceiptTypeID INT, @DispositionID INT, @datReturned DATETIME, @SamplePopID INT, @SentMailID INT, @StudyID INT, @datLogged DATETIME    
     
 SELECT @LoggedBy = '#nrcsql', @ReceiptTypeID = 0    
 SELECT @DispositionID = Disposition_id FROM Disposition WHERE HCAHPSValue = '09'    
    
 SELECT  @StudyID=sp.study_id, @SamplePopID=sp.samplepop_id,     
  @SentMailID=i.sentmail_id, @datNonDel=i.datUndeliverable,     
  @datReturned=qf.datReturned    
 FROM INSERTED i, questionform qf, samplepop sp     
 WHERE i.sentmail_id = qf.sentmail_id     
 AND qf.samplepop_id = sp.samplepop_id    
 AND i.datUndeliverable IS NOT NULL    
    
 INSERT INTO SMUndeliverable_Extract (sp.study_id, sp.samplepop_id, i.sentmail_id, i.datUndeliverable, qf.datReturned)    
 SELECT @StudyID, @SamplePopID, @SentMailID, @datNonDel, @datReturned    
    
 SET @datLogged = @datNonDel    
  
 IF NOT EXISTS (SELECT * FROM DispositionLog WHERE samplepop_id = @samplepopID AND disposition_id = @DispositionID   
  AND ReceiptType_id = @ReceiptTypeID AND datLogged = @datLogged AND LoggedBy = @LoggedBy)  

 EXEC dbo.QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @LoggedBy, @datLogged

END   GO

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE Backpopulation for Dispositions
DECLARE @dispo int
SELECT @dispo = disposition_id FROM disposition WHERE hcahpsvalue = '09'

INSERT INTO DispositionLog (SentMail_id, SamplePop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy)    
select sentmail_id, samplepop_id, Disposition_id, ReceiptType_id, datLogged, LoggedBy 
FROM (
select sm.sentmail_id, qf.samplepop_id, @dispo AS Disposition_id, 0 AS ReceiptType_id, sm.datUndeliverable AS datLogged, '#nrcsql' AS LoggedBy
FROM sentmailing sm, questionform qf, #hsvy h where qf.survey_id = h.survey_id and qf.sentmail_id = sm.sentmail_id 
and sm.datgenerated > '11/30/05') 
t2 where datLogged> '3/31/06'
-- 3:00 MIN

--Now Update the DaysFrom values

SELECT dl.sentmail_id, dl.samplepop_id, dl.disposition_id, receipttype_id, dl.datlogged, dl.LoggedBy,  DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)),datLogged) DaysFromCurrent
INTO #DFC
FROM DispositionLog dl(NOLOCK), SentMailing sm(NOLOCK)
WHERE dl.SentMail_id=sm.SentMail_id
AND dl.daysfromcurrent IS NULL
-- 3:05

SELECT dl.sentmail_id, dl.samplepop_id, dl.disposition_id, dl.receipttype_id, dl.datLogged, dl.LoggedBy
, DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),MIN(datMailed),120)),dl.datLogged) AS DaysFromFirst
INTO #DFF
FROM DispositionLog dl(NOLOCK), ScheduledMailing schm(NOLOCK), ScheduledMailing schm2(NOLOCK), SentMailing sm(NOLOCK)
WHERE dl.SentMail_id=schm.SentMail_id
AND schm.SamplePop_id=schm2.SamplePop_id
AND schm2.SentMail_id=sm.SentMail_id
AND dl.DaysFromFirst IS NULL
GROUP BY dl.sentmail_id, dl.samplepop_id, dl.disposition_id, dl.receipttype_id, dl.datLogged, dl.LoggedBy

-- 3:29
UPDATE dl SET dl.DaysFromFirst = ud.DaysFromFirst FROM dispositionlog dl, #dff ud WHERE dl.sentmail_id = ud.sentmail_id AND dl.disposition_id = ud.disposition_id AND dl.datLogged = ud.datLogged
UPDATE dl SET dl.DaysFromCurrent = ud.DaysFromCurrent FROM dispositionlog dl, #dfc ud WHERE dl.sentmail_id = ud.sentmail_id AND dl.disposition_id = ud.disposition_id AND dl.datLogged = ud.datLogged

DELETE FROM DispositionLog WHERE DaysFromFirst IS NULL

DROP TABLE #DFC
DROP TABLE #DFF

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Now get bitComplete dispostions and 

SELECT DISTINCT survey_id INTO #hsvy FROM survey_def WHERE surveytype_id = 2

DECLARE @complete INT, @incomplete int
SELECT @complete = Disposition_id FROM DISPOSITION WHERE HCAHPSVALUE = '01'
SELECT @incomplete = Disposition_id FROM DISPOSITION WHERE HCAHPSVALUE = '06'
select DISTINCT sentmail_id, samplepop_id, 
CASE WHEN bitComplete = 1 THEN @COMPLETE WHEN bitcomplete = 0 THEN @incomplete ELSE NULL END AS disposition_id, 0 AS ReceiptType_id, datReturned AS datLogged, '#nrcsql' AS LoggedBy,
CONVERT(INT,NULL) AS DaysFromCurrent, CONVERT(INT,NULL) AS DaysFromFirst
into tmpI3_dispositionlog_bitcomplete
from questionform qf, #hsvy h where qf.survey_id = h.survey_id and bitcomplete is not null


SELECT dl.sentmail_id, dl.samplepop_id, dl.disposition_id, receipttype_id, dl.datlogged, dl.LoggedBy,  DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)),datLogged) DaysFromCurrent
INTO #DFC
FROM tmpI3_dispositionlog_bitcomplete dl(NOLOCK), SentMailing sm(NOLOCK)
WHERE dl.SentMail_id=sm.SentMail_id
AND dl.daysfromcurrent IS NULL
-- 3:05

SELECT dl.sentmail_id, dl.samplepop_id, dl.disposition_id, dl.receipttype_id, dl.datLogged, dl.LoggedBy
, DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),MIN(datMailed),120)),dl.datLogged) AS DaysFromFirst
INTO #DFF
FROM tmpI3_dispositionlog_bitcomplete dl(NOLOCK), ScheduledMailing schm(NOLOCK), ScheduledMailing schm2(NOLOCK), SentMailing sm(NOLOCK)
WHERE dl.SentMail_id=schm.SentMail_id
AND schm.SamplePop_id=schm2.SamplePop_id
AND schm2.SentMail_id=sm.SentMail_id
AND dl.DaysFromFirst IS NULL
GROUP BY dl.sentmail_id, dl.samplepop_id, dl.disposition_id, dl.receipttype_id, dl.datLogged, dl.LoggedBy

UPDATE dl SET dl.DaysFromFirst = ud.DaysFromFirst FROM tmpI3_dispositionlog_bitcomplete dl, #dff ud WHERE dl.sentmail_id = ud.sentmail_id AND dl.disposition_id = ud.disposition_id AND dl.datLogged = ud.datLogged
UPDATE dl SET dl.DaysFromCurrent = ud.DaysFromCurrent FROM tmpI3_dispositionlog_bitcomplete dl, #dfc ud WHERE dl.sentmail_id = ud.sentmail_id AND dl.disposition_id = ud.disposition_id AND dl.datLogged = ud.datLogged

DROP TABLE #DFC
DROP TABLE #DFF
DROP TABLE #HSVY
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




GO
/***********************************************************************************
						GRANT EXECUTE PERMISSIONS FOR PROCEDURES
***********************************************************************************/
/*
SET NOCOUNT ON
CREATE TABLE #Commands (Id INT IDENTITY (1,1), Command VARCHAR(1000))
INSERT INTO #Commands
SELECT 'GRANT EXECUTE ON ' + name + ' TO WebPref' FROM sysobjects WHERE name LIKE 'QCL_%' AND type = 'P'

DECLARE @Id INT
DECLARE @SQL VARCHAR(1000)
WHILE (SELECT COUNT(*) FROM #Commands) > 0
BEGIN
	SELECT TOP 1 @Id = Id, @SQL = Command FROM #Commands
	--PRINT @SQL
	EXECUTE (@SQL)
	DELETE #Commands WHERE Id = @Id
END

DROP TABLE #Commands
SET NOCOUNT OFF
*/


