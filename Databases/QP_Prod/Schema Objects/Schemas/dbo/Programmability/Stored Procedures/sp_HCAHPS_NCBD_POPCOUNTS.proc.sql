CREATE procedure sp_HCAHPS_NCBD_POPCOUNTS 
	@survey int,
	@sampleunits varchar(5000),
	@fromDate datetime,
	@toDate datetime

as
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #PreSample (pop_id int, enc_id int, SampleUnit_id INT)

CREATE TABLE #popcounts (survey_id int, popCount int)

create table #datefield (survey_id int, DateField varchar(42))

CREATE TABLE #Criteria (SampleUnit_id INT,
	   Survey_id INT,
	   strcriteriastring varchar(2000))

DECLARE @Sel VARCHAR(8000),@Sel2 VARCHAR(8000), @DQ_id INT, @EncounterDateField varchar(42),
		@Study_id INT, 
		@SampleUnit INT, @ParentSampleUnit INT, @EncTable BIT,
		@strDateWhere varchar(150), @Criteria VARCHAR(7900)

DECLARE	@tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)
DECLARE	@Tables TABLE (tablename VARCHAR(40))

Set @strDateWhere=''

SELECT @Study_id=Study_id FROM Survey_def WHERE Survey_id=@Survey

--get the list of Fields needed

IF EXISTS (SELECT top 1 study_id FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')
SELECT @EncTable=1
ELSE 
SELECT @EncTable=0

--Identify the encounter date field and daterange

CREATE TABLE #DATEFIELDs (DATEFIELD VARCHAR(42))

SET @Sel = 'INSERT INTO #DATEFIELDs' +
   ' SELECT mt.strTable_nm + mf.strField_nm' +
   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
   ' WHERE sd.Study_id = mt.Study_id' +
   ' AND ms.Table_id = mt.Table_id' +
   ' AND ms.Field_id = mf.Field_id' +
   ' AND ms.table_id=sd.cutofftable_id' +
   ' AND ms.field_id=sd.cutofffield_id' +
   ' AND mf.strFieldDataType = ''D''' +
   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey)

Execute (@Sel)

SELECT @EncounterDateField=DATEFIELD
FROM #DATEFIELDs

IF @EncounterDateField is null and @encTable=0 Set @EncounterDateField='populationNewRecordDate'
	ELSE IF @EncounterDateField is null and @encTable=1 Set @EncounterDateField='encounterNewRecordDate'
--drop table #DATEFIELDs

insert into #datefield values (@survey, @EncounterDateField)

SET @strDateWhere=' AND ' + @EncounterDateField + ' BETWEEN ''' + convert(varchar,@FromDate,101) + ''' AND ''' + convert(varchar,@ToDate,101) + ' 23:59:59'''

/*get counts of numbers sampled*/

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

SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY Field_id

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
EXEC SP_Samp_ReOrgSampleUnits @Survey


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
		insert into #Criteria (sampleunit_id, strcriteriastring, survey_id)
		values (@SampleUnit, replace(replace(replace(@Criteria,'POPULATION',''),'ENCOUNTER',''),'IN(', 'IN ('), @survey)
	ELSE 
		insert into #Criteria (sampleunit_id, strcriteriastring, survey_id)
		select @SampleUnit, c.strcriteriastring+' and ' +replace(replace(replace(@Criteria,'POPULATION',''),'ENCOUNTER',''),'IN(', 'IN ('), @survey
		from #Criteria c
		where sampleunit_Id=@ParentSampleUnit	

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
		SELECT @Sel2='PopulationPop_id, EncounterEnc_id'
		ELSE 
		SELECT @Sel2='PopulationPop_id'
		
		--build the SELECT list
		SELECT @sel2=@sel2+','+Fieldname
		FROM @tbl
		ORDER BY Field_id
	

		SET @Sel='INSERT INTO #BVUK('+@Sel+')
			SELECT '+@Sel2+' 
			FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK)
			WHERE ('+@Criteria+')' + @strDateWhere

		exec (@Sel)

		IF @EncTable=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id)
				SELECT PopulationPop_id,'+CONVERT(VARCHAR,@SampleUnit)+'
				FROM #bvuk
				WHERE ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id)
				SELECT Pop_id,Enc_id,'+CONVERT(VARCHAR,@SampleUnit)+'
				FROM #bvuk
				WHERE ('+@Criteria+')'
	END
	ELSE
	BEGIN
		IF @EncTable=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,)
				SELECT b.Pop_id,'+CONVERT(VARCHAR,@SampleUnit)+'
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.pop_id=b.pop_id
				AND ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id)
				SELECT b.Pop_id,b.Enc_id,'+CONVERT(VARCHAR,@SampleUnit)+'
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

set @sel='INSERT INTO #popcounts (survey_id, popCount)
		select ' + convert(varchar,@survey) +', count(*)
		from (select distinct pop_id, enc_id
				from #presample
				where sampleunit_id in (' + @sampleunits + ')) p'

exec (@sel)

select *
from #popcounts


