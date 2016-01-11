CREATE PROCEDURE [dbo].[QCL_SelectAllFacilities]  
@IsPracticeSite bit = null,
@SUFacility_id INT = null,
@Client_id INT = null,
@AHA_id INT = null
AS    
begin
	CREATE TABLE #t (  
	SUFacility_id INT,  
	strFacility_nm VARCHAR(100),  
	City VARCHAR(42),  
	State VARCHAR(2),  
	Country VARCHAR(42),  
	RowType CHAR(1),
	GroupID varchar(12),
	Region_id INT,  
	AdmitNumber INT,  
	BedSize INT,  
	bitPeds BIT,  
	bitTeaching BIT,  
	bitTrauma BIT,  
	bitReligious BIT,  
	bitGovernment BIT,  
	bitRural BIT,  
	bitForProfit BIT,  
	bitRehab BIT,  
	bitCancerCenter BIT,  
	bitPicker BIT,  
	bitFreeStanding BIT,  
	AHA_id INT,  
	MedicareNumber VARCHAR(20),  
	MedicareName VARCHAR(45),  
	IsHCAHPSAssigned BIT DEFAULT(0)  
	)  
	  
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)  
	SELECT distinct suf.SUFacility_id,strFacility_nm,City,State,Country,'F','',Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber
	--,MedicareName  
	FROM SUFacility suf with(NOLOCK)
	left join ClientSUFacilityLookup csuf with(NOLOCK) on suf.SUFacility_id = csuf.SUFacility_id 
	WHERE ((@IsPracticeSite is null) or (@IsPracticeSite = 0))
	AND ((@Client_id is null) or (@Client_id = csuf.Client_id))
	AND ((@SUFacility_id is null) or (@SUFacility_id = suf.SUFacility_id))
	AND ((@AHA_id is null) or (@AHA_id = AHA_id))	
	--LEFT JOIN MedicareLookup ml  
	--ON suf.MedicareNumber=ml.MedicareNumber  
	ORDER BY strFacility_nm, City  

	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)
	SELECT distinct sg.[SiteGroup_ID]
		  ,[GroupName]
		  ,[City]
		  ,[ST]
		  ,'USA','G',convert(varchar(12),sg.[SiteGroup_ID])
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
	  FROM [dbo].[SiteGroup] sg with(NOLOCK)
	  left join ClientPracticeSiteGroupLookup cpsgl with(NOLOCK) on sg.SiteGroup_ID = cpsgl.SiteGroup_id
	  WHERE (@IsPracticeSite is null)
	  AND ((@Client_id is null) or (@Client_id = cpsgl.Client_id))
	  AND (@AHA_id is null)


	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)
	SELECT distinct ps.[PracticeSite_ID]
		  ,ps.[PracticeName]
		  ,ps.[City]
		  ,ps.[ST]
		  ,'USA','G',convert(varchar(12),sg.[SiteGroup_ID])
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
	  FROM [dbo].[PracticeSite] ps with (NOLOCK)
	  inner join [dbo].[SiteGroup] sg with(NOLOCK) on ps.SiteGroup_ID = sg.SiteGroup_ID
	  left join ClientPracticeSiteGroupLookup cpsgl with(NOLOCK) on sg.SiteGroup_ID = cpsgl.SiteGroup_id
	  WHERE (@IsPracticeSite = 1)
	  AND ((@Client_id is null) or (@Client_id = cpsgl.Client_id))
	  AND (@AHA_id is null)
	  and ((ps.bitActive = 1) and (sg.bitActive = 1))

	UPDATE t  
	SET t.IsHCAHPSAssigned=1  
	FROM #t t, SampleUnit su  
	WHERE t.SUFacility_id=su.SUFacility_id and  
	 su.bithcahps=1  
	  
	SELECT suf.SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,--MedicareName,  
	 IsHCAHPSAssigned  
	FROM #t suf
	ORDER BY strFacility_nm, City  
	  
	DROP TABLE #t  
	----------------------------  
end


