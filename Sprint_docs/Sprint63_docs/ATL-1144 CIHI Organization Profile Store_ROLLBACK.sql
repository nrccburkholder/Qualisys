use qp_prod

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Submission')
	DROP TABLE [CIHI].[Submission];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionSurvey')
	DROP TABLE [CIHI].[SubmissionSurvey];

if exists (select * from sys.objects where schema_name(schema_id)='CIHI' and name = 'trg_CIHI_OrgProfile')
	DROP TRIGGER [CIHI].[trg_CIHI_OrgProfile] 

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'OrgProfile')
	DROP TABLE [CIHI].[OrgProfile];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'QA_QuestionnaireCycleAndStrata')
	DROP TABLE [CIHI].[QA_QuestionnaireCycleAndStrata];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'QA_Questionnaire')
	DROP TABLE [CIHI].[QA_Questionnaire];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'QA_Question')
	DROP TABLE [CIHI].[QA_Question];

if exists (select * from sys.schemas where name = 'CIHI')
	exec ('DROP SCHEMA CIHI');
