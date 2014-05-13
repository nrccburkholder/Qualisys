SET ANSI_NULLS OFF
GO  

IF EXISTS (SELECT *
             FROM DBO.SYSOBJECTS
            WHERE ID = OBJECT_ID(N'dbo.APB_CM_Constant')
              AND XTYPE IN (N'FN', N'IF', N'TF')
          )
    DROP FUNCTION dbo.APB_CM_Constant
GO

/*******************************************************************************
 *
 * Function Name:
 *           APB_CM_Constant
 *
 * Description:
 *           Define all the constants used for batch program
 *
 * Parameters:
 *           @ConstantName
 *               Constant name
 *
 * Return:
 *           Constant value
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE FUNCTION dbo.APB_CM_Constant (
        @ConstantName     sysname
       ) RETURNS int
AS
BEGIN
  RETURN
         CASE @ConstantName
           -- 
           --   WHEN ''               THEN 
           
           -- Boolean
           WHEN 'YES'                                 THEN 1
           WHEN 'NO'                                  THEN 0
           
           -- Indent space
           WHEN 'INDENT'                              THEN 4

           -- Job Status
           WHEN 'JOB_QUEUED'                          THEN 1
           WHEN 'JOB_SCHEDULED'                       THEN 2
           WHEN 'JOB_WAITING'                         THEN 10
           WHEN 'JOB_PULLING_DATA'                    THEN 20
           WHEN 'JOB_DOING_STATISTIC'                 THEN 30
           WHEN 'JOB_OUTPUTTING_RESULT'               THEN 40
           WHEN 'JOB_PROCESSED'                       THEN 50
           WHEN 'JOB_GENERATING_PDF'                  THEN 510
           WHEN 'JOB_PDF_GENERATED'                   THEN 520
           WHEN 'JOB_ERR_PULL_DATA'                   THEN 1020
           WHEN 'JOB_ERR_DO_STATISTIC'                THEN 1030
           WHEN 'JOB_ERR_OUTPUT_RESULT'               THEN 1040
           WHEN 'JOB_GEN_FAILED'                      THEN 1510
           WHEN 'JOB_GEN_TIMEOUT'                     THEN 1511
           WHEN 'JOB_AP_NOT_EXIST'                    THEN 2001
           WHEN 'JOB_TEMPLATE_UNASSIGNED'             THEN 2002
           WHEN 'JOB_TEMPLATE_NOT_EXIST'              THEN 2003
           WHEN 'JOB_OTHER_ERROR'                     THEN 2999
           WHEN 'JOB_CANCELLED'                       THEN 5001
           WHEN 'JOB_PENDING'                         THEN 5002

           -- Mailing status
           WHEN 'MAIL_NOT_YET'                        THEN 1
           WHEN 'MAIL_WAITING'                        THEN 2
           WHEN 'MAIL_COMPLETED'                      THEN 3
           WHEN 'MAIL_FAILED'                         THEN 4

           -- Report generating types
           WHEN 'RPT_GEN_STAND'                       THEN 1
           WHEN 'RPT_GEN_MOCK'                        THEN 2

           -- Component types
           WHEN 'COMP_VBAR'                           THEN 1
           WHEN 'COMP_HBAR_MEASURE'                   THEN 2
           WHEN 'COMP_HBAR_STACK'                     THEN 3
           WHEN 'COMP_HBAR_BREAKOUT'                  THEN 4
           WHEN 'COMP_HBAR_RANK'                      THEN 5
           WHEN 'COMP_QUADRANT'                       THEN 6
           WHEN 'COMP_TREND'                          THEN 7
           WHEN 'COMP_NARRATIVE'                      THEN 8
           WHEN 'COMP_TAB_RANKING'                    THEN 9
           WHEN 'COMP_TAB_RANKING_TITLE'              THEN 10
           WHEN 'COMP_TAB_RANKING_SECTION'            THEN 11
           WHEN 'COMP_BOX_PLOT'                       THEN 12
           WHEN 'COMP_HEALTHSOUTH_RANKING'            THEN 13

           -- Comparison types
           WHEN 'CMP_TYPE_UNIT_BEST'                  THEN 1
           WHEN 'CMP_TYPE_CORRELATION'                THEN 2
           WHEN 'CMP_TYPE_STD_DEV'                    THEN 3
           WHEN 'CMP_TYPE_N_SIZE'                     THEN 4
           WHEN 'CMP_TYPE_UNIT_COMPARISON'            THEN 5
           WHEN 'CMP_TYPE_BOTTOM_2_BOX'               THEN 6
           WHEN 'CMP_TYPE_BOTTOM_BOX'                 THEN 7
           WHEN 'CMP_TYPE_THIRD_BOX'                  THEN 8
           WHEN 'CMP_TYPE_TOP_2_BOX'                  THEN 9
           WHEN 'CMP_TYPE_TOP_3_BOX'                  THEN 10
           WHEN 'CMP_TYPE_TOP_BOX'                    THEN 11
           WHEN 'CMP_TYPE_SECOND_BOX'                 THEN 12
           WHEN 'CMP_TYPE_UNIT_WORST'                 THEN 13
           WHEN 'CMP_TYPE_UNIT_PERCENTILE'            THEN 14
           WHEN 'CMP_TYPE_TOP_4_BOX'                  THEN 15
           WHEN 'CMP_TYPE_BOTTOM_4_BOX'               THEN 16
           WHEN 'CMP_TYPE_DISSATISFIED'               THEN 17
           WHEN 'CMP_TYPE_DELIGHTED'                  THEN 18

           -- Comparison clusters
           WHEN 'CMP_CLUSTER_ALIAS'                   THEN 1
           WHEN 'CMP_CLUSTER_CORRELATION'             THEN 2
           WHEN 'CMP_CLUSTER_NORM_AVG'                THEN 3
           WHEN 'CMP_CLUSTER_NORM_STD_PERCENTILE'     THEN 4
           WHEN 'CMP_CLUSTER_NORM_IND_PERCENTILE'     THEN 5
           WHEN 'CMP_CLUSTER_GROUPING'                THEN 6
           WHEN 'CMP_CLUSTER_NSIZE'                   THEN 7
           WHEN 'CMP_CLUSTER_UNIT_COMPARISON'         THEN 8
           WHEN 'CMP_CLUSTER_UNIT_BENCHMARK'          THEN 9
           WHEN 'CMP_CLUSTER_UNIT_PERCENTILE'         THEN 10
           WHEN 'CMP_CLUSTER_SD'                      THEN 11

           -- Measure types
           WHEN 'MEASURE_NONE'                        THEN 0
           WHEN 'MEASURE_MEAN'                        THEN 1
           WHEN 'MEASURE_PROPORTION'                  THEN 2
           WHEN 'MEASURE_N_SIZE'                      THEN 3
           WHEN 'MEASURE_STD_PERCENTILE'              THEN 4
           WHEN 'MEASURE_IND_PERCENTILE'              THEN 5
           
           -- Measure subtype
           WHEN 'MEASURE_SUBTYPE_NONE'                THEN 0
           
           -- Measure subtype: Mean
           WHEN 'MEAN_NONE'                           THEN 0

           -- Measure subtype: Proportion
           WHEN 'PROP_TYPE_NONE'                      THEN 0
           WHEN 'PROP_TYPE_BOTTOM_2_BOX'              THEN 6
           WHEN 'PROP_TYPE_BOTTOM_BOX'                THEN 7
           WHEN 'PROP_TYPE_THIRD_BOX'                 THEN 8
           WHEN 'PROP_TYPE_TOP_2_BOX'                 THEN 9
           WHEN 'PROP_TYPE_TOP_3_BOX'                 THEN 10
           WHEN 'PROP_TYPE_TOP_BOX'                   THEN 11
           WHEN 'PROP_TYPE_SECOND_BOX'                THEN 12
           WHEN 'PROP_TYPE_TOP_4_BOX'                 THEN 15
           WHEN 'PROP_TYPE_BOTTOM_4_BOX'              THEN 16
           WHEN 'PROP_TYPE_PROBLEM'                   THEN 998
           WHEN 'PROP_TYPE_POSITIVE'                  THEN 999
           WHEN 'PROP_TYPE_BREAKOUT'                  THEN 1000

           -- Measure subtype: Sample size
           WHEN 'NSIZE_UNWEIGHT_ALL_POP'              THEN 0
           
           -- Period types
           WHEN 'PERIOD_PREVIOUS'                     THEN 1
           WHEN 'PERIOD_CURRENT'                      THEN 2

           -- Previous period types
           WHEN 'PREVIOUS_PERIOD_PRIMARY'             THEN 1
           WHEN 'PREVIOUS_PERIOD_SECONDARY'           THEN 2
           
           -- Correlation coefficient methods
           WHEN 'CORR_CALCULATE'                      THEN 0
           WHEN 'CORR_SAVE'                           THEN 1
           WHEN 'CORR_APPLY'                          THEN 2
           
           -- Sort methods
           WHEN 'SORT_SCORE_ASCEND'                   THEN 1
           WHEN 'SORT_SCORE_DESCEND'                  THEN 2
           WHEN 'SORT_DIFF_FOR_HIGHER_SCORE'          THEN 3
           WHEN 'SORT_DIFF_FOR_LOWER_SCORE'           THEN 4
           WHEN 'SORT_HS_SIG_TEST_ASCEND'             THEN 5
           WHEN 'SORT_HS_FIRST_SCORE_ASCEND'          THEN 6
           WHEN 'SORT_HS_FIRST_SCORE_DESCEND'         THEN 7
           WHEN 'SORT_HS_UNIT_NAME'                   THEN 8
           WHEN 'SORT_CORRELATION'                    THEN 50
           WHEN 'SORT_QUESTION_SEQ_NUM'               THEN 51
           WHEN 'SORT_RANK_SCORE'                     THEN 60
           WHEN 'SORT_RANK_GROUP_NAME'                THEN 61
           WHEN 'SORT_BREAKOUT_SCALE_SEQ_NUM'         THEN 70
           WHEN 'SORT_UNIT_SEQ_NUM'                   THEN 71

           -- Column types for vbar, hbar, stack, breakout, ranking
           WHEN 'COLUMN_PREVIOUS'                     THEN 1
           WHEN 'COLUMN_CURRENT'                      THEN 2
           WHEN 'COLUMN_COMPARISON'                   THEN 3

           -- Data types
           WHEN 'DATA_TYPE_INTEGER'                   THEN 1
           WHEN 'DATA_TYPE_FLOAT'                     THEN 2
           WHEN 'DATA_TYPE_PERCENT'                   THEN 3

           -- Default value for null
           WHEN 'NULL_DEFAULT_VALUE'                  THEN -99999

           -- Business rules
           WHEN 'BR_MIN_NSIZE_IN_UNIT'                THEN 30
           WHEN 'BR_CUSTOM_UNIT_MIN_UNIT'             THEN 5
           WHEN 'BR_NORM_MIN_UNIT'                    THEN 10
           WHEN 'BR_MIN_CLIENT'                       THEN 2
/*
           WHEN 'BR_MIN_NSIZE_IN_UNIT'                THEN 2     --  (for test)
           WHEN 'BR_CUSTOM_UNIT_MIN_UNIT'             THEN 2     --  (for test)
           WHEN 'BR_NORM_MIN_UNIT'                    THEN 2     --  (for test)
           WHEN 'BR_MIN_CLIENT'                       THEN 1     --  (for test)
*/
           -- Norm types
           WHEN 'NORM_STANDARD_NORM'                  THEN 1
           WHEN 'NORM_TOP_N_PERCENT'                  THEN 2
           WHEN 'NORM_BOTTOM_N_PERCENT'               THEN 3
           WHEN 'NORM_IND_PERCENTILE'                 THEN 4
           WHEN 'NORM_STD_PERCENTILE'                 THEN 5
           WHEN 'NORM_BEST_NORM'                      THEN 6
           WHEN 'NORM_WORST_NORM'                     THEN 7
           WHEN 'NORM_IND_DECILE'                     THEN 8
        
           -- Norm categories
           WHEN 'NORM_CAT_STANDARD_NORM'              THEN 1
           WHEN 'NORM_CAT_QUESTION_BENCHMARK'         THEN 2
           WHEN 'NORM_CAT_THEME_BENCHMARK'            THEN 3

           -- Norm rating methods
           WHEN 'RATE_NONE'                           THEN 0
           WHEN 'RATE_TOP_N_PERCENT'                  THEN 1
           WHEN 'RATE_BOTTOM_N_PERCENT'               THEN 2
           WHEN 'RATE_PERCENTILE'                     THEN 3
           WHEN 'RATE_BEST'                           THEN 4
           WHEN 'RATE_WORST'                          THEN 5

           -- Response count types
           WHEN 'RESP_TOTAL'                          THEN 1
           WHEN 'RESP_GROUPING'                       THEN 2
           WHEN 'RESP_PROB_POS'                       THEN 3

           -- Business rule types
           WHEN 'BR_TYPE_NSIZE'                       THEN 1
           WHEN 'BR_TYPE_UNIT'                        THEN 2
           WHEN 'BR_TYPE_CLIENT'                      THEN 3

           -- Special Kaiser norm
           WHEN 'SPECIAL_KAISER_NORM_1'               THEN 1267
           WHEN 'SPECIAL_KAISER_NORM_2'               THEN 1268
           
           -- Significant test results
           WHEN 'SIGDIFF_LOWER'                       THEN 0
           WHEN 'SIGDIFF_HIGHER'                      THEN 1

           -- Correlation highlight settings
           WHEN 'HIGHLIGHT_NONE'                      THEN 0
           WHEN 'HIGHLIGHT_TOP_3_CORRELATION'         THEN 1
           WHEN 'HIGHLIGHT_HIGHER_THRESHOLD'          THEN 2

           -- Response Rate calculation algorithm
           WHEN 'RR_EXCLUDE_UNDERLIVERABLE'           THEN 1
           WHEN 'RR_INCLUDE_UNDERLIVERABLE'           THEN 2

           -- Y-Axis settings for quadrant
           WHEN 'QUAD_POSITIVE_Y_AXIS'                THEN 1
           WHEN 'QUAD_ALL_Y_AXIS'                     THEN 2

           -- Control trend chart type
           WHEN 'TREND_TYPE_X_BAR_S_CHART'            THEN 1
           WHEN 'TREND_TYPE_P_CHART'                  THEN 2

           -- Trend chart interval increment
           WHEN 'TREND_INTERVAL_YEAR'                 THEN 1
           WHEN 'TREND_INTERVAL_QUARTER'              THEN 2
           WHEN 'TREND_INTERVAL_MONTH'                THEN 3
           WHEN 'TREND_INTERVAL_WEEK'                 THEN 4
           WHEN 'TREND_INTERVAL_DAY'                  THEN 5

           -- Min sample size for showing control limits in trend chart
           WHEN 'TREND_MIN_NSIZE_X_BAR_S_CHART'       THEN 25
           WHEN 'TREND_MIN_NSIZE_P_CHART'             THEN 25

           -- Date styles
           WHEN 'DATE_STYLE_YEAR'                     THEN 1
           WHEN 'DATE_STYLE_QUARTER'                  THEN 2
           WHEN 'DATE_STYLE_MONTH'                    THEN 3
           WHEN 'DATE_STYLE_DAY'                      THEN 4

           -- Cache types
           WHEN 'CACHE_UNCACHEABLE'                   THEN 0
           WHEN 'CACHE_TO_BE_CACHED'                  THEN 1
           WHEN 'CACHE_EXIST_IN_CACHE'                THEN 2
           
           -- Tabular ranking periods
           WHEN 'TAB_RANK_PERIOD_CURRENT'             THEN 1
           WHEN 'TAB_RANK_PERIOD_PRIMARY_PREVIOUS'    THEN 2
           WHEN 'TAB_RANK_PERIOD_SECONDARY_PREVIOUS'  THEN 3
           
           -- HealthSouth ranking report column types
           WHEN 'HS_COLUMN_NSIZE'                     THEN 2
           WHEN 'HS_COLUMN_QUESTION'                  THEN 1

           -- HealthSouth ranking report row types
           WHEN 'HS_ROW_COMPARISON'                   THEN 2
           WHEN 'HS_ROW_CURRENT'                      THEN 1

           -- Correlation coefficient backup/restore
           WHEN 'CORR_CALCULATE'                      THEN 0
           WHEN 'CORR_BACKUP'                         THEN 1
           WHEN 'CORR_RESTORE'                        THEN 2

           -- Table categories
           WHEN 'TABLE_OTHER'                         THEN 1
           WHEN 'TABLE_APB_DEFINTION'                 THEN 2
           WHEN 'TABLE_APB_OUTPUT'                    THEN 3
           WHEN 'TABLE_APB_LOG'                       THEN 4
           
           -- Component item table
           WHEN 'COMP_TBL_NONE'                       THEN 0
           WHEN 'COMP_TBL_VBAR_DETAIL'                THEN 1
           WHEN 'COMP_TBL_HBAR_DETAIL'                THEN 2
           WHEN 'COMP_TBL_BREAKOUT_DETAIL'            THEN 3
           WHEN 'COMP_TBL_HBAR_RANKING_DETAIL'        THEN 4
           WHEN 'COMP_TBL_QUADRANT_DETAIL'            THEN 5
           WHEN 'COMP_TBL_TREND_DETAIL'               THEN 6
           WHEN 'COMP_TBL_TAB_RANKING_DETAIL'         THEN 7
           WHEN 'COMP_TBL_BOX_PLOT_DETAIL'            THEN 8
           WHEN 'COMP_TBL_HS_RANKING_DETAIL'          THEN 9
           WHEN 'COMP_TBL_UNIT_BENCHMARK'             THEN 10
           WHEN 'COMP_TBL_UNIT_BENCHMARK_DETAIL'      THEN 11

           END

END
GO


/*******************************************************************************

  DECLARE
      -- Boolean
      @YES                                  int,
      @NO                                   int,
      
      -- Indent space
      @INDENT                               int,
      
      -- Job Status
      @JOB_QUEUED                           int,
      @JOB_SCHEDULED                        int,
      @JOB_WAITING                          int,
      @JOB_PULLING_DATA                     int,
      @JOB_DOING_STATISTIC                  int,
      @JOB_OUTPUTTING_RESULT                int,
      @JOB_PROCESSED                        int,
      @JOB_GENERATING_PDF                   int,
      @JOB_PDF_GENERATED                    int,
      @JOB_ERR_PULL_DATA                    int,
      @JOB_ERR_DO_STATISTIC                 int,
      @JOB_ERR_OUTPUT_RESULT                int,
      @JOB_GEN_FAILED                       int,
      @JOB_GEN_TIMEOUT                      int,
      @JOB_AP_NOT_EXIST                     int,
      @JOB_TEMPLATE_UNASSIGNED              int,
      @JOB_TEMPLATE_NOT_EXIST               int,
      @JOB_OTHER_ERROR                      int,
      @JOB_CANCELLED                        int,
      @JOB_PENDING                          int,

      -- Mailing status
      @MAIL_NOT_YET                         int,
      @MAIL_WAITING                         int,
      @MAIL_COMPLETED                       int,
      @MAIL_FAILED                          int

      -- Report generating types
      @RPT_GEN_STAND                        int,
      @RPT_GEN_MOCK                         int,

      -- Component types
      @COMP_VBAR                            int,
      @COMP_HBAR_MEASURE                    int,
      @COMP_HBAR_STACK                      int,
      @COMP_HBAR_BREAKOUT                   int,
      @COMP_HBAR_RANK                       int,
      @COMP_QUADRANT                        int,
      @COMP_TREND                           int,
      @COMP_NARRATIVE                       int,
      @COMP_TAB_RANKING                     int,
      @COMP_TAB_RANKING_TITLE               int,
      @COMP_TAB_RANKING_SECTION             int,
      @COMP_BOX_PLOT                        int,
      @COMP_HEALTHSOUTH_RANKING             int,

      -- Comparison types
      @CMP_TYPE_UNIT_BEST                   int,
      @CMP_TYPE_CORRELATION                 int,
      @CMP_TYPE_STD_DEV                     int,
      @CMP_TYPE_N_SIZE                      int,
      @CMP_TYPE_UNIT_COMPARISON             int,
      @CMP_TYPE_BOTTOM_2_BOX                int,
      @CMP_TYPE_BOTTOM_BOX                  int,
      @CMP_TYPE_THIRD_BOX                   int,
      @CMP_TYPE_TOP_2_BOX                   int,
      @CMP_TYPE_TOP_3_BOX                   int,
      @CMP_TYPE_TOP_BOX                     int,
      @CMP_TYPE_SECOND_BOX                  int,
      @CMP_TYPE_UNIT_WORST                  int,
      @CMP_TYPE_UNIT_PERCENTILE             int,
      @CMP_TYPE_TOP_4_BOX                   int,
      @CMP_TYPE_BOTTOM_4_BOX                int,
      @CMP_TYPE_DISSATISFIED                int,
      @CMP_TYPE_DELIGHTED                   int,

      -- Comparison clusters
      @CMP_CLUSTER_ALIAS                    int,
      @CMP_CLUSTER_CORRELATION              int,
      @CMP_CLUSTER_NORM_AVG                 int,
      @CMP_CLUSTER_NORM_STD_PERCENTILE      int,
      @CMP_CLUSTER_NORM_IND_PERCENTILE      int,
      @CMP_CLUSTER_GROUPING                 int,
      @CMP_CLUSTER_NSIZE                    int,
      @CMP_CLUSTER_UNIT_COMPARISON          int,
      @CMP_CLUSTER_UNIT_BENCHMARK           int,
      @CMP_CLUSTER_UNIT_PERCENTILE          int,
      @CMP_CLUSTER_SD                       int,

      -- Measure types
      @MEASURE_NONE                         int,
      @MEASURE_MEAN                         int,
      @MEASURE_PROPORTION                   int,
      @MEASURE_N_SIZE                       int,
      @MEASURE_STD_PERCENTILE               int,
      @MEASURE_IND_PERCENTILE               int,

      -- Measure subtype
      @MEASURE_SUBTYPE_NONE                 int,
      
      -- Measure subtype: Mean
      @MEAN_NONE                            int,

      -- Measure subtype: Proportion
      @PROP_TYPE_NONE                       int,
      @PROP_TYPE_PROBLEM                    int,
      @PROP_TYPE_POSITIVE                   int,
      @PROP_TYPE_TOP_BOX                    int,
      @PROP_TYPE_TOP_2_BOX                  int,
      @PROP_TYPE_TOP_3_BOX                  int,
      @PROP_TYPE_TOP_4_BOX                  int,
      @PROP_TYPE_BOTTOM_BOX                 int,
      @PROP_TYPE_BOTTOM_2_BOX               int,
      @PROP_TYPE_BOTTOM_4_BOX               int,
      @PROP_TYPE_SECOND_BOX                 int,
      @PROP_TYPE_THIRD_BOX                  int,
      @PROP_TYPE_BREAKOUT                   int,
      
      -- Measure subtype: Sample size
      @NSIZE_UNWEIGHT_ALL_POP               int,

      -- Period types
      @PERIOD_PREVIOUS                      int,
      @PERIOD_CURRENT                       int,
       
      -- Previous period types
      @PREVIOUS_PERIOD_PRIMARY              int,
      @PREVIOUS_PERIOD_SECONDARY            int,

      -- Correlation coefficient methods
      @CORR_CALCULATE                       int,
      @CORR_SAVE                            int,
      @CORR_APPLY                           int,

      -- Sort methods
      @SORT_SCORE_ASCEND                    int,
      @SORT_SCORE_DESCEND                   int,
      @SORT_DIFF_FOR_HIGHER_SCORE           int,
      @SORT_DIFF_FOR_LOWER_SCORE            int,
      @SORT_HS_SIG_TEST_ASCEND              int,
      @SORT_HS_FIRST_SCORE_ASCEND           int,
      @SORT_HS_FIRST_SCORE_DESCEND          int,
      @SORT_HS_UNIT_NAME                    int,
      @SORT_CORRELATION                     int,
      @SORT_QUESTION_SEQ_NUM                int,
      @SORT_RANK_SCORE                      int,
      @SORT_RANK_GROUP_NAME                 int,
      @SORT_BREAKOUT_SCALE_SEQ_NUM          int,
      @SORT_UNIT_SEQ_NUM                    int,

      -- Column types for vbar, hbar, stack, breakout, ranking
      @COLUMN_PREVIOUS                      int,
      @COLUMN_CURRENT                       int,
      @COLUMN_COMPARISON                    int,

      -- Data types
      @DATA_TYPE_INTEGER                    int,
      @DATA_TYPE_FLOAT                      int,
      @DATA_TYPE_PERCENT                    int,

      -- Default value for null
      @NULL_DEFAULT_VALUE                   int,

      -- Business rules
      @BR_MIN_NSIZE_IN_UNIT                 int,
      @BR_CUSTOM_UNIT_MIN_UNIT              int,
      @BR_NORM_MIN_UNIT                     int,
      @BR_MIN_CLIENT                        int,

      -- Norm types
      @NORM_STANDARD_NORM                   int,
      @NORM_TOP_N_PERCENT                   int,
      @NORM_BOTTOM_N_PERCENT                int,
      @NORM_IND_PERCENTILE                  int,
      @NORM_STD_PERCENTILE                  int,
      @NORM_BEST_NORM                       int,
      @NORM_WORST_NORM                      int,
      @NORM_IND_DECILE                      int,

      -- Norm categories
      @NORM_CAT_STANDARD_NORM               int,
      @NORM_CAT_QUESTION_BENCHMARK          int,
      @NORM_CAT_THEME_BENCHMARK             int,

      -- Norm rating methods
      @RATE_NONE                            int,
      @RATE_TOP_N_PERCENT                   int,
      @RATE_BOTTOM_N_PERCENT                int,
      @RATE_PERCENTILE                      int,
      @RATE_BEST                            int,
      @RATE_WORST                           int,

      -- Response count types
      @RESP_TOTAL                           int,
      @RESP_GROUPING                        int,
      @RESP_PROB_POS                        int,

      -- Business rule types
      @BR_TYPE_NSIZE                        int,
      @BR_TYPE_UNIT                         int,
      @BR_TYPE_CLIENT                       int,

      -- Special Kaiser norm
      @SPECIAL_KAISER_NORM_1                int,
      @SPECIAL_KAISER_NORM_2                int,

      -- Significant test results
      @SIGDIFF_LOWER                        int,
      @SIGDIFF_HIGHER                       int,

      -- Correlation highlight settings
      @HIGHLIGHT_NONE                       int,
      @HIGHLIGHT_TOP_3_CORRELATION          int,
      @HIGHLIGHT_HIGHER_THRESHOLD           int,

      -- Response Rate calculation algorithm
      @RR_EXCLUDE_UNDERLIVERABLE            int,
      @RR_INCLUDE_UNDERLIVERABLE            int,

      -- Y-Axis settings for quadrant
      @QUAD_POSITIVE_Y_AXIS                 int,
      @QUAD_ALL_Y_AXIS                      int,

      -- Control trend chart type
      @TREND_TYPE_X_BAR_S_CHART             int,
      @TREND_TYPE_P_CHART                   int,

      -- Trend chart interval increment
      @TREND_INTERVAL_YEAR                  int,
      @TREND_INTERVAL_QUARTER               int,
      @TREND_INTERVAL_MONTH                 int,
      @TREND_INTERVAL_WEEK                  int,
      @TREND_INTERVAL_DAY                   int,

      -- Min sample size for showing control limits in trend chart
      @TREND_MIN_NSIZE_X_BAR_S_CHART        int,
      @TREND_MIN_NSIZE_P_CHART              int,

      -- Date styles
      @DATE_STYLE_YEAR                      int,
      @DATE_STYLE_QUARTER                   int,
      @DATE_STYLE_MONTH                     int,
      @DATE_STYLE_DAY                       int,

      -- Cache types
      @CACHE_UNCACHEABLE                    int,
      @CACHE_TO_BE_CACHED                   int,
      @CACHE_EXIST_IN_CACHE                 int,

      -- Tabular ranking periods
      @TAB_RANK_PERIOD_CURRENT              int,
      @TAB_RANK_PERIOD_PRIMARY_PREVIOUS     int,
      @TAB_RANK_PERIOD_SECONDARY_PREVIOUS   int,

      -- HealthSouth ranking report column types
      @HS_COLUMN_NSIZE                      int,
      @HS_COLUMN_QUESTION                   int,

      -- HealthSouth ranking report row types
      @HS_ROW_COMPARISON                    int,
      @HS_ROW_CURRENT                       int,

      -- Correlation coefficient backup/restore
      @CORR_CALCULATE                       int,
      @CORR_BACKUP                          int,
      @CORR_RESTORE                         int,

      -- Table categories
      @TABLE_OTHER                          int,
      @TABLE_APB_DEFINTION                  int,
      @TABLE_APB_OUTPUT                     int,
      @TABLE_APB_LOG                        int,

      -- Component item table
      @COMP_TBL_NONE                        int,
      @COMP_TBL_VBAR_DETAIL                 int,
      @COMP_TBL_HBAR_DETAIL                 int,
      @COMP_TBL_BREAKOUT_DETAIL             int,
      @COMP_TBL_HBAR_RANKING_DETAIL         int,
      @COMP_TBL_QUADRANT_DETAIL             int,
      @COMP_TBL_TREND_DETAIL                int,
      @COMP_TBL_TAB_RANKING_DETAIL          int,
      @COMP_TBL_BOX_PLOT_DETAIL             int,
      @COMP_TBL_HS_RANKING_DETAIL           int,
      @COMP_TBL_UNIT_BENCHMARK              int,
      @COMP_TBL_UNIT_BENCHMARK_DETAIL       int,


*******************************************************************************


  -- Boolean
  SET @YES                                  = dbo.APB_CM_Constant('YES')
  SET @NO                                   = dbo.APB_CM_Constant('NO')

  -- Indent space
  SET @INDENT                               = dbo.APB_CM_Constant('INDENT')

  -- Job Status
  SET @JOB_QUEUED                           = dbo.APB_CM_Constant('JOB_QUEUED')
  SET @JOB_SCHEDULED                        = dbo.APB_CM_Constant('JOB_SCHEDULED')
  SET @JOB_WAITING                          = dbo.APB_CM_Constant('JOB_WAITING')
  SET @JOB_PULLING_DATA                     = dbo.APB_CM_Constant('JOB_PULLING_DATA')
  SET @JOB_DOING_STATISTIC                  = dbo.APB_CM_Constant('JOB_DOING_STATISTIC')
  SET @JOB_OUTPUTTING_RESULT                = dbo.APB_CM_Constant('JOB_OUTPUTTING_RESULT')
  SET @JOB_PROCESSED                        = dbo.APB_CM_Constant('JOB_PROCESSED')
  SET @JOB_GENERATING_PDF                   = dbo.APB_CM_Constant('JOB_GENERATING_PDF')
  SET @JOB_PDF_GENERATED                    = dbo.APB_CM_Constant('JOB_PDF_GENERATED')
  SET @JOB_ERR_PULL_DATA                    = dbo.APB_CM_Constant('JOB_ERR_PULL_DATA')
  SET @JOB_ERR_DO_STATISTIC                 = dbo.APB_CM_Constant('JOB_ERR_DO_STATISTIC')
  SET @JOB_ERR_OUTPUT_RESULT                = dbo.APB_CM_Constant('JOB_ERR_OUTPUT_RESULT')
  SET @JOB_GEN_FAILED                       = dbo.APB_CM_Constant('JOB_GEN_FAILED')
  SET @JOB_GEN_TIMEOUT                      = dbo.APB_CM_Constant('JOB_GEN_TIMEOUT')
  SET @JOB_AP_NOT_EXIST                     = dbo.APB_CM_Constant('JOB_AP_NOT_EXIST')
  SET @JOB_TEMPLATE_UNASSIGNED              = dbo.APB_CM_Constant('JOB_TEMPLATE_UNASSIGNED')
  SET @JOB_TEMPLATE_NOT_EXIST               = dbo.APB_CM_Constant('JOB_TEMPLATE_NOT_EXIST')
  SET @JOB_OTHER_ERROR                      = dbo.APB_CM_Constant('JOB_OTHER_ERROR')
  SET @JOB_CANCELLED                        = dbo.APB_CM_Constant('JOB_CANCELLED')
  SET @JOB_PENDING                          = dbo.APB_CM_Constant('JOB_PENDING')
  
  -- Mailing Status
  SET @MAIL_NOT_YET                         = dbo.APB_CM_Constant('MAIL_NOT_YET')
  SET @MAIL_WAITING                         = dbo.APB_CM_Constant('MAIL_WAITING')
  SET @MAIL_COMPLETED                       = dbo.APB_CM_Constant('MAIL_COMPLETED')
  SET @MAIL_FAILED                          = dbo.APB_CM_Constant('MAIL_FAILED')

  -- Report generating types
  SET @RPT_GEN_STAND                        = dbo.APB_CM_Constant('RPT_GEN_STAND')
  SET @RPT_GEN_MOCK                         = dbo.APB_CM_Constant('RPT_GEN_MOCK')

  -- Component types
  SET @COMP_VBAR                            = dbo.APB_CM_Constant('COMP_VBAR')
  SET @COMP_HBAR_MEASURE                    = dbo.APB_CM_Constant('COMP_HBAR_MEASURE')
  SET @COMP_HBAR_STACK                      = dbo.APB_CM_Constant('COMP_HBAR_STACK')
  SET @COMP_HBAR_BREAKOUT                   = dbo.APB_CM_Constant('COMP_HBAR_BREAKOUT')
  SET @COMP_HBAR_RANK                       = dbo.APB_CM_Constant('COMP_HBAR_RANK')
  SET @COMP_QUADRANT                        = dbo.APB_CM_Constant('COMP_QUADRANT')
  SET @COMP_TREND                           = dbo.APB_CM_Constant('COMP_TREND')
  SET @COMP_NARRATIVE                       = dbo.APB_CM_Constant('COMP_NARRATIVE')
  SET @COMP_TAB_RANKING                     = dbo.APB_CM_Constant('COMP_TAB_RANKING')
  SET @COMP_TAB_RANKING_TITLE               = dbo.APB_CM_Constant('COMP_TAB_RANKING_TITLE')
  SET @COMP_TAB_RANKING_SECTION             = dbo.APB_CM_Constant('COMP_TAB_RANKING_SECTION')
  SET @COMP_BOX_PLOT                        = dbo.APB_CM_Constant('COMP_BOX_PLOT')
  SET @COMP_HEALTHSOUTH_RANKING             = dbo.APB_CM_Constant('COMP_HEALTHSOUTH_RANKING')

  -- Comparison types
  SET @CMP_TYPE_UNIT_BEST                   = dbo.APB_CM_Constant('CMP_TYPE_UNIT_BEST')
  SET @CMP_TYPE_CORRELATION                 = dbo.APB_CM_Constant('CMP_TYPE_CORRELATION')
  SET @CMP_TYPE_STD_DEV                     = dbo.APB_CM_Constant('CMP_TYPE_STD_DEV')
  SET @CMP_TYPE_N_SIZE                      = dbo.APB_CM_Constant('CMP_TYPE_N_SIZE')
  SET @CMP_TYPE_UNIT_COMPARISON             = dbo.APB_CM_Constant('CMP_TYPE_UNIT_COMPARISON')
  SET @CMP_TYPE_BOTTOM_2_BOX                = dbo.APB_CM_Constant('CMP_TYPE_BOTTOM_2_BOX')
  SET @CMP_TYPE_BOTTOM_BOX                  = dbo.APB_CM_Constant('CMP_TYPE_BOTTOM_BOX')
  SET @CMP_TYPE_THIRD_BOX                   = dbo.APB_CM_Constant('CMP_TYPE_THIRD_BOX')
  SET @CMP_TYPE_TOP_2_BOX                   = dbo.APB_CM_Constant('CMP_TYPE_TOP_2_BOX')
  SET @CMP_TYPE_TOP_3_BOX                   = dbo.APB_CM_Constant('CMP_TYPE_TOP_3_BOX')
  SET @CMP_TYPE_TOP_BOX                     = dbo.APB_CM_Constant('CMP_TYPE_TOP_BOX')
  SET @CMP_TYPE_SECOND_BOX                  = dbo.APB_CM_Constant('CMP_TYPE_SECOND_BOX')
  SET @CMP_TYPE_UNIT_WORST                  = dbo.APB_CM_Constant('CMP_TYPE_UNIT_WORST')
  SET @CMP_TYPE_UNIT_PERCENTILE             = dbo.APB_CM_Constant('CMP_TYPE_UNIT_PERCENTILE')
  SET @CMP_TYPE_TOP_4_BOX                   = dbo.APB_CM_Constant('CMP_TYPE_TOP_4_BOX')
  SET @CMP_TYPE_BOTTOM_4_BOX                = dbo.APB_CM_Constant('CMP_TYPE_BOTTOM_4_BOX')
  SET @CMP_TYPE_DISSATISFIED                = dbo.APB_CM_Constant('CMP_TYPE_DISSATISFIED')
  SET @CMP_TYPE_DELIGHTED                   = dbo.APB_CM_Constant('CMP_TYPE_DELIGHTED')

  -- Comparison clusters
  SET @CMP_CLUSTER_ALIAS                    = dbo.APB_CM_Constant('CMP_CLUSTER_ALIAS')
  SET @CMP_CLUSTER_CORRELATION              = dbo.APB_CM_Constant('CMP_CLUSTER_CORRELATION')
  SET @CMP_CLUSTER_NORM_AVG                 = dbo.APB_CM_Constant('CMP_CLUSTER_NORM_AVG')
  SET @CMP_CLUSTER_NORM_STD_PERCENTILE      = dbo.APB_CM_Constant('CMP_CLUSTER_NORM_STD_PERCENTILE')
  SET @CMP_CLUSTER_NORM_IND_PERCENTILE      = dbo.APB_CM_Constant('CMP_CLUSTER_NORM_IND_PERCENTILE')
  SET @CMP_CLUSTER_GROUPING                 = dbo.APB_CM_Constant('CMP_CLUSTER_GROUPING')
  SET @CMP_CLUSTER_NSIZE                    = dbo.APB_CM_Constant('CMP_CLUSTER_NSIZE')
  SET @CMP_CLUSTER_UNIT_COMPARISON          = dbo.APB_CM_Constant('CMP_CLUSTER_UNIT_COMPARISON')
  SET @CMP_CLUSTER_UNIT_BENCHMARK           = dbo.APB_CM_Constant('CMP_CLUSTER_UNIT_BENCHMARK')
  SET @CMP_CLUSTER_UNIT_PERCENTILE          = dbo.APB_CM_Constant('CMP_CLUSTER_UNIT_PERCENTILE')
  SET @CMP_CLUSTER_SD                       = dbo.APB_CM_Constant('CMP_CLUSTER_SD')

  -- Measure types
  SET @MEASURE_NONE                         = dbo.APB_CM_Constant('MEASURE_NONE')
  SET @MEASURE_MEAN                         = dbo.APB_CM_Constant('MEASURE_MEAN')
  SET @MEASURE_PROPORTION                   = dbo.APB_CM_Constant('MEASURE_PROPORTION')
  SET @MEASURE_N_SIZE                       = dbo.APB_CM_Constant('MEASURE_N_SIZE')
  SET @MEASURE_STD_PERCENTILE               = dbo.APB_CM_Constant('MEASURE_STD_PERCENTILE')
  SET @MEASURE_IND_PERCENTILE               = dbo.APB_CM_Constant('MEASURE_IND_PERCENTILE')

  -- Measure subtype
  SET @MEASURE_SUBTYPE_NONE                 = dbo.APB_CM_Constant('MEASURE_SUBTYPE_NONE')
  
  -- Measure subtype: Mean
  SET @MEAN_NONE                            = dbo.APB_CM_Constant('MEAN_NONE')

  -- Measure subtype: Proportion
  SET @PROP_TYPE_NONE                       = dbo.APB_CM_Constant('PROP_TYPE_NONE')
  SET @PROP_TYPE_PROBLEM                    = dbo.APB_CM_Constant('PROP_TYPE_PROBLEM')
  SET @PROP_TYPE_POSITIVE                   = dbo.APB_CM_Constant('PROP_TYPE_POSITIVE')
  SET @PROP_TYPE_TOP_BOX                    = dbo.APB_CM_Constant('PROP_TYPE_TOP_BOX')
  SET @PROP_TYPE_TOP_2_BOX                  = dbo.APB_CM_Constant('PROP_TYPE_TOP_2_BOX')
  SET @PROP_TYPE_TOP_3_BOX                  = dbo.APB_CM_Constant('PROP_TYPE_TOP_3_BOX')
  SET @PROP_TYPE_TOP_4_BOX                  = dbo.APB_CM_Constant('PROP_TYPE_TOP_4_BOX')
  SET @PROP_TYPE_BOTTOM_BOX                 = dbo.APB_CM_Constant('PROP_TYPE_BOTTOM_BOX')
  SET @PROP_TYPE_BOTTOM_2_BOX               = dbo.APB_CM_Constant('PROP_TYPE_BOTTOM_2_BOX')
  SET @PROP_TYPE_BOTTOM_4_BOX               = dbo.APB_CM_Constant('PROP_TYPE_BOTTOM_4_BOX')
  SET @PROP_TYPE_SECOND_BOX                 = dbo.APB_CM_Constant('PROP_TYPE_SECOND_BOX')
  SET @PROP_TYPE_THIRD_BOX                  = dbo.APB_CM_Constant('PROP_TYPE_THIRD_BOX')
  SET @PROP_TYPE_BREAKOUT                   = dbo.APB_CM_Constant('PROP_TYPE_BREAKOUT')

  -- Measure subtype: Sample size
  SET @NSIZE_UNWEIGHT_ALL_POP               = dbo.APB_CM_Constant('NSIZE_UNWEIGHT_ALL_POP')

  -- Period types
  SET @PERIOD_PREVIOUS                      = dbo.APB_CM_Constant('PERIOD_PREVIOUS')
  SET @PERIOD_CURRENT                       = dbo.APB_CM_Constant('PERIOD_CURRENT')

  -- Previous period types
  SET @PREVIOUS_PERIOD_PRIMARY              = dbo.APB_CM_Constant('PREVIOUS_PERIOD_PRIMARY')
  SET @PREVIOUS_PERIOD_SECONDARY            = dbo.APB_CM_Constant('PREVIOUS_PERIOD_SECONDARY')

  -- Correlation coefficient methods
  SET @CORR_CALCULATE                       = dbo.APB_CM_Constant('CORR_CALCULATE')
  SET @CORR_SAVE                            = dbo.APB_CM_Constant('CORR_SAVE')
  SET @CORR_APPLY                           = dbo.APB_CM_Constant('CORR_APPLY')

  -- Sort methods
  SET @SORT_SCORE_ASCEND                    = dbo.APB_CM_Constant('SORT_SCORE_ASCEND')
  SET @SORT_SCORE_DESCEND                   = dbo.APB_CM_Constant('SORT_SCORE_DESCEND')
  SET @SORT_DIFF_FOR_HIGHER_SCORE           = dbo.APB_CM_Constant('SORT_DIFF_FOR_HIGHER_SCORE')
  SET @SORT_DIFF_FOR_LOWER_SCORE            = dbo.APB_CM_Constant('SORT_DIFF_FOR_LOWER_SCORE')
  SET @SORT_HS_SIG_TEST_ASCEND              = dbo.APB_CM_Constant('SORT_HS_SIG_TEST_ASCEND')
  SET @SORT_HS_FIRST_SCORE_ASCEND           = dbo.APB_CM_Constant('SORT_HS_FIRST_SCORE_ASCEND')
  SET @SORT_HS_FIRST_SCORE_DESCEND          = dbo.APB_CM_Constant('SORT_HS_FIRST_SCORE_DESCEND')
  SET @SORT_HS_UNIT_NAME                    = dbo.APB_CM_Constant('SORT_HS_UNIT_NAME')
  SET @SORT_CORRELATION                     = dbo.APB_CM_Constant('SORT_CORRELATION')
  SET @SORT_QUESTION_SEQ_NUM                = dbo.APB_CM_Constant('SORT_QUESTION_SEQ_NUM')
  SET @SORT_RANK_SCORE                      = dbo.APB_CM_Constant('SORT_RANK_SCORE')
  SET @SORT_RANK_GROUP_NAME                 = dbo.APB_CM_Constant('SORT_RANK_GROUP_NAME')
  SET @SORT_BREAKOUT_SCALE_SEQ_NUM          = dbo.APB_CM_Constant('SORT_BREAKOUT_SCALE_SEQ_NUM')
  SET @SORT_UNIT_SEQ_NUM                    = dbo.APB_CM_Constant('SORT_UNIT_SEQ_NUM')
  
  -- Column types for vbar, hbar, stack, breakout, ranking
  SET @COLUMN_PREVIOUS                      = dbo.APB_CM_Constant('COLUMN_PREVIOUS')
  SET @COLUMN_CURRENT                       = dbo.APB_CM_Constant('COLUMN_CURRENT')
  SET @COLUMN_COMPARISON                    = dbo.APB_CM_Constant('COLUMN_COMPARISON')

  -- Data types
  SET @DATA_TYPE_INTEGER                    = dbo.APB_CM_Constant('DATA_TYPE_INTEGER')
  SET @DATA_TYPE_FLOAT                      = dbo.APB_CM_Constant('DATA_TYPE_FLOAT')
  SET @DATA_TYPE_PERCENT                    = dbo.APB_CM_Constant('DATA_TYPE_PERCENT')

  -- Default value for null
  SET @NULL_DEFAULT_VALUE                   = dbo.APB_CM_Constant('NULL_DEFAULT_VALUE')

  -- Business rules
  SET @BR_MIN_NSIZE_IN_UNIT                 = dbo.APB_CM_Constant('BR_MIN_NSIZE_IN_UNIT')
  SET @BR_CUSTOM_UNIT_MIN_UNIT              = dbo.APB_CM_Constant('BR_CUSTOM_UNIT_MIN_UNIT')
  SET @BR_NORM_MIN_UNIT                     = dbo.APB_CM_Constant('BR_NORM_MIN_UNIT')
  SET @BR_MIN_CLIENT                        = dbo.APB_CM_Constant('BR_MIN_CLIENT')

  -- Norm types
  SET @NORM_STANDARD_NORM                   = dbo.APB_CM_Constant('NORM_STANDARD_NORM')
  SET @NORM_TOP_N_PERCENT                   = dbo.APB_CM_Constant('NORM_TOP_N_PERCENT')
  SET @NORM_BOTTOM_N_PERCENT                = dbo.APB_CM_Constant('NORM_BOTTOM_N_PERCENT')
  SET @NORM_IND_PERCENTILE                  = dbo.APB_CM_Constant('NORM_IND_PERCENTILE')
  SET @NORM_STD_PERCENTILE                  = dbo.APB_CM_Constant('NORM_STD_PERCENTILE')
  SET @NORM_BEST_NORM                       = dbo.APB_CM_Constant('NORM_BEST_NORM')
  SET @NORM_WORST_NORM                      = dbo.APB_CM_Constant('NORM_WORST_NORM')
  SET @NORM_IND_DECILE                      = dbo.APB_CM_Constant('NORM_IND_DECILE')

  -- Norm categories
  SET @NORM_CAT_STANDARD_NORM               = dbo.APB_CM_Constant('NORM_CAT_STANDARD_NORM')
  SET @NORM_CAT_QUESTION_BENCHMARK          = dbo.APB_CM_Constant('NORM_CAT_QUESTION_BENCHMARK')
  SET @NORM_CAT_THEME_BENCHMARK             = dbo.APB_CM_Constant('NORM_CAT_THEME_BENCHMARK')

  -- Norm rating methods
  SET @RATE_NONE                            = dbo.APB_CM_Constant('RATE_NONE')
  SET @RATE_TOP_N_PERCENT                   = dbo.APB_CM_Constant('RATE_TOP_N_PERCENT')
  SET @RATE_BOTTOM_N_PERCENT                = dbo.APB_CM_Constant('RATE_BOTTOM_N_PERCENT')
  SET @RATE_PERCENTILE                      = dbo.APB_CM_Constant('RATE_PERCENTILE')
  SET @RATE_BEST                            = dbo.APB_CM_Constant('RATE_BEST')
  SET @RATE_WORST                           = dbo.APB_CM_Constant('RATE_WORST')

  -- Response count types
  SET @RESP_TOTAL                           = dbo.APB_CM_Constant('RESP_TOTAL')
  SET @RESP_GROUPING                        = dbo.APB_CM_Constant('RESP_GROUPING')
  SET @RESP_PROB_POS                        = dbo.APB_CM_Constant('RESP_PROB_POS')

  -- Business rule types
  SET @BR_TYPE_NSIZE                        = dbo.APB_CM_Constant('BR_TYPE_NSIZE')
  SET @BR_TYPE_UNIT                         = dbo.APB_CM_Constant('BR_TYPE_UNIT')
  SET @BR_TYPE_CLIENT                       = dbo.APB_CM_Constant('BR_TYPE_CLIENT')

  -- Special Kaiser norm
  SET @SPECIAL_KAISER_NORM_1                = dbo.APB_CM_Constant('SPECIAL_KAISER_NORM_1')
  SET @SPECIAL_KAISER_NORM_2                = dbo.APB_CM_Constant('SPECIAL_KAISER_NORM_2')

  -- Significant test results
  SET @SIGDIFF_LOWER                        = dbo.APB_CM_Constant('SIGDIFF_LOWER')
  SET @SIGDIFF_HIGHER                       = dbo.APB_CM_Constant('SIGDIFF_HIGHER')

  -- Correlation highlight settings
  SET @HIGHLIGHT_NONE                       = dbo.APB_CM_Constant('HIGHLIGHT_NONE')
  SET @HIGHLIGHT_TOP_3_CORRELATION          = dbo.APB_CM_Constant('HIGHLIGHT_TOP_3_CORRELATION')
  SET @HIGHLIGHT_HIGHER_THRESHOLD           = dbo.APB_CM_Constant('HIGHLIGHT_HIGHER_THRESHOLD')

  -- Response Rate calculation algorithm
  SET @RR_EXCLUDE_UNDERLIVERABLE            = dbo.APB_CM_Constant('RR_EXCLUDE_UNDERLIVERABLE')
  SET @RR_INCLUDE_UNDERLIVERABLE            = dbo.APB_CM_Constant('RR_INCLUDE_UNDERLIVERABLE')

  -- Y-Axis settings for quadrant
  SET @QUAD_POSITIVE_Y_AXIS                 = dbo.APB_CM_Constant('QUAD_POSITIVE_Y_AXIS')
  SET @QUAD_ALL_Y_AXIS                      = dbo.APB_CM_Constant('QUAD_ALL_Y_AXIS')

  -- Control trend chart type
  SET @TREND_TYPE_X_BAR_S_CHART             = dbo.APB_CM_Constant('TREND_TYPE_X_BAR_S_CHART')
  SET @TREND_TYPE_P_CHART                   = dbo.APB_CM_Constant('TREND_TYPE_P_CHART')

  -- Trend chart interval increment
  SET @TREND_INTERVAL_YEAR                  = dbo.APB_CM_Constant('TREND_INTERVAL_YEAR')
  SET @TREND_INTERVAL_QUARTER               = dbo.APB_CM_Constant('TREND_INTERVAL_QUARTER')
  SET @TREND_INTERVAL_MONTH                 = dbo.APB_CM_Constant('TREND_INTERVAL_MONTH')
  SET @TREND_INTERVAL_WEEK                  = dbo.APB_CM_Constant('TREND_INTERVAL_WEEK')
  SET @TREND_INTERVAL_DAY                   = dbo.APB_CM_Constant('TREND_INTERVAL_DAY')

  -- Min sample size for showing control limits in trend chart
  SET @TREND_MIN_NSIZE_X_BAR_S_CHART        = dbo.APB_CM_Constant('TREND_MIN_NSIZE_X_BAR_S_CHART')
  SET @TREND_MIN_NSIZE_P_CHART              = dbo.APB_CM_Constant('TREND_MIN_NSIZE_P_CHART')

  -- Date styles
  SET @DATE_STYLE_YEAR                      = dbo.APB_CM_Constant('DATE_STYLE_YEAR')
  SET @DATE_STYLE_QUARTER                   = dbo.APB_CM_Constant('DATE_STYLE_QUARTER')
  SET @DATE_STYLE_MONTH                     = dbo.APB_CM_Constant('DATE_STYLE_MONTH')
  SET @DATE_STYLE_DAY                       = dbo.APB_CM_Constant('DATE_STYLE_DAY')

  -- Cache types
  SET @CACHE_UNCACHEABLE                    = dbo.APB_CM_Constant('CACHE_UNCACHEABLE')
  SET @CACHE_TO_BE_CACHED                   = dbo.APB_CM_Constant('CACHE_TO_BE_CACHED')
  SET @CACHE_EXIST_IN_CACHE                 = dbo.APB_CM_Constant('CACHE_EXIST_IN_CACHE')

  -- Tabular ranking periods
  SET @TAB_RANK_PERIOD_CURRENT              = dbo.APB_CM_Constant('TAB_RANK_PERIOD_CURRENT')
  SET @TAB_RANK_PERIOD_PRIMARY_PREVIOUS     = dbo.APB_CM_Constant('TAB_RANK_PERIOD_PRIMARY_PREVIOUS')
  SET @TAB_RANK_PERIOD_SECONDARY_PREVIOUS   = dbo.APB_CM_Constant('TAB_RANK_PERIOD_SECONDARY_PREVIOUS')

  -- HealthSouth ranking report column types
  SET @HS_COLUMN_NSIZE                      = dbo.APB_CM_Constant('HS_COLUMN_NSIZE')
  SET @HS_COLUMN_QUESTION                   = dbo.APB_CM_Constant('HS_COLUMN_QUESTION')

  -- HealthSouth ranking report row types
  SET @HS_ROW_COMPARISON                    = dbo.APB_CM_Constant('HS_ROW_COMPARISON')
  SET @HS_ROW_CURRENT                       = dbo.APB_CM_Constant('HS_ROW_CURRENT')

  -- Correlation coefficient backup/restore
  SET @CORR_CALCULATE                       = dbo.APB_CM_Constant('CORR_CALCULATE')
  SET @CORR_BACKUP                          = dbo.APB_CM_Constant('CORR_BACKUP')
  SET @CORR_RESTORE                         = dbo.APB_CM_Constant('CORR_RESTORE')

  -- Table categories
  SET @TABLE_OTHER                          = dbo.APB_CM_Constant('TABLE_OTHER')
  SET @TABLE_APB_DEFINTION                  = dbo.APB_CM_Constant('TABLE_APB_DEFINTION')
  SET @TABLE_APB_OUTPUT                     = dbo.APB_CM_Constant('TABLE_APB_OUTPUT')
  SET @TABLE_APB_LOG                        = dbo.APB_CM_Constant('TABLE_APB_LOG')

  -- Component item table
  SET @COMP_TBL_NONE                        = dbo.APB_CM_Constant('COMP_TBL_NONE')
  SET @COMP_TBL_VBAR_DETAIL                 = dbo.APB_CM_Constant('COMP_TBL_VBAR_DETAIL')
  SET @COMP_TBL_HBAR_DETAIL                 = dbo.APB_CM_Constant('COMP_TBL_HBAR_DETAIL')
  SET @COMP_TBL_BREAKOUT_DETAIL             = dbo.APB_CM_Constant('COMP_TBL_BREAKOUT_DETAIL')
  SET @COMP_TBL_HBAR_RANKING_DETAIL         = dbo.APB_CM_Constant('COMP_TBL_HBAR_RANKING_DETAIL')
  SET @COMP_TBL_QUADRANT_DETAIL             = dbo.APB_CM_Constant('COMP_TBL_QUADRANT_DETAIL')
  SET @COMP_TBL_TREND_DETAIL                = dbo.APB_CM_Constant('COMP_TBL_TREND_DETAIL')
  SET @COMP_TBL_TAB_RANKING_DETAIL          = dbo.APB_CM_Constant('COMP_TBL_TAB_RANKING_DETAIL')
  SET @COMP_TBL_BOX_PLOT_DETAIL             = dbo.APB_CM_Constant('COMP_TBL_BOX_PLOT_DETAIL')
  SET @COMP_TBL_HS_RANKING_DETAIL           = dbo.APB_CM_Constant('COMP_TBL_HS_RANKING_DETAIL')
  SET @COMP_TBL_UNIT_BENCHMARK              = dbo.APB_CM_Constant('COMP_TBL_UNIT_BENCHMARK')
  SET @COMP_TBL_UNIT_BENCHMARK_DETAIL       = dbo.APB_CM_Constant('COMP_TBL_UNIT_BENCHMARK_DETAIL')

*******************************************************************************/
