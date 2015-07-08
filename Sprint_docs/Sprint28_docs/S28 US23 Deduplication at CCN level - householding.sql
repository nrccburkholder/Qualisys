/*
	S28 US23	de-duplication at CCN level
	As a team we want to finish development of de-dup at CCN level
	per HCAHPS compliance. Next visit is Oct.  Split work over multiple sprints	2

	23.2	make modifications to stored procedures

Dave Gilsdorf

QP_Prod:
ALTER PROCEDURE [dbo].[QCL_SampleSetHouseholdingExclusion]
*/
go
use qp_Prod
go
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
ALTER PROCEDURE [dbo].[QCL_SampleSetHouseholdingExclusion]
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
      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ', pop_id int, CCN varchar(20))
		  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ', pop_id, CCN)
		  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
			  , 'x.', ',9999999),ISNULL(')
			  , ', ,', ',')
			  , 12, 2000) 
			  + ',9999999), p.pop_id, suf.MedicareNumber as CCN
		  FROM sampleset ss
			   INNER JOIN eligibleenclog h ON ss.sampleset_id = h.sampleset_id 
		       INNER JOIN SampleUnit su ON h.sampleunit_id= su.sampleunit_Id 
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
		  WHERE x.sampleunit_id = suf.sampleunit_id 
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
		  and sfu.MedicareNumber = y.CCN
		  and isnull(x.removed_rule, 0) = 0  
		  and x.pop_id = y.pop_id

		  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 10 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
		  FROM #SampleUnit_Universe x, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = sfu.sampleunit_id
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
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
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
go