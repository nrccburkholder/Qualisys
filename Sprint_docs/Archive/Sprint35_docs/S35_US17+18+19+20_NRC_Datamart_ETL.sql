/*

S35 US17  As a Hospice CAHPS Vendor, we need to fix/refactor lag time calculations, so we submit accurate data & comply w/ an on-site visit item 
S35 US18  As a Hospice CAHPS Vendor, we need to report ineligible presample at the CCN level, so we submit accurate data & comply w/ an on-site visit item
S35 US19  As a Hospice CAHPS Vendor, we need to report number attempts mail as the wave on which the disposition was determined, so we comply w/ an on-site visit item
S35 US20  As a Hospice CAHPS Vendor, we need to correctly report the sample type, so we submit accurate data & comply w/ an on-site visit item

Tim Butler

	alter table [dbo].[SampleSetTemp] add column datFirstMailed (NRC_Datamart_ETL)
	alter table [dbo].[SampleUnitTemp] add column ineligibleCount (NRC_Datamart_ETL)
	alter table [dbo].[SampleUnitTemp] add column isCensus (NRC_Datamart_ETL)
	ALTER PROCEDURE [dbo].[csp_GetSampleSetExtractData] 
	ALTER PROCEDURE [dbo].[csp_GetSamplePopulationExtractData]  (NRC_Datamart_ETL)
	ALTER PROCEDURE [dbo].[csp_GetSamplePopulationExtractData2] (NRC_Datamart_ETL)

*/



use [NRC_DataMart_ETL]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleSetTemp' 
					   AND sc.NAME = 'datFirstMailed' )

	alter table [dbo].[SampleSetTemp] add datFirstMailed datetime NULL 

go

commit tran
go


use [NRC_DataMart_ETL]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleUnitTemp' 
					   AND sc.NAME = 'ineligibleCount' )

	alter table [dbo].[SampleUnitTemp] add ineligibleCount int NULL 

go

commit tran
go


use [NRC_DataMart_ETL]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleUnitTemp' 
					   AND sc.NAME = 'isCensus' )

	alter table [dbo].[SampleUnitTemp] add isCensus tinyInt NULL 

go

commit tran
go




USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSampleSetExtractData]    Script Date: 10/1/2015 2:16:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[csp_GetSampleSetExtractData] 
	@ExtractFileID int 
AS
-- =============================================
-- Procedure Name: csp_GetSampleSetExtractData
-- History: 1.0  Original as of 2015.01.06
--			2.0  Tim Butler - S14.2 US11 Add StandardMethodologyID column to SampleSetTemp
--			3.0  Tim Butler - S18 US16 Add IneligibleCount column to SampleSet
--			S20 US09 Add SamplingMethod		Tim Butler
--			S35 US17 Add datFirstMailed		Tim Butler
-- =============================================
BEGIN
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 8 -- SampleSet
--    	
--	declare @ExtractFileID int
--	set @ExtractFileID = 2 

	---------------------------------------------------------------------------------------
	-- Load records to Insert/Update/Delete into a temp table
	---------------------------------------------------------------------------------------

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT

	delete SampleSetTemp where ExtractFileID = @ExtractFileID

	insert SampleSetTemp 
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID, IneligibleCount, SamplingMethodID)
		select distinct @ExtractFileID,eh.PKey1,study.client_id,study.study_id, survey.survey_id, ss.DATSAMPLECREATE_DT,eh.IsDeleted,
			mm.StandardMethodologyID, -- S15 US11
			ISNULL(ss.IneligibleCount,0), -- S18 US 16
			pdef.SamplingMethod_id -- S20 US9
		 from (select distinct PKey1 ,PKey2,IsDeleted
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID ) eh		  
		  left join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = eh.PKey1
          left join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on eh.PKey2 = survey.survey_id
          left join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1-- S15 US11
		  left join QP_Prod.dbo.PeriodDates pdates with (NOLOCK) on pdates.SampleSet_id = ss.SAMPLESET_ID -- S20 US9
		  left join QP_Prod.dbo.PeriodDef pdef on pdef.PeriodDef_id = pdates.PeriodDef_id; -- S20 US9


	WITH Mailings_CTE(SampleSet_id, datMailed)
	AS
	(
		SELECT sst.SAMPLESET_ID, max (DATMAILED) datMailed
		FROM SampleSetTemp sst
		INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.SAMPLESET_ID = sst.SAMPLESET_ID
		inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
		inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
		inner join QP_Prod.[dbo].[MAILINGSTEP] ms on ms.MAILINGSTEP_ID = smg.MAILINGSTEP_ID
		where sm.DATMAILED is not null 
		AND ms.INTSEQUENCE = 1
		group by sst.SAMPLESET_ID
	)

	update sst
		SET datFirstMailed = datMailed
	FROM SampleSetTemp sst
	INNER JOIN Mailings_CTE m1 on m1.SAMPLESET_ID = sst.SAMPLESET_ID


	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
END


GO

USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSamplePopulationExtractData]    Script Date: 10/5/2015 12:20:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[csp_GetSamplePopulationExtractData] 
	@ExtractFileID int 
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
	
	insert SelectedSampleTemp (ExtractFileID,SAMPLESET_ID, SAMPLEPOP_ID, SAMPLEUNIT_ID, POP_ID, ENC_ID, selectedTypeID,STUDY_ID,intExtracted_flg)
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

	 -- S35 US18 - ineligibleCount
	 SELECT distinct se.SampleSet_id, se.SampleUnit_id, pop_id
	 INTO #ExclusionLog
	 FROM [QP_Prod].[dbo].[Sampling_ExclusionLog] se
	 inner join dbo.SampleunitTemp su on su.SAMPLESET_ID = se.Sampleset_ID and su.SAMPLEUNIT_ID = se.Sampleunit_ID

	 update sut
	  set sut.ineligibleCount = sel.ineligibleCount
	   from dbo.SampleunitTemp sut
	   inner join (
			SELECT[sampleset_id]
		    ,[sampleunit_id]
		    ,count(*) ineligibleCount
		    FROM #ExclusionLog
		    group by sampleset_id, sampleunit_id
	   )   sel
	   on sel.sampleset_id = sut.SAMPLESET_ID and sel.Sampleunit_ID = sut.SAMPLEUNIT_ID
	 where sut.ExtractFileID = @ExtractFileID  

	 -- S35 US20 - isCensus
	  update sut 
			set isCensus=case when spw.intSampledNow = spw.intAvailableUniverse then 1 else 0 end 
		from SampleUnitTemp sut
		inner join QP_Prod.dbo.SamplePlanWorksheet spw on sut.Sampleset_id=spw.Sampleset_id and sut.SampleUnit_id=spw.SampleUnit_id 
		where sut.ExtractFileID = @ExtractFileID  

	 update sp
	  set ENC_ID = ss.ENC_ID
	   from dbo.SamplePopTemp sp
	   inner join (select distinct SAMPLESET_ID,SAMPLEPOP_ID,ENC_ID--*
	     			from dbo.SelectedSampleTemp
					where ExtractFileID = @ExtractFileID  and intextracted_flg = 1 ) ss on sp.SAMPLESET_ID = ss.SAMPLESET_ID and sp.SAMPLEPOP_ID = ss.SAMPLEPOP_ID
		where sp.ExtractFileID = @ExtractFileID 

    ---------------------------------------------------------------------------------------
	-- Add delete rows to SamplePopTemp 
	---------------------------------------------------------------------------------------
     insert SamplePopTemp 
		(ExtractFileID,SAMPLESET_ID,SAMPLEPOP_ID, POP_ID,IsDeleted )
	  select distinct @ExtractFileID, PKey2, PKey1, 0, 1
        from ExtractHistory  with (NOLOCK) 
         where ExtractFileID = @ExtractFileID
	      and EntityTypeID = @EntityTypeID
	       and IsDeleted = 1
	 

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2


GO

USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSamplePopulationExtractData2]    Script Date: 10/2/2015 11:15:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
				[sampleUnit!4!isCensus] int NULL --S35 US20  - added attribute samplingMethodID
	       
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
				   NULL, NULL -- S35 US 18,20

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
				   NULL, NULL -- S35 US 18,20
				
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
				   NULL, NULL -- S35 US 18,20
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
				   NULL, NULL -- S35 US 18,20
		   
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
				  SampleUnitTemp.isCensus -- S35 US 20
   
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
		[sampleUnit!4!isCensus] int NULL --S35 US20  - added attribute samplingMethodID
		
	       
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
		   NULL, NULL -- S35 US 18,20

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
		   NULL, NULL -- S35 US 18,20

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
		   NULL, NULL -- S35 US 18,20
		   
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
				  SampleUnitTemp.isCensus -- S35 US 20


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

