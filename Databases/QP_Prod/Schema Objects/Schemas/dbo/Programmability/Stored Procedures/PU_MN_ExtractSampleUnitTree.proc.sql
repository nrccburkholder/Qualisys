/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractSampleUnitTree
 *
 * Description:
 *           Extract sample unit tree using binary tree preorder traversal algorithm
 *
 *           eg.    a
 *                 / \
 *                b   c
 *               / \   \
 *              d  e    f
 *
 *      order is a -> b -> d -> e -> c -> f
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
CREATE PROCEDURE dbo.PU_MN_ExtractSampleUnitTree
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON
  
  DECLARE @DatamartServer     sysname,
          @Sql                varchar(8000),
          @intTier            tinyint,
          @intRowCount        int,
          @datBegin           datetime

  SELECT @datBegin = GETDATE()


  --
  -- Get datamart server name
  --
  SELECT @DatamartServer = strParam_Value 
    FROM QualPro_Params
   WHERE strParam_NM = 'Datamart'


  ---------------------------
  -- Sample Unit Tree
  ---------------------------

  CREATE TABLE #SampleUnitTree (
        SampleUnit_ID         int NOT NULL PRIMARY KEY,
        SamplePlan_ID         int NOT NULL,
        Survey_ID             int NULL,
        RootSampleUnit_ID     int NOT NULL,
        ParentSampleUnit_ID   int NULL,
        Target                int NULL,
        bitSuppress           bit NOT NULL DEFAULT 0,
        Tier                  tinyint NOT NULL,
        FullPath              varchar(500) NOT NULL
  )
  
  --
  -- Pull root sample unit
  --
  SET @intTier = 1
  
  INSERT INTO #SampleUnitTree (
          SampleUnit_ID,
          SamplePlan_ID,
          RootSampleUnit_ID,
          ParentSampleUnit_ID,
          Target,
          Tier,
          FullPath
         )
  SELECT SampleUnit_ID,
         SamplePlan_ID,
         SampleUnit_ID AS RootSampleUnit_ID,
         NULL AS ParentSampleUnit_ID,
         intTargetReturn,
         @intTier,
         RIGHT('00000000' + CONVERT(varchar, SampleUnit_ID), 9) AS FullPath
    FROM SampleUnit 
   WHERE ParentSampleUnit_ID IS NULL

  SELECT @intRowCount = @@ROWCOUNT

  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 1', @datBegin OUTPUT

  --
  -- Pull sample unit with tier of 2, 3, 4, ...
  -- until all the sample units are pulled
  --
  WHILE @intRowCount > 0 BEGIN
      SET @intTier = @intTier + 1

      INSERT INTO #SampleUnitTree (
              SampleUnit_ID,
              SamplePlan_ID,
              RootSampleUnit_ID,
              ParentSampleUnit_ID,
              Target,
              Tier,
              FullPath
             )
      SELECT su.SampleUnit_ID,
             su.SamplePlan_ID,
             sut.RootSampleUnit_ID,
             su.ParentSampleUnit_ID,
             su.intTargetReturn,
             @intTier,
             sut.FullPath + '-' +
               + RIGHT('00000000' + CONVERT(varchar, su.SampleUnit_ID), 9) AS FullPath
        FROM #SampleUnitTree sut,
             SampleUnit su 
       WHERE sut.Tier = @intTier - 1
         AND su.ParentSampleUnit_ID = sut.SampleUnit_ID

      SELECT @intRowCount = @@ROWCOUNT
/*
      PRINT 'Tier ' + CONVERT(varchar, @intTier) + ': ' + CONVERT(varchar, @intRowCount) + ' rows'
      EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 2', @datBegin OUTPUT
*/
  END

  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 2', @datBegin OUTPUT

  SET @Sql = '
       UPDATE ut
          SET Survey_ID = sp.Survey_ID,
              bitSuppress = ISNULL(su.bitSuppress, 0)
         FROM #SampleUnitTree ut,
              SamplePlan sp,
              ' + @DatamartServer + '.QP_Comments.dbo.SampleUnit su
        WHERE sp.SamplePlan_ID = ut.SamplePlan_ID
          AND su.SampleUnit_ID = ut.SampleUnit_ID
  '
  
  EXEC(@Sql)
  
  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 3', @datBegin OUTPUT


/*
  --
  -- Tree order
  --

  CREATE TABLE #SampleUnitTreeOrder (
          SampleUnit_ID      int NOT NULL,
          RootSampleUnit_ID  int NOT NULL,
          ID                 int NOT NULL IDENTITY(1,1),
          TreeOrder          smallint NULL
  )

  --
  -- Sort sample units by "FullPath" and give each unit an ID
  -- Using binary tree preorder traversal algorithm
  --
  INSERT INTO #SampleUnitTreeOrder (
          SampleUnit_ID,
          RootSampleUnit_ID
         )
  SELECT SampleUnit_ID,
         RootSampleUnit_ID
    FROM #SampleUnitTree
   ORDER BY
         FullPath

  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 4', @datBegin OUTPUT

  --
  -- The sample unit's TreeOrder = [unit's ID] - [root unit's ID] + 1
  --
  UPDATE uto
     SET TreeOrder = uto.ID - rto.ID + 1
    FROM #SampleUnitTreeOrder uto,    -- sample unit tree order
         #SampleUnitTreeOrder rto     -- root sample unit tree order
   WHERE uto.RootSampleUnit_ID = rto.SampleUnit_ID

  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 5', @datBegin OUTPUT
*/


  --
  -- Delete old data
  --
  TRUNCATE TABLE SampleUnitTree

  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 6', @datBegin OUTPUT

  --
  -- Output result
  --
  INSERT INTO dbo.SampleUnitTree (
          SampleUnit_ID,
          Survey_ID,
          RootSampleUnit_ID,
          ParentSampleUnit_ID,
          Target,
          bitSuppress,
          Tier
         )
  SELECT SampleUnit_ID,
         Survey_ID,
         RootSampleUnit_ID,
         ParentSampleUnit_ID,
         Target,
         bitSuppress,
         Tier
    FROM #SampleUnitTree
   WHERE Survey_ID IS NOT NULL
   ORDER BY
         FullPath
    
  
  IF (@@ERROR <> 0) RETURN 2

  EXEC dbo.PU_CM_TimeUsed '[PU_MN_ExtractSampleUnitTree] step 7', @datBegin OUTPUT

  UPDATE STATISTICS SampleUnitTree WITH FULLSCAN
  
  RETURN -1


