-- Flag SampleSet records that will be used to populate backgroung data in datamart "Big_Table" table(s).
-- Modified 6/24/04 SS
-- modified DBG 2/26/13 - added references to MedusaEtlFilterStudy and MedusaEtlFilterDate
CREATE PROCEDURE [dbo].[SP_Phase4_Web_Extract_Flg]
AS
  SET TRANSACTION isolation level READ uncommitted
  SET nocount ON

  -- if filtering the ETL for specific dates, there'll be a record in MedusaEtlFilterDate
  -- use that record to set @filterBeginDate and @filterEndDate
  DECLARE @filterBeginDate DATETIME,
          @filterEndDate   DATETIME

  SELECT @filterBeginDate = begindate,
         @filterEndDate = enddate
  FROM   dbo.MedusaEtlFilterDate

  -- if not filtering, set @filterBeginDate and @filterEndDate to a sufficently wide range.
  IF @filterBeginDate IS NULL
    SET @filterBeginDate = Dateadd(week, -13, Getdate())

  IF @filterEndDate IS NULL
    SET @filterEndDate = '12/31/2100'

  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#SampSet'))
    DROP TABLE #SampSet;

  CREATE TABLE #sampset (sampleset_id INT,
                         datMailed    DATETIME)

  -- Gather Smpleset.SampleSet_id WHERE SentMailing.datMailed is no more than 13 weeks old AND the SampleSet.Web_Extract_flg  is NULL.
  -- if filtering the ETL for specific studies, there'll be records in MedusaEtlFilterStudy
  IF EXISTS (SELECT *
             FROM   dbo.MedusaEtlFilterStudy)
    -- there are records in MedusaEtlFilterStudy, so add it into the query
    INSERT INTO #sampset
    SELECT ss.sampleset_id,
           sm.datmailed
    FROM   dbo.sampleset ss,
           dbo.samplepop sp,
           dbo.MedusaEtlFilterStudy sf,
           dbo.scheduledmailing schm,
           dbo.sentmailing sm
    WHERE  ss.web_extract_flg IS NULL
           AND ss.sampleset_id = sp.sampleset_id
           AND sp.study_id = sf.study_id
           AND sp.samplepop_id = schm.samplepop_id
           AND schm.sentmail_id = sm.sentmail_id
           --Lee Kohrs 2013-07-12 added "OR sm.DATMAILED IS NULL" per HCAHPS2012 Audit Project
           --          Technical Requirement TR#13 (SampleSet 929664 has a datmailed & a null)
           AND (sm.datmailed BETWEEN @filterBeginDate AND @filterEndDate
                 OR sm.DATMAILED IS NULL)
    GROUP  BY ss.sampleset_id,
              sm.datmailed
  ELSE
    -- there are no records in MedusaEtlFilterStudy, so process all studies.
    INSERT INTO #sampset
    SELECT ss.sampleset_id,
           sm.datmailed
    FROM   dbo.sampleset ss,
           dbo.samplepop sp,
           dbo.scheduledmailing schm,
           dbo.sentmailing sm
    WHERE  ss.web_extract_flg IS NULL
           AND ss.sampleset_id = sp.sampleset_id
           AND sp.samplepop_id = schm.samplepop_id
           AND schm.sentmail_id = sm.sentmail_id
           --Lee Kohrs 2013-07-12 added "OR sm.DATMAILED IS NULL" per HCAHPS2012 Audit Project
           --          Technical Requirement TR#13 (SampleSet 929664 has a datmailed & a null)
           AND (sm.datmailed BETWEEN @filterBeginDate AND @filterEndDate
                 OR sm.DATMAILED IS NULL)
    GROUP  BY ss.sampleset_id,
              sm.datmailed

  --
  -- Find and add return SampleSets not in mailed SampleSets -- Mod 6/24/04 SS
  -- Find all samplsets in this Extract's returns (qfe.Study_id IS NOT NULL)
  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#rtrnSampSet'))
    DROP TABLE #rtrnSampSet;

  CREATE TABLE #rtrnsampset (sampleset_id INT)

  INSERT INTO #rtrnsampset
              (sampleset_id)
  SELECT sp.sampleset_id
  FROM   dbo.questionform_extract qfe,
         dbo.questionform qf,
         dbo.samplepop sp,
         dbo.sampleset ss
  WHERE  qfe.study_id IS NOT NULL
         AND qfe.questionform_id = qf.questionform_id
         AND qf.samplepop_id = sp.samplepop_id
         AND sp.sampleset_id = ss.sampleset_id
  GROUP  BY sp.sampleset_id

  -- Add samplsets from returns that don't have a mail date
  INSERT INTO #sampset
              (sampleset_id)
  SELECT sampleset_id
  FROM   #rtrnsampset rss
  WHERE  NOT EXISTS (SELECT *
                     FROM   #sampset mss
                     WHERE  rss.sampleset_id = mss.sampleset_id)

  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#Remove'))
    DROP TABLE #Remove;

  CREATE TABLE #Remove (sampleset_id INT)

  INSERT INTO #Remove
              (sampleset_id)
  SELECT sampleset_id
  FROM   #sampset
  WHERE  datMailed IS NULL
  GROUP  BY sampleset_id

  DELETE ss
  FROM   #sampset ss,
         #Remove r
  WHERE  ss.sampleset_id = r.sampleset_id

  -- Update SampleSet.Web_Extract_flg for ONLY those SampleSet_id that were selected in the previous step.
  UPDATE ss
  SET    ss.web_extract_flg = 0
  FROM   dbo.sampleset ss,
         #sampset s
  WHERE  ss.sampleset_id = s.sampleset_id
         AND ss.web_extract_flg IS NULL

  ---- Cleanup
  --DROP TABLE #sampset
  --DROP TABLE #rtrnsampset
  SET TRANSACTION isolation level READ committed
  SET nocount OFF


