
IF EXISTS (SELECT *
             FROM DBO.SYSOBJECTS
            WHERE ID = OBJECT_ID(N'dbo.APB_CM_ConcateBreakoutSubset')
              AND XTYPE IN (N'FN', N'IF', N'TF')
          )
    DROP FUNCTION dbo.APB_CM_ConcateBreakoutSubset
GO

/*******************************************************************************
 *
 * Function Name:
 *           APB_CM_ConcateBreakoutSubset
 *
 * Description:
 *           {brief procedure description}
 *
 * Parameters:
 *
 * Return:
 *           {description}
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.APB_CM_ConcateBreakoutSubset (
        @Theme_ID      int,
        @Subset_ID     int
       ) RETURNS varchar(8000)
AS
BEGIN

  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE
      @YES                                  int,
      @NO                                   int

  SET @YES                                  = dbo.APB_CM_Constant('YES')
  SET @NO                                   = dbo.APB_CM_Constant('NO')


  --------------------------------------------------------------------
  -- Variables
  --------------------------------------------------------------------
  DECLARE @List                 varchar(8000),
          @PrevQstnCore         varchar(12),
          @QstnCore             varchar(12),
          @ResponseValue        varchar(12),
          @InSelection          char(1)


  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------

  DECLARE curSubset CURSOR LOCAL FOR
  SELECT tq.QstnCore,
         sc.ResponseValue,
         CASE
           WHEN ss.ResponseValue IS NOT NULL THEN @YES
           ELSE @NO
           END AS InSelection
    FROM APB_wk_ApThemeQuestions tq
         JOIN APB_wk_Questions qs
           ON tq.Theme_ID = @Theme_ID
              AND qs.QstnCore = tq.QstnCore
         JOIN APB_wk_Scales sc
           ON sc.ScaleID = qs.ScaleID
         LEFT JOIN APB_wk_ApSubsetDetail ss
           ON ss.Subset_ID = @Subset_ID
              AND ss.ResponseValue = sc.ResponseValue
   ORDER BY
         tq.QstnCore,
         sc.ResponseValue

  SET @List = ''
  SET @PrevQstnCore = 0
  
  OPEN curSubset
  FETCH curSubset INTO @QstnCore, @ResponseValue, @InSelection
  
  WHILE @@FETCH_STATUS = 0 BEGIN
      IF (@PrevQstnCore <> @QstnCore) BEGIN
          SET @List = @List + '|' + @QstnCore + ':'
          SET @PrevQstnCore = @QstnCore
      END
      SET @List = @List + @ResponseValue + ',' + @InSelection + ';'
      
      FETCH curSubset INTO @QstnCore, @ResponseValue, @InSelection
  END

  CLOSE curSubset
  DEALLOCATE curSubset

  RETURN @List

END
GO