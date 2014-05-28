/*******************************************************************************
 *
 * Procedure Name:
 *           sp_LoadApply
 *
 * Description:
 *           Apply the data from load table to live table
 *           There are 2 flags indicate the status of the records in load table
 *
 *           ExistFlg
 *              0: Those records that do not have matched record in live table
 *              1: Those records that have matched records in live table by
 *                 match keys.
 *
 *           LatestFlg:
 *              0: "Old data", which means primary key value of this record is
 *                 less than another record which has the same match fields
 *              1: "Latest data", which means primary key value of this record
 *                 is larger than any other records which have the same match
 *                 fields
 *
 *           Process:
 *              For "Population_Load",
 *                 If record "ExistFlg" is 1 or "LatestFlg" is 0
 *                    If there is a field in another load table (say <Tbl_A>)
 *                    which has the same name as the primary key field in table
 *                    "Population_Load", replace this field in <Tbl_A> with the
 *                    primary key of the matched record in table "Population".
 *                 If record "ExistFlg" is 1 and "LatestFlg" is 1
 *                    Replace all the fields except primary key and match key
 *                    fields in table "Population" with the data in
 *                    "Population_Load"
 *                 If record "ExistFlg" is 0 and "LatestFlg" is 1
 *                    Copy the record from table "Population_Load" to
 *                    "Population"
 *
 *              For other load table,
 *                 If record "ExistFlg" is 0 and "LatestFlg" is 1
 *                    Copy the record from load table to live table
 *              
 * Parameters:
 *           @pstrStudy_ID varchar(30)
 *              Study ID
 *           @pintBadRecords int OUTPUT
 *              Bad record number in table "Population_Load"
 *              Bad records are defined as population records which share the
 *              same population key field but the match fields are different.
 *            Note:
 *              Since population key field normally is an identity column,
 *              and everytime we delete table "Population_Load" before we do
 *              the data load, there should be no record in "Population_Load"
 *              which share the same population key with record in "Population".
 *              But anyway I will keep this process.
 *
 * Return:
 *           0:      succeed
 *           1:      failed to replace quotes in load table
 *           2:      failed to get the key field of "Population" table
 *           3:      failed to get match fields of "Population" table
 *           4:      failed to get bad record number of "Population_Load" table
 *           5:      failed to create temporary table "#LoadRef"
 *           6:      failed to create reference data in table "#LoadRef"
 *           7:      failed to update load population primary key found in other
 *                   load tables
 *           8:      failed to update live population record with the match
 *                   record in load table
 *           9:      failed to copy new data from table "Population_Load" to
 *                   "Population"
 *           10:     failed to get the key field
 *           11:     failed to get match fields
 *           12:     failed to copy new data from load table to live table
 *
 * History:
 *           1.0  05/12/1999 by RPEASLEY
 *           2.0  05/27/1999 by RPEASLEY
 *                CHANGE FOR INSERTING ONLY THE LAST RECORD BASED IN MATCH FIELD
 *           3.0  06/17/1999 by RPEASLEY
 *                CHANGE FOR FIXING AMBIGIOUS FIELD REFERNECE
 *           4.0  07/29/1999 by RPEASLEY
 *                CHANGE FOR FIXING PERFOMANCE AND ORPHAN PROBLEMS
 *           5.0  07/30/1999 by RPEASLEY
 *                CHANGE FOR RETURNING BADRECORD COUNT
 *           6.0  01/29/2001 by Brian Dohmen
 *                THE TEMP TABLE #LOADIDBAD COULD ALSO BE OUTPUT OR PROCESSED
 *                IF REQUIRED
 *                Corrected typo in the final update statement.  This statement
 *                updates metafields for records that are already in the live
 *                tables.
 *           7.0  06/21/2001 by Brian Dohmen
 *                Added if loop to only update population records.
 *           8.0  12/16/2002 by Brian Mao
 *                Rewrote for the readability and preformance issue
 *
 * Note:
 *           When move to production DB, the following changes need to be done:
 *           (1) Change SP name to "sp_LoadApply"
 *           (2) Change the DB name from "QP_Test" to "QP_Prod"
 *           (3) Change called SP name from "bm_ImpWiz_ReplaceQuotes" to
 *               "sp_ImpWiz_ReplaceQuotes"
 *
 ******************************************************************************/

CREATE PROC dbo.bm_LoadApply (
                @pstrStudy_ID varchar(30),
                @pintBadRecords int OUTPUT
            )
AS
  SET NOCOUNT ON
  
  -- Constants
  DECLARE @POPULATION           varchar(30)
  
  -- Variables
  DECLARE @intReturn            int,
          @intStudy_ID          int,
          @strPopPK             varchar(20),
          @strField             varchar(200),
          @strSQL               varchar(8000),
          @strSQLPart1          varchar(8000),
          @strSQLPart2          varchar(8000),
          @strSQLPart3          varchar(8000),
          @strSQLPart4          varchar(8000),
          @strPopTable          varchar(50),
          @strPopLoadTable      varchar(50),
          @strTable             varchar(20),
          @strPK                varchar(20),
          @strLiveTable         varchar(50),
          @strLoadTable         varchar(50),
          @datTime              datetime
  
  -- Init
  SET @POPULATION = 'Population'
  SET @intStudy_ID = CONVERT(int, @pstrStudy_ID)
  SET @strPopTable = 'S' + @pstrStudy_ID + '.' + @POPULATION
  SET @strPopLoadTable = @strPopTable + '_Load'
  BEGIN TRAN
  
  -- Repace character <'> and <"> with <`> in the string type columns
  -- in load tables
  -- SET @datTime = GetDate()
  EXEC @intReturn = bm_ImpWiz_ReplaceQuotes @intStudy_ID
  IF (@intReturn <> 0) RETURN 1
  --SELECT 'Replace quotes ' + CONVERT(varchar, DATEDIFF(millisecond, @datTime, GETDATE()))
  
  /*****************************************************************************
   *
   * Section 1. Apply "Population" load table to live for a study
   * 
   * 1. Calculate bad record number in table "Population_Load"
   *
   * 2. Apply for "Population" data
   *    If record "ExistFlg" is 1 or "LatestFlg" is 0
   *       If there is a field in another load table (say <Tbl_A>) which
   *       has the same name as the primary key field in table
   *       "Population_Load", replace this field in <Tbl_A> with the
   *       primary key of the matched record in table "Population".
   *    If record "ExistFlg" is 1 and "LatestFlg" is 1
   *       Replace all the fields except primary key and match key
   *       fields in table "Population" with the data in "Population_Load"
   *    If record "ExistFlg" is 0 and "LatestFlg" is 1
   *       Copy the record from table "Population_Load" to "Population"
   *
   ****************************************************************************/

  ------------------------------------------------------------------------------
  -- Get primary key of table "Population" 
  -- If no primary key, end procedure
  ------------------------------------------------------------------------------
  EXEC @intReturn = dbo.sp_LoadApply_PK @intStudy_ID,
                                        @POPULATION,
                                        @strPopPK OUTPUT
  IF (@intReturn <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 2
  END
  
  ------------------------------------------------------------------------------
  -- Retrieve match fields, build the component for the SQL statements used
  -- in the next processes.
  -- If no match field, end procedure
  ------------------------------------------------------------------------------
  EXEC @intReturn = dbo.sp_LoadApply_MatchField @intStudy_ID,
                                                @POPULATION,
                                                @strSQLPart1 OUTPUT,
                                                @strSQLPart2 OUTPUT,
                                                @strSQLPart3 OUTPUT,
                                                @strSQLPart4 OUTPUT
  IF (@intReturn <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 3
  END
  
  ------------------------------------------------------------------------------
  -- Calculate bad record number in table "Population_Load"
  --
  -- Suppose for the table "Population", the primary key is "Pop_ID", and match
  -- fields are "MemberID" and "SurveyID", the insert SQL statement will look
  -- like the following:
  -- 
  --    SELECT COUNT(*)
  --    FROM S1048.Population_Load ld,
  --         S1048.Population lv
  --    WHERE ld.Pop_ID = lv.Pop_ID
  --    AND (ld.MemberID <> lv.MemberID OR
  --         ld.SurveyID <> lv.SurveyID
  --        )
  --
  ------------------------------------------------------------------------------
  CREATE TABLE #Temp(Cnt int)
  
  SET @strSQL = ''
  SET @strSQL = @strSQL + ' INSERT INTO #Temp'
  SET @strSQL = @strSQL + ' SELECT COUNT(*) Cnt'
  SET @strSQL = @strSQL + ' FROM ' + @strPopLoadTable + ' ld,'
  SET @strSQL = @strSQL + '      ' + @strPopTable + ' lv'
  SET @strSQL = @strSQL + ' WHERE ld.' + @strPopPK + ' = lv.' + @strPopPK
  SET @strSQL = @strSQL + ' AND (' + @strSQLPart4
  SET @strSQL = @strSQL + '     )'

  EXEC(@strSQL)
  IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 4
  END
  
  SELECT @pintBadRecords = Cnt
  FROM #Temp
  
  DROP TABLE #Temp
  
  
  ------------------------------------------------------------------------------
  -- Create temp table saving the match relationship between table 
  -- "Population" and "Population_Load", and also the flags for each record
  -- in table "Population_Load"
  -- 
  -- The insert SQL statement will look like the following:
  --
  --    INSERT INTO #LoadRef (
  --            LiveID,
  --            LoadID,
  --            ExistFlg,
  --            LatestFlg
  --           )
  --    SELECT ISNULL(lv.Pop_ID, ldg.Pop_ID) AS LiveID,
  --           ld.Pop_ID AS LoadID,
  --           CASE
  --             WHEN lv.Pop_ID IS NULL  THEN 0
  --             ELSE 1
  --             END AS ExistFlg,
  --           CASE
  --             WHEN ld.Pop_ID = ldg.Pop_ID THEN 1
  --             ELSE 0
  --             END AS LatestFlg
  --    FROM S1048.Population_Load ld
  --         JOIN
  --         (
  --          SELECT MemberID
  --                 , SurveyID
  --                 , MAX(Pop_ID) Pop_ID
  --          FROM S1048.Population_Load
  --          GROUP BY
  --                MemberID
  --                , SurveyID
  --         ) ldg
  --           ON (ld.MemberID = ldg.MemberID
  --               AND ld.SurveyID = ldg.SurveyID
  --           )
  --         LEFT OUTER JOIN S1048.Population lv
  --           ON (ld.MemberID = lv.MemberID
  --               AND ld.SurveyID = lv.SurveyID
  --           )  
  ------------------------------------------------------------------------------

/* 
  -- Used for comparing performance between w or w/o index.
  -- The Result shows better performance w/o index

  CREATE TABLE #LoadRef (
       LoadID int,
       LiveID int,
       existflg tinyint,
       latestflg tinyint
  )
*/
  CREATE TABLE #LoadRef (
       LoadID int,
       LiveID int,
       existflg bit,
       latestflg bit
  )

  IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 5
  END
  
  SET @strSQL = ''
  SET @strSQL = @strSQL + ' INSERT INTO #LoadRef ('
  SET @strSQL = @strSQL + '         LiveID,'
  SET @strSQL = @strSQL + '         LoadID,'
  SET @strSQL = @strSQL + '         ExistFlg,'
  SET @strSQL = @strSQL + '         LatestFlg'
  SET @strSQL = @strSQL + '        )'
  SET @strSQL = @strSQL + ' SELECT ISNULL(lv.' + @strPopPK + ', ldg.' + @strPopPK + ') AS LiveID,'
  SET @strSQL = @strSQL + '        ld.' + @strPopPK + ' AS LoadID,'
  SET @strSQL = @strSQL + '        CASE'
  SET @strSQL = @strSQL + '          WHEN lv.' + @strPopPK + ' IS NULL THEN 0'
  SET @strSQL = @strSQL + '          ELSE 1'
  SET @strSQL = @strSQL + '          END AS ExistFlg,'
  SET @strSQL = @strSQL + '        CASE'
  SET @strSQL = @strSQL + '          WHEN ld.' + @strPopPK + ' = ldg.' + @strPopPK + ' THEN 1'
  SET @strSQL = @strSQL + '          ELSE 0'
  SET @strSQL = @strSQL + '          END AS LatestFlg'
  SET @strSQL = @strSQL + ' FROM ' + @strPopLoadTable + ' ld'
  SET @strSQL = @strSQL + '      JOIN'
  SET @strSQL = @strSQL + '      ('
  SET @strSQL = @strSQL + '       SELECT ' + @strSQLPart1
  SET @strSQL = @strSQL + '              , MAX(' + @strPopPK + ') ' + @strPopPK
  SET @strSQL = @strSQL + '       FROM ' + @strPopLoadTable
  SET @strSQL = @strSQL + '       GROUP BY'
  SET @strSQL = @strSQL + '             ' + @strSQLPart1
  SET @strSQL = @strSQL + '      ) ldg'
  SET @strSQL = @strSQL + '        ON (' + @strSQLPart2
  SET @strSQL = @strSQL + '        )'
  SET @strSQL = @strSQL + '      LEFT OUTER JOIN ' + @strPopTable + ' lv'
  SET @strSQL = @strSQL + '        ON (' + @strSQLPart3
  SET @strSQL = @strSQL + '        )'

  EXEC(@strSQL)
  IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 6
  END

/*
  CREATE INDEX #Idn_LoadRef_1
  ON #LoadRef(ExistFlg, LatestFlg)

  UPDATE STATISTICS #LoadRef
*/

  ------------------------------------------------------------------------------
  -- Update load population primary key if found in other load tables
  --
  -- The update SQL statement will look like the following:
  --
  --    UPDATE ld
  --    SET Pop_ID = rf.LiveID
  --    FROM S1048.Encounter_Load ld,
  --         #LoadRef rf
  --    WHERE (rf.ExistFlg = 1 OR
  --           rf.LatestFlg = 0
  --          )
  --    AND ld.Pop_ID = rf.LoadID
  ------------------------------------------------------------------------------
  DECLARE curTable CURSOR FOR
  SELECT DISTINCT
         t.strTable_nm
  FROM MetaTable t,
       MetaStructure s,
       MetaField f
  WHERE t.Study_id = @intStudy_ID
  AND t.StrTable_Nm <> @POPULATION
  AND s.Table_ID = t.Table_ID
  AND s.Field_ID = f.Field_ID
  AND f.strField_nm = @strPopPK

  OPEN curTable 
  FETCH NEXT FROM curTable INTO @strTable
  WHILE (@@FETCH_STATUS = 0 ) BEGIN
      SET @strSQL = ''
      SET @strSQL = @strSQL + ' UPDATE ld'
      SET @strSQL = @strSQL + ' SET ' + @strPopPK + ' = rf.LiveID'
      SET @strSQL = @strSQL + ' FROM S' + @pstrStudy_ID + '.' + @strTable + '_Load ld,'
      SET @strSQL = @strSQL + '      #LoadRef rf'
      SET @strSQL = @strSQL + ' WHERE (rf.ExistFlg = 1 OR'
      SET @strSQL = @strSQL + '        rf.LatestFlg = 0'
      SET @strSQL = @strSQL + '       )'
      SET @strSQL = @strSQL + ' AND ld.' + @strPopPK + ' = rf.LoadID'
      
      EXEC(@strSQL)
      IF (@@ERROR <> 0) BEGIN
          CLOSE curTable
          DEALLOCATE curTable
          ROLLBACK TRAN
          RETURN 7
      END
      
      FETCH NEXT FROM curTable INTO @strTable
  END
  CLOSE curTable
  DEALLOCATE curTable
  
  ------------------------------------------------------------------------------
  -- Update live population record with the match record in load table
  --
  -- The update SQL statement will look like the following:
  --
  --     UPDATE lv
  --     SET LangID = ld.LangID,
  --         Del_Pt = ld.Del_Pt,
  --         ...
  --     FROM #LoadRef rf,
  --          S1048.Population lv,
  --          S1048.Population_Load ld
  --     WHERE rf.ExistFlg = 1
  --     AND rf.LatestFlg = 1
  --     AND rf.LiveID = lv.Pop_ID
  --     AND rf.LoadID = ld.Pop_ID
  ------------------------------------------------------------------------------
  DECLARE curUpdateField CURSOR FOR
  SELECT  f.strField_nm + ' = ld.' + f.strField_nm 
  FROM MetaTable t,
       MetaStructure s,
       MetaField f
  WHERE t.Study_id = @intStudy_ID
  AND t.StrTable_Nm = @POPULATION
  AND s.Table_ID = t.Table_ID
  AND s.Field_ID = f.Field_ID
  AND s.BitMatchField_Flg <> 1
  AND s.BitKeyField_flg <> 1
  AND f.StrField_nm NOT IN ('NewRecordDate','NewRecordFlag')
  
  OPEN curUpdateField 
  FETCH NEXT FROM curUpdateField INTO @strField
  SET @strSQLPart1 = ''
  WHILE (@@FETCH_STATUS = 0 ) BEGIN
      IF (@strSQLPart1 <> '')
          SET @strSQLPart1 = @strSQLPart1 + ' , '
      SET @strSQLPart1 = @strSQLPart1 + @strField
      FETCH NEXT FROM curUpdateField INTO @strField
  END
  CLOSE curUpdateField
  DEALLOCATE curUpdateField
  
  IF (@strSQLPart1 <> '') BEGIN
      SET @strSQL = ''
      SET @strSQL = @strSQL + ' UPDATE lv'
      SET @strSQL = @strSQL + ' SET ' + @strSQLPart1
      SET @strSQL = @strSQL + ' FROM #LoadRef rf,'
      SET @strSQL = @strSQL + '      ' + @strPopTable + ' lv,'
      SET @strSQL = @strSQL + '      ' + @strPopLoadTable + ' ld'
      SET @strSQL = @strSQL + ' WHERE rf.ExistFlg = 1'
      SET @strSQL = @strSQL + ' AND rf.LatestFlg = 1'
      SET @strSQL = @strSQL + ' AND rf.LiveID = lv.' + @strPopPK
      SET @strSQL = @strSQL + ' AND rf.LoadID = ld.' + @strPopPK  

      EXEC(@strSQL)
      IF (@@ERROR <> 0) BEGIN
          ROLLBACK TRAN
          RETURN 8
      END
  END


  ------------------------------------------------------------------------------
  -- Copy new data from table "Population_Load" to "Population"
  --
  -- The insert SQL statement will look like the following:
  --
  --    INSERT INTO S1048.Population
  --    SELECT ld.*
  --    FROM #LoadRef rf,
  --         S1048.Population_Load ld
  --    WHERE rf.ExistFlg = 0
  --    AND rf.LatestFlg = 1
  --    AND rf.LoadID = ld.Pop_ID
  ------------------------------------------------------------------------------
  SET @strSQL = ''
  SET @strSQL = @strSQL + ' INSERT INTO ' + @strPopTable
  SET @strSQL = @strSQL + ' SELECT ld.*'
  SET @strSQL = @strSQL + ' FROM #LoadRef rf,'
  SET @strSQL = @strSQL + '      ' + @strPopLoadTable + ' ld'
  SET @strSQL = @strSQL + ' WHERE rf.ExistFlg = 0'
  SET @strSQL = @strSQL + ' AND rf.LatestFlg = 1'
  SET @strSQL = @strSQL + ' AND rf.LoadID = ld.' + @strPopPK
  
  EXEC(@strSQL)
  IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 9
  END
  

  /*****************************************************************************
   *
   * Section 2. Apply all load tables to live for a study except "Population"
   *
   ****************************************************************************/

  ------------------------------------------------------------------------------
  -- Retrive tables except "Population"
  ------------------------------------------------------------------------------
  DECLARE curTable CURSOR FOR
  SELECT strTable_nm
  FROM MetaTable
  WHERE Study_id = @intStudy_ID
  AND StrTable_Nm <> @POPULATION
  
  OPEN curTable 
  FETCH NEXT FROM curTable INTO @strTable
  WHILE (@@FETCH_STATUS = 0 ) BEGIN
      ------------------------------------------------------------------------------
      -- Get primary key of table
      -- If no primary key, end procedure
      ------------------------------------------------------------------------------
      EXEC @intReturn = dbo.sp_LoadApply_PK @intStudy_ID, @strTable, @strPK OUTPUT
      IF (@intReturn <> 0) BEGIN
          CLOSE curTable
          DEALLOCATE curTable
          ROLLBACK TRAN
          RETURN 10
      END
      
      ------------------------------------------------------------------------------
      -- Retrieve match fields, build the component for the SQL statements used
      -- in the next processes.
      -- If no match field, end procedure
      ------------------------------------------------------------------------------
      EXEC @intReturn = dbo.sp_LoadApply_MatchField @intStudy_ID,
                                                    @strTable,
                                                    @strSQLPart1 OUTPUT,
                                                    @strSQLPart2 OUTPUT,
                                                    @strSQLPart3 OUTPUT,
                                                    @strSQLPart4 OUTPUT
      IF (@intReturn <> 0) BEGIN
          CLOSE curTable
          DEALLOCATE curTable
          ROLLBACK TRAN
          RETURN 11
      END

      -- Set table name
      SET @strLiveTable = 'S' + @pstrStudy_ID + '.' + @strTable
      SET @strLoadTable = @strLiveTable + '_Load'
      
      ------------------------------------------------------------------------------
      -- Copy new data from load table live
      --
      -- Suppose for the table "Encounter", the primary key is "Enc_ID", and match
      -- fields are "FacilityNum" and "VisitNum", the insert SQL statement will look
      -- like the following:
      --
      --    INSERT INTO S1048.Encounter
      --    SELECT ld.*
      --    FROM S1048.Encounter_Load ld
      --         JOIN
      --         (
      --          SELECT FacilityNum
      --                 , VisitNum
      --                 , MAX(Enc_ID) Enc_ID
      --          FROM S1048.Encounter_Load
      --          GROUP BY
      --                FacilityNum
      --                , VisitNum
      --         ) ldg
      --           ON (ld.FacilityNum = ldg.FacilityNum
      --               AND ld.VisitNum = ldg.VisitNum
      --           )
      --         LEFT OUTER JOIN S1048.Encounter lv
      --           ON (ld.FacilityNum = ldg.FacilityNum
      --               AND ld.VisitNum = lv.VisitNum
      --           )
      --    WHERE ld.Enc_ID = ldg.Enc_ID
      --    AND lv.Enc_ID IS NULL
      --
      ------------------------------------------------------------------------------
      SET @strSQL = ''
      SET @strSQL = @strSQL + ' INSERT INTO ' + @strLiveTable
      SET @strSQL = @strSQL + ' SELECT ld.*'
      SET @strSQL = @strSQL + ' FROM ' + @strLoadTable + ' ld'
      SET @strSQL = @strSQL + '      JOIN'
      SET @strSQL = @strSQL + '      ('
      SET @strSQL = @strSQL + '       SELECT ' + @strSQLPart1
      SET @strSQL = @strSQL + '              , MAX(' + @strPK + ') ' + @strPK
      SET @strSQL = @strSQL + '       FROM ' + @strLoadTable
      SET @strSQL = @strSQL + '       GROUP BY'
      SET @strSQL = @strSQL + '             ' + @strSQLPart1
      SET @strSQL = @strSQL + '      ) ldg'
      SET @strSQL = @strSQL + '        ON (' + @strSQLPart2
      SET @strSQL = @strSQL + '        )'
      SET @strSQL = @strSQL + '      LEFT OUTER JOIN ' + @strLiveTable + ' lv'
      SET @strSQL = @strSQL + '        ON (' + @strSQLPart3
      SET @strSQL = @strSQL + '        )'
      SET @strSQL = @strSQL + ' WHERE ld.' + @strPK + ' = ldg.' + @strPK
      SET @strSQL = @strSQL + ' AND lv.' + @strPK + ' IS NULL'

      EXEC(@strSQL)
      IF (@@ERROR <> 0) BEGIN
          CLOSE curTable
          DEALLOCATE curTable
          ROLLBACK TRAN
          RETURN 12
      END
      
      FETCH NEXT FROM curTable INTO @strTable
  END
  CLOSE curTable
  DEALLOCATE curTable
    
  ------------------------------------------------------------------------------
  -- End
  ------------------------------------------------------------------------------
  COMMIT TRAN
  RETURN 0


