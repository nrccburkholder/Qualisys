/*
	S28 US23	de-duplication at CCN level
	As a team we want to finish development of de-dup at CCN level
	per HCAHPS compliance. Next visit is Oct.  Split work over multiple sprints	2

	23.2	make modifications to stored procedures

Dave Gilsdorf

QP_Prod:
ALTER PROCEDURE [dbo].[QCL_SampleSetAssignHouseHold]
*/
go
use qp_prod
go
--5/10/2011 DRM  Added code to replace 9999999 with '12/31/4000' for ISNULL on date fields  
ALTER PROCEDURE QCL_SampleSetAssignHouseHold          
 @strHouseholdField_CreateTable  VARCHAR(8000), /* List of fields and type that are used for HouseHolding criteria */          
 @strHouseholdField_Select   VARCHAR(8000), /* List of fields that are used for HouseHolding criteria */          
 @strHousehold_Join    VARCHAR(8000),          
 @HouseHoldingType CHAR(1)          
AS          

print '@strhouseholdfield_createtable = ' + @strHouseholdField_CreateTable        
print '@strHouseholdField_Select = ' + @strHouseholdField_Select        
print '@strHousehold_Join = ' + @strHousehold_Join        
print '@HouseHoldingType = ' + @HouseHoldingType        
DECLARE @sql VARCHAR(8000)          
  
IF @HouseHoldingType='A'          
BEGIN          
SELECT @sql='CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), '+@strHouseHoldField_CreateTable+')          
INSERT INTO #Distinct ('+@strHouseHoldField_Select+')          
SELECT DISTINCT '+SUBSTRING(REPLACE(REPLACE(@strHouseHoldField_Select,'x.',',9999999),ISNULL('),', ,',','),12,2000)+',9999999)'+'          
FROM #SampleUnit_Universe X          
          
UPDATE x          
SET x.HouseHold_id=y.a          
FROM #SampleUnit_Universe x, #Distinct y          
WHERE '+REPLACE(REPLACE(@strHouseHold_Join,'x.','ISNULL(X.'),'=',',9999999)=')+'          
          
DROP TABLE #Distinct'      


select @sql = replace(@sql, 'DOB,9999999', 'DOB,''12/31/4000''')  
select @sql = replace(@sql, 'Date,9999999', 'Date,''12/31/4000''')  
  
print @sql

EXEC (@sql)          
END          
          
ELSE IF @HouseHoldingType='M'          
BEGIN          
SELECT @sql='SELECT * FROM FicticiousTable'          
EXEC (@sql)          
END          
          
IF @HouseHoldingType IN ('M','A')          
--Now to set HouseHold_id back to NULL if the person is the only pop_id tied to the HouseHold_id          
UPDATE suu          
SET HouseHold_id=NULL          
FROM #SampleUnit_Universe suu, (          
  SELECT HouseHold_id          
  FROM #SampleUnit_Universe          
  GROUP BY HouseHold_id          
  HAVING COUNT(DISTINCT Pop_id)=1) a          
WHERE a.HouseHold_id=suu.HouseHold_id          
go