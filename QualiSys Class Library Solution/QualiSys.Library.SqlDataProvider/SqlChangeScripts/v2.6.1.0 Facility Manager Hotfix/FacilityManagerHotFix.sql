set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.

Created: 3/14/2006 by DC

Modified:


*/
ALTER  PROCEDURE [dbo].[QCL_SelectFacility]
@SUFacility_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,MedicareName
FROM SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
WHERE SUFacility_id=@SUFacility_id

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id and
	su.bithcahps=1

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


--------------------------------------------
GO
--------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*      
Business Purpose:       
This procedure is used to support the Qualisys Class Library.  It will return all facilities for an AHAId.  
      
Created: 3/14/2006 by DC  
      
Modified:      
    
  
*/          
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByAHAId]  
@AHA_ID INT  
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,MedicareName
FROM SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
WHERE AHA_id=@AHA_id  

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id and
	su.bithcahps=1

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
---------------------------------------

GO
---------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*          
Business Purpose:           
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.      
          
Created: 3/14/2006 by DC      
          
Modified:          
        
      
*/
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByClientId]
@Client_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
MedicareName VARCHAR(200),
IsHCAHPSAssigned BIT DEFAULT(0)
)

INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT suf.SUFacility_id,strFacility_nm,City,State,Country,
  Region_id,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,
  bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,
  bitCancerCenter,bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,
  MedicareName
FROM ClientSUFacilityLookup cf, SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
WHERE cf.Client_id=@Client_Id
AND cf.SUFacility_id=suf.SUFacility_id

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id and
	su.bithcahps=1

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-----------------------------------------
GO
-----------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllFacilities]
AS  

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
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName)
SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber,MedicareName
FROM SUFacility suf LEFT JOIN MedicareLookup ml
ON suf.MedicareNumber=ml.MedicareNumber
ORDER BY strFacility_nm, City

UPDATE t
SET t.IsHCAHPSAssigned=1
FROM #t t, SampleUnit su
WHERE t.SUFacility_id=su.SUFacility_id and
	su.bithcahps=1

SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,
 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,
 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,
 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,MedicareName,
 IsHCAHPSAssigned
FROM #t
ORDER BY strFacility_nm, City

DROP TABLE #t
----------------------------
GO
----------------------------
ALTER TABLE Sampleunit DROP COLUMN facilitystate
----------------------------
GO
----------------------------
CREATE PROCEDURE QCL_AllowUnassignmentFacility
@FacilityId INT,
@ClientId INT
AS

--Return 1 if facility can be unassigned, otherwise return 0
IF EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s 
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	SELECT 1
END
----------------------------
GO
----------------------------
ALTER PROCEDURE QCL_Samp_PopulateDataSetDates @DataSet_id INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF  
  
DELETE DataSetDateRange WHERE DataSet_id=@DataSet_id  
  
DECLARE @Study_id INT, @sql VARCHAR(8000), @hasEncounter BIT, @a INT  
  
SELECT @Study_id=Study_id FROM Data_Set WHERE DataSet_id=@DataSet_id  
  
--Do we have an encounter table in the study  
IF EXISTS (SELECT * FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')  
  SELECT @hasEncounter=1  
ELSE   
  SELECT @hasEncounter=0  
  
--Get the list of fields we have to deal with  
SELECT IDENTITY(INT,1,1) a, strTable_nm+strField_nm DateField, Table_id, Field_id  
INTO #Field  
FROM MetaData_View  
WHERE strFieldDataType='d'   
AND bitUserField_flg=1  
AND Study_id=1040--@Study_id  


-- Return out of the procedure if there are no datefields to report on.
IF @@ROWCOUNT = 0
	RETURN
  
--Create a temp table to hold the dates  
CREATE TABLE #Dates (DataSet_id INT)  
  
--Initialize the variable  
SELECT @sql='ALTER TABLE #Dates ADD'  
  
--Add in the additional columns needed in the #Dates table  
SELECT @sql=@sql+CASE WHEN RIGHT(@sql,3)='ADD' THEN ' ' ELSE ',' END+'MIN_'+DateField+' DATETIME,MAX_'+DateField+' DATETIME'  
FROM #field  
  
EXEC (@sql)  
  
--Now to build the syntax to populate the #Dates table  
SELECT @sql='INSERT INTO #Dates (DataSet_id'  
  
--Add in the columns  
SELECT @sql=@sql+',MIN_'+DateField+',MAX_'+DateField  
FROM #Field  
ORDER BY a  
  
--Add the select clause  
SELECT @sql=@sql+') SELECT '+LTRIM(STR(@DataSet_id))  
  
--Add the columns to the select clause  
SELECT @sql=@sql+',MIN('+DateField+'),MAX('+DateField+')'  
FROM #Field  
ORDER BY a  
  
--Finish off the query   
SELECT @sql=@sql+' FROM S'+LTRIM(STR(@Study_id))+'.Big_View b, DataSetMember dsm  
WHERE dsm.DataSet_id='+LTRIM(STR(@DataSet_id))+'  
AND '+CASE @hasEncounter WHEN 1 THEN 'dsm.Enc_id=b.EncounterEnc_id' ELSE 'dsm.Pop_id=b.PopulationPop_id' END  
  
EXEC (@sql)  
  
--Now to use the temp table to populate the DataSetDateRange table  
--Loop thru one field at a time  
SELECT TOP 1 @a=a FROM #Field ORDER BY a  
WHILE @@ROWCOUNT>0  
BEGIN  
  
--Add a record into the DataSetDateRange table for the table and field  
SELECT @sql='INSERT INTO DataSetDateRange (DataSet_id, Table_id, Field_id, MinDate, MaxDate)  
SELECT '+LTRIM(STR(@DataSet_id))+',Table_id, Field_id, MIN_'+DateField+',MAX_'+DateField+'  
FROM #Dates t, #Field f  
WHERE f.a='+LTRIM(STR(@a))  
FROM #Field  
WHERE a=@a  
  
EXEC (@sql)  
  
DELETE #Field WHERE a=@a  
  
SELECT TOP 1 @a=a FROM #Field ORDER BY a  
  
END  
  
  
DROP TABLE #Field  
DROP TABLE #Dates  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
SET ANSI_WARNINGS ON  


