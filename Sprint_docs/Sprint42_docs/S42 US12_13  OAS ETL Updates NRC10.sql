/*

Sprint 42

US 12 OAS: Count Fields 
As an OAS-CAHPS vendor, we need to report in the submission file the number of patients in the data file & the number of eligible patients, so our files are accepted.

	ALTER PROCEDURE QP_prod.[dbo].[QCL_SelectEncounterUnitEligibility]
	alter table NRC_Datamart_ETL.[dbo].[SampleUnitTemp] add eligibleCount int NULL
	ALTER PROCEDURE NRC_Datamart_ETL.[dbo].[csp_GetSamplePopulationExtractData] 
	ALTER PROCEDURE NRC_Datamart_ETL.[dbo].[csp_GetSamplePopulationExtractData2] 

US 13 OAS: Language in which Survey Completed 
As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs

	alter table [dbo].[QuestionFormTemp] add [LangID] int NULL 
	ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 
	ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData2]


Tim Butler 

*/



--US 12 OAS: Count Fields 

USE QP_PROD
GO

ALTER PROCEDURE [dbo].[QCL_SelectEncounterUnitEligibility]
   @Survey_id INT ,
   @Study_id INT ,
   @DataSet VARCHAR(2000) ,
   @startDate DATETIME = NULL ,
   @EndDate DATETIME = NULL ,
   @seed INT ,
   @ReSurvey_Period INT ,
   @EncounterDateField VARCHAR(42) ,
   @ReportDateField VARCHAR(42) ,
   @encTableExists BIT ,
   @sampleSet_id INT ,
   @samplingMethod INT ,
   @resurveyMethod_id INT = 1 ,
   @samplingAlgorithmId AS INT                                     
 --,@indebug int = 0                                                
AS 

/* 
=============================================

	S42 US12     02/06/2016 T.Butler  OAS: Count Fields As an OAS-CAHPS vendor, we need to report in the submission file the number of patients in the data file & the number of eligible patients, so our files are accepted.

=============================================
*/
   BEGIN                                                
      SET NOCOUNT ON                                                
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                
                                    
      DECLARE @indebug TINYINT ,
         @SamplingLogInsert TINYINT                                    
      SET @indebug = 0       
      SET @SamplingLogInsert = 1                          
                                                 
      DECLARE @FromDate VARCHAR(10) ,
         @ToDate VARCHAR(10)                                                
                           
                  
                                      
      IF @indebug = 1 
         PRINT 'Start QCL_SelectEncounterUnitEligibility'                                      
                          
                           
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Start Proc', GETDATE(), ''                          
         END                   
                                                 
      SET @fromDate = CONVERT(VARCHAR, @startdate, 101)                                                
      SET @toDate = CONVERT(VARCHAR, @EndDate, 101)                                                
                                                 
      DECLARE @Sel VARCHAR(8000) ,
         @sql VARCHAR(8000) ,
         @DQ_id INT ,
         @newbornRule VARCHAR(7900)                            
      DECLARE @SampleUnit INT ,
         @ParentSampleUnit INT ,
         @strDateWhere VARCHAR(150)                                                
      DECLARE @bitDoTOCL BIT ,
         @SurveyType_ID INT                                                
                                                 
      SET @strDateWhere = ''                                                
                                                 
      CREATE TABLE #DataSets (DataSet_id INT)                                           
      SET @Sel = 'INSERT INTO #DataSets                                                
				  SELECT DataSet_id FROM Data_Set WHERE DataSet_id IN (' + @DataSet + ')'                                      
      EXEC (@Sel)                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 1', GETDATE(), ''                          
         END                          
                          
                                                 
 --get the list of Fields needed                                                
      DECLARE @tbl TABLE (Fieldname VARCHAR(50) ,
                          DataType VARCHAR(20) ,
                          Length INT ,
                          Field_id INT)                                 
                                                 
 --Get HouseHolding Variables if needed                                           
      DECLARE @HouseHoldFieldSelectSyntax VARCHAR(1000) ,
		 @HouseHoldFieldSelectBigViewSyntax VARCHAR(1000) ,
         @HouseHoldFieldCreateTableSyntax VARCHAR(1000) ,
         @HouseHoldJoinSyntax VARCHAR(1000) ,
         @HouseHoldingType CHAR(1)                                                
                                                 
      SELECT   @HouseHoldFieldSelectSyntax = '', @HouseHoldFieldSelectBigViewSyntax = '',
               @HouseHoldFieldCreateTableSyntax = '', @HouseHoldJoinSyntax = ''                                                 
                                                 
      DECLARE @HHFields TABLE (Fieldname VARCHAR(50) ,
                               DataType VARCHAR(20) ,
                               Length INT ,
                               Field_id INT)        
							                                 
		declare @CGCAHPS int
		SELECT @CGCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'CGCAHPS'

		declare @HCAHPS int
		SELECT @HCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'HCAHPS IP'

		declare @HHCAHPS int
		SELECT @HHCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Home Health CAHPS'

		declare @ACOCAHPS int
		SELECT @ACOCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

		declare @ICHCAHPS int
		SELECT @ICHCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'

		declare @hospiceCAHPS int
		SELECT @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

		declare @CIHI int
		select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

		declare @OASCAHPS int
		select @OASCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'
	                                             
              
 --MWB 9/2/08  HCAHPS Prop Sampling Sprint                                              
      SELECT   @HouseHoldingType = strHouseHoldingType, @bitDoTOCL = 1, @SurveyType_ID = SurveyType_id                                              
 -- case                                               
 --     --when surveytype_id=2 then 0 --HCAHPS IP   --ALL surveys now do Householding not just picker or non HCAHPS                                              
 -- when surveytype_id=2 then 1                                               
 --     else 1                                                
 --    END                                                
      FROM     Survey_def
      WHERE    Survey_id = @Survey_id                                                
                                                 
      CREATE TABLE #HH_Dup_People (id_num INT IDENTITY ,
                                   Pop_id INT ,
                                   bitKeep BIT)                                                
      CREATE TABLE #Minor_Universe (id_num INT IDENTITY ,
                                    Pop_id INT ,
                                    intShouldBeRand TINYINT ,
                                    intRemove INT ,
                                    intMinorException INT)                                                
      CREATE TABLE #Minor_Exclude (Pop_id INT ,
                                   intMinorException INT)                                                 
      CREATE TABLE #HouseHold_Dups (dummyColumn BIT)                                                
                                                 
      IF @HouseHoldingType <> 'N' 
         BEGIN                                                
                                                 
            INSERT   INTO @HHFields
                     SELECT   strTable_nm + strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
                     FROM     dbo.HouseHoldRule HR ,
                              MetaData_View m
                     WHERE    HR.Table_id = M.Table_id
                              AND HR.Field_id = M.Field_id
                              AND HR.Survey_id = @Survey_id                                                
                            
            SELECT   @HouseHoldFieldSelectSyntax = @HouseHoldFieldSelectSyntax + ', X.' + Fieldname
            FROM     @HHFields
            ORDER BY Field_id                                                
            SET @HouseHoldFieldSelectSyntax = SUBSTRING(@HouseHoldFieldSelectSyntax, 2,
                                                        LEN(@HouseHoldFieldSelectSyntax) - 1)                                                
                                                 
            SELECT   @HouseHoldJoinSyntax = CASE WHEN @HouseHoldJoinSyntax = '' THEN ''
                                                 ELSE @HouseHoldJoinSyntax + ' AND '
                                            END + ' X.' + Fieldname + '=Y.' + FieldName
            FROM     @HHFields
            ORDER BY Field_id                                                
                                                
            SELECT   @HouseHoldFieldCreateTableSyntax = @HouseHoldFieldCreateTableSyntax + ',' + FieldName + ' '
                     + CASE DataType
                         WHEN 'I' THEN 'INT '
                         WHEN 'D' THEN 'DATETIME '
                         ELSE 'VARCHAR(' + CONVERT(VARCHAR, Length) + ')'
                       END
            FROM     @HHFields
            ORDER BY Field_id                                                
            SELECT   @sel = REPLACE(@sel, ',,', '')                                                
            SELECT   @HouseHoldFieldCreateTableSyntax = SUBSTRING(@HouseHoldFieldCreateTableSyntax, 2,
                                                                  LEN(@HouseHoldFieldCreateTableSyntax) - 1)                                                
                                                 
                          
            IF @SamplingLogInsert = 1 
               BEGIN                          
                  INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                           SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 2', GETDATE(), ''                          
               END                          
                                                 
            IF @encTableExists = 1 
               SELECT   @sel = 'ALTER TABLE #HH_Dup_People ADD EncounterEnc_id INT'                                                
            ELSE 
               SELECT   @sel = 'ALTER TABLE #HH_Dup_People ADD ,'                                                
                                                 
            SELECT   @sel = @sel + ',' + FieldName + ' ' + CASE DataType
                                                             WHEN 'I' THEN 'INT '
                                                             WHEN 'D' THEN 'DATETIME '
                                                             ELSE 'VARCHAR(' + CONVERT(VARCHAR, Length) + ')'
                                                           END
            FROM     @HHFields
            ORDER BY Field_id                                                
            SELECT   @sel = REPLACE(@sel, ',,', '')                                                
                                      
                                        
            IF @indebug = 1 
               PRINT @sel                                                 
            EXEC (@Sel)                                                
                          
            IF @SamplingLogInsert = 1 
               BEGIN                          
                  INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                           SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 3', GETDATE(), ''                          
               END                          
                          
                                        
            SELECT   @sel = REPLACE(@sel, '#HH_Dup_People', '#Minor_Universe')                                                
            IF @indebug = 1 
               PRINT @sel                                      
            EXEC (@Sel)             
                                        
            SELECT   @sel = REPLACE(@sel, '#Minor_Universe', '#Minor_Exclude')                                                
            IF @indebug = 1 
               PRINT @sel                                      
            EXEC (@Sel)                                                
                                        
            SELECT   @sel = REPLACE(@sel, '#Minor_Exclude', '#HouseHold_Dups')                                                
            IF @indebug = 1 
               PRINT @sel                                      
            EXEC (@Sel)                                                 
                                            
         END                                                
                                                 
 --Create temp Tables                                                
      CREATE TABLE #SampleUnit_Universe (id_num INT IDENTITY ,
                                         SampleUnit_id INT ,
                                         Pop_id INT ,
                                         Enc_id INT ,
                                         Age INT ,
                                         DQ_Bus_Rule INT ,
                                         Removed_Rule INT DEFAULT 0 ,
                                         strUnitSelectType VARCHAR(1) ,
                                         EncDate DATETIME ,
                                         ReSurveyDate DATETIME ,
                                         HouseHold_id INT ,
                                         bitBadAddress BIT DEFAULT 0 ,
                                         bitBadPhone BIT DEFAULT 0 ,
                                         reportDate DATETIME)                                                
                        
      CREATE INDEX idx_SUUniv_PopID ON #SampleUnit_Universe (Pop_ID)                                      
      CREATE INDEX idx_SUUniv_EncID ON #SampleUnit_Universe (Enc_ID)                    
                                                 
      CREATE TABLE #PreSample (Pop_id INT ,
                               Enc_id INT ,
                               SampleUnit_id INT NOT NULL ,
                               DQ_id INT ,
                               bitBadAddress BIT DEFAULT 0 ,
                               bitBadPhone BIT DEFAULT 0)                                                
      IF @encTableExists = 0 
         ALTER TABLE #PreSample                                    
         DROP COLUMN Enc_id                                                
                 
 --Set Join Variables                                                
      DECLARE @BVJOIN VARCHAR(100) ,
         @PopID_EncID_Join VARCHAR(100) ,
         @POPENCSelect VARCHAR(100) ,
         @PopID_EncID_CreateTable VARCHAR(100) ,
         @PopID_EncID_Select_Aliased VARCHAR(100)                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 4', GETDATE(), ''                          
         END                          
                          
                                                 
      IF @encTableExists = 1 
         BEGIN                                                
            SELECT   @BVJOIN = 'X.Pop_id=BV.POPULATIONPop_id AND X.Enc_id=BV.ENCOUNTEREnc_id'                                                
            SELECT   @PopID_EncID_Join = 'X.Pop_id=Y.Pop_id AND X.Enc_id=Y.Enc_id'                                                
            SELECT   @POPENCSelect = 'Pop_id, Enc_id'                                                
            SELECT   @PopID_EncID_CreateTable = 'Pop_id int, Enc_id int'                                                
            SELECT   @PopID_EncID_Select_Aliased = 'x.Pop_id, x.Enc_id'                                                
         END                            
      ELSE 
         BEGIN                                           
            SELECT   @BVJOIN = 'X.Pop_id=BV.POPULATIONPop_id'                                                
            SELECT   @PopID_EncID_Join = 'X.Pop_id=Y.Pop_id'                                                
            SELECT   @POPENCSelect = 'Pop_id'                                                
            SELECT   @PopID_EncID_CreateTable = 'Pop_id int'                                                
            SELECT   @PopID_EncID_Select_Aliased = 'x.Pop_id'                                                
         END                         
                                                 
 --Identify the encounter date field and daterange                                                
      IF NOT (@FromDate IS NULL
              OR @FromDate = '') 
         BEGIN                                                
            IF @EncounterDateField IS NULL
               AND @encTableExists = 0 
               SET @EncounterDateField = 'populationNewRecordDate'                                                
            ELSE 
               IF @EncounterDateField IS NULL
                  AND @encTableExists = 1 
                  SET @EncounterDateField = 'encounterNewRecordDate'                                                
                                                  
            SELECT   @strDateWhere = ' AND ' + @EncounterDateField + ' BETWEEN ''' + @FromDate + ''' AND '''
                     + CONVERT(VARCHAR, @ToDate) + ' 23:59:59'''                                                
         END                                                
              
 --Add fields to bigview                                                
      IF @encTableExists = 1 
         INSERT   INTO @tbl
         VALUES   ('ENCOUNTEREnc_id', 'I', 4, 0)                                                
                                                 
      INSERT   INTO @tbl
               SELECT DISTINCT
                        strTable_nm + strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
               FROM     CriteriaStmt cs ,
                        CriteriaClause cc ,
                        MetaData_View m
               WHERE    cs.Study_id = @Study_id
                        AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
                        AND cc.Table_id = m.Table_id
                        AND cc.Field_id = m.Field_id
                        AND strTable_nm + strField_nm NOT IN ('EncounterEnc_id', 'POPULATIONPop_id')
               UNION
               SELECT   *
               FROM     @HHFields
               WHERE    FieldName NOT IN ('EncounterEnc_id', 'POPULATIONPop_id')                                                
                                                 
      IF NOT EXISTS ( SELECT  1
                      FROM    @tbl
                      WHERE   FieldName = 'POPULATIONAge' ) 
         INSERT   INTO @tbl
                  SELECT   'POPULATIONAge', 'I', 4, '9999'                                                
      IF NOT EXISTS ( SELECT  1
                      FROM    @tbl
                      WHERE   FieldName = @EncounterDateField )
         AND @EncounterDateField IS NOT NULL 
         INSERT   INTO @tbl
                  SELECT   @EncounterDateField, 'D', 4, '9999'                                                
      IF NOT EXISTS ( SELECT  1
                      FROM    @tbl
            WHERE   FieldName = @reportDateField )
         AND @reportDateField IS NOT NULL 
         INSERT   INTO @tbl
                  SELECT   @reportDateField, 'D', 4, '9999'                                                
      CREATE TABLE #BVUK (POPULATIONPop_id INT)                                                
                                                 
 --Add fields to bigview                                                
      SET @sel = 'ALTER TABLE #BVUK ADD ,'                                                
                                                 
      SELECT   @sel = @sel + ',' + FieldName + ' ' + CASE DataType
                                                       WHEN 'I' THEN 'INT '
                                                       WHEN 'D' THEN 'DATETIME '
                                                       ELSE 'VARCHAR(' + CONVERT(VARCHAR, Length) + ')'
                                                     END
      FROM     @tbl
      ORDER BY Field_id                                                
      SET @sel = REPLACE(@sel, ',,', '')                                                
                                                 
      EXEC (@Sel)                                                
                      
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 5', GETDATE(), ''                          
         END                          
                          
                                                 
 --Add HH fields to #sampleunitUniverse                                                
      IF EXISTS ( SELECT TOP 1
                           *
                  FROM     @HHFields ) 
         BEGIN                                                
            SET @sel = 'ALTER TABLE #SampleUnit_Universe ADD ,'                                    
                                                 
            SELECT   @sel = @sel + ',' + FieldName + ' ' + CASE DataType
                                                             WHEN 'I' THEN 'INT '
                                                             WHEN 'D' THEN 'DATETIME '
                                                             ELSE 'VARCHAR(' + CONVERT(VARCHAR, Length) + ')'
                                                           END
            FROM     @HHFields
            ORDER BY Field_id                                                
            SET @sel = REPLACE(@sel, ',,', '')                                                
                                      
            IF @indebug = 1 
               PRINT @sel                                                 
            EXEC (@Sel)     
         END                                                
                                                 
                                                 
      IF @encTableExists = 1 
         CREATE INDEX popenc ON #BVUK (Populationpop_id, EncounterEnc_id)                                                
      ELSE 
         CREATE INDEX Populationpop_id ON #BVUK (Populationpop_id)                                       
                                                 
      CREATE TABLE #Criters (Survey_id INT ,
                             CriteriaStmt_id INT ,
                             strCriteriaStmt VARCHAR(7900) ,
                             BusRule_cd VARCHAR(20))                                                        
                                      
      IF @indebug = 1 
         PRINT 'insert DQ Rules into #criters'                         
      INSERT   INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)
               SELECT   Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
               FROM     CriteriaStmt c ,
                        BusinessRule b
               WHERE    c.CriteriaStmt_id = b.CriteriaStmt_id
                        AND c.Study_id = @Study_id
                        AND BusRule_cd = 'Q'
                        AND Survey_id = @Survey_id                                                
                                      
      IF @indebug = 1 
         PRINT 'insert C Rules into #criters'                                                 
      INSERT   INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)
               SELECT   Survey_id, c.CriteriaStmt_id, strCriteriaString, 'C'
               FROM     CriteriaStmt c ,
                        SampleUnit su ,
                        Sampleplan sp
               WHERE    c.CriteriaStmt_id = su.CriteriaStmt_id
                        AND c.Study_id = @Study_id
                        AND su.Sampleplan_id = sp.Sampleplan_id
                        AND Survey_id = @Survey_id                                                
                                      
      IF @indebug = 1 
         PRINT 'insert F and A (bad Addr) Rules into #criters'                                                 
 --Add the bad address and bad phone criterias                                                
      INSERT   INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)
               SELECT   Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
               FROM     CriteriaStmt c ,
                        BusinessRule b
               WHERE    c.CriteriaStmt_id = b.CriteriaStmt_id 
                        AND c.Study_id = @Study_id
                        AND BusRule_cd IN ('F', 'A')
                        AND Survey_id = @Survey_id                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 6', GETDATE(), ''                          
         END                
                          
                                                 
      DECLARE @Tables TABLE (tablename VARCHAR(40))                                                
      INSERT   INTO @Tables
               SELECT DISTINCT
                        strTable_nm
               FROM     MetaTable
               WHERE    Study_id = @Study_id                                                
                                                 
      SELECT TOP 1
               @sel = tablename
      FROM     @tables                                                
      WHILE @@ROWCOUNT > 0 
         BEGIN                                                
                              
            DELETE   @tables
            WHERE    tablename = @sel                                                
                                               
            SET @sel = 'UPDATE #Criters SET strCriteriaStmt=REPLACE(strCriteriaStmt,''' + @sel + '.'',''' + @sel + ''')'                                                
            IF @indebug = 1 
               PRINT @sel                                      
            EXEC (@Sel)                                                
                                                  
            SELECT TOP 1
                     @sel = tablename
            FROM     @tables                                                
                                                 
         END                               
                                                 
      UPDATE   #Criters
      SET      strCriteriaStmt = REPLACE(strCriteriaStmt, '"', '''')                        
                        
                                                 
      DECLARE @Criteria VARCHAR(7900)                                                
                                                 
 --Loop thru one Survey at a time                                                
 --Get the SampleUnit order                                       
      CREATE TABLE #SampleUnits (SampleUnit_id INT ,
                                 ParentSampleUnit_id INT ,
                                 CriteriaStmt_id INT ,
                                 intTier INT ,
                                 strNode VARCHAR(255) ,
                                 intTreeOrder INT ,
                                 Survey_id INT)                                                
                                                 
 -- SP_Samp_ReOrgSampleUnits 388                                   
      INSERT   INTO #SampleUnits
               EXEC QCL_SampleSetReOrgSampleUnits @Survey_id                                                
                                                 
 --need two loops                                                 
 --loop the actual Criteria Stmts to assign people to Units                                                
      SELECT TOP 1
               @SampleUnit = SampleUnit_id
      FROM     #SampleUnits
      ORDER BY intTreeOrder                                                
      WHILE @@ROWCOUNT > 0 
         BEGIN                                                
                            
            SELECT   @ParentSampleUnit = ParentSampleUnit_id
            FROM     #SampleUnits
            WHERE    SampleUnit_id = @SampleUnit                                                
            SELECT   @Criteria = strCriteriaStmt
            FROM     #SampleUnits su ,
                     #Criters c
            WHERE    SampleUnit_id = @SampleUnit
                     AND su.CriteriaStmt_id = c.CriteriaStmt_id                                                
                                                 
            IF @SamplingLogInsert = 1 
               BEGIN                          
                  INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                           SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 7', GETDATE(), ''                          
               END                          
                          
                                                 
            IF @ParentSampleUnit IS NULL 
               BEGIN                                                
                  IF @encTableExists = 1 
                     BEGIN               
                        SELECT   @Sel = 'b.Populationpop_id, b.EncounterEnc_id'                                                
                        SELECT   @Sql = 'Populationpop_id, EncounterEnc_id'                                                
                     END                                             
                  ELSE 
                     BEGIN                                                
                        SELECT   @Sel = 'b.Populationpop_id'                                                
                        SELECT   @Sql = 'Populationpop_id'                                                
                     END                                                
                                                   
   --build the SELECT list                                                
                  SELECT   @sel = @sel + ',' + Fieldname
                  FROM     @tbl
                  WHERE    Fieldname NOT IN ('Populationpop_id', 'EncounterEnc_id')
                  ORDER BY Field_id                                                
                                                 
   --build the INSERT list                     
                  SELECT   @sql = @sql + ',' + Fieldname
                  FROM     @tbl
                  WHERE    Fieldname NOT IN ('Populationpop_id', 'EncounterEnc_id')
                  ORDER BY Field_id                                                
                                                  
                  IF @encTableExists = 1                                                
    --build the temp table.                                                
                     SET @Sel = 'INSERT INTO #BVUK(' + @Sql + ')                                                
								  SELECT ' + @Sel + '                                                
								  FROM s' + CONVERT(VARCHAR, @Study_id)
														+ '.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t                            
								  WHERE dsm.DataSet_id=t.DataSet_id                                                
								  AND dsm.Enc_id=b.EncounterEnc_id                                                
								  AND (' + @Criteria + ')' + @strDateWhere                                                
                  ELSE 
                     SET @Sel = 'INSERT INTO #BVUK(' + @Sql + ')                                                
								  SELECT ' + @Sel + '                                                
								  FROM s' + CONVERT(VARCHAR, @Study_id)
														+ '.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t                                                
								  WHERE dsm.DataSet_id=t.DataSet_id                        
								  AND dsm.Pop_id=b.PopulationPop_id                                                
								  AND (' + @Criteria + ')' + @strDateWhere                                                
                                         
                  IF @indebug = 1 
                     PRINT @sel                                      
                  EXEC (@Sel)                                                
                                                 
                  IF @encTableExists = 0 
                     SET @sel = 'INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)                                                
								  SELECT Populationpop_id,' + CONVERT(VARCHAR, @SampleUnit) + ',0                                                
								  FROM #bvuk b                                                
								  WHERE (' + @Criteria + ')'                                                
                  ELSE 
                     SET @sel = 'INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)                                                
								  SELECT Populationpop_id,EncounterEnc_id,' + CONVERT(VARCHAR, @SampleUnit) + ',0                         
								  FROM #bvuk b             
								  WHERE (' + @Criteria + ')'                                                
               END                                           
            ELSE 
               BEGIN                                                
                  IF @encTableExists = 0 
                     SET @sel = 'INSERT INTO #PreSample (Pop_id,SampleUnit_id,DQ_id)                                                
								  SELECT b.Populationpop_id,' + CONVERT(VARCHAR, @SampleUnit) + ',0                                                
								  FROM #bvuk b, #PreSample p                                                
								  WHERE p.SampleUnit_id=' + CONVERT(VARCHAR, @ParentSampleUnit) + '                                            
								  AND p.Pop_id=b.Populationpop_id                                      
								  AND (' + @Criteria + ')'                                                
                  ELSE 
                     SET @sel = 'INSERT INTO #PreSample (Pop_id,Enc_id,SampleUnit_id,DQ_id)                                                
								  SELECT b.Populationpop_id,b.EncounterEnc_id,' + CONVERT(VARCHAR, @SampleUnit)
														+ ',0                                                
								  FROM #bvuk b, #PreSample p                                                
								  WHERE p.SampleUnit_id=' + CONVERT(VARCHAR, @ParentSampleUnit) + '                                                
								  AND p.Enc_id=b.EncounterEnc_id                                                
								  AND (' + @Criteria + ')'                                                
               END                                      
                                              
            IF @indebug = 1 
               PRINT @sel                                          
            EXEC (@Sel)                      
                          
            IF @SamplingLogInsert = 1 
               BEGIN                          
                  INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                           SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 8', GETDATE(), ''                          
               END                          
                          
                                                  
            DELETE   c
            FROM     #SampleUnits su ,
                     #Criters c
            WHERE    SampleUnit_id = @SampleUnit
                     AND su.CriteriaStmt_id = c.CriteriaStmt_id                                                
            DELETE   #SampleUnits
            WHERE    SampleUnit_id = @SampleUnit                           
            SELECT TOP 1
                     @SampleUnit = SampleUnit_id
            FROM     #SampleUnits
            ORDER BY intTreeOrder                                                
                     
         END                                                
                                                 
      DROP TABLE #SampleUnits                                                
                  
 --Remove Records that can't be sampled and update the counts in SPW if                                                
 --it is not a census sample                                           
      IF @SamplingMethod <> 3 
         BEGIN                                                
            CREATE INDEX Pop_id ON #PRESAMPLE (Pop_id)                                                
                                                 
 --MWB 9/23/08  HCAHPS Prop Sampling Sprint -- added or (s.bitHCAHPS = 1 and s.dontsampleunit =0))                                              
 --b/c HCAHPS unit may now have a target of 0 b/c we are using prop sampling instead of old method.                                              
            SELECT   Pop_id
            INTO     #SampleAble
            FROM     #PreSample p ,
                     sampleunit s
            WHERE    p.sampleunit_id = s.sampleunit_id
                     AND (s.inttargetReturn > 0
                          OR (s.bitHCAHPS = 1
                              AND s.dontsampleunit = 0))
            GROUP BY Pop_id
            HAVING   COUNT(*) > 0                  
                       
                  
  --Remove pops not eligible for any targeted units                                           
            SELECT   p.Sampleunit_id, p.Pop_id
            INTO     #UnSampleAble
            FROM     #PreSample p
            LEFT JOIN #SampleAble s ON p.Pop_id = s.Pop_id
            WHERE    s.Pop_id IS NULL                                                
                                                 
            DELETE   p
            FROM     #PreSample p ,
                     #UnSampleAble u
            WHERE    p.Pop_id = u.Pop_id                                    
                                                 
  --Update the Universe count in SPW                                                 
            UPDATE   spw
            SET      IntUniverseCount = ISNULL(IntUniverseCount, 0) + freq
            FROM     SamplePlanWorkSheet spw ,
                     (SELECT  sampleunit_id, COUNT(*) AS freq
                      FROM    #UnSampleAble
                      GROUP BY sampleunit_id) u
            WHERE    spw.sampleunit_id = u.sampleunit_id
                     AND spw.sampleset_id = @sampleSet_id                           
                                                 
         END                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 9', GETDATE(), ''                          
         END                          
                          
                                                 
 --Evaluate the DQ rules                                                
      SELECT TOP 1
               @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
      FROM     #Criters
      WHERE    BusRule_cd = 'Q'
      ORDER BY CriteriaStmt_id                                                
      WHILE @@ROWCOUNT > 0 
         BEGIN                                                
                                                                                                  
            IF @encTableExists = 0 
               BEGIN                                               
                  SELECT   @Sel = 'UPDATE p                                                
								   SET DQ_id=' + CONVERT(VARCHAR, @DQ_id) + '                                                
								   FROM #PreSample p, #BVUK b                                                
								   WHERE p.Pop_id=b.Populationpop_id                                                
								   AND (' + @Criteria + ')                                                
								   AND DQ_id=0'                                                
                                         
                  IF @indebug = 1 
                     PRINT @sel                                        
                  EXEC (@Sel)                                          
                                           
                  SELECT   @Sel = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,SamplingExclusionType_ID,DQ_BusRule_ID)                                          
								   Select ' + CAST(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, ' + CAST(@Sampleset_ID AS VARCHAR(10))
									+ ' as Sampleset_ID, Sampleunit_ID, Pop_ID,  4 as SamplingExclusionType_ID, '
									+ CONVERT(VARCHAR, @DQ_id) + ' as DQ_BusRule_ID                               
								   FROM #PreSample p, #BVUK b                                  
								   WHERE p.Pop_id=b.Populationpop_id                                                
								   AND (' + @Criteria + ')'                                                
                                         
                  IF @indebug = 1 
                     PRINT @sel                                        
                  EXEC (@Sel)                                          
               END                              
            ELSE 
               BEGIN                                          
                  SELECT   @Sel = 'UPDATE p                                                
								   SET DQ_id=' + CONVERT(VARCHAR, @DQ_id) + '                                                
								   FROM #PreSample p, #BVUK b                                                
								   WHERE p.Pop_id=b.Populationpop_id                                                 
								   AND p.Enc_id=b.EncounterEnc_id                                                
								   AND (' + @Criteria + ')                                                
								   AND DQ_id=0'                                                
                  EXEC (@Sel)                                          
                                           
                  SELECT   @Sel = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)                                          
								   Select ' + CAST(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, ' + CAST(@Sampleset_ID AS VARCHAR(10))
								   + ' as Sampleset_ID, Sampleunit_ID, Pop_ID, Enc_ID, 4 as SamplingExclusionType_ID, '
								   + CONVERT(VARCHAR, @DQ_id) + ' as DQ_BusRule_ID                                  
								   FROM #PreSample p, #BVUK b                                                
								   WHERE p.Pop_id=b.Populationpop_id                                                 
								   AND p.Enc_id=b.EncounterEnc_id                                                
								   AND (' + @Criteria + ')'                                                
                  IF @indebug = 1 
                     PRINT @sel                                              
                  EXEC (@Sel)                                  
               END                                          
                          
                          
            IF @SamplingLogInsert = 1 
               BEGIN                          
                  INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                           SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 10', GETDATE(), ''                          
               END                          
                                            
                                                 
            DELETE   #Criters
            WHERE    CriteriaStmt_id = @DQ_id                                                
                                                 
            SELECT TOP 1
                     @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
            FROM     #Criters
            WHERE    BusRule_cd = 'Q'
            ORDER BY CriteriaStmt_id                                                
                                                 
         END   -- End While Evaluate the DQ rules  
		 

		 -- Update SampleSet.IneligibleCount  Sprint 18 US16  -- update IneligibleCount column in SampleSet table
		select cs.CRITERIASTMT_ID, cs.STRCRITERIASTMT_NM
		INTO #CRITERIASTMT
		from CRITERIASTMT cs
		where cs.STUDY_ID = @Study_ID

		UPDATE SampleSet
			SET IneligibleCount = b.[Count]
		FROM (
			SELECT count(*) 'Count'
			FROM (select distinct Sampleset_ID, Pop_ID
				from Sampling_ExclusionLog sel
				INNER JOIN #CRITERIASTMT cs on (cs.CRITERIASTMT_ID = sel.DQ_BusRule_ID) 
				where Sampleset_ID = @sampleset_Id) a 
			GROUP BY a.Sampleset_ID ) b
		WHERE Sampleset_ID = @sampleset_Id
		                                            
                                                 
 --Evaluate the Bad Address                                                 
      SELECT TOP 1
               @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
      FROM     #Criters
      WHERE    BusRule_cd = 'A'
      ORDER BY CriteriaStmt_id                                                
      WHILE @@ROWCOUNT > 0 
         BEGIN                                                
                                                                                              
            IF @encTableExists = 0 
               SELECT   @Sel = 'UPDATE p                           
							   SET bitBadAddress=1                                                
							   FROM #PreSample p, #BVUK b                                                
							   WHERE p.Pop_id=b.Populationpop_id                                                
							   AND (' + @Criteria + ')                               
							   AND DQ_id=0'                                                
            ELSE 
               SELECT   @Sel = 'UPDATE p                                                
							   SET bitBadAddress=1                                                
							   FROM #PreSample p, #BVUK b                                                
							   WHERE p.Pop_id=b.Populationpop_id                                                 
							   AND p.Enc_id=b.EncounterEnc_id                                                
							   AND (' + @Criteria + ')                                                
							   AND DQ_id=0'                                      
                                         
            IF @indebug = 1 
               PRINT @sel                                                 
            EXEC (@Sel)        
                                                 
            DELETE   #Criters
            WHERE    CriteriaStmt_id = @DQ_id                                                
                                                 
            SELECT TOP 1
                     @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
            FROM     #Criters
            WHERE    BusRule_cd = 'A'
            ORDER BY CriteriaStmt_id                                                
                                                 
         END                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 11', GETDATE(), ''                          
         END                          
                                                 
                                                 
 --Evaluate the Bad Phone rules                                                
      SELECT TOP 1
               @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
      FROM     #Criters
      WHERE    BusRule_cd = 'F'
      ORDER BY CriteriaStmt_id                                                
      WHILE @@ROWCOUNT > 0 
         BEGIN                                                
                                           --This needs to be an update statement, not an insert statement.                                                  
            IF @encTableExists = 0 
               SELECT   @Sel = 'UPDATE p                                                
							   SET bitBadPhone=1                                                
							   FROM #PreSample p, #BVUK b                                                
							   WHERE p.Pop_id=b.Populationpop_id                                                
							   AND (' + @Criteria + ')                                                
							   AND DQ_id=0'                                                
            ELSE 
               SELECT   @Sel = 'UPDATE p                                                
							   SET bitBadPhone=1                                                
							   FROM #PreSample p, #BVUK b                                                
							   WHERE p.Pop_id=b.Populationpop_id                                                 
							   AND p.Enc_id=b.EncounterEnc_id                                                
							   AND (' + @Criteria + ')                                 
							   AND DQ_id=0'                                       
                                         
            IF @indebug = 1 
               PRINT @sel                                               
            EXEC (@Sel)                                                
                                                 
            DELETE   #Criters
            WHERE    CriteriaStmt_id = @DQ_id                              
                                                 
            SELECT TOP 1
                     @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
            FROM     #Criters
            WHERE    BusRule_cd = 'F'
            ORDER BY CriteriaStmt_id                                                
                                                 
         END                                                

      IF @encTableExists = 0 
         SET @Sel = 'INSERT INTO #SampleUnit_Universe                                                 
					  SELECT DISTINCT SampleUnit_id, ' + 'x.pop_id, null as enc_ID, POPULATIONAge, DQ_ID, '
								+ 'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '
								+ CASE WHEN @EncounterDateField IS NOT NULL THEN @EncounterDateField
									   ELSE 'null'
								  END
								+ ', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone,                                            
					  ' + CASE WHEN @reportDateField IS NOT NULL THEN @reportDateField
							   ELSE 'null'
      END                                                 
      ELSE 
         SET @Sel = 'INSERT INTO #SampleUnit_Universe                         
					  SELECT DISTINCT SampleUnit_id, ' + 'x.pop_id, x.enc_id, POPULATIONAge, DQ_ID, '
								+ 'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', '
								+ CASE WHEN @EncounterDateField IS NOT NULL THEN @EncounterDateField
									   ELSE 'null'
								  END
								+ ', null as resurveyDate, null as household_id, bitBadAddress, bitBadPhone,                                                 
					  ' + CASE WHEN @reportDateField IS NOT NULL THEN @reportDateField
							   ELSE 'null'
      END                                                 
                                                   
      IF @HouseHoldingType <> 'N' 
         SET @Sel = @Sel + +', ' + REPLACE(@HouseHoldFieldSelectSyntax, 'X.', 'BV.')                                                
      SET @Sel = @Sel + ' FROM #PreSample X, #BVUK BV ' + 'WHERE ' + @BVJOIN                                                 
                            
      SET @Sel = @Sel + ' ORDER BY SampleUnit_id, ' + @PopID_EncID_Select_Aliased                                              
                                       
      IF @indebug = 1 
         PRINT @sel                                      
      EXEC (@Sel)                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 12', GETDATE(), ''                          
         END                          
                          
                                                 
      DECLARE @CutOffCode INT ,
         @SampleDate DATETIME                                
      SELECT   @CutOffCode = strCutOffResponse_cd, @SampleDate = datSampleCreate_dt
      FROM     dbo.Survey_def SD ,
               dbo.SampleSet SS
      WHERE    SD.Survey_id = SS.Survey_id
               AND SS.SampleSet_id = @SampleSet_id                                                
                                                    
 --Update ReportDate in SelectedSample for the sampleset if sampled date is the report date                                                
      IF @CutOffCode = 0 
         UPDATE   #SampleUnit_Universe
         SET      ReportDate = @SampleDate                                                
                                      
      IF @indebug = 1 
         PRINT 'calling QCL_SampleSetIndexUniverse'                                               
      EXEC QCL_SampleSetIndexUniverse @encTableExists                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 13', GETDATE(), ''                          
         END                          
                                  
                                  
 --MWB 04/08/2010                                    
 --If SurveyType = HHCAHPS need to capture the distinct count of pop_IDs that fit the HHCAHPS Unit                                  
 --and save it off to new table.                                  
      IF @SurveyType_ID in (@HHCAHPS, @hospiceCAHPS,  @OASCAHPS) -- 02/4/2016 TSB  S42 US12: added OAS
         BEGIN                                  
           INSERT INTO CAHPS_PatInfileCount (Sampleset_ID, Sampleunit_ID, MedicareNumber, NumPatInFile)
                     SELECT   @sampleSet_id, suni.SampleUnit_id, ml.MedicareNumber, COUNT(DISTINCT suni.Pop_id)
                     FROM     #SampleUnit_Universe suni ,
                              SAMPLEUNIT su ,
                              MedicareLookup ml ,
                              SUFacility f
                     WHERE    suni.SampleUnit_id = su.SAMPLEUNIT_ID
                              AND su.SUFacility_id = f.SUFacility_id
                              AND f.MedicareNumber = ml.MedicareNumber
                              AND su.CAHPSType_id in (@HHCAHPS, @hospiceCAHPS,@OASCAHPS)
                     GROUP BY suni.SampleUnit_id, ml.MedicareNumber                                               
         END                                   
                                                 
 --MWB 9/2/08  HCAHPS Prop Sampling Sprint -- run TOCL before writing HCAHPSEligibleEncLog table                                               
      IF @bitDoTOCL = 1 
         BEGIN                                      
            IF @indebug = 1 
               PRINT 'calling QCL_SampleSetTOCLRule'                                   
            EXEC QCL_SampleSetTOCLRule @study_id, @Survey_id, @sampleSet_id, 1                                          
         END                                          
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 14', GETDATE(), ''                          
         END                          
                          
                                              
 --MWB 9/2/08  HCAHPS Prop Sampling Sprint -- Exclude encounters already sampled.  Fix of existing bug                                              
      IF @indebug = 1 
         PRINT 'calling QCL_RemovePreviousSampledEncounters'                                      
      EXEC QCL_RemovePreviousSampledEncounters @study_id, @Survey_id, @sampleSet_id                                                
                          
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 15', GETDATE(), ''                          
         END                          
                  
 /******moved this code later, after resurvey and householding occurs 4/19/2012 dmp *****/            
             
                  
 ----Save off all of the eligible encounters.  We don't want to save anyone who was DQ'd.                                                
 ----However, we do want to save encounters even if the fail newborn, householding, resurvey etc.                                                
 ----Therefore, we must save before checking newborn, householding, resurvey etc.                  
                                        
 --INSERT INTO HCAHPSEligibleEncLog (sampleset_id, sampleunit_id, pop_Id, enc_id, sampleEncounterDate)                                                
 --SELECT distinct @sampleset_Id, su.sampleunit_id, pop_Id, enc_id, EncDate                                                
 --FROM #SampleUnit_Universe su, sampleunit s                                                
 --WHERE Removed_Rule=0                                                
 -- AND su.sampleunit_id=s.sampleunit_id                                      
 -- AND s.bitHCAHPS=1                             
                                                        
 -- if @SamplingLogInsert = 1                          
 -- BEGIN                          
 --    insert into SamplingLog (SampleSet_id, StepName, Occurred,SQLCode)                          
 --  Select @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 16', GETDATE(), ''                          
 -- END            
                                                 
                                                 
 --NewBorn rule                                                
      SELECT   @newbornRule = REPLACE(CONVERT(VARCHAR(7900), strCriteriaString), '"', '''')
      FROM     criteriastmt c ,
               businessrule br
      WHERE    c.criteriastmt_id = br.criteriastmt_id
               AND c.study_id = @study_id
               AND br.survey_id = @Survey_id
               AND BusRule_cd = 'B'                                                
                          
                          
                                                 
      IF @newbornRule IS NOT NULL 
         EXEC QCL_SampleSetNewbornRule @study_id, @BVJOIN, @newbornRule, @Survey_id, @sampleSet_id                                                  
                                                 
                                              
      IF @indebug = 1 
         PRINT 'calling QCL_SampleSetAssignHouseHold'                                                 
      EXEC QCL_SampleSetAssignHouseHold @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax,
         @HouseHoldJoinSyntax, @HouseHoldingType                                           
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 17', GETDATE(), ''                          
         END                     
                          
                                                 
      IF @indebug = 1 
         PRINT 'calling QCL_SampleSetResurveyExclusion_StaticPlus'                                                 
 -- Apply the resurvey exclusion rule                                                
      EXEC QCL_SampleSetResurveyExclusion_StaticPlus @study_id, @Survey_id, @resurveyMethod_id, @ReSurvey_Period,
         @samplingAlgorithmId, @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax, @HouseHoldJoinSyntax,
         @HouseHoldingType, @sampleSet_id, @indebug                                             
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 18', GETDATE(), ''                          
         END                          
            
--adding check for HCAHPS survey type 4/24/2012 dmp            
      IF @SurveyType_ID = 2 
         BEGIN            
            
 --DRM 3/19/2012 Householding            
            IF @indebug = 1 
               BEGIN        
                  PRINT 'calling QCL_SampleSetHouseholdingExclusion'                                                 
                  PRINT '@study_id: ' + CAST(@study_id AS VARCHAR)        
                  PRINT '@Survey_id: ' + CAST(@Survey_id AS VARCHAR)        
                  PRINT '@startdate: ' + CAST(@startdate AS VARCHAR)        
                  PRINT '@enddate: ' + CAST(@enddate AS VARCHAR)        
                  PRINT '@HouseHoldFieldCreateTableSyntax: ' + @HouseHoldFieldCreateTableSyntax         
                  PRINT '@HouseHoldFieldSelectSyntax: ' + @HouseHoldFieldSelectSyntax         
                  PRINT '@HouseHoldJoinSyntax: ' + @HouseHoldJoinSyntax         
                  PRINT '@HouseHoldingType: ' + @HouseHoldingType         
                  PRINT '@sampleSet_id: ' + CAST(@sampleSet_id AS VARCHAR)        
               END        
            EXEC QCL_SampleSetHouseholdingExclusion @study_id, @Survey_id, @startdate, @enddate,
               @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax, @HouseHoldJoinSyntax, @HouseHoldingType,
               @sampleSet_id, @indebug              
         END               
          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 19A', GETDATE(), ''                    
         END                                    
          
            
 --DRM 3/19/2012 Householding            
      IF @indebug = 1 
         PRINT 'calling QCL_SampleSetPerformHousehold'                                                 
      EXEC QCL_SampleSetPerformHousehold @survey_id, @sampleset_id               
            
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 19B', GETDATE(), ''                    
         END            
            
             
 /******            
 Moved eligible enc log insert after resurvey and householding 4/19 dmp            
 ******/            
             
  --Save off all of the eligible encounters.  We don't want to save anyone who was DQ'd.                                                
 --However, we do want to save encounters even if the fail newborn, householding, resurvey etc.                                                
 --Therefore, we must save before checking newborn, householding, resurvey etc.                  
             
 /***TESTING CODE Comment out in stage or prod ************/            
             
 --create table dmp_test_eligibleenclog (sampleset_id int, sampleunit_id int, pop_id int, enc_id int, sampleencounterdate datetime)            
 --insert into dmp_test_eligibleenclog (sampleset_id, sampleunit_id, pop_Id, enc_id, sampleEncounterDate)                                                
 --SELECT distinct @sampleset_Id, su.sampleunit_id, pop_Id, enc_id, EncDate                                                
 --FROM #SampleUnit_Universe su, sampleunit s                                                
 --WHERE Removed_Rule=0                                                
 -- AND su.sampleunit_id=s.sampleunit_id                                  f    
 -- AND s.bitHCAHPS=1                             
             
 /***END TESTING CODE******************************************************/            
 
 --mwb 12/22/09  adding this update b/c with nursing home change a record can be marked                                           
--in a household (IE live in a nursing home) but not be given a removed_rule = 7                               
--App code looks at household_ID and will household regardless of removed_rule status.                         
-- -7 is the anti-householding ID value.  It is never written to the sampling_exclusionLog   

--Modified by Lee Kohrs 2013-04-24 This segment was previously located after all of the 
--inserts to HCAHPSEligibleEncLog.  Nursing home residents are eligible (not housholded)
--per HCAHPS QAG. So this code was moved here.
                                                 
      UPDATE   #SampleUnit_Universe
      SET      HouseHold_id = NULL, Removed_Rule = 0
      WHERE    Removed_Rule = -7      
                                        

	  if @SurveyType_ID in (@HCAHPS,@HHCAHPS,@HospiceCAHPS, @CIHI, @OASCAHPS)  -- Added CIHI S17 US23 , OASCAHPS S42 US12
	  BEGIN

		INSERT   INTO EligibleEncLog (sampleset_id, sampleunit_id, pop_Id, enc_id, sampleEncounterDate, SurveyType_ID)
               SELECT DISTINCT
                        @sampleset_Id, su.sampleunit_id, pop_Id, enc_id, EncDate,s.CAHPSType_id
               FROM     #SampleUnit_Universe su ,
                        sampleunit s
               WHERE    Removed_Rule = 0
                        AND su.sampleunit_id = s.sampleunit_id
                        AND s.CAHPSType_id = @SurveyType_ID                               

--------------9/10/2014 CJB Adding code to populate number inserted into HCAHPSEligibleEncLog into HcahpsEligibleEncLogCount in SPW
		--Update the EncLog count in SPW                                                 
		 declare @HcahpsEligibleEncLogCount int = 0

		select @HcahpsEligibleEncLogCount = count(*) 
            FROM     SamplePlanWorkSheet spw,
					 EligibleEncLog eec
                     WHERE spw.sampleset_id = @sampleSet_id
					 and spw.SampleUnit_id = eec.sampleunit_id 
					 and spw.sampleset_id = eec.sampleset_id
					 and eec.SurveyType_id = @HCAHPS

			UPDATE   spw
			SET      HcahpsEligibleEncLogCount = @HcahpsEligibleEncLogCount
			FROM     SamplePlanWorkSheet spw,
					 sampleunit s
			WHERE	 spw.sampleset_id = @sampleSet_id
				AND  spw.SampleUnit_id = s.SAMPLEUNIT_ID 
				AND  s.CAHPSType_id = @HCAHPS
	   END

--------------9/10/2014 
                                                        
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 16', GETDATE(), ''                          
         END                          
                                                                              
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 19', GETDATE(), ''                    
         END                          
                          
--Modified by Lee Kohrs 2013-04-24 This segment was previously located here, after all of the 
--inserts to HCAHPSEligibleEncLog.  Nursing home residents are eligible (not housholded)
--per HCAHPS QAG. So this code was moved to a location prior to the inserts to HCAHPSEligibleEncLog  
--
--
----mwb 12/22/09  adding this update b/c with nursing home change a record can be marked                                           
----in a household (IE live in a nursing home) but not be given a removed_rule = 7                                          
----App code looks at household_ID and will household regardless of removed_rule status.                                          
---- -7 is the anti-householding ID value.  It is never written to the sampling_exclusionLog  

--      UPDATE   #SampleUnit_Universe
--      SET      HouseHold_id = NULL, Removed_Rule = 0
--      WHERE    Removed_Rule = -7                                           
                                                                               
 --Remove People that have a removed rule other than 0 or 4(DQ)                                                
      DECLARE @RemovedRule INT ,
         @unit INT ,
         @freq INT ,
         @RuleName VARCHAR(8)                                                
                                                 
      SELECT   sampleunit_Id, Removed_Rule, COUNT(*) AS freq
      INTO     #UnSampleAbleRR
      FROM     #SampleUnit_Universe
      WHERE    Removed_Rule NOT IN (0, 4)
      GROUP BY sampleunit_Id, Removed_Rule                                                
                                          
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 20', GETDATE(), ''                          
         END                          
                                          
      IF @indebug = 1 
         BEGIN                             
--Testing code only.                                          
--should be commented out when in stage or prod.                                          
            SET @sql = '                                          
 if exists (select 1 from sysobjects where name = ''mb_samplingUniverse_' + CAST(@sampleset_Id AS VARCHAR(10))
               + ''')                                          
 begin                                           
 drop table mb_samplingUniverse_' + CAST(@sampleset_Id AS VARCHAR(10)) + '                                          
 end                                          
                                           
 Select *                                          
 into mb_samplingUniverse_' + CAST(@sampleset_Id AS VARCHAR(10)) + '                                          
 from #SampleUnit_Universe'                                          
                                           
            IF @indebug = 1 
               PRINT @sql                                          
            IF @indebug = 1 
               EXEC (@SQL)                                          
                           
 --Testing code only.                                
--should be commented out when in stage or prod.           
            SET @sql = '                                          
 if exists (select 1 from sysobjects where name = ''mb_sampling_UnSampleAbleRR_' + CAST(@sampleset_Id AS VARCHAR(10))
               + ''')                                          
 begin                                           
 drop table mb_sampling_UnSampleAbleRR_' + CAST(@sampleset_Id AS VARCHAR(10))
               + '                                          
end                                          
                                           
 Select *                                          
 into mb_sampling_UnSampleAbleRR_' + CAST(@sampleset_Id AS VARCHAR(10)) + '                                          
 from #UnSampleAbleRR'                                          
                                           
            IF @indebug = 1 
               PRINT @sql                                          
            IF @indebug = 1 
               EXEC (@SQL)                                          
         END                                          
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 21', GETDATE(), ''                          
         END                          
                                           
                                                 
      DELETE   FROM #SampleUnit_Universe
      WHERE    Removed_Rule NOT IN (0, 4)                                                
                                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 22', GETDATE(), ''                          
         END                          
                                           
                                                 
 --Update the Universe count in SPW                                                 
      SELECT TOP 1
               @RemovedRule = Removed_Rule, @unit = sampleunit_Id, @freq = freq
      FROM     #UnSampleAbleRR                                                
                      
      WHILE @@ROWCOUNT > 0 
         BEGIN                                                
                                                  
  --IF @RemovedRule=1 SET @RuleName='Resurvey'                                                
  --IF @RemovedRule=2 SET @RuleName='NewBorn'                                                
  --IF @RemovedRule=3 SET @RuleName='TOCL'                                                
  --IF @RemovedRule=4 SET @RuleName='DQRule'                                                
  --IF @RemovedRule=5 SET @RuleName='ExcEnc'                                                
  --IF @RemovedRule=6 SET @RuleName='HHMinor'                                                
  --IF @RemovedRule=7 SET @RuleName='HHAdult'                                                
  --IF @RemovedRule=8 SET @RuleName='SSRemove'                                                
  --IF @RemovedRule=9 SET @RuleName='DupEnc'   --MWB 9/2/08  HCAHPS Prop Sampling Sprint                                              
                                            
            SELECT   @RuleName = SamplingExclusionType_nm
            FROM     SamplingExclusionTypes
            WHERE    SamplingExclusionType_ID = @RemovedRule                                          
                                           
            IF @indebug = 1 
               PRINT 'calling QCL_InsertRemovedRulesIntoSPWDQCOUNTS'                                          
            EXEC QCL_InsertRemovedRulesIntoSPWDQCOUNTS @sampleset_Id, @unit, @RuleName, @freq                                                
                                                 
            DELETE   FROM #UnSampleAbleRR
            WHERE    Removed_Rule = @removedRule
                     AND sampleunit_Id = @unit                                                
                                                 
            SELECT TOP 1
                     @RemovedRule = Removed_Rule, @unit = sampleunit_Id, @freq = freq
            FROM     #UnSampleAbleRR                                                
         END                                                
                          
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - Marker 23', GETDATE(), ''                          
         END                          
             
               
                                                 
 --Randomize file by Pop_id                                                 
      CREATE TABLE #randomPops (Pop_id INT ,
                                numrandom INT)                                                
                                                 
      INSERT   INTO #randomPops
               SELECT   Pop_id, numrandom
               FROM     (SELECT  MAX(id_num) AS id_num, Pop_id
                         FROM    #SampleUnit_Universe
                         GROUP BY Pop_id) dsp ,
                        random_numbers rn
               WHERE    ((dsp.id_num + @Seed) % 1000000) = rn.random_id                    
             
             
  /*****TESTING CODE ONLY ******/            
 --  set @sql = '                                          
 --if exists (select 1 from sysobjects where name = ''dmp_returndata_' + CAST(@sampleset_Id as varchar(10)) + ''')                                          
 --begin                                           
 --drop table dmp_returndata_' + CAST(@sampleset_Id as varchar(10)) + '                                          
 --end                                          
                                           
 -- SELECT su.SampleUnit_id, su.Pop_id, su.Enc_id, su.DQ_Bus_Rule, su.Removed_Rule, su.EncDate, su.HouseHold_id, su.bitBadAddress, su.bitBadPhone, su.reportDate                                          
 --into dmp_returndata_' + CAST(@sampleset_Id as varchar(10)) + '                                          
 --FROM #SampleUnit_Universe su, #randomPops rp       
 --WHERE su.Pop_id=rp.Pop_id               
 --ORDER BY rp.numrandom,Enc_id'                                          
                           
 --if @indebug = 1 print @sql                                          
 --if @indebug = 1 exec (@SQL)             
             
 /******END TESTING CODE*******/                 
             
                                      
                                                 
 --Return data sorted by randomPop_id                                                
      SELECT   su.SampleUnit_id, su.Pop_id, su.Enc_id, su.DQ_Bus_Rule, su.Removed_Rule, su.EncDate, su.HouseHold_id,
               su.bitBadAddress, su.bitBadPhone, su.reportDate
      FROM     #SampleUnit_Universe su ,
               #randomPops rp
      WHERE    su.Pop_id = rp.Pop_id
      ORDER BY rp.numrandom, Enc_id                  
             
                               
                                                  
      IF @SamplingLogInsert = 1 
         BEGIN                          
            INSERT   INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode)
                     SELECT   @sampleset_Id, 'QCL_SelectEncounterUnitEligibility - End Proc', GETDATE(), ''                          
         END                      
            
            
/****TESTING CODE ONLY******************/              
 --  set @sql = '                                          
 --if exists (select 1 from sysobjects where name = ''dmp_randsamplingUniverse_' + CAST(@sampleset_Id as varchar(10)) + ''')                                          
 --begin                                           
 --drop table dmp_randsamplingUniverse_' + CAST(@sampleset_Id as varchar(10)) + '                                          
 --end                                          
                                           
 --Select *                                          
 --into dmp_randsamplingUniverse_' + CAST(@sampleset_Id as varchar(10)) + '                                          
 --from #SampleUnit_Universe'                                          
                             
 --if @indebug = 1 print @sql                                          
 --if @indebug = 1 exec (@SQL)               
             
 /***END TESTING CODE****/             
                                                 
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
                          
                          
                          
                                                
   END 

GO

use [NRC_DataMart_ETL]
GO


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleUnitTemp' 
					   AND sc.NAME = 'eligibleCount' )
BEGIN
	alter table [dbo].[SampleUnitTemp] add eligibleCount int NULL 
END


USE [NRC_DataMart_ETL]
GO

ALTER PROCEDURE [dbo].[csp_GetSamplePopulationExtractData] 
	@ExtractFileID int 
	WITH RECOMPILE
AS

	---------------------------------------------------------------------------------------
	-- Changed on 2015.02.05 by tsb S15.2 US11 Add StandardMethodologyID column to SampleSet
	-- Changes on 2015.02.06 Tim Butler - S18 US16 Add IneligibleCount column to SampleSet
	-- Changes on 2015.02.10 Tim Butler - S18 US17 Add SupplementalQuestionCount column to SamplePop
	-- S20 US11 Add Patient In File Count  Tim Butler
	-- S20 US09 Add SamplingMethod  Tim Butler
	-- Fix: 2015.04.17  Tim Butler  Removed join with QuestionForm on insert into SamplePopTemp to prevent duplicate records when updating SupplementalQuestionCount
	-- S23 U8  Removed NumPatInFile from SampleSetTemp and add new code to insert records into SampleUnitTemp
	-- S28 U31 Add NumberOfMailAttempts and NumberOfPhoneAttempts to SamplePopTemp
	-- S35 US18,20  Add ineligibleCount and isCensus to SampleUnitTemp 
	-- S35 US19  Fix NumberOfMailAttempts to return correct number based on disposition and hierarchy
	-- S42 US12  OAS: Count Fields As an OAS-CAHPS vendor, we need to report in the submission file the number of patients in the data file & the number of eligible patients, so our files are accepted. 02/04/2016 TSB
	---------------------------------------------------------------------------------------
	SET NOCOUNT ON 
    
	declare @EntityTypeID int
	set @EntityTypeID = 7 -- SamplePopulation

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;
    	
--	declare @ExtractFileID int
--	set @ExtractFileID = 2

	delete SamplePopTemp where ExtractFileID = @ExtractFileID

	insert SamplePopTemp 
			(ExtractFileID,SAMPLESET_ID,SAMPLEPOP_ID, POP_ID,STUDY_ID,IsDeleted,SupplementalQuestionCount, NumberOfMailAttempts, NumberOfPhoneAttempts) --S28 US31
		select distinct @ExtractFileID, sp.sampleset_id,
			   sp.SAMPLEPOP_ID, sp.POP_ID,sp.STUDY_ID, 0,
			   NULL,
			   NULL, --S28 US31 NumberOfMailAttempts
			   NULL  --S28 US31 NumberOfPhoneAttempts
		 from (select distinct PKey1 
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID
	           and IsDeleted = 0 ) eh
		  inner join QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = eh.PKey1
          left join SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     and sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
          where sp.POP_ID > 0
          and sst.sampleset_id is NULL --excludes sample pops that will be deleted due to sampleset deletes

	/* Fix: 2015.04.17  Update the supplementalQuestionCount value*/
	-- this updates those not returned yet with the value from the first questionform
	update spt
	SET SupplementalQuestionCount = qf.numCAHPSSupplemental
	FROM SamplePopTemp spt
	inner join (select qf0.SAMPLEPOP_ID, numCAHPSSupplemental
						 from (select qf0.samplepop_id, min(QuestionForm_ID) questionformid
										from QP_Prod.dbo.QUESTIONFORM qf0 with (NOLOCK) 
										group by SamplePop_ID) qf0
						inner join QP_Prod.dbo.QUESTIONFORM qf1 With (NOLOCK) on qf1.QUESTIONFORM_ID = qf0.questionformid
						where qf1.DATRETURNED is null) qf on qf.SAMPLEPOP_ID = spt.SAMPLEPOP_ID

	-- this updates those returned with the value from the questionform that has a DATRETURNED
	update spt
	SET SupplementalQuestionCount = qf.numCAHPSSupplemental
	FROM SamplePopTemp spt
	join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.SAMPLEPOP_ID = spt.SAMPLEPOP_ID
	where qf.DATRETURNED is not null


	-- S28 US 31  Update NumberOfMailAttempts and NumberOfPhoneAttempts
	-- S35 US17  fixed so that we are getting the correct NumberOfMailAttempts based on disposition and hierarchy
	select smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id, min(std.Hierarchy) hierarchy
	INTO #Mailings
	FROM SamplePopTemp spt
	inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = spt.SAMPLEPOP_ID
	inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
	inner join QP_Prod.[dbo].[MAILINGSTEP] ms on ms.MAILINGSTEP_ID = smg.MAILINGSTEP_ID
	inner join QP_Prod.[dbo].[MAILINGMETHODOLOGY] mmg on mmg.METHODOLOGY_ID = ms.METHODOLOGY_ID and mmg.SURVEY_ID = ms.SURVEY_ID
	inner join QP_Prod.[dbo].[StandardMethodology] stmg on stmg.StandardMethodologyID = mmg.StandardMethodologyID
	inner join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.SAMPLEPOP_ID = smg.SAMPLEPOP_ID and qf.SENTMAIL_ID = sm.SENTMAIL_ID
	inner join QP_Prod.[dbo].SURVEY_DEF sd on sd.survey_id = qf.survey_id
	inner join QP_Prod.[dbo].SurveyType st on st.SurveyType_id = sd.surveytype_id
	left join QP_Prod.[dbo].[DispositionLog] dlog on dlog.SamplePop_id = smg.SAMPLEPOP_ID and dlog.SentMail_id = sm.SENTMAIL_ID
	left join QP_Prod.[dbo].[Disposition] d on d.Disposition_id = dlog.Disposition_id
	left join QP_Prod.dbo.SurveyTypeDispositions std on std.Disposition_ID = d.Disposition_id and std.SurveyType_ID = st.SurveyType_ID
	where smg.OVERRIDEITEM_ID is null
	and stmg.MethodologyType = 'Mail Only'
	group by smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id

	update spt
	SET NumberOfMailAttempts = 
		CASE 
			WHEN (m1.Disposition_id NOT IN (15)) THEN m1.INTSEQUENCE
			ELSE (SELECT MAX(INTSEQUENCE) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID)
		END
	FROM SamplePopTemp spt
	left join #Mailings m1 on m1.SAMPLEPOP_ID = spt.SAMPLEPOP_ID  
	and m1.hierarchy = (SELECT min(hierarchy) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID) 

	drop table #Mailings

	-- S28 US 31  Update NumberOfPhoneAttempts
	update spt
	SET NumberOfPhoneAttempts = d.phoneAttempts
	FROM SamplePopTemp spt
	inner join (SELECT dlog.SamplePop_id, count(dlog.SamplePop_id) phoneAttempts
			    FROM QP_Prod.[dbo].[DispositionLog] dlog 
				WHERE dlog.LoggedBy = 'QSI Transfer Results Service'
				GROUP by dlog.SamplePop_id) d on d.SamplePop_id = spt.SAMPLEPOP_ID
	

     --insert sampleset rows for insert/update sample pops 
     insert SampleSetTemp 
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID, IneligibleCount, SamplingMethodID)
		select distinct @ExtractFileID,ss.sampleset_id,study.client_id,study.study_id, ss.survey_id, ss.DATSAMPLECREATE_DT,0,
			mm.StandardMethodologyID, -- S15 US11
			ISNULL(ss.IneligibleCount,0), -- S18 US 16
			pdef.SamplingMethod_id -- S20 US9
		 from SamplePopTemp spt	  
		  inner join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on spt.sampleset_id = ss.sampleset_id           
          inner join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on ss.survey_id = survey.survey_id
          inner join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1
          left join SampleSetTemp sst with (NOLOCK) on spt.sampleset_id = sst.sampleset_id and sst.ExtractFileID = @ExtractFileID
		  inner join QP_Prod.dbo.PeriodDates pdates with (NOLOCK) on pdates.SampleSet_id = ss.SAMPLESET_ID -- S20 US9
		  inner join QP_Prod.dbo.PeriodDef pdef on pdef.PeriodDef_id = pdates.PeriodDef_id -- S20 US9
       where spt.ExtractFileID = @ExtractFileID	
            and sst.sampleset_id Is NULL--excludes sampleset_ids already in SampleSetTemp, rows were added in csp_GetSampleSetExtractData


	delete SelectedSampleTemp where ExtractFileID = @ExtractFileID

	-- If this next query is slow, create this index in QP_Prod
	--    create index IX_MSI_Performance_1 on SelectedSample (sampleset_id, pop_id, sampleunit_id, enc_id, strUnitSelectType)
	
	INSERT INTO SelectedSampleTemp (ExtractFileID,SAMPLESET_ID, SAMPLEPOP_ID, SAMPLEUNIT_ID, POP_ID, ENC_ID, selectedTypeID,STUDY_ID,intExtracted_flg)
		select distinct @ExtractFileID,ss.SAMPLESET_ID, SAMPLEPOP_ID, ss.SAMPLEUNIT_ID, ss.POP_ID, ss.ENC_ID, 
				(case when strUnitSelectType = 'D' then 1  when strUnitSelectType = 'I' then 2 else 0 end),ss.STUDY_ID,intExtracted_flg
		 from SamplePopTemp t with (NOLOCK)
				inner join QP_Prod.dbo.SELECTEDSAMPLE ss with (NOLOCK) on ss.pop_id = t.pop_id and ss.sampleset_id = t.sampleset_id
	 where t.ExtractFileID = @ExtractFileID 


	 -- S23 U8
	 delete SampleUnitTemp where ExtractFileID = @ExtractFileID

	 insert into SampleUnitTemp(ExtractFileID,SAMPLESET_ID, SAMPLEUNIT_ID)
		select distinct @ExtractFileID,sst.SAMPLESET_ID, ss.SAMPLEUNIT_ID 
		from SampleSetTemp sst
			inner join QP_Prod.dbo.SELECTEDSAMPLE ss with (NOLOCK) on ss.sampleset_id = sst.sampleset_id
		where sst.ExtractFileID = @ExtractFileID 

	 -- refactor as part of S35 US18,20
	 update sut
	  set sut.NumPatInFile = ISNULL(pif.NumPatInFile, 0)
	   from dbo.SampleunitTemp sut
	   inner join QP_Prod.dbo.CAHPS_PatInfileCount pif with (NOLOCK) on pif.Sampleset_ID = sut.SAMPLESET_ID and pif.Sampleunit_ID = sut.SAMPLEUNIT_ID
		where sut.ExtractFileID = @ExtractFileID  



	 UPDATE sut
	  SET sut.ineligibleCount = sel.ineligibleCount
	   FROM dbo.SampleunitTemp sut
	   INNER JOIN (
			SELECT  dt.[sampleset_id]
					,dt.[sampleunit_id]
					,count(*) ineligibleCount
		    FROM (	 -- S35 US18 - ineligibleCount
					 SELECT distinct se.SampleSet_id, se.SampleUnit_id, pop_id
					 FROM [QP_Prod].[dbo].[Sampling_ExclusionLog] se
					 INNER JOIN dbo.SampleunitTemp su on su.SAMPLESET_ID = se.Sampleset_ID and su.SAMPLEUNIT_ID = se.Sampleunit_ID
					 WHERE su.ExtractFileID = @ExtractFileID  ) dt
		    GROUP BY dt.sampleset_id, dt.sampleunit_id
	   )   sel
	   ON sel.sampleset_id = sut.SAMPLESET_ID and sel.Sampleunit_ID = sut.SAMPLEUNIT_ID
	 WHERE sut.ExtractFileID = @ExtractFileID  

	 -- S35 US20 - isCensus
	  update sut 
			set isCensus=case when spw.intSampledNow = spw.intAvailableUniverse then 1 else 0 end 
		from SampleUnitTemp sut
		inner join QP_Prod.dbo.SamplePlanWorksheet spw on sut.Sampleset_id=spw.Sampleset_id and sut.SampleUnit_id=spw.SampleUnit_id 
		where sut.ExtractFileID = @ExtractFileID  

	 -- S42 US12 - eligibleCount  TSB 02/04/2016
	 UPDATE sut
	  SET sut.eligibleCount = sel.eligibleCount
	   FROM dbo.SampleunitTemp sut
	   INNER JOIN (
			SELECT  dt.[sampleset_id]
					,dt.[sampleunit_id]
					,count(*) eligibleCount
		    FROM (
					 SELECT distinct se.SampleSet_id, se.SampleUnit_id, pop_id
					 FROM [QP_Prod].[dbo].[EligibleEncLog] se
					 INNER JOIN dbo.SampleunitTemp su on su.SAMPLESET_ID = se.Sampleset_ID and su.SAMPLEUNIT_ID = se.Sampleunit_ID
					 WHERE su.ExtractFileID = @ExtractFileID  ) dt
		    GROUP BY dt.sampleset_id, dt.sampleunit_id
	   )   sel
	   ON sel.sampleset_id = sut.SAMPLESET_ID and sel.Sampleunit_ID = sut.SAMPLEUNIT_ID
	 WHERE sut.ExtractFileID = @ExtractFileID  

	 UPDATE sp
	  SET ENC_ID = ss.ENC_ID
	   FROM dbo.SamplePopTemp sp
	   INNER JOIN (SELECT DISTINCT SAMPLESET_ID,SAMPLEPOP_ID,ENC_ID--*
	     			FROM dbo.SelectedSampleTemp
					WHERE ExtractFileID = @ExtractFileID  and intextracted_flg = 1 ) ss ON sp.SAMPLESET_ID = ss.SAMPLESET_ID and sp.SAMPLEPOP_ID = ss.SAMPLEPOP_ID
		WHERE sp.ExtractFileID = @ExtractFileID 

    ---------------------------------------------------------------------------------------
	-- Add delete rows to SamplePopTemp 
	---------------------------------------------------------------------------------------
     INSERT INTO SamplePopTemp 
		(ExtractFileID,SAMPLESET_ID,SAMPLEPOP_ID, POP_ID,IsDeleted )
	  SELECT DISTINCT @ExtractFileID, PKey2, PKey1, 0, 1
        FROM ExtractHistory  with (NOLOCK) 
         WHERE ExtractFileID = @ExtractFileID
	      AND EntityTypeID = @EntityTypeID
	       AND IsDeleted = 1
	 

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2


GO


ALTER PROCEDURE [dbo].[csp_GetSamplePopulationExtractData2] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
--exec csp_GetSamplePopulationExtractData2 2714
	
	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT
	
			declare @SamplePopEntityTypeID int
			set @SamplePopEntityTypeID = 7 -- SamplePopulation

			declare @SampleSetEntityTypeID int
			set @SampleSetEntityTypeID = 8 -- SampleSet
  	
			--declare @ExtractFileID int
			--set @ExtractFileID= 2714 -- test only

			declare @TestString nvarchar(40)
			set @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'
          
	---------------------------------------------------------------------------------------
	-- Formats data for XML export
	-- Changed on 2009.11.09 by kmn to remove CAPHS & nrc disposition columns
	-- Changed on 2014.12.19 by tsb S14.2 US11 Add StandardMethodologyID column to SampleSet
	-- Changes on 2015.02.06 Tim Butler - S18 US16 Add IneligibleCount column to SampleSet
	-- Changes on 2015.02.10 Tim Butler - S18 US17 Add SupplementalQuestionCount column to SamplePop
	-- S20 US09 Add SamplingMethod  Tim Butler
	-- S23 US8 Add Patient In File Count  Tim Butler
	-- S28 U31 Add NumberOfMailAttempts and NumberOfPhoneAttempts to SamplePopTemp
	-- S35 US17 Add datFirstMailed		Tim Butler
	---------------------------------------------------------------------------------------
declare @country varchar(75)
SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'

if @country = 'CA'
begin   
	

			 IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ttt_error')) 
				DROP TABLE #ttt_error	 
		
			select sampleset_id,samplepop_id,study_id,firstName,lastName,city,drNPI
			into #ttt_error
			from SamplePopTemp sst with (NOLOCK)   
			 where ExtractFileID = @ExtractFileID  
			  and ( PATINDEX (@TestString,  IsNull(sst.firstName,'') COLLATE Latin1_General_BIN) > 0   
			  or PATINDEX (@TestString, IsNull(sst.lastName,'') COLLATE Latin1_General_BIN) > 0   
			  or PATINDEX (@TestString, IsNull(sst.city,'') COLLATE Latin1_General_BIN) > 0  
			  or PATINDEX (@TestString, IsNull(sst.province,'') COLLATE Latin1_General_BIN) > 0  
			  or PATINDEX (@TestString, IsNull(sst.postalCode,'') COLLATE Latin1_General_BIN) > 0 
			  or PATINDEX (@TestString, IsNull(sst.drNPI,'') COLLATE Latin1_General_BIN) > 0  
			  or PATINDEX (@TestString, IsNull(sst.clinicNPI,'') COLLATE Latin1_General_BIN) > 0  )
   
		   delete from ExtractHistoryError where ExtractFileID = @ExtractFileID and EntityTypeID = @SamplePopEntityTypeID

		   insert into ExtractHistoryError
			 select eh.*,'csp_GetSamplePopulationExtractData2' As Source
			 ,IsNull(error.firstName,'') + ',' + IsNull(error.lastName,'') + ',' + IsNull(error.city,'')          
			 from #ttt_error error with (NOLOCK)
			 Inner Join ExtractHistory eh with (NOLOCK)
			   on error.samplepop_id = eh.PKey1 
			   and eh.ExtractFileID = @ExtractFileID 
			   and eh.EntityTypeID =  @SamplePopEntityTypeID
       
			 IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ttt')) 
				DROP TABLE #ttt	
	     
			CREATE TABLE #ttt
			(
				Tag int not null,
				Parent int null,

				[sampleSet!1!id] nvarchar(200) NULL,--sampleset	    
				[sampleSet!1!clientID] nvarchar(200) NULL,
				[sampleSet!1!sampleDate] datetime NULL,	    
				[sampleSet!1!deleteEntity] nvarchar(5) NULL,
				[sampleSet!1!standardMethodologyID] int NULL, -- S15 US11
				[sampleSet!1!ineligibleCount] int NULL, -- S18 US16
				[sampleSet!1!SamplingMethodID] int NULL, -- S20 US9
				[sampleSet!1!datFirstMailed] datetime NULL, -- S35 US17
					
				[samplePop!2!id] nvarchar(200) NULL,--sample pop
				[samplePop!2!isMale] bit NULL,
				[samplePop!2!firstName] nvarchar(100) NULL,
				[samplePop!2!lastName] nvarchar(100) NULL,
				[samplePop!2!city] nvarchar(100) NULL,
				[samplePop!2!province] nchar(2) NULL,
				[samplePop!2!postalCode] nvarchar(20) NULL,
				[samplePop!2!language] nchar(2) NULL,
				[samplePop!2!age] int NULL,
				[samplePop!2!drNPI] nvarchar(100) NULL,
				[samplePop!2!clinicNPI] nvarchar(100) NULL,
				[samplePop!2!admitDate] datetime NULL,
				[samplePop!2!serviceDate] datetime NULL,
				[samplePop!2!dischargeDate] datetime NULL,
				[samplePop!2!deleteEntity] nvarchar(5) NULL,
				[samplePop!2!supplementalQuestionCount] int NULL, -- S18 US17
				[samplePop!2!numberOfMailAttempts] int NULL, --S28 US31
				[samplePop!2!numberOfPhoneAttempts] int NULL, --S28 US31

				[selectedSample!3!sampleunitid] nvarchar(200) NULL,
				[selectedSample!3!selectedTypeID] int NULL,

				[sampleUnit!4!sampleunitid] nvarchar(200) NULL, -- S20 US11, --S35 US18,20  - changed Element name from numPatInFile to sampleUnit
				[sampleUnit!4!numPatInFile] int NULL, --S35 US18,20  - changed attribute name from patientCount to numPatInFile
				[sampleUnit!4!ineligibleCount] int NULL,--S35 US18  - changed Element name to sampleUnit
				[sampleUnit!4!isCensus] int NULL, --S35 US20  - added attribute samplingMethodID
				[sampleUnit!4!eligibleCount] int NULL --S42 US12  - added EligibleCount
	       
		  )
  
		  insert #ttt
  			select distinct 1 as Tag, NULL as Parent,
  	  		             
				   SampleSetTemp.SAMPLESET_ID,       
				   SampleSetTemp.CLIENT_ID,          
				   IsNull(SampleSetTemp.sampleDate,GetDate()),             
				   Case When IsDeleted = 1 Then 'true' Else 'false' End,
				   SampleSetTemp.StandardMethodologyID, -- S15 US11
				   SampleSetTemp.IneligibleCount, -- S18 US16
				   SampleSetTemp.SamplingMethodID, -- S20 US9
				   SampleSetTemp.datFirstMailed, -- S35 US17

				   NULL, NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ,  NULL , 
				   NULL, --S18 US17
				   NULL,NULL, -- S28 US31
		  
				   NULL, NULL,  

				   NULL, NULL, -- S23 US8
				   NULL, NULL, -- S35 US 18,20
				   NULL -- S42 US12

		--	  select *	   
			  from SampleSetTemp with (NOLOCK) 
			  where SampleSetTemp.ExtractFileID = @ExtractFileID 

			 IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ttt_deident')) 
				DROP TABLE #ttt_deident	 

			SELECT	DISTINCT 
					mt.STUDY_ID, m.STRFIELD_NM, 
					CASE 
						WHEN	CASE 
									WHEN	(
											CASE 
												WHEN m.bitAllowUS=0 THEN '0' 
												WHEN m.bitPII=1 THEN '0' 
												ELSE '1' 
											END
											)='0' THEN '1' 
									ELSE '0' 
								END = '1' THEN	CASE		WHEN m.STRFIELDDATATYPE = 'D' THEN 'Jan  1 1900 12:00AM' 
														ELSE '0' 
												END 
						ELSE '' 
					END AS DeIdent
			INTO #ttt_deident
			FROM	(SELECT DISTINCT Study_id FROM SamplePopTemp) t
					INNER JOIN QP_Prod.dbo.METATABLE mt
						ON t.STUDY_ID = mt.STUDY_ID
					INNER JOIN 
					(
					SELECT	ms.TABLE_ID, mf.STRFIELD_NM, ms.bitAllowUS, ms.bitPII, mf.STRFIELDDATATYPE
					FROM	QP_Prod.dbo.METASTRUCTURE ms
							INNER JOIN QP_Prod.dbo.METAFIELD mf
								ON ms.FIELD_ID = mf.FIELD_ID
					) m
					ON mt.TABLE_ID = m.TABLE_ID
			WHERE	(SELECT [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country') = 'CA'
					AND m.STRFIELD_NM IN ('fname','lname','city','Province','Postal_Code','LangID','Age','AdmitDate','ServiceDate','DischargeDate')
					AND
					CASE 
						WHEN	CASE 
									WHEN	(
											CASE 
												WHEN m.bitAllowUS=0 THEN '0' 
												WHEN m.bitPII=1 THEN '0' 
												ELSE '1' 
											END
											)='0' THEN '1' 
									ELSE '0' 
								END = '1' THEN	CASE		WHEN m.STRFIELDDATATYPE = 'D' THEN 'Jan  1 1900 12:00AM' 
														ELSE '0' 
												END 
						ELSE '' 
					END <> ''

		   -- Add sample pop insert/update rows
		IF (SELECT [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country') = 'CA'
		   insert #ttt
  			select 2 as Tag, 1 as Parent,
				   spt.SAMPLESET_ID,NULL, NULL, NULL, 
				   NULL, -- S15 US11
				   NULL, -- S18 US16
				   NULL, -- S20 US09
				   NULL, -- S35 US17

				   spt.SAMPLEPOP_ID, 
				   spt.isMale,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'fname')='' then spt.firstName else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'fname') end,spt.firstName) as firstName,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'lname')='' then spt.lastName else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'lname') end,spt.lastName) as lastName,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'city')='' then spt.city else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'city') end,spt.city) as city,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'province')='' then spt.province else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'province') end,spt.province) as province,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'Postal_Code')='' then spt.postalCode else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'Postal_Code') end,spt.postalCode) as postalCode,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'LangID')='' then spt.language else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'LangID') end,spt.language) as language,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'age')='' then spt.age else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'age') end,spt.age) as age,
				   spt.drNPI,
				   spt.clinicNPI,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'AdmitDate')='' then dbo.FirstDayOfMonth(spt.admitDate) else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'AdmitDate') end,dbo.FirstDayOfMonth(spt.admitDate)) as admitDate,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'ServiceDate')='' then dbo.FirstDayOfMonth(spt.serviceDate) else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'ServiceDate') end,dbo.FirstDayOfMonth(spt.serviceDate)) as serviceDate,
				   isnull(case when (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'DischargeDate')='' then dbo.FirstDayOfMonth(spt.dischargeDate) else (Select deident from #ttt_deident where study_id = spt.STUDY_ID and strfield_nm = 'DischargeDate') end,dbo.FirstDayOfMonth(spt.dischargeDate)) as dischargeDate,
				   Case When spt.IsDeleted = 1 Then 'true' Else 'false' End,
				   NULL, --S18 US17
				   NULL,NULL, -- S28 US31

				   NULL, NULL,  -- selectedsample

				   NULL, NULL, -- S23 US8
				   NULL, NULL, -- S35 US 18,20
				   NULL -- S42 US12
				
			 --select *	   
			 from	SamplePopTemp spt with (NOLOCK)
			left join #ttt_error e with (NOLOCK)
				  on spt.samplepop_id = e.samplepop_id
				  and spt.study_id = e.study_id
			 where spt.ExtractFileID = @ExtractFileID
			   and e.samplepop_id is null 
			   --and SamplePopTemp.SAMPLEPOP_ID = 68475428
		ELSE
		   insert #ttt
  			select 2 as Tag, 1 as Parent,
				   SamplePopTemp.SAMPLESET_ID,NULL, NULL, NULL,
				   NULL, -- S15 US11
				   NULL, -- S18 US16 
				   NULL, -- S20 US09
				   NULL, -- S35 US17
				   SamplePopTemp.SAMPLEPOP_ID, 
				   SamplePopTemp.isMale,
				   SamplePopTemp.firstName,
				   SamplePopTemp.lastName,
				   SamplePopTemp.city,
				   SamplePopTemp.province,
				   SamplePopTemp.postalCode,
				   SamplePopTemp.language,
				   SamplePopTemp.age,
				   SamplePopTemp.drNPI,
				   SamplePopTemp.clinicNPI,
				   SamplePopTemp.admitDate,
				   SamplePopTemp.serviceDate,
				   SamplePopTemp.dischargeDate,	    
				   Case When SamplePopTemp.IsDeleted = 1 Then 'true' Else 'false' End,
				   SamplePopTemp.SupplementalQuestionCount, --S18 US17
				   SamplePopTemp.NumberOfMailAttempts, -- S28 US31
				   SamplePopTemp.NumberOfPhoneAttempts, -- S28 US31

				   NULL, NULL, -- selectedsample
				   
				   NULL, NULL, -- S23 US8 
				   NULL, NULL, -- S35 US 18,20
				   NULL -- S42 US12
			 --select *	   
			 from SamplePopTemp with (NOLOCK)
			 left join #ttt_error error with (NOLOCK)
				  on SamplePopTemp.samplepop_id = error.samplepop_id
				  and SamplePopTemp.study_id = error.study_id
			 where SamplePopTemp.ExtractFileID = @ExtractFileID
			   and error.samplepop_id is null 
			   --and SamplePopTemp.SAMPLEPOP_ID = 68475428
	   	   	   
		  -- Add the selected sample/sample unit mappings
		  insert #ttt
  			select 3 as Tag, 2 as Parent,  		   

  				   SelectedSampleTemp.sampleset_id , NULL, NULL, NULL,
				   NULL, -- S15 US11
				   NULL, -- S18 US16
				   NULL, -- S20 US9
				   NULL, -- S35 US17
 
  				   SelectedSampleTemp.samplepop_id,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
				   NULL , -- S18 US17
				   NULL, NULL,  -- S28 US31

				   SelectedSampleTemp.sampleunit_id, 
				   selectedTypeID,

				   NULL, NULL, -- S23 US8
				   NULL, NULL, -- S35 US 18,20
				   NULL -- S42 US12
		   
			  from SelectedSampleTemp with (NOLOCK)	    
			  left join #ttt_error error with (NOLOCK)
				  on SelectedSampleTemp.samplepop_id = error.samplepop_id
				  and SelectedSampleTemp.study_id = error.study_id
			  where SelectedSampleTemp.ExtractFileID = @ExtractFileID 
			   and error.samplepop_id is null 
			  --and SelectedSampleTemp.SAMPLEPOP_ID <> 68475428

			insert #ttt
  			select 4 as Tag, 1 as Parent,  		   

  				   SampleUnitTemp.SAMPLESET_ID , NULL, NULL, NULL,
				   NULL, -- S15 US11
				   NULL, -- S18 US16
				   NULL, -- S20 US09
				   NULL, -- S35 US17
 
  				   NULL,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
				   NULL, --S18 US17
				   NULL,NULL, -- S28 US31

				   NULL, NULL,  -- selectedsample

				  SampleUnitTemp.SAMPLEUNIT_ID, -- S23 US8
				  SampleUnitTemp.NumPatInFile,
				  SampleUnitTemp.IneligibleCount, -- S35 US18
				  SampleUnitTemp.isCensus, -- S35 US 20
				  SampleUnitTemp.eligibleCount -- S42 US12
   
			  from SampleUnitTemp with (NOLOCK)	    
			  where SampleUnitTemp.ExtractFileID = @ExtractFileID 
	 
			select * 
			from #ttt    
			--where [sampleSet!1!id] <> 725591 -- and 725591
			order by [sampleSet!1!id],[samplePop!2!id], [selectedSample!3!sampleunitid] 
			for xml explicit
          
			drop table #ttt
			drop table #ttt_error
			DROP TABLE #ttt_deident


end
else
begin
	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#ttt_error')) 
		DROP TABLE #ttt_errorUS	 
		
    select sampleset_id,samplepop_id,study_id,firstName,lastName,city,drNPI
    into #ttt_errorUS
    from SamplePopTemp sst with (NOLOCK)   
     where ExtractFileID = @ExtractFileID  
      and ( PATINDEX (@TestString,  IsNull(sst.firstName,'') COLLATE Latin1_General_BIN) > 0   
	  or PATINDEX (@TestString, IsNull(sst.lastName,'') COLLATE Latin1_General_BIN) > 0   
	  or PATINDEX (@TestString, IsNull(sst.city,'') COLLATE Latin1_General_BIN) > 0  
	  or PATINDEX (@TestString, IsNull(sst.province,'') COLLATE Latin1_General_BIN) > 0  
	  or PATINDEX (@TestString, IsNull(sst.postalCode,'') COLLATE Latin1_General_BIN) > 0 
	  or PATINDEX (@TestString, IsNull(sst.drNPI,'') COLLATE Latin1_General_BIN) > 0  
	  or PATINDEX (@TestString, IsNull(sst.clinicNPI,'') COLLATE Latin1_General_BIN) > 0  )
   
   delete from ExtractHistoryError where ExtractFileID = @ExtractFileID and EntityTypeID = @SamplePopEntityTypeID

   insert into ExtractHistoryError
     select eh.*,'csp_GetSamplePopulationExtractData2' As Source
     ,IsNull(error.firstName,'') + ',' + IsNull(error.lastName,'') + ',' + IsNull(error.city,'')          
     from #ttt_errorUS error with (NOLOCK)
     Inner Join ExtractHistory eh with (NOLOCK)
	   on error.samplepop_id = eh.PKey1 
       and eh.ExtractFileID = @ExtractFileID 
       and eh.EntityTypeID =  @SamplePopEntityTypeID
       
     IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tttUS')) 
		DROP TABLE #tttUS	
	     
	CREATE TABLE #tttUS
	(
		Tag int not null,
		Parent int null,

		[sampleSet!1!id] nvarchar(200) NULL,--sampleset	    
	    [sampleSet!1!clientID] nvarchar(200) NULL,
	    [sampleSet!1!sampleDate] datetime NULL,	    
	    [sampleSet!1!deleteEntity] nvarchar(5) NULL,
		[sampleSet!1!standardMethodologyID] int NULL, -- S15 US11
		[sampleSet!1!ineligibleCount] int NULL, -- S18 US16
		[sampleSet!1!SamplingMethodID] int NULL, -- S20 US9
		[sampleSet!1!datFirstMailed] datetime NULL, -- S35 US17
					
	    [samplePop!2!id] nvarchar(200) NULL,--sample pop
	    [samplePop!2!isMale] bit NULL,
	    [samplePop!2!firstName] nvarchar(100) NULL,
	    [samplePop!2!lastName] nvarchar(100) NULL,
	    [samplePop!2!city] nvarchar(100) NULL,
	    [samplePop!2!province] nchar(2) NULL,
	    [samplePop!2!postalCode] nvarchar(20) NULL,
	    [samplePop!2!language] nchar(2) NULL,
	    [samplePop!2!age] int NULL,
	    [samplePop!2!drNPI] nvarchar(100) NULL,
	    [samplePop!2!clinicNPI] nvarchar(100) NULL,
	    [samplePop!2!admitDate] datetime NULL,
	    [samplePop!2!serviceDate] datetime NULL,
	    [samplePop!2!dischargeDate] datetime NULL,
	    [samplePop!2!deleteEntity] nvarchar(5) NULL,
		[samplePop!2!supplementalQuestionCount] int NULL, -- S18 US17
		[samplePop!2!numberOfMailAttempts] int NULL, --S28 US31
		[samplePop!2!numberOfPhoneAttempts] int NULL, --S28 US31

	    [selectedSample!3!sampleunitid] nvarchar(200) NULL,
	    [selectedSample!3!selectedTypeID] int NULL,

		[sampleUnit!4!sampleunitid] nvarchar(200) NULL, -- S20 US11, --S35 US18,20  - changed Element name from numPatInFile to sampleUnit
		[sampleUnit!4!numPatInFile] int NULL, --S35 US18,20  - changed attribute name from patientCount to numPatInFile
		[sampleUnit!4!ineligibleCount] int NULL,--S35 US18  - changed Element name to sampleUnit
		[sampleUnit!4!isCensus] int NULL, --S35 US20  - added attribute samplingMethodID
		[sampleUnit!4!eligibleCount] int NULL --S42 US12  - added EligibleCount
		
	       
  )
  
  insert #tttUS
  	select distinct 1 as Tag, NULL as Parent,
  	  		             
           SampleSetTemp.SAMPLESET_ID,       
           SampleSetTemp.CLIENT_ID,          
           IsNull(SampleSetTemp.sampleDate,GetDate()),             
		   Case When IsDeleted = 1 Then 'true' Else 'false' End,
		   SampleSetTemp.StandardMethodologyID, -- S15 US11
		   SampleSetTemp.IneligibleCount, -- S18 US16
		   SampleSetTemp.SamplingMethodID, -- S20 US9
		   SampleSetTemp.datFirstMailed, -- S35 US17

		   NULL, NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ,  NULL , 
		   NULL, --S18 US17
		   NULL,NULL, -- S28 US31
		  
		   NULL, NULL,  

		   NULL, NULL, -- S23 US8
		   NULL, NULL, -- S35 US 18,20
		   NULL -- S42 US12


--	  select *	   
	  from SampleSetTemp with (NOLOCK) 
      where SampleSetTemp.ExtractFileID = @ExtractFileID 
     
   -- Add sample pop insert/update rows
   insert #tttUS
  	select 2 as Tag, 1 as Parent,
  	  		             
           SamplePopTemp.SAMPLESET_ID,NULL, NULL, NULL, 
		   NULL, -- S15 US11
		   NULL, -- S18 US16
		   NULL, -- S20 US9
		   NULL, -- S35 US17

		   SamplePopTemp.SAMPLEPOP_ID, 		   
		   SamplePopTemp.isMale,
		   SamplePopTemp.firstName,
		   SamplePopTemp.lastName,
		   SamplePopTemp.city,
		   SamplePopTemp.province,
		   SamplePopTemp.postalCode,
		   SamplePopTemp.language,
		   SamplePopTemp.age,
		   SamplePopTemp.drNPI,
		   SamplePopTemp.clinicNPI,
		   SamplePopTemp.admitDate,
		   SamplePopTemp.serviceDate,
		   SamplePopTemp.dischargeDate,	    
		   Case When SamplePopTemp.IsDeleted = 1 Then 'true' Else 'false' End,
		   ISNULL(SamplePopTemp.SupplementalQuestionCount,0), -- S18 US17
		   SamplePopTemp.NumberOfMailAttempts,
		   SamplePopTemp.NumberOfPhoneAttempts,
		   
		   NULL, NULL, --selectedsample
		   
		   NULL, NULL, -- S23 US8 
		   NULL, NULL, -- S35 US 18,20
		   NULL -- S42 US12

	 --select *	   
	 from SamplePopTemp with (NOLOCK)
	 left join #ttt_errorUS error with (NOLOCK)
          on SamplePopTemp.samplepop_id = error.samplepop_id
          and SamplePopTemp.study_id = error.study_id
     where SamplePopTemp.ExtractFileID = @ExtractFileID
	   and error.samplepop_id is null 
	   --and SamplePopTemp.SAMPLEPOP_ID = 68475428
	   	   	   
  -- Add the selected sample/sample unit mappings
  insert #tttUS
  	select 3 as Tag, 2 as Parent,  		   

  		   SelectedSampleTemp.sampleset_id , NULL, NULL, NULL,
		   NULL, -- S15 US11
		   NULL, -- S18 US16
		   NULL, -- S20 US9
		   NULL, -- S35 US17
 
  		   SelectedSampleTemp.samplepop_id,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
		   NULL , -- S18 US17
		   NULL, NULL,  -- S28 US31

		   SelectedSampleTemp.sampleunit_id, 
		   selectedTypeID,

		   NULL, NULL, -- S23 US8
		   NULL, NULL, -- S35 US 18,20
		   NULL -- S42 US12
		   
	  from SelectedSampleTemp with (NOLOCK)	    
	  left join #ttt_errorUS error with (NOLOCK)
          on SelectedSampleTemp.samplepop_id = error.samplepop_id
          and SelectedSampleTemp.study_id = error.study_id
	  where SelectedSampleTemp.ExtractFileID = @ExtractFileID 
	   and error.samplepop_id is null 
	  --and SelectedSampleTemp.SAMPLEPOP_ID <> 68475428

	-- Add the SampleUnit/SampletSet mappings
	insert #tttUS
  			select 4 as Tag, 1 as Parent,  		   

  				   SampleUnitTemp.SAMPLESET_ID , NULL, NULL, NULL,
				   NULL, -- S15 US11
				   NULL, -- S18 US16
				   NULL, -- S20 US09
				   NULL, -- S35 US17
 
  				   NULL,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
				   NULL, --S18 US17
				   NULL,NULL, -- S28 US31

				   NULL, NULL,  -- selectedsample

				  SampleUnitTemp.SAMPLEUNIT_ID, -- S23 US8
				  SampleUnitTemp.NumPatInFile,
				  SampleUnitTemp.IneligibleCount, -- S35 US18
				  SampleUnitTemp.isCensus, -- S35 US 20
				  SampleUnitTemp.eligibleCount -- S42 US12


			  from SampleUnitTemp with (NOLOCK)	    
			  where SampleUnitTemp.ExtractFileID = @ExtractFileID 
	 
	select * 
	from #tttUS    
	--where [sampleSet!1!id] <> 725591 -- and 725591
	order by [sampleSet!1!id],[sampleUnit!4!sampleunitid], [samplePop!2!id], [selectedSample!3!sampleunitid] 
    for xml explicit
          
    drop table #tttUS
    drop table #ttt_errorUS

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
end

GO


--US 13 OAS: Language in which Survey Completed 

use [NRC_DataMart_ETL]
go


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'QuestionFormTemp' 
					   AND sc.NAME = 'LangID' )
BEGIN
	alter table [dbo].[QuestionFormTemp] add [LangID] int NULL 
END
go



USE [NRC_DataMart_ETL]
GO



-- =============================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetQuestionFormExtractData
-- Create date: 3/01/2009 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 modifed logic to handle DatUndeliverable changes
--			1.2 by ccaouette: ACO CAHPS Project
--          1.3 by dgilsdorf: CheckForACOCAHPSIncompletes changed to CheckForCAHPSIncompletes
--          1.4 by dgilsdorf: added call to CheckForMostCompleteUsablePartials for HHCAHPS and ICHCAHPS processing
--          1.5 by dgilsdorf: moved CAHPS processing procs to earlier in the ETL
--          1.6 by dgilsdorf: changed call to HHCAHPSCompleteness from a function to a procedure
--			1.7 by ccaouette: check for duplicate questionform (same samplepop_id)
--			S42 US13 OAS: Language in which Survey Completed As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs. 02/04/2016 TSB
-- =============================================
ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 
	@ExtractFileID int 
	
--exec [dbo].[csp_GetQuestionFormExtractData]  2238
AS
	SET NOCOUNT ON 

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;

	declare @EntityTypeID int
	set @EntityTypeID = 11 -- QuestionForm
--
 --   declare @ExtractFileID int
	--set @ExtractFileID = 539 -- 

	---------------------------------------------------------------------------------------
	-- ACO CAHPS Project
	-- ccaouette: 2014-05
	---------------------------------------------------------------------------------------
	--DECLARE @country VARCHAR(10)
	--SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	--select @country
	--IF @country = 'US'
	--BEGIN
	--	EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
	--	EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
	--	EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
	--END	

	---------------------------------------------------------------------------------------
	-- Load records to Insert/Update into a temp table
	-- Changed 2009.11.09 to handle surveytypeid = 3 surveys by kmn
	---------------------------------------------------------------------------------------

	-- clean up any records that might be in the tables already
	DELETE QuestionFormTemp where ExtractFileID = @ExtractFileID;

	-- CTE finds duplicate questionforms in ExtractHistory table
	WITH cteEH AS
	(
				SELECT eh1.PKey1, eh1.Pkey2, eh1.EntityTypeID, eh1.IsDeleted, eh1.Created
				FROM ExtractHistory eh1
				INNER JOIN (SELECT DISTINCT PKey1, Pkey2, EntityTypeID
								FROM ExtractHistory  with (NOLOCK) 
									WHERE ExtractFileID = @ExtractFileID
									AND EntityTypeID = @EntityTypeID --and pkey2 = '186064012'
									GROUP BY PKey1, Pkey2,EntityTypeID
									having COUNT(*) > 1) eh2 ON eh1.PKey1 = eh2.PKey1 AND (eh1.PKey2 = eh2.Pkey2 OR eh1.PKey2 IS NULL) AND eh1.EntityTypeID = eh2.EntityTypeID
				WHERE ExtractFileID = @ExtractFileID								
	)


	INSERT INTO QuestionFormTemp 
			(ExtractFileID
			, QUESTIONFORM_ID
			, SURVEY_ID
			, SurveyType_id
			, SAMPLEPOP_ID
			, strLithoCode
			, isComplete
			, ReceiptType_id
            , returnDate
			, DatMailed, DatExpire, DatGenerated, DatPrinted, DatBundled, DatUndeliverable
			,IsDeleted
			,[LangID])
	SELECT DISTINCT @ExtractFileID
						, qf.QUESTIONFORM_ID
						, qf.SURVEY_ID
						, sd.SurveyType_id
						, qf.SAMPLEPOP_ID
						, sm.strLithoCode
						, CASE WHEN qf.bitComplete <> 0 THEN 'true' ELSE 'false' END 
						, qf.ReceiptType_id
						, qf.datReturned 
						, sm.DatMailed, sm.DatExpire, sm.DatGenerated, sm.DatPrinted, sm.DatBundled, sm.DatUndeliverable
						, eh.IsDeleted
						, sm.[LangID]
		 FROM (SELECT  t1.PKey1, t1.Pkey2, t1.IsDeleted
					FROM cteEH t1 
					INNER JOIN cteEH t2 ON t1.PKey1 = t2.PKey1 AND (t1.PKey2 = t2.Pkey2 OR t2.PKey2 IS NULL) AND t1.EntityTypeID = t2.EntityTypeID
					WHERE t1.Created > t2.Created
					) eh --Find most recent duplicate ExtractHistory record
		INNER JOIN QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1
        INNER JOIN QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
        INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = qf.SAMPLEPOP_ID	
        INNER JOIN QP_Prod.dbo.Survey_def sd With (NOLOCK) on qf.SURVEY_ID = sd.SURVEY_ID
        LEFT JOIN SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     AND sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
	    WHERE (qf.DATRETURNED IS NOT NULL OR sm.DatUndeliverable IS NOT NULL ) 
	           AND sp.POP_ID > 0
	           AND sst.sampleset_id IS NULL; --excludes questionforms/sample pops that will be deleted due to sampleset deletes

	WITH cteEH AS
	(
				SELECT eh1.PKey1, eh1.Pkey2, eh1.EntityTypeID, eh1.IsDeleted, eh1.Created
				FROM ExtractHistory eh1
				INNER JOIN (SELECT DISTINCT PKey1, Pkey2, EntityTypeID
								FROM ExtractHistory  with (NOLOCK) 
									WHERE ExtractFileID = @ExtractFileID
									AND EntityTypeID = @EntityTypeID --and pkey2 = '186064012'
									GROUP BY PKey1, Pkey2,EntityTypeID
									having COUNT(*) = 1) eh2 ON eh1.PKey1 = eh2.PKey1 AND (eh1.PKey2 = eh2.Pkey2 OR eh1.PKey2 IS NULL) AND eh1.EntityTypeID = eh2.EntityTypeID
				WHERE ExtractFileID = @ExtractFileID
	)


	INSERT INTO QuestionFormTemp 
			(ExtractFileID
			, QUESTIONFORM_ID
			, SURVEY_ID
			, SurveyType_id
			, SAMPLEPOP_ID
			, strLithoCode
			, isComplete
			, ReceiptType_id
            , returnDate
			, DatMailed, DatExpire, DatGenerated, DatPrinted, DatBundled, DatUndeliverable
			,IsDeleted
			,[LangID])
	SELECT DISTINCT @ExtractFileID
						, qf.QUESTIONFORM_ID
						, qf.SURVEY_ID
						, sd.SurveyType_id
						, qf.SAMPLEPOP_ID
						, sm.strLithoCode
						, CASE WHEN qf.bitComplete <> 0 THEN 'true' ELSE 'false' END 
						, qf.ReceiptType_id
						, qf.datReturned 
						, sm.DatMailed, sm.DatExpire, sm.DatGenerated, sm.DatPrinted, sm.DatBundled, sm.DatUndeliverable
						, eh.IsDeleted
						, sm.[LangID]
		 FROM (SELECT  t1.PKey1, t1.Pkey2, t1.IsDeleted
					FROM cteEH t1 
					) eh 
		INNER JOIN QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1
        INNER JOIN QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
        INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = qf.SAMPLEPOP_ID	
        INNER JOIN QP_Prod.dbo.Survey_def sd With (NOLOCK) on qf.SURVEY_ID = sd.SURVEY_ID
        LEFT JOIN SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     AND sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
	    WHERE (qf.DATRETURNED IS NOT NULL OR sm.DatUndeliverable IS NOT NULL ) 
	           AND sp.POP_ID > 0
	           AND sst.sampleset_id IS NULL;

		--Deal with multiple QuestionForms with same SamplePop.  Process earliest returndate by setting IsDelete=0, other matching records set to IsDeleted=1
		;WITH cleanQF AS
		(
			SELECT QuestionForm_ID, SamplePop_ID, returnDate FROM QuestionFormTemp
			WHERE returnDate IS NOT NULL AND SamplePop_ID IN (
			SELECT SamplePop_ID
			FROM QuestionFormTemp
			WHERE returnDate IS NOT NULL --AND IsDeleted = 0
			GROUP BY SamplePop_ID
			HAVING COUNT(DISTINCT QuestionForm_ID) > 1) --and samplepop_id =64511502
		) 

		UPDATE t
		SET IsDeleted = 1
		--SELECT c.*,t.QuestionForm_ID, t.SamplePop_ID, t.returnDate
		FROM QuestionFormTemp t
		LEFT JOIN cleanQF c ON c.SamplePop_ID = t.SamplePop_ID
		WHERE (c.returnDate < t.returnDate  AND c.QuestionForm_ID <> t.QuestionForm_ID)
			OR (c.returnDate = t.returnDate  AND c.QuestionForm_ID <> t.QuestionForm_ID AND c.QuestionForm_ID < t.QuestionForm_ID)
---------------------------------------------------------------------------------------	    
-- Add code to determine days from first mailing as well as days from current mailing until the return    
-- Get all of the maildates for the samplepops were are extracting    
---------------------------------------------------------------------------------------
	SELECT e.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed  
	INTO #Mail    
	FROM (SELECT SamplePop_id FROM QuestionFormTemp WITH (NOLOCK) WHERE ExtractFileID = @ExtractFileID GROUP BY SamplePop_id) e
	INNER JOIN QP_Prod.dbo.ScheduledMailing schm WITH (NOLOCK) ON e.SamplePop_id=schm.SamplePop_id  
	INNER JOIN QP_Prod.dbo.SentMailing sm WITH (NOLOCK) ON schm.SentMail_id=sm.SentMail_id  


	-- Update the work table with the actual number of days    
	UPDATE QuestionFormTemp
	SET datFirstMailed = FirstMail.datMailed
	,DaysFromFirstMailing=DATEDIFF(DAY,FirstMail.datMailed,returnDate)
	,DaysFromCurrentMailing=DATEDIFF(DAY,CurrentMail.datMailed,returnDate)  
	--SELECT *  
	FROM QuestionFormTemp qftemp WITH (NOLOCK)     
	INNER JOIN  (SELECT SamplePop_id, MIN(datMailed) datMailed FROM #Mail GROUP BY SamplePop_id) FirstMail ON qftemp.SamplePop_id=FirstMail.SamplePop_id  
	INNER JOIN #Mail CurrentMail ON qftemp.SamplePop_id = CurrentMail.SamplePop_id AND qftemp.strLithoCode=CurrentMail.strLithoCode      
	WHERE qftemp.ExtractFileID = @ExtractFileID 

	drop table #Mail  
	
	-- Make sure there are no negative days.    
	UPDATE QuestionFormTemp
	SET DaysFromFirstMailing = 0 
	--SELECT *  
	FROM QuestionFormTemp WITH (NOLOCK)  
	WHERE DaysFromFirstMailing < 0 AND ExtractFileID = @ExtractFileID 

	UPDATE QuestionFormTemp
	SET DaysFromCurrentMailing = 0 
	--SELECT *  
	FROM QuestionFormTemp WITH (NOLOCK)  
	WHERE DaysFromCurrentMailing < 0 AND ExtractFileID = @ExtractFileID    
  
 ---------------------------------------------------------------------------------------
 -- Update bitComplete flag for HCACHPS seurveys
 ---------------------------------------------------------------------------------------
	UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=2
    
    CREATE TABLE #HHQF (QuestionForm_id INT, Complete INT, ATACnt INT, Q1 INT, numAnswersAfterQ1 INT)
    INSERT INTO #HHQF (QuestionForm_id)
    select QuestionForm_id 
    from QuestionFormTemp 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=3
    
    exec QP_Prod.dbo.HHCAHPSCompleteness
    
    UPDATE qft 
	SET isComplete=CASE WHEN hh.Complete <> 0 THEN 'true' ELSE 'false' END
	--SELECT *
	FROM QuestionFormTemp qft 
	inner join #HHQF hh on qft.Questionform_id=hh.questionform_id
	
	DROP TABLE #HHQF
    
    UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.MNCMCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=4

 ---------------------------------------------------------------------------------------
 -- Load records to deletes into a temp table
  ---------------------------------------------------------------------------------------
 insert QuestionFormTemp 
			(ExtractFileID, QUESTIONFORM_ID, SAMPLEPOP_ID,strLithoCode,IsDeleted )
		select distinct @ExtractFileID, IsNull(qf.QUESTIONFORM_ID,-1), IsNull(qf.SAMPLEPOP_ID,-1),IsNull(IsNull(eh.PKey2,sm.strLithoCode),-1),1 
  --      select *
		 from (select distinct PKey1 ,PKey2
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 1 ) eh
				Left join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1 AND qf.DATRETURNED IS NULL--if datReturned is not NULL it is not a delete
				Left join QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id

  	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

GO


ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData2]
@ExtractFileID INT
AS
/*
--			S42 US13 OAS: Language in which Survey Completed As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs. 02/04/2016 TSB
*/
SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 11 -- QuestionForm


	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;

--    declare @ExtractFileID int
--	set @ExtractFileID = 527

	CREATE TABLE #ttt
	(
		Tag int not null,
		Parent int null,
			
	    [questionForm!1!id] nvarchar(200) NOT NULL,
	    [questionForm!1!samplePopID] nvarchar(200) NULL,
	    [questionForm!1!isComplete] nvarchar(5) NULL,
	    [questionForm!1!returnDate] smalldatetime NULL,
        [questionForm!1!receiptType_id] int NULL,
        [questionForm!1!DatMailed] datetime NULL, 
        [questionForm!1!DatExpire] datetime NULL, 
        [questionForm!1!DatGenerated] datetime NULL, 
        [questionForm!1!DatPrinted] datetime NULL, 
        [questionForm!1!DatBundled] datetime NULL, 
        [questionForm!1!DatUndeliverable] datetime NULL, 	   
        [questionForm!1!DatFirstMailed] datetime NULL, 	 
	    [questionForm!1!deleteEntity] nvarchar(5) NULL,
		[questionForm!1!LangID] int NULL,
	    
	    [bubbleData!2!nrcQuestionCore] int NULL,
	    [bubbleData!2!sampleunitid] nvarchar(200) NULL,
	    
	    [rvals!3!v] int NULL,
	    
	    [comment!4!Cmnt_id] int NULL,
		--[comment!4!Cmnt_id!hide] int NULL,
	    [comment!4!nrcQuestionCore] int NULL,
	    [comment!4!commentType] nvarchar(50) NULL,
	    [comment!4!commentValence] nvarchar(50) NULL,
	    [comment!4!isSuppressedOnWeb] nvarchar(5) NULL,
	    [comment!4!sampleunitid] nvarchar(200) NULL,
        [comment!4!datEntered] smalldatetime NULL,
	    
	    [codes!5!cd] int NULL,
	    
	    [masked!6!seq!hide] int null,
	    [masked!6!t!element] text null,
	    
	    [unmasked!7!seq!hide] int null,
	    [unmasked!7!t!element] text null
  )
  

  declare @TestString nvarchar(40)
    set @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'
  
  delete from CommentTextTempError where ExtractFileID = @ExtractFileID

  insert Into CommentTextTempError
  select *
  from CommentTextTemp
  where ExtractFileID = @ExtractFileID 
    and PATINDEX (@TestString, BlockData COLLATE Latin1_General_BIN) > 0   

  -- insert records for inserted/updated records
  insert #ttt
  	select 1 as Tag, NULL as Parent,
  		   strLithoCode As questionform_id,
  		   samplepop_id,
  		   isComplete,
  		   returnDate,
  		   ReceiptType_ID,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed,
  		   NULL, -- deleteEntity defaults to FALSE
		   [LangID], 

		   NULL,NULL,
		   NULL,
		   NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   NULL,NULL,
		   NULL,NULL
	  from QuestionFormTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID and IsDeleted = 0
  
  -- insert records for deleted records
  insert #ttt
  	select 1 as Tag, NULL as Parent,  		   
  		   strLithoCode As questionform_id, samplepop_id, NULL, NULL, NULL                     
           ,NULL,NULL,NULL,NULL,NULL,NULL,NULL
           ,'true' as deleteEntity,
		   NULL, -- LangID

		   NULL,NULL,
		   NULL,
		   NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   NULL,NULL,
		   NULL,NULL
	  from QuestionFormTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID and IsDeleted = 1
  
       
  -- insert comments
  insert #ttt
  	select 4 as Tag, 1 as Parent,
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,

 		   Cmnt_id,
		   nrcQuestionCore,
		   commentType,
		   commentValence,
		   isSuppressedOnWeb,
		   SAMPLEUNIT_ID,
           datEntered,
		   
		   NULL,
		   NULL,NULL,
		   NULL,NULL
	  from CommentTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
      
  -- insert comment codes
  insert #ttt
  	select 5 as Tag, 4 as Parent,  	
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,
		   Cmnt_id,NULL,NULL,NULL,NULL,NULL,NULL,
		   code,
		   NULL,NULL,
		   NULL,NULL
	  from CommentCodeTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
      
  -- insert comment text
  insert #ttt
  	select 6 as Tag, 4 as Parent,  	
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,
		   Cmnt_id,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   
		   BlockNum, BlockData,
		   
		   NULL,NULL
	  from CommentTextTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
	   and IsMasked <> 0
       and not exists (select 1
                      from CommentTextTempError with (NOLOCK)
                      where CommentTextTemp.LithoCode = CommentTextTempError.LithoCode
                       and CommentTextTemp.Cmnt_id = CommentTextTempError.Cmnt_id
                        and CommentTextTemp.IsMasked = CommentTextTempError.IsMasked 
                       and CommentTextTemp.BlockNum = CommentTextTempError.BlockNum
                       and CommentTextTempError.ExtractFileID = @ExtractFileID)    
      
  -- insert comment text
  insert #ttt
  	select 7 as Tag, 4 as Parent,  	
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,
		   Cmnt_id,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   
		   NULL,NULL,
		   
		   BlockNum, BlockData
		   
	  from CommentTextTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
	   and IsMasked = 0
       and not exists (select 1
                      from CommentTextTempError with (NOLOCK)
                      where CommentTextTemp.LithoCode = CommentTextTempError.LithoCode
                       and CommentTextTemp.Cmnt_id = CommentTextTempError.Cmnt_id
                        and CommentTextTemp.IsMasked = CommentTextTempError.IsMasked 
                       and CommentTextTemp.BlockNum = CommentTextTempError.BlockNum
                       and CommentTextTempError.ExtractFileID = @ExtractFileID)  
  
  select *
    from #ttt With (NOLOCK)
    ORDER BY  [questionForm!1!id], [bubbleData!2!nrcQuestionCore],[rvals!3!v],
			[comment!4!Cmnt_id], [codes!5!cd], [masked!6!seq!hide], [unmasked!7!seq!hide]
     for xml explicit
  

  drop table #ttt

  	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

GO

