CREATE PROCEDURE [dbo].[SP_Phase3_QuestionResult_For_Extract_by_Samplepop]
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

insert into drm_tracktimes select getdate(), 'Begin SP_Phase3_QuestionResult_For_Extract' 

--The Cmnt_QuestionResult_work table should be able to be removed. 
TRUNCATE TABLE Cmnt_QuestionResult_work 
TRUNCATE TABLE Extract_Web_QuestionForm 

insert into drm_tracktimes select getdate(), 'H get hcahps records and index' 

--Get the records that are HCAHPS so we can compute completeness 
SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete 
INTO #a 
FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd 
WHERE e.Study_id IS NOT NULL 
AND e.tiExtracted=0 
AND datExtracted_dt IS NULL 
AND e.QuestionForm_id=qf.Questionform_id 
AND qf.Survey_id=sd.Survey_id 
AND SurveyType_id=2 
GROUP BY e.QuestionForm_id 

CREATE INDEX tmpIndex ON #a (QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'H update tmp table with function call' 

UPDATE #a SET Complete=dbo.HCAHPSCompleteness(QuestionForm_id) 


insert into drm_tracktimes select getdate(), 'H update questionform' 

UPDATE qf 
SET bitComplete=Complete 
FROM QuestionForm qf, #a t 
WHERE t.QuestionForm_id=qf.QuestionForm_id 


DROP TABLE #a 

--END: Get the records that are HCAHPS so we can compute completeness 

insert into drm_tracktimes select getdate(), 'HH get hcahps records and index' 

--Get the records that are HHCAHPS so we can compute completeness 
--SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1
--INTO #HHQF
--FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd 
--WHERE e.Study_id IS NOT NULL 
--AND e.tiExtracted=0 
--AND datExtracted_dt IS NULL 
--AND e.QuestionForm_id=qf.Questionform_id 
--AND qf.Survey_id=sd.Survey_id 
--AND SurveyType_id=3 
--GROUP BY e.QuestionForm_id 

select e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1, ms.STRMAILINGSTEP_NM
	into #HHQF
	from QuestionForm_extract e
	inner join QuestionForm qf on e.QuestionForm_id = qf.QuestionForm_id 
	inner join survey_def sd on qf.survey_id=sd.survey_id
	inner join SENTMAILING sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
	inner join SCHEDULEDMAILING scm on scm.scheduledmailing_id = sm.scheduledmailing_id
	inner join MAILINGSTEP ms on ms.MAILINGSTEP_ID = scm.mailingstep_id
	where e.study_id IS NOT NULL 
           AND e.tiextracted = 0
		   AND sd.surveytype_id=3
	GROUP  BY e.QuestionForm_id, ms.STRMAILINGSTEP_NM

CREATE INDEX tmpIndex ON #HHQF (QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'HH update tmp table with procedure call' 

--UPDATE #HHQF SET Complete=dbo.HHCAHPSCompleteness(QuestionForm_id) 
exec dbo.HHCAHPSCompleteness

insert into drm_tracktimes select getdate(), 'HH update questionform' 

UPDATE qf 
SET bitComplete=Complete 
FROM QuestionForm qf, #HHQF t 
WHERE t.QuestionForm_id=qf.QuestionForm_id 

--DROP TABLE #HHQF --> we're using this later, so don't drop it yet.
--END: Get the records that are HHCAHPS so we can compute completeness 

insert into drm_tracktimes select getdate(), 'MNCM get hcahps records and index' 

--Get the records that are MNCM so we can compute completeness 
SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete 
INTO #c 
FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd 
WHERE e.Study_id IS NOT NULL 
AND e.tiExtracted=0 
AND datExtracted_dt IS NULL 
AND e.QuestionForm_id=qf.Questionform_id 
AND qf.Survey_id=sd.Survey_id 
AND SurveyType_id=4 
GROUP BY e.QuestionForm_id 

--*******************************************************************  
--**  DRM 12/30/2012  Temp hack to allow hcahps only  
--*******************************************************************  
--delete #c  
--*******************************************************************  
--**  end hack  
--*******************************************************************  


CREATE INDEX tmpIndex ON #c (QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'MNCM update tmp table with function call' 

UPDATE #c SET Complete=dbo.MNCMCompleteness(QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'MNCM update questionform' 

UPDATE qf 
SET bitComplete=Complete 
FROM QuestionForm qf, #c t 
WHERE t.QuestionForm_id=qf.QuestionForm_id 

DROP TABLE #c 
--END: Get the records that are MNCM so we can compute completeness 

insert into drm_tracktimes select getdate(), 'populate Cmnt_QuestionResult_Work' 

INSERT INTO Cmnt_QuestionResult_Work (QuestionForm_id, strLithoCode, SamplePop_id, Val, 
SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, qf.Survey_id, 
ReceiptType_ID, SurveyType_ID, bitComplete) 
SELECT qf.QuestionForm_id, strLithoCode, qf.SamplePop_id, intResponseVal, SampleUnit_id, 
QstnCore, datMailed, datResultsImported, qfe.Study_id, datGenerated, qf.Survey_id, 
isnull(qf.ReceiptType_ID, 17), sd.SurveyType_id, qf.bitComplete 
FROM (SELECT DISTINCT QuestionForm_id, Study_id 
FROM QuestionForm_Extract 
WHERE Study_id IS NOT NULL 
AND tiExtracted=0 
AND datExtracted_dt IS NULL) qfe, 
QuestionForm qf, SentMailing sm, QuestionResult qr, SURVEY_DEF sd 
WHERE qfe.QuestionForm_id=qf.QuestionForm_id 
AND qf.QuestionForm_id=qr.QuestionForm_id 
AND qf.SentMail_id=sm.SentMail_id 
AND qf.SURVEY_ID = sd.SURVEY_ID 
and SAMPLEPOP_ID in (select samplepop_id from samplepops_to_manually_extract)
--*******************************************************************  
--**  DRM 12/30/2012  Temp hack to allow hcahps only  
--*******************************************************************  
--and sd.SurveyType_id=2  
--*******************************************************************  
--**  end hack  
--*******************************************************************  

insert into drm_tracktimes select getdate(), 'populate Extract_Web_QuestionForm' 

--*******************************************************************  
--**  DRM 12/30/2012  Temp hack to allow hcahps only  
--*******************************************************************  

INSERT INTO Extract_Web_QuestionForm (Study_id, Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id, 
strLithoCode, Sampleset_id, datreturned, bitComplete, strUnitSelectType, LangID, receiptType_ID) 
SELECT sp.Study_id, qf.survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode, 
sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id 
FROM (SELECT DISTINCT QuestionForm_id, Study_id 
FROM Cmnt_QuestionResult_work) qfe, 
QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss 
WHERE qfe.QuestionForm_id=qf.QuestionForm_id 
AND qf.SentMail_id=sm.SentMail_id 
AND qf.SamplePop_id=sp.SamplePop_id 
AND sp.Sampleset_id=ss.Sampleset_id 
AND sp.Pop_id=ss.Pop_id 
and qf.SAMPLEPOP_ID in (select samplepop_id from samplepops_to_manually_extract)
--INSERT INTO Extract_Web_QuestionForm (sp.Study_id, qf.Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id,                   
-- strLithoCode, Sampleset_id, datreturned, bitComplete, strUnitSelectType, LangID, receiptType_ID)                  
--SELECT sp.Study_id, qf.survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode,                   
-- sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id                
--FROM (SELECT DISTINCT QuestionForm_id, Study_id                
--  FROM Cmnt_QuestionResult_work) qfe,                
-- QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss                  
--, survey_def sd  
--WHERE qfe.QuestionForm_id=qf.QuestionForm_id                   
--AND qf.SentMail_id=sm.SentMail_id                   
--AND qf.SamplePop_id=sp.SamplePop_id                  
--AND sp.Sampleset_id=ss.Sampleset_id                  
--AND sp.Pop_id=ss.Pop_id             
--and qf.survey_id = sd.survey_id     
--and sd.surveytype_id = 2  
--*******************************************************************  
--**  end hack  
--*******************************************************************  


insert into drm_tracktimes select getdate(), 'Calc days from first mailing' 

-- Add code to determine days from first mailing as well as days from current mailing until the return 
-- Get all of the maildates for the samplepops were are extracting 
SELECT e.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed 
INTO #Mail 
FROM (SELECT SamplePop_id FROM Extract_Web_QuestionForm GROUP BY SamplePop_id) e, ScheduledMailing schm, SentMailing sm 
WHERE e.SamplePop_id=schm.SamplePop_id 
AND schm.SentMail_id=sm.SentMail_id 

CREATE INDEX TempIndex ON #Mail (SamplePop_id, strLithoCode) 

-- Update the work table with the actual number of days 
UPDATE ewq 
SET DaysFromFirstMailing=DATEDIFF(DAY,FirstMail,datReturned), DaysFromCurrentMailing=DATEDIFF(DAY,c.datMailed,datReturned) 
FROM Extract_Web_QuestionForm ewq, 
(SELECT SamplePop_id, MIN(datMailed) FirstMail FROM #Mail GROUP BY SamplePop_id) t, #Mail c 
WHERE ewq.SamplePop_id=t.SamplePop_id 
AND ewq.SamplePop_id=c.SamplePop_id 
AND ewq.strLithoCode=c.strLithoCode 

-- Make sure there are no negative days. 
UPDATE Extract_Web_QuestionForm SET DaysFromFirstMailing=0 WHERE DaysFromFirstMailing<0 
UPDATE Extract_Web_QuestionForm SET DaysFromCurrentMailing=0 WHERE DaysFromCurrentMailing<0 

DROP TABLE #Mail 

-- Modification 7/28/04 SJS -- Replaced code for skip pattern recode so that nested skip patterns are handled correctly 
--SET NOCOUNT ON 

-- Modified 01/03/2013 DRH changed @work to #work plus index
--DECLARE @work TABLE (QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)                
CREATE TABLE #work (workident INT IDENTITY (1,1) CONSTRAINT PK_work_workident PRIMARY KEY, QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)          

DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT 
SET @bitUpdate = 1 

--Now to recode Skip pattern results 
--If we have a valid answer, we will add 10000 to the responsevalue 


insert into drm_tracktimes select getdate(), 'Skip patterns' 


-- Identify the first skip pattern that needs to be enforced for a questionform_id 
declare @rowcount int

-- Modified 01/03/2013 DRH changed @work to #work plus index
--INSERT INTO @work (QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id)                
INSERT INTO #work (QuestionForm_id, SampleUnit_id, Skip_id, Survey_id)                
SELECT QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id 
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND qr.Val=si.intResponseVal 
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
WHERE sd.bitEnforceSkip <> 0 
UNION 
SELECT QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id 
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si 
ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND qr.Val IN (-8,-9,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
WHERE sd.bitEnforceSkip <> 0 
UNION 
SELECT QuestionForm_id, SampleUnit_id, -1 Skip_id, q.Survey_id 
FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
WHERE qstncore = 38694 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 3 
UNION 
SELECT QuestionForm_id, SampleUnit_id, -2 Skip_id, q.Survey_id 
FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
WHERE qstncore = 38726 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 3 
-- Modified 01/03/2013 DRH changed @work to #work plus index
ORDER BY 1,2,3,4
CREATE INDEX tmpwork_index ON #work (QuestionForm_id, SampleUnit_id, Skip_id, Survey_id)                

select @rowcount = @@rowcount
print 'After insert into #work: '+cast(@rowcount as varchar)

/*************************************************************************************************/ 
--Assign Final dispositions for HCAHPS and HHCAHPS 

insert into drm_tracktimes select getdate(), 'Final dispositions' 

--HCAHPS DISPOSITIONS 
Update cqw 
set FinalDisposition = '01' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 2 and bitcomplete = 1 

Update cqw 
set FinalDisposition = '06' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 2 and bitcomplete = 0 

--HHCAHPS DISPOSITIONS 
-- if more than half of the ATA questions have been answered, bitComplete=1 and it's coded as a Complete
Update cqw 
set FinalDisposition = '110' -- Completed Mail Survey
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 3 and bitcomplete = 1 and ReceiptType_ID = 17 

Update cqw 
set FinalDisposition = '120' -- Completed Phone Interview
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 3 and bitcomplete = 1 and ReceiptType_ID = 12 


--SELECT q.questionform_id 
--into #HHCAHPS_InvalidDisposition 
--FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
--WHERE qstncore = 38694 AND 
--val <> 1 AND 
--sd.SURVEY_ID = q.Survey_id AND 
--sd.SurveyType_id = 3 and 
--bitcomplete = 0 

-- if incomplete and Q1=No and they didn't answer any other questions, they're ineligible
Update cqw 
set FinalDisposition = '220' -- Ineligible: Does not meet eligible Population criteria
from Cmnt_QuestionResult_Work cqw
inner join #HHQF hh on hh.questionform_Id = cqw.questionform_id 
where hh.q1 = 2
and hh.complete=0
and hh.numAnswersAfterQ1 = 0

--SELECT q.questionform_id 
--into #HHCAHPS_ValidDisposition 
--FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
--WHERE qstncore = 38694 AND 
--val = 1 AND 
--sd.SURVEY_ID = q.Survey_id AND 
--sd.SurveyType_id = 3 and 
--bitcomplete = 0 

-- if incomplete and Q1=Yes or they answered questions after Q1, it's a breakoff
Update cqw 
set FinalDisposition = '310' -- Breakoff
from Cmnt_QuestionResult_Work cqw
inner join #HHQF hh on hh.questionform_Id = cqw.questionform_id 
where hh.complete=0 
and (hh.numAnswersAfterQ1 > 0 or hh.Q1=1)

-- if incomplete and Q1 isn't answered and they didn't answer anything else either, it's just a blank survey.
--UPDATE cqw 
--SET FinalDisposition = '320' -- Refusal
--FROM cmnt_QuestionResult_work cqw 
--inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
--WHERE hh.complete=0
--AND hh.numAnswersAfterQ1=0 
--AND hh.Q1=-9
-- Modified 03/27/2015 TSB  to only look at 2ndSurvey
    UPDATE cqw 
    SET    FinalDisposition = '320' -- Refusal
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND hh.numAnswersAfterQ1=0 
           AND hh.Q1=-9
		   AND hh.STRMAILINGSTEP_NM = '2nd Survey'


--MNCM DISPOSITIONS 
Update cqw 
set FinalDisposition = '21' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 4 and bitcomplete = 0 and ReceiptType_ID = 17 

Update cqw 
set FinalDisposition = '22' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 4 and bitcomplete = 0 and ReceiptType_ID = 12 

Update cqw 
set FinalDisposition = '11' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 4 and bitcomplete = 1 and ReceiptType_ID = 17 

Update cqw 
set FinalDisposition = '12' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 4 and bitcomplete = 1 and ReceiptType_ID = 12 


SELECT q.questionform_id 
into #MNCM_NegRespScreenQstn 
FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
WHERE qstncore = 39113 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 4 and bitcomplete = 0 

Update cqw 
set FinalDisposition = '38' 
from Cmnt_QuestionResult_Work cqw, #MNCM_NegRespScreenQstn i 
where i.questionform_Id = cqw.questionform_id 
/*************************************************************************************************/ 

/************************************************************************************************/ 

insert into drm_tracktimes select getdate(), 'Find ineligible hcahps' 

--round up all the HHCHAPS Surveys that were not eligible (qstncore 38694 <> 1) and set an inelig. disposition. 
DECLARE @InEligDispo INT, @SQL varchar(8000) 
SELECT @InEligDispo = d.disposition_Id FROM DISPOSITION d, HHCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and hd.HHCAHPSValue = '220' 

--SELECT q.questionform_id 
--into #updateDisposition 
--FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
--WHERE qstncore = 38694 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 3 

Create Table #UpdateDispSQL (a int identity (1,1), strSQL varchar(8000)) 

--HCHAPS 
Insert into #UpdateDispSQL 
select distinct 'Exec QCL_LogDisposition ' + 
cast(scm.SENTMAIL_ID as varchar(100)) + ', ' + 
cast(scm.SAMPLEPOP_ID as varchar(100)) + ', ' + 
cast(dv.Disposition_id as varchar(100)) + ', ' + 
cast(qf.ReceiptType_id as varchar(100)) + ', ' + '''#nrcsql''' + ', ' + 
'''' + convert(varchar, GETDATE(), 120) + '''' as strSQL 
from cmnt_questionresult_work cqw, questionform qf, 
scheduledmailing scm, Dispositions_view dv 
where cqw.Questionform_ID = qf.QUESTIONFORM_ID and 
qf.SENTMAIL_ID = scm.SENTMAIL_ID and 
dv.HCAHPSValue = cqw.FinalDisposition and 
cqw.SurveyType_ID = 2 

--HHCAHPS 
Insert into #UpdateDispSQL (strSQL) 
select distinct 'Exec QCL_LogDisposition ' + 
cast(scm.SENTMAIL_ID as varchar(100)) + ', ' + 
cast(scm.SAMPLEPOP_ID as varchar(100)) + ', ' + 
cast(dv.Disposition_id as varchar(100)) + ', ' + 
cast(qf.ReceiptType_id as varchar(100)) + ', ' + '''#nrcsql''' + ', ' + 
'''' + convert(varchar, GETDATE(), 120) + '''' as strSQL 
from cmnt_questionresult_work cqw, questionform qf, 
scheduledmailing scm, Dispositions_view dv 
where cqw.Questionform_ID = qf.QUESTIONFORM_ID and 
qf.SENTMAIL_ID = scm.SENTMAIL_ID and 
dv.hHCAHPSValue = cqw.FinalDisposition and 
cqw.SurveyType_ID = 3 

--MNCM 
Insert into #UpdateDispSQL (strSQL) 
select distinct 'Exec QCL_LogDisposition ' + 
cast(scm.SENTMAIL_ID as varchar(100)) + ', ' + 
cast(scm.SAMPLEPOP_ID as varchar(100)) + ', ' + 
cast(dv.Disposition_id as varchar(100)) + ', ' + 
cast(qf.ReceiptType_id as varchar(100)) + ', ' + '''#nrcsql''' + ', ' + 
'''' + convert(varchar, GETDATE(), 120) + '''' as strSQL 
from cmnt_questionresult_work cqw, questionform qf, 
scheduledmailing scm, Dispositions_view dv 
where cqw.Questionform_ID = qf.QUESTIONFORM_ID and 
qf.SENTMAIL_ID = scm.SENTMAIL_ID and 
dv.MNCMValue = cqw.FinalDisposition and 
cqw.SurveyType_ID = 4 


While (select COUNT(*) from #UpdateDispSQL) > 0 
begin 
select top 1 @SQL = strSQL from #UpdateDispSQL 
exec (@SQL) 
delete from #UpdateDispSQL where strsql = @SQL 

end 

/************************************************************************************************/ 

insert into drm_tracktimes select getdate(), 'Update skip questions' 

declare @loopcnt int  
set @loopcnt = 0  

--Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
declare @invskipcnt int  
set @invskipcnt = 0  

-- Modified 01/03/2013 DRH changed @work to #work plus index

SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id 
--FROM @WORK             
FROM #WORK   
ORDER BY questionform_id, sampleunit_id, skip_id 

-- Update skipped qstncores while we have work to process 

-- Modified 01/03/2013 DRH changed @work to #work plus index
--WHILE (SELECT COUNT(*) FROM @work) > 0                
WHILE (SELECT COUNT(*) FROM #WORK) > 0
BEGIN 

   set @loopcnt = @loopcnt + 1     

--print 'questionform_ID = ' + cast(@qf as varchar(10)) 
--print 'Sampleunit_ID = ' + cast(@su as varchar(10)) 
--print '@skip = ' + cast(@sk as varchar(10)) 
--print '@svy = ' + cast(@svy as varchar(10)) 
--print '@bitUpdate = ' + cast(@bitUpdate as varchar(10)) 

--SkipPatternWork: 
IF @bitUpdate = 1 
BEGIN 

--print 'standard skip update' 
UPDATE qr 
-- SET Val=-7 
SET Val=VAL+10000 
FROM Cmnt_QuestionResult_Work qr, Skipqstns sq 
WHERE @qf = qr.QuestionForm_id 
AND @su = qr.SampleUnit_id 
AND @sk = Skip_id 
AND sq.QstnCore = qr.QstnCore 
AND Val NOT IN (-9,-8,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
AND Val<9000 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'Start HHCAHPS qstncore 38694 skip update'     
 end       

--print 'HHCAHPS qstncore 38694 skip update' 
UPDATE qr 
-- SET Val=-7 
SET Val=VAL+10000 
FROM Cmnt_QuestionResult_Work qr, survey_def sd, 
(Select distinct qstncore from sel_qstns where SURVEY_ID = @svy and QSTNCORE <> 38694 and NUMMARKCOUNT > 0) a 
WHERE @qf = qr.QuestionForm_id 
AND @su = qr.SampleUnit_id 
AND @sk = -1 
AND a.QstnCore = qr.QstnCore 
AND sd.SURVEY_ID = @svy 
AND Val NOT IN (-9,-8,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
AND Val<9000 
AND sd.SurveyType_id = 3 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'End HHCAHPS qstncore 38694 skip update'     
 end       

 if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'Start HHCAHPS qstncore 38726 skip update'     
 end       

--print 'HHCAHPS qstncore 38726 skip update' 
UPDATE qr 
-- SET Val=-7 
SET Val=VAL+10000 
FROM Cmnt_QuestionResult_Work qr, survey_def sd 
WHERE @qf = qr.QuestionForm_id 
AND @su = qr.SampleUnit_id 
AND @sk = -2 
AND qr.QstnCore = 38727 
AND sd.SURVEY_ID = @svy 
AND Val NOT IN (-9,-8,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
AND Val<9000 
AND sd.SurveyType_id = 3 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'End HHCAHPS qstncore 38726 skip update'     


 end       

END 

-- Identify the NEXT skip pattern that needs to be enforced for a questionform_id 

-- Modified 01/03/2013 DRH changed @work to #work plus index
  --DELETE FROM @work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id    
  DELETE FROM #work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id            
  --SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY questionform_id, sampleunit_id, skip_id     
  SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM #WORK ORDER BY questionform_id, sampleunit_id, skip_id             

  if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'Start Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'     
 end       

--Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
select @invskipcnt=count(*) 
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
inner join SkipQstns sq on si.Skip_id = sq.Skip_id 
inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk 
WHERE sd.bitEnforceSkip <> 0 
and qr.questionform_id = @qf 

-- Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop 
IF ( 
SELECT COUNT(*) 
 FROM Cmnt_QuestionResult_Work qr 
 INNER JOIN SkipIdentifier si 
 ON qr.Questionform_id = @qf 
 AND qr.sampleunit_id = @su 
 AND qr.datGenerated=si.datGenerated 
 AND qr.QstnCore=si.QstnCore 
 AND (qr.Val = si.intResponseVal 
 OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
 AND si.skip_id = @sk 
--Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
AND @invskipcnt = 0

-- 11/30/12 DRM -- Nested skip questions 
-- If any previous gateway questions include the current gateway as a skip question, 
--	and if the previous gateway was answered so as to skip the current gateway, 
-- then don't enforce skip logic on the current gateway question. 
--select count(*) 
--FROM Cmnt_QuestionResult_Work qr 
--INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
--INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
--inner join SkipQstns sq on si.Skip_id = sq.Skip_id 
--inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk 
--WHERE sd.bitEnforceSkip <> 0 
--and qr.questionform_id = @qf 
) > 0 
OR 
(SELECT 1 
FROM Cmnt_QuestionResult_Work qr, SURVEY_DEF sd 
WHERE qr.Questionform_id = @qf 
AND qr.sampleunit_id = @su 
AND qstncore = 38694 
AND val <> 1 
AND @sk = -1 
AND sd.SURVEY_ID = qr.Survey_id 
AND sd.SurveyType_id = 3 
) > 0 
OR 
(SELECT 1 
FROM Cmnt_QuestionResult_Work qr, SURVEY_DEF sd 
WHERE qr.Questionform_id = @qf 
AND qr.sampleunit_id = @su 
AND qstncore = 38726 
AND val <> 1 
AND @sk = -2 
AND sd.SURVEY_ID = qr.Survey_id 
AND sd.SurveyType_id = 3 
) > 0 
SET @bitUpdate = 1 
ELSE 
SET @bitUpdate = 0 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'End Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'     


 end       

END 

insert into drm_tracktimes select getdate(), 'End SP_Phase3_QuestionResult_For_Extract' 

-- Modified 01/03/2013 DRH changed @work to #work plus index
DROP TABLE #work                

SET NOCOUNT OFF 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO