




IF EXISTS (SELECT *
             FROM DBO.SYSOBJECTS
            WHERE ID = OBJECT_ID(N'dbo.APB_CM_MeasureLabelForNSize')
              AND XTYPE IN (N'FN', N'IF', N'TF')
          )
    DROP FUNCTION dbo.APB_CM_MeasureLabelForNSize
GO

/*******************************************************************************
 *
 * Function Name:
 *           APB_CM_MeasureLabelForNSize
 *
 * Description:
 *           Create measure label for N-Size
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
CREATE FUNCTION dbo.APB_CM_MeasureLabelForNSize (
       ) RETURNS varchar(256)
AS
BEGIN
  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
      @CMP_TYPE_N_SIZE                      int

  SET @CMP_TYPE_N_SIZE                      = dbo.APB_CM_Constant('CMP_TYPE_N_SIZE')


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @MeasureLabel    varchar(256)
  

  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------
  SELECT @MeasureLabel = Selection_Box
    FROM tbl_ComparisonDef
   WHERE CompType_ID = @CMP_TYPE_N_SIZE

  RETURN @MeasureLabel
  
END

GO
