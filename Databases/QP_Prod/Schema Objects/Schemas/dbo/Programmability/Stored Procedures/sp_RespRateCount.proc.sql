/*
MODIFIED 3/17/3  BD  Moved the delete to occur just before the inserts.  Also moved the deletes AND insertion INTO a transaction so we 
can avoid having missing records in the table.
*/
CREATE PROCEDURE sp_RespRateCount 
AS

--This has been moved to right before we do the insert of the updated records.
--delete RespRateCount FROM RespRateCount rr, sampleset ss WHERE rr.sampleset_id = ss.sampleset_id AND (datlastmailed > DATEADD(MONTH,-4,GETDATE()) or datlastmailed is null )

--Identify the samplesets to refresh
SELECT sampleset_id
INTO #all
FROM sampleset (NOLOCK)
WHERE (datlastmailed > DATEADD(MONTH,-4,GETDATE()) or datlastmailed IS NULL )

--Build a temp table to compile the numbers
CREATE TABLE #SelSampUnit 
(survey_id INT, sampleset_id INT, datsamplecreate_dt DATETIME, sampleunit_id INT, samplepop_id INT, tiUD INT, tiReturned INT)

--insert a record for each person
INSERT INTO #selsampunit
SELECT DISTINCT survey_id, ss.sampleset_id, datsamplecreate_dt, sampleunit_id, sp.samplepop_id, 0,0
FROM sampleset sset (NOLOCK), samplepop sp (NOLOCK), selectedsample ss (NOLOCK), scheduledmailing schm (NOLOCK), sentmailing sm (NOLOCK)
WHERE sset.sampleset_id in (SELECT sampleset_id FROM #all)
AND sset.sampleset_id = sp.sampleset_id
AND sset.sampleset_id = ss.sampleset_id
AND ss.strunitselecttype = 'D'
AND sp.sampleset_id = ss.sampleset_id
AND sp.pop_id = ss.pop_id
AND sp.samplepop_id = schm.samplepop_id
AND schm.sentmail_id = sm.sentmail_id
AND sm.datmailed > '1/1/1900'

--Mark the returns
UPDATE #SelSampUnit
SET tiReturned=1
FROM QuestionForm QF
WHERE #SelSampUnit.Samplepop_id=QF.samplepop_id
  AND QF.datreturned < GETDATE()

--mark the undeliverables
UPDATE #SelSampUnit
SET tiUD=1
FROM SentMailing sm(NOLOCK), ScheduledMailing sc(NOLOCK)
WHERE #SelSampUnit.tiReturned=0 
  AND #SelSampUnit.Samplepop_id=SC.samplepop_id
  AND SC.sentmail_id=SM.sentmail_id 
  AND sm.datundeliverable < GETDATE()

--Do the next steps in a tran so we do not end up just removing records
BEGIN TRAN

--delete the records FROM the responserate table that we will be refreshing  
DELETE rr
FROM RespRateCount rr, #selsampunit t
WHERE t.sampleset_id = rr.sampleset_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN 
	RETURN
END

--Add the new/refreshed records
INSERT INTO RespRateCount (survey_id, sampleset_id, datsamplecreate_dt, sampleunit_id,intSampled,intUD,intReturned)
  SELECT survey_id,sampleset_id, datsamplecreate_dt, sampleunit_id,COUNT(DISTINCT samplepop_id),SUM(tiUD),SUM(tiReturned)
  FROM #SelSampUnit
  GROUP BY survey_id,sampleset_id,sampleunit_id, datsamplecreate_dt

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN 
	RETURN
END

--Now need to get the overall sampleset COUNTs
SELECT DISTINCT survey_id, sampleset_id, datsamplecreate_dt, samplepop_id, tiUD, tiReturned 
INTO #SelSampPop
FROM #SelSampUnit

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN 
	RETURN
END

--insert the overall sampleset COUNTs.  Signified by sampleunit_id = 0
INSERT INTO RespRateCount (survey_id, sampleset_id, datsamplecreate_dt, sampleunit_id,intSampled,intUD,intReturned)
  SELECT survey_id,sampleset_id, datsamplecreate_dt, 0,COUNT(DISTINCT samplepop_id),SUM(tiUD),SUM(tiReturned)
  FROM #SelSampPop
  GROUP BY survey_id,sampleset_id, datsamplecreate_dt

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN 
	RETURN
END

--Insert a tracking date 
INSERT INTO RR_DATE (rrrundate) SELECT GETDATE()

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN 
	RETURN
END

COMMIT TRAN

--Cleanup
DROP TABLE #SelSampUnit
DROP TABLE #SelSampPop
DROP TABLE #all

--Remove samples that have been rolledback
SELECT DISTINCT sampleset_id
INTO #resprate
FROM respratecount

BEGIN TRAN

DELETE t
FROM #resprate t LEFT OUTER JOIN sampleset ss
ON t.sampleset_id = ss.sampleset_id
WHERE ss.sampleset_id IS NOT NULL

DELETE respratecount
WHERE sampleset_id IN (SELECT sampleset_id FROM #resprate)

COMMIT TRAN

DROP TABLE #resprate

--The rest sets the datlastmailed column in sampleset.  This can be used to speed up the calculations of 
-- response rates by sampling.
CREATE TABLE #sampleset_status
(sampleset_id INT, bitcomplete BIT)

--Get the samplesets that are older than 2 weeks and currently have a datlastmailed value of null
INSERT INTO #sampleset_status
SELECT DISTINCT ss.sampleset_id, 1
FROM sampleset ss(NOLOCK), samplepop sp(NOLOCK), scheduledmailing schm(NOLOCK)
WHERE datlastmailed IS NULL
AND ss.sampleset_id = sp.sampleset_id
AND sp.samplepop_id = schm.samplepop_id
AND DATEDIFF(DAY,datsamplecreate_dt, GETDATE()) > 14

--Determine if they have completed their mailing cycle
 UPDATE #SampleSet_Status
  SET bitComplete = 0
   FROM #SampleSet_Status SSS(NOLOCK), dbo.SamplePop SP(NOLOCK), 
    dbo.ScheduledMailing SchM(NOLOCK), dbo.MailingStep MS(NOLOCK)
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND SchM.SentMail_id IS NULL
    AND SchM.OverrideItem_id IS NULL
 CREATE TABLE #SampleSet_MailDate
  (SampleSet_id INT, datLastMailDate DATETIME)
-- Of the sample sets that do have generated all mailing items, identify the date the last non-Thank You item was sent 
 INSERT INTO #SampleSet_MailDate
  SELECT DISTINCT SSS.SampleSet_id, SM.datMailed
   FROM #SampleSet_Status SSS(NOLOCK), dbo.SamplePop SP(NOLOCK), dbo.ScheduledMailing SchM(NOLOCK), 
     dbo.SentMailing SM(NOLOCK), dbo.MailingStep MS(NOLOCK)
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.SentMail_id = SM.SentMail_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND SchM.OverrideItem_id IS NULL

    AND SSS.bitComplete = 1

DELETE #sampleset_maildate
WHERE sampleset_id in (
SELECT sampleset_id 
FROM #SampleSet_MailDate
WHERE datlastmaildate IS NULL)

 DROP TABLE #SampleSet_Status

 CREATE TABLE #SampleSet_MailDate2
  (SampleSet_id INT, datLastMailDate DATETIME)

INSERT INTO #sampleset_maildate2
SELECT sampleset_id, MAX(datlastmaildate)
FROM #sampleset_maildate
GROUP BY sampleset_id

--SELECT * FROM #sampleset_maildate2

UPDATE ss
SET datlastmailed = datlastmaildate
FROM sampleset ss(NOLOCK), #sampleset_maildate2 ssd
WHERE ss.sampleset_id = ssd.sampleset_id

DROP TABLE #sampleset_maildate
DROP TABLE #sampleset_maildate2


