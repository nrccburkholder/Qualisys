IF EXISTS (SELECT *
             FROM DBO.SYSOBJECTS
            WHERE ID = OBJECT_ID(N'dbo.APB_CM_MeasureLabelForProportion')
              AND XTYPE IN (N'FN', N'IF', N'TF')
          )
    DROP FUNCTION dbo.APB_CM_MeasureLabelForProportion
GO

/*******************************************************************************
 *
 * Function Name:
 *           APB_CM_MeasureLabelForProportion
 *
 * Description:
 *           Create measure label for proportion
 *
 * Parameters:
 *            @PropType_ID
 *              Proportion type
 *            @QstnCore
 *              Question
 *
 * Return:
 *           Measure Label
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE FUNCTION dbo.APB_CM_MeasureLabelForProportion (
         @QstnCore           int,
         @PropType_ID        smallint
       ) RETURNS varchar(256)
AS
BEGIN

  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
      @YES                                  int,
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
      @PROP_TYPE_BREAKOUT                   int

  SET @YES                                  = dbo.APB_CM_Constant('YES')
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


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @ScaleLabel        varchar(256),
          @MeasureLabel      varchar(256)
  

  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------

  --
  -- Problem/positive
  --
  IF (@PropType_ID = @PROP_TYPE_PROBLEM)  SET @MeasureLabel = '% Problem Score'
  IF (@PropType_ID = @PROP_TYPE_POSITIVE) SET @MeasureLabel = '% Positive Score'


  --
  -- Grouping
  --
  IF (@PropType_ID IN (
                    @PROP_TYPE_TOP_BOX,
                    @PROP_TYPE_TOP_2_BOX,
                    @PROP_TYPE_TOP_3_BOX,
                    @PROP_TYPE_TOP_4_BOX,
                    @PROP_TYPE_BOTTOM_BOX,
                    @PROP_TYPE_BOTTOM_2_BOX,
                    @PROP_TYPE_BOTTOM_4_BOX,
                    @PROP_TYPE_SECOND_BOX,
                    @PROP_TYPE_THIRD_BOX
                   )
     ) BEGIN
      
      DECLARE curScaleSelection CURSOR LOCAL FOR
      SELECT qsr.strScaleLabel
        FROM APB_wk_ProportionDetail pr,
             APB_wk_QuestionScaleRanking qsr
       WHERE pr.QstnCore = @QstnCore
         AND pr.PropType_ID = @PropType_ID
         AND pr.InSelection = @YES
         AND qsr.QstnCore = @QstnCore
         AND qsr.ResponseValue = pr.ResponseValue
       ORDER BY qsr.RankOrder

      OPEN curScaleSelection
      FETCH curScaleSelection INTO @ScaleLabel
      
      WHILE @@FETCH_STATUS = 0 BEGIN
          IF (@MeasureLabel IS NULL) SET @MeasureLabel = '% ' + @ScaleLabel
          ELSE SET @MeasureLabel = @MeasureLabel + '/' + @ScaleLabel
          
          FETCH curScaleSelection INTO @ScaleLabel
      END
      CLOSE curScaleSelection
      DEALLOCATE curScaleSelection
  END


  --
  -- Breakout
  --
  IF (@PropType_ID >= @PROP_TYPE_BREAKOUT) SET @MeasureLabel = '% Response'

  
  --
  -- Output
  --
  RETURN(LEFT(@MeasureLabel, 50))

END

GO
