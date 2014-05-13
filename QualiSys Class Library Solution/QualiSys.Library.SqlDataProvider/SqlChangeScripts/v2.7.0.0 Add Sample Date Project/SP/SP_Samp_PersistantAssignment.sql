set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
the hierarchical order for units that is used during the presample.

Created:  05/05/2005 by DC

Modified:
		02/28/2006 Changed to use [QCL_SampleSetReOrgSampleUnits]
*/ 
ALTER     PROCEDURE [dbo].[SP_Samp_PersistantAssignment] 
	@Survey INT, 
	@DataSet VARCHAR(2000),
    @FromDate Char(10) = null, 
    @ToDate Char(10) = null
AS

Insert into #Timer (PreSampleStart) values (getdate())

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Study_id INT

SELECT @Study_id=Study_id FROM Survey_def WHERE Survey_id=@Survey

DECLARE @Sel VARCHAR(8000), @DQ_id INT, @EncounterDateField varchar(42)
DECLARE @SampleUnit INT, @ParentSampleUnit INT, @EncTable BIT,
		@strDateWhere varchar(150)

Set @strDateWhere=''


CREATE TABLE #DataSets (DataSet_id INT)
SET @Sel='INSERT INTO #DataSets
	SELECT DataSet_id FROM Data_Set WHERE DataSet_id IN ('+@DataSet+')'
EXEC (@Sel)


--get the list of Fields needed
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

IF EXISTS (SELECT top 1 study_id FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')
SELECT @EncTable=1
ELSE 
SELECT @EncTable=0

--Identify the encounter date field and daterange
IF NOT (@FromDate is null or @FromDate='')
BEGIN
	CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))

	SET @Sel = 'INSERT INTO #DATEFIELD' +
	   ' SELECT mt.strTable_nm + mf.strField_nm' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.Table_id = mt.Table_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND ms.table_id=sd.sampleEncountertable_id' +
	   ' AND ms.field_id=sd.sampleEncounterfield_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey)
	
	Execute (@Sel)

	SELECT @EncounterDateField=DATEFIELD
	FROM #DATEFIELD
	
	IF @EncounterDateField is null and @encTable=0 Set @EncounterDateField='populationNewRecordDate'
		ELSE IF @EncounterDateField is null and @encTable=1 Set @EncounterDateField='encounterNewRecordDate'
	DROP TABLE #DATEFIELD

	SET @strDateWhere=' AND ' + @EncounterDateField + ' BETWEEN ''' + @FromDate + ''' AND ''' + convert(varchar,@ToDate) + ' 23:59:59'''

END

INSERT INTO @tbl 
SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
FROM CriteriaStmt cs, CriteriaClause cc, MetaData_View m
WHERE cs.Study_id=@Study_id
AND cs.CriteriaStmt_id=cc.CriteriaStmt_id
AND cc.Table_id=m.Table_id
AND cc.Field_id=m.Field_id

CREATE TABLE #BVUK (Pop_id INT)

IF @EncTable=1
SET @sel='ALTER TABLE #BVUK ADD Enc_id INT'
ELSE
SET @sel='ALTER TABLE #BVUK ADD ,'


SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY Field_id
Set @sel=replace(@sel,',,','')

EXEC (@Sel)

CREATE TABLE #Criters (Survey_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20))        

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd='Q'
AND Survey_id=@Survey

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, 'C'
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id
AND c.Study_id=@Study_id
AND su.Sampleplan_id=sp.Sampleplan_id
AND Survey_id=@Survey

DECLARE @Tables TABLE (tablename VARCHAR(40))
INSERT INTO @Tables
SELECT DISTINCT strTable_nm
FROM MetaTable
WHERE Study_id=@Study_id

SELECT top 1 @sel=tablename FROM @tables
WHILE @@ROWCOUNT>0
BEGIN
	
	DELETE @tables WHERE tablename=@sel
	
	SET @sel='UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'''+@sel+'.'','''+@sel+''')'
	EXEC (@Sel)
	
	SELECT TOP 1 @sel=tablename FROM @tables

END

UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'"','''')

DECLARE @Criteria VARCHAR(7900)

--Loop thru one Survey at a time
--Get the SampleUnit order
CREATE TABLE #SampleUnits
  (SampleUnit_id INT,
   ParentSampleUnit_id INT,
   CriteriaStmt_id INT,
   intTier INT,
   strNode VARCHAR(255),
   intTreeOrder INT,
   Survey_id INT)

--	SP_Samp_ReOrgSampleUnits 388
INSERT INTO #SampleUnits
EXEC QCL_SampleSetReOrgSampleUnits @Survey

--need two loops 
--loop the actual Criteria Stmts to assign people to Units
SELECT TOP 1 @SampleUnit=SampleUnit_id FROM #SampleUnits ORDER BY intTreeOrder
WHILE @@ROWCOUNT>0
BEGIN

	SELECT @ParentSampleUnit=ParentSampleUnit_id 
	  FROM #SampleUnits 
	    WHERE SampleUnit_id=@SampleUnit
	SELECT @Criteria=strCriteriaStmt 
	  FROM #SampleUnits su, #Criters c 
	    WHERE SampleUnit_id=@SampleUnit
	     AND su.CriteriaStmt_id=c.CriteriaStmt_id


	IF @ParentSampleUnit IS NULL
	BEGIN
		IF @EncTable=1
		SELECT @Sel='Pop_id, Enc_id'
		ELSE 
		SELECT @Sel='Pop_id'
		
		--build the SELECT list
		SELECT @sel=@sel+','+Fieldname
		FROM @tbl
		ORDER BY Field_id
	
		IF @EncTable=1
			--build the temp table.
			SET @Sel='INSERT INTO #BVUK('+@Sel+')
				SELECT '+@Sel+'
				FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
				WHERE dsm.DataSet_id=t.DataSet_id
				AND dsm.Enc_id=b.EncounterEnc_id
				AND ('+@Criteria+')' + @strDateWhere
		ELSE
			SET @Sel='INSERT INTO #BVUK('+@Sel+')
				SELECT '+@Sel+'
				FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
				WHERE dsm.DataSet_id=t.DataSet_id
				AND dsm.Pop_id=b.PopulationPop_id
				AND ('+@Criteria+')' + @strDateWhere
		EXEC (@Sel)

		IF @EncTable=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)
				SELECT Pop_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk
				WHERE ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)
				SELECT Pop_id,Enc_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk
				WHERE ('+@Criteria+')'
	END
	ELSE
	BEGIN
		IF @EncTable=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)
				SELECT b.Pop_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.pop_id=b.pop_id
				AND ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)
				SELECT b.Pop_id,b.Enc_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.Enc_id=b.Enc_id
				AND ('+@Criteria+')'
	END
	EXEC (@Sel)
	
	DELETE c 
	  FROM #SampleUnits su, #Criters c 
	    WHERE SampleUnit_id=@SampleUnit 
	     AND su.CriteriaStmt_id=c.CriteriaStmt_id
	DELETE #SampleUnits WHERE SampleUnit_id=@SampleUnit
	SELECT TOP 1 @SampleUnit=SampleUnit_id FROM #SampleUnits ORDER BY intTreeOrder
	
END

DROP TABLE #SampleUnits


SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @EncTable=0
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Pop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Enc_id=b.Enc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE strCriteriaStmt=@Criteria AND Survey_id=@Survey

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE Survey_id=@Survey ORDER BY CriteriaStmt_id

END

	
Insert into #Timer (PreSampleEnd) values (getdate()) 

DROP TABLE #Criters
DROP TABLE #DataSets
DROP TABLE #BVUK








