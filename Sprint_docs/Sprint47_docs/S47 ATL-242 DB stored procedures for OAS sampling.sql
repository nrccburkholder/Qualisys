/*
	S47 ATL-157 Implement OAS Systematic Sampling Algorithm
	
	ATL-242 Implement DB stored procedures branching logic between the StaticPlus and Systematic algos
	
*/
use QP_Prod
go
if exists (select * from sys.procedures where name = 'QCL_CalculateSystematicSamplingOutgo')
	drop procedure QCL_CalculateSystematicSamplingOutgo
go
create procedure dbo.QCL_CalculateSystematicSamplingOutgo
@survey_id int, @samplingdate datetime
as

declare @CCN varchar(20)
select @CCN = suf.medicarenumber
from sampleplan sp
inner join sampleunit su on sp.SAMPLEPLAN_ID=su.sampleplan_id
inner join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
where sp.survey_id=@survey_id
and su.CAHPSType_id>0

if @CCN is null
	RAISERROR (N'Surveys using Systematic Sampling must have at least one unit defined as a CAHPS unit and linked to a CCN.',
           10, -- Severity
           1); -- State

if exists (select * from SystematicSamplingTarget where SampleQuarter = dbo.yearqtr(@samplingdate) and CCN=@CCN)
begin
	return
end

-- declare @survey_id int=19009, @samplingdate datetime = '7/1/16'
create table #SystematicSamplingTarget
(	SampleQuarter char(6)
,	CCN varchar(20)
,	numLocations smallint
,	SamplingAlgorithmID int
,	RespRateType varchar(15)
,	numResponseRate decimal(5,4)
,	AnnualTarget int
,	QuarterTarget int
,	MonthTarget int
,	SamplesetsPerMonth smallint
,	SamplesetTarget numeric(6,2)
,	OutgoNeededPerSampleset int
)

insert into #SystematicSamplingTarget (SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget)
select dbo.yearqtr(@samplingdate) as SampleQuarter
	, suf.medicarenumber as CCN
	, count(su.SAMPLEUNIT_ID) as numLocations
	, 4 as SamplingAlgorithmID
	, case when dbo.yearqtr(min(SwitchToCalcDate)) < dbo.yearqtr(@samplingdate) then 'Historic' else 'Default' end as RespRateType
	, case when dbo.yearqtr(min(SwitchToCalcDate)) < dbo.yearqtr(@samplingdate) then NULL else min(mlu.EstRespRate) end as numResponseRate 
	, min(mlu.AnnualReturnTarget) as AnnualTarget
	, ceiling(min(mlu.AnnualReturnTarget)/4.0) as QuarterTarget
	, ceiling(min(mlu.AnnualReturnTarget)/12.0) as MonthTarget
from sampleplan sp
inner join sampleunit su on sp.SAMPLEPLAN_ID=su.sampleplan_id
inner join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
inner join medicarelookup mlu on suf.medicarenumber=mlu.medicarenumber
where sp.survey_id=@survey_id
and su.CAHPSType_id=16
group by suf.medicarenumber 

if @@rowcount > 1
	RAISERROR (N'Surveys using Systematic Sampling can only reference one CCN.',
           10, -- Severity
           1); -- State

-- if MedicareLookup.AnnualReturnTarget isn't evenly divisible by 12, change AnnualTarget and QuarterTarget so that they align with the CEILING'd MonthTarget
if exists (select * from #SystematicSamplingTarget where AnnualTarget % 12 <> 0)
	update #SystematicSamplingTarget set AnnualTarget=12*MonthTarget, QuarterTarget=3*MonthTarget

if exists (select * from #SystematicSamplingTarget where RespRateType='Historic')
begin
	declare @rr float
	
	select @rr=1.0*sum(numReturned)/sum(numSampled)
	from (	select ss.sampleset_id, count(distinct sp.samplepop_id) as numSampled, count(distinct case when qf.datReturned is not null then qf.samplepop_id end) as numReturned, max(sm.datExpire) as datExpire
			from sampleset ss
			inner join samplepop sp on ss.sampleset_id=sp.sampleset_id
			inner join scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
			inner join sentmailing sm on scm.sentmail_id=sm.sentmail_id
			inner join questionform qf on scm.sentmail_id=qf.sentmail_id
			where ss.survey_id = @survey_id
			group by ss.sampleset_id
			having max(sm.datExpire)<getdate()
		) x

	update #SystematicSamplingTarget set numResponseRate = @rr where RespRateType='Historic'
end

if exists (select * from #SystematicSamplingTarget where numResponseRate is NULL or numResponseRate=0)
begin
	declare @RRtype varchar(15)
	select @RRType = RespRateType from #SystematicSamplingTarget
	RAISERROR (N'%s response rate cannot be 0 percent.',
           10, -- Severity,
           1, -- State
		   @RRtype); 
end

update #SystematicSamplingTarget 
set SamplesetsPerMonth=(select CEILING(sum(intExpectedSamples)/3.0)
						from #SystematicSamplingTarget sst
						inner join PeriodDef pd on sst.samplequarter = dbo.yearqtr(pd.datExpectedEncStart) and pd.survey_id=@survey_id)

update #SystematicSamplingTarget set SamplesetTarget=1.0*MonthTarget/SamplesetsPerMonth
update #SystematicSamplingTarget set OutgoNeededPerSampleset=CEILING(SamplesetTarget/numResponseRate)

insert into dbo.SystematicSamplingTarget (SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget, SamplesetsPerMonth, SamplesetTarget, OutgoNeededPerSampleset)
select SampleQuarter, CCN, numLocations, SamplingAlgorithmID, RespRateType, numResponseRate, AnnualTarget, QuarterTarget, MonthTarget, SamplesetsPerMonth, SamplesetTarget, OutgoNeededPerSampleset
from #SystematicSamplingTarget 

drop table #SystematicSamplingTarget
go
if exists (select * from sys.procedures where name = 'QCL_GetSystematicSamplingOutgo')
	drop procedure QCL_GetSystematicSamplingOutgo
go
CREATE PROCEDURE dbo.QCL_GetSystematicSamplingOutgo
@Sampleset_id int
AS 
SELECT ssp.SampleQuarter, ssp.CCN, ssp.SampleUnit_id, ssp.sampleset_id, ssp.EligibleCount, ssp.EligibleProportion, ssp.OutgoNeeded, ssp.Increment
FROM SystematicSamplingProportion ssp 
WHERE ssp.Sampleset_id=@Sampleset_id
go
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
/*
begin tran
declare 
   @Survey_id INT                   = 16088,
   @Study_id INT 					= 4858,
   @DataSet VARCHAR(2000) 			= 291258,
   @startDate DATETIME 				= '2/1/2016',
   @EndDate DATETIME 				= '2/29/2016',
   @seed INT 						= 1286916015,
   @ReSurvey_Period INT 			= 6,
   @EncounterDateField VARCHAR(42) 	= 'ENCOUNTERServiceDate',
   @ReportDateField VARCHAR(42) 	= 'ENCOUNTERServiceDate',
   @encTableExists BIT 				= 1,
   @sampleSet_id INT 				= 1219045,
   @samplingMethod INT				= 2, --SpecifyOutgo
   @resurveyMethod_id INT 			= 2, --CalendarMonths
   @samplingAlgorithmId AS INT		= 3  --StaticPlus
--*/
      SET NOCOUNT ON
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

      DECLARE @indebug TINYINT ,
         @SamplingLogInsert TINYINT
      SET @indebug = 0
      SET @SamplingLogInsert = 1

      DECLARE @FromDate VARCHAR(10) ,
         @ToDate VARCHAR(10)

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


            EXEC (@Sel)


            SELECT   @sel = REPLACE(@sel, '#HH_Dup_People', '#Minor_Universe')
            EXEC (@Sel)

            SELECT   @sel = REPLACE(@sel, '#Minor_Universe', '#Minor_Exclude')
            EXEC (@Sel)

            SELECT   @sel = REPLACE(@sel, '#Minor_Exclude', '#HouseHold_Dups')
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


    IF @SurveyType_ID in (@hospiceCAHPS,  @OASCAHPS) --IF @SurveyType_ID = @OASCAHPS CJB for TMB 2/25/2016
    BEGIN

        DECLARE @schema varchar(10)

        SET @schema = 'S' + CAST(@study_id as varchar)
        IF EXISTS (select 1
        from QP_PROD.information_schema.columns c
        where table_schema = @schema and table_name = 'Big_View' and
              column_name = 'EncounterCCN')
        BEGIN
            -- it exists, so add it
              IF NOT EXISTS ( SELECT  1
                          FROM    @tbl
                          WHERE   FieldName = 'EncounterCCN' )
             INSERT   INTO @tbl
                      SELECT   'EncounterCCN', 'V', 10, '9999'
        END
    END


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

            EXEC (@Sel)
         END


      IF @encTableExists = 1
      BEGIN
         CREATE INDEX popenc ON #BVUK (Populationpop_id, EncounterEnc_id)
      END
      ELSE
      BEGIN
         CREATE INDEX Populationpop_id ON #BVUK (Populationpop_id)
      END

      CREATE TABLE #Criters (Survey_id INT ,
                             CriteriaStmt_id INT ,
                             strCriteriaStmt VARCHAR(7900) ,
                             BusRule_cd VARCHAR(20))

      INSERT   INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)
               SELECT   Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
               FROM     CriteriaStmt c ,
                        BusinessRule b
               WHERE    c.CriteriaStmt_id = b.CriteriaStmt_id
                        AND c.Study_id = @Study_id
                        AND BusRule_cd = 'Q'
                        AND Survey_id = @Survey_id

      INSERT   INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)
               SELECT   Survey_id, c.CriteriaStmt_id, strCriteriaString, 'C'
               FROM     CriteriaStmt c ,
                        SampleUnit su ,
                        Sampleplan sp
               WHERE    c.CriteriaStmt_id = su.CriteriaStmt_id
                        AND c.Study_id = @Study_id
                        AND su.Sampleplan_id = sp.Sampleplan_id
                        AND Survey_id = @Survey_id


 --Add the bad address and bad phone criterias
      INSERT   INTO #Criters (Survey_id, CriteriaStmt_id, strCriteriaStmt, BusRule_cd)
               SELECT   Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
               FROM     CriteriaStmt c ,
                        BusinessRule b
               WHERE    c.CriteriaStmt_id = b.CriteriaStmt_id
                        AND c.Study_id = @Study_id
                        AND BusRule_cd IN ('F', 'A')
                        AND Survey_id = @Survey_id



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
                  BEGIN
    --build the temp table.
                     SET @Sel = 'INSERT INTO #BVUK(' + @Sql + ')
                                  SELECT ' + @Sel + '
                                  FROM s' + CONVERT(VARCHAR, @Study_id)
                                                        + '.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
                                  WHERE dsm.DataSet_id=t.DataSet_id
                                  AND dsm.Enc_id=b.EncounterEnc_id
                                  AND (' + @Criteria + ')' + @strDateWhere
                END
                ELSE
                BEGIN
                     SET @Sel = 'INSERT INTO #BVUK(' + @Sql + ')
                                  SELECT ' + @Sel + '
                                  FROM s' + CONVERT(VARCHAR, @Study_id)
                                                        + '.Big_View b(NOLOCK), DataSetMember dsm(NOLOCK), #DataSets t
                                  WHERE dsm.DataSet_id=t.DataSet_id
                                  AND dsm.Pop_id=b.PopulationPop_id
                                  AND (' + @Criteria + ')' + @strDateWhere
                 END

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

            EXEC (@Sel)




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
                          OR ((s.bitHCAHPS = 1 or s.CahpsType_id = @OASCahps)
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


                  EXEC (@Sel)

                  SELECT   @Sel = 'insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
                                   Select ' + CAST(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, ' + CAST(@Sampleset_ID AS VARCHAR(10))
                                    + ' as Sampleset_ID, Sampleunit_ID, Pop_ID,  4 as SamplingExclusionType_ID, '
                                    + CONVERT(VARCHAR, @DQ_id) + ' as DQ_BusRule_ID
                                   FROM #PreSample p, #BVUK b
                                   WHERE p.Pop_id=b.Populationpop_id
                                   AND (' + @Criteria + ')'


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

                  EXEC (@Sel)
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


            EXEC (@Sel)

            DELETE   #Criters
            WHERE    CriteriaStmt_id = @DQ_id

            SELECT TOP 1
                     @Criteria = strCriteriaStmt, @DQ_id = CriteriaStmt_id
            FROM     #Criters
            WHERE    BusRule_cd = 'A'
            ORDER BY CriteriaStmt_id

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


      EXEC (@Sel)



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

      EXEC QCL_SampleSetIndexUniverse @encTableExists



 --MWB 04/08/2010
 --If SurveyType = HHCAHPS need to capture the distinct count of pop_IDs that fit the HHCAHPS Unit
 --and save it off to new table.
      IF @SurveyType_ID in (@HHCAHPS)
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
                              AND su.CAHPSType_id in (@HHCAHPS)
                     GROUP BY suni.SampleUnit_id, ml.MedicareNumber
         END

    -- as per QA, hospice and OAS counts are for the entire dataset BEFORE criteria are applied
    IF @SurveyType_ID in (@hospiceCAHPS,  @OASCAHPS) -- 02/4/2016 TSB  S42 US12: added OAS
    BEGIN
        INSERT INTO CAHPS_PatInfileCount (Sampleset_ID, Sampleunit_ID, MedicareNumber, NumPatInFile)
        SELECT @sampleset_id,su.SampleUnit_id, f.MedicareNumber, COUNT(*)
        FROM     #BVUK b
        inner join SUFacility f on f.MedicareNumber = b.EncounterCCN
        inner join SampleUnit su on su.SUFacility_id = f.SUFacility_id
        WHERE    su.CAHPSType_id in (@hospiceCAHPS,@OASCAHPS)
        GROUP BY su.SampleUnit_id, f.MedicareNumber

    END


 --MWB 9/2/08  HCAHPS Prop Sampling Sprint -- run TOCL before writing HCAHPSEligibleEncLog table
      IF @bitDoTOCL = 1
         BEGIN
            EXEC QCL_SampleSetTOCLRule @study_id, @Survey_id, @sampleSet_id, 1
         END

 --MWB 9/2/08  HCAHPS Prop Sampling Sprint -- Exclude encounters already sampled.  Fix of existing bug
      EXEC QCL_RemovePreviousSampledEncounters @study_id, @Survey_id, @sampleSet_id


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


      EXEC QCL_SampleSetAssignHouseHold @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax,
         @HouseHoldJoinSyntax, @HouseHoldingType

     

 -- Apply the resurvey exclusion rule
      EXEC QCL_SampleSetResurveyExclusion_StaticPlus @study_id, @Survey_id, @resurveyMethod_id, @ReSurvey_Period,
         @samplingAlgorithmId, @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax, @HouseHoldJoinSyntax,
         @HouseHoldingType, @sampleSet_id, @indebug

   

--adding check for HCAHPS survey type 4/24/2012 dmp
      IF @SurveyType_ID = 2
         BEGIN

 --DRM 3/19/2012 Householding
            EXEC QCL_SampleSetHouseholdingExclusion @study_id, @Survey_id, @startdate, @enddate,
               @HouseHoldFieldCreateTableSyntax, @HouseHoldFieldSelectSyntax, @HouseHoldJoinSyntax, @HouseHoldingType,
               @sampleSet_id, @indebug
         END


 --DRM 3/19/2012 Householding
      EXEC QCL_SampleSetPerformHousehold @survey_id, @sampleset_id



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
            WHERE     spw.sampleset_id = @sampleSet_id
                AND  spw.SampleUnit_id = s.SAMPLEUNIT_ID
                AND  s.CAHPSType_id = @HCAHPS
       END

--------------9/10/2014

    

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

      DELETE   FROM #SampleUnit_Universe
      WHERE    Removed_Rule NOT IN (0, 4)



 --Update the Universe count in SPW
      SELECT TOP 1
               @RemovedRule = Removed_Rule, @unit = sampleunit_Id, @freq = freq
      FROM     #UnSampleAbleRR

      WHILE @@ROWCOUNT > 0
         BEGIN

            SELECT   @RuleName = SamplingExclusionType_nm
            FROM     SamplingExclusionTypes
            WHERE    SamplingExclusionType_ID = @RemovedRule

            EXEC QCL_InsertRemovedRulesIntoSPWDQCOUNTS @sampleset_Id, @unit, @RuleName, @freq

            DELETE   FROM #UnSampleAbleRR
            WHERE    Removed_Rule = @removedRule
                     AND sampleunit_Id = @unit

            SELECT TOP 1
                     @RemovedRule = Removed_Rule, @unit = sampleunit_Id, @freq = freq
            FROM     #UnSampleAbleRR
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

      IF dbo.SurveyProperty ('IsSystematic', null, @Survey_id) = 1	  
	  BEGIN
		  SELECT   suu.SampleUnit_id, suu.Pop_id, suu.Enc_id, suu.DQ_Bus_Rule, suu.Removed_Rule, suu.EncDate, suu.HouseHold_id,
				   suu.bitBadAddress, suu.bitBadPhone, suu.reportDate, rp.numRandom, su.CAHPSType_id, suf.MedicareNumber as CCN
		  INTO #OAS
		  FROM     #SampleUnit_Universe suu 
				   INNER JOIN #randomPops rp ON suu.Pop_id = rp.Pop_id
				   INNER JOIN SampleUnit su on suu.SampleUnit_id=su.SampleUnit_id
				   LEFT JOIN SUFacility suf on su.SUFacility_id=suf.SUFacility_id
		  ORDER BY rp.numrandom, Enc_id

		  -- NULL out all random numbers, except for the smallest one per SampleUnit
		  UPDATE o set numRandom=NULL
		  FROM #OAS o
		  LEFT JOIN (SELECT SampleUnit_id,MIN(numRandom) as SmallestRand from #OAS group by SampleUnit_id) small on o.SampleUnit_id=small.SampleUnit_id and o.numRandom=small.SmallestRand
		  WHERE small.SampleUnit_id is NULL
		  
		  -- update numRandom to be enc_id so that when we sort by numRandom, it's sorting by enc_id
		  -- also, add an offset to encounters before the smallest so that the smallest will be first in the list, followed 
		  -- by encounters after the smallest, then loop back to the beginning of the list.
		  update o set numRandom=o.enc_id+case when o.enc_id<small.enc_id then 100000000 else 0 end 
		  from #OAS o
		  inner join (select SampleUnit_id,ENC_id,numRandom from #OAS where numRandom is not NULL) small on o.SampleUnit_id=small.SampleUnit_id

		  create table #SystematicSamplingProportion
		  (	SampleQuarter char(6)
		  ,	CCN varchar(20)
		  ,	SampleUnit_id int
		  ,	Sampleset_id int
		  ,	EligibleCount int
		  ,	EligibleProportion numeric(5,4)
		  ,	OutgoNeeded int
		  , Increment int
		  )

		  insert into #SystematicSamplingProportion (SampleQuarter, CCN, SampleUnit_id, Sampleset_id, EligibleCount)
		  select dbo.yearqtr(encDate), CCN, SampleUnit_id, @Sampleset_id, count(*) as EligibleCount
		  from #OAS
		  where CAHPSType_id=16
		  and DQ_Bus_Rule = 0
		  group by dbo.yearqtr(encDate), CCN, SampleUnit_id

		  if @startDate is null
			select @startDate=min(encDate)
			from #OAS
			where encDate is not null

		  -- make sure there's a record in SystematicSamplingTarget 
		  exec QCL_CalculateSystematicSamplingOutgo @survey_id, @startDate 

		  update #SystematicSamplingProportion 
		  set EligibleProportion = 1.0 * EligibleCount / (select sum(EligibleCount) from #SystematicSamplingProportion)

		  update ssp 
		  set OutGoNeeded = ceiling(sst.OutgoNeededPerSampleset * ssp.EligibleProportion)
		  from #SystematicSamplingProportion ssp
		  inner join SystematicSamplingTarget sst on ssp.SampleQuarter=sst.SampleQuarter and ssp.CCN=sst.CCN

		  update #SystematicSamplingProportion 
		  set Increment=(select sum(EligibleCount) / sum(OutGoNeeded)
						 from #SystematicSamplingProportion)

		  delete from SystematicSamplingProportion 
		  where Sampleset_id=@sampleSet_id

		  insert into SystematicSamplingProportion (SampleQuarter, CCN, SampleUnit_id, Sampleset_id, EligibleCount, EligibleProportion, OutgoNeeded, Increment)
		  select SampleQuarter, CCN, SampleUnit_id, Sampleset_id, EligibleCount, EligibleProportion, OutgoNeeded, Increment
		  from #SystematicSamplingProportion 

		  select SampleUnit_id, Pop_id, Enc_id, DQ_Bus_Rule, Removed_Rule, EncDate, HouseHold_id,
				 bitBadAddress, bitBadPhone, reportDate, numRandom, CCN
		  from #OAS
		  order by SampleUnit_id, numRandom
		  
		  DROP TABLE #OAS
		  DROP TABLE #SystematicSamplingProportion 
	  END
	  ELSE
	  BEGIN
		  --Return data sorted by randomPop_id
		  SELECT   suu.SampleUnit_id, suu.Pop_id, suu.Enc_id, suu.DQ_Bus_Rule, suu.Removed_Rule, suu.EncDate, suu.HouseHold_id,
				   suu.bitBadAddress, suu.bitBadPhone, suu.reportDate, rp.numRandom, suf.MedicareNumber as CCN
		  FROM     #SampleUnit_Universe suu 
				   INNER JOIN #randomPops rp ON suu.Pop_id = rp.Pop_id
				   INNER JOIN SampleUnit su on suu.SampleUnit_id=su.SampleUnit_id
				   LEFT JOIN SUFacility suf on su.SUFacility_id=suf.SUFacility_id
		  ORDER BY rp.numrandom, Enc_id
	  END




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
