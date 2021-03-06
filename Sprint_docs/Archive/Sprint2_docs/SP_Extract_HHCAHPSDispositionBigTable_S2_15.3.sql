USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[SP_Extract_HHCAHPSDispositionBigTable]    Script Date: 6/16/2014 11:31:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[SP_Extract_HHCAHPSDispositionBigTable] @InDebug bit = 0
AS

 -- 8/9/2006 - SJS -
 -- Created to update the HDisposition disposition column in the BigTable each night during the extract.
 -- 10/19/09 - MWB -
 -- Split proc to only work with HHCAHPS Surveys.  we have a new proc to deal with HHHCAHPS surveyTypes.
 -- 11/12/09 - MWB -
 -- modified HHCHAPSValue to hold 3 characters instead of 2 (prior HCAHPSValue was only 2 chars.)
 --02/27/2013 DBG
 --if there are any records in qualisys.qp_prod.dbo.medusaEtlFilterStudy, only process the studies listed there
 --otherwise, process all studies.

 -- Modified 06/16/2014 TSB - update *CAHPSDisposition table references to use SurveyTypeDispositions table

 DECLARE @study VARCHAR(20), @SQL VARCHAR(1000), @rec INT, @BT VARCHAR(50), @study_id INT


  -- Get distinct list of studies we will be working with
  CREATE TABLE #AllSP (study_id INT, samplepop_id INT)
  CREATE INDEX ix_AllSP ON #AllSP (samplepop_id)
  CREATE TABLE #DispoNew (study_id INT, samplepop_id INT)
  CREATE INDEX ix_DispoNew ON #disponew (samplepop_id)
  CREATE TABLE #DispoWork (study_id INT, samplepop_id INT, Disposition_id INT, DatLogged DATETIME, DaysFromCurrent INT, DaysFromFirst INT, bitEvaluated BIT)
  CREATE INDEX ix_DispoWork ON #DispoWork (samplepop_id, disposition_id, datLogged)
  CREATE TABLE #UpdateBT (rec INT IDENTITY(1,1), study_id INT, survey_id INT, samplepop_id INT, BT VARCHAR(100), bitEvaluated BIT DEFAULT 0)
  CREATE TABLE #ULoop (BT VARCHAR(100))
  CREATE TABLE #tblStudy (study_id INT, study VARCHAR(10))
  CREATE TABLE #Del (study_id INT, samplepop_id INT)
  CREATE TABLE #Dispo (Study_id INT, SamplePop_id INT, Disposition_id INT, HHCAHPSHierarchy INT, HHCAHPSValue CHAR(3))
  CREATE TABLE #SampDispo (Study_id INT, SamplePop_id INT, HHCAHPSValue CHAR(3), bitEvaluated BIT DEFAULT 0)

 SET NOCOUNT ON
 -- GATHER WORK


INSERT INTO #AllSP (study_id, samplepop_id)
SELECT dl.study_id, dl.samplepop_id
FROM DispositionLog dl, clientstudysurvey css
WHERE	dl.survey_ID = css.survey_ID and
		css.surveyType_Id = 3 and
		dl.bitEvaluated = 0

if exists (select * from qualisys.qp_prod.dbo.medusaEtlFilterStudy)
	delete a
	from #AllSP a
		left outer join qualisys.qp_prod.dbo.medusaEtlFilterStudy fs
			on a.study_id=fs.study_id
	where fs.study_id is null


IF exists (select * from #allsp)
BEGIN

  --commented out 4/6/2010 MWB b/c we now have several SPs that work with Dispo log and they each only handle
  --the correct surveyTypes worth of data via the #ALLSP temp table.  No need to remove invalid entries.

  ---- First update DispositionLog for any dispositions that are NOT HHCAHPS and have a bitEvaluated = 0 (SET=1)
  --UPDATE dl SET bitEvaluated = 1, DateEvaluated = getdate()
  --FROM DispositionLog dl, Dispositions_view d, #AllSP sp, clientstudysurvey css
  --WHERE dl.disposition_id = d.disposition_id AND
  --dl.samplepop_id = sp.samplepop_id AND
  --css.survey_Id = dl.survey_ID AND
  --d.HHCAHPSValue IS NULL AND
  --css.surveyType_ID not in (2,3) AND
  --dl.bitEvaluated = 0

  if @indebug = 1 select 'Records in DispoLog' [countRecs], * from dispositionlog where bitEvaluated = 0

  -- Update the bitEvaluated flag and set it to 1 for all dispositionlog table having DaysFromFirst > 42 (Don't Fit the HHCAHPS Specs)
  UPDATE dl SET dl.bitEvaluated = 1, DateEvaluated = getdate()
  FROM DispositionLog dl, #AllSP sp, clientstudysurvey css
  WHERE dl.samplepop_id = sp.samplepop_id AND
  css.survey_ID = dl.survey_Id AND
  css.surveyType_ID = 3 AND
  dl.DaysFromFirst > 42 AND
  dl.bitEvaluated = 0

 -- PROCESS WORK
 -- Now lets work to update the Big_Table for the work we have identified.

  INSERT INTO #tblStudy (study_id, study)
  SELECT DISTINCT dl.study_id, 's' + CONVERT(VARCHAR,dl.study_id) AS study
  FROM dispositionlog dl, #AllSP sp
  WHERE dl.samplepop_id = sp.samplepop_id AND dl.bitEvaluated = 0
  CREATE CLUSTERED INDEX cix_study ON #tblstudy(study_id)

  if @indebug = 1 select '#tblStudy' [#tblStudy], * from #tblStudy

  SELECT DISTINCT table_schema + '.' + table_name studytbl, column_name
  INTO #HAV_HDISPCOL
  FROM INFORMATION_SCHEMA.COLUMNS c, #tblStudy s
  WHERE c.table_schema = s.study
  AND COLUMN_NAME = 'HHDisposition' AND TABLE_NAME NOT LIKE '%VIEW%'

  -- Find out what base tables are home for the samplepop we will be working with.

  SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy
  WHILE @@ROWCOUNT > 0
  BEGIN

  -- GET samplepops that have HHCAHPS dispositions that need to be evaluated (bitEvaluated = 0)
  TRUNCATE TABLE #DispoNew
  INSERT INTO #DispoNew (study_id, samplepop_id)
  SELECT DISTINCT dl.study_id, dl.samplepop_id
  FROM  DispositionLog dl, clientstudySurvey css, #AllSP sp
  WHERE dl.bitEvaluated = 0 and
  dl.study_id = @study_id  AND
  dl.samplepop_id = sp.samplepop_id and
  css.surveyType_ID = 3

 if @indebug = 1 select '#DispoNew' [#DispoNew], * from #DispoNew

   -- Find all logged dispositions for samplepops identified in #DispoNew
   TRUNCATE TABLE #DispoWork
   INSERT INTO #DispoWork (study_id, samplepop_id, disposition_id, datLogged, DaysFromCurrent, DaysFromFirst, bitEvaluated)
   SELECT dl.study_id, dl.samplepop_id, dl.disposition_id, dl.datLogged, dl.DaysFromCurrent, dl.DaysFromFirst, dl.bitEvaluated
   FROM DispositionLog dl, #disponew dn, clientstudysurvey css
   WHERE dl.study_id = dn.study_id and dl.samplepop_id = dn.samplepop_id and css.survey_Id = dl.survey_Id and css.SurveyType_Id = 3

   if @indebug = 1 select '#DispoWork' [#DispoWork], * from #DispoWork
   if @indebug = 1 select '#DispoWork with ReceiptType_ID' [#DispoWork], dw.*, qf.receipttype_ID from #DispoWork dw, qualisys.qp_prod.dbo.questionform qf where  qf.samplepop_ID = dw.samplepop_Id

    TRUNCATE TABLE #UpdateBT
    SET @SQL = 'INSERT INTO #UpdateBT (study_id, survey_id, samplepop_id, BT) SELECT DISTINCT n.study_Id, b.survey_id, n.samplepop_id, ''' +
    @study + '.'' + b.tablename AS BT FROM ' + @study + '.big_table_view b, #DispoNew n WHERE b.samplepop_id = n.samplepop_id'
    if @indebug = 1 print @sql
    EXEC (@SQL)


 if @indebug = 1 select '#UpdateBT' [#UpdateBT], * from #UpdateBT

   -- Update dispostionlog set bitEvaluated = 1 WHERE samplepops belong to a Non-HHCAHPS survey
   TRUNCATE TABLE #DEL

   INSERT INTO #del (study_id, samplepop_id)
   SELECT u.study_id, u.samplepop_id
   FROM  #updatebt u, clientstudysurvey c
   WHERE u.survey_id = c.survey_id and
   c.surveytype_id not in (2,3) AND
   u.study_id = @study_id

   INSERT INTO #DEL (study_id, samplepop_id)
   SELECT study_id, samplepop_id
   FROM #updatebt u
   LEFT JOIN #hav_hdispcol hc ON u.bt = hc.studytbl WHERE column_name IS NULL

   -- Update dispostionLog set bitEvaluated = 1 for dispostions that belong to samplepops prior to I1 HHCAHPS samplesets (12/1/2005) - They don't have a column to Update
   --MWB 12-2-09 b/c of HCAHPS and HHCAHPS both sharing dispoLog we no longer set all non HHCAHPS = bitEvaluated = 1 otherwise it would not evaulate the HCHAPS Records
   --UPDATE dl SET dl.bitEvaluated = 1, DateEvaluated = getdate() FROM DispositionLog dl, #del d WHERE dl.samplepop_id = d.samplepop_id AND dl.bitEvaluated = 0

   -- Now delete the samplepops from #updateBT
   DELETE u FROM #updatebt u, #del d WHERE u.samplepop_id = d.samplepop_id

 if @indebug = 1 select '#UpdateBT after #del' [#UpdateBT], bt.*, qf.receipttype_Id from #UpdateBT bt, qualisys.qp_prod.dbo.questionform qf where  qf.samplepop_ID = bt.samplepop_Id


   --Calcuate the current the HHCAHPSValue for the samplepop
   -- TSB 06/16/2014 use surveytypedispositions table instead of hhcahpsdispositions
   TRUNCATE TABLE #Dispo
   INSERT INTO #Dispo (Study_id, SamplePop_id, Disposition_id, HHCAHPSHierarchy, HHCAHPSVALUE)
   SELECT dw.study_id, dw.SamplePop_id, d.Disposition_id, hd.Hierarchy, hd.Value
   FROM #dispowork dw, disposition d, surveytypedispositions hd, #updateBT u, qualisys.qp_prod.dbo.questionform qf
   WHERE d.Disposition_id = dw.Disposition_id and
   d.disposition_ID = hd.disposition_ID AND
   dw.samplepop_id = u.samplepop_id AND
   u.samplepop_ID = qf.samplepop_ID and
   (qf.receiptType_ID = hd.ReceiptType_ID or hd.ReceiptType_ID is null) and
   dw.DaysFromFirst<43
   and hd.surveytype_id = 3

 if @indebug = 1 select '#Dispo' [#Dispo], * from #Dispo


   TRUNCATE TABLE #SampDispo
   INSERT INTO #SampDispo (Study_id, SamplePop_id, HHCAHPSValue)
   SELECT t.Study_id, t.SamplePop_id, HHCAHPSValue
   FROM #Dispo t, (SELECT SamplePop_id, MIN(HHCAHPSHierarchy) HHCAHPSHierarchy FROM #Dispo GROUP BY SamplePop_id) a
   WHERE t.SamplePop_id=a.SamplePop_id
   AND t.HHCAHPSHierarchy=a.HHCAHPSHierarchy
   GROUP BY t.Study_id, t.SamplePop_id, HHCAHPSValue

 if @indebug = 1 select '#SampDispo' [#SampDispo], * from #SampDispo

  -- UPDATE BIG_TABLE DISPOSTION
   -- Loop through each study, and update the Big_Table HHCAHPSValue field ONLY if the HHCAHPSValue is NOT NULL (Meaning is has a previous value either a default or prior disposition value)
   TRUNCATE TABLE #ULoop
   INSERT INTO #ULoop (BT) SELECT DISTINCT BT FROM #UpdateBT WHERE study_id = @study_id
   SELECT TOP 1 @BT= bt FROM #ULoop
   WHILE @@ROWCOUNT > 0
   BEGIN

     -- Only update HHCAHPS samplepops
     SET @SQL = 'UPDATE bt SET bt.HHDisposition = sd.HHCAHPSValue FROM ' + @BT + ' bt, #SampDispo sd WHERE bt.samplepop_id = sd.samplepop_id AND bt.HHDisposition IS NOT NULL'
	 if @indebug = 1 PRINT @SQL
     EXEC (@SQL)
     UPDATE #sampdispo SET bitEvaluated = 1 FROM #UpdateBT bt, #SampDispo sd WHERE bt.samplepop_id = bt.samplepop_id AND bt.BT = @bt


     DELETE FROM #ULoop WHERE @BT= bt
     SELECT TOP 1 @BT= bt FROM #ULoop
   END

   -- Now we can update the bitEvaluated flag and set it to 1 for all dispositionlog table for which we have just updated Big_Table.
   UPDATE dl SET dl.bitEvaluated = sd.bitEvaluated, DateEvaluated = getdate() FROM DispositionLog dl, #SampDispo sd WHERE dl.study_id = sd.study_id AND dl.samplepop_id = sd.samplepop_id AND dl.bitEvaluated = 0

   DELETE FROM #tblStudy WHERE study_id = @study_id
   SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy
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
  SET NOCOUNT OFF
END
  DROP TABLE #AllSP
RETURN
----------------------------------------------------------------------------------
