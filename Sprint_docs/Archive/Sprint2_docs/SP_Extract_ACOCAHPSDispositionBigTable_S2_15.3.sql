USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[SP_Extract_ACOCAHPSDispositionBigTable]    Script Date: 7/25/2014 8:42:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Extract_ACOCAHPSDispositionBigTable] @InDebug bit = 0
AS

-- 01/16/2014 - DBG. Modeled after SP_Extract_MNCMDispositionBigTable
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
CREATE TABLE #Dispo (Study_id INT, SamplePop_id INT, Disposition_id INT, ACOCAHPSHierarchy INT, ACOCAHPSValue CHAR(3))
CREATE TABLE #SampDispo (Study_id INT, SamplePop_id INT, ACOCAHPSValue CHAR(3), bitEvaluated BIT DEFAULT 0)

SET NOCOUNT ON


-- GATHER WORK
INSERT INTO #AllSP (study_id, samplepop_id)
SELECT dl.study_id, dl.samplepop_id
FROM DispositionLog dl, clientstudysurvey css, qualisys.qp_prod.dbo.surveytype st
WHERE dl.survey_ID = css.survey_ID 
AND css.surveyType_Id = st.surveyType_id 
AND dl.bitEvaluated = 0 
AND st.SurveyType_dsc = 'ACOCAHPS' 

if exists (select * from qualisys.qp_prod.dbo.medusaEtlFilterStudy)
	delete a
	from #AllSP a
		left outer join qualisys.qp_prod.dbo.medusaEtlFilterStudy fs
			on a.study_id=fs.study_id
	where fs.study_id is null

if @indebug = 1
begin
	select '#AllSP' [#AllSP], *
	FROM #AllSP
end


IF (select count(*) from #AllSP) > 0
BEGIN
	  --if @indebug = 1 select 'Records in DispoLog' [countRecs], * from dispositionlog where bitEvaluated = 0 order by samplepop_ID
	  ------ Update the bitEvaluated flag and set it to 1 for all dispositionlog table having DaysFromFirst > 42 (Don't Fit the ACOCAHPS Specs)
	  ----UPDATE dl
	  ----SET    dl.bitEvaluated = 1,
	  ----       DateEvaluated = Getdate()
	  ----FROM   dbo.DispositionLog dl, #AllSP sp
	  ----WHERE  dl.samplepop_id = sp.samplepop_id
	  ----       AND dl.DaysFromFirst > 42
	  ----       AND dl.bitEvaluated = 0

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
	  AND COLUMN_NAME = 'ACODisposition' AND TABLE_NAME NOT LIKE '%VIEW%'

	  if @indebug = 1 select '#HAV_HDISPCOL' [#HAV_HDISPCOL], * from #HAV_HDISPCOL order by 2

	  -- Find out what base tables are home for the samplepop we will be working with.

	  SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy
	  WHILE @@ROWCOUNT > 0
	  BEGIN
			-- GET samplepops that have ACOCAHPS dispositions that need to be evaluated (bitEvaluated = 0)
			TRUNCATE TABLE #DispoNew
			INSERT INTO #DispoNew (study_id, samplepop_id)
			SELECT DISTINCT dl.study_id, dl.samplepop_id
			FROM  DispositionLog dl, #AllSP sp
			WHERE dl.bitEvaluated = 0 and
			dl.study_id = @study_id  AND
			dl.samplepop_id = sp.samplepop_id 

			if @indebug = 1 select '#DispoNew' [#DispoNew], * from #DispoNew order by samplepop_ID

			-- Find all logged dispositions for samplepops identified in #DispoNew
			TRUNCATE TABLE #DispoWork
			INSERT INTO #DispoWork (study_id, samplepop_id, disposition_id, datLogged, DaysFromCurrent, DaysFromFirst, bitEvaluated)
			SELECT dl.study_id, dl.samplepop_id, dl.disposition_id, dl.datLogged, dl.DaysFromCurrent, dl.DaysFromFirst, dl.bitEvaluated
			FROM DispositionLog dl, #disponew dn
			WHERE dl.study_id = dn.study_id and dl.samplepop_id = dn.samplepop_id 

			if @indebug = 1 select '#DispoWork' [#DispoWork], * from #DispoWork order by samplepop_ID
			if @indebug = 1 select '#DispoWork with ReceiptType_ID' [#DispoWork], dw.*, qf.receipttype_ID from #DispoWork dw, qualisys.qp_prod.dbo.questionform qf where  qf.samplepop_ID = dw.samplepop_Id  order by dw.samplepop_ID

			TRUNCATE TABLE #UpdateBT
			SET @SQL = 'INSERT INTO #UpdateBT (study_id, survey_id, samplepop_id, BT) SELECT DISTINCT n.study_Id, b.survey_id, n.samplepop_id, ''' +
			@study + '.'' + b.tablename AS BT FROM ' + @study + '.big_table_view b, #DispoNew n WHERE b.samplepop_id = n.samplepop_id'
			if @indebug = 1 print @sql
			EXEC (@SQL)


			if @indebug = 1 select '#UpdateBT' [#UpdateBT], * from #UpdateBT order by samplepop_ID

			-- Update dispostionlog set bitEvaluated = 1 WHERE samplepops belong to a Non-ACOCAHPS survey
			TRUNCATE TABLE #DEL

			-- #updatebt is populated from #dispoNew, which is populated from #AllSP, which only has ACOCAHPS surveys in it. So there wouldn't be any Non-ACOCAHPS surveys to put into #DEL
			-- right?  (dbg)
			--INSERT INTO #del (study_id, samplepop_id)
			--SELECT u.study_id, u.samplepop_id
			--FROM  #updatebt u, clientstudysurvey c
			--WHERE u.survey_id = c.survey_id and
			--c.surveytype_id <> 10 AND
			--u.study_id = @study_id

			--if @indebug = 1 select '#del - 1' [#del - 1], * from #del order by samplepop_ID

			INSERT INTO #DEL (study_id, samplepop_id)
			SELECT study_id, samplepop_id
			FROM #updatebt u
			LEFT JOIN #hav_hdispcol hc ON u.bt = hc.studytbl 
			WHERE column_name IS NULL

			if @indebug = 1 select '#del - 2' [#del - 2], * from #del order by samplepop_ID

			-- Now delete the samplepops from #updateBT
			DELETE u FROM #updatebt u, #del d WHERE u.samplepop_id = d.samplepop_id

			if @indebug = 1 select '#UpdateBT after #del' [#UpdateBT], bt.*, qf.receipttype_Id from #UpdateBT bt, qualisys.qp_prod.dbo.questionform qf where  qf.samplepop_ID = bt.samplepop_Id order by bt.samplepop_ID


			--Calcuate the current the ACOCAHPSValue for the samplepop
			TRUNCATE TABLE #Dispo
			--INSERT INTO #Dispo (Study_id, SamplePop_id, Disposition_id, ACOCAHPSHierarchy, ACOCAHPSVALUE)
			--SELECT dw.study_id, dw.SamplePop_id, d.Disposition_id, hd.ACOCAHPSHierarchy, hd.ACOCAHPSValue
			--FROM #dispowork dw, disposition d, ACOCAHPSdispositions hd, #updateBT u  --, qualisys.qp_prod.dbo.questionform qf
			--WHERE d.Disposition_id = dw.Disposition_id
			--AND d.disposition_ID = hd.disposition_ID 
			--AND dw.samplepop_id = u.samplepop_id 


			INSERT INTO #Dispo (Study_id, SamplePop_id, Disposition_id, ACOCAHPSHierarchy, ACOCAHPSVALUE)
			SELECT dw.study_id, dw.SamplePop_id, d.Disposition_id, hd.Hierarchy, hd.[Value]
			FROM #dispowork dw, disposition d, surveytypedispositions hd, #updateBT u  --, qualisys.qp_prod.dbo.questionform qf
			WHERE d.Disposition_id = dw.Disposition_id
			AND d.disposition_ID = hd.disposition_ID 
			AND dw.samplepop_id = u.samplepop_id 
			AND hd.surveytype_id = 10
	
			--AND u.samplepop_ID = qf.samplepop_ID
			--AND (qf.receiptType_ID = hd.ReceiptType_ID or hd.ReceiptType_ID is null)
			--commented out b/c ACOCAHPS doesn't care about mode/receipttype
	
			--and dw.DaysFromFirst<43
			--commented out b/c ACOCAHPS does not care about date.

			if @indebug = 1 select '#Dispo' [#Dispo], * from #Dispo order by samplepop_ID


			TRUNCATE TABLE #SampDispo
			INSERT INTO #SampDispo (Study_id, SamplePop_id, ACOCAHPSValue)
			SELECT t.Study_id, t.SamplePop_id, ACOCAHPSValue
			FROM #Dispo t, (SELECT SamplePop_id, MIN(ACOCAHPSHierarchy) ACOCAHPSHierarchy FROM #Dispo GROUP BY SamplePop_id) a
			WHERE t.SamplePop_id=a.SamplePop_id
			AND t.ACOCAHPSHierarchy=a.ACOCAHPSHierarchy
			GROUP BY t.Study_id, t.SamplePop_id, ACOCAHPSValue



			if @indebug = 1 select '#SampDispo' [#SampDispo], * from #SampDispo order by samplepop_ID

			-- UPDATE BIG_TABLE DISPOSTION
			-- Loop through each study, and update the Big_Table ACOCAHPSValue field ONLY if the ACOCAHPSValue is NOT NULL (Meaning is has a previous value either a default or prior disposition value)
			TRUNCATE TABLE #ULoop
			INSERT INTO #ULoop (BT) SELECT DISTINCT BT FROM #UpdateBT WHERE study_id = @study_id
			SELECT TOP 1 @BT= bt FROM #ULoop
			WHILE @@ROWCOUNT > 0
			BEGIN
				-- Only update ACOCAHPS samplepops
				SET @SQL = 'UPDATE bt SET bt.ACODisposition = sd.[ACOCAHPSValue] 
				FROM ' + @BT + ' bt, #SampDispo sd
				WHERE bt.samplepop_id = sd.samplepop_id AND bt.ACODisposition IS NOT NULL'
				
				if @indebug = 1 PRINT @SQL
				EXEC (@SQL)
				UPDATE #sampdispo SET bitEvaluated = 1 FROM #UpdateBT bt, #SampDispo sd
				WHERE bt.samplepop_id = bt.samplepop_id AND bt.BT = @bt


				DELETE FROM #ULoop WHERE @BT= bt
				SELECT TOP 1 @BT= bt FROM #ULoop
			END

			-- Now we can update the bitEvaluated flag and set it to 1 for all dispositionlog table for which we have just updated Big_Table.
			UPDATE dl SET dl.bitEvaluated = sd.bitEvaluated, DateEvaluated = getdate() 
			FROM DispositionLog dl, #SampDispo sd 
			WHERE dl.study_id = sd.study_id 
			AND dl.samplepop_id = sd.samplepop_id 
			AND dl.bitEvaluated = 0

			DELETE FROM #tblStudy WHERE study_id = @study_id
			SELECT TOP 1 @study_id = study_id, @study = study FROM #tblStudy
	  END


	 -- CLEAN UP
	  DROP TABLE #Hav_HDispCol
	  SET NOCOUNT OFF
END

DROP TABLE #SAMPDISPO
DROP TABLE #DISPO
DROP TABLE #DEL
DROP TABLE #tblStudy
DROP TABLE #ULOOP
DROP TABLE #UPDATEBT
DROP TABLE #DISPONEW
DROP TABLE #DISPOWORK
DROP TABLE #AllSP
RETURN
----------------------------------------------------------------------------------