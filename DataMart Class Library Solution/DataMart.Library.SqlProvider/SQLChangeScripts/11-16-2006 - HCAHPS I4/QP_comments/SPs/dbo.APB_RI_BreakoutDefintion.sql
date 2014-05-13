SET ANSI_NULLS OFF
GO  

IF (ObjectProperty(Object_Id('dbo.APB_RI_BreakoutDefintion'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.APB_RI_BreakoutDefintion
GO

/*******************************************************************************
 *
 * Procedure Name:
 *           APB_RI_BreakoutDefintion
 *
 * Description:
 *           Extract breakout report defintion
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
CREATE PROCEDURE dbo.APB_RI_BreakoutDefintion 
AS
  SET NOCOUNT ON

  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
      @COMP_HBAR_BREAKOUT                   int

  SET @COMP_HBAR_BREAKOUT                   = dbo.APB_CM_Constant('COMP_HBAR_BREAKOUT')


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @AP_ID                 char(20),
          @Template_ID           int


  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------
  EXEC dbo.APB_CM_ReportInfo @AP_ID = @AP_ID OUTPUT,
                             @Template_ID = @Template_ID OUTPUT

  
  --------------------------------------------------------------------
  -- Get breakout definition
  --------------------------------------------------------------------
  DECLARE @APB_wk_ApResponseSubset TABLE (
          Page_number      smallint NOT NULL,
          Comp_Def_ID      tinyint NOT NULL,
          QuestionSeqNum   smallint NOT NULL,
          Theme_ID         int NOT NULL,
          SubsetSeqNum     tinyint NOT NULL DEFAULT 0,
          Subset_ID        int NULL,
          ResponseValue    int NULL,
          MockupSubset_ID  int IDENTITY(-1, -1) NOT NULL,
          ProportionDef    varchar(8000) NULL,
          PropType_ID      int NULL
  )
  

  INSERT INTO @APB_wk_ApResponseSubset (
          Page_number,
          Comp_Def_ID,
          QuestionSeqNum,
          Theme_ID,
          Subset_ID,
          ResponseValue
         )
  SELECT DISTINCT
         br.Page_number,
         br.Comp_Def_ID,
         br.Seq_number AS QuestionSeqNum,
         cd.Theme_ID,
         br.Subset_ID,
         CASE
           WHEN br.Subset_ID IS NOT NULL THEN NULL
           ELSE br.Val
           END AS ResponseValue
    FROM APB_wk_ApPageCompMaster cm,
         APB_wk_ApPageCompDetail cd,
         tbl_TemplateResponseSubset br
   WHERE cm.CompType = @COMP_HBAR_BREAKOUT
     AND cd.Page_Number = cm.Page_Number
     AND cd.Comp_Def_ID = cm.Comp_Def_ID
     AND cd.numBreakoutResponse IS NOT NULL
     AND br.Template_ID = @Template_ID
     AND br.Page_Number = cm.Page_Number
     AND br.Comp_Def_ID = cm.Comp_Def_ID
     AND br.Seq_number = cd.Seq_number
     AND (
          br.Subset_ID IS NOT NULL
          OR br.Val IS NOT NULL
         )
   ORDER BY
         br.Page_number,
         br.Comp_Def_ID,
         QuestionSeqNum,
         br.Subset_ID,
         ResponseValue
  
  
  --
  -- In breakout component, if there is no breakout info defined for
  -- one question, this means each response value for this question
  -- is treated as a individual subset
  --
  INSERT INTO @APB_wk_ApResponseSubset (
          Page_number,
          Comp_Def_ID,
          QuestionSeqNum,
          Theme_ID,
          ResponseValue
         )
  SELECT DISTINCT
         mq.Page_number,
         mq.Comp_Def_ID,
         mq.QuestionSeqNum,
         mq.Theme_ID,
         sc.ResponseValue
    FROM ( -- Questions missing breakout defintion
          SELECT DISTINCT
                 cd.Page_number,
                 cd.Comp_Def_ID,
                 cd.Seq_number AS QuestionSeqNum,
                 cd.Theme_ID
            FROM APB_wk_ApPageCompMaster cm
                 JOIN APB_wk_ApPageCompDetail cd
                   ON cm.CompType = @COMP_HBAR_BREAKOUT
                      AND cd.Page_Number = cm.Page_Number
                      AND cd.Comp_Def_ID = cm.Comp_Def_ID
                 LEFT JOIN @APB_wk_ApResponseSubset br
                   ON br.Page_Number = cm.Page_Number
                      AND br.Comp_Def_ID = cm.Comp_Def_ID
                      AND br.QuestionSeqNum = cd.Seq_number
           WHERE br.QuestionSeqNum IS NULL
         ) mq,
         APB_wk_ApThemeQuestions tq,
         APB_wk_Questions qs,
         APB_wk_Scales sc
   WHERE tq.Theme_ID = mq.Theme_ID
     AND qs.QstnCore = tq.QstnCore
     AND sc.ScaleID = qs.ScaleID
   ORDER BY
         mq.Page_number,
         mq.Comp_Def_ID,
         mq.QuestionSeqNum,
         sc.ResponseValue

  
  --------------------------------------------------------------------
  -- Extract subset defintion
  --------------------------------------------------------------------
  INSERT INTO APB_wk_ApSubsetDef (
	      Subset_ID,
	      SubsetName
	     )
  SELECT ss.Subset_ID,
         MIN(ss.SubsetName)
    FROM @APB_wk_ApResponseSubset br,
         tbl_ApSubsetGroup ss
   WHERE ss.Subset_ID = br.Subset_ID
   GROUP BY ss.Subset_ID
    
  
  INSERT INTO APB_wk_ApSubsetDetail (
	      Subset_ID,
	      ResponseValue
	     )
  SELECT ss.Subset_ID,
	     ss.Val
    FROM APB_wk_ApSubsetDef sd,
         tbl_ApSubsetGroup ss
   WHERE ss.Subset_ID = sd.Subset_ID


  --
  -- For each breakout defintion that uses response value instead of sebset,
  -- mock up a subset for it. The mock up Subset_ID is the ID in @APB_wk_ApResponseSubset
  --
  INSERT INTO APB_wk_ApSubsetDef (
	      Subset_ID,
	      SubsetName
	     )
  SELECT br.MockupSubset_ID AS Subset_ID,
         MIN(sc.strScaleLabel) AS SubsetName
    FROM @APB_wk_ApResponseSubset br,
         APB_wk_ApThemeQuestions tq,
         APB_wk_Questions qs,
         APB_wk_Scales sc
   WHERE br.ResponseValue IS NOT NULL
     AND tq.Theme_ID = br.Theme_ID
     AND qs.QstnCore = tq.QstnCore
     AND sc.ScaleID = qs.ScaleID
     AND sc.ResponseValue = br.ResponseValue
   GROUP BY br.MockupSubset_ID
         

  INSERT INTO APB_wk_ApSubsetDetail (
	      Subset_ID,
	      ResponseValue
	     )
  SELECT MockupSubset_ID AS Subset_ID,
         ResponseValue
    FROM @APB_wk_ApResponseSubset
   WHERE ResponseValue IS NOT NULL


  UPDATE @APB_wk_ApResponseSubset
     SET Subset_ID = MockupSubset_ID
   WHERE ResponseValue IS NOT NULL


  --------------------------------------------------------------------
  -- Assign subset sequence number.
  -- Subset sequence number is ordered by RankOrder then response value
  --------------------------------------------------------------------
  
  --
  -- For each question in the theme, find out how many of question's response
  -- values are used in breakout definition
  --
  DECLARE @QuestionResponseCount TABLE (
           Page_number           smallint NOT NULL,
           Comp_Def_ID           tinyint NOT NULL,
           QuestionSeqNum        smallint NOT NULL,
           QstnCore              int NOT NULL,
           ResponseValueCount    int NOT NULL,
          PRIMARY KEY CLUSTERED (
           Page_number,
           Comp_Def_ID,
           QuestionSeqNum,
           QstnCore
          )
  )
  
  INSERT INTO @QuestionResponseCount (
           Page_number,
           Comp_Def_ID,
           QuestionSeqNum,
           QstnCore,
           ResponseValueCount
         )
  SELECT br.Page_number,
         br.Comp_Def_ID,
         br.QuestionSeqNum,
         tq.QstnCore,
         COUNT(*) AS ResponseValueCount
    FROM @APB_wk_ApResponseSubset br,
         APB_wk_ApSubsetDetail sd,
         APB_wk_ApThemeQuestions tq,
         APB_wk_Questions qs,
         APB_wk_Scales sc
   WHERE sd.Subset_ID = br.Subset_ID
     AND tq.Theme_ID = br.Theme_ID
     AND qs.QstnCore = tq.QstnCore
     AND sc.ScaleID = qs.ScaleID
     AND sc.ResponseValue = sd.ResponseValue
   GROUP BY
         br.Page_number,
         br.Comp_Def_ID,
         br.QuestionSeqNum,
         tq.QstnCore

  --
  -- For each theme, select a representative question to be used in the 
  -- process of assigning subset sequence number.
  -- The criteria of the representative question: the question has more
  -- response values in the breakout defintion than other questions
  --
  DECLARE @RepresentativeQuestion TABLE (
           Page_number           smallint NOT NULL,
           Comp_Def_ID           tinyint NOT NULL,
           QuestionSeqNum        smallint NOT NULL,
           QstnCore              int NOT NULL,
          PRIMARY KEY CLUSTERED (
           Page_number,
           Comp_Def_ID,
           QuestionSeqNum
          )
  )
  
  INSERT INTO @RepresentativeQuestion (
          Page_number,
          Comp_Def_ID,
          QuestionSeqNum,
          QstnCore
         )
  SELECT rc.Page_number,
         rc.Comp_Def_ID,
         rc.QuestionSeqNum,
         MIN(rc.QstnCore) AS QstnCore
    FROM @QuestionResponseCount rc,
         (
          SELECT Page_number,
                 Comp_Def_ID,
                 QuestionSeqNum,
                 MAX(ResponseValueCount) AS MaxResponseValueCount
            FROM @QuestionResponseCount
           GROUP BY
                 Page_number,
                 Comp_Def_ID,
                 QuestionSeqNum
         ) mrc
   WHERE rc.Page_number = mrc.Page_number
     AND rc.Comp_Def_ID = mrc.Comp_Def_ID
     AND rc.QuestionSeqNum = mrc.QuestionSeqNum
     AND rc.ResponseValueCount = mrc.MaxResponseValueCount
   GROUP BY
         rc.Page_number,
         rc.Comp_Def_ID,
         rc.QuestionSeqNum
                 

  --
  -- Find representative question's min scale order for each subset 
  --
  DECLARE @RankOrder TABLE (
           Page_number           smallint NOT NULL,
           Comp_Def_ID           tinyint NOT NULL,
           QuestionSeqNum        smallint NOT NULL,
           Subset_ID             int NOT NULL,
           RankOrder             int NOT NULL,
          PRIMARY KEY CLUSTERED (
           Page_number,
           Comp_Def_ID,
           QuestionSeqNum,
           Subset_ID
          )
  )

  INSERT INTO @RankOrder (
          Page_number,
          Comp_Def_ID,
          QuestionSeqNum,
          Subset_ID,
          RankOrder
         )
  SELECT br.Page_number,
         br.Comp_Def_ID,
         br.QuestionSeqNum,
         br.Subset_ID,
         MIN(qsc.rankOrder)
    FROM @APB_wk_ApResponseSubset br,
         APB_wk_ApSubsetDetail sd,
         @RepresentativeQuestion rq,
         APB_wk_QuestionScaleRanking qsc
   WHERE sd.Subset_ID = br.Subset_ID
     AND rq.Page_number = br.Page_number
     AND rq.Comp_Def_ID = br.Comp_Def_ID
     AND rq.QuestionSeqNum = br.QuestionSeqNum
     AND qsc.QstnCore = rq.QstnCore
     AND qsc.ResponseValue = sd.ResponseValue
   GROUP BY
         br.Page_number,
         br.Comp_Def_ID,
         br.QuestionSeqNum,
         br.Subset_ID


  --
  -- Sort subsets by scale order then min response value
  --
  DECLARE @SortedResponseSubset TABLE (
           Page_number      smallint NOT NULL,
           Comp_Def_ID      tinyint NOT NULL,
           QuestionSeqNum   smallint NOT NULL,
           Subset_ID        int NOT NULL,
           ID               int IDENTITY(1, 1) NOT NULL,
           SubsetSeqNum     tinyint NOT NULL DEFAULT 0,
          PRIMARY KEY CLUSTERED (
           Page_number,
           Comp_Def_ID,
           QuestionSeqNum,
           Subset_ID
          )
  )
  

  INSERT INTO @SortedResponseSubset (
          Page_number,
          Comp_Def_ID,
          QuestionSeqNum,
          Subset_ID
         )
  SELECT br.Page_number,
         br.Comp_Def_ID,
         br.QuestionSeqNum,
         br.Subset_ID
    FROM (
          SELECT br.Page_number,
                 br.Comp_Def_ID,
                 br.QuestionSeqNum,
                 br.Subset_ID,
                 MIN(sd.ResponseValue) AS ResponseValue
            FROM @APB_wk_ApResponseSubset br,
                 APB_wk_ApSubsetDetail sd
           WHERE sd.Subset_ID = br.Subset_ID
           GROUP BY
                 br.Page_number,
                 br.Comp_Def_ID,
                 br.QuestionSeqNum,
                 br.Subset_ID
         ) br
         LEFT JOIN @RankOrder so
           ON so.Page_number = br.Page_number
              AND so.Comp_Def_ID = br.Comp_Def_ID
              AND so.QuestionSeqNum = br.QuestionSeqNum
              AND so.Subset_ID = br.Subset_ID
   ORDER BY
         br.Page_number,
         br.Comp_Def_ID,
         br.QuestionSeqNum,
         so.RankOrder,
         br.ResponseValue,
         br.Subset_ID


  UPDATE br
     SET SubsetSeqNum = br.ID - mi.MinID + 1
    FROM @SortedResponseSubset br,
         (
          SELECT Page_number,
                 Comp_Def_ID,
                 QuestionSeqNum,
                 MIN(ID) AS MinID
            FROM @SortedResponseSubset
           GROUP BY
                 Page_number,
                 Comp_Def_ID,
                 QuestionSeqNum
         ) mi
   WHERE mi.Page_number = br.Page_number
     AND mi.Comp_Def_ID = br.Comp_Def_ID
     AND mi.QuestionSeqNum = br.QuestionSeqNum
  
  
  --
  -- Save subset sequence number
  --
  UPDATE br
     SET SubsetSeqNum = wk.SubsetSeqNum
    FROM @APB_wk_ApResponseSubset br,
         @SortedResponseSubset wk
   WHERE wk.Page_number = br.Page_number
     AND wk.Comp_Def_ID = br.Comp_Def_ID
     AND wk.QuestionSeqNum = br.QuestionSeqNum
     AND wk.Subset_ID = br.Subset_ID


  --
  -- Concate the subset defintion into a string
  --
  UPDATE @APB_wk_ApResponseSubset
     SET ProportionDef = dbo.APB_CM_ConcateBreakoutSubset(Theme_ID, Subset_ID)

  --
  -- Populate PropType_ID for each unique subset defintion
  --
  DECLARE @Proportion TABLE (
          ProportionDef    varchar(8000) NOT NULL,
          PropType_ID      int IDENTITY(1000, 1) NOT NULL
  )
  
  INSERT INTO @Proportion (
          ProportionDef 
         )
  SELECT DISTINCT
         ProportionDef
    FROM @APB_wk_ApResponseSubset
   ORDER BY ProportionDef


  UPDATE br
     SET PropType_ID = pr.PropType_ID
    FROM @APB_wk_ApResponseSubset br,
         @Proportion pr
   WHERE pr.ProportionDef = br.ProportionDef


  --------------------------------------------------------------------
  -- Save breakout definition
  --------------------------------------------------------------------
  INSERT INTO APB_wk_ApResponseSubset (
          Page_number,
          Comp_Def_ID,
          QuestionSeqNum,
          SubsetSeqNum,
          Theme_ID,
          Subset_ID,
          PropType_ID
         )
  SELECT Page_number,
         Comp_Def_ID,
         QuestionSeqNum,
         SubsetSeqNum,
         Theme_ID,
         Subset_ID,
         PropType_ID
    FROM @APB_wk_ApResponseSubset
   ORDER BY
         Page_number,
         Comp_Def_ID,
         QuestionSeqNum,
         SubsetSeqNum


  RETURN 0
  
GO