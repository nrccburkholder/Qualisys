SET ANSI_NULLS OFF
GO  
IF EXISTS (SELECT *
             FROM DBO.SYSOBJECTS
            WHERE ID = OBJECT_ID(N'dbo.APB_CM_MeasureLabel')
              AND XTYPE IN (N'FN', N'IF', N'TF')
          )
    DROP FUNCTION dbo.APB_CM_MeasureLabel
GO

/*******************************************************************************
 *
 * Function Name:
 *           APB_CM_MeasureLabel
 *
 * Description:
 *           Create measure label for mean
 *
 * Parameters:
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
CREATE FUNCTION dbo.APB_CM_MeasureLabel (
         @Theme_ID           int,
         @MeasureType        tinyint,
         @MeasureSubtype     smallint
       ) RETURNS varchar(256)
AS
BEGIN
  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
      @MEASURE_MEAN                         int,
      @MEASURE_PROPORTION                   int,
      @MEASURE_N_SIZE                       int

  SET @MEASURE_MEAN                         = dbo.APB_CM_Constant('MEASURE_MEAN')
  SET @MEASURE_PROPORTION                   = dbo.APB_CM_Constant('MEASURE_PROPORTION')
  SET @MEASURE_N_SIZE                       = dbo.APB_CM_Constant('MEASURE_N_SIZE')


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @QstnCore        int,
          @ScaleID         int
  

  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------
  
  --
  -- Find question
  --
  SELECT @QstnCore = MAX(QstnCore)
    FROM APB_wk_ApThemeQuestions
   WHERE Theme_ID = @Theme_ID

  --
  -- Find scale
  --
  SELECT @ScaleID = ScaleID
    FROM APB_wk_Questions
   WHERE QstnCore = @QstnCore
  
  --
  -- Create measure label based on measure type
  --
  IF (@MeasureType = @MEASURE_MEAN)
      RETURN dbo.APB_CM_MeasureLabelForMean(@QstnCore, @ScaleID)
  ELSE IF (@MeasureType = @MEASURE_PROPORTION)
      RETURN dbo.APB_CM_MeasureLabelForProportion(@QstnCore, @MeasureSubtype)
  ELSE IF (@MeasureType = @MEASURE_N_SIZE)
      RETURN dbo.APB_CM_MeasureLabelForNSize()
  
  RETURN NULL
  
END

GO
