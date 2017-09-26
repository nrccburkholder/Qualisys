/*
	RTP-3948 Calculate Historic Response Rate

	Dave Gilsdorf

	CREATE PROCEDURE [dbo].[QCL_CreateCAHPSRollingYear]

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
