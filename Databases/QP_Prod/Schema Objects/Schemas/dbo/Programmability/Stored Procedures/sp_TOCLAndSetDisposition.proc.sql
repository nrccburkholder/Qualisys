CREATE PROCEDURE sp_TOCLAndSetDisposition
    @strLithoCode  varchar(10), 
    @DispositionID int

AS

DECLARE @StudyID int
DECLARE @PopID   int
DECLARE @strSql  varchar(200)

BEGIN TRANSACTION

--Get the study_id and pop_id
SELECT @StudyID = sp.Study_id, @PopID = sp.Pop_id 
FROM SentMailing sm, ScheduledMailing sc, SamplePop sp 
WHERE sm.SentMail_id = sc.SentMail_id 
  AND sc.SamplePop_id = sp.SamplePop_id 
  AND sm.strLithoCode = @strLithoCode

IF @@ERROR <> 0 
BEGIN
    ROLLBACK TRANSACTION
    RETURN 1
END

--Add to the take off call list table
INSERT INTO TOCL ( Study_id, Pop_id, datTOCL_Dat ) 
VALUES ( @StudyID, @PopID, getdate() )

IF @@ERROR <> 0 
BEGIN
    ROLLBACK TRANSACTION
    RETURN 1
END

--Update the population record
IF @DispositionID > 0 
BEGIN
    SET @strSql = 'UPDATE s' + Convert(varchar, @StudyID) + '.Population ' + 
                  'SET TOCL = ' + convert(varchar, @DispositionID) + ' ' + 
                  'WHERE Pop_id = ' + Convert(varchar, @PopID)
    EXEC (@strSql)
END

IF @@ERROR <> 0 
BEGIN
    ROLLBACK TRANSACTION
    RETURN 1
END
ELSE
BEGIN
    COMMIT TRANSACTION
    RETURN 0
END


