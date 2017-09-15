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
It will take a date find the appropriate Response Rate and Volume calculation windows for the specified SurveyType

logic for Finding Response Rate and Volume windows is used in
HCAHPS proportional Sampling to create the proportional sample percentage

Created: 8/11/2008 by MB
Refactored: 8/14/2017 by DG

*/
CREATE PROCEDURE dbo.QCL_CreateCAHPSRollingYear
	@PeriodDate DATETIME, 
	@SurveyType_id INT,
	@StartDateOut DATETIME OUTPUT, 
	@EndDateOut DATETIME OUTPUT
as

DECLARE @PeriodQtr INT, @FirstMonth INT

-- @PeriodDate's quarter:
set @PeriodQtr = DATEPART(QUARTER,@PeriodDate)

-- @PeriodQtr's first month
set @FirstMonth = (@PeriodQtr * 3) - 2

-- @PeriodDate is now the first day of its quarter
SET @PeriodDate = CONVERT(VARCHAR,@FirstMonth) + '/1/' + CONVERT(VARCHAR,YEAR(@periodDate))


-- @QuartersToSkip is the number of recent quarters we don't want to use in Response Rate and Volume calculations, because the samplesets aren't mature yet
DECLARE @QuartersToSkip int = 2

-- @QuartersToUse is the number of mature quarters we want to include in Response Rate and Volume calculations
DECLARE @QuartersToUse int = 4

IF @SurveyType_id IN (3,16) -- HHCAHPS and OAS CAHPS
BEGIN
	SET @QuartersToSkip = 1
	SET @QuartersToUse = 2
END

-- The response rate and volume window will start (@QuartersToSkip+@QuartersToUse) quarters back
SELECT @StartDateOut = DATEADD(QUARTER, -(@QuartersToSkip+@QuartersToUse), @PeriodDate)

-- and will end (@QuartersToSkip) quarters back, minus a day
SELECT @EndDateOut = DATEADD(DAY,-1,DATEADD(QUARTER, -@QuartersToSkip, @PeriodDate))

GO
/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It will return the current response rate
for all surveys in the given medicare number.  This is used when calculating the proportional sampling percentage

Created:  8/7/2008 by MB

*/
ALTER PROCEDURE [dbo].[QCL_PropSamp_CalcResponseRate]
 @MedicareNumber varchar(20), @PeriodDate datetime, @SurveyType_id int,  @indebug tinyint = 0
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @sql VARCHAR(8000)

declare @EncDateStart datetime, @EncDateEnd datetime
exec QCL_CreateCAHPSRollingYear @PeriodDate, @SurveyType_id, @EncDateStart OUTPUT, @EncDateEnd OUTPUT;


CREATE TABLE #SampleSets (Survey_id INT, SampleSet_id INT, datsamplecreate_dt datetime)
INSERT INTO #SampleSets
SELECT	ss.Survey_id, sssu.Sampleset_ID, ss.datsamplecreate_dt
FROM sufacility sf
JOIN sampleunit su				ON sf.SUFacility_ID = su.SuFacility_ID
JOIN samplesetUnitTarget sssu	ON su.sampleunit_ID = sssu.sampleunit_ID 
JOIN sampleset ss				ON ss.sampleset_ID = sssu.sampleset_ID 
JOIN periodDef pd1				ON pd1.datExpectedEncStart >= @EncDateStart and pd1.datExpectedEncEnd <= @EncDateEnd
JOIN periodDates pd2			ON pd1.periodDef_Id = pd2.PeriodDef_ID and pd2.sampleset_ID = ss.sampleset_ID AND pd2.sampleset_ID = sssu.sampleset_ID 
WHERE	su.CAHPSType_id = @SurveyType_id and
		sf.medicareNumber = @MedicareNumber

if @indebug = 1
	select '#SampleSets' as [#SampleSets], * from #SampleSets
	

--Everything from Here can Stay the same

CREATE TABLE #r (SampleUnit_id INT, intSampled INT, intReturned INT, bitCAHPS BIT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)

--
insert into #rr
select sampleset_id, sampleunit_id, intreturned, intsampled, intUD
from DATAMart.qp_comments.dbo.RespRateCount
where survey_id in (select survey_Id from #SampleSets) and
 sampleunit_id <>0

if @indebug = 1
	select '#rr' as [#rr], * from #rr

--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
INSERT INTO #r (SampleUnit_id, intSampled, intReturned, bitCAHPS)
SELECT SampleUnit_id, SUM(intSampled), SUM(intReturned), 0
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id=ss.SampleSet_id
GROUP BY SampleUnit_id

if @indebug = 1
	select '#r' as [#r], * from #r

--Identify HCAHPS units
UPDATE t
SET bitCAHPS=1
FROM #r t, SampleUnit su
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.CAHPSType_id = @SurveyType_id

IF @@ROWCOUNT>0
BEGIN

	CREATE TABLE #Update (SampleUnit_id INT, intReturned INT)
	CREATE TABLE #rrDays (sampleset_id INT, sampleunit_id INT, intreturned INT)

	insert into #rrDays
	select sampleset_id, sampleunit_id, sum(intreturned) as intreturned
	from DATAMart.qp_comments.dbo.RR_ReturnCountByDays
	where survey_id in (select survey_Id from #SampleSets)
	  AND DaysFromFirstMailing<43
	group by sampleset_id, sampleunit_id

	if @indebug = 1
		select '#rrDays' as [#rrDays], * from #rrDays

	--Update the response rate for the HCAHPS unit(s)
	INSERT INTO #Update (SampleUnit_id, intReturned)
	SELECT a.SampleUnit_id, a.intReturned
	FROM (	SELECT tt.SampleUnit_id, SUM(r2.intReturned) intReturned
			FROM #r TT
			JOIN #rr rrc ON tt.SampleUnit_id=rrc.SampleUnit_id
			JOIN #rrDays r2 ON tt.SampleUnit_id=r2.SampleUnit_id
			JOIN #SampleSets ss ON r2.sampleset_id=ss.sampleset_id
			WHERE tt.bitCAHPS=1
			GROUP BY tt.SampleUnit_id) a
	JOIN #r t ON a.SampleUnit_id=t.SampleUnit_id



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