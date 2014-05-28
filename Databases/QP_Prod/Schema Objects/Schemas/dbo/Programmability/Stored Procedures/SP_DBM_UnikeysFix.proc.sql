/*
CREATED 5/8/2003 BD
	Sampling sometimes does not insert all needed records into Unikeys.  This
	procedure will automatically add them in.  This is intented to run as the 
	last step of the formgen job.

*/

CREATE PROCEDURE SP_DBM_UnikeysFix
AS

--Get of list of the people who are missing unikeys records
SELECT fge.ScheduledMailing_id, sp.SamplePop_id, Study_id
INTO #UniKeys
FROM FormGenError fge, ScheduledMailing schm, SamplePop sp
WHERE fge.fgerrortype_id = 36
AND fge.ScheduledMailing_id = schm.ScheduledMailing_id
AND schm.SamplePop_id = sp.SamplePop_id

CREATE TABLE #Insert (SampleSet_id INT, Pop_id INT, Table_id INT, KeyValue INT)
CREATE TABLE #SampleUnit (SampleUnit_id INT)

DECLARE @sql VARCHAR(2000), @Study INT, @SamplePop_id INT, @SampleUnit_id INT, @SampleSet_id INT, @Pop_id INT

SELECT TOP 1 @SamplePop_id = SamplePop_id FROM #UniKeys

--loop through the people
WHILE @@ROWCOUNT > 0
BEGIN

TRUNCATE TABLE #SampleUnit
TRUNCATE TABLE #Insert

--Determine the Study_id for the current SamplePop
SELECT @Study = Study_id 
FROM #UniKeys 
WHERE SamplePop_id = @SamplePop_id

--insert the units that are missing unikeys records.
--At this point, all occurrances of this have been 
-- in studies with encounter tables.
INSERT INTO #SampleUnit 
SELECT SampleUnit_id 
FROM SelectedSample ss, SamplePop sp 
WHERE sp.SamplePop_id = @SamplePop_id
AND sp.SampleSet_id = ss.SampleSet_id
AND sp.Pop_id = ss.Pop_id
AND Enc_id IS NULL

IF @@ROWCOUNT=0
GOTO Ending

--get the SampleUnit, SampleSet, pop values for the lowest SampleUnit_id 
-- to have unikeys records for the current SamplePop.  Needed for the 
-- next query
SELECT TOP 1 @SampleUnit_id = SampleUnit_id, @SampleSet_id = ss.SampleSet_id, @Pop_id = ss.Pop_id 
FROM SelectedSample ss, SamplePop sp 
WHERE sp.SamplePop_id = @SamplePop_id
AND sp.SampleSet_id = ss.SampleSet_id
AND sp.Pop_id = ss.Pop_id
AND Enc_id IS NOT NULL
ORDER BY SampleUnit_id

--insert the values for the SampleUnit selected in the previous query.
--These values will be inserted for the missing records
SET @sql = 'INSERT INTO #Insert SELECT SampleSet_id, Pop_id, Table_id, KeyValue ' + CHAR(10) +
	' FROM S'+CONVERT(VARCHAR,@Study)+'.UniKeys ' + CHAR(10) +
	' WHERE SampleSet_id = '+CONVERT(VARCHAR,@SampleSet_id) + CHAR(10) +
	' AND Pop_id = '+CONVERT(VARCHAR,@Pop_id) + CHAR(10) +
	' AND SampleUnit_id = '+CONVERT(VARCHAR,@SampleUnit_id) + CHAR(10) 

EXEC (@sql)

--Actual insert into the Study's unikeys table.
--Cartesian join to populate all needed records.
SET @sql = 'INSERT INTO S'+CONVERT(VARCHAR,@Study)+'.UniKeys ' + CHAR(10) +
	' SELECT SampleSet_id, SampleUnit_id, Pop_id, Table_id, KeyValue ' + CHAR(10) +
	' FROM #SampleUnit su, #Insert i ' + CHAR(10) 

EXEC (@sql)

--Just returning the inserted values for verification
SELECT SampleSet_id, SampleUnit_id, Pop_id, Table_id, KeyValue 
FROM #SampleUnit su, #Insert i 

--This procedure will populate the enc_id field in SelectedSample for the SampleSet
EXEC SP_Samp_SelectedSampleEncid @SampleSet_id

--get rid of the error
DELETE fge
FROM FormGenError fge, ScheduledMailing schm
WHERE fge.FGErrorType_id = 36
AND fge.ScheduledMailing_id = schm.ScheduledMailing_id
AND SamplePop_id = @SamplePop_id

Ending:

--get rid of the SamplePop from the temp table
DELETE #UniKeys WHERE SamplePop_id = @SamplePop_id

--get the next SamplePop
SELECT TOP 1 @SamplePop_id = SamplePop_id FROM #UniKeys

END

--cleanup
DROP TABLE #SampleUnit
DROP TABLE #UniKeys
DROP TABLE #Insert


