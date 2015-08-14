/*
-- =============================================
-- S31_R13_T2_CGCAHPS_Group_And_Site_Tool_QCL_SelectAllFacilities.sql
-- Create date: July, 2015
-- Description:	finish config manager group and sites tab with saves and updates and deactivation
--				Modify assign to clients tab to include groups; include CRUD

ALTER PROCEDURE [dbo].[QCL_SelectAllFacilities]
-- =============================================
*/
USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectAllFacilities]    Script Date: 8/4/2015 2:23:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllFacilities]  
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
	  
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)  
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber
	--,MedicareName  
	FROM SUFacility suf 
	--LEFT JOIN MedicareLookup ml  
	--ON suf.MedicareNumber=ml.MedicareNumber  
	ORDER BY strFacility_nm, City  
/*
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)
	SELECT [AssignedID]
		  ,[GroupName]
		  ,[City]
		  ,[ST]
		  ,'USA'
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
		  ,[SiteGroup_ID]
		  ,NULL

	  FROM [dbo].[SiteGroup]
*/
	UPDATE t  
	SET t.IsHCAHPSAssigned=1  
	FROM #t t, SampleUnit su  
	WHERE t.SUFacility_id=su.SUFacility_id and  
	 su.bithcahps=1  
	  
	SELECT suf.SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,--MedicareName,  
	 IsHCAHPSAssigned  
	FROM #t suf
	inner join ClientSUFacilityLookup csuf on suf.SUFacility_id = csuf.SUFacility_id 
	WHERE ((@SUFacility_id is null) or (@SUFacility_id = suf.SUFacility_id))
	AND ((@AHA_id is null) or (@AHA_id = AHA_id))
	AND ((@Client_id is null) or (@Client_id = csuf.Client_id))
	ORDER BY IsNull(MedicareNumber, 'ZZZZZZ'),strFacility_nm, City  
	  
	DROP TABLE #t  
	----------------------------  
end
