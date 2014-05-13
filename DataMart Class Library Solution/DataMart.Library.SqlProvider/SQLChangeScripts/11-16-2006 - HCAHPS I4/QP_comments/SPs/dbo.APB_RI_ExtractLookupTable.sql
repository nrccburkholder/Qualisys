SET ANSI_NULLS OFF
GO  

IF (ObjectProperty(Object_Id('dbo.APB_RI_ExtractLookupTable'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.APB_RI_ExtractLookupTable
GO


/*******************************************************************************
 *
 * Procedure Name:
 *           APB_RI_ExtractLookupTable
 *
 * Description:
 *           Create lookup work tables
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
CREATE PROCEDURE dbo.APB_RI_ExtractLookupTable
AS
  SET NOCOUNT ON

  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
      @CMP_CLUSTER_UNIT_COMPARISON          int,
      @CMP_CLUSTER_UNIT_BENCHMARK           int,
      @CMP_CLUSTER_UNIT_PERCENTILE          int

  SET @CMP_CLUSTER_UNIT_COMPARISON          = dbo.APB_CM_Constant('CMP_CLUSTER_UNIT_COMPARISON')
  SET @CMP_CLUSTER_UNIT_BENCHMARK           = dbo.APB_CM_Constant('CMP_CLUSTER_UNIT_BENCHMARK')
  SET @CMP_CLUSTER_UNIT_PERCENTILE          = dbo.APB_CM_Constant('CMP_CLUSTER_UNIT_PERCENTILE')


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @AP_ID                 char(20),
          @Template_ID           int,
          @Client_ID             int


  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------

  --
  -- Fetch AP ID and Template ID
  --
  EXEC dbo.APB_CM_ReportInfo @AP_ID = @AP_ID OUTPUT,
                             @Template_ID = @Template_ID OUTPUT


  --------------------------------------------------------------------
  -- SampleUnit
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'SampleUnit'

  INSERT INTO APB_wk_SampleUnit
  SELECT DISTINCT
         su.SampleUnit_ID,
         su.ParentSampleUnit_ID,
         su.strSampleUnit_NM,
         su.Survey_id,
         su.study_id,
         su.strUnitSelectType,
         su.intLevel
    FROM (
          SELECT SampleUnit_ID
            FROM APB_wk_ApUnits
          UNION
          SELECT SampleUnit_ID
            FROM APB_wk_ApGroupUnits
         ) apsu,
         SampleUnit su
   WHERE apsu.SampleUnit_ID = su.SampleUnit_ID


  --------------------------------------------------------------------
  -- APB_wk_CurrentSurvey
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'APB_wk_CurrentSurvey'

  INSERT INTO APB_wk_CurrentSurvey
  SELECT DISTINCT
         su.Survey_ID,
         su.Study_ID
    FROM (
          SELECT SampleUnit_ID
            FROM APB_wk_ApUnits
          UNION
          SELECT gu.SampleUnit_ID
            FROM APB_wk_ApResponseSubgroup sg,
                 APB_wk_ApGroupUnits gu
           WHERE gu.Subgroup_ID = sg.Subgroup_ID
         ) apsu,
         APB_wk_SampleUnit su
   WHERE apsu.SampleUnit_ID = su.SampleUnit_ID
   

  --------------------------------------------------------------------
  -- Question
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'Question'

  INSERT INTO APB_wk_Questions (
          QstnCore
         )
  SELECT tq.QstnCore
    FROM APB_wk_ApPageCompDetail cd,
         APB_wk_ApThemeQuestions tq
   WHERE cd.Theme_ID = tq.Theme_ID
  UNION
  SELECT tq.QstnCore
    FROM APB_wk_ApPageCompMaster cm,
         APB_wk_ApThemeQuestions tq
   WHERE cm.CorrTheme_ID = tq.Theme_ID
  
  -- Find norms used in this report
  DECLARE @NormInUse TABLE (
          Norm_ID              int NOT NULL PRIMARY KEY CLUSTERED
  )
  
  INSERT INTO @NormInUse
  SELECT DISTINCT
         cp.Norm_ID
    FROM APB_wk_ApPageCompMasterColumn cl,
         tbl_ComparisonDef cp
   WHERE cl.CompCluster_ID IN (
                            @CMP_CLUSTER_UNIT_COMPARISON,
                            @CMP_CLUSTER_UNIT_BENCHMARK,
                            @CMP_CLUSTER_UNIT_PERCENTILE
                           )
     AND cl.CompType_ID = cp.CompType_ID
     AND cp.Norm_ID > 0


  -- Add alternative norms
  INSERT INTO @NormInUse
  SELECT DISTINCT
         nr.AlternateAggregateLevelNorm_ID
    FROM @NormInUse us,
         NormSettings nr
   WHERE nr.Norm_ID = us.Norm_ID
     AND nr.AlternateAggregateLevelNorm_ID > 0
     AND nr.AlternateAggregateLevelNorm_ID NOT IN (
                                            SELECT Norm_ID
                                              FROM @NormInUse
                                           )
    
  -- Add norm specified equivalent questions
  INSERT INTO APB_wk_Questions (
          QstnCore
         )
  SELECT DISTINCT
         qgm.QstnCore
    FROM (
          SELECT DISTINCT
                 qgm.QuestionGroup_ID
            FROM APB_wk_Questions qs,
                 @NormInUse nr,
                 QuestionGroups qg,
                 QuestionGroupMembers qgm
           WHERE qg.Norm_ID = nr.Norm_ID
             AND qgm.QuestionGroup_ID = qg.QuestionGroup_ID
             AND qgm.QstnCore = qs.QstnCore
         ) qg,
         QuestionGroupMembers qgm
   WHERE qgm.QuestionGroup_ID = qg.QuestionGroup_ID
     AND qgm.QstnCore NOT IN (
                       SELECT QstnCore
                         FROM APB_wk_Questions
                      )

  -- Add general equivalent questions
  INSERT INTO APB_wk_Questions (
          QstnCore
         )
  SELECT DISTINCT
         qgm.QstnCore
    FROM (
          SELECT DISTINCT
                 qgm.QuestionGroup_ID
            FROM APB_wk_Questions qs,
                 QuestionGroups qg,
                 QuestionGroupMembers qgm
           WHERE (
                  qg.Norm_ID IS NULL
                  OR qg.Norm_ID = 0
                 )
             AND qgm.QuestionGroup_ID = qg.QuestionGroup_ID
             AND qgm.QstnCore = qs.QstnCore
         ) qg,
         QuestionGroupMembers qgm
   WHERE qgm.QuestionGroup_ID = qg.QuestionGroup_ID
     AND qgm.QstnCore NOT IN (
                       SELECT QstnCore
                         FROM APB_wk_Questions
                      )

  -- Find 1 survey in the report that has this question defined
  UPDATE aq
     SET Survey_ID = sv.Survey_ID
    FROM APB_wk_Questions aq,
         (
          SELECT aq.QstnCore,
                 MAX(su.Survey_ID) AS Survey_ID
            FROM APB_wk_Questions aq,
                 APB_wk_SampleUnit su,
                 Questions qs
           WHERE qs.Survey_ID = su.Survey_ID
             AND qs.Language = 1
             AND qs.QstnCore = aq.QstnCore
           GROUP BY aq.QstnCore
         ) sv
   WHERE sv.QstnCore = aq.QstnCore

  -- For questions that not defined in any of the surveys in this report,
  -- Find any survey that has this question defined
  UPDATE aq
     SET Survey_ID = sv.Survey_ID
    FROM APB_wk_Questions aq,
         (
          SELECT aq.QstnCore,
                 MAX(css.Survey_ID) AS Survey_ID
            FROM APB_wk_Questions aq,
                 ClientStudySurvey css,
                 Questions qs
           WHERE aq.Survey_ID = 0
             AND qs.Survey_ID = css.Survey_ID
             AND qs.Language = 1
             AND qs.QstnCore = aq.QstnCore
           GROUP BY aq.QstnCore
         ) sv
   WHERE sv.QstnCore = aq.QstnCore

  -- Delete questions that are not defined in any surveys
  DELETE FROM APB_wk_Questions
   WHERE Survey_ID = 0
  
  -- Populate other fields
  UPDATE aq
     SET ScaleID = qs.ScaleID,
         Section_ID = qs.Section_ID,
         numMarkCount = qs.numMarkCount,
         strQuestionLabel = ISNULL(LTRIM(RTRIM(qs.strQuestionLabel)), '')
    FROM APB_wk_Questions aq,
         Questions qs
   WHERE qs.Survey_ID = aq.Survey_ID
     AND qs.Language = 1
     AND qs.QstnCore = aq.QstnCore

  -- Delete the question label prefix
  UPDATE qs
     SET strQuestionLabel = RIGHT(qs.strQuestionLabel, LEN(strQuestionLabel) - LEN(pr.Prefix))
    FROM APB_wk_Questions qs,
         lu_QuestionRemovalPrefix pr
   WHERE qs.strQuestionLabel LIKE pr.Prefix + '%'


  --------------------------------------------------------------------
  -- Scales
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'Scales'

  INSERT INTO APB_wk_Scales (
          ScaleID,
          ResponseValue,
          strScaleLabel
         )
  SELECT DISTINCT
         sc.ScaleID,
         sc.Val,
         ISNULL(LTRIM(RTRIM(sc.strScaleLabel)), '') AS strScaleLabel
    FROM (
          SELECT ScaleID,
                 MAX(Survey_ID) AS Survey_ID
            FROM APB_wk_Questions
           GROUP BY ScaleID
         ) ss,
         Scales sc
   WHERE sc.Survey_ID = ss.Survey_ID
     AND sc.Language = 1
     AND sc.ScaleID = ss.ScaleID
     AND (
          sc.bitMissing = 0
          OR sc.bitMissing IS NULL
         )
     AND sc.Val <> -10

    --
  -- Create random value range for each scale value.
  -- This range will be used in mocking up study result
  --
  DECLARE @ScaleRange TABLE (
           ScaleID           int NOT NULL,
           ResponseValue     int NOT NULL,
           OrderNum          tinyint NULL,
           MaxOrderNum       tinyint NULL,
           MinRandValue      smallint NULL,
           MaxRandValue      smallint NULL
  )
  
  INSERT INTO @ScaleRange (
          ScaleID,
          ResponseValue,
          OrderNum,
          MaxOrderNum
         )
  SELECT od.ScaleID,
         od.ResponseValue,
         od.OrderNum,
         ct.MaxOrderNum
    FROM (
          SELECT ScaleID,
                 COUNT(*) AS MaxOrderNum
            FROM APB_wk_Scales
           GROUP BY ScaleID
         ) ct,
         (
          SELECT me.ScaleID,
                 me.ResponseValue,
                 COUNT(*) AS OrderNum
            FROM APB_wk_Scales me,
                 APB_wk_Scales ot
           WHERE me.ScaleID = ot.ScaleID
             AND me.ResponseValue >= ot.ResponseValue
           GROUP BY
                 me.ScaleID,
                 me.ResponseValue
         ) od
   WHERE ct.ScaleID = od.ScaleID

  UPDATE @ScaleRange
     SET MinRandValue = 1000.0 * (OrderNum - 1) / MaxOrderNum,
         MaxRandValue = 1000.0 * OrderNum / MaxOrderNum - 1

  UPDATE sc
     SET MinRandValue = rg.MinRandValue,
         MaxRandValue = rg.MaxRandValue
    FROM APB_wk_Scales sc,
         @ScaleRange rg
   WHERE rg.ScaleID = sc.ScaleID
     AND rg.ResponseValue = sc.ResponseValue

--------------------------------------------------------------------
  -- Ranking Order
  --------------------------------------------------------------------
   EXEC dbo.APB_CM_BeginProcess 3, 'Ranking Order'

   INSERT INTO APB_wk_QuestionScaleRanking (
        Qstncore,
        ResponseValue,
        strScaleLabel,
        rankOrder)
	SELECT q.Qstncore,
        s.ResponseValue,
        s.strScaleLabel,
        rro.rankOrder as ScaleOrder
	FROM APB_wk_Questions q join APB_wk_Scales s
			ON q.scaleID=s.scaleid
		JOIN ResponseRankOrder rro
			ON q.qstncore=rro.qstncore
			and s.ResponseValue=rro.val
			and rro.rankOrder > 0

	UPDATE APB_wk_QuestionScaleRanking
	SET Max_RankOrder=m.Max_RankOrder
	FROM APB_wk_QuestionScaleRanking qsr, 
	   (Select qsr.qstncore, max(rro.rankOrder) as Max_RankOrder
		FROM APB_wk_QuestionScaleRanking qsr, ResponseRankOrder rro
		WHERE qsr.qstncore=rro.qstncore
				and rro.rankOrder > 0
		GROUP by qsr.qstncore) m
	WHERE qsr.qstncore=m.qstncore


  --------------------------------------------------------------------
  -- lu_Problem_Score
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'lu_Problem_Score'

  SELECT @Client_ID = css.Client_ID
    FROM APB_wk_CurrentSurvey sv,
         ClientStudySurvey css
   WHERE css.Survey_ID = sv.Survey_ID
  
  INSERT INTO APB_wk_lu_Problem_Score (
         QstnCore,
         ResponseValue,
         Problem_Score_Flag
         )
  SELECT cps.QstnCore,
         cps.Val,
         cps.Problem_Score_Flag
    FROM (
          SELECT DISTINCT QstnCore
            FROM APB_wk_Questions
         ) qs,
         lu_Problem_Score_Custom cps
   WHERE cps.Client_ID = @Client_ID
     AND cps.QstnCore = qs.QstnCore
     AND cps.Problem_Score_Flag IN (0, 1)

  -- Sometimes all the response is set to none-problem-positive
  -- in lu_Problem_Score_Custom. So these questions are not
  -- populated in APB_wk_lu_Problem_Score. But we still need to 
  -- remember these questions so that we will NOT pull them
  -- from lu_Problem_Score
  SELECT DISTINCT
         cps.QstnCore
    INTO #QuestionDefined
    FROM (
          SELECT DISTINCT QstnCore
            FROM APB_wk_Questions
         ) qs,
         lu_Problem_Score_Custom cps
   WHERE cps.Client_ID = @Client_ID
     AND cps.QstnCore = qs.QstnCore

  INSERT INTO APB_wk_lu_Problem_Score (
         QstnCore,
         ResponseValue,
         Problem_Score_Flag
         )
  SELECT ps.QstnCore,
         ps.Val,
         ps.Problem_Score_Flag
    FROM (
          SELECT DISTINCT
                 QstnCore
            FROM APB_wk_Questions
           WHERE QstnCore NOT IN (
                           SELECT QstnCore
                             FROM #QuestionDefined
                          )
         ) qs,
         lu_Problem_Score ps
   WHERE ps.QstnCore = qs.QstnCore
     AND ps.Problem_Score_Flag IN (0, 1)
  

  --------------------------------------------------------------------
  -- lu_Question_Recodes
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'lu_Question_Recodes'

  INSERT INTO APB_wk_lu_Question_Recodes
  SELECT re.*
    FROM APB_wk_Questions qs,
         lu_Question_Recodes re
   WHERE re.QstnCore = qs.QstnCore
     AND re.RecodedVal IS NOT NULL


  --------------------------------------------------------------------
  -- Delete invalid theme/question from APB_wk_ApPageCompDetail
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_BeginProcess 3, 'Delete invalid theme/question from APB_wk_ApPageCompDetail'

  DELETE FROM cd
    FROM APB_wk_ApPageCompDetail cd
         LEFT JOIN APB_wk_ApThemes th
           ON cd.Theme_ID = th.Theme_ID
   WHERE cd.Theme_ID >= 0
     AND th.Theme_ID IS NULL
  
  DELETE FROM cd
    FROM APB_wk_ApPageCompDetail cd
         LEFT JOIN APB_wk_Questions qs
           ON qs.QstnCore = -cd.Theme_ID
   WHERE cd.Theme_ID < 0
     AND qs.QstnCore IS NULL
  
  
  RETURN 0
  
GO
 