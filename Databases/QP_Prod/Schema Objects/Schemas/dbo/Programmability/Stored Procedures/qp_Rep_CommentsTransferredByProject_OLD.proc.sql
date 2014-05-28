CREATE procedure qp_Rep_CommentsTransferredByProject_OLD       
    @Associate varchar(50),        
    @StartDate datetime,        
    @EndDate datetime        
        
as        
        
-- =======================================================        
-- Revision        
-- MWB - 1/15/09  Added ContractNumber to report for       
-- SalesLogix integration      
-- =======================================================        
  
/******************************************************************************/  
----Debug code      
--declare @Associate varchar(50), @StartDate datetime, @EndDate datetime        
--set @Associate = 'mbeltz'  
--set @StartDate = '2009-02-23 00:000:00'  
--set @EndDate = '2009-03-03 00:00:00'  
/******************************************************************************/  
      
--Set the isolation level to avoid table locks        
set transaction isolation level read uncommitted        
set nocount on        
        
--Declare variables        
Declare @SQL        varchar(1000)        
Declare @ContractNumber varchar(9)        
        
        
--Create work tables        
CREATE TABLE #ByDay (ContractNumber varchar(9),         
                     datEntered  datetime,         
                     datReturned datetime,         
                     intKeyed    int,         
                     intDays     int)        
        
CREATE TABLE #ContractNumber (ContractNumber varchar(9))        
        
CREATE TABLE #Results (ContractNumber varchar(9),      
                       intKeyed    int,        
                       intSame     int,        
                       int1Day     int,        
                       int2Day     int,        
                       int3Day     int,        
                       int4Day     int,        
                       int5Day     int,        
                       int6Day     int,        
                       int7Day     int,        
                       int8Day     int)        
        
--Get the counts by date entered and returned by Project Number        
set @SQL = 'INSERT INTO #ByDay (ContractNumber, datEntered, datReturned, intKeyed) ' + char(10) +        
           'SELECT isnull(sd.contract, ''Missing'') as ContractNumber, Convert(varchar(10), cm.datEntered, 120), ' + char(10) +        
           '       Convert(varchar(10), qf.datReturned, 120) as datReturned, Count(*) ' + char(10) +        
           'FROM Comments cm, QuestionForm qf, SamplePop sp, SampleSet ss, Survey_Def sd ' + char(10) +        
           'WHERE cm.QuestionForm_id = qf.QuestionForm_id ' + char(10) +        
           '  AND qf.SamplePop_id = sp.SamplePop_id ' + char(10) +        
           '  AND sp.SampleSet_id = ss.SampleSet_id ' + char(10) +        
           '  AND sd.Survey_ID = ss.Survey_ID ' + char(10) +        
           '  AND Convert(varchar(10), cm.datEntered, 120) BETWEEN ''' + Convert(varchar(10), @StartDate, 120) + ''' AND ''' + Convert(varchar(10), @EndDate, 120) + ''' ' + char(10) +        
           '  AND ss.datSampleCreate_dt > ''01/01/2002''' + char(10) +         
           'GROUP BY isnull(sd.contract, ''Missing''), Convert(varchar(10), cm.datEntered, 120), Convert(varchar(10), qf.datReturned, 120) ' + char(10) +        
           'ORDER BY isnull(sd.contract, ''Missing''), Convert(varchar(10), cm.datEntered, 120), Convert(varchar(10), qf.datReturned, 120)'        
--print @sql    
exec(@SQL)        
        
--Determine the number of days between Entered and Returned        
UPDATE #ByDay        
SET intDays = Abs(DateDiff(Day, datEntered, datReturned))        
        
--print 'INSERT INTO #ContractNumber'      
--Get the distinct Project Numbers        
INSERT INTO #ContractNumber        
SELECT DISTINCT ContractNumber        
FROM #ByDay        
     
        
WHILE (SELECT Count(*) FROM #ContractNumber) > 0        
BEGIN        
    --Get the Project Number to be updated        
    SET @ContractNumber = (SELECT Top 1 ContractNumber FROM #ContractNumber ORDER BY ContractNumber)        
   
 --print '@ContractNumber = ' + cast(@ContractNumber as varchar(1000))  
    --Insert the record        
    INSERT INTO #Results (ContractNumber, intKeyed)        
    SELECT ContractNumber, Sum(intKeyed)        
    FROM #ByDay        
    WHERE ContractNumber = @ContractNumber        
    GROUP BY ContractNumber     
        
    --Update the count for same day        
    UPDATE #Results        
    SET intSame = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 0),         
        int1Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 1),         
        int2Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 2),         
        int3Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 3),         
        int4Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 4),        
        int5Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 5),         
        int6Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 6),         
        int7Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays = 7),         
        int8Day = (SELECT IsNull(Sum(intKeyed), 0) FROM #ByDay WHERE ContractNumber = @ContractNumber AND intDays > 7)        
    WHERE ContractNumber = @ContractNumber        
        
    --Delete the record from the looping table        
    DELETE FROM #ContractNumber WHERE ContractNumber = @ContractNumber        
END        
        
print 'INSERT INTO #Results'  
--Insert the record        
INSERT INTO #Results         
SELECT 'Total', Sum(intKeyed), Sum(intSame), Sum(int1Day), Sum(int2Day), Sum(int3Day), Sum(int4Day), Sum(int5Day), Sum(int6Day), Sum(int7Day), Sum(int8Day)        
FROM #Results        
        
SELECT ContractNumber, intKeyed as [Qty Keyed], intSame as [Same Day],         
       int1Day as [1 Day], int2Day as [2 Days], int3Day as [3 Days], int4Day as [4 Days],        
       int5Day as [5 Day], int6Day as [6 Days], int7Day as [7 Days], int8Day as [8 or More]        
        
FROM #Results        
        
drop table #ByDay        
Drop Table #ContractNumber        
drop table #Results        
        
set transaction isolation level read committed        
set nocount off


