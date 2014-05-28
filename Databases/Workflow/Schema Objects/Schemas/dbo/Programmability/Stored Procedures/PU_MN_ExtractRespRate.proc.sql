/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractRespRate
 *
 * Description:
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_MN_ExtractRespRate
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  -- Constants
  DECLARE @YES                     tinyint,
          @NO                      tinyint
  
  SET @YES = dbo.PU_CM_GetConstant('YES')
  SET @NO = dbo.PU_CM_GetConstant('NO')

  -- Variables
  DECLARE @DatamartServer    sysname,
          @Sql               varchar(8000)

  
  --
  -- Get datamart server name
  --
  SELECT @DatamartServer = strParam_Value 
    FROM Workflow_Params
   WHERE strParam_NM = 'Datamart'

  
  --
  -- Copy response rate table
  --
  EXEC dbo.CM_DropTable 'dbo.RespRateCount'

  SET @Sql = '
       SELECT SampleSet_ID,
              SampleUnit_ID,
              Survey_ID,
              intSampled,
              intUD,
              intReturned
         INTO dbo.RespRateCount
         FROM ' + @DatamartServer + '.QP_Comments.dbo.RespRateCount
      '

  EXEC(@Sql)

  --
  -- Create PK/index
  -- 
  --EXEC dbo.CM_CreatePK 'dbo.RespRateCount', 'SampleSet_ID, SampleUnit_ID', @NO
  EXEC dbo.CM_CreateIndex 'dbo.RespRateCount', 'Idx_RespRateCount_1', 'SampleSet_ID, Survey_ID', @YES
  
  --UPDATE STATISTICS RespRateCount WITH FULLSCAN

  
  RETURN -1


