use qp_prod

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionMetadata')
	DROP TABLE [CIHI].[SubmissionMetadata];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionOrgProfile')
	DROP TABLE [CIHI].[SubmissionOrgProfile];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionContact')
	DROP TABLE [CIHI].[SubmissionContact];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionRole')
	DROP TABLE [CIHI].[SubmissionRole];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionQuestionnaireCycle')
	DROP TABLE [CIHI].[SubmissionQuestionnaireCycle];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionStratum')
	DROP TABLE [CIHI].[SubmissionStratum];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionQuestionnaire')
	DROP TABLE [CIHI].[SubmissionQuestionnaire];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'SubmissionQuestion')
	DROP TABLE [CIHI].[SubmissionQuestion];
