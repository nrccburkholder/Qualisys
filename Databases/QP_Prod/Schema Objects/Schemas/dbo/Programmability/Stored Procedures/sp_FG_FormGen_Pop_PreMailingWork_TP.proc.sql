/*    
Modified 5/23/2 BD  Adding 6 hours to GETDATE to automatically pick up Surveys that are set to generate after midnight.      
Modified 8/15/2 BD  Added the ability to generate multiple Mailingsteps in the same night.    
Modified 7/3/3 BD  Remove duplicate Mailstep generations for the same person.  This can happen when the generation of    
 firsts are rolled back, but the second Mailstep is not deleted.      
Modified 1/20/04 SS -Adapted sp_FG_FormGen_Pop_PreMailingWork   
Mofified 8/27/04 SS - Added workcount check to see if some of the scheduled records are falling out of the join.  IF so we will insert into formgenerror_tp for the missing records.
*/    
CREATE  PROCEDURE sp_FG_FormGen_Pop_PreMailingWork_TP  
AS    
  
TRUNCATE TABLE FG_PreMailingWork_TP  
  
DECLARE @Study_id INT, @WorkCnt INT
DECLARE @sqlzip VARCHAR (250)    
DECLARE ZipCursor CURSOR FOR SELECT DISTINCT Study_id FROM FG_PreMailingWork_TP  

-- Count what there is to work on.
SELECT s.tp_id INTO #scheduledwork FROM scheduled_tp S LEFT JOIN FormGenError_TP F ON s.tp_id = f.tp_id WHERE S.bitDone = 0 and f.tp_id IS NULL
SELECT @WorkCnt = @@ROWCOUNT

-- First insert the already Scheduled Surveys    
INSERT INTO FG_PreMailingWork_TP (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, language, employee_id, bitMockup, strEmail )    
SELECT SM.Study_id, SM.Survey_id, SP.SamplePop_id, SM.SampleSet_id, SM.Pop_id, SM.TP_id, SM.MailingStep_id, SM.Methodology_id, SM.OverRideItem_id, SD.Priority_Flg, [language], employee_id, bitMockup, strEmail  
FROM   Survey_def SD(NOLOCK), Scheduled_TP SM(NOLOCK), MailingMethodology MM(NOLOCK), SamplePop SP(NOLOCK)    
WHERE   SM.bitDone = 0 AND -- SM.SentMail_id IS NULL AND  -- (MOD 1/20/04 SS)    
--     SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND   --(MOD 1/20/04 SS)  
--     SD.bitFormGenRelease = 1 AND       --(MOD 1/20/04 SS)  
	  SP.SampleSet_id=SM.Sampleset_id AND SP.study_id=SM.study_id AND SP.pop_id=SM.pop_id AND -- SP.SamplePop_id = SM.SamplePop_id AND         --(MOD 1/20/04 SS)  
       MM.Methodology_id = SM.Methodology_id AND    
       MM.Survey_id = SD.Survey_id AND
	  NOT EXISTS (SELECT TP_id FROM FormGenError_TP F WHERE SM.TP_ID = F.TP_ID)  --(MOD 8/27/04 SS)  

-- If the inserted doesn't match the workcnt then we have to error out some of the scheduled records because they failed the join (ie. rollback of sampleset)
IF @@ROWCOUNT <> @WorkCnt
	BEGIN
	INSERT INTO FormGenError_TP (TP_id, datGenerated, FGErrorType_id)
	SELECT w.tp_id, GETDATE(), 1 FROM #scheduledwork w LEFT JOIN FG_PreMailingWork_TP pw ON w.TP_ID = pw.ScheduledMailing_id WHERE pw.ScheduledMailing_id IS NULL
	DROP TABLE #scheduledwork
	END

-- 1/20/04 SS (NOT NEEDED)  
 --Now to get rid of duplicated Mailsteps for people    
 -- SELECT SamplePop_id, MailingStep_id, MAX(ScheduledMailing_id) ScheduledMailing_id    
 -- INTO #keep    
 -- FROM fg_preMailingWork    
 -- GROUP BY SamplePop_id, MailingStep_id    
    
 -- --Get the list of scheduledmailing_ids to delete    
 -- SELECT f.ScheduledMailing_id     
 -- INTO #del    
 -- FROM #keep t RIGHT OUTER JOIN fg_preMailingWork f    
 -- ON t.SamplePop_id = f.SamplePop_id    
 -- AND t.MailingStep_id = f.MailingStep_id    
 -- AND t.ScheduledMailing_id = f.ScheduledMailing_id    
 -- WHERE t.ScheduledMailing_id IS NULL    
 --     
 -- --Get rid of the fg_premailingwork records    
 -- DELETE f    
 -- FROM #del t, fg_preMailingWork f    
 -- where t.ScheduledMailing_id = f.ScheduledMailing_id    
 --     
 -- --Now to get rid of the scheduledmailing records    
 -- DELETE schm    
 -- FROM #del t, ScheduledMailing schm    
 -- where t.ScheduledMailing_id = schm.ScheduledMailing_id    
 --     
 -- --Clean up    
 -- DROP TABLE #del    
 -- DROP TABLE #keep    
    
  
-- 1/20/04 SS (NOT NEEDED)  
 -- --Determine additional Mailingsteps that need to generate    
 -- SELECT Study_id, f.Survey_id, SampleSet_id, Pop_id, Priority_flg, ms.MailingStep_id, SamplePop_id, f.Methodology_id, GETDATE() datgenerate    
 -- into #temp    
 -- FROM fg_preMailingWork f(NOLOCK), Mailingstep ms(NOLOCK)    
 -- WHERE f.MailingStep_id = ms.mmMailingStep_id    
 -- AND f.MailingStep_id <> ms.MailingStep_id    
 --     
 -- --Delete records already Scheduled    
 -- DELETE t    
 -- FROM #temp t, ScheduledMailing schm    
 -- WHERE t.MailingStep_id = schm.MailingStep_id    
 -- AND t.SamplePop_id = schm.SamplePop_id    
 --     
 -- --Schedule the additional Mailingsteps    
 -- INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, sentMail_id, Methodology_id, datgenerate)    
 -- SELECT MailingStep_id, SamplePop_id, NULL, NULL, Methodology_id, datgenerate    
 -- FROM #temp    
 --     
 -- --Insert the newly Scheduled Mailingsteps    
 -- INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg)    
 -- SELECT Study_id, Survey_id, t.SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, t.MailingStep_id, t.Methodology_id, OverRideItem_id, Priority_Flg    
 -- FROM   #temp t, ScheduledMailing schm(NOLOCK)    
 -- WHERE  t.MailingStep_id = schm.MailingStep_id    
 -- AND t.SamplePop_id = schm.SamplePop_id    
 -- AND schm.OverRideItem_id is NULL    
 --     
 -- DROP TABLE #temp    
  
  
--remove if blowup end    
--Update the zip code fields    
  
OPEN ZipCursor    
FETCH NEXT FROM ZipCursor INTO @Study_id    
WHILE @@FETCH_STATUS = 0    
 BEGIN    
  SET @SqlZip = 'UPDATE FG_PreMailingWork_TP set zip5 =  p.zip5, zip4 = p.zip4 ' + CHAR(10) +     
  ' FROM s' + CONVERT(VARCHAR(10),@Study_id) + '.Population p, FG_PreMailingWork_TP pm, SamplePop sp ' + CHAR(10) +     
  ' WHERE pm.Study_id = ' + CONVERT(VARCHAR(10),@Study_id) + CHAR(10) +    
  ' AND pm.SamplePop_id=sp.SamplePop_id ' + CHAR(10) +    
  ' AND sp.Pop_id = p.Pop_id'    
  EXEC (@SqlZip)    
  FETCH NEXT FROM ZipCursor INTO @Study_id    
 END    
CLOSE ZipCursor    
DEALLOCATE ZipCursor


