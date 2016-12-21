use qp_prod

if not exists (select * from sys.schemas where name = 'CIHI')
	exec ('CREATE SCHEMA CIHI');

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Submission')
	DROP TABLE [CIHI].[Submission];

CREATE TABLE [CIHI].[Submission] (
	SubmissionID int identity(1,1),
	DeviceManufacturer varchar(15) DEFAULT 'N0002',
	OrganizationCD varchar(20),
	CPESVersionCD varchar(20) DEFAULT 'CPES-IC_1.0',
	CPESManualVersionCD varchar(20) DEFAULT 'CPES-IC_PM_V1.0',
	SubmissionSubject char(3),
	SubmissionTypeCD char(3),
	PurposeCD char(1),
	EncounterDateStart datetime,
	EncounterDateEnd datetime,
	PullDate datetime,
	QADate datetime,
	QABy varchar(100),
	QACode varchar(100),
	FileState varchar(100),
	SubmissionDate datetime,
	SubmissionBy varchar(100),
	ResponseDate datetime,
	ResponseCD varchar(100),
	PRIMARY KEY (SubmissionID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionSurvey')
	DROP TABLE [CIHI].[SubmissionSurvey];

CREATE TABLE [CIHI].[SubmissionSurvey] (
	SubmissionSurveyID int identity(1,1),
	SubmissionID int,
	SurveyID int,
	PRIMARY KEY (SubmissionSurveyID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'OrgProfile')
	DROP TABLE [CIHI].[OrgProfile];

CREATE TABLE [CIHI].[OrgProfile] (
	OrgProfileID int identity(1,1),
	OrganizationCD varchar(20),
	SurveyingFrequency varchar(15),
	DeviceManufacturer varchar(15) DEFAULT 'N0002',
	RoleCD char(3),
	ContactCD char(3),
	ContactEmail varchar(255),
	ContactName varchar(255),
	ContactPhone varchar(30),
	ContactPhoneExtension varchar(30),
	isContracted bit,
	CreatedBy varchar(255),
	CreatedOn datetime,
	ModifiedBy varchar(255),
	ModifiedOn datetime,
	PRIMARY KEY (OrgProfileID)
);

GO
if exists (select * from sys.objects where schema_name(schema_id)='CIHI' and name = 'trg_CIHI_OrgProfile')
	DROP TRIGGER [CIHI].[trg_CIHI_OrgProfile] 
go
CREATE TRIGGER [CIHI].[trg_CIHI_OrgProfile] 
   ON  [CIHI].[OrgProfile]
   AFTER INSERT,UPDATE
AS 
BEGIN
    SET NOCOUNT ON
 
	update OP set CreatedOn=getdate(), CreatedBy=system_user 
	from [CIHI].[OrgProfile] OP
	join INSERTED i on OP.OrgProfileID=i.OrgProfileID
	where i.CreatedOn IS NULL

	update OP set ModifiedOn=getdate(), ModifiedBy=system_user 
	from [CIHI].[OrgProfile] OP
	join INSERTED i on OP.OrgProfileID=i.OrgProfileID

END
GO
IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'QA_QuestionnaireCycleAndStratum')
	DROP TABLE [CIHI].[QA_QuestionnaireCycleAndStratum];

CREATE TABLE CIHI.QA_QuestionnaireCycleAndStratum (
	QuestionnaireCycleAndStratumID int identity(1,1),
	SubmissionID int,
	CycleCD varchar(15),						--Derive from ENCOUNTERFacilityNum & encounter dates? Max length = 15.  Maybe survey_id +  begin MMYY + end MMYY (e.g. 27907_0416_0616)
	FacilityNum varchar(10),					--ENCOUNTERFacilityNum
	SubmissionTypeCD varchar(2),				--CIHI.Submission.SubmissionTypeCD
	CPESVersionCD varchar(15),					--"CPES-IC_PM_V1.0"
	EncounterDateStart varchar(8),				--CIHI.Submission.EncounterDateStart
	EncounterDateEnd varchar(8),				--CIHI.Submission.EncounterDateEnd
	samplingMethod_CD varchar(4),				--if dischargeCount=sampleSize for all strata then CEN, if one stratum then SRS, if multiple strata then DSRS
	dischargeCount int,							--count from eligible enc log
	sampleSize int,								--count (distinct pop_id) from samplepop, sum counts for all units
	nonResponseCount int,						--Calculate using dispositionlog, plus no responses
	sampleunitID int,							--sampleunit_id
	strSampleunit_nm varchar(42),				--sampleunit name. Max length in submission file = 25; strsampleunit_nm is varchar(42).
	PRIMARY KEY (QuestionnaireCycleAndStratumID)
);


IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'QA_Questionnaire')
	DROP TABLE [CIHI].[QA_Questionnaire];

CREATE TABLE CIHI.QA_Questionnaire (
	questionnaireID int identity(1,1),
	CycleCD varchar(15),						--same as in QA_QuestionnaireCycleAndStratum
	SubmissionID int,							--CIHI.Submission.SubmissionID
	samplePopID int,							--samplePop_id
	sampleSetID int, 							--sampleset_ID
	sampleunitID int,							--sampleunit_id
	HCN varchar(12),							--population.HCN
	HCN_Issuer char(3),							--population.HCN_Issuer
	CIHI_PID varchar(15),						--ENCOUNTER.CIHI_PID
	CIHI_PIDType char(3),						--ENCOUNTER.CIHI_PIDType
	DOB datetime,								--population.DOB
	estimatedBirthCD char(1),					--"N"
	sex char(3),								--population.sex
	dischargedate datetime,						--encounter.dischargedate
	CIHI_ServiceLine char(42),					--encounter.CIHI_ServiceLine
	mailingStepMethodID int,					--"derive from methodology/mailing step
	langID int,									--mailingStepMethod.mailingStepMethod_id"
	PRIMARY KEY (questionnaireID)				--sentmail.langid
);
		

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'QA_Question')
	DROP TABLE [CIHI].[QA_Question];

CREATE TABLE CIHI.QA_Question (
	questionID int identity(1,1),
	SubmissionID int,
	samplePopID int,
	qstncore int,
	intResponseVal int,
	PRIMARY KEY (questionID)
);
