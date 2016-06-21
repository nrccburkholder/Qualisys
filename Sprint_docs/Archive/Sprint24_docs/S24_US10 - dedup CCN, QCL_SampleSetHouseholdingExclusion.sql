select * from sys.procedures where object_id in (select id from syscomments where text like '%#SampleUnit_Universe%')
order by 1

select * from sys.tables where name like '%samp%' order by 1

select * from SamplingAlgorithm
select top 1000 * from SamplingLog order by 1 desc
select * from SamplingMethod

select top 100 hhr.*, mt.strTable_nm, mf.strField_nm
from HouseholdRule hhr
inner join survey_def sd on hhr.survey_id=sd.survey_id
inner join metatable mt on hhr.table_id=mt.table_id
inner join metafield mf on hhr.field_id=mf.field_id
where sd.surveytype_id=2
and hhr.survey_id in (4203,8299,6977,8293,8297,7121,11780,7458,10326,15152,11194,7444,8400,7450,7473,14039,10712,7878,11659,11722,7442,9978,8404,9706,9975,14707,9491,9741,8006,9732)
order by hhr.survey_id, hhr.householdrule_id

select * from sys.procedures where object_id in (select id from syscomments where text like '%QCL_SampleSetHouseholdingExclusion%')

sp_Helptext QCL_SelectEncounterUnitEligibility
sp_Helptext QCL_InsertSamplingLog
sp_helptext sp_samp_HouseholdingMinor
sp_helptext sp_samp_FetchHouseholdingVals
sp_helptext qcl_gethcahpseligiblecount
sp_helptext sp_Samp_CreateTempTables

      DECLARE @HHFields TABLE (Fieldname VARCHAR(50) ,
                               DataType VARCHAR(20) ,
                               Length INT ,
                               Field_id INT)        
            INSERT   INTO @HHFields
                     SELECT   strTable_nm + strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
                     FROM     dbo.HouseHoldRule HR ,
                              MetaData_View m
                     WHERE    HR.Table_id = M.Table_id
                              AND HR.Field_id = M.Field_id
                              AND HR.Survey_id = 1415 -- SELECT * FROM SURVEY_DEF WHERE surveytype_id=2                                             

          DECLARE @HouseHoldFieldSelectSyntax VARCHAR(1000)='' ,
  @HouseHoldFieldSelectBigViewSyntax VARCHAR(1000) ='',
         @HouseHoldFieldCreateTableSyntax VARCHAR(1000)='' 

            SELECT   @HouseHoldFieldSelectSyntax = @HouseHoldFieldSelectSyntax + ', X.' + Fieldname
            FROM     @HHFields
            ORDER BY Field_id                                                
            SET @HouseHoldFieldSelectSyntax = SUBSTRING(@HouseHoldFieldSelectSyntax, 2,
                                                        LEN(@HouseHoldFieldSelectSyntax) - 1)                                                

print isnull(@HouseHoldFieldSelectSyntax , 'shit')



 SELECT @SQL = 'CREATE TABLE #SampleUnit_Universe (
   id_num int IDENTITY
 , SampleUnit_id int
 , Pop_id
 , Enc_id
 , ' + @vcHH_Field_CreateTable  +  '
 , Age int
 , DQ_Bus_Rule int
 , Removed_Rule TINYINT DEFAULT 0
 , strUnitSelectType varchar(1)
 , EncDate datetime
 , ReSurveyDate DATETIME
 , reportDate datetime)'


/*                      
Created:  04/13/2012 Don Mayhew    

08/30/2013 Lee Kohrs
  Removed the following snippet to improve performance
  -- and not exists ( select ''x'' from dbo.vw_Billians_NursingHomeAssistedLiving v           
  --   where isnull(v.Street_Address, '''') = isnull(p.addr, '''') and          
  --     isnull(v.mail_Address, '''') = isnull(p.addr2, '''') and           
  --     isnull(v.city, '''') = isnull(p.city, '''') and          
  --     isnull(v.state, '''') = isnull(p.st, '''') and          
  --     isnull(substring(v.street_zip,1,5), '''') = isnull(p.zip5, '''') 
  Added the following to delete records matching the vw_Billians_NursingHomeAssistedLiving view
    DELETE #Distinct
    FROM   #Distinct d
       INNER JOIN vw_Billians_NursingHomeAssistedLiving v
               ON d.POPULATIONAddr = v.Street_Address
                  AND d.POPULATIONaddr2 = v.mail_Address
                  AND d.POPULATIONcity = v.city
                  AND d.POPULATIONst = v.state
                  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)                 

11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using 
													vw_Billians_NursingHomeAssistedLiving to be run in country=US only              
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
*/
CREATE PROCEDURE [dbo].[sp_helptext QCL_SampleSetHouseholdingExclusion]
  @Study_id                      INT,
  @Survey_ID                     INT,
  @startDate                     DATETIME,
  @EndDate                       DATETIME,
  @strHouseholdField_CreateTable VARCHAR(8000),/* List of fields and type that are used for HouseHolding criteria */
  @strHouseholdField_Select      VARCHAR(8000),/* List of fields that are used for HouseHolding criteria */
  @strHousehold_Join             VARCHAR(8000),
  @HouseHoldingType              CHAR(1),
  @Sampleset_ID                  INT = 0,
  @indebug                       INT = 0
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @sql VARCHAR(8000)
  DECLARE @BOM DATETIME,
          @EOM DATETIME

  SET @BOM = dateadd(dd, -day(@startDate) + 1, @startDate)
  SET @EOM = dateadd(dd, -1, dateadd(mm, 1, @BOM))

  IF @HouseHoldingType = 'A'
    BEGIN
    -- all those REPLACE() and the SUBSTRING() change this:
    --  X.POPULATIONAddr, X.POPULATIONCity, X.POPULATIONST, X.POPULATIONZIP5, X.POPULATIONAddr2
    -- to this:
    -- ISNULL(Addr,9999999),ISNULL(City,9999999),ISNULL(ST,9999999),ISNULL(ZIP5,9999999),ISNULL(Addr2,9999999)
      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ', pop_id int, CCN varchar(20))
  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ', pop_id, CCN)
  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
	, 'x.', ',9999999),ISNULL(')
	, ', ,', ',')
	, 12, 2000) 
	+ ',9999999), p.pop_id, suf.MedicareNumber as CCN
  FROM  SampleUnit su
  INNER JOIN eligibleenclog h ON h.sampleunit_id= su.sampleunit_Id
  INNER JOIN sampleset ss ON ss.sampleset_id = h.sampleset_id 
  INNER JOIN survey_def sd ON sd.survey_id = ss.survey_id 
  INNER JOIN S' + LTRIM(STR(@Study_id)) + '.Population p ON h.Pop_id=p.Pop_id 
  INNER JOIN SUFacility suf on su.sampleunit_id=suf.sampleunit_id 
  WHERE sd.Study_id=' + LTRIM(STR(@Study_id)) + '
  AND sampleEncounterDate BETWEEN ''' + CONVERT(VARCHAR, @BOM) + ''' AND  ''' + CONVERT(VARCHAR, @EOM) + '''
  and su.bitHCAHPS = 1
  and su.dontsampleunit = 0

--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using 
--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only              
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
IF @country=''US''
    DELETE #Distinct
    FROM   #Distinct d
       INNER JOIN vw_Billians_NursingHomeAssistedLiving v
               ON d.POPULATIONAddr = v.Street_Address
                  AND d.POPULATIONaddr2 = v.mail_Address
                  AND d.POPULATIONcity = v.city
                  AND d.POPULATIONst = v.state
                  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)               
                       
  UPDATE x                          
  SET x.Removed_Rule=10  
  FROM #SampleUnit_Universe x, SUFacility sfu, #Distinct y                   
  WHERE x.sampleunit_id=sfu.sampleunit_id 
  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
  and sfu.MedicareNumber = y.CCN 
  and isnull(x.removed_rule, 0) = 0  
  and x.pop_id = y.pop_id

  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, ' + cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 10 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
  FROM #SampleUnit_Universe x, SUFacility sfu, #Distinct y                   
  WHERE x.sampleunit_id=sfu.sampleunit_id 
  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
  and sfu.MedicareNumber = y.CCN 
  and x.pop_id = y.pop_id 
  and x.removed_rule = 10

  UPDATE x                          
  SET x.Removed_Rule=7                          
  FROM #SampleUnit_Universe x, SUFacility sfu, #Distinct y
  WHERE x.sampleunit_id=sfu.sampleunit_id 
  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
  and sfu.MedicareNumber = y.CCN 
  and isnull(x.removed_rule, 0) = 0 
  and x.pop_id <> y.pop_id  
            
  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)            
  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, ' + cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID            
  FROM #SampleUnit_Universe x, SUFacility sfu, #Distinct y
  WHERE x.sampleunit_id=sfu.sampleunit_id 
  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
  and sfu.MedicareNumber = y.CCN 
  and x.removed_rule = 7                     
            
--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using 
--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only              
IF @country=''US''
  UPDATE x                          
  SET x.Removed_Rule= -7                          
  FROM #SampleUnit_Universe x, S' + LTRIM(STR(@Study_id)) + '.Population p             
  WHERE x.pop_ID = p.pop_ID and x.removed_rule = 0             
  and exists     ( select ''x''             
     from vw_Billians_NursingHomeAssistedLiving v             
     WHERE  isnull(p.addr, '''') = v.Street_Address
       AND isnull(p.addr2, '''') = v.mail_Address
       AND isnull(p.city, '''') = v.city
       AND isnull(p.st, '''') = v.state
       AND isnull(p.zip5, '''') = LEFT(v.street_zip, 5)           
     )            
                 
  DROP TABLE #Distinct'

      SELECT @sql = replace(@sql, 'DOB,9999999', 'DOB,''12/31/4000''')

      SELECT @sql = replace(@sql, 'Date,9999999', 'Date,''12/31/4000''')

      IF @indebug = 1
        PRINT @sql

      EXEC (@sql)
    END


