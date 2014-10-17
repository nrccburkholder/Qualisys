/*
Sprint8_UserStory12_ACO-8_ACO-12_QuestionnaireVersions

12.1	Build List of Questions for each version
12.2	Insert questions in to sub types table and survey type question mapping tables

Note:   This also has been updated to reflect the SV_CAHPS_FormQuestions change in production on 9/23/2014

Chris Burkholder

UPDATE [dbo].[SurveyTypeQuestionMappings]
ALTER TABLE [dbo].[SurveyTypeQuestionMappings]
ALTER TABLE [dbo].[SurveyTypeQuestionMappings] DROP/ADD  CONSTRAINT [PK_SurveyTypeQuestionMappings]
insert into SurveyTypeQuestionMappings 
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
*/

USE [QP_Prod]
GO

UPDATE [dbo].[SurveyTypeQuestionMappings] SET SubType_ID = 0 WHERE SubType_ID IS NULL

ALTER TABLE [dbo].[SurveyTypeQuestionMappings] ALTER COLUMN SubType_ID INTEGER NOT NULL

/****** Object:  Index [PK_SurveyTypeQuestionMappings]    Script Date: 9/12/2014 1:30:35 PM ******/
ALTER TABLE [dbo].[SurveyTypeQuestionMappings] DROP CONSTRAINT [PK_SurveyTypeQuestionMappings]
GO

/****** Object:  Index [PK_SurveyTypeQuestionMappings]    Script Date: 9/12/2014 1:30:35 PM ******/
ALTER TABLE [dbo].[SurveyTypeQuestionMappings] ADD  CONSTRAINT [PK_SurveyTypeQuestionMappings] PRIMARY KEY CLUSTERED 
(
	[SurveyType_id] ASC,
	[SubType_ID] ASC,
	[QstnCore] ASC,
	[bitExpanded] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO


IF NOT EXISTS(select 1 from dbo.subtype where Subtype_nm = 'ACO-8')
INSERT INTO [dbo].[Subtype]
           ([Subtype_nm]
           ,[SubtypeCategory_id]
           ,[bitRuleOverride])
     VALUES
           ('ACO-8'
           ,2
           ,0)

IF NOT EXISTS(select 1 from dbo.subtype where Subtype_nm = 'ACO-12')
INSERT INTO [dbo].[Subtype]
           ([Subtype_nm]
           ,[SubtypeCategory_id]
           ,[bitRuleOverride])
     VALUES
           ('ACO-12'
           ,2
           ,0)
GO

declare @ACO8 int 
select @ACO8 = subtype_id from subtype where Subtype_nm = 'ACO-8'

declare @ACO12 int 
select @ACO12 = subtype_id from subtype where Subtype_nm = 'ACO-12'

IF NOT EXISTS(select 1 from dbo.surveytypesubtype where surveytype_id = 10 and subtype_id = @ACO8)
INSERT INTO [dbo].[SurveyTypeSubtype]
           ([SurveyType_id]
           ,[Subtype_id])
     VALUES
           (10
           ,@ACO8)

IF NOT EXISTS(select 1 from dbo.surveytypesubtype where surveytype_id = 10 and subtype_id = @ACO12)
INSERT INTO [dbo].[SurveyTypeSubtype]
           ([SurveyType_id]
           ,[Subtype_id])
     VALUES
           (10
           ,@ACO12)


/*
Update SurveyTypeQuestionMappings 
set SubType_ID = null --@ACO8
--select * from SurveyTypeQuestionMappings
where surveytype_id = 10 

QstnCore in (50231,50232,50233)
and SubType_ID is null
*/



/*
insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12, intOrder, qstncore 
*/

--aco-12

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,1,	50175

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,2,	50176

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,3,	50177

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,4,	51426

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,5,	50179

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,6,	50180

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,7,	50181

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,8,	50182

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,9,	50183

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,10,	50184

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,11,	50185

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,12,	50186

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,13,	50187

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,14,	50188

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,15,	50189

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,16,	50190

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,17,	50191

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,18,	50192

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,19,	50193

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,20,	50194

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,21,	50195

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,22,	50196

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,23,	50197

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,24,	50198

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,25,	50199

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,26,	50200

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,27,	50201

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,28,	50202

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,29,	50203

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,30,	50204

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,31,	50205

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,32,	50206

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,33,	50207

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,34,	50208

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,35,	50209

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,36,	50210

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,37,	50211

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,38,	50212

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,39,	50213

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,40,	50214

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,41,	50215

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,42,	50216

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,43,	50217

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,44,	50218

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,45,	50219

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,46,	50220

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,47,	50221

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,48,	50222

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,49,	50223

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,50,	50224

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,51,	50225

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,52,	50226

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,53,	50227

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,54,	50228

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,55,	50229

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,56,	50230

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,57,	50234

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,58,	50235

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,59,	50236

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,60,	50237

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,61,	50238

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,62,	50239

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,63,	50240

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,64,	50241

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,65,	50699

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,66,	50243

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,67,	50700

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,68,	50245

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,69,	50246

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,70,	50247

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,71,	50248

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,72,	50249

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,73,	50250

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,74,	50251

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,75,	50252

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,76,	50253

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,77,	50254

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,78,	50255

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,79,	50725

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,80,	50726

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,81,	50727

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,82,	50728

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,83,	50729

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,84,	50730

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,85,	50731

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,86,	50732

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,87,	50733

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,88,	50734

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,89,	50735

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,90,	50736

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,91,	50737

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,92,	50738

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,93,	50739

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,94,	50740

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,95,	50256

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO12,96,	50744

/*

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, intOrder, qstncore 
*/

--ACO-8	

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 1,	50175

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 2,	50176

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 3,	50177

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 4,	51426

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 5,	50179

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 6,	50180

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 7,	50181

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 8,	50182

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 9,	50183

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 10,	50184

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 11,	50185

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 12,	50186

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 13,	50189

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 14,	50190

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 15,	50191

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 16,	50192

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 17,	50193

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 18,	50194

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 19,	50196

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 20,	50197

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 21,	50198

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 22,	50199

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 23,	50200

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 24,	50201

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 25,	50202

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 26,	50203

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 27,	50209

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 28,	50210

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 29,	50211

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 30,	50212

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 31,	50213

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 32,	50214

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 33,	50215

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 34,	50216

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 35,	50217

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 36,	50218

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 37,	50219

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 38,	50220

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 39,	50221

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 40,	50222

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 41,	50223

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 42,	50224

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 43,	50225

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 44,	50229

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 45,	50230

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 46,	50234

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 47,	50235

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 48,	50236

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 49,	50237

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 50,	50238

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 51,	50239

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 52,	50240

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 53,	50241

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 54,	50699

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 55,	50243

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 56,	50700

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 57,	50245

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 58,	50246

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 59,	50247

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 60,	50248

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 61,	50249

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 62,	50250

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 63,	50251

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 64,	50252

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 65,	50253

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 66,	50254

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 67,	50255

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 68,	50725

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 69,	50726

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 70,	50727

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 71,	50728

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 72,	50729

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 73,	50730

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 74,	50731

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 75,	50732

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 76,	50733

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 77,	50734

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 78,	50735

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 79,	50736

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 80,	50737

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 81,	50738

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 82,	50739

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 83,	50740

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 84,	50256

insert into SurveyTypeQuestionMappings (surveytype_id, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_ID, intOrder, qstncore)
select 10, 1, 0, '1900-01-01 00:00:00.000', '2999-12-31 00:00:00.000', @ACO8, 85,	50744


GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
	9/15/2014 -- CJB accommodated for SubType_id to be NOT NULL in temp table here.  Also adjusted clumsy logic based on SurveyType so 
				ACOCAHPS follows a path closer to PCMH 
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

DECLARE @questionnaireType_id int

-- get any associated subtype_id that is has questionnaire category type
select  @questionnaireType_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 2

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure all of the CAHPS questions are on the form and in the correct location.
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

	--Check for expanded questions
	--If they exist on survey, then pull question list that includes expanded questions (bitExpanded = 1)
	declare @bitExpanded int

	CREATE TABLE #CAHPS_SurveyTypeQuestionMappings(
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL,
	[SubType_id] [INT] NOT NULL)

	IF @surveyType_id in (@HCAHPS)
	BEGIN

		select @bitExpanded = isnull((select top 1 1 from #currentform where qstncore in (46863,46864,46865,46866,46867)),0) 

	--If active sample period is after 1/1/2013, then the survey should be using expanded questions (bitExpanded = 1)
	--**************************************************
	--** Code from QCL_SelectActivePeriodbySurveyId
	--**************************************************
		create table #periods (perioddef_id int, activeperiod bit)

		--Get a list of all periods for this survey
		INSERT INTO #periods (periodDef_id)
		SELECT periodDef_id
		FROM perioddef
		WHERE survey_id=@survey_id

		--Get a list of all periods that have not completed sampling
		SELECT distinct pd.PeriodDef_id
		INTO #temp
		FROM perioddef p, perioddates pd
		WHERE p.perioddef_id=pd.perioddef_id AND
				survey_id=@survey_id AND
	  			datsampleCREATE_dt is null

		--Find the active Period.  It is either a period that hasn't completed sampling
		--or a period that hasn't started but has the most recent first scheduled date
		--If no unfinished periods exist, set active period to the period with the most
		--recently completed sample

		IF EXISTS (SELECT top 1 *
					FROM #temp)
		BEGIN

			DECLARE @UnfinishedPeriod int

			SELECT @UnfinishedPeriod=pd.perioddef_id
			FROM perioddates pd, #temp t
			WHERE pd.perioddef_id=t.perioddef_id AND
		  			pd.samplenumber=1 AND
					pd.datsampleCREATE_dt is not null

			IF @UnfinishedPeriod is not null
			BEGIN
				--There is a period that is partially finished, so set it to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id = @UnfinishedPeriod
			END
			ELSE
			BEGIN
				--There is no period that is partially finished, so set the unstarted period
				--with the earliest scheduled sample date to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id =
					(SELECT top 1 pd.perioddef_id
					 FROM perioddates pd, #temp t
					 WHERE pd.perioddef_id=t.perioddef_id AND
				  			pd.samplenumber=1
					 ORDER BY datscheduledsample_dt)
			END
		END
		ELSE
		BEGIN
			--No unfinished periods exist, so we will set the active to be the most recently
			--finished
			UPDATE #periods
			SET ActivePeriod=1
			WHERE perioddef_id =
				(SELECT top 1 p.perioddef_id
				 FROM perioddates pd, perioddef p
				 WHERE p.survey_id=@survey_id AND
						pd.perioddef_id=p.perioddef_id
				 GROUP BY p.perioddef_id
				 ORDER BY Max(datsampleCREATE_dt) desc)
		END

		IF @surveyType_id in (@HCAHPS)
		BEGIN
			if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
				select @bitExpanded = 1 ---(HCAHPS specific)
		END

		drop table #periods
		drop table #temp

		--Create subset SurveyTypeQuestionMappings looking at only surveyType
		INSERT INTO #CAHPS_SurveyTypeQuestionMappings
		Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id 
		and bitExpanded = @bitExpanded

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id

		END

	END

	--Look for questions missing from the form.
/*	IF @surveyType_id IN (@ACOCAHPS)
	BEGIN

		DECLARE @cnt50715 INT
		DECLARE @cnt50255 INT

		SELECT
		 @cnt50715 = SUM( CASE s.QstnCore WHEN 50715 THEN 1 ELSE 0 END),
		 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL and s.QstnCore NOT IN (50715,50255)

	END
*/
	IF @surveyType_id IN (@HCAHPS)
	BEGIN

		DECLARE @cnt43350 INT
		DECLARE @cnt50860 INT
		SELECT
		 @cnt43350 = SUM( CASE s.QstnCore WHEN 43350 THEN 1 ELSE 0 END),
		 @cnt50860 = SUM( CASE s.QstnCore WHEN 50860 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		IF @cnt43350 = 0 AND @cnt50860 = 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both missing.  You must have either 43350 or 50860, but not both.')
		END
		IF @cnt43350 > 0 AND @cnt50860 > 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both assigned.  You must have either 43350 or 50860, but not both.')
		END

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		AND t.QstnCore IS NULL and s.QstnCore NOT IN (43350,50860)

	END

	IF @surveyType_id = @HHCAHPS
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END

	--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		and s.SubType_id = @questionnaireType_id
		AND t.QstnCore IS NULL

		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		and s.SubType_id = @questionnaireType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck 
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
		from #CAHPS_SurveyTypeQuestionMappings qm 
		INNER JOIN #CurrentForm t ON qm.SurveyType_id = @surveyType_id
		WHERE qm.SubType_id = @questionnaireType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END
	ELSE
	BEGIN
		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff

		from #CAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
		WHERE qm.SurveyType_id = @surveyType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END


	DECLARE @OrderDifference INT

	SELECT @OrderDifference=OrderDiff
	FROM #OrderCheck
	WHERE OverAllOrder=1

	INSERT INTO #M (Error, strMessage)
	SELECT 1,'QstnCore '+LTRIM(STR(a.QstnCore))+' is out of order on the form.' FROM
	(select QstnCore
	FROM #OrderCheck
	WHERE OrderDiff<>@OrderDifference) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where (b.QstnCore is null)

	DROP TABLE #OrderCheck
	
	DROP TABLE #CurrentForm

	IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
	BEGIN
	 INSERT INTO #M (Error, strMessage)
	 SELECT 0,'All ' + @SurveyTypeDescription + ' Questions are on the form in the correct order.'

	 --IF all cores or on the survey, then check that the questions are mapped
	 --in a manner that ensures someone sampled at the units will get all of them
	 SELECT sampleunit_id
	 into #CAHPSUnits
	 FROM SampleUnit su, SamplePlan sp
	 WHERE sp.Survey_id=@Survey_id
	 AND sp.SamplePlan_id=su.SamplePlan_id
	 AND CAHPSType_id = @surveyType_id

	 DECLARE @sampleunit_id int

	 SELECT TOP 1 @sampleunit_id=sampleunit_id
	 FROM #CAHPSUnits

	 WHILE @@rowcount>0
	 BEGIN

		INSERT INTO #M (Error, strMessage)
		 SELECT 1,'QstnCore '+LTRIM(STR(a.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'
		 from
		 (
		  SELECT stqm.QstnCore, intOrder
		  FROM
		  (
		   SELECT sq.Qstncore
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
			 AND sq.survey_id=su.selqstnssurvey_id
		  ) as Q  RIGHT JOIN #CAHPS_SurveyTypeQuestionMappings stqm
		  ON Q.QstnCore=stqm.QstnCore
		  WHERE stqm.SurveyType_id=@surveyType_id AND Q.QstnCore IS NULL
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%phone%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Phone'))
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%mail%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Mail'))
		  AND not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%dummy%') 
		 ) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

		  IF @@ROWCOUNT=0
		   INSERT INTO #M (Error, strMessage)
		   SELECT 0,'All Questions are mapped properly for Sampleunit ' + convert(varchar,@sampleunit_id)

		  DELETE
		  FROM #CAHPSUnits
		  WHERE sampleunit_Id=@sampleunit_id

		  SELECT TOP 1 @sampleunit_id=sampleunit_id
		  FROM #CAHPSUnits

	 END

	 DROP TABLE #CAHPSUnits
	 

	END
	--End of Question checking

	DROP TABLE #CAHPS_SurveyTypeQuestionMappings

ENDOFPROC:

SELECT * FROM #M

DROP TABLE #M


