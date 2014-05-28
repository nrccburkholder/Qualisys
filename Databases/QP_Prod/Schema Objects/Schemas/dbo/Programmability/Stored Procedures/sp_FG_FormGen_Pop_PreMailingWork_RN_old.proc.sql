/*
Modified 5/23/2 BD  Adding 6 hours to GETDATE to automatically pick up surveys that are set to generate after midnight.  
Modified 8/15/2 BD  Added the ability to generate multiple mailingsteps in the same night.
Modified 7/3/3 BD  Remove duplicate Mailstep generations for the same person.  This can happen when the generation of
	firsts are rolled back, but the second Mailstep is not deleted.  
*/
CREATE PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork_RN_old] @Survey_id int
AS
TRUNCATE TABLE FG_PreMailingWork

DECLARE @study_id INT
DECLARE @sqlzip VARCHAR (250)
DECLARE ZipCursor CURSOR FOR SELECT DISTINCT study_id FROM FG_PreMailingWork

-- First insert the already scheduled surveys
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverrideItem_id, Priority_Flg)
SELECT SD.Study_id, SD.Survey_id, SP.SamplePop_id, SP.SampleSet_id, SP.Pop_id, SM.ScheduledMailing_id, SM.MailingStep_id, SM.Methodology_id, SM.OverrideItem_id, SD.Priority_Flg
FROM   Survey_def SD(NOLOCK), ScheduledMailing SM(NOLOCK), MailingMethodology MM(NOLOCK), SamplePop SP(NOLOCK)
WHERE  SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       SP.SamplePop_id = SM.SamplePop_id AND       
       MM.Methodology_id = SM.Methodology_id AND
       MM.Survey_id = SD.Survey_id AND
       SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError
	WHERE ScheduledMailing_id IS NOT NULL) AND
       SD.Survey_id = @Survey_id

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

--Determine additional mailingsteps that need to generate
SELECT study_id, f.survey_id, sampleset_id, pop_id, priority_flg, ms.mailingstep_id, samplepop_id, f.methodology_id, GETDATE() datgenerate
into #temp
FROM fg_premailingwork f(NOLOCK), mailingstep ms(NOLOCK)
WHERE f.mailingstep_id = ms.mmmailingstep_id
AND f.mailingstep_id <> ms.mailingstep_id

--Delete records already scheduled
DELETE t
FROM #temp t, scheduledmailing schm
WHERE t.mailingstep_id = schm.mailingstep_id
AND t.samplepop_id = schm.samplepop_id

--Schedule the additional mailingsteps
INSERT INTO scheduledmailing (mailingstep_id, samplepop_id, overrideitem_id, sentmail_id, methodology_id, datgenerate)
SELECT mailingstep_id, samplepop_id, null, null, methodology_id, datgenerate
FROM #temp

--Insert the newly scheduled mailingsteps
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverrideItem_id, Priority_Flg)
SELECT Study_id, Survey_id, t.SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, t.MailingStep_id, t.Methodology_id, OverrideItem_id, Priority_Flg
FROM   #temp t, scheduledmailing schm(NOLOCK)
WHERE  t.mailingstep_id = schm.mailingstep_id
AND t.samplepop_id = schm.samplepop_id
AND schm.overrideitem_id is null

DROP TABLE #temp
--remove if blowup end
--Update the zip code fields
open ZipCursor
FETCH NEXT FROM ZipCursor INTO @study_id
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @SqlZip = 'update FG_PreMailingWork set zip5 =  p.zip5, zip4 = p.zip4 ' + CHAR(10) + 
	' FROM s' + CONVERT(VARCHAR(10),@study_id) + '.population p, FG_PreMailingWork pm, samplepop sp ' + CHAR(10) + 
	' WHERE pm.study_id = ' + CONVERT(VARCHAR(10),@study_id) + CHAR(10) +
	' AND pm.samplepop_id=sp.samplepop_id ' + CHAR(10) +
	' AND sp.pop_id = p.pop_id'
 EXEC (@SqlZip)
 FETCH NEXT FROM ZipCursor INTO @study_id
END
CLOSE ZipCursor
DEALLOCATE ZipCursor


