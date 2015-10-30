<EVENT_INSTANCE>
  <EventType>ALTER_PROCEDURE</EventType>
  <PostTime>2015-08-14T11:47:48.267</PostTime>
  <SPID>187</SPID>
  <ServerName>NRC10</ServerName>
  <LoginName>NRC\dgilsdorf</LoginName>
  <UserName>dbo</UserName>
  <DatabaseName>QP_Prod</DatabaseName>
  <SchemaName>dbo</SchemaName>
  <ObjectName>QCL_SampleSetHouseholdingExclusion</ObjectName>
  <ObjectType>PROCEDURE</ObjectType>
  <TSQLCommand>
    <SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
    <CommandText>/*
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
alter PROCEDURE [dbo].[QCL_SampleSetHouseholdingExclusion]
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

  DECLARE @sql VARCHAR(MAX)
  DECLARE @BOM DATETIME,
          @EOM DATETIME

declare @guid VARCHAR(30)
SET @guid=convert(nvarchar(50),GETDATE(),112)+' '+convert(nvarchar(50),GETDATE(),114)+' '+RIGHT(CONVERT(VARCHAR,100000+ROUND(RAND()*100000,0)),5)

SET @SQL='
select '+convert(varchar,@Study_id)    +' as at_Study_id                     ,
 	   '+convert(varchar,@Survey_ID)   +' as at_Survey_ID                    ,
	   '''+convert(varchar,@startDate,101)+''' as at_startDate               ,
	   '''+convert(varchar,@EndDate,101)+''' as at_EndDate                   ,
	   '''+replace(@strHouseholdField_CreateTable,'''','''''')+''' as at_strHouseholdField_CreateTable,
	   '''+replace(@strHouseholdField_Select,'''','''''')     +''' as at_strHouseholdField_Select     ,
	   '''+replace(@strHousehold_Join,'''','''''')            +''' as at_strHousehold_Join            ,
	   '''+@HouseHoldingType             +''' as at_HouseHoldingType             ,
	   '+convert(varchar,@Sampleset_ID)+' as at_Sampleset_ID                 ,
	   '+convert(varchar,@indebug)     +' as at_indebug                      ,
	   *
into [dbg_temp_QCL_SampleSetHouseholdingExclusion________'+@guid+']
from #SampleUnit_Universe'
EXEC (@SQL)


  SET @BOM = dateadd(dd, -day(@startDate) + 1, @startDate)
  SET @EOM = dateadd(dd, -1, dateadd(mm, 1, @BOM))

  IF @HouseHoldingType = 'A'
    BEGIN
      SELECT @SQL = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ', pop_id int, CCN varchar(20))
		  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ', pop_id, CCN)
		  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
			  , 'x.', ',9999999),ISNULL(p.')
			  , ', ,', ',')
			  , 12, 2000) 
			  + ',9999999), p.pop_id, suf.MedicareNumber as CCN
		  FROM sampleset ss
			   INNER JOIN eligibleenclog h ON ss.sampleset_id = h.sampleset_id 
		       INNER JOIN SampleUnit su ON h.sampleunit_id= su.sampleunit_Id 
			   INNER JOIN survey_def sd ON sd.survey_id = ss.survey_id
			   INNER JOIN S' + LTRIM(STR(@Study_id)) + '.Population p ON h.Pop_id=p.Pop_id 
			   INNER JOIN SUFacility suf on su.SUFacility_id = suf.SUFacility_id
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
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
		  and suf.MedicareNumber = y.CCN
		  and isnull(x.removed_rule, 0) = 0  
		  and x.pop_id = y.pop_id

		  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 10 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
		  and suf.MedicareNumber = y.CCN
		  and x.pop_id = y.pop_id 
		  and x.removed_rule = 10
  
		  UPDATE x
		  SET x.Removed_Rule=7
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + ' 
		  and suf.MedicareNumber = y.CCN 
		  and isnull(x.removed_rule, 0) = 0 
		  and x.pop_id &lt;&gt; y.pop_id

		  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
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
</CommandText>
  </TSQLCommand>
</EVENT_INSTANCE>