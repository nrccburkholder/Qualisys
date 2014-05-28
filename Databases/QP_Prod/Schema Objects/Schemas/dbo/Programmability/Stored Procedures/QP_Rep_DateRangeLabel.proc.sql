CREATE PROCEDURE QP_Rep_DateRangeLabel @Associate VARCHAR(50), @BeginDate datetime, @EndDate datetime
AS
	SET @EndDate = DATEADD(hh,23,@EndDate)
	SET @EndDate = DATEADD(mi,59,@EndDate)

SELECT CONVERT(VARCHAR,@BeginDate) + ' - ' + CONVERT(VARCHAR,@EndDate) AS DateRange


