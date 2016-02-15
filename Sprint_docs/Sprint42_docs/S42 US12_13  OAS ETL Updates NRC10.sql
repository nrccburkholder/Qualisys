/*

Sprint 42

US 12 OAS: Count Fields 
As an OAS-CAHPS vendor, we need to report in the submission file the number of patients in the data file & the number of eligible patients, so our files are accepted.

	alter table NRC_Datamart_ETL.[dbo].[SampleUnitTemp] add eligibleCount int NULL
	ALTER PROCEDURE NRC_Datamart_ETL.[dbo].[csp_GetSamplePopulationExtractData] 
	ALTER PROCEDURE NRC_Datamart_ETL.[dbo].[csp_GetSamplePopulationExtractData2] 

US 13 OAS: Language in which Survey Completed 
As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs

	alter table [dbo].[QuestionFormTemp] add [LangID] int NULL 
	ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 
	ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData2]
	ALTER PROCEDURE [dbo].[SP_BDUS_UpdateBackgroundInfo] 
	ALTER TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SENTMAILING] 


Tim Butler 

*/



--US 12 OAS: Count Fields 


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

USE [QP_Prod]
GO

ALTER PROCEDURE [dbo].[SP_BDUS_UpdateBackgroundInfo]
    @intStudyID         INT,      
    @intPopID           INT,      
    @intSamplePopID     INT,      
    @intQuestionFormID  INT,      
    @strSetClause       VARCHAR(7800),      
    @strFieldList       VARCHAR(5000),      
    @intProgram  int      
      
AS      
/*
	S42 US13 OAS: Language in which Survey Completed - added code to update SentMailing.LangID for Phone step processed through QSI TransferResults 02/08/2016 TSB
*/      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
--Declare required variables      
DECLARE @strSql VARCHAR(8000)      
      
--Update the Population table for this study      
SET @strSql='UPDATE S'+CONVERT(VARCHAR,@intStudyID)+'.Population '+CHAR(10)+      
            'SET '+@strSetClause+' '+CHAR(10)+      
            'WHERE Pop_id='+CONVERT(VARCHAR,@intPopID)      
EXEC (@strSql)    

-- S42 US13
if SUBSTRING(@strSetClause,1, 6) = 'LangID'
BEGIN

	SET @strSQL = '
		if not exists (
			select 1
			from dbo.SENTMAILING sm
			inner join dbo.questionform qf on (sm.SENTMAIL_ID = qf.SENTMAIL_ID)
			inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
			inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
			inner join MailingStepMethod msm on msm.MailingStepMethod_id= ms.MailingStepMethod_id
			where qf.SAMPLEPOP_ID = ' + CONVERT(VARCHAR,@intSamplePopID) +' '+ CHAR(10) + 
			'and msm.MailingStepMethod_nm = ''Phone''
			and sm.'+ @strSetClause + ')'+ CHAR(10) +  
			'begin ' + CHAR(10) +  
				'update sm '+ CHAR(10) +  
				'SET ' + @strSetClause + ' '+ CHAR(10) + 
				'from dbo.SENTMAILING sm
				inner join dbo.questionform qf on (sm.SENTMAIL_ID = qf.SENTMAIL_ID)
				inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
				inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
				inner join MailingStepMethod msm on msm.MailingStepMethod_id= ms.MailingStepMethod_id
				where qf.SAMPLEPOP_ID = ' + CONVERT(VARCHAR,@intSamplePopID) +' '+ CHAR(10) + 
				'and msm.MailingStepMethod_nm = ''Phone''' + CHAR(10) +  
			'end '

	EXEC (@strSql)  
	 
END
  
      
--Add the entries into the HandEntry_Log table      
SELECT @strSql='INSERT INTO HandEntry_Log (QuestionForm_id,Field_id,datEntered,intProgram)      
SELECT '+LTRIM(STR(@intQuestionFormID))+',Field_id,GETDATE(),'+LTRIM(STR(@intProgram))+'      
FROM MetaField      
WHERE strField_nm IN ('''+REPLACE(@strFieldList,',',''',''')+''')'      
EXEC (@strSql)      
      
--Update the datamart for this study      
--We will now only queue up the changes on 10 instead of on 47.      
INSERT INTO UpdateBackGroundInfo_Log (Study_id,Pop_id,SamplePop_id,strSetClause,datScheduled)      
SELECT @intStudyID,@intPopID,@intSamplePopID,@strSetClause,GETDATE()      

INSERT INTO UpdateBackGroundInfo_History (Study_id,Pop_id,SamplePop_id,strSetClause,datScheduled)      
SELECT @intStudyID,@intPopID,@intSamplePopID,@strSetClause,GETDATE()      
      
--EXEC NRC47.QP_Comments.dbo.SP_BDUS_UpdateBackgroundInfo @intStudyID, @intPopID, @intSamplePopID, @strSetClause      
    
--insert into Catalyst extract queue so new address will be updated    
insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,IsDeleted, source)      
select 7, @intSamplePopID, NULL, 0,0, 'SP_BDUS_UpdateBackgroundInfo'    
        
--Cleanup      
SET NOCOUNT OFF      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

USE [QP_Prod]
GO

-- Trigger
ALTER TRIGGER [dbo].[trg_NRC_DataMart_ETL_dbo_SENTMAILING]
   ON  [dbo].[SENTMAILING] 
   AFTER UPDATE
AS 
BEGIN
SET NOCOUNT ON
    IF ( UPDATE (DatMailed) OR UPDATE (DatExpire) OR UPDATE (DatGenerated) OR UPDATE (DatPrinted) Or UPDATE (DatBundled) Or UPDATE (DATUNDELIVERABLE) OR UPDATE([LangID]))
    BEGIN
		insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)
        select 11, QUESTIONFORM_ID, i.strlithocode, 0,'trg_NRC_DataMart_ETL_dbo_SENTMAILING'
        from INSERTED i
        inner join QUESTIONFORM qf With (NOLOCK) on  qf.SentMail_id = i.SentMail_id   
        where i.strlithocode is not null
    END

END

GO