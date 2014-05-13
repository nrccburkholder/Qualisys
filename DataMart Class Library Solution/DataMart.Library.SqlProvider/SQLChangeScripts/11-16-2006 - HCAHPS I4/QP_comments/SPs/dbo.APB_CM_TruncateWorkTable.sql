SET ANSI_NULLS OFF
GO  

IF (ObjectProperty(Object_Id('dbo.APB_CM_TruncateWorkTable'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.APB_CM_TruncateWorkTable
GO

/*******************************************************************************
 *
 * Procedure Name:
 *           APB_CM_TruncateWorkTable
 *
 * Description:
 *           Truncate all the work tables
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.APB_CM_TruncateWorkTable
AS
  SET NOCOUNT ON

  TRUNCATE TABLE dbo.APB_wk_AllCriteriaTheme
  TRUNCATE TABLE dbo.APB_wk_ApBackgroundSelections
  TRUNCATE TABLE dbo.APB_wk_ApCorrelationDetail
  TRUNCATE TABLE dbo.APB_wk_ApGlobals
  TRUNCATE TABLE dbo.APB_wk_ApGroupDef
  TRUNCATE TABLE dbo.APB_wk_ApGroupUnits
  TRUNCATE TABLE dbo.APB_wk_ApJobList
  TRUNCATE TABLE dbo.APB_wk_ApPageCompDetail
  TRUNCATE TABLE dbo.APB_wk_ApPageCompDetailNarrative
  TRUNCATE TABLE dbo.APB_wk_ApPageCompMaster
  TRUNCATE TABLE dbo.APB_wk_ApPageCompMasterColumn
  TRUNCATE TABLE dbo.APB_wk_ApPageCompSection
  TRUNCATE TABLE dbo.APB_wk_ApPageDef
  TRUNCATE TABLE dbo.APB_wk_ApPeriod
  TRUNCATE TABLE dbo.APB_wk_ApResponseSubgroup
  TRUNCATE TABLE dbo.APB_wk_ApResponseSubset
  TRUNCATE TABLE dbo.APB_wk_ApSubsetDef
  TRUNCATE TABLE dbo.APB_wk_ApSubsetDetail
  TRUNCATE TABLE dbo.APB_wk_ApThemeQuestions
  TRUNCATE TABLE dbo.APB_wk_ApThemes
  TRUNCATE TABLE dbo.APB_wk_ApTrendInterval
  TRUNCATE TABLE dbo.APB_wk_ApUnits
  TRUNCATE TABLE dbo.APB_wk_Background
  TRUNCATE TABLE dbo.APB_wk_BarRanking
  TRUNCATE TABLE dbo.APB_wk_BarRankingColumn
  TRUNCATE TABLE dbo.APB_wk_BarRankingDetail
  TRUNCATE TABLE dbo.APB_wk_BarRankingQuestion
  TRUNCATE TABLE dbo.APB_wk_BarRankingRow
  TRUNCATE TABLE dbo.APB_wk_BoxPlot
  TRUNCATE TABLE dbo.APB_wk_BoxPlotColumn
  TRUNCATE TABLE dbo.APB_wk_BoxPlotDetail
  TRUNCATE TABLE dbo.APB_wk_BoxPlotQuestion
  TRUNCATE TABLE dbo.APB_wk_BRCheckResultNonProportion
  TRUNCATE TABLE dbo.APB_wk_BRCheckResultProportion
  TRUNCATE TABLE dbo.APB_wk_Breakout
  TRUNCATE TABLE dbo.APB_wk_BreakoutColumn
  TRUNCATE TABLE dbo.APB_wk_BreakoutDetail
  TRUNCATE TABLE dbo.APB_wk_BreakoutRow
  TRUNCATE TABLE dbo.APB_wk_CacheCriteriaCustomUnitComparison
  TRUNCATE TABLE dbo.APB_wk_Component
  TRUNCATE TABLE dbo.APB_wk_Criteria
  TRUNCATE TABLE dbo.APB_wk_CriteriaInUse
  TRUNCATE TABLE dbo.APB_wk_CurrentSurvey
  TRUNCATE TABLE dbo.APB_wk_CustomUnitBenchmark
  TRUNCATE TABLE dbo.APB_wk_CustomUnitBenchmarkDetail
  TRUNCATE TABLE dbo.APB_wk_CustomUnitBenchmarkPercentile
  TRUNCATE TABLE dbo.APB_wk_ExclusionRelatedCriteria
  TRUNCATE TABLE dbo.APB_wk_HBar
  TRUNCATE TABLE dbo.APB_wk_HBarColumn
  TRUNCATE TABLE dbo.APB_wk_HBarDetail
  TRUNCATE TABLE dbo.APB_wk_HBarRow
  TRUNCATE TABLE dbo.APB_wk_HSRanking
  TRUNCATE TABLE dbo.APB_wk_HSRankingColumn
  TRUNCATE TABLE dbo.APB_wk_HSRankingDetail
  TRUNCATE TABLE dbo.APB_wk_HSRankingRow
  TRUNCATE TABLE dbo.APB_wk_ItemCriteria
  TRUNCATE TABLE dbo.APB_wk_ItemCustomUnitBenchmark
  TRUNCATE TABLE dbo.APB_wk_ItemNorm
  TRUNCATE TABLE dbo.APB_wk_ItemSigTest1SampleTtest
  TRUNCATE TABLE dbo.APB_wk_ItemSigTestChiSquare
  TRUNCATE TABLE dbo.APB_wk_ItemSigTestProportionTest
  TRUNCATE TABLE dbo.APB_wk_ItemSigTestUnwgt2SampleTtest
  TRUNCATE TABLE dbo.APB_wk_ItemSigTestWgt2SampleTtest
  TRUNCATE TABLE dbo.APB_wk_ItemSigTestChiSquare
  TRUNCATE TABLE dbo.APB_wk_ItemStatCorrelationBiserial
  TRUNCATE TABLE dbo.APB_wk_ItemStatCorrelationPearson
  TRUNCATE TABLE dbo.APB_wk_ItemStatMean
  TRUNCATE TABLE dbo.APB_wk_ItemStatMeanBR
  TRUNCATE TABLE dbo.APB_wk_ItemStatNSizeAllPop
  TRUNCATE TABLE dbo.APB_wk_ItemStatNSizeAllPopBR
  TRUNCATE TABLE dbo.APB_wk_ItemStatNSizeAvgAllPop
  TRUNCATE TABLE dbo.APB_wk_ItemStatNSizeInSelectResponse
  TRUNCATE TABLE dbo.APB_wk_ItemStatNSizePropPop
  TRUNCATE TABLE dbo.APB_wk_ItemStatProportion
  TRUNCATE TABLE dbo.APB_wk_ItemStatProportionBR
  TRUNCATE TABLE dbo.APB_wk_ItemStatSD
  TRUNCATE TABLE dbo.APB_wk_ItemStatSDProp
  TRUNCATE TABLE dbo.APB_wk_ItemStatSDResponse
  TRUNCATE TABLE dbo.APB_wk_lu_Problem_Score
  TRUNCATE TABLE dbo.APB_wk_lu_question_recodes
  TRUNCATE TABLE dbo.APB_wk_Narrative
  TRUNCATE TABLE dbo.APB_wk_Norm
  TRUNCATE TABLE dbo.APB_wk_Norm_Benchmark
  TRUNCATE TABLE dbo.APB_wk_Norm_Percentile
  TRUNCATE TABLE dbo.APB_wk_NormConverted
  TRUNCATE TABLE dbo.APB_wk_NormQuestionGroup
  TRUNCATE TABLE dbo.APB_wk_NormWork
  TRUNCATE TABLE dbo.APB_wk_Period
  TRUNCATE TABLE dbo.APB_wk_PeriodQuarter
  TRUNCATE TABLE dbo.APB_wk_ProportionDetail
  TRUNCATE TABLE dbo.APB_wk_Quadrant
  TRUNCATE TABLE dbo.APB_wk_QuadrantDetail
  TRUNCATE TABLE dbo.APB_wk_Questions
  TRUNCATE TABLE dbo.APB_wk_QuestionScaleRanking
  TRUNCATE TABLE dbo.APB_wk_QuestionSetDef
  TRUNCATE TABLE dbo.APB_wk_QuestionSetDetail
  TRUNCATE TABLE dbo.APB_wk_Report
  TRUNCATE TABLE dbo.APB_wk_ResponseResultQuestion
  TRUNCATE TABLE dbo.APB_wk_ResponseResultSamplePop
  TRUNCATE TABLE dbo.APB_wk_ResponseResultSampleUnit
  TRUNCATE TABLE dbo.APB_wk_SampleUnit
  TRUNCATE TABLE dbo.APB_wk_SampleUnitGroupDef
  TRUNCATE TABLE dbo.APB_wk_SampleUnitGroupDetail
  TRUNCATE TABLE dbo.APB_wk_Scales
  TRUNCATE TABLE dbo.APB_wk_SigTest1SampleTtest
  TRUNCATE TABLE dbo.APB_wk_SigTestChiSquare
  TRUNCATE TABLE dbo.APB_wk_SigTestProportionTest
  TRUNCATE TABLE dbo.APB_wk_SigTestUnwgt2SampleTtest
  TRUNCATE TABLE dbo.APB_wk_SigTestWgt2SampleTtest
  TRUNCATE TABLE dbo.APB_wk_StatCorrelationBiserial
  TRUNCATE TABLE dbo.APB_wk_StatCorrelationPearson
  TRUNCATE TABLE dbo.APB_wk_StatMean
  TRUNCATE TABLE dbo.APB_wk_StatMeanBR
  TRUNCATE TABLE dbo.APB_wk_StatNSizeAllPop
  TRUNCATE TABLE dbo.APB_wk_StatNSizeAllPopBR
  TRUNCATE TABLE dbo.APB_wk_StatNSizeAvgAllPop
  TRUNCATE TABLE dbo.APB_wk_StatNSizeInSelectResponse
  TRUNCATE TABLE dbo.APB_wk_StatNSizePropPop
  TRUNCATE TABLE dbo.APB_wk_StatProportion
  TRUNCATE TABLE dbo.APB_wk_StatProportionBR
  TRUNCATE TABLE dbo.APB_wk_StatSD
  TRUNCATE TABLE dbo.APB_wk_StatSDProp
  TRUNCATE TABLE dbo.APB_wk_StatSDResponse
  TRUNCATE TABLE dbo.APB_wk_StudyQuarter
  TRUNCATE TABLE dbo.APB_wk_StudyResultMeanAggregate
  TRUNCATE TABLE dbo.APB_wk_StudyResultNSizeAggregate
  TRUNCATE TABLE dbo.APB_wk_StudyResultProportionAggregate
  TRUNCATE TABLE dbo.APB_wk_StudyThemeQuestion
  TRUNCATE TABLE dbo.APB_wk_TabRanking
  TRUNCATE TABLE dbo.APB_wk_TabRankingColumn
  TRUNCATE TABLE dbo.APB_wk_TabRankingDetail
  TRUNCATE TABLE dbo.APB_wk_TabRankingRow
  TRUNCATE TABLE dbo.APB_wk_TabRankingSection
  TRUNCATE TABLE dbo.APB_wk_ThemeApplicableQuestions
  TRUNCATE TABLE dbo.APB_wk_ThemeBenchmarkResult
  TRUNCATE TABLE dbo.APB_wk_ThemeMinQuestionGroupNum
  TRUNCATE TABLE dbo.APB_wk_Trend
  TRUNCATE TABLE dbo.APB_wk_TrendDetail
  TRUNCATE TABLE dbo.APB_wk_TrendInterval
  TRUNCATE TABLE dbo.APB_wk_TrendSeries
  TRUNCATE TABLE dbo.APB_wk_UncachedCriteriaTheme
  TRUNCATE TABLE dbo.APB_wk_VBar
  TRUNCATE TABLE dbo.APB_wk_VBarColumn
  TRUNCATE TABLE dbo.APB_wk_VBarDetail

  EXEC dbo.APB_CM_DropUserView 'APB_wk_Study_Results_Vertical_View'
  EXEC dbo.APB_CM_DropUserView 'APB_wk_Big_Table_View'
  
  EXEC dbo.APB_CM_DropUserTable 'APB_wk_Criteria4Dedup'
  EXEC dbo.APB_CM_DropUserTable 'APB_wk_StudyDataSetCriteria'
  EXEC dbo.APB_CM_DropUserTable 'APB_wk_QuestionValue'
  EXEC dbo.APB_CM_DropUserTable 'APB_wk_WeightCriteria'

  EXEC dbo.CM_DropTable 'dbo.APB_wk_StudyDataSet'
  EXEC dbo.CM_DropTable 'dbo.APB_wk_StudyDataSetNew'
  EXEC dbo.CM_DropTable 'dbo.APB_wk_FilterResult'
  EXEC dbo.CM_DropTable 'dbo.APB_wk_FilterResultNew'
  EXEC dbo.CM_DropTable 'dbo.APB_wk_StudyResult'
  EXEC dbo.CM_DropTable 'dbo.APB_wk_StudyResultAggregated'


  RETURN 0

GO