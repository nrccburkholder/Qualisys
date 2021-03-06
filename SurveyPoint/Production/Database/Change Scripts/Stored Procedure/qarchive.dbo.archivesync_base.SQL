/****** Object:  StoredProcedure [dbo].[archivesync_base]    Script Date: 08/08/2006 13:53:12 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[archivesync_base]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[archivesync_base]
GO
/****** Object:  StoredProcedure [dbo].[archivesync_base]    Script Date: 08/08/2006 13:53:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[archivesync_base]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure archivesync_base (@mode int)
as
begin
exec AnswerCategories_pn @mode
exec AnswerCategoryTypes_pn @mode
exec CalculationTypes_pn @mode
exec Clients_pn @mode
exec ControlTypes_pn @mode
exec Criteria_pn @mode
exec CriteriaDataTypes_pn @mode
exec CriteriaPredefinedParameters_pn @mode
exec CriteriaTypes_pn @mode
exec DbFileSizeLog_pn @mode
exec Events_pn @mode
exec EventTypes_pn @mode
exec FileDefColumns_pn @mode
exec FileDefFilters_pn @mode
exec FileDefs_pn @mode
exec FileDefTypes_pn @mode
exec FileTypes_pn @mode
exec GHS_RiskFactors_pn @mode
exec GHS_RiskFactorTypes_pn @mode
exec ghs_SeniorHealthUniverseMetrics_pn @mode
exec Hours_pn @mode
exec LU_RISK_PERCENTILE_pn @mode
exec MapFileDefCols_pn @mode
exec OperationTypes_pn @mode
exec Processors_pn @mode
exec Properties_pn @mode
exec Protocols_pn @mode
exec ProtocolStepParameters_pn @mode
exec ProtocolSteps_pn @mode
exec ProtocolStepTypeEvents_pn @mode
exec ProtocolStepTypeParameters_pn @mode
exec ProtocolStepTypes_pn @mode
exec QuestionAnswerCategoryTypes_pn @mode
exec QuestionFolders_pn @mode
exec Questions_pn @mode
exec QuestionTypes_pn @mode
exec Quota_pn @mode
exec RespondentRiskScores_pn @mode
exec ScorePercentiles_pn @mode
exec ScriptedTriggers_pn @mode
exec Scripts_pn @mode
exec ScriptScreenCategories_pn @mode
exec ScriptScreens_pn @mode
exec ScriptTypes_pn @mode
exec SeniorHealthScores_pn @mode
exec SpecialDates_pn @mode
exec Sql2000DataTypes_pn @mode
exec States_pn @mode
exec SurveyInstanceCategories_pn @mode
exec SurveyInstanceDefaultScripts_pn @mode
exec SurveyInstanceEvents_pn @mode
exec SurveyInstanceProperties_pn @mode
exec SurveyInstanceProtocolSteps_pn @mode
exec SurveyInstances_pn @mode
exec SurveyQuestions_pn @mode
exec SurveyQuotaDefaults_pn @mode
exec Surveys_pn @mode
exec TriggerDependencies_pn @mode
exec Triggers_pn @mode
exec TriggerTypes_pn @mode
exec UserGroupPrivledges_pn @mode
exec UserGroups_pn @mode
exec Users_pn @mode
end
' 
END
GO
