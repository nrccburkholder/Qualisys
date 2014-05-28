CREATE PROCEDURE QP_Rep_ScanningStatusTitle
    @Associate varchar(50),
    @BeginDate datetime,
    @EndDate   datetime
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, startdate, enddate, procedurebegin) select 'Scanning Status', @associate, @begindate, @enddate, @procedurebegin

--Create the temp table for the title data
CREATE TABLE #Title (BeginDate datetime, EndDate DateTime)

--Insert the dates into the temp table
INSERT INTO #Title (BeginDate, EndDate) VALUES (@BeginDate, @EndDate)

--Select the title data
SELECT Convert(varchar, BeginDate, 101) AS [From], Convert(varchar, EndDate, 101) AS [To] FROM #Title

--Cleanup the mess
DROP TABLE #Title

set transaction isolation level read committed


