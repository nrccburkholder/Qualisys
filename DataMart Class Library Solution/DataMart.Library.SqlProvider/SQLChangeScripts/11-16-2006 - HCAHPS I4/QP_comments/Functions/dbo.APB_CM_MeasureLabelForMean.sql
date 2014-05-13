

IF EXISTS (SELECT *
             FROM DBO.SYSOBJECTS
            WHERE ID = OBJECT_ID(N'dbo.APB_CM_MeasureLabelForMean')
              AND XTYPE IN (N'FN', N'IF', N'TF')
          )
    DROP FUNCTION dbo.APB_CM_MeasureLabelForMean
GO

/*******************************************************************************
 *
 * Function Name:
 *           APB_CM_MeasureLabelForMean
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
CREATE FUNCTION dbo.APB_CM_MeasureLabelForMean (
         @Qstncore int,
		 @ScaleID  int
       ) RETURNS varchar(256)
AS
BEGIN
  DECLARE @MinResponseValue    int,
          @MinScaleLabel       varchar(256),
          @MaxResponseValue    int,
          @MaxScaleLabel       varchar(256),
          @MeasureLabel        varchar(256)
  
  --
  -- Get min/max value by scale order
  --
  SELECT @MinResponseValue = ResponseValue,
         @MinScaleLabel = strScaleLabel
    FROM APB_wk_QuestionScaleRanking
   WHERE Qstncore = @Qstncore
     AND RankOrder = Max_RankOrder

  SELECT @MaxResponseValue = ResponseValue,
         @MaxScaleLabel = strScaleLabel
    FROM APB_wk_QuestionScaleRanking
   WHERE Qstncore = @Qstncore
     AND RankOrder = 1

  --
  -- If rank order is not defined, use response value
  --
  IF (@MinResponseValue IS NULL OR @MaxResponseValue IS NULL) BEGIN
  
      SELECT @MinResponseValue = MIN(ResponseValue),
             @MaxResponseValue = MAX(ResponseValue)
        FROM APB_wk_Scales
       WHERE ScaleID = @ScaleID

      SELECT @MinScaleLabel = strScaleLabel
        FROM APB_wk_Scales
       WHERE ScaleID = @ScaleID
         AND ResponseValue = @MinResponseValue

      SELECT @MaxScaleLabel = strScaleLabel
        FROM APB_wk_Scales
       WHERE ScaleID = ScaleID
         AND ResponseValue = @MaxResponseValue
  END

  --
  -- Generate value range label
  --  
  SET @MeasureLabel = 'Mean Rating ('
                      + CONVERT(varchar, @MinResponseValue)
                      + '=' + @MinScaleLabel
                      + '; ' +
                      + CONVERT(varchar, @MaxResponseValue)
                      + '=' + @MaxScaleLabel
                      + ')'

  RETURN @MeasureLabel
  
END

GO

