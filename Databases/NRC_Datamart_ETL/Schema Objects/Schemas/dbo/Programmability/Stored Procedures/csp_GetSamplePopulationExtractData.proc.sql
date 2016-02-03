CREATE PROCEDURE [dbo].[csp_GetSamplePopulationExtractData] 
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
	-- S35 US19  Fix NumberOfMailAttempts to return correct number based on disposition and heirarchy
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
	-- S35 US17  fixed so that we are getting the correct NumberOfMailAttempts based on disposition and heirarchy
	select smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id, min(std.Hierarchy) heirarchy
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
	and m1.heirarchy = (SELECT min(heirarchy) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID) 

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


