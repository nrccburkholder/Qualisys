use qp_prod

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Metadata')
	DROP TABLE [CIHI].[Final_Metadata];

CREATE TABLE CIHI.Final_Metadata (
	Final_MetadataID int identity(1,1),
	submissionID int,
	[creationTime_value] varchar(8),
	[sender.device.manufacturer.id.value] varchar(5),
	[sender.organization.id.value] varchar(10),
	[versionCode_code] varchar(11),
	[versionCode_codeSystem] varchar(50),
	[purpose_code] char(1),
	[purpose_codeSystem] varchar(50),
	PRIMARY KEY (Final_MetadataID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_OrgProfile')
	DROP TABLE [CIHI].[Final_OrgProfile];

CREATE TABLE CIHI.Final_OrgProfile (
	Final_OrgProfileID int identity(1,1),
	SubmissionID int,
	Final_MetadataID int,
	[organizationProfile.organization.id.value] varchar(10),
	[organizationProfile.surveyingFrequency_code] varchar(9),
	[organizationProfile.surveyingFrequency_codeSystem] varchar(50),
	[organizationProfile.device.manufacturer.id.value] varchar(10),
	PRIMARY KEY (Final_OrgProfileID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Contact')
	DROP TABLE [CIHI].[Final_Contact];

CREATE TABLE CIHI.Final_Contact (
	Final_ContactID int identity(1,1),
	SubmissionID int,
	Final_OrgProfileID int,
	[organizationProfile.organization.contact.code_code] varchar(3),
	[organizationProfile.organization.contact.code_codeSystem] varchar(50),
	[organizationProfile.organization.contact.email] varchar(50),
	[organizationProfile.organization.contact.name] varchar(25),
	[organizationProfile.organization.contact.phone_extension] varchar(10),
	[organizationProfile.organization.contact.phone_number] varchar(20),
	PRIMARY KEY (Final_ContactID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Role')
	DROP TABLE [CIHI].[Final_Role];

CREATE TABLE CIHI.Final_Role (
	Final_RoleID int identity(1,1),
	SubmissionID int,
	Final_OrgProfileID int,
	[organizationProfile.role_code] varchar(3),
	[organizationProfile.role_codeSystem] varchar(50),
	PRIMARY KEY (Final_RoleID)
);


IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_QuestionnaireCycle')
	DROP TABLE [CIHI].[Final_QuestionnaireCycle];

CREATE TABLE CIHI.Final_QuestionnaireCycle (
	Final_QuestionnaireCycleID int identity(1,1),
	submissionID int,
	[questionnaireCycle.id.value] varchar(15),
	[questionnaireCycle.healthCareFacility.id.value] varchar(10),
	[questionnaireCycle.submissionType_code] varchar(2),
	[questionnaireCycle.submissionType_codeSystem] varchar(50),
	[questionnaireCycle.proceduresManualVersion_code] varchar(15),
	[questionnaireCycle.proceduresManualVersion_codeSystem] varchar(50),
	[questionnaireCycle.effectiveTime.low_value] varchar(8),
	[questionnaireCycle.effectiveTime.high_value] varchar(8),
	[questionnaireCycle.sampleInformation.samplingMethod_code] varchar(4),
	[questionnaireCycle.sampleInformation.samplingMethod_codeSystem] varchar(50),
	[questionnaireCycle.sampleInformation.populationInformation.dischargeCount] int,
	[questionnaireCycle.sampleInformation.populationInformation.sampleSize] int,
	[questionnaireCycle.sampleInformation.populationInformation.nonResponseCount] int,
	PRIMARY KEY (Final_QuestionnaireCycleID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Stratum')
	DROP TABLE [CIHI].[Final_Stratum];

CREATE TABLE CIHI.Final_Stratum (
	Final_StratumID int identity(1,1),
	SubmissionID int,
	Final_QuestionnaireCycleID int,
	[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode] varchar(15),
	[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumDescription] varchar(25),
	[questionnaireCycle.sampleInformation.populationInformation.stratum.dischargeCount] int,
	[questionnaireCycle.sampleInformation.populationInformation.stratum.sampleSize] int,
	[questionnaireCycle.sampleInformation.populationInformation.stratum.nonResponseCount] int,
	PRIMARY KEY (Final_StratumID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Questionnaire')
	DROP TABLE [CIHI].[Final_Questionnaire];

CREATE TABLE CIHI.Final_Questionnaire (
	Final_QuestionnaireID int identity(1,1),
	SubmissionID int,
	Final_QuestionnaireCycleID int,
	[questionnaireCycle.questionnaire.id.value] varchar(15),
	[questionnaireCycle.questionnaire.subject.id.value] varchar(12),
	[questionnaireCycle.questionnaire.subject.id.issuer.code_code] char(2),
	[questionnaireCycle.questionnaire.subject.id.issuer.code_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.subject.otherId.value] varchar(15),
	[questionnaireCycle.questionnaire.subject.otherId.code_code] char(3),
	[questionnaireCycle.questionnaire.subject.otherId.code_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.subject.personInformation.birthTime_value] varchar(8),
	[questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_code] char(1),
	[questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.subject.personInformation.gender_code] char(3),
	[questionnaireCycle.questionnaire.subject.personInformation.gender_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.encompassingEncounter.effectiveTime.high_value] varchar(8),
	[questionnaireCycle.questionnaire.encompassingEncounter.service_code] char(4),
	[questionnaireCycle.questionnaire.encompassingEncounter.service_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.authorMode_code] varchar(10),
	[questionnaireCycle.questionnaire.authorMode_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.language_code] char(3),
	[questionnaireCycle.questionnaire.language_codeSystem] varchar(50),
	PRIMARY KEY (Final_QuestionnaireID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Question')
	DROP TABLE [CIHI].[Final_Question];

CREATE TABLE CIHI.Final_Question (
	Final_QuestionID int identity(1,1),
	SubmissionID int,
	Final_QuestionnaireID int,
	[questionnaireCycle.questionnaire.questions.question.code_code] char(4),
	[questionnaireCycle.questionnaire.questions.question.code_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.questions.question.answer_code] varchar(10),
	[questionnaireCycle.questionnaire.questions.question.answer_codeSystem] varchar(50),
	PRIMARY KEY (Final_QuestionID)
);