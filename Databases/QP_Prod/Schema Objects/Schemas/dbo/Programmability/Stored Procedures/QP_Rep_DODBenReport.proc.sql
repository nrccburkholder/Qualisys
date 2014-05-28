CREATE PROCEDURE QP_Rep_DODBenReport 
	@Associate varchar(50),
	@Client varchar(50),
	@Study varchar(50),
	@Survey varchar(50)
AS
set transaction isolation level read uncommitted
SET NOCOUNT ON

-- Declare variables
Declare @Survey_id int
Declare @Study_id int
Declare @sSql varchar(8000)
Declare @QFID int
Declare @TotalMailed float
Declare @TotalReturned float
Declare @QR2 int

-- Get the study_id and survey_id
SELECT @Survey_id = sd.Survey_id, @Study_id = st.Study_id 
FROM Survey_Def sd, Study st, Client cl
WHERE cl.strClient_Nm = @Client
  AND st.strStudy_Nm = @Study
  AND sd.strSurvey_Nm = @Survey
  AND cl.Client_id = st.Client_id
  AND st.Study_id = sd.Study_id

--/////////////////////////////////////////////////////////////////////////
--//
--// Set the FLAG_FIN for all records
--//
--/////////////////////////////////////////////////////////////////////////

--Create the PopIDs table
CREATE TABLE #PopIDs ( Pop_id int, QuestionForm_id int, Returned bit, FirstSurvey bit, QR1 bit, QR2 bit )

-- Populate the PopIDs table for all surveys that have had results transfered
INSERT INTO #PopIDs ( Pop_id, QuestionForm_id, Returned, FirstSurvey )
SELECT DISTINCT sp.Pop_id, qf.QuestionForm_id, 1, 
                case when ms.intSequence = 2 then 1 else 0 end 
FROM SentMailing sm, SamplePop sp, QuestionForm qf, ScheduledMailing sc, MailingStep ms
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sm.SentMail_id = sc.SentMail_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND qf.datResultsImported IS NOT NULL
  AND qf.Survey_id = @Survey_id

-- Populate the PopIDs table for all surveys that have NOT had results transfered
INSERT INTO #PopIDs ( Pop_id, QuestionForm_id, Returned, QR1, QR2, FirstSurvey )
SELECT DISTINCT sp.Pop_id, qf.QuestionForm_id, 0, 0, 0, 
                case when ms.intSequence = 2 then 1 else 0 end 
FROM SentMailing sm, SamplePop sp, QuestionForm qf, ScheduledMailing sc, MailingStep ms
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sm.SentMail_id = sc.SentMail_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND sm.datMailed IS NOT NULL
  AND qf.datResultsImported IS NULL
  AND qf.Survey_id = @Survey_id

-- Update PopIDs table with the quantity of non-blank values from QuestionResult
Declare Tmp Cursor For SELECT QuestionForm_id FROM #PopIDs WHERE Returned = 1
Open Tmp
Fetch Next From Tmp Into @QFID
While @@fetch_status = 0
    BEGIN
        If (SELECT Count(*) FROM QuestionResult WHERE QuestionForm_id = @QFID AND intResponseVal > -9) > 0
            UPDATE #PopIDs SET QR1 = 1, QR2 = 0 WHERE QuestionForm_id = @QFID
        Else
            BEGIN
                If (SELECT Count(*) FROM QuestionResult2 WHERE QuestionForm_id = @QFID AND intResponseVal > -9) > 0
                    SET @QR2 = 1
                Else
                    SET @QR2 = 0
                
                UPDATE #PopIDs SET QR1 = 0, QR2 = @QR2 WHERE QuestionForm_id = @QFID
            END

        Fetch Next From Tmp Into @QFID
    END
Close Tmp
Deallocate Tmp


--Reset FLAG_FIN to NULL unless it is 18 or 19
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = NULL ' +
            'WHERE FLAG_FIN NOT IN (18,19)'

--Set FLAG_FIN = 17
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 17 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction IS NULL ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--** Added 11-07-01 JJF
--Set FLAG_FIN = 24
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 24 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction = 17 ' +

            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)
--** End of add 11-07-01 JJF

--Set FLAG_FIN = 16
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 16 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction IN (12,13,14,15) ' +

            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 15
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 15 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction = 4 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 14
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 14 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction IN (9,10) ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 13
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 13 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction IN (6,7) ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 12
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 12 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction = 5 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 11
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 11 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction = 16 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 10
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 10 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 0 ' +
            '  AND Restriction = 11 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 9
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 9 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction IS NULL ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--** Added 11-07-01 JJF
--Set FLAG_FIN = 23
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 23 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction = 17 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)
--** End of add 11-07-01 JJF

--Set FLAG_FIN = 8
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 8 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction IN (12,13,14,15) ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 7
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 7 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction = 4 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 6
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 6 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction IN (9,10) ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 5
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 5 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction IN (6,7) ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 4
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 4 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction = 5 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 3
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 3 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 0 AND QR2 = 0) ' +
            '  AND Restriction = 11 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 2
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 2 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 1 OR QR2 = 1) ' +
            '  AND Restriction = 8 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 1
SET @sSql = 'UPDATE po ' +
            'SET FLAG_FIN = 1 ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND (QR1 = 1 OR QR2 = 1) ' +
            '  AND (Restriction <> 8 OR Restriction IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 18
--FLAG_FIN = 18 is set in the DoDBUS program

--Set FLAG_FIN = 19
--FLAG_FIN = 19 is set in the DoDBUS program

--Set FLAG_FIN = 21
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 21 ' +
            'WHERE Restriction = 2 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 22
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 22 ' +
            'WHERE Restriction = 3 ' +
            '  AND (FLAG_FIN NOT IN (18,19) OR FLAG_FIN IS NULL)'
EXEC (@sSql)

--Set FLAG_FIN = 10 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 10 ' +
            'WHERE Restriction = 11 ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)

--Set FLAG_FIN = 11 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 11 ' +
            'WHERE Restriction = 16 ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)

--Set FLAG_FIN = 12 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 12 ' +
            'WHERE Restriction = 5 ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)

--Set FLAG_FIN = 13 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 13 ' +
            'WHERE Restriction IN (6,7) ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)


--Set FLAG_FIN = 14 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 14 ' +
            'WHERE Restriction IN (9,10) ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)

--Set FLAG_FIN = 15 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 15 ' +
            'WHERE Restriction = 4 ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)

--Set FLAG_FIN = 16 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 16 ' +
            'WHERE Restriction IN (12,13,14,15) ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)

--** Added 11-07-01 JJF
--Set FLAG_FIN = 24 for population that was sent a pre-note but not a first survey
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 24 ' +
            'WHERE Restriction = 17 ' +
            '  AND FLAG_FIN IS NULL'
EXEC (@sSql)
--** End of add 11-07-01 JJF

--Set FLAG_FIN = 20
SET @sSql = 'UPDATE s' + convert(varchar, @Study_id) + '.Population ' +
            'SET FLAG_FIN = 20 ' +
            'WHERE FLAG_FIN IS NULL'
EXEC (@sSql)


--/////////////////////////////////////////////////////////////////////////
--//
--// Generate the numbers for the report
--//
--/////////////////////////////////////////////////////////////////////////

--Create the RepData table
CREATE TABLE #RepData ( Counter int identity, Heading varchar(50), Quantity varchar(10) )

--Insert records
INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'MAIL ACTIVITY', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Total Sample', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
SELECT '    Mailed 1st surveys', convert(varchar, count(*))
FROM #PopIDs
WHERE FirstSurvey = 1 

INSERT INTO #RepData ( Heading, Quantity ) 
SELECT '    Mailed 2nd surveys', convert(varchar, count(*))
FROM #PopIDs
WHERE FirstSurvey = 0 

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Non-blank Returns', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
SELECT '    1st Surveys', convert(varchar, count(*))
FROM #PopIDs
WHERE FirstSurvey = 1 
  AND Returned = 1
  AND (QR1 = 1 OR QR2 = 1)

INSERT INTO #RepData ( Heading, Quantity ) 
SELECT '    2nd Surveys', convert(varchar, count(*))
FROM #PopIDs
WHERE FirstSurvey = 0 
  AND Returned = 1
  AND (QR1 = 1 OR QR2 = 1)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Duplicate Returns', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
SELECT '    Blank', convert(varchar, count(DISTINCT Pop_id))
FROM #PopIDs
WHERE QR1 = 0 AND QR2 = 0
  AND Returned = 1
  AND Pop_id IN (SELECT DISTINCT Pop_id FROM #PopIDs WHERE Returned = 1 GROUP BY Pop_id HAVING Count(*) > 1)

INSERT INTO #RepData ( Heading, Quantity ) 
SELECT '    Completed', convert(varchar, count(DISTINCT Pop_id))
FROM #PopIDs
WHERE (QR1 = 1 OR QR2 = 1)
  AND Returned = 1
  AND Pop_id IN (SELECT DISTINCT Pop_id FROM #PopIDs WHERE Returned = 1 GROUP BY Pop_id HAVING Count(*) > 1)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Blank Returns', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( '  Notification of Ineligibility', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Not eligible for MHS plan on xx/xx/xx", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 7'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Deceased", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 4'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Permanently Incapacitated", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 5 ' +
            '  AND Restriction = 6'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Incarcerated", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 5 ' +
            '  AND Restriction = 7'
EXEC (@sSql)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( '  Notification of Refusal', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    No longer in military after xx/xx/xx", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 6 ' +
            '  AND Restriction = 9'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Divorced/separated after xx/xx/xx", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 6 ' +
            '  AND Restriction = 10'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Hospitalized/temporary illness", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 3'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Dont use/refuse care", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 8 ' +
            '  AND (Restriction = 12 OR Restriction = 15)'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    No insurance thru military", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 8 ' +
            '  AND Restriction = 14'
EXEC (@sSql)

--** Added 11-07-01 JJF
SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Deployment", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 23 ' +
            '  AND Restriction = 17'
EXEC (@sSql)
--** End of add 11-07-01 JJF

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    No reason given", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 9'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Other", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 8 ' +
            '  AND Restriction = 13'
EXEC (@sSql)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'PHONE/FAX ACTIVITY', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Notification of Ineligibility', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Not eligible for MHS plan on xx/xx/xx", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 15'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Deceased", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 12'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Permanently Incapacitated", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 13 ' +
            '  AND Restriction = 6'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Incarcerated", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 13 ' +
            '  AND Restriction = 7'
EXEC (@sSql)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Notification of Refusal', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    No longer in military after xx/xx/xx", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 14 ' +
            '  AND Restriction = 9'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Divorced/separated after xx/xx/xx", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 14 ' +
            '  AND Restriction = 10'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Hospitalized/temporary illness", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 10'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Dont use/refuse care", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 16 ' +
            '  AND (Restriction = 12 OR Restriction = 15)'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    No insurance thru military", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 16 ' +
            '  AND Restriction = 14'
EXEC (@sSql)

--** Added 11-07-01 JJF
SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Deployment", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 24 ' +
            '  AND Restriction = 17'
EXEC (@sSql)
--** End of add 11-07-01 JJF

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    No reason given", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 21'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "    Other", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 16 ' +
            '  AND Restriction = 13'
EXEC (@sSql)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Live Phone Calls Received", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
--** Modified 11-07-01 JJF
--            'WHERE FLAG_FIN IN (10,11,12,13,14,15,16) ' +
            'WHERE FLAG_FIN IN (10,11,12,13,14,15,16,24) ' +
--** End of modification 11-07-01 JJF
            '   OR ServiceInd_29 = 1 OR ServiceInd_30 = 1 OR ServiceInd_31 = 1'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Voice Messages Received", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE (ServiceInd_29 = 2 OR ServiceInd_30 = 2 OR ServiceInd_31 = 2)'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Facsimilies Received", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE (ServiceInd_29 = 3 OR ServiceInd_30 = 3 OR ServiceInd_31 = 3)'
EXEC (@sSql)

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

SELECT @TotalMailed = count(DISTINCT Pop_id) FROM #PopIDs
SELECT @TotalReturned = count(DISTINCT Pop_id) FROM #PopIDs WHERE Returned = 1

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Total Surveys Returned', convert(varchar, @TotalReturned) ) 

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Surveys Not Returned Yet', convert(varchar, @TotalMailed - @TotalReturned) ) 

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'TYPE OF RETURN', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Completed Surveys", convert(varchar, count(DISTINCT pd.Pop_id)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND FLAG_FIN = 1'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Blank Surveys", convert(varchar, count(DISTINCT pd.Pop_id)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
--** Modified 11-07-01 JJF
--            '  AND FLAG_FIN IN (3,4,5,6,7,8,9)'
            '  AND FLAG_FIN IN (3,4,5,6,7,8,9,23)'
--** End of modification 11-07-01 JJF
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Ineligible Non-blank Surveys", convert(varchar, count(DISTINCT pd.Pop_id)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
--** Modified 11-07-01 JJF
--            '  AND FLAG_FIN = 2'
            '  AND FLAG_FIN IN (2,23)'
--** End of modification 11-07-01 JJF
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Loaded Eligible", convert(varchar, count(DISTINCT pd.Pop_id)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population po, #PopIDs pd ' +
            'WHERE po.Pop_id = pd.Pop_id ' +
            '  AND Returned = 1 ' +
            '  AND FLAG_FIN IN (1,3,6,8,9)'
EXEC (@sSql)


INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Total number mailed out', convert(varchar, @TotalMailed) )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Total number returned', convert(varchar, @TotalReturned) )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'Raw response rate', convert(varchar, ROUND((@TotalReturned/@TotalMailed)*100, 1)) + '%' )


INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( 'RETURNS BY POPULATION TYPE', ' ' )

INSERT INTO #RepData ( Heading, Quantity ) 
VALUES ( ' ', ' ' )

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Active Duty", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 1 ' +
            '  AND BeneficiaryGrp = "01"'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Family Member Of Active Duty", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 1 ' +
            '  AND BeneficiaryGrp IN ("02","03","04")'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Retiree and Family Member < 65", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 1 ' +
            '  AND BeneficiaryGrp IN ("05","06","07")'
EXEC (@sSql)

SET @sSql = 'INSERT INTO #RepData ( Heading, Quantity ) ' +
            'SELECT "Retiree and Family Member > 65", convert(varchar, count(*)) ' +
            'FROM s' + convert(varchar, @Study_id) + '.Population ' +
            'WHERE FLAG_FIN = 1 ' +
            '  AND BeneficiaryGrp IN ("08","09","10")'
EXEC (@sSql)

--Create the report recordset
SELECT Heading, Quantity FROM #RepData ORDER BY Counter

--Cleanup Temp Tables
DROP TABLE #PopIDs
DROP TABLE #RepData


SET NOCOUNT OFF

set transaction isolation level read committed


