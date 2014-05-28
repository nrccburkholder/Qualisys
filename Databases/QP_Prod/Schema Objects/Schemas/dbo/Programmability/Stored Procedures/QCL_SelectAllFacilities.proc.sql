CREATE PROCEDURE [dbo].[QCL_SelectAllFacilities]  
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
	  
	UPDATE t  
	SET t.IsHCAHPSAssigned=1  
	FROM #t t, SampleUnit su  
	WHERE t.SUFacility_id=su.SUFacility_id and  
	 su.bithcahps=1  
	  
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,--MedicareName,  
	 IsHCAHPSAssigned  
	FROM #t  
	ORDER BY strFacility_nm, City  
	  
	DROP TABLE #t  
	----------------------------  
end


