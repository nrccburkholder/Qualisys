/*

S71_ATL-1419 Resurvey Exclusion for Returns Only.sql

Chris Burkholder

3/20/2017

INSERT INTO SubTypeCategory
INSERT INTO SubType
INSERT INTO SurveyTypeSubtype
ALTER PROCEDURE [dbo].[QCL_SampleSetResurveyExclusion_StaticPlus]

select * from surveytype
select * from subtypecategory
select * from subtype
select * from surveytypesubtype

*/

USE [QP_Prod]
GO

if not exists(select * from SubTypeCategory where SubtypeCategory_nm = 'Resurvey Exclusion Type')
INSERT INTO [dbo].[SubtypeCategory]
           ([SubtypeCategory_nm]
           ,[bitMultiSelect])
     VALUES
           ('Resurvey Exclusion Type'
           ,0)
GO

if not exists(select * from Subtype where Subtype_nm = 'Returns Only')
INSERT INTO [dbo].[Subtype]
           ([Subtype_nm]
           ,[SubtypeCategory_id]
           ,[bitRuleOverride]
           ,[bitQuestionnaireRequired]
           ,[bitActive])
     VALUES
           ('Returns Only'
           ,3
           ,0
           ,0
           ,1)
GO

if not exists(select * from SurveyTypeSubtype where SurveyType_id = 7)
INSERT INTO [dbo].[SurveyTypeSubtype]
           ([SurveyType_id]
           ,[Subtype_id])
     VALUES
           (7
           ,IDENT_CURRENT('dbo.Subtype'))
GO

/****** Object:  StoredProcedure [dbo].[QCL_SampleSetResurveyExclusion_StaticPlus]    Script Date: 3/28/2017 11:38:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It determines
which records should be DQ'd because of resurvey exclusion

Created:  02/28/2006 by DC

Modified:
03/01/2006 BY Brian Dohmen  Incorporated Calendar Month as a resurvey method.
10/05/2007 Steve Spicka - Modified Calendar Month resurvey exclusion.
       Only HCAHPS unit encounters cause exclusion.
       Picker only units can may not be excluded.
       Temporary HCAHPS solution until sampling can be re-written
10/14/2009 Michael Beltz - added survey_ID var so we can check for the actual
       resurvey month variable instead of hard coding to 1
12/08/2009 Michael Beltz - Added not exists check to vw_Billians_NursingHomeAssistedLiving
    to make sure we do not household nursing or assisted living homes.

12/10/2009 by MWB
  Added inserts into SamplingExclusion_Log to log all occurances of
  exclusions for all Static Plus Samples

5/10/2011 DRM
  Added code to replace 9999999 with '12/31/4000' for ISNULL on date fields

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

02/26/2016 Dave Gilsdorf - added D_HH index on #Distinct 

03/28/2017 Chris Burkholder - ATL-1419 added logic to handle the Resurvey Exclusion Type of Returns Only

*/
ALTER PROCEDURE [dbo].[QCL_SampleSetResurveyExclusion_StaticPlus]
  @Study_id                      INT,
  @Survey_ID                     INT,
  @ReSurveyMethod_id             INT,
  @ReSurvey_Excl_Period          INT,
  @SamplingAlgorithmID           INT,
  @strHouseholdField_CreateTable VARCHAR(8000),/* List of fields and type that are used for HouseHolding criteria */
  @strHouseholdField_Select      VARCHAR(8000),/* List of fields that are used for HouseHolding criteria */
  @strHousehold_Join             VARCHAR(8000),
  @HouseHoldingType              CHAR(1),
  @Sampleset_ID                  INT = 0,
  @indebug                       INT = 0
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @minDate        DATETIME,
          @maxDate        DATETIME,
          @sql            VARCHAR(max),
          @ResurveyMonths INT
  DECLARE @surveyType_ID INT

  SET @ResurveyMonths = 1

  IF @indebug = 1
    PRINT 'Start QCL_SampleSetResurveyExclusion_StaticPlus'

  SELECT @ResurveyMonths = INTRESURVEY_PERIOD
  FROM   dbo.SURVEY_DEF
  WHERE  SURVEY_ID = @Survey_ID
         AND ReSurveyMethod_id = 2

  SELECT @surveyType_ID = surveyType_ID
  FROM   dbo.survey_Def
  WHERE  survey_ID = @survey_ID

  SELECT @minDate = MIN(EncDate),
         @maxDate = MAX(EncDate)
  FROM   #SampleUnit_Universe

  SELECT @minDate = dbo.FirstDayOfMonth(DATEADD(MONTH, ((@ResurveyMonths - 1) * -1), dbo.FirstDayOfMonth(@minDate)))

  SELECT @maxDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1, dbo.FirstDayOfMonth(@maxDate)))

  IF @ReSurveyMethod_id = 1  --Resurvey Days
    BEGIN
      IF EXISTS (SELECT *
                 FROM   tempdb.dbo.sysobjects o
                 WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#Remove_Pops'))
        DROP TABLE #Remove_Pops;

	  --ATL-1419 ResurveyExclusionType ReturnsOnly -> only resurvey exclude those with a return for Returns Only subtype
		SELECT DISTINCT
				sp.Pop_id
		INTO   #Remove_Pops
		FROM   dbo.SamplePop sp
				INNER JOIN dbo.SampleSet ss ON sp.SampleSet_id = ss.SampleSet_id
				INNER JOIN dbo.QUESTIONFORM qf on sp.SAMPLEPOP_ID = qf.SAMPLEPOP_ID --ATL-1419
				LEFT JOIN dbo.SurveySubtype sst on ss.SURVEY_ID = sst.Survey_id		--ATL-1419
				LEFT JOIN dbo.Subtype st on sst.Subtype_id = st.Subtype_id			--ATL-1419
		WHERE  Study_id = @Study_id
				AND (DATEDIFF(day, ss.datLastMailed, GETDATE()) < @Resurvey_Excl_Period
					OR ss.datLastMailed IS NULL)
				AND ((st.Subtype_nm ='Returns Only' and qf.DATRETURNED is not null) --ATL-1419
					OR st.Subtype_nm is NULL 
					OR st.Subtype_nm <> 'Returns Only')
	  --ATL-1419 END ResurveyExclusionType ReturnsOnly -> only resurvey exclude those with a return for Returns Only subtype

      --Removed Rule value of 1 means it is resurvey exclusion.  This is not a bit field.
      UPDATE #SampleUnit_Universe
      SET    Removed_Rule = 1
      FROM   #SampleUnit_Universe U
             INNER JOIN #Remove_Pops MM ON U.Pop_id = MM.Pop_id
      WHERE  isnull(Removed_Rule, 0) = 0

      INSERT INTO dbo.Sampling_ExclusionLog
                  (Survey_ID,
                   Sampleset_ID,
                   Sampleunit_ID,
                   Pop_ID,
                   Enc_ID,
                   SamplingExclusionType_ID,
                   DQ_BusRule_ID)
      SELECT @survey_ID AS Survey_ID,
             @Sampleset_ID AS Sampleset_ID,
             Sampleunit_ID,
             U.Pop_ID,
             U.Enc_ID,
             1 AS SamplingExclusionType_ID,
             NULL AS DQ_BusRule_ID
      FROM   #SampleUnit_Universe U
	         INNER JOIN #Remove_Pops MM ON U.Pop_id = MM.Pop_id

      IF EXISTS (SELECT *
                 FROM   tempdb.dbo.sysobjects o
                 WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#Remove_Pops'))
        DROP TABLE #Remove_Pops
    END  --if @ReSurveyMethod_id = 1
  ELSE IF @ReSurveyMethod_id = 2  --Calendar month
    BEGIN
      UPDATE #SampleUnit_Universe
      SET    ReSurveyDate = dbo.FirstDayOfMonth(EncDate)

      IF EXISTS (SELECT *
                 FROM   tempdb.dbo.sysobjects o
                 WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#ReSurvey'))
        DROP TABLE #ReSurvey;

      CREATE TABLE #ReSurvey (pop_ID       INT,
							  enc_ID	   INT,
	                          CCN          VARCHAR(20),
                              ReSurveyDate DATETIME)

  	  DECLARE @IntResurvey_Period int
	  select @IntResurvey_Period = INTRESURVEY_PERIOD from survey_def where survey_id = @survey_id

      --if HCAHPS / OAS
      IF dbo.SurveyProperty('DoesResurveyByCCN', @surveyType_ID, null) = 1 -- in (2, 16)
        BEGIN
          --Get the distinct months of the reportdate for each pop_id
          INSERT INTO #ReSurvey (pop_ID, enc_ID, CCN, ReSurveyDate)
		  SELECT DISTINCT 
				 a.Pop_id,
				 a.Enc_id,
				 a.CCN,
				 dbo.FirstDayOfMonth(sampleEncounterDate) ReSurveyDate
          FROM   (
                 --Get all the reportdates for all the eligible records for sample
                 SELECT t.Pop_id,
						t.Enc_id,
                        sampleEncounterDate,
						suf.MedicareNumber as CCN
                  FROM  dbo.SelectedSample ss
                        INNER JOIN dbo.SampleUnit su ON ss.sampleunit_id = su.sampleunit_Id
                        INNER JOIN #SampleUnit_Universe t ON t.Pop_id = ss.Pop_id
						INNER JOIN SUFacility suf on su.SUFacility_ID = suf.SUFacility_ID
                  WHERE su.CAHPSType_id = @surveyType_ID
                        AND ss.Study_id = @Study_id
                        AND sampleEncounterDate BETWEEN @minDate AND @maxDate) a

          CREATE INDEX tmpIndex
            ON #ReSurvey (Pop_id)

          UPDATE u
          SET    Removed_Rule = 1
          FROM   #SampleUnit_Universe U
                 INNER JOIN SampleUnit su 
					ON u.sampleunit_id=su.sampleunit_id 
					AND su.CAHPSType_id = @surveyType_ID 
                 INNER JOIN SUFacility suf ON su.SUFacility_ID = suf.SUFacility_ID
                 INNER JOIN #ReSurvey MM 
					ON U.Pop_id = MM.Pop_id 
					AND mm.resurveydate >= dateadd(month, ((@IntResurvey_Period - 1) * -1), u.ReSurveyDate)
					AND suf.MedicareNumber=mm.CCN
          WHERE  isnull(Removed_Rule, 0) = 0

        END  --dbo.SurveyProperty('DoesResurveyByCCN', @surveyType_ID, null) = 1 -- in (2, 16/HCAHPS, OAS CAHPS)
      ELSE
	  IF dbo.SurveyProperty('DoesResurvey', @surveyType_ID, null) = 1 -- in (3,12/HHCAHPS,CIHI)
        BEGIN
          --Get the distinct months of the reportdate for each pop_id
          INSERT INTO #ReSurvey (pop_ID, Enc_id, ReSurveyDate)
          SELECT DISTINCT 
				 a.Pop_id,
				 a.Enc_id,
				 --a.CCN,
                 dbo.FirstDayOfMonth(a.sampleEncounterDate) ReSurveyDate
          FROM   (
                 --Get all the reportdates for all the eligible records for sample
                 SELECT t.Pop_id,
						t.Enc_id,
                        sampleEncounterDate
                  FROM   dbo.SelectedSample ss
                        INNER JOIN dbo.SampleUnit su ON ss.sampleunit_id = su.sampleunit_Id
                        INNER JOIN #SampleUnit_Universe t ON t.Pop_id = ss.Pop_id
						--INNER JOIN SUFacility suf on su.SUFacility_ID = suf.SUFacility_ID
                  WHERE  su.CAHPSType_id = @surveyType_ID
                         AND ss.Study_id = @Study_id
                         AND sampleEncounterDate BETWEEN @minDate AND @maxDate) a

          CREATE INDEX tmpIndex
            ON #ReSurvey (Pop_id)

          UPDATE u
          SET    Removed_Rule = 1
          FROM   #SampleUnit_Universe U
                 --INNER JOIN SUFacility suf ON su.SUFacility_ID = suf.SUFacility_ID
				 INNER JOIN #ReSurvey MM 
					ON U.Pop_id = MM.Pop_id
					AND mm.resurveydate >= dateadd(month, ((@IntResurvey_Period - 1) * -1), u.ReSurveyDate)
					--AND suf.MedicareNumber=mm.CCN
          WHERE isnull(Removed_Rule, 0) = 0

        END  -- dbo.SurveyProperty('DoesResurvey', @surveyType_ID, null) = 1) -- in (3,12)

		--Assign the encounters just marked as removed to other sampleunit/encounter pairs for that encounter
        UPDATE u
        SET    Removed_Rule = 1
        FROM   #SampleUnit_Universe U
                INNER JOIN #SampleUnit_Universe U2 on U.enc_id = U2.enc_id and U2.Removed_Rule = 1
		WHERE  isnull(u.Removed_Rule, 0) = 0

		--use removed rule = 1 to determine all rows to insert in the exclusion log
        INSERT INTO dbo.Sampling_ExclusionLog
                    (Survey_ID,
                    Sampleset_ID,
                    Sampleunit_ID,
                    Pop_ID,
                    Enc_ID,
                    SamplingExclusionType_ID,
                    DQ_BusRule_ID)
        SELECT @survey_ID AS Survey_ID,
                @Sampleset_ID AS Sampleset_ID,
                U.Sampleunit_ID,
                U.Pop_ID,
                U.Enc_ID,
                1 AS SamplingExclusionType_ID,
                NULL AS DQ_BusRule_ID
        FROM   #SampleUnit_Universe U
        WHERE  isnull(Removed_Rule, 0) = 1 --was set to 1 in the UPDATES just prior and further back

        IF EXISTS (SELECT *
                    FROM   tempdb.dbo.sysobjects o
                    WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#ReSurvey'))
        DROP TABLE #ReSurvey;
    END  -- @ReSurveyMethod_id = 2

  --If Static Plus
  IF @SamplingAlgorithmID = 3
    BEGIN
      --Now to remove everyone in the household if anyone in the household is removed
      UPDATE #SampleUnit_Universe
      SET    HouseHold_id = id_Num
      WHERE  HouseHold_id IS NULL

      CREATE INDEX tmpIndex2
        ON #SampleUnit_Universe (HouseHold_id)

      UPDATE t
      SET    t.Removed_Rule = 1
      FROM   #SampleUnit_Universe t,
             (SELECT HouseHold_id
              FROM   #SampleUnit_Universe
              WHERE  Removed_Rule = 1
              GROUP  BY HouseHold_id) a
      WHERE  a.HouseHold_id = t.HouseHold_id

      UPDATE #SampleUnit_Universe
      SET    HouseHold_id = NULL
      WHERE  HouseHold_id = id_Num
    END

  --Now to expand to people not in this sample
  IF @HouseHoldingType = 'A'
     AND @ReSurveyMethod_id = 2   --Calendar month
    BEGIN
      -- all those REPLACE() and the SUBSTRING() change something like this:
      --  X.POPULATIONAddr, X.POPULATIONCity, X.POPULATIONST, X.POPULATIONZIP5, X.POPULATIONAddr2
      -- to this:
      -- ISNULL(Addr,9999999),ISNULL(City,9999999),ISNULL(ST,9999999),ISNULL(ZIP5,9999999),ISNULL(Addr2,9999999)

      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ', pop_id int, CCN varchar(20))
		  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ', pop_id, CCN)
		  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
			  , 'x.', ',9999999),ISNULL(p.')
			  , ', ,', ',')
			  , 12, 2000)
			  + ',9999999), p.pop_id, suf.MedicareNumber as CCN
		  FROM dbo.SelectedSample ss
		       INNER JOIN dbo.SampleUnit su ON ss.sampleunit_id=su.sampleunit_Id
			   INNER JOIN dbo.SUFacility suf on su.SUFacility_id = suf.SUFacility_id
		       INNER JOIN S' + LTRIM(STR(@Study_id)) + '.Population p ON ss.Pop_id=p.Pop_id
		  WHERE ss.Study_id=' + LTRIM(STR(@Study_id)) + '
		  AND sampleEncounterDate BETWEEN ''' + CONVERT(VARCHAR, @minDate) + ''' AND ''' + CONVERT(VARCHAR, @maxDate) + '''
		  and su.bitHCAHPS = 1

		CREATE NONCLUSTERED INDEX D_HH ON #Distinct ('+REPLACE(@strHouseHoldField_Select, 'X.', '')+', CCN)
										
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

		  --select *
		  --into dbo.mb_Sampling_HHdistinct_' + CAST(@Sampleset_ID AS VARCHAR(10)) + '
		  --from #Distinct

		  UPDATE x
		  SET x.Removed_Rule=7
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and suf.MedicareNumber = y.CCN 
		  and isnull(x.removed_rule, 0) = 0

		  insert into dbo.Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and suf.MedicareNumber = y.CCN 
		  and x.removed_rule = 7

		--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
		--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only
		IF @country=''US''
		  UPDATE x
		  SET x.Removed_Rule= -7
		  FROM #SampleUnit_Universe x, S' + LTRIM(STR(@Study_id)) + '.Population p
		  WHERE x.pop_ID = p.pop_ID
		  and x.removed_rule in (0, 7)
		  and exists     ( select ''x''
			 from dbo.vw_Billians_NursingHomeAssistedLiving v
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
  ELSE IF @HouseHoldingType = 'A'
     AND @ReSurveyMethod_id = 1  -- resurvey days
    BEGIN
      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ')
		  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ')
		  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
					  , 'x.', ',9999999),ISNULL(')
					  , ', ,', ',')
					  , 12, 2000)
					  + ',9999999)
		  FROM dbo.SelectedSample ss
		       INNER JOIN dbo.SampleSet sset ON ss.SampleSet_id=sset.SampleSet_id
			   INNER JOIN S' + LTRIM(STR(@Study_id)) + '.Population p ON ss.Pop_id=p.Pop_id
		  WHERE ss.Study_id=' + LTRIM(STR(@Study_id)) + '
		  AND sset.datSampleCreate_dt>''' + CONVERT(VARCHAR, DATEADD(DAY, -@ReSurvey_Excl_Period, GETDATE())) + '''

		  CREATE NONCLUSTERED INDEX D_HH ON #Distinct ('+REPLACE(@strHouseHoldField_Select, 'X.', '')+')

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

		  --select *
		  --into mb_Sampling_HHdistinct_' + CAST(@Sampleset_ID AS VARCHAR(10)) + '
		  --from #distinct

		  UPDATE x
		  SET x.Removed_Rule=7
		  FROM #SampleUnit_Universe x, #Distinct y
		  WHERE ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and isnull(x.removed_rule, 0) = 0

		  insert into dbo.Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
		  FROM #SampleUnit_Universe x, #Distinct y
		  WHERE ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and x.removed_rule = 7

		--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
		--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only
		IF @country=''US''
		  UPDATE x
		  SET x.Removed_Rule= -7
		  FROM #SampleUnit_Universe x, S' + LTRIM(STR(@Study_id)) + '.Population p
		  WHERE x.pop_ID = p.pop_ID
		  and x.removed_rule = 7  /*** EXPERIMENT - DMP - 07/12/16 prevents enc samp 2x ***/
		  and exists     ( select ''x''
			from dbo.vw_Billians_NursingHomeAssistedLiving v
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

  IF @indebug = 1
    PRINT 'End QCL_SampleSetResurveyExclusion_StaticPlus'
--test code should not be in production unless there is a specific sampling error
--insert into mb_sampling_samplesql
--select @sql as SQL

GO