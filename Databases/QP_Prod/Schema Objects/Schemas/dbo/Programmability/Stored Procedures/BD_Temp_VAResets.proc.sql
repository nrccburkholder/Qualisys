CREATE PROCEDURE BD_Temp_VAResets @QuestionForms VARCHAR(4000)
AS

DECLARE @sql VARCHAR(8000)

SET @sql='UPDATE bd_va_rescans01152004
SET datamart=1
WHERE questionform_id in ('+@QuestionForms+')'
EXEC (@sql)


