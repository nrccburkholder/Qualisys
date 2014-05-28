CREATE PROCEDURE sp_ValidateLithoCode
    @strLithoCode varchar(10),
    @strName      varchar(100) OUTPUT

AS

SET NOCOUNT ON

--Declare required variables
DECLARE @StudyID   int
DECLARE @PopID     int
DECLARE @strSql    varchar(1000)
DECLARE @intFName  int
DECLARE @intLName  int
DECLARE @bitReturn bit

--Create required temp tables
CREATE TABLE #Names (strName varchar(100))

--Check to see if the 
IF EXISTS (SELECT strLithoCode FROM SentMailing WHERE strLithoCode = @strLithoCode)
BEGIN
    --Get the Study and Pop IDs
    SELECT @StudyID = sp.Study_id, @PopID = sp.Pop_id 
    FROM SentMailing sm, ScheduledMailing sc, SamplePop sp
    WHERE sm.ScheduledMailing_id = sc.ScheduledMailing_id 
      AND sc.SamplePop_id = sp.SamplePop_id
      AND sm.strLithoCode = @strLithoCode
    
    --Determine if the FName field is present
    SELECT @intFName = Count(*) 
    FROM MetaTable mt, MetaStructure ms, MetaField mf 
    WHERE mt.Table_id = ms.Table_id 
      AND ms.Field_id = mf.Field_id 
      AND mt.strTable_Nm = 'Population' 
      AND mf.strField_Nm = 'FName' 
      AND ms.bitPostedField_Flg = 1
    
    --Determine if the LName field is present
    SELECT @intLName = Count(*) 
    FROM MetaTable mt, MetaStructure ms, MetaField mf 
    WHERE mt.Table_id = ms.Table_id 
      AND ms.Field_id = mf.Field_id 
      AND mt.strTable_Nm = 'Population' 
      AND mf.strField_Nm = 'LName' 
      AND ms.bitPostedField_Flg = 1
    
    --Determine which fields we are selecting
    IF (@intFName > 0) AND (@intLName > 0)
        SET @strSql = 'SELECT FName + '' '' + LName '
    ELSE IF (@intFName > 0)
        SET @strSql = 'SELECT FName '
    ELSE IF (@intLName > 0)
        SET @strSql = 'SELECT LName '
    ELSE
        SET @strSql = Null
    
    IF NOT (@strSql IS NULL)
    BEGIN
        SET @strSql = 'INSERT INTO #Names (strName) ' + @strSql + 
                      'FROM s' + Convert(varchar, @StudyID) + '.Population ' +
                      'WHERE Pop_id = ' + Convert(varchar, @PopID)
        EXEC (@strSql)
        SELECT @strName = strName FROM #Names
    END
    ELSE
        SET @strName = 'N/A'
    
    --Return Success
    SET @bitReturn = 1
END
ELSE
BEGIN
    --The supplied LithoCode was not found
    SET @bitReturn = 0
END

--Cleanup
DROP TABLE #Names
SET NOCOUNT OFF

--Set the return value
RETURN @bitReturn


