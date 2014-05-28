/*
Modified 5/23/2 BD  Adding 6 hours to GETDATE to automatically pick up Surveys that are set to generate after midnight.  
Modified 8/15/2 BD  Added the ability to generate multiple Mailingsteps in the same night.
Modified 7/3/3 BD  Remove duplicate Mailstep generations for the same person.  This can happen when the generation of
	firsts are rolled back, but the second Mailstep is not deleted.  
*/
CREATE PROCEDURE sp_FG_FormGen_Pop_PreMailingWork
AS
TRUNCATE TABLE FG_PreMailingWork

DECLARE @Study_id INT
DECLARE @sqlzip VARCHAR (250)
DECLARE ZipCursor CURSOR FOR SELECT DISTINCT Study_id FROM FG_PreMailingWork

-- First insert the already Scheduled Surveys
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg)
SELECT SD.Study_id, SD.Survey_id, SP.SamplePop_id, SP.SampleSet_id, SP.Pop_id, SM.ScheduledMailing_id, SM.MailingStep_id, SM.Methodology_id, SM.OverRideItem_id, SD.Priority_Flg
FROM   Survey_def SD(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK), SamplePop SP(NOLOCK)
WHERE  SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       SP.SamplePop_id = SM.SamplePop_id AND       
       MM.Methodology_id = SM.Methodology_id AND
       MM.Survey_id = SD.Survey_id AND
       SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError
	WHERE ScheduledMailing_id IS NOT NULL)

--Now to get rid of duplicated Mailsteps for people
SELECT SamplePop_id, MailingStep_id, MAX(ScheduledMailing_id) ScheduledMailing_id
INTO #keep
FROM fg_preMailingWork
GROUP BY SamplePop_id, MailingStep_id

--Get the list of scheduledmailing_ids to delete
SELECT f.ScheduledMailing_id 
INTO #del
FROM #keep t RIGHT OUTER JOIN fg_preMailingWork f
ON t.SamplePop_id = f.SamplePop_id
AND t.MailingStep_id = f.MailingStep_id
AND t.ScheduledMailing_id = f.ScheduledMailing_id
WHERE t.ScheduledMailing_id IS NULL

--Get rid of the fg_premailingwork records
DELETE f
FROM #del t, fg_preMailingWork f
where t.ScheduledMailing_id = f.ScheduledMailing_id

--Now to get rid of the scheduledmailing records
DELETE schm
FROM #del t, ScheduledMailing schm
where t.ScheduledMailing_id = schm.ScheduledMailing_id

--Clean up
DROP TABLE #del
DROP TABLE #keep

--Determine additional Mailingsteps that need to generate
SELECT Study_id, f.Survey_id, SampleSet_id, Pop_id, Priority_flg, ms.MailingStep_id, SamplePop_id, f.Methodology_id, GETDATE() datgenerate
into #temp
FROM fg_preMailingWork f(NOLOCK), Mailingstep ms(NOLOCK)
WHERE f.MailingStep_id = ms.mmMailingStep_id
AND f.MailingStep_id <> ms.MailingStep_id

--Delete records already Scheduled
DELETE t
FROM #temp t, ScheduledMailing schm
WHERE t.MailingStep_id = schm.MailingStep_id
AND t.SamplePop_id = schm.SamplePop_id

--Schedule the additional Mailingsteps
INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, sentMail_id, Methodology_id, datgenerate)
SELECT MailingStep_id, SamplePop_id, NULL, NULL, Methodology_id, datgenerate
FROM #temp

--Insert the newly Scheduled Mailingsteps
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg)
SELECT Study_id, Survey_id, t.SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, t.MailingStep_id, t.Methodology_id, OverRideItem_id, Priority_Flg
FROM   #temp t, ScheduledMailing schm(NOLOCK)
WHERE  t.MailingStep_id = schm.MailingStep_id
AND t.SamplePop_id = schm.SamplePop_id
AND schm.OverRideItem_id is NULL

DROP TABLE #temp
--remove if blowup end
--Update the zip code fields
OPEN ZipCursor
FETCH NEXT FROM ZipCursor INTO @Study_id
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @SqlZip = 'UPDATE FG_PreMailingWork set zip5 =  p.zip5, zip4 = p.zip4 ' + CHAR(10) + 
	' FROM s' + CONVERT(VARCHAR(10),@Study_id) + '.Population p, FG_PreMailingWork pm, SamplePop sp ' + CHAR(10) + 
	' WHERE pm.Study_id = ' + CONVERT(VARCHAR(10),@Study_id) + CHAR(10) +
	' AND pm.SamplePop_id=sp.SamplePop_id ' + CHAR(10) +
	' AND sp.Pop_id = p.Pop_id'
 EXEC (@SqlZip)
 FETCH NEXT FROM ZipCursor INTO @Study_id
END
CLOSE ZipCursor
DEALLOCATE ZipCursor


