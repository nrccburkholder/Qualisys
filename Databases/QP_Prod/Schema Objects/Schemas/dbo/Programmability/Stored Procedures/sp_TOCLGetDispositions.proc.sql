CREATE PROCEDURE sp_TOCLGetDispositions
    @strLithoCode varchar(10)

AS

DECLARE @StudyID int
DECLARE @PopID   int
DECLARE @ToclID  int

--Create the temp table
CREATE TABLE #Disp (Disposition_id int, strDisposition_Nm varchar(100))

--Get the study_id, pop_id, and TOCL_id
SELECT @StudyID = sp.Study_id, @PopID = sp.Pop_id, @ToclID = cl.TOCL_id 
FROM SentMailing sm, ScheduledMailing sc, 
     SamplePop sp LEFT JOIN TOCL cl 
                         ON sp.Study_id = cl.Study_id 
                        AND sp.Pop_id = cl.Pop_id 
WHERE sm.SentMail_id = sc.SentMail_id 
  AND sc.SamplePop_id = sp.SamplePop_id 
  AND sm.strLithoCode = @strLithoCode

--Check to see if this person is already taken off the call list
IF NOT (@ToclID IS NULL) 
BEGIN
    --Already taken of the call list
    INSERT INTO #Disp (Disposition_id, strDisposition_Nm)
    VALUES (-1, 'This respondent has already been added to the Take Off Call List!') 
END
ELSE
BEGIN
    --Determine if this study has the TOCL field
    IF (SELECT Count(*) 
        FROM MetaTable mt, MetaStructure ms, MetaField mf
        WHERE mt.Table_id = ms.Table_id
          AND ms.Field_id = mf.Field_id
          AND mt.Study_id = @StudyID
          AND mf.strField_Nm = 'TOCL'
          AND ms.bitPostedField_Flg = 1) > 0
    BEGIN
        --The TOCL field exists so return the disposition list
        INSERT INTO #Disp (Disposition_id, strDisposition_Nm)
        SELECT Disposition_id, strDisposition_Nm FROM TOCLDispositions ORDER BY Disposition_id
    END
    ELSE
    BEGIN
        --The TOCL field does not exist so take this person off the call list
        EXEC sp_TOCLAndSetDisposition @strLithoCode, 0
        INSERT INTO #Disp (Disposition_id, strDisposition_Nm)
        VALUES (-2, 'This respondent has been successfully added to the Take Off Call List!') 
    END
END

--Return the result set
SELECT Disposition_id, strDisposition_Nm FROM #Disp ORDER BY Disposition_id

--Drop the temp table
DROP TABLE #Disp


