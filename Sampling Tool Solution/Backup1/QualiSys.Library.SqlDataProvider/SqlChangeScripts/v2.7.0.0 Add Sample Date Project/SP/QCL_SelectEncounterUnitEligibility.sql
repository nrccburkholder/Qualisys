set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It returns a single
record for each encounter that is eligible to be sampled.  It also does checks of 
DQ rules and other business rules.

Created:  02/20/2006 by DC

Modified:
		07/28/2006 by DC
		Fixed bug when encounter table did not exist and added code to skip TOCL check if HCAHPS

*/  
ALTER PROCEDURE [dbo].[QCL_SelectEncounterUnitEligibility]
	@Survey_id INT, 
	@Study_id INT,
	@DataSet VARCHAR(2000),
    @startDate DATETIME=NULL, 
    @EndDate DATETIME=NULL,
	@seed INT,
	@ReSurvey_Period INT,
	@EncounterDateField VARCHAR(42),
	@ReportDateField Varchar(42),
	@encTableExists BIT,
	@sampleSet_id INT,
	@samplingMethod INT,
	@resurveyMethod_id INT=1,
	@samplingAlgorithmId as INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @FromDate varchar(10), @ToDate varchar(10)

SET @fromDate=CONVERT(VARCHAR,@startdate,101)
SET @toDate=CONVERT(VARCHAR,@EndDate,101)

DECLARE @Sel VARCHAR(8000), @sql VARCHAR(8000), @DQ_id INT, @newbornRule varchar(7900)
DECLARE @SampleUnit INT, @ParentSampleUnit INT, @strDateWhere VARCHAR(150)
DECLARE @bitDoTOCL bit

SET @strDateWhere=''

CREATE TABLE #DataSets (DataSet_id INT)
SET @Sel='INSERT INTO #DataSets
	SELECT DataSet_id FROM Data_Set WHERE DataSet_id IN ('+@DataSet+')'
EXEC (@Sel)

--get the list of Fields needed
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

--Get HouseHolding Variables if needed
DECLARE @HouseHoldFieldSelectSyntax VARCHAR(1000), @HouseHoldFieldSelectBigViewSyntax VARCHAR(1000),
	@HouseHoldFieldCreateTableSyntax VARCHAR(1000), @HouseHoldJoinSyntax VARCHAR(1000),
	@HouseHoldingType CHAR(1)

SELECT @HouseHoldFieldSelectSyntax='', @HouseHoldFieldSelectBigViewSyntax='',
	@HouseHoldFieldCreateTableSyntax='', @HouseHoldJoinSyntax='' 

DECLARE @HHFields TABLE  (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT)

SELECT @HouseHoldingType=strHouseHoldingType, 
	@bitDoTOCL=	CASE
					when surveytype_id=2 then 0 --HCAHPS IP
					else 1
				END
FROM Survey_def 
WHERE Survey_id=@Survey_id

CREATE TABLE #HH_Dup_People (id_num INT IDENTITY, Pop_id INT, bitKeep BIT)
CREATE TABLE #Minor_Universe (id_num INT IDENTITY, Pop_id INT, intShouldBeRand TINYINT, intRemove INT, intMinorException INT)
CREATE TABLE #Minor_Exclude (Pop_id INT, intMinorException INT)	
CREATE TABLE #HouseHold_Dups (dummyColumn BIT)

IF @HouseHoldingType <> 'N'
BEGIN

	INSERT INTO @HHFields
	SELECT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
	FROM dbo.HouseHoldRule HR, MetaData_View m
	WHERE HR.Table_id=M.Table_id
	AND HR.Field_id=M.Field_id
	AND HR.Survey_id=@Survey_id

	SELECT @HouseHoldFieldSelectSyntax=@HouseHoldFieldSelectSyntax+', X.'+Fieldname
	FROM @HHFields
	ORDER BY Field_id
	SET @HouseHoldFieldSelectSyntax=substring(@HouseHoldFieldSelectSyntax,2,len(@HouseHoldFieldSelectSyntax)-1)

	SELECT @HouseHoldJoinSyntax=CASE WHEN @HouseHoldJoinSyntax='' THEN '' 
               ELSE @HouseHoldJoinSyntax+' AND ' END+' X.'+Fieldname+'=Y.'+FieldName
	FROM @HHFields
	ORDER BY Field_id

	SELECT @HouseHoldFieldCreateTableSyntax=@HouseHoldFieldCreateTableSyntax+
		','+
		FieldName+' '+
		CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
	FROM @HHFields
	ORDER BY Field_id
	SELECT @sel=REPLACE(@sel,',,','')
	SELECT @HouseHoldFieldCreateTableSyntax=SUBSTRING(@HouseHoldFieldCreateTableSyntax,2,LEN(@HouseHoldFieldCreateTableSyntax)-1)


	IF @encTableExists=1
	SELECT @sel='ALTER TABLE #HH_Dup_People ADD EncounterEnc_id INT'
	ELSE
	SELECT @sel='ALTER TABLE #HH_Dup_People ADD ,'

	SELECT @sel=@sel+
		','+
		FieldName+' '+
		CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
	FROM @HHFields
	ORDER BY Field_id
	SELECT @sel=REPLACE(@sel,',,','')

	EXEC (@Sel)
	SELECT @sel=REPLACE(@sel,'#HH_Dup_People','#Minor_Universe')
	EXEC (@Sel)
	SELECT @sel=REPLACE(@sel,'#Minor_Universe','#Minor_Exclude')
	EXEC (@Sel)
	SELECT @sel=REPLACE(@sel,'#Minor_Exclude','#HouseHold_Dups')
	EXEC (@Sel) 
 
END

--Create temp Tables
CREATE TABLE #SampleUnit_Universe (id_num INT IDENTITY, SampleUnit_id INT, Pop_id INT, Enc_id INT, Age INT, 
		DQ_Bus_Rule INT, Removed_Rule INT DEFAULT 0, strUnitSelectType VARCHAR(1), EncDate DATETIME,
		ReSurveyDate DATETIME, HouseHold_id int, bitBadAddress bit default 0, bitBadPhone bit default 0,
		reportDate datetime)

CREATE TABLE #PreSample (Pop_id INT, Enc_id INT, SampleUnit_id INT NOT NULL, DQ_id INT, bitBadAddress bit default 0, bitBadPhone bit default 0)
IF @encTableExists=0 
	ALTER TABLE #PreSample
		DROP COLUMN Enc_id

--Set Join Variables
DECLARE @BVJOIN VARCHAR(100), @PopID_EncID_Join VARCHAR(100), @POPENCSelect VARCHAR(100),
	 @PopID_EncID_CreateTable VARCHAR(100), @PopID_EncID_Select_Aliased  VARCHAR(100)

IF @encTableExists=1
BEGIN
	SELECT @BVJOIN= 'X.Pop_id=BV.POPULATIONPop_id AND X.Enc_id=BV.ENCOUNTEREnc_id'
	SELECT @PopID_EncID_Join='X.Pop_id=Y.Pop_id AND X.Enc_id=Y.Enc_id'
	SELECT @POPENCSelect='Pop_id, Enc_id'
	SELECT @PopID_EncID_CreateTable ='Pop_id int, Enc_id int'
	SELECT @PopID_EncID_Select_Aliased='x.Pop_id, x.Enc_id'
END
ELSE 
BEGIN
	SELECT @BVJOIN= 'X.Pop_id=BV.POPULATIONPop_id'
	SELECT @PopID_EncID_Join='X.Pop_id=Y.Pop_id'
	SELECT @POPENCSelect='Pop_id'
	SELECT @PopID_EncID_CreateTable ='Pop_id int'
	SELECT @PopID_EncID_Select_Aliased='x.Pop_id'
END


--Identify the encounter date field and daterange
IF NOT (@FromDate is null or @FromDate='')
BEGIN
	IF @EncounterDateField IS NULL AND @encTableExists=0 SET @EncounterDateField='populationNewRecordDate'
		ELSE IF @EncounterDateField IS NULL AND @encTableExists=1 SET @EncounterDateField='encounterNewRecordDate'
	
	SELECT @strDateWhere=' AND '+@EncounterDateField+' BETWEEN '''+@FromDate+''' AND '''+CONVERT(VARCHAR,@ToDate)+' 23:59:59'''
END

--Add fields to bigview
IF @encTableExists=1
Insert into @tbl values ('ENCOUNTEREnc_id', 'I',4,0)

INSERT INTO @tbl 
	SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
	FROM CriteriaStmt cs, CriteriaClause cc, MetaData_View m
	WHERE cs.Study_id=@Study_id
	AND cs.CriteriaStmt_id=cc.CriteriaStmt_id
	AND cc.Table_id=m.Table_id
	AND cc.Field_id=m.Field_id
	AND strTable_nm+strField_nm not in ('EncounterEnc_id','POPULATIONPop_id')
UNION
	SELECT *
	FROM @HHFields
	WHERE FieldName not in ('EncounterEnc_id','POPULATIONPop_id')

IF NOT EXISTS (SELECT 1 FROM @tbl WHERE FieldName= 'POPULATIONAge')
	INSERT INTO @tbl SELECT 'POPULATIONAge', 'I',4,'9999'
IF NOT EXISTS (SELECT 1 FROM @tbl WHERE FieldName= @EncounterDateField) and @EncounterDateField is not null
	INSERT INTO @tbl SELECT @EncounterDateField, 'D',4,'9999'
IF NOT EXISTS (SELECT 1 FROM @tbl WHERE FieldName= @reportDateField) and @reportDateField is not null
	INSERT INTO @tbl SELECT @reportDateField, 'D',4,'9999'
CREATE TABLE #BVUK (POPULATIONPop_id INT)

--Add fields to bigview
SET @sel='ALTER TABLE #BVUK ADD ,'

SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY Field_id
SET @sel=REPLACE(@sel,',,','')

EXEC (@Sel)

--Add HH fields to #sampleunitUniverse
IF exists(select top 1 * from @HHFields)
BEGIN
	SET @sel='ALTER TABLE #SampleUnit_Universe ADD ,'

	SELECT @sel=@sel+
		','+
		FieldName+' '+
		CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
	FROM @HHFields
	ORDER BY Field_id
	SET @sel=REPLACE(@sel,',,','')

	EXEC (@Sel)
END


IF @encTableExists=1 CREATE INDEX popenc ON #BVUK (Populationpop_id, EncounterEnc_id)
	ELSE CREATE INDEX Populationpop_id ON #BVUK (Populationpop_id)

CREATE TABLE #Criters (Survey_id INT, CriteriaStmt_id INT, strCriteriaStmt VARCHAR(7900), BusRule_cd VARCHAR(20))        

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd='Q'
AND Survey_id=@Survey_id

INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, 'C'
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id
AND c.Study_id=@Study_id
AND su.Sampleplan_id=sp.Sampleplan_id
AND Survey_id=@Survey_id

--Add the bad address and bad phone criterias
INSERT INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd) 
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd in ('F','A')
AND Survey_id=@Survey_id

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
EXEC QCL_SampleSetReOrgSampleUnits @Survey_id

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
		IF @encTableExists=1
		BEGIN
			SELECT @Sel='b.Populationpop_id, b.EncounterEnc_id'
			SELECT @Sql='Populationpop_id, EncounterEnc_id'
		END
		ELSE 
		BEGIN
			SELECT @Sel='b.Populationpop_id'
			SELECT @Sql='Populationpop_id'
		END
		
		--build the SELECT list
		SELECT @sel=@sel+','+Fieldname
		FROM @tbl
		WHERE Fieldname NOT IN ('Populationpop_id', 'EncounterEnc_id')
		ORDER BY Field_id

		--build the INSERT list
		SELECT @sql=@sql+','+Fieldname
		FROM @tbl
		WHERE Fieldname NOT IN ('Populationpop_id', 'EncounterEnc_id')
		ORDER BY Field_id
	
		IF @encTableExists=1
			--build the temp table.
			SET @Sel='INSERT INTO #BVUK('+@Sql+')
				SELECT '+@Sel+'
				FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
				WHERE dsm.DataSet_id=t.DataSet_id
				AND dsm.Enc_id=b.EncounterEnc_id
				AND ('+@Criteria+')'+@strDateWhere
		ELSE
			SET @Sel='INSERT INTO #BVUK('+@Sql+')
				SELECT '+@Sel+'
				FROM s'+CONVERT(VARCHAR,@Study_id)+'.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
				WHERE dsm.DataSet_id=t.DataSet_id
				AND dsm.Pop_id=b.PopulationPop_id
				AND ('+@Criteria+')'+@strDateWhere
		EXEC (@Sel)

		IF @encTableExists=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)
				SELECT Populationpop_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b
				WHERE ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)
				SELECT Populationpop_id,EncounterEnc_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b
				WHERE ('+@Criteria+')'
	END
	ELSE
	BEGIN
		IF @encTableExists=0
			SET @sel='INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)
				SELECT b.Populationpop_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.Pop_id=b.Populationpop_id
				AND ('+@Criteria+')'
		ELSE
			SET @sel='INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)
				SELECT b.Populationpop_id,b.EncounterEnc_id,'+CONVERT(VARCHAR,@SampleUnit)+',0
				FROM #bvuk b, #PreSample p
				WHERE p.SampleUnit_id='+CONVERT(VARCHAR,@ParentSampleUnit)+'
				AND p.Enc_id=b.EncounterEnc_id
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

--Remove Records that can't be sampled and update the counts in SPW if
--it is not a census sample
IF @SamplingMethod <>3
BEGIN
	CREATE INDEX Pop_id ON #PRESAMPLE (Pop_id)

	SELECT Pop_id
	INTO #SampleAble
	FROM #PreSample p, sampleunit s
	WHERE p.sampleunit_id=s.sampleunit_id and
			s.inttargetReturn>0
	 GROUP BY Pop_id
	 HAVING COUNT(*)>0

	--Remove pops not eligible for any targeted units
	SELECT p.Sampleunit_id, p.Pop_id
	INTO #UnSampleAble
	FROM #PreSample p LEFT JOIN #SampleAble s
		ON p.Pop_id=s.Pop_id
	WHERE s.Pop_id IS NULL

	DELETE p
	FROM #PreSample p, #UnSampleAble u
	WHERE p.Pop_id=u.Pop_id

	--Update the Universe count in SPW 
	UPDATE spw
	SET IntUniverseCount=ISNULL(IntUniverseCount,0)+freq
	FROM SamplePlanWorkSheet spw, 
		(SELECT sampleunit_id, COUNT(*) AS freq
		 FROM #UnSampleAble 
		 GROUP BY sampleunit_id) u
	WHERE spw.sampleunit_id=u.sampleunit_id AND
			spw.sampleset_id=@sampleSet_id

END

--Evaluate the DQ rules
SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd='Q' ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @encTableExists=0
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id 
					AND p.Enc_id=b.EncounterEnc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE CriteriaStmt_id=@DQ_id

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd='Q' ORDER BY CriteriaStmt_id

END

--Evaluate the Bad Address 
SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='A' ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @encTableExists=0
		SELECT @Sel='UPDATE p
					SET bitBadAddress=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET bitBadAddress=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id 
					AND p.Enc_id=b.EncounterEnc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE CriteriaStmt_id=@DQ_id

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='A' ORDER BY CriteriaStmt_id

END


--Evaluate the Bad Phone rules
SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='F' ORDER BY CriteriaStmt_id
WHILE @@ROWCOUNT>0
BEGIN

	--This needs to be an update statement, not an insert statement.		
	IF @encTableExists=0
		SELECT @Sel='UPDATE p
					SET bitBadPhone=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET bitBadPhone=1
					FROM #PreSample p, #BVUK b
					WHERE p.Pop_id=b.Populationpop_id 
					AND p.Enc_id=b.EncounterEnc_id
					AND ('+@Criteria+')
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE CriteriaStmt_id=@DQ_id

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE BusRule_cd ='F' ORDER BY CriteriaStmt_id

END



IF @encTableExists=0
	SET @Sel='INSERT INTO #SampleUnit_Universe 
	SELECT DISTINCT SampleUnit_id, ' +
	'x.pop_id, null as enc_ID, POPULATIONAge, DQ_ID, '+
	'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '+
	 case 
		when @EncounterDateField is not null then @EncounterDateField
		else 'null'
	 end +', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone, 
	'+case 
		when @reportDateField is not null then @reportDateField
		else 'null'
	 end 
ELSE
	SET @Sel='INSERT INTO #SampleUnit_Universe 
	SELECT DISTINCT SampleUnit_id, ' +
	'x.pop_id, x.enc_id, POPULATIONAge, DQ_ID, '+
	'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '+
	 case 
		when @EncounterDateField is not null then @EncounterDateField
		else 'null'
	 end +', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone, 
	'+case 
		when @reportDateField is not null then @reportDateField
		else 'null'
	 end 
	 
IF @HouseHoldingType<>'N' SET @Sel=@Sel++', '+REPLACE(@HouseHoldFieldSelectSyntax,'X.','BV.')
SET @Sel=@Sel+' FROM #PreSample X, #BVUK BV ' +
'WHERE '+@BVJOIN 

SET @Sel=@Sel+' ORDER BY SampleUnit_id, '+@PopID_EncID_Select_Aliased 
EXEC (@Sel)

DECLARE @CutOffCode int, @SampleDate DATETIME
 SELECT @CutOffCode=strCutOffResponse_cd, @SampleDate=datSampleCreate_dt
  FROM dbo.Survey_def SD, dbo.SampleSet SS
  WHERE SD.Survey_id=SS.Survey_id
   AND SS.SampleSet_id=@SampleSet_id
   
--Update ReportDate in SelectedSample for the sampleset if sampled date is the report date
IF @CutOffCode=0
 UPDATE #SampleUnit_Universe
 SET ReportDate=@SampleDate

EXEC QCL_SampleSetIndexUniverse @encTableExists

SELECT @newbornRule=REPLACE(CONVERT(VARCHAR(7900),strCriteriaString),'"','''')
FROM criteriastmt c, businessrule br
WHERE c.criteriastmt_id=br.criteriastmt_id AND
	c.study_id=@study_id AND
	br.survey_id=@Survey_id AND
	BusRule_cd='B'

IF @newbornRule IS NOT NULL EXEC QCL_SampleSetNewbornRule @study_id, @BVJOIN, @newbornRule

IF @bitDoTOCL=1 EXEC QCL_SampleSetTOCLRule @study_id

EXEC QCL_SampleSetAssignHouseHold @HouseHoldFieldCreateTableSyntax, 
                                 @HouseHoldFieldSelectSyntax, 
                                 @HouseHoldJoinSyntax, 
                                 @HouseHoldingType

-- Apply the resurvey exclusion rule
EXEC QCL_SampleSetResurveyExclusion_StaticPlus @study_id, @resurveyMethod_id, @ReSurvey_Period, 
 @samplingAlgorithmId, @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax, 
 @HouseHoldJoinSyntax, @HouseHoldingType 

--Remove People that have a removed rule other than 0 or 4(DQ)
DECLARE @RemovedRule INT, @unit INT, @freq INT, @RuleName VARCHAR(8)

SELECT sampleunit_Id, Removed_Rule, COUNT(*) AS freq
INTO #UnSampleAbleRR
FROM #SampleUnit_Universe 
WHERE Removed_Rule NOT IN (0,4)
GROUP by sampleunit_Id, Removed_Rule

DELETE 
FROM #SampleUnit_Universe
WHERE Removed_Rule NOT IN (0,4)

--Update the Universe count in SPW 
SELECT top 1 @RemovedRule=Removed_Rule, @unit=sampleunit_Id, @freq=freq
FROM #UnSampleAbleRR

WHILE @@ROWCOUNT>0
BEGIN
	
	IF @RemovedRule=1 SET @RuleName='Resurvey'
	IF @RemovedRule=2 SET @RuleName='NewBorn'
	IF @RemovedRule=3 SET @RuleName='TOCL'
	IF @RemovedRule=4 SET @RuleName='DQRule'
	IF @RemovedRule=5 SET @RuleName='ExcEnc'
	IF @RemovedRule=6 SET @RuleName='HHMinor'
	IF @RemovedRule=7 SET @RuleName='HHAdult'
	IF @RemovedRule=8 SET @RuleName='SSRemove'
	EXEC QCL_InsertRemovedRulesIntoSPWDQCOUNTS @sampleset_Id, @unit, @RuleName, @freq

	DELETE 
	FROM #UnSampleAbleRR
	WHERE Removed_Rule=@removedRule 
		AND sampleunit_Id=@unit

	SELECT TOP 1 @RemovedRule=Removed_Rule, @unit=sampleunit_Id, @freq=freq
	FROM #UnSampleAbleRR
END

--Randomize file by Pop_id 
CREATE TABLE #randomPops (Pop_id INT, numrandom INT)

INSERT INTO #randomPops
SELECT Pop_id, numrandom
FROM (Select MAX(id_num) AS id_num, Pop_id
	FROM #SampleUnit_Universe
	GROUP BY Pop_id) dsp, random_numbers rn
WHERE ((dsp.id_num+@Seed)%1000000)=rn.random_id

--Return data sorted by randomPop_id
SELECT su.SampleUnit_id, su.Pop_id, su.Enc_id, su.DQ_Bus_Rule, su.Removed_Rule, su.EncDate, su.HouseHold_id, su.bitBadAddress, su.bitBadPhone, su.reportDate
FROM #SampleUnit_Universe su, #randomPops rp
WHERE su.Pop_id=rp.Pop_id
ORDER BY rp.numrandom,Enc_id
	

DROP TABLE #Criters
DROP TABLE #Presample
DROP TABLE #DataSets
DROP TABLE #BVUK
DROP TABLE #randomPops
DROP TABLE #HH_Dup_People
DROP TABLE #Minor_Universe
DROP TABLE #Minor_Exclude
DROP TABLE #HouseHold_Dups
DROP TABLE #SAMPLEUNIT_UNIVERSE
DROP TABLE #SampleAble
DROP TABLE #UnSampleAble
DROP TABLE #UnSampleAblerr
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF




