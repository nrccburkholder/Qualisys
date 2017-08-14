/*
	RTP-3948 Calculate Historic Response Rate

	Dave Gilsdorf

	CREATE PROCEDURE [dbo].[QCL_CreateCAHPSRollingYear]
	ALTER PROCEDURE [dbo].[QCL_PropSamp_CalcResponseRate]

*/
use qp_prod
go
IF OBJECT_ID('[dbo].[QCL_CreateCAHPSRollingYear]') IS NOT NULL
	DROP PROCEDURE [dbo].[QCL_CreateCAHPSRollingYear]
GO
/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.
It will take a date find the previous calander quarter and output the starting and ending date to create a rolling year.

logic for Finding year block for rolling HCAHPS year is used in
HCAHPS proportional Sampling to create the proportional sample percentage

Created: 8/11/2008 by MB



--To Test this proc Test proc

declare @outStart datetime, @outEnd Datetime
exec QCL_CreateHCHAPSRollingYear '2004-8-01 1:00:00', @outStart OUTPUT, @outEnd OUTPUT

print '@outStart called'
print convert(varchar, @outStart,120)
print '@outEnd called'
print convert(varchar, @outEnd,120)

*/
CREATE PROCEDURE dbo.QCL_CreateCAHPSRollingYear
	@PeriodDate DATETIME, 
	@StartDateOut DATETIME OUTPUT, 
	@EndDateOut DATETIME OUTPUT
as

DECLARE @PeriodQtr INT, @FirstMonth INT

-- @PeriodDate's quarter:
set @PeriodQtr = DATEPART(QUARTER,@PeriodDate)

-- @PeriodQtr's first month
set @FirstMonth = (@PeriodQtr * 3) - 2

-- first day of @PeriodDate's quarter
SET @PeriodQtr = CONVERT(VARCHAR,@FirstMonth) + '/1/' + CONVERT(VARCHAR,YEAR(@periodDate))


-- @QuartersToSkip is the number of recent quarters we don't want to use in Response Rate and Volume calculations, because the samplesets aren't mature yet
DECLARE @QuartersToSkip int = 2

-- @QuartersToUse is the number of mature quarters we want to include in Response Rate and Volume calculations
DECLARE @QuartersToUse int = 4


-- The response rate and volume window will start (@QuartersToSkip+@QuartersToUse) quarters back
SELECT @StartDateOut = DATEADD(QUARTER, -(@QuartersToSkip+@QuartersToUse), @PeriodQtr)

-- and will end (@QuartersToSkip) quarters back, minus a day
SELECT @EndDateOut = DATEADD(DAY,-1,DATEADD(QUARTER, -@QuartersToSkip, @PeriodQtr))

GO
/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It will return the current response rate
for all surveys in the given medicare number.  This is used when calculating the proportional sampling percentage

Created:  8/7/2008 by MB

*/
ALTER PROCEDURE [dbo].[QCL_PropSamp_CalcResponseRate]
 @MedicareNumber varchar(20), @PeriodDate datetime,   @indebug tinyint = 0
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @sql VARCHAR(8000), @DataMart VARCHAR(50)

SELECT @DataMart=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'

declare @EncDateStart datetime, @EncDateEnd datetime
exec QCL_CreateHCHAPSRollingYear @PeriodDate, @EncDateStart OUTPUT, @EncDateEnd OUTPUT



CREATE TABLE #SampleSets (SampleSet_id INT, datsamplecreate_dt datetime)
INSERT INTO #SampleSets
SELECT	sssu.Sampleset_ID, ss.datsamplecreate_dt
FROM	medicarelookup ml, sufacility sf, sampleunit su, samplesetUnitTarget sssu, sampleset ss, periodDef pd1, periodDates pd2
WHERE	ml.medicareNumber = sf.MedicareNumber and
		sf.SUFacility_ID = su.SuFacility_ID and
		su.sampleunit_ID = sssu.sampleunit_ID and
		ss.sampleset_ID = sssu.sampleset_ID and
		pd1.periodDef_Id = pd2.PeriodDef_ID and
		pd2.sampleset_ID = ss.sampleset_ID and
		pd2.sampleset_ID = sssu.sampleset_ID and
		pd1.datExpectedEncStart >= @EncDateStart and
		pd1.datExpectedEncEnd <= @EncDateEnd and
		su.bithcahps = 1 and
		ml.medicareNumber = @MedicareNumber

if @indebug = 1
	select '#SampleSets' as [#SampleSets], * from #SampleSets

CREATE TABLE #SurveyIDs (Survey_ID INT)
INSERT INTO #SurveyIDs
SELECT	distinct ss.Survey_ID
FROM	medicarelookup ml, sufacility sf, sampleunit su, samplesetUnitTarget sssu, sampleset ss
WHERE	ml.medicareNumber = sf.MedicareNumber and
		sf.SUFacility_ID = su.SuFacility_ID and
		su.sampleunit_ID = sssu.sampleunit_ID and
		ss.sampleset_ID = sssu.sampleset_ID and
		su.bithcahps = 1 and
		ml.medicareNumber = @MedicareNumber

if @indebug = 1
	select '#SurveyIDs' as [#SurveyIDs], * from #SurveyIDs



--Everything from Here can Stay the same

CREATE TABLE #r (SampleUnit_id INT, intSampled INT, intReturned INT, bitHCAHPS BIT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)

--
insert into #rr
select sampleset_id, sampleunit_id, intreturned, intsampled, intUD
from DATAMart.qp_comments.dbo.RespRateCount
where survey_id in (select survey_Id from #SurveyIDs) and
 sampleunit_id <>0

if @indebug = 1
	select '#rr' as [#rr], * from #rr

--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
SELECT @sql='INSERT INTO #r (SampleUnit_id, intSampled, intReturned, bitHCAHPS)
SELECT SampleUnit_id, SUM(intSampled), SUM(intReturned), 0
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id=ss.SampleSet_id
GROUP BY SampleUnit_id'
EXEC (@sql)

if @indebug = 1
	select '#r' as [#r], * from #r

--Identify HCAHPS units
UPDATE t
SET bitHCAHPS=1
FROM #r t, SampleUnit su
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.bitHCAHPS=1

IF @@ROWCOUNT>0
BEGIN

CREATE TABLE #Update (SampleUnit_id INT, intReturned INT)
CREATE TABLE #rrDays (sampleset_id INT, sampleunit_id INT, intreturned INT)

insert into #rrDays
select sampleset_id, sampleunit_id, sum(intreturned) as intreturned
from DATAMart.qp_comments.dbo.RR_ReturnCountByDays
where survey_id in (select survey_Id from #SurveyIDs)
  AND DaysFromFirstMailing<43
group by sampleset_id, sampleunit_id

if @indebug = 1
	select '#rrDays' as [#rrDays], * from #rrDays

 --Update the response rate for the HCAHPS unit(s)
 SELECT @sql='INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(r2.intReturned) intReturned
       FROM #rr rrc,
     #rrDays r2,
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND r2.sampleset_id=ss.sampleset_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND tt.SampleUnit_id=r2.SampleUnit_id
  AND ss.datSampleCreate_dt>''4/10/6''
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id

 INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(rrc.intReturned) intReturned
       FROM #rr rrc,
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND ss.datSampleCreate_dt<''4/10/6''
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id'

 EXEC (@sql)

if @indebug = 1
	select '#Update' as [#Update], * from #Update

 UPDATE t
 SET intReturned=u.intReturned
 FROM #r t, (SELECT SampleUnit_id, SUM(intReturned) intReturned
 FROM #Update
 GROUP BY SampleUnit_id) u
 WHERE t.SampleUnit_id=u.SampleUnit_id

 DROP TABLE #Update

if @indebug = 1
	select '#r' as [#r], * from #r

END

select avg(RespRate)
FROM SampleUnit su, (SELECT SampleUnit_id, ((intReturned*1.0)/(intSampled)*100) RespRate FROM #r) a
WHERE su.SampleUnit_id=a.SampleUnit_id


DROP TABLE #r

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO