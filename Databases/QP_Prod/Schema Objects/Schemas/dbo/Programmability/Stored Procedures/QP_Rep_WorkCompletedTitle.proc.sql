CREATE PROCEDURE QP_Rep_WorkCompletedTitle
 @Associate VARCHAR(20),
 @FirstDay DATETIME,
 @LastDay DATETIME,
 @Client VARCHAR(50) = 'ALL',
 @Study VARCHAR(50) = 'ALL',
 @Survey VARCHAR(50) = 'ALL'
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @procedurebegin DATETIME
SET @procedurebegin = GETDATE()

INSERT INTO dashboardlog (report, associate, startdate, enddate, procedurebegin) SELECT 'Work Completed', @associate, @firstday, @lastday, @procedurebegin

  IF @firstday = @lastday
	BEGIN
		SET @firstday = DATEADD(DAY, -45, @firstday)
	END


 CREATE TABLE #title (FirstDay DATETIME, LastDay DATETIME)
 INSERT INTO #title (firstday,lastday) VALUES (@firstDay, @lastDay)
 SELECT CONVERT(VARCHAR,FirstDay,1) AS [From], CONVERT(VARCHAR,LastDay,1) AS [To] FROM #title
 DROP TABLE #Title

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


