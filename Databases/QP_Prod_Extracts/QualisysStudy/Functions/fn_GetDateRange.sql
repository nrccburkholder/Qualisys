CREATE FUNCTION [QualisysStudy].[fn_GetDateRange]
(	
	@Frequency VARCHAR(20)
	,@DatePartIncrement INT
	,@DateOffSet INT
	,@DateHour INT
)
RETURNS @Results TABLE
(
	StartDate DATE
	, EndDate DATE
	, CurrentDate DATETIME
	, RunDate DATETIME
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
		Set @StartDate =  dateadd(day, @firstday - 1, dateadd(month, @firstmonth - 1, dateadd(year, @lastYear-1900, 0)))
		SET @RunDate = DateAdd(HOUR, @DateHour,dateadd(day, @DatePartIncrement - 1, dateadd(month, @firstmonth - 1, dateadd(year, @Y_DatePart-1900, 0))))
		--last day of previous Year 
		SET @EndDate =  dateadd(ms,86399998,dateadd(day, @lastday - 1, dateadd(month, @lastmonth - 1, dateadd(year, @lastYear-1900, 0))))
	
    END
	ELSE IF @Frequency = 'Month' 
	BEGIN	
		SET @OffSet = @DateOffSet	
		SET @RunDate = DateAdd(HOUR, @DateHour,DateAdd(day, @DatePartIncrement - 1, DateAdd(month, @M_DatePart - 1, DateAdd(Year, @Y_DatePart-1900, 0))))						   
		--first day of previous month + offset if initial run
		SET @StartDate =  CAST( DATEADD(dd,-(DAY(DATEADD(mm,1,DATEADD(mm,-@OffSet,@currDate)))-1),DATEADD(mm,-@OffSet,@currDate))AS DATETIME )
		--last day of previous month 	
		SET @EndDate = CAST( DATEADD(dd,-(DAY(@currDate)),@currDate) AS DATETIME )	

		---------------------------------------------------------------------------------------------------------------------------------------  
		--SET @StartDate = '2012-10-01'
		--SET @EndDate = '2013-04-30'
    END
    ELSE IF @Frequency = 'Week' 
	BEGIN
	
		SET @DatePartIncrement = DATEPART(DAY, GETDATE()) - DATEPART(WeekDay, GETDATE()) + @DatePartIncrement

		SET @RunDate = DateAdd(HOUR, @DateHour,DateAdd(day, @DatePartIncrement - 1, DateAdd(month, @M_DatePart - 1, DateAdd(Year, @Y_DatePart-1900, 0)))	)
							   			
		--Sunday start of previous week
		SET @StartDate =  DATEADD(wk, DATEDIFF(wk, 6, GETDATE()-6), 6)		

		--Saturday end of previous week	
		SET @EndDate = DATEADD(dd, - datepart(dw, GetDate()), GetDate())
		
    END
    ELSE IF @Frequency = 'Day' 
	BEGIN
	
			--Sunday start of previous week
		SET @StartDate =  DATEADD(dd, @DatePartIncrement, GETDATE())		
		--Saturday end of previous week	
		SET @EndDate = DATEADD(dd, @DatePartIncrement, GetDate())

		SET @DatePartIncrement = DATEPART(DAY, GETDATE()) + @DatePartIncrement
		SET @RunDate = DateAdd(HOUR, @DateHour,DateAdd(day, @DatePartIncrement , DateAdd(month, @M_DatePart - 1, DateAdd(Year, @Y_DatePart-1900, 0)))	)
							   			

		
    END    
    ELSE --Error
    BEGIN		  
		--SELECT @monthOffSet,@startDate,@endDate 
		SET @StartDate = NULL
		SET @EndDate= NULL
    END 
    
    --SELECT @monthOffSet,@startDate,@endDate 
	INSERT INTO @Results
	(StartDate, EndDate, CurrentDate,RunDate)
	SELECT @StartDate AS ReturnsStartDate,@EndDate AS ReturnsEndDate, @currDate AS CurrentDate, @RunDate AS RunDate
	RETURN

END
