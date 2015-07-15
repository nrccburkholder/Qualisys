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
alter PROCEDURE [dbo].[QCL_SampleSetAssignHouseHold]
 @strHouseholdField_CreateTable  VARCHAR(8000), /* List of fields and type that are used for HouseHolding criteria */
 @strHouseholdField_Select   VARCHAR(8000), /* List of fields that are used for HouseHolding criteria */
 @strHousehold_Join    VARCHAR(8000),
 @HouseHoldingType CHAR(1)
AS

--print '@strhouseholdfield_createtable = ' + @strHouseholdField_CreateTable
--print '@strHouseholdField_Select = ' + @strHouseholdField_Select
--print '@strHousehold_Join = ' + @strHousehold_Join
--print '@HouseHoldingType = ' + @HouseHoldingType
DECLARE @sql VARCHAR(max), @surveytype_id int

select @surveytype_id=sd.surveytype_id
from #SampleUnit_Universe suu
inner join sampleunit su on suu.sampleunit_id=su.sampleunit_id
inner join sampleplan sp on su.sampleplan_id=sp.sampleplan_id
inner join survey_def sd on sp.survey_id=sd.survey_id

IF @HouseHoldingType='A'
BEGIN
	if @surveytype_id=2 -- HCAHPS
	begin

declare @dbg varchar(30) set @dbg=convert(varchar,getdate(),109)

set @SQL = 'temp_dbg_SampleUnit_Universe QCL_SampleSetAssignHouseHold              before '+@dbg
while exists (select * from sys.tables where name = @SQL)
	set @SQL = @SQL + 'x'

set @SQL = 'select * into ['+@SQL+'] from #SampleUnit_Universe'
exec (@SQL)


set @sql = 'temp_dbg_distinct            QCL_SampleSetAssignHouseHold                     '+@dbg
while exists (select * from sys.tables where name = @SQL)
	set @SQL = @SQL + 'x'
		
		SELECT @sql='CREATE TABLE ['+@sql+'] (a INT IDENTITY(-1,-1), '+@strHouseHoldField_CreateTable+', CCN varchar(20))
		INSERT INTO ['+@sql+'] ('+@strHouseHoldField_Select+', CCN)
		SELECT DISTINCT '+SUBSTRING(REPLACE(REPLACE(@strHouseHoldField_Select,'x.',',9999999),ISNULL('),', ,',','),12,2000)+',9999999), isnull(suf.MedicareNumber,''dummy'')
		FROM #SampleUnit_Universe X
		INNER JOIN SampleUnit su on x.sampleunit_id=su.sampleunit_id
		LEFT JOIN SUFacility suf on su.SUFacility_id=suf.SUFacility_id

		-- assign household_id to those who are HCAHPS eligible, using the HCAHPS sampleunit’s CCN as part of the critera
		UPDATE x
		SET x.HouseHold_id=y.a
		FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, ['+@sql+'] y
		WHERE x.sampleunit_id = su.sampleunit_id 
		and su.SUFacility_id = suf.SUFacility_id
		and suf.medicarenumber=y.ccn
		and '+REPLACE(REPLACE(@strHouseHold_Join,'x.','ISNULL(X.'),'=',',9999999)=')+'
		and su.bitHCAHPS=1

		-- if the same pop_id that’s in an HCAHPS unit is also in some other (non-HCAHPS eligible) units, assign them the same household_id we just assigned them
		update x
		set household_id=sub.household_id
		from #SampleUnit_Universe x
		inner join (SELECT POP_ID,HOUSEHOLD_ID FROM #SampleUnit_Universe WHERE HOUSEHOLD_ID IS NOT NULL) sub
			on x.pop_id=sub.pop_id
		where x.household_id is null

		-- if there’s anyone in the household that wasn’t HCAHPS eligible, assign them to their HCAHPS-eligible housemate’s household_id 
		UPDATE x
		SET x.HouseHold_id=y.a
		FROM #SampleUnit_Universe x, ['+@sql+'] y
		WHERE '+REPLACE(REPLACE(@strHouseHold_Join,'x.','ISNULL(X.'),'=',',9999999)=')+'
		and y.CCN<>''dummy''
		AND isnull(x.Household_id,0)=0

		-- now assign household_id to households in which no one was HCAHPS eligible
		UPDATE x
		SET x.HouseHold_id=y.a
		FROM #SampleUnit_Universe x, ['+@sql+'] y
		WHERE '+REPLACE(REPLACE(@strHouseHold_Join,'x.','ISNULL(X.'),'=',',9999999)=')+'
		and y.CCN=''dummy''
		AND isnull(x.Household_id,0)=0

		--DROP TABLE ['+@sql+']'
	end
	else
	begin
		SELECT @sql='CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), '+@strHouseHoldField_CreateTable+')
		INSERT INTO #Distinct ('+@strHouseHoldField_Select+')
		SELECT DISTINCT '+SUBSTRING(REPLACE(REPLACE(@strHouseHoldField_Select,'x.',',9999999),ISNULL('),', ,',','),12,2000)+',9999999)
		FROM #SampleUnit_Universe X

		UPDATE x
		SET x.HouseHold_id=y.a
		FROM #SampleUnit_Universe x, #Distinct y
		WHERE '+REPLACE(REPLACE(@strHouseHold_Join,'x.','ISNULL(X.'),'=',',9999999)=')+'

		DROP TABLE #Distinct'
	end

	select @sql = replace(@sql, 'DOB,9999999', 'DOB,''12/31/4000''')
	select @sql = replace(@sql, 'Date,9999999', 'Date,''12/31/4000''')

	print @sql

if not exists (select * from sys.tables where name = 'temp_dbg_somestrings')
	create table temp_dbg_somestrings (ss_id int identity(1,1), theProc varchar(100), theTime datetime, theString varchar(8000))

INSERT INTO temp_dbg_somestrings (theProc, theTime, theString) values ('QCL_SampleSetAssignHouseHold', getdate(), @SQL)

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

set @SQL = 'temp_dbg_SampleUnit_Universe QCL_SampleSetAssignHouseHold              after  '+@dbg
while exists (select * from sys.tables where name = @SQL)
	set @SQL = @SQL + 'x'

set @SQL = 'select * into ['+@SQL+'] from #SampleUnit_Universe'
exec (@SQL)

go
