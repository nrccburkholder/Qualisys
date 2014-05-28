-- ======================================================
-- Author:			Hui Holay
-- Create date:	12-13-2006
-- Description:		
-- =======================================================
-- Revision
-- =======================================================
CREATE PROCEDURE QP_Rep_ResponseRate_FullTreePlusTitle
	@Associate VARCHAR(20),
	@FirstDay DATETIME,
	@LastDay DATETIME,
	@Client VARCHAR(50),
	@Study VARCHAR(50) = 'ALL',
	@Survey VARCHAR(50) = 'ALL'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @procedurebegin DATETIME
	SET @procedurebegin = GETDATE()

	INSERT INTO DashboardLog (Report, Associate, StartDate, EndDate, ProcedureBegin) 
	SELECT 'Response Rate FullTreePlus', @Associate, @FirstDay, @LastDay, @ProcedureBegin

	IF @Firstday = @Lastday
		BEGIN
			SET @FirstDay = DATEADD(DAY, -45, @FirstDay)
		END

	 CREATE TABLE #Title (FirstDay DATETIME, LastDay DATETIME)
	 INSERT INTO #Title (Firstday, Lastday) VALUES (@FirstDay, @LastDay)
	 SELECT CONVERT(VARCHAR,FirstDay,1) AS [From], CONVERT(VARCHAR,LastDay,1) AS [To] FROM #Title
	 DROP TABLE #Title

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


