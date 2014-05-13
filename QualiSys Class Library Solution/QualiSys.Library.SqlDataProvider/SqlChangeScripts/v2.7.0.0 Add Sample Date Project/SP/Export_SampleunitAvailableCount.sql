

/*
Business Purpose: 
This procedure is used to calculate the number of eligible discharges.  It
is used IN the header record of the CMS export

Created:  06/22/2006 by DC

Modified:

*/  
ALTER PROCEDURE [dbo].[Export_SampleunitAvailableCount]
	@Sampleunit_id INT, 
    @startDate DATETIME, 
    @EndDate DATETIME,
	@EncounterDateField varchar(100) = Null
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Study_id INT, @Survey_id INT,
		@Sel VARCHAR(8000), @SampleUnit INT, @strDateWHERE VARCHAR(150),
		@Where1 VARCHAR(8000), @Where2 VARCHAR(8000), @Where3 VARCHAR(8000),
		@Where4 VARCHAR(8000), @Where5 VARCHAR(8000), @Where6 VARCHAR(8000),
		@Where7 VARCHAR(8000), @Where8 VARCHAR(8000), @Where9 VARCHAR(8000),
		@Where10 VARCHAR(8000),@fields varchar(5000), @DQCriter varchar(8000)

SELECT  @Where1='', @Where2='', @Where3='',
		@Where4='', @Where5='', @Where6='',
		@Where7='', @Where8='', @Where9='',
		@Where10=''

SELECT @study_id=sd.study_id,
	@survey_id=sd.survey_id
FROM sampleunit su, sampleplan sp, survey_def sd
WHERE su.sampleunit_id=@sampleunit_id 
	and su.sampleplan_id=sp.sampleplan_id
	and sp.survey_id=sd.survey_id
	
--get Datefield
CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))
IF @EncounterDateField IS NULL
BEGIN
	SET @Sel = 'INSERT INTO #DATEFIELD' +
	   ' SELECT mt.strTABLE_nm + mf.strField_nm' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTABLE  mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.TABLE_id = mt.TABLE_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND ms.TABLE_id=sd.sampleEncounterTABLE_id' +
	   ' AND ms.field_id=sd.sampleEncounterfield_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey_id)
END
ELSE 
BEGIN
	SET @Sel = 'INSERT INTO #DATEFIELD' +
	   ' SELECT mt.strTABLE_nm + mf.strField_nm' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTABLE  mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.TABLE_id = mt.TABLE_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey_id) +
	   ' AND mf.strField_nm = ''' + @EncounterDateField + ''''
END
Execute (@Sel)

SELECT @EncounterDateField=DATEFIELD
FROM #DATEFIELD


DECLARE @FROMDate VARCHAR(10), @ToDate VARCHAR(10)

SET @FROMDate=CONVERT(VARCHAR,@startdate,101)
SET @toDate=CONVERT(VARCHAR,@EndDate,101)

SET @strDateWhere=''

--Identify the encounter date field AND daterange
IF @EncounterDateField IS NULL 
BEGIN
	RAISERROR ('The cutoff date is not an encounter data field.  The eligible count cannot be calculated.', 16, 1)                  
	RETURN
END

IF (@FROMDate is null or @FROMDate='')
BEGIN
	RAISERROR ('Null dates are not allowed.', 16, 1)                  
	RETURN
END

--get the list of Fields needed for evaluating DQ rules
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

INSERT INTO @tbl 
SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
FROM CriteriaStmt cs, CriteriaClause cc, MetaData_View m, BusinessRule b
WHERE cs.Study_id=@Study_id
AND cs.CriteriaStmt_id=cc.CriteriaStmt_id
AND cc.Table_id=m.Table_id
AND cc.Field_id=m.Field_id
AND cs.CriteriaStmt_id=b.CriteriaStmt_id
AND b.survey_id=@survey_id
AND BusRule_cd='Q'

IF @@rowcount=0 
	INSERT INTO @tbl Values ('PopulationPop_id', 'I',4,1)

CREATE TABLE #BVUK (DummyField INT)

SET @sel='ALTER TABLE #BVUK ADD ,'

SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY Field_id
Set @sel=replace(@sel,',,','')

EXEC (@Sel)

ALTER TABLE #BVUK 
	DROP COLUMN DummyField

SELECT @strDateWhere=' AND ('+@EncounterDateField+' BETWEEN '''+@FROMDate+''' AND '''+CONVERT(VARCHAR,@ToDate)+' 23:59:59'')'

CREATE TABLE  #Criters (Survey_id INT, Sampleunit_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20), bitKeep bit default 0)        

INSERT INTO #Criters (Survey_id, Sampleunit_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, su.Sampleunit_id, c.CriteriaStmt_id, strCriteriaString, 'C'
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id
AND c.Study_id=@Study_id
AND su.Sampleplan_id=sp.Sampleplan_id
AND Survey_id=@Survey_id

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd='Q'
AND Survey_id=@Survey_id

DECLARE @Tables TABLE (Tablename VARCHAR(40))

INSERT INTO @Tables
SELECT DISTINCT strtable_nm
FROM MetaTABLE 
WHERE Study_id=@Study_id

SELECT TOP 1 @sel=Tablename FROM @Tables
WHILE @@ROWCOUNT>0
BEGIN
	
	DELETE @Tables WHERE Tablename=@sel
	
	SET @sel='UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'''+@sel+'.'','''+@sel+''')'
	EXEC (@Sel)
	
	SELECT TOP 1 @sel=Tablename FROM @Tables

END

UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,'"','''')

DECLARE @Criteria VARCHAR(7900)

SET @Criteria=''

--loop the actual Criteria Stmts
SELECT @SampleUnit=@SampleUnit_id

WHILE @@ROWCOUNT>0
BEGIN

	UPDATE #Criters
	SET bitKeep=1
	WHERE SampleUnit_id=@SampleUnit
	
	SELECT @SampleUnit=parentsampleunit_id
	FROM SampleUnit
	WHERE sampleunit_id=@SampleUnit
END

SELECT *
INTO #UnitCriters
FROM #CRITERS
WHERE bitKeep=1
	AND BusRule_cd='C'

SELECT *
INTO #DQCriters
FROM #CRITERS
WHERE BusRule_cd='Q'

--Concatenating criterias could produce a string over 8000 chars, so we must place each IN 
--its own variable.  We assume that 10 variables will be enough

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where1=strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE strCriteriaStmt=@Where1
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where2=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where2
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where3=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where3
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where4=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where4
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where5=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where5
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where6=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where6
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where7=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where7
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where8=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where8
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where9=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where9
END

IF EXISTS (SELECT TOP 1 1 FROM #UnitCriters)
BEGIN
	SELECT @Where10=' AND ' + strCriteriaStmt
	FROM #UnitCriters	

	DELETE FROM #UnitCriters WHERE ' AND ' + strCriteriaStmt=@Where10
END

SET @fields=''

--build the SELECT list
SELECT @fields=@fields+','+Fieldname
FROM @tbl
ORDER BY Field_id

SET @fields=substring(@fields,2,len(@fields)-1)

SET @sel='INSERT INTO #BVUK('+@fields+')
	SELECT '+@fields+'
	FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View (NOLOCK)
	WHERE'

--QUERY BIG VIEW
--PRINT (@sel +' ('+@Where1+@Where2+@Where3+@Where4+@Where5+@Where6+@Where7+@Where8+@Where9+@Where10+')' + @strDateWhere)
EXEC (@sel +' ('+@Where1+@Where2+@Where3+@Where4+@Where5+@Where6+@Where7+@Where8+@Where9+@Where10+')' + @strDateWhere)

--Loop through DQ Rules

SELECT TOP 1 @DQCriter=strCriteriaStmt
FROM #DQCriters

WHILE @@rowcount>0
BEGIN
	SET @SEL='DELETE FROM #BVUK
			  WHERE ' + @DQCriter 

	--PRINT @SEL
	EXEC (@SEL)

	DELETE
	FROM #DQCriters
	WHERE strCriteriaStmt=@DQCriter

	SELECT TOP 1 @DQCriter=strCriteriaStmt
	FROM #DQCriters
END

SELECT COUNT(*)
FROM #BVUK

DROP TABLE #CRITERS
DROP TABLE #UnitCriters
DROP TABLE #DATEFIELD
DROP TABLE #DQCriters

