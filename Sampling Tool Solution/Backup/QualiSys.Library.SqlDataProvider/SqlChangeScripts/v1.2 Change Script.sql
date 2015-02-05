

/********************************************************************************************************/  
/*                        */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns two  */  
/* datasets.  The first is a list of all client names an employee has rights to.  The second */  
/* selects all of the study names and client_ids the employee has rights to.    */  
/*                        */  
/* Date Created:  10/11/2005                    */  
/*                        */  
/* Created by:  Brian Dohmen                     
Modified:
02/16/2006 by DC - Added ADEmployee_id to Study. */   
/********************************************************************************************************/  
ALTER PROCEDURE [dbo].[QCL_SelectClientsAndStudiesByUser]  
    @UserName VARCHAR(42)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
--Need a temp table to hold the ids the user has rights to  
CREATE TABLE #EmpStudy (  
     Client_id INT,  
     Study_id INT,  
     strStudy_nm VARCHAR(10),  
     strStudy_dsc VARCHAR(255),
	 ADEmployee_id int 
)  
  
--Populate the temp table with the studies they have rights to.  
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id)  
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc, s.ADEmployee_id 
FROM Employee e, Study_Employee se, Study s  
WHERE e.strNTLogin_nm=@UserName  
AND e.Employee_id=se.Employee_id  
AND se.Study_id=s.Study_id  
AND s.datArchived IS NULL  
  
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)  
  
--First recordset.  List of clients they have rights to.  
SELECT c.Client_id, c.strClient_nm  
FROM #EmpStudy t, Client c  
WHERE t.Client_id=c.Client_id  
GROUP BY c.Client_id, c.strClient_nm  
ORDER BY c.strClient_nm  
  
--Second recordset.  List of studies they have rights to  
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id  
FROM #EmpStudy  
ORDER BY strStudy_nm  
  
--Cleanup temp table  
DROP TABLE #EmpStudy  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO 
-----------------------------------------------------------------------------------------------
GO


/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It returns a single
record for each encounter that is eligible to be sampled.  It also does checks of 
DQ rules and other business rules.

Created:  02/20/2006 by DC

Modified:

*/  
create PROCEDURE [dbo].[QCL_SelectEncounterUnitEligibility]
	@Survey_id INT, 
	@Study_id INT,
	@DataSet VARCHAR(2000),
        @startDate DATETIME=NULL, 
        @EndDate DATETIME=NULL,
	@seed INT,
	@ReSurvey_Period INT,
	@EncounterDateField VARCHAR(42),
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

SELECT @HouseHoldingType=strHouseHoldingType
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
		ReSurveyDate DATETIME, HouseHold_id int, bitBadAddress bit default 0, bitBadPhone bit default 0)

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
IF @EncounterDateField IS NULL AND @encTableExists=0 SET @EncounterDateField='populationNewRecordDate'
	ELSE IF @EncounterDateField IS NULL AND @encTableExists=1 SET @EncounterDateField='encounterNewRecordDate'

IF NOT (@FromDate is null or @FromDate='')
BEGIN
	SELECT @strDateWhere=' AND '+@EncounterDateField+' BETWEEN '''+@FromDate+''' AND '''+CONVERT(VARCHAR,@ToDate)+' 23:59:59'''
END
ELSE
BEGIN
	SET @strDateWhere=' AND '+@EncounterDateField+' BETWEEN ''01jan1900'' AND ''01jan2500'''
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
IF NOT EXISTS (SELECT 1 FROM @tbl WHERE FieldName= @EncounterDateField)
	INSERT INTO @tbl SELECT @EncounterDateField, 'D',4,'9999'
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
				AND p.Pop_id=b.Pop_id
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



SET @Sel='INSERT INTO #SampleUnit_Universe 
SELECT DISTINCT SampleUnit_id, ' +
@PopID_EncID_Select_Aliased+', POPULATIONAge, DQ_ID, '+
'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '+@EncounterDateField+', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone' 
IF @HouseHoldingType<>'N' SET @Sel=@Sel++', '+REPLACE(@HouseHoldFieldSelectSyntax,'X.','BV.')
SET @Sel=@Sel+' FROM #PreSample X, #BVUK BV ' +
'WHERE '+@BVJOIN 

SET @Sel=@Sel+' ORDER BY SampleUnit_id, '+@PopID_EncID_Select_Aliased 
EXEC (@Sel)



EXEC QCL_SampleSetIndexUniverse @encTableExists

SELECT @newbornRule=REPLACE(CONVERT(VARCHAR(7900),strCriteriaString),'"','''')
FROM criteriastmt c, businessrule br
WHERE c.criteriastmt_id=br.criteriastmt_id AND
	c.study_id=@study_id AND
	br.survey_id=@Survey_id AND
	BusRule_cd='B'

IF @newbornRule IS NOT NULL EXEC QCL_SampleSetNewbornRule @study_id, @BVJOIN, @newbornRule

EXEC QCL_SampleSetTOCLRule @study_id

EXEC QCL_SampleSetAssignHouseHold @HouseHoldFieldCreateTableSyntax, 
                                 @HouseHoldFieldSelectSyntax, 
                                 @HouseHoldJoinSyntax, 
                                 @HouseHoldingType

IF (SELECT strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart')='ATHENA'
BEGIN
SELECT @sel='SELECT * INTO BDTEMP_'+LTRIM(STR(@SampleSet_id))+' FROM #SampleUnit_Universe'
EXEC (@sel)
END

-- Apply the resurvey exclusion rule
EXEC QCL_SampleSetResurveyExclusion @study_id, @resurveyMethod_id, @ReSurvey_Period, @samplingAlgorithmId

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
SELECT su.SampleUnit_id, su.Pop_id, su.Enc_id, su.DQ_Bus_Rule, su.Removed_Rule, su.EncDate, su.HouseHold_id, su.bitBadAddress, su.bitBadPhone
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
drop table #SampleAble
drop table #UnSampleAble
drop table #UnSampleAblerr
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF 




GO 
-----------------------------------------------------------------------------------------------
GO

insert into sampleselectiontype values ('Exclusive')
insert into sampleselectiontype values ('Minor Module')
insert into sampleselectiontype values ('NonExclusive')

GO 
-----------------------------------------------------------------------------------------------
GO


/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It creates a new
sampleset record and also adds placeholders in the sampleplanworksheet table.

Created:  2/23/2006 by DC

Modified:

*/ 

CREATE          PROCEDURE [dbo].[QCL_InsertSampleSet] 
 @intSurvey_id INT,
 @intEmployee_id INT,
 @vcDateRange_FromDate VARCHAR(24) = NULL,
 @vcDateRange_ToDate VARCHAR(24) = NULL,
 @tiOverSample_flag bit,
 @tiNewPeriod_flag bit,
 @intPeriodDef_id int,
 @strSurvey_nm VARCHAR(10), 
 @intDateRange_Table_id int, 
 @intDateRange_Field_id int,
 @SamplingAlgorithmId int,
 @intSamplePlan_id INT
AS
 DECLARE @intSampleSet_id int

 INSERT INTO dbo.SampleSet
  (SamplePlan_id, Survey_id, Employee_id, datSampleCreate_dt, 
   intDateRange_Table_id, intDateRange_Field_id, datDateRange_FromDate, 
   datDateRange_ToDate, tiOverSample_flag, tiNewPeriod_flag, strSampleSurvey_nm,
	SamplingAlgorithmId)
 VALUES
  (@intSamplePlan_id, @intSurvey_id, @intEmployee_id, GETDATE(), 
   @intDateRange_Table_id, @intDateRange_Field_id, @vcDateRange_FromDate, 
   @vcDateRange_ToDate, @tiOverSample_flag, @tiNewPeriod_flag, @strSurvey_nm,
	@SamplingAlgorithmId)
                                                                                                                                                                        
 SELECT @intSampleSet_id = @@IDENTITY 

 --Insert into SamplePlanWorkSheet table
	INSERT INTO SamplePlanWorkSheet (SampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intPeriodReturnTarget, 
		numDefaultResponseRate, intSamplesInPeriod)
	SELECT @intSampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intTargetReturn, 
		numInitResponseRate, intExpectedSamples
	FROM SampleUnit su, SamplePlan sp, Survey_def sd, Perioddef p
	WHERE sp.Survey_id = @intSurvey_id
	AND sp.SamplePlan_id = su.SamplePlan_id
	AND sp.Survey_id = sd.Survey_id 
	AND sd.survey_id=p.survey_Id
	AND p.periodDef_id=@intPeriodDef_id

SELECT @intSampleSet_id AS intSampleSet_id
GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to add one record to the samplepop table
for each person sampled.  The people sampled will already have
their records inserted into selectedsample.

Created:  2/23/2006 by DC

Modified:

*/  
CREATE PROCEDURE [dbo].[QCL_InsertSamplePop]
 @SampleSet_id int,
 @Study_id int, 
 @pop_id int,
 @bitBadAddress bit,
 @bitBadPhone bit
AS
 
 INSERT INTO dbo.SamplePop
  (SampleSet_id, Study_id, Pop_id, bitBadAddress, bitBadPhone)
  Values (@SampleSet_id, @Study_id, @Pop_id, @bitBadAddress, @bitBadPhone)
GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
indicating which dataset was sampled for a sampleset

Created:  02/23/2006 by DC

Modified:
*/  

Create  PROCEDURE [dbo].[QCL_InsertSampleDataSet]
 @SampleSet_id int, 
 @dataSet_Id int
AS

INSERT INTO dbo.SampleDataSet values (@SampleSet_id, @dataSet_Id)
GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
for each unit that an pop record is sampled for into SelectedSample

Created:  02/24/2006 by DC

Modified:
*/  

CREATE  PROCEDURE [dbo].[QCL_InsertSelectedSample]
 @SampleSet_id int, 
 @study_id int,
 @pop_id int,
 @sampleunit_id int,
 @strunitSelectType char(1),
 @enc_id int = null,
 @reportDate datetime
AS

INSERT INTO dbo.selectedsample (SampleSet_id, Study_id, Pop_id, SampleUnit_id,
		StrunitSelecttype, enc_id, reportDate) values (@SampleSet_id, @study_id, @pop_id,
	@sampleunit_id, @strunitSelectType, @enc_id, @reportDate)

GO 
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It will update the response
rate information in the sampleunit table.

Created:  02/24/2006 by DC

Modified:
*/  
CREATE       PROCEDURE [dbo].[QCL_CalcResponseRates]
 @Survey_id INT,
 @ResponseRate_Recalc_Period INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period = intResponse_Recalc_Period
  FROM Survey_def
  WHERE Survey_id = @Survey_id

CREATE TABLE #SampleSets (SampleSet_id INT)
 /* Mark the Sample Sets that have completed the collection methodology */
 INSERT INTO #SampleSets
 SELECT SampleSet_id
  FROM SampleSet
  WHERE datLastMailed IS NOT NULL
   AND DATEDIFF(DAY, datLastMailed, GETDATE()) > @ResponseRate_Recalc_Period
   AND Survey_id = @Survey_id

--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled))*100) AS RespRate
INTO #r
FROM nrc47.qp_comments.dbo.RespRateCount rrc, #SampleSets ss
WHERE SampleUnit_id <> 0
AND rrc.SampleSet_id = ss.SampleSet_id
GROUP BY SampleUnit_id

UPDATE SampleUnit
SET numResponseRate = RespRate
FROM #r
WHERE SampleUnit.SampleUnit_id = #r.SampleUnit_id

DROP TABLE #r


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It updates the samplesetUnitTarget
table with target information, and also updates the SPW.

Created:  02/24/2006 by DC

Modified:
*/  
CREATE  PROCEDURE [dbo].[QCL_CalcTargets]
 @SampleSet_id INT,
 @Period_id INT, 
 @SamplesInPeriod INT,
 @SamplesRun INT,
 @Survey_id INT,
 @samplingMethod int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
DECLARE @SamplesLeft int
SET @SamplesLeft=@SamplesInPeriod-@SamplesRun

 /* Creating temp tables for calculation of targets */
 /* The following table will retain the number of eligible record per sample unit */
 CREATE TABLE #SampleUnit_Count
  (SampleUnit_id INT, 
  PopCounter INT)
 /* The following table will retain the sample_sets within this period*/
 CREATE TABLE #SampleSet_Period
  (SampleSet_id INT)
 /* The following table will retain the number of Samples left, target returns and response rates for each sample_units */
 CREATE TABLE #SampleUnit_Temp
  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period real, 
  ResponseRate real,
  InitResponseRate INT)
 /* The following table will retain the different numbers used to compute targets for each sample_units */
 CREATE TABLE #SampleUnit_Sample
  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period INT, 
  ResponseRate real, 
  InitResponseRate real,
  NumSampled_Period INT, 
  ReturnEstimate INT, 
  ReturnsNeeded_Period INT, 
  NumToSend_Period FLOAT, 
  NumToSend_SampleSet INT)

	 /* Getting the other sampleSet_id than the one we are processing */
	 INSERT INTO #SampleSet_Period
	  SELECT SampleSet_id 
	  FROM dbo.PeriodDates S
	  WHERE S.perioddef_id = @Period_id and
			datsamplecreate_dt is not null

	 IF @SamplesLeft < 1 SELECT @SamplesLeft = 1 

	 INSERT INTO #SampleUnit_Temp
	  SELECT SampleUnit_id, @SamplesLeft, intTargetReturn, numResponseRate, numInitResponseRate
	   FROM dbo.SamplePlan SP, dbo.SampleUnit SU
	   WHERE SP.SamplePlan_id = SU.SamplePlan_id
	    AND SP.Survey_id = @Survey_id

	 INSERT INTO #SampleUnit_Sample(SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate,
	   NumSampled_Period, ReturnEstimate, ReturnsNeeded_Period, NumToSend_Period, 
	   NumToSend_SampleSet)
	  SELECT  SampleUnit_id, SamplesLeft, 
	   TargetReturn_Period, ISNULL(ResponseRate,0), InitResponseRate, 0, 0, 0, 0, 0
	   FROM  #SampleUnit_Temp

	 INSERT INTO #SampleUnit_Count
	  SELECT SS.SampleUnit_id, COUNT(Pop_id)
	   FROM dbo.SelectedSample SS, #SampleSet_Period SSP
	   WHERE SS.SampleSet_id = SSP.SampleSet_id
	    AND SS.strUnitSelectType = 'D'
	   GROUP BY SS.SampleUnit_id

	 UPDATE #SampleUnit_Sample
	  SET NumSampled_Period = PopCounter
	  FROM #SampleUnit_Count SUC
	  WHERE SUC.SampleUnit_id = #SampleUnit_Sample.SampleUnit_id

IF @samplingMethod=1 
BEGIN

	 /* Computing the rest of the SampleUnit targets */
	 UPDATE #SampleUnit_Sample
	  SET ReturnEstimate = ROUND(NumSampled_Period * (CONVERT(float,ResponseRate)/100), 0)

	 UPDATE #SampleUnit_Sample
	  SET ReturnsNeeded_Period = TargetReturn_Period - ReturnEstimate

	 UPDATE #SampleUnit_Sample
	  SET NumToSend_Period = CASE 
		WHEN ResponseRate = 0 THEN ReturnsNeeded_Period/(CONVERT(float, InitResponseRate)/100)
		WHEN ResponseRate is null THEN ReturnsNeeded_Period/(CONVERT(float, 100)/100)
	   ELSE ReturnsNeeded_Period/(CONVERT(float, ResponseRate)/100) 
	   END

	 UPDATE #SampleUnit_Sample
	  SET NumToSend_SampleSet = ROUND(NumToSend_Period/SamplesLeft, 0)

	INSERT INTO SampleSetUnitTarget
	  SELECT @SampleSet_id, SampleUnit_id, NumToSend_SampleSet
	   FROM #SampleUnit_Sample
	
	--Updates to SamplePlanWorkSheet table
	UPDATE spw
	SET spw.numHistoricResponseRate = ResponseRate, intAnticipatedTPPOReturns = ReturnEstimate,
		intAdditionalReturnsNeeded = ReturnsNeeded_Period, intSamplesLeftInPeriod = SamplesLeft - 1,
		numAdditionalPeriodOutgoNeeded = NumToSend_Period, intOutgoNeededNow = NumToSend_SampleSet,
		intSamplesAlreadyPulled=@SamplesRun + 1, inttotalpriorperiodoutgo=NumSampled_Period
	FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t
	WHERE spw.SampleSet_id = @SampleSet_id
	AND spw.SampleUnit_id = t.SampleUnit_id
END
Else IF @samplingMethod=2
Begin
	 UPDATE #SampleUnit_Sample
	  SET ReturnsNeeded_Period = TargetReturn_Period - NumSampled_Period

	 UPDATE #SampleUnit_Sample 
	  SET NumToSend_SampleSet=ROUND(ReturnsNeeded_Period*1.0/SamplesLeft,0)
	   FROM dbo.SamplePlan SP, dbo.SampleUnit SU
	   WHERE SP.SamplePlan_id = SU.SamplePlan_id
	    AND SP.Survey_id = @Survey_id 
		AND su.sampleunit_id=#SampleUnit_Sample.sampleunit_id

	INSERT INTO SampleSetUnitTarget
	  SELECT @SampleSet_id, SampleUnit_id, NumToSend_SampleSet
	   FROM #SampleUnit_Sample
	
	--Updates to SamplePlanWorkSheet table
	UPDATE spw
	SET spw.numHistoricResponseRate = ResponseRate, 
		intAdditionalReturnsNeeded = ReturnsNeeded_Period,
		intSamplesLeftInPeriod = SamplesLeft - 1,
		intOutgoNeededNow = NumToSend_SampleSet,
		intSamplesAlreadyPulled=@SamplesRun + 1, 
		inttotalpriorperiodoutgo=NumSampled_Period,
		numAdditionalPeriodOutgoNeeded = ReturnsNeeded_Period
	FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t
	WHERE spw.SampleSet_id = @SampleSet_id
	AND spw.SampleUnit_id = t.SampleUnit_id
END
ELSE
BEGIN
	--CENSUS
	 UPDATE #SampleUnit_Sample
	  SET NumToSend_SampleSet = 999999
	
	INSERT INTO SampleSetUnitTarget
	  SELECT @SampleSet_id, SampleUnit_id, NumToSend_SampleSet
	   FROM #SampleUnit_Sample
	
	--Updates to SamplePlanWorkSheet table
	--SamplesLeft and Samples to Run need to be adjusted to account for this
	--Sample
	UPDATE spw
	SET spw.numHistoricResponseRate = ResponseRate, 
		intSamplesLeftInPeriod = SamplesLeft -1,
		intOutgoNeededNow = NumToSend_SampleSet,
		intSamplesAlreadyPulled=@SamplesRun + 1, 
		inttotalpriorperiodoutgo=NumSampled_Period
	FROM SamplePlanWorkSheet spw, #SampleUnit_Sample t
	WHERE spw.SampleSet_id = @SampleSet_id
	AND spw.SampleUnit_id = t.SampleUnit_id

END


 DROP TABLE #SampleUnit_Count
 DROP TABLE #SampleSet_Period
 DROP TABLE #SampleUnit_Temp
 DROP TABLE #SampleUnit_Sample


  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It returns 1 record 
for each sampleunit that needs to be sampled.

Created:  02/24/2006 by DC

Modified:
*/  

CREATE  PROCEDURE [dbo].[QCL_SelectOutGoNeeded]
 @SampleSet_id int, 
 @survey_id int,
 @Period_id INT, 
 @SamplesInPeriod INT,
 @SamplesRun INT,
 @samplingMethod INT,
 @ResponseRate_Recalc_Period INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
--Calculates the current response rate and updates the sampleunit table
EXEC QCL_CalcResponseRates @survey_id, @ResponseRate_Recalc_Period
--Calculates the targets for the current sampleset and saves in the SampleSetUnitTarget table
EXEC QCL_CalcTargets @SampleSet_id, @Period_id, @SamplesInPeriod, @SamplesRun, 
		@Survey_id, @samplingMethod

 SELECT sampleunit_id, intTarget 
  FROM dbo.samplesetunittarget 
  WHERE SampleSet_id = @SampleSet_id
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It adds or updates the sample
in the PeriodDates table.

Created:  02/27/2006 by DC

Modified:
*/  

CREATE    PROCEDURE [dbo].[QCL_InsertSampleSetInPeriod]
 @SampleSet_id int,
 @Period_id int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
Declare @minEmptySample integer

SELECT @minEmptySample=MIN(samplenumber)
FROM perioddates
WHERE datsamplecreate_dt IS null and
	  PERIODDEF_ID=@Period_id

IF @minEmptySample IS NULL
	--Oversample
	BEGIN
		DECLARE @MAXSAMPLE AS INTEGER

		SELECT @MAXSAMPLE=MAX(SAMPLENUMBER)
		FROM PERIODDATES
		WHERE PERIODDEF_ID=@Period_id

		INSERT INTO PERIODDATES (PERIODDEF_ID, SAMPLENUMBER, DATSCHEDULEDSAMPLE_DT,
								 SAMPLESET_ID, DATSAMPLECREATE_DT)
		VALUES (@Period_id, @MAXSAMPLE + 1, GETDATE(), @SampleSet_id, GETDATE())
	END
ELSE
	BEGIN
		UPDATE perioddates
		SET SAMPLESET_ID=@SampleSet_id,
			DATSAMPLECREATE_DT=GETDATE()
		WHERE PERIODDEF_ID=@Period_id AND
			SAMPLENUMBER=@minEmptySample
	END

  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO 
-----------------------------------------------------------------------------------------------
GO
alter table SamplePlanWorkSheet
	add badphonecount int not null default 0,
	 BadAddressCount int not null default 0,
	 HcahpsDirectSampledCount int not null default 0
GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It updates the sample
plan worksheet table after we have finished the sampling algorithm.

Created:  02/27/2006 by DC

Modified:
*/  

Alter        PROCEDURE [dbo].[QCL_UpdateSamplePlanWorksheet]
 @SampleSet_id int,
 @SampleUnit_id int,
 @DQCount int,
 @DirectSampleCount int,
 @IndirectSampleCount int,
 @UniverseCount int,
 @MinEncDate datetime = null,
 @MaxEncDate datetime = null,
 @BadPhoneCount int,
 @BadAddressCount int,
 @HcahpsDirectSampledCount int
AS

UPDATE SamplePlanWorkSheet
SET intSampledNow = @DirectSampleCount,
	intIndirectSampledNow=@IndirectSampleCount, 
	intDQ = @DQCount, 
	intAvailableUniverse = @UniverseCount - @DQCount, 
	intUniversecount=coalesce(intUniversecount,0) + @UniverseCount,
	intshortfall=intoutgoneedednow-@DirectSampleCount,
	minEnc_dt=@MinEncDate,
	maxEnc_dt=@MaxEncDate,
	BadPhoneCount=@BadPhoneCount,
	BadAddressCount=@BadAddressCount,
	HcahpsDirectSampledCount=@HcahpsDirectSampledCount
WHERE SampleUnit_id = @SampleUnit_id
AND SampleSet_id = @SampleSet_id


GO 
-----------------------------------------------------------------------------------------------
GO



/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
for each unit and Removed rule that represents the count of occurences of that combination.

Created:  02/27/2006 by DC

Modified:
*/  
ALTER      PROCEDURE [dbo].[QCL_InsertRemovedRulesIntoSPWDQCOUNTS] 
	@sampleset_Id int, 
	@sampleunit_id int,
	@RuleName varchar(42),
	@count int
as

IF EXISTS (SELECT 1 FROM SPWDQCounts 
			WHERE sampleset_id=@sampleset_Id 
			AND sampleunit_Id=@sampleunit_id 
			AND DQ=@RuleName)
BEGIN
	UPDATE SPWDQCounts
	SET N=N+@count
	WHERE sampleset_id=@sampleset_Id 
		AND sampleunit_Id=@sampleunit_id 
		AND DQ=@RuleName
END
ELSE 
BEGIN
	INSERT INTO SPWDQCounts (sampleset_id, sampleunit_Id, DQ, N)
	VALUES (@sampleset_Id, @sampleunit_id, @RuleName, @count)
END

GO 
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
for each unit and DQ that represents the count of occurences of that combination.

Created:  02/27/2006 by DC

Modified:
*/  
CREATE      PROCEDURE [dbo].[QCL_InsertDQRuleIntoSPWDQCOUNTS] 
	@sampleset_Id int, 
	@sampleunit_id int,
	@DQRuleId int,
	@count int
as
DECLARE @DQName as varchar(8)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


SELECT @DQName=strCriteriaStmt_nm
  FROM CriteriaStmt
  WHERE CriteriaStmt_id=@DQRuleId

INSERT INTO SPWDQCounts (sampleset_id, sampleunit_Id, DQ, N)
VALUES (@sampleset_Id, @sampleunit_id, @DQName, @count)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO 
-----------------------------------------------------------------------------------------------
GO
alter table SPWDQCounts
	alter column DQ varchar(42)
GO 
-----------------------------------------------------------------------------------------------
GO


/*
Business Purpose: 

This procedure is used to get information about all sample sets for a period.  

Created:  01/30/2006 by Dan Christensen

Modified:
	02/28/2006 by DC
		aliased SamplingAlgorithmId

*/
ALTER PROCEDURE [dbo].[QCL_SelectSampleSetsByPeriod]
@PeriodDef_id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, ss.Employee_Id,
	p.datExpectedEncStart, p.datExpectedEncEnd, ss.SamplePlan_Id, ss.intSample_Seed,
	tiNewPeriod_flag, tiOversample_flag, datScheduled, ss.SamplingAlgorithmId
FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s
WHERE pd.PeriodDef_id=@PeriodDef_id
AND ss.SampleSet_id = pd.SampleSet_id
AND pd.PeriodDef_id = p.PeriodDef_id
AND ss.Survey_id = sd.Survey_id
AND sd.Study_id = s.Study_id
AND sd.Survey_id = ss.Survey_id
ORDER BY ss.datSampleCreate_dt

GO 
-----------------------------------------------------------------------------------------------
GO


/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  01/30/2006 by Dan Christensen

Modified:
	02/28/2006 by DC
		aliased SamplingAlgorithmId

*/
ALTER PROCEDURE [dbo].[QCL_SelectSampleSet]
@SampleSet_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, ss.Employee_Id,
	p.datExpectedEncStart, p.datExpectedEncEnd, ss.SamplePlan_Id, ss.intSample_Seed,
	tiNewPeriod_flag,tiOversample_flag, datScheduled, ss.SamplingAlgorithmId
FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s
WHERE ss.SampleSet_id=@SampleSet_id
AND ss.SampleSet_id = pd.SampleSet_id
AND pd.PeriodDef_id = p.PeriodDef_id
AND ss.Survey_id = sd.Survey_id
AND sd.Study_id = s.Study_id
AND sd.Survey_id = ss.Survey_id
ORDER BY ss.datSampleCreate_dt


GO 
-----------------------------------------------------------------------------------------------
GO
/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It updates the   
contents of the sampleset table after the sampling algorithm has finished. 
  
Created:  02/28/2006 by DC  
  
Modified:  
*/      
CREATE PROCEDURE [dbo].[QCL_UpdateSampleSetPostSample]  
@sampleSetId INT,  
@preSampleTime INT,
@postSampleTime INT,
@seed INT,
@MinEncounterDate datetime = null,
@MaxEncounterDate datetime =null

AS 

if @MinEncounterDate is null
BEGIN 
  	UPDATE SampleSet  
	SET PreSampleTime=@preSampleTime,
		PostSampleTime=@postSampleTime,
		intSample_Seed=@seed
	WHERE SampleSet_id=@SampleSetid 
END
ELSE
BEGIN
  	UPDATE SampleSet  
	SET PreSampleTime=@preSampleTime,
		PostSampleTime=@postSampleTime,
		intSample_Seed=@seed,
		datDateRange_FromDate=@MinEncounterDate,
		datDateRange_ToDate=@MaxEncounterDate
	WHERE SampleSet_id=@SampleSetid 
END 

GO 
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
which records should be DQ'd because of resurvey exclusion

Created:  02/28/2006 by DC

Modified:

*/  
CREATE       PROCEDURE [dbo].[QCL_SampleSetResurveyExclusion]
 @Study_id INT,
 @Resurvey_Excl_Period INT
AS

 SELECT distinct sp.pop_id
 INTO #remove_pops
 FROM samplepop sp, sampleset ss
 WHERE study_id=@Study_id AND
	sp.sampleset_id=ss.sampleset_id AND
	(DATEDIFF(day, ss.datlastmailed, GETDATE()) <@Resurvey_Excl_Period
			OR ss.datlastmailed is null)	

 --Removed Rule value of 1 means it is resurvey exclusion.  This is not a bit field.
 UPDATE #Sampleunit_universe
  SET Removed_Rule = 1  
  FROM #Sampleunit_universe U, #remove_pops MM
  WHERE U. Pop_id = MM.Pop_id and
		removed_rule=0

 DROP TABLE #remove_pops

GO 
-----------------------------------------------------------------------------------------------
GO
--Drop the old versions of resurvey exclusion

DROP       PROCEDURE [dbo].[sp_Samp_Resurvey_Exclusion]
GO 
-----------------------------------------------------------------------------------------------
GO
DROP       PROCEDURE [dbo].[sp_Samp_Resurvey_ExclusionV2]
GO 
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It indexes the list of
all eligible encounters and is used during the sampling process.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE      PROCEDURE [dbo].[QCL_SampleSetIndexUniverse]
 @bitEncounterExists bit = 0
AS

 
 IF @bitEncounterExists = 1
 BEGIN
  CREATE INDEX idxSUU_Pop_Enc
   ON #SampleUnit_Universe (Pop_id, Enc_id)
  CREATE CLUSTERED INDEX IX_PreSample_DSPopSU 
	ON #PreSample
		    (sampleunit_id, pop_id, Enc_id)
 END
 ELSE
 BEGIN
  CREATE INDEX idxSUU_Pop_Enc
   ON #SampleUnit_Universe (Pop_id)
  CREATE CLUSTERED INDEX IX_PreSample_DSPopSU 
	ON #PreSample
		    (sampleunit_id, Pop_id)
 END

GO 
-----------------------------------------------------------------------------------------------
GO
--Drop the old version of index universe

Drop Procedure sp_Samp_Index_Universe

GO 
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
which records should be DQ'd because of newborn criteria.

Created:  02/28/2006 by DC

Modified:

*/  
CREATE       PROCEDURE [dbo].[QCL_SampleSetNewbornRule]
 @Study_id int,
 @vcBigView_Join varchar(8000),
 @vcNewborn_Where varchar(8000)
AS
 DECLARE @vcUPDATE varchar(8000)
 DECLARE @vcSET varchar(8000)
 DECLARE @vcFROM varchar(8000)
 DECLARE @vcWHERE varchar(8000)

 /*Newborn rule Const*/
 DECLARE @NewbornRemoveFlag tinyint
 SET @NewbornRemoveFlag = 2
 /*Format the 'INSERT', 'SELECT', 'FROM', and 'WHERE' elements of the SQL Statement*/
 SET @vcUPDATE = 'UPDATE #Sampleunit_Universe'
 SET @vcSET = ' SET Removed_Rule = ' + CONVERT(varchar, @NewbornRemoveFlag)
 SET @vcFROM = ' FROM #Sampleunit_Universe X, S' + CONVERT(varchar, @Study_id) + '.Big_View BV'
 SET @vcWHERE = ' WHERE Removed_Rule=0 and ' + @vcBigView_Join +
     ' AND ' + @vcNewborn_Where
 EXECUTE (@vcUPDATE + @vcSET + @vcFROM + @vcWHERE)
GO 
-----------------------------------------------------------------------------------------------
GO
--Drop the old versions of newborn check
Drop Procedure sp_Samp_Apply_Newborn_Rule
Drop Procedure sp_Samp_Apply_Newborn_RuleV2

GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
which records should be DQ'd because of Take off call list.

Created:  02/28/2006 by DC

Modified:

*/  
CREATE    PROCEDURE [dbo].[QCL_SampleSetTOCLRule]
 @Study_id int
AS

 DECLARE @TOCLRemoveRule tinyint
 SET @TOCLRemoveRule = 3
 UPDATE #Sampleunit_Universe
  SET Removed_Rule = @TOCLRemoveRule
  FROM #Sampleunit_Universe U, dbo.TOCL T
  WHERE U.Pop_id = T.Pop_id
   AND T.Study_id = @Study_id

GO 
-----------------------------------------------------------------------------------------------
GO
--Drop the old versions of TOCL Rule
Drop Procedure sp_Samp_Apply_TOCL_Rule
Drop Procedure sp_Samp_Apply_TOCL_RuleV2

GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
the hierarchical order for units that is used during the presample.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE PROCEDURE [dbo].[QCL_SampleSetReOrgSampleUnits]  
  @Survey_id INT, @bitPreSampleReport BIT=0  
AS   
  
SET NOCOUNT ON  
  
CREATE TABLE #SU  
  (strSurvey_nm VARCHAR(42),  
   SampleUnit_id INT,  
   strSampleUnit_nm VARCHAR(42),  
   ParentSampleUnit_id INT,  
   CriteriaStmt_id INT,  
   intTier INT,  
   strNode VARCHAR(255),  
   intTreeOrder INT,  
   Survey_id INT,
   intTargetReturn INT)  
  
DECLARE @strSql VARCHAR(3000)  
DECLARE @Tier INT, @TreeOrder INT, @intSamplePlan_id INT  
  
SET @Tier=0  
  
SELECT @intSamplePlan_id=SamplePlan_id FROM SamplePlan WHERE Survey_id=@Survey_id  
  
--First pull over the Parent Unit  
INSERT INTO #SU (SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, CriteriaStmt_id, intTier, strNode, Survey_id,strSurvey_nm,intTargetReturn)  
  SELECT SampleUnit_id,su.strSampleUnit_nm,ParentSampleUnit_id,CriteriaStmt_id,1,CONVERT(VARCHAR,SampleUnit_id), sp.Survey_id,sd.strSurvey_nm,intTargetReturn
  FROM SampleUnit su, SamplePlan sp, Survey_def sd   
 WHERE sp.SamplePlan_id=@intSamplePlan_id  
  AND sp.SamplePlan_id=su.SamplePlan_id   
  AND ParentSampleUnit_id IS NULL  
  AND sp.Survey_id=sd.Survey_id  
  
--Now to pull over the children  
WHILE (@@ROWCOUNT>0)  
BEGIN  
  SET @Tier = @Tier + 1  
  INSERT INTO #SU (SampleUnit_id,strSampleUnit_nm,ParentSampleUnit_id, CriteriaStmt_id, intTier, strNode, Survey_id,strSurvey_nm,intTargetReturn)  
   SELECT su.SampleUnit_id,su.strSampleUnit_nm,su.ParentSampleUnit_id,su.CriteriaStmt_id,@Tier+1,  
  t.strNode+'.'+RIGHT('000000'+CONVERT(VARCHAR,su.SampleUnit_id),7), Survey_id,strSurvey_nm,su.intTargetReturn
   FROM SampleUnit su, #SU t  
   WHERE su.SamplePlan_id=@intSamplePlan_id  
     AND su.ParentSampleUnit_id=t.SampleUnit_id   
     AND t.intTier=@Tier  
END  
  
--Determine the ordering of the tree  
SET @TreeOrder=1  
UPDATE #SU   
 SET intTreeOrder=@TreeOrder   
 WHERE strNode=(SELECT MIN(strNode) FROM #SU WHERE intTreeOrder IS NULL)  
WHILE @@ROWCOUNT>0  
BEGIN  
  SET @TreeOrder=@TreeOrder+1  
  UPDATE #SU   
   SET intTreeOrder=@TreeOrder   
   WHERE strNode=(SELECT MIN(strNode) FROM #SU WHERE intTreeOrder IS NULL)  
END  
  
IF @bitPreSampleReport=1  
 SELECT * FROM #SU  
ELSE  
 SELECT SampleUnit_id,ParentSampleUnit_id,CriteriaStmt_id,intTier,strNode,intTreeOrder,Survey_id  
 FROM #SU  
GO 
-----------------------------------------------------------------------------------------------
GO
--Drop the old version of Reorganize SampleUnits
Drop Procedure SP_Samp_ReOrgSampleUnits

GO 
-----------------------------------------------------------------------------------------------
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
	   ' AND ms.table_id=sd.cutofftable_id' +
	   ' AND ms.field_id=sd.cutofffield_id' +
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
					AND'+@Criteria+'
					AND DQ_id=0'
	ELSE
		SELECT @Sel='UPDATE p
					SET DQ_id='+CONVERT(VARCHAR,@DQ_id)+'
					FROM #PreSample p, #BVUK b
					WHERE p.Enc_id=b.Enc_id
					AND'+@Criteria+'
					AND DQ_id=0'
	EXEC (@Sel)

	DELETE #Criters WHERE strCriteriaStmt=@Criteria AND Survey_id=@Survey

	SELECT TOP 1 @Criteria=strCriteriaStmt, @DQ_id=CriteriaStmt_id FROM #Criters WHERE Survey_id=@Survey ORDER BY CriteriaStmt_id

END

	
Insert into #Timer (PreSampleEnd) values (getdate()) 

DROP TABLE #Criters
DROP TABLE #DataSets
DROP TABLE #BVUK
GO 
-----------------------------------------------------------------------------------------------
GO 
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It checks to
see if adult householing rules have been violated.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE     PROCEDURE [dbo].[QCL_SampleSetHouseHoldingAdult]
 @Study_id     INT,   /* Study Identifier */
 @strHouseholdField_CreateTable  VARCHAR(8000), /* List of fields and type that are used for HouseHolding criteria */
 @strHouseholdField_Select   VARCHAR(8000), /* List of fields that are used for HouseHolding criteria */
 @strHousehold_Join    VARCHAR(8000), /* Join criteria that are used for HouseHolding */
 @lngReSurveyEx_Period   INT ,  /* Survey exclusion period (in days) */
 @seed int /*The random number seed*/
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  


 DECLARE @HHRemoveRule  TINYINT 
 DECLARE @strSQL  VARCHAR(8000)
 /* sets variable @HHRemoveRule with appropriate code for Removed_Rule field of 
  #SampleUnit_Universe for Adult Householding*/
 SET @HHRemoveRule = 7


/***********************************************************
 Creation of local temporary tables
***********************************************************/
 CREATE TABLE #Random_Pop
  (ID_num int identity,
  Pop_id INT, 
  numRandom FLOAT(24))
/**************************************************************************************
  (b1) Compare Householding between all people in the Universe with all 
 people in other Sample Sets
**************************************************************************************/
 /* (b1a) Set "#SampleUnit_Universe.bitRemove" = 1 on those people who have the same 
  address as somebody in any other sample set on the study who has not 
  completed a mailing methodology. */
 SELECT @strSQL = 
  'UPDATE #SampleUnit_Universe
   SET Removed_Rule = ' + CONVERT(VARCHAR, @HHRemoveRule) + '
   FROM #SampleUnit_Universe Y, 
    S' + CONVERT(VARCHAR, @Study_id) + '.Population X, 
    dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, 
    dbo.MailingStep MS
   WHERE Y.Pop_id = SP.Pop_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND SchM.SentMail_id IS NULL
    AND ' + @strHousehold_Join + '
    AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
    AND MS.bitThankYouItem = 0
    AND Y.Removed_Rule = 0'
 -- PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b1c) Insert the Householding fields and mailing date of the last mailing item 
  sent for any houshold represented in #SampleUnit_Universe table. */
 SELECT @strSQL = 
  'INSERT INTO #Max_MailingDate
   SELECT ' + @strHouseholdField_Select + ', MAX (SM.datMailed)
    FROM #SampleUnit_Universe X, 
     S' + CONVERT(VARCHAR, @Study_id) + '.Population Y, 
     dbo.SamplePop SP, 
     dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, 
     dbo.MailingStep MS
    WHERE Y.Pop_id = SP.Pop_id
     AND SP.SamplePop_id = SchM.SamplePop_id
     AND SchM.ScheduledMailing_id = SM.ScheduledMailing_id
     AND SchM.MailingStep_id = MS.MailingStep_id
     AND ' + @strHousehold_Join + '
     AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
     AND X.Removed_Rule = 0
     AND MS.bitThankYouItem = 0
    GROUP BY ' + @strHouseholdField_Select
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b1d) Set "#SampleUnit_Universe.bitRemove" = 1 if a record matches the householding 
  fields of the #Max_Mailing table, and the "#Max_Mailing.datMailed" is within the 
  Re-Survey exclusion number of days from the current date. */
 SELECT @strSQL = 
  'UPDATE #SampleUnit_Universe
   SET Removed_Rule = ' + CONVERT(VARCHAR, @HHRemoveRule) + '
   FROM #SampleUnit_Universe X, 
    #Max_MailingDate Y
   WHERE ' + @strHousehold_Join + '
    AND X.Removed_Rule = 0
    AND DATEDIFF(day, Y.datMailed, GETDATE()) < ' 
     + CONVERT(VARCHAR, @lngReSurveyEx_Period)
 --PRINT @strSQL
 EXECUTE (@strSQL)
  
/**************************************************************************************
  (b2) Compare Householding of all people in the Universe among themselves
**************************************************************************************/
 /* (b2b) Insert the Householding fields from #SampleUnit_Universe into #HH_Dup_Fields where 
  more than one person in #SampleUnit_Universe has the sample Householding fields.  
  Do not include anybody where "SampleUnit_Universe.bitHousehold_Remove" = 1. */
 SELECT @strSQL = 
  'INSERT INTO #HH_Dup_Fields
   SELECT ' + @strHouseholdField_Select + '
    FROM #SampleUnit_Universe X
    WHERE Removed_Rule = 0
    GROUP BY ' + @strHouseholdField_Select + '
    HAVING COUNT(*) > 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b2d) Insert the distinct Pop_id and Householding Fields of the people from 
  #SampleUnit_Universe into #HH_Dup_People whose Householding fields are the same as 
  the Householding fields in #HH_Dup_Fields. */
 SELECT @strSQL = 
  'INSERT INTO #HH_Dup_People
   SELECT DISTINCT Pop_id, ' + @strHouseholdField_Select + ', 0
    FROM #HH_Dup_Fields X, 
     S' + CONVERT(VARCHAR, @Study_id) + '.Population Y
    WHERE ' + @strHousehold_Join
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b2f) Assign a random number to each record in #HH_Dup_Fields. */
 /* (b2g) Update the "bitKeep" field = 1 in #HH_Dup_Fields for each Householding fields record 
  that has the smallest "numRandom" value. */
 /* Assign a Random number to each duped record of the #Minor_Universe */
 
 INSERT INTO #Random_Pop 
 SELECT Pop_id, numrandom
 FROM #HH_Dup_People dp, random_numbers rn
 WHERE ((dp.id_num+@Seed)%1000000)=rn.random_id
 ORDER BY numrandom

 /* (b2g) Update the "bitKeep" field = 1 in #HH_Dup_Fields for each Householding fields record 
  that has the smallest "numRandom" value. */
 SELECT @strSQL = 'UPDATE #HH_Dup_People
   SET bitKeep = 1
   FROM #HH_Dup_People HHDP, #Random_Pop Y, 
		(SELECT ' + @strHouseholdField_Select + ', MIN(Y.id_num) as id_num
    	FROM #HH_Dup_People X, #Random_Pop Y
    	WHERE X.Pop_id = Y.Pop_id
    	GROUP BY ' + @strHouseholdField_Select + ') AK
    WHERE HHDP.Pop_id = Y.Pop_id
     AND Y.id_num = AK.id_num'
 EXECUTE (@strSQL)
 /* (b2h) Set "#SampleUnit_Universe.bitHousehold_Remove" = 1 where a person has a 
  "#HH_Dup_Fields.bitKeep" = 0. */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = @HHRemoveRule
  FROM #SampleUnit_Universe SU, #HH_Dup_People HH
  WHERE SU.Pop_id = HH.Pop_id
   AND HH.bitKeep = 0
 /* Drop temporary tables. */
 --DROP TABLE #Adult_Keep
 DROP TABLE #Random_Pop


  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO 
-----------------------------------------------------------------------------------------------
GO 
--Drop the old version of Householding Adult
--Drop Procedure sp_Samp_HouseHoldingAdult

GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It checks to
see if minor householing rules have been violated.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE       PROCEDURE [dbo].[QCL_SampleSetHouseHoldingMinor]
 @Study_id     INT,   /* Study Identifier */
 @strHouseholdField_CreateTable  VARCHAR(8000), /* List of fields and type that are used for HouseHolding criteria */
 @strHouseholdField_Select   VARCHAR(8000), /* List of fields that are used for HouseHolding criteria */
 @strHousehold_Join    VARCHAR(8000), /* Join criteria that are used for HouseHolding */
 @lngReSurveyEx_Period   INT,   /* Survey exclusion period (in days) */
 @strMinorException_Where   VARCHAR(8000)=NULL, /* Minor exclusion criteria (used in where clause) */
 @seed int /*Seed for joining to random number table*/
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

 DECLARE @HHRemoveRule  TINYINT 
 DECLARE @strSQL  VARCHAR(8000)
 /* sets variable @HHRemoveRule with appropriate code for Removed_Rule field of #SampleUnit_Universe 
  for Adult Householding */
 SET @HHRemoveRule = 6

/***********************************************************
 Creation of local temporary tables
***********************************************************/
 CREATE TABLE #Random_Pop 
  (id_num int identity, Pop_id INT, numRandom FLOAT(24))
/**************************************************************************************
 (a1) Compare Householding between Minors in the Sample Unit Universe with 
   Minors in other Sample Sets.
**************************************************************************************/
 /* (a1b) Insert everyone who is < 18 into #Minor_Universe, de-duped from #SampleUnit_Universe. */
 SELECT @strSQL = 
  'INSERT INTO #Minor_Universe
   SELECT DISTINCT X.Pop_id, ' + @strHouseholdField_Select + ', NULL, NULL, 0
    FROM #SampleUnit_Universe X
    WHERE X.Age < 18
     AND X.Removed_Rule = 0'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1c) Retrieve the Minor Exception rule into strMinorException_Where. */
 /*
  Use the method FetchWhereClause_BV from the MTS object "CriteriaEditorMTS.cDataAccess" 
   passing in m_intMinorExcept_CritID to assign strMinorException_Where.
 */
 /* (a1d) Mark any minor that meets the Minor Exception Rule. */
 IF @strMinorException_Where IS NOT NULL
 BEGIN
  SELECT @strSQL = 
   'UPDATE #Minor_Universe
    SET intMinorException = 1
    FROM #Minor_Universe MU, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
     WHERE MU.Pop_id = BV.POPULATIONPop_id
      AND ' + @strMinorException_Where
  --PRINT @strSQL
  EXECUTE (@strSQL)
 END
 /* (a1f) From each sample set on the study, insert into #Minor_Exclude everyone 
  who's Age < 18, who has a Non-Thank You mailing item that has not been mailed, 
  and has the same Householding Fields as a minor in #Minor_Universe. */

 SELECT @strSQL = 
  'INSERT INTO #Minor_Exclude
   SELECT Y.Pop_id, ' + @strHouseholdField_Select + ', 0
   FROM #Minor_Universe X, 
    S' + CONVERT(VARCHAR, @Study_id) + '.Population Y, 
    dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, 
    dbo.MailingStep MS
   WHERE Y.Pop_id = SP.Pop_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND ' + @strHousehold_Join + '
    AND SchM.SentMail_id IS NULL
    AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
    AND Y.Age < 18
    AND X.intMinorException <> 1
    AND MS.bitThankYouItem = 0'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1g) Mark anybody from #Minor_Exclude that meets the Minor Exception Rule. */
 IF @strMinorException_Where IS NOT NULL
 BEGIN
  SELECT @strSQL = 
   'UPDATE #Minor_Exclude
    SET intMinorException = 1
    FROM #Minor_Exclude ME, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
    WHERE ME.Pop_id = BV.POPULATIONPop_id
     AND ' + @strMinorException_Where
  --PRINT @strSQL
  EXECUTE (@strSQL)
 END
 /* (a1h) Update the "intRemove" field to 1 on any minor in the #Minor_Universe table 
  that has the same household fields as someone in #Minor_Exclude. */
 SELECT @strSQL = 
  'UPDATE #Minor_Universe
   SET intRemove = 1
   FROM #Minor_Universe X, #Minor_Exclude Y
   WHERE ' + @strHousehold_Join + '
    AND X.intMinorException <> 1
    AND Y.intMinorException <> 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1j) Insert into #Max_MailingDate all Household field records and the most 
  recent mailing item date of any minor on the study who matches an 
  Household field records of a minor in #Minor_Universe. */
 SELECT @strSQL = 
  'INSERT INTO #Max_MailingDate
   SELECT ' + @strHouseholdField_Select + ', MAX(SM.datMailed)
    FROM #Minor_Universe X, 
     S' + CONVERT(VARCHAR, @Study_id) + '.Population Y, 
     dbo.SamplePop SP, 
     dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, 
     dbo.MailingStep MS
    WHERE Y. Pop_id = SP.Pop_id
     AND SP.SamplePop_id = SchM.SamplePop_id
     AND SchM.ScheduledMailing_id = SM.ScheduledMailing_id
     AND SchM.MailingStep_id = MS.MailingStep_id
     AND ' + @strHousehold_Join + '
     AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
     AND Y.Age < 18
     AND X.intMinorException <> 1
     AND X.intRemove <> 1
     AND MS.bitThankYouItem = 0 
    GROUP BY ' + @strHouseholdField_Select
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1k) Insert into #Minor_Exclude anybody who has the same Household fields and 
  mailing date in #Max_MailingDate and where the mailing date is less than 
  m_lngReSurveyEx_Period from today. */
 SELECT @strSQL = 
  'INSERT INTO #Minor_Exclude
   SELECT X.Pop_id, ' + @strHouseholdField_Select + ', 0
   FROM S' + CONVERT(VARCHAR, @Study_id) + '.POPULATION X, #Max_MailingDate Y, dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, dbo.SentMailing SM
   WHERE ' + @strHousehold_Join + '
    AND X.Pop_id = SP.Pop_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.ScheduledMailing_id = SM.ScheduledMailing_id
    AND SM.datMailed = Y.datMailed
    AND DATEDIFF(day, Y.datMailed, GETDATE()) < ' + CONVERT(VARCHAR, @lngReSurveyEx_Period)
 --PRINT @strSQL
 EXECUTE (@strSQL)
 
 /* (a1m) Mark anybody from #Minor_Exclude that meets the Minor Exception Rule and is 
  not already excluded. */
 IF @strMinorException_Where IS NOT NULL
 BEGIN
  SELECT @strSQL = 
   'UPDATE #Minor_Exclude
    SET intMinorException = 1
    FROM #Minor_Exclude ME, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
    WHERE ME.Pop_id = BV.POPULATIONPop_id
     AND ' + @strMinorException_Where + '
     AND intMinorException <> 1'
  --PRINT @strSQL
  EXECUTE (@strSQL)
 END
 /* (a1n) Update the "intRemove" field to 1 on any minor in the #Minor_Universe that has 
  the same household fields as someone in #Minor_Exclude and is not already remed */
 SELECT @strSQL = 
  'UPDATE #Minor_Universe
   SET intRemove = 1
   FROM #Minor_Universe X, #Minor_Exclude Y
   WHERE ' + @strHousehold_Join + '
    AND X.intMinorException <> 1
    AND X.intRemove <> 1
    AND Y.intMinorException <> 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
/**************************************************************************************
 (a2) Compare Householding of Minors in the Universe among themselves 
**************************************************************************************/
 /* (a2b) Insert the Household fields (m_strHouseholdField_Select) of any duplicate 
  Household fields from #Minor_Universe  (ignoring those with "intRemove" = 1 
  and "intMinorException" = 1) into #Household_Dups. */
 SELECT @strSQL = 
  'INSERT INTO #Household_Dups
   SELECT ' + @strHouseholdField_Select + '
    FROM #Minor_Universe X
    WHERE intRemove <> 1
     AND intMinorException <> 1
    GROUP BY ' + @strHouseholdField_Select + '
    HAVING COUNT(*) > 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a2c) Assign a random number ("numRandom") to all people in #Minor_Universe that 
  matches the Household fields in #Household_Dups (excluding those with "intRemove" = 1 
  and "intMinorException" = 1). 
 */
 /* flagging the dupped records in #Minor_Universe in order to randomize them */
 SELECT @strSQL = 
  'UPDATE X
   SET intShouldBeRand = 1
   FROM #Minor_Universe X, #Household_Dups Y
   WHERE intRemove <> 1
    AND intMinorException <> 1
    AND ' + @strHousehold_Join
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /*Assign a Random number to each duped record of the #Minor_Universe */

 INSERT INTO #Random_Pop 
 SELECT Pop_id, numrandom
 FROM #Minor_Universe dp, random_numbers rn
 WHERE intShouldBeRand = 1 and 
	((dp.id_num+@Seed)%1000000)=rn.random_id
 ORDER BY numrandom
 
 /* (a2f) Set "intRemove" = 0 on #Minor_Universe the records that match the 
  "numRandom" values in #Minor_Keep. */
 SELECT @strSQL =  
	'UPDATE #Minor_Universe
  SET intRemove = 0
  FROM #Minor_Universe MU, (
		SELECT ' + @strHouseholdField_Select + ', MIN(Y.id_num) as id_num
    	FROM #Minor_Universe X, #Random_Pop Y
    	WHERE numRandom IS NOT NULL
     		AND X.Pop_id = Y.Pop_id
    	GROUP BY ' + @strHouseholdField_Select +' ) MK, #Random_Pop RP
  WHERE MU.Pop_id = RP.Pop_id
   AND RP.id_num = MK.id_num'

 EXECUTE (@strSQL)
 /* (a2g) Update "intRemove" = 1 where "intRemove" <> 0 and "numRandom" IS NOT NULL 
  in #Minor_Universe. */
 UPDATE #Minor_Universe
  SET intRemove = 1
  WHERE intShouldBeRand IS NOT NULL
   AND intRemove <> 0
 /* (a2h) Update the "strRemove_Rule" field on #SampleUnit_Universe = "H" on anybody  in 
  #Minor_Universe with "intRemove" = 1. */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = @HHRemoveRule 
  FROM #SampleUnit_Universe U, #Minor_Universe MU
  WHERE U. Pop_id = MU.Pop_id
   AND MU.intRemove = 1
 /* drop temp tables */
 --DROP TABLE #Minor_Keep
 DROP TABLE #Random_Pop



  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  

GO 
-----------------------------------------------------------------------------------------------
GO 
--Drop the old version of Householding Minor
--Drop Procedure sp_Samp_HouseHoldingMinor

GO 
-----------------------------------------------------------------------------------------------
GO 

/***********************************************************************************************************************************
SP Name: sp_Samp_Populate_Sampleunit_Universe 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 03/01/2004
Author(s): DC
Revision: First build - 03/01/2004
	03/09/2006 DC -ADDed code to handle the resurveyDate field
***********************************************************************************************************************************/
ALTER                PROCEDURE [dbo].[sp_Samp_Populate_Sampleunit_Universe] 
	@Study Integer,
    @Survey Integer,
    @DataSet VarChar(255), 
    @Pop_Enc VarChar(200),
    @Bigview_join VarChar(200), 
    @HH_Field VarChar(200) = null
AS
DECLARE @strInsert VarChar(8000), @EncounterDateField varchar(42), @sql varchar(8000),
		@EncTable bit,@sampleplan_id int

Insert into #Timer (PostSampleStart) values (getdate()) 

/* make sure sampleunitTreeIndex is populated*/
Select @sampleplan_id=sampleplan_id
from sampleplan
where survey_id=@Survey

execute SP_SAMP_AddTreeIndex @sampleplan_id


IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@Study AND strTable_nm='Encounter')>0
SELECT @EncTable=1
ELSE 
SELECT @EncTable=0

CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))

SET @SQL = 'INSERT INTO #DATEFIELD' +
   ' SELECT mt.strTable_nm + mf.strField_nm' +
   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
   ' WHERE sd.Study_id = mt.Study_id' +
   ' AND ms.Table_id = mt.Table_id' +
   ' AND ms.Field_id = mf.Field_id' +
   ' AND ms.table_id=sd.cutofftable_id' +
   ' AND ms.field_id=sd.cutofffield_id' +
   ' AND mf.strFieldDataType = ''D''' +
   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey)

Execute (@sql)

SELECT @EncounterDateField=DATEFIELD
FROM #DATEFIELD

IF @EncounterDateField is null and @encTable=0 Set @EncounterDateField='populationNewRecordDate'
	ELSE IF @EncounterDateField is null and @encTable=1 Set @EncounterDateField='encounterNewRecordDate'
DROP TABLE #DATEFIELD


SET @strInsert = 'INSERT INTO #SampleUnit_Universe 
SELECT DISTINCT SampleUnit_id, ' +
@Pop_Enc + ', ' 

IF @HH_Field is not null SET @strInsert = @strInsert + @HH_Field + ', '

SET @strInsert = @strInsert + ' POPULATIONAge, DQ_ID, '+
'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', ' +  @EncounterDateField + ', Null ' +
'FROM #PreSample X, S' +CONVERT(VARCHAR,@Study)+ '.Big_View BV ' +
'WHERE ' + @Bigview_join 

Set @strInsert=@strInsert + ' ORDER BY SampleUnit_id, ' + @Pop_Enc 

EXECUTE (@strInsert)

EXECUTE dbo.sp_Samp_IdentifyDataSets @DataSet

GO 
-----------------------------------------------------------------------------------------------
GO 
/***********************************************************************************************************************************
SP Name: sp_Samp_CreateTempTables
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:    
Date         By			Description
-------------------------------------------
09-08-1999   DA, RC		Created
02-29-2000   Dave Gilsdorf	v2.0.1 Removed white-space from most of the @SQL values
12-17-2002   Hui Holay		Added the condition to check if temp tables exist and
  				delete them before creating new ones.
02-05-2004   DC Added Identity column to #sampleunit_universe
05-18-2004   DC Added code to ALTER  the presample table
03/09/2006   DC Added resurveyDate column #sampleunit_universe
***********************************************************************************************************************************/
ALTER          PROCEDURE [dbo].[sp_Samp_CreateTempTables]
 @vcPop_Enc_CreateTable varchar(8000),
 @vcHH_Field_CreateTable varchar(8000) = NULL
AS
	--Delete from dc_temp_timer
	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_CreateTempTables', getdate())

 DECLARE @SQL varchar (8000)
 CREATE TABLE #CreateStatements
  (SQLStatement VARCHAR(8000))
 /*Creating temp tables used for sampling.   
 The Removed_Rule column tracks which rule eliminated a record from the universe:
  1- Resurvey Exclusion rule
  2- New born rule
  3- TOCL rule
  4- DQ Rules
  5- De-Dupe Sample Unit Universe
  6- Minor Householding
  7- Adult Householding
  8- Secondary Sampling Removal (Removed only from "DIRECT" sampling)
 */
 /* Create the statement for Universe Table creation */

 /*IF (ISNULL(OBJECT_ID('tempdb..#universe'),0) <> 0) 
  BEGIN
   DROP TABLE #Universe
  END  

 SELECT @SQL = 'CREATE TABLE #Universe '+ 
    '(' + @vcPop_Enc_CreateTable + ', '+
    'Removed_Rule TINYINT DEFAULT 0, '+
    'numRandom float(24))'
 
 INSERT INTO #CreateStatements
  VALUES (@SQL)*/

/* Create the statement for Presample Table creation */
 SELECT @SQL = 'CREATE TABLE #PreSample ('+
    	@vcPop_Enc_CreateTable + ', ' +
		'SampleUnit_id 	INT NOT NULL,'+
		'DQ_id			INT)'
  INSERT INTO #CreateStatements
  VALUES (@SQL)   
 
 /* Create the statement for SampleUnit_Universe Table creation */
 SELECT @SQL = 'CREATE TABLE #SampleUnit_Universe '+
    '(id_num int IDENTITY, SampleUnit_id int, '
     + @vcPop_Enc_CreateTable + ', '
 IF @vcHH_Field_CreateTable IS NOT NULL 
  SET @SQL = @SQL + @vcHH_Field_CreateTable  +  ', ' 
 SET @SQL = @SQL +  'Age int, DQ_Bus_Rule int, Removed_Rule TINYINT DEFAULT 0, strUnitSelectType varchar(1), EncDate datetime, ReSurveyDate DATETIME)'
 
 INSERT INTO #CreateStatements
  VALUES (@SQL)
 /* Create the statement for DataSet Table creation */
 SELECT @SQL = 'CREATE TABLE #DataSet (DataSet_id int)'
 
 INSERT INTO #CreateStatements
  VALUES (@SQL)

 /* Create the Timer Tables*/
 SELECT @SQL = 'CREATE TABLE #Timer (PreSampleStart datetime, PreSampleEnd datetime, PostSampleStart datetime, PostSampleEnd datetime)'
 
 INSERT INTO #CreateStatements
  VALUES (@SQL)

 /*Create the Child Sample Temp Table*/
 SET @SQL = 'CREATE TABLE #DD_Dups (' + @vcPop_Enc_CreateTable + ')'
 
 INSERT INTO #CreateStatements
  VALUES (@SQL)
 /*Create the Child Sample Temp Table*/
 SET @SQL = 'CREATE TABLE #DD_ChildSample (CS_ID int IDENTITY, SampleUnit_id int, '
     + @vcPop_Enc_CreateTable + ', numRandom float(24), bitKeep bit)'
 
 INSERT INTO #CreateStatements
  VALUES (@SQL)
 IF @vcHH_Field_CreateTable IS NOT NULL
 BEGIN
  /* (b1b) Create the #Max_MailingDate */
  SET @SQL = 'CREATE TABLE #Max_MailingDate ('
      + @vcHH_Field_CreateTable + ', datMailed DATETIME) '
  
  INSERT INTO #CreateStatements
   VALUES (@SQL)
 
  /* (b2a) Create the #HH_Dup_Fields Table. */
  SET @SQL =  'CREATE TABLE #HH_Dup_Fields (' + @vcHH_Field_CreateTable + ')'
 
  INSERT INTO #CreateStatements
   VALUES (@SQL)
 
  /* (b2c) Create the #HH_Dup_People Table. */
  SET @SQL =  'CREATE TABLE #HH_Dup_People (id_num int identity, Pop_id INT, ' + @vcHH_Field_CreateTable + ', bitKeep BIT)'
 
  INSERT INTO #CreateStatements
   VALUES (@SQL)
 
  /* (a1a) Create the #Minor_Universe table. - Will be in MTS component */
  SET @SQL =  'CREATE TABLE #Minor_Universe
     (id_num int identity, '+
	  'Pop_id INT, '+
      + @vcHH_Field_CreateTable + ', '+
     'intShouldBeRand TINYINT, '+
     'intRemove INT, '+
     'intMinorException INT)'
 
  INSERT INTO #CreateStatements
   VALUES (@SQL)
 

 
  /* (a1e) Create the #Minor_Exclude Table */
  SET @SQL =  'CREATE TABLE #Minor_Exclude '+
     '(Pop_id int, '+
      + @vcHH_Field_CreateTable + ', '+
     'intMinorException int)'
 
  INSERT INTO #CreateStatements
   VALUES (@SQL)
 
  /* (a2a) Create the table #Household_Dups. */
  SET @SQL =  'CREATE TABLE #Household_Dups '+
     '(' + @vcHH_Field_CreateTable + ')'
 
  INSERT INTO #CreateStatements
   VALUES (@SQL)

 END
 
 /* Sends the statements creating the temporary tables to the middle-tier */
 SELECT *
  FROM #CreateStatements

 DROP TABLE #CreateStatements


GO 
-----------------------------------------------------------------------------------------------
GO 


/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns a single
dataset representing field that exists for the specified table and field d

Created:  3/10/2006 by DC

Modified:
*/    
CREATE PROCEDURE [dbo].[QCL_SelectStudyTableColumn]  
@TableId INT,  
@FieldId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
 SELECT Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
     intFieldLength, bitUserField_FLG
 FROM MetaData_View  
 WHERE Table_id=@TableId  
 AND Field_id=@FieldID
 
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   
GO 
-----------------------------------------------------------------------------------------------
GO 



/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     dataset representing the study data tables for the tableId 	 */
/*                       										 */  
/* Date Created:  3/10/2006                 								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE [dbo].[QCL_SelectStudyTable]
@TableId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Table_id, strTable_nm, strTable_dsc, Study_id, 0 IsView
FROM MetaTable
WHERE Table_id = @TableId


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteriaInListByCriteriaClauseID]
@CRITERIACLAUSE_ID INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT CRITERIAINLIST_ID, CRITERIACLAUSE_ID, STRLISTVALUE
FROM CRITERIAINLIST
WHERE CRITERIACLAUSE_ID=@CRITERIACLAUSE_ID

GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteriaClauseByStatementANDPhraseID]
@CriteriaStatement_Id INT,
@CriteriaPhrase_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT CRITERIACLAUSE_ID, CRITERIAPHRASE_ID, CRITERIASTMT_ID, TABLE_ID, FIELD_ID, INTOPERATOR, STRLOWVALUE, STRHIGHVALUE
FROM CriteriaClause
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id
	AND CriteriaPhrase_Id=@CriteriaPhrase_Id


GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteriaPhraseByCriteriaStatementID]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  DISTINCT CRITERIASTMT_ID, CriteriaPhrase_Id
FROM CriteriaClause
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


GO 
-----------------------------------------------------------------------------------------------
GO 



/*
Business Purpose: 

This procedure is used to get information about a Criteria Statement.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteria]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  CriteriaStmt_Id, STUDY_ID, STRCRITERIASTMT_NM, strCriteriaString
FROM CRITERIASTMT
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


GO 
-----------------------------------------------------------------------------------------------
GO 


/*
Business Purpose: 

This procedure is used to Delete All the criteria Phrases  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteCriteriaPhrases]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DELETE ci
FROM CRITERIAInList ci, criteriaClause cp
WHERE cp.CRITERIASTMT_ID=@CriteriaStatement_Id
	AND ci.criteriaClause_id=cp.criteriaClause_Id

DELETE criteriaClause
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id



GO 
-----------------------------------------------------------------------------------------------
GO 



/*
Business Purpose: 

This procedure is used to Delete a criteria  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteCriteria]
@CriteriaStatement_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

EXEC QCL_DeleteCriteriaPhrases @CriteriaStatement_Id

DELETE criteriaStmt
WHERE CRITERIASTMT_ID=@CriteriaStatement_Id


GO 
-----------------------------------------------------------------------------------------------
GO 

  /*
Business Purpose: 

This procedure is used to Insert a record into Criteria Statement 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertCriteria]
@study_Id INT,
@STRCRITERIASTMT_NM varchar(42),
@strCriteriaString text
AS

INSERT INTO CriteriaStmt (STUDY_ID, STRCRITERIASTMT_NM, strCriteriaString)
VALUES (@study_Id, @STRCRITERIASTMT_NM, @strCriteriaString)

SELECT SCOPE_IDENTITY() as criteriastmt_id



GO 
-----------------------------------------------------------------------------------------------
GO 


/*
Business Purpose: 

This procedure is used to Insert a record into CriteriaClause Table 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertCriteriaClause]
@criteriaStatementId Int, 
@criteriaPhraseId Int, 
@tableId Int, 
@fieldId Int, 
@operator Int, 
@lowValue varchar(42), 
@highValue varchar(42)
AS

INSERT INTO CriteriaClause (CRITERIAPHRASE_ID, CRITERIASTMT_ID, TABLE_ID, FIELD_ID, INTOPERATOR, STRLOWVALUE, STRHIGHVALUE)
VALUES (@criteriaPhraseId, @criteriaStatementId, @tableId, @fieldId, @operator, @lowValue, @highValue)

SELECT SCOPE_IDENTITY() as criteriaClause_id
GO 
-----------------------------------------------------------------------------------------------
GO 
/*
Business Purpose: 

This procedure is used to Insert a record into CriteriaInList Table 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertCriteriaInValue]
@criteriaClauseId Int, 
@Value varchar(42)
AS

INSERT INTO CriteriaInList (CRITERIACLAUSE_ID, STRLISTVALUE)
VALUES (@criteriaClauseId, @Value)

SELECT SCOPE_IDENTITY() as CRITERIAINLIST_ID

GO 
-----------------------------------------------------------------------------------------------
GO 


/*
Business Purpose: 

This procedure is used to Update a record in Criteria Statement 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_UpdateCriteria]
@criteriaStmt_id INT,
@STRCRITERIASTMT_NM varchar(42),
@strCriteriaString text
AS

UPDATE CriteriaStmt 
SET STRCRITERIASTMT_NM=@STRCRITERIASTMT_NM, 
	strCriteriaString=@strCriteriaString
WHERE criteriaStmt_id=@criteriaStmt_id
GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to Insert a record into Busines Rule 

Created:  03/13/2006 by Dan Christensen

Modified:

*/
CREATE  PROCEDURE [dbo].[QCL_InsertBusinessRule]
@study_Id INT,
@survey_Id int,
@CRITERIASTMT_Id int,
@BusRule_CD char(1)
AS

INSERT INTO BusinessRule (Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD)
VALUES (@survey_Id, @study_Id, @CRITERIASTMT_Id,@BusRule_CD)

SELECT SCOPE_IDENTITY() as businessRule_id


GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to get information about a Business Rule   

Created:  03/13/2006 by Dan Christensen

Modified:

*/
Create PROCEDURE [dbo].[QCL_SelectBusinessRule]
@BusinessRule_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  BusinessRule_Id, Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD
FROM BusinessRule
WHERE BusinessRule_Id=@BusinessRule_Id


GO 
-----------------------------------------------------------------------------------------------
GO 


/*
Business Purpose: 

This procedure is used to Delete a BusinessRule  

Created:  03/13/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteBusinessRule]
@BusinessRule_Id INT
AS

DELETE BusinessRule
WHERE BusinessRule_ID=@BusinessRule_Id


GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns a single
dataset representing fields that exist in the specifed study data table

Created:  10/17/2005 by Joe Camp

Modified:
01/25/2006 by Joe Camp - Added Field_id to returnset
02/27/2006 by Brian Dohmen - Added bitUserField_FLG to returnset
03/13/2006 by Dan Christensen - Added table_id to returnset
*/    
ALTER PROCEDURE [dbo].[QCL_SelectStudyTableColumns]  
@StudyId INT,  
@TableId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
IF @TableId=0  
BEGIN  
--  SELECT NULL Field_id, Column_Name strField_nm,   
--                 CASE Data_Type WHEN 'varchar' THEN 'S'   
--                                WHEN 'int' THEN 'I'   
--                                WHEN 'datetime' THEN 'D'   
--                                END strFieldDataType,   
--                 0 bitKeyField_Flg, '' strField_Dsc, Character_Maximum_Length intFieldLength  
--  FROM Information_Schema.Columns  
--  WHERE Table_Schema='s'+CONVERT(VARCHAR,@StudyId)  
--  AND Table_Name='Big_View'  
--  ORDER BY Column_Name  

 SELECT NULL Table_id, NULL Field_id, strTable_nm+strField_nm strField_nm, strFieldDataType, 
     bitKeyField_FLG, strField_DSC, intFieldLength, bitUserField_FLG
 FROM MetaData_View
 WHERE Study_id=@StudyId
 ORDER BY strTable_nm+strField_nm

END  
ELSE  
BEGIN  
 SELECT Table_id, Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
     intFieldLength, bitUserField_FLG
 FROM MetaData_View  
 WHERE Study_id=@StudyId  
 AND Table_id=@TableId  
 ORDER BY bitKeyField_FLG DESC, strField_nm  
END  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


GO 
-----------------------------------------------------------------------------------------------
GO 


/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns a single
dataset representing field that exists for the specified table and field d

Created:  3/10/2006 by DC

Modified:
03/13/2006 by Dan Christensen - Added table_id to returnset
*/    
ALTER PROCEDURE [dbo].[QCL_SelectStudyTableColumn]  
@TableId INT,  
@FieldId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
 SELECT Table_id, Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
     intFieldLength, bitUserField_FLG
 FROM MetaData_View  
 WHERE Table_id=@TableId  
 AND Field_id=@FieldID
 
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   


GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to get information about all Business Rules for a survey  

Created:  03/13/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectBusinessRulesBySurveyId]
@survey_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  BusinessRule_Id, Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD
FROM BusinessRule
WHERE Survey_ID=@survey_Id
GO 
-----------------------------------------------------------------------------------------------
GO 
/*
Business Purpose: 

This procedure is used to Select existing HouseHolding Field records for a survey

Created:  03/14/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectHouseHoldingFieldsBySurveyId]
@survey_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

 SELECT MV.Table_id, MV.Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
     intFieldLength, bitUserField_FLG
 FROM MetaData_View MV, HOUSEHOLDRULE HH
 WHERE HH.survey_Id=@survey_Id  
	AND MV.table_id=HH.Table_Id 
	AND MV.field_id=HH.field_id 
 ORDER BY bitKeyField_FLG DESC, strField_nm  
GO 
-----------------------------------------------------------------------------------------------
GO 

/*
Business Purpose: 

This procedure is used to add a new HouseHolding Fields record for a survey

Created:  03/14/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertHouseHoldingField]
@survey_Id INT,
@table_id INT,
@field_id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

Insert HOUSEHOLDRULE (survey_id, table_id, field_id) VALUES (@survey_Id,@table_id,@field_id)

GO 
-----------------------------------------------------------------------------------------------
GO 

   /*
Business Purpose: 

This procedure is used to delete all HouseHolding Fields for a Survey

Created:  03/14/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteHouseHoldingFieldsBySurveyId]
@survey_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DELETE HOUSEHOLDRULE
WHERE Survey_ID=@survey_Id
GO 
-----------------------------------------------------------------------------------------------
GO
/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It will return all facility regions.
    
Created: 3/14/2006 by DC
    
Modified:    
		

*/        
CREATE PROCEDURE [dbo].[QCL_SelectAllFacilityRegions]
AS

SELECT region_id, strRegion_nm
FROM Region 
ORDER BY strRegion_nm 

GO 
-----------------------------------------------------------------------------------------------
GO

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.
    
Created: 3/14/2006 by DC
    
Modified:    
		

*/        
CREATE PROCEDURE [dbo].[QCL_SelectFacility]
@SUFacility_id INT
AS

SELECT SUFacility_id, Client_id, strFacility_nm, City, State, Country, Region_id, AdmitNumber, BedSize, bitPeds, bitTeaching,
	bitTrauma, bitReligious, bitGovernment, bitRural, bitForProfit, bitRehab, bitCancerCenter, bitPicker, bitFreeStanding, AHA_id
FROM SUFacility 
WHERE SUFacility_id = @SUFacility_id

GO 
-----------------------------------------------------------------------------------------------
GO


/*      
Business Purpose:       
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.  
      
Created: 3/14/2006 by DC  
      
Modified:      
    
  
*/          
CREATE PROCEDURE [dbo].[QCL_SelectFacilityByClientId]    
@client_id INT    
AS    
  
SELECT SUFacility_id, Client_id, strFacility_nm, City, State, Country,   
  Region_id, AdmitNumber, BedSize, bitPeds, bitTeaching, bitTrauma,   
  bitReligious, bitGovernment, bitRural, bitForProfit, bitRehab,   
  bitCancerCenter, bitPicker, bitFreeStanding, AHA_id    
FROM SUFacility     
WHERE ISNULL(Client_id,-999) = ISNULL(@Client_Id,-999)  
ORDER BY strFacility_nm, AHA_id

GO 
-----------------------------------------------------------------------------------------------
GO

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It will return all facilities for an AHAId.
    
Created: 3/14/2006 by DC
    
Modified:    
		

*/        
CREATE PROCEDURE [dbo].[QCL_SelectFacilityByAHAId]
@AHA_ID INT
AS

SELECT SUFacility_id, Client_id, strFacility_nm, City, State, Country, Region_id, AdmitNumber, BedSize, bitPeds, bitTeaching,
	bitTrauma, bitReligious, bitGovernment, bitRural, bitForProfit, bitRehab, bitCancerCenter, bitPicker, bitFreeStanding, AHA_id
FROM SUFacility 
WHERE AHA_id = @AHA_id
GO 
-----------------------------------------------------------------------------------------------
GO
INSERT INTO SamplingAlgorithm (AlgorithmName) VALUES ('StaticPlus')
GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_DeleteFacility
@FacilityId INT
AS


IF EXISTS (SELECT * FROM SampleUnit WHERE SUFacility_id = @FacilityId)
BEGIN
	RAISERROR ('The facility cannot be deleted because there are still sample units associated with it.', 18, 1)
END
ELSE
BEGIN
	DELETE SUFacility
	WHERE SUFacility_id = @FacilityId
END
GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_AllowDeleteFacility
@FacilityId INT
AS

--Return 1 if facility can be deleted otherwise return 0
IF EXISTS (SELECT * FROM SampleUnit WHERE SUFacility_id = @FacilityId)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	SELECT 1
END
GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_InsertFacility
@Client_id INT,
@AHA_id INT,
@strFacility_nm VARCHAR(100),
@City VARCHAR(42),
@State VARCHAR(2),
@Country VARCHAR(42),
@Region_id INT,
@AdmitNumber INT,
@BedSize INT,
@bitPeds BIT,
@bitTeaching BIT,
@bitTrauma BIT,
@bitReligious BIT,
@bitGovernment BIT,
@bitRural BIT,
@bitForProfit BIT,
@bitRehab BIT,
@bitCancerCenter BIT,
@bitPicker BIT,
@bitFreeStanding BIT
AS

INSERT INTO SUFacility(Client_id, AHA_id, strFacility_nm, City, State, Country,   
  Region_id, AdmitNumber, BedSize, bitPeds, bitTeaching, bitTrauma,   
  bitReligious, bitGovernment, bitRural, bitForProfit, bitRehab,   
  bitCancerCenter, bitPicker, bitFreeStanding)
VALUES (@Client_id, @AHA_id, @strFacility_nm, @City, @State, @Country,   
  @Region_id, @AdmitNumber, @BedSize, @bitPeds, @bitTeaching, @bitTrauma,   
  @bitReligious, @bitGovernment, @bitRural, @bitForProfit, @bitRehab,   
  @bitCancerCenter, @bitPicker, @bitFreeStanding)

SELECT SCOPE_IDENTITY()

GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_UpdateFacility
@Facility_id INT,
@Client_id INT,
@AHA_id INT,
@strFacility_nm VARCHAR(100),
@City VARCHAR(42),
@State VARCHAR(2),
@Country VARCHAR(42),
@Region_id INT,
@AdmitNumber INT,
@BedSize INT,
@bitPeds BIT,
@bitTeaching BIT,
@bitTrauma BIT,
@bitReligious BIT,
@bitGovernment BIT,
@bitRural BIT,
@bitForProfit BIT,
@bitRehab BIT,
@bitCancerCenter BIT,
@bitPicker BIT,
@bitFreeStanding BIT
AS

UPDATE SUFacility 
	SET Client_id = @Client_id, 
	AHA_id = @AHA_id, 
	strFacility_nm = @strFacility_nm, 
	City = @City, 
	State = @State, 
	Country = @Country,   
	Region_id = @Region_id, 
	AdmitNumber = @AdmitNumber, 
	BedSize = @BedSize, 
	bitPeds = @bitPeds, 
	bitTeaching = @bitTeaching, 
	bitTrauma = @bitTrauma,
	bitReligious = @bitReligious, 
	bitGovernment = @bitGovernment, 
	bitRural = @bitRural, 
	bitForProfit = @bitForProfit, 
	bitRehab = @bitRehab,
	bitCancerCenter = @bitCancerCenter, 
	bitPicker = @bitPicker, 
	bitFreeStanding = @bitFreeStanding
WHERE SUFacility_id = @Facility_id
GO 
-----------------------------------------------------------------------------------------------
GO
drop procedure sp_Add_default_DQRules
drop procedure sp_DQ_CriteriaStmt
drop procedure sp_DQ_BusRule
drop procedure sp_DQ_CriteriaClause
drop procedure sp_DQ_INList
GO 
-----------------------------------------------------------------------------------------------
GO
/****** Object:  Stored Procedure dbo.sp_DQ_CriteriaClause    Script Date: 6/9/99 4:36:39 PM ******/
/******		Modified 6/2/3 BD Changed @@Identity to Scope_Identity().                    ******/
CREATE PROCEDURE [dbo].[QCL_InsertDefaultCriteriaClause] 
 @CriteriaPhrase_id int, 
 @CriteriaStmt_id int, 
 @Table_id int, 
 @Field_str varchar(32), 
 @Operator varchar(20), 
 @LowValue varchar(20),
 @HighValue varchar(20),
 @CriteriaClause_id int OUTPUT
AS
 DECLARE @field_id int, @operator_num int
 SELECT @field_id = mf.Field_id
 FROM dbo.metafield mf
 WHERE mf.strfield_nm = @Field_Str
 SELECT @operator_num = Operator_Num
 FROM dbo.operator
 WHERE strOperator = @Operator
 BEGIN TRANSACTION
 INSERT INTO CriteriaClause(criteriaphrase_id, criteriastmt_id, table_id, field_id, intoperator, strlowvalue, strhighvalue)
 VALUES(@CriteriaPhrase_id, @CriteriaStmt_id, @Table_id, @Field_id, @Operator_Num, @LowValue, @HighValue)
-- SELECT @CriteriaClause_id = @@IDENTITY
 SELECT @CriteriaClause_id = SCOPE_IDENTITY()
 COMMIT TRANSACTION
GO 
-----------------------------------------------------------------------------------------------
GO
/****** Object:  Stored Procedure dbo.sp_DQ_CriteriaStmt    Script Date: 6/9/99 4:36:39 PM ******/
/******		Modified 6/2/3 BD Changed @@Identity to Scope_Identity().                  ******/
/**    Modified: 5/06/2004 - Dan Christensen - Added strcriteriastring  */
CREATE  PROCEDURE [dbo].[QCL_InsertCriteriaStmt]
 @Study_id int, 
 @CriteriaStmt_nm CHAR(8),
 @strcriteriaString varchar(8000),
 @CriteriaStmt_id INT OUTPUT
AS
 DECLARE @a VARCHAR(20)
 BEGIN TRANSACTION
 INSERT INTO CriteriaStmt (study_id, strcriteriastmt_nm, strCriteriaString)
 VALUES (@Study_id, @CriteriaStmt_nm, @strcriteriaString)
-- SELECT @CriteriaStmt_id = @@IDENTITY
 SELECT @CriteriaStmt_id = SCOPE_IDENTITY()
 COMMIT TRANSACTION
 
GO 
-----------------------------------------------------------------------------------------------
GO

/*********************************************************************************************************************************
  **	Copyright (c) National Research Corporation							
  **	Stored Procedure:  dbo.QCL_InsertDefaultDQRules
  **	Description:  Called by ConfigManagerUI.vbp, this SP calls dbo.QCL_InsertCriteriaStmt, 
  **		dbo.QCL_InsertBusinessRule, and dbo.QCL_InsertDefaultCriteriaClause to add the standard disqualification 
  **		criteria to a Survey.
  **
  **	Modified: 9/7/1999 - Daniel Vansteenburg - Added check to make sure the Field exists 
  **		before adding DQ rule.
  **	Modified: 4/23/2001 - Brian Dohmen - Added null langid DQ rule.
  **    Modified: 9/09/2002 - Ron Niewohner - Added null MRN DQ rule.
  **    Modified: 7/14/2003 - Brian Dohmen - Added additional address DQ rules
  **    Modified: 5/06/2004 - Dan Christensen - Added strcriteriastring 
  **    Modified: 6/03/2005 - Brian Dohmen - Added Address Error 420 rule
  **    Modified: 9/14/2005 - Brian Dohmen - Added Province and Postal_Code errors for Canada
  **********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[QCL_InsertDefaultDQRules]
	@Survey_id INT
AS
	DECLARE @Study_id INT
	DECLARE @Table_id INT
	DECLARE @Country_id INT
	DECLARE @CriteriaStmt_id INT	
	DECLARE @CriteriaClause_id INT
	DECLARE @Owner VARCHAR(32)

/*Get the Study_id for this Survey*/
	SELECT @Study_id=Study_id
	FROM dbo.Survey_def
	WHERE Survey_id=@Survey_id
	IF @Study_id IS NULL
		RETURN

/*Get the Country_id from the QualPro_Params*/
	SELECT @Country_id=numParam_Value 
	FROM QualPro_Params
	WHERE strParam_nm='Country'

/*Get POPULATION's Table_id*/
	SELECT @Table_id=mt.Table_id	
	FROM dbo.MetaTable mt
	WHERE mt.strTable_nm='POPULATION'
	AND mt.Study_id=@Study_id
	IF @Table_id IS NULL
	BEGIN
		RAISERROR ('No Population Table defined for Survey %s', 16, 1, @Survey_id)
		RETURN
	END

/*Add LName Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='LNAME')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_L Nm', '((POPULATIONLName IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'LNAME', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add FName Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='FNAME')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_F Nm', '((POPULATIONFName IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'FNAME', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add Addr Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='ADDR')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Addr', '((POPULATIONADDR IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDR', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add City Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='CITY')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_City', '((POPULATIONCITY IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'CITY', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

	/*American Address Rules*/
	IF @Country_id=1
	BEGIN
	
	/*Add ST Rule, Operator 9 */
		IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
				AND Study_id=@Study_id
				AND strField_nm='ST')
		BEGIN
			EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_ST', '((POPULATIONST IS NULL))', @CriteriaStmt_id OUTPUT
			EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
			EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ST', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
		END
	
	/*Add Zip5 Rule, Operator 9 */
		IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
				AND Study_id=@Study_id
				AND strField_nm='ZIP5')
		BEGIN
			EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Zip5', '((POPULATIONZIP5 IS NULL))', @CriteriaStmt_id OUTPUT
			EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
			EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ZIP5', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
		END
	
	END
	
	/*American Address Rules*/
	IF @Country_id=2
	BEGIN
	
	/*Add Province Rule, Operator 9 */
		IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
				AND Study_id=@Study_id
				AND strField_nm='Province')
		BEGIN
			EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PROV', '((POPULATIONProvince IS NULL))', @CriteriaStmt_id OUTPUT
			EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
			EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'Province', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
		END
	
	/*Add Postal_Code Rule, Operator 9 */
		IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
				AND Study_id=@Study_id
				AND strField_nm='Postal_Code')
		BEGIN
			EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PstCd', '((POPULATIONZIPostal_Code IS NULL))', @CriteriaStmt_id OUTPUT
			EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
			EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'Postal_Code', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
		END
	
	END

/*Add DOB Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='DOB')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_DOB', '((POPULATIONDOB IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'DOB', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add AGE Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='AGE')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_AGE', '((POPULATIONAge IS NULL) OR (POPULATIONAGE < 0))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'AGE', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
		EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @Table_id, 'AGE', '<', '0', '', @CriteriaClause_id OUTPUT
	END

/*Add SEX Rule, Operator 2 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='SEX')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_SEX','((POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'SEX', '<>', 'M', '', @CriteriaClause_id OUTPUT
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'SEX', '<>', 'F', '', @CriteriaClause_id OUTPUT
		EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @Table_id, 'SEX', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add AddrErr Rule, Operator 7 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='ADDRERR')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_AddEr','((POPULATIONAddrErr IN ("E101","E212","E213","E214","E216","E302","E421","E422","E423","E425","E427","E428","E429","E432","E433","E434","E435","E436","E437","E450","E451","E452","E453","E502","E600")))'
				, @CriteriaStmt_id OUTPUT 
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDRERR', 'IN', '', '', @CriteriaClause_id OUTPUT
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E101'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E212'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E213'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E214'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E216'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E302'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E421'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E422'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E423'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E425'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E427'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E428'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E429'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E432'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E433'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E434'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E435'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E436'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E437'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E450'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E451'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E452'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E453'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E502'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E600'
/* Old rules
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E101'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E212'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E213'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E214'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E216'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E302'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E421'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E422'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E423'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E425'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E427'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E428'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E429'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E502'
		EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'E600'
*/
	END

/*Add PhonStat Rule, Operator 2 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='PHONSTAT')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PHONSTAT','((POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'PHONSTAT', '<>', '0', '', @CriteriaClause_id OUTPUT
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'PHONSTAT', 'IS NOT', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add LangID Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='LangID')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_LangID','((POPULATIONLangID IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'LangID', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add MRN IS NULL Rule, Operator 9 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='MRN')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MRN','((POPULATIONMRN IS NULL))', @CriteriaStmt_id OUTPUT
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'MRN', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT
	END

/*Add E420 Address Error, Operator 1 */
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id 
			AND Study_id=@Study_id
			AND strField_nm='ADDRERR')
	BEGIN
		EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_AE420','(POPULATIONAddrErr="E420")', @CriteriaStmt_id OUTPUT 
		EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'
		EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDRERR', '=', 'E420', '', @CriteriaClause_id OUTPUT
	END

GO 
-----------------------------------------------------------------------------------------------
GO
/********************************************************************************************************/    
/*																										*/    
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns two		*/    
/* datasets.  The first is a list of all client names an employee has rights to.  The second			*/    
/* selects all of the study names and client_ids the employee has rights to.							*/    
/*																										*/    
/* Date Created:  10/11/2005																			*/    
/*																										*/    
/* Created by:  Brian Dohmen																			*/
/* Modified:																							*/
/* 02/16/2006 by DC - Added ADEmployee_id to Study.														*/
/********************************************************************************************************/    
ALTER PROCEDURE [dbo].[QCL_SelectClientsAndStudiesByUser]    
    @UserName VARCHAR(42),
	@ShowAllClients BIT = 0
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
--Need a temp table to hold the ids the user has rights to    
CREATE TABLE #EmpStudy (    
     Client_id INT,    
     Study_id INT,    
     strStudy_nm VARCHAR(10),    
     strStudy_dsc VARCHAR(255),  
  ADEmployee_id int   
)    
    
--Populate the temp table with the studies they have rights to.    
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id)    
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc, s.ADEmployee_id   
FROM Employee e, Study_Employee se, Study s    
WHERE e.strNTLogin_nm=@UserName    
AND e.Employee_id=se.Employee_id    
AND se.Study_id=s.Study_id    
AND s.datArchived IS NULL    
    
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)    
    
--First recordset.  List of clients they have rights to or all clients    
IF @ShowAllClients = 1
BEGIN
	SELECT c.Client_id, c.strClient_nm            
	FROM Client c
	ORDER BY c.strClient_nm            
END
ELSE
BEGIN
	SELECT c.Client_id, c.strClient_nm    
	FROM #EmpStudy t, Client c    
	WHERE t.Client_id=c.Client_id    
	GROUP BY c.Client_id, c.strClient_nm    
	ORDER BY c.strClient_nm    
END
    
--Second recordset.  List of studies they have rights to    
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id    
FROM #EmpStudy    
ORDER BY strStudy_nm    
    
--Cleanup temp table    
DROP TABLE #EmpStudy    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF    
GO 
-----------------------------------------------------------------------------------------------
GO
/*      
Business Purpose:       
      
This procedure is used to support the Qualisys Class Library.  It returns three      
datasets.  The first is a list of all client names an employee has rights to.  The second       
selects all of the study names and client_ids the employee has rights to.  The third selects        
all of the survey names and study_ids the employee has rights to.       
      
      
Created:  11/03/2005 by Joe Camp      
      
Modified:      
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection      
02/16/2006 by DC - Added bitValidated_flg to survey selection. Added ADEmployee_id to Study.       
02/23/2006 by DC - Added samplePlanId to survey selection      
02/24/2006 by DC - Added INTRESPONSE_RECALC_PERIOD to survey selection      
02/28/2006 by Brian Dohmen - Added Additional columns to survey selection      
03/01/2006 by Brian Dohmen - Changed to left join to sampleplan table  
03/17/2006 by Joe Camp - Changed to add ShowAllClients option
03/27/2006 by DC - Added strHouseholdingType to survey selection    
      
*/         
CREATE PROCEDURE [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]    
    @UserName VARCHAR(42),
	@ShowAllClients BIT = 0
AS            
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
SET NOCOUNT ON            
            
--Need a temp table to hold the ids the user has rights to            
CREATE TABLE #EmpStudy (            
     Client_id INT,            
     Study_id INT,            
     strStudy_nm VARCHAR(10),            
     strStudy_dsc VARCHAR(255),      
  ADEmployee_id int          
)            
            
--Populate the temp table with the studies they have rights to.            
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc,ADEmployee_id)            
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc,s.ADEmployee_id         
FROM Employee e, Study_Employee se, Study s            
WHERE e.strNTLogin_nm=@UserName            
AND e.Employee_id=se.Employee_id            
AND se.Study_id=s.Study_id            
AND s.datArchived IS NULL            
            
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)            
            
--First recordset.  List of clients they have rights to.            
IF @ShowAllClients = 1
BEGIN
	SELECT c.Client_id, c.strClient_nm            
	FROM Client c
	ORDER BY c.strClient_nm            
END
ELSE
BEGIN
	SELECT c.Client_id, c.strClient_nm            
	FROM #EmpStudy t, Client c            
	WHERE t.Client_id=c.Client_id            
	GROUP BY c.Client_id, c.strClient_nm            
	ORDER BY c.strClient_nm            
END
            
--Second recordset.  List of studies they have rights to            
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id              
FROM #EmpStudy            
ORDER BY strStudy_nm        
      
--Third recordset.  List of surveys they have rights to            
SELECT s.Survey_id, s.strSurvey_nm, s.strSurvey_dsc, s.Study_id, s.strCutoffResponse_cd,     
 s.CutoffTable_id, s.CutoffField_id, bitValidated_flg, ISNULL(sp.SamplePlan_id,0) SamplePlan_id,   
 s.INTRESPONSE_RECALC_PERIOD,    
/*Beginning of addition 2/27/2006*/      
 s.intResurvey_Period, s.datSurvey_Start_dt, s.datSurvey_End_dt, s.SamplingAlgorithmID,       
 s.bitEnforceSkip, s.strClientFacingName, s.SurveyType_id, s.SurveyTypeDef_id, s.datHCAHPSReportable,  
 s.ReSurveyMethod_id, strHouseholdingType  
/*End of addition 2/27/2006*/      
FROM #EmpStudy t, Survey_def s LEFT JOIN SamplePlan sp  
ON s.Survey_id=sp.Survey_id      
WHERE t.Study_id=s.Study_id  
ORDER BY s.strSurvey_nm            
            
--Cleanup temp table            
DROP TABLE #EmpStudy            
            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
SET NOCOUNT OFF       
  
   
GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_InsertClient
@ClientName VARCHAR(40)
AS

IF EXISTS (SELECT * FROM Client WHERE strClient_nm = @ClientName)
BEGIN
	RAISERROR ('The specified client name already exists.', 18, 1)
END
ELSE
BEGIN
	INSERT INTO Client (strClient_nm)
	VALUES(@ClientName)

	SELECT SCOPE_IDENTITY()
END

GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_DeleteClient
@ClientId INT
AS

IF EXISTS (SELECT * FROM Study WHERE Client_id = @ClientId)
BEGIN
	RAISERROR ('The client cannot be deleted because it contains studies.', 18, 1)
END
ELSE
BEGIN
	DELETE Client
	WHERE Client_id = @ClientId
END
GO 
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_SelectStudiesByClientId
@ClientId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT Study_id, strStudy_nm, strStudy_dsc, Client_id, ADEmployee_id   
FROM Study   
WHERE Client_id = @ClientId
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF    
GO 
-----------------------------------------------------------------------------------------------
GO
IF (ObjectProperty(Object_Id('dbo.QCL_SelectServiceTypes'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_SelectServiceTypes
GO
-----------------------------------------------------------------------------------------------
GO

/*******************************************************************************
 *
 * Procedure Name:
 *           QCL_SelectServiceTypes
 *
 * Description:
 *           Select all the sample unit service type
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:     Success
 *           Other:  Fail
 *
 * History:
 *           1.0  03/13/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.QCL_SelectServiceTypes
AS
  SELECT Service_ID,
         ParentService_id,
         strService_nm
    FROM Service
   ORDER BY
         ParentService_id,
         strService_NM,
         Service_ID

  RETURN -1
  
GO
-----------------------------------------------------------------------------------------------
GO
IF (ObjectProperty(Object_Id('dbo.QCL_SelectServiceTypesBySampleUnitID'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.QCL_SelectServiceTypesBySampleUnitID
GO
-----------------------------------------------------------------------------------------------
GO

/*******************************************************************************
 *
 * Procedure Name:
 *           QCL_SelectServiceTypesBySampleUnitID
 *
 * Description:
 *           Pull the service type and sub types selected for the sample unit
 *
 * Parameters:
 *           @SampleUnit_ID      int
 *
 * Return:
 *           -1:     Success
 *           Other:  Fail
 *
 * History:
 *           1.0  03/14/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.QCL_SelectServiceTypesBySampleUnitID (
        @SampleUnit_ID      int
       )
AS
  DECLARE @Service_ID  AS int
  
  --
  -- There is a record in SampleUnitService which has sample unit ID
  -- of "1" and service type of "other". This is not the value we
  -- want for new sample unit
  --
  IF (@SampleUnit_ID <= 0) BEGIN
      SELECT Service_Id,
             ParentService_Id,
             strService_NM
        FROM Service
       WHERE 1 = 0
      
      RETURN -1
  END
  
  --
  -- Find the parent service type ID.
  -- Using this defensive way to get the smallest service type ID if there are
  -- multiple parent service types selected to sample unit
  --
  SELECT TOP 1
         @Service_ID = Service_ID
    FROM (
          -- Parent service
          SELECT sv.Service_ID
            FROM SampleUnitService us,
                 Service sv
           WHERE us.SampleUnit_ID = @SampleUnit_ID
             AND sv.Service_ID = us.Service_ID
             AND sv.ParentService_ID IS NULL
          UNION
          -- Child service's parent service
          SELECT sv.ParentService_ID AS Service_ID
            FROM SampleUnitService us,
                 Service sv
           WHERE us.SampleUnit_ID = @SampleUnit_ID
             AND sv.Service_ID = us.Service_ID
             AND sv.ParentService_ID > 0
         ) sv
   ORDER BY Service_ID

  
  --
  -- Pull the service type and its service sub type of this sample unit
  --
  
  -- Parent service
  SELECT Service_Id,
         ParentService_Id,
         strService_NM
    FROM Service
   WHERE Service_ID = @Service_ID
  
  UNION ALL
  
  -- Child services
  SELECT sv.Service_ID,
         sv.ParentService_ID,
         sv.strService_NM
    FROM SampleUnitService us,
         Service sv
   WHERE us.SampleUnit_ID = @SampleUnit_ID
     AND sv.Service_ID = us.Service_ID
     AND sv.ParentService_ID = @Service_ID
   ORDER BY
         ParentService_ID,
         Service_Id

  RETURN -1
  
GO
-----------------------------------------------------------------------------------------------
GO



/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It returns a set of    
records representing survey data for the ID specified    
    
Created:  2/20/2006 by Dan Christensen   
    
Modified:    
03/27/2006 by DC - Added strHouseholdingType to survey selection    
    
*/        
CREATE PROCEDURE [dbo].[QCL_SelectSurveysByStudyId]      
@StudyId INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      
SELECT sd.Survey_id, strSurvey_nm, strSurvey_dsc, Study_id, strCutoffResponse_cd, CutoffTable_id, CutoffField_id,    
 bitValidated_flg, SamplePlan_id as SamplePlan_id, INTRESPONSE_RECALC_PERIOD,  
 intResurvey_Period, datSurvey_Start_dt, datSurvey_End_dt, SamplingAlgorithmID,   
 bitEnforceSkip, strClientFacingName, SurveyType_id, SurveyTypeDef_id, datHCAHPSReportable,
 ReSurveyMethod_id,strHouseholdingType  
FROM Survey_Def sd, SamplePlan sp    
WHERE sd.Study_id=@StudyId  and
		sd.survey_id=sp.survey_id
		     
          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF      

/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It inserts a record into the
samplePlan table
    
Created:  2/21/2006 by Dan Christensen   
    
Modified:    
 */   
CREATE PROCEDURE [dbo].[QCL_InsertSamplePlan]      
@employee_id INT,
@survey_id int     
AS       

INSERT INTO SamplePlan (employee_id, survey_id, DatCreate_DT)
VALUES(@employee_id, @survey_id,getDate())

SELECT SCOPE_IDENTITY()

GO
-----------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE QCL_UpdateClient
@ClientId INT,
@ClientName VARCHAR(40)

AS

IF EXISTS (SELECT * FROM Client WHERE strClient_nm = @ClientName)
BEGIN
	RAISERROR ('The specified client name has already been used.', 18, 1)
END
ELSE
BEGIN
	UPDATE Client SET strClient_nm = @ClientName WHERE Client_id = @ClientId
END
GO
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 

This procedure is used to display a grid of information about existing sample sets.  Since this dataset joins 
information from so many entities it is not used to populate the Class Library but is just for display purposes

Created:  01/26/2006 by Joe Camp

Modified:

*/
ALTER PROCEDURE [dbo].[QCL_SelectExistingSampleSetsBySurvey]
@SurveyId INT,
@StartDate DATETIME,
@EndDate DATETIME,
@ShowOnlyUnscheduled BIT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SET @StartDate = ISNULL(@StartDate, '1/1/1900')
SET @EndDate = ISNULL(@EndDate, '1/1/3000')

IF @ShowOnlyUnscheduled = 0
BEGIN
	SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled,
			sum(spw.intSampledNow+ spw.intinDirectSampledNow) as sampledCount
	FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s, Employee e,
		SamplePlanWorksheet spw
	WHERE ss.SampleSet_id = pd.SampleSet_id
	AND pd.PeriodDef_id = p.PeriodDef_id
	AND ss.Survey_id = sd.Survey_id
	AND sd.Study_id = s.Study_id
	AND ss.Employee_id = e.Employee_id
	AND sd.Survey_id = @SurveyId
	AND ss.datSampleCreate_dt > @StartDate
	AND ss.datSampleCreate_dt < DATEADD(DAY, 1, @EndDate)
	AND ss.sampleset_id=spw.sampleset_id 
	AND spw.parentsampleunit_id is null
	GROUP BY s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled
	ORDER BY ss.datSampleCreate_dt DESC
END
ELSE
BEGIN
	SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled,
			sum(spw.intSampledNow+ spw.intinDirectSampledNow) as sampledCount
	FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s, Employee e,
		SamplePlanWorksheet spw
	WHERE ss.SampleSet_id = pd.SampleSet_id
	AND pd.PeriodDef_id = p.PeriodDef_id
	AND ss.Survey_id = sd.Survey_id
	AND sd.Study_id = s.Study_id
	AND ss.Employee_id = e.Employee_id
	AND sd.Survey_id = @SurveyId
	AND ss.datSampleCreate_dt > @StartDate
	AND ss.datSampleCreate_dt < DATEADD(DAY, 1, @EndDate)
	AND ss.datScheduled IS NULL
	AND ss.sampleset_id=spw.sampleset_id 
	AND spw.parentsampleunit_id is null
	GROUP BY s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled
	ORDER BY ss.datSampleCreate_dt DESC
END
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure will return the period data for all period for a survey.

Created:  01/27/2006 by Dan Christensen

Modified:
		03/28/2006 by DC
		Added code to mark each period as 0=past, 1=active, 2=future

*/

ALTER   PROCEDURE [dbo].[QCL_SelectSamplePeriodsBySurvey]
	@survey_id int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
CREATE TABLE #activePeriod (periodDef_id int, ActivePeriod bit default 0)

INSERT INTO #activePeriod
EXEC [dbo].[QCL_SelectActivePeriodbySurveyId] @survey_id

SELECT p.PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEnd,
    SamplingMethod_id, coalesce(a.ActivePeriod,0) as ActivePeriod,
	case
		when a.ActivePeriod is not null then 1
		else 0
	end as TimeFrame
INTO #AllPeriods
FROM PeriodDef p LEFT JOIN #activePeriod a
ON p.perioddef_id=a.perioddef_id 
WHERE p.survey_id =@survey_id

--Mark any periods that are in the future
UPDATE #AllPeriods
SET TimeFrame=2
WHERE perioddef_id in 
	(select p.perioddef_id
	 from #AllPeriods p, perioddates pd
	 WHERE p.perioddef_id=pd.perioddef_id and
			p.activeperiod=0 and
			pd.samplenumber=1 and
			pd.datsamplecreate_dt is null)

SELECT *
FROM #AllPeriods
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure will return the period data for a period ID.

Created:  01/27/2006 by Dan Christensen

Modified:
		03/28/2006 by DC
		Added code to mark each period as 0=past, 1=active, 2=future


*/
ALTER   PROCEDURE [dbo].[QCL_SelectSamplePeriod]
	@period_id int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
--This recordSET has the Period Properties informatiON
SELECT PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEND,
    SamplingMethod_id
INTO #period
FROM PeriodDef
WHERE perioddef_id =@period_id

CREATE table #activePeriods (periodDef_id int, ActivePeriod bit default 0)

DECLARE @survey_id int
SELECT @survey_id=survey_id
FROM #periods

IF @survey_id IS NOT NULL
BEGIN
	INSERT INTO #activePeriods
	EXEC [dbo].[QCL_SELECTActivePeriodbySurveyId] @survey_id
END

SELECT p.PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEnd,
    SamplingMethod_id, coalesce(a.ActivePeriod,0) as ActivePeriod,
	case
		when a.ActivePeriod is not null then 1
		else 0
	end as TimeFrame
INTO #AllPeriod
FROM #period p LEFT JOIN #activePeriod a
ON p.perioddef_id=a.perioddef_id 
WHERE p.survey_id =@survey_id

--Mark any periods that are in the future
UPDATE #AllPeriod
SET TimeFrame=2
WHERE perioddef_id in 
	(select p.perioddef_id
	 from #AllPeriod p, perioddates pd
	 WHERE p.perioddef_id=pd.perioddef_id and
			p.activeperiod=0 and
			pd.samplenumber=1 and
			pd.datsamplecreate_dt is null)

SELECT *
FROM #AllPeriod
GO
-----------------------------------------------------------------------------------------------
GO


















--ADDED 3/30/2004 DC New
ALTER             procedure [dbo].[QP_Rep_SamplePlanWorkSheetExpanded]
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intSampleSet_id int, @DQAddress int, @DQAge int, @strsql varchar(2000), @intstudy_id int

select @intSurvey_id=sd.survey_id, @intstudy_id=s.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

 create table #SPW
 (SampleUnit_id int,    
  Tier int,
  Unit_nm varchar(60),
  PRT int,     -- Period Return Target
  QP int,      -- Qualified Population
  DRR int,     -- Default Response Rate
  HRRn int,    -- Historic Response Rate (numerator)
  HRRd int,    -- Historic Response Rate (denominator)
  HRR float,   -- Historic Response Rate 
  TPO int,     -- Total Prior Outgo for this period
  AR float,    -- Anticipated Returns from TPO
  ARN float,   -- Additional Returns Needed 
  SAP int,     -- Samples Already Pulled
  SIP int,     -- Samples In Period
  SLP int,     -- Samples Left in Period
  APON float,  -- Additional Period Outgo Needed 
  ONTS int,    -- Outgo Needed This Sampleset
  STS int,     -- Sampled This Sampleset
  D int,       -- Difference between ONTS and STS
  Avail int,   -- Available records
  ISTS int,    -- Number Indirectly Sampled
  DQAdd int,   -- Records DQ'd for address
  DQAge int,   -- Records DQ'd for age
  TotalDQ int, -- Total DQ'd
  HCAHPSSampled int) --Total number also sampled for HCAHPS unit 

  INSERT INTO #SPW (unit_nm, sts)
   SELECT 'Total Individuals Sampled',
 		count(*)
   from SamplePop
   where sampleset_id=@intSampleset_id

 create table #SampleUnits
  (SampleUnit_id int,
   strSampleUnit_nm varchar(255),
   intTier int,
   intTreeOrder int)

 declare @intSamplePlan_id int
 select @intSamplePlan_id=sampleplan_id from sampleset where sampleset_id=@intSampleset_id
 exec sp_SampleUnits @intSamplePlan_id

 INSERT into #SPW 
   (SampleUnit_id, tier, Unit_nm, PRT, QP, DRR, HRRn, HRRd, HRR, TPO, AR, ARN, SAP, SIP, SLP, APON, ONTS, STS, D, ISTS, Avail, DQAdd, DQAge, TotalDQ, HCAHPSSampled)
 select sampleunit_id, intTier, strSampleUnit_nm, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 from #sampleunits
 
 drop table #SampleUnits

IF EXISTS (SELECT sampleset_id from sampleplanworksheet WHERE sampleset_id=@intsampleset_id)
BEGIN
 CREATE Table #DQ (sampleunit_id int, DQAdd int, DQAge int, TotalDQ int)

 INSERT INTO #DQ (sampleunit_id,DQAdd,DQAge,TotalDQ)
 SELECT sampleunit_id,0,0,0
 From SAMPLEUNIT
 WHERE sampleplan_id=@intSamplePlan_id

 UPDATE #DQ
 SET DQAge= N
 FROM #DQ d, SPWDQCounts s
 WHERE DQ ='DQ_adder' and
		d.sampleunit_id=s.sampleunit_id and
		sampleset_id=@intSampleset_id

 UPDATE #DQ
 SET DQAge= N
 FROM #DQ d, SPWDQCounts s
 WHERE DQ ='DQ_age' and
		d.sampleunit_id=s.sampleunit_id and
		sampleset_id=@intSampleset_id

 SELECT sampleunit_Id, sum(N) as DQcount
 INTO #Total
 FROM SPWDQCounts
 WHERE sampleset_id=@intSampleset_id
 GROUP BY Sampleunit_id

 UPDATE #DQ
 SET TotalDQ = DQcount
 FROM #DQ d, #Total t
 WHERE d.sampleunit_id=t.sampleunit_id
 
 DROP TABLE #Total

 UPDATE #SPW 
 SET 
    PRT=intPeriodReturnTarget,
    DRR=numDefaultResponseRate,
    HRR=numHistoricResponseRate,
    TPO=intTotalPriorPeriodOutgo,
    AR=intAnticipatedTPPOReturns,
    ARN=intAdditionalReturnsNeeded,
    SAP=intSamplesAlreadyPulled,
    SIP=intSamplesInPeriod,
    SLP=intSamplesLeftInPeriod,
    APON=case 
			when numAdditionalPeriodOutgoNeeded < 0 then 0
			else numAdditionalPeriodOutgoNeeded
		end,
    ONTS=case 
			when intOutgoNeededNow < 0 then 0
			else intOutgoNeededNow
		end,
	ISTS=coalesce(intIndirectSampledNow,0),
    STS=coalesce(intSampledNow,0),
    D=case 
			when intShortfall < 0 then 0
			when intshortfall is null then intOutgoNeededNow-0
			else intshortfall
		end,
    Avail=coalesce(intAvailableUniverse,0),
	HCAHPSSampled=HcahpsDirectSampledCount
 FROM #SPW spw, sampleplanworksheet s
 WHERE s.sampleset_id=@intsampleset_id and
		spw.sampleunit_Id=s.sampleunit_Id

UPDATE #SPW 
 SET DQADD=d.DQAdd, 
    DQAge=d.DQAge,
    TotalDQ=d.TotalDQ
 FROM #SPW spw, #DQ d
 WHERE spw.sampleunit_Id=d.sampleunit_id 

 select 
    Unit_nm as SampleUnit,
    Tier,
    SampleUnit_id as [Unit ID],
    PRT,
    DRR,
    HRR,
    TPO,
    str(APON,10,2) as APON,
    ONTS,
	ISTS,
    STS,
    D,
    Avail,
    TotalDQ,
	HCAHPSSampled,
    space(2) as [ ]
 from #spw

END
ELSE
BEGIN

 UPDATE #SPW
 set PRT = intTargetReturn, DRR = NUMINITResponseRate, HRR = NULL
 from sampleunit SU
 where #SPW.SampleUnit_id = SU.SampleUnit_id

 DECLARE @ResponseRate_Recalc_Period int, @datSampleCreate_dt datetime
 -- Fetch the Response Rate Recalculation Period 
 SELECT @ResponseRate_Recalc_Period = intResponse_Recalc_Period
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id

 -- Fetch the date/time the sampleset was created 
 SELECT @datSampleCreate_dt=datSampleCreate_dt 
  FROM dbo.SampleSet
  WHERE SampleSet_id = @intSampleSet_id

 -- Fetch the period datetime bookends
 DECLARE @datPeriodStart datetime, @datPeriodEnd datetime
 select @datPeriodStart = ISNULL(max(datPeriodDate),'1/1/1990')
 from Period
 where datperioddate<@datSampleCreate_dt
   and survey_id=@intSurvey_id

 select @datPeriodEnd = ISNULL(min(datPeriodDate),getdate())
 from Period
 where datperioddate>@datSampleCreate_dt
   and survey_id=@intSurvey_id

 CREATE TABLE #SampleSet_Status
  (SampleSet_id int, bitComplete bit)
 -- Identify the Sample Sets that have mailing items. 
 INSERT INTO #SampleSet_Status
  SELECT DISTINCT SS.SampleSet_id, 1
   FROM dbo.SampleSet SS, dbo.SamplePop SP, dbo.ScheduledMailing SchM
   WHERE SS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SS.Survey_id = @intSurvey_id
    AND SS.datSampleCreate_dt < @datSampleCreate_dt

 -- Of the sample sets that have mailing items, identify the ones that have non-generated mailing items. 
 UPDATE #SampleSet_Status
  SET bitComplete = 0
   FROM #SampleSet_Status SSS, dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, dbo.MailingStep MS
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND (SchM.SentMail_id IS NULL OR SchM.datGenerate >= @datSampleCreate_dt)
    AND SchM.OverrideItem_id IS NULL
    
 CREATE TABLE #SampleSet_MailDate
  (SampleSet_id int, datLastMailDate datetime, bitCompleteCollMethod bit)
 -- Of the sample sets that have generated all mailing items, identify the date the last non-Thank You item was sent 
 INSERT INTO #SampleSet_MailDate
  SELECT SSS.SampleSet_id, MAX(SM.datMailed), 0
   FROM #SampleSet_Status SSS, dbo.SamplePop SP, dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, dbo.MailingStep MS
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.SentMail_id = SM.SentMail_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND SchM.OverrideItem_id IS NULL
    AND SSS.bitComplete = 1
   GROUP BY SSS.SampleSet_id
 DROP TABLE #SampleSet_Status
 
 -- Mark the Sample Sets that have completed the collection methodology 
 UPDATE #SampleSet_MailDate
  SET bitCompleteCollMethod = 1
  WHERE datLastMailDate IS NOT NULL
   AND DATEDIFF(day, datLastMailDate, @datSampleCreate_dt) > @ResponseRate_Recalc_Period
 CREATE TABLE #SampleUnit_Mailed
  (SampleUnit_id int, intNumMailed int)

 -- For each Sample Unit, calculate the number of people directly sampled from the sample sets that have completed the collection methodology 
 INSERT INTO #SampleUnit_Mailed
  SELECT SU.SampleUnit_id, COUNT(DISTINCT SS.Pop_id)
   FROM dbo.SamplePlan SP, dbo.SampleUnit SU, dbo.SelectedSample SS, 
    dbo.SamplePop SPop, dbo.QuestionForm QF, #SampleSet_MailDate SSMD
   WHERE SP.SamplePlan_id = SU.SamplePlan_id
    AND SU.SampleUnit_id = SS.SampleUnit_id
    AND SS.SampleSet_id = SSMD.SampleSet_id
    AND SS.SampleSet_id = SPop.SampleSet_id
    AND SS.Study_id = SPop.Study_id
    AND SS.Pop_id = SPop.Pop_id
    AND SPop.SamplePop_id = QF.SamplePop_id
    AND SP.Survey_id = @intSurvey_id
    AND SSMD.bitCompleteCollMethod = 1
    AND SS.strUnitSelectType = 'D'
   GROUP BY SU.SampleUnit_id
 CREATE TABLE #SampleUnit_Returned
  (SampleUnit_id int, intNumReturn int)

 -- For each Sample Unit, calculate the number of people who have returned surveys from the sample sets that have completed the collection methodology 
 INSERT INTO #SampleUnit_Returned
  SELECT SU.SampleUnit_id, COUNT(DISTINCT SS.Pop_id)
   FROM dbo.SamplePlan SP, dbo.SampleUnit SU, dbo.SelectedSample SS, 
    dbo.SamplePop SPop, dbo.QuestionForm QF, #SampleSet_MailDate SSMD
   WHERE SP.SamplePlan_id = SU.SamplePlan_id
    AND SU.SampleUnit_id = SS.SampleUnit_id
    AND SS.SampleSet_id = SSMD.SampleSet_id
    AND SS.SampleSet_id = SPop.SampleSet_id
    AND SS.Study_id = SPop.Study_id
    AND SS.Pop_id = SPop.Pop_id
    AND SPop.SamplePop_id = QF.SamplePop_id
    AND SP.Survey_id = @intSurvey_id
    AND SSMD.bitCompleteCollMethod = 1
    AND SS.strUnitSelectType = 'D'
    AND ISNULL(QF.datReturned,getdate()) < @datSampleCreate_dt
   GROUP BY SU.SampleUnit_id

 -- Calculate and Record the Response Rate for each sample unit 
 UPDATE #SPW
  SET HRRn = SUR.intNumReturn,
      HRRd = SUS.intNumMailed,
      HRR = CONVERT(float, SUR.intNumReturn)/CONVERT(float, SUS.intNumMailed) * 100
  FROM #SampleUnit_Mailed SUS, #SampleUnit_Returned SUR
  WHERE #SPW.SampleUnit_id = SUS.SampleUnit_id
    AND SUS.SampleUnit_id = SUR.SampleUnit_id
    AND SUR.intNumReturn <> 0
    AND SUS.intNumMailed <> 0 
 DROP TABLE #SampleUnit_Mailed
 DROP TABLE #SampleUnit_Returned
 DROP TABLE #SampleSet_MailDate


 DECLARE @SamplesInPeriod INT
 DECLARE @SamplesRun INT
 DECLARE @SamplesLeft INT

 -- Creating temp tables for calculation of targets 
 -- The following table will retain the number of eligible record per sample unit 
 CREATE TABLE #SampleUnit_Count
  (SampleUnit_id INT, 
  PopCounter INT)
 -- The following table will retain the sample_sets within this period
 CREATE TABLE #SampleSet_Period
  (SampleSet_id INT)
 -- The following table will retain the number of Samples left, target returns and response rates for each sample_units 
 CREATE TABLE #SampleUnit_Temp

  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period INT, 
  ResponseRate INT,
  InitResponseRate INT)
 -- The following table will retain the different numbers used to compute targets for each sample_units 
 CREATE TABLE #SampleUnit_Sample
  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period INT, 
  ResponseRate INT, 
  InitResponseRate INT,
  NumSampled_Period INT, 
  ReturnEstimate INT, 
  ReturnsNeeded_Period INT, 
  NumToSend_Period FLOAT, 
  NumToSend_SampleSet INT)
 -- Getting the other sampleSet_id prior to the one we are processing 
 INSERT INTO #SampleSet_Period
  SELECT SampleSet_id 
  FROM dbo.SampleSet S
  WHERE S.survey_id = @intSurvey_id
   AND S.SampleSet_id <> @intSampleSet_id
   AND S.datSampleCreate_dt between @datPeriodStart and dateadd(second,-1,@datSampleCreate_dt)
 SELECT @SamplesInPeriod = intSamplesInPeriod
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id
 SELECT @SamplesRun = COUNT(*)
  FROM #SampleSet_Period
 SELECT @SamplesLeft = @SamplesInPeriod - @SamplesRun
 IF @SamplesLeft < 1 
  SELECT @SamplesLeft = 1 
 INSERT INTO #SampleUnit_Temp (SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate)
  SELECT SampleUnit_id, @SamplesLeft, PRT, HRR, DRR
   FROM #spw SP
   --WHERE SP.SamplePlan_id = SU.SamplePlan_id
   -- AND SP.Survey_id = @intSurvey_id
 INSERT INTO #SampleUnit_Sample(SampleUnit_id, SamplesLeft, 
      TargetReturn_Period, ResponseRate, InitResponseRate,
   NumSampled_Period, ReturnEstimate, ReturnsNeeded_Period, NumToSend_Period, 
   NumToSend_SampleSet)
  SELECT  SampleUnit_id, SamplesLeft, 
   TargetReturn_Period, ResponseRate, InitResponseRate, 0, 0, 0, 0, 0
   FROM  #SampleUnit_Temp
 INSERT INTO #SampleUnit_Count
  SELECT SS.SampleUnit_id, COUNT(DISTINCT Pop_id)
   FROM dbo.SelectedSample SS, #SampleSet_Period SSP
   WHERE SS.SampleSet_id = SSP.SampleSet_id
    AND SS.strUnitSelectType = 'D'
   GROUP BY SS.SampleUnit_id
 UPDATE #SampleUnit_Sample

  SET NumSampled_Period = PopCounter
  FROM #SampleUnit_Count SUC
  WHERE SUC.SampleUnit_id = #SampleUnit_Sample.SampleUnit_id
 /* Computing the rest of the SampleUnit targets */
 UPDATE #SampleUnit_Sample
  SET ReturnEstimate = ROUND(NumSampled_Period * (CONVERT(float,isnull(ResponseRate,initResponseRate))/100), 0)
 UPDATE #SampleUnit_Sample
  SET ReturnsNeeded_Period = TargetReturn_Period - ReturnEstimate
  WHERE (TargetReturn_Period - ReturnEstimate) > 0
 UPDATE #SampleUnit_Sample
  SET NumToSend_Period = ReturnsNeeded_Period/(CONVERT(float, isnull(ResponseRate,initResponseRate))/100)
 UPDATE #SampleUnit_Sample
  SET NumToSend_SampleSet = ROUND(NumToSend_Period/SamplesLeft, 0)

 UPDATE #SPW
   set SAP=@SamplesRun,
       SIP=@SamplesInPeriod,
       SLP=SamplesLeft,
       PRT=TargetReturn_Period, 
       TPO=NumSampled_Period, 
       AR=ReturnEstimate, 
       ARN=ReturnsNeeded_Period, 
       APON=NumToSend_Period, 
       ONTS=NumToSend_SampleSet,
       D=0
  FROM #SampleUnit_Sample
  WHERE #SPW.SampleUnit_id=#SampleUnit_Sample.SampleUnit_id

 DROP TABLE #SampleUnit_Count
 DROP TABLE #SampleSet_Period
 DROP TABLE #SampleUnit_Temp
 DROP TABLE #SampleUnit_Sample

 update #SPW
   set STS=cnt
   from (select sampleunit_id, count(*) as cnt
         from selectedsample
         where sampleset_id=@intSampleSet_id
           and STRUNITSELECTTYPE='D'
         group by sampleunit_id) xx
   where xx.sampleunit_id=#spw.sampleunit_id

 update #SPW
   set ISTS=cnt
   from (select sampleunit_id, count(*) as cnt
         from selectedsample
         where sampleset_id=@intSampleSet_id
           and STRUNITSELECTTYPE='I'
         group by sampleunit_id) xx
   where xx.sampleunit_id=#spw.sampleunit_id

 update #SPW
   set D = ONTS-STS 

 Create table #avail (sampleunit_id int, cnt int)

 set @strsql = 'insert into #avail select sampleunit_id, count(distinct pop_id) from s' + convert(varchar,@intstudy_id) + '.unikeys
	where sampleset_id = ' + convert(varchar,@intsampleset_id) + ' group by sampleunit_id'

 exec (@strsql)

 update t
   set t.avail = a.cnt
   from #spw t, #avail a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #avail

 Create table #addr (sampleunit_id int, cnt int)
 
 set @dqaddress = (select top 1 businessrule_id from businessrule br, criteriastmt c
	where survey_id = @intsurvey_id
	and br.criteriastmt_id = c.criteriastmt_id
	and c.strcriteriastmt_nm = 'DQ_AddEr')
 
 insert into #addr select sampleunit_id, count(*) from unitdq
	where sampleset_id = @intsampleset_id
	and dqrule_id = @dqaddress
	group by sampleunit_id

 update t
   set t.dqadd = a.cnt
   from #spw t, #addr a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #addr

 Create table #age (sampleunit_id int, cnt int)

 set @dqage = (select top 1 businessrule_id from businessrule br, criteriastmt c
	where survey_id = @intsurvey_id
	and br.criteriastmt_id = c.criteriastmt_id
	and c.strcriteriastmt_nm = 'DQ_Age')

 insert into #age select sampleunit_id, count(*) from unitdq
	where sampleset_id = @intsampleset_id
	and dqrule_id = @dqage
	group by sampleunit_id

 update t
   set t.dqage = a.cnt
   from #spw t, #age a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #age


 Create table #totalDQ (sampleunit_id int, cnt int)

 insert into #totalDQ select sampleunit_id, count(*) from unitdq
	where sampleset_id = @intsampleset_id
	group by sampleunit_id

 update t
   set t.totalDQ = a.cnt
   from #spw t, #totalDQ a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #totalDQ

 select 
    Unit_nm as SampleUnit,
    Tier,
    SampleUnit_id as [Unit ID],
    PRT,
    DRR,
    str(HRR,10,2) as HRR,
    TPO,
    str(APON,10,2) as APON,
    ONTS,
	ISTS,
    STS,
    D,
    Avail,
    TotalDQ,
	HCAHPSSampled,
    SPACE(2) as [ ]
 from #spw
 
END


 drop table #spw

set transaction isolation level read committed



GO
-----------------------------------------------------------------------------------------------
GO




ALTER            procedure [dbo].[QP_Rep_SamplePlanWorkSheetTitle]
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime,@SamplesInPeriod int, @SamplesRun int, 
		@SamplesLeft int, @intSampleset_id int, @intsurvey_id int,
		@periodDateRange varchar(50), @sampledDateRange varchar(50),
		@SelectedDateRange varchar(50), @EncounterDateField varchar(50),
		@sql varchar(8000), @intstudy_id int
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, survey, sampleset, procedurebegin) select 'Sample Plan Worksheet', @associate, @client, @study, @survey, @sampleset, @procedurebegin


select @intSurvey_id=sd.survey_id,
	   @intStudy_id=s.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

create table #title (SampleSet varchar(250), SAP int, SIP int, SLP int)
/*
insert into #title (SamplePlanWorkSheet) values ('Client: ' + @Client)
insert into #title (SamplePlanWorkSheet) values ('Study: ' + @Study)
insert into #title (SamplePlanWorkSheet) values ('Survey: ' + @Survey)
*/
insert into #title (SampleSet) values (@SampleSet)

IF EXISTS (SELECT sampleset_id from sampleplanworksheet WHERE sampleset_id=@intsampleset_id)
BEGIN
	SELECT @SamplesRun=intSamplesAlreadyPulled,
			@samplesinPeriod=intSamplesInPeriod,
			@samplesLeft=intSamplesLeftInPeriod
	FROM sampleplanworksheet
	WHERE sampleset_id=@intsampleset_id
END
ELSE
BEGIN
 DECLARE @datPeriodStart datetime, @datSampleCreate_dt datetime, @period int
 SELECT @datSampleCreate_dt=datSampleCreate_dt 
  FROM dbo.SampleSet
  WHERE SampleSet_id = @intSampleSet_id
	
 Select @period=perioddef_id
 FROM PERIODDates
 WHERE sampleset_id=@intsampleset_id

 select @datPeriodStart = datSampleCreate_dt
 from PeriodDates 
 where perioddef_id=@period and
		samplenumber=1

 SELECT @SamplesRun=COUNT(*) 
  FROM dbo.SampleSet S
  WHERE S.survey_id = @intSurvey_id
   AND S.datSampleCreate_dt between @datPeriodStart and @datSampleCreate_dt

 SELECT @SamplesInPeriod = intSamplesInPeriod
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id

 SELECT @SamplesLeft = @SamplesInPeriod - @SamplesRun
END

CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))

SET @SQL = 'INSERT INTO #DATEFIELD' +
   ' SELECT mt.strTable_nm + ''.'' + mf.strField_nm' +
   ' FROM Sampleset ss, survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
   ' WHERE ss.sampleset_id= ' + convert(varchar,@intSampleSet_id) + 
   ' AND ss.Survey_id = sd.survey_id' +
   ' AND sd.Study_id = mt.Study_id' +
   ' AND ms.Table_id = mt.Table_id' +
   ' AND ms.Field_id = mf.Field_id' +
   ' AND ms.table_id=sd.cutofftable_id' +
   ' AND ms.field_id=sd.cutofffield_id' +
   ' AND mf.strFieldDataType = ''D''' 

Execute (@sql)

SELECT @EncounterDateField=DATEFIELD
FROM #DATEFIELD

DECLARE	@EncTable bit


IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@intstudy_id AND strTable_nm='Encounter')>0
SELECT @EncTable=1
ELSE 
SELECT @EncTable=0

IF @EncounterDateField is null and @encTable=0 Set @EncounterDateField='populationNewRecordDate'
	ELSE IF @EncounterDateField is null and @encTable=1 Set @EncounterDateField='encounterNewRecordDate'


DROP TABLE #DATEFIELD


 SELECT @SampledDateRange=
	case
		when minEnc_dt is not null then 
			@EncounterDateField + ' ' + 
			convert(varchar,minEnc_dt,101) + ' - ' + 
			convert(varchar,maxEnc_dt,101)
		else 'Sampled Date Range Unknown'
	end
 FROM sampleplanworksheet
 WHERE sampleset_id=@intsampleset_id and
	parentsampleunit_id is null

IF @SampledDateRange is null SET @SampledDateRange='Sampled Date Range is Not Available'

 SELECT Distinct @PeriodDateRange=
		case 
		  when datexpectedencstart is not null then 
			'Period Date Range ' + 
			convert(varchar,datexpectedencstart,101) + ' - ' + 
			convert(varchar,datexpectedencend,101)
		  else 'Period Date Range not specified'
		end
 FROM PeriodDef p, perioddates pd
 WHERE pd.sampleset_id=@intsampleset_id and
		p.perioddef_id=pd.perioddef_id

 SELECT @SelectedDateRange=
		case 
		  when datdaterange_fromdate is not null then 
			'Selected Date Range ' + 
			convert(varchar,datdaterange_fromdate,101) + ' - ' + 
			convert(varchar,datdaterange_todate,101)
		  else 'Selected Date Range not specified'
		end
 FROM SAMPLESET
 WHERE sampleset_id=@intsampleset_id

UPDATE #Title
SET SAP=@samplesrun,
	SIP=@SamplesinPeriod,
	SLP=@Samplesleft	

--Get A list of datasets used
Declare @datasets varchar(200), @tempDataset varchar(20)
SET @datasets=''

SELECT dataset_id
INTO #Datasets
FROM sampledataset
WHERE sampleset_id=@intsampleset_id

IF @@Rowcount > 0
Begin
	SELECT TOP 1 @tempDataset=convert(varchar,dataset_id)
	FROM #Datasets

	While @@rowcount>0
	BEGIN

		IF @datasets='' SET @datasets= @tempDataset
		ELSE SET @datasets=@datasets + ', ' + @tempDataset

		DELETE FROM #DATASETS WHERE dataset_id=@tempDataset

		SELECT TOP 1 @tempDataset=convert(varchar,dataset_id)
		FROM #Datasets
	END
End

INSERT INTO #Title (sampleset)
	values (@PeriodDateRange)
INSERT INTO #Title (sampleset)
	values (@SelectedDateRange)
INSERT INTO #Title (sampleset)
	values (@SampledDateRange)
INSERT INTO #Title (sampleset)
	values ('Dataset(s) Used: '+ @datasets)


select * from #title
drop table #title
drop table #datasets

set transaction isolation level read committed

GO
-----------------------------------------------------------------------------------------------
GO