CREATE PROCEDURE dbo.sp_QPGetCriteriaFields
    @StudyID int

AS

SELECT Table_id, Field_id, strFieldDataType, strTable_Nm + '.' + strField_Nm as strField_Nm 
FROM MetaData_View 
WHERE Study_id = @StudyID


