use qp_prod

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Metadata')
	DROP TABLE [CIHI].[Final_Metadata];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_OrgProfile')
	DROP TABLE [CIHI].[Final_OrgProfile];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Contact')
	DROP TABLE [CIHI].[Final_Contact];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Role')
	DROP TABLE [CIHI].[Final_Role];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_QuestionnaireCycle')
	DROP TABLE [CIHI].[Final_QuestionnaireCycle];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Stratum')
	DROP TABLE [CIHI].[Final_Stratum];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Questionnaire')
	DROP TABLE [CIHI].[Final_Questionnaire];

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Final_Question')
	DROP TABLE [CIHI].[Final_Question];
