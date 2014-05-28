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
CREATE          PROCEDURE [dbo].[sp_Samp_CreateTempTables]
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
 SET @SQL = @SQL +  'Age int, DQ_Bus_Rule int, Removed_Rule TINYINT DEFAULT 0, strUnitSelectType varchar(1), EncDate datetime, ReSurveyDate DATETIME, reportDate datetime)'
 
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


