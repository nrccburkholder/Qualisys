CREATE PROCEDURE [dbo].[csp_GetSamplePopulationExtractData2] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
--exec csp_GetSamplePopulationExtractData2 2714
	
	
			declare @SamplePopEntityTypeID int
			set @SamplePopEntityTypeID = 7 -- SamplePopulation

			declare @SampleSetEntityTypeID int
			set @SampleSetEntityTypeID = 8 -- SampleSet
  	
			--declare @ExtractFileID int
			--set @ExtractFileID= 2714 -- test only

			declare @TestString nvarchar(40)
			set @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'
          
	---------------------------------------------------------------------------------------
	-- Formmats data for XML export
	-- Changed on 2009.11.09 by kmn to remove CAPHS & nrc disposition columns
	-- Changed on 2012.12.19 by tsb S14.2 US11 Add StandardMethodologyID column to SampleSet
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
					NULL, NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ,  NULL ,
		  
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
		    NULL, NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL ,  NULL ,
		  
		    NULL, NULL  

--	  select *	   
	  from SampleSetTemp with (NOLOCK) 
      where SampleSetTemp.ExtractFileID = @ExtractFileID 
     
   -- Add sample pop insert/update rows
   insert #tttUS
  	select 2 as Tag, 1 as Parent,
  	  		             
           SamplePopTemp.SAMPLESET_ID,NULL, NULL, NULL, 
		   NULL, -- S15 US11

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
 
  		   SelectedSampleTemp.samplepop_id,  NULL , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,

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


end



