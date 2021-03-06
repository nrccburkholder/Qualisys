USE QP_PROD
GO



if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Contact')
	drop procedure [CIHI].[Select_Final_Contact]
GO

CREATE PROCEDURE [CIHI].[Select_Final_Contact]
	@ID INT
AS
BEGIN

	SELECT [Final_ContactID]
		  ,[SubmissionID]
		  ,[Final_OrgProfileID]
		  ,[organizationProfile.organization.contact.code_code]
		  ,[organizationProfile.organization.contact.code_codeSystem]
		  ,[organizationProfile.organization.contact.email]
		  ,[organizationProfile.organization.contact.name]
		  ,[organizationProfile.organization.contact.phone_extension]
		  ,[organizationProfile.organization.contact.phone_number]
	  FROM [CIHI].[Final_Contact]
	  WHERE Final_OrgProfileID = @ID
END
GO


if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Metadata')
	drop procedure [CIHI].[Select_Final_Metadata]
GO

CREATE PROCEDURE [CIHI].[Select_Final_Metadata]
	@ID INT

AS
BEGIN

	SELECT distinct [Final_MetadataID]
		  ,fm.[submissionID]
		  ,[creationTime_value]
		  ,[sender.device.manufacturer.id.value]
		  ,[sender.organization.id.value]
		  ,[versionCode_code]
		  ,[versionCode_codeSystem]
		  ,[purpose_code]
		  ,[purpose_codeSystem]
		  ,s.[SubmissionSubject]
	  FROM [CIHI].[Final_Metadata] fm
	  INNER JOIN [CIHI].[Submission] s on s.submissionid = fm.submissionid
	  WHERE fm.submissionID = @ID

END

GO


if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_OrgProfile')
	drop procedure [CIHI].[Select_Final_OrgProfile]
GO

CREATE PROCEDURE [CIHI].[Select_Final_OrgProfile]
	@ID INT
AS
BEGIN


	SELECT [Final_OrgProfileID]
		  ,[SubmissionID]
		  ,[Final_MetadataID]
		  ,[organizationProfile.organization.id.value]
		  ,[organizationProfile.surveyingFrequency_code]
		  ,[organizationProfile.surveyingFrequency_codeSystem]
		  ,[organizationProfile.device.manufacturer.id.value]
	  FROM [CIHI].[Final_OrgProfile]
	  WHERE Final_MetadataID = @ID

END

GO

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Question')
	drop procedure [CIHI].[Select_Final_Question]
GO

CREATE PROCEDURE [CIHI].[Select_Final_Question]
	@ID INT
AS
BEGIN

	SELECT fqu.[Final_QuestionID]
		  ,fqu.[Final_QuestionnaireID]
		  ,fqu.[questionnaireCycle.questionnaire.questions.question.code_code]
		  ,fqu.[questionnaireCycle.questionnaire.questions.question.code_codeSystem]
		  ,fqu.[questionnaireCycle.questionnaire.questions.question.answer_code]
		  ,fqu.[questionnaireCycle.questionnaire.questions.question.answer_codeSystem]
	  FROM [CIHI].[Final_Question] fqu
	  WHERE fqu.Final_QuestionnaireID = @ID

END

GO

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Questionnaire')
	drop procedure [CIHI].[Select_Final_Questionnaire]
GO

CREATE PROCEDURE [CIHI].[Select_Final_Questionnaire]
	@ID INT
AS
BEGIN


	SELECT fq.[Final_QuestionnaireID]
		  ,fq.[Final_QuestionnaireCycleID]
		  ,fq.[questionnaireCycle.questionnaire.id.value]
		  ,fq.[questionnaireCycle.questionnaire.subject.id.value]
		  ,fq.[questionnaireCycle.questionnaire.subject.id.issuer.code_code]
		  ,fq.[questionnaireCycle.questionnaire.subject.id.issuer.code_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.subject.otherId.value]
		  ,fq.[questionnaireCycle.questionnaire.subject.otherId.code_code]
		  ,fq.[questionnaireCycle.questionnaire.subject.otherId.code_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.subject.personInformation.birthTime_value]
		  ,fq.[questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_code]
		  ,fq.[questionnaireCycle.questionnaire.subject.personInformation.estimatedBirthTimeInd_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.subject.personInformation.gender_code]
		  ,fq.[questionnaireCycle.questionnaire.subject.personInformation.gender_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.encompassingEncounter.effectiveTime.high_value]
		  ,fq.[questionnaireCycle.questionnaire.encompassingEncounter.service_code]
		  ,fq.[questionnaireCycle.questionnaire.encompassingEncounter.service_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.authorMode_code]
		  ,fq.[questionnaireCycle.questionnaire.authorMode_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.language_code]
		  ,fq.[questionnaireCycle.questionnaire.language_codeSystem]
		  ,fq.[questionnaireCycle.questionnaire.stratumCode]
	  FROM [CIHI].[Final_Questionnaire] fq
	  WHERE fq.Final_QuestionnaireCycleID = @ID



END

GO

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_QuestionnaireCycle')
	drop procedure [CIHI].[Select_Final_QuestionnaireCycle]
GO

CREATE PROCEDURE [CIHI].[Select_Final_QuestionnaireCycle]
	@ID INT,
	@FacilityNum varchar(10)
AS
BEGIN


	SELECT fqc.[Final_QuestionnaireCycleID]
		  ,fqc.[submissionID]
		  ,fqc.[questionnaireCycle.id.value]
		  ,fqc.[questionnaireCycle.healthCareFacility.id.value]
		  ,fqc.[questionnaireCycle.submissionType_code]
		  ,fqc.[questionnaireCycle.submissionType_codeSystem]
		  ,fqc.[questionnaireCycle.proceduresManualVersion_code]
		  ,fqc.[questionnaireCycle.proceduresManualVersion_codeSystem]
		  ,fqc.[questionnaireCycle.effectiveTime.low_value]
		  ,fqc.[questionnaireCycle.effectiveTime.high_value]
		  ,fqc.[questionnaireCycle.sampleInformation.samplingMethod_code]
		  ,fqc.[questionnaireCycle.sampleInformation.samplingMethod_codeSystem]
		  ,fqc.[questionnaireCycle.sampleInformation.populationInformation.dischargeCount]
		  ,fqc.[questionnaireCycle.sampleInformation.populationInformation.sampleSize]
		  ,fqc.[questionnaireCycle.sampleInformation.populationInformation.nonResponseCount]
	  FROM [CIHI].[Final_QuestionnaireCycle] fqc
	  WHERE fqc.submissionID = @ID
	  and fqc.[questionnaireCycle.healthCareFacility.id.value] = @FacilityNum


END

GO

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Role')
	drop procedure [CIHI].[Select_Final_Role]
GO

CREATE PROCEDURE [CIHI].[Select_Final_Role]
	@ID INT
AS
BEGIN


	SELECT [Final_RoleID]
	      ,[SubmissionID]
		  ,[Final_OrgProfileID]
		  ,[organizationProfile.role_code]
		  ,[organizationProfile.role_codeSystem]
	  FROM [CIHI].[Final_Role]
	  WHERE Final_OrgProfileID = @ID

END

GO


if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_Final_Stratum')
	drop procedure [CIHI].[Select_Final_Stratum]
GO

CREATE PROCEDURE [CIHI].[Select_Final_Stratum]
	@ID INT
AS
BEGIN


	SELECT [Final_StratumID]
		  ,[Final_QuestionnaireCycleID]
		  ,[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode]
		  ,[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumDescription]
		  ,[questionnaireCycle.sampleInformation.populationInformation.stratum.dischargeCount]
		  ,[questionnaireCycle.sampleInformation.populationInformation.stratum.sampleSize]
		  ,[questionnaireCycle.sampleInformation.populationInformation.stratum.nonResponseCount]
	  FROM [CIHI].[Final_Stratum]
	  WHERE Final_QuestionnaireCycleID = @ID


END

GO


if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'Select_All_By_SubmissionID')
	drop procedure [CIHI].[Select_All_By_SubmissionID]
GO

CREATE PROCEDURE [CIHI].[Select_All_By_SubmissionID]
	@ID INT
AS
BEGIN

	-- 0 MetaData
	SELECT [Final_MetadataID]
		  ,[submissionID]
		  ,[creationTime_value]
		  ,[sender.device.manufacturer.id.value]
		  ,[sender.organization.id.value]
		  ,[versionCode_code]
		  ,[versionCode_codeSystem]
		  ,[purpose_code]
		  ,[purpose_codeSystem]
	  FROM [CIHI].[Final_Metadata]
	  WHERE submissionID = @ID

	  -- 1 OrganizationProfile
	  SELECT [Final_OrgProfileID]
		  ,fop.[Final_MetadataID]
		  ,[organizationProfile.organization.id.value]
		  ,[organizationProfile.surveyingFrequency_code]
		  ,[organizationProfile.surveyingFrequency_codeSystem]
		  ,[organizationProfile.device.manufacturer.id.value]
	  FROM [CIHI].[Final_OrgProfile] fop
	  INNER JOIN [CIHI].[Final_Metadata] fm on fm.Final_MetadataID = fop.Final_MetadataID
	  WHERE fm.submissionID = @ID

	  -- 2 Contact
	  SELECT [Final_ContactID]
		  ,fc.[Final_OrgProfileID]
		  ,[organizationProfile.organization.contact.code_code]
		  ,[organizationProfile.organization.contact.code_codeSystem]
		  ,[organizationProfile.organization.contact.email]
		  ,[organizationProfile.organization.contact.name]
		  ,[organizationProfile.organization.contact.phone_extension]
		  ,[organizationProfile.organization.contact.phone_number]
	  FROM [CIHI].[Final_Contact] fc
	  INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.Final_OrgProfileID = fc.Final_OrgProfileID
	  INNER JOIN [CIHI].[Final_Metadata] fm on fm.Final_MetadataID = fop.Final_MetadataID
	  WHERE fm.submissionID = @ID


	  -- 3 Role
	  SELECT [Final_RoleID]
		  ,fr.[Final_OrgProfileID]
		  ,[organizationProfile.role_code]
		  ,[organizationProfile.role_codeSystem]
	  FROM [CIHI].[Final_Role] fr
	  INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.Final_OrgProfileID = fr.Final_OrgProfileID
	  INNER JOIN [CIHI].[Final_Metadata] fm on fm.Final_MetadataID = fop.Final_MetadataID
	  WHERE fm.submissionID = @ID


END

GO


