--CREATE SCHEMA [QualisysStudy]

CREATE FUNCTION [QualisysStudy].[fn_FindStartEndDates]
(	
	@Frequency VARCHAR(50)
	,@StartDateOffSetPart VARCHAR(50)
	,@StartDateOffSetInc INT
	,@EndDateOffSetDatePart VARCHAR(50)
	,@EndDateOffSetInc INT
)
RETURNS @Results TABLE
(
	StartDate DATE
	, EndDate DATE

)
AS
BEGIN

	DECLARE @OffSet INT,@currDate DATETIME,@StartDate DATE,@EndDate DATE, @lastYear INT
	, @firstmonth INT, @firstday INT, @lastmonth INT, @lastday INT, @M_DatePart INT, @Y_DatePart INT, @RunDate DATETIME
	SET @currDate = GETDATE()
	SET @M_DatePart = DATEPART(MONTH, @currDate);
	SET @Y_DatePart = DATEPART(YEAR, @currDate);

	IF @Frequency = 'Year' 
	BEGIN	
								   
		SELECT @firstmonth = 1, @firstday = 1, @lastmonth=12,@lastday=31			   
		--first day of previous Year
		SET @lastYear =  DATEPART(year,DATEADD(year,-1,@currDate))
		
		--last day of previous Year 
		SET @EndDate =  dateadd(ms,86399998,dateadd(day, @lastday - 1, dateadd(month, @lastmonth - 1, dateadd(year, @lastYear-1900, 0))))

    END
	ELSE IF @Frequency = 'Month' 
	BEGIN	
						   
		--first day of previous month + offset if initial run
		--last day of previous month 	
		IF @StartDateOffSetPart = 'DAY'
		BEGIN
			SET @StartDate = CAST( DATEADD(mm, -1, DATEADD(dd,-(DAY(DATEADD(mm,-1,@currDate))-1),DATEADD(dd,@StartDateOffSetInc,@currDate))) AS DATETIME )
		END
		ELSE IF @StartDateOffSetPart = 'YEAR'  
		BEGIN
			--last day of previous month 	
			IF  @EndDateOffSetDatePart = 'DAY'
			BEGIN 
				SET @EndDate = CAST( DATEADD(DAY,@EndDateOffSetInc ,DATEADD(dd,-(DAY(@currDate)),@currDate)) AS DATETIME )	
				SET @StartDate = CAST( DATEADD(DAY, 1, DATEADD(YEAR,@StartDateOffSetInc,@EndDate)) AS DATETIME )
			END
			
		END
		ELSE
		BEGIN
			SET @StartDate =  CAST( DATEADD(dd,-(DAY(DATEADD(mm,1,DATEADD(mm,@StartDateOffSetInc,@currDate)))-1),DATEADD(mm,@StartDateOffSetInc,@currDate))AS DATETIME )
		END
		
		

		

		---------------------------------------------------------------------------------------------------------------------------------------  
		--SET @StartDate = '2012-10-01'
		--SET @EndDate = '2013-04-30'
    END
    ELSE IF @Frequency = 'Week' 
	BEGIN
		--Sunday start of previous week
		SET @StartDate =  DATEADD(wk, DATEDIFF(wk, 6, GETDATE()-6 + @StartDateOffSetInc), 6)		

		--Saturday end of previous week	
		SET @EndDate = DATEADD(dd, - datepart(dw, GetDate()) + @EndDateOffSetInc, GetDate())
		
    END
    ELSE IF @Frequency = 'DAY' 
	BEGIN
		--Sunday start of previous week
		SET @StartDate =  DATEADD(dd, @StartDateOffSetInc, GETDATE())		

		--Saturday end of previous week	
		SET @EndDate = DATEADD(dd, @EndDateOffSetInc, GETDATE())
		
    END
    ELSE --Error
    BEGIN		  
		--SELECT @monthOffSet,@startDate,@endDate 
		SET @StartDate = NULL
		SET @EndDate= NULL
    END 
    
    --SELECT @monthOffSet,@startDate,@endDate 
	INSERT INTO @Results
	(StartDate, EndDate)
	SELECT @StartDate AS ReturnsStartDate,@EndDate AS ReturnsEndDate
	RETURN

END
