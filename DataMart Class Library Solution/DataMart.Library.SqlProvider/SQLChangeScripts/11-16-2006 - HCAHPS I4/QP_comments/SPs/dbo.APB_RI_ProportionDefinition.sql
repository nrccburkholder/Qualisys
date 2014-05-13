SET ANSI_NULLS OFF
GO  

IF (ObjectProperty(Object_Id('dbo.APB_RI_ProportionDefinition'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.APB_RI_ProportionDefinition
GO

/*******************************************************************************
 *
 * Procedure Name:
 *           APB_RI_ProportionDefinition
 *
 * Description:
 *         Create proportion definition for grouping, problem/positive score and 
 *         breakout. Proportion definition indicates which values are in the group,
 *         which are out.
 *         e.g.
 *         top 2 box (grouping): 
 *           top 2 response values are in the group;
 *           other response values are out of the group.
 *         problem score:
 *           Problem response values are in the group;
 *           Positive response values are out of the group.
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
CREATE PROCEDURE dbo.APB_RI_ProportionDefinition
AS
  SET NOCOUNT ON

  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
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
      @PROP_TYPE_THIRD_BOX                  int

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


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @Return                      int


  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------
  
  --
  -- Problem score
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT ps.QstnCore,
         @PROP_TYPE_PROBLEM,
         ps.ResponseValue,
         ps.Problem_Score_Flag
    FROM APB_wk_Questions qs,
         APB_wk_lu_Problem_Score ps
   WHERE ps.QstnCore = qs.QstnCore


  --
  -- Positive score
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT ps.QstnCore,
         @PROP_TYPE_POSITIVE,
         ps.ResponseValue,
         1 - ps.Problem_Score_Flag
    FROM APB_wk_Questions qs,
         APB_wk_lu_Problem_Score ps
   WHERE ps.QstnCore = qs.QstnCore


  --
  -- Top box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_TOP_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder = 1 THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore
     

  --
  -- Top 2 Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_TOP_2_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder BETWEEN 1 AND 2 THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Top 3 Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_TOP_3_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder BETWEEN 1 AND 3 THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Top 4 Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_TOP_4_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder BETWEEN 1 AND 4 THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Bottom Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_BOTTOM_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder = qsr.Max_RankOrder THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Bottom 2 Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_BOTTOM_2_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder BETWEEN qsr.Max_RankOrder-1 AND qsr.Max_RankOrder THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Bottom 4 Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_BOTTOM_4_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder BETWEEN qsr.Max_RankOrder-3 AND qsr.Max_RankOrder THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Second Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_SECOND_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder = 2 THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  --
  -- Third Box
  --
  INSERT INTO APB_wk_ProportionDetail (
          QstnCore,
          PropType_ID,
          ResponseValue,
          InSelection
         )
  SELECT qs.QstnCore,
         @PROP_TYPE_THIRD_BOX,
         qsr.ResponseValue,
         CASE 
           WHEN qsr.rankOrder = 3 THEN 1
           ELSE 0
           END AS InSelection
    FROM APB_wk_Questions qs,
         APB_wk_QuestionScaleRanking qsr
   WHERE qs.Qstncore = qsr.Qstncore


  RETURN 0
  
GO