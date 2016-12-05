use qp_prod

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionMetadata')
	DROP TABLE [CIHI].[SubmissionMetadata];

CREATE TABLE CIHI.SubmissionMetadata (
	SubmissionMetadataID int identity(1,1),
	submissionID int,
	[creationTime_value] varchar(8),
	[sender.device.manufacturer.id.value] varchar(5),
	[sender.organization.id.value] varchar(10),
	[versionCode_code] varchar(11),
	[versionCode_codeSystem] varchar(50),
	[purpose_code] char(1),
	[purpose_codeSystem] varchar(50),
	PRIMARY KEY (SubmissionMetadataID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionOrgProfile')
	DROP TABLE [CIHI].[SubmissionOrgProfile];

CREATE TABLE CIHI.SubmissionOrgProfile (
	SubmissionOrgProfileID int identity(1,1),
	SubmissionMetadataID int,
	[organizationProfile.organization.id.value] varchar(10),
	[organizationProfile.surveyingFrequency_code] varchar(9),
	[organizationProfile.surveyingFrequency_codeSystem] varchar(50),
	[organizationProfile.device.manufacturer.id.value] varchar(10),
	PRIMARY KEY (SubmissionOrgProfileID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionContact')
	DROP TABLE [CIHI].[SubmissionContact];

CREATE TABLE CIHI.SubmissionContact (
	SubmissionContactID int identity(1,1),
	SubmissionOrgProfileID int,
	[organizationProfile.organization.contact.code_code] varchar(3),
	[organizationProfile.organization.contact.code_codeSystem] varchar(50),
	[organizationProfile.organization.contact.email] varchar(50),
	[organizationProfile.organization.contact.name] varchar(25),
	[organizationProfile.organization.contact.phone_extension] varchar(10),
	[organizationProfile.organization.contact.phone_number] varchar(20),
	PRIMARY KEY (SubmissionContactID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionRole')
	DROP TABLE [CIHI].[SubmissionRole];

CREATE TABLE CIHI.SubmissionRole (
	SubmissionRoleID int identity(1,1),
	SubmissionOrgProfileID int,
	[organizationProfile.role_code] varchar(3),
	[organizationProfile.role_codeSystem] varchar(50),
	PRIMARY KEY (SubmissionRoleID)
);


IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionQuestionnaireCycle')
	DROP TABLE [CIHI].[SubmissionQuestionnaireCycle];

CREATE TABLE CIHI.SubmissionQuestionnaireCycle (
	SubmissionQuestionnaireCycleID int identity(1,1),
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
	PRIMARY KEY (SubmissionQuestionnaireCycleID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionStratum')
	DROP TABLE [CIHI].[SubmissionStratum];

CREATE TABLE CIHI.SubmissionStratum (
	SubmissionStratumID int identity(1,1),
	SubmissionQuestionnaireCycleID int,
	[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode] varchar(15),
	[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumDescription] varchar(25),
	[questionnaireCycle.sampleInformation.populationInformation.stratum.dischargeCount] int,
	[questionnaireCycle.sampleInformation.populationInformation.stratum.sampleSize] int,
	[questionnaireCycle.sampleInformation.populationInformation.stratum.nonResponseCount] int,
	PRIMARY KEY (SubmissionStratumID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionQuestionnaire')
	DROP TABLE [CIHI].[SubmissionQuestionnaire];

CREATE TABLE CIHI.SubmissionQuestionnaire (
	SubmissionQuestionnaireID int identity(1,1),
	SubmissionQuestionnaireCycleID int,
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
	PRIMARY KEY (SubmissionQuestionnaireID)
);

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionQuestion')
	DROP TABLE [CIHI].[SubmissionQuestion];

CREATE TABLE CIHI.SubmissionQuestion (
	SubmissionQuestionID int identity(1,1),
	SubmissionQuestionnaireID int,
	[questionnaireCycle.questionnaire.questions.question.code_code] char(4),
	[questionnaireCycle.questionnaire.questions.question.code_codeSystem] varchar(50),
	[questionnaireCycle.questionnaire.questions.question.answer_code] varchar(10),
	[questionnaireCycle.questionnaire.questions.question.answer_codeSystem] varchar(50),
	PRIMARY KEY (SubmissionQuestionID)
);