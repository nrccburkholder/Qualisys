/*

S20 US11 As a CAHPS Developer, I need to create a new Catalyst entity to store the patients in file count at the sampleunit/CCN level

	BACKUP

	Tim Butler

	alter table [dbo].[SampleSetTemp] drop column NumPatInFile (NRC_Datamart_ETL)
	ALTER PROCEDURE [dbo].[csp_GetSampleSetExtractData]
	 
*/


use [NRC_DataMart_ETL]
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleSetTemp' 
					   AND sc.NAME = 'NumPatInFile' )

	alter table [dbo].[SampleSetTemp] drop column NumPatInFile 

go

commit tran
go



USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSampleSetExtractData]    Script Date: 3/6/2015 10:46:48 AM ******/
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
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID, IneligibleCount )
		select distinct @ExtractFileID,eh.PKey1,study.client_id,study.study_id, survey.survey_id, ss.DATSAMPLECREATE_DT,eh.IsDeleted,
			mm.StandardMethodologyID, -- S15 US11
			ISNULL(ss.IneligibleCount,0) -- S18 US 16
		 from (select distinct PKey1 ,PKey2,IsDeleted
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID ) eh		  
		  left join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = eh.PKey1
          left join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on eh.PKey2 = survey.survey_id
          left join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1-- S15 US11

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
END

GO


USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSamplePopulationExtractData]    Script Date: 2/10/2015 1:46:10 PM ******/
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
			(ExtractFileID,SAMPLESET_ID,SAMPLEPOP_ID, POP_ID,STUDY_ID,IsDeleted,SupplementalQuestionCount) --S18 US17
		select distinct @ExtractFileID, sp.sampleset_id,
			   sp.SAMPLEPOP_ID, sp.POP_ID,sp.STUDY_ID, 0,
			   qf.numCAHPSSupplemental  --S18 US17
		 from (select distinct PKey1 
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID
	           and IsDeleted = 0 ) eh
		  inner join QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = eh.PKey1
		  left join (select SamplePop_ID, numCAHPSSupplemental
						 from (select max(SamplePop_ID) samplepopid
										from QP_Prod.dbo.QUESTIONFORM qf  with (NOLOCK) 
										group by SamplePop_ID) qf0
						inner join QP_Prod.dbo.QUESTIONFORM qf1 With (NOLOCK) on qf1.samplepop_id = qf0.samplepopid
					) qf on qf.SAMPLEPOP_ID = sp.SAMPLEPOP_ID		--S18 US17
          left join SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     and sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
          where sp.POP_ID > 0
          and sst.sampleset_id is NULL --excludes sample pops that will be deleted due to sampleset deletes

     --insert sampleset rows for insert/update sample pops 
     insert SampleSetTemp 
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID, IneligibleCount )
		select distinct @ExtractFileID,ss.sampleset_id,study.client_id,study.study_id, ss.survey_id, ss.DATSAMPLECREATE_DT,0,
			mm.StandardMethodologyID, -- S15 US11
			ISNULL(ss.IneligibleCount,0) -- S18 US 16
		 from SamplePopTemp spt	  
		  inner join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on spt.sampleset_id = ss.sampleset_id           
          inner join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on ss.survey_id = survey.survey_id
          inner join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1
          left join SampleSetTemp sst with (NOLOCK) on spt.sampleset_id = sst.sampleset_id and sst.ExtractFileID = @ExtractFileID	
       where spt.ExtractFileID = @ExtractFileID	
            and sst.sampleset_id Is NULL--excludes sampleset_ids already in SampleSetTemp, rows were added in csp_GetSampleSetExtractData


	delete SelectedSampleTemp where ExtractFileID = @ExtractFileID

	-- If this next query is slow, create this index in QP_Prod
	--    create index IX_MSI_Performance_1 on SelectedSample (sampleset_id, pop_id, sampleunit_id, enc_id, strUnitSelectType)
	
	insert SelectedSampleTemp (ExtractFileID,SAMPLESET_ID, SAMPLEPOP_ID, SAMPLEUNIT_ID, POP_ID, ENC_ID, selectedTypeID,STUDY_ID,intExtracted_flg)
		select distinct @ExtractFileID,ss.SAMPLESET_ID
                , SAMPLEPOP_ID, SAMPLEUNIT_ID, ss.POP_ID, ss.ENC_ID, 
				(case when strUnitSelectType = 'D' then 1  when strUnitSelectType = 'I' then 2 else 0 end),ss.STUDY_ID,intExtracted_flg
		 from SamplePopTemp t with (NOLOCK)
				inner join QP_Prod.dbo.SELECTEDSAMPLE ss with (NOLOCK)
					on ss.pop_id = t.pop_id and ss.sampleset_id = t.sampleset_id
	 where t.ExtractFileID = @ExtractFileID 
	 
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
/****** Object:  StoredProcedure [dbo].[csp_GetSamplePopulationExtractData2]    Script Date: 2/17/2015 10:47:41 AM ******/
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
				[samplePop!2!supplementalQuestionCount] int NULL, --S18 US17

				[selectedSample!3!sampleunitid] nvarchar(200) NULL,
				[selectedSample!3!selectedTypeID] int NULL
	       
		  )
  
		  insert #ttt
  			select distinct 1 as Tag, NULL as Parent,
  	  		             
				   SampleSetTemp.SAMPLESET_ID,       
				   SampleSetTemp.CLIENT_ID,          
				   IsNull(SampleSetTemp.sampleDate,GetDate()),             
				   Case When IsDeleted = 1 Then 'true' Else 'false' End,
				   SampleSetTemp.StandardMethodologyID, -- S15 US11
				   SampleSetTemp.IneligibleCount, -- S18 US16

				   NULL, NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ,  NULL , NULL ,
		  
				   NULL, NULL 

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

				   NULL, NULL 
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
				   NULL, NULL 
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
 
  				   SelectedSampleTemp.samplepop_id,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,

				   SelectedSampleTemp.sampleunit_id, 
				   selectedTypeID
		   
			  from SelectedSampleTemp with (NOLOCK)	    
			  left join #ttt_error error with (NOLOCK)
				  on SelectedSampleTemp.samplepop_id = error.samplepop_id
				  and SelectedSampleTemp.study_id = error.study_id
			  where SelectedSampleTemp.ExtractFileID = @ExtractFileID 
			   and error.samplepop_id is null 
			  --and SelectedSampleTemp.SAMPLEPOP_ID <> 68475428
	 
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

	    [selectedSample!3!sampleunitid] nvarchar(200) NULL,
	    [selectedSample!3!selectedTypeID] int NULL
	       
  )
  
  insert #tttUS
  	select distinct 1 as Tag, NULL as Parent,
  	  		             
           SampleSetTemp.SAMPLESET_ID,       
           SampleSetTemp.CLIENT_ID,          
           IsNull(SampleSetTemp.sampleDate,GetDate()),             
		   Case When IsDeleted = 1 Then 'true' Else 'false' End,
		   SampleSetTemp.StandardMethodologyID, -- S15 US11
		   SampleSetTemp.IneligibleCount, -- S18 US16

		   NULL, NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ,  NULL , NULL ,
		  
		    NULL, NULL  

--	  select *	   
	  from SampleSetTemp with (NOLOCK) 
      where SampleSetTemp.ExtractFileID = @ExtractFileID 
     
   -- Add sample pop insert/update rows
   insert #tttUS
  	select 2 as Tag, 1 as Parent,
  	  		             
           SamplePopTemp.SAMPLESET_ID,NULL, NULL, NULL, 
		   NULL, -- S15 US11
		   NULL, -- S18 US16

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
		   
		   NULL, NULL 
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
 
  		   SelectedSampleTemp.samplepop_id,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ,

		   SelectedSampleTemp.sampleunit_id, 
		   selectedTypeID
		   
	  from SelectedSampleTemp with (NOLOCK)	    
	  left join #ttt_errorUS error with (NOLOCK)
          on SelectedSampleTemp.samplepop_id = error.samplepop_id
          and SelectedSampleTemp.study_id = error.study_id
	  where SelectedSampleTemp.ExtractFileID = @ExtractFileID 
	   and error.samplepop_id is null 
	  --and SelectedSampleTemp.SAMPLEPOP_ID <> 68475428
	 
	select * 
	from #tttUS    
	--where [sampleSet!1!id] <> 725591 -- and 725591
	order by [sampleSet!1!id],[samplePop!2!id], [selectedSample!3!sampleunitid] 
    for xml explicit
          
    drop table #tttUS
    drop table #ttt_errorUS

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
end

GO


