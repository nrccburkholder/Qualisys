/*
	S59 ATL-946
	Medusa ETL: Lag time calculation business logic bug fix

	Dave Gilsdorf

	ALTER PROCEDURE [dbo].[SP_Extract_HCAHPSDispositionBigTable]
*/
use qp_comments
go
ALTER PROCEDURE [dbo].[SP_Extract_HCAHPSDispositionBigTable]
  @indebug BIT = 0
AS
BEGIN
  -- 8/9/2006 - SJS -
  -- Created to update the HDisposition disposition column in the BigTable each night during the extract.
  -- 10/19/09 - MWB -
  -- Split proc to only work with HCAHPS Surveys.  we have a new proc to deal with HHCAHPS surveyTypes.
  -- 12/02/11 - DRM -
  -- Added HNumAttempts.
  -- 02/27/2013 DBG
  -- if there are any records in qualisys.qp_prod.dbo.medusaEtlFilterStudy, only process the studies listed there
  -- otherwise, process all studies.

  -- Modified 06/16/2014 TSB - update *CAHPSDisposition table references to use SurveyTypeDispositions table

  --declare @indebug bit
  SET arithabort ON

  DECLARE @study    VARCHAR(20),
          @SQL      VARCHAR(1000),
          @rec      INT,
          @BT       VARCHAR(50),
          @study_id INT
  -- DRM 12/02/11 HNumAttempts
  DECLARE @samplepop_id INT,
          @datlogged    DATETIME,
          @sentmail_id  INT
  -- DRM 3/1/2011 HNumAttempts fix
  DECLARE @tmp_count INT

  -- Get distinct list of studies we will be working with
  CREATE TABLE #AllSP (study_id     INT,
                       samplepop_id INT)

  CREATE INDEX ix_AllSP
    ON #AllSP (samplepop_id)

  CREATE TABLE #DispoNew (study_id     INT,
                          samplepop_id INT)

  CREATE INDEX ix_DispoNew
    ON #disponew (samplepop_id)

  -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id.
  CREATE TABLE #DispoWork (study_id        INT,
                           survey_id       INT,
                           samplepop_id    INT,
                           Disposition_id  INT,
                           DatLogged       DATETIME,
                           DaysFromCurrent INT,
                           DaysFromFirst   INT,
                           bitEvaluated    BIT,
                           ReceiptType_id  INT)

  CREATE INDEX ix_DispoWork
    ON #DispoWork (samplepop_id, disposition_id, datLogged)

  CREATE TABLE #UpdateBT (rec          INT IDENTITY(1, 1),
                          study_id     INT,
                          survey_id    INT,
                          samplepop_id INT,
                          BT           VARCHAR(100),
                          bitEvaluated BIT DEFAULT 0)

  CREATE TABLE #ULoop (BT VARCHAR(100))

  CREATE TABLE #tblStudy (study_id INT,
                          study    VARCHAR(10))

  CREATE TABLE #Del (study_id     INT,
                     samplepop_id INT)

  -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id, sentmail_id, datlogged.
  CREATE TABLE #Dispo (Study_id        INT,
                       survey_id       INT,
                       SamplePop_id    INT,
                       Disposition_id  INT,
                       HCAHPSHierarchy INT,
                       HCAHPSValue     CHAR(2),
                       ReceiptType_id  INT,
                       Sentmail_id     INT,
                       DatLogged       DATETIME)

  -- DRM 12/02/11 HNumAttempts - Added HNumAttempts, ReceiptType_id, survey_id, sentmail_id, datlogged, disposition_id.
  CREATE TABLE #SampDispo (Study_id       INT,
                           survey_id      INT,
                           SamplePop_id   INT,
                           HCAHPSValue    CHAR(2),
                           bitEvaluated   BIT DEFAULT 0,
                           LagTime        INT DEFAULT 0,
                           HNumAttempts   INT,
                           ReceiptType_id INT,
                           Sentmail_id    INT,
                           DatLogged      DATETIME,
                           Disposition_id INT)

  -- DRM 12/02/11 HNumAttempts - Added temp tables for iterating through affected samplepop_ids.
  CREATE TABLE #tmp_samplepops (samplepop_id INT,
                                datlogged    DATETIME)

  CREATE TABLE #tmp_samplepops2 (samplepop_id INT,
                                 sentmail_id  INT)

  SET NOCOUNT ON

  -- GATHER WORK
  INSERT INTO #AllSP
              (study_id,
               samplepop_id)
  --select 1563, 69032326
  SELECT dl.study_id,
         dl.samplepop_id
  FROM   dbo.DispositionLog dl,
         dbo.clientstudysurvey css
  WHERE  dl.survey_ID = css.survey_ID
         AND css.surveyType_Id = 2
         AND dl.bitEvaluated = 0

  IF EXISTS (SELECT *
             FROM   qualisys.qp_prod.dbo.medusaEtlFilterStudy)
    DELETE a
    FROM   #AllSP a
           LEFT OUTER JOIN qualisys.qp_prod.dbo.medusaEtlFilterStudy fs
                        ON a.study_id = fs.study_id
    WHERE  fs.study_id IS NULL

  IF EXISTS (SELECT *
             FROM   #allsp)
    BEGIN
      --commented out 4/6/2010 MWB b/c we now have several SPs that work with Dispo log and they each only handle
      --the correct surveyTypes worth of data via the #ALLSP temp table.  No need to remove invalid entries.
      ---- First update DispositionLog for any dispositions that are NOT HCAHPS/HHCAHPS and have a
      --bitEvaluated = 0 (SET=1)
      --UPDATE dl SET bitEvaluated = 1, DateEvaluated = getdate()
      --FROM DispositionLog dl, Dispositions_view d, #AllSP sp, clientstudysurvey css
      --WHERE dl.disposition_id = d.disposition_id AND
      --dl.samplepop_id = sp.samplepop_id AND
      --css.survey_Id = dl.survey_ID AND
      --d.HCAHPSValue IS NULL AND
      --css.surveyType_ID not in (2, 3) AND
      --dl.bitEvaluated = 0
      --Update the bitEvaluated flag and set it to 1 for all dispositionlog table having
      --DaysFromFirst > 42 (Don't Fit the HCAHPS Specs)
      UPDATE dl
      SET    dl.bitEvaluated = 1,
             DateEvaluated = Getdate()
      FROM   dbo.DispositionLog dl,
             #AllSP sp,
             dbo.clientstudysurvey css
      WHERE  dl.samplepop_id = sp.samplepop_id
             AND css.survey_ID = dl.survey_Id
             AND css.surveyType_ID = 2
             AND dl.DaysFromFirst > 42
             AND dl.bitEvaluated = 0

      -- PROCESS WORK
      -- Now lets work to update the Big_Table for the work we have identified.
      INSERT INTO #tblStudy
                  (study_id,
                   study)
      SELECT DISTINCT
             dl.study_id,
             's'
             + CONVERT(VARCHAR, dl.study_id) AS study
      FROM   dbo.dispositionlog dl,
             #AllSP sp
      WHERE  dl.samplepop_id = sp.samplepop_id
             AND dl.bitEvaluated = 0

      CREATE CLUSTERED INDEX cix_study
        ON #tblstudy(study_id)

      SELECT DISTINCT
             table_schema
             + '.'
             + table_name studytbl,
             column_name
      INTO   #HAV_HDISPCOL
      FROM   INFORMATION_SCHEMA.COLUMNS c,
             #tblStudy s
      WHERE  c.table_schema = s.study
             AND COLUMN_NAME = 'HDisposition'
             AND TABLE_NAME NOT LIKE '%VIEW%'

      -- Find out what base tables are home for the samplepop we will be working with.
      SELECT TOP 1 @study_id = study_id,
                   @study = study
      FROM   #tblStudy

      WHILE @@ROWCOUNT > 0
        BEGIN
          -- GET samplepops that have HCAHPS dispositions that need to be evaluated (bitEvaluated = 0)
          TRUNCATE TABLE #DispoNew

          INSERT INTO #DispoNew
                      (study_id,
                       samplepop_id)
          SELECT DISTINCT
                 dl.study_id,
                 dl.samplepop_id
          FROM   dbo.DispositionLog dl,
                 --dbo.clientstudySurvey css, -- the records in #AllSP are already for surveys with surveytype_id=2, so there's no need to join to clientstudysurvey and filter on surveytype_id=2
                 #AllSP sp
          WHERE  dl.bitEvaluated = 0
                 AND dl.study_id = @study_id
                 AND dl.samplepop_id = sp.samplepop_id
                 --AND css.surveyType_ID = 2  -- plus, this is the only place CSS is mentioned in the where clause - there's no joining logic (which should probably be dl.survey_id=css.survey_id)

          -- Find all logged dispositions for samplepops identified in #DispoNew
          TRUNCATE TABLE #DispoWork

          -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id
          INSERT INTO #DispoWork
                      (study_id,
                       survey_id,
                       samplepop_id,
                       disposition_id,
                       datLogged,
                       DaysFromCurrent,
                       DaysFromFirst,
                       bitEvaluated,
                       ReceiptType_id)
          SELECT dl.study_id,
                 dl.survey_id,
                 dl.samplepop_id,
                 dl.disposition_id,
                 dl.datLogged,
                 dl.DaysFromCurrent,
                 dl.DaysFromFirst,
                 dl.bitEvaluated,
                 dl.ReceiptType_id
          FROM   dbo.DispositionLog dl,
                 #disponew dn,
                 dbo.clientstudysurvey css
          WHERE  dl.study_id = dn.study_id
                 AND dl.samplepop_id = dn.samplepop_id
                 AND css.survey_Id = dl.survey_Id
                 AND css.SurveyType_Id = 2

          SELECT '#DispoWork'

          SELECT *
          FROM   #DispoWork

          TRUNCATE TABLE #UpdateBT

          SET @SQL = 'INSERT INTO #UpdateBT (study_id, survey_id, samplepop_id, BT) '
                     + ' SELECT DISTINCT n.study_Id, b.survey_id, n.samplepop_id, '''
                     + @study
                     + '.'' + b.tablename AS BT FROM '
                     + @study
                     + '.big_table_view b, #DispoNew n '
                     + ' WHERE b.samplepop_id = n.samplepop_id '
                     + ' and b.tablename >= ''big_table_2011_4'''

          IF @indebug = 1
            PRINT @sql

          EXEC (@SQL)

          --******** DRM
          -- and b.tablename >= ''big_table_2011_4''
          -- Update dispostionlog set bitEvaluated = 1 WHERE samplepops belong to a Non-HCAHPS survey
          TRUNCATE TABLE #DEL

          INSERT INTO #del
                      (study_id,
                       samplepop_id)
          SELECT u.study_id,
                 u.samplepop_id
          FROM   #updatebt u,
                 dbo.clientstudysurvey c
          WHERE  u.survey_id = c.survey_id
                 AND c.surveytype_id NOT IN (2, 3)
                 AND u.study_id = @study_id

          INSERT INTO #DEL
                      (study_id,
                       samplepop_id)
          SELECT    study_id,
                    samplepop_id
          FROM      #updatebt u
          LEFT JOIN #hav_hdispcol hc
                 ON u.bt = hc.studytbl
          WHERE     column_name IS NULL

          --Update dispostionLog set bitEvaluated = 1 for dispostions that belong to
          --samplepops prior to I1 HCAHPS samplesets (12/1/2005) - They don't have a column to Update
          --MWB 12-2-09 b/c of HCAHPS and HHCAHPS both sharing dispoLog we no longer
          --set all non HCAHPS = bitEvaluated = 1 otherwise it would not evaulate the
          --HHCHAPS Records
          --UPDATE dl SET dl.bitEvaluated = 1, DateEvaluated = getdate()
          --FROM DispositionLog dl, #del d WHERE dl.samplepop_id = d.samplepop_id
          --AND dl.bitEvaluated = 0
          --Now delete the samplepops from #updateBT
          DELETE u
          FROM   #updatebt u,
                 #del d
          WHERE  u.samplepop_id = d.samplepop_id

          --Calcuate the current the HCAHPSValue for the samplepop
          TRUNCATE TABLE #Dispo

          -- DRM 12/02/11 HNumAttempts - Added Receipttype_id, survey_id, datlogged.
		  -- TSB 06/16/2014 use surveytypedispositions table instead of hcahpsdispositions
          INSERT INTO #Dispo
                      (Study_id,
                       survey_id,
                       SamplePop_id,
                       Disposition_id,
                       HCAHPSHierarchy,
                       HCAHPSVALUE,
        ReceiptType_id,
                       datlogged)
          SELECT dw.study_id,
                 dw.survey_id,
                 dw.SamplePop_id,
                 d.Disposition_id,
                 hd.Hierarchy,
                 hd.Value,
                 dw.ReceiptType_id,
                 dw.datlogged
          FROM   #dispowork dw,
                 dbo.disposition d,
                 dbo.surveytypedispositions hd,
                 #updateBT u
          WHERE  d.Disposition_id = dw.Disposition_id
                 AND d.disposition_ID = hd.disposition_ID
                 AND dw.samplepop_id = u.samplepop_id
                 AND dw.DaysFromFirst < 43
				 AND hd.surveytype_id = 2

          TRUNCATE TABLE #SampDispo

          INSERT INTO #SampDispo
                      (Study_id,
                       survey_id,
                       SamplePop_id,
                       HCAHPSValue)
          SELECT t.Study_id,
                 t.survey_id,
                 t.SamplePop_id,
                 HCAHPSValue
          FROM   #Dispo t,
                 (SELECT SamplePop_id,
                         Min(HCAHPSHierarchy) HCAHPSHierarchy
                  FROM   #Dispo
                  GROUP  BY SamplePop_id) a
          WHERE  t.SamplePop_id = a.SamplePop_id
                 AND t.HCAHPSHierarchy = a.HCAHPSHierarchy
          GROUP  BY t.Study_id,
                    t.survey_id,
                    t.SamplePop_id,
                    HCAHPSValue

          -- UPDATE BIG_TABLE DISPOSTION
          -- Loop through each study, and update the Big_Table HCAHPSValue field
          -- ONLY if the HCAHPSValue is NOT NULL (Meaning it has a previous value
          -- either a default or prior disposition value)
          TRUNCATE TABLE #ULoop

          INSERT INTO #ULoop
                      (BT)
          SELECT DISTINCT
                 BT
          FROM   #UpdateBT
          WHERE  study_id = @study_id

          SELECT TOP 1 @BT = bt
          FROM   #ULoop

          WHILE @@ROWCOUNT > 0
            BEGIN
              --LagTime calcs
              --  --Step 1: If initial "08" population, lagtime = datmailed + 42 - dischargedate
              --  select dateadd(dd,42,sm.datmailed) datmailed, schm.samplepop_id
              --  into #tmp
              --  from qualisys.qp_prod.dbo.sentmailing sm inner join qualisys.qp_prod.dbo.scheduledmailing schm
              --   on sm.sentmail_id = schm.sentmail_id
              --  inner join #SampDispo sd
              --   on schm.samplepop_id = sd.samplepop_id
              --  where sd.HCAHPSValue = '08'
              --  select max(datmailed) datmailed, samplepop_id
              --  into #tmp_datmailed
              --  from #tmp
              --  group by samplepop_id
              --  set @sql = 'UPDATE sd SET lagtime = abs(datediff(dd, dm.datmailed, bt.dischargedate))
              --      FROM ' + @BT + ' bt, #SampDispo sd, #tmp_datmailed dm WHERE bt.samplepop_id = sd.samplepop_id -
              --      AND bt.samplepop_id = dm.samplepop_id'
              --  if @indebug = 1 PRINT @SQL
              --  EXEC (@SQL)
              --select * from #sampdispo
              --DRM 12/27/2011 Add check to make sure Lagtime exists in big_table
              --
              -----------------------------------------------------------------------------------------
              SELECT @sql = 'if not exists (select 1 from information_schema.columns '
                            + 'where column_name = ''lagtime'' '
                            + ' and table_schema + ''.'' + table_name = '''
                            + @BT
                            + ''' )
							begin
								alter table ' + @BT + ' add LagTime int
								exec sp_dbm_makeview ''s' + Cast(@study_id AS VARCHAR) + ''', ''big_table''
							end'

      EXEC (@sql)

              --
              --Step 1: If returns exist, lagtime = returndate - dischargedate
              --
              --2013-05-08 Lee Kohrs commented out "Replace(@BT, 'big_table', 'study_results')"
              --           and added "LEFT(@BT, len(@BT) -16) + 'study_results_work' "
              --           Per TR#10 of HCAHPS 2012 Audit Project.
              SET @sql = 'UPDATE sd SET lagtime = abs(datediff(dd, sr.datreturned, bt.dischargedate)) FROM '
                         + @BT
                         + ' bt, '
                         --+ Replace(@BT, 'big_table', 'study_results')
                         + LEFT(@BT, len(@BT) -16) -- Pick off the schema_name
              --
              IF (EXISTS (SELECT *
                          FROM   INFORMATION_SCHEMA.TABLES
                          WHERE  table_schema = LEFT(@BT, len(@BT) - 17)
                                 AND table_name = 'study_results_work'))
                --2013-05-22 Lee Kohrs Recoded this section to test for the existence of the work table first.
                --          If it exists, use it.  If not, look to the live study_results table instead.
                SET @SQL = @SQL
                           + 'study_results_work'
              ELSE
                SET @SQL = @SQL
                           + 'study_results' + RIGHT(@BT, 7)

              --2013-05-08 Lee Kohrs Added ' AND sd.hcahpsvalue IN (''01'',''06'')'.
              --           Per TR#9 of HCAHPS 2012 Audit Project.
              SET @SQL = @SQL

                         + ' sr, #SampDispo sd '
                         + ' WHERE bt.samplepop_id = sd.samplepop_id '
                         + ' AND bt.samplepop_id = sr.samplepop_id '
						 + ' and bt.Sampleunit_id = sr.SampleUnit_id '
                         + ' AND sd.lagtime = 0'
                         + ' AND sd.hcahpsvalue IN (''01'',''06'')'
						 -- this assumes that any patient with a dispo of 01 or 06 will have a non-null datReturned. Which, yes, should be true. But what if it's not? LagTime would be NULL
              --if @indebug = 1
              PRINT @SQL

              IF EXISTS (SELECT 1
                         FROM   information_schema.tables
                         WHERE  table_schema
                                + '.'
                                + table_name = Replace(@BT, 'big_table', 'study_results'))
                EXEC (@SQL)

              --
              --Step 2: If undeliverable, lagtime = datundeliverable - dischargedate
              --
              --2013-05-08  Lee Kohrs changed 'bt.datundeliverable is null' to 'bt.datundeliverable is NOT null'.
              --            Per the HCAHPS 2012 Audit project Technical Requirements Document, item TR#11
              SET @sql = 'UPDATE sd SET lagtime = isnull(abs(datediff(dd, '
                         + ' bt.datundeliverable, bt.dischargedate)), 0) '
                         + ' FROM '
                         + @BT
                         + ' bt, #SampDispo sd WHERE bt.samplepop_id = sd.samplepop_id '
                         + ' AND sd.lagtime = 0 and bt.datundeliverable is NOT null'

              --if @indebug = 1
              PRINT @SQL

              EXEC (@SQL)

              --2013-06-05 Lee Kohrs added this select statement for the LagTime Issues in the HCAHPS 2012 Audit Project
              --This select statement obtains the most recent 'datLogged' from the dispositionLog that has a
              --'DaysFromFirst' value less than 43.  There can be multiple records for the same SamplePop_ID in
              --a study and the proc was previously using the first record that arbitrarily came up.
              --Step 3: Else, lagtime = disposition date - dischargedate

			  -- 2014-06-16 TSB using surveytypedisposition table instead of hcahpsdispositions
              SET @sql = 'UPDATE sd SET lagtime = abs(datediff(dd, (SELECT TOP 1 x.datlogged
                                      FROM   dbo.dispositionlog x
                                      WHERE  x.samplepop_id = dw.samplepop_id
                              AND x.study_id = dw.study_id
                                             AND x.DaysFromFirst < 43
                                      ORDER  BY datLogged DESC), bt.dischargedate)) '
                         + ' FROM '
                         + @BT
                         + ' bt, #SampDispo sd, #dispowork dw, surveytypedispositions hd '
                         + ' WHERE bt.samplepop_id = sd.samplepop_id and bt.samplepop_id = dw.samplepop_id '
                         + ' and sd.hcahpsvalue = hd.value '
                         + ' and hd.disposition_id = dw.disposition_id '
                         + ' AND sd.lagtime = 0 '
						 + ' AND hd.surveytype_id = 2'

              --if @indebug = 1
              PRINT @SQL

              EXEC (@SQL)

              --************************
              --**    HNumAttempts
              --************************
              IF @indebug = 1
                SELECT 'one'

              IF @indebug = 1
                SELECT *
                FROM   #dispo

              IF @indebug = 1
                SELECT *
                FROM   #sampdispo

              UPDATE dw
              SET    sentmail_id = qdl.sentmail_id
              FROM   #dispo dw
                     INNER JOIN qualisys.qp_prod.dbo.dispositionlog qdl
                             ON dw.samplepop_id = qdl.samplepop_id
                                AND dw.disposition_id = qdl.disposition_id
                                AND dw.datlogged = qdl.datlogged

              IF @indebug = 1
                SELECT     *
                FROM       #dispo dw
                INNER JOIN qualisys.qp_prod.dbo.dispositionlog qdl
                        ON dw.samplepop_id = qdl.samplepop_id
                           AND dw.disposition_id = qdl.disposition_id
                           AND dw.datlogged = qdl.datlogged

              IF @indebug = 1
                SELECT     *
                FROM       #dispo dw
                INNER JOIN (SELECT samplepop_id,
                                   Max(sentmail_id) sentmail_id
                            FROM   #dispo
                            GROUP  BY samplepop_id) dw2
                        ON dw.samplepop_id = dw2.samplepop_id
                WHERE      dw.sentmail_id IS NULL

              UPDATE dw
              SET    sentmail_id = dw2.sentmail_id
              FROM   #dispo dw
                     INNER JOIN (SELECT samplepop_id,
                                        Max(sentmail_id) sentmail_id
                                 FROM   #dispo
                                 GROUP  BY samplepop_id) dw2
                             ON dw.samplepop_id = dw2.samplepop_id
              WHERE  dw.sentmail_id IS NULL

              IF @indebug = 1
                BEGIN
                  SELECT *
                  FROM   #dispo
                END

              IF @indebug = 1
                SELECT 'two'

              IF @indebug = 1
                SELECT *
                FROM   #dispo

              IF @indebug = 1
                SELECT *
                FROM   #sampdispo

              UPDATE sd
              SET    sentmail_id = dw.sentmail_id,
                     receipttype_id = dw.receipttype_id,
                     datlogged = dw.datlogged
              FROM   #sampdispo sd
                     INNER JOIN #dispo dw
                             ON sd.samplepop_id = dw.samplepop_id
                                AND sd.hcahpsvalue = dw.hcahpsvalue

              -- and sd.datlogged = dw.datlogged
              IF @indebug = 1
                SELECT     *
                FROM       #sampdispo sd
                INNER JOIN #dispo dw
                        ON sd.samplepop_id = dw.samplepop_id
                           AND sd.hcahpsvalue = dw.hcahpsvalue

              IF @indebug = 1
                SELECT 'three'

  IF @indebug = 1
                SELECT *
                FROM   #dispo

              IF @indebug = 1
                SELECT *
                FROM   #sampdispo

              --Phone methodology where receipttype_id = 12
              TRUNCATE TABLE #tmp_samplepops

              --
              --TR#8 LeeKohrs 2013-07-22 HCAHPS2012 HnumAttempts part 1 fix
              INSERT INTO #tmp_samplepops
                          (samplepop_id,
                           datlogged)
              SELECT     DISTINCT
                         sd.samplepop_id,
                         sd.datlogged
              FROM       #sampdispo sd
              INNER JOIN QUALISYS.QP_PROD.DBO.SCHEDULEDMAILING SCHM
                      ON SD.Sentmail_id = SCHM.SENTMAIL_ID
                         AND sd.samplepop_id = schm.samplepop_id
              INNER JOIN qualisys.qp_prod.dbo.mailingmethodology mm
                      ON SCHM.METHODOLOGY_ID = mm.METHODOLOGY_ID
              WHERE      sd.receipttype_id = 12
                         --AND mm.bitactivemethodology = 1 --Lee Kohrs 2013-07-22 commented
                         AND mm.standardmethodologyid IN (2, 12)

              SELECT TOP 1 @samplepop_id = samplepop_id,
                           @datlogged = datlogged
              FROM   #tmp_samplepops

              WHILE (SELECT Count(*)
                     FROM   #tmp_samplepops) > 0
                BEGIN
                  -- DRM 3/1/2011 HNumAttempts fix
                  SELECT @tmp_count = Count(*)
                  FROM   dbo.dispositionlog --#dispo
                  WHERE  datlogged <= @datlogged
                         AND samplepop_id = @samplepop_id
                         AND receipttype_id = 12
                         AND loggedby <> '#nrcsql'

                  --Lee Kohrs added the following per TR#1 and TR#2 of HCAHPS 2012 Audit Project (Part 1 of 2).
                  --IF EXISTS (SELECT 1
                  --           FROM   dispositionlog
                  --           WHERE  samplepop_id = @samplepop_id
                  --                  AND disposition_id = 8
                  --                  AND loggedby = 'QSI Transfer Results Service')
                  --  SELECT @tmp_count = count(*)
                  --  FROM   dispositionlog
                  --  WHERE  samplepop_id = @samplepop_id
                  --         AND receipttype_id = 12
                  --         AND ((loggedby <> '#nrcsql'
                  --               AND disposition_id <> 8)
                  --               OR (loggedby = 'QSI Transfer Results Service'
                  --                   AND disposition_id = 8))
                  IF EXISTS (SELECT 1
                             FROM   dispositionlog
                             WHERE  samplepop_id = @samplepop_id
                                    AND disposition_id IN (8, 15))
                    SELECT @tmp_count = count(*)
                    FROM   dispositionlog
                    WHERE  samplepop_id = @samplepop_id
                           AND receipttype_id = 12
                           AND loggedby <> '#nrcsql'

                  IF @tmp_count > 5
                    SET @tmp_count = 5

                  UPDATE #sampdispo
                  SET    hnumattempts = @tmp_count
                  WHERE  samplepop_id = @samplepop_id

                  DELETE #tmp_samplepops
                  WHERE  samplepop_id = @samplepop_id

                  SELECT TOP 1 @samplepop_id = samplepop_id,
                               @datlogged = datlogged
                  FROM   #tmp_samplepops
                END

              --Phone methodology where receipttype_id <> 12
              TRUNCATE TABLE #tmp_samplepops

              --TR#8 Lee Kohrs 2013-07-22 HCAHPS2012 HnumAttempts part 2 fix
              INSERT INTO #tmp_samplepops
                          (samplepop_id,
                datlogged)
              SELECT     DISTINCT
                         sd.samplepop_id,
                         sd.datlogged
              FROM       #sampdispo sd
              INNER JOIN QUALISYS.QP_PROD.DBO.SCHEDULEDMAILING SCHM
                      ON SD.Sentmail_id = SCHM.SENTMAIL_ID
                         AND sd.samplepop_id = schm.samplepop_id
              INNER JOIN qualisys.qp_prod.dbo.mailingmethodology mm
                      ON SCHM.METHODOLOGY_ID = mm.METHODOLOGY_ID
              WHERE      sd.receipttype_id <> 12
                         --AND mm.bitactivemethodology = 1 --Lee Kohrs 2013-07-22 commented
                         AND mm.standardmethodologyid IN (2, 12)

              SELECT TOP 1 @samplepop_id = samplepop_id,
                           @datlogged = datlogged
              FROM   #tmp_samplepops

              WHILE (SELECT Count(*)
                     FROM   #tmp_samplepops) > 0
                BEGIN
                  -- DRM 3/1/2011 HNumAttempts fix
                  SELECT @tmp_count = Count(*)
                  FROM   dbo.dispositionlog --#dispo
                  WHERE  datlogged < @datlogged
                         AND samplepop_id = @samplepop_id
                         AND receipttype_id = 12
                         AND loggedby <> '#nrcsql'

                  --Lee Kohrs added the following per TR#1 and TR#2 of HCAHPS 2012 Audit Project (Part 2 of 2)
                  --IF EXISTS (SELECT 1
                  --           FROM   dispositionlog
                  --           WHERE  samplepop_id = @samplepop_id
                  --                  AND disposition_id = 8
                  --                  AND loggedby = 'QSI Transfer Results Service')
                  --  SELECT @tmp_count = count(*)
                  --  FROM   dispositionlog
                  --  WHERE  samplepop_id = @samplepop_id
                  --         AND receipttype_id = 12
                  --         AND ((loggedby <> '#nrcsql'
                  --               AND disposition_id <> 8)
                  --               OR (loggedby = 'QSI Transfer Results Service'
                  --                   AND disposition_id = 8))
                  IF EXISTS (SELECT 1
                             FROM   dispositionlog
                             WHERE  samplepop_id = @samplepop_id
                                    AND disposition_id IN (8, 15))
                    SELECT @tmp_count = count(*)
                    FROM   dispositionlog
                    WHERE  samplepop_id = @samplepop_id
                           AND receipttype_id = 12
                           AND loggedby <> '#nrcsql'

                  IF @tmp_count > 5
                    SET @tmp_count = 5

                  UPDATE #sampdispo
                  SET    hnumattempts = @tmp_count
                  WHERE  samplepop_id = @samplepop_id

                  DELETE #tmp_samplepops
                  WHERE  samplepop_id = @samplepop_id

                  SELECT TOP 1 @samplepop_id = samplepop_id,
                               @datlogged = datlogged
                  FROM   #tmp_samplepops
                END

              --Mail methodology
              TRUNCATE TABLE #tmp_samplepops2

              --TR#8 LeeKohrs 2013-07-22 HCAHPS2012 HnumAttempts part 3 fix
              INSERT INTO #tmp_samplepops2
                          (samplepop_id,
                           sentmail_id)
              SELECT     DISTINCT
                         sd.samplepop_id,
                         sd.sentmail_id
              FROM       #sampdispo sd
              INNER JOIN QUALISYS.QP_PROD.DBO.SCHEDULEDMAILING SCHM
                      ON SD.Sentmail_id = SCHM.SENTMAIL_ID
                         AND sd.samplepop_id = schm.samplepop_id
              INNER JOIN qualisys.qp_prod.dbo.mailingmethodology mm
                      ON SCHM.METHODOLOGY_ID = mm.METHODOLOGY_ID
              WHERE
                --mm.bitactivemethodology = 1 AND --Lee Kohrs 2013-07-22 commented out
                mm.standardmethodologyid IN (1, 9)

              --
              IF @indebug = 1
                SELECT *
                FROM   #tmp_samplepops2

              SELECT TOP 1 @samplepop_id = samplepop_id,
                           @sentmail_id = sentmail_id
              FROM   #tmp_samplepops2

              WHILE (SELECT Count(*)
                     FROM   #tmp_samplepops2) > 0
                BEGIN
                  SELECT @tmp_count = Count(*)
                  FROM   qualisys.qp_prod.dbo.scheduledmailing
                  --#dispo      -- DRM 3/1/2011 HNumAttempts fix
                  WHERE  sentmail_id <= @sentmail_id
                         AND samplepop_id = @samplepop_id
                         AND OverrideItem_ID IS NULL --Lee Kohrs 2013-07-17 added per HCAHPS2012 Audit item TR#5

                  --
                  --
                  --2013-05-08  Lee Kohrs commented out the following segment.
                  --            Per the HCAHPS 2012 Audit project Technical Requirements Document, item TR#12
                  --
                  --IF @tmp_count = 0
                  --  BEGIN
                  --      SELECT 'count=0'
                  --      SET @tmp_count = 1
                  --  END
                  --
                  UPDATE #sampdispo
                  SET    hnumattempts = @tmp_count
                  WHERE  samplepop_id = @samplepop_id

                  DELETE #tmp_samplepops2
                  WHERE  samplepop_id = @samplepop_id

                  SELECT TOP 1 @samplepop_id = samplepop_id,
                               @sentmail_id = sentmail_id
                  FROM   #tmp_samplepops2
                END

              IF @indebug = 1
                SELECT *
                FROM   #sampdispo

              --DRM 12/02/2011 Add check to make sure HNumAttempts exists in big_table
              SELECT @sql = 'if not exists (select 1 from information_schema.columns '
                            + ' where column_name = ''HNumAttempts'' '
                            + ' and table_schema + ''.'' + table_name = '''
                            + @BT
                            + ''' )
							begin
								alter table ' + @BT + ' add HNumAttempts int
								exec dbo.sp_dbm_makeview ''s' + Cast(@study_id AS VARCHAR) + ''', ''big_table''
							end'

              EXEC (@sql)

              --
              --TR#14 HCAHPS 2012 Audit project.
              --Lee Kohrs 2013-05-22 Added the following two update statements
              UPDATE #sampdispo
              SET    hnumattempts = 8
              WHERE  sentmail_id = -1

              -- Only update HCAHPS samplepops
              SET @SQL = 'UPDATE bt '
                         + ' SET HDisposition = sd.HCAHPSValue, '
                         + 'LagTime = sd.LagTime, '
                         + 'HNumAttempts = sd.HNumAttempts FROM '
                         + @BT
                         + ' bt, #SampDispo sd '
                         + 'WHERE bt.samplepop_id = sd.samplepop_id '
                         + 'AND bt.HDisposition IS NOT NULL'

              IF @indebug = 1
                PRINT @SQL

              EXEC (@SQL)

              UPDATE #sampdispo
              SET    bitEvaluated = 1
              FROM   #UpdateBT bt,
                     #SampDispo sd
              WHERE  bt.samplepop_id = bt.samplepop_id
                     AND bt.BT = @bt

              DELETE FROM #ULoop
              WHERE  @BT = bt

              SELECT TOP 1 @BT = bt
              FROM   #ULoop
            END

          -- Now we can update the bitEvaluated flag and set it to 1 for all
          -- dispositionlog table for which we have just updated Big_Table.
          UPDATE dl
          SET    dl.bitEvaluated = sd.bitEvaluated,
                 DateEvaluated = Getdate()
          FROM   dbo.DispositionLog dl,
                 #SampDispo sd
          WHERE  dl.study_id = sd.study_id
                 AND dl.samplepop_id = sd.samplepop_id
                 AND dl.bitEvaluated = 0

          DELETE FROM #tblStudy
          WHERE  study_id = @study_id

          SELECT TOP 1 @study_id = study_id,
                       @study = study
          FROM   #tblStudy
        END

      -- CLEAN UP
      DROP TABLE #UPDATEBT

      DROP TABLE #DEL

      DROP TABLE #ULOOP

      DROP TABLE #DISPONEW

      DROP TABLE #DISPOWORK

      DROP TABLE #DISPO

      DROP TABLE #SAMPDISPO

      DROP TABLE #tblStudy

      DROP TABLE #Hav_HDispCol

      DROP TABLE #tmp_samplepops

      DROP TABLE #tmp_samplepops2

      SET NOCOUNT OFF
    END

  DROP TABLE #AllSP

  RETURN
----------------------------------------------------------------------------------
END
GO