--
-- Run on datamart DB
--

SET NOCOUNT ON

DECLARE @QualiSysServer       sysname,
        @TableName            sysname,
        @Study                sysname,
        @PrevStudy            sysname,
        @Study_ID             int,
        @id                   int,
        @Sql                  varchar(8000),
        @i                    int,
        @TableCount           varchar(10),
        @HasSpecialSampleSet  bit


--
-- Find the server for QualiSys database
--
SELECT @QualiSysServer = strParam_Value
  FROM Datamart_Params
 WHERE strParam_NM = 'QualPro Server'


--
-- Pull sample sets that don't use meta date field as cutoff date.
-- These sample sets may use return date or sample create date as 
-- cutoff date. For these sample sets, we will populate the sample
-- enounter column with null value. For the other sample set we
-- will populate the sample encounter column and copy the date
-- from report date colum
--
EXEC dbo.CM_DropTable 'dbo.#StudySampleSet'

CREATE TABLE dbo.#StudySampleSet (
        Study_ID         int NOT NULL,
        SampleSet_ID     int NOT NULL,
       PRIMARY KEY CLUSTERED (
        Study_ID,
        SampleSet_ID
       )
)

SET @Sql = '
     INSERT INTO #StudySampleSet
     SELECT sv.Study_ID,
            ss.SampleSet_ID
       FROM ' + @QualiSysServer + 'QP_Prod.dbo.SampleSet ss,
            ' + @QualiSysServer + 'QP_Prod.dbo.Survey_Def sv
      WHERE ss.intDateRange_Table_ID IS NULL
        AND sv.Survey_ID = ss.Survey_ID
    '

EXEC(@Sql)


EXEC dbo.CM_DropTable 'dbo.#SampleSet'

CREATE TABLE dbo.#SampleSet (
        SampleSet_ID     int NOT NULL PRIMARY KEY CLUSTERED,
)


--
-- Save big table list in a temp table
--
SELECT ur.name + '.' + ob.name AS TableName,
       ur.name AS Study,
       ob.id
  INTO dbo.#Table
  FROM sysobjects ob,
       sysusers ur
 WHERE ob.name LIKE 'big_table_%'
   AND (
        ob.name >= 'big_table_2005_4'
        OR ob.name = 'big_table_null'
       )
   AND ob.xtype = 'U'
   AND ur.uid = ob.uid


--
-- Get count of big tables
--
SELECT @TableCount = COUNT(*)
  FROM #Table


--
-- Loop through each big table to back populate "datSampleEncounterDate" field
--
DECLARE curTable CURSOR LOCAL FOR
SELECT TableName,
       Study,
       id
  FROM #Table
 ORDER BY TableName


OPEN curTable
FETCH curTable INTO @TableName, @Study, @id

SET @i = 1
SET @PrevStudy = ''

WHILE @@FETCH_STATUS = 0 BEGIN
    
    PRINT '(' + CONVERT(varchar, @i) + ' of ' + @TableCount + ').  ' +
         @TableName + ' ...' + REPLICATE(' ', 60)
    
    SET @Study_ID = SUBSTRING(@Study, 2, 100)
    
    
    --
    -- If current study is not the same as previous, 
    -- recreate big_table_view on the previous study's big tables
    --
    IF (@PrevStudy <> '' AND @PrevStudy <> @Study) BEGIN
        EXEC dbo.sp_dbm_makeview @PrevStudy, 'Big_Table'
    END

    IF (@PrevStudy <> @Study) BEGIN
        SET @PrevStudy = @Study

        --
        -- Find if any sampleset in this study using return date or sample create date
        -- as cutoff date.
        --
        TRUNCATE TABLE #SampleSet
    
        INSERT INTO #SampleSet
        SELECT SampleSet_ID
          FROM #StudySampleSet
         WHERE Study_ID = @Study_ID

        IF @@ROWCOUNT > 0 SET @HasSpecialSampleSet = 1
        ELSE SET @HasSpecialSampleSet = 0
    END
    
    
    --
    -- If column "datSampleEncounterDate" already exists, do nothing
    --
    IF EXISTS (
        SELECT name
          FROM syscolumns
         WHERE id = @id
           AND name = 'datSampleEncounterDate'
       ) GOTO NextLoop
    
    
    --
    -- Append column "datSampleEncounterDate"
    --
    SET @Sql = '
         ALTER TABLE ' + @TableName + '
           ADD datSampleEncounterDate datetime NULL
        '

    EXEC(@Sql)


    --
    -- Populate value to column "datSampleEncounterDate" for sampleset using meta
    -- date field as cutoff date
    -- For samplesets using return date or sample create date as cutoff date field:
    --   the column "datSampleEncounterDate" will be null;
    -- for other samplesets:
    --   copy the date from "datReportDate" to "datSampleEncounterDate"
    --
    
    -- Some sample sets in this study use return date or sample create date as cutoff date field
    IF (@HasSpecialSampleSet = 1) BEGIN
        PRINT '    Some sample sets in this study use return date or sample create date as cutoff date field'
        
        SET @Sql = '
             UPDATE bt
                SET datSampleEncounterDate = bt.datReportDate
               FROM ' + @TableName + ' bt
                    LEFT JOIN #SampleSet ss
                      ON bt.SampleSet_ID = ss.SampleSet_ID
              WHERE ss.SampleSet_ID IS NULL
            '
    END
    -- All the sample sets in this study use meta date field as cutoff date field
    ELSE BEGIN
        PRINT '    All the sample sets in this study use meta date field as cutoff date field'
        
        SET @Sql = '
             UPDATE ' + @TableName + '
                SET datSampleEncounterDate = datReportDate
            '
    END
    
    EXEC(@Sql)

NextLoop:
    SET @i = @i + 1
    FETCH curTable INTO @TableName, @Study, @id
END

CLOSE curTable
DEALLOCATE curTable


--
-- recreate big_table_view on the last study's big tables
--
IF (@PrevStudy <> '') BEGIN
    EXEC dbo.sp_dbm_makeview @PrevStudy, 'Big_Table'
END


SELECT 'Completed!' AS Result
