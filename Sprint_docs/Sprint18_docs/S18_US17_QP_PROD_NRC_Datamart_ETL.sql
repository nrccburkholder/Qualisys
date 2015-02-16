/*

	S18 US17 As an authorized Hospice CAHPS vendor, we need to count the number of supplemental questions for each sampled patient, so that we can report the data to CMS.

	alter table [dbo].[SamplePopTemp] add SupplementalQuestionCount int NULL  (NRC_Datamart_ETL)
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
					   AND st.NAME = 'SamplePopTemp' 
					   AND sc.NAME = 'SupplementalQuestionCount' )

	alter table [dbo].[SamplePopTemp] add SupplementalQuestionCount int NULL 

go

commit tran
go

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
						 from (select distinct PKey1 
										from ExtractHistory  with (NOLOCK) 
										 where ExtractFileID = @ExtractFileID
										 and EntityTypeID = 11 -- QuestionForm Entity Type
										 and IsDeleted = 0 ) eh1
						inner join QP_Prod.dbo.QUESTIONFORM qf1 With (NOLOCK) on qf1.QUESTIONFORM_ID = eh1.PKey1
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
/****** Object:  StoredProcedure [dbo].[csp_GetSamplePopulationExtractData2]    Script Date: 2/12/2015 2:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[csp_GetSamplePopulationExtractData2] 
	@ExtractFileID int
AS
BEGIN
	SET NOCOUNT ON 
--exec csp_GetSamplePopulationExtractData2 2714
	---------------------------------------------------------------------------------------
	-- Formats data for XML export
	-- Changed on 2009.11.09 by kmn to remove CAPHS & nrc disposition columns
	-- Changed on 2014.12.19 by tsb S14.2 US11 Add StandardMethodologyID column to SampleSet
	-- Changes on 2015.02.06 Tim Butler - S18 US16 Add IneligibleCount column to SampleSet
	-- Changes on 2015.02.10 Tim Butler - S18 US17 Add SupplementalQuestionCount column to SamplePop
	---------------------------------------------------------------------------------------
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
		[samplePop!2!supplementalQuestionCount] int NULL,

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
     
   -- Add sample pop insert/update rows
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
		   ISNULL(SamplePopTemp.SupplementalQuestionCount,0),

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
 
  		   SelectedSampleTemp.samplepop_id,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ,

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


	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
END


GO