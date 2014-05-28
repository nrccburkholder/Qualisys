CREATE PROCEDURE QP_Rep_DODBenDailyAddrChanges
	@Associate varchar(50),
	@Client varchar(50),
	@Study varchar(50),
	@Survey varchar(50)
AS
set transaction isolation level read uncommitted

SET NOCOUNT ON

--Declare the required variables
Declare @Survey_id int
Declare @Study_id int
Declare @sSql varchar(8000)
Declare @PreNote int
Declare @FirstSurvey int
Declare @PostCard int
Declare @SecondSurvey int
Declare @PNTotal int
Declare @FSTotal int
Declare @PCTotal int
Declare @SSTotal int


--Get the study_id and survey_id
SELECT @Survey_id = sd.Survey_id, @Study_id = st.Study_id 
FROM Survey_Def sd, Study st, Client cl
WHERE cl.strClient_Nm = @Client
  AND st.strStudy_Nm = @Study
  AND sd.strSurvey_Nm = @Survey
  AND cl.Client_id = st.Client_id
  AND st.Study_id = sd.Study_id


--Create temp table to identify which pop_ids where mailed which mailing steps
CREATE TABLE #PopIDs ( Pop_id int, 
                       PreNote bit default 0, 
                       FirstSurvey bit default 0, 
                       PostCard bit default 0, 
                       SecondSurvey bit default 0 )

--Insert all of the pop_ids
SET @sSql = 'INSERT INTO #PopIDs ( Pop_id ) ' +
            'SELECT Pop_id ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population'
EXEC (@sSql)

--Update with PreNote data
UPDATE pd 
SET PreNote = 1 
FROM #PopIDs pd, SamplePop sp, ScheduledMailing sc, MailingStep ms
WHERE pd.Pop_id = sp.Pop_id
  AND sp.Study_id = @Study_id
  AND sp.SamplePop_id = sc.SamplePop_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND ms.intSequence = 1

--Update with 1st survey data
UPDATE pd
SET FirstSurvey = 1
FROM #PopIDs pd, SamplePop sp, ScheduledMailing sc, MailingStep ms
WHERE pd.Pop_id = sp.Pop_id
  AND sp.Study_id = @Study_id
  AND sp.SamplePop_id = sc.SamplePop_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND ms.intSequence = 2

--Update with postcard data
UPDATE pd
SET PostCard = 1
FROM #PopIDs pd, SamplePop sp, ScheduledMailing sc, MailingStep ms
WHERE pd.Pop_id = sp.Pop_id
  AND sp.Study_id = @Study_id
  AND sp.SamplePop_id = sc.SamplePop_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND ms.intSequence = 3

--Update with 2nd survey data
UPDATE pd
SET SecondSurvey = 1
FROM #PopIDs pd, SamplePop sp, ScheduledMailing sc, MailingStep ms
WHERE pd.Pop_id = sp.Pop_id
  AND sp.Study_id = @Study_id
  AND sp.SamplePop_id = sc.SamplePop_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND ms.intSequence = 4


--Create PreNote table
CREATE TABLE #PreNote ( Region varchar(10), 
                        RoomNum varchar(10), 
                        AddrUsed varchar(10), 
                        Quantity int )

--Get raw PreNote data
SET @sSql = 'INSERT INTO #PreNote ( Region, RoomNum, Quantity ) ' +
            'SELECT Region, RoomNum, Count(*) ' +
            'FROM #PopIDs pd, s' + convert(varchar, @Study_id) + '.Population po ' +
            'WHERE pd.Pop_id = po.Pop_id ' +
            '  AND pd.PreNote = 1 ' +
            'GROUP BY Region, RoomNum'
EXEC (@sSql)

--Determine address used
UPDATE #PreNote SET AddrUsed = RoomNum
UPDATE #PreNote SET AddrUsed = 5 WHERE Region = 1

/*
PRINT 'PreNote Raw Data'
SELECT * FROM #PreNote
SELECT AddrUsed, Sum(Quantity)
FROM #PreNote
GROUP BY AddrUsed
--*/


--Create FirstSurvey table
CREATE TABLE #FirstSurvey ( Region varchar(10), 
                            RoomNum varchar(10), 
                            PlanNum2 varchar(10), 
                            AddrUsed varchar(10), 
                            Quantity int )

--Get raw FirstSurvey data
SET @sSql = 'INSERT INTO #FirstSurvey ( Region, RoomNum, PlanNum2, Quantity ) ' +
            'SELECT Region, RoomNum, PlanNum2, Count(*) ' +
            'FROM #PopIDs pd, s' + convert(varchar, @Study_id) + '.Population po ' +
            'WHERE pd.Pop_id = po.Pop_id ' +
            '  AND pd.FirstSurvey = 1 ' +
            'GROUP BY Region, RoomNum, PlanNum2'
EXEC (@sSql)

--Determine address used
UPDATE #FirstSurvey SET AddrUsed = PlanNum2
UPDATE #FirstSurvey SET AddrUsed = RoomNum WHERE AddrUsed IS NULL
UPDATE #FirstSurvey SET AddrUsed = 5 WHERE Region = 1 AND RoomNum = AddrUsed

/*
PRINT 'FirstSurvey Raw Data'
SELECT * FROM #FirstSurvey
SELECT AddrUsed, Sum(Quantity)
FROM #FirstSurvey
GROUP BY AddrUsed
--*/


--Create PostCard table
CREATE TABLE #PostCard ( Region varchar(10), 
                         RoomNum varchar(10), 
                         PlanNum2 varchar(10), 
                         AddrUsed varchar(10), 
                         Quantity int )

--Get raw PostCard data
SET @sSql = 'INSERT INTO #PostCard ( Region, RoomNum, PlanNum2, Quantity ) ' +
            'SELECT Region, RoomNum, PlanNum2, Count(*) ' +
            'FROM #PopIDs pd, s' + convert(varchar, @Study_id) + '.Population po ' +
            'WHERE pd.Pop_id = po.Pop_id ' +
            '  AND pd.PostCard = 1 ' +
            'GROUP BY Region, RoomNum, PlanNum2'
EXEC (@sSql)

--Determine address used
UPDATE #PostCard SET AddrUsed = PlanNum2
UPDATE #PostCard SET AddrUsed = RoomNum WHERE AddrUsed IS NULL
UPDATE #PostCard SET AddrUsed = 5 WHERE Region = 1 AND RoomNum = AddrUsed

/*
PRINT 'PostCard Raw Data'
SELECT * FROM #PostCard
SELECT AddrUsed, Sum(Quantity)
FROM #PostCard
GROUP BY AddrUsed
--*/


--Create SecondSurvey table
CREATE TABLE #SecondSurvey ( Region varchar(10), 
                             RoomNum varchar(10), 
                             PlanNum2 varchar(10), 
                             PlanNum3 varchar(10), 
                             AddrUsed varchar(10), 
                             Quantity int )

--Get raw SecondSurvey data
SET @sSql = 'INSERT INTO #SecondSurvey ( Region, RoomNum, PlanNum2, PlanNum3, Quantity ) ' +
            'SELECT Region, RoomNum, PlanNum2, PlanNum3, Count(*) ' +
            'FROM #PopIDs pd, s' + convert(varchar, @Study_id) + '.Population po ' +
            'WHERE pd.Pop_id = po.Pop_id ' +
            '  AND pd.SecondSurvey = 1 ' +
            'GROUP BY Region, RoomNum, PlanNum2, PlanNum3'
EXEC (@sSql)

--Determine address used
UPDATE #SecondSurvey SET AddrUsed = PlanNum3
UPDATE #SecondSurvey SET AddrUsed = PlanNum2 WHERE AddrUsed IS NULL
UPDATE #SecondSurvey SET AddrUsed = RoomNum WHERE AddrUsed IS NULL
UPDATE #SecondSurvey SET AddrUsed = 5 WHERE Region = 1 AND RoomNum = AddrUsed

/*
PRINT 'SecondSurvey Raw Data'
SELECT * FROM #SecondSurvey
SELECT AddrUsed, Sum(Quantity)
FROM #SecondSurvey
GROUP BY AddrUsed
--*/


--Create the report data table
CREATE TABLE #RepData ( Sorting int identity, 
                        Title varchar(40), 
                        PreNote int default 0, 
                        FirstSurvey int default 0,
                        PostCard int default 0, 
                        SecondSurvey int default 0 )

--Get the Address 1 data
SET @PreNote = (SELECT Sum(Quantity) FROM #PreNote WHERE AddrUsed = 1)
SET @FirstSurvey = (SELECT Sum(Quantity) FROM #FirstSurvey WHERE AddrUsed = 1)
SET @PostCard = (SELECT Sum(Quantity) FROM #PostCard WHERE AddrUsed = 1)
SET @SecondSurvey = (SELECT Sum(Quantity) FROM #SecondSurvey WHERE AddrUsed = 1)

SET @PNTotal = @PNTotal + @PreNote
SET @FSTotal = @FSTotal + @FirstSurvey
SET @PCTotal = @PCTotal + @PostCard
SET @SSTotal = @SSTotal + @SecondSurvey

INSERT INTO #RepData ( Title, PreNote, FirstSurvey, PostCard, SecondSurvey )
VALUES ( 'Beneficiary Address', @PreNote, @FirstSurvey, @PostCard, @SecondSurvey )

--Get the NCOA data
SET @PreNote = (SELECT Sum(Quantity) FROM #PreNote WHERE AddrUsed = 5)
SET @FirstSurvey = (SELECT Sum(Quantity) FROM #FirstSurvey WHERE AddrUsed = 5)
SET @PostCard = (SELECT Sum(Quantity) FROM #PostCard WHERE AddrUsed = 5)
SET @SecondSurvey = (SELECT Sum(Quantity) FROM #SecondSurvey WHERE AddrUsed = 5)

SET @PNTotal = @PNTotal + @PreNote
SET @FSTotal = @FSTotal + @FirstSurvey
SET @PCTotal = @PCTotal + @PostCard
SET @SSTotal = @SSTotal + @SecondSurvey

INSERT INTO #RepData ( Title, PreNote, FirstSurvey, PostCard, SecondSurvey )
VALUES ( 'New Address from NCOA', @PreNote, @FirstSurvey, @PostCard, @SecondSurvey )

--Get the Address 2 data
SET @PreNote = (SELECT Sum(Quantity) FROM #PreNote WHERE AddrUsed = 2)
SET @FirstSurvey = (SELECT Sum(Quantity) FROM #FirstSurvey WHERE AddrUsed = 2)
SET @PostCard = (SELECT Sum(Quantity) FROM #PostCard WHERE AddrUsed = 2)
SET @SecondSurvey = (SELECT Sum(Quantity) FROM #SecondSurvey WHERE AddrUsed = 2)

SET @PNTotal = @PNTotal + @PreNote
SET @FSTotal = @FSTotal + @FirstSurvey
SET @PCTotal = @PCTotal + @PostCard
SET @SSTotal = @SSTotal + @SecondSurvey

INSERT INTO #RepData ( Title, PreNote, FirstSurvey, PostCard, SecondSurvey )
VALUES ( 'Sponsor Address', @PreNote, @FirstSurvey, @PostCard, @SecondSurvey )

--Get the Address 3 data
SET @PreNote = (SELECT Sum(Quantity) FROM #PreNote WHERE AddrUsed = 3)
SET @FirstSurvey = (SELECT Sum(Quantity) FROM #FirstSurvey WHERE AddrUsed = 3)
SET @PostCard = (SELECT Sum(Quantity) FROM #PostCard WHERE AddrUsed = 3)
SET @SecondSurvey = (SELECT Sum(Quantity) FROM #SecondSurvey WHERE AddrUsed = 3)

SET @PNTotal = @PNTotal + @PreNote
SET @FSTotal = @FSTotal + @FirstSurvey
SET @PCTotal = @PCTotal + @PostCard
SET @SSTotal = @SSTotal + @SecondSurvey

INSERT INTO #RepData ( Title, PreNote, FirstSurvey, PostCard, SecondSurvey )
VALUES ( 'Unit Address', @PreNote, @FirstSurvey, @PostCard, @SecondSurvey )

--Get the New Address data
SET @PreNote = (SELECT Sum(Quantity) FROM #PreNote WHERE AddrUsed = 4)
SET @FirstSurvey = (SELECT Sum(Quantity) FROM #FirstSurvey WHERE AddrUsed = 4)
SET @PostCard = (SELECT Sum(Quantity) FROM #PostCard WHERE AddrUsed = 4)
SET @SecondSurvey = (SELECT Sum(Quantity) FROM #SecondSurvey WHERE AddrUsed = 4)

SET @PNTotal = @PNTotal + @PreNote
SET @FSTotal = @FSTotal + @FirstSurvey
SET @PCTotal = @PCTotal + @PostCard
SET @SSTotal = @SSTotal + @SecondSurvey

INSERT INTO #RepData ( Title, PreNote, FirstSurvey, PostCard, SecondSurvey )
VALUES ( 'New Address from Beneficiary', @PreNote, @FirstSurvey, @PostCard, @SecondSurvey )


-- Get the report data resultset
SELECT Title AS [Address Used in Mailing Steps], PreNote AS Prenote, 
       FirstSurvey AS [1st Survey], PostCard AS [Post Card],
       SecondSurvey AS [2nd Survey]
FROM #RepData
ORDER BY Sorting


--Cleanup
DROP TABLE #PopIDs
DROP TABLE #PreNote
DROP TABLE #FirstSurvey
DROP TABLE #PostCard
DROP TABLE #SecondSurvey
DROP TABLE #RepData

SET NOCOUNT OFF

set transaction isolation level read committed


